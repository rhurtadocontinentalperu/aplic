&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-ChkTareas FOR ChkTareas.
DEFINE BUFFER b-vtacdocu FOR VtaCDocu.



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

DEFINE INPUT PARAMETER pCoddoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pChequeador AS CHAR.
DEFINE INPUT PARAMETER pCodPer AS CHAR.
DEFINE INPUT PARAMETER pPrioridad AS CHAR.
DEFINE INPUT PARAMETER pEmbalado AS CHAR.
DEFINE INPUT PARAMETER pMesa AS CHAR.
DEFINE OUTPUT PARAMETER pProcesado AS LOG.
DEFINE OUTPUT PARAMETER pItems AS INT.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-msgerror AS CHAR NO-UNDO.
DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.

x-fecha-inicio = TODAY.
x-hora-inicio = STRING(TIME,"HH:MM:SS").

FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia AND
    b-vtacdocu.coddiv = s-CodDiv AND
    b-vtacdocu.codped = pCoddoc AND
    b-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR NO-WAIT.
IF NOT AVAILABLE b-vtacdocu THEN DO:
    MESSAGE "La HPK no existe ó esta bloqueada...verifiquelo!!!".
    RETURN ERROR.
END.

/* BUSCAMOS LA FECHA DE INICIO */
FIND FIRST LogTrkDocs USE-INDEX idx01 WHERE LogTrkDocs.CodCia = s-CodCia AND
    LogTrkDocs.CodDoc = b-Vtacdocu.CodPed AND
    LogTrkDocs.NroDoc = b-Vtacdocu.NroPed AND
    LogTrkDocs.Clave = 'TRCKHPK' AND
    LogTrkDocs.Codigo = 'CK_CI'
    NO-LOCK NO-ERROR.
IF AVAILABLE LogTrkDocs THEN
    ASSIGN
    x-Fecha-Inicio = DATE(LogTrkDocs.Fecha)
    x-Hora-Inicio  = SUBSTRING(ENTRY(2, STRING(LogTrkDocs.Fecha), ' ' ), 1,8).

/* MARCAMOS EL INICIO DE CHEQUEO */
RUN gn/p-log-status-pedidos (b-Vtacdocu.CodPed,
                             b-Vtacdocu.NroPed,
                             'TRCKHPK',
                             'CK_CI',
                             '',
                             ?).


/* MARCAMOS_INICIO:                                                                                */
/* DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, RETURN ERROR:                                 */
/*     /* Marcamos la Tarea como en PROCESO*/                                                      */
/*     FIND FIRST b-ChkTareas WHERE b-ChkTareas.codcia = s-codcia AND                              */
/*         b-ChkTareas.coddiv = s-coddiv AND                                                       */
/*         b-ChkTareas.mesa = pMesa AND                                                            */
/*         b-ChkTareas.coddoc = pCoddoc AND                                                        */
/*         b-ChkTareas.nroped = pNrodoc AND                                                        */
/*         (b-ChkTareas.flgest = 'P' OR b-ChkTareas.flgest = 'X')                                  */
/*         EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                                        */
/*     IF ERROR-STATUS:ERROR = YES THEN DO:                                                        */
/*         x-msgerror = "La tarea(" + pCoddoc + " " + pNrodoc + ") NO esta en la cola de Chequeo". */
/*         UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.                                            */
/*     END.                                                                                        */
/*     /* Marcamos como proceso de Pickeo */                                                       */
/*     FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia AND                                */
/*         b-vtacdocu.coddiv = s-CodDiv AND                                                        */
/*         b-vtacdocu.codped = pCoddoc AND                                                         */
/*         b-vtacdocu.nroped = pNroDoc EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                            */
/*     IF NOT AVAILABLE b-vtacdocu THEN DO:                                                        */
/*         x-msgerror = "La HPK no existe ó esta bloqueada...verifiquelo!!!".                      */
/*         UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.                                            */
/*     END.                                                                                        */
/*                                                                                                 */
/*     IF NOT (b-vtacdocu.flgest = 'P' AND b-vtacdocu.flgsit = "PT") THEN DO:                      */
/*         x-msgerror = "La orden NO esta en la cola de chequeo".                                  */
/*         UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.                                            */
/*     END.                                                                                        */
/*                                                                                                 */
/*     /**/                                                                                        */
/*     ASSIGN                                                                                      */
/*         b-ChkTareas.flgest = 'X' NO-ERROR.                                                      */
/*     /**/                                                                                        */
/*     ASSIGN                                                                                      */
/*         b-vtacdocu.flgsit = 'PK' NO-ERROR.   /* Lo ponemos en proceso de chequeo */             */
/* END.                                                                                            */
/* IF x-msgerror > '' THEN DO:                                                                     */
/*     RELEASE b-ChkTareas.                                                                        */
/*     RELEASE b-vtacdocu.                                                                         */
/*     MESSAGE x-msgerror.                                                                         */
/*     RETURN ERROR.                                                                               */
/* END.                                                                                            */
/* /* Desbloqueamos */                                                                             */
/* FIND CURRENT b-vtacdocu NO-LOCK NO-ERROR.                                                       */
/* FIND CURRENT b-ChkTareas NO-LOCK NO-ERROR.                                                      */

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-cliente FILL-IN-orden FILL-IN-PHR ~
FILL-IN-chequeador FILL-IN-codplanilla FILL-IN-Embalaje FILL-IN-embalado ~
FILL-IN-crossdocking FILL-IN-prioridad 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD centrar-texto D-Dialog 
FUNCTION centrar-texto RETURNS LOGICAL
  ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-chk-bandeja-hpk-v2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "REGRESAR" 
     SIZE 17 BY 1.15
     BGCOLOR 8 FONT 6.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "CERRAR ORDEN" 
     SIZE 17 BY 1.15
     BGCOLOR 8 FONT 6.

