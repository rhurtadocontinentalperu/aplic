
/**
 * QueryTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Query
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tqueryString as char init ?.
