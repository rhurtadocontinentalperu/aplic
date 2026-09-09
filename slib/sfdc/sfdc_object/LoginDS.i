
/**
 * LoginDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Login
&else
    &scoped xName {1}
&endif



{LoginTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
