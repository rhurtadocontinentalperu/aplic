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
DEFINE INPUT PARAMETER pPerfilUsuario AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

DEF NEW SHARED VAR s-nivel-acceso AS INT INIT 0 NO-UNDO.

s-nivel-acceso = 0.     /* Total */

DEF NEW SHARED VAR lh_handle AS HANDLE.


/*
    Segun el perfil se va a asignar
*/    
IF pPerfilUsuario = '*' THEN s-nivel-acceso = 0.
IF pPerfilUsuario = 'COMER' THEN s-nivel-acceso = 1.
IF pPerfilUsuario = 'VENTAS' THEN s-nivel-acceso = 2.
IF pPerfilUsuario = 'LOGIS' THEN s-nivel-acceso = 3.
IF pPerfilUsuario = 'CYC' THEN s-nivel-acceso = 4.
IF pPerfilUsuario = 'INVEVEN' THEN s-nivel-acceso = 5.      /* Invitacion Eventos */

&SCOPED-DEFINE x-nivel-acceso "SI".

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
DEFINE VARIABLE h_b-avisos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-corporativo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-linea-credito AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-obs-analista AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-cliente-sede AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-upd96-obsvta AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv08 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv09-cliente-sede AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-avisos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-linea-credito AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-obs-analista AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-avales AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-conyugue AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-datos-analista AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-datos-analista2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-obscre AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-clie-locales AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-client AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-conyugue AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-avales2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-avisos-input AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cliente-sede AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-conyugue AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-datos-analista AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-datos-analista-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-mant-clientes-ventas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-obscre AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-obsvta AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 138.14 BY 30
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "MANTENIMIENTO DE MAESTRO DE CLIENTES"
         HEIGHT             = 27.46
         WIDTH              = 137.72
         MAX-HEIGHT         = 38.69
         MAX-WIDTH          = 138.14
         VIRTUAL-HEIGHT     = 38.69
         VIRTUAL-WIDTH      = 138.14
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
ON END-ERROR OF W-Win /* MANTENIMIENTO DE MAESTRO DE CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MANTENIMIENTO DE MAESTRO DE CLIENTES */
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
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 65.29 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.35 , 21.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv08.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv08 ).
       RUN set-position IN h_p-updv08 ( 1.04 , 1.14 ) NO-ERROR.
       RUN set-size IN h_p-updv08 ( 1.31 , 49.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-mant-clientes-ventas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-mant-clientes-ventas ).
       RUN set-position IN h_v-mant-clientes-ventas ( 2.31 , 1.14 ) NO-ERROR.
       /* Size in UIB:  ( 14.81 , 133.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Obs.Ventas|Obs.Creditos|Corporativo|Linea Credito|Sedes|Conyugue|Obs.Analista|Avisos|Avales':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 17.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 11.15 , 136.43 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/adm/q-client.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-client ).
       RUN set-position IN h_q-client ( 1.00 , 106.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.46 , 18.29 ) */

       /* Links to SmartViewer h_v-mant-clientes-ventas. */
       RUN add-link IN adm-broker-hdl ( h_p-updv08 , 'TableIO':U , h_v-mant-clientes-ventas ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-mant-clientes-ventas ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-client. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-client ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv08 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-mant-clientes-ventas ,
             h_p-updv08 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             h_v-mant-clientes-ventas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-client ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtamay/v-obsvta.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-obsvta ).
       RUN set-position IN h_v-obsvta ( 18.50 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.42 , 70.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-upd96-obsvta ).
       RUN set-position IN h_p-upd96-obsvta ( 20.62 , 73.72 ) NO-ERROR.
       RUN set-size IN h_p-upd96-obsvta ( 4.04 , 23.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-obsvta. */
       RUN add-link IN adm-broker-hdl ( h_p-upd96-obsvta , 'TableIO':U , h_v-obsvta ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-obsvta ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-obsvta ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-upd96-obsvta ,
             h_v-obsvta , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtamay/v-obscre.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-obscre ).
       RUN set-position IN h_v-obscre ( 19.46 , 4.43 ) NO-ERROR.
       /* Size in UIB:  ( 3.65 , 69.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-obscre ).
       RUN set-position IN h_p-updv96-obscre ( 19.46 , 76.14 ) NO-ERROR.
       RUN set-size IN h_p-updv96-obscre ( 3.65 , 20.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/v-datos-analista.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-datos-analista-3 ).
       RUN set-position IN h_v-datos-analista-3 ( 23.65 , 4.57 ) NO-ERROR.
       /* Size in UIB:  ( 2.69 , 72.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-datos-analista ).
       RUN set-position IN h_p-updv96-datos-analista ( 24.77 , 77.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-datos-analista ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartViewer h_v-obscre. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-obscre , 'TableIO':U , h_v-obscre ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-obscre ).

       /* Links to SmartViewer h_v-datos-analista-3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-datos-analista , 'TableIO':U , h_v-datos-analista-3 ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-datos-analista-3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-obscre ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-obscre ,
             h_v-obscre , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-datos-analista-3 ,
             h_p-updv96-obscre , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-datos-analista ,
             h_v-datos-analista-3 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-codunico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-corporativo ).
       RUN set-position IN h_b-corporativo ( 18.69 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-corporativo ( 6.69 , 66.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-corporativo. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-corporativo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-corporativo ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-lc-gn-cliel-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-linea-credito ).
       RUN set-position IN h_b-linea-credito ( 19.19 , 4.86 ) NO-ERROR.
       RUN set-size IN h_b-linea-credito ( 7.58 , 68.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-linea-credito ).
       RUN set-position IN h_p-updv12-linea-credito ( 20.27 , 76.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-linea-credito ( 4.62 , 16.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-linea-credito. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-linea-credito , 'TableIO':U , h_b-linea-credito ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-linea-credito ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-linea-credito ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-linea-credito ,
             h_b-linea-credito , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/v-cliente-sede.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cliente-sede ).
       RUN set-position IN h_v-cliente-sede ( 18.27 , 3.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.31 , 121.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-new/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-cliente-sede ).
       RUN set-position IN h_p-navico-cliente-sede ( 25.73 , 61.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-cliente-sede ( 1.38 , 27.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv09.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv09-cliente-sede ).
       RUN set-position IN h_p-updv09-cliente-sede ( 25.77 , 4.86 ) NO-ERROR.
       RUN set-size IN h_p-updv09-cliente-sede ( 1.42 , 49.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/q-clie-locales.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-clie-locales ).
       RUN set-position IN h_q-clie-locales ( 18.96 , 126.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-cliente-sede. */
       RUN add-link IN adm-broker-hdl ( h_p-updv09-cliente-sede , 'TableIO':U , h_v-cliente-sede ).
       RUN add-link IN adm-broker-hdl ( h_q-clie-locales , 'Record':U , h_v-cliente-sede ).

       /* Links to SmartQuery h_q-clie-locales. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-cliente-sede , 'Navigation':U , h_q-clie-locales ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_q-clie-locales ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cliente-sede ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-cliente-sede ,
             h_v-cliente-sede , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv09-cliente-sede ,
             h_p-navico-cliente-sede , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/v-conyugue.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-conyugue ).
       RUN set-position IN h_v-conyugue ( 18.65 , 6.43 ) NO-ERROR.
       /* Size in UIB:  ( 4.92 , 70.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-conyugue ).
       RUN set-position IN h_p-updv96-conyugue ( 18.65 , 76.86 ) NO-ERROR.
       RUN set-size IN h_p-updv96-conyugue ( 3.85 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/q-conyugue.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-conyugue ).
       RUN set-position IN h_q-conyugue ( 19.77 , 104.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-conyugue. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-conyugue , 'TableIO':U , h_v-conyugue ).
       RUN add-link IN adm-broker-hdl ( h_q-conyugue , 'Record':U , h_v-conyugue ).

       /* Links to SmartQuery h_q-conyugue. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_q-conyugue ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-conyugue ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-conyugue ,
             h_v-conyugue , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-obs-analista-consulta.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-obs-analista ).
       RUN set-position IN h_b-obs-analista ( 18.19 , 3.29 ) NO-ERROR.
       RUN set-size IN h_b-obs-analista ( 7.12 , 109.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-obs-analista ).
       RUN set-position IN h_p-updv12-obs-analista ( 18.81 , 112.29 ) NO-ERROR.
       RUN set-size IN h_p-updv12-obs-analista ( 4.62 , 12.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/v-datos-analista.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-datos-analista ).
       RUN set-position IN h_v-datos-analista ( 25.35 , 3.43 ) NO-ERROR.
       /* Size in UIB:  ( 2.69 , 72.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-datos-analista2 ).
       RUN set-position IN h_p-updv96-datos-analista2 ( 25.96 , 77.72 ) NO-ERROR.
       RUN set-size IN h_p-updv96-datos-analista2 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-obs-analista. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-obs-analista , 'TableIO':U , h_b-obs-analista ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-obs-analista ).

       /* Links to SmartViewer h_v-datos-analista. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-datos-analista2 , 'TableIO':U , h_v-datos-analista ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-datos-analista ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-obs-analista ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-obs-analista ,
             h_b-obs-analista , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-datos-analista ,
             h_p-updv12-obs-analista , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-datos-analista2 ,
             h_v-datos-analista , 'AFTER':U ).
    END. /* Page 7 */
    WHEN 8 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/v-gn-cliem-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-avisos-input ).
       RUN set-position IN h_v-avisos-input ( 18.77 , 29.72 ) NO-ERROR.
       /* Size in UIB:  ( 7.00 , 63.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-gn-cliem-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-avisos ).
       RUN set-position IN h_b-avisos ( 18.88 , 4.43 ) NO-ERROR.
       RUN set-size IN h_b-avisos ( 6.69 , 25.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-avisos ).
       RUN set-position IN h_p-updv12-avisos ( 18.92 , 93.14 ) NO-ERROR.
       RUN set-size IN h_p-updv12-avisos ( 4.62 , 17.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-avisos-input. */
       RUN add-link IN adm-broker-hdl ( h_b-avisos , 'Record':U , h_v-avisos-input ).
       RUN add-link IN adm-broker-hdl ( h_p-updv12-avisos , 'TableIO':U , h_v-avisos-input ).

       /* Links to SmartBrowser h_b-avisos. */
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_b-avisos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-avisos-input ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-avisos ,
             h_v-avisos-input , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-avisos ,
             h_b-avisos , 'AFTER':U ).
    END. /* Page 8 */
    WHEN 9 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/v-avales2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-avales2 ).
       RUN set-position IN h_v-avales2 ( 18.46 , 6.29 ) NO-ERROR.
       /* Size in UIB:  ( 8.88 , 83.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-avales ).
       RUN set-position IN h_p-updv96-avales ( 20.12 , 92.14 ) NO-ERROR.
       RUN set-size IN h_p-updv96-avales ( 4.23 , 17.00 ) NO-ERROR.

       /* Links to SmartViewer h_v-avales2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-avales , 'TableIO':U , h_v-avales2 ).
       RUN add-link IN adm-broker-hdl ( h_q-client , 'Record':U , h_v-avales2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-avales2 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-avales ,
             h_v-avales2 , 'AFTER':U ).
    END. /* Page 9 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page W-Win 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    RUN restricciones.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN restricciones.

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

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'Disable-Header' THEN DO:
        RUN dispatch IN h_p-updv08 ('disable':U).
        RUN dispatch IN h_p-navico ('disable':U).
        RUN dispatch IN h_q-client ('disable':U).
    END.
    WHEN 'Enable-Header' THEN DO:
        RUN dispatch IN h_p-updv08 ('enable':U).
        RUN dispatch IN h_p-navico ('enable':U).
        RUN dispatch IN h_q-client ('enable':U).
    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restricciones W-Win 
PROCEDURE restricciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-pos AS INT.
DEFINE VAR x-visible AS LOG.
DEFINE VAR x-editable AS LOG.

IF s-nivel-acceso <> 0 THEN DO:
    FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'MANTENIMIENTO-CLIENTE-GRUPO' NO-LOCK:

        x-pos = (s-nivel-acceso * 2) - 1.

        x-visible = factabla.campo-l[x-pos].
        x-editable = factabla.campo-l[x-pos + 1].

        CASE factabla.codigo:
            WHEN "OBS.VENTAS" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_v-obsvta ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-upd96-obsvta ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-upd96-obsvta ('hide':U) NO-ERROR.
                    END.
                END.
                
            END.
            WHEN "OBS.CREDITOS" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_v-obscre ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv96-obscre ('hide':U) NO-ERROR.
                    RUN dispatch IN h_v-datos-analista-3 ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv96-datos-analista ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv96-obscre ('hide':U) NO-ERROR.
                        RUN dispatch IN h_p-updv96-datos-analista ('hide':U) NO-ERROR.
                    END.
                END.

            END.
            WHEN "CORPORATIVO" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_b-corporativo ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        
                    END.
                END.

            END.
            WHEN "LINEA-CREDITO" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_b-linea-credito ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv12-linea-credito ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv12-linea-credito ('hide':U) NO-ERROR.
                    END.
                END.
                IF x-visible = NO OR x-editable = NO THEN DO:
                    RUN actualizable IN h_b-linea-credito(INPUT NO) NO-ERROR.
                END.                

            END.
            WHEN "SEDES" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_v-cliente-sede ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv09-cliente-sede ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-navico-cliente-sede ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv09-cliente-sede ('hide':U) NO-ERROR.
                    END.
                END.

            END.
            WHEN "CONYUGUE" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_v-conyugue ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv96-conyugue ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv96-conyugue ('hide':U) NO-ERROR.
                    END.
                END.

            END.
            WHEN "OBS.ANALISTA" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_b-obs-analista ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv12-obs-analista ('hide':U) NO-ERROR.
                    RUN dispatch IN h_v-datos-analista ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv96-datos-analista2 ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv12-obs-analista ('hide':U) NO-ERROR.
                        RUN dispatch IN h_p-updv96-datos-analista2 ('hide':U) NO-ERROR.
                    END.
                END.

            END.
            WHEN "AVISOS" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_b-avisos ('hide':U) NO-ERROR.
                    RUN dispatch IN h_v-avisos-input ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv12-avisos ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_v-avisos-input ('hide':U) NO-ERROR.
                        RUN dispatch IN h_p-updv12-avisos ('hide':U) NO-ERROR.
                    END.
                END.

            END.
            WHEN "AVALES" THEN DO:
                IF x-visible = NO THEN DO:
                    RUN dispatch IN h_v-avales2 ('hide':U) NO-ERROR.
                    RUN dispatch IN h_p-updv96-avales ('hide':U) NO-ERROR.
                END.
                ELSE DO:
                    IF x-editable = NO THEN DO:
                        RUN dispatch IN h_p-updv96-avales ('hide':U) NO-ERROR.
                    END.
                END.

            END.

        END CASE.

    END.
END.
                           
END PROCEDURE.

/*
    RUN dispatch IN h_v-obscre ('hide':U) NO-ERROR.

    Pag 1 : Obs.Ventas
        h_v-obsvta
        h_p-upd96-obsvta
    Pag 2 : Obs.Creditos
        h_v-obscre
        h_p-updv96-obscre
        h_v-datos-analista-3
        h_p-updv96-datos-analista
    Pag 3 : Corporativo
        h_b-corporativo
    Pag 4 : Linea Credito
        h_b-linea-credito
        h_p-updv12-linea-credito
    Pag 5 : Sedes
        h_v-cliente-sede
        h_p-updv09-cliente-sede
        h_p-navico-cliente-sede
    Pag 6 : Conyugue
        h_v-conyugue
        h_p-updv96-conyugue
    Pag 7 : Obs.Analista
        h_b-obs-analista
        h_p-updv12-obs-analista
        h_v-datos-analista
        h_p-updv96-datos-analista2
    Pag 8 : Avisos
        h_b-avisos
        h_v-avisos-input
        h_p-updv12-avisos
    Pag 9 : Avales
        h_v-avales2
        h_p-updv96-avales
*/

/*
    Segun el perfil se va a asignar

IF pPerfilUsuario = '*' THEN s-nivel-acceso = 0.
IF pPerfilUsuario = 'COMER' THEN s-nivel-acceso = 1.
IF pPerfilUsuario = 'VENTAS' THEN s-nivel-acceso = 2.
IF pPerfilUsuario = 'LOGIS' THEN s-nivel-acceso = 3.
IF pPerfilUsuario = 'CYC' THEN s-nivel-acceso = 4.
IF pPerfilUsuario = 'INVEVEN' THEN s-nivel-acceso = 5.      /* Invitacion Eventos */

*/

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

