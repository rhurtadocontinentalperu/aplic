
/**
 * GetDeletedResponseDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName GetDeletedResponse
&else
    &scoped xName {1}
&endif



{GetDeletedResponseTT.i {&xName}}

{DeletedRecordsTT.i {&xName}_Records}

define dataset ds{&xName}

    for tt{&xName}, tt{&xName}_Records.
