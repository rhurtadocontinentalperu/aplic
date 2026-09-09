
/**
 * service.i -
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

{slib/crud/global.i}

{slib/sliberr.i}

{slib/slibstr.i}

define shared var pcInputParam      as longchar no-undo.
define shared var pcOutputParam     as longchar no-undo.

define input param phInputParam     as handle no-undo.
define input param phOutputParam    as handle no-undo.



if phInputParam <> ? or phOutputParam <> ? then
    run processRequestByDataset.
else
    run processRequestByJson.

procedure processRequestByJson:

/*
&if defined( roles ) > 0 or defined( exclude_roles ) > 0 or defined( users ) > ~0 or defined( exclude_users ) > 0 &then

    if  not ( ( "{&roles}" = "" and "{&users}" = ""
             or str_lookupList( gcCrudUserRoles,    "{&roles}" ) )
        and not str_lookupList( gcCrudUserRoles,    "{&exclude_roles}" )
        and not str_lookupList( gcCrudUsername,     "{&exclude_users}" )
             or str_lookupList( gcCrudUsername,     "{&users}" ) ) then do:

*/

&if defined( roles ) > 0 or defined( exclude_roles ) > 0 &then

    if not ( ( "{&roles}" = ""
            or str_lookupList( gcCrudUserRoles, "{&roles}" ) )
       and not str_lookupList( gcCrudUserRoles, "{&exclude_roles}" ) ) then do:

        run blocktrycnt.p.

        {slib/err_throw "'access_denied'"}.

    end. /* not str_lookupList( &roles ) */

&endif

    if pcInputParam <> "" and pcInputParam <> ? then
    dataset input_param:read-json( "longchar", pcInputParam, "empty" ) {slib/err_no-error}.

    run processRequest.

    dataset output_param:write-json( "longchar", pcOutputParam ) {slib/err_no-error}.

end procedure. /* processRequestByJson */

procedure processRequestByDataset:

    phOutputParam:empty-dataset().

    if phInputParam <> ? and phOutputParam <> ? then
        run processRequestByInputOutput(
            input   dataset-handle phInputParam /* by-reference */,
            output  dataset-handle phOutputParam /* by-reference */ ).

    else
    if phInputParam <> ? then
        run processRequestByInput(
            input   dataset-handle phInputParam /* by-reference */ ).

    else
    if phOutputParam <> ? then
        run processRequestByOutput(
            output  dataset-handle phOutputParam /* by-reference */ ).

    phInputParam:empty-dataset().

end procedure. /* processRequestByDataset */

procedure processRequestByInputOutput:

    define input    param dataset for input_param.
    define output   param dataset for output_param.

    run processRequest.

end procedure. /* processRequestByInputOutput */

procedure processRequestByInput:

    define input param dataset for input_param.

    run processRequest.

end procedure. /* processRequestByInput */

procedure processRequestByOutput:

    define output param dataset for output_param.

    run processRequest.

end procedure. /* processRequestByOutput */

