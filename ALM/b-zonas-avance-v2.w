&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-AlmDInv NO-UNDO LIKE INTEGRAL.AlmDInv.



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

DEFINE SHARED VAR s-codcia  AS INTEGER INIT 1.
DEFINE SHARED VAR s-user-id AS CHARACTER.
DEFINE SHARED VAR s-nomcia  AS CHARACTER.

DEFINE VARIABLE cConfi  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyDif AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCant   AS INTEGER     NO-UNDO INIT 0.
DEFINE VARIABLE cArti   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dQtyCon AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cFiltro AS CHARACTER   NO-UNDO.

DEFINE VARIABLE s-task-no AS INTEGER  NO-UNDO.


DEFINE BUFFER tmp-tt-AlmDInv FOR tt-AlmDInv.
/*
DEFINE TEMP-TABLE tt-Datos LIKE tmp-tt-AlmDInv.
*/
DEFINE VARIABLE Imp AS INTEGER NO-UNDO.

/*Mensaje de Proceso*/
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.


    DEFINE VAR lConteoTotal AS INT INITIAL 0.
    DEFINE VAR lConteoAvance AS INT INITIAL 0.
    DEFINE VAR lReConteoTotal AS INT INITIAL 0.
    DEFINE VAR lReConteoAvance AS INT INITIAL 0.
    DEFINE VAR l3erConteoTotal AS INT INITIAL 0.
    DEFINE VAR l3erConteoAvance AS INT INITIAL 0.

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
&Scoped-define INTERNAL-TABLES tt-AlmDInv

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-AlmDInv.CodAlm tt-AlmDInv.CodUbi ~
tt-AlmDInv.QtyFisico tt-AlmDInv.QtyConteo tt-AlmDInv.Libre_c01 ~
tt-AlmDInv.NroPagina tt-AlmDInv.QtyReconteo tt-AlmDInv.Libre_c02 ~
tt-AlmDInv.Libre_d01 tt-AlmDInv.Libre_d02 tt-AlmDInv.Libre_c03 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY tt-AlmDInv.CodAlm ~
       BY tt-AlmDInv.CodUbi
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-AlmDInv WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY tt-AlmDInv.CodAlm ~
       BY tt-AlmDInv.CodUbi.
&Scoped-define TABLES-IN-QUERY-br_table tt-AlmDInv
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-AlmDInv


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnImpReconteo btnExcelAvance txt-codalm ~
txt-page-1 txt-page-2 btn-consulta btn-Excel BUTTON-1 btn-exit-2 br_table ~
btnExcelAvance-2 RECT-67 RECT-68 
&Scoped-Define DISPLAYED-OBJECTS txtExcelAvance txt-codalm txt-page-1 ~
txt-page-2 txtConteoTotal txtConteoAvance txtConteoPor txtReConteoTotal ~
txtReConteoAvance txtReConteoPor txt3erConteoTotal txt3erConteoAvance ~
txt3erConteoPor 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD favance B-table-Win 
FUNCTION favance RETURNS DECIMAL
  ( INPUT pTotal AS DEC, INPUT pAvanze AS DEC)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-consulta 
     IMAGE-UP FILE "IMG/pvbrowd.bmp":U
     LABEL "Button 10" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btn-exit-2 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "btn exit 2" 
     SIZE 9 BY 1.88.

DEFINE BUTTON btnExcelAvance 
     LABEL "..." 
     SIZE 3.14 BY .73.

DEFINE BUTTON btnExcelAvance-2 
     LABEL "Blanquear Excel Avance" 
     SIZE 18.29 BY .73.

DEFINE BUTTON btnImpReconteo 
     LABEL "Ir a Impimir Marbetes" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE txt-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-page-1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt-page-2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt3erConteoAvance AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txt3erConteoPor AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txt3erConteoTotal AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtConteoAvance AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtConteoPor AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .81 NO-UNDO.

DEFINE VARIABLE txtConteoTotal AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtExcelAvance AS CHARACTER FORMAT "X(256)":U 
     LABEL "Excel del Avance" 
     VIEW-AS FILL-IN 
     SIZE 60.57 BY .81 NO-UNDO.

DEFINE VARIABLE txtReConteoAvance AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE txtReConteoPor AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE txtReConteoTotal AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 3.5.

