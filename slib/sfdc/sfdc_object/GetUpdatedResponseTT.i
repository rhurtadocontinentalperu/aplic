
/**
 * GetUpdatedResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetUpdatedResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tlatestDateCovered    as datetime init ?
    field tsforceReserved       as char     init ?.
