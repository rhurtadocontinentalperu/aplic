
/**
 * user.p -
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

{store/user.i}

{slib/crud/store.i}

{slib/slibstr.i}



define query qry

    for crud_user scrolling.

function openQuery returns handle:

    define var cWhere as char no-undo.

    run andCondition( "username",   "crud_user.username",   input-output cWhere ).
    run andCondition( "last_name",  "crud_user.last_name",  input-output cWhere ).
    run andCondition( "first_name", "crud_user.first_name", input-output cWhere ).
    run andCondition( "birth_date", "crud_user.birth_date", input-output cWhere ).

    query qry:query-prepare(
        "for each crud_user " +
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index
              else "" ) + " " +

            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    if  not lookup( "admin", gcCrudUserRoles ) > 0
    and not crud_user.listing_roles = ""
    and not str_lookupList( gcCrudUserRoles, crud_user.listing_roles ) then
        return no.

    find last  crud_login_history
         where crud_login_history.username = crud_user.username
         use-index user_start
         no-lock no-error.

    assign
        data.username               = lc( crud_user.username )
        data.password               = ""
        data.password_expiry        =
            ( if not crud_user.never_expires
              then crud_user.password_expiry
              else ? )

        data.change_password        = crud_user.change_password
        data.never_expires          = crud_user.never_expires
        data.first_name             = crud_user.first_name
        data.last_name              = crud_user.last_name
        data.full_name              = crud_user.full_name
        data.birth_date             = crud_user.birth_date
        data.user_locale            = crud_user.user_locale
        data.user_roles             = crud_user.user_roles
        data.listing_roles          = crud_user.listing_roles
        data.office                 = crud_user.office
        data.address                = crud_user.address
        data.country                = crud_user.country
        data.state                  = crud_user.state
        data.work_phone             = crud_user.work_phone
        data.mobile_phone           = crud_user.mobile_phone
        data.home_phone             = crud_user.home_phone
        data.phones                 = crud_user.phones
        data.email_address          = crud_user.email_address
        data.comments               = crud_user.comments
        data.failed_logins          = crud_user.failed_logins
        data.account_locked         = crud_user.account_locked
        data.activate_log           = crud_user.activate_log
        data.fixed_ip_address       = crud_user.fixed_ip_address
        data.exclude_ip_address     = crud_user.exclude_ip_address
        data.export_to_excel        = crud_user.export_to_excel
        data.last_login             =
            ( if avail crud_login_history
              then crud_login_history.start_time
              else ? )

        data.is_expired             =
            ( if not crud_user.never_expires
              then crud_user.password_expiry < today
              else no )

        data.is_online              = can-find(
            first crud_session
            where crud_session.username = crud_user.username
              and crud_session.is_online )

        data.is_busy                = data.is_online and can-find(
            first crud_session
            where crud_session.username = crud_user.username
              and crud_session.is_online
              and crud_session.is_busy ).

end function. /* bufferCopy */



function normalizeRoles returns char ( pcRoles as char ):

    define var cRetVal          as char no-undo.
    define var cInvalidRoles    as char no-undo.

    define var str  as char no-undo.
    define var len  as int no-undo.
    define var i    as int no-undo.

    assign
        cRetVal         = ""
        cInvalidRoles   = ""

    len = num-entries( pcRoles ).
    do i = 1 to len:

        str = lc( trim( entry( i, pcRoles ) ) ).

        if  str <> "all"
        and not can-find(
            first crud_role
            where crud_role.role_id = str ) then

            cInvalidRoles = cInvalidRoles
                + ( if cInvalidRoles <> "" then "," else "" )
                + str.

        cRetVal = cRetVal
            + ( if cRetVal <> "" then "," else "" )
            + str.

    end. /* 1 to len */

    if cInvalidRoles <> "" then
        {slib/err_throw "'role_not_found'" cInvalidRoles}.

    return cRetVal.

end function. /* normalizeRoles */