DEFINE RECTANGLE RECT-68
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 14.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-AlmDInv SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-AlmDInv.CodAlm FORMAT "x(3)":U WIDTH 6.29
      tt-AlmDInv.CodUbi FORMAT "x(6)":U WIDTH 7.14
      tt-AlmDInv.QtyFisico COLUMN-LABEL "Nro.Articulos" FORMAT "->>>,>>>,>>9":U
            WIDTH 8.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 2 COLUMN-FONT 6
      tt-AlmDInv.QtyConteo FORMAT "->>>,>>>,>>9":U WIDTH 5.43 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.Libre_c01 COLUMN-LABEL "%Conteo" FORMAT "x(60)":U
            WIDTH 7 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.NroPagina COLUMN-LABEL "Art.Reconteo" FORMAT "->,>>>,>>9":U
            COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.QtyReconteo COLUMN-LABEL "Reconteos" FORMAT "->>>,>>>,>>9":U
            WIDTH 7.57 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.Libre_c02 COLUMN-LABEL "%Reconteo" FORMAT "x(60)":U
            WIDTH 8 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.Libre_d01 COLUMN-LABEL "Art.3erConteo" FORMAT "->>>,>>>,>>9":U
            WIDTH 9.43 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.Libre_d02 COLUMN-LABEL "3erConteo" FORMAT "->>>,>>>,>>9":U
            WIDTH 7.86 COLUMN-BGCOLOR 15 COLUMN-FONT 6
      tt-AlmDInv.Libre_c03 COLUMN-LABEL "%3erConteo" FORMAT "x(60)":U
            WIDTH 8.29 COLUMN-BGCOLOR 15 COLUMN-FONT 6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 94.86 BY 14
         FONT 4
         TITLE "Avance por Zonas".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnImpReconteo AT ROW 21.23 COL 68 WIDGET-ID 102
     btnExcelAvance AT ROW 3.73 COL 76.43 WIDGET-ID 98
     txtExcelAvance AT ROW 3.69 COL 13.43 COLON-ALIGNED WIDGET-ID 96
     txt-codalm AT ROW 1.54 COL 12 COLON-ALIGNED WIDGET-ID 30
     txt-page-1 AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 58
     txt-page-2 AT ROW 2.62 COL 26 COLON-ALIGNED WIDGET-ID 60
     btn-consulta AT ROW 1.58 COL 73 WIDGET-ID 8
     btn-Excel AT ROW 1.65 COL 86 WIDGET-ID 20
     BUTTON-1 AT ROW 1.54 COL 62 WIDGET-ID 62
     txtConteoTotal AT ROW 20.12 COL 15.72 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     btn-exit-2 AT ROW 20.81 COL 87.57 WIDGET-ID 52
     br_table AT ROW 5 COL 3.14
     txtConteoAvance AT ROW 21.08 COL 15.72 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     txtConteoPor AT ROW 22 COL 15.72 COLON-ALIGNED NO-LABEL WIDGET-ID 68
     txtReConteoTotal AT ROW 20.12 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     txtReConteoAvance AT ROW 21.08 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 70
     txtReConteoPor AT ROW 22 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     txt3erConteoTotal AT ROW 20.12 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     txt3erConteoAvance AT ROW 21.08 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     txt3erConteoPor AT ROW 22 COL 47 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     btnExcelAvance-2 AT ROW 3.73 COL 79.86 WIDGET-ID 100
     "Total Registros" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 20.31 COL 5 WIDGET-ID 82
     "Avance" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 21.27 COL 5 WIDGET-ID 84
     "% Avance" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 22.15 COL 5 WIDGET-ID 86
     "C O N T E O" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 19.5 COL 18 WIDGET-ID 88
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "R E C O N T E O" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 19.46 COL 33 WIDGET-ID 90
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "3er C O N T E O" VIEW-AS TEXT
          SIZE 13.86 BY .5 AT ROW 19.46 COL 49.14 WIDGET-ID 92
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Zona" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 2.77 COL 3.57 WIDGET-ID 94
     RECT-67 AT ROW 1.27 COL 2 WIDGET-ID 32
     RECT-68 AT ROW 4.77 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-AlmDInv T "?" NO-UNDO INTEGRAL AlmDInv
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
         HEIGHT             = 22.23
         WIDTH              = 98.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table btn-exit-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN txt3erConteoAvance IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt3erConteoPor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt3erConteoTotal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtConteoAvance IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtConteoPor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtConteoTotal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtExcelAvance IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtReConteoAvance IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtReConteoPor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtReConteoTotal IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-AlmDInv"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "Temp-Tables.tt-AlmDInv.CodAlm|yes,Temp-Tables.tt-AlmDInv.CodUbi|yes"
     _FldNameList[1]   > Temp-Tables.tt-AlmDInv.CodAlm
