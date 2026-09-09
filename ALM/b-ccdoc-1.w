&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.

/* VARIABLES A USAR EN EL BROWSE */
DEF VAR x-NomCli AS CHAR FORMAT 'x(45)' NO-UNDO.
DEF VAR x-CodAlm AS CHAR FORMAT 'x(3)'  NO-UNDO.

DEF VAR x-Marca AS CHAR FORMAT 'X' NO-UNDO.

DEFINE TEMP-TABLE tt-almdcdoc LIKE almdcdoc.

DEFINE FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Espere un momento por favor..." SKIP
    WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.

&SCOPED-DEFINE condicion AlmDCdoc.CodCia = s-codcia ~
AND (COMBO-BOX-CodDoc = 'Todos' OR INTEGRAL.AlmDCdoc.CodDoc BEGINS COMBO-BOX-CodDoc) ~
AND (FILL-IN-NroDoc = '' OR AlmDCdoc.NroDoc BEGINS FILL-IN-NroDoc) ~
AND (COMBO-BOX-CodAlm = 'Todos' OR AlmDCdoc.CodAlm BEGINS COMBO-BOX-CodAlm) ~
AND AlmDCdoc.Fecha >= fill-in-fecha ~
AND AlmDCdoc.Fecha <= fill-in-fecha-2 ~
AND (AlmDCdoc.FlgEst = "S" OR AlmDCdoc.FlgEst = "R")

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmDCdoc gn-clie

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmDCdoc.Fecha AlmDCdoc.Hora ~
AlmDCdoc.usuario ~
IF (AlmDCdoc.FlgEst =  'R' ) THEN ('*') ELSE ('') @ x-Marca AlmDCdoc.CodDoc ~
AlmDCdoc.NroDoc AlmDCdoc.CodAlm gn-clie.NomCli AlmDCdoc.Bultos ~
AlmDCdoc.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH AlmDCdoc WHERE ~{&KEY-PHRASE} ~
      AND AlmDCdoc.CodCia = s-codcia ~
 AND (COMBO-BOX-CodDoc = 'Todos'  ~
   OR AlmDCdoc.CodDoc BEGINS COMBO-BOX-CodDoc) ~
 AND (FILL-IN-NroDoc = ''  ~
   OR AlmDCdoc.NroDoc BEGINS FILL-IN-NroDoc) ~
 AND (COMBO-BOX-CodAlm = 'Todos'  ~
   OR AlmDCdoc.CodAlm BEGINS COMBO-BOX-CodAlm) ~
/*** ~
 AND (FILL-IN-Fecha = ?  ~
   OR AlmDCdoc.Fecha = FILL-IN-Fecha) ~
****/ ~
 AND AlmDCdoc.Fecha >= fill-in-fecha ~
 AND AlmDCdoc.Fecha <= fill-in-fecha-2 ~
 AND (AlmDCdoc.FlgEst = "S" ~
  OR AlmDCdoc.FlgEst = "R") NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = AlmDCdoc.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY AlmDCdoc.Fecha DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmDCdoc WHERE ~{&KEY-PHRASE} ~
      AND AlmDCdoc.CodCia = s-codcia ~
 AND (COMBO-BOX-CodDoc = 'Todos'  ~
   OR AlmDCdoc.CodDoc BEGINS COMBO-BOX-CodDoc) ~
 AND (FILL-IN-NroDoc = ''  ~
   OR AlmDCdoc.NroDoc BEGINS FILL-IN-NroDoc) ~
 AND (COMBO-BOX-CodAlm = 'Todos'  ~
   OR AlmDCdoc.CodAlm BEGINS COMBO-BOX-CodAlm) ~
