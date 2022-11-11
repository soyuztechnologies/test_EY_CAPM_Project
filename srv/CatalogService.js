module.exports = cds.service.impl( async function(srv){
    const { POs, PurchaseOrderItems } = this.entities;


    this.on('boost', async req => {
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);

            const reply = await tx.update(POs).with({
                GROSS_AMOUNT : { '+=' : 20000, NOTE: 'Boosted!!'}
            }).where(ID);

            return reply;

        } catch (error) {
            return "Error " + error.toString();
        }
    });
    
    this.before('CREATE', POs, (req,res) => {
        console.log("aaya kya", req.data);
        
    });
    this.before('CREATE', PurchaseOrderItems, (req,res) => {
        console.log("aaya kya", req.data);
        
    });

    this.on('largestOrder', async req => {
        try {
            const tx = cds.tx(req);

            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;

        } catch (error) {
            return "Error " + error.toString();
        }
    });

});