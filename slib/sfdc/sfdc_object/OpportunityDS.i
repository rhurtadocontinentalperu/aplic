
/**
 * OpportunityDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName Opportunity
&else
    &scoped xName {1}
&endif



{OpportunityTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
