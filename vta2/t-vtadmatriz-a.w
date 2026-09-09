&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE T-DMatriz NO-UNDO LIKE VtaDMatriz.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-CodCli AS CHAR.
DEF SHARED VAR s-CodMon AS INT.
DEF SHARED VAR s-TpoCmb AS DEC.
DEF SHARED VAR s-FlgSit AS CHAR.
DEF SHARED VAR s-NroDec AS INT.
DEF SHARED VAR s-CodAlm AS CHAR.
DEF SHARED VAR s-PorIgv AS DEC.

/* PRODUCTOS POR ROTACION */
DEFINE SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-NROPED  AS CHAR.

DEFINE BUFFER B-DMatriz FOR T-DMatriz.

DEFINE VARIABLE x-Cantidad AS DEC NO-UNDO.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

DEF VAR c-FgColor AS INT EXTENT 5.
DEF VAR c-BgColor AS INT EXTENT 5.
ASSIGN
    c-FgColor[1] = 9
    c-FgColor[2] = 0
    c-FgColor[3] = 15
    c-FgColor[4] = 15
    c-FgColor[5] = 15.
ASSIGN
    c-BgColor[1] = 10
    c-BgColor[2] = 14
    c-BgColor[3] = 1
    c-BgColor[4] = 5
    c-BgColor[5] = 13.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCMatriz
&Scoped-define FIRST-EXTERNAL-TABLE VtaCMatriz


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCMatriz.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DMatriz

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DMatriz.LabelFila ~
T-DMatriz.Cantidad[1] T-DMatriz.UndVta[1] T-DMatriz.Cantidad[2] ~
T-DMatriz.UndVta[2] T-DMatriz.Cantidad[3] T-DMatriz.UndVta[3] ~
T-DMatriz.Cantidad[4] T-DMatriz.UndVta[4] T-DMatriz.Cantidad[5] ~
T-DMatriz.UndVta[5] T-DMatriz.Cantidad[6] T-DMatriz.UndVta[6] ~
T-DMatriz.Cantidad[7] T-DMatriz.UndVta[7] T-DMatriz.Cantidad[8] ~
T-DMatriz.UndVta[8] T-DMatriz.Cantidad[9] T-DMatriz.UndVta[9] ~
T-DMatriz.Cantidad[10] T-DMatriz.UndVta[10] T-DMatriz.Cantidad[11] ~
T-DMatriz.UndVta[11] T-DMatriz.Cantidad[12] T-DMatriz.UndVta[12] ~
fCantidad() @ x-Cantidad 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DMatriz.Cantidad[1] ~
T-DMatriz.Cantidad[2] T-DMatriz.Cantidad[3] T-DMatriz.Cantidad[4] ~
T-DMatriz.Cantidad[5] T-DMatriz.Cantidad[6] T-DMatriz.Cantidad[7] ~
T-DMatriz.Cantidad[8] T-DMatriz.Cantidad[9] T-DMatriz.Cantidad[10] ~
T-DMatriz.Cantidad[11] T-DMatriz.Cantidad[12] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DMatriz
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DMatriz
&Scoped-define QUERY-STRING-br_table FOR EACH T-DMatriz OF VtaCMatriz WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DMatriz OF VtaCMatriz WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-DMatriz
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DMatriz


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-DesMat 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpLin-1 FILL-IN-ImpLin-2 ~
FILL-IN-ImpLin-3 FILL-IN-ImpLin-4 FILL-IN-ImpLin-5 FILL-IN-ImpLin-6 ~
FILL-IN-ImpLin-7 FILL-IN-ImpLin-8 FILL-IN-ImpLin-9 FILL-IN-ImpLin-10 ~
FILL-IN-ImpLin-11 FILL-IN-ImpLin-12 FILL-IN-DesMat FILL-IN-ImpTot 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCantidad B-table-Win 
FUNCTION fCantidad RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 81 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-1 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL POR COLUMNAS >>>" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-10 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-11 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-12 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-2 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-3 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-4 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-5 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-6 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-7 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-8 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-9 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     BGCOLOR 11 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "IMPORTE TOTAL GENERAL" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 0 FGCOLOR 14 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DMatriz SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DMatriz.LabelFila FORMAT "x(60)":U WIDTH 22
      T-DMatriz.Cantidad[1] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[1] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[2] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[2] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[3] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[3] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[4] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[4] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[5] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[5] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[6] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[6] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[7] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[7] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[8] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[8] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[9] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[9] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[10] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[10] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[11] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[11] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      T-DMatriz.Cantidad[12] COLUMN-LABEL "" FORMAT ">>9.99":U
      T-DMatriz.UndVta[12] COLUMN-LABEL "" FORMAT "x(3)":U WIDTH 3.14
      fCantidad() @ x-Cantidad COLUMN-LABEL "Cantidad" FORMAT ">>,>>9":U
            COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 11
  ENABLE
      T-DMatriz.Cantidad[1]
      T-DMatriz.Cantidad[2]
      T-DMatriz.Cantidad[3]
      T-DMatriz.Cantidad[4]
      T-DMatriz.Cantidad[5]
      T-DMatriz.Cantidad[6]
      T-DMatriz.Cantidad[7]
      T-DMatriz.Cantidad[8]
      T-DMatriz.Cantidad[9]
      T-DMatriz.Cantidad[10]
      T-DMatriz.Cantidad[11]
      T-DMatriz.Cantidad[12]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 13.27
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpLin-1 AT ROW 14.46 COL 23 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-ImpLin-2 AT ROW 14.46 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-ImpLin-3 AT ROW 14.46 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-ImpLin-4 AT ROW 14.46 COL 51 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-ImpLin-5 AT ROW 14.46 COL 60 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-ImpLin-6 AT ROW 14.46 COL 69 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN-ImpLin-7 AT ROW 14.46 COL 78 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-ImpLin-8 AT ROW 14.46 COL 87 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-ImpLin-9 AT ROW 14.46 COL 96 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-ImpLin-10 AT ROW 14.46 COL 105 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-ImpLin-11 AT ROW 14.46 COL 114 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     FILL-IN-ImpLin-12 AT ROW 14.46 COL 123 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     FILL-IN-DesMat AT ROW 15.42 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-ImpTot AT ROW 15.42 COL 126 COLON-ALIGNED WIDGET-ID 32
     "F8: Cambiar Unidad  de Venta    F9: Cambiar Almacén" VIEW-AS TEXT
          SIZE 45 BY .5 AT ROW 16.38 COL 25 WIDGET-ID 36
          BGCOLOR 1 FGCOLOR 15 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.VtaCMatriz
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: T-DMatriz T "SHARED" NO-UNDO INTEGRAL VtaDMatriz
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
         HEIGHT             = 16.31
         WIDTH              = 142.57.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-10 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-11 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-12 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-6 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-7 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-8 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DMatriz OF INTEGRAL.VtaCMatriz"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.T-DMatriz.LabelFila
