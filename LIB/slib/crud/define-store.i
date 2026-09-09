
/**
 * define-store.i -
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

&if defined(updateable) = 0 &then
    &global updateable no
&endif

&if defined(optimistic_locking) = 0 &then
    &global optimistic_locking yes
&endif

&if defined(batched) = 0 &then
    &global batched yes
&endif

&if defined(audit) = 0 &then
    &global audit yes
&endif

&if defined(assert_indexed_reposition) = 0 &then
    &global assert_indexed_reposition yes
&endif

&if {&updateable} and not {&batched} &then
    &undef batched
    &global batched yes
&endif



define temp-table {&prefix}input_header no-undo serialize-name "inputHeader"

    field service_operation as char         serialize-name "serviceOperation"
    field active_index      as char         serialize-name "activeIndex"

&if {&updateable} &then
    field esign             as log init no  serialize-name "eSign"
&endif

&if {&batched} &then
    field batch_size        as int init ?   serialize-name "batchSize"
&endif
.

&if {&updateable} &then

define temp-table {&prefix}change no-undo serialize-name "changes"

    field change_id     as int              serialize-name "changeId"
    field change_type   as char             serialize-name "changeType" /* (c)reate, (u)pdate, (d)elete, (b)efore-image  */
    field row_id        as rowid extent 7   serialize-name "rowId"

    {&fields}

    index change_type_id is primary
          change_type
          change_id.

&endif

define temp-table {&prefix}param_values no-undo serialize-name "paramValues"

&if {&batched} &then
    field row_id as rowid extent 7 serialize-name "rowId"
&endif

    {&fields}

&if defined( params ) <> 0 &then
    {&params}
&endif
.

define temp-table {&prefix}param_list no-undo serialize-name "paramList"

    field param_name        as char             serialize-name "param"
    field param_operator    as char init "="    serialize-name "operator"

    index param_name is primary unique
          param_name.

define temp-table {&prefix}confirm_list no-undo serialize-name "confirmList"

    field confirm_num       as int              serialize-name "num"
    field confirm_value     as log              serialize-name "value"

    index confirm_num is primary unique
          confirm_num.

define temp-table {&prefix}index_field no-undo serialize-name "indexFields"

    field field_seq         as int              serialize-name "seq"
    field field_name        as char             serialize-name "field"
    field field_descend     as log              serialize-name "descend"

    index field_seq is primary unique
          field_seq

    index field_name is unique
          field_name.

define dataset {&prefix}input_param serialize-name "inputParam"

    for {&prefix}input_header, {&prefix}param_values, {&prefix}param_list, {&prefix}confirm_list, {&prefix}index_field

    &if {&updateable} &then
        , {&prefix}change
    &endif
    .



define temp-table {&prefix}output_header no-undo serialize-name "outputHeader"

    field content_type      as char             serialize-name "contentType"
    field reached_home      as log init false   serialize-name "reachedHome"
    field reached_end       as log init false   serialize-name "reachedEnd"

    field prompt_params     as char             serialize-name "promptParams"
    field confirm_num       as int              serialize-name "confirmNum"
    field confirm_default   as log              serialize-name "confirmDefault"

    field error_code        as char init ?      serialize-name "errorCode"
    field error_params      as char init ?      serialize-name "errorParams"
    field error_msg         as char init ?      serialize-name "errorMsg".

define temp-table {&prefix}data no-undo serialize-name "data"

&if {&updateable} &then

    field change_id         as int              serialize-name "changeId"
    field change_type       as char             serialize-name "changeType" /* (c)reate, (u)pdate, (d)elete, (b)efore-image~ */

    field error_code        as char init ?      serialize-name "errorCode"
    field error_params      as char init ?      serialize-name "errorParams"
    field error_msg         as char init ?      serialize-name "errorMsg"

&endif

&if {&batched} &then

    field row_seq           as int              serialize-name "rowSeq"
    field row_id            as rowid extent 7   serialize-name "rowId"

&endif

    {&fields}

&if {&batched} &then

    index row_seq is primary
          row_seq

&endif
.

&if {&updateable} &then

define temp-table {&prefix}field_error no-undo serialize-name "fieldErrors"

    field change_id         as int              serialize-name "changeId"
    field field_name        as char             serialize-name "field"

    field error_code        as char init ?      serialize-name "errorCode"
    field error_params      as char init ?      serialize-name "errorParams"
    field error_msg         as char init ?      serialize-name "errorMsg"

    index change_id_field is primary unique
          change_id
          field_name.

&endif /* updateable */

define temp-table {&prefix}output_param_values no-undo serialize-name "paramValues"

    {&fields}

&if defined( params ) <> 0 &then
    {&params}
&endif
.

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

    for {&prefix}output_header, {&prefix}output_param_values, {&prefix}output_param_list, {&prefix}msg_list, {&prefix}data

    &if {&updateable} &then
        , {&prefix}field_error
    &endif

    &if defined( substores ) <> 0 &then
        , {&substores}
    &endif

    &if {&updateable} &then
        data-relation for {&prefix}data, {&prefix}field_error
            relation-fields ( change_id, change_id )
                nested foreign-key-hidden
    &endif
.



&if not defined( prefix ) <> 0 &then

    {slib/global-define.i &name = "roles"               &value = "{&roles}"}
    {slib/global-define.i &name = "exclude_roles"       &value = "{&exclude_roles}"}

    {slib/global-define.i &name = "updateable"          &value = "{&updateable}"}
    {slib/global-define.i &name = "batched"             &value = "{&batched}"}
    {slib/global-define.i &name = "audit"               &value = "{&audit}"}
    {slib/global-define.i &name = "optimistic_locking"  &value = "{&optimistic_locking}"}
    {slib/global-define.i &name = "fields"              &value = "{&fields}"}
    {slib/global-define.i &name = "params"              &value = "{&params}"}
    {slib/global-define.i &name = "substores"           &value = "{&substores}"}

&endif /* not defined( prefix ) */
