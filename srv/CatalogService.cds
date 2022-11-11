using { anubhav.db } from '../db/datamodel';
using { anubhav.db.CDSViews } from '../db/CDSViews';

service CatalogService @(path: 'CatalogService') 
                       @(requires : 'authenticated-user')
    {
    
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity AddressSet as projection on db.master.address;
    entity EmployeeSet @(restrict:[
        {
            grant: ['READ'],
            to: 'Viewer',
            where : 'bankName = $user.BankName'
        },{
            grant: ['WRITE'],
            to: 'Admin'
        }
    ])
    
     as projection on db.master.employees;
    entity ProductSet as projection on db.master.product;
    entity PurchaseOrderItems as projection on db.transaction.poitems{
        *,
        PARENT_KEY: redirected to POs,
        PRODUCT_GUID: redirected to ProductSet
    };
    entity POs @(
        odata.draft.enabled: true
    ) as projection on db.transaction.purchaseorder{
        *,
        Items: redirected to PurchaseOrderItems,
        case LIFECYCLE_STATUS
        when 'N' then 'New'
        when 'D' then 'Delivered'
        when 'B' then 'Blocked'
        end as LIFECYCLE_STATUS: String(20),
        case LIFECYCLE_STATUS
        when 'N' then 2
        when 'D' then 1
        when 'B' then 3
        end as Criticality: Integer,
        round(GROSS_AMOUNT, 2) as GROSS_AMOUNT: Decimal(10,2)
    }actions{
        action boost();
        function largestOrder() returns array of POs;
    };
    // entity CProductValuesView as projection on CDSViews.CProductValuesView;

}
