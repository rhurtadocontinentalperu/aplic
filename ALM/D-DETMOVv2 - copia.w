&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

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
DEFINE INPUT PARAMETER P-CODALM AS CHAR.
DEFINE INPUT PARAMETER P-CODMAT AS CHAR.
DEFINE INPUT PARAMETER P-DESMAT AS CHAR.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
/*DEFINE SHARED VAR S-CODALM AS char.*/

DEFINE VAR x-Tipo AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almdmov Almcmov

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 Almdmov.NroSer Almdmov.NroDoc ~
Almcmov.CodRef Almcmov.NroRef Almdmov.FchDoc Almcmov.DateUpdate ~
Almdmov.TipMov Almdmov.CodMov Almdmov.AlmOri Almdmov.CodUnd ~
IF LOOKUP(Almdmov.TipMov, "I,R,U" ) > 0  THEN  ( FILL (" ", 12 -  LENGTH ( TRIM( STRING (Almdmov.CanDes, ">>>>>>9.9999"))))   + TRIM( STRING (Almdmov.CanDes, ">>>>>>9.9999"))) ELSE ("") ~
IF LOOKUP(Almdmov.TipMov, "I,R,U" ) = 0  THEN  ( FILL (" ", 12 -  LENGTH ( TRIM ( STRING (Almdmov.CanDes, ">>>>,>>9.9999"))))   +  TRIM( STRING (Almdmov.CanDes, ">>>>,>>9.9999"))) ELSE ("") ~
Almdmov.StkSub fTipo()  @  x-Tipo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH Almdmov ~
      WHERE Almdmov.codcia = s-codcia ~
 AND Almdmov.CodAlm = p-codalm ~
 AND Almdmov.Codmat = p-codmat USE-INDEX ALMD03 NO-LOCK, ~
      EACH Almcmov OF Almdmov NO-LOCK ~
    BY Almdmov.CodCia DESCENDING ~
       BY Almdmov.CodAlm DESCENDING ~
        BY Almdmov.codmat DESCENDING ~
         BY Almdmov.FchDoc DESCENDING ~
          BY Almdmov.TipMov DESCENDING ~
           BY Almdmov.CodMov DESCENDING ~
            BY Almdmov.NroDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH Almdmov ~
      WHERE Almdmov.codcia = s-codcia ~
 AND Almdmov.CodAlm = p-codalm ~
 AND Almdmov.Codmat = p-codmat USE-INDEX ALMD03 NO-LOCK, ~
      EACH Almcmov OF Almdmov NO-LOCK ~
    BY Almdmov.CodCia DESCENDING ~
       BY Almdmov.CodAlm DESCENDING ~
        BY Almdmov.codmat DESCENDING ~
         BY Almdmov.FchDoc DESCENDING ~
          BY Almdmov.TipMov DESCENDING ~
           BY Almdmov.CodMov DESCENDING ~
            BY Almdmov.NroDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 Almdmov Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 Almdmov
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 Almcmov


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-3 BUTTON-2 BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN-DesMat F-DESMOV ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTipo D-Dialog 
FUNCTION fTipo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "EXCEL" 
     SIZE 5 BY 1.35.

DEFINE VARIABLE F-DESMOV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.57 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .81 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "adeicon/blank":U
     SIZE 9.14 BY 2.46.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      Almdmov, 
      Almcmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 D-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      Almdmov.NroSer COLUMN-LABEL "Serie" FORMAT "9999":U WIDTH 5.43
            LABEL-FONT 6
      Almdmov.NroDoc COLUMN-LABEL "Número" FORMAT "999999999":U
            WIDTH 7.43 COLUMN-FONT 4 LABEL-FONT 6
      Almcmov.CodRef COLUMN-LABEL "Refer." FORMAT "x(3)":U WIDTH 6.43
            LABEL-FONT 6
      Almcmov.NroRef FORMAT "X(12)":U WIDTH 9.43 LABEL-FONT 6
      Almdmov.FchDoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
            WIDTH 10.43 COLUMN-FONT 2 LABEL-FONT 6
      Almcmov.DateUpdate COLUMN-LABEL "Fecha  de Transacción" FORMAT "99/99/9999":U
            WIDTH 19.43 COLUMN-FONT 2 LABEL-FONT 6
      Almdmov.TipMov COLUMN-LABEL "Mov." FORMAT "X":U WIDTH 4.14
            COLUMN-FONT 4 LABEL-FONT 6
      Almdmov.CodMov COLUMN-LABEL "Código" FORMAT "99":U WIDTH 6.43
            COLUMN-FONT 4 LABEL-FONT 6
      Almdmov.AlmOri COLUMN-LABEL "Alm Origen" FORMAT "x(3)":U
            WIDTH 9.43 COLUMN-FONT 4 LABEL-FONT 6
      Almdmov.CodUnd COLUMN-LABEL "Unidad" FORMAT "X(10)":U COLUMN-FONT 4
            LABEL-FONT 6
      IF LOOKUP(Almdmov.TipMov, "I,R,U" ) > 0  THEN 
