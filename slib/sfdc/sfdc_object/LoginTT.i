
/**
 * LoginTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Login
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tusername as char init ?
    field tpassword as char init ?.
