
/**
 * LoginResponseRead.p
 *
 * 
 */

{libsfdc.i}

{libxml.i}

{liberr.i}

{LoginResponseDS.i}



define output   param dataset for dsLoginResponse.
define input    param pcLoginResponse as longchar no-undo.

define var hDoc         as handle no-undo.
define var hResult      as handle no-undo.
define var hUserInfo    as handle no-undo.



create widget-pool.

create x-document hDoc.
create x-noderef hResult.
create x-noderef hUserInfo.

dataset dsLoginResponse:empty-dataset( ).

hDoc:load( "longchar", pcLoginResponse, no ).

repeat while xml_getElementByAttr( hDoc, hResult, "result", "" ):

    create ttLoginResponse.
    run sfdc_readDSBuffer( input buffer ttLoginResponse:handle, hResult ).

    if xml_getElementByAttr( hResult, hUserInfo, "userInfo", "" ) then do:

        create ttLoginResponse_UserInfo.
        run sfdc_readDSBuffer( ( buffer ttLoginResponse_UserInfo:handle ), hUserInfo ).

    end. /* xml_getElementByAttr */

end. /* repeat */