"T-DMatriz.LabelFila" ? ? "character" ? ? ? ? ? ? no ? no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DMatriz.Cantidad[1]
"T-DMatriz.Cantidad[1]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DMatriz.UndVta[1]
"T-DMatriz.UndVta[1]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMatriz.Cantidad[2]
"T-DMatriz.Cantidad[2]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMatriz.UndVta[2]
"T-DMatriz.UndVta[2]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMatriz.Cantidad[3]
"T-DMatriz.Cantidad[3]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DMatriz.UndVta[3]
"T-DMatriz.UndVta[3]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DMatriz.Cantidad[4]
"T-DMatriz.Cantidad[4]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-DMatriz.UndVta[4]
"T-DMatriz.UndVta[4]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-DMatriz.Cantidad[5]
"T-DMatriz.Cantidad[5]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-DMatriz.UndVta[5]
"T-DMatriz.UndVta[5]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-DMatriz.Cantidad[6]
"T-DMatriz.Cantidad[6]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.T-DMatriz.UndVta[6]
"T-DMatriz.UndVta[6]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.T-DMatriz.Cantidad[7]
"T-DMatriz.Cantidad[7]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.T-DMatriz.UndVta[7]
"T-DMatriz.UndVta[7]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-DMatriz.Cantidad[8]
"T-DMatriz.Cantidad[8]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.T-DMatriz.UndVta[8]
"T-DMatriz.UndVta[8]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > Temp-Tables.T-DMatriz.Cantidad[9]
"T-DMatriz.Cantidad[9]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > Temp-Tables.T-DMatriz.UndVta[9]
"T-DMatriz.UndVta[9]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > Temp-Tables.T-DMatriz.Cantidad[10]
"T-DMatriz.Cantidad[10]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > Temp-Tables.T-DMatriz.UndVta[10]
"T-DMatriz.UndVta[10]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > Temp-Tables.T-DMatriz.Cantidad[11]
"T-DMatriz.Cantidad[11]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > Temp-Tables.T-DMatriz.UndVta[11]
"T-DMatriz.UndVta[11]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > Temp-Tables.T-DMatriz.Cantidad[12]
"T-DMatriz.Cantidad[12]" "" ">>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > Temp-Tables.T-DMatriz.UndVta[12]
"T-DMatriz.UndVta[12]" "" "x(3)" "character" ? ? ? ? ? ? no ? no no "3.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"fCantidad() @ x-Cantidad" "Cantidad" ">>,>>9" ? 11 1 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    /* PONEMOS EN GRIS AQUELLOS QUE NO TIENEN UN PRODUCTO DEFINIDO */
    IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.Cantidad[1]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.Cantidad[2]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.Cantidad[3]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.Cantidad[4]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.Cantidad[5]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.Cantidad[6]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[7] = "" THEN T-DMatriz.Cantidad[7]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[8] = "" THEN T-DMatriz.Cantidad[8]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[9] = "" THEN T-DMatriz.Cantidad[9]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[10] = "" THEN T-DMatriz.Cantidad[10]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[11] = "" THEN T-DMatriz.Cantidad[11]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[12] = "" THEN T-DMatriz.Cantidad[12]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.UndVta[1]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.UndVta[2]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.UndVta[3]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.UndVta[4]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.UndVta[5]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.UndVta[6]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[7] = "" THEN T-DMatriz.UndVta[7]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[8] = "" THEN T-DMatriz.UndVta[8]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[9] = "" THEN T-DMatriz.UndVta[9]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[10] = "" THEN T-DMatriz.UndVta[10]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[11] = "" THEN T-DMatriz.UndVta[11]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[12] = "" THEN T-DMatriz.UndVta[12]:BGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.Cantidad[1]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.Cantidad[2]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.Cantidad[3]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.Cantidad[4]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.Cantidad[5]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.Cantidad[6]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[7] = "" THEN T-DMatriz.Cantidad[7]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[8] = "" THEN T-DMatriz.Cantidad[8]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[9] = "" THEN T-DMatriz.Cantidad[9]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[10] = "" THEN T-DMatriz.Cantidad[10]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[11] = "" THEN T-DMatriz.Cantidad[11]:FGCOLOR IN BROWSE {&browse-name} = 8.
    IF T-DMatriz.CodMat[12] = "" THEN T-DMatriz.Cantidad[12]:FGCOLOR IN BROWSE {&browse-name} = 8.

    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}

      
  ASSIGN
      T-DMatriz.Cantidad[1]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[2]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[3]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[4]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[5]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[6]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[7]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[8]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[9]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[10]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[11]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[12]:READ-ONLY IN BROWSE {&browse-name} = NO.
  IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.Cantidad[1]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.Cantidad[2]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.Cantidad[3]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.Cantidad[4]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.Cantidad[5]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.Cantidad[6]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[7] = "" THEN T-DMatriz.Cantidad[7]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[8] = "" THEN T-DMatriz.Cantidad[8]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[9] = "" THEN T-DMatriz.Cantidad[9]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[10] = "" THEN T-DMatriz.Cantidad[10]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[11] = "" THEN T-DMatriz.Cantidad[11]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[12] = "" THEN T-DMatriz.Cantidad[12]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[12] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[12] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[11] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[11] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[10] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[10] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[9] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[9] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[8] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[8] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[7] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[7] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[6] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[6] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[5] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[5] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[4] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[4] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[3] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[3] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[2] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[2] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[1] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[1] IN BROWSE {&browse-name}.

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