procedure createRecord:

    define param buffer change for change.

    define var cFullName    like crud_user.full_name no-undo.
    define var cPhones      like crud_user.phones no-undo.

    if change.password = ""
    or change.password = ? then
        {slib/err_throw "'blank_password'"}.

    if change.user_locale = ""
    or change.user_locale = ? then
       change.user_locale = gbCrudApp.default_locale.

    create crud_user.
    assign
        crud_user.username              = lc( change.username )
        crud_user.password              = encode( change.password )
        crud_user.password_history      = ?
        crud_user.password_expiry       =
            ( if not change.never_expires
              then today + gbCrudApp.password_expiry_days
              else 12/31/2099 )

        crud_user.change_password       = yes
        crud_user.never_expires         = change.never_expires
        crud_user.birth_date            = change.birth_date
        crud_user.user_locale           = caps( change.user_locale )
        crud_user.user_roles            = normalizeRoles( change.user_roles )
        crud_user.listing_roles         = normalizeRoles( change.listing_roles )
        crud_user.unseen_cnt            = 0
        crud_user.office                = change.office
        crud_user.address               = change.address
        crud_user.country               = change.country
        crud_user.state                 = change.state
        crud_user.email_address         = change.email_address
        crud_user.comments              = change.comments
        crud_user.failed_logins         = 0
        crud_user.account_locked        = change.account_locked
        crud_user.activate_log          = change.activate_log
        crud_user.fixed_ip_address      = change.fixed_ip_address
        crud_user.exclude_ip_address    = change.exclude_ip_address
        crud_user.export_to_excel       = change.export_to_excel
            {slib/err_no-error}.

    if crud_user.first_name <> change.first_name
    or crud_user.last_name  <> change.last_name then do:

        cFullName = "".

        if change.last_name <> "" then
            cFullName = cFullName
                + ( if cFullName <> "" then ", " else "" )
                + trim( change.last_name ).

        if change.first_name <> "" then
            cFullName = cFullName
                + ( if cFullName <> "" then ", " else "" )
                + trim( change.first_name ).

        assign
            crud_user.first_name    = change.first_name
            crud_user.last_name     = change.last_name
            crud_user.full_name     = cFullName.

    end. /* crud_user.first_name <> change */

    if crud_user.work_phone     <> change.work_phone
    or crud_user.mobile_phone   <> change.mobile_phone
    or crud_user.home_phone     <> change.home_phone then do:

        cPhones = "".

        if  change.work_phone <> ""
        and change.work_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.work_phone.

        if  change.mobile_phone <> ""
        and change.mobile_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.mobile_phone.

        if  change.home_phone <> ""
        and change.home_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.home_phone.

        assign
            crud_user.work_phone    = change.work_phone
            crud_user.mobile_phone  = change.mobile_phone
            crud_user.home_phone    = change.home_phone
            crud_user.phones        = cPhones.

    end. /* crud_user.work_phone <> change */

end procedure. /* createRecord */

