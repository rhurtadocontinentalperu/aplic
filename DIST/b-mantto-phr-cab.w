&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO.
DEFINE TEMP-TABLE tt-DI-RutaC NO-UNDO LIKE DI-RutaC
       FIELD Libre_d07 AS INT /* Ptos Entrega */.



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
{src/bin/_prns.i}

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-desalm AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.
DEF SHARED VAR lh_handle AS HANDLE.

/* Local Variable Definitions ---                                       */
DEF VAR x-Estado AS CHAR NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Importe AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-SKU AS INT NO-UNDO.
DEF VAR x-Clientes AS INT NO-UNDO.

DEFINE TEMP-TABLE tt-puntos-entrega
    FIELD   tsede AS CHAR
    INDEX idx01 tsede.

&SCOPED-DEFINE Condicion ( ~
                           DI-RutaC.CodCia = s-codcia AND ~
                           DI-RutaC.CodDiv = s-coddiv AND ~
                           DI-RutaC.CodDoc = s-coddoc AND ~
                           (DI-RutaC.FchDoc >= FILL-IN-Desde AND DI-RutaC.FchDoc <= FILL-IN-Hasta) AND ~
                           (RADIO-SET-FlgEst = 'Todos' OR DI-RutaC.FlgEst = RADIO-SET-FlgEst) ~
                           )

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

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
&Scoped-define INTERNAL-TABLES DI-RutaC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaC.FchDoc DI-RutaC.NroDoc ~
fEstado() @ x-Estado fPeso() @ x-Peso fImporte() @ x-Importe ~
fVolumen() @ x-Volumen fClientes() @ x-Clientes fBultos() @ x-Bultos ~
fSKU() @ x-SKU DI-RutaC.Observ DI-RutaC.Libre_d01 DI-RutaC.Libre_d02 ~
DI-RutaC.Libre_d03 DI-RutaC.Libre_c05 DI-RutaC.Libre_f05 DI-RutaC.Libre_c04 ~
DI-RutaC.CodCob 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DI-RutaC.Observ ~
DI-RutaC.Libre_d01 DI-RutaC.Libre_d02 DI-RutaC.Libre_d03 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DI-RutaC
&Scoped-define QUERY-STRING-br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DI-RutaC


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 FILL-IN-Desde RADIO-SET-FlgEst ~
BUTTON-Aplicar FILL-IN-Hasta br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Desde RADIO-SET-FlgEst ~
FILL-IN-Hasta 

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
NroDoc|y||INTEGRAL.DI-RutaC.NroDoc|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NroDoc' + '",
     SortBy-Case = ':U + 'NroDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fClientes B-table-Win 
FUNCTION fClientes RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado2 B-table-Win 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Aplicar 
     LABEL "Aplicar Filtros" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgEst AS CHARACTER INITIAL "P" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Cerradas", "C",
