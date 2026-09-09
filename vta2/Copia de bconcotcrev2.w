&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER DETALLE FOR FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEF VAR x-Estado AS CHAR NO-UNDO.

/* Preprocesadores para cada campo filtro */
&SCOPED-DEFINE FILTRO1 ( Faccpedi.NomCli BEGINS FILL-IN-NomCli )
&SCOPED-DEFINE FILTRO2 ( INDEX ( Faccpedi.NomCli , FILL-IN-NomCli ) <> 0 )

DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.

DEF VAR pPorcAvance     AS DEC NO-UNDO.
DEF VAR pTotItems       AS INT NO-UNDO.
DEF VAR pTotPeso        AS DEC NO-UNDO.
DEF VAR pImpAtendido    AS DEC NO-UNDO.
DEF VAR pImpxAtender    AS DEC NO-UNDO.
DEF VAR pFlgEst         AS CHAR INIT 'Todos' NO-UNDO.

&SCOPED-DEFINE Condicion FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "COT" ~
 AND (x-CodDiv = 'Todas' OR FacCPedi.CodDiv = x-CodDiv) ~
 AND FacCPedi.FchPed >= FILL-IN-FchPed-1 ~
 AND FacCPedi.FchPed <= FILL-IN-FchPed-2 ~
 AND (TOGGLE-1 = YES OR LOOKUP(FacCPedi.FlgEst, "A,V") = 0) ~
 AND (pFlgEst = "Todos" OR FacCPedi.FlgEst = pFlgEst) ~
 AND (FILL-IN-NroPed = '' OR FacCPedi.NroPed = FILL-IN-NroPed) ~
 AND (FILL-IN-CodVen = '' OR FacCPedi.CodVen = FILL-IN-CodVen) ~
 AND ( FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli)

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
&Scoped-define INTERNAL-TABLES FacCPedi FacDPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDiv FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.fchven FacCPedi.FchEnt FacCPedi.NomCli ~
FacCPedi.CodVen FacCPedi.ImpTot _FlgEst() @ x-Estado ~
fPorcAvance() @ pPorcAvance fTotItems() @ pTotItems fTotPeso() @ pTotPeso ~
fImpAtendido() @ pImpAtendido fImpxAtender() @ pImpxAtender 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE (RADIO-SET-FlgEst <> "PP" OR FacDPedi.canate > 0) NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE (RADIO-SET-FlgEst <> "PP" OR FacDPedi.canate > 0) NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi FacDPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacDPedi


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodDiv RADIO-SET-FlgEst BUTTON-1 ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 COMBO-BOX-Filtro FILL-IN-NomCli ~
FILL-IN-NroPed FILL-IN-CodVen BUTTON-Excel RADIO-SET-Excel FILL-IN-CodCli ~
TOGGLE-1 br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv RADIO-SET-FlgEst FILL-IN-FchPed-1 ~
FILL-IN-FchPed-2 COMBO-BOX-Filtro FILL-IN-NomCli FILL-IN-NroPed ~
FILL-IN-CodVen FILL-IN-NomVen RADIO-SET-Excel FILL-IN-CodCli FILL-IN-DesCli ~
TOGGLE-1 

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
Nombres que inicien con|y||INTEGRAL.FacCPedi.NomCli
Nombres que contengan|y||INTEGRAL.FacCPedi.NomCli
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "Nombres que inicien con,Nombres que contengan",
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotItems B-table-Win 
FUNCTION fTotItems RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTotPeso B-table-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /*INPUT pFlgEst AS CHAR*/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 7" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Filtro AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtro por Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Nombres que inicien con","Nombres que contengan" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División Origen" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 68 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(9)":U 
     LABEL "Nro. Cotización" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Excel AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Cabeceras", 1,
"Cabecera + Detalle", 2
     SIZE 20 BY 1.54 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgEst AS CHARACTER INITIAL "Todos" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "Todos",
