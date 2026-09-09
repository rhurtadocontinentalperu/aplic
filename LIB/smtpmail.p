&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/*
Progress Solution 

 
ID: P28320 
Title: "How to send an e-mail with attachments using Outlook from the 4GL?" 
Created: 27-Jun-2003             Last Modified: 25-Nov-2003 
Status: Verified 

Goal(s): 
How to send an e-mail with attachments using Outlook from the 4GL? 
*/
 
DEFINE VARIABLE objOutlook       AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE objOutlookMsg    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE objOutlookAttach AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE objOutlookRecip  AS COM-HANDLE NO-UNDO.

CREATE "Outlook.Application" objOutlook.

objoutlookMsg         = objOutlook:CreateItem(0).
objOutlookRecip       = objOutlookMsg:Recipients:Add("youremail@yourmailserver.com").
objOutlookRecip:Type  = 1.
objOutlookMsg:Subject = "Your Subject".
objOutlookMsg:Body    = "The Body".

objOutlookMsg:Attachments:Add("c:\autoexec.bat").
objOutlookRecip:Resolve.
objOutlookMsg:Send.
objoutlook:Quit().

RELEASE OBJECT objOutlook.
RELEASE OBJECT objOutlookMsg.
RELEASE OBJECT objOutlookRecip.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


