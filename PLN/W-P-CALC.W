&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
/* Procedure Description
"Generaci¢n de calculos de planilla"
*/
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEFINE VARIABLE h_b-bole AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-bole1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updpar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updpar-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updpar-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updpar-5 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updsav-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updva2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updva2-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updva2-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-calc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-conc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-plan AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-varg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-bole1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-bt-cal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-calc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-calc1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-conc AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-plan AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-varg AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.57 BY 25.62.


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
         TITLE              = "Programaci¢n de Calculos"
         HEIGHT             = 25.62
         WIDTH              = 139.57
         MAX-HEIGHT         = 25.62
         MAX-WIDTH          = 149.57
         VIRTUAL-HEIGHT     = 25.62
         VIRTUAL-WIDTH      = 149.57
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img/calculo":U) THEN
    MESSAGE "Unable to load icon: img/calculo"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
ON END-ERROR OF W-Win /* Programaci¢n de Calculos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Programaci¢n de Calculos */
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
             INPUT  'pln/v-plan.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-plan ).
       RUN set-position IN h_v-plan ( 1.23 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 52.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updva2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updva2 ).
       RUN set-position IN h_p-updva2 ( 1.23 , 60.29 ) NO-ERROR.
       RUN set-size IN h_p-updva2 ( 1.35 , 29.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-calc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-calc ).
       RUN set-position IN h_v-calc ( 2.81 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 52.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updva2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updva2-2 ).
       RUN set-position IN h_p-updva2-2 ( 2.81 , 60.29 ) NO-ERROR.
       RUN set-size IN h_p-updva2-2 ( 1.35 , 29.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'C lculos|Procesos|Conceptos|Variables|Contables' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 4.27 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 22.12 , 139.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-plan.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-plan ).
       RUN set-position IN h_q-plan ( 1.23 , 53.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.31 , 7.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-calc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-calc ).
       RUN set-position IN h_q-calc ( 2.81 , 53.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.31 , 6.86 ) */

       /* Links to SmartViewer h_v-plan. */
       RUN add-link IN adm-broker-hdl ( h_p-updva2 , 'TableIO':U , h_v-plan ).
       RUN add-link IN adm-broker-hdl ( h_q-plan , 'Record':U , h_v-plan ).

       /* Links to SmartViewer h_v-calc. */
       RUN add-link IN adm-broker-hdl ( h_p-updva2-2 , 'TableIO':U , h_v-calc ).
       RUN add-link IN adm-broker-hdl ( h_q-calc , 'Record':U , h_v-calc ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-calc. */
       RUN add-link IN adm-broker-hdl ( h_q-plan , 'Navigation':U , h_q-calc ).
       RUN add-link IN adm-broker-hdl ( h_q-plan , 'Record':U , h_q-calc ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updva2 ,
             h_v-plan , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-calc ,
             h_p-updva2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updva2-2 ,
             h_v-calc , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_p-updva2-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-plan ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-calc ,
             h_q-plan , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-bole.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-bole ).
       RUN set-position IN h_b-bole ( 5.50 , 2.72 ) NO-ERROR.
       RUN set-size IN h_b-bole ( 5.15 , 73.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-bt-cal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-bt-cal ).
       RUN set-position IN h_v-bt-cal ( 5.62 , 96.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.19 , 14.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updva2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updva2-3 ).
       RUN set-position IN h_p-updva2-3 ( 6.00 , 79.00 ) NO-ERROR.
       RUN set-size IN h_p-updva2-3 ( 4.00 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-bole1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-bole1 ).
       RUN set-position IN h_v-bole1 ( 10.77 , 2.57 ) NO-ERROR.
       /* Size in UIB:  ( 14.81 , 126.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updpar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updpar ).
       RUN set-position IN h_p-updpar ( 12.15 , 129.00 ) NO-ERROR.
       RUN set-size IN h_p-updpar ( 3.00 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-bole. */
       RUN add-link IN adm-broker-hdl ( h_p-updva2-3 , 'TableIO':U , h_b-bole ).
       RUN add-link IN adm-broker-hdl ( h_q-calc , 'Record':U , h_b-bole ).

       /* Links to SmartViewer h_v-bt-cal. */
       RUN add-link IN adm-broker-hdl ( h_q-calc , 'Record':U , h_v-bt-cal ).

       /* Links to SmartViewer h_v-bole1. */
       RUN add-link IN adm-broker-hdl ( h_b-bole , 'Record':U , h_v-bole1 ).
       RUN add-link IN adm-broker-hdl ( h_p-updpar , 'TableIO':U , h_v-bole1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-bole ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-bt-cal ,
             h_b-bole , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updva2-3 ,
             h_v-bt-cal , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-bole1 ,
             h_p-updva2-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updpar ,
             h_v-bole1 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-calc1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-calc1 ).
       RUN set-position IN h_v-calc1 ( 5.81 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 14.62 , 95.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updpar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updpar-4 ).
       RUN set-position IN h_p-updpar-4 ( 8.88 , 99.00 ) NO-ERROR.
       RUN set-size IN h_p-updpar-4 ( 3.00 , 10.43 ) NO-ERROR.

       /* Links to SmartViewer h_v-calc1. */
       RUN add-link IN adm-broker-hdl ( h_p-updpar-4 , 'TableIO':U , h_v-calc1 ).
       RUN add-link IN adm-broker-hdl ( h_q-calc , 'Record':U , h_v-calc1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-calc1 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updpar-4 ,
             h_v-calc1 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-conc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-conc ).
       RUN set-position IN h_v-conc ( 6.00 , 10.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.42 , 71.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 14.58 , 10.00 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.50 , 18.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'ADM-VM/OBJECTS/P-UPDV10.W':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updsav-2 ).
       RUN set-position IN h_p-updsav-2 ( 14.58 , 29.29 ) NO-ERROR.
       RUN set-size IN h_p-updsav-2 ( 1.54 , 52.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-conc.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-conc ).
       RUN set-position IN h_q-conc ( 6.58 , 36.00 ) NO-ERROR.
       /* Size in UIB:  ( 0.96 , 15.86 ) */

       /* Links to SmartViewer h_v-conc. */
       RUN add-link IN adm-broker-hdl ( h_p-updsav-2 , 'TableIO':U , h_v-conc ).
       RUN add-link IN adm-broker-hdl ( h_q-conc , 'Record':U , h_v-conc ).

       /* Links to SmartQuery h_q-conc. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-conc ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-conc ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_v-conc , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updsav-2 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-conc ,
             h_q-calc , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/v-varg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-varg ).
       RUN set-position IN h_v-varg ( 6.00 , 7.86 ) NO-ERROR.
       /* Size in UIB:  ( 10.73 , 69.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updpar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updpar-2 ).
       RUN set-position IN h_p-updpar-2 ( 9.27 , 77.57 ) NO-ERROR.
       RUN set-size IN h_p-updpar-2 ( 3.00 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/q-varg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-varg ).
       RUN set-position IN h_q-varg ( 6.04 , 2.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.31 , 5.43 ) */

       /* Links to SmartViewer h_v-varg. */
       RUN add-link IN adm-broker-hdl ( h_p-updpar-2 , 'TableIO':U , h_v-varg ).
       RUN add-link IN adm-broker-hdl ( h_q-varg , 'Record':U , h_v-varg ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-varg ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updpar-2 ,
             h_v-varg , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pln/b-bole1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-bole1 ).
       RUN set-position IN h_b-bole1 ( 6.77 , 7.00 ) NO-ERROR.
       RUN set-size IN h_b-bole1 ( 10.96 , 75.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-updpar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updpar-5 ).
       RUN set-position IN h_p-updpar-5 ( 9.65 , 85.00 ) NO-ERROR.
       RUN set-size IN h_p-updpar-5 ( 3.00 , 9.29 ) NO-ERROR.

       /* Links to SmartBrowser h_b-bole1. */
       RUN add-link IN adm-broker-hdl ( h_p-updpar-5 , 'TableIO':U , h_b-bole1 ).
       RUN add-link IN adm-broker-hdl ( h_q-calc , 'Record':U , h_b-bole1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-bole1 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updpar-5 ,
             h_b-bole1 , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available W-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-show-errors W-Win 
PROCEDURE local-show-errors :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  message "ERROR CAPTURADO" VIEW-AS ALERT-BOX.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'show-errors':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

