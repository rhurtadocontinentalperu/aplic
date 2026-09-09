&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS mainmenu 
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
{BIN/S-GLOBAL.I}

DEFINE NEW SHARED VARIABLE  S-PERIODO    AS INTEGER FORMAT "9999" INIT 1996.
DEFINE NEW SHARED VARIABLE  S-NROMES     AS INTEGER FORMAT "9999" .
DEFINE NEW SHARED VARIABLE  s-CodFam     AS CHAR.
DEFINE NEW SHARED VARIABLE  CB-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  PV-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  CL-codcia    AS INTEGER INIT 0.
DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.
DEFINE NEW SHARED VARIABLE  xterm as char.

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartMenu

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-mmenu FILL-PERIODO-1 F-mes RECT-10 
&Scoped-Define DISPLAYED-OBJECTS FILL-PERIODO-1 F-mes F-N-MES 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR mainmenu AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 7 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-PERIODO-1 AS DECIMAL FORMAT "9999":U INITIAL ? 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 9 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-N-MES AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.29 BY .65 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 8  
     SIZE 20.29 BY .88.

DEFINE RECTANGLE RECT-mmenu
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.72 BY 1.35
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-PERIODO-1 AT ROW 1.19 COL 7 COLON-ALIGNED
     F-mes AT ROW 1.19 COL 53 COLON-ALIGNED HELP
          "Mes Actual"
     F-N-MES AT ROW 1.31 COL 61.14 COLON-ALIGNED NO-LABEL
     RECT-mmenu AT ROW 1 COL 1
     RECT-10 AT ROW 1.19 COL 62.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.72 BY 1.38
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartMenu
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW mainmenu ASSIGN
         HIDDEN             = YES
         TITLE              = "Administrador del Sistema"
         HEIGHT             = 1.38
         WIDTH              = 83.72
         MAX-HEIGHT         = 1.73
         MAX-WIDTH          = 83.72
         VIRTUAL-HEIGHT     = 1.73
         VIRTUAL-WIDTH      = 83.72
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT mainmenu:LOAD-ICON("img\api-@@":U) THEN
    MESSAGE "Unable to load icon: img\api-@@"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW mainmenu
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Default                                                              */
/* SETTINGS FOR FILL-IN F-N-MES IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
THEN mainmenu:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB mainmenu 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mainmenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON END-ERROR OF mainmenu /* Administrador del Sistema */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mainmenu mainmenu
ON WINDOW-CLOSE OF mainmenu /* Administrador del Sistema */
DO:
    /* This ADM code must be left here in order for the SmartWindow
       and its descendents to terminate properly on exit. */
    RUN SALIR.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-mes mainmenu
ON VALUE-CHANGED OF F-mes IN FRAME F-Main /* Mes */
DO:
    Assign f-mes.
    s-nromes = f-mes.
    run bin/_mes( f-mes , 1 , output f-n-mes ).
    display f-n-mes with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-PERIODO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-PERIODO-1 mainmenu
ON VALUE-CHANGED OF FILL-PERIODO-1 IN FRAME F-Main /* Periodo */
DO:
   DEF VAR OLD-PERIODO AS INTEGER INIT 0.
   
   OLD-PERIODO = FILL-PERIODO-1.
   
   ASSIGN S-PERIODO      = INPUT FILL-PERIODO-1.
  
   IF S-PERIODO < OLD-PERIODO THEN DO:
      Assign f-mes = 12
             f-mes:screen-value = "12"
             s-nromes = 12.
             run bin/_mes( f-mes , 1 , output f-n-mes ).
             display f-n-mes with frame {&FRAME-NAME}. 
   END.
  
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK mainmenu 


/* ***************************  Main Block  *************************** */
/* Include custom  Main Block code for SmartWindows. */

{adm-vm/method/vmmenu.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects mainmenu _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available mainmenu _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI mainmenu _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(mainmenu)
  THEN DELETE WIDGET mainmenu.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI mainmenu _DEFAULT-ENABLE
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
  DISPLAY FILL-PERIODO-1 F-mes F-N-MES 
      WITH FRAME F-Main IN WINDOW mainmenu.
  ENABLE RECT-mmenu FILL-PERIODO-1 F-mes RECT-10 
      WITH FRAME F-Main IN WINDOW mainmenu.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW mainmenu.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit mainmenu 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize mainmenu 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  FILL-PERIODO-1 = ?.
  DO WITH FRAME {&FRAME-NAME} :
     FILL-PERIODO-1:LIST-ITEMS = P-LIST.
     FILL-PERIODO-1:SCREEN-VALUE = ENTRY(NUM-ENTRIES(P-LIST) , P-LIST).
     FILL-PERIODO-1 = INTEGER(ENTRY(NUM-ENTRIES(P-LIST) , P-LIST)).
     S-Periodo    = FILL-PERIODO-1.
     IF S-PERIODO = YEAR( TODAY ) THEN S-NROMES = MONTH ( TODAY).
     ELSE DO:
          IF S-PERIODO > YEAR(TODAY) THEN S-NROMES =  1.
          ELSE S-NROMES = 12.
     END.    
     F-mes = S-NROMES.
     run bin/_mes( f-mes , 1 , output f-n-mes ).
     display F-mes f-n-mes.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records mainmenu _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartMenu, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed mainmenu 
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


