
/**
 * RetrieveResponseRead.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}



define input param phSObject            as handle no-undo.  
define input param pcRetrieveResponse   as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hBuffer  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.

hBuffer = phSObject:get-buffer-handle(1).

hDoc:load( "longchar", pcRetrieveResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    hBuffer:buffer-create( ).
    run sfdc_readDSBuffer( hBuffer, hResult ).

end. /* repeat */
