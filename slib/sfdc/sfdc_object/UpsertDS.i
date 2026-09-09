
/**
 * UpsertDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Upsert
&else
    &scoped xName {1}
&endif



{UpsertTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
