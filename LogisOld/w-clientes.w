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

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEF NEW SHARED VAR s-nivel-acceso AS INT INIT 0 NO-UNDO.
/* DEF VAR X-REP AS CHAR NO-UNDO.                                              */
/* DEF VAR x-Claves AS CHAR INIT 'networks,adminlevel,utilexmod,duos' NO-UNDO. */
/*                                                                             */
/* RUN lib/_clave3 (x-claves, OUTPUT x-rep).                                   */
/* s-nivel-acceso = LOOKUP(x-rep, x-Claves).                                   */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-codunico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-gn-cliem-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-gncliel02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv09 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-clie-dir-fiscal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-clie-locales AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-client AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-conyugue AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cliente AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cliente-info-comercial AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cliente-sede AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cliente-sede-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-conyugue AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-gn-cliem-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-obscre AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "MAESTRO DE CLIENTES"
         HEIGHT             = 25.85
         WIDTH              = 144.29
         MAX-HEIGHT         = 32.46
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.46
         VIRTUAL-WIDTH      = 205.72
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
ON END-ERROR OF W-Win /* MAESTRO DE CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MAESTRO DE CLIENTES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.
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
             INPUT  'src/adm-vm/objects/p-updv08.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.42 , 49.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 52.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.62 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/v-cliente.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cliente ).
       RUN set-position IN h_v-cliente ( 2.62 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.96 , 130.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Dirección Fiscal|Locales|Información de Comercial|Conyugue|Información de Créditos|Mensajes|Relacionados|Línea de Crédito':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 12.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 14.00 , 142.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/adm/q-client.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-client ).
       RUN set-position IN h_q-client ( 1.00 , 71.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.46 , 18.29 ) */

       /* Links to SmartViewer h_v-cliente. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_v-cliente ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-cliente ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-client. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-client ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_p-updv08 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cliente ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             h_v-cliente , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-client ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/v-cliente-sede.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cliente-sede ).
       RUN set-position IN h_v-cliente-sede ( 13.65 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.31 , 121.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 24.96 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/q-clie-dir-fiscal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-clie-dir-fiscal ).
       RUN set-position IN h_q-clie-dir-fiscal ( 13.65 , 129.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-cliente-sede. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_v-cliente-sede ).
       RUN add-link IN adm-broker-hdl ( h_q-clie-dir-fiscal , 'Record':U , h_v-cliente-sede ).

       /* Links to SmartQuery h_q-clie-dir-fiscal. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_q-clie-dir-fiscal ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cliente-sede ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_v-cliente-sede , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/v-cliente-sede.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cliente-sede-2 ).
       RUN set-position IN h_v-cliente-sede-2 ( 13.65 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.31 , 121.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv09.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv09 ).
       RUN set-position IN h_p-updv09 ( 24.96 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv09 ( 1.42 , 48.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 24.96 , 53.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/q-clie-locales.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-clie-locales ).
       RUN set-position IN h_q-clie-locales ( 14.19 , 107.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-cliente-sede-2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv09 , 'TableIO':U , h_v-cliente-sede-2 ).
       RUN add-link IN adm-broker-hdl ( h_q-clie-locales , 'Record':U , h_v-cliente-sede-2 ).

       /* Links to SmartQuery h_q-clie-locales. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-clie-locales ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_q-clie-locales ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cliente-sede-2 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv09 ,
             h_v-cliente-sede-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_p-updv09 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/v-cliente-info-comercial.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cliente-info-comercial ).
       RUN set-position IN h_v-cliente-info-comercial ( 13.65 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.38 , 71.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 24.15 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartViewer h_v-cliente-info-comercial. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_v-cliente-info-comercial ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-cliente-info-comercial ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cliente-info-comercial ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_v-cliente-info-comercial , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/v-conyugue.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-conyugue ).
       RUN set-position IN h_v-conyugue ( 13.92 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.92 , 70.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/q-conyugue.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-conyugue ).
       RUN set-position IN h_q-conyugue ( 14.46 , 80.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-conyugue. */
       RUN add-link IN adm-broker-hdl ( h_q-conyugue , 'Record':U , h_v-conyugue ).

       /* Links to SmartQuery h_q-conyugue. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_q-conyugue ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-conyugue ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtamay/v-obscre.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-obscre ).
       RUN set-position IN h_v-obscre ( 13.65 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.65 , 69.00 ) */

       /* Links to SmartViewer h_v-obscre. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-obscre ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-obscre ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-gn-cliem-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-gn-cliem-1 ).
       RUN set-position IN h_b-gn-cliem-1 ( 13.65 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-gn-cliem-1 ( 6.69 , 25.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/v-gn-cliem-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-gn-cliem-1 ).
       RUN set-position IN h_v-gn-cliem-1 ( 13.65 , 28.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.00 , 63.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 20.92 , 28.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-gn-cliem-1. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-gn-cliem-1 ).

       /* Links to SmartViewer h_v-gn-cliem-1. */
       RUN add-link IN adm-broker-hdl ( h_b-gn-cliem-1 , 'Record':U , h_v-gn-cliem-1 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_v-gn-cliem-1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-gn-cliem-1 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-gn-cliem-1 ,
             h_b-gn-cliem-1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_v-gn-cliem-1 , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-codunico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-codunico ).
       RUN set-position IN h_b-codunico ( 13.65 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-codunico ( 6.69 , 66.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-codunico. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-codunico ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-codunico ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 7 */
    WHEN 8 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-gncliel02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-gncliel02 ).
       RUN set-position IN h_b-gncliel02 ( 13.65 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-gncliel02 ( 6.42 , 62.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-gncliel02. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-gncliel02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-gncliel02 ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 8 */

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
  VIEW FRAME F-Main IN WINDOW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-handle W-Win 
PROCEDURE Procesa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'disable-fields' THEN DO:
        RUN dispatch IN h_p-updv08 ('disable':U).
        RUN adm-disable IN h_p-navico.
        RUN adm-disable IN h_q-client.
    END.
    WHEN 'enable-fields' THEN DO:
        RUN dispatch IN h_p-updv08 ('enable':U).
        RUN adm-enable IN h_p-navico.
        RUN adm-enable IN h_q-client.
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

