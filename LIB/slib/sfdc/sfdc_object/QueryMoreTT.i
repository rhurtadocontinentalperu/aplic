
/**
 * QueryMoreTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName QueryMore
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tqueryLocator as char init ?.
