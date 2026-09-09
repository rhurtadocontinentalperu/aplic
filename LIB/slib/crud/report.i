
/**
 * report.i -
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

define var pcExportFile as char no-undo.



procedure processRequest:

    find first param_values no-error.

    if not avail param_values then
    create param_values.

    create output_header.
    assign output_header.content_type = "".

    create output_param_values.
    run resetOutputParams.

    assign
        pcExportFile = ?.

    do on quit undo, leave:

        run fillData.

        run exportFile.

        assign
            output_header.content_type  = "completed"
            output_header.export_file   = pcExportFile.

    end. /* on quit */

    do transaction:

		if output_header.content_type = "completed" then do:

			create crud_export_file.
			assign
				crud_export_file.session_id  	= gcCrudSessionId
				crud_export_file.request_id	 	= gcCrudRequestId
				crud_export_file.export_file	= pcExportFile.

		end. /* content_type = "completed" */

		else do:

			if pcExportFile <> ? then
				os-delete value( pcExportFile ).

		end. /* else */

    end. /* do trans */

    run err_throwLast.

    err_catchQuit().

    run saveOutputParams.

end procedure. /* processRequest */
