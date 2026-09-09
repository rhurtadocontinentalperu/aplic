
/**
 * QueryResponseRead.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{QueryResponseDS.i}



define output   param dataset for dsQueryResponse.
define input    param phSObject         as handle no-undo.
define input    param pcQueryResponse   as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hRecords as handle no-undo.
define var hBuffer  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hRecords.

dataset dsQueryResponse:empty-dataset( ).

hBuffer = phSObject:get-buffer-handle(1).

hDoc:load( "longchar", pcQueryResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttQueryResponse.
    run sfdc_readDSBuffer( input buffer ttQueryResponse:handle, hResult ).

    repeat while xml_getElementByAttr( hResult, hRecords, "records", "" ):

        hBuffer:buffer-create( ).
        run sfdc_readDSBuffer( hBuffer, hRecords ).

    end. /* repeat */

end. /* repeat */
