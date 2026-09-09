
/**
 * Pricebook2DS.i -
 *
 * By Alon Blich
 */

&if "{1}" = "" &then
    &scoped xName PriceBook2
&else
    &scoped xName {1}
&endif



{PriceBook2TT.i {&xName}}

define dataset ds{&xName} for tt{&xName}.