"tt-AlmDInv.CodAlm" ? ? "character" ? ? ? ? ? ? no ? no no "6.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-AlmDInv.CodUbi
"tt-AlmDInv.CodUbi" ? ? "character" ? ? ? ? ? ? no ? no no "7.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-AlmDInv.QtyFisico
"tt-AlmDInv.QtyFisico" "Nro.Articulos" "->>>,>>>,>>9" "decimal" 2 0 6 ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-AlmDInv.QtyConteo
"tt-AlmDInv.QtyConteo" ? "->>>,>>>,>>9" "decimal" 15 ? 6 ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-AlmDInv.Libre_c01
"tt-AlmDInv.Libre_c01" "%Conteo" ? "character" 15 ? 6 ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-AlmDInv.NroPagina
"tt-AlmDInv.NroPagina" "Art.Reconteo" ? "integer" 15 ? 6 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-AlmDInv.QtyReconteo
"tt-AlmDInv.QtyReconteo" "Reconteos" "->>>,>>>,>>9" "decimal" 15 ? 6 ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-AlmDInv.Libre_c02
"tt-AlmDInv.Libre_c02" "%Reconteo" ? "character" 15 ? 6 ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-AlmDInv.Libre_d01
"tt-AlmDInv.Libre_d01" "Art.3erConteo" "->>>,>>>,>>9" "decimal" 15 ? 6 ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-AlmDInv.Libre_d02
"tt-AlmDInv.Libre_d02" "3erConteo" "->>>,>>>,>>9" "decimal" 15 ? 6 ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-AlmDInv.Libre_c03
"tt-AlmDInv.Libre_c03" "%3erConteo" ? "character" 15 ? 6 ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Avance por Zonas */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Avance por Zonas */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Avance por Zonas */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-consulta B-table-Win
ON CHOOSE OF btn-consulta IN FRAME F-Main /* Button 10 */
DO:
    ASSIGN 
        txt-codalm        
        txt-page-1
        txt-page-2
        txtExcelAvance.
    SESSION:SET-WAIT-STATE('GENERAL').    
    RUN Carga-Temporal.
    RUN adm-open-query.   

    txtConteoTotal:SCREEN-VALUE = STRING(lConteoTotal,">,>>>,>>9").
    txtConteoAvance:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = STRING(lConteoAvance,">,>>>,>>9").
    txtConteoPor:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = STRING((lConteoAvance / lConteoTotal) * 100,">>9.99").
    txtReConteoTotal:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = STRING(lReConteoTotal,">,>>>,>>9").
    txtReConteoAvance:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = STRING(lReConteoAvance,">,>>>,>>9").
    txtReConteoPor:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = STRING((lReConteoAvance / lReConteoTotal) * 100,">>9.99").
    txt3erConteoTotal:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = STRING(l3erConteoTotal,">,>>>,>>9").
    txt3erConteoAvance:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = STRING(l3erConteoAvance,">,>>>,>>9").
    txt3erConteoPor:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = STRING((l3erConteoAvance / l3erConteoTotal) * 100,">>9.99") .

    ASSIGN txtConteoTotal txtReConteoTotal txt3erConteoTotal
        txtConteoAvance txtReConteoAvance txt3erConteoAvance
        txtConteoPor txtReConteoPor txt3erConteoPor.

    IF txtExcelAvance <> "" THEN  DO:
        RUN um-avance-excel.
    END.


    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel B-table-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO:
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit-2 B-table-Win
ON CHOOSE OF btn-exit-2 IN FRAME F-Main /* btn exit 2 */
DO:
  RUN adm-exit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcelAvance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcelAvance B-table-Win
ON CHOOSE OF btnExcelAvance IN FRAME F-Main /* ... */
DO:
  
    DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
    DEFINE VARIABLE txtFile AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE TxtFile
        FILTERS "Archivos Excel (*.xls?)" "*.xls?", "Todos (*.*)" "*.*"
        TITLE "Archivo(s) de Carga..."
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = FALSE THEN RETURN.

    IF txtFile = ? OR txtFile = ""  THEN RETURN.

    txtExcelAvance:SCREEN-VALUE = txtFile.

    ASSIGN txtExcelAvance.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExcelAvance-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcelAvance-2 B-table-Win