( FILL (" ", 12 -  LENGTH ( TRIM( STRING (Almdmov.CanDes, ">>>>>>9.9999"))))
  + TRIM( STRING (Almdmov.CanDes, ">>>>>>9.9999"))) ELSE ("") COLUMN-LABEL "Ingresos" FORMAT "X(15)":U
            WIDTH 11.14 COLUMN-FGCOLOR 9 COLUMN-FONT 2 LABEL-FGCOLOR 9 LABEL-FONT 6
      IF LOOKUP(Almdmov.TipMov, "I,R,U" ) = 0  THEN 
( FILL (" ", 12 -  LENGTH ( TRIM ( STRING (Almdmov.CanDes, ">>>>,>>9.9999"))))
  +  TRIM( STRING (Almdmov.CanDes, ">>>>,>>9.9999"))) ELSE ("") COLUMN-LABEL "Salidas" FORMAT "X(15)":U
            WIDTH 12.43 COLUMN-FGCOLOR 12 COLUMN-FONT 2 LABEL-FGCOLOR 12 LABEL-FONT 6
      Almdmov.StkSub COLUMN-LABEL "Saldo" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 11.43 LABEL-FONT 6
      fTipo()  @  x-Tipo COLUMN-LABEL "Tipo de Transferencia" FORMAT "x(10)":U
            WIDTH 15.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 147 BY 13.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CodMat AT ROW 1.19 COL 10.29 COLON-ALIGNED
     BUTTON-2 AT ROW 1.38 COL 78
     FILL-IN-DesMat AT ROW 2.04 COL 3.43
     BROWSE-1 AT ROW 2.96 COL 2
     F-DESMOV AT ROW 16.96 COL 2 NO-LABEL
     FILL-IN-Mensaje AT ROW 16.96 COL 67 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     IMAGE-3 AT ROW 6.15 COL 37.57
     SPACE(104.14) SKIP(9.50)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Movimiento por Articulo".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 FILL-IN-DesMat D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-DESMOV IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-CodMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.Almdmov,INTEGRAL.Almcmov OF INTEGRAL.Almdmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.Almdmov.CodCia|no,INTEGRAL.Almdmov.CodAlm|no,INTEGRAL.Almdmov.codmat|no,INTEGRAL.Almdmov.FchDoc|no,INTEGRAL.Almdmov.TipMov|no,INTEGRAL.Almdmov.CodMov|no,INTEGRAL.Almdmov.NroDoc|no"
     _Where[1]         = "integral.Almdmov.codcia = s-codcia
 AND integral.Almdmov.CodAlm = p-codalm
 AND integral.Almdmov.Codmat = p-codmat USE-INDEX ALMD03"
     _FldNameList[1]   > integral.Almdmov.NroSer
