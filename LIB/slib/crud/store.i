
/**
 * store.i -
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
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

{slib/crud/data.i}

&if {&audit} &then

define temp-table ttAudit no-undo

    {&fields}.

&endif



define var hQuery as handle no-undo.

&if {&batched} &then

define var row_seq as int no-undo.
define var row_cnt as int no-undo.

function openQuery  returns handle forward.
function bufferCopy returns log ( buffer data for data ) forward.

&endif

&if {&updateable} &then
function validateFields returns log ( buffer change for change ) forward.
&endif



procedure processRequest:

    find first input_header no-error.
    find first param_values no-error.

&if {&updateable} &then

    if input_header.service_operation = "update" then
        find change no-error. /* only works if there is one change record. used for prompts */

&endif

&if {&batched} &then

    if phInputParam <> ? or phOutputParam <> ? then do:

        if input_header.batch_size = 0 or input_header.batch_size = ? then
           input_header.batch_size = 1000000.

    end. /* phInputParam <> ? */

    else do:

        if input_header.batch_size = 0 or input_header.batch_size = ? then
           input_header.batch_size = 100.

    end. /* else */

    if input_header.batch_size < 10 then
       input_header.batch_size = 10.

&endif

    if not avail param_values then
    create param_values.

    create output_header.
    assign output_header.content_type = "".

    create output_param_values.
    run resetOutputParams.

    do on quit undo, leave:

    &if {&batched} &then

        case input_header.service_operation:

        &if {&updateable} &then
            when "update"               then run processTransaction.
        &endif

            when "openquery"            then run processOpenQuery.
            when "repositiontorowid"    then run processRepositionToRowid.
            when "find"                 then run processFind.
            when "end"                  then run processEnd.
            when "offendtop"            then run processOffEndTop.
            when "offendbottom"         then run processOffEndBottom.
            otherwise                        run processCustom.

        end case. /* service_operation */

    &else /* batched */

        case input_header.service_operation:

            when "openquery"            then run processFillData.
            otherwise                        run processCustom.

        end case. /* service_operation */

    &endif /* else */

    end. /* on quit */

    run err_throwLast.

    err_catchQuit().

    run saveOutputParams.

end procedure. /* processRequest */



&if {&updateable} &then