ON CHOOSE OF btnExcelAvance-2 IN FRAME F-Main /* Blanquear Excel Avance */
DO:
  
    txtExcelAvance:SCREEN-VALUE = "".
    ASSIGN txtExcelAvance.

   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnImpReconteo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnImpReconteo B-table-Win
ON CHOOSE OF btnImpReconteo IN FRAME F-Main /* Ir a Impimir Marbetes */
DO:
    DEFINE VAR lUbis AS CHAR.
    DEFINE VAR cComa AS CHAR.
    DEFINE VAR iTCont AS INT.
    DEFINE VAR iCont AS INT.
    DEFINE VAR xValor AS CHAR.

    lUbis = "".
    ASSIGN txt-codalm.    

    cComa = "".
    iTCont = 0.
    DO WITH FRAME {&FRAME-NAME}:
          /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
        iTCont = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
        DO iCont = 1 TO iTCont :
              IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(icont) THEN DO:
                      xValor = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.codubi.
                      lUbis = lUbis + cComa + xValor.
                      cComa = ",".
              END.
       END.
    END.

    IF txt-codalm <> "" THEN DO : 
        /*MESSAGE '(' + lUbis + ")" VIEW-AS ALERT-BOX ERROR.*/
        /*RUN alm\r-implistarec (input txt-codalm, INPUT lUbis).*/
        xValor = txt-codalm + "*" + lUbis.
        RUN alm\r-implistarec (input xValor).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Almacenes AS CHAR.
    x-Almacenes = txt-CodAlm:SCREEN-VALUE.
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    txt-CodAlm:SCREEN-VALUE = x-Almacenes.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-AlmdInv:
        DELETE tt-AlmdInv.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion B-table-Win 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    DEFINE VAR L-Ubica AS LOGICAL INIT YES.       

    REPEAT WHILE L-Ubica:
           s-task-no = RANDOM(900000,999999).
           FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
           IF NOT AVAILABLE w-report THEN L-Ubica = NO.
    END.

    FOR EACH tt-AlmDInv NO-LOCK
        BREAK BY tt-AlmDInv.NroPagina 
            BY tt-AlmDInv.NroSecuencia:

        FIND FIRST almacen WHERE almacen.codcia = tt-almdinv.codcia
            AND almacen.codalm = tt-almdinv.codalm NO-LOCK NO-ERROR.

        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no
            w-report.Llave-I    = tt-AlmDInv.CodCia
            w-report.Campo-I[1] = tt-AlmDInv.NroPagina
            w-report.Campo-I[2] = tt-AlmDInv.NroSecuencia
            w-report.Campo-C[1] = tt-AlmDInv.CodAlm
            w-report.Campo-C[2] = tt-AlmDInv.CodUbi
            w-report.Campo-C[3] = tt-AlmDInv.CodMat
            w-report.Campo-C[5] = "Almacen: " + tt-AlmDInv.CodAlm + "-" + Almacen.Descripcion
            w-report.Campo-F[1] = tt-AlmDInv.QtyFisico
            w-report.Campo-F[2] = tt-AlmDInv.QtyConteo
            w-report.Campo-F[3] = tt-AlmDInv.QtyReconteo.
            w-report.Campo-F[5] = tt-AlmDInv.libre_d02.
        /*Diferencia*/
        ASSIGN w-report.Campo-F[4] = (tt-AlmDInv.Libre_d01 - tt-AlmDInv.QtyFisico).
        IF tt-AlmDInv.CodUserRec = '' THEN w-report.Campo-C[4] = tt-AlmDInv.CodUserCon.
        ELSE w-report.Campo-C[4] = tt-AlmDInv.CodUserRec.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.
    HIDE FRAME f-proceso.
    */
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
    DEFINE VARIABLE lReconteo AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cAlmc     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCia   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iint      AS INTEGER     NO-UNDO.

    DEFINE VAR lAlmx AS CHARACTER.
    DEFINE VAR lpag AS INT.
    DEFINE VAR lZona AS CHARACTER.

    lConteoTotal        = 0.
    lConteoAvance       = 0.
    lReConteoTotal      = 0.
    lReConteoAvance     = 0.
    l3erConteoTotal     = 0.
    l3erConteoAvance    = 0.

    RUN Borra-Temporal.  

    cNomCia = "CONTI".
    cAlmc   = txt-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DO iint = 1 TO NUM-ENTRIES(cAlmc):
        FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-codcia
            AND AlmCInv.NomCia = cNomCia 
            /*
            AND AlmCInv.NroPagina >= txt-page-1
            AND AlmCInv.NroPagina <= txt-page-2                         
            */
            AND AlmCInv.CodAlm = ENTRY(iint,calmc,",") NO-LOCK NO-ERROR.
        IF NOT AVAIL AlmCInv THEN DO:
            MESSAGE 'Almacén ' + ENTRY(iint,calmc,",")
                    ' no Inventariado   ' SKIP
                    'o número página no encontrada'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.            
        END.
    END.                        

    iint = 0.
    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
        AND AlmCInv.NomCia = cNomCia 
        /*
        AND AlmCInv.NroPagina >= txt-page-1
        AND AlmCInv.NroPagina <= txt-page-2
        */
        AND LOOKUP(TRIM(AlmCInv.CodAlm),cAlmc) > 0 NO-LOCK:        
        
        FOR EACH AlmDInv OF AlmCInv NO-LOCK:

            IF txt-page-1 <> "" AND txt-page-2 <> "" THEN DO:
                IF NOT (almDInv.codubi >= txt-page-1 AND almDInv.codubi <= txt-page-2) THEN NEXT.
            END.
            
            lAlmx = almDInv.codalm.
            lPag = almDInv.nropagina.
            lZona = almDInv.codubi.

            FIND FIRST tt-almdinv WHERE tt-almdinv.codalm = lAlmx AND tt-almdinv.codubi = lZona EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE tt-almdinv THEN DO:
                iint = iint + 1.
                CREATE tt-almdinv NO-ERROR.
                ASSIGN tt-almDInv.codalm = lAlmx
                        tt-almDInv.codubi = lZona
                        tt-almDInv.QtyFisico = 0
                        tt-almDInv.QtyConteo = 0
                        tt-almDInv.NroPagina = 0
                        tt-almDInv.QtyReconteo = 0
                        tt-almDInv.libre_d01 = 0
                        tt-almDInv.libre_d02 = 0
                        tt-almDInv.libre_c01 = "  0.00"
                        tt-almDInv.libre_c02 = "  0.00"
                        tt-almDInv.libre_c03 = "  0.00"
                        tt-almDInv.nrosecuencia = iint.
            END.
            /* Conteo */
            lConteoTotal = lConteoTotal + 1.
            ASSIGN tt-almDInv.QtyFisico = tt-almDInv.QtyFisico  + 1.
            IF almDInv.codusercon <> ? AND almDInv.codusercon <> "" THEN DO:
                ASSIGN tt-almDInv.QtyConteo = tt-almDInv.QtyConteo + 1.
                lConteoAvance = lConteoAvance + 1.
            END.
            IF tt-almDInv.QtyFisico > 0 THEN DO:
                ASSIGN tt-almDInv.libre_c01 = STRING((tt-almDInv.QtyConteo / tt-almDInv.QtyFisico ) * 100,">>9.99").
            END.
            /* Reconteo */
            IF almDInv.libre_c04 <> ? AND almDInv.libre_c04 <> "" THEN DO:
                lReConteoTotal = lReConteoTotal + 1.
                ASSIGN tt-almDInv.nropagina = tt-almDInv.nropagina + 1.
                IF almDInv.coduserrec <> ? AND almDInv.coduserrec <> "" THEN DO:
                    lReConteoAvance = lReConteoAvance + 1.
                    ASSIGN tt-almDInv.qtyreconteo = tt-almDInv.qtyreconteo + 1.
                    ASSIGN tt-almDInv.libre_c02 = 
                        STRING((tt-almDInv.qtyreconteo / tt-almDInv.nropagina) * 100,">>9.99").
                END.
            END.
            /* 3er Conteo */
            IF almDInv.libre_c05 <> ? AND almDInv.libre_c05 <> "" THEN DO:
                l3erConteoTotal = l3erConteoTotal + 1.
                ASSIGN tt-almDInv.libre_d01 = tt-almDInv.libre_d01 + 1.
                IF almDInv.libre_c01 <> ? AND almDInv.libre_c01 <> "" THEN DO:
                    l3erConteoAvance = l3erConteoAvance + 1.
                    ASSIGN tt-almDInv.libre_d01 = tt-almDInv.libre_d01 + 1.
                    ASSIGN tt-almDInv.libre_c03 = 
                        STRING((tt-almDInv.libre_d02 / tt-almDInv.libre_d01) * 100,">>9.99").
                END.
            END.
        END.
        
    END.        
    
    HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-TemporalDif B-table-Win 
