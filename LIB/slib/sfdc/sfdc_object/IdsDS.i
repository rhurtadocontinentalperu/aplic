
/**
 * IdsDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName IDs
&else
    &scoped xName {1}
&endif



{IdsTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
