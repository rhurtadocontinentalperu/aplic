
/**
 * SaveResponseRead.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{SaveResponseDS.i}




define output   param dataset for dsSaveResponse.
define input    param pcSaveResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hErrors  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hErrors.

dataset dsSaveResponse:empty-dataset( ).

hDoc:load( "longchar", pcSaveResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttSaveResponse.
    run sfdc_readDSBuffer( input buffer ttSaveResponse:handle, hResult ).

    repeat while xml_getElementByAttr( hResult, hErrors, "errors", "" ):

        create ttSaveResponse_Errors.
        assign ttSaveResponse_Errors.tid = ttSaveResponse.tid.

        run sfdc_readDSBuffer( input buffer ttSaveResponse_Errors:handle, hErrors ).

    end. /* repeat */

end. /* repeat */