PROCEDURE Carga-TemporalDif :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VARIABLE lReconteo AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lDif      AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cNomCia   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAlmc     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iint AS INTEGER     NO-UNDO.

    RUN Borra-Temporal.  

    cNomCia = "CONTI".
    cAlmc   = txt-CodAlm:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    DO iint = 1 TO NUM-ENTRIES(cAlmc):
        FIND FIRST AlmCInv WHERE AlmCInv.CodCia = s-codcia
            AND AlmCInv.NomCia = cNomCia 
            AND AlmCInv.NroPagina >= txt-page-1
            AND AlmCInv.NroPagina <= txt-page-2
            AND AlmCInv.CodAlm = ENTRY(iint,calmc,",") NO-LOCK NO-ERROR.
        IF NOT AVAIL AlmCInv THEN DO:
            MESSAGE 'Almacén ' + ENTRY(iint,calmc,",")
                    ' no Inventariado   ' SKIP
                    'o número página no encontrada'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.            
        END.
    END.                        

    FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
        AND LOOKUP(TRIM(AlmCInv.CodAlm),cAlmc) > 0
        AND AlmCInv.NroPagina >= txt-page-1
        AND AlmCInv.NroPagina <= txt-page-2
        AND AlmCInv.NomCia = cNomCia NO-LOCK:
        /*
        FOR EACH AlmDInv OF AlmCInv 
            WHERE AlmDInv.CodMat BEGINS txt-CodMat NO-LOCK:
            IF (almDInv.libre_d01 - AlmDInv.QtyFisico ) = 0 THEN NEXT.
            CREATE tt-AlmDInv.
            BUFFER-COPY AlmDInv TO tt-AlmDInv.
            ASSIGN tt-AlmDInv.DifQty = (AlmDInv.Libre_d01 - AlmDInv.QtyFisico ).
            IF AlmCInv.SwReconteo THEN ASSIGN tt-AlmDInv.CodUserCon =  AlmDInv.CodUserRec.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        END.
        */
    END.
    HIDE FRAME F-Proceso.
