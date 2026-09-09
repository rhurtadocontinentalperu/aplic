
/**
 * GetUpdatedDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetUpdated
&else
    &scoped xName {1}
&endif



{GetUpdatedTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
