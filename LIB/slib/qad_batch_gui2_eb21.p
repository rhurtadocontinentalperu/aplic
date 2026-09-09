/* GUI CONVERTED from mf1.p (converter v1.77) Tue Jul 22 07:00:53 2003 */
/* mf1.p      - Mfg/pro Manufacturing Entry Program                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/*                                                                            */
/* Description:                                                               */
/*  This startup routine will set the user's language code  prior             */
/*  to any translatable source code routines.  The program mf1a.p             */
/*  is where the bulk of startup processing is  now  done.   This             */
/*  program  stays  in the same location as mf.p, while mf1a.p is             */
/*  located in the same directory as mfmenu.p.  05/14/93 - rwl                */
/*                                                                            */
/*  Revision:       By: rwl            Date: 03/16/93  Rel: 7.3   ECO: *G821* */
/*  Revision:       By: rwl            Date: 05/18/93  Rel: 7.3   ECO: *GA97* */
/*  Revision:       By: rwl            Date: 06/25/93  Rel: 7.3   ECO: *GC72* */
/*  Revision:       By: rmh            Date: 06/14/94  Rel: 7.3   ECO: *FO83* */
/*  Revision:       By: rmh            Date: 07/07/94  Rel: 7.3   ECO: *FO78* */
/*  Revision:       By: jzs            Date: 03/25/95  Rel: 7.3   ECO: *G0KC* */
/*  Revision:       By: jzs            Date: 03/25/95  Rel: 7.3   ECO: *G0NQ* */
/*  Revision:       By: ame            Date: 12/20/95  Rel: 7.3   ECO: *F0WW* */
/*  Revision:       By: tvo            Date: 11/21/95  Rel: 8.5   ECO: *J094* */
/*  Revision:       By: taf            Date: 10/01/96  Rel: 8.5   ECO: *J15D* */
/*  Revision:       By: wep            Date: 04/30/97  Rel: 8.5   ECO: *J1PW* */
/*  Revision:       By: das            Date: 10/13/97  Rel: 8.6   ECO: *K0WK* */
/*  Revision:       By: A. Rahane      Date: 02/23/98  Rel: 8.6e  ECO: *L007* */
/*  Revision:       By: Suhas Bhargav  Date: 05/09/98  Rel: 8.6e  ECO: *J2JB* */
/*  Revision:       By: Alfred Tan     Date: 05/20/98  Rel: 8.6e  ECO: *K1Q4* */
/*  Revision:       By: Edwin Janse    Date: 06/30/98  Rel: 8.6e  ECO: *L01R* */
/*  Revision:       By: Vijaya Pakala  Date: 07/31/98  Rel: 8.6e  ECO: *H1MQ* */
/*  Revision:       By: Hemanth Ebene  Date: 03/10/99  Rel: 9.0   ECO: *M0B8* */
/*  Revision:       By: Alfred Tan     Date: 03/13/99  Rel: 9.0   ECO: *M0BD* */
/*  Revision:       By: Brian Compton  Date: 05/18/99  Rel: 9.1   ECO: *N03S* */
/*  Revision:       By: B. Gates       Date: 01/28/00  Rel: 9.1   ECO: *N06R* */
/*  Revision:       By: Falguni Dalal  Date: 04/26/00  Rel: 9.1   ECO: *M0LS* */
/* REVISION: 9.1    LAST MODIFIED: 08/17/00 BY: *N0LJ* Mark Brown             */
/* Revision: 1.22      BY:Fred Yeadon   DATE: 09/29/01  ECO: *M18S*           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.23      BY: Rajaneesh S.   DATE: 08/29/02  ECO: *M1BY*         */
/* $Revision: 1.26 $  BY: Paul Donnelly  DATE: 07/01/03  ECO: *Q00H*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i "new global"}

/*** alonb ***/
{slib/slibpro.i}

DEFINE VAR cFileName AS CHAR NO-UNDO.
/*** alonb ***/

/*AT STARTUP, BEFORE USER IS ESTABLISHED*/
/*USE THE SYSTEM DOMAIN AS THE CURRENT SESSION DOMAIN.*/
/*IF NO SYSTEM DOMAIN IS PRESENT, USE THE CONSTANT - QAD */
for first dom_mstr
fields (dom_domain dom_type)
no-lock
where dom_type = "SYSTEM":
    global_domain = dom_domain.
end.
if global_domain = "" then
    global_domain = "QAD".