"Anuladas", "A",
"Todos", "Todos"
     SIZE 12 BY 2.42 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaC.FchDoc FORMAT "99/99/9999":U
      DI-RutaC.NroDoc FORMAT "X(9)":U WIDTH 9.72
      fEstado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 13.86
      fPeso() @ x-Peso COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      fImporte() @ x-Importe COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      fVolumen() @ x-Volumen COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
      fClientes() @ x-Clientes COLUMN-LABEL "Clientes" FORMAT ">>,>>9":U
      fBultos() @ x-Bultos COLUMN-LABEL "Bultos" FORMAT ">>,>>9":U
      fSKU() @ x-SKU COLUMN-LABEL "SKU" FORMAT ">>,>>9":U
      DI-RutaC.Observ COLUMN-LABEL "Glosa" FORMAT "x(40)":U
      DI-RutaC.Libre_d01 COLUMN-LABEL "Clientes Máximo" FORMAT ">>>,>>9":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      DI-RutaC.Libre_d02 COLUMN-LABEL "Peso Máximo" FORMAT ">>>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      DI-RutaC.Libre_d03 COLUMN-LABEL "Volumen Máximo" FORMAT ">>>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      DI-RutaC.Libre_c05 COLUMN-LABEL "Usuario Modifición" FORMAT "x(10)":U
      DI-RutaC.Libre_f05 COLUMN-LABEL "Fecha Modificación" FORMAT "99/99/9999":U
      DI-RutaC.Libre_c04 COLUMN-LABEL "Glosa de Anulación" FORMAT "x(30)":U
            COLUMN-FGCOLOR 15 COLUMN-BGCOLOR 2
      DI-RutaC.CodCob COLUMN-LABEL "N° Hoja de Ruta" FORMAT "X(12)":U
  ENABLE
      DI-RutaC.Observ
      DI-RutaC.Libre_d01
      DI-RutaC.Libre_d02
      DI-RutaC.Libre_d03
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Desde AT ROW 1.27 COL 94 COLON-ALIGNED WIDGET-ID 2
     RADIO-SET-FlgEst AT ROW 1.27 COL 111 NO-LABEL WIDGET-ID 6
     BUTTON-Aplicar AT ROW 1.27 COL 125 WIDGET-ID 12
     FILL-IN-Hasta AT ROW 2.08 COL 94 COLON-ALIGNED WIDGET-ID 4
     br_table AT ROW 3.96 COL 1
     RECT-2 AT ROW 1 COL 89 WIDGET-ID 14
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
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
      END-FIELDS.
      TABLE: tt-DI-RutaC T "?" NO-UNDO INTEGRAL DI-RutaC
      ADDITIONAL-FIELDS:
          FIELD Libre_d07 AS INT /* Ptos Entrega */
      END-FIELDS.
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
         HEIGHT             = 12.58
         WIDTH              = 146.57.
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
/* BROWSE-TAB br_table FILL-IN-Hasta F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.DI-RutaC.FchDoc
     _FldNameList[2]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fEstado() @ x-Estado" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fPeso() @ x-Peso" "Peso" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fImporte() @ x-Importe" "Importe" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fVolumen() @ x-Volumen" "Volumen" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fClientes() @ x-Clientes" "Clientes" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fBultos() @ x-Bultos" "Bultos" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fSKU() @ x-SKU" "SKU" ">>,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Glosa" "x(40)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.DI-RutaC.Libre_d01
"DI-RutaC.Libre_d01" "Clientes Máximo" ">>>,>>9" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.DI-RutaC.Libre_d02
"DI-RutaC.Libre_d02" "Peso Máximo" ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.DI-RutaC.Libre_d03
"DI-RutaC.Libre_d03" "Volumen Máximo" ">>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.DI-RutaC.Libre_c05
"DI-RutaC.Libre_c05" "Usuario Modifición" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.DI-RutaC.Libre_f05
"DI-RutaC.Libre_f05" "Fecha Modificación" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.DI-RutaC.Libre_c04
"DI-RutaC.Libre_c04" "Glosa de Anulación" "x(30)" "character" 2 15 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.DI-RutaC.CodCob
"DI-RutaC.CodCob" "N° Hoja de Ruta" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-Aplicar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aplicar B-table-Win
ON CHOOSE OF BUTTON-Aplicar IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN FILL-IN-Desde FILL-IN-Hasta RADIO-SET-FlgEst.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON FIND OF di-rutaC DO:
    FIND FIRST tt-di-rutaC OF di-rutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-di-rutaC THEN DO:
        CREATE tt-di-rutaC.   /* USING ROWID(ROWID(di-rutaC)) NO-ERROR.*/
        BUFFER-COPY di-rutaC TO tt-di-rutaC.

        EMPTY TEMP-TABLE tt-puntos-entrega.

        ASSIGN 
            /*
            tt-di-rutaC.libre_d04 = 0
            tt-di-rutaC.libre_d01 = 0       /* PEso */
            tt-di-rutaC.libre_d02 = 0       /* Importe */
            tt-di-rutaC.libre_d03 = 0       /* Clientes */
            tt-di-rutaC.libre_d05 = 0
            tt-di-rutaC.libre_d06 = 0       /* Volumen */
            */
            tt-di-rutaC.libre_d07 = 0       /* Puntos de entrega */
            .

        FOR EACH Di-RutaD OF Di-RutaC NO-LOCK ,
            FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
                AND FacCPedi.CodDoc = Di-RutaD.codref           
                AND FacCPedi.NroPed = Di-RutaD.nroref
            BREAK BY Faccpedi.CodCli:
            /*
            IF FIRST-OF(Faccpedi.CodCli) THEN tt-di-rutaC.libre_d03 = tt-di-rutaC.libre_d03 + 1.
            ASSIGN
                tt-Di-Rutac.Libre_d02 = tt-Di-Rutac.Libre_d02 + Faccpedi.AcuBon[8]
                tt-Di-Rutac.Libre_d01 = tt-Di-Rutac.Libre_d01 + Faccpedi.Peso
                tt-Di-Rutac.Libre_d06 = tt-Di-Rutac.Libre_d06 + Faccpedi.Volumen.
            IF Faccpedi.coddoc = 'OTR' THEN DO:
                 tt-Di-Rutac.Libre_d02 = tt-Di-Rutac.Libre_d02 - Faccpedi.AcuBon[8].
                 FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                      tt-Di-Rutac.Libre_d02 =  tt-Di-Rutac.Libre_d02 + 
                          (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * 
                                          (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).
                 END.
            END.
            */
            /* Ic - 04Set2020 Puntos de entrega a pedido de Fernan segun meet avalado po Daniel Llican y Maz Ramos */
            FIND FIRST tt-puntos-entrega WHERE tt-puntos-entrega.tsede = faccpedi.sede EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-puntos-entrega THEN DO:
                CREATE tt-puntos-entrega.
                    ASSIGN tt-puntos-entrega.tsede = faccpedi.sede.
                    ASSIGN tt-di-rutaC.libre_d07 = tt-di-rutaC.libre_d07 + 1.
            END.
        END.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'NroDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY DI-RutaC.NroDoc DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT DI-RUTAC EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          DI-RutaC.flgest = 'A'
          DI-RutaC.Libre_f05 = TODAY
          DI-RutaC.Libre_c05 = s-user-id.
      FIND CURRENT DI-RUTAC NO-LOCK NO-ERROR.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE BUTTON-Aplicar FILL-IN-Desde FILL-IN-Hasta RADIO-SET-FlgEst.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE BUTTON-Aplicar FILL-IN-Desde FILL-IN-Hasta RADIO-SET-FlgEst.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF BUFFER B-CPEDI FOR Faccpedi.

