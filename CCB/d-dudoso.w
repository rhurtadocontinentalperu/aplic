&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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
DEF OUTPUT PARAMETER pOk AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

pOk = 'ADM-ERROR'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.FchDoc CcbCDocu.ImpTot CcbCDocu.SdoAct 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH CcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH CcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog CcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX_CodDoc FILL-IN_NroDoc Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.FchDoc CcbCDocu.ImpTot CcbCDocu.SdoAct 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDoc FILL-IN_NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "x(3)" INITIAL "FAC" 
     LABEL "Codigo" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "FAC","BOL","LET","N/D","N/C","CHQ","DCO" 
     DROP-DOWN-LIST
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "X(12)" 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     COMBO-BOX_CodDoc AT ROW 1.38 COL 14 COLON-ALIGNED
     FILL-IN_NroDoc AT ROW 2.35 COL 14 COLON-ALIGNED
     CcbCDocu.CodCli AT ROW 3.31 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     CcbCDocu.NomCli AT ROW 4.27 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.FchDoc AT ROW 5.23 COL 14 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.ImpTot AT ROW 6.19 COL 14 COLON-ALIGNED
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     CcbCDocu.SdoAct AT ROW 7.19 COL 14 COLON-ALIGNED
          LABEL ""
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     Btn_OK AT ROW 8.5 COL 4
     Btn_Cancel AT ROW 8.5 COL 18
     SPACE(40.56) SKIP(0.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DOCUMENTO A COBRANZA DUDOSA"
         CANCEL-BUTTON Btn_Cancel.


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

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FchDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.SdoAct IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* DOCUMENTO A COBRANZA DUDOSA */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN COMBO-BOX_CodDoc FILL-IN_NroDoc.
  /* Validacion */
  FIND ccbcdocu WHERE codcia = s-codcia
    AND coddoc = COMBO-BOX_CodDoc
    AND nrodoc = FILL-IN_NroDoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbcdocu THEN DO:
    MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF ccbcdocu.flgest <> 'P' THEN DO:
    MESSAGE 'El documento NO esta pendiente de cancelación' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  MESSAGE 'Desea proceder a pasar el documento a Cobranza Dudosa?' 
    VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
  IF Rpta = NO THEN RETURN NO-APPLY.
  FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN NO-APPLY.
  ASSIGN
    CcbCDocu.FchUbiA = CcbCDocu.FchUbi
    CcbCDocu.FchAct = TODAY
    CcbCDocu.FchUbi = TODAY
    CcbCDocu.FlgEst = 'J'
    CcbCDocu.usuario = s-user-id.
  /* RHC 23.11.2010 CONTROL CONTABLE */
  CREATE CcbDMvto.
  ASSIGN
      CcbDMvto.CodCia = Ccbcdocu.codcia
      CcbDMvto.CodCli = Ccbcdocu.codcli
      CcbDMvto.CodDiv = Ccbcdocu.coddiv
      CcbDMvto.CodDoc = "DCD"       /* Dcumento Cobranza Dudosa */
      CcbDMvto.NroDoc = Ccbcdocu.nrodoc
      CcbDMvto.CodRef = Ccbcdocu.coddoc
      CcbDMvto.NroRef = Ccbcdocu.nrodoc
      CcbDMvto.FchEmi = TODAY
      CcbDMvto.ImpTot = Ccbcdocu.imptot
      CcbDMvto.usuario = s-user-id
      CcbDMvto.FlgCbd = NO.
  RELEASE Ccbcmvto.
  /* FIN DE CONTROL CONTABLE */
  RELEASE ccbcdocu.
  pOk = 'OK'.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroDoc D-Dialog
ON LEAVE OF FILL-IN_NroDoc IN FRAME D-Dialog /* Numero */
DO:
  FIND ccbcdocu WHERE codcia = s-codcia
    AND coddoc = COMBO-BOX_CodDoc:SCREEN-VALUE
    AND nrodoc = FILL-IN_NroDoc:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  ASSIGN
    CcbCDocu.CodCli:SCREEN-VALUE = ''
    CcbCDocu.FchDoc:SCREEN-VALUE = ''
    CcbCDocu.ImpTot:SCREEN-VALUE = ''
    CcbCDocu.NomCli:SCREEN-VALUE = ''
    CcbCDocu.SdoAct:SCREEN-VALUE = ''.
  IF AVAILABLE ccbcdocu THEN DO:
    DISPLAY CcbCDocu.CodCli CcbCDocu.FchDoc CcbCDocu.ImpTot CcbCDocu.NomCli 
                CcbCDocu.SdoAct WITH FRAME {&FRAME-NAME}.
    IF ccbcdocu.codmon = 1
    THEN ASSIGN
            CcbCDocu.ImpTot:LABEL = 'Importe Total S/.'
            CcbCDocu.SdoAct:LABEL = 'Saldo Actual S/.'.
    ELSE ASSIGN
            CcbCDocu.ImpTot:LABEL = 'Importe Total US$'
            CcbCDocu.SdoAct:LABEL = 'Saldo Actual US$'.
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
  DISPLAY COMBO-BOX_CodDoc FILL-IN_NroDoc 
      WITH FRAME D-Dialog.
  IF AVAILABLE CcbCDocu THEN 
    DISPLAY CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc CcbCDocu.ImpTot 
          CcbCDocu.SdoAct 
      WITH FRAME D-Dialog.
  ENABLE COMBO-BOX_CodDoc FILL-IN_NroDoc Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

