
/**
 * DeletedRecordsTT.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName DeletedRecords
&else
    &scoped xName {1}
&endif



define temp-table tt{&xName} no-undo

    field tdeletedDate  as datetime init ?
    field tid           as char     init ?

    index tid is primary /* unique */
          tid.
