&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.

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
&Scoped-define INTERNAL-TABLES T-MATG

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-MATG.DesMat T-MATG.CodMar ~
T-MATG.CodFam T-MATG.SubFam T-MATG.CodSSFam T-MATG.Licencia[1] ~
T-MATG.Chr__02 T-MATG.TpoPro T-MATG.FlgComercial T-MATG.TpoMrg ~
T-MATG.UndBas T-MATG.UndCmp T-MATG.UndStk T-MATG.UndA T-MATG.UndB ~
T-MATG.UndC T-MATG.Chr__01 T-MATG.UndAlt[1] T-MATG.CodPr1 T-MATG.CanEmp ~
T-MATG.StkRep T-MATG.CodDigesa T-MATG.VtoDigesa T-MATG.AftIgv T-MATG.AftIsc ~
T-MATG.Largo T-MATG.Ancho T-MATG.Alto T-MATG.Libre_d02 T-MATG.Pesmat ~
T-MATG.CodBrr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-MATG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-MATG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-MATG
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-MATG


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-MATG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-MATG.DesMat FORMAT "X(45)":U
      T-MATG.CodMar FORMAT "X(4)":U
      T-MATG.CodFam COLUMN-LABEL "Familia" FORMAT "X(3)":U
      T-MATG.SubFam COLUMN-LABEL "Sub-Familia" FORMAT "X(3)":U
            WIDTH 8
      T-MATG.CodSSFam COLUMN-LABEL "Sub Sub-Familia" FORMAT "x(3)":U
      T-MATG.Licencia[1] FORMAT "x(3)":U WIDTH 9.72
      T-MATG.Chr__02 COLUMN-LABEL "Origen Desctos." FORMAT "X(8)":U
      T-MATG.TpoPro COLUMN-LABEL "Origen Compra" FORMAT "X(8)":U
      T-MATG.FlgComercial COLUMN-LABEL "Indice Comercial" FORMAT "x(8)":U
      T-MATG.TpoMrg COLUMN-LABEL "Venta" FORMAT "X(1)":U
      T-MATG.UndBas COLUMN-LABEL "Unidad Basica" FORMAT "X(8)":U
      T-MATG.UndCmp COLUMN-LABEL "Unidad Compra" FORMAT "X(8)":U
      T-MATG.UndStk COLUMN-LABEL "Unidad Stock" FORMAT "X(8)":U
      T-MATG.UndA COLUMN-LABEL "Mostrador A" FORMAT "X(8)":U
      T-MATG.UndB COLUMN-LABEL "Mostrador B" FORMAT "X(8)":U
      T-MATG.UndC COLUMN-LABEL "Mostrador C" FORMAT "X(8)":U
      T-MATG.Chr__01 COLUMN-LABEL "Oficina" FORMAT "X(8)":U
      T-MATG.UndAlt[1] COLUMN-LABEL "Al por menor" FORMAT "x(10)":U
      T-MATG.CodPr1 COLUMN-LABEL "Cod. Proveedor" FORMAT "x(11)":U
      T-MATG.CanEmp COLUMN-LABEL "Master" FORMAT "->>,>>9.99":U
      T-MATG.StkRep COLUMN-LABEL "Inner" FORMAT "ZZ,ZZZ,ZZ9.99":U
      T-MATG.CodDigesa COLUMN-LABEL "N° Autorización Sanitaria" FORMAT "x(20)":U
      T-MATG.VtoDigesa COLUMN-LABEL "Fecha Vencimiento" FORMAT "99/99/9999":U
      T-MATG.AftIgv FORMAT "Si/No":U
      T-MATG.AftIsc FORMAT "Si/No":U
      T-MATG.Largo FORMAT "999,999.9999":U
      T-MATG.Ancho FORMAT "999,999.9999":U
      T-MATG.Alto FORMAT "999,999.9999":U
      T-MATG.Libre_d02 COLUMN-LABEL "Volumen" FORMAT "->>>,>>>,>>9.99":U
      T-MATG.Pesmat FORMAT "->>,>>9.9999":U
      T-MATG.CodBrr FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 143 BY 24.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 24.73
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 24.73
         WIDTH              = 144.29
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-MATG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.T-MATG.DesMat
     _FldNameList[2]   = Temp-Tables.T-MATG.CodMar
     _FldNameList[3]   > Temp-Tables.T-MATG.CodFam
