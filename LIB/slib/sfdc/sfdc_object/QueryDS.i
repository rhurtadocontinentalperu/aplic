
/**
 * QueryDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Query
&else
    &scoped xName {1}
&endif



{QueryTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
