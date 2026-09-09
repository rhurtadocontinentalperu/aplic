&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE COTIZACION LIKE FacCPedi.
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
 AND (FILL-IN-NroPed = '' OR FacCPedi.NroPed = FILL-IN-NroPed) ~
 AND (FILL-IN-CodVen = '' OR FacCPedi.CodVen = FILL-IN-CodVen) ~
 AND ( FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-FchEnt-1 = ? OR FacCPedi.FchPed >= FILL-IN-FchEnt-1) ~
 AND (FILL-IN-FchEnt-2 = ? OR FacCPedi.FchPed <= FILL-IN-FchEnt-2) ~
 AND (x-Lista = 'Todas' OR Faccpedi.libre_c01 = x-Lista) ~
 AND (FILL-IN-NomCli = '' OR INDEX(Faccpedi.nomcli, FILL-IN-NomCli) > 0 )

/*
&SCOPED-DEFINE Condicion FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = "COT" ~
 AND (x-CodDiv = 'Todas' OR FacCPedi.CodDiv = x-CodDiv) ~
 AND FacCPedi.FchPed >= FILL-IN-FchPed-1 ~
 AND FacCPedi.FchPed <= FILL-IN-FchPed-2 ~
 AND (TOGGLE-1 = YES OR LOOKUP(FacCPedi.FlgEst, "A,V") = 0) ~
 AND (pFlgEst = "Todos" OR FacCPedi.FlgEst = pFlgEst) ~
 AND (FILL-IN-NroPed = '' OR FacCPedi.NroPed = FILL-IN-NroPed) ~
 AND (FILL-IN-CodVen = '' OR FacCPedi.CodVen = FILL-IN-CodVen) ~
 AND ( FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-FchEnt-1 = ? OR FacCPedi.FchPed >= FILL-IN-FchEnt-1) ~
 AND (FILL-IN-FchEnt-2 = ? OR FacCPedi.FchPed <= FILL-IN-FchEnt-2) ~
 AND (x-Lista = 'Todas' OR Faccpedi.libre_c01 = x-Lista) ~
 AND (FILL-IN-NomCli = '' OR INDEX(Faccpedi.nomcli, FILL-IN-NomCli) > 0 )

*/


