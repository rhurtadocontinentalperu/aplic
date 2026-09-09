&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-emision-desde AS DATE.
DEFINE VAR x-emision-hasta AS DATE.

DEFINE VAR x-lista-precios AS CHAR.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nroped AS CHAR.
DEFINE VAR x-por-atender AS DEC.
DEFINE VAR x-que-contenga AS CHAR INIT "".
DEFINE VAR x-todos AS LOG.
DEFINE VAR x-cotizacion AS CHAR INIT "".

DEFINE VAR x-col-peso AS DEC.
DEFINE VAR x-col-importe AS DEC.
DEFINE VAR x-col-peso-x-atender AS DEC.
DEFINE VAR x-col-importe-x-atender AS DEC.

DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.

x-todos = NO.

/*s-user-id = 'ADMIN'.*/

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "VALIDA" NO-LOCK NO-ERROR.
IF AVAILABLE factabla THEN DO:
    IF LOOKUP(s-user-id,factabla.campo-c[1]) > 0 THEN DO:
        x-todos = YES.
    END.
END.
/*
&SCOPED-DEFINE CONDICION ( ~
            faccpedi.codcia = s-codcia and ~
            faccpedi.coddoc = 'COT' AND ~
            (faccpedi.fchped >= x-emision-desde and faccpedi.fchped <= x-emision-hasta) and ~
            (lookup(faccpedi.libre_c01,x-lista-precios) > 0 AND faccpedi.coddiv = s-coddiv) and ~
            faccpedi.flgest = "P" and ~
            (x-que-contenga = "" OR faccpedi.nomcli MATCHES x-que-contenga) AND ~
            (x-todos = YES OR faccpedi.usuario = s-user-id) ~
            )
*/

&SCOPED-DEFINE CONDICION ( ~
            faccpedi.codcia = s-codcia and ~
            faccpedi.coddoc = 'COT' AND ~
            (faccpedi.fchped >= x-emision-desde and faccpedi.fchped <= x-emision-hasta) and ~
            ((x-todos = YES AND lookup(faccpedi.libre_c01,x-lista-precios) > 0) OR (faccpedi.coddiv = s-coddiv AND lookup(faccpedi.libre_c01,x-lista-precios) > 0 )) and ~
            faccpedi.flgest = "P" and ~
            ( x-cotizacion = "" OR faccpedi.nroped BEGINS x-cotizacion ) and ~
            (x-que-contenga = "" OR faccpedi.nomcli MATCHES x-que-contenga ) ~
            )

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi FacDPedi

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 FacCPedi.NroPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.FchPed FacCPedi.FchEnt ~
calcula-peso-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-peso-x-atender ~
calcula-importe-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-importe-x-atender ~
FacCPedi.Libre_d02 FacCPedi.ImpTot FacCPedi.CodDiv FacCPedi.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE (facdpedi.canped - facdpedi.canate) > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE (facdpedi.canped - facdpedi.canate) > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacCPedi FacDPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 FacDPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 FILL-IN-cotizacion BUTTON-4 ~
txtDesde BUTTON-1 BUTTON-2 FILL-IN-cliente 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-cotizacion txtDesde txtHasta ~
FILL-IN-contenga txtFechaEntrega txtUltFechaTope FILL-IN-cliente 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcula-importe W-Win 
FUNCTION calcula-importe RETURNS DECIMAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcula-importe-x-atender W-Win 
FUNCTION calcula-importe-x-atender RETURNS DECIMAL
 ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcula-peso W-Win 
FUNCTION calcula-peso RETURNS DECIMAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD calcula-peso-x-atender W-Win 
FUNCTION calcula-peso-x-atender RETURNS DECIMAL
    ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD con-saldos W-Win 
FUNCTION con-saldos RETURNS LOGICAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar" 
     SIZE 13 BY .85.

DEFINE BUTTON BUTTON-2 
     LABEL "Proceso Masivo" 
     SIZE 17.57 BY 1.15.

