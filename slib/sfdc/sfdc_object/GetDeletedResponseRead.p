
/**
 * GetDeletedResponseRead.p
 *
 * By Alon Blich
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{GetDeletedResponseDS.i}



define output   param dataset for dsGetDeletedResponse.
define input    param pcGetDeletedResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.
define var hRecords as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hRecords.

dataset dsGetDeletedResponse:empty-dataset( ).

hDoc:load( "longchar", pcGetDeletedResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttGetDeletedResponse.
    run sfdc_readDSBuffer( input buffer ttGetDeletedResponse:handle, hResult ).
    
    repeat while xml_getElementByAttr( hResult, hRecords, "deletedRecords", "" ):

        create ttGetDeletedResponse_Records.
        run sfdc_readDSBuffer( input buffer ttGetDeletedResponse_Records:handle, hRecords ).

    end. /* repeat */

end. /* repeat */
