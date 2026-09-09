
/**
 * GetUpdatedWrite.p -
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{GetUpdatedDS.i}



define input    param dataset for dsGetUpdated.
define output   param pcGetUpdated as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.

find first ttGetUpdated no-error.
if not avail ttGetUpdated then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:getUpdated", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).
run sfdc_writeDSBuffer( input buffer ttGetUpdated:handle , hRoot ).

hDoc:save( "longchar", pcGetUpdated ).