/* Prefijo para el codigo de Barras  */
DEFINE VAR x-prefijo-docto AS CHAR NO-UNDO.
DEFINE VAR x-codigo-barra-docto AS CHAR NO-UNDO.
DEFINE VAR x-nrodoc AS CHAR NO-UNDO.

RUN gn/prefijo-codigo-barras-doc(INPUT di-rutaC.coddoc, OUTPUT x-prefijo-docto).
IF x-prefijo-docto = 'ERROR' THEN DO:
    MESSAGE "ERROR al ubicar el prefijo del codigo de barra para (" di-rutaC.coddoc + ")".
    RETURN.
END.
x-nrodoc = DI-Rutac.Nrodoc.
x-codigo-barra-docto = "*" + x-prefijo-docto + x-nrodoc + "*".

/* Capturamos el Excel */
SESSION:SET-WAIT-STATE('GENERAL').
RUN Captura-Temporal IN lh_handle (INPUT-OUTPUT TABLE T-RUTAD).

DEF VAR s-task-no AS INT NO-UNDO.

s-task-no = 0.
REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) 
        THEN LEAVE.
END.
CREATE w-report.
ASSIGN w-report.task-no = s-task-no.
FOR EACH T-RUTAD OF DI-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no
        w-report.Campo-C[1] = T-RutaD.CodRef 
        w-report.Campo-C[2] = T-RutaD.NroRef
        w-report.Campo-C[3] = faccpedi.codcli
        w-report.Campo-C[4] = faccpedi.nomcli
        w-report.Campo-C[5] = faccpedi.dircli
        w-report.Campo-C[6] = T-RUTAD.Estado
        w-report.Campo-F[1] = T-RUTAD.ImpCob
        w-report.Campo-F[2] = T-RUTAD.Libre_d01
        w-report.Campo-F[3] = T-RUTAD.Libre_d02
        w-report.Campo-F[4] = DECIMAL(T-RUTAD.Libre_c01)
        .
    ASSIGN
        w-report.Campo-C[10] = Faccpedi.Glosa.

    /* Buscamos si viene de un Cross Docking */
    /*
    IF Faccpedi.coddoc = 'OTR' AND Faccpedi.codref = 'R/A' AND Faccpedi.CrossDocking = NO
        THEN DO:
        FIND Almcrepo WHERE almcrepo.CodCia = Faccpedi.codcia
            AND almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
            AND almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcrepo THEN DO:
            FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = Almcrepo.codcia
                AND B-CPEDI.coddoc = "OTR"
                AND B-CPEDI.codref = "R/A"
                AND B-CPEDI.nroref = STRING(Almcrepo.nroser,"999") + STRING(Almcrepo.nrodoc, "999999")
                AND B-CPEDI.crossdocking = YES
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CPEDI THEN 
                ASSIGN
                w-report.Campo-C[7] = B-CPEDI.coddoc
                w-report.Campo-C[8] = B-CPEDI.nroped.
        END.
    END.
    */
    IF faccpedi.crossdocking = YES OR faccpedi.tpoped = 'XD' THEN DO:
        ASSIGN w-report.Campo-C[7] = faccpedi.codref
        w-report.Campo-C[8] = faccpedi.nroref.
    END.
