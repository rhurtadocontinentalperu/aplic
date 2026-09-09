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
DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-coddoc AS CHAR INIT 'PER' NO-UNDO.
DEF VAR s-nroser AS CHAR INIT '914,915' NO-UNDO.

DEFINE VAR dDesde AS DATE.
DEFINE VAR dHasta AS DATE.
DEFINE VAR cCliente AS CHAR.
DEFINE VAR cCodDiv AS CHAR.
DEFINE VAR cSerie AS CHAR.

cCodDiv     = "".
cSerie      = '914,915'.
cCliente    = "".
dDesde      = 01/01/1990.
dHasta      = TODAY.

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.CcbCMvto.CodCia = s-codcia AND ~
            INTEGRAL.CcbCMvto.CodDoc = s-coddoc AND ~
            LOOKUP(SUBSTRING(INTEGRAL.CcbCMvto.NroDoc,1,3), cSerie) > 0 AND ~
            (INTEGRAL.CcbCMvto.fchdoc >= dDesde AND INTEGRAL.CcbCMvto.fchdoc <= dhasta) AND ~
            INTEGRAL.CcbCMvto.coddiv BEGINS cCodDiv AND ~
            INTEGRAL.CcbCMvto.codcli BEGINS cCliente)

/*
&SCOPED-DEFINE CONDICION ( ~
    FacCPedi.CodCia = s-CodCia AND ~
    FacCPedi.CodDoc = s-CodDoc AND ~
    FacCPedi.DivDes = s-CodDiv AND ~
    FacCPedi.FlgEst = "P" AND ~
    FacCPedi.FlgSit = "C" )

INTEGRAL.CcbCMvto.CodCia = s-codcia
 AND INTEGRAL.CcbCMvto.CodDoc = s-coddoc
 AND LOOKUP(SUBSTRING(INTEGRAL.CcbCMvto.NroDoc,1,3), s-nroser) > 0
 and {&CONDICION}
 */

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
&Scoped-define INTERNAL-TABLES CcbCMvto gn-clie

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 CcbCMvto.CodDiv CcbCMvto.FchDoc ~
CcbCMvto.NroDoc CcbCMvto.CodCli gn-clie.NomCli ~
IF (CcbCMvto.FlgEst = "A") THEN ("ANULADO") ELSE ("") @ CcbCMvto.FlgEst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH CcbCMvto ~
      WHERE CcbCMvto.CodCia = s-codcia ~
 AND CcbCMvto.CodDoc = s-coddoc ~
 and {&CONDICION} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = CcbCMvto.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH CcbCMvto ~
      WHERE CcbCMvto.CodCia = s-codcia ~
 AND CcbCMvto.CodDoc = s-coddoc ~
 and {&CONDICION} NO-LOCK, ~
      FIRST gn-clie WHERE gn-clie.CodCli = CcbCMvto.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 CcbCMvto gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 CcbCMvto
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 gn-clie


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta txtSerie cboDivision ~
txtCliente BROWSE-3 BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta txtSerie cboDivision ~
txtCliente FILL-IN-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.92.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.92.

DEFINE VARIABLE cboDivision AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1.15 NO-UNDO.

DEFINE VARIABLE txtCliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.15 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.15 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.15 NO-UNDO.

DEFINE VARIABLE txtSerie AS CHARACTER FORMAT "X(25)":U INITIAL "914,008,915" 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 15.57 BY 1.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      CcbCMvto, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      CcbCMvto.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U
      CcbCMvto.FchDoc FORMAT "99/99/9999":U
      CcbCMvto.NroDoc FORMAT "X(9)":U WIDTH 8.72
      CcbCMvto.CodCli FORMAT "x(11)":U WIDTH 11.86
      gn-clie.NomCli FORMAT "x(250)":U WIDTH 43.72
      IF (CcbCMvto.FlgEst = "A") THEN ("ANULADO") ELSE ("") @ CcbCMvto.FlgEst COLUMN-LABEL "ESTADO" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 92 BY 16.92
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtDesde AT ROW 1.58 COL 5.29 COLON-ALIGNED WIDGET-ID 6
     txtHasta AT ROW 1.58 COL 26.14 COLON-ALIGNED WIDGET-ID 8
     txtSerie AT ROW 1.62 COL 46.43 COLON-ALIGNED WIDGET-ID 10
     cboDivision AT ROW 1.77 COL 68.57 COLON-ALIGNED WIDGET-ID 12
     txtCliente AT ROW 3.12 COL 6 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-4 AT ROW 3.15 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     BROWSE-3 AT ROW 4.65 COL 2 WIDGET-ID 200
     BUTTON-1 AT ROW 10.04 COL 96 WIDGET-ID 2
     BUTTON-2 AT ROW 13.88 COL 96 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 105.14 BY 21.12
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
         TITLE              = "IMPRIME COMPROBANTES DE PERCEPCION"
         HEIGHT             = 21.12
         WIDTH              = 105.14
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

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 FILL-IN-4 fMain */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.CcbCMvto,INTEGRAL.gn-clie WHERE INTEGRAL.CcbCMvto ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "INTEGRAL.CcbCMvto.CodCia = s-codcia
 AND INTEGRAL.CcbCMvto.CodDoc = s-coddoc
 and {&CONDICION}"
     _JoinCode[2]      = "INTEGRAL.gn-clie.CodCli = INTEGRAL.CcbCMvto.CodCli"
     _Where[2]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.CcbCMvto.CodDiv
