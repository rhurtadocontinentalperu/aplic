
/**
 * GetDeletedResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetDeletedResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tearliestDateAvailable    as datetime init ?
    field tlatestDateCovered        as datetime init ?
    field tsforceReserved           as char     init ?.
