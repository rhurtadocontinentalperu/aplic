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
DEF INPUT PARAMETER Pparam AS CHAR.

/* Local Variable Definitions ---                                       */

/* RHC 21/05/2018 Se van a definir las llaves para cada pestaña de trabajo */
/* Capacidad */
DEF NEW SHARED VAR s-Llave-Capacidad AS CHAR.
DEF NEW SHARED VAR s-Llave-Zona AS CHAR.
DEF NEW SHARED VAR s-Llave-Canal AS CHAR.
DEF NEW SHARED VAR s-Llave-CanalDia AS CHAR.

CASE pParam:
    WHEN "OD" THEN DO:
        s-Llave-Capacidad = "CDSKU_OD".
        s-Llave-Zona = "SZGHRXDIA_OD".
        s-Llave-Canal = "CANALHR_OD".
        s-Llave-CanalDia = "CANALHRXDIA_OD".
    END.
    WHEN "OTR" THEN DO:
        s-Llave-Capacidad = "CDSKU_OTR".
        s-Llave-Zona = "SZGHRXDIA_OTR".
        s-Llave-Canal = "CANALHR_OTR".
        s-Llave-CanalDia = "CANALHRXDIA_OTR".
    END.
    WHEN "DIV" THEN DO:
        s-Llave-Capacidad = "CDSKU_DIV".
        s-Llave-Zona = "SZGHRXDIA_DIV".
        s-Llave-Canal = "CANALHR_DIV".
        s-Llave-CanalDia = "CANALHRXDIA_DIV".
    END.
    OTHERWISE RETURN ERROR.
