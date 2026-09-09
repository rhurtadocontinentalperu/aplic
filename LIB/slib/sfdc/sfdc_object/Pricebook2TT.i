
/**
 * Pricebook2TT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName PriceBook2
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tId               as char     init ?
    field tDescription      as char     init ?
    field tIsActive         as char     init ?
    field tIsDeleted        as char     init ?
    field tIsStandard       as char     init ?
    field tName             as log      init ?
    
    index tId is primary
          tId.
