
/**
 * DeleteDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Delete
&else
    &scoped xName {1}
&endif




{IdsTT.i {&xName}_IDs}

define dataset ds{&xName}

    for tt{&xName}_IDs.
