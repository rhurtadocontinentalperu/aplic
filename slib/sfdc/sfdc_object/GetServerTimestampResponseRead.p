
/**
 * GetServerTimestampResponseRead.p -
 *
 * By Alon Blich
 */

{slib/slibsfdc.i}

{slib/slibxml.i}

{slib/sliberr.i}

{sfdc_object/GetServerTimestampResponseDS.i}



define output   param dataset for dsGetServerTimestampResponse.
define input    param pcGetServerTimestampResponse as longchar no-undo.

define var hDoc     as handle no-undo.
define var hResult  as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.

dataset dsGetServerTimestampResponse:empty-dataset( ).

hDoc:load( "longchar", pcGetServerTimestampResponse, no ).

repeat while xml_getElementByAttr( 

    input hDoc,
    input hResult,
    input "", "result", 
    input "", "", "" ):

    create ttGetServerTimestampResponse.
    run sfdc_readDSBuffer( input buffer ttGetServerTimestampResponse:handle, hResult ).
    
end. /* repeat */
