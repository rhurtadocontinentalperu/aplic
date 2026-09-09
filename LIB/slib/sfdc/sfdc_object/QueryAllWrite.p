
/**
 * QueryWrite.p
 *
 * By Alon Blich
 */

{slib/slibsfdc.i}

{slib/slibxml.i}

{slib/sliberr.i}

{sfdc_object/QueryDS.i}



define input    param dataset for dsQuery.
define output   param pcQuery as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.

find first ttQuery no-error.
if not avail ttQuery then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:queryAll", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc",  {&sfdc_xNsSForce} ).
hRoot:set-attribute( "xmlns:sfo",   {&sfdc_xNsSObject} ).

run sfdc_writeDSBuffer( input buffer ttQuery:handle, hRoot ).

hDoc:save( "longchar", pcQuery ).
