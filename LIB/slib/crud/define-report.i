
/**
 * define-report.i -
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

define temp-table {&prefix}param_values no-undo serialize-name "paramValues"

    {&params}.

define temp-table {&prefix}param_list no-undo serialize-name "paramList"

    field param_name as char serialize-name "param"
    index param_name is primary unique
          param_name.

define temp-table {&prefix}confirm_list no-undo serialize-name "confirmList"

    field confirm_num   as int serialize-name "num"
    field confirm_value as log serialize-name "value"

    index confirm_num is primary unique
          confirm_num.

define dataset {&prefix}input_param serialize-name "inputParam"

    for {&prefix}param_values, {&prefix}param_list, {&prefix}confirm_list.



define temp-table {&prefix}output_header no-undo serialize-name "outputParam"

    field content_type      as char         serialize-name "contentType"
    field export_file       as char         serialize-name "exportFile"

    field prompt_params     as char         serialize-name "promptParams"
    field confirm_num       as int          serialize-name "confirmNum"
    field confirm_default   as log          serialize-name "confirmDefault"

    field error_code        as char init ?  serialize-name "errorCode"
    field error_params      as char init ?  serialize-name "errorParams"
    field error_msg         as char init ?  serialize-name "errorMsg".

define temp-table {&prefix}output_param_values no-undo serialize-name "paramValues"

    {&params}.

define temp-table {&prefix}output_param_list no-undo serialize-name "paramList"

    field param_name as char serialize-name "param"
    index param_name is primary unique
          param_name.

define temp-table {&prefix}msg_list no-undo serialize-name "msgList"

    field msg_seq       as int  serialize-name "msgSeq"
    field msg_type      as char serialize-name "msgType"
    field msg_code      as char serialize-name "msgCode"
    field msg_params    as char serialize-name "msgParams"
    field msg_text      as char serialize-name "msgText"

    index msg_seq is primary unique
          msg_seq.

define dataset {&prefix}output_param serialize-name "outputParam"

    for {&prefix}output_header, {&prefix}output_param_values, {&prefix}output_param_list, {&prefix}msg_list.



&if not defined( prefix ) <> 0 &then

    {slib/global-define.i &name = "roles"           &value = "{&roles}"}
    {slib/global-define.i &name = "exclude_roles"   &value = "{&exclude_roles}"}
    {slib/global-define.i &name = "params"          &value = "{&params}"}

&endif /* not defined( prefix ) */