DEFINE BUTTON BUTTON-4 
     LABEL "Cta Cte." 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-cliente AS CHARACTER FORMAT "X(11)":U 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-contenga AS CHARACTER FORMAT "X(60)":U 
      VIEW-AS TEXT 
     SIZE 37 BY 1
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-cotizacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cotizacion" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaEntrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Abastecimiento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtUltFechaTope AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Tope" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .96
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      FacCPedi, 
      FacDPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Cotizacion" FORMAT "X(12)":U
            WIDTH 10.43 COLUMN-FONT 0
      FacCPedi.CodCli FORMAT "x(11)":U COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(100)":U
            WIDTH 39.29 COLUMN-FONT 0
      FacCPedi.FchPed COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 11 COLUMN-FONT 0
      calcula-peso-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-peso-x-atender COLUMN-LABEL "Peso!Atender" FORMAT "->>,>>>,>>9.99":U
            COLUMN-FONT 0
      calcula-importe-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-importe-x-atender COLUMN-LABEL "Importe!Atender" FORMAT "->>,>>>,>>9.99":U
            WIDTH 13.72 COLUMN-FONT 0
      FacCPedi.Libre_d02 COLUMN-LABEL "Peso Total" FORMAT "->>>,>>>,>>9.99":U
            COLUMN-FONT 0
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U COLUMN-FONT 0
      FacCPedi.CodDiv FORMAT "x(5)":U COLUMN-FONT 0
      FacCPedi.Libre_c01 COLUMN-LABEL "Lista" FORMAT "x(6)":U WIDTH 8.14
            COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 129 BY 20.08 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-4 AT ROW 4.19 COL 2 WIDGET-ID 200
     FILL-IN-cotizacion AT ROW 3 COL 34.86 COLON-ALIGNED WIDGET-ID 124
     BUTTON-4 AT ROW 24.65 COL 102 WIDGET-ID 122
     txtDesde AT ROW 1.69 COL 10 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.73 COL 10 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-contenga AT ROW 1.81 COL 39.43 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     txtFechaEntrega AT ROW 1.12 COL 96.57 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 3.15 COL 66 WIDGET-ID 100
     BUTTON-2 AT ROW 24.65 COL 79 WIDGET-ID 116
     txtUltFechaTope AT ROW 2.04 COL 96.57 COLON-ALIGNED WIDGET-ID 120
     FILL-IN-cliente AT ROW 1.85 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 126
     "Cotizaciones emitidas" VIEW-AS TEXT
          SIZE 21.72 BY .62 AT ROW 1.04 COL 4 WIDGET-ID 102
          FGCOLOR 4 FONT 2
     "Cliente" VIEW-AS TEXT
          SIZE 14.86 BY .62 AT ROW 1.27 COL 27.14 WIDGET-ID 106
          FGCOLOR 9 FONT 6
     "DobleClick en Cotizacion para Generar PCO" VIEW-AS TEXT
          SIZE 40 BY .62 AT ROW 3.5 COL 91 WIDGET-ID 118
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 132.29 BY 25.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Generacion de PCO para programacion de Abastecimiento"
         HEIGHT             = 25.38
         WIDTH              = 132.29
         MAX-HEIGHT         = 30.08
         MAX-WIDTH          = 195.14
         VIRTUAL-HEIGHT     = 30.08
         VIRTUAL-WIDTH      = 195.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-4 1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-contenga IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFechaEntrega IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtUltFechaTope IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&CONDICION}"
     _Where[2]         = "(facdpedi.canped - facdpedi.canate) > 0"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Cotizacion" ? "character" ? ? 0 ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? 0 ? ? ? no ? no no "39.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emision" ? "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Entrega" ? "date" 11 ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"calcula-peso-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-peso-x-atender" "Peso!Atender" "->>,>>>,>>9.99" ? ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"calcula-importe-x-atender(faccpedi.coddoc, faccpedi.nroped)  @ x-col-importe-x-atender" "Importe!Atender" "->>,>>>,>>9.99" ? ? ? 0 ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.Libre_d02