DEFINE VARIABLE FILL-IN-chequeador AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1
     FGCOLOR 4 FONT 17 NO-UNDO.

DEFINE VARIABLE FILL-IN-cliente AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1
     FGCOLOR 1 FONT 17 NO-UNDO.

DEFINE VARIABLE FILL-IN-codplanilla AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod.Planilla" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-crossdocking AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-embalado AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-Embalaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1.35
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS CHARACTER FORMAT "X(60)":U INITIAL "OTR 000 000127" 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY 1.15
     FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-PHR AS CHARACTER FORMAT "X(60)":U INITIAL "OTR 000 000127" 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY 1.15
     FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-prioridad AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-tiempo AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY 1.31
     FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 165 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-cliente AT ROW 1.15 COL 47.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN-orden AT ROW 1.27 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 1.27 COL 124
     FILL-IN-tiempo AT ROW 1.81 COL 141 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-PHR AT ROW 2.35 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 54
     FILL-IN-chequeador AT ROW 2.35 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     Btn_Cancel AT ROW 2.35 COL 124
     FILL-IN-codplanilla AT ROW 2.46 COL 107 COLON-ALIGNED WIDGET-ID 62
     FILL-IN-Embalaje AT ROW 3.42 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 60 DEBLANK 
     FILL-IN-embalado AT ROW 3.46 COL 69.43 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     FILL-IN-crossdocking AT ROW 3.5 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-prioridad AT ROW 3.54 COL 11.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     "CrossDock :" VIEW-AS TEXT
          SIZE 10.86 BY .62 AT ROW 3.69 COL 38 WIDGET-ID 30
          FONT 5
     "Prioridad :" VIEW-AS TEXT
          SIZE 11.57 BY .62 AT ROW 3.69 COL 2 WIDGET-ID 28
          FONT 5
     "Embalado :" VIEW-AS TEXT
          SIZE 11.43 BY .62 AT ROW 3.65 COL 59.43 WIDGET-ID 32
          FONT 5
     "CHEQUEADOR" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 2.62 COL 34 WIDGET-ID 48
          FONT 5
     "CLIENTE" VIEW-AS TEXT
          SIZE 8.86 BY .62 AT ROW 1.35 COL 40 WIDGET-ID 46
          FONT 5
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 50
     SPACE(0.13) SKIP(19.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "CHEQUEO DE HOJAS DE PICKING"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-ChkTareas B "?" ? INTEGRAL ChkTareas
      TABLE: b-vtacdocu B "?" ? INTEGRAL VtaCDocu
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

/* SETTINGS FOR FILL-IN FILL-IN-chequeador IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-codplanilla IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-crossdocking IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-embalado IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Embalaje IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-Embalaje:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PHR IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-prioridad IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tiempo IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-tiempo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME D-Dialog:HANDLE
       ROW             = 1
       COLUMN          = 149
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 52
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* CHEQUEO DE HOJAS DE PICKING */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* CERRAR ORDEN */
DO:
  RUN Cerra-Orden IN h_b-chk-bandeja-hpk-v2.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame D-Dialog OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tiempo AS CHAR.
DEFINE VAR x-centrar AS LOG.

x-Tiempo = ''.

RUN lib/_time-passed ( DATETIME(STRING(x-fecha-inicio,"99/99/9999") + ' ' + x-hora-inicio),
                         DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).


fill-in-tiempo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

x-centrar = centrar-texto(fill-in-tiempo:HANDLE).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
             INPUT  'logis/b-chk-bandeja-hpk-v2.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-chk-bandeja-hpk-v2 ).
       RUN set-position IN h_b-chk-bandeja-hpk-v2 ( 5.31 , 1.14 ) NO-ERROR.
       RUN set-size IN h_b-chk-bandeja-hpk-v2 ( 18.00 , 165.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 23.35 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-chk-bandeja-hpk-v2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-chk-bandeja-hpk-v2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-chk-bandeja-hpk-v2 ,
             FILL-IN-prioridad:HANDLE , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-chk-bandeja-hpk-v2 , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load D-Dialog  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "d-chk-bandeja-hpk-v2.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "d-chk-bandeja-hpk-v2.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY FILL-IN-cliente FILL-IN-orden FILL-IN-PHR FILL-IN-chequeador 
          FILL-IN-codplanilla FILL-IN-Embalaje FILL-IN-embalado 
          FILL-IN-crossdocking FILL-IN-prioridad 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 Btn_OK Btn_Cancel 
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
  RUN Captura-Parametros IN h_b-chk-bandeja-hpk-v2
    ( INPUT pCoddoc /* CHARACTER */,
      INPUT pNroDoc /* CHARACTER */,
      INPUT pChequeador /* CHARACTER */,
      INPUT pCodPer /* CHARACTER */,
      INPUT pPrioridad /* CHARACTER */,
      INPUT pEmbalado /* CHARACTER */,
      INPUT pMesa /* CHARACTER */).
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FILL-in-orden = pCodDoc + "-" + pNroDoc.
      FILL-IN-chequeador = pChequeador.
      fill-in-prioridad = pPrioridad.
      fill-in-embalado = pEmbalado.
      FILL-in-crossdocking = 'NO'.
      fill-in-codplanilla = pCodPer.
      fill-in-cliente = b-vtacdocu.codcli + " " + b-vtacdocu.nomcli.
      FILL-in-PHR = b-vtacdocu.codori + ' ' +  b-vtacdocu.nroori.
      IF pEmbalado = "SI" THEN ASSIGN FILL-IN-Embalaje:VISIBLE = YES FILL-IN-Embalaje = "PEDIDO LLEVA EMBALAJE ESPECIAL".
          ELSE ASSIGN FILL-IN-Embalaje:VISIBLE = NO FILL-IN-Embalaje = "".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle D-Dialog 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER p-handle AS CHAR.

CASE p-handle:
    WHEN 'disable-buttons' THEN DO:
        DISABLE Btn_Cancel Btn_OK WITH FRAME {&FRAME-NAME}.
    END.
    WHEN 'enable-buttons' THEN DO:
        ENABLE Btn_Cancel Btn_OK WITH FRAME {&FRAME-NAME}.
    END.
/*     WHEN 'disable-campos' THEN DO:                           */
/*         ASSIGN                                               */
/*             Btn_Done:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  */
/*         RUN disable-campos IN h_b-picking-ordenes.           */
/*     END.                                                     */
/*     WHEN 'enable-campos' THEN DO:                            */
/*         ASSIGN                                               */
/*             Btn_Done:SENSITIVE IN FRAME {&FRAME-NAME} = YES. */
/*         RUN enable-campos IN h_b-picking-ordenes.            */
/*     END.                                                     */
    WHEN 'Add-Record' THEN RUN notify IN h_p-updv12   ('add-record':U).
END CASE.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION centrar-texto D-Dialog 
FUNCTION centrar-texto RETURNS LOGICAL
  ( INPUT h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE reps AS INTEGER     NO-UNDO.

reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
reps = reps / 2.
h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).

RETURN yes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