DEF BUFFER tt-faccpedi FOR faccpedi.

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
&Scoped-define INTERNAL-TABLES COTIZACION FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.CodDiv FacCPedi.Libre_c01 ~
FacCPedi.NroPed FacCPedi.LugEnt2 FacCPedi.FchPed FacCPedi.fchven ~
FacCPedi.FchEnt FacCPedi.CodCli FacCPedi.NomCli FacCPedi.CodVen ~
FacCPedi.ImpTot COTIZACION.Libre_c02 COTIZACION.Libre_d01 ~
COTIZACION.AcuBon[2] COTIZACION.AcuBon[3] COTIZACION.AcuBon[4] ~
COTIZACION.AcuBon[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacCPedi.LugEnt2 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacCPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define QUERY-STRING-br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} ~
      AND (RADIO-SET-FlgEst = "Todos" OR COTIZACION.FlgEst = RADIO-SET-FlgEst) NO-LOCK, ~
      FIRST FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH COTIZACION WHERE ~{&KEY-PHRASE} ~
      AND (RADIO-SET-FlgEst = "Todos" OR COTIZACION.FlgEst = RADIO-SET-FlgEst) NO-LOCK, ~
      FIRST FacCPedi OF COTIZACION NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table COTIZACION FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table COTIZACION
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 RECT-20 x-CodDiv RADIO-SET-FlgEst ~
BUTTON-18 BUTTON-Excel x-Lista BUTTON-1 FILL-IN-FchPed-1 FILL-IN-FchPed-2 ~
RADIO-SET-Excel FILL-IN-FchEnt-1 FILL-IN-FchEnt-2 FILL-IN-NroPed TOGGLE-1 ~
FILL-IN-CodVen btnActivaPtoSalida FILL-IN-CodCli FILL-IN-NomCli br_table 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv RADIO-SET-FlgEst x-Lista ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 RADIO-SET-Excel FILL-IN-FchEnt-1 ~
FILL-IN-FchEnt-2 FILL-IN-NroPed TOGGLE-1 FILL-IN-CodVen FILL-IN-NomVen ~
FILL-IN-CodCli FILL-IN-NomCli 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
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
CodDiv|y||INTEGRAL.FacCPedi.CodDiv|yes,INTEGRAL.FacCPedi.NroPed|no
Libre_c01|||INTEGRAL.FacCPedi.Libre_c01|yes,INTEGRAL.FacCPedi.CodDiv|yes,INTEGRAL.FacCPedi.NroPed|no
ImpTot|||INTEGRAL.FacCPedi.ImpTot|no
NroPed|||INTEGRAL.FacCPedi.NroPed|no
LugEnt2|||INTEGRAL.FacCPedi.LugEnt2|yes,INTEGRAL.FacCPedi.NroPed|no
FchPed|||INTEGRAL.FacCPedi.FchPed|yes,INTEGRAL.FacCPedi.NroPed|no
fchven|||INTEGRAL.FacCPedi.fchven|yes,INTEGRAL.FacCPedi.NroPed|no
CodCli|||INTEGRAL.FacCPedi.CodCli|yes,INTEGRAL.FacCPedi.NroPed|no
NomCli|||INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.NroPed|no
Libre_d01|||COTIZACION.Libre_d01|no
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodDiv,Libre_c01,ImpTot,NroPed,LugEnt2,FchPed,fchven,CodCli,NomCli,Libre_d01' + '",
     SortBy-Case = ':U + 'CodDiv').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

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
  ( INPUT pFlgEst AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnActivaPtoSalida 
     LABEL "Activar Punto Salida" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-1 
     LABEL "Limpiar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-18 
     LABEL "Aplicar Filtro" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 7" 
     SIZE 6 BY 1.54.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "División Origen" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 68 BY 1 NO-UNDO.

DEFINE VARIABLE x-Lista AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Lista" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 68 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Por Código de Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodVen AS CHARACTER FORMAT "X(3)":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entregar Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchEnt-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Entregar Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Por Nombre de Cliente" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

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
     SIZE 16 BY 1.54 NO-UNDO.

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

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 127 BY 5.77.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.86 BY 3.65.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Mostrar ANULADOS y VENCIDOS" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      COTIZACION, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.CodDiv COLUMN-LABEL "Origen" FORMAT "x(5)":U
      FacCPedi.Libre_c01 COLUMN-LABEL "Lista**" FORMAT "x(5)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(9)":U WIDTH 9.43
      FacCPedi.LugEnt2 COLUMN-LABEL "PDD" FORMAT "x(3)":U
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
      FacCPedi.fchven COLUMN-LABEL "Vencimiento" FORMAT "99/99/9999":U
      FacCPedi.FchEnt COLUMN-LABEL "Fch Entrega" FORMAT "99/99/9999":U
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 9.86
      FacCPedi.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(50)":U
      FacCPedi.CodVen COLUMN-LABEL "Vend" FORMAT "x(5)":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
      COTIZACION.Libre_c02 COLUMN-LABEL "Estado" FORMAT "x(20)":U
      COTIZACION.Libre_d01 COLUMN-LABEL "% Avance" FORMAT "->,>>9.99":U
      COTIZACION.AcuBon[2] COLUMN-LABEL "Total de Items" FORMAT ">,>>9":U
      COTIZACION.AcuBon[3] COLUMN-LABEL "Total Peso Kg." FORMAT ">>>,>>9.99":U
      COTIZACION.AcuBon[4] COLUMN-LABEL "Import. Atendido" FORMAT "->>>>>,>>9.99":U
      COTIZACION.AcuBon[5] COLUMN-LABEL "Import. por Atender" FORMAT "->>>>>,>>9.99":U
  ENABLE
      FacCPedi.LugEnt2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 144 BY 6.15
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.19 COL 15 COLON-ALIGNED WIDGET-ID 22
     RADIO-SET-FlgEst AT ROW 1.19 COL 87 NO-LABEL WIDGET-ID 32
     BUTTON-18 AT ROW 1.38 COL 110 WIDGET-ID 62
     BUTTON-Excel AT ROW 1.38 COL 134 WIDGET-ID 52
     x-Lista AT ROW 1.96 COL 15 COLON-ALIGNED WIDGET-ID 66
     BUTTON-1 AT ROW 2.54 COL 110 WIDGET-ID 50
     FILL-IN-FchPed-1 AT ROW 2.73 COL 15 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-FchPed-2 AT ROW 2.73 COL 39 COLON-ALIGNED WIDGET-ID 28
     RADIO-SET-Excel AT ROW 2.92 COL 129 NO-LABEL WIDGET-ID 54
     FILL-IN-FchEnt-1 AT ROW 3.5 COL 15 COLON-ALIGNED WIDGET-ID 58
     FILL-IN-FchEnt-2 AT ROW 3.5 COL 39 COLON-ALIGNED WIDGET-ID 60
     FILL-IN-NroPed AT ROW 4.27 COL 15 COLON-ALIGNED WIDGET-ID 40
     TOGGLE-1 AT ROW 4.27 COL 41 WIDGET-ID 30
     FILL-IN-CodVen AT ROW 5.04 COL 15 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NomVen AT ROW 5.04 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 46
     btnActivaPtoSalida AT ROW 5.42 COL 129 WIDGET-ID 64
     FILL-IN-CodCli AT ROW 5.81 COL 15 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-NomCli AT ROW 5.81 COL 50 COLON-ALIGNED WIDGET-ID 48
     br_table AT ROW 6.77 COL 1
     RECT-19 AT ROW 1 COL 1 WIDGET-ID 70
     RECT-20 AT ROW 1 COL 128 WIDGET-ID 72
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
      TABLE: COTIZACION T "SHARED" ? INTEGRAL FacCPedi
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
/* BROWSE-TAB br_table FILL-IN-NomCli F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.COTIZACION,INTEGRAL.FacCPedi OF Temp-Tables.COTIZACION"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "(RADIO-SET-FlgEst = ""Todos"" OR Temp-Tables.COTIZACION.FlgEst = RADIO-SET-FlgEst)"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" "Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.Libre_c01
"FacCPedi.Libre_c01" "Lista**" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.LugEnt2
"FacCPedi.LugEnt2" "PDD" "x(3)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Vencimiento" "99/99/9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Fch Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.CodVen
"FacCPedi.CodVen" "Vend" "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.COTIZACION.Libre_c02
"COTIZACION.Libre_c02" "Estado" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.COTIZACION.Libre_d01
"COTIZACION.Libre_d01" "% Avance" "->,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.COTIZACION.AcuBon[2]
"COTIZACION.AcuBon[2]" "Total de Items" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.COTIZACION.AcuBon[3]
"COTIZACION.AcuBon[3]" "Total Peso Kg." ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.COTIZACION.AcuBon[4]
"COTIZACION.AcuBon[4]" "Import. Atendido" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > Temp-Tables.COTIZACION.AcuBon[5]
"COTIZACION.AcuBon[5]" "Import. por Atender" "->>>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
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
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
  DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
  DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

  hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
  CASE hSortColumn:NAME:
      WHEN "CodDiv" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodDiv').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_c01" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_c01').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "NroPed" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'NroPed').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "LugEnt2" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'LugEnt2').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchPed" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchPed').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchVen" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchVen').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "FchEnt" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'FchEnt').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "CodCli" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'CodCli').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "NomCli" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "ImpTot" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'ImpTot').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
      WHEN "Libre_d01" THEN DO:
          RUN set-attribute-list ('SortBy-Case = ':U + 'Libre_d01').
          RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
      END.
  END CASE.

  /*
  hQueryHandle = BROWSE {&BROWSE-NAME}:QUERY.
  hQueryHandle:QUERY-CLOSE().
  hQueryHandle:QUERY-PREPARE("FOR EACH CUSTOMER NO-LOCK BY " + hSortColumn:NAME).
  hQueryHandle:QUERY-OPEN().
  */
END.

/*
RUN set-attribute-list (
    'SortBy-Options = "':U + 'CodDiv,Libre_c01' + '",
     SortBy-Case = ':U + 'Libre_c01').
RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
*/

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


&Scoped-define SELF-NAME btnActivaPtoSalida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnActivaPtoSalida B-table-Win
ON CHOOSE OF btnActivaPtoSalida IN FRAME F-Main /* Activar Punto Salida */
DO:
    DEF VAR x-Claves AS CHAR INIT '31416,ptosalida' NO-UNDO.
    DEF VAR x-rep AS CHAR INIT '' NO-UNDO.
    DEF VAR x-nivel-acceso AS INT INIT 0.

    RUN lib/_clave3 (x-claves, OUTPUT x-rep).
    x-nivel-acceso = LOOKUP(x-rep, x-Claves).
    IF x-nivel-acceso = 1 OR x-nivel-acceso  = 2  THEN DO :
        /*{&SECOND-TABLE-IN-QUERY-br_table}.lugent2:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.*/
        ASSIGN
            FILL-IN-CodCli:SENSITIVE = NO
            FILL-IN-CodVen:SENSITIVE = NO
            FILL-IN-FchEnt-1:SENSITIVE = NO
            FILL-IN-FchEnt-2:SENSITIVE = NO
            FILL-IN-FchPed-1:SENSITIVE = NO
            FILL-IN-FchPed-2:SENSITIVE = NO
            FILL-IN-NroPed:SENSITIVE = NO
            RADIO-SET-Excel:SENSITIVE = NO
            RADIO-SET-FlgEst:SENSITIVE = NO
            TOGGLE-1:SENSITIVE = NO
            x-CodDiv:SENSITIVE = NO
            x-Lista:SENSITIVE = NO .
        Faccpedi.LugEnt2:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
        APPLY 'ENTRY':U TO Faccpedi.LugEnt2 IN BROWSE {&BROWSE-NAME}.
    END.
    ELSE DO:
        ASSIGN
            FILL-IN-CodCli:SENSITIVE = YES
            FILL-IN-CodVen:SENSITIVE = YES
            FILL-IN-FchEnt-1:SENSITIVE = YES
            FILL-IN-FchEnt-2:SENSITIVE = YES
            FILL-IN-FchPed-1:SENSITIVE = YES
            FILL-IN-FchPed-2:SENSITIVE = YES
            FILL-IN-NroPed:SENSITIVE = YES
            RADIO-SET-Excel:SENSITIVE = YES
            RADIO-SET-FlgEst:SENSITIVE = YES
            TOGGLE-1:SENSITIVE = YES
            x-CodDiv:SENSITIVE = YES
            x-Lista:SENSITIVE = YES.
        Faccpedi.LugEnt2:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Limpiar Filtros */
DO:
  ASSIGN
      x-CodDiv = 'Todas'
      x-Lista  = 'Todas'
      FILL-IN-FchPed-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-FchPed-2 = TODAY
      FILL-IN-FchEnt-1 = ?
      FILL-IN-FchEnt-2 = ?
      RADIO-SET-FlgEst = 'Todos'
      
      FILL-IN-CodCli = ''
      FILL-IN-CodVen = ''
      FILL-IN-NomCli = ''

      FILL-IN-NomVen = ''
      FILL-IN-NroPed = ''
      TOGGLE-1 = NO.
  DISPLAY
      x-CodDiv
      x-Lista
      FILL-IN-FchPed-1
      FILL-IN-FchPed-2
      FILL-IN-FchEnt-1
      FILL-IN-FchEnt-2
      RADIO-SET-FlgEst
      
      FILL-IN-CodCli 
      FILL-IN-CodVen 
      FILL-IN-NomCli 
      
      FILL-IN-NomVen 
      FILL-IN-NroPed 
      TOGGLE-1
      WITH FRAME {&FRAME-NAME}.

  EMPTY TEMP-TABLE COTIZACION.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  
  APPLY 'VALUE-CHANGED':U TO RADIO-SET-FlgEst.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-18 B-table-Win
ON CHOOSE OF BUTTON-18 IN FRAME F-Main /* Aplicar Filtro */
DO:
  ASSIGN
      FILL-IN-CodCli FILL-IN-CodVen FILL-IN-NomCli FILL-IN-FchEnt-1 
      FILL-IN-FchEnt-2 FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-NomVen 
      FILL-IN-NroPed RADIO-SET-Excel RADIO-SET-FlgEst TOGGLE-1 x-CodDiv
      x-Lista.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).
  SESSION:SET-WAIT-STATE('').
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


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli B-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Por Código de Cliente */
DO:
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
        AND gn-clie.CodCli = INPUT {&self-name}
        NO-LOCK NO-ERROR.
    ASSIGN {&self-name}.
