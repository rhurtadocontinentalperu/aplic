&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-Tabla LIKE FacTabla.



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
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-Tabla AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR lh_handle AS HANDLE.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE FILL-IN-Archivo AS CHAR         NO-UNDO.
DEFINE VARIABLE OKpressed       AS LOG          NO-UNDO.
DEFINE VARIABLE chExcelApplication          AS COM-HANDLE.
DEFINE VARIABLE chWorkbook                  AS COM-HANDLE.
DEFINE VARIABLE chWorksheet                 AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-Tabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ~
ENTRY(1,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[1] ~
ENTRY(2,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[2] ~
ENTRY(3,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[3] T-Tabla.Valor[1] ~
T-Tabla.Valor[11] T-Tabla.Valor[2] T-Tabla.Valor[12] T-Tabla.Valor[3] ~
T-Tabla.Valor[13] T-Tabla.Valor[4] T-Tabla.Valor[14] T-Tabla.Valor[5] ~
T-Tabla.Valor[15] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-Tabla WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-Tabla WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-Tabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-Tabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-4 BUTTON-5 RADIO-SET-1 ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 

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
DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/import-excel.bmp":U
     LABEL "Button 4" 
     SIZE 19 BY 1.62.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/save.ico":U
     LABEL "Button 5" 
     SIZE 8 BY 1.88 TOOLTIP "Grabar".

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Actualizar", 1,
"Borrar todo y Actualizar", 2
     SIZE 29 BY 2.15
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 41 BY 2.69
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-Tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ENTRY(1,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[1] COLUMN-LABEL "División" FORMAT "x(6)":U
      ENTRY(2,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[2] COLUMN-LABEL "Linea" FORMAT "x(3)":U
            WIDTH 5
      ENTRY(3,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[3] COLUMN-LABEL "SubLinea" FORMAT "x(3)":U
            WIDTH 6.72
      T-Tabla.Valor[1] COLUMN-LABEL "Cant. Min." FORMAT ">>>>>>,>>9.99":U
            WIDTH 9.43
      T-Tabla.Valor[11] COLUMN-LABEL "%Dto" FORMAT ">>9.9999":U
      T-Tabla.Valor[2] COLUMN-LABEL "Cant. Min." FORMAT ">>>>>>,>>9.99":U
            WIDTH 9.43
      T-Tabla.Valor[12] COLUMN-LABEL "%Dto" FORMAT ">>9.9999":U
      T-Tabla.Valor[3] COLUMN-LABEL "Cant. Min." FORMAT ">>>>>>,>>9.99":U
            WIDTH 9.43
      T-Tabla.Valor[13] COLUMN-LABEL "%Dto" FORMAT ">>9.9999":U
      T-Tabla.Valor[4] COLUMN-LABEL "Cant. Min." FORMAT ">>>>>>,>>9.99":U
            WIDTH 9.43
      T-Tabla.Valor[14] COLUMN-LABEL "%Dto" FORMAT ">>9.9999":U
      T-Tabla.Valor[5] COLUMN-LABEL "Cant. Min." FORMAT ">>>>>>,>>9.99":U
            WIDTH 8.29
      T-Tabla.Valor[15] COLUMN-LABEL "%Dto" FORMAT ">>9.9999":U
            WIDTH .57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 105 BY 20.46
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 1.27 COL 9 WIDGET-ID 2
     BUTTON-5 AT ROW 1.27 COL 32 WIDGET-ID 14
     RADIO-SET-1 AT ROW 1.27 COL 42.43 NO-LABEL WIDGET-ID 16
     br_table AT ROW 3.69 COL 1
     RECT-1 AT ROW 1 COL 31 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Tabla T "?" ? INTEGRAL FacTabla
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
         HEIGHT             = 24.38
         WIDTH              = 108.43.
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
/* BROWSE-TAB br_table RADIO-SET-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-Tabla"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > "_<CALC>"
"ENTRY(1,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[1]" "División" "x(6)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"ENTRY(2,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[2]" "Linea" "x(3)" ? ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"ENTRY(3,t-Tabla.Codigo,'|') @ T-Tabla.Campo-C[3]" "SubLinea" "x(3)" ? ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-Tabla.Valor[1]
"T-Tabla.Valor[1]" "Cant. Min." ">>>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-Tabla.Valor[11]
"T-Tabla.Valor[11]" "%Dto" ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-Tabla.Valor[2]
"T-Tabla.Valor[2]" "Cant. Min." ">>>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-Tabla.Valor[12]
"T-Tabla.Valor[12]" "%Dto" ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-Tabla.Valor[3]
"T-Tabla.Valor[3]" "Cant. Min." ">>>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-Tabla.Valor[13]
"T-Tabla.Valor[13]" "%Dto" ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-Tabla.Valor[4]
"T-Tabla.Valor[4]" "Cant. Min." ">>>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-Tabla.Valor[14]
"T-Tabla.Valor[14]" "%Dto" ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-Tabla.Valor[5]
"T-Tabla.Valor[5]" "Cant. Min." ">>>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-Tabla.Valor[15]
"T-Tabla.Valor[15]" "%Dto" ">>9.9999" "decimal" ? ? ? ? ? ? no ? no no ".57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN Captura-Excel.
  /* Todo OK */
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 B-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN RADIO-SET-1. 
    pMensaje = ''.
    RUN Grabar-Datos (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    MESSAGE 'Carga Terminada' VIEW-AS ALERT-BOX INFORMATION.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Procesa-Handle IN lh_handle ('Open-Browsers').
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Excel B-table-Win 
PROCEDURE Captura-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* RUTINA GENERAL */
    SYSTEM-DIALOG GET-FILE FILL-IN-Archivo
        FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls,*.xlsx", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN 'ADM-ERROR'.

    /* CREAMOS LA HOJA EXCEL */
    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-Archivo).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    /* CERRAMOS EL EXCEL */
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

    /* Mensaje de error de carga */
    IF pMensaje > "" THEN DO:
        MESSAGE pMensaje SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
        EMPTY TEMP-TABLE t-Tabla.
        RETURN 'ADM-ERROR'.
    END.

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

DEF VAR k         AS INT NO-UNDO.
DEF VAR x-DtoVolR AS DEC NO-UNDO.
DEF VAR x-DtoVolD AS DEC NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.
DEF VAR x-Linea AS CHAR NO-UNDO.
DEF VAR x-SubLinea AS CHAR NO-UNDO.

/* CHEQUEAMOS LA INTEGRIDAD DEL ARCHIVO EXCEL */
ASSIGN
    t-Column = 0
    t-Row = 1.     /* Saltamos 1ra linea */

cValue = chWorkSheet:Cells(1,1):VALUE.
IF cValue = "" OR cValue = ? THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

IF NOT INDEX(cValue, "- DESCUENTOS POR VOLUMEN") > 0 THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

/* División */
ASSIGN x-CodDiv = ENTRY(1,cValue, " - ").
IF NOT CAN-FIND(gn-divi WHERE gn-divi.codcia = s-codcia AND
                gn-divi.coddiv = x-CodDiv NO-LOCK) THEN DO:
    pMensaje = "División " + x-CodDiv + " no registrada".
    RETURN.
END.

/* ******** */
ASSIGN
    t-Row    = t-Row + 1
    t-column = t-column + 1.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "LINEA" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.

t-column = t-column + 2.
cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
IF cValue = "" OR cValue = ? OR cValue <> "SUB-LINEA" THEN DO:
    pMensaje = 'Formato del archivo Excel errado'.
    RETURN.
END.
/* Cargamos temporal */
EMPTY TEMP-TABLE t-Tabla.
ASSIGN
    t-Column = 0
    t-Row = 2.     /* Saltamos el encabezado de los campos */
REPEAT:
    ASSIGN
        t-column = 0
        t-Row    = t-Row + 1.
    t-column = t-column + 1.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
    /* Linea */
    ASSIGN x-Linea = cValue.
    /* SubLinea */
    t-Column = t-Column + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN x-SubLinea = cValue.
    /* Llaves */
    CREATE t-Tabla.
    ASSIGN
        t-Tabla.codcia = s-codcia
        t-Tabla.Tabla  = s-Tabla
        t-Tabla.Codigo = TRIM(x-CodDiv) + "|" + TRIM(x-Linea) + "|" + TRIM(x-SubLinea)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Error en la línea ' + STRING(t-Row).
        LEAVE.
    END.
    /* Unidad Base */
    t-Column = t-Column + 2.
    cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
    ASSIGN
        t-Tabla.Nombre = cValue.
    /* Cargamos Descuentos por Volumen */
    DO iCountLine = 1 TO 5:
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            t-Tabla.Valor[iCountLine] = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Rango".
            LEAVE.
        END.
        t-Column = t-Column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            t-Tabla.Valor[iCountLine + 10] = DECIMAL(cValue)
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error en la linea " + TRIM(STRING(t-Row, '>>>9')) + ":"  + CHR(10) 
                + "Descuento".
            LEAVE.
        END.
    END.
END.
/* Depuración */
FOR EACH t-Tabla:
    DO k = 1 TO 5:
        IF t-Tabla.Valor[k] = ? THEN t-Tabla.Valor[k] = 0.
        IF t-Tabla.Valor[k + 10] = ? THEN t-Tabla.Valor[k + 10] = 0.
    END.
    IF NOT CAN-FIND(Almtfami WHERE Almtfami.CodCia = s-CodCia AND
                    Almtfami.codfam = ENTRY(2,t-Tabla.Codigo,'|') NO-LOCK)
        THEN DO:
        DELETE t-Tabla.
        NEXT.
    END.
    IF NOT CAN-FIND(Almsfami WHERE Almsfami.CodCia = s-CodCia AND
                    Almsfami.codfam = ENTRY(2,t-Tabla.Codigo,'|') AND
                    AlmSFami.subfam = ENTRY(3,t-Tabla.Codigo,'|') NO-LOCK)
        THEN DO:
        DELETE t-Tabla.
        NEXT.
    END.
    IF LOOKUP(ENTRY(2,t-Tabla.Codigo,'|'), "013,017") = 0 THEN DELETE t-Tabla.
END.
/* EN CASO DE ERROR */
IF pMensaje > "" THEN DO:
    EMPTY TEMP-TABLE t-Tabla.
    RETURN.
END.
/* Filtramos solo lineas autorizadas */
FOR EACH t-Tabla:
    FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = "LP"
        AND Vtatabla.llave_c1 = s-user-id
        AND Vtatabla.llave_c2 = ENTRY(2,t-Tabla.Codigo,'|')
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtatabla THEN DELETE t-Tabla.
END.
FIND FIRST t-Tabla NO-LOCK NO-ERROR.
IF NOT AVAILABLE t-Tabla THEN MESSAGE 'No hay registros que procesar' VIEW-AS ALERT-BOX ERROR.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Datos B-table-Win 
PROCEDURE Grabar-Datos PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
CICLO:            
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST t-Tabla NO-LOCK NO-ERROR.
    IF NOT AVAILABLE t-Tabla THEN LEAVE.
    IF RADIO-SET-1 = 2 THEN DO:
        FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.CodCia = s-codcia AND
            FacTabla.Tabla  = s-tabla AND
            FacTabla.Codigo BEGINS ENTRY(1,t-Tabla.Codigo,'|')
            ON ERROR UNDO, THROW:
            DELETE FacTabla.
        END.
    END.
    FOR EACH t-Tabla:
        FIND FIRST FacTabla OF t-Tabla NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacTabla THEN CREATE FacTabla.
        ELSE DO:
            FIND CURRENT FacTabla EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
        END.
        BUFFER-COPY t-Tabla TO FacTabla.
        /* 06/12/2020 Control de Margen: Cesar Camus */
        RUN Valida-Margen (OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'.

        DELETE t-Tabla.
    END.
END.
SESSION:SET-WAIT-STATE('').
RELEASE FacTabla.
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
  {src/adm/template/snd-list.i "T-Tabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Margen B-table-Win 
PROCEDURE Valida-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF VAR x-Orden AS INT NO-UNDO.

DEF VAR x-Margen AS DECI NO-UNDO.
DEF VAR x-Limite AS DECI NO-UNDO.
DEF VAR x-PorDto AS DECI NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE BUFFER LocalBufferMatg FOR Almmmatg.

RUN pri/pri-librerias PERSISTENT SET hProc.
FOR EACH LocalBufferMatg NO-LOCK WHERE LocalBufferMatg.CodCia = s-codcia AND
    LocalBufferMatg.codfam = ENTRY(2, FacTabla.Codigo, '|') AND
    LocalBufferMatg.subfam = ENTRY(3, FacTabla.Codigo, '|') AND
    LocalBufferMatg.tpoart <> "D":
    DO x-Orden = 11 TO 20:
        x-PorDto = FacTabla.Valor[x-Orden].
        IF x-PorDto > 0 THEN DO:
            RUN PRI_Margen-Utilidad-Listas IN hProc (INPUT ENTRY(1, FacTabla.Codigo, '|'),
                                                     INPUT LocalBufferMatg.CodMat,
                                                     INPUT LocalBufferMatg.CHR__01,
                                                     INPUT x-PorDto,
                                                     INPUT 1,
                                                     OUTPUT x-Margen,
                                                     OUTPUT x-Limite,
                                                     OUTPUT pError).
            IF RETURN-VALUE = 'ADM-ERROR' OR pError > '' THEN RETURN 'ADM-ERROR'.
        END.
    END.
END.
DELETE PROCEDURE hProc.
RETURN 'OK'.

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

