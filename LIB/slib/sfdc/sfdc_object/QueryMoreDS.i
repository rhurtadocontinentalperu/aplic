
/**
 * QueryMoreDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName QueryMore
&else
    &scoped xName {1}
&endif



{QueryMoreTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