"CodFam" "Familia" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MATG.SubFam
"SubFam" "Sub-Familia" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MATG.CodSSFam
"CodSSFam" "Sub Sub-Familia" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.Licencia[1]
"Licencia[1]" ? ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.Chr__02
"Chr__02" "Origen Desctos." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MATG.TpoPro
"TpoPro" "Origen Compra" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-MATG.FlgComercial
"FlgComercial" "Indice Comercial" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-MATG.TpoMrg
"TpoMrg" "Venta" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-MATG.UndBas
"UndBas" "Unidad Basica" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-MATG.UndCmp
"UndCmp" "Unidad Compra" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-MATG.UndStk
"UndStk" "Unidad Stock" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-MATG.UndA
"UndA" "Mostrador A" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-MATG.UndB
"UndB" "Mostrador B" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-MATG.UndC
"UndC" "Mostrador C" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-MATG.Chr__01
"Chr__01" "Oficina" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-MATG.UndAlt[1]
"UndAlt[1]" "Al por menor" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-MATG.CodPr1
"CodPr1" "Cod. Proveedor" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.T-MATG.CanEmp
"CanEmp" "Master" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.T-MATG.StkRep
"StkRep" "Inner" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.T-MATG.CodDigesa
"CodDigesa" "N° Autorización Sanitaria" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.T-MATG.VtoDigesa
"VtoDigesa" "Fecha Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   = Temp-Tables.T-MATG.AftIgv
     _FldNameList[25]   = Temp-Tables.T-MATG.AftIsc
     _FldNameList[26]   = Temp-Tables.T-MATG.Largo
     _FldNameList[27]   = Temp-Tables.T-MATG.Ancho
     _FldNameList[28]   = Temp-Tables.T-MATG.Alto
     _FldNameList[29]   > Temp-Tables.T-MATG.Libre_d02
"Libre_d02" "Volumen" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   = Temp-Tables.T-MATG.Pesmat
     _FldNameList[31]   = Temp-Tables.T-MATG.CodBrr
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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
  ENABLE BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel W-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR lNuevoFile AS LOG NO-UNDO.
DEF VAR lFIleXls   AS CHAR NO-UNDO.
DEF VAR x-Archivo  AS CHAR NO-UNDO.

DEFINE VAR OKpressed AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx"
    MUST-EXIST
    TITLE "Seleccione archivo..."
    UPDATE OKpressed.   

IF OKpressed = NO THEN RETURN.
lFileXls = x-Archivo.
lNuevoFile = NO.

{lib/excel-open-file.i}
chExcelApplication:Visible = FALSE.
lMensajeAlTerminar = YES.
lCerrarAlTerminar = YES.

DEF VAR t-Col AS INT NO-UNDO.
DEF VAR t-Row AS INT NO-UNDO.
DEF VAR cValue AS CHAR NO-UNDO.
DEF VAR fValue AS DATE NO-UNDO.
DEF VAR dValue AS DEC  NO-UNDO.

ASSIGN
    t-Col = 0
    t-Row = 4.    
EMPTY TEMP-TABLE T-MATG.
SESSION:SET-WAIT-STATE('GENERAL').
REPEAT:
    ASSIGN
        t-Col = 0
        t-Row = t-Row + 1.
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* Descripción */
    CREATE T-MATG.
    ASSIGN
        T-MATG.codcia = s-codcia
        T-MATG.DesMat = cValue.
    /* Marca */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.CodMar = cValue.
    /* Familia */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.CodFam = cValue.
    /* SubFamilia */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.SubFam = cValue.
    /* SubSubFamilia */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.CodSSFam = cValue.
    /* Licencias */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Licencia[1] = cValue.
    /* Origen Descuentos */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Chr__02 = cValue.
    /* Origen Compra */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.TpoPro = cValue.
    /* Indice comercial */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.FlgComercial = cValue.
    /* Venta */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.TpoMrg = cValue.
    /* Unidad básica */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndBas = cValue.
    /* Unidad compra */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndCmp = cValue.
    /* Unidad stock */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndStk = cValue.
    /* Unidad A */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndA = cValue.
    /* Unidad B */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndB = cValue.
    /* Unidad C */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndC = cValue.
    /* Unidad oficina */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Chr__01 = cValue.
    /* Unidad al por menor */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.UndAlt[1] = cValue.
    /* Proveedor */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.CodPr1 = cValue.



    /* Digesa */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.CodDigesa = cValue.
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.VtoDigesa = DATE(cValue).
    /* IGV */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.AftIgv = LOGICAL(cValue).
    /* ISC */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.AftIsc = LOGICAL(cValue).
    /* Medidas */
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Largo = DECIMAL(cValue).
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Ancho = DECIMAL(cValue).
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Alto = DECIMAL(cValue).
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    ASSIGN
        T-MATG.Libre_d02 = DECIMAL(cValue).
    t-Col = t-Col + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Col):VALUE.
    /* Peso */
    ASSIGN
        T-MATG.Pesmat = DECIMAL(cValue).
    /* EAN 13 */
    ASSIGN
        T-MATG.CodBrr = cValue.


END.
SESSION:SET-WAIT-STATE('').

{lib/excel-close-file.i}

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
  {src/adm/template/snd-list.i "T-MATG"}

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

