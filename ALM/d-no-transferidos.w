&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF INPUT PARAMETER TABLE FOR T-MATG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-MATG Almmmatg

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-MATG.Libre_c01 T-MATG.codmat ~
Almmmatg.DesMat Almmmatg.DesMar Almmmatg.UndStk T-MATG.Libre_d01 ~
T-MATG.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-MATG NO-LOCK, ~
      EACH Almmmatg OF T-MATG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-MATG NO-LOCK, ~
      EACH Almmmatg OF T-MATG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-MATG Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-MATG
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 BUTTON-1 Btn_OK 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClasificacion D-Dialog 
FUNCTION fClasificacion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "CONTINUAR" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      T-MATG, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 D-Dialog _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-MATG.Libre_c01 COLUMN-LABEL "Almacén!Despacho" FORMAT "x(3)":U
            WIDTH 7.29
      T-MATG.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 8.43
      Almmmatg.DesMat FORMAT "X(50)":U WIDTH 38.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      T-MATG.Libre_d01 COLUMN-LABEL "Cantidad" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.29
      T-MATG.Libre_d02 COLUMN-LABEL "Stock Disponible" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 13.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 15.08
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-3 AT ROW 1 COL 1 WIDGET-ID 200
     BUTTON-1 AT ROW 16.08 COL 1 WIDGET-ID 2
     Btn_OK AT ROW 16.35 COL 89
     SPACE(2.00) SKIP(0.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "PRODUCTOS QUE NO PUDIERON SER TRANSFERIDOS"
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-MATG,INTEGRAL.Almmmatg OF Temp-Tables.T-MATG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-MATG.Libre_c01
"T-MATG.Libre_c01" "Almacén!Despacho" "x(3)" "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MATG.codmat
"T-MATG.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(50)" "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.Almmmatg.UndStk
"Almmmatg.UndStk" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MATG.Libre_d01
"T-MATG.Libre_d01" "Cantidad" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MATG.Libre_d02
"T-MATG.Libre_d02" "Stock Disponible" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* PRODUCTOS QUE NO PUDIERON SER TRANSFERIDOS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Button 1 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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
  ENABLE BROWSE-3 BUTTON-1 Btn_OK 
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

SESSION:SET-WAIT-STATE('GENERAL').

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
chWorkSheet:Range("A2"):VALUE = "Código".
chWorkSheet:Range("B2"):VALUE = "Descripcion".
chWorkSheet:Range("C2"):VALUE = "Marca".
chWorkSheet:Range("D2"):VALUE = "Unidad".
chWorkSheet:Range("E2"):VALUE = "Almacén Despacho".
chWorkSheet:Range("F2"):VALUE = "Cantidad Requerida".
chWorkSheet:Range("G2"):VALUE = "Cantidad Generada".
chWorkSheet:Range("H2"):VALUE = "Stock Actual".
chWorkSheet:Range("I2"):VALUE = "Stock Reservado".
chWorkSheet:Range("J2"):VALUE = "Stock Disponible".
chWorkSheet:Range("K2"):VALUE = "Stock Máximo + Seguridad".
chWorkSheet:Range("L2"):VALUE = "Stock en Tránsito".
chWorkSheet:Range("M2"):VALUE = "Empaque Reposición".
chWorkSheet:Range("N2"):VALUE = "Empaque Mastes".
chWorkSheet:Range("O2"):VALUE = "Clasificacion".
chWorkSheet:Range("P2"):VALUE = "Origen".
chWorkSheet:Range("Q2"):VALUE = "Zona".
chWorkSheet:Range("R2"):VALUE = "Costo de Reposicion".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".


/* Encabezado de Control */
chWorkSheet:Range("A1"):VALUE = "PEDIDO DE REPOSICION - " + TRIM(s-CodAlm).
t-Row = 2.
chWorkSheet = chExcelApplication:Sheets:Item(1).
FOR EACH T-MATG NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = T-MATG.CodMat NO-LOCK NO-ERROR.
    FIND FIRST Almmmate WHERE Almmmate.codcia = s-codcia
        AND Almmmate.codalm = s-codalm AND Almmmate.codmat = T-MATG.codmat
        NO-LOCK NO-ERROR.
    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.CodMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_c01.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d02.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d02.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (IF AVAILABLE Almmmate THEN Almmmate.StkAct ELSE 0).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d01.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (IF AVAILABLE Almmmate THEN (Almmmate.StkAct - T-MATG.Libre_d01) ELSE 0).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (IF AVAILABLE Almmmate THEN Almmmate.StkMin ELSE 0).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = 0.     /*T-MATG.CanTran.*/
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (IF AVAILABLE Almmmate THEN Almmmate.StkMax ELSE 0).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.CanEmp.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fClasificacion().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = 'MAN'.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (IF AVAILABLE Almmmate THEN Almmmate.codubi ELSE '').
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d01 * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot).
END.
/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
FOR EACH T-MATG NO-LOCK WHERE T-MATG.Libre_d02 > 0, 
    FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = s-codalm AND Almmmate.codmat = T-MATG.codmat:
    t-Row = t-Row + 1.
    t-Column = 1.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = T-MATG.CodMat NO-LOCK NO-ERROR.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.CodMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_c01.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d02.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d02.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkAct.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d01.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = (Almmmate.StkAct - T-MATG.Libre_d01).
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkMin.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = 0.     /*T-MATG.CanTran.*/
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.StkMax.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.CanEmp.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fClasificacion().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = 'MAN'.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Almmmate.codubi.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = T-MATG.Libre_d01 * (IF Almmmatg.MonVta = 2 THEN Almmmatg.CtoTot * Almmmatg.TpoCmb ELSE Almmmatg.CToTot).
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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
  {src/adm/template/snd-list.i "T-MATG"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClasificacion D-Dialog 
FUNCTION fClasificacion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almcfggn THEN RETURN Almmmatg.TipRot[1].
  FIND FacTabla WHERE FacTabla.CodCia = s-codcia 
      AND FacTabla.Tabla = 'RANKVTA'
      AND FacTabla.Codigo = Almmmatg.codmat
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacTabla THEN RETURN Almmmatg.TipRot[1].
  FIND gn-divi WHERE gn-divi.codcia = s-codcia
      AND gn-divi.coddiv = s-coddiv
      NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN Almcfggn.Temporada = "C" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[2].
          ELSE RETURN FacTabla.Campo-C[3].
      END.
      WHEN Almcfggn.Temporada = "NC" THEN DO:
          IF GN-DIVI.CanalVenta = "MIN" THEN RETURN FacTabla.Campo-C[5].
          ELSE RETURN FacTabla.Campo-C[6].
      END.
  END CASE.


  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