/*** ~
 AND (FILL-IN-Fecha = ?  ~
   OR AlmDCdoc.Fecha = FILL-IN-Fecha) ~
****/ ~
 AND AlmDCdoc.Fecha >= fill-in-fecha ~
 AND AlmDCdoc.Fecha <= fill-in-fecha-2 ~
 AND (AlmDCdoc.FlgEst = "S" ~
  OR AlmDCdoc.FlgEst = "R") NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = AlmDCdoc.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK ~
    BY AlmDCdoc.Fecha DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table AlmDCdoc gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmDCdoc
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-clie


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodAlm BUTTON-3 COMBO-BOX-CodDoc ~
FILL-IN-NroDoc FILL-IN-Fecha FILL-IN-Fecha-2 COMBO-BOX-Cliente ~
FILL-IN-NomCli br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm COMBO-BOX-CodDoc ~
FILL-IN-NroDoc FILL-IN-Fecha FILL-IN-Fecha-2 COMBO-BOX-Cliente ~
FILL-IN-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDescrip B-table-Win 
FUNCTION fDescrip RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Cliente AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtro" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","FAC","BOL","G/R" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(9)":U 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      AlmDCdoc, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmDCdoc.Fecha COLUMN-LABEL "<<Fecha>>" FORMAT "99/99/99":U
      AlmDCdoc.Hora COLUMN-LABEL "<Hora>" FORMAT "X(5)":U WIDTH 6
      AlmDCdoc.usuario COLUMN-LABEL "<Usuario>" FORMAT "x(10)":U
            WIDTH 10
      IF (AlmDCdoc.FlgEst =  'R' ) THEN ('*') ELSE ('') @ x-Marca COLUMN-LABEL "F" FORMAT "X":U
            WIDTH 2
      AlmDCdoc.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 3.57
      AlmDCdoc.NroDoc COLUMN-LABEL "<<Numero>>" FORMAT "X(9)":U
            WIDTH 9
      AlmDCdoc.CodAlm COLUMN-LABEL "Alm." FORMAT "x(3)":U
      gn-clie.NomCli FORMAT "x(50)":U
      AlmDCdoc.Bultos FORMAT "->,>>9":U
      AlmDCdoc.Observ FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 123 BY 14.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1.19 COL 11 COLON-ALIGNED
     BUTTON-3 AT ROW 2.08 COL 111 WIDGET-ID 4
     COMBO-BOX-CodDoc AT ROW 2.15 COL 11 COLON-ALIGNED
     FILL-IN-NroDoc AT ROW 2.15 COL 29.86 COLON-ALIGNED
     FILL-IN-Fecha AT ROW 3.15 COL 11 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 3.15 COL 30.14 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Cliente AT ROW 4.23 COL 11 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NomCli AT ROW 4.23 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     br_table AT ROW 5.15 COL 2
     "Exporta Excel" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.69 COL 110 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 19.23
         WIDTH              = 131.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
/* BROWSE-TAB br_table FILL-IN-NomCli F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.AlmDCdoc,INTEGRAL.gn-clie WHERE INTEGRAL.AlmDCdoc ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "INTEGRAL.AlmDCdoc.Fecha|no"
     _Where[1]         = "INTEGRAL.AlmDCdoc.CodCia = s-codcia
 AND (COMBO-BOX-CodDoc = 'Todos' 
   OR INTEGRAL.AlmDCdoc.CodDoc BEGINS COMBO-BOX-CodDoc)
 AND (FILL-IN-NroDoc = '' 
   OR INTEGRAL.AlmDCdoc.NroDoc BEGINS FILL-IN-NroDoc)
 AND (COMBO-BOX-CodAlm = 'Todos' 
   OR INTEGRAL.AlmDCdoc.CodAlm BEGINS COMBO-BOX-CodAlm)
/***
 AND (FILL-IN-Fecha = ? 
   OR INTEGRAL.AlmDCdoc.Fecha = FILL-IN-Fecha)
****/
 AND INTEGRAL.AlmDCdoc.Fecha >= fill-in-fecha
 AND INTEGRAL.AlmDCdoc.Fecha <= fill-in-fecha-2
 AND (AlmDCdoc.FlgEst = ""S""
  OR AlmDCdoc.FlgEst = ""R"")"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.AlmDCdoc.CodCli"
     _Where[2]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.AlmDCdoc.Fecha
