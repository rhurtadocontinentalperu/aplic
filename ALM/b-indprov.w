&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          reporte          PROGRESS
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

DEFINE SHARED VAR S-CODCIA AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES IndProvC
&Scoped-define FIRST-EXTERNAL-TABLE IndProvC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR IndProvC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Indprov gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Indprov.CodProv gn-prov.NomPro ~
Indprov.Monto[1] Indprov.Monto[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Indprov.CodProv ~
Indprov.Monto[1] Indprov.Monto[2] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodProv ~{&FP2}CodProv ~{&FP3}~
 ~{&FP1}Monto[1] ~{&FP2}Monto[1] ~{&FP3}~
 ~{&FP1}Monto[2] ~{&FP2}Monto[2] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Indprov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Indprov
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Indprov OF IndProvC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodPro = Indprov.CodProv NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Indprov gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Indprov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Indprov, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Indprov.CodProv FORMAT "X(13)"
      gn-prov.NomPro COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(45)"
      Indprov.Monto[1] COLUMN-LABEL "Monto Campaña!US$" COLUMN-FGCOLOR 9
      Indprov.Monto[2] COLUMN-LABEL "Monto no Campaña!US$" COLUMN-FGCOLOR 9
  ENABLE
      Indprov.CodProv
      Indprov.Monto[1]
      Indprov.Monto[2]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 75.86 BY 8.12
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: REPORTE.IndProvC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.15
         WIDTH              = 75.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "REPORTE.Indprov OF REPORTE.IndProvC,INTEGRAL.gn-prov WHERE REPORTE.Indprov ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[2]      = "INTEGRAL.gn-prov.CodPro = REPORTE.Indprov.CodProv"
     _FldNameList[1]   > REPORTE.Indprov.CodProv
"Indprov.CodProv" ? "X(13)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > INTEGRAL.gn-prov.NomPro
"gn-prov.NomPro" "Nombre o Razon Social" "x(45)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > REPORTE.Indprov.Monto[1]
"Indprov.Monto[1]" "Monto Campaña!US$" ? "decimal" ? 9 ? ? ? ? yes ?
     _FldNameList[4]   > REPORTE.Indprov.Monto[2]
"Indprov.Monto[2]" "Monto no Campaña!US$" ? "decimal" ? 9 ? ? ? ? yes ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF Indprov.Codprov,Indprov.Monto[1],Indprov.Monto[2]
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "IndProvC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "IndProvC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE iColumn                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".
DEFINE BUFFER b-faccpedi for faccpedi.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
/*chWorkSheet:Columns("A"):ColumnWidth = 11.
 * chWorkSheet:Columns("B"):ColumnWidth = 20.
 * chWorkSheet:Columns("C"):ColumnWidth = 20.
 * chWorkSheet:Columns("D"):ColumnWidth = 20.
 * chWorkSheet:Columns("E"):ColumnWidth = 20.
 * chWorkSheet:Columns("F"):ColumnWidth = 20.
 * chWorkSheet:Columns("G"):ColumnWidth = 20.*/


chWorkSheet:Range("A1:AB8"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Font:Size = 16.
chWorkSheet:Range("A1"):Value = "Indicador de Proveedores".
chWorkSheet:Range("A3:AB7"):Font:Size = 10.
chWorkSheet:Range("A3"):Value = "Periodo de Evaluacion del " + STRING(Indprovc.DesdeF,"99/99/9999") +
                                " al " + STRING(Indprovc.HastaF,"99/99/9999").
chWorkSheet:Range("A4"):Value = "Stock Al " + STRING(Indprovc.FchStk,"99/99/9999") .

chWorkSheet:Range("A7"):Value = "Codigo".
chWorkSheet:Range("B7"):Value = "Razon Social".
chWorkSheet:Range("C7"):Value = "Linea $".
chWorkSheet:Range("I7"):Value = "Clasificacion %".
chWorkSheet:Range("P7"):Value = "Compra".
chWorkSheet:Range("Q7"):Value = "Venta".
chWorkSheet:Range("R7"):Value = "Stock x almacen (Participacion en %)".
chWorkSheet:Range("Y7"):Value = "Rotacion".
chWorkSheet:Range("Z7"):Value = "Participacion".
chWorkSheet:Range("AA7"):Value = "Participacion".

chWorkSheet:Range("A8:AB8"):Font:Size = 8.

chWorkSheet:Range("C8"):Value = "Periodo Camp".
chWorkSheet:Range("D8"):Value = "Periodo no Camp".
chWorkSheet:Range("E8"):Value = "Stock".
chWorkSheet:Range("F8"):Value = "Pend x Recibir".
chWorkSheet:Range("G8"):Value = "Total".
chWorkSheet:Range("H8"):Value = "Disponible".

chWorkSheet:Range("I8"):Value = "A".
chWorkSheet:Range("J8"):Value = "B".
chWorkSheet:Range("K8"):Value = "C".
chWorkSheet:Range("L8"):Value = "D".
chWorkSheet:Range("M8"):Value = "E".
chWorkSheet:Range("N8"):Value = "F".
chWorkSheet:Range("O8"):Value = " ".
chWorkSheet:Range("P8"):Value = "Acumulada $".
chWorkSheet:Range("Q8"):Value = "Acumulada $".
chWorkSheet:Range("R8"):Value = "Alm Ate".
chWorkSheet:Range("S8"):Value = "Alm  83".
chWorkSheet:Range("T8"):Value = "Andah".
chWorkSheet:Range("U8"):Value = "Ucayali".
chWorkSheet:Range("V8"):Value = "Paruro".
chWorkSheet:Range("W8"):Value = "Margen".
chWorkSheet:Range("X8"):Value = "Items".
chWorkSheet:Range("Y8"):Value = "Anual".
chWorkSheet:Range("Z8"):Value = "Vta x Proveedor".
chWorkSheet:Range("AA8"):Value = "Util x Proveedor".

chWorkSheet:Range("A9:AB5000"):Font:Size = 8.


/* cambia de hoja  */

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */
iColumn = 9.
FOR EACH Indprov OF IndProvc:
    FIND Gn-Prov WHERE Gn-Prov.Codcia = 0 AND
                       Gn-Prov.Codpro = Indprov.Codprov
                       NO-LOCK NO-ERROR.

 
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = indprov.codprov.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = gn-prov.nompro.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Monto[1] .
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Monto[2] .
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkVal .
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.ComPen .
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Total .
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Dispon  .
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[1] .
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[2] .
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[3] .
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[4] .
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[5] .
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[6] .
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Clasifi[7] .

    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.TotCom .
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.TotVta .
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkAlm[1]  .
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkAlm[2]   .
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkAlm[3] .
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkAlm[4] . 
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.StkAlm[5]  .
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Margen .
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.Items .
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.RotAnu.
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.PartVta .
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = Indprov.PartUti .

    iColumn = iColumn + 1.


END.




/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGn 
   IndProv.Codcia = IndProvc.Codcia
   IndProv.NumInd = IndProvc.NumInd.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "IndProvC"}
  {src/adm/template/snd-list.i "Indprov"}
  {src/adm/template/snd-list.i "gn-prov"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