"Pendiente", "P",
"En Proceso", "PP",
"Atendida Total", "C",
"Cerrada Manualmente", "X",
"Saldo Transferido", "ST"
     SIZE 21 BY 3.65 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Mostrar ANULADOS y VENCIDOS" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      FacDPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDiv COLUMN-LABEL "Div. Origen" FORMAT "x(5)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U WIDTH 10.57
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/99":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/99":U
      FacCPedi.FchEnt FORMAT "99/99/99":U
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(50)":U
      FacCPedi.CodVen FORMAT "x(10)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      _FlgEst() @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(20)":U
            WIDTH 19.29
      fPorcAvance() @ pPorcAvance COLUMN-LABEL "% Avance"
      fTotItems() @ pTotItems COLUMN-LABEL "Total de Items" FORMAT ">,>>9":U
      fTotPeso() @ pTotPeso COLUMN-LABEL "Total Peso Kg." FORMAT ">>>,>>9.99":U
      fImpAtendido() @ pImpAtendido COLUMN-LABEL "Import. Atendido" FORMAT "->>>>>,>>9.99":U
      fImpxAtender() @ pImpxAtender COLUMN-LABEL "Import. por Atender" FORMAT "->>>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 144 BY 6.92
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.19 COL 15 COLON-ALIGNED WIDGET-ID 22
     RADIO-SET-FlgEst AT ROW 1.19 COL 87 NO-LABEL WIDGET-ID 32
     BUTTON-1 AT ROW 1.19 COL 112 WIDGET-ID 50
     FILL-IN-FchPed-1 AT ROW 1.96 COL 15 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchPed-2 AT ROW 1.96 COL 39 COLON-ALIGNED WIDGET-ID 28
     COMBO-BOX-Filtro AT ROW 2.73 COL 15 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NomCli AT ROW 2.73 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     FILL-IN-NroPed AT ROW 3.5 COL 15 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-CodVen AT ROW 4.27 COL 15 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NomVen AT ROW 4.27 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     BUTTON-Excel AT ROW 4.27 COL 114 WIDGET-ID 52
     RADIO-SET-Excel AT ROW 4.27 COL 120 NO-LABEL WIDGET-ID 54
     FILL-IN-CodCli AT ROW 5.04 COL 15 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-DesCli AT ROW 5.04 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     TOGGLE-1 AT ROW 5.04 COL 86 WIDGET-ID 30
     br_table AT ROW 6 COL 1
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
      TABLE: DETALLE B "?" ? INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 12.08
         WIDTH              = 144.86.
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
/* BROWSE-TAB br_table TOGGLE-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR FILL-IN FILL-IN-DesCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _Where[2]         = "(RADIO-SET-FlgEst <> ""PP"" OR FacDPedi.canate > 0)"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" "Div. Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.FacCPedi.CodVen
     _FldNameList[8]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"_FlgEst() @ x-Estado" "Estado" "x(20)" ? ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fPorcAvance() @ pPorcAvance" "% Avance" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"fTotItems() @ pTotItems" "Total de Items" ">,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"fTotPeso() @ pTotPeso" "Total Peso Kg." ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"fImpAtendido() @ pImpAtendido" "Import. Atendido" "->>>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"fImpxAtender() @ pImpxAtender" "Import. por Atender" "->>>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
    /*RUN vta/d-conpedcremos (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).*/
    /*RUN vta2/dcotizacionesypedidos (Faccpedi.coddoc, Faccpedi.nroped).*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  
  IF AVAILABLE Faccpedi 
  THEN ASSIGN 
      s-CodCli = Faccpedi.codcli
      s-CodDoc = Faccpedi.coddoc
      s-NroPed = Faccpedi.nroped.
  ELSE ASSIGN
      s-CodCli = ?
      s-CodDoc = ?
      s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Limpiar Filtros */
