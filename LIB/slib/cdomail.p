                                            
/**
 * cdomail.p - mail util that builds on windows cdo.
 *
 * developed as a progress version 8 replacement for smtpmail.p that did not have socket support.
 *
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

&global xDefaultMailFrom    "mfgmail@mail.elmoil.co.il"
&global xDefaultMailHub     "mail.elmoil.co.il"
&global xDefaultMailPort     25 /* default smtp mail port */



define input    param pcFrom            as char no-undo.
define input    param pcTo              as char no-undo.
define input    param pcCc              as char no-undo.
define input    param pcSubject         as char no-undo.
define input    param pcTextBody        as char no-undo.
define input    param pcHtmlBody        as char no-undo.
define input    param pcAttachments     as char no-undo.
define output   param plError           as log no-undo.
define output   param pcErrorMsg        as char no-undo.

define var cMailHub         as char no-undo.
define var iMailPort        as int no-undo.
define var iAuthType        as int no-undo.
define var cAuthUserName    as char no-undo.
define var cAuthPassword    as char no-undo.

define var hCdo             as com-handle no-undo.
define var i                as int no-undo.

assign
    plError     = no
    pcErrorMsg  = "".



if pcFrom = "" then
   pcFrom = ?.

if pcFrom = ? then
   pcFrom = {&xDefaultMailFrom}.

if pcCc = "" then
   pcCc = ?.

if pcHtmlBody = "" then
   pcHtmlBody = ?.

if pcTextBody = "" then
   pcTextBody = ?.

if pcHtmlBody <> ? and pcTextBody <> ? then
   pcTextBody = ?.

if pcHtmlBody = ? and pcTextBody = ? then
   pcTextBody = "".

if pcAttachments = "" then
   pcAttachments = ?.

if pcAttachments <> ? then
   pcAttachments = replace( pcAttachments, ",", ";" ).



assign
    cMailHub        = {&xDefaultMailHub}
    iMailPort       = {&xDefaultMailPort}

    iAuthType       = 0
    cAuthUserName   = ""
    cAuthPassword   = "".

/*** mfg/pro defaults ***/

find first code_mstr
     where code_fldname = "email-hub"
       and code_value = ""
     no-lock no-error.

if avail code_mstr then do:

    if num-entries( code_cmmt, ":" ) = 1 then
    assign
        cMailHub    = code_cmmt.

    else
    assign
        cMailHub    =      entry( 1, code_cmmt, ":" )
        iMailPort   = int( entry( 2, code_cmmt, ":" ) ).

end. /* code_mstr */

find first code_mstr
     where code_fldname = "email-auth"
       and code_value = ""
     no-lock no-error.

if avail code_mstr then do:

    if num-entries( code_cmmt ) = 3 then
    assign
        iAuthType       = int( entry( 1, code_cmmt ) )
        cAuthUsername   =      entry( 2, code_cmmt )
        cAuthPassword   =      entry( 3, code_cmmt ).

end. /* avail */

if pcFrom = ? then do:

    find first code_mstr
         where code_fldname = "email-from"
           and code_value = ""
         no-lock no-error.

    if avail code_mstr then
        pcFrom = code_cmmt.

end. /* code_mstr */

/*** mfg/pro defaults ***/



do on quit undo, leave
   on stop undo, leave
   on error undo, leave
   on endkey undo, leave:

    create "CDO.Message" hCdo.
    assign
        hCdo:From       = pcFrom
        hCdo:To         = pcTo
        hCdo:Cc         = pcCc when pcCc <> ?
        hCdo:Subject    = pcSubject
        hCdo:TextBody   = pcTextBody when pcTextBody <> ?
        hCdo:HTMLbody   = pcHtmlBody when pcHtmlBody <> ?.

    if pcAttachments <> ? then do:

        do i = 1 to num-entries( pcAttachments, ";" ):

            hCdo:AddAttachment( entry( i, pcAttachments, ";" ) ).

        end. /* 1 to num-entries */

    end. /* on error */



    hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusing" )        = 2.
    hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserver" )       = cMailHub.
    hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpserverport" )   = iMailPort.

    if iAuthType <> 0 then do:

        hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate")  = iAuthType.
        hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendusername")      = cAuthUsername.
        hCdo:Configuration:Fields:Item( "http://schemas.microsoft.com/cdo/configuration/sendpassword")      = cAuthPassword.

    end. /* iAuthType */

    hCdo:Configuration:Fields:Update( ).
    hCdo:Send( ) no-error.

    if error-status:num-messages > 0 then do:

        do i = 1 to error-status:num-messages:

            pcErrorMsg = pcErrorMsg
                + ( pcErrorMsg <> "" then "~n" else "" )
                + error-status:get-message(1).

        end. /* 1 to num-messages */

        plError = yes.

    end. /* error */

end. /* on error */

release object hCdo.
hCdo = ?.
