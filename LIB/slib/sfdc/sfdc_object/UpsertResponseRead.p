
/**
 * UpsertResponseRead.p
 *
 * 
 */

{UpsertResponseDS.i}

{libsfdc.i}

{libxml.i}

{liberr.i}



define output   param dataset for dsUpsertResponse.
define input    param pcUpsertResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hErrors  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hErrors.

dataset dsUpsertResponse:empty-dataset( ).

hDoc:load( "longchar", pcUpsertResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttUpsertResponse.
    run sfdc_readDSBuffer( input buffer ttUpsertResponse:handle, hResult ).

    repeat while xml_getElementByAttr( hResult, hErrors, "errors", "" ):

        create ttUpsertResponse_Errors.
        assign ttUpsertResponse_Errors.tid = ttUpsertResponse.tid.

        run sfdc_readDSBuffer( input buffer ttUpsertResponse_Errors:handle, hErrors ).

    end. /* repeat */

end. /* repeat */
