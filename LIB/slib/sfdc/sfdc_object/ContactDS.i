
/**
 * ContactDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Contact
&else
    &scoped xName {1}
&endif



{ContactTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
