&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE BUFFER B-RutaD FOR DI-RutaD.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF INPUT PARAMETER pCodPHR AS CHAR.
DEF INPUT PARAMETER pNroPHR AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

FIND DI-RutaC WHERE DI-RutaC.CodCia = s-CodCia AND 
    DI-RutaC.CodDiv = s-CodDiv AND 
    DI-RutaC.CodDoc = pCodPHR AND 
    DI-RutaC.NroDoc = pNroPHR
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE DI-RutaC THEN RETURN.
IF NOT LOOKUP(DI-RutaC.FlgEst, 'PF,PX,PK') > 0 THEN RETURN.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc ~
FILL-IN-CodCli FILL-IN-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "O/D" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(15)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX-CodDoc AT ROW 1.81 COL 10 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 2.88 COL 10 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CodCli AT ROW 3.96 COL 10 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NomCli AT ROW 5.04 COL 10 COLON-ALIGNED WIDGET-ID 8
     Btn_OK AT ROW 6.65 COL 3
     Btn_Cancel AT ROW 6.65 COL 18
     SPACE(32.13) SKIP(1.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "INGRESE ORDEN REPROGRAMADA"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
   END-TABLES.
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

/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* INGRESE ORDEN REPROGRAMADA */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN COMBO-BOX-CodDoc FILL-IN-NroDoc.
  /* Validación */
  IF TRUE <> (FILL-IN-NroDoc > '') THEN DO:
      MESSAGE 'Debe ingresar la Orden' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-NroDoc.
      RETURN NO-APPLY.
  END.
  /* Debe estar Reprogramado */
  FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
      Almcdocu.codllave = s-coddiv AND
      Almcdocu.coddoc = COMBO-BOX-CodDoc AND
      Almcdocu.nrodoc = FILL-IN-NroDoc AND
      Almcdocu.flgest = "C"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcdocu THEN DO:
      MESSAGE 'Reprogramación NO aprobada' VIEW-AS ALERT-BOX ERROR.
      FILL-IN-NroDoc:SCREEN-VALUE = ''.
      APPLY 'ENTRY':U TO FILL-IN-NroDoc.
      RETURN NO-APPLY.
  END.
  FIND FIRST B-RutaD WHERE B-RutaD.codcia = s-codcia AND
      B-RutaD.coddiv = s-coddiv AND
      B-RutaD.coddoc = pCodPHR AND
      B-RutaD.CodRef = COMBO-BOX-CodDoc AND
      B-RutaD.NroRef = FILL-IN-NroDoc AND
      CAN-FIND(FIRST B-RutaC OF B-RutaD WHERE B-RutaC.FlgEst = "C" NO-LOCK)
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-RutaD THEN DO:
      MESSAGE 'Este documento YA ha sido reprogramado anteriormente' SKIP
          'Continuamos?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          FILL-IN-NroDoc:SCREEN-VALUE = ''.
          APPLY 'ENTRY':U TO FILL-IN-NroDoc.
          RETURN NO-APPLY.
      END.
  END.
  RUN Graba-Registro.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al grabar la orden'.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDoc D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-CodDoc IN FRAME D-Dialog /* Documento */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc D-Dialog
ON LEAVE OF FILL-IN-NroDoc IN FRAME D-Dialog /* Número */
DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.
  ASSIGN {&self-name}.
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
      Faccpedi.divdes = s-coddiv AND
      Faccpedi.coddoc = COMBO-BOX-CodDoc AND
      Faccpedi.nroped = FILL-IN-NroDoc AND
      Faccpedi.flgest = "F"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Documento NO encontrado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* Debe estar Reprogramado */
  FIND FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia AND
      Almcdocu.codllave = s-coddiv AND
      Almcdocu.coddoc = Faccpedi.coddoc AND
      Almcdocu.nrodoc = Faccpedi.nroped AND
      Almcdocu.flgest = "C"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcdocu THEN DO:
      MESSAGE 'Documento NO reprogramado' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
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
  DISPLAY COMBO-BOX-CodDoc FILL-IN-NroDoc FILL-IN-CodCli FILL-IN-NomCli 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX-CodDoc FILL-IN-NroDoc Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro D-Dialog 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Verificamos que la PHR sea la correcta */
    {lib/lock-genericov3.i ~
        &Tabla="DI-RutaC" ~
        &Condicion="DI-RutaC.CodCia = s-CodCia AND ~
        DI-RutaC.CodDiv = s-CodDiv AND ~
        DI-RutaC.CodDoc = pCodPHR AND ~
        DI-RutaC.NroDoc = pNroPHR" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TxtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF NOT LOOKUP(DI-RutaC.FlgEst, 'PF,PX,PK') > 0 THEN DO:
        pMensaje = "La " + pCodPHR + " " + pNroPHR + " ya no es válida" + CHR(10) +
            "Estado = " + DI-RutaC.FlgEst.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Verificamos que NO esté en otra PHR en trámite */
    FIND FIRST DI-RutaD OF DI-RutaC WHERE DI-RutaD.CodRef = COMBO-BOX-CodDoc AND
        DI-RutaD.NroDoc = FILL-IN-NroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE DI-RutaD THEN DO:
        pMensaje = "Documento Repetido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND FIRST B-RutaD WHERE B-RutaD.codcia = s-codcia AND
        B-RutaD.coddiv = s-coddiv AND
        B-RutaD.coddoc = pCodPHR AND
        B-RutaD.CodRef = COMBO-BOX-CodDoc AND
        B-RutaD.NroRef = FILL-IN-NroDoc AND
        CAN-FIND(FIRST B-RutaC OF B-RutaD WHERE LOOKUP(B-RutaC.FlgEst, 'PX,PK,PF,P') > 0 NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-RutaD THEN DO:
        pMensaje = "El documento se encuentra registrado en la " + B-RutaD.CodDoc + " " + B-RutaD.NroDoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF AVAILABLE DI-RutaD THEN DO:
        pMensaje = "Documento Repetido".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* NO debe reprogramarse mas de tres veces */
    DEF VAR iVeces AS INT NO-UNDO.
    FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.codcia = s-codcia AND
        B-RutaD.coddiv = s-coddiv AND
        B-RutaD.coddoc = pCodPHR AND
        B-RutaD.CodRef = COMBO-BOX-CodDoc AND
        B-RutaD.NroRef = FILL-IN-NroDoc AND
        CAN-FIND(FIRST B-RutaC OF B-RutaD WHERE B-RutaC.FlgEst = "C" NO-LOCK):
        iVeces = iVeces + 1.
    END.
    IF iVeces >= 3 THEN DO:
        MESSAGE 'NO se puede reprogramar mas de tres veces' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************** */
    /* Grabamos */
    CREATE DI-RutaD.
    BUFFER-COPY DI-RutaC TO DI-RutaD
        ASSIGN
        DI-RutaD.CodRef = COMBO-BOX-CodDoc 
        DI-RutaD.NroRef = FILL-IN-NroDoc.
    RELEASE DI-RutaD.
END.
RETURN 'OK'.

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

