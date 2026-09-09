&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEFINE SHARED VARIABLE  S-PERIODO    AS INTEGER .
DEFINE SHARED VARIABLE  S-NROMES     AS INTEGER .

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

/*RUN cbd/cb-m000-1.r(OUTPUT P-LIST).*/
RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

&SCOPED-DEFINE Condicion cb-control.tipo = COMBO-BOX-Tipo ~
AND cb-control.CodCia = s-codcia ~
AND  (COMBO-BOX-CodDiv = "Todas" OR cb-control.CodDiv = COMBO-BOX-CodDiv) ~
AND cb-control.Periodo = COMBO-BOX-Periodo ~
AND (COMBO-BOX-NroMes = 0 OR cb-control.Nromes = COMBO-BOX-NroMes)

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-control

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 cb-control.Periodo ~
cb-control.Nromes cb-control.CodDiv cb-control.Codope cb-control.Nroast ~
cb-control.FchPro cb-control.Usuario cb-control.Fecha cb-control.Hora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH cb-control ~
      WHERE {&Condicion} NO-LOCK ~
    BY cb-control.CodDiv ~
       BY cb-control.Codope ~
        BY cb-control.Nroast INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH cb-control ~
      WHERE {&Condicion} NO-LOCK ~
    BY cb-control.CodDiv ~
       BY cb-control.Codope ~
        BY cb-control.Nroast INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 cb-control
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 cb-control


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Tipo BUTTON-1 COMBO-BOX-CodDiv ~
COMBO-BOX-Periodo COMBO-BOX-NroMes BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Tipo COMBO-BOX-CodDiv ~
COMBO-BOX-Periodo COMBO-BOX-NroMes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6 BY 1.54 TOOLTIP "Exportar a Excel".

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Todas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 71 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEM-PAIRS "Todos",0,
                     "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "@CJ" 
     LABEL "Tipo de Asiento" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Asiento de Caja","@CJ",
                     "Deposito de Cheques en Banco","@CHD",
                     "Depósitos Bóveda a Banco","@BOV",
                     "Depósito de Tarjetas de Crédito","@TCR",
                     "Boletas de Depósito","@BD",
                     "Canje de Letras","@CCB",
                     "Cobranza de Letras x Nota Bancaria","@N/B",
                     "Asiento de Ventas","@PV",
                     "Asiento de Venta Transferencia Gratuita","@PVT",
                     "Anticipos de Campaña","@A/C"
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      cb-control SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      cb-control.Periodo FORMAT "->>>9":U
      cb-control.Nromes FORMAT "99":U
      cb-control.CodDiv FORMAT "x(5)":U
      cb-control.Codope COLUMN-LABEL "Operación" FORMAT "x(3)":U
      cb-control.Nroast COLUMN-LABEL "Asiento" FORMAT "x(6)":U
            WIDTH 10.86
      cb-control.FchPro COLUMN-LABEL "Fecha Asiento" FORMAT "99/99/9999":U
      cb-control.Usuario FORMAT "X(12)":U
      cb-control.Fecha COLUMN-LABEL "Fecha Proceso" FORMAT "99/99/9999":U
            WIDTH 14.14
      cb-control.Hora COLUMN-LABEL "Hora Proceso" FORMAT "X(5)":U
            WIDTH 28.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 17.12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Tipo AT ROW 1.19 COL 16 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.19 COL 106 WIDGET-ID 10
     COMBO-BOX-CodDiv AT ROW 2.35 COL 16 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-Periodo AT ROW 3.5 COL 16 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-NroMes AT ROW 4.65 COL 16 COLON-ALIGNED WIDGET-ID 8
     BROWSE-2 AT ROW 5.81 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.86 BY 22.54 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONTROL DE ASIENTOS TRANSFERIDOS"
         HEIGHT             = 22.54
         WIDTH              = 111.86
         MAX-HEIGHT         = 22.54
         MAX-WIDTH          = 111.86
         VIRTUAL-HEIGHT     = 22.54
         VIRTUAL-WIDTH      = 111.86
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-NroMes F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.cb-control"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.cb-control.CodDiv|yes,INTEGRAL.cb-control.Codope|yes,INTEGRAL.cb-control.Nroast|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.cb-control.Periodo
     _FldNameList[2]   = INTEGRAL.cb-control.Nromes
     _FldNameList[3]   > INTEGRAL.cb-control.CodDiv
"cb-control.CodDiv" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.cb-control.Codope
"cb-control.Codope" "Operación" "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.cb-control.Nroast
"cb-control.Nroast" "Asiento" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.cb-control.FchPro
"cb-control.FchPro" "Fecha Asiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.cb-control.Usuario
     _FldNameList[8]   > INTEGRAL.cb-control.Fecha
