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

/*&SCOPED-DEFINE Precio-de-Venta pri/p-precio-mayor-credito*/
&SCOPED-DEFINE Precio-de-Venta pri/PrecioVentaMayorCredito

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-Tipo AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion (VtaListaMay.CodCia = s-CodCia AND ~
VtaListaMay.CodDiv = COMBO-BOX-Lista)

&SCOPED-DEFINE Condicion2 (Almmmatg.codfam = COMBO-BOX-CodFam)

DEF TEMP-TABLE Detalle
    FIELD DtoVolR AS DEC
    FIELD DtoVolD AS DEC
    FIELD PreUni  AS DEC.

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
&Scoped-define INTERNAL-TABLES VtaListaMay Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaListaMay.codmat Almmmatg.DesMat ~
Almmmatg.DesMar VtaListaMay.Chr__01 VtaListaMay.PromDto ~
(IF VtaListaMay.FlagDesctos =  0 THEN 'NORMAL' ELSE 'SIN DESCUENTO') @ x-Tipo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaListaMay ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF VtaListaMay ~
      WHERE {&Condicion2} NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaListaMay ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST Almmmatg OF VtaListaMay ~
      WHERE {&Condicion2} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaListaMay Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaListaMay
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Lista COMBO-BOX-ClfCli BUTTON-10 ~
BUTTON-11 COMBO-BOX-CodFam BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Lista COMBO-BOX-ClfCli ~
COMBO-BOX-CodFam 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 10" 
     SIZE 7 BY 1.62 TOOLTIP "Por CATEGORIA".

DEFINE BUTTON BUTTON-11 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 11" 
     SIZE 7 BY 1.62 TOOLTIP "Por ESCALAS".

DEFINE VARIABLE COMBO-BOX-ClfCli AS CHARACTER FORMAT "X(256)":U INITIAL "C" 
     LABEL "Clasificacion" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaListaMay, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaListaMay.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 9.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 60.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      VtaListaMay.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      VtaListaMay.PromDto COLUMN-LABEL "Dcto Feria %" FORMAT "->9.9999":U
            WIDTH 13
      (IF VtaListaMay.FlagDesctos =  0 THEN 'NORMAL' ELSE 'SIN DESCUENTO') @ x-Tipo COLUMN-LABEL "Config. de!Descuento" FORMAT "x(15)":U
            WIDTH 2.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 117 BY 23.15
         FONT 4 ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Lista AT ROW 1.27 COL 12 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-ClfCli AT ROW 1.27 COL 65 COLON-ALIGNED WIDGET-ID 8
     BUTTON-10 AT ROW 1.27 COL 98 WIDGET-ID 6
     BUTTON-11 AT ROW 1.27 COL 105 WIDGET-ID 10
     COMBO-BOX-CodFam AT ROW 2.08 COL 12 COLON-ALIGNED WIDGET-ID 2
     BROWSE-2 AT ROW 3.15 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 119 BY 25.85
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "LISTA DE PRECIOS EVENTOS - FORMATO 001"
         HEIGHT             = 25.85
         WIDTH              = 119
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-CodFam F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaListaMay,INTEGRAL.Almmmatg OF INTEGRAL.VtaListaMay"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "{&Condicion2}"
     _FldNameList[1]   > INTEGRAL.VtaListaMay.codmat