"FacCPedi.Libre_d02" "Peso Total" "->>>,>>>,>>9.99" "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" ? ? "decimal" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacCPedi.Libre_c01
"FacCPedi.Libre_c01" "Lista" "x(6)" "character" ? ? 0 ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de PCO para programacion de Abastecimiento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de PCO para programacion de Abastecimiento */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON ENTRY OF BROWSE-4 IN FRAME F-Main
DO:
    x-coddoc = "".
    x-nroped = "".
    IF AVAILABLE faccpedi THEN DO:
          x-coddoc = faccpedi.coddoc.
          x-nroped = faccpedi.nroped.
    END.

    {&OPEN-QUERY-BROWSE-5}
    /*RUN calcula-peso-importe.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:

    ASSIGN txtUltFechaTope txtFechaEntrega.

  IF AVAILABLE faccpedi THEN DO:
      RUN lgc/w-generacion-pco-grabar.r(INPUT faccpedi.coddoc, INPUT faccpedi.nroped, INPUT txtFechaEntrega, INPUT txtUltFechaTope).      

 {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON VALUE-CHANGED OF BROWSE-4 IN FRAME F-Main
DO:
  x-coddoc = "".
  x-nroped = "".
  IF AVAILABLE faccpedi THEN DO:
        x-coddoc = faccpedi.coddoc.
        x-nroped = faccpedi.nroped.
  END.

  {&OPEN-QUERY-BROWSE-5}
    /*RUN calcula-peso-importe.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:

    ASSIGN fill-in-contenga fill-in-cotizacion.

    x-emision-desde = DATE(txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    x-emision-hasta = DATE(txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    x-que-contenga = "".    
    IF fill-in-contenga <> "" THEN DO:
        x-que-contenga = "*" + fill-in-contenga + "*".
    END.
    x-cotizacion = fill-in-cotizacion.

  SESSION:SET-WAIT-STATE("GENERAL").
  {&OPEN-QUERY-BROWSE-4}
  SESSION:SET-WAIT-STATE("").

  RUN calcula-peso-importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Proceso Masivo */
