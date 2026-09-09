&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE ITEM-3 NO-UNDO LIKE FacDPedi.



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
DEFINE INPUT PARAMETER C-NRODOC AS CHAR.
DEFINE INPUT PARAMETER C-CODDOC AS CHAR.
/* Local Variable Definitions ---                                       */
/* DEFINE NEW SHARED TEMP-TABLE PEDI LIKE FacDPedi.    */
/* DEFINE NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi. */
DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "PED".
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CODIGV   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE NEW SHARED VARIABLE S-TIPVTA   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE NEW SHARED VARIABLE S-TPOCMB AS DECIMAL. /*******/
DEFINE NEW SHARED VARIABLE s-IMport-IBC AS LOG.
DEFINE NEW SHARED VARIABLE s-NroCot AS CHAR.
DEFINE NEW SHARED VAR s-adm-new-record AS CHAR.

DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.
S-CODDOC = C-CODDOC.

DEFINE BUFFER B-CPEDI FOR FacCPedi.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

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
&Scoped-Define ENABLED-OBJECTS B-Rechaza B-Aprobar B-Consulta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-pedido-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedcon AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-pedido-3 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Aprobar 
     LABEL "APROBAR" 
     SIZE 19.72 BY 1
     FONT 1.

DEFINE BUTTON B-Consulta 
     IMAGE-UP FILE "img\calendar":U
     LABEL "Cuenta Corriente" 
     SIZE 5.72 BY 1.12.

DEFINE BUTTON B-Rechaza 
     LABEL "RECHAZAR" 
     SIZE 19.72 BY 1.04
     FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     B-Rechaza AT ROW 23.88 COL 9
     B-Aprobar AT ROW 23.88 COL 30
     B-Consulta AT ROW 23.88 COL 52
     SPACE(54.84) SKIP(0.34)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "<insert SmartDialog title>".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-2 T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-3 T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Aprobar D-Dialog
ON CHOOSE OF B-Aprobar IN FRAME D-Dialog /* APROBAR */
DO:
  MESSAGE 'Aprobar Documento' VIEW-AS ALERT-BOX 
          QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
  IF x-rpta THEN RUN Aprobar-Cotizacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Consulta D-Dialog
ON CHOOSE OF B-Consulta IN FRAME D-Dialog /* Cuenta Corriente */
DO:
  RUN vta\d-concli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Rechaza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Rechaza D-Dialog
ON CHOOSE OF B-Rechaza IN FRAME D-Dialog /* RECHAZAR */
DO:
  MESSAGE 'Rechazar Documento' VIEW-AS ALERT-BOX 
          QUESTION BUTTONS YES-NO UPDATE x-rpta AS LOGICAL.
  IF x-rpta THEN RUN Rechazar-Cotizacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
DEFINE VAR WTITULO AS CHAR.
IF C-CODDOC = "COT" THEN WTITULO = "Cotización".
IF C-CODDOC = "PED" THEN WTITULO = "Pedido".

ASSIGN FRAME {&FRAME-NAME}:TITLE = WTITULO.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/v-pedido-3.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-pedido-3 ).
       RUN set-position IN h_v-pedido-3 ( 1.00 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.23 , 100.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/b-pedido-3.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pedido-3 ).
       RUN set-position IN h_b-pedido-3 ( 11.23 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pedido-3 ( 12.31 , 109.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/q-pedcon.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedcon ).
       RUN set-position IN h_q-pedcon ( 23.88 , 61.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 14.86 ) */

       /* Links to SmartViewer h_v-pedido-3. */
       RUN add-link IN adm-broker-hdl ( h_q-pedcon , 'Record':U , h_v-pedido-3 ).

       /* Links to SmartBrowser h_b-pedido-3. */
       RUN add-link IN adm-broker-hdl ( h_q-pedcon , 'Record':U , h_b-pedido-3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-pedido-3 ,
             B-Rechaza:HANDLE , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pedido-3 ,
             h_v-pedido-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedcon ,
             B-Consulta:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Cotizacion D-Dialog 
PROCEDURE Aprobar-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia 
        AND  B-CPEDI.Coddoc = S-CODDOC 
        AND  B-CPEDI.NroPed = C-NRODOC 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN RETURN 'ADM-ERROR'.
    /* Buscamos deudas pendientes */
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL,LET,N/D,CHQ') > 0
        AND Ccbcdocu.flgest = 'P'
        AND Ccbcdocu.codcli = B-CPEDI.codcli
        AND Ccbcdocu.fchvto + 1 < TODAY
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'El cliente tiene una deuda atrazada:' SKIP
            'Documento:' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
            'Vencimiento:' Ccbcdocu.fchvto SKIP
            'Continúa con la aprobación?'
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO
            UPDATE Rpta AS LOG.
        IF Rpta = NO THEN DO: 
            RELEASE B-CPEDI.
            RETURN 'ADM-ERROR'.
        END.
    END.
    ASSIGN
        B-CPEDI.Flgest = 'P'
        B-CPEDI.UsrAprobacion = s-user-id
        B-CPEDI.FchAprobacion = TODAY.
    FOR EACH FacDPedi OF B-CPEDI :
        ASSIGN FacDPedi.Flgest = B-CPEDI.Flgest.    /* <<< OJO <<< */
    END.

    /* TRACKING */
    s-FechaT = DATETIME(TODAY, MTIME).

    /* Control de tracking por cada almacen */
    FOR EACH Facdpedi OF B-CPEDI NO-LOCK,
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = Facdpedi.almdes
        BREAK BY Almacen.coddiv:
        IF FIRST-OF(Almacen.coddiv) THEN DO:
            /* TRACKING */
            s-FechaT = DATETIME(TODAY, MTIME).
        END.
    END.

    RELEASE B-CPEDI.
    RUN dispatch IN h_v-pedido-3 ('display-fields':U).
  END.

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
  ENABLE B-Rechaza B-Aprobar B-Consulta 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND FacCPedi WHERE FacCPedi.CodCia = s-codcia 
                 AND  FacCPedi.CodDoc = C-CODDOC 
                 AND  FacCPedi.NroPed = C-NRODOC 
                NO-LOCK NO-ERROR.
  IF AVAILABLE FacCPedi THEN S-CODCLI = FacCPedi.codcli.
  
  RUN Recibe-Parametros IN h_q-pedcon (C-NRODOC,C-CODDOC).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar-Cotizacion D-Dialog 
PROCEDURE Rechazar-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia 
        AND B-CPEDI.Coddoc = S-CODDOC 
        AND B-CPEDI.NroPed = C-NRODOC 
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN RETURN 'ADM-ERROR'.
    ASSIGN
        B-CPEDI.Flgest = 'R'.
    /* TRACKING */
    s-FechaT = DATETIME(TODAY, MTIME).
    RUN vta/pFlujoPedido (s-CodCia,
                          s-CodDiv,
                          'ANP',
                          s-User-Id,
                          B-CPEDI.CodDoc,
                          B-CPEDI.NroPed,
                          'S',
                          'IO',
                          s-FechaI,
                          s-FechaT).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RELEASE B-CPEDI.
    RUN dispatch IN h_v-pedido-3 ('display-fields':U).
END.

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

