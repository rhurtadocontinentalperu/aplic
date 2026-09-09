
/**
 * QueryResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName QueryResponse
&else
    &scoped xName {1}
&endif



{QueryResponseTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