"AlmDCdoc.Fecha" "<<Fecha>>" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.AlmDCdoc.Hora
"AlmDCdoc.Hora" "<Hora>" ? "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.AlmDCdoc.usuario
"AlmDCdoc.usuario" "<Usuario>" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"IF (AlmDCdoc.FlgEst =  'R' ) THEN ('*') ELSE ('') @ x-Marca" "F" "X" ? ? ? ? ? ? ? no ? no no "2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.AlmDCdoc.CodDoc
"AlmDCdoc.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no "3.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.AlmDCdoc.NroDoc
"AlmDCdoc.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.AlmDCdoc.CodAlm
"AlmDCdoc.CodAlm" "Alm." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.gn-clie.NomCli
     _FldNameList[9]   > INTEGRAL.AlmDCdoc.Bultos
"AlmDCdoc.Bultos" ? "->,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   = INTEGRAL.AlmDCdoc.Observ
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 B-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN
        COMBO-BOX-CodAlm 
        COMBO-BOX-CodDoc 
        FILL-IN-Fecha 
        FILL-IN-Fecha-2 
        FILL-IN-NroDoc.
    RUN Genera-Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacen */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDoc B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDoc IN FRAME F-Main /* Documento */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha B-table-Win
ON LEAVE OF FILL-IN-Fecha IN FRAME F-Main /* Desde */
DO:
  IF {&SELF-NAME} <> INPUT {&SELF-NAME}
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 B-table-Win
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME F-Main /* Hasta */
DO:
  IF {&SELF-NAME} <> INPUT {&SELF-NAME}
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc B-table-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Numero */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON FIND OF AlmDCDoc 
DO:
    ASSIGN
        x-NomCli = fDescrip().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel B-table-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.


FOR EACH tt-almdcdoc:
    DELETE tt-almdcdoc.
END.

GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE almdcdoc:
    CREATE tt-almdcdoc.
    BUFFER-COPY almdcdoc TO tt-almdcdoc.
    GET NEXT {&BROWSE-NAME}.
END.
     

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Hora".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Usuario".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Bultos".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Observaciones".

/*VIEW FRAME f-mensaje.*/
FOR EACH tt-almdcdoc NO-LOCK ,
    FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = tt-almdcdoc.codcli NO-LOCK
    BREAK BY tt-almdcdoc.Fecha DESC:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.Fecha.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.Hora.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.usuario.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.CodDoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(tt-AlmDCdoc.NroDoc,'999999999').
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.Bultos.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-AlmDCdoc.Observ.
END.
/*HIDE FRAME f-mensaje.*/

MESSAGE 'Proceso Terminado'
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Almacen WHERE Almacen.codcia = s-codcia No-LOCK:
        COMBO-BOX-CodAlm:ADD-LAST(Almacen.codalm).
    END.
    COMBO-BOX-CodAlm:SCREEN-VALUE = s-codalm.
    COMBO-BOX-CodAlm = s-codalm.
    ASSIGN 
        fill-in-fecha = TODAY
        fill-in-fecha-2 = TODAY.
    DISPLAY 
        fill-in-fecha
        fill-in-fecha-2.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "AlmDCdoc"}
  {src/adm/template/snd-list.i "gn-clie"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDescrip B-table-Win 
FUNCTION fDescrip RETURNS CHARACTER:
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE AlmDCDoc.coddoc:
    WHEN 'FAC' OR WHEN 'BOL' OR WHEN 'G/R' THEN DO:
        FIND CcbCDocu WHERE ccbcdocu.codcia = almdcdoc.codcia
            AND ccbcdocu.coddoc = almdcdoc.coddoc
            AND ccbcdocu.nrodoc = almdcdoc.nrodoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcdocu THEN RETURN ccbcdocu.nomcli.   
        ELSE DO:
            FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                AND almtmovm.tipmov = 'S'
                AND almtmovm.reqguia = YES NO-LOCK:
                FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                    FIND Almcmov WHERE almcmov.codcia = s-codcia
                        AND almcmov.codalm = almacen.codalm
                        AND almcmov.tipmov = almtmovm.tipmov
                        AND almcmov.codmov = almtmovm.codmov
                        AND almcmov.flgest <> 'A'
                        AND almcmov.nroser = INTEGER(SUBSTRING(almdcdoc.nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(almdcdoc.nrodoc,4))
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN RETURN almcmov.NomRef.
                END.
            END.
        END.
    END.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

