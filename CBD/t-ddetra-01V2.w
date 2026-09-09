&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DDET LIKE cb-ddetr.



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

DEF SHARED VAR lh_handle AS HANDLE.

DEF BUFFER B-DDET FOR T-DDET.

DEF SHARED VAR pv-codcia AS INT.

DEF SHARED VAR s-codcia AS INT.

/* Variables para capturar el EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.
DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DDET gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DDET.CodPro gn-prov.NomPro ~
T-DDET.CtaPro T-DDET.ImpDep T-DDET.CodBien T-DDET.TipOpe ~
T-DDET.Provi_Periodo T-DDET.Provi_Nromes T-DDET.CodDoc T-DDET.NroSer ~
T-DDET.NroDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DDET.CodPro T-DDET.ImpDep ~
T-DDET.CodBien T-DDET.TipOpe T-DDET.Provi_Periodo T-DDET.Provi_Nromes ~
T-DDET.CodDoc T-DDET.NroSer T-DDET.NroDoc 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DDET
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DDET
&Scoped-define QUERY-STRING-br_table FOR EACH T-DDET WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia ~
  AND gn-prov.CodPro = T-DDET.CodPro NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DDET WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST gn-prov WHERE gn-prov.CodCia = pv-codcia ~
  AND gn-prov.CodPro = T-DDET.CodPro NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DDET gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DDET
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-prov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS x-ImpTot 

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
DEFINE VARIABLE x-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe Total >>>" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DDET, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DDET.CodPro COLUMN-LABEL "Proveedor" FORMAT "x(11)":U
      gn-prov.NomPro FORMAT "x(50)":U
      T-DDET.CtaPro COLUMN-LABEL "<<<Cuenta>>>" FORMAT "x(11)":U
      T-DDET.ImpDep FORMAT "Z,ZZZ,ZZ9.99":U
      T-DDET.CodBien FORMAT "x(3)":U
      T-DDET.TipOpe FORMAT "x(2)":U
      T-DDET.Provi_Periodo FORMAT "9999":U WIDTH 5.86
      T-DDET.Provi_Nromes FORMAT "99":U WIDTH 3.43
      T-DDET.CodDoc FORMAT "X(4)":U
      T-DDET.NroSer FORMAT "x(5)":U WIDTH 7.14
      T-DDET.NroDoc FORMAT "X(15)":U WIDTH 13.72
  ENABLE
      T-DDET.CodPro
      T-DDET.ImpDep
      T-DDET.CodBien
      T-DDET.TipOpe
      T-DDET.Provi_Periodo
      T-DDET.Provi_Nromes
      T-DDET.CodDoc
      T-DDET.NroSer
      T-DDET.NroDoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 126 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.54 COL 1
     x-ImpTot AT ROW 8.46 COL 58 COLON-ALIGNED
     "|-------------------------------- PROVISION ---------------------------------|" VIEW-AS TEXT
          SIZE 38 BY .5 AT ROW 1 COL 86 WIDGET-ID 2
          BGCOLOR 1 FGCOLOR 15 
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
   Temp-Tables and Buffers:
      TABLE: T-DDET T "SHARED" ? INTEGRAL cb-ddetr
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
         HEIGHT             = 10.19
         WIDTH              = 132.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{aplic/cbd/cbglobal.i}
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN x-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DDET,INTEGRAL.gn-prov WHERE Temp-Tables.T-DDET ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.gn-prov.CodCia = pv-codcia
  AND INTEGRAL.gn-prov.CodPro = Temp-Tables.T-DDET.CodPro"
     _FldNameList[1]   > Temp-Tables.T-DDET.CodPro
"T-DDET.CodPro" "Proveedor" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.gn-prov.NomPro
     _FldNameList[3]   > Temp-Tables.T-DDET.CtaPro
"T-DDET.CtaPro" "<<<Cuenta>>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DDET.ImpDep
"T-DDET.ImpDep" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DDET.CodBien
"T-DDET.CodBien" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DDET.TipOpe
"T-DDET.TipOpe" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DDET.Provi_Periodo
"T-DDET.Provi_Periodo" ? ? "integer" ? ? ? ? ? ? yes ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DDET.Provi_Nromes
"T-DDET.Provi_Nromes" ? ? "integer" ? ? ? ? ? ? yes ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DDET.CodDoc
"T-DDET.CodDoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-DDET.NroSer
"T-DDET.NroSer" ? "x(5)" "character" ? ? ? ? ? ? yes ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-DDET.NroDoc
"T-DDET.NroDoc" ? "X(15)" "character" ? ? ? ? ? ? yes ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME T-DDET.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DDET.CodPro br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DDET.CodPro IN BROWSE br_table /* Proveedor */
DO:
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
    AND Gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov 
  THEN DISPLAY 
        Gn-prov.nompro 
        Gn-prov.telfnos[3] @ T-DDET.CtaPro
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF T-DDET.CodBien, T-DDET.CodPro, T-DDET.CtaPro, T-DDET.ImpDep, T-DDET.TipOpe,
    /*T-DDET.Provi_Codope, T-DDET.Provi_NroAst,*/ T-DDET.Provi_Nromes, T-DDET.Provi_Periodo,
    T-DDET.CodDoc, T-DDET.Nroser, T-DDET.NroDoc
    DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-DDET.

