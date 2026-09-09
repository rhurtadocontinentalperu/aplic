
/**
 * UpsertWrite.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{UpsertDS.i}



define input    param dataset for dsUpsert.
define input    param phSObject as handle no-undo.
define output   param pcUpsert  as longchar no-undo.

define var hDoc         as handle no-undo.
define var hRoot        as handle no-undo.
define var hSObjects    as handle no-undo.
define var hElement     as handle no-undo.
define var hValue       as handle no-undo.

define var qhSObject    as handle no-undo.
define var bhSObject    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hRoot.
create x-noderef hSObjects.
create x-noderef hElement.
create x-noderef hValue.

find first ttUpsert no-error.
if not avail ttUpsert then return.

hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:upsert", "element" ).
hDoc:append-child( hRoot ).

hRoot:set-attribute( "xmlns:xsi",   {&xml_xNsXsi} ).
hRoot:set-attribute( "xmlns:sfdc",  {&sfdc_xNsSForce} ).
hRoot:set-attribute( "xmlns:sfo",   {&sfdc_xNsSObject} ).

hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:externalIDFieldName", "element" ).
hRoot:append-child( hElement ).

hDoc:create-node( hValue, ?, "text" ).
hElement:append-child( hValue ).

hValue:node-value = ttUpsert.texternalIDFieldName.



create query qhSObject.
create buffer bhSObject

    for table phSObject:get-buffer-handle(1):table-handle
        buffer-name "bSObject".

qhSObject:set-buffers( bhSObject ).
qhSObject:query-prepare( "for each bSObject" ).
qhSObject:query-open( ).

repeat while qhSObject:get-next( ):

    hDoc:create-node-namespace( hSObjects, {&sfdc_xNsSForce}, "sfdc:sObjects", "element" ).
    hRoot:append-child( hSObjects ).

    hSObjects:set-attribute( "xsi:type", "sfo:" + ttUpsert.tsObjectType ).
    run sfdc_writeDSBuffer( bhSObject, hSObjects ).

end. /* repeat */

qhSObject:query-close( ) no-error.

hDoc:save( "longchar", pcUpsert ).
