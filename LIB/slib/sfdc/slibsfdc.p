
/**
 * libsfdc.p -
 *
 * (c) Copyright ABC Alon Blich Consulting Tech, Ltd.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

{libsfdcprop.i}

{libxml.i}

{libos.i}

{liberr.i "'libsfdc.err'"}



{LoginDS.i}
{LoginResponseDS.i}

{IdsDS.i}
{QueryDS.i}
{QueryMoreDS.i}
{QueryResponseDS.i}

{RetrieveDS.i}

{CreateDS.i}
{UpdateDS.i}
{SaveResponseDS.i}

{UpsertDS.i}
{UpsertResponseDS.i}

{DeleteDS.i}
{DeleteResponseDS.i}

{GetServerTimestampResponseDS.i}

{GetUpdatedDS.i}
{GetUpdatedResponseDS.i}

{GetDeletedDS.i}
{GetDeletedResponseDS.i}



procedure sfdc_login:

    define input    param pcUsername    as char no-undo.
    define input    param pcPassword    as char no-undo.
    define input    param pcToken       as char no-undo.

    define output   param phWebService  as handle no-undo.
    define output   param phPortType    as handle no-undo.
    define output   param dataset for dsLoginResponse. 

    run doLogin(
        input   pcUsername,
        input   pcPassword,
        input   pcToken,

        output  phWebService,
        output  phPortType,
        output  dataset dsLoginResponse by-reference ).

end procedure. /* sfdc_login */



/***
procedure sfdc_fetchChanges:

    define input        param pcSObjectType                 as char no-undo.
    define input        param pcFieldList                   as char no-undo.
    define input-output param ptGetUpdatedLatestDateCovered as datetime no-undo.
    define input-output param ptGetDeletedLatestDateCovered as datetime no-undo.
    define output       param dataset-handle phSObject.
    define output       param dataset for dsIDs.

    run fetchChanges(
        input           target-procedure,
        input           pcSObjectType,
        input           pcFieldList,
        input-output    ptGetUpdatedLatestDateCovered,
        input-output    ptGetDeletedLatestDateCovered,
        input           phSObject,
        output          dataset dsIDs by-reference ).

end procedure. /* sfdc_fetchChanges */
***/



procedure sfdc_getDeleted:

    define input    param pcSObjectType as char no-undo.
    define input    param ptStartDate   as datetime no-undo.
    define input    param ptEndDate     as datetime no-undo.
    define input    param plByLocalTime as log no-undo.
    define output   param dataset for dsGetDeletedResponse.

    run getDeleted(
        input   target-procedure,
        input   pcSObjectType,
        input   ptStartDate,
        input   ptEndDate,
        input   plByLocalTime,
        output  dataset dsGetDeletedResponse by-reference ).

end procedure. /* sfdc_getDeleted */

procedure sfdc_getUpdated:

    define input    param pcSObjectType as char no-undo.
    define input    param ptStartDate   as datetime no-undo.
    define input    param ptEndDate     as datetime no-undo.
    define input    param plByLocalTime as log no-undo. 
    define output   param dataset for dsGetUpdatedResponse.

    run getUpdated(
        input   target-procedure,
        input   pcSObjectType,
        input   ptStartDate,
        input   ptEndDate,
        input   plByLocalTime,
        output  dataset dsGetUpdatedResponse by-reference ).

end procedure. /* sfdc_getUpdated */

procedure sfdc_getServerTimestamp:
    
    define output param dataset for dsGetServerTimestampResponse.
    
    run getServerTimestamp(
        input   target-procedure,
        output  dataset dsGetServerTimestampResponse by-reference ).
    
end procedure. /* sfdc_getServerTimestamp */

procedure sfdc_getTimeDiff:

    define output param piTimeDiff as int no-undo.

    run getTimeDiff( 
        input   target-procedure,
        output  piTimeDiff  ).

end procedure. /* sfdc_getTimeDiff */



procedure sfdc_queryNoBatch:

    define input    param pcQueryString as char no-undo.
    define output   param dataset-handle phSObject.

    run doQuery(
        input   target-procedure,
        input   pcQueryString,
        input   phSObject,
        output  dataset dsQueryResponse by-reference ).

    repeat:

        find first ttQueryResponse no-error.

        if ttQueryResponse.tdone then leave.

        run doQueryMore(
            input   target-procedure,
            input   ttQueryResponse.tqueryLocator,
            input   phSObject,
            output  dataset dsQueryResponse by-reference ).

    end. /* repeat */

