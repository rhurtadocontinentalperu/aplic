
/**
 * slibzprop.i -
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



/* compress/uncompress function return values. negative values are errors, positive values are used for special but normal events. */

&global Z_OK             0
&global Z_STREAM_END     1
&global Z_NEED_DICT      2
&global Z_ERRNO         -1
&global Z_STREAM_ERROR  -2
&global Z_DATA_ERROR    -3
&global Z_MEM_ERROR     -4
&global Z_BUF_ERROR     -5
&global Z_VERSION_ERROR -6
