
/**
 * DeleteResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName DeleteResponse
&else
    &scoped xName {1}
&endif



{DeleteResponseTT.i {&xName}}
{ErrorsTT.i         {&xName}_Errors}

define dataset ds{&xName} 

    for tt{&xName}, tt{&xName}_Errors

        data-relation tid for tt{&xName}, tt{&xName}_Errors relation-fields ( tid, tid ).