ASSIGN
    t-Column = 0
    t-Row = 3.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* PROVEEDOR */
    ASSIGN
        cValue = chWorkSheet:Cells(t-Row, 10):VALUE
        cValue = STRING(DEC(cValue), '99999999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la fila' t-Row SKIP
            'RUC errado' cValue SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.Ruc = cValue NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la fila' t-Row SKIP
            'RUC errado' cValue SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    CREATE T-DDET.
    ASSIGN
        T-DDET.CodPro = gn-prov.codpro
        T-DDET.CtaPro = Gn-prov.telfnos[3].
    /* IMPORTE */
    cValue = chWorkSheet:Cells(t-Row, 19):VALUE.
    ASSIGN
        T-DDET.ImpDep = DEC(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la fila' t-Row SKIP
            'Retención errado' cValue SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        DELETE T-DDET.
        RETURN.
    END.
    /* Bien o Servicio */
    cValue = chWorkSheet:Cells(t-Row, 13):VALUE.
    ASSIGN
        T-DDET.CodBien = cValue.
    /* Operacion */
    ASSIGN
        T-DDET.TipOpe = "01".
    /* Periodo */
    cValue = chWorkSheet:Cells(t-Row, 1):VALUE.
    ASSIGN
        T-DDET.Provi_Periodo = INT(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la fila' t-Row SKIP
            'Periodo errado' cValue SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        DELETE T-DDET.
        RETURN.
    END.
    /* Mes */
    cValue = chWorkSheet:Cells(t-Row, 2):VALUE.
    ASSIGN
        T-DDET.Provi_NroMes = INT(cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'ERROR en la fila' t-Row SKIP
            'Mes errado' cValue SKIP
            'Proceso abortado'
            VIEW-AS ALERT-BOX ERROR.
        DELETE T-DDET.
        RETURN.
    END.
    /* Documento */
    ASSIGN
        T-DDET.CodDoc = "FAC".
    /* Serie */
    cValue = chWorkSheet:Cells(t-Row, 7):VALUE.
    ASSIGN
        T-DDET.NroSer = SUBSTRING(cValue,1,5)
        T-DDET.NroDoc = SUBSTRING(cValue,6).

    RUN valida-importacion.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        DELETE T-DDET.
        RETURN.
    END.

END.

END PROCEDURE.

PROCEDURE valida-importacion:

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lSerDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
      AND Gn-prov.codpro = T-DDET.CodPro
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-prov THEN DO:
      MESSAGE 'Proveedor no registrado' T-DDET.CodPro VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Cb-Tabl WHERE Cb-tabl.Tabla = '30' 
      AND Cb-tabl.Codigo = T-DDET.CodBien
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-Tabl THEN DO:
      MESSAGE 'Tipo de bien o servicio no registrado' T-DDET.CodBien VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Cb-Tabl WHERE Cb-tabl.Tabla = '31' 
      AND Cb-tabl.Codigo = T-DDET.TipOpe
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-Tabl THEN DO:
      MESSAGE 'Tipo de operación no registrado' T-DDET.TipOpe VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF T-DDET.CtaPro = '' THEN DO:
      MESSAGE 'El proveedor' T-DDET.codpro gn-prov.nompro SKIP 'NO tiene una cuenta en el Banco de la Nación' SKIP
          'Configurar la cuenta en el maestro de proveedores'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  lCodDoc = trim(T-DDET.CodDoc).
  lSerDoc = trim(T-DDET.NroSer).
  lNroDoc = trim(T-DDET.NroDoc).

  IF lCodDoc <> "" AND lCodDoc <> 'FAC' AND lCodDoc <> 'BOL'  THEN DO:
    MESSAGE "Codigos de documentos validos FAC:Factura, BOL:Boleta de Venta" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF lSerDoc = ? THEN DO:
    MESSAGE "La SERIE del documento esta errado!!" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF lNroDoc = ? THEN DO:
    MESSAGE "El NUMERO del documento esta errado!!" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF  (lCodDoc = "" AND (lSerDoc <> "" OR lNroDoc <> "")) OR 
      (lCodDoc <> "" AND (lSerDoc = "" OR lNroDoc = ""))THEN DO:
      MESSAGE "Datos del Documento estan ERRADOS!!" VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  RETURN "OK".
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel B-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE FILL-IN-Archivo AS CHAR NO-UNDO.
DEFINE VARIABLE OKpressed AS LOG NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
    FILTERS "Archivos Excel (*.xls)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

CREATE "Excel.Application" chExcelApplication.
chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

RUN Carga-Temporal.

chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

 RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Disable-Head').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-DDET.CtaPro = T-DDET.CtaPro:SCREEN-VALUE IN BROWSE {&browse-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Total.

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
  RUN Total.

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
  RUN Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
        WHEN "CodBien" THEN 
            ASSIGN
                input-var-1 = "30"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "TipOpe" THEN 
            ASSIGN
                input-var-1 = "31"
                input-var-2 = ""
                input-var-3 = "".
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
  {src/adm/template/snd-list.i "T-DDET"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Total B-table-Win 
PROCEDURE Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  x-ImpTot = 0.
  FOR EACH B-DDET:
    x-ImpTot = x-ImpTot + B-DDET.ImpDep.
  END.
  DISPLAY x-ImpTot WITH FRAME {&FRAME-NAME}.
  
  
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

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lSerDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
      AND Gn-prov.codpro = T-DDET.CodPro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-prov THEN DO:
      MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Cb-Tabl WHERE Cb-tabl.Tabla = '30' 
      AND Cb-tabl.Codigo = T-DDET.CodBien:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-Tabl THEN DO:
      MESSAGE 'Tipo de bien o servicio no registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND Cb-Tabl WHERE Cb-tabl.Tabla = '31' 
      AND Cb-tabl.Codigo = T-DDET.TipOpe:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Cb-Tabl THEN DO:
      MESSAGE 'Tipo de operación no registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF T-DDET.CtaPro:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN DO:
      MESSAGE 'El proveedor NO tiene una cuenta en el Banco de la Nación' SKIP
          'Configurar la cuenta en el maestro de proveedores'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO T-DDET.CodPro.
      RETURN 'ADM-ERROR'.
  END.

  lCodDoc = trim(T-DDET.CodDoc:SCREEN-VALUE IN BROWSE {&browse-name}).
  lSerDoc = trim(T-DDET.NroSer:SCREEN-VALUE IN BROWSE {&browse-name}).
  lNroDoc = trim(T-DDET.NroDoc:SCREEN-VALUE IN BROWSE {&browse-name}).

  IF lCodDoc <> "" AND lCodDoc <> 'FAC' AND lCodDoc <> 'BOL'  THEN DO:
    MESSAGE "Codigos de documentos validos FAC:Factura, BOL:Boleta de Venta" VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-DDET.CodDoc.
    RETURN 'ADM-ERROR'.
  END.
  IF lSerDoc = ? THEN DO:
    MESSAGE "La SERIE del documento esta errado!!" VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-DDET.NroSer.
    RETURN 'ADM-ERROR'.
  END.
  IF lNroDoc = ? THEN DO:
    MESSAGE "El NUMERO del documento esta errado!!" VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO T-DDET.NroDoc.
    RETURN 'ADM-ERROR'.
  END.
  IF  (lCodDoc = "" AND (lSerDoc <> "" OR lNroDoc <> "")) OR 
      (lCodDoc <> "" AND (lSerDoc = "" OR lNroDoc = ""))THEN DO:
      MESSAGE "Datos del Documento estan ERRADOS!!" VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO T-DDET.NroDoc.
      RETURN 'ADM-ERROR'.
  END.


  /* Verificamos asiento de provision */
/*   FIND cb-cmov WHERE cb-cmov.codcia = s-codcia                                                   */
/*       AND cb-cmov.periodo = INTEGER (T-DDET.Provi_Periodo:SCREEN-VALUE IN BROWSE {&browse-name}) */
/*       AND cb-cmov.nromes = INTEGER (T-DDET.Provi_Nromes:SCREEN-VALUE IN BROWSE {&browse-name})   */
/*       AND cb-cmov.codope = T-DDET.Provi_Codope:SCREEN-VALUE IN BROWSE {&browse-name}             */
/*       AND cb-cmov.nroast = T-DDET.Provi_NroAst:SCREEN-VALUE IN BROWSE {&browse-name}             */
/*       NO-LOCK NO-ERROR.                                                                          */
/*   IF NOT AVAILABLE cb-cmov THEN DO:                                                              */
/*       MESSAGE 'Provisión NO registrada' VIEW-AS ALERT-BOX ERROR.                                 */
/*       APPLY 'entry' TO T-DDET.Provi_Periodo.                                                     */
/*       RETURN 'ADM-ERROR'.                                                                        */
/*   END.                                                                                           */
  /* ******************************** */

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

