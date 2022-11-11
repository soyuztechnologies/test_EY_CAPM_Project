const cds = require('@sap/cds');
const { employees } = cds.entities("anubhav.db.master");


const mysrvdemo = function(srv){
    srv.on('somesrv', (req, res) => {
        return "hey " + req.data.msg;
    });

    srv.on("READ", "ReadEmployeeSrv", async(req, res) => {
        var results = [];

        //example 1
        // results.push({
        //     "ID":"ANUBHAV-IS-TESTING",
        //     "nameFirst": "Messi",
        //     "nameLast": "C"
        // });


        //exmaple 2
        ///results = await cds.tx(req).run(SELECT.from(employees).limit(3));

        //example 3
        ///results = await cds.tx(req).run(SELECT.from(employees).where({"nameFirst": "Susan"}));

        //example 4 - dynamic input parameter
        var whereCondition = req.data;
        console.log(whereCondition);
        if(whereCondition.hasOwnProperty("ID")){
            results = await cds.tx(req).run(SELECT.from(employees).where(whereCondition));
        }else{
            results = await cds.tx(req).run(SELECT.from(employees).limit(1));
        }

        return results;
    });

    function randomString(length, chars) {
        var result = '';
        for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
        return result;
    }

    srv.on("CREATE", "InsertEmployeeSrv", async(req,res) => {
        console.log(req.data);

        if(req.data.salaryAmount < 90000){
            req.error(500, "Salary Cannot be less than 90 k");
            return;
        }

        let resultData = await cds.transaction(req).run([
            INSERT.into(employees).entries(req.data)
        ]).then( (resolve, reject) => {
            if(typeof(resolve) !== undefined){
                return req.data;
            }else{
                req.error(500, "There was an error ");
            }
        }).catch(oError => {
            req.error(500, "There was an error " + oError.toString());
        });

        return req.data;

    });

    srv.on("UPDATE", "UpdateEmployeeSrv", async(req,res) => {

        let responseData = await cds.transaction(req).run([
            UPDATE(employees).set({
                nameFirst: req.data.nameFirst,
                nameLast: req.data.nameLast
            }).where({ID : req.data.ID})
        ]).then( (resolve, reject) => {
            if(typeof(resolve) !== undefined){
                return req.data;
            }else{
                req.error(500, "An error occurred");
            }
        } ).catch( err => {
            req.error(500, "An error occurred" + err.toString());
        });

        return responseData;

    });

    srv.on("DELETE", "DeleteEmployeeSrv", async(req,res) => {

        let returnData = await cds.transaction(req).run([
            DELETE.from(employees).where(req.data)
        ]).then( (resolve, reject) => {
            if(typeof(resolve) !== undefined){
                return req.data;
            }else{
                req.error(500, "An error occurred");
            }
        }).catch( err => {
            req.error(500, "An error occurred" + err.toString());
        });

        return returnData;

    });

}

module.exports = mysrvdemo;