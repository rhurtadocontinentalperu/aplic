
/**
 * slibhttpprop.i -
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



/* i decided to use vars and not &preprocessors in this case because with preprocessors some special characters 
   would need to be escaped twice that might confuse or complicate.once for the &global-define and another time 
   where they are used so that for every one ~ there would have to be 3 */

define var http_cEncodeQuery    as char no-undo init "~;/?:@=& <>~"#%~{}|~\^~[]`+".
define var http_cEncodeCookie   as char no-undo init "~;/?:@=& ,".
define var http_cEncodeDefault  as char no-undo init "~;/?:@=& ".