END.
RELEASE w-report.
SESSION:SET-WAIT-STATE('').

GET-KEY-VALUE SECTION 'Startup'
    KEY 'BASE'
    VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
RB-REPORT-NAME = 'PreHoja Ruta5a'.
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "DI-Rutac.Codcia = " + STRING(DI-Rutac.codcia) +  
    " AND Di-Rutac.Coddiv = '" + DI-Rutac.coddiv + "'" +
    " AND DI-Rutac.Coddoc = '" + DI-Rutac.coddoc + "'" + 
    " AND Di-Rutac.Nrodoc = '" + DI-Rutac.nrodoc + "'" +
    " AND w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + "~ns-task-no = " + STRING(s-task-no) +
                        "~ns-codbarra = " + x-codigo-barra-docto.
RUN lib/_Imprime2.p (
    RB-REPORT-LIBRARY,
    RB-REPORT-NAME,
    RB-INCLUDE-RECORDS,
    RB-FILTER,
    RB-OTHER-PARAMETERS
    ).


FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.
END PROCEDURE.

/*
IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF BUFFER B-CPEDI FOR Faccpedi.

/* Prefijo para el codigo de Barras  */
DEFINE VAR x-prefijo-docto AS CHAR NO-UNDO.
DEFINE VAR x-codigo-barra-docto AS CHAR NO-UNDO.
DEFINE VAR x-nrodoc AS CHAR NO-UNDO.

RUN gn/prefijo-codigo-barras-doc(INPUT di-rutaC.coddoc, OUTPUT x-prefijo-docto).
IF x-prefijo-docto = 'ERROR' THEN DO:
    MESSAGE "ERROR al ubicar el prefijo del codigo de barra para (" di-rutaC.coddoc + ")".
    RETURN.
END.
x-nrodoc = DI-Rutac.Nrodoc.
x-codigo-barra-docto = "*" + x-prefijo-docto + x-nrodoc + "*".

/* Prueba */
RUN Captura-Temporal IN lh_handle (INPUT-OUTPUT TABLE T-RUTAD).
FOR EACH t-rutad:
    MESSAGE t-rutad.codref t-rutad.nroref.
END.

DEF VAR s-task-no AS INT NO-UNDO.

s-task-no = 0.
REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) 
        THEN LEAVE.
END.
CREATE w-report.
ASSIGN w-report.task-no = s-task-no.
FOR EACH di-rutad OF di-rutac NO-LOCK,
    FIRST faccpedi NO-LOCK WHERE faccpedi.codcia = di-rutad.codcia
    AND faccpedi.coddoc = di-rutad.codref
    AND faccpedi.nroped = di-rutad.nroref:
    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-task-no
        w-report.Campo-C[1] = faccpedi.coddoc
        w-report.Campo-C[2] = faccpedi.nroped
        w-report.Campo-C[3] = faccpedi.codcli
        w-report.Campo-C[4] = faccpedi.nomcli
        w-report.Campo-C[5] = faccpedi.dircli
        w-report.Campo-C[6] = fEstado2()
        .
    /* Buscamos si viene de un Cross Docking */
    IF Faccpedi.coddoc = 'OTR' AND Faccpedi.codref = 'R/A' AND Faccpedi.CrossDocking = NO
        THEN DO:
        FIND Almcrepo WHERE almcrepo.CodCia = Faccpedi.codcia
            AND almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
            AND almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcrepo THEN DO:
            FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = Almcrepo.codcia
                AND B-CPEDI.coddoc = "OTR"
                AND B-CPEDI.codref = "R/A"
                AND B-CPEDI.nroref = STRING(Almcrepo.nroser,"999") + STRING(Almcrepo.nrodoc, "999999")
                AND B-CPEDI.crossdocking = YES
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CPEDI THEN 
                ASSIGN
                w-report.Campo-C[7] = B-CPEDI.coddoc
                w-report.Campo-C[8] = B-CPEDI.nroped.
        END.
    END.
