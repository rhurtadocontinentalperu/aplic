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
       FIELD Libre_d06 AS DEC.



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

&SCOPED-DEFINE Condicion ( ~
                           DI-RutaC.CodCia = s-codcia AND ~
                           DI-RutaC.CodDiv = s-coddiv AND ~
                           DI-RutaC.CodDoc = s-coddoc AND ~
                           (DI-RutaC.FchDoc >= FILL-IN-Desde AND DI-RutaC.FchDoc <= FILL-IN-Hasta) AND ~
                           (LOOKUP(DI-RutaC.FlgEst, RADIO-SET-FlgEst, '|') > 0) ~
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

DEFINE BUFFER x-di-rutaD FOR di-rutaD.
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-controlOD FOR controlOD.

DEFINE TEMP-TABLE tdi-rutaC LIKE di-rutaC.

DEFINE TEMP-TABLE tt-clientes
    FIELD   tcodcli AS CHAR.

DEFINE TEMP-TABLE tt-datos-extras
    FIELD   tcodcli AS CHAR.

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
&Scoped-define INTERNAL-TABLES DI-RutaC tt-DI-RutaC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaC.FchDoc DI-RutaC.NroDoc ~
fEstado() @ x-Estado tt-DI-RutaC.Libre_d01 ~
tt-DI-RutaC.Libre_d06 @ x-Volumen tt-DI-RutaC.Libre_d02 ~
tt-DI-RutaC.Libre_d04 tt-DI-RutaC.Libre_d03 tt-DI-RutaC.Libre_d05 ~
DI-RutaC.Observ DI-RutaC.Libre_c05 DI-RutaC.Libre_f05 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DI-RutaC.Observ 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DI-RutaC
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DI-RutaC
&Scoped-define QUERY-STRING-br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST tt-DI-RutaC OF DI-RutaC OUTER-JOIN NO-LOCK ~
    BY DI-RutaC.Observ INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST tt-DI-RutaC OF DI-RutaC OUTER-JOIN NO-LOCK ~
    BY DI-RutaC.Observ INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table DI-RutaC tt-DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DI-RutaC
&Scoped-define SECOND-TABLE-IN-QUERY-br_table tt-DI-RutaC


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-cuales FILL-IN-contenido ~
FILL-IN-od br_table BUTTON-Aplicar FILL-IN-Desde FILL-IN-Hasta ~
RADIO-SET-FlgEst 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-cuales FILL-IN-contenido ~
FILL-IN-od FILL-IN-Desde FILL-IN-Hasta RADIO-SET-FlgEst FILL-IN-Peso ~
FILL-IN-Volumen FILL-IN-Importe FILL-IN-Bultos 

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

DEFINE VARIABLE COMBO-BOX-cuales AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos",1,
                     "Que inicien",2,
                     "Que contenga",3
     DROP-DOWN-LIST
     SIZE 14.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-contenido AS CHARACTER FORMAT "X(50)":U 
     LABEL "Nombre cliente" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-od AS CHARACTER FORMAT "X(12)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgEst AS CHARACTER INITIAL "PX|PK|PF" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pend. Almacén", "PX|PK|PF",
"Por Generar H/R", "P",
"Por Fedatear", "PF",
"Con HPK", "PK",
"Cerradas", "C",
"Anuladas", "A"
     SIZE 17 BY 4.85 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DI-RutaC, 
      tt-DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaC.FchDoc FORMAT "99/99/9999":U
      DI-RutaC.NroDoc FORMAT "X(9)":U WIDTH 9.72
      fEstado() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(20)":U
            WIDTH 12.86
      tt-DI-RutaC.Libre_d01 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      tt-DI-RutaC.Libre_d06 @ x-Volumen COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      tt-DI-RutaC.Libre_d02 COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      tt-DI-RutaC.Libre_d04 COLUMN-LABEL "Bultos" FORMAT ">>>,>>9.99":U
            WIDTH 8.43
      tt-DI-RutaC.Libre_d03 COLUMN-LABEL "Clientes" FORMAT "->,>>>,>>9":U
            WIDTH 8.43
      tt-DI-RutaC.Libre_d05 COLUMN-LABEL "SKUs" FORMAT "->>,>>9":U
      DI-RutaC.Observ COLUMN-LABEL "Glosa" FORMAT "x(40)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      DI-RutaC.Libre_c05 COLUMN-LABEL "Usuario Modificación" FORMAT "x(10)":U
      DI-RutaC.Libre_f05 COLUMN-LABEL "Fecha Modificación" FORMAT "99/99/9999":U
            WIDTH 1.57
  ENABLE
      DI-RutaC.Observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 122 BY 7.81
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-cuales AT ROW 1 COL 1 NO-LABEL WIDGET-ID 18
     FILL-IN-contenido AT ROW 1 COL 25.86 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-od AT ROW 1 COL 67.86 COLON-ALIGNED WIDGET-ID 14
     br_table AT ROW 2.08 COL 1
     BUTTON-Aplicar AT ROW 2.19 COL 126 WIDGET-ID 12
     FILL-IN-Desde AT ROW 3.38 COL 127 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Hasta AT ROW 4.23 COL 127 COLON-ALIGNED WIDGET-ID 4
     RADIO-SET-FlgEst AT ROW 5.23 COL 124 NO-LABEL WIDGET-ID 6
     FILL-IN-Peso AT ROW 9.88 COL 43.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-Volumen AT ROW 9.88 COL 52.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Importe AT ROW 9.88 COL 61.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-Bultos AT ROW 9.88 COL 70.43 RIGHT-ALIGNED NO-LABEL WIDGET-ID 28
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
          FIELD Libre_d06 AS DEC
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
         HEIGHT             = 11.73
         WIDTH              = 148.86.
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
/* BROWSE-TAB br_table FILL-IN-od F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-cuales IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Bultos IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.DI-RutaC,Temp-Tables.tt-DI-RutaC OF INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _OrdList          = "INTEGRAL.DI-RutaC.Observ|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.DI-RutaC.FchDoc
     _FldNameList[2]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fEstado() @ x-Estado" "Estado" "x(20)" ? ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-DI-RutaC.Libre_d01
"tt-DI-RutaC.Libre_d01" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"tt-DI-RutaC.Libre_d06 @ x-Volumen" "Volumen" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-DI-RutaC.Libre_d02
"tt-DI-RutaC.Libre_d02" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-DI-RutaC.Libre_d04
"tt-DI-RutaC.Libre_d04" "Bultos" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-DI-RutaC.Libre_d03
"tt-DI-RutaC.Libre_d03" "Clientes" "->,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-DI-RutaC.Libre_d05
"tt-DI-RutaC.Libre_d05" "SKUs" "->>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Glosa" "x(40)" "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.DI-RutaC.Libre_c05
"DI-RutaC.Libre_c05" "Usuario Modificación" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.DI-RutaC.Libre_f05
"DI-RutaC.Libre_f05" "Fecha Modificación" ? "date" ? ? ? ? ? ? no ? no no "1.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

  DEF VAR k AS INT.

  FILL-IN-Peso = 0.
  FILL-IN-Bultos = 0.
  FILL-IN-Importe = 0.
  FILL-IN-Volumen = 0.
  DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
      IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN 
          ASSIGN
          FILL-IN-Peso = FILL-IN-Peso + tt-DI-RutaC.Libre_d01
          FILL-IN-Volumen = FILL-IN-Volumen + tt-DI-RutaC.Libre_d06
          FILL-IN-Importe = FILL-IN-Importe + tt-DI-RutaC.Libre_d02
          FILL-IN-Bultos = FILL-IN-Bultos + tt-DI-RutaC.Libre_d04.
  END.
  DISPLAY FILL-IN-Peso FILL-IN-Volumen FILL-IN-Importe FILL-IN-Bultos
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aplicar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aplicar B-table-Win
ON CHOOSE OF BUTTON-Aplicar IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN FILL-IN-Desde FILL-IN-Hasta RADIO-SET-FlgEst combo-box-cuales fill-in-contenido fill-in-od.

  EMPTY TEMP-TABLE tt-clientes.
  EMPTY TEMP-TABLE tt-di-rutaC.

  DEFINE VAR x-contenido AS CHAR.
    
  x-contenido = fill-in-contenido.
  
  SESSION:SET-WAIT-STATE('GENERAL').

  IF NOT (TRUE <> (x-contenido > "")) THEN DO:
      IF combo-box-cuales <> 1 THEN DO:
          IF combo-box-cuales = 2 THEN DO:
              FOR EACH gn-clie WHERE gn-clie.nomcli BEGINS x-contenido NO-LOCK:
                  CREATE tt-clientes.
                  ASSIGN tt-clientes.tcodcli = gn-clie.codcli.
              END.
          END.
          ELSE DO:
               x-contenido = "*" +  x-contenido + "*".
              FOR EACH gn-clie WHERE gn-clie.nomcli MATCHES x-contenido NO-LOCK:
                  CREATE tt-clientes.
                  ASSIGN tt-clientes.tcodcli = gn-clie.codcli.
              END.
          END.
      END.
  END.

  
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

    DEFINE VAR x-nro-phr AS CHAR.
    DEFINE VAR x-nro-od AS CHAR.
    DEFINE VAR x-existe AS LOG INIT YES.    
    DEFINE VAR x-cuales AS INT.
    DEFINE VAR x-contenido AS CHAR.

    x-nro-od = fill-in-od:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    x-contenido = fill-in-contenido:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF NOT (TRUE <> (x-nro-od > "")) THEN DO:
        x-nro-phr = di-rutaC.nrodoc.

        x-existe = NO.

        BUSCAR_OD:
        FOR EACH x-di-rutaD WHERE x-di-rutaD.codcia = s-codcia AND
                                    x-di-rutaD.coddoc = "PHR" AND
                                    x-di-rutaD.codref = 'O/D' AND
                                    x-di-rutaD.nroref = x-nro-od NO-LOCK :

            IF x-di-rutaD.nrodoc = x-nro-phr THEN DO:
                x-existe = YES.
                LEAVE BUSCAR_OD.
            END.
        END.
        IF x-existe = NO THEN RETURN ERROR.
    END.

    /* Cliente */
    x-cuales = combo-box-cuales.
    x-existe = YES.    

    IF NOT (TRUE <> (x-contenido > "")) THEN DO:
    
        IF x-cuales > 1 THEN DO:
            x-existe = NO.
            
            BUSCAR_CLIENTE:
            FOR EACH x-di-rutaD WHERE x-di-rutaD.codcia = s-codcia AND
                                        x-di-rutaD.coddiv = di-rutaC.coddiv AND
                                        x-di-rutaD.coddoc = di-rutaC.coddoc AND
                                        x-di-rutaD.nrodoc = di-rutaC.nrodoc NO-LOCK:
                FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                                x-faccpedi.coddoc = x-di-rutaD.codref AND
                                                x-faccpedi.nroped = x-di-rutaD.nroref NO-LOCK NO-ERROR.
                
                IF AVAILABLE x-faccpedi THEN DO:
                    
                    FIND FIRST tt-Clientes WHERE tt-Clientes.tcodcli = x-faccpedi.codcli NO-ERROR.
                    IF AVAILABLE tt-clientes THEN DO:
                        x-existe = YES.
                        LEAVE BUSCAR_CLIENTE.
                    END.
                END.                
            END.
        END.
        
        IF x-existe = NO THEN RETURN ERROR.
    END.

    /**/    
    FIND FIRST tt-di-rutaC OF di-rutaC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-di-rutaC THEN DO:
        CREATE tt-di-rutaC.   /* USING ROWID(ROWID(di-rutaC)) NO-ERROR.*/
        BUFFER-COPY di-rutaC TO tt-di-rutaC.
        /* Bultos */
        ASSIGN 
            tt-di-rutaC.libre_d04 = 0
            tt-di-rutaC.libre_d01 = 0
            tt-di-rutaC.libre_d02 = 0
            tt-di-rutaC.libre_d03 = 0
            tt-di-rutaC.libre_d05 = 0
            tt-di-rutaC.libre_d06 = 0
            .
        FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
            FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
                AND FacCPedi.CodDoc = Di-RutaD.codref
                AND FacCPedi.NroPed = Di-RutaD.nroref
            BREAK BY Faccpedi.CodCli:
            IF FIRST-OF(Faccpedi.CodCli) THEN tt-di-rutaC.libre_d03 = tt-di-rutaC.libre_d03 + 1.
            RUN logis/p-numero-de-bultos (s-CodDiv, Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Bultos).
            ASSIGN 
                tt-di-rutaC.libre_d04 = tt-di-rutaC.libre_d04 + x-Bultos.
            IF Faccpedi.CodDoc <> "OTR" THEN 
                ASSIGN
                tt-di-rutaC.libre_d02 = tt-di-rutaC.libre_d02 + (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
            FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
                ASSIGN
                    tt-di-rutaC.libre_d05 = tt-di-rutaC.libre_d05 + 1
                    tt-di-rutaC.libre_d01 = tt-di-rutaC.libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat)
                    .
                IF almmmatg.libre_d02 <> ? THEN tt-di-rutaC.libre_d06 = tt-di-rutaC.libre_d06 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
                IF Faccpedi.CodDoc = "OTR" THEN DO:
                    FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                        AND AlmStkGe.codmat = Facdpedi.codmat 
                        AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
                    IF AVAILABLE AlmStkGe THEN
                        tt-di-rutaC.libre_d02 = tt-di-rutaC.libre_d02 + (AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor).
                END.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Adicionar-Reprogramada B-table-Win 
PROCEDURE Adicionar-Reprogramada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE DI-RutaC THEN RETURN.
DEF VAR pMensaje AS CHAR NO-UNDO.
RUN logis/d-mantto-phr-od (INPUT DI-RutaC.CodDoc,
                           INPUT DI-RutaC.NroDoc,
                           OUTPUT pMensaje).
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
END.
ELSE RUN Procesa-Handle IN lh_handle ('Pinta-Detalle').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    IF hColumn:LABEL = 'Glosa' THEN hColumn:READ-ONLY = TRUE.
END.

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
  /* Tiene o no tiene items? */
  IF CAN-FIND(FIRST Di-RutaD OF Di-RutaC NO-LOCK) THEN DO:
      IF LOOKUP(DI-RutaC.FlgEst, 'P,PX') = 0 THEN DO:
          MESSAGE "La PHR imposible de ANULAR (" + DI-RutaC.FlgEst + ")" SKIP
              'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-Bultos = 0
          FILL-IN-Importe = 0
          FILL-IN-Peso = 0
          FILL-IN-Volumen = 0.
      DISPLAY FILL-IN-Bultos 
          FILL-IN-Importe 
          FILL-IN-Peso 
          FILL-IN-Volumen.
  END.

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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "tt-DI-RutaC"}

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
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 1 THEN DO:
    MESSAGE 'Debe seleccionar un solo registro' VIEW-AS ALERT-BOX ERROR.
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
  DEF VAR pBultos AS INT NO-UNDO.
  DEFINE VAR x-etq AS CHAR.

  FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
      FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = Di-RutaD.codcia
      AND FacCPedi.CodDoc = Di-RutaD.codref
      AND FacCPedi.NroPed = Di-RutaD.nroref:
      RUN logis/p-numero-de-bultos (s-CodDiv, Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Bultos).
      pBultos = pBultos + x-Bultos.
/*       FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Faccpedi.codcia */
/*           AND CcbCBult.CodDiv = s-CodDiv                                */
/*           AND CcbCBult.CodDoc = Faccpedi.CodDoc                         */
/*           AND CcbCBult.NroDoc = Faccpedi.NroPed:                        */
/*           x-Bultos = x-Bultos + CcbCBult.Bultos.                        */
/*       END.                                                              */
  END.
  
  RETURN pBultos.

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
      WHEN 'PF' THEN x-Estado = 'Por Fedatear'.
      WHEN 'PX' THEN x-Estado = 'Generadas'.
      WHEN 'PK' THEN x-Estado = 'Con HPK'.
      WHEN 'PC' THEN x-Estado = 'Pickeo OK'.
      WHEN 'P' THEN x-Estado = 'Chequeo OK'.
      WHEN 'C' THEN x-Estado = 'Con H/R'.
      WHEN 'A' THEN x-Estado = 'Anulada'.
      OTHERWISE x-Estado = DI-RutaC.FlgEst.
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

