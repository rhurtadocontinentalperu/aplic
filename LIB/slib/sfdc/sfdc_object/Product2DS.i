
/**
 * Product2DS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Product2
&else
    &scoped xName {1}
&endif



{Product2TT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