&Scoped-define SELF-NAME T-DMatriz.Cantidad[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[1] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[1] IN BROWSE br_table
DO:
  FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = T-DMatriz.codmat[1]
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[1] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[1] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[1],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[1] = output-var-2.
    DISPLAY T-DMatriz.UndVta[1] @ T-DMatriz.UndVta[1] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[1] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[1] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[1] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[1] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[1],
                         T-DMatriz.AlmDes[1],
                         T-DMatriz.UndVta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[1].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[1], T-DMatriz.UndVta[1], T-DMatriz.Cantidad[1], 
                      T-DMatriz.AlmDes[1], OUTPUT pImpLin).
    T-DMatriz.Importe[1] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[2] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[2] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[2] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[2] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[2],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[2] = output-var-2.
    DISPLAY T-DMatriz.UndVta[2] @ T-DMatriz.UndVta[2] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[2] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[2] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[2] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[2] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[2],
                         T-DMatriz.AlmDes[2],
                         T-DMatriz.UndVta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[2].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[2], T-DMatriz.UndVta[2], T-DMatriz.Cantidad[2], 
                      T-DMatriz.AlmDes[2], OUTPUT pImpLin).
    T-DMatriz.Importe[2] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[3] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[3] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[3]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[3] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[3] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[3],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[3] = output-var-2.
    DISPLAY T-DMatriz.UndVta[3] @ T-DMatriz.UndVta[3] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[3] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[3] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[3] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[3] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[3],
                         T-DMatriz.AlmDes[3],
                         T-DMatriz.UndVta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[3].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[3], T-DMatriz.UndVta[3], T-DMatriz.Cantidad[3], 
                      T-DMatriz.AlmDes[3], OUTPUT pImpLin).
    T-DMatriz.Importe[3] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[4] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[4] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[4]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[4] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[4] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[4],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[4] = output-var-2.
    DISPLAY T-DMatriz.UndVta[4] @ T-DMatriz.UndVta[4] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[4] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[4] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[4] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[4] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[4] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[4],
                         T-DMatriz.AlmDes[4],
                         T-DMatriz.UndVta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[4].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[4], T-DMatriz.UndVta[4], T-DMatriz.Cantidad[4], 
                      T-DMatriz.AlmDes[4], OUTPUT pImpLin).
    T-DMatriz.Importe[4] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[5] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[5] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[5]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[5] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[5] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[5],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[5] = output-var-2.
    DISPLAY T-DMatriz.UndVta[5] @ T-DMatriz.UndVta[5] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[5] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[5] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[5] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[5] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[5] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[5],
                         T-DMatriz.AlmDes[5],
                         T-DMatriz.UndVta[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[5].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[5], T-DMatriz.UndVta[5], T-DMatriz.Cantidad[5], 
                      T-DMatriz.AlmDes[5], OUTPUT pImpLin).
    T-DMatriz.Importe[5] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[6] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[6] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[6]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[6] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[6] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[6],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[6] = output-var-2.
    DISPLAY T-DMatriz.UndVta[6] @ T-DMatriz.UndVta[6] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[6] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[6] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[6] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[6] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[6] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[6],
                         T-DMatriz.AlmDes[6],
                         T-DMatriz.UndVta[6]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[6].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[6], T-DMatriz.UndVta[6], T-DMatriz.Cantidad[6], 
                      T-DMatriz.AlmDes[6], OUTPUT pImpLin).
    T-DMatriz.Importe[6] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[7] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[7] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[7]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[7] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[7] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[7],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[7] = output-var-2.
    DISPLAY T-DMatriz.UndVta[7] @ T-DMatriz.UndVta[7] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[7] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[7] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[7] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[7] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[7] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[7],
                         T-DMatriz.AlmDes[7],
                         T-DMatriz.UndVta[7]:SCREEN-VALUE IN BROWSE {&browse-name},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[7].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[7], T-DMatriz.UndVta[7], T-DMatriz.Cantidad[7], 
                      T-DMatriz.AlmDes[7], OUTPUT pImpLin).
    T-DMatriz.Importe[7] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[8] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[8] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[8]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[8] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[8] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[8],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[8] = output-var-2.
    DISPLAY T-DMatriz.UndVta[8] @ T-DMatriz.UndVta[8] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[8] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[8] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[8] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[8] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[8] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[8],
                         T-DMatriz.AlmDes[8],
                         T-DMatriz.UndVta[8]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[8].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[8], T-DMatriz.UndVta[8], T-DMatriz.Cantidad[8], 
                      T-DMatriz.AlmDes[8], OUTPUT pImpLin).
    T-DMatriz.Importe[8] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[9] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[9] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[9]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[9] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[9] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[9],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[9] = output-var-2.
    DISPLAY T-DMatriz.UndVta[9] @ T-DMatriz.UndVta[9] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[9] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[9] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[9] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[9] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[9] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[9],
                         T-DMatriz.AlmDes[9],
                         T-DMatriz.UndVta[9]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[9].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[9], T-DMatriz.UndVta[9], T-DMatriz.Cantidad[9], 
                      T-DMatriz.AlmDes[9], OUTPUT pImpLin).
    T-DMatriz.Importe[9] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[10] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[10] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[10]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[10] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[10] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[10],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[10] = output-var-2.
    DISPLAY T-DMatriz.UndVta[10] @ T-DMatriz.UndVta[10] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[10] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[10] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[10] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[10] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[10] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[10],
                         T-DMatriz.AlmDes[10],
                         T-DMatriz.UndVta[10]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[10].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[10], T-DMatriz.UndVta[10], T-DMatriz.Cantidad[10], 
                      T-DMatriz.AlmDes[10], OUTPUT pImpLin).
    T-DMatriz.Importe[10] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[11] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[11] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[11]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[11] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[11] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[11],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[11] = output-var-2.
    DISPLAY T-DMatriz.UndVta[11] @ T-DMatriz.UndVta[11] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[11] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[11] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[11] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[11] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[11] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[11],
                         T-DMatriz.AlmDes[11],
                         T-DMatriz.UndVta[11]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[11].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[11], T-DMatriz.UndVta[11], T-DMatriz.Cantidad[11], 
                      T-DMatriz.AlmDes[11], OUTPUT pImpLin).
    T-DMatriz.Importe[11] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DMatriz.Cantidad[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[12] br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF T-DMatriz.Cantidad[12] IN BROWSE br_table
DO:
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = T-DMatriz.codmat[12]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = Almmmatg.codmat + ' ' + Almmmatg.desmat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[12] br_table _BROWSE-COLUMN B-table-Win
ON F8 OF T-DMatriz.Cantidad[12] IN BROWSE br_table
DO:
    /****    Selecciona las unidades de medida   ****/
    RUN vtagn/c-uniabc ("Unidades de Venta",
                        T-DMatriz.CodMat[12],
                        s-CodAlm
                        ).
    IF output-var-1 <> ? THEN T-DMatriz.UndVta[12] = output-var-2.
    DISPLAY T-DMatriz.UndVta[12] @ T-DMatriz.UndVta[12] WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[12] br_table _BROWSE-COLUMN B-table-Win
ON F9 OF T-DMatriz.Cantidad[12] IN BROWSE br_table
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-coddiv
        input-var-3 = ''.
    RUN vtagn/c-vtaalmdiv-01 ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN T-DMatriz.AlmDes[12] = output-var-2.
    RUN Color-Celdas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DMatriz.Cantidad[12] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DMatriz.Cantidad[12] IN BROWSE br_table
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) = 0 THEN RETURN.

    RUN Valida-por-Item (T-DMatriz.CodMat[12],
                         T-DMatriz.AlmDes[12],
                         T-DMatriz.UndVta[12]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(SELF:SCREEN-VALUE)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    /*RUN dispatch IN THIS-PROCEDURE ('assign-statement':U).*/

    /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
    ASSIGN T-DMatriz.Cantidad[12].

    DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

    RUN Importe-Item (T-DMatriz.CodMat[12], T-DMatriz.UndVta[12], T-DMatriz.Cantidad[12], 
                      T-DMatriz.AlmDes[12], OUTPUT pImpLin).
    T-DMatriz.Importe[12] = pImpLin.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF T-DMatriz.Cantidad[1], T-DMatriz.Cantidad[10], 
    T-DMatriz.Cantidad[11], T-DMatriz.Cantidad[12], 
    T-DMatriz.Cantidad[2], T-DMatriz.Cantidad[3], T-DMatriz.Cantidad[4], 
    T-DMatriz.Cantidad[5], T-DMatriz.Cantidad[6], T-DMatriz.Cantidad[7], 
    T-DMatriz.Cantidad[8], T-DMatriz.Cantidad[9]
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaCMatriz"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCMatriz"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Color-Celdas B-table-Win 
PROCEDURE Color-Celdas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF T-DMatriz.AlmDes[1] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[1]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[1], s-CodAlm)]
        T-DMatriz.Cantidad[1]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[1], s-CodAlm)].
    IF T-DMatriz.AlmDes[2] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[2]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[2], s-CodAlm)]
        T-DMatriz.Cantidad[2]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[2], s-CodAlm)].
    IF T-DMatriz.AlmDes[3] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[3]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[3], s-CodAlm)]
        T-DMatriz.Cantidad[3]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[3], s-CodAlm)].
    IF T-DMatriz.AlmDes[4] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[4]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[4], s-CodAlm)]
        T-DMatriz.Cantidad[4]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[4], s-CodAlm)].
    IF T-DMatriz.AlmDes[5] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[5]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[5], s-CodAlm)]
        T-DMatriz.Cantidad[5]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[5], s-CodAlm)].
    IF T-DMatriz.AlmDes[6] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[6]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[6], s-CodAlm)]
        T-DMatriz.Cantidad[6]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[6], s-CodAlm)].
    IF T-DMatriz.AlmDes[7] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[7]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[7], s-CodAlm)]
        T-DMatriz.Cantidad[7]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[7], s-CodAlm)].
    IF T-DMatriz.AlmDes[8] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[8]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[8], s-CodAlm)]
        T-DMatriz.Cantidad[8]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[8], s-CodAlm)].
    IF T-DMatriz.AlmDes[9] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[9]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[9], s-CodAlm)]
        T-DMatriz.Cantidad[9]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[9], s-CodAlm)].
    IF T-DMatriz.AlmDes[10] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[10]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[10], s-CodAlm)]
        T-DMatriz.Cantidad[10]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[10], s-CodAlm)].
    IF T-DMatriz.AlmDes[11] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[11]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[11], s-CodAlm)]
        T-DMatriz.Cantidad[11]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[11], s-CodAlm)].
    IF T-DMatriz.AlmDes[12] <> '' THEN 
        ASSIGN
        T-DMatriz.Cantidad[12]:FGCOLOR IN BROWSE {&browse-name} = c-FgColor[LOOKUP(T-DMatriz.AlmDes[12], s-CodAlm)]
        T-DMatriz.Cantidad[12]:BGCOLOR IN BROWSE {&browse-name} = c-BgColor[LOOKUP(T-DMatriz.AlmDes[12], s-CodAlm)].

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Item B-table-Win 
PROCEDURE Crea-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pCodMat AS CHAR.
    DEF INPUT PARAMETER pCantidad AS DEC.
    DEF INPUT PARAMETER pUndVta AS CHAR.
    DEF INPUT PARAMETER pAlmDes AS CHAR.

    IF pCodMat = "" THEN RETURN.
    IF pCantidad <= 0 THEN RETURN.

    DEF VAR x-NroItm AS INT NO-UNDO.

    x-NroItm = 1.
    FOR EACH ITEM BY ITEM.NroItm:
        x-NroItm = ITEM.NroItm + 1.
    END.
    FIND ITEM WHERE ITEM.codmat = pCodMat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM. ELSE x-NroItm = ITEM.NroItm.
    ASSIGN
        ITEM.codcia = s-codcia
        ITEM.almdes = pAlmDes
        ITEM.CodMat = pCodMat
        ITEM.CanPed = pCantidad
        ITEM.Factor = 1
        ITEM.UndVta = pUndVta
        ITEM.NroItm = x-NroItm.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registros B-table-Win 
