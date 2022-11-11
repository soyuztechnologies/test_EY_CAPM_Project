using CatalogService as service from '../../srv/CatalogService';

annotate CatalogService.POs with {
    PARTNER_GUID@(
        Common: {
            Text: PARTNER_GUID.COMPANY_NAME,
            ValueList                : {
                Label : 'Badhiya',
                CollectionPath : 'BusinessPartnerSet',
                SearchSupported : True,
                Parameters     : [{
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'PARTNER_GUID_NODE_KEY.COMPANY_NAME',
                    ValueListProperty : 'COMPANY_NAME'
                },{
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'PARTNER_GUID_NODE_KEY',
                    ValueListProperty : 'NODE_KEY'
                }]
            }
        }
    )
};

// @cds.odata.valuelist
// annotate CatalogService.ProductSet with @(
//     UI.identification : [{
//         $Type: 'UI.DataField',
//         Value: DESCRIPTION
//     }]
// );

annotate CatalogService.PurchaseOrderItems with {
    PRODUCT_GUID@(
        Common: {
            Text: PRODUCT_GUID.DESCRIPTION,
            ValueList                : {
                Label : 'Badhiya',
                CollectionPath : 'ProductSet',
                SearchSupported : True,
                Parameters     : [{
                    $Type             : 'Common.ValueListParameterOut',
                    LocalDataProperty : 'PRODUCT_GUID.DESCRIPTION',
                    ValueListProperty : 'DESCRIPTION'
                },{
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : 'PRODUCT_GUID_NODE_KEY',
                    ValueListProperty : 'NODE_KEY'
                }]
            }
        },
        ValueList.entity : CatalogService.ProductSet
    )
};

annotate service.POs with @(
    UI.SelectionFields :[
        PO_ID,
        GROSS_AMOUNT,
        CURRENCY_CODE,
        PARTNER_GUID_NODE_KEY.COMPANY_NAME,
        CURRENCY_CODE
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Order Id',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Label: 'Vendor',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataFieldForAction',
            Label: 'Boost',
            Action: 'CatalogService.boost',
            Inline: true
        },
        {
            $Type : 'UI.DataField',
            Label : 'Amount',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : CURRENCY_CODE,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : LIFECYCLE_STATUS,
            Criticality: Criticality,
            CriticalityRepresentation: #WithIcon
        }
    ],
    UI.HeaderInfo:{
        $Type: 'UI.HeaderInfoType',
        TypeName: 'Order',
        TypeNamePlural: 'Orders',
        Description: { Value : PARTNER_GUID.COMPANY_NAME },
        Title: {Value : PO_ID},
        ImageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/EY_logo_2019.svg/800px-EY_logo_2019.svg.png'
    }
);
annotate service.POs with @(
    UI.FieldGroup #Spiderman : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'CURRENCY_CODE',
                Value : CURRENCY_CODE,
            },
            {
                $Type : 'UI.DataField',
                Label : 'GROSS_AMOUNT',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NET_AMOUNT',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Label : 'TAX_AMOUNT',
                Value : TAX_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NODE_KEY',
                Value : NODE_KEY,
            },
            {
                $Type : 'UI.DataField',
                Label : 'PO_ID',
                Value : PO_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'PARTNER_GUID_NODE_KEY',
                Value : PARTNER_GUID_NODE_KEY,
            },
            {
                $Type : 'UI.DataField',
                Label : 'LIFECYCLE_STATUS',
                Value : LIFECYCLE_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Label : 'OVERALL_STATUS',
                Value : OVERALL_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Label : 'NOTE',
                Value : NOTE,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#Spiderman',
        },{
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet2',
            Label : '{i18n>POItemDetails}',
            Target : 'Items/@UI.LineItem',
        }
    ]
);

annotate service.PurchaseOrderItems with @(
    UI: {
        LineItem: [
            {
                $Type: 'UI.DataField',
                Value : PO_ITEM_POS
            },
            {
                $Type: 'UI.DataField',
                Value : PRODUCT_GUID_NODE_KEY
            },{
                $Type: 'UI.DataField',
                Label: 'Product Id',
                Value : PRODUCT_GUID.PRODUCT_ID
            },{
                $Type: 'UI.DataField',
                Value : GROSS_AMOUNT
            },{
                $Type: 'UI.DataField',
                Value : NET_AMOUNT
            },{
                $Type: 'UI.DataField',
                Value : TAX_AMOUNT
            },{
                $Type: 'UI.DataField',
                Value : CURRENCY_CODE
            }

        ],
        HeaderInfo: {
            $Type: 'UI.HeaderInfoType',
            TypeName: 'Item',
            TypeNamePlural: 'Order Items',
            Description: { Value : GROSS_AMOUNT },
            Title: {Value : PO_ITEM_POS},
            ImageUrl: 'sap-icon://product'
        },
        Facets:[
            {
                $Type : 'UI.ReferenceFacet',
                ID : 'ItemFacet1',
                Label : 'Item Information',
                Target : '@UI.FieldGroup#ItemData'
            },{
                $Type : 'UI.ReferenceFacet',
                ID : 'ItemFacet2',
                Label : 'Product Information',
                Target : '@UI.FieldGroup#ProductData'
            }
        ],
        FieldGroup#ItemData : {
            $Type : 'UI.FieldGroupType',
            Data : [
                {
                    $Type : 'UI.DataField',
                    Label : 'Item Position',
                    Value : PO_ITEM_POS,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Parent ID',
                    Value : PARENT_KEY,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Node Key',
                    Value : PRODUCT_GUID_NODE_KEY,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Gross Amount',
                    Value : GROSS_AMOUNT,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Net Amount',
                    Value : NET_AMOUNT,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Tax Amount',
                    Value : TAX_AMOUNT,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'CURRENCY_CODE',
                    Value : CURRENCY_CODE,
                }
            ]
        },
        FieldGroup#ProductData : {
            $Type : 'UI.FieldGroupType',
            Data : [
                {
                    $Type : 'UI.DataField',
                    Label : 'Product Id',
                    Value : PRODUCT_GUID.PRODUCT_ID,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Product Name',
                    Value : PRODUCT_GUID.DESCRIPTION,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Type Code',
                    Value : PRODUCT_GUID.TYPE_CODE,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Category',
                    Value : PRODUCT_GUID.CATEGORY,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Supplier',
                    Value : PRODUCT_GUID.SUPPLIER_GUID.COMPANY_NAME,
                },
                {
                    $Type : 'UI.DataField',
                    Label : 'Tax Tarrif',
                    Value : PRODUCT_GUID.TAX_TARIF_CODE,
                }
            ]
        }
    }
);