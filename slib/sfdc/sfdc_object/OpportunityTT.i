
/**
 * OpportunityTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Opportunity
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                           as char     init ?
    field tAccountId                    as char     init ?
    field tAmount                       as dec      init ?
    field tCloseDate                    as date     init ?
    field tDescription                  as char     init ?
    field tExpectedRevenue              as dec      init ?
    field tFiscal                       as char     init ?
    field tFiscalQuarter                as int      init ?
    field tFiscalYear                   as int      init ?
    field tForecastCategory             as char     init ?
    field tForecastCategoryName         as char     init ?
    field tHasOpportunityLineItem       as log      init ?
    field tIsClosed                     as log      init ?
    field tIsDeleted                    as log      init ?
    field tIsWon                        as log      init ?
    field tLastActivityDate             as date     init ?
    field tLeadSource                   as char     init ?
    field tName                         as char     init ?
    field tNextStep                     as char     init ?
    field tOwnerId                      as char     init ?
    field tPricebook2Id                 as char     init ?
    field tPricebookId                  as char     init ?
    field tProbability                  as dec      init ?
    field tStageName                    as char     init ?
    field tTotalOpportunityQuantity     as dec      init ?
    field tType                         as char     init ?

    field tCreatedDate                  as datetime init ?
    field tCreatedById                  as char     init ?
    field tLastModifiedDate             as datetime init ?
    field tLastModifiedById             as char     init ?
    field tSystemModstamp               as datetime init ?

    field tAdvanced_Kit__c              as char     init ?
    field tSor__c                       as log      init ?
    field tShipment_Terms__c            as char     init ?
    field tInterface_to_MFG__c          as log      init ?
    field tPayment_Terms_Comments__c    as char     init ?
    field tOpportunity_Number__c        as /* dec */ char      init ?
    field tProject_Start_Date__c        as date     init ?
    field tProject_Description__c       as char     init ?
    field tDescription_Status__c        as char     init ?
    field tSales_Person__c              as char     init ?
    field tCredit_Terms__c              as char     init ?
    field tFreight_Amount__c            as dec      init ? 
    field tPO_Number__c                 as char     init ? 

    index tId is primary
          tId.