procedure processTransaction:

    define var cTransErrorCode      as char no-undo.
    define var cTransErrorParams    as char no-undo.
    define var cTransErrorMsg       as char no-undo.

    define var cRecordErrorCode     as char no-undo.
    define var cRecordErrorParams   as char no-undo.
    define var cRecordErrorMsg      as char no-undo.

    define var cErrorCode   as char no-undo.
    define var cErrorParams as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cStackTrace  as char no-undo.

    define var str          as char no-undo.
    define var ok           as log no-undo.

    run beforeTrans in this-procedure no-error.

    assign
        output_header.content_type = "update".

    assign
        cTransErrorCode     = ""
        cTransErrorParams   = ""
        cTransErrorMsg      = "".

    str = dynamic-function( "validateTrans" ) no-error.
    if str <> ? and str <> "" then do:

        if cTransErrorCode = "" then
        assign
            cTransErrorCode     = "validate_error"
            cTransErrorParams   = str
            cTransErrorMsg      = str.

        else
        assign
            cTransErrorCode     = cTransErrorCode   + chr(1) + "validate_error"
            cTransErrorParams   = cTransErrorParams + chr(1) + str
            cTransErrorMsg      = cTransErrorMsg    + chr(1) + str.

    end. /* str <> ? */

    do transaction:

        {slib/err_try}:

            run beginTrans in this-procedure no-error.

        {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

            if cErrorCode <> ? and cErrorCode <> "" then do:

                if cTransErrorCode = "" then
                assign
                    cTransErrorCode     = cErrorCode
                    cTransErrorParams   = cErrorParams
                    cTransErrorMsg      = cErrorMsg.

                else
                assign
                    cTransErrorCode     = cTransErrorCode   + chr(1) + cErrorCode
                    cTransErrorParams   = cTransErrorParams + chr(1) + cErrorParams
                    cTransErrorMsg      = cTransErrorMsg    + chr(1) + cErrorMsg.

            end. /* cErrorCode <> ? */

        {slib/err_end}.

        for each  change
            where change.change_type = "c"
               or change.change_type = "u"
               or change.change_type = "d"

            /* if deletes are done first it could prevent unique constraints */
            by ( if change.change_type = "d" then 1 else 99 ):

            assign
                cRecordErrorCode    = ""
                cRecordErrorParams  = ""
                cRecordErrorMsg     = "".

            create data.
            assign
                data.change_id      = change.change_id
                data.change_type    = change.change_type
                data.row_id         = change.row_id.

            case change.change_type:

                when "c" then

                    run processCreate(
                        buffer          change,
                        buffer          data,

                        input-output    cRecordErrorCode,
                        input-output    cRecordErrorParams,
                        input-output    cRecordErrorMsg,

                        input-output    cTransErrorCode,
                        input-output    cTransErrorParams,
                        input-output    cTransErrorMsg ).

                when "u" then

                    run processUpdate(
                        buffer          change,
                        buffer          data,

                        input-output    cRecordErrorCode,
                        input-output    cRecordErrorParams,
                        input-output    cRecordErrorMsg,

                        input-output    cTransErrorCode,
                        input-output    cTransErrorParams,
                        input-output    cTransErrorMsg ).

                when "d" then

                    run processDelete(
                        buffer          change,
                        buffer          data,

                        input-output    cRecordErrorCode,
                        input-output    cRecordErrorParams,
                        input-output    cRecordErrorMsg,

                        input-output    cTransErrorCode,
                        input-output    cTransErrorParams,
                        input-output    cTransErrorMsg ).

            end case. /* change_type */

            if cRecordErrorCode <> "" and cTransErrorCode = "" then
            assign
                cTransErrorCode     = "trans_failed"
                cTransErrorParams   = ""
                cTransErrorMsg      = "".

            if cRecordErrorCode <> "" then
            assign
                data.error_code     = cRecordErrorCode
                data.error_params   = cRecordErrorParams
                data.error_msg      = cRecordErrorMsg.

        end. /* for each change */

        {slib/err_try}:

            run endTrans in this-procedure no-error.

        {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

            if cErrorCode <> ? and cErrorCode <> "" then do:

                if cTransErrorCode = "" then
                assign
                    cTransErrorCode     = cErrorCode
                    cTransErrorParams   = cErrorParams
                    cTransErrorMsg      = cErrorMsg.

                else
                assign
                    cTransErrorCode     = cTransErrorCode   + chr(1) + cErrorCode
                    cTransErrorParams   = cTransErrorParams + chr(1) + cErrorParams
                    cTransErrorMsg      = cTransErrorMsg    + chr(1) + cErrorMsg.

            end. /* cErrorCode <> ? */

        {slib/err_end}.

        if cTransErrorCode <> "" then do:

            assign
                output_header.error_code    = cTransErrorCode
                output_header.error_params  = cTransErrorParams
                output_header.error_msg     = cTransErrorMsg.

            undo, leave.

        end. /* cTransErrorCode <> "" */

    end. /* do transaction */

    run afterTrans in this-procedure no-error.

end procedure. /* processTransaction */

procedure processCreate:

    define              param buffer change         for change.
    define              param buffer data           for data.

    define input-output param pcRecordErrorCode     as char no-undo.
    define input-output param pcRecordErrorParams   as char no-undo.
    define input-output param pcRecordErrorMsg      as char no-undo.

    define input-output param pcTransErrorCode      as char no-undo.
    define input-output param pcTransErrorParams    as char no-undo.
    define input-output param pcTransErrorMsg       as char no-undo.

    define var cErrorCode   as char no-undo.
    define var cErrorParams as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cStackTrace  as char no-undo.

    define var lBefore      as log no-undo.
    define var lFound       as log no-undo.
    define var lAfter       as log no-undo.
    define var cAfterChange as longchar no-undo.

    define var rRowids      as rowid extent 7 no-undo.
    define var hndl         as handle no-undo.
    define var str          as char no-undo.
    define var ok           as log no-undo.
    define var i            as int no-undo.

    empty temp-table param_list.
    hQuery = openQuery() {slib/err_no-error}.

    str = dynamic-function( "validateRecord", buffer change ) no-error.
    if str <> ? and str <> "" then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "validate_error"
            pcRecordErrorParams = str
            pcRecordErrorMsg    = str.

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "validate_error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + str.

        return.

    end. /* str <> ? */

    str = dynamic-function( "validateCreate", buffer change ) no-error.
    if str <> ? and str <> "" then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "validate_error"
            pcRecordErrorParams = str
            pcRecordErrorMsg    = str.

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "validate_error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + str.

        return.

    end. /* str <> ? */

    ok = validateFields( buffer change ).
    if not ok and pcRecordErrorCode = "" then
    assign
        pcRecordErrorCode   = "create_failed"
        pcRecordErrorParams = ""
        pcRecordErrorMsg    = "".

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

    do i = 1 to hQuery:num-buffers:

        hndl = hQuery:get-buffer-handle(i).
        hndl:buffer-release().

    end. /* 1 to num-buffers */

    {slib/err_try}:

        run createRecord in this-procedure ( buffer change ) {slib/err_no-error}.

    {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

        if cErrorCode <> ? and cErrorCode <> "" then do:

            if pcRecordErrorCode = "" then
            assign
                pcRecordErrorCode   = cErrorCode
                pcRecordErrorParams = cErrorParams
                pcRecordErrorMsg    = cErrorMsg.

            else
            assign
                pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + cErrorCode
                pcRecordErrorParams = pcRecordErrorParams   + chr(1) + cErrorParams
                pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + cErrorMsg.

        end. /* str */

    {slib/err_end}.

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

    assign
        lBefore = no
        lFound  = no
        lAfter  = no

        rRowids = ?.

    do i = 1 to hQuery:num-buffers:

        hndl = hQuery:get-buffer-handle(i).
        if hndl:available then
        assign
            rRowids[i]  = hndl:rowid
            lFound      = yes.

        else do:
            if lFound then
                lAfter = yes.
            else
                lBefore = yes.
        end.

    end. /* 1 to num-buffers */

    if not lFound then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "record_not_found"
            pcRecordErrorParams = ""
            pcRecordErrorMsg    = "".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "record_not_found"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

        return.

    end. /* not lFound */

    ok = bufferCopy( buffer data ) {slib/err_no-error}.
    if ok = no then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "error"
            pcRecordErrorParams = "bufferCopy() failed."
            pcRecordErrorMsg    = "bufferCopy() failed.".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + "bufferCopy() failed."
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "bufferCopy() failed.".

        return.

    end. /* ok = no */

    if ( lBefore or lAfter )
    and can-find( first index_field ) then do:

        str = "".

        empty temp-table param_list.

        for each index_field:

            str = str + ( if str <> "" then "," else "" ) + index_field.field_name.

            find first param_list
                 where param_list.param_name = index_field.field_name
                 no-error.

            if not avail param_list then do:

                create param_list.
                assign param_list.param_name = index_field.field_name.

            end. /* not avail param_list */

            assign
                param_list.param_operator = "=".

        end. /* for each index_field */

        buffer param_values:buffer-copy( buffer data:handle, str ).
        hQuery = openQuery() {slib/err_no-error}.

        /***
        if lBefore and not lAfter then do:
        ***/

            ok = hQuery:get-first( no-lock ).
            if not ok then do:

                if pcRecordErrorCode = "" then
                assign
                    pcRecordErrorCode   = "record_not_found"
                    pcRecordErrorParams = ""
                    pcRecordErrorMsg    = "".

                else
                assign
                    pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "record_not_found"
                    pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
                    pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

                return.

            end. /* not ok */

        /***
        end. /* lBefore */

        /* will not work with outer joins */
        else do:

            repeat:

                ok = hQuery:get-next( no-lock ).
                if not ok then do:

                    if pcRecordErrorCode = "" then
                    assign
                        pcRecordErrorCode   = "record_not_found"
                        pcRecordErrorParams = ""
                        pcRecordErrorMsg    = "".

                    else
                    assign
                        pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "record_not_found"
                        pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
                        pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

                    return.

                end. /* not ok */

                ok = yes.

                do i = 1 to hQuery:num-buffers:

                    if rRowids[i] <> ? then do:

                        hndl = hQuery:get-buffer-handle(i).
                        if hndl:available and hndl:rowid <> rRowids[i] then do:

                            ok = no.
                            leave.

                        end. /* rowid <> rRowids */

                    end. /* rRowids <> ? */

                end. /* 1 to num-buffers */

                if ok then
                    leave.

            end. /* repeat */

        end. /* else */
        ***/

        do i = 1 to hQuery:num-buffers:

            hndl = hQuery:get-buffer-handle(i).

            if rRowids[i] = ?  and hndl:available then
               rRowids[i] = hndl:rowid.

        end. /* 1 to num-buffers */

    end. /* lBefore or lAfter */

    assign
        data.row_id = rRowids.

&if {&audit} &then

    empty temp-table ttAudit.

    create ttAudit.
    buffer-copy data to ttAudit.

    buffer ttAudit:serialize-row( "json", "longchar", cAfterChange, no, "utf-8", no, yes ).

    define var iTransId as int no-undo.
    iTransId = ?.

    do i = 1 to hQuery:num-buffers:

        hndl = hQuery:get-buffer-handle(i).
        if hndl:available and hndl:locked then do:

            iTransId = dbtaskid( hndl:dbname ).
            if iTransId <> ? then
                leave.

        end. /* hndl:available */

    end. /* 1 to num-buffers */

    create crud_audit.
    assign
        crud_audit.service_name     = gcCrudServiceName
        crud_audit.audit_datetime   = now
        crud_audit.audit_operation  = "c"
        crud_audit.username         = gcCrudUsername
        crud_audit.ip_address       = gcCrudIpAddress
        crud_audit.trans_id         = iTransId
        crud_audit.esign            = input_header.esign
        crud_audit.changed_fields   = ?
        crud_audit.before_change    = ?
        crud_audit.after_change     = cAfterChange.

&endif /* audit */

end procedure. /* processCreate */

procedure processUpdate:

    define              param buffer change         for change.
    define              param buffer data           for data.

    define input-output param pcRecordErrorCode     as char no-undo.
    define input-output param pcRecordErrorParams   as char no-undo.
    define input-output param pcRecordErrorMsg      as char no-undo.

    define input-output param pcTransErrorCode      as char no-undo.
    define input-output param pcTransErrorParams    as char no-undo.
    define input-output param pcTransErrorMsg       as char no-undo.

    define buffer bAudit1       for ttAudit.
    define buffer bAudit2       for ttAudit.

    define var cErrorCode       as char no-undo.
    define var cErrorParams     as char no-undo.
    define var cErrorMsg        as char no-undo.
    define var cStackTrace      as char no-undo.

    define var cChangedFields   as char no-undo.
    define var cBeforeChange    as longchar no-undo.
    define var cAfterChange     as longchar no-undo.

    define var hndl             as handle no-undo.
    define var str              as char no-undo.
    define var ok               as log no-undo.
    define var i                as int no-undo.

    run repositionToRowidBeforeUpdate(
        buffer          change,
        buffer          data,

        input-output    pcRecordErrorCode,
        input-output    pcRecordErrorParams,
        input-output    pcRecordErrorMsg ).

    if pcRecordErrorCode <> "" then
        return.

    str = dynamic-function( "validateRecord", buffer change ) no-error.
    if str <> ? and str <> "" then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "validate_error"
            pcRecordErrorParams = str
            pcRecordErrorMsg    = str.

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "validate_error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + str.

    end. /* str <> ? */

    str = dynamic-function( "validateUpdate", buffer change ) no-error.
    if str <> ? and str <> "" then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "validate_error"
            pcRecordErrorParams = str
            pcRecordErrorMsg    = str.

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "validate_error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + str.

    end. /* str <> ? */

    ok = validateFields( buffer change ).
    if not ok and pcRecordErrorCode = "" then
    assign
        pcRecordErrorCode   = "update_failed"
        pcRecordErrorParams = ""
        pcRecordErrorMsg    = "".

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

    {slib/err_try}:

        run updateRecord in this-procedure ( buffer change ) {slib/err_no-error}.

    {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

        if cErrorCode <> ? and cErrorCode <> "" then do:

            if pcRecordErrorCode = "" then
            assign
                pcRecordErrorCode   = cErrorCode
                pcRecordErrorParams = cErrorParams
                pcRecordErrorMsg    = cErrorMsg.

            else
            assign
                pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + cErrorCode
                pcRecordErrorParams = pcRecordErrorParams   + chr(1) + cErrorParams
                pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + cErrorMsg.

        end. /* str */

    {slib/err_end}.

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

&if {&audit} &then

    empty temp-table ttAudit.

    create bAudit1.
    buffer-copy data to bAudit1.

&endif /* audit */

    ok = bufferCopy( buffer data ) {slib/err_no-error}.
    if ok = no then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "error"
            pcRecordErrorParams = "bufferCopy() failed."
            pcRecordErrorMsg    = "bufferCopy() failed.".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + "bufferCopy() failed."
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "bufferCopy() failed.".

        return.

    end. /* ok = no */

&if {&audit} &then

    create bAudit2.
    buffer-copy data to bAudit2.

    buffer-compare
        bAudit1 to bAudit2
        save result in cChangedFields.

    buffer bAudit1:serialize-row( "json", "longchar", cBeforeChange, no, "utf-8", no, yes ).
    buffer bAudit2:serialize-row( "json", "longchar", cAfterChange, no, "utf-8", no, yes ).

    define var iTransId as int no-undo.
    iTransId = ?.

    do i = 1 to hQuery:num-buffers:

        hndl = hQuery:get-buffer-handle(i).
        if hndl:available and hndl:locked then do:

            iTransId = dbtaskid( hndl:dbname ).
            if iTransId <> ? then
                leave.

        end. /* hndl:available */

    end. /* 1 to num-buffers */

    create crud_audit.
    assign
        crud_audit.service_name     = gcCrudServiceName
        crud_audit.audit_datetime   = now
        crud_audit.audit_operation  = "u"
        crud_audit.username         = gcCrudUsername
        crud_audit.ip_address       = gcCrudIpAddress
        crud_audit.trans_id         = iTransId
        crud_audit.esign            = input_header.esign
        crud_audit.changed_fields   = cChangedFields
        crud_audit.before_change    = cBeforeChange
        crud_audit.after_change     = cAfterChange.

&endif /* audit */

end procedure. /* processUpdate */

procedure processDelete:

    define              param buffer change         for change.
    define              param buffer data           for data.

    define input-output param pcRecordErrorCode     as char no-undo.
    define input-output param pcRecordErrorParams   as char no-undo.
    define input-output param pcRecordErrorMsg      as char no-undo.

    define input-output param pcTransErrorCode      as char no-undo.
    define input-output param pcTransErrorParams    as char no-undo.
    define input-output param pcTransErrorMsg       as char no-undo.

    define var cErrorCode       as char no-undo.
    define var cErrorParams     as char no-undo.
    define var cErrorMsg        as char no-undo.
    define var cStackTrace      as char no-undo.

    define var cBeforeChange    as longchar no-undo.
    define var hndl             as handle no-undo.
    define var str              as char no-undo.
    define var i                as int no-undo.

    run repositionToRowidBeforeUpdate(
        buffer          change,
        buffer          data,

        input-output    pcRecordErrorCode,
        input-output    pcRecordErrorParams,
        input-output    pcRecordErrorMsg ).

    if pcRecordErrorCode <> "" then
        return.

    str = dynamic-function( "validateDelete", buffer change ) no-error.
    if str <> ? and str <> "" then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "validate_error"
            pcRecordErrorParams = str
            pcRecordErrorMsg    = str.

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "validate_error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + str.

    end. /* str <> ? */

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

    {slib/err_try}:

        run deleteRecord in this-procedure ( buffer change ) {slib/err_no-error}.

    {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

        if cErrorCode <> ? and cErrorCode <> "" then do:

            if pcRecordErrorCode = "" then
            assign
                pcRecordErrorCode   = cErrorCode
                pcRecordErrorParams = cErrorParams
                pcRecordErrorMsg    = cErrorMsg.

            else
            assign
                pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + cErrorCode
                pcRecordErrorParams = pcRecordErrorParams   + chr(1) + cErrorParams
                pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + cErrorMsg.

        end. /* str */

    {slib/err_end}.

    if pcRecordErrorCode <> "" or pcTransErrorCode <> "" then
        return.

    hQuery:query-open() {slib/err_no-error}.
    hQuery:reposition-to-rowid( change.row_id ) no-error.

    if error-status:num-messages = 0 then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "delete_failed"
            pcRecordErrorParams = ""
            pcRecordErrorMsg    = "".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "delete_failed"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

        return.

    end. /* num-messages > 0 */

&if {&audit} &then

    empty temp-table ttAudit.

    create ttAudit.
    buffer-copy data to ttAudit.

    buffer ttAudit:serialize-row( "json", "longchar", cBeforeChange, no, "utf-8", no, yes ).

    define var iTransId as int no-undo.
    iTransId = ?.

    do i = 1 to hQuery:num-buffers:

        hndl = hQuery:get-buffer-handle(i).
        if hndl:available and hndl:locked then do:

            iTransId = dbtaskid( hndl:dbname ).
            if iTransId <> ? then
                leave.

        end. /* hndl:available */

    end. /* 1 to num-buffers */

    create crud_audit.
    assign
        crud_audit.service_name     = gcCrudServiceName
        crud_audit.audit_datetime   = now
        crud_audit.audit_operation  = "d"
        crud_audit.username         = gcCrudUsername
        crud_audit.ip_address       = gcCrudIpAddress
        crud_audit.trans_id         = iTransId
        crud_audit.esign            = input_header.esign
        crud_audit.changed_fields   = ?
        crud_audit.before_change    = cBeforeChange
        crud_audit.after_change     = ?.

&endif /* audit */

end procedure. /* processDelete */



procedure repositionToRowidBeforeUpdate:

    define              param buffer change         for change.
    define              param buffer data           for data.

    define input-output param pcRecordErrorCode     as char no-undo.
    define input-output param pcRecordErrorParams   as char no-undo.
    define input-output param pcRecordErrorMsg      as char no-undo.

&if {&optimistic_locking} &then
    define buffer bBi for change.
&endif

    define var hndl as handle no-undo.
    define var str  as char no-undo.
    define var ok   as log no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    empty temp-table param_list.

    hQuery = openQuery() {slib/err_no-error}.
    run assertIndexedReposition.

    do i = 1 to 3:

        if i <> 1 then
            pause 1.

        hQuery:reposition-to-rowid( change.row_id ) no-error.
        if error-status:num-messages > 0 then do:

            if pcRecordErrorCode = "" then
            assign
                pcRecordErrorCode   = "record_not_found"
                pcRecordErrorParams = ""
                pcRecordErrorMsg    = "".

            else
            assign
                pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "record_not_found"
                pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
                pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

            return.

        end. /* num-messages > 0 */

        hQuery:get-next( ?, no-wait ).

        ok = yes.
        do j = 1 to hQuery:num-buffers:

            hndl = hQuery:get-buffer-handle(i).
            if hndl:locked then do:

                ok = no.
                leave.

            end. /* locked */

        end. /* 1 to num-buffers */

        if ok then
            leave.

    end. /* 1 to 3 */

    if not ok then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "record_locked"
            pcRecordErrorParams = ""
            pcRecordErrorMsg    = "".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "record_locked"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + ""
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

        return.

    end. /* locked */

&if {&optimistic_locking} or {&audit} &then

    ok = bufferCopy( buffer data ) {slib/err_no-error}.
    if ok = no then do:

        if pcRecordErrorCode = "" then
        assign
            pcRecordErrorCode   = "error"
            pcRecordErrorParams = "bufferCopy() failed."
            pcRecordErrorMsg    = "bufferCopy() failed.".

        else
        assign
            pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "error"
            pcRecordErrorParams = pcRecordErrorParams   + chr(1) + "bufferCopy() failed."
            pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "bufferCopy() failed.".

        return.

    end. /* ok = no */

&endif /* optimistic locking or auditing */

&if {&optimistic_locking} &then

    find first bBi
         where bBi.change_id    = change.change_id
           and bBi.change_type  = "b"
         no-error.

    if avail bBi then do:

        buffer-compare
            bBi except change_id change_type row_id to data
            save result in str.

        if str <> "" then do:

            if pcRecordErrorCode = "" then
            assign
                pcRecordErrorCode   = "optimistic_lock"
                pcRecordErrorParams = str
                pcRecordErrorMsg    = "".

            else
            assign
                pcRecordErrorCode   = pcRecordErrorCode     + chr(1) + "optimistic_lock"
                pcRecordErrorParams = pcRecordErrorParams   + chr(1) + str
                pcRecordErrorMsg    = pcRecordErrorMsg      + chr(1) + "".

            return.

        end. /* str <> "" */

    end. /* avail bBi */

&endif /* optimistic_locking */

end procedure. /* repositionToRowidBeforeUpdate */

function validateFields returns log ( buffer change for change ):

    define var hndl as handle no-undo.
    define var str  as char no-undo.
    define var ok   as log no-undo.
    define var i    as int no-undo.

    ok = yes.

    do i = 1 to buffer change:num-fields:

        hndl = buffer change:buffer-field(i).

        if hndl:name = "change_id"
        or hndl:name = "change_type"
        or hndl:name = "row_id" then
            next.

        str = dynamic-function( "validate" + hndl:name, buffer change ) no-error.
        if str <> ? and str <> "" then do:

            find first field_error
                 where field_error.change_id    = change.change_id
                   and field_error.field_name   = hndl:name
                 use-index change_id_field
                 no-error.

            if not avail field_error then do:

                create field_error.
                assign
                    field_error.change_id       = change.change_id
                    field_error.field_name      = hndl:name

                    field_error.error_code      = "validate_error"
                    field_error.error_params    = str
                    field_error.error_msg       = str.

            end. /* not avail field_error */

            else do:

                assign
                    field_error.error_code      = field_error.error_code    + chr(1) + "validate_error"
                    field_error.error_params    = field_error.error_params  + chr(1) + str
                    field_error.error_msg       = field_error.error_msg     + chr(1) + str.

            end. /* else */

            ok = no.

        end. /* str <> ? */

    end. /* 1 to num-fields */

    return ok.

end function. /* validateFields */



procedure commitChanges:

    temp-table change:copy-temp-table( temp-table data:handle, false, false, true ).

    empty temp-table data.

    run processTransaction.

end procedure. /* commitChanges */

&endif /* updateable */



procedure processCustom:

    define var cErrorCode   as char no-undo.
    define var cErrorParams as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var cStackTrace  as char no-undo.

    {slib/err_try}:

        run value( input_header.service_operation ) in this-procedure {slib/err_no-error}.

    {slib/err_catch cErrorCode cErrorMsg cErrorParams cStackTrace}:

        assign
            output_header.error_code    = cErrorCode
            output_header.error_params  = cErrorParams
            output_header.error_msg     = cErrorMsg.

    {slib/err_end}.

end procedure. /* processCustom */



&if {&batched} &then

procedure processOpenQuery:

    hQuery = openQuery() {slib/err_no-error}.
    hQuery:get-first( no-lock ).

    assign
        output_header.content_type  = "refresh"
        output_header.reached_home  = yes
        output_header.reached_end   = no.

    row_seq = 1.

    run fillBatchDown.

end procedure. /* processOpenQuery */

procedure processFind:

    define var rRowids      as rowid extent 7 no-undo.
    define var iBatchSize   as int no-undo.

    define var cError       as char no-undo.
    define var cErrorMsg    as char no-undo.
    define var hndl         as handle no-undo.
    define var i            as int no-undo.

    {slib/err_try}:

        find last index_field no-error.
        if not avail index_field then
            {slib/err_throw "'match_not_found'"}.

        find first param_list
             where param_list.param_name = index_field.field_name
             no-error.

        if not avail param_list then
            {slib/err_throw "'match_not_found'"}.

        if index_field.field_descend
        then param_list.param_operator = "<=".
        else param_list.param_operator = ">=".

        hQuery = openQuery() {slib/err_no-error}.
        hQuery:get-first( no-lock ).

        repeat while hQuery:query-off-end:

            delete index_field.
            delete param_list.

            find last index_field no-error.
            if not avail index_field then
                {slib/err_throw "'match_not_found'"}.

            find first param_list
                 where param_list.param_name = index_field.field_name
                 no-error.

            if not avail param_list then
                {slib/err_throw "'match_not_found'"}.

            if index_field.field_descend
            then param_list.param_operator = "<".
            else param_list.param_operator = ">".

            hQuery = openQuery() {slib/err_no-error}.
            hQuery:get-first( no-lock ).

        end. /* repeat */

        for each index_field:

            find first param_list
                 where param_list.param_name = index_field.field_name
                 no-error.

            if avail param_list then
              delete param_list.

            delete index_field.

        end. /* for each index_field */

        do i = 1 to hQuery:num-buffers:

            hndl = hQuery:get-buffer-handle(i).
            rRowids[i] = hndl:rowid.

        end. /* 1 to num-buffers */

        hQuery = openQuery() {slib/err_no-error}.
        run assertIndexedReposition.

        hQuery:reposition-to-rowid( rRowids ).
        hQuery:get-next( no-lock ).

        assign
            output_header.content_type  = "refresh"
            output_header.reached_home  = no
            output_header.reached_end   = no.

        assign
            iBatchSize              = input_header.batch_size
            i                       = truncate( iBatchSize / 2, 0 )

            input_header.batch_size = i
            row_seq                 = i + 1.

        run fillBatchDown.
        i = min( i, row_cnt ).

        hQuery:reposition-to-rowid( rRowids ).
        hQuery:get-prev( no-lock ).

        assign
            input_header.batch_size = iBatchSize - i
            row_seq                 = i.

        run fillBatchUp.

    {slib/err_catch cError}:

        if cError = "match_not_found" then do:

            for each index_field:

                find first param_list
                     where param_list.param_name = index_field.field_name
                     no-error.

                if avail param_list then
                  delete param_list.

                delete index_field.

            end. /* for each index_field */

            run processEnd.

        end. /* match_not_found */

        else
            {slib/err_throw last}.

    {slib/err_end}.

end procedure. /* processFind */

procedure processRepositionToRowid:

    define var iBatchSize   as int no-undo.
    define var i            as int no-undo.

    hQuery = openQuery() {slib/err_no-error}.
    run assertIndexedReposition.

    hQuery:reposition-to-rowid( param_values.row_id ) no-error.
    if error-status:num-messages > 0 then do:

        hQuery:get-first( no-lock ).

        assign
            output_header.content_type  = "refresh"
            output_header.reached_home  = no
            output_header.reached_end   = no

            output_header.error_code    = "failed_to_reposition"
            output_header.error_params  = ""
            output_header.error_msg     = "".

        run fillBatchDown.

        return.

    end. /* error-status */

    hQuery:get-next( no-lock ).

    assign
        output_header.content_type  = "refresh"
        output_header.reached_home  = no
        output_header.reached_end   = no.

    assign
        iBatchSize              = input_header.batch_size
        i                       = truncate( iBatchSize / 2, 0 )

        input_header.batch_size = i
        row_seq                 = i + 1.

    run fillBatchDown.
    i = min( i, row_cnt ).

    hQuery:reposition-to-rowid( param_values.row_id ) no-error.
    hQuery:get-prev( no-lock ).

    assign
        input_header.batch_size = iBatchSize - i
        row_seq                 = i.

    run fillBatchUp.

end procedure. /* processRepositionToRowid */

procedure processEnd:

    hQuery = openQuery() {slib/err_no-error}.
    hQuery:get-last( no-lock ).

    assign
        output_header.content_type  = "refresh"
        output_header.reached_home  = no
        output_header.reached_end   = yes.

    row_seq = input_header.batch_size.

    run fillBatchUp.

end procedure. /* processEnd */

procedure processOffEndTop:

    hQuery = openQuery() {slib/err_no-error}.
    run assertIndexedReposition.

    hQuery:reposition-to-rowid( param_values.row_id ) no-error.
    if error-status:num-messages > 0 then do:

        hQuery:get-first( no-lock ).

        assign
            output_header.content_type  = "refresh"
            output_header.reached_home  = yes
            output_header.reached_end   = no

            output_header.error_code    = "failed_to_reposition"
            output_header.error_params  = ""
            output_header.error_msg     = "".

        run fillBatchDown.

        return.

    end. /* error-status */

    hQuery:get-prev( no-lock ).

    assign
        output_header.content_type  = "offendtop"
        output_header.reached_home  = no.

    row_seq = input_header.batch_size.

    run fillBatchUp.

end procedure. /* processOffEndTop */

procedure processOffEndBottom:

    hQuery = openQuery() {slib/err_no-error}.
    run assertIndexedReposition.

    hQuery:reposition-to-rowid( param_values.row_id ) no-error.
    if error-status:num-messages > 0 then do:

        hQuery:get-first( no-lock ).

        assign
            output_header.content_type  = "refresh"
            output_header.reached_home  = yes
            output_header.reached_end   = no

            output_header.error_code    = "failed_to_reposition"
            output_header.error_params  = ""
            output_header.error_msg     = "".

        run fillBatchDown.

        return.

    end. /* error-status */

    hQuery:get-next( no-lock ).

    assign
        output_header.content_type  = "offendbottom"
        output_header.reached_end   = no.

    row_seq = 1.

    run fillBatchDown.

end procedure. /* processOffEndBottom */



procedure fillBatchDown:

    define var rRowids  as rowid extent 7 no-undo.
    define var hndl     as handle no-undo.
    define var ok       as log no-undo.
    define var i        as int no-undo.

    if hQuery:query-off-end then do:

        output_header.reached_end = yes.
        return.

    end. /* query-off-end */

    row_cnt = 0.
    do while row_cnt < input_header.batch_size:

        rRowids = ?.

        do i = 1 to hQuery:num-buffers:

            hndl = hQuery:get-buffer-handle(i).
            rRowids[i] = hndl:rowid.

        end. /* 1 to num-buffers */

        create data.
        assign
            data.row_seq    = row_seq
            data.row_id     = rRowids.

        ok = bufferCopy( buffer data ) {slib/err_no-error}.
        if ok = no then
            delete data.

        else
        assign
            row_seq = row_seq + 1
            row_cnt = row_cnt + 1.

        hQuery:get-next( no-lock ).

        if hQuery:query-off-end then do:

            output_header.reached_end = yes.
            return.

        end. /* query-off-end */

    end. /* while i <= batch_size */

end procedure. /* fillBatchDown */

procedure fillBatchUp:

    define var rRowids  as rowid extent 7 no-undo.
    define var hndl     as handle no-undo.
    define var ok       as log no-undo.
    define var i        as int no-undo.

    if hQuery:query-off-end then do:

        output_header.reached_home = yes.
        return.

    end. /* query-off-end */

    row_cnt = 0.
    do while row_cnt < input_header.batch_size:

        rRowids = ?.

        do i = 1 to hQuery:num-buffers:

            hndl = hQuery:get-buffer-handle(i).
            rRowids[i] = hndl:rowid.

        end. /* 1 to num-buffers */

        create data.
        assign
            data.row_seq    = row_seq
            data.row_id     = rRowids.

        ok = bufferCopy( buffer data ) {slib/err_no-error}.
        if ok = no then
            delete data.

        else
        assign
            row_seq = row_seq - 1
            row_cnt = row_cnt + 1.

        hQuery:get-prev( no-lock ).

        if hQuery:query-off-end then do:

            output_header.reached_home = yes.
            return.

        end. /* query-off-end */

    end. /* 1 to batch_size */

end procedure. /* fillBatchUp */

procedure assertIndexedReposition:

    if  hQuery:prepare-string <> ?
    and index( hQuery:prepare-string, "indexed-reposition" ) = 0 then

        {slib/err_throw "'crud_indexed_reposition_expected'"}.

end procedure. /* assertIndexedReposition */



&else /* batched */

procedure processFillData:

    assign
        output_header.content_type  = "refresh"
        output_header.reached_home  = yes
        output_header.reached_end   = yes.

    run fillData {slib/err_no-error}.

end procedure. /* processFillData */

&endif /* else */



procedure andCondition:

    define input        param pcConditionField  as char no-undo.
    define input        param pcQueryField      as char no-undo.
    define input-output param pcWhere           as char no-undo.

    define buffer param_list for param_list.

    define var hField       as handle no-undo.
    define var cSafeValue   as char no-undo.

    find first param_list
         where param_list.param_name = pcConditionField
         no-lock no-error.

    if not avail param_list then
        return.

    assign
       hField = ?
       hField = buffer param_values:buffer-field( pcConditionField ) no-error.

    if hField = ? then
        {slib/err_throw "'field_not_found'" pcConditionField}.

    if hField:data-type = "character" then
        cSafeValue = "dynamic-function('getFieldValue', '"
            + string( hField ) + "')".

    else do:

        cSafeValue = string( hField:buffer-value ).
        if cSafeValue = ? then cSafeValue = "?".

    end. /* else */

    pcWhere = pcWhere
        + ( if pcWhere <> "" then " and " else "" )
        + pcQueryField
        + " " + param_list.param_operator + " "
        + cSafeValue.

end procedure. /* andCondition */

function getFieldValue returns char ( pcFieldHndl as char ):

    define var hField as handle no-undo.

    hField = widget-handle( pcFieldHndl ).
    return hField:buffer-value.

end function. /* getFieldValue */

function getConditionOperator returns char ( pcFieldName as char ):

    define buffer param_list for param_list.

    find first param_list
         where param_list.param_name = pcFieldName
         no-error.

    if avail param_list
    then return " " + param_list.param_operator + " ".
    else return " = ".

end function. /* getConditionOperator */
