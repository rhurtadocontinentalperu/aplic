&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Mate FOR Almmmate.
DEFINE BUFFER B-Tabla FOR VtaTabla.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

DEF SHARED VAR s-tabla AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR x-codalm AS CHAR NO-UNDO.

DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES Almmmate Almmmatg VtaTabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmate.codmat Almmmatg.DesMat ~
Almmmatg.DesMar fMoneda() @ x-Moneda Almmmatg.TpoCmb Almmmatg.UndBas ~
Almmmatg.Chr__01 Almmmatg.Prevta[1] VtaTabla.Valor[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH Almmmate WHERE ~{&KEY-PHRASE} ~
      AND Almmmate.CodCia = s-codcia ~
 AND Almmmate.CodAlm = x-codalm ~
 AND Almmmate.StkAct > 0 ~
 AND (COMBO-BOX-Precios = 'Todos' OR Almmmate.Libre_d01 <= 0) NO-LOCK, ~
      FIRST Almmmatg OF Almmmate NO-LOCK, ~
      FIRST VtaTabla WHERE VtaTabla.CodCia = Almmmate.CodCia ~
  AND VtaTabla.Llave_c1 = Almmmate.codmat ~
      AND VtaTabla.Tabla = s-tabla ~
 OUTER-JOIN NO-LOCK ~
    BY Almmmate.codmat
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmate WHERE ~{&KEY-PHRASE} ~
      AND Almmmate.CodCia = s-codcia ~
 AND Almmmate.CodAlm = x-codalm ~
 AND Almmmate.StkAct > 0 ~
 AND (COMBO-BOX-Precios = 'Todos' OR Almmmate.Libre_d01 <= 0) NO-LOCK, ~
      FIRST Almmmatg OF Almmmate NO-LOCK, ~
      FIRST VtaTabla WHERE VtaTabla.CodCia = Almmmate.CodCia ~
  AND VtaTabla.Llave_c1 = Almmmate.codmat ~
      AND VtaTabla.Tabla = s-tabla ~
 OUTER-JOIN NO-LOCK ~
    BY Almmmate.codmat.
&Scoped-define TABLES-IN-QUERY-br_table Almmmate Almmmatg VtaTabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table VtaTabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-5 COMBO-BOX-CodAlm COMBO-BOX-Precios ~
br_table BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm COMBO-BOX-Precios 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "ASIGNAR PRECIO DE VENTA" 
     SIZE 30 BY 1.12.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 5" 
     SIZE 6 BY 1.35.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén de Remate" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 61 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Precios AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Todos","Sin Precio" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmate, 
      Almmmatg, 
      VtaTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmate.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(65)":U
      Almmmatg.DesMar FORMAT "X(15)":U
      fMoneda() @ x-Moneda COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      Almmmatg.TpoCmb FORMAT "Z9.9999":U
      Almmmatg.UndBas FORMAT "X(4)":U
      Almmmatg.Chr__01 COLUMN-LABEL "Unidad!Oficina" FORMAT "X(4)":U
      Almmmatg.Prevta[1] COLUMN-LABEL "Precio Lista" FORMAT ">>,>>>,>>9.9999":U
      VtaTabla.Valor[1] COLUMN-LABEL "Precio Unitario" FORMAT "->>>,>>>,>>9.9999":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 119 BY 12.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-5 AT ROW 1 COL 113 WIDGET-ID 10
     COMBO-BOX-CodAlm AT ROW 1.27 COL 21 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Precios AT ROW 1.27 COL 89 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     br_table AT ROW 2.62 COL 1
     BUTTON-1 AT ROW 16.08 COL 1 WIDGET-ID 4
     "NOTA: Selecciona uno o mas productos para ASIGNAR PRECIO DE VENTA" VIEW-AS TEXT
          SIZE 67 BY .62 AT ROW 15.27 COL 1 WIDGET-ID 6
          BGCOLOR 7 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Mate B "?" ? INTEGRAL Almmmate
      TABLE: B-Tabla B "?" ? INTEGRAL VtaTabla
   END-TABLES.
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
         HEIGHT             = 16.27
         WIDTH              = 122.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table COMBO-BOX-Precios F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Almmmate,INTEGRAL.Almmmatg OF INTEGRAL.Almmmate,INTEGRAL.VtaTabla WHERE INTEGRAL.Almmmate ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _OrdList          = "INTEGRAL.Almmmate.codmat|yes"
     _Where[1]         = "INTEGRAL.Almmmate.CodCia = s-codcia
 AND INTEGRAL.Almmmate.CodAlm = x-codalm
 AND INTEGRAL.Almmmate.StkAct > 0
 AND (COMBO-BOX-Precios = 'Todos' OR Almmmate.Libre_d01 <= 0)"
     _JoinCode[3]      = "INTEGRAL.VtaTabla.CodCia = INTEGRAL.Almmmate.CodCia
  AND INTEGRAL.VtaTabla.Llave_c1 = INTEGRAL.Almmmate.codmat"
     _Where[3]         = "INTEGRAL.VtaTabla.Tabla = s-tabla
"
     _FldNameList[1]   > INTEGRAL.Almmmate.codmat
"Almmmate.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(65)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fMoneda() @ x-Moneda" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Almmmatg.TpoCmb
     _FldNameList[6]   = INTEGRAL.Almmmatg.UndBas
     _FldNameList[7]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "Unidad!Oficina" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.Almmmatg.Prevta[1]
"Almmmatg.Prevta[1]" "Precio Lista" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.VtaTabla.Valor[1]
"VtaTabla.Valor[1]" "Precio Unitario" ? "decimal" 11 9 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ASIGNAR PRECIO DE VENTA */
DO:
  IF {&browse-name}:NUM-SELECTED-ROWS = 0 THEN DO:
      MESSAGE 'Debe seleccionar al menos 1 registro' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  DEF VAR x-PreUni LIKE Almmmatg.PreOfi NO-UNDO.
  DEF VAR j AS INT NO-UNDO.

  RUN vtagn/d-precioremate (OUTPUT x-PreUni).
  IF x-PreUni > 0 THEN DO:
      DO j = 1 TO {&browse-name}:NUM-SELECTED-ROWS:
          IF {&browse-name}:FETCH-SELECTED-ROW(j) THEN DO:
              FIND B-MATE WHERE ROWID(B-MATE) = ROWID(Almmmate) EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE B-MATE THEN NEXT.
              FIND FIRST B-Tabla WHERE B-Tabla.codcia = s-codcia
                  AND B-Tabla.tabla = s-tabla
                  AND B-Tabla.llave_c1 = almmmate.codmat
                  EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE B-Tabla THEN DO:
                  CREATE B-Tabla.
                  ASSIGN
                      B-Tabla.codcia = s-codcia
                      B-Tabla.tabla = s-tabla
                      B-Tabla.llave_c1 = almmmate.codmat.
              END.
              ASSIGN
                  B-MATE.Libre_d01 = x-PreUni
                  B-Tabla.valor[1] = x-PreUni
                  B-Tabla.Libre_c01 = STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
                  B-Tabla.Libre_c02 = s-user-id.
          END.
      END.
      RELEASE B-Tabla.
      RELEASE B-MATE.
      RUN Procesa-Handle IN lh_handle ('Pinta-Browsers':U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
   RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacén de Remate */
DO:
  ASSIGN {&self-name}.
  x-CodAlm = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
  RUN Carga-Precio-Almacen.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Precios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Precios B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Precios IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Precio-Almacen B-table-Win 
PROCEDURE Carga-Precio-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


FOR EACH B-MATE WHERE B-MATE.codcia = s-codcia
    AND B-MATE.codalm = x-codalm
    AND B-MATE.stkact > 0:
    FIND FIRST Vtatabla WHERE VtaTabla.codcia = s-codcia
        AND Vtatabla.tabla = s-tabla
        AND Vtatabla.llave_c1 = B-MATE.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtatabla THEN B-MATE.Libre_d01 = VtaTabla.Valor[1].
    ELSE B-MATE.Libre_d01 = 0.
END.
RELEASE B-MATE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

/* Cargamos el temporal */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
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

/* Titulos */
chWorkSheet:Range("A1"):VALUE = "Codigo".
chWorkSheet:Range("B1"):VALUE = "Descripcion".
chWorkSheet:Range("C1"):VALUE = "Marca".
chWorkSheet:Range("D1"):VALUE = "Moneda".
chWorkSheet:Range("E1"):VALUE = "T.C.".
chWorkSheet:Range("F1"):VALUE = "Unidad Básica".
chWorkSheet:Range("G1"):VALUE = "Unidad Oficina".
chWorkSheet:Range("H1"):VALUE = "Precio Lista".
chWorkSheet:Range("I1"):VALUE = "Precio Unitario".
chWorkSheet:Range("J1"):VALUE = "Proveedor".

/* Formatos */
/*chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".*/
chWorkSheet:COLUMNS("A"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).
GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Almmmate:
    IF VtaTabla.Valor[1] > 0 THEN DO:
        t-Row = t-Row + 1.
        t-Column = 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmate.codmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fMoneda().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.TpoCmb.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.Chr__01.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.Prevta[1].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = VtaTabla.Valor[1].
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = Almmmatg.codpr1 NO-LOCK NO-ERROR.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.codpr1 + (IF AVAILABLE gn-prov THEN " - "  + gn-prov.nompro ELSE '').
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').


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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
  DEF VAR x-Almacen AS CHAR NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      x-Almacen = ''.
      FOR EACH Almacen NO-LOCK WHERE codcia = s-codcia
          AND campo-c[3] = "Si":
          COMBO-BOX-CodAlm:ADD-LAST(codalm + ' - ' + descripcion).
          IF x-Almacen = '' THEN x-Almacen = (codalm + ' - ' + descripcion).
      END.
      ASSIGN
          COMBO-BOX-CodAlm = x-Almacen
          x-CodAlm = ENTRY(1, x-Almacen, ' - ').
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   RUN Carga-Precio-Almacen.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "Almmmate"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "VtaTabla"}

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
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ALmmmatg THEN RETURN ''.
CASE Almmmatg.monvta:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
    OTHERWISE RETURN '¿?'.
END CASE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

