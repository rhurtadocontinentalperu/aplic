
/**
 * DeleteWrite.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{DeleteDS.i}



define input    param dataset for dsDelete.
define output   param pcDelete as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.
define var hElement as handle no-undo.
define var hValue   as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.
create x-noderef hElement.
create x-noderef hValue.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:delete", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc",  {&sfdc_xNsSForce} ).
hRoot:set-attribute( "xmlns:sfo",   {&sfdc_xNsSObject} ).

for each ttDelete_IDs:

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:ids", "element" ).
    hRoot:append-child( hElement ).

    hDoc:create-node( hValue, ?, "text" ).
    hElement:append-child( hValue ).

    hValue:node-value = ttDelete_IDs.tids.

end. /* for each */

hDoc:save( "longchar", pcDelete ).
