
/**
 * slibtimeevnt.p - timing events library main procedure
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



{slib/slibwin.i} /* makes use of the high performance timer win api instead of mtime( ) which is only available starting from openedge 10. pstimer is already windows dependent so what the heck ;) */

{slib/sliberr.i}



/* ctrl frame container */

define var whWin        as widget no-undo.
define var whFrame      as widget no-undo.
define var whCtrlFrame  as widget no-undo.

define var chCtrlFrame  as com-handle no-undo.
define var chCtrl       as com-handle no-undo.



define temp-table ttEvent no-undo

    field iEventID      as int
    field dPerfCounter  as dec

    field cInternalProc as char
    field hProcHndl     as handle

    index iEventID is primary unique 
          iEventID

    index dPerfCounter
          dPerfCounter.

define var iEventIDSeq      as int no-undo.

define var dMSecFreq        as dec no-undo. /* 1 millisecond relative to the performance counter frequency */

define var lCheckPointBusy  as log no-undo. /* marks if the check point has not completed and should not be runned again. */



on "close" of this-procedure do:

    if valid-handle( whCtrlFrame ) then run stopTimer.

    delete procedure this-procedure.

end. /* close of this-procedure */

procedure initializeProc:

    assign
        iEventIDSeq     = 0

        dMSecFreq       = win_queryPerfFrequency( ) / 1000

        lCheckPointBusy = no.

end procedure. /* initializeProc */



function time_setTimeout returns integer /* returns the timing event id */

    ( pcInternalProc    as char,
      phProcHndl        as handle,
      pdMTimeout        as dec ):

    define buffer ttEvent for ttEvent.

    define var dPerfCounter as dec no-undo.

    dPerfCounter = win_queryPerfCounter( ) + pdMTimeout * dMSecFreq.



    iEventIDSeq = iEventIDSeq + 1.

    create ttEvent.
    assign
        ttEvent.iEventID        = iEventIDSeq
        ttEvent.dPerfCounter    = dPerfCounter

        ttEvent.cInternalProc   = pcInternalProc
        ttEvent.hProcHndl       = phProcHndl.

    run setNextCheckPoint.

    return ttEvent.iEventID.

end function. /* time_setTimeout */

procedure time_clearTimeout:

    define input param piEventID as int no-undo.

    define buffer ttEvent for ttEvent.

    if piEventID = ? or piEventID = 0 or piEventID = -1 then do:

        empty temp-table ttEvent.
        run stopTimer.

    end. /* piEventID = ? */

    else do:

        find ttEvent where ttEvent.iEventID = piEventID no-error.
        if avail ttEvent then do:

            delete ttEvent.
            run setNextCheckPoint.

        end. /* avail */

    end. /* else */

end procedure. /* time_clearTimeout */



procedure setNextCheckPoint private:

    define buffer ttEvent for ttEvent.

    find first ttEvent use-index dPerfCounter no-error.

    if not avail ttEvent then do:

        if valid-handle( whCtrlFrame ) then
            run stopTimer.

    end. /* not avail */

    else do:

        if not valid-handle( whCtrlFrame ) then
            run startTimer.

        chCtrl:interval = max( ( ttEvent.dPerfCounter - win_queryPerfCounter( ) ) / dMSecFreq, 1 ).

    end. /* else */

end procedure. /* setNextCheckPoint */

procedure startTimer private:

    define var lOK as log no-undo.

    create window whWin
    assign
        hidden  = yes.

    create frame whFrame
    assign
        parent  = whWin.

    create control-frame whCtrlFrame
    assign
        frame   = whFrame
        name    = "CtrlFrame".

    chCtrlFrame = whCtrlFrame:com-handle.



    file-info:file-name = "slib/bin/slibtimeevnt.wrx".

    /***
    if file-info:full-pathname = ? then
       file-info:file-name = "slib/slibtimeevnt.wrx".

    if file-info:full-pathname = ? then
       file-info:file-name = "slibtimeevnt.wrx".

    if file-info:full-pathname = ? then
       file-info:file-name = "xx/slibtimeevnt.wrx".

    if file-info:full-pathname = ? then
       file-info:file-name = "us/xx/slibtimeevnt.wrx".

    if file-info:full-pathname = ? then
       file-info:file-name = "xxsrc/slibtimeevnt.wrx".

    if file-info:full-pathname = ? then
       file-info:file-name = "us/xxsrc/slibtimeevnt.wrx".
    ***/

    if file-info:full-pathname = ? then
       {slib/err_throw "'file_not_found'" file-info:file-name}.

    chCtrlFrame:LoadControls( file-info:full-pathname, "CtrlFrame" ) {slib/err_no-error}.

    chCtrl = chCtrlFrame:PSTimer.
    chCtrl:interval = 5000. /* just a default */

end procedure. /* startTimer */

procedure stopTimer private:

    delete widget whWin. /* deletes the window and all the windows children including the control-frame that releases the activex controls */

    assign
        whWin       = ?
        whFrame     = ?
        whCtrlFrame = ?.

end procedure. /* stopTimer */



/* timing events check point. this is where the magic happens */

procedure CtrlFrame.PSTimer.Tick: 

    define buffer ttEvent for ttEvent.

    if lCheckPointBusy then return.

    {slib/err_try}:

        lCheckPointBusy = yes.

        for each  ttEvent
            where ttEvent.dPerfCounter <= win_queryPerfCounter( ) /* functions are resolved once when opening the query */
            use-index dPerfCounter:

            {slib/err_try}:

                /* debug ***

                display
                    ( win_queryPerfCounter( ) - ttEvent.dPerfCounter ) / dMSecFreq label "diff"
                with 1 down side-labels.

                *** debug */

                if ttEvent.hProcHndl = ? then
                     run value( ttEvent.cInternalProc ) no-error.
                else run value( ttEvent.cInternalProc ) in ttEvent.hProcHndl no-error.

            {slib/err_catch}:

                {slib/err_throw last}.
                
            {slib/err_finally}:

                /* the event may have already been deleted by time_clearTimeout( ) in the calling procedure */
                if avail ttEvent then delete ttEvent.

            {slib/err_end}.

        end. /* for each */

    {slib/err_catch}:

        {slib/err_throw last}.

    {slib/err_finally}:

        run setNextCheckPoint.

        lCheckPointBusy = no.

    {slib/err_end}.

end procedure. /* tick */
