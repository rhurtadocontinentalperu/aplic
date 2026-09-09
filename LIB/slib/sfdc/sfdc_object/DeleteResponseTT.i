
/**
 * DeleteResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName DeleteResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tid       as char init ?
    field tsuccess  as log  init ?.