PROCEDURE Graba-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.

FOR EACH T-DMatriz:
    RUN Crea-Item (T-DMatriz.CodMat[1], T-DMatriz.Cantidad[1], T-DMatriz.UndVta[1], T-DMatriz.AlmDes[1]).
    RUN Crea-Item (T-DMatriz.CodMat[2], T-DMatriz.Cantidad[2], T-DMatriz.UndVta[2], T-DMatriz.AlmDes[2]).
    RUN Crea-Item (T-DMatriz.CodMat[3], T-DMatriz.Cantidad[3], T-DMatriz.UndVta[3], T-DMatriz.AlmDes[3]).
    RUN Crea-Item (T-DMatriz.CodMat[4], T-DMatriz.Cantidad[4], T-DMatriz.UndVta[4], T-DMatriz.AlmDes[4]).
    RUN Crea-Item (T-DMatriz.CodMat[5], T-DMatriz.Cantidad[5], T-DMatriz.UndVta[5], T-DMatriz.AlmDes[5]).
    RUN Crea-Item (T-DMatriz.CodMat[6], T-DMatriz.Cantidad[6], T-DMatriz.UndVta[6], T-DMatriz.AlmDes[6]).
    RUN Crea-Item (T-DMatriz.CodMat[7], T-DMatriz.Cantidad[7], T-DMatriz.UndVta[7], T-DMatriz.AlmDes[7]).
    RUN Crea-Item (T-DMatriz.CodMat[8], T-DMatriz.Cantidad[8], T-DMatriz.UndVta[8], T-DMatriz.AlmDes[8]).
    RUN Crea-Item (T-DMatriz.CodMat[9], T-DMatriz.Cantidad[9], T-DMatriz.UndVta[9], T-DMatriz.AlmDes[9]).
    RUN Crea-Item (T-DMatriz.CodMat[10], T-DMatriz.Cantidad[10], T-DMatriz.UndVta[10], T-DMatriz.AlmDes[10]).
    RUN Crea-Item (T-DMatriz.CodMat[11], T-DMatriz.Cantidad[11], T-DMatriz.UndVta[11], T-DMatriz.AlmDes[11]).
    RUN Crea-Item (T-DMatriz.CodMat[12], T-DMatriz.Cantidad[12], T-DMatriz.UndVta[12], T-DMatriz.AlmDes[12]).
