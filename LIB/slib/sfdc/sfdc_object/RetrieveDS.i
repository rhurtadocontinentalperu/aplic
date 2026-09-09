
/**
 * RetrieveDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Retrieve
&else
    &scoped xName {1}
&endif



{RetrieveTT.i   {&xName}}
{IdsTT.i        {&xName}_IDs}

define dataset ds{&xName}

    for tt{&xName}, tt{&xName}_IDs.
