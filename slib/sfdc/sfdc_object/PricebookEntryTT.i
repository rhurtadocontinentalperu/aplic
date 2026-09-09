
/**
 * PricebookEntryTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName PricebookEntry
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId                   as char     init ?
    field tCurrencyIsoCode      as char     init ?
    field tIsActive             as log      init ?
    field tIsDeleted            as log      init ?
    field tName                 as char     init ?
    field tPricebook2Id         as char     init ?
    field tProduct2Id           as char     init ?
    field tProductCode          as char     init ?
    field tUnitPrice            as dec      init ?
    field tUseStandardPrice     as dec      init ?
    
    index tId is primary
          tId.
