
/**
 * dump1.p -
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

disable triggers for load of {1}.
disable triggers for dump of {1}.

define stream stOut.

define var cFile    as char no-undo.
define var iFile    as int no-undo.
define var i        as int no-undo.



assign
    cFile   = "{2}/" + lc( "{1}" ) + ".d"
    iFile   = 1
    i       = 0.

hide message no-pause.
message
    today
    string( time, "hh:mm:ss" )

    "{1}"
    trim( string( i, ">>>,>>>,>>>,>>9" ) ) 
    "records dumped.".


    
output stream stOut to value( cFile ).

for each {1}
    no-lock:

    export stream stOut {1}.

    if seek( stOut ) >= 1000000000 /* approx gigabyte */ then do:
    
        assign
            iFile = iFile + 1
            cFile = "{2}/" + lc( "{1}" ) + ".d" + string( iFile ).

        output stream stOut close.
        output stream stOut to value( cFile ).

    end. /* seek >= gigabyte */

        
        
    i = i + 1.
        
    if i mod 10000 = 0 then do:
    
        hide message no-pause.
        message
            today
            string( time, "hh:mm:ss" )
            
            "{1}" 
            trim( string( i, ">>>,>>>,>>>,>>9" ) ) 
            "records dumped.".

    end. /* mod 10000 = 0 */

end. /* each {1} */



hide message no-pause.
message
    today
    string( time, "hh:mm:ss" )
    
    "{1}" 
    trim( string( i, ">>>,>>>,>>>,>>9" ) ) 
    "records dumped.".

output stream stOut close.