end procedure. /* sfdc_queryNoBatch */

procedure sfdc_query:

    define input    param pcQueryString as char no-undo.
    define output   param dataset-handle phSObject.
    define output   param dataset for dsQueryResponse.

    run doQuery(
        input   target-procedure,
        input   pcQueryString,
        input   phSObject,
        output  dataset dsQueryResponse by-reference ).

end procedure. /* sfdc_query */

procedure sfdc_queryAllNoBatch:

    define input    param pcQueryString as char no-undo.
    define output   param dataset-handle phSObject.

    run doQueryAll(
        input   target-procedure,
        input   pcQueryString,
        input   phSObject,
        output  dataset dsQueryResponse by-reference ).

    repeat:

        find first ttQueryResponse no-error.

        if ttQueryResponse.tdone then leave.

        run doQueryMore(
            input   target-procedure,
            input   ttQueryResponse.tqueryLocator,
            input   phSObject,
            output  dataset dsQueryResponse by-reference ).

    end. /* repeat */

end procedure. /* sfdc_queryNoBatch */

procedure sfdc_queryAll:

    define input    param pcQueryString as char no-undo.
    define output   param dataset-handle phSObject.
    define output   param dataset for dsQueryResponse.

    run doQueryAll(
        input   target-procedure,
        input   pcQueryString,
        input   phSObject,
        output  dataset dsQueryResponse by-reference ).

end procedure. /* sfdc_query */

procedure sfdc_queryMore:

    define input        param pcQueryLocator as char no-undo.
    define input-output param dataset-handle phSObject.
    define output       param dataset for dsQueryResponse.

    run doQueryMore(
        input   target-procedure,
        input   pcQueryLocator,
        input   phSObject,
        output  dataset dsQueryResponse by-reference ).

end procedure. /* sfdc_queryMore */

procedure sfdc_retrieve:

    define input        param dataset for dsRetrieve.
    define input-output param dataset-handle phSObject.

    run doRetrieve(
        input target-procedure,
        input dataset dsRetrieve by-reference,
        input phSObject ).

end procedure. /* sfdc_retrieve */

procedure sfdc_create:

    define input    param pcSObjectType as char no-undo.
    define input    param dataset-handle phSObject.
    define output   param dataset for dsSaveResponse.

    run doCreate (
        input   target-procedure,
        input   pcSObjectType,
        input   phSObject,
        output  dataset dsSaveResponse by-reference ).

end procedure. /* sfdc_create */

procedure sfdc_delete:

    define input    param dataset for dsDelete.
    define output   param dataset for dsDeleteResponse.
    
    run doDelete(
        input   target-procedure,
        input   dataset dsDelete by-reference  ,
        output  dataset dsDeleteResponse by-reference  ).
    
end procedure. /* sfdc_delete */

procedure sfdc_update:

    define input    param pcSObjectType as char no-undo.
    define input    param dataset-handle phSObject.
    define output   param dataset for dsSaveResponse.

    run doUpdate (
        input   target-procedure,
        input   pcSObjectType,
        input   phSObject,
        output  dataset dsSaveResponse by-reference ).

end procedure. /* sfdc_update */

procedure sfdc_upsert:

    define input    param pcSObjectType         as char no-undo.
    define input    param pcExternalIDFieldName as char no-undo.
    define input    param dataset-handle phSObject.
    define output   param dataset for dsUpsertResponse.

    run doUpsert (
        input   target-procedure,
        input   pcSObjectType,
        input   pcExternalIDFieldName,
        input   phSObject,
        output  dataset dsUpsertResponse by-reference ).

end procedure. /* sfdc_upsert */



