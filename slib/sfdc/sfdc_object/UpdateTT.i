
/**
 * UpdateTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Update
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tsObjectType as char init ?.
