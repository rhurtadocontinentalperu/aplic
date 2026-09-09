
/**
 * ErrorsDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Errors
&else
    &scoped xName {1}
&endif



{ErrorsTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.

