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

DEF NEW SHARED VAR s-Tabla AS CHAR INIT "PROM".

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-Selecciona-Tdas 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bpromoarticulos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromodivisiones AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromolineas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromomarcas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromonoarticulos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromonolineas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromoofertas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bpromoproveedores AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv09 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-5 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-6 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-7 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-8 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_qvtactabla AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones-02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones-03 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones-04 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpromociones-05 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Selecciona-Tdas 
     LABEL "SELECCIONA TIENDAS" 
     SIZE 24 BY 1.12.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 150 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Selecciona-Tdas AT ROW 7.19 COL 4 WIDGET-ID 4
     RECT-1 AT ROW 2.62 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 152 BY 26.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONFIGURACION GENERAL DE PROMOCIONES"
         HEIGHT             = 26.69
         WIDTH              = 152
         MAX-HEIGHT         = 27.23
         MAX-WIDTH          = 152
         VIRTUAL-HEIGHT     = 27.23
         VIRTUAL-WIDTH      = 152
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
ASSIGN 
       BUTTON-Selecciona-Tdas:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONFIGURACION GENERAL DE PROMOCIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONFIGURACION GENERAL DE PROMOCIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Selecciona-Tdas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Selecciona-Tdas W-Win
ON CHOOSE OF BUTTON-Selecciona-Tdas IN FRAME F-Main /* SELECCIONA TIENDAS */
DO:
  RUN Selecciona-Tiendas IN h_bpromodivisiones.
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
             INPUT  'adm-vm/objects/p-updv03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv09 ).
       RUN set-position IN h_p-updv09 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv09 ( 1.42 , 64.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 67.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.35 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpromociones ).
       RUN set-position IN h_vpromociones ( 2.92 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.96 , 142.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Condición|Tiendas|Promoción|Excepciones' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 5.04 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 22.50 , 150.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/qvtactabla.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_qvtactabla ).
       RUN set-position IN h_qvtactabla ( 1.00 , 90.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_vpromociones. */
       RUN add-link IN adm-broker-hdl ( h_p-updv09 , 'TableIO':U , h_vpromociones ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_qvtactabla. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_qvtactabla ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv09 ,
             BUTTON-Selecciona-Tdas:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_p-updv09 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_vpromociones , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromoarticulos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromoarticulos ).
       RUN set-position IN h_bpromoarticulos ( 6.38 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromoarticulos ( 8.35 , 112.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpromociones-01 ).
       RUN set-position IN h_vpromociones-01 ( 6.38 , 98.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.54 , 21.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-1 ).
       RUN set-position IN h_p-updv96-1 ( 6.38 , 119.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-1 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 8.00 , 98.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 4.81 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromoproveedores.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromoproveedores ).
       RUN set-position IN h_bpromoproveedores ( 14.73 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromoproveedores ( 4.04 , 94.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Initial-Lock = NO-LOCK,
                     Hide-on-Init = no,
                     Disable-on-Init = no,
                     Layout = ,
                     Create-On-Add = ?':U ,
             OUTPUT h_vpromociones-02 ).
       RUN set-position IN h_vpromociones-02 ( 14.73 , 98.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.54 , 21.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-2 ).
       RUN set-position IN h_p-updv96-2 ( 14.73 , 119.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-2 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-3 ).
       RUN set-position IN h_p-updv12-3 ( 17.23 , 98.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-3 ( 1.54 , 31.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromolineas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromolineas ).
       RUN set-position IN h_bpromolineas ( 18.96 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromolineas ( 4.42 , 94.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones-04.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpromociones-04 ).
       RUN set-position IN h_vpromociones-04 ( 18.96 , 98.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.54 , 21.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-4 ).
       RUN set-position IN h_p-updv96-4 ( 18.96 , 119.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-4 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-6 ).
       RUN set-position IN h_p-updv12-6 ( 21.85 , 98.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-6 ( 1.54 , 32.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromomarcas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromomarcas ).
       RUN set-position IN h_bpromomarcas ( 23.62 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromomarcas ( 3.50 , 67.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones-05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpromociones-05 ).
       RUN set-position IN h_vpromociones-05 ( 23.62 , 71.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.54 , 21.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 23.62 , 92.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-8 ).
       RUN set-position IN h_p-updv12-8 ( 25.50 , 71.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-8 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_bpromoarticulos. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_bpromoarticulos ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromoarticulos ).

       /* Links to SmartViewer h_vpromociones-01. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-1 , 'TableIO':U , h_vpromociones-01 ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones-01 ).

       /* Links to SmartBrowser h_bpromoproveedores. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-3 , 'TableIO':U , h_bpromoproveedores ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromoproveedores ).

       /* Links to SmartViewer h_vpromociones-02. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-2 , 'TableIO':U , h_vpromociones-02 ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones-02 ).

       /* Links to SmartBrowser h_bpromolineas. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-6 , 'TableIO':U , h_bpromolineas ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromolineas ).

       /* Links to SmartViewer h_vpromociones-04. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-4 , 'TableIO':U , h_vpromociones-04 ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones-04 ).

       /* Links to SmartBrowser h_bpromomarcas. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-8 , 'TableIO':U , h_bpromomarcas ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromomarcas ).

       /* Links to SmartViewer h_vpromociones-05. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_vpromociones-05 ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones-05 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromoarticulos ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones-01 ,
             h_bpromoarticulos , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-1 ,
             h_vpromociones-01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             BUTTON-Selecciona-Tdas:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromoproveedores ,
             h_p-updv12-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones-02 ,
             h_bpromoproveedores , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-2 ,
             h_vpromociones-02 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-3 ,
             h_p-updv96-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromolineas ,
             h_p-updv12-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones-04 ,
             h_bpromolineas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-4 ,
             h_vpromociones-04 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-6 ,
             h_p-updv96-4 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromomarcas ,
             h_p-updv12-6 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones-05 ,
             h_bpromomarcas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_vpromociones-05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-8 ,
             h_p-updv96 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromodivisiones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromodivisiones ).
       RUN set-position IN h_bpromodivisiones ( 8.50 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromodivisiones ( 10.77 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 9.85 , 71.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.81 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bpromodivisiones. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_bpromodivisiones ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromodivisiones ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromodivisiones ,
             BUTTON-Selecciona-Tdas:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_bpromodivisiones , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromoofertas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromoofertas ).
       RUN set-position IN h_bpromoofertas ( 8.54 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromoofertas ( 6.69 , 100.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/vpromociones-03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpromociones-03 ).
       RUN set-position IN h_vpromociones-03 ( 8.54 , 104.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.42 , 21.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-3 ).
       RUN set-position IN h_p-updv96-3 ( 8.54 , 125.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-3 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-4 ).
       RUN set-position IN h_p-updv12-4 ( 15.27 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-4 ( 1.35 , 35.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bpromoofertas. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-4 , 'TableIO':U , h_bpromoofertas ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromoofertas ).

       /* Links to SmartViewer h_vpromociones-03. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-3 , 'TableIO':U , h_vpromociones-03 ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_vpromociones-03 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromoofertas ,
             BUTTON-Selecciona-Tdas:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpromociones-03 ,
             h_bpromoofertas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-3 ,
             h_vpromociones-03 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-4 ,
             h_p-updv96-3 , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromonolineas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromonolineas ).
       RUN set-position IN h_bpromonolineas ( 8.88 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromonolineas ( 6.69 , 91.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-5 ).
       RUN set-position IN h_p-updv12-5 ( 10.23 , 95.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-5 ( 4.62 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/bpromonoarticulos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bpromonoarticulos ).
       RUN set-position IN h_bpromonoarticulos ( 16.00 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bpromonoarticulos ( 9.23 , 97.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-7 ).
       RUN set-position IN h_p-updv12-7 ( 17.35 , 83.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-7 ( 4.62 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bpromonolineas. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-5 , 'TableIO':U , h_bpromonolineas ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromonolineas ).

       /* Links to SmartBrowser h_bpromonoarticulos. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-7 , 'TableIO':U , h_bpromonoarticulos ).
       RUN add-link IN adm-broker-hdl ( h_qvtactabla , 'Record':U , h_bpromonoarticulos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromonolineas ,
             BUTTON-Selecciona-Tdas:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-5 ,
             h_bpromonolineas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bpromonoarticulos ,
             h_p-updv12-5 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-7 ,
             h_bpromonoarticulos , 'AFTER':U ).
    END. /* Page 4 */

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
  ENABLE RECT-1 BUTTON-Selecciona-Tdas 
      WITH FRAME F-Main IN WINDOW W-Win.
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
  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  CASE RETURN-VALUE:
      WHEN "2" THEN BUTTON-Selecciona-Tdas:HIDDEN IN FRAME {&FRAME-NAME} = NO.
      OTHERWISE BUTTON-Selecciona-Tdas:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END CASE.

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
  BUTTON-Selecciona-Tdas:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
    WHEN "Disable-Update" THEN DO:
        IF h_p-updv12 <> ?   THEN RUN dispatch IN h_p-updv12 ('disable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
        IF h_p-updv12-3 <> ? THEN RUN dispatch IN h_p-updv12-3 ('disable':U).
        IF h_p-updv12-4 <> ? THEN RUN dispatch IN h_p-updv12-4 ('disable':U).
        IF h_p-updv12-5 <> ? THEN RUN dispatch IN h_p-updv12-5 ('disable':U).
        IF h_p-updv12-6 <> ? THEN RUN dispatch IN h_p-updv12-6 ('disable':U).
        IF h_p-updv12-7 <> ? THEN RUN dispatch IN h_p-updv12-7 ('disable':U).
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('disable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('disable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('disable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('disable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('disable':U).
        RUN dispatch IN h_folder ('disable':U).

    END.
    WHEN "Enable-Update" THEN DO:
        IF h_p-updv12 <> ?   THEN RUN dispatch IN h_p-updv12 ('enable':U).
        IF h_p-updv12-2 <> ? THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
        IF h_p-updv12-3 <> ? THEN RUN dispatch IN h_p-updv12-3 ('enable':U).
        IF h_p-updv12-4 <> ? THEN RUN dispatch IN h_p-updv12-4 ('enable':U).
        IF h_p-updv12-5 <> ? THEN RUN dispatch IN h_p-updv12-5 ('enable':U).
        IF h_p-updv12-6 <> ? THEN RUN dispatch IN h_p-updv12-6 ('enable':U).
        IF h_p-updv12-7 <> ? THEN RUN dispatch IN h_p-updv12-7 ('enable':U).
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('enable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('enable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('enable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('enable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('enable':U).
        RUN dispatch IN h_folder ('enable':U).
    END.
    WHEN "Disable-Heads" THEN DO:
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('disable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('disable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('disable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('disable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('disable':U).
        IF h_p-updv12-2 <> ?   THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
        IF h_p-updv12-3 <> ?   THEN RUN dispatch IN h_p-updv12-3 ('disable':U).
        IF h_p-updv12-4 <> ?   THEN RUN dispatch IN h_p-updv12-4 ('disable':U).
        IF h_p-updv12-6 <> ?   THEN RUN dispatch IN h_p-updv12-6 ('disable':U).
    END.
    WHEN "Disable-Heads-1" THEN DO:
        IF h_p-updv09 <> ?   THEN RUN dispatch IN h_p-updv09 ('disable':U).
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('disable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('disable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('disable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('disable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('disable':U).
    END.
    WHEN "Enable-Heads" THEN DO:
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('enable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('enable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('enable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('enable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('enable':U).
        IF h_p-updv12-2 <> ?   THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
        IF h_p-updv12-3 <> ?   THEN RUN dispatch IN h_p-updv12-3 ('enable':U).
        IF h_p-updv12-4 <> ?   THEN RUN dispatch IN h_p-updv12-4 ('enable':U).
        IF h_p-updv12-6 <> ?   THEN RUN dispatch IN h_p-updv12-6 ('enable':U).
    END.
    WHEN "Enable-Heads-1" THEN DO:
        IF h_p-updv09 <> ?   THEN RUN dispatch IN h_p-updv09 ('enable':U).
        IF h_p-updv96-1 <> ?   THEN RUN dispatch IN h_p-updv96-1 ('enable':U).
        IF h_p-updv96-2 <> ?   THEN RUN dispatch IN h_p-updv96-2 ('enable':U).
        IF h_p-updv96-3 <> ?   THEN RUN dispatch IN h_p-updv96-3 ('enable':U).
        IF h_p-updv96-4 <> ?   THEN RUN dispatch IN h_p-updv96-4 ('enable':U).
        IF h_p-updv96 <> ?   THEN RUN dispatch IN h_p-updv96 ('enable':U).
    END.
    WHEN 'Open-Browses' THEN DO:
        /*MESSAGE 'Repinta browses'.*/
        IF h_bpromoarticulos <> ? THEN  RUN dispatch IN h_bpromoarticulos ('open-query':U).
        IF h_bpromoproveedores <> ? THEN  RUN dispatch IN h_bpromoproveedores ('open-query':U).
        IF h_bpromolineas <> ? THEN  RUN dispatch IN h_bpromolineas ('open-query':U).
        IF h_bpromodivisiones <> ? THEN  RUN dispatch IN h_bpromodivisiones ('open-query':U).
        IF h_bpromoarticulos <> ? THEN  RUN dispatch IN h_bpromoarticulos ('open-query':U).
        IF h_bpromoofertas <> ? THEN  RUN dispatch IN h_bpromoofertas ('open-query':U).
        IF h_bpromonolineas <> ? THEN  RUN dispatch IN h_bpromonolineas ('open-query':U).
        IF h_bpromonoarticulos <> ? THEN  RUN dispatch IN h_bpromonoarticulos ('open-query':U).
        IF h_bpromomarcas <> ? THEN  RUN dispatch IN h_bpromomarcas ('open-query':U).
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