*/
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

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-ctopro AS DECIMAL     NO-UNDO.
DEFINE VAR lValor AS INT INIT 0.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "LISTADO DE AVANCE INVENTARIO POR ZONAS".
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.
cRange = "C" + '3'.
chWorkSheet:Range(cRange):Value = "Almacen(es): ".
cRange = "D" + '3'.
chWorkSheet:Range(cRange):Value = txt-CodAlm.


/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".

/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Alm".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicación".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Conteo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Avance Conteo".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "% Avance Conteo".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "ReConteo".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Avance ReConteo".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "% Avance ReConteo".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "3erConteo".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Avance 3erConteo".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "% Avance 3erConteo".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "...".


FOR EACH tmp-tt-AlmDInv NO-LOCK BY tmp-tt-AlmDInv.CodAlm BY tmp-tt-AlmDInv.CodUbi:
    lValor = 0.
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tmp-tt-AlmDInv.CodAlm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tmp-tt-AlmDInv.CodUbi.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.qtyfisico.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.qtyconteo.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c01.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.nropagina.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.qtyreconteo.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c02.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.libre_d01.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_d02.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c03.

    IF (tmp-tt-almDInv.qtyfisico > 0 AND tmp-tt-AlmDInv.qtyconteo >= tmp-tt-almDInv.qtyfisico ) THEN lValor = lValor + 1.
    IF (tmp-tt-almDInv.nropagina > 0 AND tmp-tt-AlmDInv.qtyreconteo >= tmp-tt-almDInv.nropagina ) THEN lValor = lValor + 1.
    IF (tmp-tt-almDInv.libre_d01 > 0 AND tmp-tt-AlmDInv.libre_d02 >= tmp-tt-almDInv.libre_d01 ) THEN lValor = lValor + 1.

    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = lValor.


    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
END.

t-Column = t-Column + 2.
cColumn = STRING(t-Column).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "C O N T E O".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "R E C O N T E O".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "3er C O N T E O".

