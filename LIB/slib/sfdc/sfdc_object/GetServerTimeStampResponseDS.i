
/**
 * GetServerTimestampResponseDS.i -
 *
 * 
 */

&if "{1}" = "" &then
    &scoped xName GetServerTimestampResponse
&else
    &scoped xName {1}
&endif



{GetServerTimestampResponseTT.i  {&xName}}

define dataset ds{&xName} 

    for tt{&xName}. 

