
/**
 * UpsertResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName UpsertResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tcreated  as log  init ?
    field tid       as char init ?
    field tsuccess  as log  init ?.
