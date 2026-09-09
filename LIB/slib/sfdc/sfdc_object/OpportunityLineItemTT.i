
/**
 * OpportunityLineItemTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName OpportunityLineItem
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                       as char     init ?
    field tConnectionReceivedId     as char     init ?
    field tConnectionSentId         as char     init ?
    field tCurrencyIsoCode          as char     init ?
    field tDescription              as char     init ?
    field tHasQuantitySchedule      as log      init ?
    field tHasRevenueSchedule       as log      init ?
    field tIsDeleted                as log      init ?
    field tListPrice                as dec      init ?
    field tOpportunityId            as char     init ?
    field tPriceBookEntryId         as char     init ?
    field tProductCode              as char     init ?
    field tProductId                as char     init ?
    field tQuantity                 as dec      init ?
    field tSalesPrice               as dec      init ?
    field tServiceDate              as date     init ?
    field tSortOrder                as char     init ?
    field tTotalPrice               as dec      init ?
    field tUnitPrice                as dec      init ?

    field tSales_Discount__c        as char     init ?
    field tCost_Per_Unit__c         as dec      init ?

    index tId is primary
          tId.