{eddmnset.i}
{pxsevcon.i}


/* THE FOLLOWING VARIABLE MUST NOT BE DEFINED AS GLOBAL
* IN ORDER FOR MFDEMO.I TO WORK */
define new shared variable menu as character.
define new shared variable menu_log as decimal.

define new shared variable h_mfinitpl as handle no-undo.

{mf1.i "new global"}
{wbgp03.i &new=" new shared "}
{pxgblmgr.i "new global"}

/*
* RESET MODE FOR USER INTERFACE IN CASE
* IT WAS PREVIOUSLY SET TO API
*/

assign c-application-mode = "".

/*SET GLOBAL_USERID*/

/*V8+*/

     
get-key-value section "mfgpro" key "mfguserid" value global_userid.
if global_userid = ?
or global_userid = ""
then do:
   global_userid = "".
end. /* IF global_userid .... */
  

/*SET LANGUAGE CODE*/

for first gl_ctrl
   fields(gl_domain gl_lang)
   no-lock
where gl_domain = global_domain:
end. /* FOR FIRST gl_ctrl */

if available gl_ctrl
then
   global_user_lang = gl_lang.
else
   global_user_lang = "US".

assign
   global_user_lang_nbr = 1
   global_user_lang_dir = "".

{mflang.i}

/*CHECK DEMO EXPIRATION*/
{mfdemo.i 01/01/1900 01/01/9999}

/*NOT SURE WHAT THIS IS FOR*/
assign menu_log = 55702683.14.

/*LOAD THE INITIALIZATION PROCEDURE LIBRARY*/
run mfinitpl.p persistent set h_mfinitpl.

/*LOAD THE PROJECTX PROCEDURE LIBRARIES*/

run pxtools.p persistent.
run pxgblmgr.p persistent set global_gblmgr_handle.

/*SET THE MESSAGE HANDLER IN MFINITPL.P TO THIS PROCEDURE
SO IT WILL RUN THE PROCEDURE REGISTERREASONMESSAGE BELOW*/

run setMessageHandlerHandle in h_mfinitpl(this-procedure).

/*SET GLOBAL_DB*/

run setGlobalDB in h_mfinitpl.


/* CALL THE BROWSE MANAGER */
{gprun.i 'gpbrqgen.p' persistent}
/*GUI*/ if global-beam-me-up then undo, leave.


/* CHECK LENGTH OF USER ID */
do on error undo, leave:
   run checkUserIDLength in h_mfinitpl.
end. /* DO ON ERROR */

if return-value = {&APP-ERROR-RESULT}
then do:
   /*V8+*/
   quit.
end. /* IF return-value = {&APP-ERROR-RESULT} */

/* NOW CALL THE TRANSLATABLE PORTION OF THE (OLD) MF1.P */
/*** alonb ***
{gprun1.i ""mf1a.p""}
*** alonb ***/

/*** alonb ***/
cFileName = pro_getRunFile( "slib/qad_batch_gui3_eb21.p" ).

/***
if cFileName = ? then
   cFileName = pro_getRunFile( "qad_batch_gui3_eb21.p" ).

if cFileName = ? then
   cFileName = pro_getRunFile( "xx/qad_batch_gui3_eb21.p" ).

if cFileName = ? then
   cFileName = pro_getRunFile( "us/xx/qad_batch_gui3_eb21.p" ).
***/

run value( cFileName ).
/*** alonb ***/



PROCEDURE registerReasonMessage:
/*------------------------------------------------------------------
Purpose:    Message handler for mfinitpl.p procedures
Exceptions:
Notes:
History:
------------------------------------------------------------------*/

   define input parameter pMessageNumber      as integer   no-undo.
   define input parameter pMessageDescription as character no-undo.
   define input parameter pMessageSeverity    as integer   no-undo.

   define variable severity as integer no-undo.

   severity = pMessageSeverity.
   if severity = 3
   then
      severity = 4. /*DON'T WANT "PLEASE RE-ENTER"*/

   if pMessageDescription > ''
   then do:
      {pxmsg.i &MSGTEXT=pMessageDescription &ERRORLEVEL=pMessageSeverity}
   end. /* IF pMessageDescription > "" */
   else do:
      {pxmsg.i &MSGNUM=pMessageNumber &ERRORLEVEL=pMessageSeverity}
   end. /* ELSE DO: */
END PROCEDURE.
