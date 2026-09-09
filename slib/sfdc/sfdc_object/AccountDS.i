
/**
 * AccountDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Account
&else
    &scoped xName {1}
&endif



{AccountTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