END CASE.

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
DEFINE VARIABLE h_b-canalhr-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-canalhrxdia-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cfg-skuxcd-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-div-cd AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-div-cd-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-div-cd-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-div-cd-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-estado-od-otr-fchent AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-subzonahrxdia-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv100 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-cfg-calendar-base-fletedifer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-cfg-feriado-cal-log AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cfg-cal-log-base AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cfg-feriado-cal-log AS HANDLE NO-UNDO.

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
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONFIGURACION CALENDARIO LOGISTICO"
         HEIGHT             = 25.85
         WIDTH              = 144.29
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONFIGURACION CALENDARIO LOGISTICO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONFIGURACION CALENDARIO LOGISTICO */
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
CASE pParam:
    WHEN "OD" THEN {&WINDOW-NAME}:TITLE = 'CONFIGURACION CALENDARIO LOGISTICO - ORDENES DE DESPACHO'.
    WHEN "OTR" THEN {&WINDOW-NAME}:TITLE = 'CONFIGURACION CALENDARIO LOGISTICO - ORDENES DE TRANSFERENCIA'.
    WHEN "DIV" THEN {&WINDOW-NAME}:TITLE = 'CONFIGURACION CALENDARIO LOGISTICO - FLETE DIFERENCIADO'.
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
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Capacidad|Programación Despachos|Canales de Venta|Programación por Canal|Estados válidos':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 25.85 , 144.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/v-cfg-cal-log-base.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cfg-cal-log-base ).
       RUN set-position IN h_v-cfg-cal-log-base ( 2.88 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.23 , 60.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-3 ).
       RUN set-position IN h_p-updv97-3 ( 6.12 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-3 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-cfg-skuxcd-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cfg-skuxcd-v3 ).
       RUN set-position IN h_b-cfg-skuxcd-v3 ( 9.08 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-cfg-skuxcd-v3 ( 14.27 , 140.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 23.35 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/q-cfg-calendar-base-fletediferenciado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-cfg-calendar-base-fletedifer ).
       RUN set-position IN h_q-cfg-calendar-base-fletedifer ( 2.88 , 66.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-cfg-cal-log-base. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-3 , 'TableIO':U , h_v-cfg-cal-log-base ).
       RUN add-link IN adm-broker-hdl ( h_q-cfg-calendar-base-fletedifer , 'Record':U , h_v-cfg-cal-log-base ).

       /* Links to SmartBrowser h_b-cfg-skuxcd-v3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-cfg-skuxcd-v3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cfg-cal-log-base ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-3 ,
             h_v-cfg-cal-log-base , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cfg-skuxcd-v3 ,
             h_p-updv97-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-cfg-skuxcd-v3 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-div-cd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-cd ).
       RUN set-position IN h_b-div-cd ( 2.62 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-div-cd ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 8.27 , 75.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.38 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'DIST/v-cfg-feriado-fletediferenciado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cfg-feriado-cal-log ).
       RUN set-position IN h_v-cfg-feriado-cal-log ( 9.62 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 105.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'DIST/b-subzonahrxdia-fletediferenciado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-subzonahrxdia-v3 ).
       RUN set-position IN h_b-subzonahrxdia-v3 ( 10.96 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-subzonahrxdia-v3 ( 13.46 , 105.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 24.42 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'DIST/q-cfg-feriado-fletediferenciado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-cfg-feriado-cal-log ).
       RUN set-position IN h_q-cfg-feriado-cal-log ( 9.62 , 111.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-cfg-feriado-cal-log. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_v-cfg-feriado-cal-log ).
       RUN add-link IN adm-broker-hdl ( h_q-cfg-feriado-cal-log , 'Record':U , h_v-cfg-feriado-cal-log ).

       /* Links to SmartBrowser h_b-subzonahrxdia-v3. */
       RUN add-link IN adm-broker-hdl ( h_b-div-cd , 'Record':U , h_b-subzonahrxdia-v3 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_b-subzonahrxdia-v3 ).

       /* Links to SmartQuery h_q-cfg-feriado-cal-log. */
       RUN add-link IN adm-broker-hdl ( h_b-div-cd , 'Record':U , h_q-cfg-feriado-cal-log ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-cd ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_b-div-cd , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-cfg-feriado-cal-log ,
             h_p-updv96 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-subzonahrxdia-v3 ,
             h_v-cfg-feriado-cal-log , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_b-subzonahrxdia-v3 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-div-cd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-cd-2 ).
       RUN set-position IN h_b-div-cd-2 ( 2.62 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-div-cd-2 ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-canalhr-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-canalhr-v3 ).
       RUN set-position IN h_b-canalhr-v3 ( 9.62 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-canalhr-v3 ( 15.08 , 81.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10-3 ).
       RUN set-position IN h_p-updv10-3 ( 24.96 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10-3 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-canalhr-v3. */
       RUN add-link IN adm-broker-hdl ( h_b-div-cd-2 , 'Record':U , h_b-canalhr-v3 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv10-3 , 'TableIO':U , h_b-canalhr-v3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-cd-2 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-canalhr-v3 ,
             h_b-div-cd-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10-3 ,
             h_b-canalhr-v3 , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-div-cd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-cd-3 ).
       RUN set-position IN h_b-div-cd-3 ( 2.62 , 8.00 ) NO-ERROR.
       RUN set-size IN h_b-div-cd-3 ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'DIST/b-canalhrxdia-fletediferenciado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-canalhrxdia-v3 ).
       RUN set-position IN h_b-canalhrxdia-v3 ( 9.62 , 8.00 ) NO-ERROR.
       RUN set-size IN h_b-canalhrxdia-v3 ( 15.08 , 106.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-2 ).
       RUN set-position IN h_p-updv97-2 ( 24.69 , 8.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-2 ( 1.54 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-canalhrxdia-v3. */
       RUN add-link IN adm-broker-hdl ( h_b-div-cd-3 , 'Record':U , h_b-canalhrxdia-v3 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv97-2 , 'TableIO':U , h_b-canalhrxdia-v3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-cd-3 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-canalhrxdia-v3 ,
             h_b-div-cd-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-2 ,
             h_b-canalhrxdia-v3 , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/b-div-cd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-cd-4 ).
       RUN set-position IN h_b-div-cd-4 ( 2.62 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-div-cd-4 ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-estado-od-otr-fchent.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-estado-od-otr-fchent ).
       RUN set-position IN h_b-estado-od-otr-fchent ( 9.88 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-estado-od-otr-fchent ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv100.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv100 ).
       RUN set-position IN h_p-updv100 ( 16.62 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv100 ( 1.23 , 16.43 ) NO-ERROR.

       /* Links to SmartBrowser h_b-estado-od-otr-fchent. */
       RUN add-link IN adm-broker-hdl ( h_b-div-cd-4 , 'Record':U , h_b-estado-od-otr-fchent ).
       RUN add-link IN adm-broker-hdl ( h_p-updv100 , 'TableIO':U , h_b-estado-od-otr-fchent ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-cd-4 ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-estado-od-otr-fchent ,
             h_b-div-cd-4 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv100 ,
             h_b-estado-od-otr-fchent , 'AFTER':U ).
    END. /* Page 5 */

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

