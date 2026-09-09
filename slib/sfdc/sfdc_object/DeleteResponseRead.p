
/**
 * DeleteResponseRead.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{DeleteResponseDS.i}



define output   param dataset for dsDeleteResponse.
define input    param pcDeleteResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hErrors  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hErrors.

dataset dsDeleteResponse:empty-dataset( ).

hDoc:load( "longchar", pcDeleteResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttDeleteResponse.
    run sfdc_readDSBuffer( input buffer ttDeleteResponse:handle, hResult ).

    repeat while xml_getElementByAttr( hResult, hErrors, "errors", "" ):

        create ttDeleteResponse_Errors.
        assign ttDeleteResponse_Errors.tid = ttDeleteResponse.tid.

        run sfdc_readDSBuffer( input buffer ttDeleteResponse_Errors:handle, hErrors ).

    end. /* repeat */

end. /* repeat */
