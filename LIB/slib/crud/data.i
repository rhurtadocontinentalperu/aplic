
/**
 * data.i -
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

{slib/crud/service.i}

define var iConfirm as int no-undo init -1.
define var iMsgSeq  as int no-undo init 0.



procedure saveOutputParams:

    define var str  as char no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    buffer-compare
        param_values to output_param_values
        save result in str.

    if str <> "" then do:

        j = num-entries( str ).
        do i = 1 to j:

            create output_param_list.
            assign output_param_list.param_name = entry( i, str ).

        end. /* 1 to j */

        buffer-copy param_values to output_param_values.

    end. /* str <> "" */

end procedure. /* saveOutputParams */

procedure resetOutputParams:

    define var iField   as int no-undo.
    define var hField   as handle no-undo.
    define var iExtent  as int no-undo.

    do iField = 1 to buffer param_values:num-fields:
       hField = buffer param_values:buffer-field( iField ).

        if not can-find(
            first param_list
            where param_list.param_name = hField:name
               or param_list.param_name = hField:serialize-name ) then do:

            if hField:extent = 0 then
                hField:buffer-value(0) = ? no-error.

            else
                do iExtent = 1 to hField:extent:
                   hField:buffer-value( iExtent ) = ? no-error.
                end.

        end. /* not can-find */

    end. /* do iField */

    buffer-copy param_values to output_param_values.

end procedure. /* resetOutputParams */

procedure setParamValues:

    define input param pcParams     as char no-undo.
    define input param pcDefaults   as char no-undo.

    define var cParam   as char no-undo.
    define var hParam   as handle no-undo.
    define var lChange  as log no-undo.
    define var cValue   as char no-undo.
    define var cDelim   as char no-undo.

    define var i        as int no-undo.
    define var j        as int no-undo.

    if pcDefaults = "" then
        return.

    if index( pcDefaults, chr(1) ) > 0 then
        cDelim = chr(1).
    else
        cDelim = ",".

    j = min( num-entries( pcDefaults, cDelim ), num-entries( pcParams ) ).
    do i = 1 to j:

        assign
           cValue = entry( i, pcDefaults, cDelim )
           cParam = entry( i, pcParams )
           hParam = buffer param_values:buffer-field( cParam ) no-error.

        if hParam <> ? then
        case hParam:data-type:

            when "character" then do:
                hParam:buffer-value(0) = cValue {slib/err_no-error}.
            end.

            when "integer" then do:
                hParam:buffer-value(0) = int( cValue ) {slib/err_no-error}.
            end.

            when "decimal" then do:
                hParam:buffer-value(0) = dec( cValue ) {slib/err_no-error}.
            end.

            when "date" then do:
                hParam:buffer-value(0) = date( cValue ) {slib/err_no-error}.
            end.

        end case. /* data-type */

    end. /* 1 to len */

end procedure. /* setParamValues */



/* the temp-table record is not being saved
   if safeChar and getSafeChar are in the same query-prepare statement.
   temp-table replaced with char extent.

define temp-table ttSafeChar no-undo

    field iCharIndex    as int
    field cValue        as char

    index iCharIndex is primary unique
          iCharIndex.
*/

define var cCharValue as char extent 100.
define var iCharIndex as int no-undo.

function safeChar returns char ( pcValue as char ):

    /* define buffer ttSafeChar for ttSafeChar. */

    iCharIndex = iCharIndex + 1.
    cCharValue[ iCharIndex ] = pcValue.

    /*
    create ttSafeChar.
    assign
        ttSafeChar.iCharIndex   = iCharIndex
        ttSafeChar.cValue       = pcValue.
    */

    return "dynamic-function('getSafeChar', " + string( iCharIndex ) + ")".

end function. /* safeChar */

function getSafeChar returns char ( piCharIndex as int ):

    /*
    define buffer ttSafeChar for ttSafeChar.

    find first ttSafeChar
         where ttSafeChar.iCharIndex = piCharIndex
         no-error.

    return ttSafeChar.cValue.
    */

    return cCharValue[ piCharIndex ].

end function. /* getSafeChar */

function hasCondition returns log ( pcFieldName as char ):

    define buffer param_list for param_list.

    return can-find(
        first param_list
        where param_list.param_name = pcFieldName ).

end function. /* hasCondition */



