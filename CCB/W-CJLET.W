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
DEFINE NEW SHARED VARIABLE S-CODDOC   AS CHAR INITIAL 'CJE'.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-CODCOB   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE NEW SHARED VARIABLE s-cndcre   AS CHAR.
DEFINE NEW SHARED VARIABLE S-FCHDOC   AS DATE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE NEW SHARED VARIABLE S-CONDIC   AS CHAR.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.

IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

DEFINE NEW SHARED TEMP-TABLE MVTO LIKE CcbDMvto.

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
&Scoped-Define ENABLED-OBJECTS RECT-23 RECT-24 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cjlet1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cjlet2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpcj1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpcj2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-cjlet AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-cjlet AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.88.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 6.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RECT-23 AT ROW 4.27 COL 1
     RECT-24 AT ROW 9.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.72 BY 16.12
         FONT 4.


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
         TITLE              = "Canje de Letras"
         HEIGHT             = 16.12
         WIDTH              = 82.72
         MAX-HEIGHT         = 16.12
         MAX-WIDTH          = 82.72
         VIRTUAL-HEIGHT     = 16.12
         VIRTUAL-WIDTH      = 82.72
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
ON END-ERROR OF W-Win /* Canje de Letras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Canje de Letras */
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
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
             INPUT  'aplic/ccb/v-cjlet.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-cjlet ).
       RUN set-position IN h_v-cjlet ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.19 , 82.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 15.46 , 10.57 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.35 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 15.46 , 29.00 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.42 , 53.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/q-cjlet.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-cjlet ).
       RUN set-position IN h_q-cjlet ( 15.58 , 1.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.04 , 8.29 ) */

       /* Links to SmartViewer h_v-cjlet. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-cjlet ).
       RUN add-link IN adm-broker-hdl ( h_q-cjlet , 'Record':U , h_v-cjlet ).

       /* Links to SmartQuery h_q-cjlet. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-cjlet ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-cjlet , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-cjlet ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-cjlet1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjlet1 ).
       RUN set-position IN h_b-cjlet1 ( 4.54 , 15.29 ) NO-ERROR.
       RUN set-size IN h_b-cjlet1 ( 4.42 , 56.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-cjlet2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cjlet2 ).
       RUN set-position IN h_b-cjlet2 ( 9.35 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-cjlet2 ( 5.81 , 72.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96-3 ).
       RUN set-position IN h_p-updv96-3 ( 9.88 , 73.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96-3 ( 4.04 , 9.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cjlet1. */
       RUN add-link IN adm-broker-hdl ( h_q-cjlet , 'Record':U , h_b-cjlet1 ).

       /* Links to SmartBrowser h_b-cjlet2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96-3 , 'TableIO':U , h_b-cjlet2 ).
       RUN add-link IN adm-broker-hdl ( h_q-cjlet , 'Record':U , h_b-cjlet2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cjlet1 ,
             h_v-cjlet , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cjlet2 ,
             h_b-cjlet1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96-3 ,
             h_b-cjlet2 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.r':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 4.54 , 67.29 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.27 , 10.43 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-tmpcj1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpcj1 ).
       RUN set-position IN h_b-tmpcj1 ( 4.50 , 6.00 ) NO-ERROR.
       RUN set-size IN h_b-tmpcj1 ( 4.31 , 61.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-tmpcj2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpcj2 ).
       RUN set-position IN h_b-tmpcj2 ( 9.50 , 3.29 ) NO-ERROR.
       RUN set-size IN h_b-tmpcj2 ( 5.15 , 75.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 13.69 , 3.57 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpcj1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpcj1 ).

       /* Links to SmartBrowser h_b-tmpcj2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_b-tmpcj2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpcj1 ,
             h_v-cjlet , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpcj2 ,
             h_b-tmpcj1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_b-tmpcj2 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 2 ).

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
  ENABLE RECT-23 RECT-24 
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
  ASSIGN lh_Handle = THIS-PROCEDURE.
  RUN Procesa-Handle ('Pagina1').
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
DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "browse" THEN DO:
          RUN dispatch IN h_b-cjlet1 ('open-query':U).
          RUN dispatch IN h_b-cjlet2 ('open-query':U).
      END.
    WHEN "browse1" THEN DO:
          RUN dispatch IN h_b-cjlet1 ('open-query':U).
          RUN dispatch IN h_b-tmpcj1 ('open-query':U).
      END.
    WHEN "browse2" THEN DO:
          RUN dispatch IN h_b-cjlet2 ('open-query':U).
          RUN dispatch IN h_b-tmpcj2 ('open-query':U).
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:    
         RUN select-page(1).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:    
         RUN select-page(2).
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