procedure updateRecord:

    define param buffer change for change.

    define buffer bSession for crud_session.

    define var cFullName    like crud_user.full_name no-undo.
    define var cPhones      like crud_user.phones no-undo.

    if change.user_locale = ""
    or change.user_locale = ? then
       change.user_locale = gbCrudApp.default_locale.

    assign
        crud_user.change_password       = change.change_password
        crud_user.never_expires         = change.never_expires
        crud_user.birth_date            = change.birth_date
        crud_user.user_locale           = caps( change.user_locale )
        crud_user.user_roles            = normalizeRoles( change.user_roles )
        crud_user.listing_roles         = normalizeRoles( change.listing_roles )
        crud_user.office                = change.office
        crud_user.address               = change.address
        crud_user.country               = change.country
        crud_user.state                 = change.state
        crud_user.email_address         = change.email_address
        crud_user.comments              = change.comments
        crud_user.activate_log          = change.activate_log
        crud_user.export_to_excel       = change.export_to_excel
            {slib/err_no-error}.

    if  change.password <> ""
    and change.password <> ? then do:

        run setPassword( change.password ).
        if return-value <> "" and return-value <> ? then
            {slib/err_throw return-value}.

        assign
            crud_user.change_password = yes.

    end. /* password <> "" */

    if crud_user.first_name <> change.first_name
    or crud_user.last_name  <> change.last_name then do:

        cFullName = "".

        if change.last_name <> "" then
            cFullName = cFullName
                + ( if cFullName <> "" then ", " else "" )
                + trim( change.last_name ).

        if change.first_name <> "" then
            cFullName = cFullName
                + ( if cFullName <> "" then ", " else "" )
                + trim( change.first_name ).

        assign
            crud_user.first_name    = change.first_name
            crud_user.last_name     = change.last_name
            crud_user.full_name     = cFullName.

    end. /* crud_user.first_name <> change */

    if crud_user.work_phone     <> change.work_phone
    or crud_user.mobile_phone   <> change.mobile_phone
    or crud_user.home_phone     <> change.home_phone then do:

        cPhones = "".

        if  change.work_phone <> ""
        and change.work_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.work_phone.

        if  change.mobile_phone <> ""
        and change.mobile_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.mobile_phone.

        if  change.home_phone <> ""
        and change.home_phone <> ? then
            cPhones = cPhones
                + ( if cPhones <> "" then ", " else "" )
                + change.home_phone.

        assign
            crud_user.work_phone    = change.work_phone
            crud_user.mobile_phone  = change.mobile_phone
            crud_user.home_phone    = change.home_phone
            crud_user.phones        = cPhones.

    end. /* crud_user.work_phone <> change */

    if crud_user.fixed_ip_address   <> change.fixed_ip_address
    or crud_user.exclude_ip_address <> change.exclude_ip_address then do:

        assign
            crud_user.fixed_ip_address      = change.fixed_ip_address
            crud_user.exclude_ip_address    = change.exclude_ip_address
                {slib/err_no-error}.

        for each  crud_session
            where crud_session.username = crud_user.username
            no-lock:

            if      not ( ( crud_user.fixed_ip_address = ""
                 or can-do( crud_user.fixed_ip_address,     crud_session.ip_address ) )
            and not can-do( crud_user.exclude_ip_address,   crud_session.ip_address ) ) then do:

                find bSession
                    where rowid( bSession ) = rowid( crud_session )
                    exclusive-lock no-error.

                if avail bSession then
                assign
                    bSession.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

            end. /* not can-do( fixed_ip_address */

        end. /* for each crud_session */

    end. /* fixed_ip_address <> change */

    if crud_user.account_locked <> change.account_locked then do:

        assign
           crud_user.account_locked = change.account_locked.
        if crud_user.account_locked then

        for each  crud_session
            where crud_session.username = crud_user.username
            exclusive-lock:

            assign
                crud_session.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

        end. /* for each crud_session */

    end. /* account_locked <> change */

end procedure. /* updateRecord */

procedure deleteRecord:

    define param buffer change for change.

    if not confirm(
        input "warning",
        input ?,
        input ?,
        input "If the user is ref in other tables, his details will be lost. Delete?",
        input no ) then
            return.

    for each  crud_session
        where crud_session.username = crud_user.username
        exclusive-lock:

        assign
            crud_session.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

    end. /* for each crud_session */

    delete crud_user.

end procedure. /* deleteRecord */



