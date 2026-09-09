
/**
 * watchdog.p -
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
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +972-54-218-8086
 */

&if "{&window-system}" = "tty" &then

{slib/slibticker.i}

&else

{slib/slibtimeevnt.i}

&endif

{slib/slibdate.i}



&global xTimeout    1800 /* 30 mins in seconds */

&if "{&window-system}" <> "tty" &then

&global xInterval   60

&endif



define var tLastDbAccessDate    as date no-undo.
define var iLastDbAccessTime    as int no-undo.
define var iLastDbAccessIO      as int no-undo.



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */



run initializeProc.

procedure initializeProc private:

    assign
        tLastDbAccessDate   = ?
        iLastDbAccessTime   = ?
        iLastDbAccessIO     = ?.

    &if "{&window-system}" = "tty" &then

        subscribe to "tick" anywhere.

    &else

        time_setTimeout( "tick", this-procedure, {&xInterval} * 1000 ).

    &endif

end procedure. /* initializeProc */



procedure tick:

    for each  /* qaddb. */ _myconnect 
        no-lock,

        each  /* qaddb. */ _userio
        where /* qaddb. */ _userio._userio-usr = _myconnect._myconn-userid
        no-lock:
        
        if iLastDbAccessIO <> _userio._userio-dbaccess then
        
        assign
            tLastDbAccessDate   = today
            iLastDbAccessTime   = time
            iLastDbAccessIO     = _userio._userio-dbaccess.

    end. /* each _myconnect */

    if {slib/date_intervaltime today time tLastDbAccessDate iLastDbAccessTime} >= {&xTimeout} then do:
    
        pause 0 before-hide.
        hide all no-pause.
        
        quit.

    end. /* interval >= timeout */
    
    &if "{&window-system}" <> "tty" &then

        time_setTimeout( "tick", this-procedure, {&xInterval} * 1000 ).

    &endif

end procedure. /* tick */