END.

END PROCEDURE.

/*
DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR f-PreBas AS DEC NO-UNDO.
DEF VAR f-PreVta AS DEC NO-UNDO.
DEF VAR f-Dsctos AS DEC NO-UNDO.
DEF VAR y-Dsctos AS DEC NO-UNDO.
DEF VAR z-Dsctos AS DEC NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.

FOR EACH T-DMatriz:
    IF T-DMatriz.Cantidad[1] <> 0 THEN DO:
        CREATE ITEM.
        ASSIGN
            ITEM.codcia = s-codcia
            ITEM.almdes = ENTRY(1, s-codalm)
            ITEM.CodMat = T-DMatriz.CodMat[1]
            ITEM.CanPed = T-DMatriz.Cantidad[1]
            ITEM.Factor = 1.
        pCodMat = ITEM.codmat.
        RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
        IF pCodMat = '' THEN UNDO, NEXT.
        FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = ITEM.codmat
            NO-LOCK.
        IF Almmmatg.Chr__01 = "" THEN DO:
           MESSAGE "Articulo" ITEM.codmat "no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
           UNDO, NEXT.
        END.
        ITEM.UndVta = Almmmatg.UndA.
        RUN vta2/PrecioMayorista-Cont (s-CodCia,
                                       s-CodDiv,
                                       s-CodCli,
                                       s-CodMon,
                                       s-TpoCmb,
                                       OUTPUT f-Factor,
                                       ITEM.codmat,
                                       s-FlgSit,
                                       ITEM.undvta,
                                       ITEM.CanPed,
                                       s-NroDec,
                                       ITEM.almdes,   /* Necesario para REMATES */
                                       OUTPUT f-PreBas,
                                       OUTPUT f-PreVta,
                                       OUTPUT f-Dsctos,
                                       OUTPUT y-Dsctos,
                                       OUTPUT x-TipDto
                                       ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, NEXT.
        ASSIGN
            ITEM.PreUni = F-PREVTA
            ITEM.Por_Dsctos[2] = z-Dsctos
            ITEM.Por_Dsctos[3] = y-Dsctos.

        ASSIGN 
            ITEM.Factor = F-FACTOR
            /*ITEM.NroItm = I-NroItm*/
            ITEM.PorDto = f-Dsctos
            ITEM.PreBas = F-PreBas 
            ITEM.AftIgv = Almmmatg.AftIgv
            ITEM.AftIsc = Almmmatg.AftIsc
            ITEM.Libre_c04 = x-TipDto.
        ASSIGN
            ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
        IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
            THEN ITEM.ImpDto = 0.
            ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
        ASSIGN
            ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
            ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
        IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
        ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
        THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Item B-table-Win 
PROCEDURE Importe-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF OUTPUT PARAMETER pImpLin AS DEC.

pImpLin = 0.
IF pCodMat = "" THEN RETURN.

DEFINE VARIABLE f-Factor LIKE Facdpedi.factor NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
RUN vta2/PrecioMayorista-Cont (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               pCodMat,
                               s-FlgSit,
                               pUndVta,
                               pCanPed,
                               s-NroDec,
                               pAlmDes,
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto
                               ).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
ASSIGN
    pImpLin = ROUND ( pCanPed * f-PreVta * ( 1 - y-Dsctos / 100 ), 2 ).
ASSIGN
    pImpLin = ROUND(pImpLin, 2).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total B-table-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-ImpLin-1 = 0
    FILL-IN-ImpLin-10 = 0
    FILL-IN-ImpLin-11 = 0
    FILL-IN-ImpLin-12 = 0
    FILL-IN-ImpLin-2 = 0
    FILL-IN-ImpLin-3 = 0
    FILL-IN-ImpLin-4 = 0
    FILL-IN-ImpLin-5 = 0
    FILL-IN-ImpLin-6 = 0
    FILL-IN-ImpLin-7 = 0
    FILL-IN-ImpLin-8 = 0
    FILL-IN-ImpLin-9 = 0
    FILL-IN-ImpTot = 0.