procedure doLogin private:

    define input    param pcUsername    as char no-undo.
    define input    param pcPassword    as char no-undo.
    define input    param pcToken       as char no-undo.
    define output   param phWebService  as handle no-undo.
    define output   param phPortType    as handle no-undo.
    define output   param dataset for dsLoginResponse. 

    define var cWsdlFile        as char no-undo.
    define var cLogin           as longchar no-undo.
    define var cLoginResponse   as longchar no-undo.

    dataset dsLoginResponse:empty-dataset( ).

    {slib/err_try}:

        file-info:file-name = "src/enterprise.xml".

        cWsdlFile = os_getFullPath( "srcl/enterprise.xml" ).

        if cWsdlFile = ? then
           cWsdlFile = os_getFullPath( "enterprise.xml" ).

        if cWsdlFile = ? then {slib/err_throw "'sfdc_wsdl_file_not_found'" "'src/enterprise.xml'"}.

        create server phWebService.

        phWebService:connect( "-WSDL " + quoter( cWsdlFile ) ) {slib/err_no-error}.
        if not phWebService:connected( ) then {slib/err_throw "'sfdc_conn_failed'"}.

        run Soap set phPortType on phWebService {slib/err_no-error}.

        dataset dsLogin:empty-dataset( ).

        create ttLogin.
        assign
            ttLogin.tusername = pcUsername
            ttLogin.tpassword = pcPassword + pcToken.

        run LoginWrite.p (
            input   dataset dsLogin by-reference,
            output  cLogin ).

        run login in phPortType ( 
            input   cLogin,
            output  cLoginResponse ) {slib/err_no-error}.

        run LoginResponseRead.p (
            output  dataset dsLoginResponse by-reference,
            input   cLoginResponse ).

        find first ttLoginResponse no-error.
        find first ttLoginResponse_UserInfo no-error.

        if not ( avail ttLoginResponse
             and avail ttLoginResponse_UserInfo ) then {slib/err_throw "'sfdc_conn_failed'"}.

        delete procedure phPortType no-error.

        phWebService:disconnect( ) {slib/err_no-error}.
        delete object phWebService no-error.

        create server phWebService.

        phWebService:connect( 
              "-WSDL " + quoter( cWsdlFile ) + " "
            + "-Binding SoapBinding "
            + "-SOAPEndpoint " + quoter( ttLoginResponse.tserverUrl ) ) {slib/err_no-error}.

        if not phWebService:connected( ) then {slib/err_throw "'sfdc_conn_failed'"}.
        run Soap set phPortType on phWebService {slib/err_no-error}.

    {slib/err_catch}:

        delete procedure phPortType no-error.

        phWebService:disconnect( ) no-error.
        delete object phWebService no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doLogin */

/***
procedure fetchChanges private:

    define input        param phConn                        as handle no-undo.
    define input        param pcSObjectType                 as char no-undo.
    define input        param pcFieldList                   as char no-undo.
    define input-output param ptGetUpdatedLatestDateCovered as datetime no-undo.
    define input-output param ptGetDeletedLatestDateCovered as datetime no-undo.
    define input        param phSObject                     as handle no-undo.
    define output       param dataset for dsIDs.

    define var qhSObject as handle no-undo.
    define var bhSObject as handle no-undo.

    phSObject:empty-dataset( ).
    dataset dsIDs:empty-dataset( ).

    if ptGetUpdatedLatestDateCovered = ? then
       ptGetUpdatedLatestDateCovered = datetime( today - 1 ).

    if ptGetDeletedLatestDateCovered = ? then
       ptGetDeletedLatestDateCovered = datetime( today - 1 ).

    run getUpdated(
        input   phConn,
        input   pcSObjectType,
        input   ptGetUpdatedLatestDateCovered,
        input   datetime( today + 1 ),
        input   yes,
        output  dataset dsGetUpdatedResponse by-reference ).

    run getDeleted(
        input   phConn,
        input   pcSObjectType,
        input   ptGetDeletedLatestDateCovered,
        input   datetime( today + 1 ),
        input   yes,
        output  dataset dsGetDeletedResponse by-reference ).

    dataset dsRetrieve:empty-dataset( ).

    create ttRetrieve.
    assign
        ttRetrieve.tfieldList   = pcFieldList
        ttRetrieve.tsObjectType = pcSObjectType.

    for each ttGetUpdatedResponse_IDs:

        create ttRetrieve_IDs.
        assign ttRetrieve_IDs.tids = ttGetUpdatedResponse_IDs.tids.

    end. /* each ttGetUpdatedResponse_IDs */

    for each ttGetDeletedResponse_Records:

        create ttRetrieve_IDs.
        assign ttRetrieve_IDs.tids = ttGetDeletedResponse_Records.tid.

    end. /* each ttGetDeletedResponse_Records */

    if can-find( first ttRetrieve_IDs ) then do:

        run doRetrieve(
            input phConn,
            input dataset dsRetrieve by-reference,
            input phSObject ).

        {slib/err_try}:

            create query qhSObject.
            create buffer bhSObject

                for table phSObject:get-buffer-handle(1):table-handle
                    buffer-name "bSObject".

            qhSObject:set-buffers( ( buffer ttRetrieve_IDs:handle ), bhSObject ).
            qhSObject:query-prepare( 

                "for each  ttRetrieve_IDs, " +

                    "first bSObject " +
                    "where bSObject.tId = ttRetrieve_IDs.tids " +
                    "outer-join" ) {slib/err_no-error}.

            qhSObject:query-open( ) {slib/err_no-error}.

            repeat while qhSObject:get-next( ):

                if not bhSObject:avail then do:

                    create ttIDs.
                    assign ttIDs.tids = ttRetrieve_IDs.tids.

                end. /* not avail */

            end. /* repeat */

        {slib/err_catch}:

            {slib/err_throw last}.

        {slib/err_finally}:

            if valid-handle( qhSObject ) then
                qhSObject:query-close( ) no-error.

            delete object qhSObject no-error.
            delete object bhSObject no-error.

        {slib/err_end}.

    end. /* can-find( first ) */

    find first ttGetUpdatedResponse no-error.
    find first ttGetDeletedResponse no-error.
    
    ptGetUpdatedLatestDateCovered = ttGetUpdatedResponse.tlatestDateCovered.
    ptGetDeletedLatestDateCovered = ttGetDeletedResponse.tlatestDateCovered.