t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Total Registros".

cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = txtConteoTotal.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = txtReConteoTotal.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = txt3erConteoTotal.
/* Reconteo */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Avances".

cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = txtConteoAvance.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = txtReConteoAvance.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = txt3erConteoAvance.
/* 3er Conteo */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "% Avance".

cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = txtConteoPor.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = txtReConteoPor.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = txt3erConteoPor.




HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
   
  RUN Carga-Impresion.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
  IF imp = 1 THEN RB-REPORT-NAME = 'Listado Final Inventario'.
  ELSE RB-REPORT-NAME = 'Listado Final Inventario Draft'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.               

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

    
  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
  s-task-no = 0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  {src/adm/template/snd-list.i "tt-AlmDInv"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-avance-excel B-table-Win 
PROCEDURE um-avance-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VAR lFIleXls AS CHAR.                                                                                                                    

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

    DEFINE VAR lValor AS INT INIT 0.
    DEFINE VAR t-column AS INT INIT 0.
    DEFINE VAR x-column AS INT INIT 0.

    lFIleXls = txtExcelAvance.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.       

        /* Abrir un EXCEL (es este o el crear un new workbook) */
        chWorkbook = chExcelApplication:Workbooks:OPEN(lFIleXls).

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(2).

        chExcelApplication:Calculation = -4135.
        /*
        REPEAT X-column = 2 TO 65000:
                cColumn = STRING(X-column).
            m.loExcel.Range("A4:N1500").EntireRow.Delete
            END.
        */
/*        chWorkSheet:Range("A2:A2"):SELECT.*/
        chWorkSheet:Range("A2:N2000"):CLEAR.
        t-Column = 1.
        cColumn = STRING(t-Column).
    /*
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "Ubicación".
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "Conteo".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "Avance Conteo".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "% Avance Conteo".
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "ReConteo".
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "Avance ReConteo".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "% Avance ReConteo".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "3erConteo".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "Avance 3erConteo".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "% Avance 3erConteo".
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "Fase".
*/

    Fi-Mensaje = "Actualizandoooo Layaout...".
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

    FOR EACH tmp-tt-AlmDInv NO-LOCK BY tmp-tt-AlmDInv.CodAlm BY tmp-tt-AlmDInv.CodUbi:


        Fi-Mensaje = tmp-tt-AlmDInv.CodUbi.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

        lValor = 0.
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        /*
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tmp-tt-AlmDInv.CodAlm.
        */
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tmp-tt-AlmDInv.CodUbi.
        /*
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.qtyfisico.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.qtyconteo.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c01.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.nropagina.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.qtyreconteo.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c02.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-almDInv.libre_d01.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_d02.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tmp-tt-AlmDInv.libre_c03.
        */
        IF (tmp-tt-almDInv.qtyfisico > 0 AND tmp-tt-AlmDInv.qtyconteo >= tmp-tt-almDInv.qtyfisico ) THEN lValor = lValor + 1.
        IF (tmp-tt-almDInv.nropagina > 0 AND tmp-tt-AlmDInv.qtyreconteo >= tmp-tt-almDInv.nropagina ) THEN lValor = lValor + 1.
        IF (tmp-tt-almDInv.libre_d01 > 0 AND tmp-tt-AlmDInv.libre_d02 >= tmp-tt-almDInv.libre_d01 ) THEN lValor = lValor + 1.

        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = lValor.
        
    END.

    HIDE FRAME F-Proceso.

    /*
    cColumn = "25".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Aquiiii".
    */

    /* ----------------------   */
    /*MESSAGE 'Excel' + lFIleXls  VIEW-AS ALERT-BOX ERROR.*/
    /* ----------------------  */

    chExcelApplication:Calculation = -4105.
   
    chWorkSheet:SaveAs(lFIleXls).
    chExcelApplication:DisplayAlerts = False.
    /*
        chWorkSheet:SaveAs("d:\ciman\file.xls").
    */     
        chExcelApplication:Quit().
   
        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION favance B-table-Win 
FUNCTION favance RETURNS DECIMAL
  ( INPUT pTotal AS DEC, INPUT pAvanze AS DEC) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR lpAva AS DEC.

    lpAva = IF (pTotal>0) THEN ((pAvanze / pTotal) * 100 ) ELSE 0.

  RETURN lpAva.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

