&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-nro-hpk AS CHAR INIT "".

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ControlOD VtaDDocu

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 ControlOD.NroEtq 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH ControlOD ~
      WHERE controlOD.codcia = s-codcia and ~
controlOD.coddoc = radio-set-coddoc and ~
controlOD.nrodoc = fill-in-nrodoc and ~
(x-nro-hpk = "" or controlOD.nroetq begins x-nro-hpk) NO-LOCK ~
    BY ControlOD.NroEtq
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH ControlOD ~
      WHERE controlOD.codcia = s-codcia and ~
controlOD.coddoc = radio-set-coddoc and ~
controlOD.nrodoc = fill-in-nrodoc and ~
(x-nro-hpk = "" or controlOD.nroetq begins x-nro-hpk) NO-LOCK ~
    BY ControlOD.NroEtq.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 ControlOD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 ControlOD


/* Definitions for BROWSE BROWSE-16                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-16 VtaDDocu.CodMat VtaDDocu.CanPick ~
VtaDDocu.Factor VtaDDocu.CanPed VtaDDocu.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-16 
&Scoped-define QUERY-STRING-BROWSE-16 FOR EACH VtaDDocu ~
      WHERE vtaddocu.codcia = s-codcia and ~
vtaddocu.codped = radio-set-coddoc and ~
vtaddocu.nroped = fill-in-nrodoc and ~
(x-nro-hpk = "" or vtaddocu.libre_c01 begins x-nro-hpk) NO-LOCK ~
    BY VtaDDocu.Libre_c01 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-16 OPEN QUERY BROWSE-16 FOR EACH VtaDDocu ~
      WHERE vtaddocu.codcia = s-codcia and ~
vtaddocu.codped = radio-set-coddoc and ~
vtaddocu.nroped = fill-in-nrodoc and ~
(x-nro-hpk = "" or vtaddocu.libre_c01 begins x-nro-hpk) NO-LOCK ~
    BY VtaDDocu.Libre_c01 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-16 VtaDDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-16 VtaDDocu


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-14}~
    ~{&OPEN-QUERY-BROWSE-16}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-coddoc FILL-IN-nrodoc BUTTON-2 ~
FILL-IN-serie-hpk FILL-IN-nro-hpk BROWSE-14 BROWSE-16 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-coddoc FILL-IN-nrodoc ~
FILL-IN-serie-hpk FILL-IN-nro-hpk FILL-IN-bultos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     LABEL "Consultar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-bultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-nro-hpk AS INTEGER FORMAT ">>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-nrodoc AS CHARACTER FORMAT "X(15)":U INITIAL "0" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-serie-hpk AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "HPK" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-coddoc AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "O/D", "O/D",
"OTR", "OTR"
     SIZE 23 BY 1.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      ControlOD SCROLLING.

DEFINE QUERY BROWSE-16 FOR 
      VtaDDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 wWin _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      ControlOD.NroEtq FORMAT "x(25)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56 BY 19.62 ROW-HEIGHT-CHARS .77 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-16 wWin _STRUCTURED
  QUERY BROWSE-16 NO-LOCK DISPLAY
      VtaDDocu.CodMat COLUMN-LABEL "CodMat" FORMAT "X(6)":U
      VtaDDocu.CanPick FORMAT "->>>,>>9.9999":U
      VtaDDocu.Factor FORMAT ">>>,>>9.9999":U
      VtaDDocu.CanPed FORMAT "->>>,>>9.9999":U
      VtaDDocu.Libre_c01 COLUMN-LABEL "HPK" FORMAT "x(25)":U WIDTH 24.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 69.43 BY 19.62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     RADIO-SET-coddoc AT ROW 1.35 COL 4.86 NO-LABEL WIDGET-ID 4
     FILL-IN-nrodoc AT ROW 1.38 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-2 AT ROW 1.38 COL 98 WIDGET-ID 8
     FILL-IN-serie-hpk AT ROW 1.58 COL 54 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-nro-hpk AT ROW 1.58 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BROWSE-14 AT ROW 3.31 COL 3.72 WIDGET-ID 200
     BROWSE-16 AT ROW 3.38 COL 75.57 WIDGET-ID 300
     FILL-IN-bultos AT ROW 7.73 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "Total Bultos" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 7.04 COL 61.43 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.14 BY 22.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 22.5
         WIDTH              = 146.14
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-14 FILL-IN-nro-hpk fMain */
/* BROWSE-TAB BROWSE-16 BROWSE-14 fMain */
/* SETTINGS FOR FILL-IN FILL-IN-bultos IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "INTEGRAL.ControlOD"
     _Options          = "NO-LOCK"
     _OrdList          = "INTEGRAL.ControlOD.NroEtq|yes"
     _Where[1]         = "controlOD.codcia = s-codcia and
controlOD.coddoc = radio-set-coddoc and
controlOD.nrodoc = fill-in-nrodoc and
(x-nro-hpk = """" or controlOD.nroetq begins x-nro-hpk)"
     _FldNameList[1]   = INTEGRAL.ControlOD.NroEtq
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-16
/* Query rebuild information for BROWSE BROWSE-16
     _TblList          = "INTEGRAL.VtaDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.VtaDDocu.Libre_c01|yes"
     _Where[1]         = "vtaddocu.codcia = s-codcia and
vtaddocu.codped = radio-set-coddoc and
vtaddocu.nroped = fill-in-nrodoc and
(x-nro-hpk = """" or vtaddocu.libre_c01 begins x-nro-hpk)"
     _FldNameList[1]   > INTEGRAL.VtaDDocu.CodMat
"CodMat" "CodMat" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.VtaDDocu.CanPick
     _FldNameList[3]   = INTEGRAL.VtaDDocu.Factor
     _FldNameList[4]   = INTEGRAL.VtaDDocu.CanPed
     _FldNameList[5]   > INTEGRAL.VtaDDocu.Libre_c01
"Libre_c01" "HPK" "x(25)" "character" ? ? ? ? ? ? no ? no no "24.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-16 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Consultar */
DO:
  ASSIGN radio-set-coddoc fill-in-nrodoc fill-in-serie-hpk fill-in-nro-hpk.

  SESSION:SET-WAIT-STATE("GENERAL").

   x-nro-hpk = "".
 IF fill-in-nro-hpk > 0 THEN DO:
     x-nro-hpk = "HPK-" + STRING(fill-in-serie-hpk,"999") + STRING(fill-in-nro-hpk,"99999999").
 END.

MESSAGE x-nro-hpk. 
  
  {&OPEN-query-browse-14}
  {&OPEN-query-browse-16}

 DEFINE VAR x-bultos AS INT INIT 0.

 GET FIRST {&BROWSE-NAME}.
 DO  WHILE AVAILABLE controlOD:
     x-bultos = x-bultos + 1.
    GET NEXT {&BROWSE-NAME}.
 END.

 GET FIRST {&BROWSE-NAME}.
 
  fill-in-bultos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-bultos,">,>>>,>>9").

  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET-coddoc FILL-IN-nrodoc FILL-IN-serie-hpk FILL-IN-nro-hpk 
          FILL-IN-bultos 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RADIO-SET-coddoc FILL-IN-nrodoc BUTTON-2 FILL-IN-serie-hpk 
         FILL-IN-nro-hpk BROWSE-14 BROWSE-16 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

