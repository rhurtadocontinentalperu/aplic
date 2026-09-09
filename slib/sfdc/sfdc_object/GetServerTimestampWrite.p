
/**
 * GetServerTimestampWrite.p
 *
 * 
 */

{libsfdc.i}

{libxml.i}

{liberr.i}



define output param pcGetServerTimestamp as longchar no-undo.

define var hDoc     as handle no-undo.
define var hRoot    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:getServerTimestamp", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:sfdc",  {&sfdc_xNsSForce} ).

hDoc:save( "longchar", pcGetServerTimestamp ).
