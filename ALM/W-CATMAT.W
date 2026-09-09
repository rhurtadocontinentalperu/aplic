&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE s-nroser   AS INTEGER.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-3 f-copias BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS f-copias 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-subcat-web AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv99 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-catmat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-stkminxcamp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-catmat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-catmat-web AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-equiestad AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-equiestad-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-matg-attr AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-stkminxcamp AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "EAN" 
     SIZE 8.72 BY .69.

DEFINE BUTTON BUTTON-4 
     LABEL "Cod.Barra" 
     SIZE 8.72 BY .69.

DEFINE VARIABLE f-copias AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-3 AT ROW 24.08 COL 77
     f-copias AT ROW 24.62 COL 84 COLON-ALIGNED NO-LABEL
     BUTTON-4 AT ROW 24.85 COL 77
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 109.86 BY 25.27
         FONT 4.


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
         TITLE              = "Catalogo de Articulos"
         HEIGHT             = 25.27
         WIDTH              = 109.86
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
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
ON END-ERROR OF W-Win /* Catalogo de Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Catalogo de Articulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* EAN */
DO:
      assign f-copias.
    S-NROSER = F-COPIAS.
    Run Barras in h_v-catmat(2).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Cod.Barra */
DO:
  assign f-copias.
  S-NROSER = F-COPIAS.
  Run Barras in h_v-catmat(1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-copias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-copias W-Win
ON LEAVE OF f-copias IN FRAME F-Main
DO:
  ASSIGN F-COPIAS.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_Handle = THIS-PROCEDURE.

/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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
             INPUT  'src/adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Registro|Equivalencia|Web|Estadísticas|Reposición|Atributos' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 25.19 , 109.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             BUTTON-3:HANDLE IN FRAME F-Main , 'BEFORE':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-catmat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Initial-Lock = NO-LOCK,
                     Hide-on-Init = no,
                     Disable-on-Init = no,
                     Layout = ,
                     Create-On-Add = ?':U ,
             OUTPUT h_v-catmat ).
       RUN set-position IN h_v-catmat ( 2.35 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 21.46 , 107.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 24.08 , 16.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.58 , 16.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 24.08 , 32.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.62 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-catmat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-catmat ).
       RUN set-position IN h_q-catmat ( 24.27 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.19 , 12.57 ) */

       /* Links to SmartViewer h_v-catmat. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_v-catmat ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-catmat ).

       /* Links to SmartQuery h_q-catmat. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-catmat ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-catmat ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-catmat , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-catmat ,
             BUTTON-4:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 2.35 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-equiestad.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-equiestad ).
       RUN set-position IN h_v-equiestad ( 4.23 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.42 , 87.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-equiestad. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_v-equiestad ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-equiestad ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-equiestad ,
             h_p-updv96 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv99 ).
       RUN set-position IN h_p-updv99 ( 2.35 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv99 ( 1.42 , 33.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-catmat-web.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-catmat-web ).
       RUN set-position IN h_v-catmat-web ( 3.96 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 12.38 , 92.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-subcat-web.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-subcat-web ).
       RUN set-position IN h_b-subcat-web ( 16.88 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-subcat-web ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 17.69 , 71.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.58 , 11.00 ) NO-ERROR.

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-catmat-web. */
       RUN add-link IN adm-broker-hdl ( h_p-updv99 , 'TableIO':U , h_v-catmat-web ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-catmat-web ).

       /* Links to SmartBrowser h_b-subcat-web. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-subcat-web ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_b-subcat-web ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv99 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-catmat-web ,
             h_p-updv99 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-subcat-web ,
             h_v-catmat-web , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-subcat-web , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-2 ).
       RUN set-position IN h_p-updv96-2 ( 3.15 , 6.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-2 ( 1.54 , 26.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-equiestad-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-equiestad-01 ).
       RUN set-position IN h_v-equiestad-01 ( 5.31 , 3.14 ) NO-ERROR.
       /* Size in UIB:  ( 9.08 , 103.57 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-equiestad-01. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-2 , 'TableIO':U , h_v-equiestad-01 ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-equiestad-01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-2 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-equiestad-01 ,
             h_p-updv96-2 , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-3 ).
       RUN set-position IN h_p-updv97-3 ( 2.35 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-3 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-stkminxcamp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-stkminxcamp ).
       RUN set-position IN h_v-stkminxcamp ( 3.88 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.58 , 92.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/t-stkminxcamp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-stkminxcamp ).
       RUN set-position IN h_t-stkminxcamp ( 9.46 , 5.00 ) NO-ERROR.
       RUN set-size IN h_t-stkminxcamp ( 12.62 , 92.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 10.04 , 97.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 6.15 , 11.00 ) NO-ERROR.

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-stkminxcamp. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-3 , 'TableIO':U , h_v-stkminxcamp ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-stkminxcamp ).

       /* Links to SmartBrowser h_t-stkminxcamp. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_t-stkminxcamp ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_t-stkminxcamp ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-3 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-stkminxcamp ,
             h_p-updv97-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-stkminxcamp ,
             h_v-stkminxcamp , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_t-stkminxcamp , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97-2 ).
       RUN set-position IN h_p-updv97-2 ( 2.54 , 5.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97-2 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-matg-attr.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-matg-attr ).
       RUN set-position IN h_v-matg-attr ( 4.27 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 17.50 , 71.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-matg-attr. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97-2 , 'TableIO':U , h_v-matg-attr ).
       RUN add-link IN adm-broker-hdl ( h_q-catmat , 'Record':U , h_v-matg-attr ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97-2 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-matg-attr ,
             h_p-updv97-2 , 'AFTER':U ).
    END. /* Page 6 */

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
  DISPLAY f-copias 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-3 f-copias BUTTON-4 
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
DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'Repinta-Minimos' THEN  RUN dispatch IN h_t-stkminxcamp ('open-query':U).
    WHEN 'Repinta-Reposicion' THEN RUN dispatch IN h_t-stkminxcamp ('open-query':U).
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