/*     IF AVAILABLE gn-clie THEN FILL-IN-DesCli:SCREEN-VALUE = gn-clie.NomCli. */
/*     ASSIGN {&self-name} FILL-IN-DesCli.                                     */
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
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
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchEnt-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchEnt-1 B-table-Win
ON LEAVE OF FILL-IN-FchEnt-1 IN FRAME F-Main /* Entregar Desde */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchEnt-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchEnt-2 B-table-Win
ON LEAVE OF FILL-IN-FchEnt-2 IN FRAME F-Main /* Entregar Hasta */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-1 B-table-Win
ON LEAVE OF FILL-IN-FchPed-1 IN FRAME F-Main /* Emitidos Desde */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchPed-2 B-table-Win
ON LEAVE OF FILL-IN-FchPed-2 IN FRAME F-Main /* Emitidos Hasta */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed B-table-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* Nro. Cotización */
DO:
  ASSIGN {&self-name}.
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
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
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 B-table-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main /* Mostrar ANULADOS y VENCIDOS */
DO:
    ASSIGN {&self-name}.
/*     RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*     RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodDiv B-table-Win
ON VALUE-CHANGED OF x-CodDiv IN FRAME F-Main /* División Origen */
DO:
  ASSIGN {&self-name}.
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Lista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Lista B-table-Win
ON VALUE-CHANGED OF x-Lista IN FRAME F-Main /* Lista */
DO:
  ASSIGN {&self-name}.
