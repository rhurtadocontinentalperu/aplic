
/**
 * OpportunityLineItemDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName OpportunityLineItem
&else
    &scoped xName {1}
&endif



{OpportunityLineItemTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
