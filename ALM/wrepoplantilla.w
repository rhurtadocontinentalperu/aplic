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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF VAR x-StkAct LIKE Almmmate.stkact NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD FchDoc AS DATE
    FIELD CanDes AS DEC
    INDEX Llave01 AS PRIMARY FchDoc.

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
&Scoped-define INTERNAL-TABLES Almmmatg Almmmate

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 Almmmate.codmat Almmmate.StkMin ~
Almmmate.StkMax Almmmate.StkRep fStock(FILL-IN-FchCorte) @ x-StkAct ~
Almmmatg.CanEmp Almmmatg.UndStk Almmmatg.DesMat Almmmatg.DesMar ~
Almmmatg.OrdTmp Almmmatg.tiprot[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH Almmmatg ~
      WHERE Almmmatg.CodCia = s-codcia ~
 AND Almmmatg.TpoArt <> "D" ~
 AND ( COMBO-BOX-CodFam = 'Todas'  ~
OR Almmmatg.codfam = COMBO-BOX-CodFam ) NO-LOCK, ~
      EACH Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH Almmmatg ~
      WHERE Almmmatg.CodCia = s-codcia ~
 AND Almmmatg.TpoArt <> "D" ~
 AND ( COMBO-BOX-CodFam = 'Todas'  ~
OR Almmmatg.codfam = COMBO-BOX-CodFam ) NO-LOCK, ~
      EACH Almmmate OF Almmmatg ~
      WHERE Almmmate.CodAlm = s-codalm NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 Almmmatg Almmmate
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 Almmmatg
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almmmate


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-1 BtnDone COMBO-BOX-CodFam ~
FILL-IN-FchCorte BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen COMBO-BOX-CodFam ~
FILL-IN-FchCorte 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStock wWin 
FUNCTION fStock RETURNS DECIMAL
  ( pFchCorte AS DATE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 5 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Filtrar por Familias" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchCorte AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Corte" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 137 BY 1.73
     BGCOLOR 11 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      Almmmatg, 
      Almmmate SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      Almmmate.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7.43
      Almmmate.StkMin COLUMN-LABEL "Stock!Minimo" FORMAT "Z,ZZZ,ZZ9.99":U
            WIDTH 9.43
      Almmmate.StkMax COLUMN-LABEL "Stock!Maximo" FORMAT "Z,ZZZ,ZZZ,ZZ9.99":U
            WIDTH 9.43
      Almmmate.StkRep COLUMN-LABEL "Stock de!Reposición" FORMAT "ZZ,ZZZ,ZZ9.99":U
            WIDTH 9.43
      fStock(FILL-IN-FchCorte) @ x-StkAct COLUMN-LABEL "Stock!Almacén" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 8.43
      Almmmatg.CanEmp FORMAT "->>,>>9.99":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad!Stock" FORMAT "X(4)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      Almmmatg.OrdTmp COLUMN-LABEL "Ranking" FORMAT ">>>>,>>9":U
      Almmmatg.tiprot[1] COLUMN-LABEL "Categoria" FORMAT "x(1)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137 BY 14.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1.19 COL 127 WIDGET-ID 8
     BtnDone AT ROW 1.19 COL 133 WIDGET-ID 14
     FILL-IN-Almacen AT ROW 1.38 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     COMBO-BOX-CodFam AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-FchCorte AT ROW 3.88 COL 15 COLON-ALIGNED WIDGET-ID 12
     BROWSE-3 AT ROW 5.23 COL 2 WIDGET-ID 200
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.14 BY 19.31
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "PLANTILLA DE REPOSICIONES AUTOMATICAS"
         HEIGHT             = 19.31
         WIDTH              = 139.14
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
/* BROWSE-TAB BROWSE-3 FILL-IN-FchCorte fMain */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.Almmmatg,INTEGRAL.Almmmate OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Almmmatg.CodCia = s-codcia
 AND Almmmatg.TpoArt <> ""D""
 AND ( COMBO-BOX-CodFam = 'Todas' 
OR Almmmatg.codfam = COMBO-BOX-CodFam )"
     _Where[2]         = "Almmmate.CodAlm = s-codalm"
     _FldNameList[1]   > INTEGRAL.Almmmate.codmat
"Almmmate.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmate.StkMin
"Almmmate.StkMin" "Stock!Minimo" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmate.StkMax
"Almmmate.StkMax" "Stock!Maximo" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmate.StkRep
"Almmmate.StkRep" "Stock de!Reposición" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fStock(FILL-IN-FchCorte) @ x-StkAct" "Stock!Almacén" "(ZZZ,ZZZ,ZZ9.99)" ? ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.Almmmatg.CanEmp
     _FldNameList[7]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad!Stock" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.Almmmatg.OrdTmp
"Almmmatg.OrdTmp" "Ranking" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.Almmmatg.tiprot[1]
"Almmmatg.tiprot[1]" "Categoria" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* PLANTILLA DE REPOSICIONES AUTOMATICAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* PLANTILLA DE REPOSICIONES AUTOMATICAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
   RUN Excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Filtrar por Familias */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCorte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCorte wWin
ON LEAVE OF FILL-IN-FchCorte IN FRAME fMain /* Fecha de Corte */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas wWin 
PROCEDURE Carga-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-FchIni AS DATE.
DEF INPUT PARAMETER x-FchFin AS DATE.
DEF INPUT PARAMETER x-CodMat AS CHAR.
DEF INPUT PARAMETER x-CodAlm AS CHAR.
DEF INPUT PARAMETER x-Factor AS DEC.

DEFINE VAR X-CODDIA AS INTEGER NO-UNDO INIT 1.
DEFINE VAR X-CODANO AS INTEGER NO-UNDO.
DEFINE VAR X-CODMES AS INTEGER NO-UNDO.
DEFINE VAR I        AS INTEGER NO-UNDO.
DEFINE VAR x-AnoMesDia AS CHAR.
DEFINE VAR x-Fecha  AS DATE NO-UNDO.

FOR EACH Ventas_Detalle USE-INDEX Index02 NO-LOCK WHERE Ventas_Detalle.DateKey >= x-FchIni
    AND Ventas_Detalle.DateKey <= x-FchFin
    AND Ventas_Detalle.CodMat = x-CodMat
    AND Ventas_Detalle.AlmDes = x-CodAlm:
    ASSIGN
        x-AnoMesDia = STRING(YEAR(Ventas_Detalle.DateKey), '9999') +
                        STRING(MONTH(Ventas_Detalle.DateKey), '99') +
                        STRING(DAY(Ventas_Detalle.DateKey), '99')
        x-Fecha = Ventas_Detalle.DateKey.
    FIND Detalle WHERE Detalle.FchDoc = X-FECHA NO-ERROR.
    IF NOT AVAILABLE Detalle THEN CREATE Detalle.
    ASSIGN
        Detalle.fchdoc = x-Fecha
        Detalle.candes = Detalle.candes + Ventas_Detalle.Cantidad * x-factor.
END.

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
  DISPLAY FILL-IN-Almacen COMBO-BOX-CodFam FILL-IN-FchCorte 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 BUTTON-1 BtnDone COMBO-BOX-CodFam FILL-IN-FchCorte BROWSE-3 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 2.

DEFINE VARIABLE pVtaPromedio            AS DECIMAL NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Range("A1"):Value = s-codalm + ' ' + Almacen.descrip.
chWorkSheet:Range("A2"):Value = "ARTICULO".
chWorkSheet:Range("B2"):Value = "STOCK MINIMO".
chWorkSheet:Range("C2"):Value = "STOCK MAXIMO".
chWorkSheet:Range("D2"):Value = "STOCK REPOSICION".
chWorkSheet:Range("E2"):Value = "STOCK ALMACEN AL " + STRING(FILL-IN-FchCorte, '99/99/9999').
chWorkSheet:Range("F2"):Value = "VENTAS EN 15 DIAS".
chWorkSheet:Range("G2"):Value = "UNIDAD".
chWorkSheet:Range("H2"):Value = "DESCRIPCION".
chWorkSheet:Range("I2"):Value = "MARCA".
chWorkSheet:Range("J2"):Value = "LINEA".
chWorkSheet:Range("K2"):Value = "SUBLINEA".
chWorkSheet:Range("L2"):Value = "PROVEEDOR".
chWorkSheet:Range("M2"):Value = "RANKING".
chWorkSheet:Range("N2"):Value = "CATEGORIA".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("K"):NumberFormat = "@".
/* chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy". */
/* chWorkSheet:COLUMNS("C"):NumberFormat = "@".          */
    
FOR EACH Almmmatg WHERE Almmmatg.CodCia = s-codcia
    AND Almmmatg.TpoArt <> "D"
    AND ( COMBO-BOX-CodFam = 'Todas' 
          OR Almmmatg.codfam = COMBO-BOX-CodFam ) NO-LOCK,
    FIRST Almtfami OF Almmmatg NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    EACH INTEGRAL.Almmmate OF INTEGRAL.Almmmatg
    WHERE Almmmate.CodAlm = s-codalm NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmate.codmat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmate.StkMin.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmate.StkMax.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmate.StkRep.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = fStock(FILL-IN-FchCorte).

    /* Ventas a 15 dias del mismo periodo del año pasado */
    RUN Ventas-Promedio ( TODAY - 365, TODAY - 365 + 15, s-CodAlm, Almmmate.CodMat, OUTPUT pVtaPromedio).
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = pVtaPromedio.

    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.UndStk.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.DesMat.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.DesMar.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.CodFam + ' ' + Almtfami.desfam.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.SubFam + ' ' + AlmSFami.dessub.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.CodPr1.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN
        chWorkSheet:Cells(t-Row, t-Column):VALUE = gn-prov.CodPro + ' ' + gn-prov.NomPro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.OrdTmp.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = Almmmatg.tiprot[1].
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm NO-LOCK.
  FILL-IN-Almacen = "ALMACÉN: " + Almacen.codalm + " " + CAPS(Almacen.Descripcion).

  FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
      COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' ' + Almtfami.desfam, Almtfami.codfam)
          IN FRAME {&FRAME-NAME}.
  END.

  FILL-IN-FchCorte = TODAY.


  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ventas-Promedio wWin 
PROCEDURE Ventas-Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFchIni AS DATE.
DEF INPUT PARAMETER pFchFin AS DATE.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pVtaPromedio AS DEC.

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-CodMat AS CHAR NO-UNDO.
DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.
DEF VAR x-Items  AS INT NO-UNDO.
DEF VAR x-Promedio AS DEC NO-UNDO.
DEF VAR x-Fecha  AS DATE NO-UNDO.
DEF VAR x-Desviacion AS DEC NO-UNDO.

/* CALCULO ESTADISTICO DE LAS VENTAS DIARIAS */
EMPTY TEMP-TABLE Detalle.
/* PRIMERA PASADA */
ASSIGN
    x-CodMat = pCodMat
    x-FchIni = pFchIni
    x-FchFin = pFchFin
    x-Factor = 1
    pVtaPromedio = 0.
RUN Carga-Ventas (x-FchIni, x-FchFin, x-CodMat, s-CodAlm, x-Factor).

/* SEGUNDA PASADA: CARGAMOS LAS VENTAS POR EL CODIGO EQUIVALENTE */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK.
IF NUM-ENTRIES(Almmmatg.Libre_c03, '|') = 2 THEN DO:
    ASSIGN
        x-Factor = DECIMAL(ENTRY(2, Almmmatg.Libre_c03, '|'))
        x-CodMat = ENTRY(1, Almmmatg.Libre_c03, '|').
    RUN Carga-Ventas (x-FchIni, x-FchFin, x-CodMat, s-CodAlm, x-Factor).
END.

/* CALCULO ESTADISTICO */
ASSIGN
    x-Items = 0
    x-Promedio = 0.
DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle AND WEEKDAY(x-Fecha) = 1 THEN NEXT.    /* DOMINGO SIN VENTA */
    x-Items = x-Items + 1.
    IF AVAILABLE Detalle THEN x-Promedio = x-Promedio + Detalle.candes.
END.
x-Promedio = x-Promedio / x-Items.

DO x-Fecha = pFchIni TO pFchFin:
    FIND Detalle WHERE Detalle.fchdoc = x-Fecha NO-LOCK NO-ERROR.
    IF AVAILABLE Detalle 
    THEN x-Desviacion = x-Desviacion + EXP( ( Detalle.CanDes - x-Promedio ) , 2 ).
    ELSE x-Desviacion = x-Desviacion + EXP( ( 0 - x-Promedio ) , 2 ).
END.
x-Desviacion = SQRT ( x-Desviacion / ( x-Items - 1 ) ).

/* Eliminamos los items que están fuera de rango */
FOR EACH Detalle:
    IF Detalle.candes > (x-Promedio + 3 * x-Desviacion) OR Detalle.candes < (x-Promedio - 3 * x-Desviacion) 
    THEN DO:
        DELETE Detalle.
        x-Items = x-Items - 1.
    END.
END.
x-Promedio = 0.
FOR EACH Detalle:
    x-Promedio = x-Promedio + Detalle.candes.
END.
/*pVtaPromedio = x-Promedio / x-Items.*/
pVtaPromedio = x-Promedio.      /* <<< OJO <<< */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStock wWin 
FUNCTION fStock RETURNS DECIMAL
  ( pFchCorte AS DATE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF pFchCorte = TODAY THEN RETURN Almmmate.stkact.
  FIND LAST Almstkal OF Almmmate WHERE Almstkal.fecha <= pFchCorte
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almstkal THEN RETURN AlmStkal.StkAct.
  ELSE RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

