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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.

/* Local Variable Definitions ---                                       */
DEF INPUT PARAMETER s-coddoc AS CHAR.
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pCodOrigen AS CHAR.
DEF OUTPUT PARAMETER pNroOrigen AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = 'ADM-ERROR'.

DEF VAR s-nroser AS INTE NO-UNDO.
DEF VAR s-adm-new-record AS LOG NO-UNDO.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDoc = s-coddoc AND
    FacCorre.CodDiv = s-coddiv AND 
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO se encontró el correlativo para el documento' s-coddoc SKIP
        'Proceso abortado'.
    RETURN.
END.

s-NroSer = FacCorre.NroSer.
s-adm-new-record = YES.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN DO:
    MESSAGE 'Registro NO encontrado' SKIP 'Proceso Abortado'.
    RETURN.
END.

FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.coddoc
    AND Ccbcdocu.nroped = Faccpedi.nroped
    AND Ccbcdocu.coddoc = s-coddoc
    AND Ccbcdocu.flgest = 'P'
    AND Ccbcdocu.imptot = Ccbcdocu.sdoact
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN s-adm-new-record = NO.

DEF VAR x-ImpTope AS DECI NO-UNDO.

x-ImpTope = Faccpedi.ImpTot.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN_Libre_c01 FILL-IN_Libre_c02 ~
FILL-IN_ImpTot Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_CodCli FILL-IN_NomCli FILL-IN_DNI ~
FILL-IN_CodCob FILL-IN_NomOper FILL-IN_Libre_c01 FILL-IN_Libre_c02 ~
COMBO-BOX_CodMon FILL-IN_ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/error.ico":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/ok.ico":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_CodMon AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "S/.",1,
                     "US$",2
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCob AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operador" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DNI AS CHARACTER FORMAT "X(256)":U 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Libre_c01 AS CHARACTER FORMAT "X(25)":U 
     LABEL "ID Contrato" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Libre_c02 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido Venta" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomOper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Razón Social" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_CodCli AT ROW 1.54 COL 17 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_NomCli AT ROW 1.54 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN_DNI AT ROW 2.88 COL 17 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_CodCob AT ROW 4.23 COL 17 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_NomOper AT ROW 5.58 COL 17 COLON-ALIGNED WIDGET-ID 10
     FILL-IN_Libre_c01 AT ROW 6.92 COL 17 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_Libre_c02 AT ROW 8.27 COL 17 COLON-ALIGNED WIDGET-ID 12
     COMBO-BOX_CodMon AT ROW 9.62 COL 17 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_ImpTot AT ROW 10.96 COL 17 COLON-ALIGNED WIDGET-ID 6
     Btn_OK AT ROW 12.58 COL 4
     Btn_Cancel AT ROW 12.58 COL 21
     SPACE(45.28) SKIP(0.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "REGISTRO DE CONTRATO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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

/* SETTINGS FOR COMBO-BOX COMBO-BOX_CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCob IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DNI IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomOper IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* REGISTRO DE CONTRATO */
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
  ASSIGN COMBO-BOX_CodMon FILL-IN_CodCob FILL-IN_ImpTot FILL-IN_Libre_c01 
      FILL-IN_Libre_c02 FILL-IN_NomOper.
  ASSIGN FILL-IN_DNI.
  /* Validación */
  IF FILL-IN_ImpTot > x-ImpTope THEN DO:
      MESSAGE 'El importe NO puede superar los' x-ImpTope VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Graba-Registro (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  pMensaje = "OK".
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
  DISPLAY FILL-IN_CodCli FILL-IN_NomCli FILL-IN_DNI FILL-IN_CodCob 
          FILL-IN_NomOper FILL-IN_Libre_c01 FILL-IN_Libre_c02 COMBO-BOX_CodMon 
          FILL-IN_ImpTot 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN_Libre_c01 FILL-IN_Libre_c02 FILL-IN_ImpTot Btn_OK Btn_Cancel 
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
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF s-adm-new-record = YES THEN DO:
        {lib/lock-genericov3.i ~
            &Tabla="FacCorre" ~
            &Alcance="FIRST" ~
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND  FacCorre.CodDiv = s-coddiv ~
            AND  FacCorre.CodDoc = s-coddoc ~
            AND  FacCorre.NroSer = s-NroSer" ~ 
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        CREATE Ccbcdocu.
        ASSIGN
            Ccbcdocu.CodCia = s-codcia 
            Ccbcdocu.CodDiv = s-coddiv
            Ccbcdocu.CodDoc = s-coddoc
            Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        RELEASE FacCorre.
    END.
    ELSE DO:
        FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    ASSIGN
        Ccbcdocu.FchAte = TODAY
        Ccbcdocu.TpoFac = "EFE"
        Ccbcdocu.CodAge = "Lima"
        Ccbcdocu.CodCli = pCodCli
        CcbCDocu.CodAnt = FILL-IN_DNI.
    ASSIGN
        Ccbcdocu.FchDoc = TODAY
        Ccbcdocu.FlgEst = "P"       /* OJO -> APROBADO */
        Ccbcdocu.FlgSit = "Aprobado"
        Ccbcdocu.FchUbi = ?
        Ccbcdocu.FlgUbi = ""
        CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
        Ccbcdocu.usuario= s-user-id.
    ASSIGN
        Ccbcdocu.codmon = COMBO-BOX_CodMon 
        Ccbcdocu.codcob = FILL-IN_CodCob 
        Ccbcdocu.imptot = FILL-IN_ImpTot 
        Ccbcdocu.libre_c01 = FILL-IN_Libre_c01 
        Ccbcdocu.libre_c02 = FILL-IN_Libre_c02
        Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = Ccbcdocu.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN Ccbcdocu.nomcli = gn-clie.nomcli.
    ASSIGN
        CcbCDocu.CodPed = Faccpedi.CodDoc
        CcbCDocu.NroPed = Faccpedi.NroPed.
    ASSIGN
        CcbCDocu.FchUbi = TODAY
        CcbCDocu.FlgUbi = s-user-id.

    FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
    ASSIGN
        pCodOrigen = Ccbcdocu.CodDoc
        pNroOrigen = Ccbcdocu.NroDoc.
END.

RETURN 'OK'.

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
  FILL-IN_CodCli = Faccpedi.codcli.
  FILL-IN_NomCli = Faccpedi.nomcli.
  FILL-IN_CodCob = pCodPro.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = Faccpedi.codcli
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN_DNI = gn-clie.dni.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = FILL-IN_CodCob
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN_NomOper = gn-prov.nompro.
  /* Datos adicionales */
  IF s-adm-new-record = NO THEN DO:
      COMBO-BOX_CodMon = Ccbcdocu.codmon.
      FILL-IN_ImpTot = Ccbcdocu.imptot.
      FILL-IN_Libre_c01 = Ccbcdocu.libre_c01.
      FILL-IN_Libre_c02 = Ccbcdocu.libre_c02.
  END.
  ELSE DO:
      COMBO-BOX_CodMon = Faccpedi.codmon.
      FILL-IN_ImpTot = x-ImpTope.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