DO:

    ASSIGN txtUltFechaTope.

  RUN generar-masivo.

 {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Cta Cte. */
DO:
  IF AVAILABLE faccpedi THEN DO:

    S-CODCLI = faccpedi.codcli.
    RUN vta2/d-ctactepend.

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-fecha-tope W-Win 
PROCEDURE calcula-fecha-tope :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFechaInicio AS DATE.
DEFINE OUTPUT PARAMETER pFechaProyectada AS DATE.

DEFINE VAR lQtyDom AS INT.
DEFINE VAR lDia AS DATE.
DEFINE VAR lCuantosDomingos AS INT.

lCuantosDomingos = 2.

lQtyDom = 0. /* Cuantos domingos paso */
DO lDia = pFechaInicio TO pFechaInicio + 100:
    pFechaProyectada = lDia.
    /* Es Domingo */
    IF WEEKDAY(lDia) = 1 THEN DO:
        lQtyDom = lQtyDom + 1.
    END.
    /* Ic - 20Ene2017, a pedido de C.Camus se cambio de 2 a 4 domingos */
    /*IF lQtyDom = 2 THEN DO:*/
    IF lQtyDom = lCuantosDomingos THEN DO:
        /* Ubico el siguiente proximo Domingo */
        LEAVE.
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-peso-importe W-Win 
PROCEDURE calcula-peso-importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR x-peso AS DEC INIT 0.
DEFINE VAR x-importe AS DEC INIT 0.
DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-precio AS DEC.

DEFINE BUFFER x-almmmatg FOR almmmatg.

SESSION:SET-WAIT-STATE("GENERAL").
GET FIRST BROWSE-5.
DO  WHILE AVAILABLE facdpedi:
    x-codmat = facdpedi.codmat.
    FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                                    x-almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE x-almmmatg THEN DO:
        x-peso = x-peso + ((facdpedi.canped - facdpedi.canate) * x-almmmatg.pesmat).
    END.
    x-precio = IF(facdpedi.canped > 0) THEN (facdpedi.implin / facdpedi.canped) ELSE 0.
    x-importe = x-importe + ((facdpedi.canped - facdpedi.canate) * x-precio).
    GET NEXT BROWSE-5.
END.
/*
fill-in-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-peso,"->>,>>>,>>9.99").
fill-in-importe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-importe,"->>,>>>,>>9.99").
*/
SESSION:SET-WAIT-STATE("").
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-cotizacion txtDesde txtHasta FILL-IN-contenga txtFechaEntrega 
          txtUltFechaTope FILL-IN-cliente 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-4 FILL-IN-cotizacion BUTTON-4 txtDesde BUTTON-1 BUTTON-2 
         FILL-IN-cliente 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-masivo W-Win 
PROCEDURE generar-masivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-cotizaciones AS INT INIT 0.
DEFINE VAR x-cotizaciones-ok AS INT INIT 0.
DEFINE VAR x-sec AS INT INIT 0.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nroped AS CHAR.
DEFINE VAR x-msgerror AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    x-cotizaciones = browse-4:NUM-SELECTED-ROWS.

    IF x-cotizaciones < 2 THEN DO:
        MESSAGE "Debe seleccionar al menos 2 a mas cotizaciones".
        RETURN.
    END.
    
    IF x-cotizaciones > 10 THEN DO:
        MESSAGE "Calculo del MASIVO como maximo 5 Cotizaciones por proceso (de 10 en 10)".
        RETURN.
    END.

    MESSAGE 'Seguro de trabajar la(s) ' + STRING(x-cotizaciones) + ' Cotizacion(es) ?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.

   
    DO x-sec = 1 TO x-cotizaciones:
        IF browse-4:FETCH-SELECTED-ROW(x-sec) THEN DO:
            x-coddoc = {&FIRST-TABLE-IN-QUERY-browse-4}.coddoc.
            x-nroped = {&FIRST-TABLE-IN-QUERY-browse-4}.nroped.
            x-msgerror = "".
            RUN generar-pco(INPUT x-coddoc, INPUT x-nroped, OUTPUT x-msgerror).
            
            IF s-user-id = 'ADMIN' THEN DO:
                IF x-msgerror <> 'OK' THEN DO:
                    MESSAGE "x-nroped " x-nroped SKIP
                        "x-msgerror " x-msgerror.
                END.
            END.
            
            IF x-msgerror = 'OK' THEN x-cotizaciones-ok = x-cotizaciones-ok + 1.
                /*cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.*/
        END.
    END.
    
    MESSAGE "Se procesaron " + STRING(x-cotizaciones-ok) + " de " + 
        STRING(x-cotizaciones) + " cotizaciones seleecionadas".

    {&OPEN-QUERY-BROWSE-4}

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-pco W-Win 
PROCEDURE generar-pco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Numero de la Cotizacion */
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pMsgError AS CHAR.

pMsgError = "".

DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

/* Si tiene PCO */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = 'PCO' AND
                            x-faccpedi.codref = pCodDoc AND 
                            x-faccpedi.nroref = pNroPed AND 
                            (x-faccpedi.flgest = 'G' OR x-faccpedi.flgest = 'T') NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    /*pMsgError = "Cotizacion ya tiene generado una PCO".
    RETURN.*/   
END.

/* La detalle de la cotizacion */
FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                            x-facdpedi.coddoc = pCodDOc AND
                            x-facdpedi.nroped = pNroPed AND
                            (x-facdpedi.canped - x-facdpedi.canate) > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-facdpedi THEN DO:
    pMsgError = "La cotizacion no tiene pendiente de entrega".
    RETURN.
END.

/* Cabecera de la cotizacion */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND
                            x-faccpedi.nroped = pNroPed AND
                            x-faccpedi.flgest <> 'A'
                            NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La cotizacion es anulada".
    RETURN.
END.

pMsgError = "".

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-corre AS INT.
DEFINE VAR x-proceso-ok AS LOG.
DEFINE VAR x-cantidad AS DEC.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.

/* Ultimo correlativo de la PCO */
FOR EACH b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = 'PCO' AND
                            b-faccpedi.codref = 'COT' AND
                            b-faccpedi.nroref = x-faccpedi.nroped NO-LOCK:
    x-corre = x-corre + 1.
END.
x-corre = x-corre + 1.

x-proceso-ok = NO.
GRABAR_DATA:
DO TRANSACTION ON ERROR UNDO GRABAR_DATA, LEAVE GRABAR_DATA:
    /* Cabecera de la PCO */
    CREATE b-faccpedi.
    /*BUFFER-COPY x-faccpedi EXCEPT coddoc nroped TO b-faccpedi.*/
    x-nroped = x-faccpedi.nroped + "-" + STRING(x-corre).
    BUFFER-COPY x-faccpedi EXCEPT coddoc nroped TO b-faccpedi
    ASSIGN b-faccpedi.coddoc = 'PCO'
            b-faccpedi.nroped = x-nroped
            b-faccpedi.codref = x-faccpedi.coddoc
            b-faccpedi.nroref = x-faccpedi.nroped
            b-faccpedi.fchped = TODAY
            b-faccpedi.fchent = txtUltFechaTope
            b-faccpedi.libre_f01 = txtUltFechaTope  /* abastecimiento */
            b-faccpedi.libre_f02 = txtUltFechaTope + 6   /* fecha tope */
            b-faccpedi.hora = STRING(TIME,"HH:MM:SS")
            b-faccpedi.usuario = s-user-id                
            b-faccpedi.flgest  = 'G' NO-ERROR.

    IF ERROR-STATUS:ERROR = YES THEN DO:
        UNDO GRABAR_DATA, LEAVE GRABAR_DATA.
    END.
        

    FOR EACH x-facdpedi OF x-faccpedi WHERE (x-facdpedi.canped - x-facdpedi.canate) > 0 ON ERROR UNDO, THROW:
        FIND FIRST facdpedi WHERE facdpedi.codcia = x-facdpedi.codcia AND
                                    facdpedi.coddoc = x-faccpedi.coddoc AND
                                    facdpedi.nroped = x-faccpedi.nroped AND 
                                    facdpedi.codmat = x-facdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:            
            x-cantidad = (x-facdpedi.canped - x-facdpedi.canate).
            /* Grabo el detalle de la PCO */
            CREATE b-facdpedi.
            BUFFER-COPY x-facdpedi EXCEPT coddoc nroped TO b-facdpedi
            ASSIGN  b-facdpedi.coddoc = b-faccpedi.coddoc
                    b-facdpedi.nroped = b-faccpedi.nroped
                    b-facdpedi.libre_d05 = x-facdpedi.canped
                    b-facdpedi.canped = x-cantidad 
                    b-facdpedi.libre_c01 = ""
                    b-facdpedi.libre_c02 = ""
                NO-ERROR.

            IF ERROR-STATUS:ERROR = YES THEN DO:
                UNDO GRABAR_DATA, LEAVE GRABAR_DATA.
            END.
            /*  */
            ASSIGN facdpedi.canate = facdpedi.canate + x-cantidad NO-ERROR.
        END.
    END.
    x-proceso-ok = YES.
END.

RELEASE b-faccpedi.
RELEASE b-facdpedi.
RELEASE facdpedi.

IF x-proceso-ok = YES THEN pMsgError = "OK".

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/99999").    /*"01/07/2018".*/
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/99999").

  x-emision-desde = DATE(txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  x-emision-hasta = DATE(txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  DEFINE VAR lFechaTope AS DATE.
  /*
  RUN calcula-fecha-tope (INPUT TODAY, OUTPUT lFechaTope).

  txtUltFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(lFechaTope,"99/99/99999").
    */
  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'ABASTECIMIENTO' AND
                          vtatabla.llave_c1 = 'CONFIG' 
                          NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:

      txtFechaEntrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 1,"99/99/9999").
      txtUltFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 7,"99/99/9999").
      
  END.

  /* Ferias: Configuración Eventos */
  x-lista-precios = "".
  FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "EVENTOS_LISTAS":
      x-lista-precios = x-lista-precios + IF(x-lista-precios = "") THEN "" ELSE ",".
      x-lista-precios = x-lista-precios + TRIM(FacTabla.Codigo).
  END.
/*   FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND                               */
/*       gn-divi.canalventa = 'FER' NO-LOCK.                                            */
/*       x-lista-precios = x-lista-precios + IF(x-lista-precios = "") THEN "" ELSE ",". */
/*       x-lista-precios = x-lista-precios + TRIM(gn-divi.coddiv).                      */
/*   END.                                                                               */

  SESSION:SET-WAIT-STATE("GENERAL").
  /*{&OPEN-QUERY-BROWSE-4}*/
  SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcula-importe W-Win 
FUNCTION calcula-importe RETURNS DECIMAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER x-facdpedi FOR facdpedi.

  DEFINE VAR x-retval AS DEC INIT 0.
  DEFINE VAR x-precio AS DEC.

  FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                x-facdpedi.coddoc = pCodDoc AND
                                x-facdpedi.nroped = pNroPed NO-LOCK:
      x-precio = x-facdpedi.implin / x-facdpedi.canped .
      x-retval = x-retval + (x-facdpedi.canped * x-precio).
      
  END.

  RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcula-importe-x-atender W-Win 
FUNCTION calcula-importe-x-atender RETURNS DECIMAL
 ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER x-facdpedi FOR facdpedi.
  DEFINE BUFFER x-faccpedi FOR faccpedi.

  DEFINE VAR x-retval AS DEC INIT 0.
  DEFINE VAR x-precio AS DEC.
  DEFINE VAR x-codref AS CHAR.
  DEFINE VAR X-nroref AS CHAR.

  /* El pCoddoc y pNroPed es el PCO */
  FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCodDoc AND 
                                x-faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
  IF AVAILABLE x-faccpedi THEN DO:
      /* La cotizacion */
      x-codref = x-faccpedi.codref.
      x-nroref = x-faccpedi.nroref.

      FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                    x-facdpedi.coddoc = pCodDoc AND
                                    x-facdpedi.nroped = pNroPed AND
                                    (x-facdpedi.canped - x-facdpedi.canate)  > 0 NO-LOCK:
          x-precio = x-facdpedi.implin / x-facdpedi.canped .
          x-retval = x-retval + ((x-facdpedi.canped - x-facdpedi.canate) * x-precio).

      END.

  END.

  RETURN x-retval.

  END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcula-peso W-Win 
FUNCTION calcula-peso RETURNS DECIMAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER x-facdpedi FOR facdpedi.
  DEFINE BUFFER x-almmmatg FOR almmmatg.

  DEFINE VAR x-retval AS DEC INIT 0.

  FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                x-facdpedi.coddoc = pCodDoc AND
                                x-facdpedi.nroped = pNroPed AND
                                (x-facdpedi.canped - x-facdpedi.canate) > 0 NO-LOCK:
      FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                                      x-almmmatg.codmat = x-facdpedi.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE x-almmmatg THEN DO:
          x-retval = x-retval + (x-facdpedi.canped * x-almmmatg.pesmat).
      END.
      /*x-importe = x-importe + facdpedi.implin.*/
      
  END.

  RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION calcula-peso-x-atender W-Win 
FUNCTION calcula-peso-x-atender RETURNS DECIMAL
    ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    DEFINE BUFFER x-facdpedi FOR facdpedi.
    DEFINE BUFFER x-faccpedi FOR faccpedi.
    DEFINE BUFFER x-almmmatg FOR almmmatg.

    DEFINE VAR x-retval AS DEC INIT 0.
    DEFINE VAR x-precio AS DEC.
    DEFINE VAR x-codref AS CHAR.
    DEFINE VAR X-nroref AS CHAR.

    /* El pCoddoc y pNroPed es el PCO */
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                  x-faccpedi.coddoc = pCodDoc AND 
                                  x-faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:

        FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                      x-facdpedi.coddoc = pCodDoc AND
                                      x-facdpedi.nroped = pNroPed AND
                                      (x-facdpedi.canped - x-facdpedi.canate)  > 0 NO-LOCK:

            FIND FIRST x-almmmatg OF x-facdpedi NO-LOCK NO-ERROR.
            IF AVAILABLE x-almmmatg THEN DO:
                x-retval = x-retval + ((x-facdpedi.canped - x-facdpedi.canate) * x-almmmatg.pesmat).
            END.
            

        END.

    END.

    RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION con-saldos W-Win 
FUNCTION con-saldos RETURNS LOGICAL
  ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER x-facdpedi FOR facdpedi.
  DEFINE VAR x-retval AS LOG INIT NO.

  FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                x-facdpedi.coddoc = pCodDoc AND
                                x-facdpedi.nroped = pNroPed AND
                                (x-facdpedi.canped - x-facdpedi.canate) > 0 
                                NO-LOCK NO-ERROR.
  IF AVAILABLE x-facdpedi THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