"Almdmov.NroSer" "Serie" "9999" "integer" ? ? ? ? ? 6 no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.Almdmov.NroDoc
"Almdmov.NroDoc" "Número" ? "integer" ? ? 4 ? ? 6 no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almcmov.CodRef
"Almcmov.CodRef" "Refer." ? "character" ? ? ? ? ? 6 no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almcmov.NroRef
"Almcmov.NroRef" ? "X(12)" "character" ? ? ? ? ? 6 no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.Almdmov.FchDoc
"Almdmov.FchDoc" "Fecha" ? "date" ? ? 2 ? ? 6 no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almcmov.DateUpdate
"Almcmov.DateUpdate" "Fecha  de Transacción" ? "date" ? ? 2 ? ? 6 no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.Almdmov.TipMov
"Almdmov.TipMov" "Mov." ? "character" ? ? 4 ? ? 6 no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.Almdmov.CodMov
"Almdmov.CodMov" "Código" ? "integer" ? ? 4 ? ? 6 no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.Almdmov.AlmOri
"Almdmov.AlmOri" "Alm Origen" ? "character" ? ? 4 ? ? 6 no "" no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.Almdmov.CodUnd
"Almdmov.CodUnd" "Unidad" ? "character" ? ? 4 ? ? 6 no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"IF LOOKUP(Almdmov.TipMov, ""I,R,U"" ) > 0  THEN 
( FILL ("" "", 12 -  LENGTH ( TRIM( STRING (Almdmov.CanDes, "">>>>>>9.9999""))))
  + TRIM( STRING (Almdmov.CanDes, "">>>>>>9.9999""))) ELSE ("""")" "Ingresos" "X(15)" ? ? 9 2 ? 9 6 no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"IF LOOKUP(Almdmov.TipMov, ""I,R,U"" ) = 0  THEN 
( FILL ("" "", 12 -  LENGTH ( TRIM ( STRING (Almdmov.CanDes, "">>>>,>>9.9999""))))
  +  TRIM( STRING (Almdmov.CanDes, "">>>>,>>9.9999""))) ELSE ("""")" "Salidas" "X(15)" ? ? 12 2 ? 12 6 no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > integral.Almdmov.StkSub
"Almdmov.StkSub" "Saldo" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? 6 no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fTipo()  @  x-Tipo" "Tipo de Transferencia" "x(10)" ? ? ? ? ? ? ? no ? no no "15.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Movimiento por Articulo */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 D-Dialog
ON VALUE-CHANGED OF BROWSE-1 IN FRAME D-Dialog
DO:
   RUN PINTA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 D-Dialog
ON CHOOSE OF BUTTON-2 IN FRAME D-Dialog /* EXCEL */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CodMat FILL-IN-DesMat F-DESMOV FILL-IN-Mensaje 
      WITH FRAME D-Dialog.
  ENABLE IMAGE-3 BUTTON-2 BROWSE-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
PROCEDURE Excel :
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Serie".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Tip Mov".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod Mov".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Alm Ref.".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Ingresos".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Salidas".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Stock Acumulado".

FOR EACH Almdmov NO-LOCK USE-INDEX ALMD03 WHERE Almdmov.codcia = s-codcia
        AND Almdmov.CodAlm = p-codalm
        AND Almdmov.Codmat = p-codmat
        BY Almdmov.codcia DESC
        BY Almdmov.codalm DESC
        BY Almdmov.codmat DESC
        BY Almdmov.fchdoc DESC
        BY Almdmov.tipmov DESC
        BY Almdmov.codmov DESC
        BY Almdmov.nrodoc DESC:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
        "*** PROCESANDO : " + STRING(Almdmov.fchdoc, '99/99/9999').
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.nroser.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.nrodoc.
    cRange = "C" + cColumn.
    ASSIGN chWorkSheet:Range(cRange):Value = Almdmov.fchdoc NO-ERROR.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.tipmov.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(Almdmov.codmov, '99').
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.AlmOri.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.codund.
    cRange = "H" + cColumn.
    IF LOOKUP(Almdmov.TipMov, "I,R,U" ) > 0  
    THEN chWorkSheet:Range(cRange):Value = Almdmov.CanDes.
    cRange = "I" + cColumn.
    IF LOOKUP(Almdmov.TipMov, "I,R,U" ) = 0  
    THEN chWorkSheet:Range(cRange):Value = Almdmov.CanDes.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.stksub.
END.
/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*-------------------------------------------------m----------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  FILL-IN-DESMAT:SCREEN-VALUE IN FRAME {&FRAME-NAME} = P-DESMAT. 
  FILL-IN-CODMAT:SCREEN-VALUE IN FRAME {&FRAME-NAME} = P-CODMAT. 
  /* Code placed here will execute AFTER standard behavior.    */
  RUN PINTA.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PINTA D-Dialog 
PROCEDURE PINTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAILABLE almdmov THEN
DO:
FIND ALMTMOVM WHERE Almtmovm.CodCia = S-CODCIA AND Almtmovm.Codmov = Almdmov.CodMov AND Almtmovm.Tipmov = Almdmov.TipMov. 
   IF AVAILABLE Almtmovm THEN DO:
        IF LOOKUP(Almdmov.TipMov, "I,R") > 0 THEN F-DesMov:Screen-value IN FRAME {&FRAME-NAME} = "MOV.DE INGRESO : " + Almtmovm.Desmov.
        ELSE F-DesMov:Screen-value IN FRAME {&FRAME-NAME} = "MOV.DE SALIDA : " + Almtmovm.Desmov.
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almdmov"}
  {src/adm/template/snd-list.i "Almcmov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTipo D-Dialog 
FUNCTION fTipo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Solo para INGRESO por TRANSFERENCIA (I-03)
------------------------------------------------------------------------------*/

IF NOT (almdmov.tipmov = 'I' AND almdmov.codmov = 03) THEN RETURN "".
/* buscamos OTR */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddoc = almcmov.codref
    AND faccpedi.nroped = almcmov.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE faccpedi AND faccpedi.codref = 'R/A' THEN DO:
    FIND FIRST almcrepo WHERE almcrepo.codcia = s-codcia
        AND almcrepo.nroser = INT(SUBSTRING(faccpedi.nroref,1,3))
        AND almcrepo.nrodoc = INT(SUBSTRING(faccpedi.nroref,4))
        NO-LOCK NO-ERROR.
    IF AVAILABLE almcrepo THEN DO:
        IF almcrepo.tipmov = "A" THEN RETURN "AUTOMATICO".
        IF almcrepo.tipmov = "M" THEN RETURN "SEMI-AUTOMATICO".
    END.
END.
RETURN "MANUAL".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

