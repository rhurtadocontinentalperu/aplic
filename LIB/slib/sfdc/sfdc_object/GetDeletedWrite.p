
/**
 * GetDeletedWrite.p -
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{GetDeletedDS.i}



define input    param dataset for dsGetDeleted.
define output   param pcGetDeleted as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.

find first ttGetDeleted no-error.
if not avail ttGetDeleted then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:getDeleted", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).
run sfdc_writeDSBuffer( input buffer ttGetDeleted:handle, hRoot ).

hDoc:save( "longchar", pcGetDeleted ).
