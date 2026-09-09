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
DEF SHARED VAR s-nomcia AS CHAR.

DEF SHARED VAR s-user-id AS CHAR.
DEF BUFFER DOCU FOR Ccbcdocu.

DEF VAR ImpMndS LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR ImpMndD LIKE ccbcdocu.imptot NO-UNDO.
DEF VAR documto LIKE ccbcdocu.coddoc NO-UNDO.

&SCOPED-DEFINE CONDICION ccbcdocu.codcia = s-codcia ~
AND (txt-cliente = "" OR ccbcdocu.codcli = txt-cliente) ~
AND (LOOKUP(ccbcdocu.coddoc,documto) > 0) ~
AND ccbcdocu.flgest = 'J'

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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.CodDiv CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.FchDoc ~
CcbCDocu.FchVto CcbCDocu.FchUbi ~
IF (CcbCDocu.CodMon =1 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndS ~
IF (CcbCDocu.CodMon =2 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndD ~
CcbCDocu.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY CcbCDocu.FchUbi DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&CONDICION} NO-LOCK ~
    BY CcbCDocu.FchUbi DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txt-cliente br_table x-docs btn-Actualizar ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS txt-cliente x-docs x-TotalMn x-TotalMe 

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
DEFINE BUTTON btn-Actualizar 
     LABEL "Actualizar" 
     SIZE 15 BY 1.35.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 1" 
     SIZE 5.29 BY 1.46 TOOLTIP "Calcula totales".

DEFINE VARIABLE txt-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-TotalMe AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total de documentos en Dolares" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 14  NO-UNDO.

DEFINE VARIABLE x-TotalMn AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total de documentos en Soles" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 14  NO-UNDO.

DEFINE VARIABLE x-docs AS CHARACTER INITIAL "Todas" 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "Todas" 
     SIZE 12 BY 4.85 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Docu." FORMAT "x(3)":U
      CcbCDocu.NroDoc COLUMN-LABEL "<<<Numero>>>" FORMAT "x(12)":U
      CcbCDocu.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 9.86
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 34.86
      CcbCDocu.FchDoc COLUMN-LABEL "<Emision>" FORMAT "99/99/99":U
      CcbCDocu.FchVto COLUMN-LABEL "Vencmto." FORMAT "99/99/99":U
            WIDTH 7
      CcbCDocu.FchUbi COLUMN-LABEL "<Castigo>" FORMAT "99/99/99":U
      IF (CcbCDocu.CodMon =1 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndS COLUMN-LABEL "Importe S/." FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.57
      IF (CcbCDocu.CodMon =2 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndD COLUMN-LABEL "Importe $" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.43
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 113 BY 13.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-cliente AT ROW 1.27 COL 8 COLON-ALIGNED WIDGET-ID 16
     br_table AT ROW 1.27 COL 23
     x-docs AT ROW 2.62 COL 10 NO-LABEL WIDGET-ID 10
     btn-Actualizar AT ROW 7.73 COL 7 WIDGET-ID 14
     x-TotalMn AT ROW 14.81 COL 101 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 14.81 COL 115 WIDGET-ID 6
     x-TotalMe AT ROW 15.62 COL 101 COLON-ALIGNED WIDGET-ID 4
     "Doc." VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 2.62 COL 5 WIDGET-ID 12
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
         HEIGHT             = 15.54
         WIDTH              = 140.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table txt-cliente F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* SETTINGS FOR FILL-IN x-TotalMe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-TotalMn IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.CcbCDocu.FchUbi|no"
     _Where[1]         = "{&CONDICION}"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Docu." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" "<<<Numero>>>" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.CodDiv
"CcbCDocu.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "34.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "<Emision>" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Vencmto." "99/99/99" "date" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.FchUbi
"CcbCDocu.FchUbi" "<Castigo>" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"IF (CcbCDocu.CodMon =1 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndS" "Importe S/." "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"IF (CcbCDocu.CodMon =2 ) THEN (CcbCDocu.ImpTot) ELSE (0) @ ImpMndD" "Importe $" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME btn-Actualizar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Actualizar B-table-Win
ON CHOOSE OF btn-Actualizar IN FRAME F-Main /* Actualizar */
DO:  
  ASSIGN 
      txt-cliente
      x-docs.
  documto = x-docs.
  IF documto = "Todas" THEN 
      documto = "FAC,BOL,LET,CHQ,N/C,N/D".
  
  RUN dispatch IN THIS-PROCEDURE ('open-query').
                                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
 RUN Totales.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Excel B-table-Win 
PROCEDURE Carga-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE x-ImporteMn AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-ImporteMe AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE x-SaldoMn AS DECIMAL.
    DEFINE VARIABLE x-SaldoMe AS DECIMAL.
    DEFINE VARIABLE cCliente  AS CHARACTER   NO-UNDO.

    cCliente = txt-cliente:SCREEN-VALUE IN FRAME {&FRAME-NAME}.    
    documto = x-docs:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF documto = "Todas" THEN documto = "FAC,BOL,LET,CHQ,N/C,N/D".

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE COBRANZA DUDOSA".

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Documento".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "División".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nombre".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Emisión".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Castigo".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe $".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo $".
    iCount = iCount + 1.

    FOR EACH Ccbcdocu NO-LOCK WHERE {&Condicion}:
/*     FOR EACH CcbCDocu NO-LOCK USE-INDEX llave06        */
/*         WHERE ccbcdocu.codcia = s-codcia               */
/*         AND ccbcdocu.codcli BEGINS txt-cliente         */
/*         AND LOOKUP(TRIM(ccbcdocu.coddoc), documto) > 0 */
/*         AND ccbcdocu.flgest = "J"                      */
/*         BREAK BY ccbcdocu.codcli                       */
/*             BY ccbcdocu.fchdoc:                        */

        IF ccbcdocu.codmon = 1 THEN 
            ASSIGN
                x-ImporteMn = ccbcdocu.imptot
                x-ImporteMe = 0
                x-SaldoMn = ccbcdocu.sdoact
                x-SaldoMe = 0.
        ELSE ASSIGN
            x-ImporteMn = ccbcdocu.imptot
            x-ImporteMe = 0
            x-SaldoMe = ccbcdocu.sdoact
            x-SaldoMn = 0.

        FIND FIRST facdocum 
            WHERE facdocum.codcia = ccbcdocu.codcia
            AND facdocum.coddoc = ccbcdocu.coddoc NO-LOCK NO-ERROR.
        IF AVAILABLE facdocum AND facdocum.tpodoc = NO THEN
            ASSIGN
                x-SaldoMe = - 1 * x-SaldoMe
                x-SaldoMn = - 1 * x-SaldoMn.

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.codDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.NroDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.CodDiv.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + ccbcdocu.CodCli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.NomCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.fchdoc.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ccbcdocu.FchUbi.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = x-ImporteMn.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = x-ImporteMe.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = x-SaldoMn.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = x-SaldoMe.
        iCount = iCount + 1.
  END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

  FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN 'ADM-ERROR'.

  MESSAGE "Está seguro de sacar el documento de la cobranza dudosa?"
      VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN DO:
      FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
      RETURN "ADM-ERROR".
  END.

  /* RHC 23.11.2010 CONTROL CONTABLE */
  FIND CcbDMvto WHERE CcbDMvto.CodCia = Ccbcdocu.codcia
      AND CcbDMvto.CodDoc = "DCD"       /* Cobranza Dudosa */
      AND CcbDMvto.CodRef = Ccbcdocu.coddoc
      AND CcbDMvto.NroRef = Ccbcdocu.nrodoc
      EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE CcbDMvto THEN DO:
      IF CcbDMvto.FlgCbd = YES THEN DO:
          MESSAGE 'Este documento ya ha sido transferido a contabilidad' SKIP
              'Continuamos con el proceso?'
              VIEW-AS ALERT-BOX QUESTION 
              BUTTONS YES-NO
              UPDATE rpta-2 AS LOG.
          IF rpta-2 = NO THEN DO:
              FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
      DELETE CcbDMvto.
      RELEASE CcbDMvto.
  END.
  ASSIGN
      CcbCDocu.FchUbi = CcbCDocu.FchUbiA
      CcbCDocu.FchAct = TODAY
      CcbCDocu.FlgEst = 'P'
      CcbCDocu.usuario = s-user-id.

  FIND CURRENT Ccbcdocu NO-LOCK NO-ERROR.
  RETURN 'OK'.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN          
          txt-cliente
          x-docs.
      IF x-docs = "Todas" THEN 
          documto = "FAC,BOL,LET,N/C,N/D".
      ELSE
          documto = x-docs.
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'Base'  VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'.
  RB-REPORT-NAME = 'Cobranza Dudosa'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "ccbcdocu.codcia = " + STRING(s-codcia) + 
              " and ccbcdocu.codcli BEGINS '" + txt-cliente + "'" + 
              " and ccbcdocu.flgest = 'J'"  + 
              " and LOOKUP(ccbcdocu.coddoc,'" + documto + "') > 0 " . 
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.

  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

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
  
  DO WITH FRAME {&FRAME-NAME}:
      x-docs:LIST-ITEMS = "Todas".  
      FOR EACH facdocum WHERE facdocum.codcia = s-codcia 
          AND LOOKUP(facdocum.coddoc,"FAC,BOL,LET,CHQ,N/C,N/D,DCO") > 0 NO-LOCK:
          x-docs:ADD-LAST(facdocum.coddoc).
      END.
      x-docs:SCREEN-VALUE = "Todas".  
      documto = "FAC,BOL,LET,CHQ,N/C,N/D,DCO".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    x-TotalMe = 0 x-TotalMn = 0.
 GET FIRST {&BROWSE-NAME}.
 DO WHILE AVAILABLE(Ccbcdocu):
     IF Ccbcdocu.codmon = 1 THEN x-TotalMn = x-TotalMn + Ccbcdocu.SdoAct.
     ELSE x-TotalMe = x-TotalMe + Ccbcdocu.SdoAct.
    GET NEXT {&BROWSE-NAME}.
 END.
DISPLAY
    x-TotalMe x-TotalMn WITH FRAME {&FRAME-NAME}.

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