END.
RELEASE w-report.

GET-KEY-VALUE SECTION 'Startup'
    KEY 'BASE'
    VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
RB-REPORT-NAME = 'PreHoja Ruta5'.
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "DI-Rutac.Codcia = " + STRING(DI-Rutac.codcia) +  
    " AND Di-Rutac.Coddiv = '" + DI-Rutac.coddiv + "'" +
    " AND DI-Rutac.Coddoc = '" + DI-Rutac.coddoc + "'" + 
    " AND Di-Rutac.Nrodoc = '" + DI-Rutac.nrodoc + "'" +
    " AND w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + "~ns-task-no = " + STRING(s-task-no) +
                        "~ns-codbarra = " + x-codigo-barra-docto.
RUN lib/_Imprime2.p (
    RB-REPORT-LIBRARY,
    RB-REPORT-NAME,
    RB-INCLUDE-RECORDS,
    RB-FILTER,
    RB-OTHER-PARAMETERS
    ).

FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Desde = ADD-INTERVAL(TODAY , -30, 'days').
      FILL-IN-Hasta = TODAY.

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
  {src/adm/template/snd-list.i "DI-RutaC"}

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

IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L') > 0 THEN DO:
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Bultos AS INT NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref:
      RUN logis/p-numero-de-bultos (s-CodDiv, Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Bultos).
/*       FIND FIRST CcbCBult WHERE CcbCBult.CodCia = Faccpedi.codcia                */
/*           AND CcbCBult.CodDoc = Faccpedi.CodDoc                                  */
/*           AND CcbCBult.NroDoc = Faccpedi.NroPed                                  */
/*           AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */ */
/*           NO-LOCK NO-ERROR.                                                      */
/*       IF AVAILABLE CcbCBult THEN x-Bultos = x-Bultos + CcbCBult.Bultos.          */
  END.
  RETURN x-Bultos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fClientes B-table-Win 
FUNCTION fClientes RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Clientes AS INT NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref
      BREAK BY Faccpedi.CodCli:
      IF FIRST-OF(Faccpedi.CodCli) THEN x-Clientes = x-Clientes + 1.
  END.
  RETURN x-Clientes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Estado AS CHAR NO-UNDO.
  CASE DI-RutaC.FlgEst:
      WHEN 'P' THEN x-Estado = 'Pendiente'.
      WHEN 'C' THEN x-Estado = 'Cerrada'.
      WHEN 'A' THEN x-Estado = 'Anulada'.
      WHEN 'PK' THEN x-Estado = 'Con HPK'.
      WHEN 'PX' THEN x-Estado = 'Generada'.
      OTHERWISE x-Estado = 'NO DEFINIDO: ' + DI-RutaC.FlgEst.
  END CASE.
  RETURN x-Estado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado2 B-table-Win 
FUNCTION fEstado2 RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgSit = "C" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
      END.
  END CASE.
  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Importe AS DEC NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref:
      IF Faccpedi.CodDoc = "OTR" THEN DO:
          FOR EACH Facdpedi OF Faccpedi NO-LOCK:
              FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                  AND AlmStkGe.codmat = Facdpedi.codmat 
                  AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
              IF AVAILABLE AlmStkGe THEN
                  x-Importe = x-Importe + (AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor).
          END.
      END.
      ELSE DO:
          x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
      END.
  END.
  RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Pesos AS DEC NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref,
      EACH Facdpedi OF Faccpedi NO-LOCK,
      FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
  END.
  RETURN x-Pesos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-SKU AS INT NO-UNDO.
  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref,
      EACH Facdpedi OF Faccpedi NO-LOCK:
      x-SKU = x-SKU + 1.
  END.
  RETURN x-SKU.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Volumen AS DEC NO-UNDO.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref,
      EACH Facdpedi OF Faccpedi NO-LOCK,
      FIRST Almmmatg OF Facdpedi NO-LOCK:
      IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
  END.
  RETURN x-Volumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