/*   RUN dispatch IN THIS-PROCEDURE ('open-query':U).  */
/*   RUN Procesa-Handle IN lh_handle ('Open-Query':U). */
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

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'CodDiv':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodDiv BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_c01':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.Libre_c01 BY FacCPedi.CodDiv BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'ImpTot':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.ImpTot DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NroPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'LugEnt2':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.LugEnt2 BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'FchPed':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.FchPed BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'fchven':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.fchven BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'CodCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.CodCli BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli BY FacCPedi.NroPed DESCENDING
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'Libre_d01':U THEN DO:
      &Scope SORTBY-PHRASE BY COTIZACION.Libre_d01 DESCENDING
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE COTIZACION.

PRINCIPAL:
FOR EACH Faccpedi NO-LOCK WHERE {&Condicion}:
/*     CASE RADIO-SET-FlgEst:                                                                */
/*         WHEN "P" THEN DO:                                                                 */
/*             /* Cotizaciones aprobadas pero NO tienen atenciones */                        */
/*             IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK)     */
/*                 THEN NEXT PRINCIPAL.                                                      */
/*         END.                                                                              */
/*         WHEN "PP" THEN DO:                                                                */
/*             /* Cotizaciones aprobadas pero con al menos una atención */                   */
/*             IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) */
/*                 THEN NEXT PRINCIPAL.                                                      */
/*         END.                                                                              */
/*     END CASE.                                                                             */
    CREATE COTIZACION.
    BUFFER-COPY Faccpedi TO COTIZACION.
    ASSIGN
        COTIZACION.Libre_c02 = _FlgEst(COTIZACION.FlgEst)
        COTIZACION.Libre_d01 = fPorcAvance()
        COTIZACION.AcuBon[2] = fTotItems()
        COTIZACION.AcuBon[3] = fTotPeso()
        COTIZACION.AcuBon[4] = fImpAtendido()
        COTIZACION.AcuBon[5] = fImpxAtender().
