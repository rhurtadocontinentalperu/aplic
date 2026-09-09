&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-prdnew AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-prdprm AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-prdvap AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-option AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-option-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-option-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-detmat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-detmat-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-detmat-3 AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 16.08
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
         TITLE              = "Consulta de Articulos"
         HEIGHT             = 16.08
         WIDTH              = 89.72
         MAX-HEIGHT         = 16.23
         MAX-WIDTH          = 90.29
         VIRTUAL-HEIGHT     = 16.23
         VIRTUAL-WIDTH      = 90.29
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Articulos */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
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
             INPUT  'adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Productos Nuevos|Promociones|Variaciones de Precios':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 14.04 , 89.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-option.r':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'Style = Combo-Box,
                     Drawn-in-UIB = yes,
                     Case-Attribute = SortBy-Case,
                     Case-Changed-Event = Open-Query,
                     Dispatch-Open-Query = yes,
                     Edge-Pixels = 2,
                     Label = ':U + '' + ',
                     Link-Name = SortBy-Target,
                     Margin-Pixels = 6,
                     Options-Attribute = SortBy-Options,
                     Font = 4':U ,
             OUTPUT h_p-option ).
       RUN set-position IN h_p-option ( 1.00 , 61.72 ) NO-ERROR.
       RUN set-size IN h_p-option ( 1.50 , 28.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/b-prdnew.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ,
                     SortBy-Case = Fecha Ingreso':U ,
             OUTPUT h_b-prdnew ).
       RUN set-position IN h_b-prdnew ( 2.88 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 12.04 , 88.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/v-detmat.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-detmat-3 ).
       RUN set-position IN h_v-detmat-3 ( 15.19 , 1.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.81 , 85.86 ) */

       /* Links to SmartLookup h_b-prdnew. */
       RUN add-link IN adm-broker-hdl ( h_p-option , 'SortBy':U , h_b-prdnew ).

       /* Links to SmartViewer h_v-detmat-3. */
       RUN add-link IN adm-broker-hdl ( h_b-prdnew , 'Record':U , h_v-detmat-3 ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/b-prdprm.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-prdprm ).
       RUN set-position IN h_b-prdprm ( 2.88 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 12.04 , 88.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/v-detmat.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-detmat-2 ).
       RUN set-position IN h_v-detmat-2 ( 15.04 , 2.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.81 , 85.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-option.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Style = Combo-Box,
                     Drawn-in-UIB = yes,
                     Case-Attribute = SortBy-Case,
                     Case-Changed-Event = Open-Query,
                     Dispatch-Open-Query = yes,
                     Edge-Pixels = 2,
                     Label = ':U + '' + ',
                     Link-Name = SortBy-Target,
                     Margin-Pixels = 6,
                     Options-Attribute = SortBy-Options,
                     Font = 4':U ,
             OUTPUT h_p-option-2 ).
       RUN set-position IN h_p-option-2 ( 1.00 , 61.72 ) NO-ERROR.
       RUN set-size IN h_p-option-2 ( 1.50 , 28.14 ) NO-ERROR.

       /* Links to SmartLookup h_b-prdprm. */
       RUN add-link IN adm-broker-hdl ( h_p-option-2 , 'SortBy':U , h_b-prdprm ).

       /* Links to SmartViewer h_v-detmat-2. */
       RUN add-link IN adm-broker-hdl ( h_b-prdprm , 'Record':U , h_v-detmat-2 ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/b-prdvap.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-prdvap ).
       RUN set-position IN h_b-prdvap ( 2.88 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 12.04 , 88.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/v-detmat.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-detmat ).
       RUN set-position IN h_v-detmat ( 15.08 , 2.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.81 , 85.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-option.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Style = Combo-Box,
                     Drawn-in-UIB = yes,
                     Case-Attribute = SortBy-Case,
                     Case-Changed-Event = Open-Query,
                     Dispatch-Open-Query = yes,
                     Edge-Pixels = 2,
                     Label = ':U + '' + ',
                     Link-Name = SortBy-Target,
                     Margin-Pixels = 6,
                     Options-Attribute = SortBy-Options,
                     Font = 4':U ,
             OUTPUT h_p-option-3 ).
       RUN set-position IN h_p-option-3 ( 1.00 , 61.72 ) NO-ERROR.
       RUN set-size IN h_p-option-3 ( 1.50 , 28.14 ) NO-ERROR.

       /* Links to SmartLookup h_b-prdvap. */
       RUN add-link IN adm-broker-hdl ( h_p-option-3 , 'SortBy':U , h_b-prdvap ).

       /* Links to SmartViewer h_v-detmat. */
       RUN add-link IN adm-broker-hdl ( h_b-prdvap , 'Record':U , h_v-detmat ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 3 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


