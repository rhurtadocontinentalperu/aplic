
/**
 * Product2TT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Product2
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                               as char     init ?
    field tCanUseQuantitySchedule           as log      init ?
    field tCanUseRevenueSchedule            as log      init ?
    field tConnectionReceivedId             as char     init ?
    field tConnectionSentId                 as char     init ?
    field tCurrencyIsoCode                  as char     init ?
    field tDefaultPrice                     as dec      init ?
    field tDescription                      as char     init ?
    field tFamily                           as char     init ?
    field tIsActive                         as log      init ?
    field tIsDeleted                        as log      init ?
    field tName                             as char     init ?
    field tNumberOfQuantityInstallments     as int      init ?
    field tNumberofRevenueInstallments      as int      init ?
    field tProductCode                      as char     init ?
    field tQuantityInstallmentPeriod        as char     init ?
    field tQuantityScheduleType             as char     init ?
    field tRevenueInstallmentPeriod         as char     init ?
    field tRevenueScheduleType              as char     init ?
    
    field tCost__c                          as dec      init ?
    field tMinimum_Stock__c                 as dec      init ?
    field tMOQ__c                           as dec      init ?
    field tOld_3rd_party_P_N__c             as char     init ?
    field tOrigin_of_Goods__c               as char     init ?
    field tProduct_Line__c                  as char     init ?          
    
    index tId is primary
          tId.