"cb-control.Fecha" "Fecha Proceso" ? "date" ? ? ? ? ? ? no ? no no "14.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.cb-control.Hora
"cb-control.Hora" "Hora Proceso" ? "character" ? ? ? ? ? ? no ? no no "28.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONTROL DE ASIENTOS TRANSFERIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONTROL DE ASIENTOS TRANSFERIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Excel.
    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Todas */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroMes W-Win
ON VALUE-CHANGED OF COMBO-BOX-NroMes IN FRAME F-Main /* Mes */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Periodo IN FRAME F-Main /* Periodo */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Tipo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Tipo IN FRAME F-Main /* Tipo de Asiento */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DISPLAY COMBO-BOX-Tipo COMBO-BOX-CodDiv COMBO-BOX-Periodo COMBO-BOX-NroMes 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Tipo BUTTON-1 COMBO-BOX-CodDiv COMBO-BOX-Periodo 
         COMBO-BOX-NroMes BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
DEF VAR Titulo AS CHAR NO-UNDO.

CASE COMBO-BOX-Tipo:
    WHEN "@CJ" THEN Titulo = "Asiento de Caja".
    WHEN "@CHD" THEN Titulo = "Deposito de Cheques en Banco".
    WHEN "@BOV" THEN Titulo = "Depósitos Bóveda a Banco".
    WHEN "@TCR" THEN Titulo = "Depósito de Tarjetas de Crédito".
    WHEN "@BD" THEN Titulo = "Boletas de Depósito".
    WHEN "@CCB" THEN Titulo = "Canje de Letras".
    WHEN "@N/B" THEN Titulo = "Cobranza de Letras x Nota Bancaria".
    WHEN "@PV" THEN Titulo = "Asiento de Ventas".
    WHEN "@PVT" THEN Titulo = "Asiento de Venta Transferencia Gratuita".
    WHEN "@A/C" THEN Titulo = "Anticipos de Campaña".
END CASE.
ASSIGN
    chWorkSheet:Range("A1"):Value = Titulo
    chWorkSheet:Range("A2"):Value = "Periodo"
    chWorkSheet:Range("B2"):Value = "Mes"
    chWorkSheet:Range("C2"):Value = "C.Div"
    chWorkSheet:Range("D2"):Value = "Operación"
    chWorkSheet:Range("E2"):Value = "Asiento"
    chWorkSheet:Range("F2"):Value = "Fecha Asiento"
    chWorkSheet:Range("G2"):Value = "Usuario"
    chWorkSheet:Range("H2"):Value = "Fecha Proceso"
    chWorkSheet:Range("I2"):Value = "Hora Proceso"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Columns("D"):NumberFormat = "@"
    chWorkSheet:Columns("E"):NumberFormat = "@"
    chWorkSheet:Columns("F"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Columns("H"):NumberFormat = "dd/mm/yyyy".

ASSIGN
    t-Row = 2.
FOR EACH cb-control NO-LOCK WHERE {&Condicion}:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Periodo.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Nromes.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.CodDiv.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Codope.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Nroast.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.FchPro.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Usuario.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Fecha.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = cb-control.Hora.
END.
chExcelApplication:VISIBLE = TRUE.

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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
          COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv + ' '  + gn-divi.desdiv, gn-divi.coddiv).
      END.
      COMBO-BOX-Periodo = ?.
      COMBO-BOX-Periodo:LIST-ITEMS = P-LIST.
      IF LOOKUP(STRING(s-Periodo), p-List) > 0 THEN COMBO-BOX-Periodo = s-Periodo.
      ELSE COMBO-BOX-Periodo = INTEGER(ENTRY(NUM-ENTRIES(p-List), p-List)).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   FILL-PERIODO-1 = ?.                                                                                                                       */
/*   DO WITH FRAME {&FRAME-NAME} :                                                                                                             */
/*      FILL-PERIODO-1:LIST-ITEMS = P-LIST.                                                                                                    */
/*      FILL-PERIODO-1:SCREEN-VALUE = ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST).  /* INTEGER(ENTRY(NUM-ENTRIES(P-LIST) , P-LIST)). */ */
/*      FILL-PERIODO-1 = INTEGER(ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST)).                                                          */
/*      S-Periodo    = FILL-PERIODO-1.                                                                                                         */
/*      IF S-PERIODO = YEAR( TODAY ) THEN S-NROMES = MONTH ( TODAY).                                                                           */
/*      ELSE DO:                                                                                                                               */
/*           IF S-PERIODO > YEAR(TODAY) THEN S-NROMES =  1.                                                                                    */
/*           ELSE S-NROMES = 12.                                                                                                               */
/*      END.                                                                                                                                   */
/*      F-mes = S-NROMES.                                                                                                                      */
/*      run bin/_mes( f-mes , 1 , output f-n-mes ).                                                                                            */
/*      display F-mes f-n-mes.                                                                                                                 */
/*   END.                                                                                                                                      */

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cb-control"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

