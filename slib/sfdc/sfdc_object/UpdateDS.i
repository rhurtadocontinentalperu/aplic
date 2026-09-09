
/**
 * UpdateDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Update
&else
    &scoped xName {1}
&endif



{UpdateTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
