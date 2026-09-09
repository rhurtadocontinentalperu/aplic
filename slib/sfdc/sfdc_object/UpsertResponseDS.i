
/**
 * UpsertResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName UpsertResponse
&else
    &scoped xName {1}
&endif



{UpsertResponseTT.i {&xName}}
{ErrorsTT.i         {&xName}_Errors}

define dataset ds{&xName} 

    for tt{&xName}, tt{&xName}_Errors

        data-relation tid for tt{&xName}, tt{&xName}_Errors relation-fields ( tid, tid ).
