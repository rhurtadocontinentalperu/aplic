
/**
 * RetrieveWrite.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{RetrieveDS.i}



define input    param dataset for dsRetrieve.
define output   param pcRetrieve as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.
define var hElement as handle no-undo.
define var hValue   as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.
create x-noderef hElement.
create x-noderef hValue.

find first ttRetrieve no-error.
if not avail ttRetrieve then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:retrieve", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc",  {&sfdc_xNsSForce} ).
hRoot:set-attribute( "xmlns:sfo",   {&sfdc_xNsSObject} ).

run sfdc_writeDSBuffer( input buffer ttRetrieve:handle, hRoot ).

for each ttRetrieve_IDs:

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:ids", "element" ).
    hRoot:append-child( hElement ).

    hDoc:create-node( hValue, ?, "text" ).
    hElement:append-child( hValue ).

    hValue:node-value = ttRetrieve_IDs.tids.

end. /* for each */

hDoc:save( "longchar", pcRetrieve ).
