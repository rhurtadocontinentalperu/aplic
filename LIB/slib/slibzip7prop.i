
/**
 * slibzip7prop.i -
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



&if "{&opsys}" begins "win" &then

    &global zip7_xUtilZip   'C:~\Program Files~\7-Zip~\7z.exe'

&else

    &global zip7_xUtilZip   '/opt/freeware/bin/7za'

&endif

&global zip7_xCmdAdd        '"%zip%" a %archive% %files%            -t%type% -r -y %param%'
&global zip7_xCmdDel        '"%zip%" d %archive% %files%            -t%type% -r'
&global zip7_xCmdList       '"%zip%" l %archive%                    -t%type%'
&global zip7_xCmdExtract    '"%zip%" x %archive% %files% -o%outdir% -t%type% -r -y -aoa'



define temp-table zip7_ttFile no-undo

    field cPath     as char
    field tDate     as date
    field iTime     as int
    field dLength   as dec

    index cPath is primary unique
          cPath.
