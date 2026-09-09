
/**
 * QueryResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName QueryResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tdone         as log  init ?
    field tqueryLocator as char init ?
    field tsize         as int  init ?.
