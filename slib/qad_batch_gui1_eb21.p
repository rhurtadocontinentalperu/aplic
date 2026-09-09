/* GUI CONVERTED from mf.p (converter v1.77) Tue Jul 22 07:00:53 2003 */
/* mf.p       - Mfg/Pro Manufacturing Pre-entry Program                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.19 $                                                          */
/*                                                                            */
/* Description:                                                               */
/*  This is the initial start-up program for MFG/PRO.                         */
/*                                                                            */
/*  This program can be compiled against any database because  it             */
/*  has  no   database references.  Its sole purpose is to set an             */
/*  alias for the  first database named in the start-up script so             */
/*  that the real  programs (which have been compiled against the             */
/*  pseudo-database name  qaddb) can run.                                     */
/*                                                                            */
/*  Revision:       By: afs *           Date: 11/07/91  Rel: 7.0  ECO:        */
/*  Revision:       By: rwl             Date: 03/12/93  Rel: 7.3  ECO: *G809* */
/*  Revision:       By: rmh             Date: 06/20/94  Rel: 7.3  ECO: *FO78* */
/*  Revision:       By: yep             Date: 12/21/94  Rel: 7.3  ECO: *F0BB* */
/*  Revision:       By: ame             Date: 04/24/95  Rel: 7.3  ECO: *G0L6* */
/*  Revision:       By: jzs             Date: 06/30/95  Rel: 7.3  ECO: *G0NQ* */
/*  Revision:       By: ame             Date: 09/19/95  Rel: 7.3  ECO: *G0XF* */
/*  Revision:       By: ame             Date: 12/20/95  Rel: 7.3  ECO: *F0WW* */
/*  Revision:       By: jzs             Date: 03/05/96  Rel: 7.3  ECO: *G1MP* */
/*  Revision:       By: rkc             Date: 04/26/96  Rel: 7.3  ECO: *G1Q8* */
/*  Revision:       By: taf             Date: 08/09/96  Rel: 7.3  ECO: *G2BV* */
/*  Revision:       By: ame             Date: 09/25/96  Rel: 7.3  ECO: *G2F8* */
/*  Revision:       By: dxb             Date: 11/11/96  Rel: 8.5  ECO: *H0P2* */
/*  Revision:       By: Duane Burdett   Date: 03/25/97  Rel: 8.5  ECO: *G2LR* */
/*  Revision: 1.7.4.1 By: Alfred Tan    Date: 05/20/98  Rel: 8.6E ECO: *K1Q4* */
/*  Revision: 1.8     By: A. Rahane     Date: 02/23/98  Rel: 8.6E ECO: *L007* */
/*  Revision: 1.10    By: Alfred Tan    Date: 10/04/98  Rel: 8.6E ECO: *J314* */
/*  Revision: 1.11    By: Hemanth Ebene Date: 03/10/99  Rel: 9.0  ECO: *M0B8* */
/*  Revision: 1.12    By: Alfred Tan    Date: 03/13/99  Rel: 9.0  ECO: *M0BD* */
/*  Revision: 1.13    By: Brian Wintz   Date: 02/24/00  Rel: 9.1  ECO: *N03S* */
/*  Revision: 1.15    By: B. Gates      Date: 01/28/00  Rel: 9.1  ECO: *N06R* */
/*  Revision: 1.16    By: Mark Brown    Date: 08/30/00  Rel: 9.1  ECO: *N0QB* */
/*  Revision: 1.17    By: Jean Miller   Date: 01/28/00  Rel: 9.1  ECO: *N0T3* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18     BY: Jean Miller       DATE: 07/30/01        ECO: *N10V* */
/* $Revision: 1.19 $  BY: Subashini Bala    DATE: 01/01/03        ECO: *N239* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/* ALIAS QADDB POINTS TO THE MFG/PRO DATABASE THUS IF WE ARE     */
/* RUNNING WITH A NON-PROGRESS DB THE ALIAS QADDB MUST POINT TO THE     */
/* FOREIGN DATABASE NOT THE FIRST CONNECTED DATABASE.                   */

/* CHECK TO SEE IF WE HAVE ANY CONNECTED DATABASES BEFORE WE CREATE */
/* THE ALIAS AND RUN MF1.P, OTHERWISE INFORM USER AND QUIT PROGRESS */