function isComplexPassword returns log ( pcPassword as char ):

    define var lUpper   as log no-undo.
    define var lLower   as log no-undo.
    define var lDigit   as log no-undo.
    define var lSpecial as log no-undo.
    define var iCnt     as int no-undo.

    define var ch       as char case-sensitive no-undo.
    define var i        as int no-undo.
    define var j        as int no-undo.

    j = length( pcPassword ).
    if j < 8 then
        return no.

    assign
        lUpper      = no
        lLower      = no
        lDigit      = no
        lSpecial    = no
        iCnt        = 0.

    do i = 1 to j:

        ch = substr( pcPassword, i, 1 ).

        if ch >= "A" and ch <= "Z" then do:

            if not lUpper then
            assign
                lUpper      = yes
                iCnt        = iCnt + 1.

        end. /* upper */

        else
        if ch >= "a" and ch <= "z" then do:

            if not lLower then
            assign
                lLower      = yes
                iCnt        = iCnt + 1.

        end. /* lower */

        else
        if ch >= "0" and ch <= "9" then do:

            if not lDigit then
            assign
                lDigit      = yes
                iCnt        = iCnt + 1.

        end. /* digit */

        else
        if index( "~~!@#$%^&*_-+=~`|\()~{~}[]:;~"~'<>,.?/", ch ) > 0 then do:

            if not lSpecial then
            assign
                lSpecial    = yes
                iCnt        = iCnt + 1.

        end. /* special */

        if iCnt >= 3 then
            return yes.

    end. /* 1 to j */

    return no.

end function. /* isComplexPassword */

procedure checkPassword:

    define var cError as char no-undo.

    cError = ?.

    _try:
    do /* transaction */:

        find first crud_user
             where crud_user.username = param_values.username
             use-index username
             no-lock /* exclusive-lock */ no-error.

        if not avail crud_user then do:
            cError = "wrong_username_password".
            leave _try.
        end.

        else
        if  not crud_user.never_expires
        and crud_user.password_expiry < today then do:
            cError = "account_expired".
            leave _try.
        end.

        else
        if crud_user.account_locked then do:
            cError = "account_locked".
            leave _try.
        end.

        else
        if crud_user.password <> encode( param_values.password ) then do:

            /*** currently disabled or replaced with ip blocking ***
            assign
                crud_user.failed_logins     =   crud_user.failed_logins + 1
                crud_user.account_locked    = ( crud_user.failed_logins > 5 ).
            ***/

            cError = "wrong_username_password".
            leave _try.

        end. /* password <> encode */

        else
        if crud_user.change_password then do:
            cError = "change_password".
            leave _try.
        end.

        /*
        assign
            crud_user.failed_logins = 0.
        */

    end. /* trans */

    if cError <> ? then
        {slib/err_throw cError}.

    assign
        param_values.expiry_days =
            ( if crud_user.never_expires
              then 99999
              else crud_user.password_expiry - today + 1 ).

end procedure. /* checkPassword */

procedure changePassword:

    define var cError as char no-undo.

    if param_values.new_password = ""
    or param_values.new_password = ? then
        {slib/err_throw "'blank_password'"}.

    assign
        cError = ?.

    _try:
    do transaction:

        find first crud_user
             where crud_user.username = param_values.username
             use-index username
             exclusive-lock no-error.

        if not avail crud_user then do:
            cError = "wrong_username_password".
            leave _try.
        end.

        else
        if  not crud_user.never_expires
        and crud_user.password_expiry < today then do:
            cError = "account_expired".
            leave _try.
        end.

        else
        if crud_user.account_locked then do:
            cError = "account_locked".
            leave _try.
        end.

        else
        if crud_user.password <> encode( param_values.password ) then do:

            /*** currently disabled or replaced with ip blocking ***
            assign
                crud_user.failed_logins     =   crud_user.failed_logins + 1
                crud_user.account_locked    = ( crud_user.failed_logins > 5 ).
            ***/

            cError = "wrong_username_password".
            leave _try.

        end. /* password <> encode */

        run setPassword( param_values.new_password ).
        if return-value <> "" and return-value <> ? then do:
            cError = return-value.
            leave _try.
        end.

    end. /* trans */

    if cError <> ? then
        {slib/err_throw cError}.

end procedure. /* changePassword */

procedure setPassword:

    define input param pcPassword as char no-undo.

    define var cHistory like crud_user.password_history no-undo.
    define var cEncode  like crud_user.password.
    define var i        as int no-undo.

    assign
        cHistory    = crud_user.password_history
        cEncode     = encode( pcPassword ).

    do i = 1 to 10:

        if cHistory[i] = "" or cHistory[i] = ? then
            leave.

        if cEncode = cHistory[i] then
            return "old_password".

    end. /* 1 to 10 */

    if gbCrudApp.complex_passwords then do:

        if not isComplexPassword( pcPassword ) then
            return "invalid_complex_password".

    end. /* complex_passwords */

    else do:

        if length( pcPassword ) < 6 then
            return "invalid_basic_password".

    end. /* else */

    cHistory = crud_user.password_history.

    do i = 10 to 2 by -1:
        cHistory[i] = cHistory[ i - 1 ].
    end.

    cHistory[1] = cEncode.

    assign
        crud_user.password          = cEncode
        crud_user.password_history  = cHistory
        crud_user.password_expiry   =
            ( if not crud_user.never_expires
              then today + gbCrudApp.password_expiry_days
              else 12/31/2099 )

        crud_user.change_password   = no.

end procedure. /* setPassword */