end procedure. /* fetchChanges */
***/

procedure getDeleted private:

    define input    param phConn        as handle no-undo.
    define input    param pcSObjectType as char no-undo.
    define input    param ptStartTime   as datetime no-undo.
    define input    param ptEndTime     as datetime no-undo.
    define input    param plByLocalTime as log no-undo.
    define output   param dataset for dsGetDeletedResponse.

    define var hPortType            as handle no-undo.
    define var hSOAPHeader          as handle no-undo.
    define var cSessionID           as char no-undo.
    define var iTimeDiff            as int no-undo.

    define var cGetDeleted          as longchar no-undo.
    define var cGetDeletedResponse  as longchar no-undo.

    dataset dsGetDeletedResponse:empty-dataset( ).

    {slib/err_try}:

        if plByLocalTime then do:

            run getTimeDiff( input phConn, output iTimeDiff ).

            assign
                ptStartTime = ptStartTime   - iTimeDiff
                ptEndTime   = ptEndTime     - iTimeDiff.
           
        end. /* plLocalTime */

        assign
            ptStartTime = datetime( date( ptStartTime ),    mtime( ptStartTime )    - mtime( ptStartTime ) mod 60000 )
            ptEndTime   = datetime( date( ptEndTime ),      mtime( ptEndTime )      - mtime( ptEndTime ) mod 60000 )
                 
        /***
        if  ptEndTime = ptStartTime then
            ptEndTime = ptEndTime + 60000.
        ***/
            ptEndTime = ptEndTime + 60000.

        

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn ) {slib/err_no-error}.
        
        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        dataset dsGetDeleted:empty-dataset( ).

        create ttGetDeleted.
        assign
            ttGetDeleted.tsObjectType   = pcSObjectType
            ttGetDeleted.tstartDate     = ptStartTime
            ttGetDeleted.tendDate       = ptEndTime.
         
        run GetDeletedWrite.p (
            input   dataset dsGetDeleted by-reference,
            output  cGetDeleted ).

        run getDeleted in hPortType ( 
            input   cGetDeleted,
            output  cGetDeletedResponse ) {slib/err_no-error}.

        run GetDeletedResponseRead.p (
            output  dataset dsGetDeletedResponse by-reference,
            input   cGetDeletedResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* getDeleted */

procedure getUpdated private:

    define input    param phConn        as handle no-undo.
    define input    param pcSObjectType as char no-undo.
    define input    param ptStartTime   as datetime no-undo.
    define input    param ptEndTime     as datetime no-undo.
    define input    param plByLocalTime as log no-undo.
    define output   param dataset for dsGetUpdatedResponse.

    define var hPortType            as handle no-undo.
    define var hSOAPHeader          as handle no-undo.
    define var cSessionID           as char no-undo.

    define var cGetUpdated          as longchar no-undo.
    define var cGetUpdatedResponse  as longchar no-undo.

    define var iTimeDiff            as int no-undo.

    dataset dsGetUpdatedResponse:empty-dataset( ).

    {slib/err_try}:
        
        if plByLocalTime then do:

            run getTimeDiff( input phConn, output iTimeDiff ).

            assign
                ptStartTime = ptStartTime   - iTimeDiff
                ptEndTime   = ptEndTime     - iTimeDiff.

        end. /* plByLocalTime */

        assign
            ptStartTime = datetime( date( ptStartTime ),    mtime( ptStartTime )    - mtime( ptStartTime ) mod 60000 )
            ptEndTime   = datetime( date( ptEndTime ),      mtime( ptEndTime )      - mtime( ptEndTime ) mod 60000 )
                        
        /***
        if  ptEndTime = ptStartTime then
            ptEndTime = ptEndTime + 60000.
        ***/

            ptEndTime = ptEndTime + 60000.



        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn ) {slib/err_no-error}.
        
        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        dataset dsGetUpdated:empty-dataset( ).

        create ttGetUpdated.
        assign
            ttGetUpdated.tsObjectType   = pcSObjectType
            ttGetUpdated.tstartDate     = ptStartTime
            ttGetUpdated.tendDate       = ptEndTime.
        


        run GetUpdatedWrite.p (
            input   dataset dsGetUpdated by-reference,
            output  cGetUpdated ).

        run getUpdated in hPortType ( 
            input   cGetUpdated,
            output  cGetUpdatedResponse ) {slib/err_no-error}.

        run GetUpdatedResponseRead.p (
            output  dataset dsGetUpdatedResponse by-reference,
            input   cGetUpdatedResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* getUpdated */

procedure getServerTimestamp private:

    define input    param phConn        as handle no-undo.
    define output   param dataset for dsGetServerTimestampResponse.

    define var hPortType            as handle no-undo.
    define var hSOAPHeader          as handle no-undo.
    define var cSessionID           as char no-undo.

    define var cGetServerTimestamp          as longchar no-undo.
    define var cGetServerTimestampResponse  as longchar no-undo.

    dataset dsGetServerTimestampResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).
        

        run GetServerTimestampWrite.p (
            output  cGetServerTimestamp ).

        run getServerTimestamp in hPortType ( 
            input   cGetServerTimestamp,
            output  cGetServerTimestampResponse ) {slib/err_no-error}.

        run GetServerTimestampResponseRead.p (
            output  dataset dsGetServerTimestampResponse by-reference,
            input   cGetServerTimestampResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* getServerTimestamp */

procedure getTimeDiff private:

    define input  param phConn      as handle no-undo.
    define output param piTimeDiff  as int no-undo.

    {slib/err_try}:

        run getServerTimestamp(
            input   phConn,
            output  dataset dsGetServerTimestampResponse by-reference ).

        find first ttGetServerTimestampResponse no-error.

        if avail ttGetServerTimestampResponse then
             piTimeDiff = interval( now, ttGetServerTimestampResponse.tTimestamp, "milliseconds" ).
        else piTimeDiff = timezone( now ) * 60 * 1000.

    {slib/err_catch}:
        
        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* getTimeDiff */



procedure doRetrieve private:

    define input param phConn       as handle no-undo.
    define input param dataset for dsRetrieve.
    define input param phSObject    as handle no-undo.

    define var hPortType            as handle no-undo.
    define var hSOAPHeader          as handle no-undo.
    define var cSessionID           as char no-undo.

    define var cRetrieve            as longchar no-undo.
    define var cRetrieveResponse    as longchar no-undo.

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        run RetrieveWrite.p (
            input   dataset dsRetrieve by-reference,
            output  cRetrieve ).

        run retrieve in hPortType ( 
            input   cRetrieve,
            output  cRetrieveResponse ) {slib/err_no-error}.

        run RetrieveResponseRead.p (
            input   phSObject,
            input   cRetrieveResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doRetrieve */

procedure doQuery private:

    define input    param phConn        as handle no-undo.
    define input    param pcQueryString as char no-undo.
    define input    param phSObject     as handle no-undo.
    define output   param dataset for dsQueryResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cQuery           as longchar no-undo.
    define var cQueryResponse   as longchar no-undo.

    phSObject:empty-dataset( ).

    dataset dsQueryResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            iBatchSize  = dynamic-function( "sfdc_getBatchSize" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsQuery:empty-dataset( ).

        create ttQuery.
        assign ttQuery.tqueryString = pcQueryString.

        run QueryWrite.p (
            input   dataset dsQuery by-reference,
            output  cQuery ).

        run query in hPortType ( 
            input   cQuery,
            output  cQueryResponse ) {slib/err_no-error}.

        run QueryResponseRead.p (
            output  dataset dsQueryResponse by-reference,
            input   phSObject,
            input   cQueryResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doQuery */

procedure doQueryAll private:

    define input    param phConn        as handle no-undo.
    define input    param pcQueryString as char no-undo.
    define input    param phSObject     as handle no-undo.
    define output   param dataset for dsQueryResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cQuery           as longchar no-undo.
    define var cQueryResponse   as longchar no-undo.

    phSObject:empty-dataset( ).

    dataset dsQueryResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            iBatchSize  = dynamic-function( "sfdc_getBatchSize" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsQuery:empty-dataset( ).

        create ttQuery.
        assign ttQuery.tqueryString = pcQueryString.

        run QueryAllWrite.p (
            input   dataset dsQuery by-reference,
            output  cQuery ).

        run queryAll in hPortType ( 
            input   cQuery,
            output  cQueryResponse ) {slib/err_no-error}.

        run QueryAllResponseRead.p (
            output  dataset dsQueryResponse by-reference,
            input   phSObject,
            input   cQueryResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doQueryAll */

procedure doQueryMore private:

    define input    param phConn            as handle no-undo.
    define input    param pcQueryLocator    as char no-undo.
    define input    param phSObject         as handle no-undo.
    define output   param dataset for dsQueryResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cQueryMore       as longchar no-undo.
    define var cQueryResponse   as longchar no-undo.

    dataset dsQueryResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            iBatchSize  = dynamic-function( "sfdc_getBatchSize" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsQueryMore:empty-dataset( ).

        create ttQueryMore.
        assign ttQueryMore.tqueryLocator = pcQueryLocator.

        run QueryMoreWrite.p (
            input   dataset dsQueryMore by-reference,
            output  cQueryMore ).

        run queryMore in hPortType ( 
            input   cQueryMore,
            output  cQueryResponse ) {slib/err_no-error}.

        run QueryResponseRead.p (
            output  dataset dsQueryResponse by-reference,
            input   phSObject,
            input   cQueryResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doQueryMore */

procedure doCreate:

    define input    param phConn        as handle no-undo.
    define input    param pcSObjectType as char no-undo.
    define input    param phSObject     as handle no-undo.
    define output   param dataset for dsSaveResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cCreate          as longchar no-undo.
    define var cSaveResponse    as longchar no-undo.

    dataset dsSaveResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsCreate:empty-dataset( ).

        create ttCreate.
        assign ttCreate.tsObjectType = pcSObjectType.

        run CreateWrite.p (
            input   dataset dsCreate by-reference,
            input   phSObject,
            output  cCreate ).

        run create in hPortType ( 
            input   cCreate,
            output  cSaveResponse ) {slib/err_no-error}.

        run SaveResponseRead.p (
            output  dataset dsSaveResponse by-reference,
            input   cSaveResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doCreate */

procedure doDelete private:

    define input  param phConn       as handle no-undo.
    define input  param dataset for dsDelete.
    define output param dataset for dsDeleteResponse.
    
    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.

    define var cDelete          as longchar no-undo.
    define var cDeleteResponse  as longchar no-undo.

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        run DeleteWrite.p (
            input   dataset dsDelete by-reference,
            output  cDelete ).

        run delete in hPortType ( 
            input   cDelete,
            output  cDeleteResponse ) {slib/err_no-error}.

        run DeleteResponseRead.p (
            output  dataset dsDeleteResponse by-reference,
            input   cDeleteResponse ).
        
    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doDelete */

procedure doUpdate:

    define input    param phConn        as handle no-undo.
    define input    param pcSObjectType as char no-undo.
    define input    param phSObject     as handle no-undo.
    define output   param dataset for dsSaveResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cUpdate          as longchar no-undo.
    define var cSaveResponse    as longchar no-undo.

    dataset dsSaveResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsUpdate:empty-dataset( ).

        create ttUpdate.
        assign ttUpdate.tsObjectType = pcSObjectType.

        run UpdateWrite.p (
            input   dataset dsUpdate by-reference,
            input   phSObject,
            output  cUpdate ).

        run update in hPortType ( 
            input   cUpdate,
            output  cSaveResponse ) {slib/err_no-error}.

        run SaveResponseRead.p (
            output  dataset dsSaveResponse by-reference,
            input   cSaveResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doUpdate */

procedure doUpsert:

    define input    param phConn                as handle no-undo.
    define input    param pcSObjectType         as char no-undo.
    define input    param pcExternalIDFieldName as char no-undo.
    define input    param phSObject             as handle no-undo.
    define output   param dataset for dsUpsertResponse.

    define var hPortType        as handle no-undo.
    define var hSOAPHeader      as handle no-undo.
    define var cSessionID       as char no-undo.
    define var iBatchSize       as int no-undo.
    define var lUpdateMRU       as log no-undo.

    define var cUpsert          as longchar no-undo.
    define var cUpsertResponse  as longchar no-undo.

    dataset dsUpsertResponse:empty-dataset( ).

    {slib/err_try}:

        assign
            hPortType   = dynamic-function( "sfdc_getPortType"  in phConn )
            cSessionID  = dynamic-function( "sfdc_getSessionID" in phConn )
            lUpdateMRU  = dynamic-function( "sfdc_getUpdateMRU" in phConn ) {slib/err_no-error}.

        create soap-header hSOAPHeader.

        run sfdc_setSOAPHeader in phConn ( hSOAPHeader ).
        run appendSessionHeader( hSOAPHeader, cSessionID ).

        if iBatchSize <> ? then
        run appendQueryOptions( hSOAPHeader, iBatchSize ).

        if lUpdateMRU <> ? then
        run appendMRUHeader( hSOAPHeader, lUpdateMRU ).

        dataset dsUpsert:empty-dataset( ).

        create ttUpsert.
        assign
            ttUpsert.tsObjectType           = pcSObjectType
            ttUpsert.texternalIdFieldName   = pcExternalIDFieldName.

        run UpsertWrite.p (
            input   dataset dsUpsert by-reference,
            input   phSObject,
            output  cUpsert ).

        run upsert in hPortType ( 
            input   cUpsert,
            output  cUpsertResponse ) {slib/err_no-error}.

        run UpsertResponseRead.p (
            output  dataset dsUpsertResponse by-reference,
            input   cUpsertResponse ).

    {slib/err_catch}:

        delete object hSOAPHeader no-error.

        {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* doUpsert */



procedure appendAssignmentRuleHeader private:

    define input param phSOAPHeader         as handle no-undo.
    define input param pcAssignmentRuleID   as char no-undo.
    define input param plUseDefaultRule     as log no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:AssignmentRuleHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:assignmentRuleId", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = pcAssignmentRuleID.

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:useDefaultRule", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( plUseDefaultRule, "true/false" ).

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendAssignmentRuleHeader */

procedure appendEmailHeader private:

    define input param phSOAPHeader                 as handle no-undo.
    define input param plTriggerAutoResponseEmail   as log no-undo.
    define input param plTriggerOtherEmail          as log no-undo.
    define input param plTriggerUserEmail           as log no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:EmailHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:triggerAutoResponseEmail", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( plTriggerAutoResponseEmail ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:triggerOtherEmail", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( plTriggerOtherEmail ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:triggerUserEmail", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( plTriggerUserEmail ).

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendEmailHeader */ 

procedure appendMRUHeader private:

    define input param phSOAPHeader as handle no-undo.
    define input param plUpdateMRU  as log no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:MruHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:updateMru", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( plUpdateMRU, "true/false" ).

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendMRUHeader */

procedure appendLoginScopeHeader private:

    define input param phSOAPHeader     as handle no-undo.
    define input param pcOrganizationID as char no-undo.
    define input param pcPortalId       as char no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:LoginScopeHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:organizationId", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = pcOrganizationID.

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:portalId", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = pcPortalID.

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendLoginScopeHeader */

procedure appendQueryOptions private:

    define input param phSOAPHeader as handle no-undo.
    define input param piBatchSize  as int no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:QueryOptions", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:batchSize", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = string( piBatchSize ).

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendQueryOptions */

procedure appendSessionHeader private:

    define input param phSOAPHeader as handle no-undo.
    define input param pcSessionID  as char no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:SessionHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:sessionId", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = pcSessionID.

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendSessionHeader */

procedure appendUserTerritoryDeleteHeader private:

    define input param phSOAPHeader         as handle no-undo.
    define input param pcTransferToUserID   as char no-undo.

    define var hSOAPEntry   as handle no-undo.
    define var hDoc         as handle no-undo.
    define var hRoot        as handle no-undo.
    define var hElement     as handle no-undo.
    define var hValue       as handle no-undo.

    create soap-header-entryref hSOAPEntry.
    phSOAPHeader:add-header-entry( hSOAPEntry ).

    create x-document hDoc.
    create x-noderef hRoot.
    create x-noderef hElement.
    create x-noderef hValue.

    hDoc:create-node-namespace( hRoot, {&sfdc_xNsSForce}, "sfdc:UserTerritoryDeleteHeader", "element" ).
    hDoc:append-child( hRoot ).

    hRoot:set-attribute( "xmlns:sfdc", {&sfdc_xNsSForce} ).

    hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce}, "sfdc:transferToUserId", "element" ).
    hDoc:create-node( hValue, ?, "text" ).

    hRoot:append-child( hElement ).
    hElement:append-child( hValue ).

    hValue:node-value = pcTransferToUserID.

    hSOAPEntry:set-node( hRoot ).

    delete object hSOAPEntry no-error.
    delete object hDoc no-error.
    delete object hRoot no-error.
    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* appendUserTerritoryDeleteHeader */



procedure sfdc_readDSBuffer /* private */:

    define input param phBuffer as handle no-undo.
    define input param phParent as handle no-undo.

    define var hElement as handle no-undo.
    define var hValue   as handle no-undo.
    define var hField   as handle no-undo.
    define var i        as int no-undo.

    create x-noderef hElement.
    create x-noderef hValue.



    do  i = 1 to phParent:num-children:
        phParent:get-child( hElement, i ).

        if  hElement:subtype        = "element"
        and hElement:num-children   = 1 then do:

            hElement:get-child( hValue, 1 ).
            if hValue:subtype = "text" then do:

                hField = phBuffer:buffer-field( "t" + hElement:local-name ) no-error.
                if valid-handle( hField ) then do:

                    case hField:data-type:
    
                        when "date"         then hField:buffer-value = xml_Xml2Date( hValue:node-value ).
                        when "datetime"     then hField:buffer-value = xml_Xml2Datetime( hValue:node-value ).
                        when "datetime-tz"  then hField:buffer-value = xml_Xml2DatetimeTz( hValue:node-value ).
    
                        when "decimal" then 
                        hField:buffer-value = xml_Xml2Dec( hValue:node-value ).
    
                        otherwise
                        hField:buffer-value = hValue:node-value.
    
                    end case.

                end. /* valid-handle */

            end. /* subtype = "text" */

        end. /* subtype = "element " */

    end. /* 1 to num-children */

    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* sfdc_readDSBuffer */

procedure sfdc_writeDSBuffer /* private */:

    define input param phBuffer as handle no-undo.
    define input param phParent as handle no-undo.

    define var hDoc     as handle no-undo.
    define var hElement as handle no-undo.
    define var hValue   as handle no-undo.
    define var hField   as handle no-undo.
    define var i        as int no-undo.

    hDoc = phParent:owner-document.

    create x-noderef hElement.
    create x-noderef hValue.

    do  i = 1 to phBuffer:num-fields:

        hField = phBuffer:buffer-field(i).
        if hField:buffer-value <> ? then do:

            if lookup( substr( hField:name, 2 ), "Id,fieldsToNull" ) = 0 then
                 hDoc:create-node-namespace( hElement, {&sfdc_xNsSForce},   "sfdc:" + substr( hField:name, 2 ), "element" ).
            else hDoc:create-node-namespace( hElement, {&sfdc_xNsSObject},  "sfo:"  + substr( hField:name, 2 ), "element" ).

            phParent:append-child( hElement ).

            hDoc:create-node( hValue, ?, "text" ).
            hElement:append-child( hValue ).

            case hField:data-type:

                when "date" or
                when "datetime" or
                when "datetime-tz" then 
                    hValue:node-value = iso-date( hField:buffer-value ).

                when "character" then
                    hValue:node-value = hField:buffer-value.

                when "logical" then
                    hValue:node-value = string( hField:buffer-value, "true/false" ).

                otherwise
                    hValue:node-value = string( hField:buffer-value ).

            end case. /* data-type */

        end. /* buffer-value <> ? */

    end. /* 1 to num-fields */

    delete object hElement no-error.
    delete object hValue no-error.

end procedure. /* sfdc_writeDSBuffer */
