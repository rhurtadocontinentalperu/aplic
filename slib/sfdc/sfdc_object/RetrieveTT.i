
/**
 * RetrieveTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Retrieve
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tfieldList    as char init ?
    field tsObjectType  as char init ?.
