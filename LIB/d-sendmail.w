&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pEmailFrom AS CHAR.
DEF INPUT PARAMETER pEmailTo AS CHAR.
DEF INPUT PARAMETER pSubject AS CHAR.
DEF INPUT PARAMETER pAttach AS CHAR.    /* Archivo */
DEF INPUT PARAMETER pBody   AS CHAR.    /* Archivo texto */

/* Local Variable Definitions ---                                       */


/* Buscamos los parámetros de acuerdo al usuario */
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR lEmailFrom AS CHAR NO-UNDO.
DEF VAR lEmailCC   AS CHAR NO-UNDO.
DEF VAR lEmailCCO  AS CHAR NO-UNDO.
DEF VAR lSmtpMail  AS CHAR NO-UNDO.
DEF VAR lEmailUser AS CHAR NO-UNDO.
DEF VAR lEmailPassword AS CHAR NO-UNDO.
DEF VAR lAttach AS CHAR NO-UNDO.

ASSIGN
    lEmailFrom      = pEmailFrom
    lSmtpMail       = "mail.continentalperu.com"
    lEmailUser      = "ciman@continentalperu.com"
    lEmailPassword  = "@Sistemas09"
    .

FOR EACH emailconfig NO-LOCK WHERE emailconfig.Codcia = s-codcia:
    IF LOOKUP(s-user-id, emailconfig.Usuarios) > 0 THEN DO:
        IF TRUE <> (lEmailFrom > '') THEN lEmailFrom = emailconfig.EmailFrom.
        ELSE DO:
            /* Que no esté ya registrado */
            IF LOOKUP(emailconfig.EmailFrom,lEmailFrom) = 0 
                THEN lEmailFrom = lEmailFrom + "," + emailconfig.EmailFrom.
        END.
        IF TRUE <> (lEmailCC > '') THEN lEmailCC = emailconfig.EmailCC.
        ELSE DO:
            /* Que no esté ya registrado */
            IF LOOKUP(emailconfig.EmailCC,lEmailCC) = 0 
                THEN lEmailCC = lEmailCC + "," + emailconfig.EmailCC.
        END.
        IF TRUE <> (lEmailCCO > '') THEN lEmailCCO = emailconfig.EmailCCO + "^B".
        ELSE DO:
            /* Que no esté ya registrado */
            IF LOOKUP(emailconfig.EmailCCO,lEmailCCO) = 0 
                THEN lEmailCCO = lEmailCCO + "," + emailconfig.EmailCCO + "^B".
        END.
        IF emailconfig.SmtpMail > ''      THEN lSmtpMail = emailconfig.SmtpMail.
        IF emailconfig.EmailUser > ''     THEN lEmailUser = emailconfig.EmailUser.
        IF emailconfig.EmailPassword > '' THEN lEmailPassword = emailconfig.EmailPassword.
    END.
END.

IF TRUE <> (lEmailFrom > '') THEN DO:
    MESSAGE 'El usuario no está configurado para enviar correos' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK BUTTON-Attach Btn_Cancel ~
COMBO-BOX-From FILL-IN-To FILL-IN-CC FILL-IN-Subject EDITOR-Body 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-From FILL-IN-To FILL-IN-CC ~
FILL-IN-Subject FILL-IN-Attach EDITOR-Body 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnOK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img/email.ico":U
     LABEL "OK" 
     SIZE 7 BY 1.88 TOOLTIP "Enviar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancel" 
     SIZE 7 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Attach 
     IMAGE-UP FILE "img/email-attachment.ico":U
     LABEL "ADJUNTO" 
     SIZE 7 BY 1.88 TOOLTIP "Adjuntar archivo".