FOR EACH B-DMatriz OF VtaCMatriz:
    ASSIGN
        FILL-IN-ImpLin-1 = FILL-IN-ImpLin-1 + B-DMatriz.Cantidad[1]
        FILL-IN-ImpLin-2 = FILL-IN-ImpLin-2 + B-DMatriz.Cantidad[2]
        FILL-IN-ImpLin-3 = FILL-IN-ImpLin-3 + B-DMatriz.Cantidad[3]
        FILL-IN-ImpLin-4 = FILL-IN-ImpLin-4 + B-DMatriz.Cantidad[4]
        FILL-IN-ImpLin-5 = FILL-IN-ImpLin-5 + B-DMatriz.Cantidad[5]
        FILL-IN-ImpLin-6 = FILL-IN-ImpLin-6 + B-DMatriz.Cantidad[6]
        FILL-IN-ImpLin-7 = FILL-IN-ImpLin-7 + B-DMatriz.Cantidad[7]
        FILL-IN-ImpLin-8 = FILL-IN-ImpLin-8 + B-DMatriz.Cantidad[8]
        FILL-IN-ImpLin-9 = FILL-IN-ImpLin-9 + B-DMatriz.Cantidad[9]
        FILL-IN-ImpLin-10 = FILL-IN-ImpLin-10 + B-DMatriz.Cantidad[10]
        FILL-IN-ImpLin-11 = FILL-IN-ImpLin-11 + B-DMatriz.Cantidad[11]
        FILL-IN-ImpLin-12 = FILL-IN-ImpLin-12 + B-DMatriz.Cantidad[12].
/*     ASSIGN                                                            */
/*         FILL-IN-ImpLin-1 = FILL-IN-ImpLin-1 + B-DMatriz.Importe[1]    */
/*         FILL-IN-ImpLin-10 = FILL-IN-ImpLin-10 + B-DMatriz.Importe[10] */
/*         FILL-IN-ImpLin-11 = FILL-IN-ImpLin-11 + B-DMatriz.Importe[11] */
/*         FILL-IN-ImpLin-12 = FILL-IN-ImpLin-12 + B-DMatriz.Importe[12] */
/*         FILL-IN-ImpLin-2 = FILL-IN-ImpLin-2 + B-DMatriz.Importe[2]    */
/*         FILL-IN-ImpLin-3 = FILL-IN-ImpLin-3 + B-DMatriz.Importe[3]    */
/*         FILL-IN-ImpLin-4 = FILL-IN-ImpLin-4 + B-DMatriz.Importe[4]    */
/*         FILL-IN-ImpLin-5 = FILL-IN-ImpLin-5 + B-DMatriz.Importe[5]    */
/*         FILL-IN-ImpLin-6 = FILL-IN-ImpLin-6 + B-DMatriz.Importe[6]    */
/*         FILL-IN-ImpLin-7 = FILL-IN-ImpLin-7 + B-DMatriz.Importe[7]    */
/*         FILL-IN-ImpLin-8 = FILL-IN-ImpLin-8 + B-DMatriz.Importe[8]    */
/*         FILL-IN-ImpLin-9 = FILL-IN-ImpLin-9 + B-DMatriz.Importe[9].   */
END.
FOR EACH B-DMatriz:
    FILL-IN-ImpTot = FILL-IN-ImpTot +
        B-DMatriz.Importe[1] + B-DMatriz.Importe[2] + B-DMatriz.Importe[3] + 
        B-DMatriz.Importe[4] + B-DMatriz.Importe[5] + B-DMatriz.Importe[6] + 
        B-DMatriz.Importe[7] + B-DMatriz.Importe[8] + B-DMatriz.Importe[9] + 
        B-DMatriz.Importe[10] + B-DMatriz.Importe[11] + B-DMatriz.Importe[12].
END.
DISPLAY
    FILL-IN-ImpLin-1 
    FILL-IN-ImpLin-10
    FILL-IN-ImpLin-11
    FILL-IN-ImpLin-12
    FILL-IN-ImpLin-2 
    FILL-IN-ImpLin-3 
    FILL-IN-ImpLin-4 
    FILL-IN-ImpLin-5 
    FILL-IN-ImpLin-6 
    FILL-IN-ImpLin-7 
    FILL-IN-ImpLin-8 
    FILL-IN-ImpLin-9 
    FILL-IN-ImpTot
    WITH FRAME {&FRAME-NAME}.


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
/*
  /* REGRABAMOS LAS UNIDADES DE VENTA */
  ASSIGN
      T-DMatriz.UndVta[1] = T-DMatriz.UndVta[1]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[2] = T-DMatriz.UndVta[2]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[3] = T-DMatriz.UndVta[3]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[4] = T-DMatriz.UndVta[4]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[5] = T-DMatriz.UndVta[5]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[6] = T-DMatriz.UndVta[6]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[7] = T-DMatriz.UndVta[7]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[8] = T-DMatriz.UndVta[8]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[9] = T-DMatriz.UndVta[9]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[10] = T-DMatriz.UndVta[10]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[11] = T-DMatriz.UndVta[11]:SCREEN-VALUE IN BROWSE {&browse-name}
      T-DMatriz.UndVta[12] = T-DMatriz.UndVta[12]:SCREEN-VALUE IN BROWSE {&browse-name}.

  /* POR CADA COLUMNA CALCULAMOS SU IMPORTE */
  DEF VAR pImpLin LIKE Facdpedi.ImpLin NO-UNDO.

  RUN Importe-Item (T-DMatriz.CodMat[1], T-DMatriz.UndVta[1], T-DMatriz.Cantidad[1], 
                    T-DMatriz.AlmDes[1], OUTPUT pImpLin).
  T-DMatriz.Importe[1] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[2], T-DMatriz.UndVta[2], T-DMatriz.Cantidad[2], 
                    T-DMatriz.AlmDes[2], OUTPUT pImpLin).
  T-DMatriz.Importe[2] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[3], T-DMatriz.UndVta[3], T-DMatriz.Cantidad[3], 
                    T-DMatriz.AlmDes[3], OUTPUT pImpLin).
  T-DMatriz.Importe[3] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[4], T-DMatriz.UndVta[4], T-DMatriz.Cantidad[4], 
                  T-DMatriz.AlmDes[4], OUTPUT pImpLin).
  T-DMatriz.Importe[4] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[5], T-DMatriz.UndVta[5], T-DMatriz.Cantidad[5], 
                    T-DMatriz.AlmDes[5], OUTPUT pImpLin).
  T-DMatriz.Importe[5] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[6], T-DMatriz.UndVta[6], T-DMatriz.Cantidad[6], 
                    T-DMatriz.AlmDes[6], OUTPUT pImpLin).
  T-DMatriz.Importe[6] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[7], T-DMatriz.UndVta[7], T-DMatriz.Cantidad[7], 
                    T-DMatriz.AlmDes[7], OUTPUT pImpLin).
  T-DMatriz.Importe[7] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[8], T-DMatriz.UndVta[8], T-DMatriz.Cantidad[8], 
                    T-DMatriz.AlmDes[8], OUTPUT pImpLin).
  T-DMatriz.Importe[8] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[9], T-DMatriz.UndVta[9], T-DMatriz.Cantidad[9], 
                    T-DMatriz.AlmDes[9], OUTPUT pImpLin).
  T-DMatriz.Importe[9] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[10], T-DMatriz.UndVta[10], T-DMatriz.Cantidad[10], 
                    T-DMatriz.AlmDes[10], OUTPUT pImpLin).
  T-DMatriz.Importe[10] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[11], T-DMatriz.UndVta[11], T-DMatriz.Cantidad[11], 
                    T-DMatriz.AlmDes[11], OUTPUT pImpLin).
  T-DMatriz.Importe[11] = pImpLin.

  RUN Importe-Item (T-DMatriz.CodMat[12], T-DMatriz.UndVta[12], T-DMatriz.Cantidad[12], 
                    T-DMatriz.AlmDes[12], OUTPUT pImpLin).
  T-DMatriz.Importe[12] = pImpLin.

  RUN Importe-Total.
  RUN Color-Celdas.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
