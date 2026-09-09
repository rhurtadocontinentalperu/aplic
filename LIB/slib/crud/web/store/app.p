
/**
 * app.p -
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

{store/app.i}

{slib/crud/store.i}

{slib/slibstr.i}



define query qry

    for crud_app scrolling.

function openQuery returns handle:

    query qry:query-prepare(
        "for each crud_app " +
            /*
            "where " + cWhere + " " +
            ( if input_header.active_index <> ""
              then "use-index " + input_header.active_index
              else "" ) + " " +

            */
            "exclusive-lock " +

            "indexed-reposition" ) {slib/err_no-error}.

    query qry:query-open().

    return query qry:handle.

end function. /* openQuery */

function bufferCopy returns log ( buffer data for data ):

    assign
        data.default_locale         = caps( crud_app.default_locale )
        data.complex_passwords      = crud_app.complex_passwords
        data.password_expiry_days   = crud_app.password_expiry_days
        data.block_try_cnt          = crud_app.block_try_cnt
        data.block_timeout          = crud_app.block_timeout
        data.session_timeout        = crud_app.session_timeout
        data.session_lock_timeout   = crud_app.session_lock_timeout
        data.log_history_days       = crud_app.log_history_days
        data.chat_history_days      = crud_app.chat_history_days
        data.alert_history_days     = crud_app.alert_history_days
        data.login_history_days     = crud_app.login_history_days
        data.show_login_history     = crud_app.show_login_history
        data.block_access           = crud_app.block_access
        data.fixed_ip_address       = crud_app.fixed_ip_address
        data.exclude_ip_address     = crud_app.exclude_ip_address.

end function. /* bufferCopy */



procedure updateRecord:

    define param buffer change for change.

    define buffer bSession for crud_session.

    if not avail crud_app then
        create crud_app.

    assign
        crud_app.default_locale         = caps( change.default_locale )
        crud_app.complex_passwords      = change.complex_passwords
        crud_app.password_expiry_days   = change.password_expiry_days
        crud_app.block_try_cnt          = change.block_try_cnt
        crud_app.block_timeout          = change.block_timeout
        crud_app.session_timeout        = change.session_timeout
        crud_app.session_lock_timeout   = change.session_lock_timeout
        crud_app.log_history_days       = change.log_history_days
        crud_app.chat_history_days      = change.chat_history_days
        crud_app.alert_history_days     = change.alert_history_days
        crud_app.login_history_days     = change.login_history_days
        crud_app.show_login_history     = change.show_login_history
            {slib/err_no-error}.

    if crud_app.block_access <> change.block_access then do:

        assign
            crud_app.block_access = change.block_access
                {slib/err_no-error}.

        if crud_app.block_access then
        for each  crud_session
            where crud_session.session_id <> gcCrudSessionId
            no-lock,

            first crud_user
            where crud_user.username = crud_session.username
              and lookup( "admin", crud_user.user_roles ) = 0
            no-lock:

            find bSession
                where rowid( bSession ) = rowid( crud_session )
                exclusive-lock no-error.

            if avail bSession then
            assign
                bSession.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

        end. /* for each crud_session */

    end. /* change <> crud */

    if crud_app.fixed_ip_address    <> change.fixed_ip_address
    or crud_app.exclude_ip_address  <> change.exclude_ip_address then do:

        assign
            crud_app.fixed_ip_address   = change.fixed_ip_address
            crud_app.exclude_ip_address = change.exclude_ip_address
                {slib/err_no-error}.

        for each crud_session
            no-lock:

            if      not ( ( crud_app.fixed_ip_address = ""
                 or can-do( crud_app.fixed_ip_address,      crud_session.ip_address ) )
            and not can-do( crud_app.exclude_ip_address,    crud_session.ip_address ) ) then do:

                find bSession
                    where rowid( bSession ) = rowid( crud_session )
                    exclusive-lock no-error.

                if avail bSession then
                assign
                    bSession.last_hit = datetime-tz( 01, 01, 1970, 00, 00, 00, 0 ).

            end. /* not can-do( fixed_ip_address ) */

        end. /* for each crud_session */

    end. /* crud_app.fixed_ip_address <> change */

end procedure. /* updateRecord */