procedure prompt:

    define input param pcMsgType    as char no-undo.
    define input param pcMsgCode    as char no-undo.
    define input param pcMsgParams  as char no-undo.
    define input param pcMsgText    as char no-undo.
    define input param pcParams     as char no-undo.
    define input param pcDefaults   as char no-undo.

    define var ok   as log no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    assign
        ok  = true
        j   = num-entries( pcParams ).

    do i = 1 to j:

        if not can-find(
            first param_list
            where param_list.param_name = entry( i, pcParams ) ) then do:

            ok = false.
            leave.

        end. /* not can-find */

    end. /* 1 to j */

    if ok then
        return.

    assign
        output_header.content_type  = "prompt"
        output_header.prompt_params = pcParams.

    empty temp-table msg_list.

    create msg_list.
    assign
        msg_list.msg_seq    = 1
        msg_list.msg_type   = pcMsgType
        msg_list.msg_code   = pcMsgCode
        msg_list.msg_params = pcMsgParams
        msg_list.msg_text   = pcMsgText.

    run setParamValues( pcParams, pcDefaults ).

    {slib/err_quit}.

end procedure. /* prompt */

procedure promptAgain:

    define input param pcParams     as char no-undo.
    define input param pcDefaults   as char no-undo.

    assign
        output_header.content_type  = "prompt-again"
        output_header.prompt_params = pcParams.

    run setParamValues( pcParams, pcDefaults ).

    {slib/err_quit}.

end procedure. /* promptAgain */

procedure promptError:

    define input param pcMsgType    as char no-undo.
    define input param pcMsgCode    as char no-undo.
    define input param pcMsgParams  as char no-undo.
    define input param pcMsgText    as char no-undo.

    assign
        output_header.content_type = "prompt-error".

    empty temp-table msg_list.

    create msg_list.
    assign
        msg_list.msg_seq    = 1
        msg_list.msg_type   = "error"
        msg_list.msg_code   = pcMsgCode
        msg_list.msg_params = pcMsgParams
        msg_list.msg_text   = pcMsgText.

    {slib/err_quit}.

end procedure. /* promptError */

function confirm return logical ( 
    input pcMsgType     as char,
    input pcMsgCode     as char,
    input pcMsgParams   as char,
    input pcMsgText     as char,
    input plDefault     as log ):

    iConfirm = iConfirm + 1.

    find first confirm_list
         where confirm_list.confirm_num = iConfirm
         no-error.

    if avail confirm_list then
      return confirm_list.confirm_value.

    assign
        output_header.content_type      = "confirm"
        output_header.confirm_num       = iConfirm
        output_header.confirm_default   = plDefault.

    empty temp-table msg_list.

    create msg_list.
    assign
        msg_list.msg_seq    = 1
        msg_list.msg_type   = pcMsgType
        msg_list.msg_code   = pcMsgCode
        msg_list.msg_params = pcMsgParams
        msg_list.msg_text   = pcMsgText.

    {slib/err_quit}.

end function. /* confirm */

procedure promptMsg:

    define input param pcMsgType    as char no-undo.
    define input param pcMsgCode    as char no-undo.
    define input param pcMsgParams  as char no-undo.
    define input param pcMsgText    as char no-undo.

    iConfirm = iConfirm + 1.

    find first confirm_list
         where confirm_list.confirm_num = iConfirm
         no-error.

    if avail confirm_list then
        return.

    assign
        output_header.content_type = "prompt-message".

    empty temp-table msg_list.

    create msg_list.
    assign
        msg_list.msg_seq    = 1
        msg_list.msg_type   = pcMsgType
        msg_list.msg_code   = pcMsgCode
        msg_list.msg_params = pcMsgParams
        msg_list.msg_text   = pcMsgText.

    {slib/err_quit}.

end procedure. /* promptMsg */

procedure msg:

    define input param pcMsgType    as char no-undo.
    define input param pcMsgCode    as char no-undo.
    define input param pcMsgParams  as char no-undo.
    define input param pcMsgText    as char no-undo.

    iMsgSeq = iMsgSeq + 1.

    create msg_list.
    assign
        msg_list.msg_seq    = iMsgSeq
        msg_list.msg_type   = pcMsgType
        msg_list.msg_code   = pcMsgCode
        msg_list.msg_params = pcMsgParams
        msg_list.msg_text   = pcMsgText.

end procedure. /* msg */

