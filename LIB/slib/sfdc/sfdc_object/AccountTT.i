
/**
 * AccountTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Account
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                                   as char     init ?
    field tAccountNumber                        as char     init ?
    field tName                                 as char     init ?
    field tIsDeleted                            as log      init ?
    field tMasterRecordId                       as char     init ?
    field tType                                 as char     init ?
    field tParentId                             as char     init ?
    field tBillingStreet                        as char     init ?
    field tBillingCity                          as char     init ?
    field tBillingState                         as char     init ?
    field tBillingPostalCode                    as char     init ?
    field tBillingCountry                       as char     init ?
    field tShippingStreet                       as char     init ?
    field tShippingCity                         as char     init ?
    field tShippingState                        as char     init ?
    field tShippingPostalCode                   as char     init ?
    field tShippingCountry                      as char     init ?
    field tPhone                                as char     init ?
    field tFax                                  as char     init ?
    field tWebsite                              as char     init ?
    field tSic                                  as char     init ?
    field tIndustry                             as char     init ?
    field tAnnualRevenue                        as dec      init ?
    field tNumberOfEmployees                    as int      init ?
    field tOwnership                            as char     init ?
    field tTickerSymbol                         as char     init ?
    field tDescription                          as char     init ?
    field tRating                               as char     init ?
    field tSite                                 as char     init ?
    field tOwner                                as char     init ?
    field tOwnerId                              as char     init ?

    field tCreatedDate                          as datetime init ?
    field tCreatedById                          as char     init ?
    field tLastModifiedDate                     as datetime init ?
    field tLastModifiedById                     as char     init ?
    field tSystemModstamp                       as datetime init ?
    field tLastActivityDate                     as date     init ?

    field tOf_Closed_Opportunities__c           as int      init ?
    field tAccount_Code__c                      as char     init ? /* external id */
    field tAccount_Currency__c                  as char     init ?
    field tAccount_Status__c                    as char     init ?
    field tAction_Items__c                      as char     init ?
    field tAdditional_Wireless_Products__c      as char     init ?
    field tAgent__c                             as char     init ?
    field tAgreement_Filed__c                   as char     init ?
    field tAgreement_Filed_Date__c              as date     init ?
    field tCompany_Type__c                      as char     init ?
    field tConverted_from_Lead__c               as char     init ?
    field tCountry__c                           as char     init ?
    field tCredit_Line__c                       as dec      init ?
    field tCredit_Line_Balance__c               as dec      init ?
    field tCredit_Line_Current_Status__c        as dec      init ?
    field tDescription_Status__c                as char     init ?
    field tDiscount__c                          as dec      init ?
    field tFreight_Terms__c                     as char     init ?
    field tMFG_Account_Name__c                  as char     init ?
    field tMOQ_VS_PRICES__c                     as char     init ?
    field tPayment_Terms__c                     as char     init ?
    field tProtection__c                        as char     init ?
    field tProtection_Due_Date__c               as date     init ?
    field tRegion__c                            as char     init ?
    field tSales_Person__c                      as char     init ?
    field tSent_to_a_Partner__c                 as log      init ?
    field tSubtype__c                           as char     init ?
    field tSite__c                              as char     init ?
    field tTerritory__c                         as char     init ?
    field tUpdate_MFG__c                        as log      init ?
    field tWarranty_months__c                   as dec      init ?
    field tWeb__c                               as char     init ?
    field tWeekly_Report__c                     as char     init ?
    
    index tId is primary /* unique */
          tId.