*/
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
  FILL-IN-DesMat:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  ASSIGN
      T-DMatriz.Cantidad[1]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[2]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[3]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[4]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[5]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[6]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[7]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[8]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[9]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[10]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[11]:READ-ONLY IN BROWSE {&browse-name} = NO
      T-DMatriz.Cantidad[12]:READ-ONLY IN BROWSE {&browse-name} = NO.
  IF T-DMatriz.CodMat[1] = "" THEN T-DMatriz.Cantidad[1]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[2] = "" THEN T-DMatriz.Cantidad[2]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[3] = "" THEN T-DMatriz.Cantidad[3]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[4] = "" THEN T-DMatriz.Cantidad[4]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[5] = "" THEN T-DMatriz.Cantidad[5]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[6] = "" THEN T-DMatriz.Cantidad[6]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[7] = "" THEN T-DMatriz.Cantidad[7]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[8] = "" THEN T-DMatriz.Cantidad[8]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[9] = "" THEN T-DMatriz.Cantidad[9]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[10] = "" THEN T-DMatriz.Cantidad[10]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[11] = "" THEN T-DMatriz.Cantidad[11]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[12] = "" THEN T-DMatriz.Cantidad[12]:READ-ONLY IN BROWSE {&browse-name} = YES.
  IF T-DMatriz.CodMat[12] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[12] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[11] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[11] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[10] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[10] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[9] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[9] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[8] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[8] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[7] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[7] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[6] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[6] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[5] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[5] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[4] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[4] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[3] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[3] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[2] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[2] IN BROWSE {&browse-name}.
  IF T-DMatriz.CodMat[1] <> "" THEN APPLY 'ENTRY':U TO T-DMatriz.Cantidad[1] IN BROWSE {&browse-name}.


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
  ASSIGN
      T-DMatriz.UndVta[1]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[1]
      T-DMatriz.UndVta[2]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[2]
      T-DMatriz.UndVta[3]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[3]
      T-DMatriz.UndVta[4]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[4]
      T-DMatriz.UndVta[5]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[5]
      T-DMatriz.UndVta[6]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[6]
      T-DMatriz.UndVta[7]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[7]
      T-DMatriz.UndVta[8]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[8]
      T-DMatriz.UndVta[9]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[9]
      T-DMatriz.UndVta[10]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[10]
      T-DMatriz.UndVta[11]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[11]
      T-DMatriz.UndVta[12]:LABEL IN BROWSE {&browse-name} = VtaCMatriz.LabelColumna[12].

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Importe-Total.

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
  {src/adm/template/snd-list.i "VtaCMatriz"}
  {src/adm/template/snd-list.i "T-DMatriz"}

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

/* LA VALIDACION SE VA A HACER POR CADA CELDA 
IF T-DMatriz.CodMat[1] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[1],
                         T-DMatriz.AlmDes[1],
                         T-DMatriz.UndVta[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[1] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[2] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[2],
                         T-DMatriz.AlmDes[2],
                         T-DMatriz.UndVta[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[2] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[3] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[3],
                         T-DMatriz.AlmDes[3],
                         T-DMatriz.UndVta[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[3] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[4] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[4],
                         T-DMatriz.AlmDes[4],
                         T-DMatriz.UndVta[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[4] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[5] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[5],
                         T-DMatriz.AlmDes[5],
                         T-DMatriz.UndVta[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[5] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[6] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[6]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[6],
                         T-DMatriz.AlmDes[6],
                         T-DMatriz.UndVta[6]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[6]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[6] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[7] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[7]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[7],
                         T-DMatriz.AlmDes[7],
                         T-DMatriz.UndVta[7]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[7]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[7] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[8] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[8]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[8],
                         T-DMatriz.AlmDes[8],
                         T-DMatriz.UndVta[8]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[8]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[8] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[9] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[9]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[9],
                         T-DMatriz.AlmDes[9],
                         T-DMatriz.UndVta[9]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[9]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[9] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[10] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[10]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[10],
                         T-DMatriz.AlmDes[10],
                         T-DMatriz.UndVta[10]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[10]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[10] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[11] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[11]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[11],
                         T-DMatriz.AlmDes[11],
                         T-DMatriz.UndVta[11]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[11]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[11] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
IF T-DMatriz.CodMat[12] <> "" 
    AND DECIMAL(T-DMatriz.Cantidad[12]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0 THEN DO:
    RUN Valida-por-Item (T-DMatriz.CodMat[12],
                         T-DMatriz.AlmDes[12],
                         T-DMatriz.UndVta[12]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
                         DECIMAL(T-DMatriz.Cantidad[12]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO T-DMatriz.Cantidad[12] IN BROWSE {&BROWSE-NAME}.
        RETURN "ADM-ERROR".
    END.
END.
*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-por-Item B-table-Win 
PROCEDURE Valida-por-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pAlmDes AS CHAR.
DEF INPUT PARAMETER pUndVta AS CHAR.
DEF INPUT PARAMETER pCanPed AS DEC.

DEF VAR pPreUni AS DEC NO-UNDO.
DEF VAR pPor_Dsctos1 AS DEC NO-UNDO.
DEF VAR pPor_Dsctos2 AS DEC NO-UNDO.
DEF VAR pPor_Dsctos3 AS DEC NO-UNDO.

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

/* PRODUCTO */  
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Código de producto' pCodMat 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF Almmmatg.TpoArt = "D" THEN DO:
    MESSAGE 'Producto' Almmmatg.desmat 'DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
    AND Almmmate.CodAlm = pAlmDes
    AND Almmmate.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN DO:
    MESSAGE "Articulo" Almmmatg.desmat "no asignado al almacén" pAlmDes
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* FAMILIA DE VENTAS */
FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN DO:
    MESSAGE 'Producto' Almmmatg.desmat SKIP
        'Línea' Almmmatg.codfam 'NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
