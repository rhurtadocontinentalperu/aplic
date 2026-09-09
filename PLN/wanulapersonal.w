&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME Win
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FLG-MES NO-UNDO LIKE PL-FLG-MES.
DEFINE TEMP-TABLE T-FLG-MES-2 NO-UNDO LIKE PL-FLG-MES.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Win 
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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-FLG-MES PL-PERS PL-FLG-MES T-FLG-MES-2

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-FLG-MES.codper PL-PERS.patper ~
PL-PERS.matper PL-PERS.nomper PL-FLG-MES.vcontr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-FLG-MES NO-LOCK, ~
      FIRST PL-PERS OF T-FLG-MES NO-LOCK, ~
      FIRST PL-FLG-MES OF T-FLG-MES  NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-FLG-MES NO-LOCK, ~
      FIRST PL-PERS OF T-FLG-MES NO-LOCK, ~
      FIRST PL-FLG-MES OF T-FLG-MES  NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-FLG-MES PL-PERS PL-FLG-MES
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-FLG-MES
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-3 PL-FLG-MES


/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 T-FLG-MES-2.codper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH T-FLG-MES-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH T-FLG-MES-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 T-FLG-MES-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 T-FLG-MES-2


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-Excel BUTTON-2 BtnDone ~
BROWSE-3 BROWSE-7 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     LABEL "ELIMINAR CESADOS" 
     SIZE 22 BY 1.35.

DEFINE BUTTON BUTTON-Excel 
     LABEL "IMPORTAR EXCEL" 
     SIZE 16 BY 1.35.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87 BY 4.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-FLG-MES, 
      PL-PERS
    FIELDS(PL-PERS.patper
      PL-PERS.matper
      PL-PERS.nomper), 
      PL-FLG-MES SCROLLING.

DEFINE QUERY BROWSE-7 FOR 
      T-FLG-MES-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-FLG-MES.codper FORMAT "X(6)":U WIDTH 7.43
      PL-PERS.patper FORMAT "X(20)":U WIDTH 20.43
      PL-PERS.matper FORMAT "X(20)":U WIDTH 20.86
      PL-PERS.nomper FORMAT "X(20)":U WIDTH 21.29
      PL-FLG-MES.vcontr FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 15
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      T-FLG-MES-2.codper FORMAT "X(6)":U WIDTH 20.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 38 BY 3.35
         FONT 4
         TITLE "    A   |" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-Excel AT ROW 1.19 COL 3 WIDGET-ID 96
     BUTTON-2 AT ROW 1.19 COL 19 WIDGET-ID 100
     BtnDone AT ROW 1.19 COL 41 WIDGET-ID 98
     BROWSE-3 AT ROW 2.73 COL 3 WIDGET-ID 200
     BROWSE-7 AT ROW 18.69 COL 5 WIDGET-ID 300
     "FORMATO DEL ARCHIVO EXCEL" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 18.12 COL 4 WIDGET-ID 90
          BGCOLOR 7 FGCOLOR 15 
     RECT-1 AT ROW 18.31 COL 3 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.72 BY 21.77
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-FLG-MES T "?" NO-UNDO INTEGRAL PL-FLG-MES
      TABLE: T-FLG-MES-2 T "?" NO-UNDO INTEGRAL PL-FLG-MES
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ELIMINA PERSONAL CESADO"
         HEIGHT             = 21.77
         WIDTH              = 91.72
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 BtnDone fMain */
/* BROWSE-TAB BROWSE-7 BROWSE-3 fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win)
THEN Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-FLG-MES,INTEGRAL.PL-PERS OF Temp-Tables.T-FLG-MES,INTEGRAL.PL-FLG-MES OF Temp-Tables.T-FLG-MES "
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST"
     _FldNameList[1]   > Temp-Tables.T-FLG-MES.codper
"T-FLG-MES.codper" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.PL-PERS.patper
"PL-PERS.patper" ? "X(20)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PL-PERS.matper
"PL-PERS.matper" ? "X(20)" "character" ? ? ? ? ? ? no ? no no "20.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PL-PERS.nomper
"PL-PERS.nomper" ? "X(20)" "character" ? ? ? ? ? ? no ? no no "21.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.PL-FLG-MES.vcontr
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "Temp-Tables.T-FLG-MES-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-FLG-MES-2.codper
"T-FLG-MES-2.codper" ? ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win Win
ON END-ERROR OF Win /* ELIMINA PERSONAL CESADO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win Win
ON WINDOW-CLOSE OF Win /* ELIMINA PERSONAL CESADO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone Win
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 Win
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* ELIMINAR CESADOS */
DO:
   MESSAGE 'Procedemos a eliminar los cesados?' SKIP(2)
       'Este proceso es irreversible'
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
       UPDATE rpta AS LOG.
   IF rpta = YES THEN DO:
       SESSION:SET-WAIT-STATE('GENERAL').
       RUN Eliminar-Cesados.
       SESSION:SET-WAIT-STATE('').
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel Win
ON CHOOSE OF BUTTON-Excel IN FRAME fMain /* IMPORTAR EXCEL */
DO:
  RUN Importar-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win)
  THEN DELETE WIDGET Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Cesados Win 
PROCEDURE Eliminar-Cesados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FLG-MES EXCLUSIVE-LOCK,
    FIRST pl-flg-mes OF t-flg-mes EXCLUSIVE-LOCK 
    ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    DELETE PL-FLG-MES.
    DELETE T-FLG-MES.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Win  _DEFAULT-ENABLE
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
  ENABLE RECT-1 BUTTON-Excel BUTTON-2 BtnDone BROWSE-3 BROWSE-7 
      WITH FRAME fMain IN WINDOW Win.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.


SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls,*xlsx)" "*.xls,*.xlsx"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* PRIMERO BORRAMOS TODO EL DETALLE */
EMPTY TEMP-TABLE T-FLG-MES.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    iCountLine = iCountLine + 1.
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    ASSIGN
        cValue = STRING(DECIMAL(cValue), '999999')
        NO-ERROR.
    FIND pl-pers WHERE pl-pers.codcia = s-codcia AND pl-pers.codper = cValue NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN NEXT.
    FIND pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.periodo = s-periodo
        AND pl-flg-mes.nromes = s-nromes
        AND pl-flg-mes.codper = cValue
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-flg-mes THEN NEXT.
    CREATE T-FLG-MES.
    BUFFER-COPY PL-FLG-MES TO T-FLG-MES NO-ERROR.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

SESSION:SET-WAIT-STATE('').

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