"VtaListaMay.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "60.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaListaMay.Chr__01
"VtaListaMay.Chr__01" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaListaMay.PromDto
"VtaListaMay.PromDto" "Dcto Feria %" ? "decimal" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"(IF VtaListaMay.FlagDesctos =  0 THEN 'NORMAL' ELSE 'SIN DESCUENTO') @ x-Tipo" "Config. de!Descuento" "x(15)" ? ? ? ? ? ? ? no ? no no "2.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* LISTA DE PRECIOS EVENTOS - FORMATO 001 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LISTA DE PRECIOS EVENTOS - FORMATO 001 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
    /* This ADM trigger code must be preserved in order to notify other
       objects when the browser's current row changes. */
    {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 10 */
DO:
  ASSIGN COMBO-BOX-ClfCli COMBO-BOX-CodFam COMBO-BOX-Lista.
  RUN Generar-Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Button 11 */
DO:
  ASSIGN COMBO-BOX-ClfCli COMBO-BOX-CodFam COMBO-BOX-Lista.
  RUN Generar-Excel-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME F-Main /* Línea */
DO:
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Lista W-Win
ON VALUE-CHANGED OF COMBO-BOX-Lista IN FRAME F-Main /* Lista Precios */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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
  DISPLAY COMBO-BOX-Lista COMBO-BOX-ClfCli COMBO-BOX-CodFam 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Lista COMBO-BOX-ClfCli BUTTON-10 BUTTON-11 COMBO-BOX-CodFam 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Excel W-Win 
PROCEDURE Generar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.
DEFINE VAR s-UndVta AS CHAR NO-UNDO.
DEFINE VAR f-Factor AS DEC NO-UNDO.
DEFINE VAR F-PREBAS AS DEC NO-UNDO.
DEFINE VAR F-PREVTA AS DEC NO-UNDO.
DEFINE VAR F-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Y-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Z-DSCTOS AS DEC NO-UNDO.
DEFINE VAR X-TIPDTO AS CHAR NO-UNDO.
DEFINE VAR f-FleteUnitario AS DEC NO-UNDO.
DEFINE VAR x-ImpLin AS DEC NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

SESSION:SET-WAIT-STATE('GENERAL').
{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iRow = 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND 
    gn-divi.coddiv = COMBO-BOX-Lista NO-LOCK.
    chWorkSheet:Range(cRange):VALUE = "LISTA DE PRECIOS: " + gn-divi.coddiv + " " + CAPS(gn-divi.desdiv).
iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    FIND ClfClie WHERE ClfClie.Categoria = COMBO-BOX-ClfCli NO-LOCK.
    chWorkSheet:Range(cRange):VALUE = "Los precios corresponden a la categoria " +
        ClfClie.Categoria + " " +
        ClfClie.DesCat.
iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Los precios incluyen IGV".
iRow = iRow + 2.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Codigo".
    cRange = "B" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Descripcion".
    cRange = "C" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Marca".
    cRange = "D" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Unidad".
    cRange = "E" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Cajon".
    cRange = "F" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Dcto Feria".
    cRange = "G" + TRIM(STRING(iRow)).
    chWorkSheet:Range(cRange):VALUE = "Precio Final".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".

iRow = iRow + 1.
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE VtaListaMay:
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = VtaListaMay.codmat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = Almmmatg.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = Almmmatg.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = VtaListaMay.Chr__01.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = Almmmatg.Libre_d03.
    /* Lista de Precios */
    s-UndVta = VtaListaMay.Chr__01.
    f-Factor = 1.
    RUN {&Precio-de-Venta} (
        "E",    /* Expolibreria */
        COMBO-BOX-Lista,
        '11111111111',
        Almmmatg.MonVta,        /*1,*/
        INPUT-OUTPUT S-UNDVTA,
        OUTPUT f-Factor,
        VtaListaMay.codmat,
        "001",
        1,
        4,
        OUTPUT F-PREBAS,
        OUTPUT F-PREVTA,
        OUTPUT F-DSCTOS,
        OUTPUT Y-DSCTOS,
        OUTPUT Z-DSCTOS,
        OUTPUT X-TIPDTO,
        COMBO-BOX-ClfCli,
        OUTPUT f-FleteUnitario,
        "",
        NO).
    f-PreVta = f-PreVta + f-FleteUnitario.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = (IF VtaListaMay.FlagDesctos =  0 THEN STRING(y-Dsctos,'>>9.99') ELSE 'ESCALA').
    cRange = "G" + cColumn.
    x-ImpLin = ROUND ( F-PREVTA * ( 1 - z-Dsctos / 100 ) * ( 1 - y-Dsctos / 100 ) , 4 ).
    chWorkSheet:Range(cRange):VALUE = (IF VtaListaMay.FlagDesctos =  0 THEN STRING(x-ImpLin, '>>>,>>9.9999') ELSE 'ESCALA').

    GET NEXT {&BROWSE-NAME}.
    iRow = iRow + 1.
END.
SESSION:SET-WAIT-STATE('').
chExcelApplication:Visible = TRUE.
{lib\excel-close-file.i} 

RUN lib/logtabla ("EXPOLIBRERIA",
                  COMBO-BOX-Lista + "," + COMBO-BOX-CodFam + "," + COMBO-BOX-ClfCli ,
                  "IMPRIMELISTA").

{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Excel-2 W-Win 
PROCEDURE Generar-Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
define VAR cValue as char.
DEFINE VAR s-UndVta AS CHAR NO-UNDO.
DEFINE VAR f-Factor AS DEC NO-UNDO.
DEFINE VAR F-PREBAS AS DEC NO-UNDO.
DEFINE VAR F-PREVTA AS DEC NO-UNDO.
DEFINE VAR F-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Y-DSCTOS AS DEC NO-UNDO.
DEFINE VAR Z-DSCTOS AS DEC NO-UNDO.
DEFINE VAR X-TIPDTO AS CHAR NO-UNDO.
DEFINE VAR f-FleteUnitario AS DEC NO-UNDO.
DEFINE VAR x-ImpLin AS DEC NO-UNDO.

DEF VAR k AS INT NO-UNDO.
DEF VAR f-Precio AS DEC NO-UNDO.

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

SESSION:SET-WAIT-STATE('GENERAL').
{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iRow = 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND 
    gn-divi.coddiv = COMBO-BOX-Lista NO-LOCK.
    chWorkSheet:Range(cRange):VALUE = "LISTA DE PRECIOS: " + gn-divi.coddiv + " " + CAPS(gn-divi.desdiv).
iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    FIND ClfClie WHERE ClfClie.Categoria = COMBO-BOX-ClfCli NO-LOCK.
    chWorkSheet:Range(cRange):VALUE = "Los precios corresponden a la categoria " +
        ClfClie.Categoria + " " +
        ClfClie.DesCat.
iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Los precios incluyen IGV".
iRow = iRow + 1.
    cColumn = TRIM(STRING(iRow)).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ESCALA DE VENTAS".
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAILABLE VtaListaMay:
    IF VtaListaMay.FlagDesctos <> 0 THEN DO:
        /* TITULOS */
        iRow = iRow + 2.
        cColumn = TRIM(STRING(iRow)).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = CAPS(Almmmatg.DesMat).
        iRow = iRow + 1.
        cColumn = TRIM(STRING(iRow)).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = VtaListaMay.Chr__01.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "CAJA".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "P.UNITARIO".
        /* Buscamos los descuentos por volumen y los ordenamos */
        EMPTY TEMP-TABLE Detalle.
        DO k = 1 TO 10:
            IF VtaListaMay.DtoVolR[k] = 0 THEN LEAVE.
            F-PRECIO = VtaListaMay.PreOfi.
            IF Almmmatg.MonVta = 2 THEN F-PRECIO = F-PRECIO * Almmmatg.TpoCmb.
            /* Flete */
            RUN {&Precio-de-Venta} (
                "E",    /* Expolibreria */
                COMBO-BOX-Lista,
                '11111111111',
                Almmmatg.MonVta,        /*1,*/
                INPUT-OUTPUT S-UNDVTA,
                OUTPUT f-Factor,
                VtaListaMay.codmat,
                "001",
                VtaListaMay.DtoVolR[k],
                4,
                OUTPUT F-PREBAS,
                OUTPUT F-PREVTA,
                OUTPUT F-DSCTOS,
                OUTPUT Y-DSCTOS,
                OUTPUT Z-DSCTOS,
                OUTPUT X-TIPDTO,
                COMBO-BOX-ClfCli,
                OUTPUT f-FleteUnitario,
                "",
                NO).
            F-Precio = F-Precio + f-FleteUnitario.
            /* ***** */
            CREATE Detalle.
            ASSIGN
                Detalle.DtoVolR = VtaListaMay.DtoVolR[k]
                Detalle.DtoVolD = VtaListaMay.DtoVolD[k]
                Detalle.PreUni  = ROUND(F-PRECIO * ( 1 - ( VtaListaMay.DtoVolD[k] / 100 ) ),4).
        END.
        FOR EACH Detalle BY Detalle.DtoVolR DESC:
            iRow = iRow + 1.
            cColumn = TRIM(STRING(iRow)).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Detalle.DtoVolR.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = (Detalle.DtoVolR / Almmmatg.Libre_d03).
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Detalle.PreUni.
        END.
        iRow = iRow + 1.
        cColumn = TRIM(STRING(iRow)).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "P.MOSTRADOR".
        cColumn = TRIM(STRING(iRow)).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = F-PRECIO.
    END.
    GET NEXT {&BROWSE-NAME}.
END.
SESSION:SET-WAIT-STATE('').
chExcelApplication:Visible = TRUE.
{lib\excel-close-file.i} 

RUN lib/logtabla ("EXPOLIBRERIA",
                  COMBO-BOX-Lista + "," + COMBO-BOX-CodFam,
                  "IMPRIMELISTA").

{&OPEN-QUERY-{&BROWSE-NAME}}

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
      COMBO-BOX-CodFam:DELETE(1).
      FOR EACH VtaTabla WHERE VtaTabla.Llave_c1 = s-User-Id
          AND VtaTabla.CodCia = s-codcia
          AND VtaTabla.Tabla = "LP" NO-LOCK,
          EACH Almtfami WHERE Almtfami.CodCia = VtaTabla.CodCia
          AND Almtfami.codfam = VtaTabla.Llave_c2 NO-LOCK
          BREAK BY VtaTabla.CodCia:
          IF FIRST-OF(VtaTabla.CodCia) THEN COMBO-BOX-CodFam = Almtfami.codfam.
          COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' ' + Almtfami.desfam,Almtfami.codfam ).
      END.
      COMBO-BOX-Lista:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
          gn-divi.canalventa = "FER" AND
          gn-divi.campo-log[1] = NO
          BREAK BY gn-divi.codcia:
          IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Lista = GN-DIVI.CodDiv.
          COMBO-BOX-Lista:ADD-LAST(GN-DIVI.CodDiv + ' ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
      END.
      COMBO-BOX-ClfCli:DELETE(1).
      FOR EACH ClfClie NO-LOCK WHERE ClfClie.PorDsc > 0:
          COMBO-BOX-ClfCli:ADD-LAST(ClfClie.Categoria + " = " + ClfClie.DesCat,ClfClie.Categoria).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "VtaListaMay"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