IF AVAILABLE Almsfami 
    AND AlmSFami.SwDigesa = YES 
    AND Almmmatg.VtoDigesa <> ? 
    AND  Almmmatg.VtoDigesa < TODAY THEN DO:
    MESSAGE 'Producto' Almmmatg.desmat 'con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:
    MESSAGE "No se puede vender el producto" Almmmatg.desmat "al por menor"
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:
    MESSAGE "No se puede vender el producto" Almmmatg.desmat "al por mayor"
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* ********************************************* */
/* UNIDAD */
IF pUndVta = "" THEN DO:
    MESSAGE 'Producto' Almmmatg.desmat "NO tiene registrado la unidad de venta" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* CANTIDAD */
IF pCanPed < 0.125 THEN DO:
    MESSAGE "Cantidad del producto" Almmmatg.desmat "debe ser mayor o igual a 0.125" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF pUndVta = "UNI" AND pCanPed - TRUNCATE(pCanPed, 0) <> 0 THEN DO:
    MESSAGE "NO se permiten ventas fraccionadas en el producto" Almmmatg.desmat VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* FACTOR DE EQUIVALENCIA Y PRECIO UNITARIO*/
RUN vta2/PrecioMayorista-Cont (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               pCodMat,
                               s-FlgSit,
                               pUndVta,
                               pCanPed,
                               s-NroDec,
                               pAlmDes,
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto
                               ).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".
ASSIGN
    pPreUni = f-PreVta
    pPor_Dsctos2 = f-Dsctos
    pPor_Dsctos3 = y-Dsctos.

/* EMPAQUE */
DEF VAR f-Canped AS DEC NO-UNDO.
IF s-FlgEmpaque = YES THEN DO:
  f-CanPed = pCanPed * f-Factor.
  IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
      FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
      IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / Vtalistamay.CanEmp),0) * Vtalistamay.CanEmp).
          IF f-CanPed <> pCanPed * f-Factor THEN DO:
              MESSAGE 'Para el producto' Almmmatg.desmat SKIP
                  'Solo puede vender en empaques de' Vtalistamay.CanEmp Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  ELSE DO:      /* LISTA GENERAL */
      IF Almmmatg.DEC__03 > 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          IF f-CanPed <> pCanPed * f-Factor THEN DO:
              MESSAGE 'Para el producto' Almmmatg.desmat SKIP
                  'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
END.
/* MINIMO DE VENTA */
IF s-FlgMinVenta = YES THEN DO:
  f-CanPed = pCanPed * f-Factor.
  IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
      FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
      IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
          IF f-CanPed < Vtalistamay.CanEmp THEN DO:
              MESSAGE 'Para el producto' Almmmatg.desmat SKIP
                  'Solo puede vender como mínimo' Vtalistamay.CanEmp Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  ELSE DO:      /* LISTA GENERAL */
      IF Almmmatg.DEC__03 > 0 THEN DO:
          IF f-CanPed < Almmmatg.DEC__03 THEN DO:
              MESSAGE 'Para el producto' Almmmatg.desmat SKIP
                  'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
END.

/* STOCK COMPROMETIDO */
DEF VAR s-StkComprometido AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.

RUN vta2/Stock-Comprometido (pCodMat, 
                             pAlmDes, 
                             OUTPUT s-StkComprometido).
IF s-adm-new-record = 'NO' THEN DO:
    FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.coddoc = s-coddoc
        AND Facdpedi.nroped = s-nroped
        AND Facdpedi.codmat = pCodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ).
END.
ASSIGN
    x-CanPed = pCanPed * f-Factor
    x-StkAct = Almmmate.StkAct.
IF (x-StkAct - s-StkComprometido) < x-CanPed
  THEN DO:
    MESSAGE "Producto" Almmmatg.desmat SKIP
        "No hay STOCK suficiente" SKIP(1)
        "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP
        "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP
        "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* ************************************** */
/* RHC 13.12.2010 Margen de Utilidad */
/* RHC menos para productos de remate */
FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pAlmDes NO-LOCK.
IF Almacen.Campo-C[3] <> "Si" THEN DO:    /* NO para almacenes de remate */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR X-MARGEN AS DEC NO-UNDO.
    DEF VAR X-LIMITE AS DEC NO-UNDO.
    DEF VAR x-PreUni AS DEC NO-UNDO.

    x-PreUni = pPreUni *
        ( 1 - pPor_Dsctos1 / 100 ) *
        ( 1 - pPor_Dsctos2 / 100 ) *
        ( 1 - pPor_Dsctos3 / 100 ) .
    RUN vtagn/p-margen-utilidad (
        pCodMat,      /* Producto */
        x-PreUni,  /* Precio de venta unitario */
        pUndVta,
        s-CodMon,       /* Moneda de venta */
        s-TpoCmb,       /* Tipo de cambio */
        YES,            /* Muestra el error */
        "",
        OUTPUT x-Margen,        /* Margen de utilidad */
        OUTPUT x-Limite,        /* Margen mínimo de utilidad */
        OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
        ).
    IF pError = "ADM-ERROR" THEN RETURN "ADM-ERROR".
END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCantidad B-table-Win 
FUNCTION fCantidad RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN T-DMatriz.Cantidad[1] + T-DMatriz.Cantidad[2] + T-DMatriz.Cantidad[3] + 
    T-DMatriz.Cantidad[4] + T-DMatriz.Cantidad[5] + T-DMatriz.Cantidad[6] + 
    T-DMatriz.Cantidad[7] + T-DMatriz.Cantidad[8] + T-DMatriz.Cantidad[9] + 
    T-DMatriz.Cantidad[10] + T-DMatriz.Cantidad[11] + T-DMatriz.Cantidad[12].

  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

