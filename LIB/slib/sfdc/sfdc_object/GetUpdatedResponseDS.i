
/**
 * GetUpdatedResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetUpdatedResponse
&else
    &scoped xName {1}
&endif



{GetUpdatedResponseTT.i {&xName}}

{IdsTT.i {&xName}_IDs}

define dataset ds{&xName}

    for tt{&xName}, tt{&xName}_IDs.
