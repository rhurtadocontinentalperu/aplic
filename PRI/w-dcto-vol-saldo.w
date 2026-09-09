&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-FacTabla LIKE FacTabla.



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
DEF INPUT PARAMETER pParam AS CHAR.

/* Posibles Valores:
1. Mayorista con Lista General
2. Minorista con Lista General (UTILEX)
3. Mayorista con Lista x División 
4. Mayorista para EVENTOS */
IF LOOKUP(pParam, '1,2,3,4') = 0 THEN DO:
    MESSAGE 'ERROR: el parámetro debe ser 1, 2, 3 o 4' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR s-Tabla   AS CHAR.
DEF NEW SHARED VAR s-Tabla-1 AS CHAR.
DEF NEW SHARED VAR lh_Handle AS HANDLE.

s-Tabla   = "DVXSALDOC".      /* Descto x Vol x Saldos Cabecera */
s-Tabla-1 = "DVXSALDOD".      /* Descto x Vol x Saldos Detalle */

DEF NEW SHARED VAR S-CODDOC   AS CHAR.

DEFINE NEW SHARED VARIABLE s-Divisiones AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Divisiones-Validas IN hProc (INPUT INTEGER(pParam), OUTPUT s-Divisiones).
DELETE PROCEDURE hProc.
IF TRUE <> (s-Divisiones > '') THEN DO:
    MESSAGE 'ERROR: no hay divisiones configuradas' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 RECT-18 BUTTON-Genera-Excel ~
RADIO-SET-2 BUTTON-Importar BUTTON-Replica 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-dcto-vol-saldo-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-dcto-vol-saldo-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-dcto-vol-saldo-div AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-dcto-vol-saldo-div AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Genera-Excel 
     LABEL "GENERA PLANTILLA EXCEL" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-Importar 
     LABEL "IMPORTAR EXCEL" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-Replica 
     LABEL "REPLICAR" 
     SIZE 15 BY 1.12 TOOLTIP "Copiar el registro seleccionado a todas las divisiones seleccionadas".

