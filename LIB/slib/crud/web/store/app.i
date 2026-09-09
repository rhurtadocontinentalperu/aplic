
/**
 * app.i -
 *
 * By Alon Blich
 */

{slib/crud/define-store.i

    &roles = "admin"

    &updateable = yes
    &audit = yes

    &fields = "
        field default_locale        like crud_app.default_locale
        field complex_passwords     like crud_app.complex_passwords
        field password_expiry_days  like crud_app.password_expiry_days
        field block_try_cnt         like crud_app.block_try_cnt
        field block_timeout         like crud_app.block_timeout
        field session_timeout       like crud_app.session_timeout
        field session_lock_timeout  like crud_app.session_lock_timeout
        field log_history_days      like crud_app.log_history_days
        field chat_history_days     like crud_app.chat_history_days
        field alert_history_days    like crud_app.alert_history_days
        field login_history_days    like crud_app.login_history_days
        field show_login_history    like crud_app.show_login_history
        field block_access          like crud_app.block_access
        field fixed_ip_address      like crud_app.fixed_ip_address
        field exclude_ip_address    like crud_app.exclude_ip_address"}
