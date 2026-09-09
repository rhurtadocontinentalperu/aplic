
/**
 * LoginResponseTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName LoginResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tmetadataServerUrl    as char init ?
    field tpasswordExpired      as log  init ?
    field tserverUrl            as char init ?
    field tsessionId            as char init ?
    field tuserId               as char init ?.
