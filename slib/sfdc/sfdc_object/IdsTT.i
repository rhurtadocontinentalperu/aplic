
/**
 * IdsTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName IDs
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tids as char init ?
    index tids is primary /* unique */ tIds.