/*     IF RADIO-SET-FlgEst = "C" AND COTIZACION.Libre_d01 < 100  THEN DELETE COTIZACION. */
    /* Controles Finales */
    IF COTIZACION.FlgEst = "P" 
        AND CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate > 0 NO-LOCK) 
        THEN COTIZACION.FlgEst = "PP".
    IF COTIZACION.FlgEst = "C"
        AND COTIZACION.Libre_d01 < 100 
        THEN COTIZACION.FlgEst = "PP".
    ASSIGN COTIZACION.Libre_c02 = _FlgEst(COTIZACION.FlgEst).
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
chWorkSheet:Range("B1"):VALUE = "Lista".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".

chWorkSheet:Range("C1"):VALUE = "Número".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:Range("D1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("G1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H1"):VALUE = "Vendedor".
chWorkSheet:Range("I1"):VALUE = "Importe".
chWorkSheet:Range("J1"):VALUE = "Estado".
chWorkSheet:Range("K1"):VALUE = "% Avance".
chWorkSheet:Range("L1"):VALUE = "Total de Items".
chWorkSheet:Range("M1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("N1"):VALUE = "Import. Atendido".
chWorkSheet:Range("O1"):VALUE = "Import. por Atender".
chWorkSheet:Range("P1"):VALUE = "No".
chWorkSheet:Range("Q1"):VALUE = "Articulo".
chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
chWorkSheet:Range("R1"):VALUE = "Descripción".
chWorkSheet:Range("S1"):VALUE = "Marca".
chWorkSheet:Range("T1"):VALUE = "Unidad".
chWorkSheet:Range("U1"):VALUE = "Cantidad Aprobada".
chWorkSheet:Range("V1"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("W1"):VALUE = "Precio Unitario".
chWorkSheet:Range("X1"):VALUE = "% Dscto Manual".
chWorkSheet:Range("Y1"):VALUE = "% Dscto Evento".
chWorkSheet:Range("Z1"):VALUE = "% Dscto Vol/Prom".
chWorkSheet:Range("AA1"):VALUE = "Importe".
chWorkSheet:Range("AB1"):VALUE = "PDD".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE COTIZACION:
    FOR EACH DETALLE OF Faccpedi NO-LOCK,FIRST Almmmatg OF DETALLE NO-LOCK :
        t-Column = 1.
        t-Row = t-Row + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.libre_c01.
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
        /*chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.Libre_C02.
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.Libre_D01.
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fTotItems().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[2].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[3].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[4].
        t-column = t-column + 1.
        /*chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().*/
        chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[5].
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
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = faccpedi.lugent2.
    END.
    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
chWorkSheet:Range("B1"):VALUE = "Lista".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".

chWorkSheet:Range("C1"):VALUE = "Número".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:Range("D1"):VALUE = "Emisión".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("E1"):VALUE = "Vencimiento".
chWorkSheet:COLUMNS("E"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("F1"):VALUE = "Fecha Entrega".
chWorkSheet:COLUMNS("F"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:Range("G1"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H1"):VALUE = "Vendedor".
chWorkSheet:Range("I1"):VALUE = "Importe".
chWorkSheet:Range("J1"):VALUE = "Estado".
chWorkSheet:Range("K1"):VALUE = "% Avance".
chWorkSheet:Range("L1"):VALUE = "Total de Items".
chWorkSheet:Range("M1"):VALUE = "Total Peso Kg.".
chWorkSheet:Range("N1"):VALUE = "Import. Atendido".
chWorkSheet:Range("O1"):VALUE = "Import. por Atender".
chWorkSheet:Range("P1"):VALUE = "PDD".

GET FIRST {&browse-name}.
REPEAT WHILE AVAILABLE COTIZACION:
    t-Row = t-Row + 1.
    t-Column = 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.coddiv.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = Faccpedi.libre_c01.
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
    /*chWorkSheet:Cells(t-Row, t-Column) = _FlgEst().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.Libre_C02.
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fPorcAvance().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.Libre_D01.
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fTotItems().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[2].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fTotPeso().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[3].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fImpAtendido().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[4].
    t-column = t-column + 1.
    /*chWorkSheet:Cells(t-Row, t-Column) = fImpxAtender().*/
    chWorkSheet:Cells(t-Row, t-Column) = COTIZACION.AcuBon[5].
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = faccpedi.lugent2.

    GET NEXT {&browse-name}.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('Open-Query':U).

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
  DEF VAR pRowid AS ROWID.
  pRowid = ROWID(COTIZACION).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   ASSIGN                                                                             */
/*       cotizacion.lugent2 = cotizacion.lugent2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}. */
/*   FIND FIRST tt-faccpedi OF cotizacion EXCLUSIVE NO-ERROR.                           */
/*   IF AVAILABLE tt-faccpedi THEN ASSIGN tt-faccpedi.lugent2 = cotizacion.lugent2.     */
/*   RELEASE tt-faccpedi.                                                               */
/*   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).                               */
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&browse-name} TO ROWID pRowid.
  
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
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:
      x-Lista:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv, gn-divi.coddiv).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  Faccpedi.LugEnt2:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.

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
  {src/adm/template/snd-list.i "COTIZACION"}
  {src/adm/template/snd-list.i "FacCPedi"}

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

  DEFINE VAR lAlmx AS CHAR.
  DEFINE VAR lrowid AS ROWID.

  IF Faccpedi.LugEnt2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> '' THEN DO:
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = Faccpedi.LugEnt2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
        MESSAGE 'Almacén NO registrado' VIEW-AS ALERT-BOX ERROR.
        /* SETFOCUS */
        APPLY 'ENTRY':U TO Faccpedi.LugEnt2 IN BROWSE {&BROWSE-NAME}.
        RETURN 'ADM-ERROR'.
    END.
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
    Notes:  Deo facturado
------------------------------------------------------------------------------*/

  DEF VAR xPorcAvance AS DEC NO-UNDO.
  DEF VAR xImpPed AS DEC NO-UNDO.
  DEF VAR xImpAte AS DEC NO-UNDO.

  DEF BUFFER PEDIDOS  FOR Faccpedi.
  DEF BUFFER FACTURAS FOR Ccbcdocu.
  DEF BUFFER CREDITOS FOR Ccbcdocu.

  /* 17/12/2014 Probemos por cantidades */
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      xImpPed = xImpPed + Facdpedi.canped.
  END.
  FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = Faccpedi.codcia
      AND PEDIDOS.coddoc = 'PED'
      AND PEDIDOS.codref = Faccpedi.coddoc
      AND PEDIDOS.nroref = Faccpedi.nroped
      AND PEDIDOS.fchped >= Faccpedi.fchped
      AND PEDIDOS.flgest <> "A",
      EACH FACTURAS NO-LOCK WHERE FACTURAS.codcia = Faccpedi.codcia
      AND LOOKUP(FACTURAS.coddoc, 'FAC,BOL') > 0
      AND FACTURAS.flgest <> "A"
      AND FACTURAS.codped = PEDIDOS.coddoc
      AND FACTURAS.nroped = PEDIDOS.nroped
      AND FACTURAS.fchdoc >= PEDIDOS.fchped:
      FOR EACH Ccbddocu OF FACTURAS NO-LOCK:
          ASSIGN xImpAte = xImpAte + Ccbddocu.CanDes.
      END.
      FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = FACTURAS.codcia
          AND CREDITOS.coddoc = "N/C"
          AND CREDITOS.codref = FACTURAS.coddoc
          AND CREDITOS.nroref = FACTURAS.nrodoc
          AND CREDITOS.cndcre = "D"
          AND CREDITOS.flgest <> "A",
          EACH Ccbddocu OF CREDITOS NO-LOCK:
          ASSIGN xImpAte = xImpAte - Ccbddocu.CanDes.
      END.
  END.
  xPorcAvance = xImpAte / xImpPed * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.

  /* 17/12/2014 Bloqueado por importes 
  FOR EACH PEDIDOS NO-LOCK WHERE PEDIDOS.codcia = Faccpedi.codcia
      AND PEDIDOS.coddoc = 'PED'
      AND PEDIDOS.codref = Faccpedi.coddoc
      AND PEDIDOS.nroref = Faccpedi.nroped
      AND PEDIDOS.fchped >= Faccpedi.fchped
      AND PEDIDOS.flgest <> "A",
      EACH FACTURAS NO-LOCK WHERE FACTURAS.codcia = Faccpedi.codcia
      AND LOOKUP(FACTURAS.coddoc, 'FAC,BOL') > 0
      AND FACTURAS.flgest <> "A"
      AND FACTURAS.codped = PEDIDOS.coddoc
      AND FACTURAS.nroped = PEDIDOS.nroped
      AND FACTURAS.fchdoc >= PEDIDOS.fchped:
      ASSIGN xImpAte = xImpAte + FACTURAS.ImpTot.
      FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = FACTURAS.codcia
          AND CREDITOS.coddoc = "N/C"
          AND CREDITOS.codref = FACTURAS.coddoc
          AND CREDITOS.nroref = FACTURAS.nrodoc
          AND CREDITOS.cndcre = "D"
          AND CREDITOS.flgest <> "A":
          ASSIGN xImpAte = xImpAte - CREDITOS.ImpTot.
      END.
  END.
  xPorcAvance = xImpAte / Faccpedi.ImpTot * 100.
  IF xPorcAvance < 0 THEN xPorcAvance = 0.
  IF xPorcAvance > 100 THEN xPorcAvance = 100.
  */

  /*
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      ASSIGN
          xImpPed = xImpPed + Facdpedi.ImpLin
          xImpAte = xImpAte + (Facdpedi.ImpLin / facdpedi.CanPed) * Facdpedi.CanAte
          xPorcAvance = xImpAte / xImpPed * 100.
  END.
  */

  RETURN ROUND(xPorcAvance, 2).

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
  ( INPUT pFlgEst AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pEstado AS CHAR NO-UNDO.

/*RUN vta2/p-faccpedi-flgestv2 (ROWID(Faccpedi), OUTPUT pEstado).*/

        CASE pFlgEst:
            WHEN 'E' THEN pEstado = "POR APROBAR".
            WHEN 'P' THEN pEstado = "PENDIENTE".
            WHEN 'PP' THEN pEstado = "EN PROCESO".
            WHEN 'V' THEN pEstado = "VENCIDA".
            WHEN 'R' THEN pEstado = "RECHAZADO".
            WHEN 'A' THEN pEstado = "ANULADO".
            WHEN 'C' THEN pEstado = "ATENDIDA TOTAL".
            WHEN 'S' THEN pEstado = "SUSPENDIDA".
            WHEN 'X' THEN pEstado = "CERRADA MANUALMENTE".
            WHEN 'T' THEN pEstado = "EN REVISION".
            WHEN 'ST' THEN pEstado = "SALDO TRANSFERIDO".
        END CASE.


RETURN pEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

