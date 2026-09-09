
/**
 * LoginWrite.p -
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{LoginDS.i}



define input    param dataset for dsLogin.
define output   param pcLogin as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.

find first ttLogin no-error.
if not avail ttLogin then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:login", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

run sfdc_writeDSBuffer( input buffer ttLogin:handle, hRoot ).

hDoc:save( "longchar", pcLogin ).

