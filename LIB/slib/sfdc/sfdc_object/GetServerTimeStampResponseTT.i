
/**
 * GetServerTimestampResponseTT.i -
 *
 * 
 */

&if "{1}" = "" &then
    &scoped xName GetServerTimestampResponse
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field ttimestamp as datetime init ?.