DEFINE VARIABLE COMBO-BOX-From AS CHARACTER FORMAT "X(256)":U 
     LABEL "De" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE EDITOR-Body AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 137 BY 16.69
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-Attach AS CHARACTER FORMAT "X(256)":U 
     LABEL "Adjunto" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CC AS CHARACTER FORMAT "X(256)":U 
     LABEL "CC" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Subject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Asunto" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-To AS CHARACTER FORMAT "X(256)":U 
     LABEL "Para" 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BtnOK AT ROW 1 COL 2 WIDGET-ID 44
     BUTTON-Attach AT ROW 1 COL 9 WIDGET-ID 18
     Btn_Cancel AT ROW 1 COL 16 WIDGET-ID 58
     COMBO-BOX-From AT ROW 3.15 COL 8 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-To AT ROW 4.23 COL 8 COLON-ALIGNED WIDGET-ID 54
     FILL-IN-CC AT ROW 5.31 COL 8 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-Subject AT ROW 6.38 COL 8 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-Attach AT ROW 7.46 COL 8 COLON-ALIGNED WIDGET-ID 28
     EDITOR-Body AT ROW 8.54 COL 2 NO-LABEL WIDGET-ID 20
     SPACE(1.28) SKIP(0.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Envío de correo" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Attach IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Envío de correo */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK D-Dialog
ON CHOOSE OF BtnOK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN COMBO-BOX-From FILL-IN-To EDITOR-Body FILL-IN-Attach FILL-IN-CC FILL-IN-Subject.
  DEF VAR k AS INT NO-UNDO.
  DEF VAR x-Correo AS CHAR NO-UNDO.

  IF TRUE <> (FILL-IN-To > '') THEN DO:
      MESSAGE 'Ingrese el destino' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-To.
      RETURN NO-APPLY.
  END.
  IF FILL-IN-To > '' THEN DO:
      DO k = 1 TO NUM-ENTRIES(FILL-IN-To):
          x-Correo = ENTRY(k,FILL-IN-To).
          IF NUM-ENTRIES(x-Correo, '@') <> 2 THEN DO:
                MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FILL-IN-To.
                RETURN NO-APPLY.
            END.
      END.
  END.
  IF FILL-IN-CC > '' THEN DO:
      DO k = 1 TO NUM-ENTRIES(FILL-IN-CC):
          x-Correo = ENTRY(k,FILL-IN-CC).
          IF NUM-ENTRIES(x-Correo, '@') <> 2 THEN DO:
                MESSAGE 'Correo mal registrado' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO FILL-IN-CC.
                RETURN NO-APPLY.
            END.
      END.
  END.
  IF TRUE <> (FILL-IN-Subject > '') THEN DO:
      MESSAGE 'Desea enviar el mensaje sin asunto?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO FILL-IN-Subject.
          RETURN NO-APPLY.
      END.
  END.
  RUN SendMail.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Attach
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Attach D-Dialog
ON CHOOSE OF BUTTON-Attach IN FRAME D-Dialog /* ADJUNTO */
DO:
  lAttach = pAttach.
  DEF VAR rpta AS LOG NO-UNDO.
  SYSTEM-DIALOG 
      GET-FILE lAttach 
      TITLE 'Seleccione el archivo'
      USE-FILENAME
      UPDATE rpta.
  IF rpta = NO THEN RETURN NO-APPLY.
  FILL-IN-Attach:SCREEN-VALUE = lAttach.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY COMBO-BOX-From FILL-IN-To FILL-IN-CC FILL-IN-Subject FILL-IN-Attach 
          EDITOR-Body 
      WITH FRAME D-Dialog.
  ENABLE BtnOK BUTTON-Attach Btn_Cancel COMBO-BOX-From FILL-IN-To FILL-IN-CC 
         FILL-IN-Subject EDITOR-Body 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-From:ADD-LAST(lEmailFrom).
      ASSIGN
          COMBO-BOX-From  = ENTRY(1,lEmailFrom)
          FILL-IN-To      = pEmailTo
          FILL-IN-CC      = lEmailCC
          FILL-IN-Subject = pSubject
          FILL-IN-Attach  = pAttach.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF pBody > '' THEN EDITOR-Body:INSERT-FILE(pBody).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SendMail D-Dialog 
PROCEDURE SendMail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR lEmailCC AS CHAR NO-UNDO.
DEF VAR lAttachments AS CHAR NO-UNDO.
DEF VAR lLocalFiles AS CHAR NO-UNDO.
DEF VAR lSeparador AS CHAR NO-UNDO.

lEmailCC = FILL-IN-CC.
IF lEmailCCO > '' THEN lEmailCC = lEmailCC + (IF TRUE <> (lEmailCC > '') THEN '' ELSE ',') +
    lEmailCCO.
IF FILL-IN-Attach > '' THEN DO:
    FILE-INFO:FILE-NAME = FILL-IN-Attach.
    IF FILE-INFO:TYPE <> ? THEN DO:
        IF INDEX(FILL-IN-Attach, '/') > 0 THEN lSeparador = '/'.
        IF INDEX(FILL-IN-Attach, '\') > 0 THEN lSeparador = '\'.
        lAttachments = ENTRY(NUM-ENTRIES(FILL-IN-Attach,lSeparador),FILL-IN-Attach,lSeparador).
        lAttachments = lAttachments + ":filetype=BINARY".
        lLocalFiles = FILE-INFO:FULL-PATHNAME.
    END.
END.

{lib/sendmail.i ~
    &SmtpMail=lSmtpmail ~
    &EmailFrom=COMBO-BOX-From ~
    &EmailTO=FILL-IN-To ~
    &EmailCC=lEmailCC ~
    &Attachments=lAttachments ~
    &LocalFiles=lLocalFiles  ~
    &Subject=FILL-IN-Subject ~
    &Body=EDITOR-Body ~
    &xUser=lEmailUser ~
    &xPass=lEmailPassword ~    
    }
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

