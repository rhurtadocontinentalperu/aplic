
/**
 * ttErrorsTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Errors
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tid           as char init ?
    field tfields       as char init ?
    field tmessage      as char init ?
    field tstatusCode   as char init ?.