DEFINE VARIABLE RADIO-SET-2 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Porcentajes", 1,
"Importes", 2
     SIZE 22 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 64 BY 1.62
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 1.62.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Genera-Excel AT ROW 3.15 COL 72 WIDGET-ID 4
     RADIO-SET-2 AT ROW 3.42 COL 111 NO-LABEL WIDGET-ID 38
     BUTTON-Importar AT ROW 4.77 COL 72 WIDGET-ID 6
     BUTTON-Replica AT ROW 6.38 COL 72 WIDGET-ID 2
     "Valores en:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.62 COL 102 WIDGET-ID 42
     RECT-16 AT ROW 2.88 COL 70 WIDGET-ID 44
     RECT-17 AT ROW 4.5 COL 70 WIDGET-ID 46
     RECT-18 AT ROW 6.12 COL 70 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 135.29 BY 24.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FacTabla T "NEW SHARED" ? INTEGRAL FacTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DESCUENTO POR VOLUMEN POR SALDO"
         HEIGHT             = 24.27
         WIDTH              = 135.29
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 178.72
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 178.72
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESCUENTO POR VOLUMEN POR SALDO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESCUENTO POR VOLUMEN POR SALDO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Genera-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Genera-Excel W-Win
ON CHOOSE OF BUTTON-Genera-Excel IN FRAME F-Main /* GENERA PLANTILLA EXCEL */
DO:
    ASSIGN RADIO-SET-2.
  RUN Generar-Plantilla IN h_b-dcto-vol-saldo-cab (INPUT RADIO-SET-2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Importar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Importar W-Win
ON CHOOSE OF BUTTON-Importar IN FRAME F-Main /* IMPORTAR EXCEL */
DO:
  RUN Carga-Plantilla IN h_b-dcto-vol-saldo-cab.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Replica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Replica W-Win
ON CHOOSE OF BUTTON-Replica IN FRAME F-Main /* REPLICAR */
DO:
    DEF VAR pDivisiones AS CHAR.

    /*RUN pri/d-selecc-div-lima (INPUT "ATL,EXP,FER,HOR,INS,MIN,MOD,OTR,PRO,TDA", OUTPUT pDivisiones).*/
    pDivisiones = s-Divisiones.
    RUN Replica-Plantilla IN h_b-dcto-vol-saldo-div ( INPUT pDivisiones /* CHARACTER */).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

CASE pParam:
    WHEN '1' THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - LISTA DE PRECIOS LIMA MAYORISTA".
    WHEN '2' THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - LISTA DE PRECIOS UTILEX MINORISTA".
    WHEN '3' THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - LISTA DE PRECIOS MAYORISTA POR DIVISION".
    WHEN '4' THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - LISTA DE PRECIOS EVENTOS".
END CASE.

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
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-dcto-vol-saldo-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dcto-vol-saldo-cab ).
       RUN set-position IN h_b-dcto-vol-saldo-cab ( 2.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-dcto-vol-saldo-cab ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Artículos Relacionados|Descuento x Volumen':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 9.35 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 15.88 , 135.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dcto-vol-saldo-cab. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-dcto-vol-saldo-cab ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             BUTTON-Genera-Excel:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dcto-vol-saldo-cab ,
             h_p-updv10 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             BUTTON-Replica:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-dcto-vol-saldo-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dcto-vol-saldo-det ).
       RUN set-position IN h_b-dcto-vol-saldo-det ( 10.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-dcto-vol-saldo-det ( 13.27 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 23.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dcto-vol-saldo-det. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-dcto-vol-saldo-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dcto-vol-saldo-det ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-dcto-vol-saldo-det , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-dcto-vol-saldo-div.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-dcto-vol-saldo-div ).
       RUN set-position IN h_b-dcto-vol-saldo-div ( 10.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-dcto-vol-saldo-div ( 12.12 , 71.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/v-dcto-vol-saldo-div.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-dcto-vol-saldo-div ).
       RUN set-position IN h_v-dcto-vol-saldo-div ( 10.96 , 75.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.58 , 50.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 22.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 1.42 , 34.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 22.54 , 75.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-dcto-vol-saldo-div. */
       RUN add-link IN adm-broker-hdl ( h_b-dcto-vol-saldo-cab , 'Record':U , h_b-dcto-vol-saldo-div ).
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_b-dcto-vol-saldo-div ).

       /* Links to SmartViewer h_v-dcto-vol-saldo-div. */
       RUN add-link IN adm-broker-hdl ( h_b-dcto-vol-saldo-div , 'Record':U , h_v-dcto-vol-saldo-div ).
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_v-dcto-vol-saldo-div ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-dcto-vol-saldo-div ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-dcto-vol-saldo-div ,
             h_b-dcto-vol-saldo-div , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             h_v-dcto-vol-saldo-div , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_p-updv12-2 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY RADIO-SET-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-16 RECT-17 RECT-18 BUTTON-Genera-Excel RADIO-SET-2 
         BUTTON-Importar BUTTON-Replica 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParametro AS CHAR.


CASE pParametro:
    WHEN "Open-Browse" THEN DO:
        IF h_b-dcto-vol-saldo-det <> ? THEN RUN dispatch IN h_b-dcto-vol-saldo-det ('open-query':U).
        IF h_b-dcto-vol-saldo-div <> ? THEN RUN dispatch IN h_b-dcto-vol-saldo-div ('open-query':U).
        IF h_v-dcto-vol-saldo-div <> ? THEN RUN dispatch IN h_v-dcto-vol-saldo-div ('display-fields':U).
    END.
    WHEN "Disable-Header" THEN DO:
        IF h_p-updv10 <> ? THEN RUN dispatch IN h_p-updv10 ('disable':U).
        IF h_p-updv12 <> ? THEN RUN dispatch IN h_p-updv12 ('disable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('disable':U).
        DISABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Enable-Header" THEN DO:
        IF h_p-updv10 <> ? THEN RUN dispatch IN h_p-updv10 ('enable':U).
        IF h_p-updv12 <> ? THEN RUN dispatch IN h_p-updv12 ('enable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('enable':U).
        ENABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Disable-Detail" THEN DO:
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
    END.
    WHEN "Enable-Detail" THEN DO:
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
    END.
    WHEN "Pinta-Divisiones" THEN DO:
        IF h_b-dcto-vol-saldo-div <> ? THEN RUN dispatch IN h_b-dcto-vol-saldo-div ('open-query':U).
    END.
    WHEN "Disable-Header-2" THEN DO:
        IF h_p-updv10 <> ? THEN RUN dispatch IN h_p-updv10 ('disable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('disable':U).
        DISABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Enable-Header-2" THEN DO:
        IF h_p-updv10 <> ? THEN RUN dispatch IN h_p-updv10 ('enable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('enable':U).
        ENABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Disable-Header-3" THEN DO:
        IF h_p-updv12 <> ? THEN RUN dispatch IN h_p-updv12 ('disable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('disable':U).
        DISABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
    WHEN "Enable-Header-3" THEN DO:
        IF h_p-updv12 <> ? THEN RUN dispatch IN h_p-updv12 ('enable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
        IF h_p-updv96 <> ? THEN RUN dispatch IN h_p-updv96 ('enable':U).
        ENABLE BUTTON-Replica BUTTON-Genera-Excel BUTTON-Importar WITH FRAME {&FRAME-NAME}.
    END.
END CASE.


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