DO:
  ASSIGN
      x-CodDiv = 'Todas'
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY
      RADIO-SET-FlgEst = 'Todos'
      COMBO-BOX-Filtro = 'Todos'
      FILL-IN-CodCli = ''
      FILL-IN-CodVen = ''
      FILL-IN-DesCli = ''
      FILL-IN-NomCli = ''
      FILL-IN-NomVen = ''
      FILL-IN-NroPed = ''
      TOGGLE-1 = NO.
  DISPLAY
      x-CodDiv
      FILL-IN-FchPed-1
      FILL-IN-FchPed-2
      RADIO-SET-FlgEst
      COMBO-BOX-Filtro
      FILL-IN-CodCli 
      FILL-IN-CodVen 
      FILL-IN-DesCli 
      FILL-IN-NomCli 
      FILL-IN-NomVen 
      FILL-IN-NroPed 
      TOGGLE-1
      WITH FRAME {&FRAME-NAME}.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Filtro.
  APPLY 'VALUE-CHANGED':U TO RADIO-SET-FlgEst.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel B-table-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 7 */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  ASSIGN RADIO-SET-Excel.
  CASE RADIO-SET-Excel:
      WHEN 1 THEN RUN Excel-solo-cabecera.
      WHEN 2 THEN RUN Excel-cabecera-detalle.
  END CASE.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Filtro B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Filtro IN FRAME F-Main /* Filtro por Cliente */
DO:
    IF COMBO-BOX-Filtro = COMBO-BOX-Filtro:SCREEN-VALUE 
        AND FILL-IN-NomCli = FILL-IN-NomCli:SCREEN-VALUE THEN RETURN.
    ASSIGN
        FILL-IN-NomCli
        COMBO-BOX-filtro.
    IF COMBO-BOX-filtro = "Todos" THEN RUN set-attribute-list('Key-Name=?').
    ELSE RUN set-attribute-list('Key-Name=' + COMBO-BOX-filtro).
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli B-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
        AND gn-clie.CodCli = INPUT {&self-name}
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN FILL-IN-DesCli:SCREEN-VALUE = gn-clie.NomCli.
    ASSIGN {&self-name} FILL-IN-DesCli.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodVen B-table-Win
ON LEAVE OF FILL-IN-CodVen IN FRAME F-Main /* Vendedor */
DO:
  FIND gn-ven WHERE gn-ven.CodCia = s-codcia
      AND gn-ven.CodVen = INPUT {&self-name}
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ven THEN FILL-IN-NomVen:SCREEN-VALUE = gn-ven.NomVen.
  ASSIGN {&self-name} FILL-IN-NomVen.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-1 B-table-Win
