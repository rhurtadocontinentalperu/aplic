&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

DEFINE VARIABLE ok-wait-state AS LOGICAL.
ok-wait-state = SESSION:SET-WAIT-STATE("").

{bin\s-global.i}
{pln\s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PL-FLG-SEM PL-PERS

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 PL-FLG-SEM.codper PL-PERS.patper ~
PL-PERS.matper PL-PERS.nomper PL-FLG-SEM.Exceso-Sem 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 PL-FLG-SEM.Exceso-Sem 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2~
 ~{&FP1}Exceso-Sem ~{&FP2}Exceso-Sem ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 PL-FLG-SEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 PL-FLG-SEM
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-codcia ~
 AND PL-FLG-SEM.Periodo = s-periodo ~
 AND PL-FLG-SEM.codpln = FILL-IN-pln ~
 AND PL-FLG-SEM.NroSem = FILL-IN-nrosem NO-LOCK, ~
      EACH PL-PERS OF PL-FLG-SEM  NO-LOCK ~
    BY PL-FLG-SEM.Proyecto ~
       BY PL-PERS.patper ~
        BY PL-PERS.matper ~
         BY PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 PL-FLG-SEM PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 PL-FLG-SEM


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 BROWSE-2 Btn-UP-3 FILL-IN-pln ~
Btn-DOWN-3 Btn-UP FILL-IN-NroSem Btn-DOWN-2 Btn-salir 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-pln FILL-IN-NroSem 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-3 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-salir 
     LABEL "&Salir" 
     SIZE 9.14 BY .85.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-3 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-NroSem AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-pln AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.86 BY 10.73.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      PL-FLG-SEM, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 C-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      PL-FLG-SEM.codper
      PL-PERS.patper
      PL-PERS.matper
      PL-PERS.nomper FORMAT "X(20)"
      PL-FLG-SEM.Exceso-Sem
  ENABLE
      PL-FLG-SEM.Exceso-Sem
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61 BY 8.92
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BROWSE-2 AT ROW 2.73 COL 2.14
     Btn-UP-3 AT ROW 1.31 COL 15.72
     FILL-IN-pln AT ROW 1.54 COL 9.86 COLON-ALIGNED
     Btn-DOWN-3 AT ROW 1.92 COL 15.72
     Btn-UP AT ROW 1.31 COL 30.72
     FILL-IN-NroSem AT ROW 1.54 COL 24.86 COLON-ALIGNED
     Btn-DOWN-2 AT ROW 1.92 COL 30.72
     Btn-salir AT ROW 1.54 COL 53.14
     RECT-3 AT ROW 1.15 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.29 BY 11.19
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Excesos de Semana"
         HEIGHT             = 11
         WIDTH              = 63.29
         MAX-HEIGHT         = 11.19
         MAX-WIDTH          = 63.29
         VIRTUAL-HEIGHT     = 11.19
         VIRTUAL-WIDTH      = 63.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Default                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM "
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-SEM.Proyecto|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-codcia
 AND PL-FLG-SEM.Periodo = s-periodo
 AND PL-FLG-SEM.codpln = FILL-IN-pln
 AND PL-FLG-SEM.NroSem = FILL-IN-nrosem"
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   > integral.PL-PERS.nomper
"PL-PERS.nomper" ? "X(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.PL-FLG-SEM.Exceso-Sem
"PL-FLG-SEM.Exceso-Sem" ? ? "decimal" ? ? ? ? ? ? yes ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Excesos de Semana */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Excesos de Semana */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 C-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME DEFAULT-FRAME
DO:
    IF INPUT FRAME {&FRAME-NAME} FILL-IN-nrosem - 1 >= 1 THEN DO:
        DISPLAY INPUT FILL-IN-nrosem - 1 @ FILL-IN-nrosem WITH FRAME {&FRAME-NAME}.
        ASSIGN FILL-IN-nrosem.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-3 C-Win
ON CHOOSE OF Btn-DOWN-3 IN FRAME DEFAULT-FRAME
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND PREV PL-PLAN WHERE PL-PLAN.tippln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN FILL-IN-pln = PL-PLAN.CODPLN.
            DISPLAY FILL-IN-pln WITH FRAME {&FRAME-NAME}.
    END.
    IF NOT AVAIL PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN FILL-IN-pln = PL-PLAN.CODPLN.
        DISPLAY FILL-IN-pln WITH FRAME {&FRAME-NAME}.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-salir C-Win
ON CHOOSE OF Btn-salir IN FRAME DEFAULT-FRAME /* Salir */
DO:
    APPLY "CLOSE" TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP C-Win
ON CHOOSE OF Btn-UP IN FRAME DEFAULT-FRAME
DO:
    IF INPUT FRAME {&FRAME-NAME} FILL-IN-nrosem + 1 <= 53 THEN DO:
        DISPLAY INPUT FILL-IN-nrosem + 1 @ FILL-IN-nrosem WITH FRAME {&FRAME-NAME}.
        ASSIGN FILL-IN-nrosem.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-3 C-Win
ON CHOOSE OF Btn-UP-3 IN FRAME DEFAULT-FRAME
DO:
    IF AVAILABLE PL-PLAN THEN DO:
        FIND NEXT PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN FILL-IN-pln = PL-PLAN.CODPLN.
        DISPLAY FILL-IN-pln WITH FRAME {&FRAME-NAME}.
    END.
    IF NOT AVAILABLE PL-PLAN THEN DO:
        FIND FIRST PL-PLAN WHERE PL-PLAN.TipPln = FALSE NO-ERROR.
        IF AVAILABLE PL-PLAN THEN FILL-IN-pln = PL-PLAN.CODPLN.
        DISPLAY FILL-IN-pln WITH FRAME {&FRAME-NAME}.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.


FIND FIRST PL-PLAN WHERE
    PL-PLAN.tippln = FALSE NO-LOCK NO-ERROR.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  FILL-IN-pln = 2.
  FILL-IN-nrosem = s-nrosem.
  RUN enable_UI.
  {&OPEN-QUERY-{&BROWSE-NAME}}

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-pln FILL-IN-NroSem 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-3 BROWSE-2 Btn-UP-3 FILL-IN-pln Btn-DOWN-3 Btn-UP FILL-IN-NroSem 
         Btn-DOWN-2 Btn-salir 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


