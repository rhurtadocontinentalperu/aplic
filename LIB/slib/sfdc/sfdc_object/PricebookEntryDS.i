
/**
 * PricebookEntryDS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName PricebookEntry
&else
    &scoped xName {1}
&endif



{PricebookEntryTT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