ON LEAVE OF FILL-IN-FchPed-1 IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-2 B-table-Win
ON LEAVE OF FILL-IN-FchPed-2 IN FRAME F-Main /* Emitidos Hasta */
DO:
  
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed B-table-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* Nro. Cotización */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-FlgEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-FlgEst B-table-Win
ON VALUE-CHANGED OF RADIO-SET-FlgEst IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  pFlgEst = {&self-name}.
  IF {&self-name} = "PP" THEN pFlgEst = "P".
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 B-table-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Mostrar ANULADOS y VENCIDOS */
DO:
    ASSIGN {&self-name}.
    RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
    RUN Procesa-Handle IN lh_handle ('Open-Query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDiv B-table-Win
ON VALUE-CHANGED OF x-CodDiv IN FRAME F-Main /* División Origen */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.

  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'Nombres que inicien con':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro1} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que inicien con */
    WHEN 'Nombres que contengan':U THEN DO:
       &Scope KEY-PHRASE ( {&Filtro2} )
       {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* Nombres que contengan */
    OTHERWISE DO:
       &Scope KEY-PHRASE TRUE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-cabecera-detalle B-table-Win 
PROCEDURE Excel-cabecera-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
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
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Número".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("G1"):VALUE = "Vendedor".
chWorkSheet:Range("H1"):VALUE = "Importe".
chWorkSheet:Range("I1"):VALUE = "Estado".
chWorkSheet:Range("J1"):VALUE = "% Avance".
chWorkSheet:Range("K1"):VALUE = "Total de Items".
chWorkSheet:Range("L1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("M1"):VALUE = "Import. Atendido".
chWorkSheet:Range("N1"):VALUE = "Import. por Atender".
chWorkSheet:Range("O1"):VALUE = "No".
chWorkSheet:Range("P1"):VALUE = "Articulo".
chWorkSheet:COLUMNS("P"):NumberFormat = "@".
chWorkSheet:Range("Q1"):VALUE = "Descripción".
chWorkSheet:Range("R1"):VALUE = "Marca".
chWorkSheet:Range("S1"):VALUE = "Unidad".
chWorkSheet:Range("T1"):VALUE = "Cantidad Aprobada".
chWorkSheet:Range("U1"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("V1"):VALUE = "Precio Unitario".
chWorkSheet:Range("W1"):VALUE = "% Dscto Manual".
chWorkSheet:Range("X1"):VALUE = "% Dscto Evento".
chWorkSheet:Range("Y1"):VALUE = "% Dscto Vol/Prom".
chWorkSheet:Range("Z1"):VALUE = "Importe".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Faccpedi:
    FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
        t-Column = 1.
        t-Row = t-Row + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchent.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fTotItems().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.nroitm.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.codmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.desmar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.undvta.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.canped.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.canate.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.preuni.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[1].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[2].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.por_dscto[3].
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = DETALLE.implin.
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-solo-cabecera B-table-Win 
PROCEDURE Excel-solo-cabecera :
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

DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Div. Origen".
chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:Range("B1"):VALUE = "Número".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:Range("C1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("C"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("D1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("G1"):VALUE = "Vendedor".
chWorkSheet:Range("H1"):VALUE = "Importe".
chWorkSheet:Range("I1"):VALUE = "Estado".
chWorkSheet:Range("J1"):VALUE = "% Avance".
chWorkSheet:Range("K1"):VALUE = "Total de Items".
chWorkSheet:Range("L1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("M1"):VALUE = "Import. Atendido".
chWorkSheet:Range("N1"):VALUE = "Import. por Atender".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE Faccpedi:
    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nroped.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchped.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchven.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.fchent.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.nomcli.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.codven.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.imptot.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fTotItems().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().

    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE('open-query-cases':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

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
/*   x-CodDiv:DELETE(1) IN FRAME {&FRAME-NAME}. */
  ASSIGN
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY.
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:
      x-CodDiv:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv, gn-divi.coddiv).
  END.
/*   FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:      */
/*       x-DivDes:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv, gn-divi.coddiv). */
/*   END.                                                                            */
/*   x-CodDiv = s-CodDiv. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'value-changed' TO {&browse-name} IN FRAME {&FRAME-NAME}.
  /*
  IF AVAILABLE Faccpedi THEN s-NroPed = Faccpedi.nroped.
  ELSE s-NroPed = ?.
  RUN Procesa-Handle IN lh_handle ('Open-Query-2':U).
  */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-Cotizacion B-table-Win 
PROCEDURE Numero-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pNroCot AS CHAR.

IF AVAILABLE Faccpedi THEN pNroCot = Faccpedi.nroped.
ELSE pNroCot = ?.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "FacDPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpAtendido B-table-Win 
FUNCTION fImpAtendido RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xImpAte AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpAte.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImpxAtender B-table-Win 
FUNCTION fImpxAtender RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR xImpAte AS DEC NO-UNDO.
    DEF VAR xImpTot AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpTot = xImpTot + Facdpedi.ImpLin.
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte.
  END.

  RETURN xImpTot - xImpAte.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPorcAvance B-table-Win 
FUNCTION fPorcAvance RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xPorcAvance AS DEC NO-UNDO.
  DEF VAR xImpPed AS DEC NO-UNDO.
  DEF VAR xImpAte AS DEC NO-UNDO.


  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpPed = xImpPed + Facdpedi.ImpLin
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte
          xPorcAvance = xImpAte / xImpPed * 100.
  END.

  RETURN xPorcAvance.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotItems B-table-Win 
FUNCTION fTotItems RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR xTotItems AS INTE NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xTotItems = xTotItems + 1.
  END.

  RETURN xTotItems.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTotPeso B-table-Win 
FUNCTION fTotPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

        
  DEF VAR xTotPeso AS DEC.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      ASSIGN
          xTotPeso = xTotPeso + Facdpedi.canPed * Facdpedi.factor * Almmmatg.PesMat.
  END.
  RETURN xTotPeso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _FlgEst B-table-Win 
FUNCTION _FlgEst RETURNS CHARACTER
  ( /*INPUT pFlgEst AS CHAR*/ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

/*RUN vta2/p-faccpedi-flgest (Faccpedi.FlgEst, Faccpedi.CodDoc, OUTPUT pEstado).*/
RUN vta2/p-faccpedi-flgestv2 (ROWID(Faccpedi), OUTPUT pEstado).

RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

