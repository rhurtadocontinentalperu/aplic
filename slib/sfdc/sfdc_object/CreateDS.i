
/**
 * CreateDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Create
&else
    &scoped xName {1}
&endif



{CreateTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
