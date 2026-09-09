
/**
 * GetDeletedDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetDeleted
&else
    &scoped xName {1}
&endif



{GetDeletedTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
