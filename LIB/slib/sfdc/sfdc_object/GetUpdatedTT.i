
/**
 * GetUpdatedTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetUpdated
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tsObjectType  as char     init ?
    field tstartDate    as datetime init ?
    field tendDate      as datetime init ?.