"CcbCMvto.CodDiv" "División" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.CcbCMvto.FchDoc
     _FldNameList[3]   > INTEGRAL.CcbCMvto.NroDoc
"CcbCMvto.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCMvto.CodCli
"CcbCMvto.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "43.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"IF (CcbCMvto.FlgEst = ""A"") THEN (""ANULADO"") ELSE ("""") @ CcbCMvto.FlgEst" "ESTADO" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* IMPRIME COMPROBANTES DE PERCEPCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* IMPRIME COMPROBANTES DE PERCEPCION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
   RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
   RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboDivision
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboDivision wWin
ON VALUE-CHANGED OF cboDivision IN FRAME fMain /* Division */
DO:

  /*  MESSAGE cboDivision:SCREEN-VALUE VIEW-AS ALERT-BOX.*/

    IF cboDivision:SCREEN-VALUE = "Todos" THEN DO:
        cCodDiv = "".
    END.
    ELSE DO:
        cCodDiv = SUBSTR(cboDivision:SCREEN-VALUE,1,5).
    END.
    
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCliente wWin
ON LEAVE OF txtCliente IN FRAME fMain /* Cliente */
DO:

    cCliente = txtCliente:SCREEN-VALUE.

    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtDesde wWin
ON LEAVE OF txtDesde IN FRAME fMain /* Desde */
DO:
    ASSIGN txtDesde.

    dDesde = txtDesde.

    ASSIGN {&self-name}.
      {&OPEN-QUERY-{&BROWSE-NAME}}   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtHasta wWin
ON LEAVE OF txtHasta IN FRAME fMain /* Hasta */
DO:

  ASSIGN txtHasta.

  dHasta = txtHasta.

  ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtSerie wWin
ON LEAVE OF txtSerie IN FRAME fMain /* Serie */
DO:

    cSerie = txtSerie:SCREEN-VALUE.

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
  DISPLAY txtDesde txtHasta txtSerie cboDivision txtCliente FILL-IN-4 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtDesde txtHasta txtSerie cboDivision txtCliente BROWSE-3 BUTTON-1 
         BUTTON-2 
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
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Division".
chWorkSheet:Range("B1"):VALUE = "Fecha".
chWorkSheet:Range("C1"):VALUE = "Numero".
chWorkSheet:Range("D1"):VALUE = "Cliente".
chWorkSheet:Range("E1"):VALUE = "Nombre".
chWorkSheet:Range("F1"):VALUE = "Estado".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE Ccbcmvto:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = Ccbcmvto.coddiv.
    cRange = "B" + cColumn.   
    chWorkSheet:Range(cRange):Value = Ccbcmvto.fchdoc.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = Ccbcmvto.nrodoc.
    cRange = "D" + cColumn.   
    chWorkSheet:Range(cRange):Value = Ccbcmvto.codcli.
    cRange = "E" + cColumn.   
    chWorkSheet:Range(cRange):Value = gn-clie.nomcli.
    cRange = "F" + cColumn.   
    chWorkSheet:Range(cRange):Value = IF (CcbCMvto.FlgEst = "A") THEN ("ANULADO") ELSE ("").
    GET NEXT {&BROWSE-NAME}.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}
/* launch Excel so it is visible to the user */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR answer AS LOGICAL NO-UNDO.
DEF VAR k AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE 'Selecciones al menos un registro' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
    IF NOT answer THEN RETURN.
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
            RUN vta2/r-imppercepcion (ROWID(ccbcmvto)).
        END.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "01/01/1990".
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

          CboDivision:ADD-LAST('Todos').
          FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia :
            cboDivision:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv).
          END.
          cboDivision:SCREEN-VALUE = 'Todos'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
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

