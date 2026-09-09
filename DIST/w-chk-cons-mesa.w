&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-User-Id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Actualizar BUTTON-Asignar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-chk-cons-mesa-ocu AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-chk-cons-tareas AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Actualizar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Asignar 
     LABEL "REASIGNAR MESA" 
     SIZE 21 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Actualizar AT ROW 4.08 COL 63 WIDGET-ID 2
     BUTTON-Asignar AT ROW 25.23 COL 84 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.43 BY 26.04 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE MESAS"
         HEIGHT             = 26.04
         WIDTH              = 123.43
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 2.62
       COLUMN          = 91
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 4
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      RUN adjust-tab-order IN adm-broker-hdl ( h_b-chk-cons-mesa-ocu , CtrlFrame , 'BEFORE':U ).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE MESAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE MESAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Actualizar W-Win
ON CHOOSE OF BUTTON-Actualizar IN FRAME F-Main /* REFRESCAR */
DO:
    RUN dispatch IN h_b-chk-cons-mesa-ocu ('open-query':U).
    RUN dispatch IN h_b-chk-cons-tareas ('open-query':U).
   /* RUN dispatch IN h_b-chk-cons-mesa-libre ('open-query':U).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Asignar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Asignar W-Win
ON CHOOSE OF BUTTON-Asignar IN FRAME F-Main /* REASIGNAR MESA */
DO:
    RUN Asignar-Mesa.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    APPLY 'CHOOSE':U TO  BUTTON-Actualizar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

  RUN adm-open-query IN h_b-chk-cons-mesa-ocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Artificio */
&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-chk-cons-mesa.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).
IF OCXFile = ? THEN DO:
    OCXFile = ENTRY(1,PROPATH).
    IF R-INDEX(OCXFile, '\') <> LENGTH(OCXFile) AND R-INDEX(OCXFile, '/') <> LENGTH(OCXFile)
        THEN OCXFile = OCXFile + '/'.
    PROPATH = PROPATH + "," + OCXFile + "aplic/dist".
END.

&ENDIF

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
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
             INPUT  'aplic/dist/b-chk-cons-mesa-ocu.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-chk-cons-mesa-ocu ).
       RUN set-position IN h_b-chk-cons-mesa-ocu ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-chk-cons-mesa-ocu ( 10.00 , 56.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-chk-cons-tareas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-chk-cons-tareas ).
       RUN set-position IN h_b-chk-cons-tareas ( 11.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-chk-cons-tareas ( 13.08 , 119.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-chk-cons-tareas. */
       RUN add-link IN adm-broker-hdl ( h_b-chk-cons-mesa-ocu , 'Record':U , h_b-chk-cons-tareas ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-chk-cons-mesa-ocu ,
             BUTTON-Actualizar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-chk-cons-tareas ,
             BUTTON-Actualizar:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Mesa W-Win 
PROCEDURE Asignar-Mesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/

DEF VAR pRowid AS ROWID NO-UNDO.

RUN Dame-Rowid IN h_b-chk-cons-tareas ( OUTPUT pRowid /* ROWID */).

IF pRowid = ? THEN RETURN.

FIND ChkTareas WHERE ROWID(ChkTareas) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Chktareas OR ChkTareas.FlgEst <> "P" THEN RETURN.


DEF VAR pPrioridad AS CHAR.
DEF VAR pEmbalaje AS LOG.
DEF VAR pMesa AS CHAR.
DEF VAR pOk AS LOG.

pPrioridad = ChkTareas.prioridad.
pEmbalaje = ChkTareas.embalaje.
pMesa = ChkTareas.mesa.

RUN dist/d-chk-selecc-mesa (INPUT-OUTPUT pPrioridad,
                            INPUT-OUTPUT pEmbalaje,
                            INPUT-OUTPUT pMesa,
                            OUTPUT pOk).
IF pOk = NO THEN RETURN 'ADM-ERROR'.

DEF BUFFER B-ChkTareas FOR ChkTareas.

/* Bloqueamos registro */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="ChkTareas" ~
        &Condicion="ROWID(ChkTareas) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* ************************************************************************ */
    /* TABLAS RELACIONADAS */
    /* ************************************************************************ */
    FIND ChkMesas WHERE ChkMesas.CodCia = s-CodCia AND 
        ChkMesas.CodDiv = s-CodDiv AND 
        ChkMesas.Mesa = ChkTareas.Mesa
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ChkMesas THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        ChkMesa.FlgEst = "L".
    FIND FIRST B-ChkTareas WHERE B-ChkTareas.CodCia = s-CodCia AND
        B-ChkTareas.CodDiv = s-CodDiv AND 
        B-ChkTareas.Mesa = ChkMesas.Mesa AND
        B-ChkTareas.FlgEst = "P" AND
        ROWID(B-ChkTareas) <> pRowid
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-ChkTareas THEN ChkMesa.FlgEst = "O".     /* Ocupado */
    FIND ChkMesas WHERE ChkMesas.CodCia = s-CodCia AND 
        ChkMesas.CodDiv = s-CodDiv AND 
        ChkMesas.Mesa = pMesa
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ChkMesas THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        ChkMesas.FlgEst = "O".      /* Mesa OCUPADA */
    /* ************************************************************************ */
    /* ************************************************************************ */
    ASSIGN
        ChkTareas.Embalaje = pEmbalaje
        ChkTareas.FechaInicio = TODAY
        ChkTareas.HoraInicio = STRING(TIME, 'HH:MM:SS')
        ChkTareas.Mesa = pMesa
        ChkTareas.Prioridad = pPrioridad
        ChkTareas.UsuarioInicio = s-User-Id.
    /* Tracking de Control */
    FIND Faccpedi WHERE FacCPedi.CodCia = s-CodCia AND 
        FacCPedi.CodDoc = ChkTareas.CodDoc AND
        FacCPedi.NroPed = ChkTareas.NroPed NO-LOCK NO-ERROR.
    IF AVAILABLE FacCPedi THEN
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            'CHKASG',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef).

END.
RELEASE ChkTareas.
RELEASE ChkControl.
RELEASE ChkMesas.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
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

OCXFile = SEARCH( "w-chk-cons-mesa.wrx":U ).
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
ELSE MESSAGE "w-chk-cons-mesa.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  ENABLE BUTTON-Actualizar BUTTON-Asignar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

