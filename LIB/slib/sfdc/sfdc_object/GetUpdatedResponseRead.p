
/**
 * GetUpdatedResponseRead.p -
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{GetUpdatedResponseDS.i}



define output   param dataset for dsGetUpdatedResponse.
define input    param pcGetUpdatedResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hIds     as handle no-undo.
define var hValue   as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hIds.
create x-noderef hValue.

dataset dsGetUpdatedResponse:empty-dataset( ).

hDoc:load( "longchar", pcGetUpdatedResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttGetUpdatedResponse.
    run sfdc_readDSBuffer( input buffer ttGetUpdatedResponse:handle, hResult ).

    repeat while xml_getElementByAttr( hResult, hIds, "ids", "" ):

        hIds:get-child( hValue, 1 ).
        if hValue:subtype = "text" then do:

            create ttGetUpdatedResponse_IDs.
            assign ttGetUpdatedResponse_IDs.tids = hValue:node-value.

        end. /* subtype = "text" */

    end. /* repeat */
    
end. /* repeat */