{mfqwizrd.i "new global"}



/*** alonb ***/
{slib/slibpro.i}

DEFINE INPUT PARAM pcUserid     AS CHAR NO-UNDO.
DEFINE INPUT PARAM pcPasswd     AS CHAR NO-UNDO.
DEFINE INPUT PARAM pcDomain     AS CHAR NO-UNDO.
DEFINE INPUT PARAM pcProgram    AS CHAR NO-UNDO.
DEFINE INPUT PARAM pcCimFile    AS CHAR NO-UNDO.
DEFINE INPUT PARAM pcLogFile    AS CHAR NO-UNDO.

DEFINE NEW SHARED VAR gcUserid  AS CHAR NO-UNDO.
DEFINE NEW SHARED VAR gcPasswd  AS CHAR NO-UNDO.
DEFINE NEW SHARED VAR gcDomain  AS CHAR NO-UNDO.
DEFINE NEW SHARED VAR gcProgram AS CHAR NO-UNDO.
DEFINE NEW SHARED VAR gcCimFile AS CHAR NO-UNDO.
DEFINE NEW SHARED VAR gcLogFile AS CHAR NO-UNDO.

DEFINE VAR cFileName AS CHAR NO-UNDO.

ASSIGN
    gcUserid    = pcUserid
    gcPasswd    = pcPasswd
    gcDomain    = pcDomain
    gcProgram   = pcProgram
    gcCimFile   = pcCimFile
    gcLogFile   = pcLogFile.
/*** alonb ***/



define new global shared variable cut_paste as character format "x(70)" no-undo.

/* Introducing a variable to store the datatype while copying in ChUI */
define new global shared variable copyfldtype as character no-undo.

define variable sdb as integer no-undo.

     
/* GUI'S FIRST PROGRAM MUST CREATE A WINDOW OR ONE IS CREATED FOR YOU */
if not qwizard then do:
   define var window-1 as widget-handle no-undo.

   create window window-1
   assign
      title      = "MFG/PRO Sign On"
      x             = 40
      y             = 1
      width         = 80
      height        = 17
      max-width     = 80  /* Stay same size on Maximize Event */
      max-height    = 17
      virtual-width = 80  /* Stay same size on Maximize Event */
      virtual-height = 17
      fgcolor       = ?
      bgcolor       = 8
      message-area  = no
      visible       = no
      sensitive     = yes
      resize        = yes
      private-data  = "MFG/PRO"
      /*** alonb ***/
      HIDDEN = YES.
      /*** alonb ***/

   current-window = window-1.
end.  /* IF NOT QWIZARD DO */

/* THE MAIN WINDOW FOR QWIZARD MUST BE A SMALL WINDOW. OTHERWISE     */
/* PROGRESS ISSUES AN ERROR MSG EVERY TIME A PROGRAM IS LAUNCHED     */
else if qwizard then do:
   create window window-1
   assign
      title      = "MFG/PRO with Qwizard"
      x             = 1
      y             = 1
      width         = 27
      height        = 1
      fgcolor       = 8
      bgcolor       = 8
      message-area  = no
      visible       = no
      sensitive     = no
      resize        = no
      scroll-bars   = no
      private-data  = "MFG/PRO"
      /*** alonb ***/
      HIDDEN = YES.
      /*** alonb ***/
   current-window = window-1.
end.  /* IF QWIZARD DO */
  

/*CHECK NUM-DBS AND SET QADDB, QAD ALIASES*/
do on error undo, leave:
   run mfcqa.p(input "").

   /*** alonb ***/
   cFileName = pro_getRunFile( "slib/qad_batch_gui2_eb21.p" ).
    
   /***
   if cFileName = ? then
      cFileName = pro_getRunFile( "qad_batch_gui2_eb21.p" ).
    
   if cFileName = ? then
      cFileName = pro_getRunFile( "xx/qad_batch_gui2_eb21.p" ).
    
   if cFileName = ? then
      cFileName = pro_getRunFile( "us/xx/qad_batch_gui2_eb21.p" ).
   ***/

   run value( cFileName ).
   /*** alonb ***/
   
   /*** alonb ***
   return.
   *** alonb ***/
end.

/*** alonb ***
pause.
*** alonb ***/

quit.
