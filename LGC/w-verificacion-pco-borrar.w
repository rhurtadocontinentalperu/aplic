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

DEFINE VAR x-lista-precios AS CHAR.

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nroped AS CHAR.
DEFINE VAR x-por-atender AS DEC.
DEFINE VAR x-que-contenga AS CHAR INIT "".
DEFINE VAR x-todos AS LOG.
DEFINE VAR x-filtro-estado AS CHAR INIT 'X'.

DEFINE VAR x-col-peso AS DEC.
DEFINE VAR x-col-importe AS DEC.
DEFINE VAR x-col-peso-x-atender AS DEC.
DEFINE VAR x-col-importe-x-atender AS DEC.
DEFINE VAR x-estado AS CHAR.

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
            faccpedi.coddoc = 'PCO' AND ~
            (lookup(faccpedi.libre_c01,x-lista-precios) > 0 AND faccpedi.coddiv = s-coddiv) and ~
            ((x-filtro-estado = 'X' AND (faccpedi.flgest = 'G' OR faccpedi.flgest = 'T' OR faccpedi.flgest = 'P') ) OR faccpedi.flgest = x-filtro-estado) and ~
            (x-que-contenga = "" OR faccpedi.nomcli MATCHES x-que-contenga) AND ~
            (x-todos = YES OR faccpedi.usuario = s-user-id) ~
            )
*/
&SCOPED-DEFINE CONDICION ( ~
            faccpedi.codcia = s-codcia and ~
            faccpedi.coddoc = 'PCO' AND ~
            ((x-todos = YES AND lookup(faccpedi.libre_c01,x-lista-precios) > 0) OR (faccpedi.coddiv = s-coddiv AND lookup(faccpedi.libre_c01,x-lista-precios) > 0)) and ~
            ((x-filtro-estado = 'X' AND (faccpedi.flgest = 'G' OR faccpedi.flgest = 'T' OR faccpedi.flgest = 'P') ) OR faccpedi.flgest = x-filtro-estado) and ~
            (x-que-contenga = "" OR faccpedi.nomcli MATCHES x-que-contenga) ~
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
&Scoped-define INTERNAL-TABLES FacCPedi FacDPedi Almmmatg

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 ~
estado(faccpedi.coddoc,faccpedi.nroped) @ x-estado FacCPedi.NroRef ~
FacCPedi.NroPed FacCPedi.CodCli FacCPedi.NomCli FacCPedi.FchPed ~
FacCPedi.CodDiv calcula-peso(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso ~
calcula-importe(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe ~
calcula-peso-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso-x-atender ~
calcula-importe-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe-x-atender ~
FacCPedi.FchEnt FacCPedi.Libre_f01 FacCPedi.Libre_f02 FacCPedi.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 FacCPedi.FchEnt 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE facdpedi.canped > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacCPedi ~
      WHERE {&CONDICION} NO-LOCK, ~
      FIRST FacDPedi OF FacCPedi ~
      WHERE facdpedi.canped > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacCPedi FacDPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-4 FacDPedi


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 FacDPedi.codmat Almmmatg.DesMat ~
Almmmatg.DesMar FacDPedi.UndVta FacDPedi.CanPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH FacDPedi ~
      WHERE FacDPedi.CodCia = s-codcia and ~
facdpedi.coddoc = x-coddoc and ~
facdpedi.nroped = x-nroped and ~
facdpedi.canped > 0 NO-LOCK, ~
      EACH Almmmatg WHERE FacDPedi.CodCia = Almmmatg.CodCia and ~
FacDPedi.codmat =  Almmmatg.codmat NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH FacDPedi ~
      WHERE FacDPedi.CodCia = s-codcia and ~
facdpedi.coddoc = x-coddoc and ~
facdpedi.nroped = x-nroped and ~
facdpedi.canped > 0 NO-LOCK, ~
      EACH Almmmatg WHERE FacDPedi.CodCia = Almmmatg.CodCia and ~
FacDPedi.codmat =  Almmmatg.codmat NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-4 BUTTON-8 RADIO-SET-estado BUTTON-4 ~
FILL-IN-contenga BUTTON-1 BROWSE-5 BUTTON-2 BUTTON-3 BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-estado FILL-IN-contenga ~
txtFechaAbastecimiento txtFechaTope 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD estado W-Win 
FUNCTION estado RETURNS CHARACTER
    ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refrescar" 
     SIZE 13 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Autorizacion Masiva" 
     SIZE 19 BY 1.15.

DEFINE BUTTON BUTTON-3 
     LABEL "Rechazar masivo" 
     SIZE 22.14 BY 1.15.

DEFINE BUTTON BUTTON-4 
     LABEL "Adicionar Articulos desde la Cotizacion" 
     SIZE 35 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "Desautorizar" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "Procesados sin Pedido a Autorizados" 
     SIZE 35 BY 1.12.

DEFINE VARIABLE FILL-IN-contenga AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE txtFechaAbastecimiento AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha abastecimiento" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE txtFechaTope AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Tope de entrega" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE RADIO-SET-estado AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "X",
"Generados", "G",
"Autorizados", "T",
"Procesados", "P"
     SIZE 48 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      FacCPedi, 
      FacDPedi SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      FacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      estado(faccpedi.coddoc,faccpedi.nroped) @ x-estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 10 COLUMN-FONT 0
      FacCPedi.NroRef COLUMN-LABEL "Cotizacion" FORMAT "X(12)":U
            WIDTH 9.72 COLUMN-FONT 0
      FacCPedi.NroPed COLUMN-LABEL "Nro. PCO" FORMAT "X(12)":U
            WIDTH 11.86 COLUMN-FONT 0
      FacCPedi.CodCli FORMAT "x(11)":U COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre del Cliente" FORMAT "x(50)":U
            WIDTH 35.29 COLUMN-FONT 0
      FacCPedi.FchPed COLUMN-LABEL "Generado" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.CodDiv FORMAT "x(5)":U COLUMN-FONT 0
      calcula-peso(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso COLUMN-LABEL "Peso!Autorizado" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.14 COLUMN-FONT 0
      calcula-importe(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe COLUMN-LABEL "Importe!Autorizado" FORMAT "->>,>>>,>>9.99":U
            WIDTH 12.43 COLUMN-FONT 0
      calcula-peso-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso-x-atender COLUMN-LABEL "Peso!x Atender"
            COLUMN-FONT 0
      calcula-importe-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe-x-atender COLUMN-LABEL "Importe!x Atender" FORMAT "->>,>>>,>>9.99":U
            COLUMN-FONT 0
      FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.Libre_f01 COLUMN-LABEL "Abastecimiento" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.Libre_f02 COLUMN-LABEL "Fecha Tope" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.Libre_c01 COLUMN-LABEL "Lista" FORMAT "x(6)":U WIDTH 8.14
            COLUMN-FONT 0
  ENABLE
      FacCPedi.FchEnt
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 138 BY 10.46 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      FacDPedi.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U COLUMN-FONT 0
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 46.43 COLUMN-FONT 0
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 16.43
            COLUMN-FONT 0
      FacDPedi.UndVta FORMAT "x(8)":U COLUMN-FONT 0
      FacDPedi.CanPed FORMAT ">,>>>,>>9.9999":U WIDTH 11.14 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 93.86 BY 12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-4 AT ROW 3.15 COL 2.14 WIDGET-ID 200
     BUTTON-8 AT ROW 19.04 COL 103 WIDGET-ID 132
     RADIO-SET-estado AT ROW 1 COL 34 NO-LABEL WIDGET-ID 124
     BUTTON-4 AT ROW 15.81 COL 103 WIDGET-ID 122
     FILL-IN-contenga AT ROW 2.04 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 104
     txtFechaAbastecimiento AT ROW 1.12 COL 105.72 COLON-ALIGNED WIDGET-ID 98
     BUTTON-1 AT ROW 1.19 COL 128 WIDGET-ID 100
     BROWSE-5 AT ROW 14 COL 2.14 WIDGET-ID 300
     BUTTON-2 AT ROW 14.27 COL 98.86 WIDGET-ID 116
     BUTTON-3 AT ROW 14.27 COL 119.43 WIDGET-ID 118
     txtFechaTope AT ROW 2.12 COL 105.72 COLON-ALIGNED WIDGET-ID 128
     BUTTON-5 AT ROW 17.42 COL 111.57 WIDGET-ID 130
     "Que contengan" VIEW-AS TEXT
          SIZE 14.86 BY .62 AT ROW 1.38 COL 4.43 WIDGET-ID 106
          FGCOLOR 9 FONT 6
     "DobleClick en Nro PCO para autorizar." VIEW-AS TEXT
          SIZE 32 BY .62 AT ROW 2.54 COL 44 WIDGET-ID 120
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.14 BY 25.38 WIDGET-ID 100.


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
         TITLE              = "Validacion y verificacion de PCO"
         HEIGHT             = 25.38
         WIDTH              = 142.14
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
/* BROWSE-TAB BROWSE-5 BUTTON-1 F-Main */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

ASSIGN 
       BUTTON-3:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN txtFechaAbastecimiento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtFechaTope IN FRAME F-Main
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
     _Where[2]         = "facdpedi.canped > 0"
     _FldNameList[1]   > "_<CALC>"
"estado(faccpedi.coddoc,faccpedi.nroped) @ x-estado" "Estado" "x(15)" ? ? ? 0 ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" "Cotizacion" ? "character" ? ? 0 ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Nro. PCO" ? "character" ? ? 0 ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre del Cliente" ? "character" ? ? 0 ? ? ? no ? no no "35.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Generado" ? "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.CodDiv
"FacCPedi.CodDiv" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"calcula-peso(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso" "Peso!Autorizado" "->>,>>>,>>9.99" ? ? ? 0 ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"calcula-importe(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe" "Importe!Autorizado" "->>,>>>,>>9.99" ? ? ? 0 ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"calcula-peso-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-peso-x-atender" "Peso!x Atender" ? ? ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"calcula-importe-x-atender(faccpedi.coddoc,faccpedi.nroped) @ x-col-importe-x-atender" "Importe!x Atender" "->>,>>>,>>9.99" ? ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Entrega" ? "date" ? ? 0 ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.FacCPedi.Libre_f01
"FacCPedi.Libre_f01" "Abastecimiento" "99/99/9999" "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.FacCPedi.Libre_f02
"FacCPedi.Libre_f02" "Fecha Tope" "99/99/9999" "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.FacCPedi.Libre_c01
"FacCPedi.Libre_c01" "Lista" "x(6)" "character" ? ? 0 ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.FacDPedi,INTEGRAL.Almmmatg WHERE INTEGRAL.FacDPedi ..."
     _Options          = "NO-LOCK"
     _Where[1]         = "FacDPedi.CodCia = s-codcia and
facdpedi.coddoc = x-coddoc and
facdpedi.nroped = x-nroped and
facdpedi.canped > 0"
     _JoinCode[2]      = "FacDPedi.CodCia = Almmmatg.CodCia and
FacDPedi.codmat =  Almmmatg.codmat"
     _FldNameList[1]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Codigo" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? 0 ? ? ? no ? no no "46.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? 0 ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacDPedi.UndVta
"FacDPedi.UndVta" ? ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" ? ? "decimal" ? ? 0 ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Validacion y verificacion de PCO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Validacion y verificacion de PCO */
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
   /* RUN calcula-peso-importe.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:

    ASSIGN txtFechaTope txtFechaAbastecimiento.

  IF AVAILABLE faccpedi THEN DO:
      RUN lgc/w-validacion-pco-grabar.r(INPUT faccpedi.coddoc, INPUT faccpedi.nroped).      

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
   /* RUN calcula-peso-importe.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt BROWSE-4 _BROWSE-COLUMN W-Win
ON ENTRY OF FacCPedi.FchEnt IN BROWSE BROWSE-4 /* Entrega */
DO:
  
    IF faccpedi.flgest = 'T' THEN DO:
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FchEnt BROWSE-4 _BROWSE-COLUMN W-Win
ON LEAVE OF FacCPedi.FchEnt IN BROWSE BROWSE-4 /* Entrega */
DO:
  DEFINE VAR x-nueva-fecha-entrega AS DATE.

  x-nueva-fecha-entrega = DATE(faccpedi.fchent:SCREEN-VALUE IN BROWSE BROWSE-4).

  IF x-nueva-fecha-entrega < faccpedi.libre_f01 THEN DO:
      MESSAGE "La fecha de Entrega debe se mayor a la fecha de abastecimiento".
      APPLY 'entry':u TO faccpedi.fchent IN BROWSE browse-4. 
      RETURN "ADM-ERROR".
  END.
  IF x-nueva-fecha-entrega > faccpedi.libre_f02 THEN DO:
      MESSAGE "La fecha de Entrega NO debe se mayor a la fecha tope".
      APPLY 'entry':u TO faccpedi.fchent IN BROWSE browse-4. 
      RETURN "ADM-ERROR".
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refrescar */
DO:

    ASSIGN fill-in-contenga RADIO-SET-estado.

    x-filtro-estado = RADIO-SET-estado.
    x-que-contenga = "".
    IF fill-in-contenga <> "" THEN DO:
        x-que-contenga = "*" + fill-in-contenga + "*".
    END.

  {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Autorizacion Masiva */
DO:

    ASSIGN txtFechaTope txtFechaAbastecimiento.

  RUN autorizacion-masivo.

 {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Rechazar masivo */
DO:

    ASSIGN txtFechaTope txtFechaAbastecimiento.

  RUN desautorizacion-masivo.

 {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Adicionar Articulos desde la Cotizacion */
DO:
  IF AVAILABLE faccpedi THEN DO:
     IF faccpedi.flgest = 'G' THEN DO:
         RUN lgc/w-verificacion-pco-add-items.r(INPUT faccpedi.coddoc, INPUT faccpedi.nroped).
         {&OPEN-QUERY-BROWSE-5}
          /* RUN calcula-peso-importe.*/
     END.
     ELSE DO:
         MESSAGE "La PCO ya esta autorizada imppsible adicionarle Items".
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Desautorizar */
DO:

  DEFINE VAR x-pass-valido AS CHAR.
  DEFINE VAR x-clave AS CHAR FORMAT 'x(25)'.

  DEFINE BUFFER b-faccpedi FOR faccpedi.

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'ABASTECIMIENTO' AND
                          vtatabla.llave_c1 = 'CONFIG' 
                          NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:

      IF AVAILABLE faccpedi THEN DO:
         IF faccpedi.flgest = 'T' THEN DO:
                UPDATE
                    SKIP(.5)
                    SPACE(2)
                    x-clave PASSWORD-FIELD
                    SPACE(2)
                    SKIP(.5)
                    WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
                    NO-LABEL TITLE "Ingrese Clave".
                ASSIGN x-clave.
                IF vtatabla.libre_c03 = x-clave  THEN DO:
                    SESSION:SET-WAIT-STATE("GENERAL").
                    FIND FIRST b-faccpedi OF faccpedi EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE b-faccpedi THEN DO:
                        ASSIGN b-faccpedi.flgest = 'G'.
                        RELEASE b-faccpedi.
                    END.
                    BROWSE-4:REFRESH().
                    SESSION:SET-WAIT-STATE("").
                END.
                ELSE DO:
                    MESSAGE
                        "CLAVE INCORRECTA"
                        VIEW-AS ALERT-BOX ERROR.
                END.
    
         END.
         ELSE DO:
             MESSAGE "La PCO aun NO esta Autorizada!!!".
         END.
      END.
  END.
  ELSE DO:
      MESSAGE "No ha definido el password, para este proceso".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Procesados sin Pedido a Autorizados */
DO:

    ASSIGN txtFechaTope txtFechaAbastecimiento.

  RUN procesado-a-autorizado.

 {&OPEN-QUERY-BROWSE-4}
      RUN calcula-peso-importe.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE a-autorizado-pco W-Win 
PROCEDURE a-autorizado-pco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pMsgError AS CHAR NO-UNDO.

pMsgError = "".

DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER z-faccpedi FOR faccpedi.

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER b-faccpedi FOR faccpedi.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND 
                            x-faccpedi.nroped = pNroPed AND 
                            x-faccpedi.flgest = 'P' NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO ya NO esta procesada".
    RETURN.
END.

/* Verificamos que la PCO no tenga pedido emitido */
FIND FIRST z-faccpedi WHERE z-faccpedi.codcia = s-codcia AND 
                            z-faccpedi.coddoc = 'PED' AND
                            z-faccpedi.coddoc = x-faccpedi.codref AND       /* Cotizacion */
                            z-faccpedi.nroped = x-faccpedi.nroref AND
                            z-faccpedi.codorigen = x-faccpedi.coddoc AND    /* PCO */
                            z-faccpedi.nroorigen = x-faccpedi.nroped
                            /*x-faccpedi.flgest <> 'A' */ NO-LOCK NO-ERROR.
IF AVAILABLE z-faccpedi THEN DO:
    pMsgError = "La PCO tiene Pedido generado".
    RETURN.
END.

FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                            x-facdpedi.coddoc = pCodDOc AND
                            x-facdpedi.nroped = pNroPed AND
                            x-facdpedi.canped > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-facdpedi THEN DO:
    pMsgError = "La PCO no tiene ningun articulo para trabajar ".
    RETURN.
END.

DEFINE VAR x-proceso-ok AS LOG INIT NO.
pMsgError = "".

SESSION:SET-WAIT-STATE("GENERAL").

GRABAR_DATOS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
  DO:
    /* Order update block */
      FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                  b-faccpedi.coddoc = pCodDoc AND 
                                  b-faccpedi.nroped = pNroPed AND 
                                  b-faccpedi.flgest = 'P' EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF NOT AVAILABLE x-faccpedi THEN DO:
          pMsgError = "La PCO ya NO esta procesada".
          UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
      END.
      ELSE DO:
          ASSIGN b-faccpedi.flgest = 'T'
                b-faccpedi.fchent = txtFechaAbastecimiento
                b-faccpedi.libre_f01 = txtFechaAbastecimiento
                b-faccpedi.libre_f02 = txtFechaTope.
      END.

  END.
  FOR EACH x-facdpedi OF x-faccpedi NO-LOCK ON ERROR UNDO, THROW:
    /* OrderLine update block */
      /* Eliminar en VTADDOCU */
      FIND FIRST vtaddocu WHERE vtaddocu.codcia = x-facdpedi.codcia AND
                                  vtaddocu.codped = x-faccpedi.coddoc AND
                                  vtaddocu.nroped = x-faccpedi.nroped AND 
                                  vtaddocu.codmat = x-facdpedi.codmat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE vtaddocu THEN DO:
          DELETE vtaddocu.
          /**/
      END.
      ELSE DO:
          UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
      END.

  END.
  x-proceso-ok = YES.
END. /* TRANSACTION block */

IF x-proceso-ok = YES THEN pMsgError = "OK".

SESSION:SET-WAIT-STATE("").

RELEASE b-faccpedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autorizacion-masivo W-Win 
PROCEDURE autorizacion-masivo :
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
        MESSAGE 'Seguro de trabajar la(s) ' + STRING(x-cotizaciones) + ' Cotizacion(es) ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN.

   
    DO x-sec = 1 TO x-cotizaciones:
        IF browse-4:FETCH-SELECTED-ROW(x-sec) THEN DO:
            x-coddoc = {&FIRST-TABLE-IN-QUERY-browse-4}.coddoc.
            x-nroped = {&FIRST-TABLE-IN-QUERY-browse-4}.nroped.
            x-msgerror = "".
            RUN autorizar-pco(INPUT x-coddoc, INPUT x-nroped, OUTPUT x-msgerror).
            /*
            MESSAGE "x-nroped " x-nroped SKIP
                "x-msgerror " x-msgerror.
            */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autorizar-pco W-Win 
PROCEDURE autorizar-pco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pMsgError AS CHAR.

pMsgError = "".

DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER b-faccpedi FOR faccpedi.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND 
                            x-faccpedi.nroped = pNroPed AND 
                            (x-faccpedi.flgest = 'G' OR x-faccpedi.flgest = 'T') NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO ya no esta generada".
    RETURN.
END.
FIND FIRST x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                            x-facdpedi.coddoc = pCodDOc AND
                            x-facdpedi.nroped = pNroPed AND
                            x-facdpedi.canped > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-facdpedi THEN DO:
    pMsgError = "La PCO no tiene ningun articulo para trabajar ".
    RETURN.
END.
/*
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND
                            x-faccpedi.nroped = pNroPed AND
                            x-faccpedi.flgest <> 'A'
                            NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La cotizacion es anulada".
    RETURN.
END.
*/
pMsgError = "".
DEFINE VAR x-proceso-ok AS LOG INIT NO.

FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = pCodDoc AND 
                            b-faccpedi.nroped = pNroPed AND 
                            (b-faccpedi.flgest = 'G' OR b-faccpedi.flgest = 'T') EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO ya no esta generada".
END.
ELSE DO:
    ASSIGN b-faccpedi.flgest = 'T'
            b-faccpedi.libre_f01 = txtFechaAbastecimiento
            b-faccpedi.libre_f02 = txtFechaTope
    .
END.

x-proceso-ok = YES.

IF x-proceso-ok = YES THEN pMsgError = "OK".

/*
SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR x-corre AS INT.
DEFINE VAR x-proceso-ok AS LOG.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.

FOR EACH b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.codref = 'COT' AND
                            b-faccpedi.nroref = x-faccpedi.nroped NO-LOCK:
    x-corre = x-corre + 1.
END.
x-corre = x-corre + 1.

x-proceso-ok = NO.
DO TRANSACTION ON ERROR UNDO, LEAVE:
    CREATE b-faccpedi.
    BUFFER-COPY x-faccpedi EXCEPT coddoc nroped TO b-faccpedi.

    x-nroped = x-faccpedi.nroped + "-" + STRING(x-corre).
    ASSIGN b-faccpedi.coddoc = 'PCO'
            b-faccpedi.nroped = x-nroped
            b-faccpedi.codref = x-faccpedi.coddoc
            b-faccpedi.nroref = x-faccpedi.nroped
            b-faccpedi.fchped = TODAY
            b-faccpedi.fchent = txtUltFechaTope
            b-faccpedi.hora = STRING(TIME,"HH:MM:SS")
            b-faccpedi.usuario = s-user-id                
            b-faccpedi.flgest  = 'G'.

    FOR EACH x-facdpedi OF x-faccpedi WHERE (x-facdpedi.canped - x-facdpedi.canate) > 0 ON ERROR UNDO, THROW:
        FIND FIRST facdpedi WHERE facdpedi.codcia = x-facdpedi.codcia AND
                                    facdpedi.coddoc = x-faccpedi.coddoc AND
                                    facdpedi.nroped = x-faccpedi.nroped AND 
                                    facdpedi.codmat = x-facdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN facdpedi.canate = facdpedi.canate + (x-facdpedi.canped - x-facdpedi.canate).
            /**/
            CREATE b-facdpedi.
            BUFFER-COPY x-facdpedi EXCEPT coddoc nroped TO b-facdpedi.
            ASSIGN  b-facdpedi.coddoc = b-faccpedi.coddoc
                    b-facdpedi.nroped = b-faccpedi.nroped
                    b-facdpedi.canped = (x-facdpedi.canped - x-facdpedi.canate).
        END.
    END.
    x-proceso-ok = YES.
END.
*/

RELEASE b-faccpedi.

IF x-proceso-ok = YES THEN pMsgError = "OK".

SESSION:SET-WAIT-STATE("").

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
        x-peso = x-peso + (facdpedi.canped * x-almmmatg.pesmat).
    END.
    x-precio = if( facdpedi.libre_d05 > 0) THEN facdpedi.implin / facdpedi.libre_d05 ELSE 0.
    x-importe = x-importe + (facdpedi.canped * x-precio).
    GET NEXT BROWSE-5.
END.
/*
fill-in-peso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-peso,"->>,>>>,>>9.99").
fill-in-importe:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-importe,"->>,>>>,>>9.99").
*/
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desautorizacion-masivo W-Win 
PROCEDURE desautorizacion-masivo :
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

    IF x-cotizaciones < 1 THEN DO:
        MESSAGE "Debe seleccionar al menos 1 a mas cotizaciones".
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
            RUN desautorizar-pco(INPUT x-coddoc, INPUT x-nroped, OUTPUT x-msgerror).
            /*
            MESSAGE "x-nroped " x-nroped SKIP
                "x-msgerror " x-msgerror.
            */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desautorizar-pco W-Win 
PROCEDURE desautorizar-pco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pMsgError AS CHAR.

pMsgError = "".

DEFINE BUFFER x-facdpedi FOR facdpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                            x-faccpedi.coddoc = pCodDoc AND 
                            x-faccpedi.nroped = pNroPed AND 
                            x-faccpedi.flgest = 'G' NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO aun no esta Generada".
    RETURN.
END.

pMsgError = "".
/*
DEFINE VAR x-proceso-ok AS LOG INIT NO.

FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = pCodDoc AND 
                            b-faccpedi.nroped = pNroPed AND 
                            b-faccpedi.flgest = 'G' NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO ya no esta generada".
END.
ELSE DO:
    ASSIGN b-faccpedi.flgest = 'T'.
END.

x-proceso-ok = YES.

IF x-proceso-ok = YES THEN pMsgError = "OK".
*/

DEFINE VAR x-corre AS INT.
DEFINE VAR x-proceso-ok AS LOG.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.
/*
FOR EACH b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.codref = 'COT' AND
                            b-faccpedi.nroref = x-faccpedi.nroped NO-LOCK:
    x-corre = x-corre + 1.
END.
x-corre = x-corre + 1.
*/

FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = pCodDoc AND 
                            b-faccpedi.nroped = pNroPed AND 
                            b-faccpedi.flgest = 'G' NO-LOCK NO-ERROR.
IF NOT AVAILABLE x-faccpedi THEN DO:
    pMsgError = "La PCO aun no esta Generada".
    RETURN.
END.

SESSION:SET-WAIT-STATE("GENERAL").
x-proceso-ok = NO.
DO TRANSACTION ON ERROR UNDO, LEAVE:

    FOR EACH x-facdpedi OF x-faccpedi WHERE x-facdpedi.canped > 0 ON ERROR UNDO, THROW:
        /* Rebajar la cotizacion */
        FIND FIRST facdpedi WHERE facdpedi.codcia = x-facdpedi.codcia AND
                                    facdpedi.coddoc = x-faccpedi.codref AND
                                    facdpedi.nroped = x-faccpedi.nroref AND 
                                    facdpedi.codmat = x-facdpedi.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE facdpedi THEN DO:
            ASSIGN facdpedi.canate = facdpedi.canate - x-facdpedi.canped.
            /**/
        END.
    END.
    /* Marco la PCO como ANULADA */
    FIND CURRENT b-faccpedi EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN b-faccpedi.flgest = 'A'.

    x-proceso-ok = YES.
END.

RELEASE b-faccpedi.
RELEASE b-facdpedi.

IF x-proceso-ok = YES THEN pMsgError = "OK".

SESSION:SET-WAIT-STATE("").


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
  DISPLAY RADIO-SET-estado FILL-IN-contenga txtFechaAbastecimiento txtFechaTope 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-4 BUTTON-8 RADIO-SET-estado BUTTON-4 FILL-IN-contenga BUTTON-1 
         BROWSE-5 BUTTON-2 BUTTON-3 BUTTON-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

      txtFechaAbastecimiento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 1,"99/99/9999").
    txtFechaTope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 7,"99/99/9999").
      
  END.



  /* Ferias */
  x-lista-precios = "".
  FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia AND 
                            gn-divi.canalventa = 'FER' NO-LOCK.
      x-lista-precios = x-lista-precios + IF(x-lista-precios = "") THEN "" ELSE ",".
      x-lista-precios = x-lista-precios + TRIM(gn-divi.coddiv).
  END.

  {&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesado-a-autorizado W-Win 
PROCEDURE procesado-a-autorizado :
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

    IF x-cotizaciones < 1 THEN DO:
        MESSAGE "Debe seleccionar al menos 1 a mas PCOs".
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
            RUN a-autorizado-pco(INPUT x-coddoc, INPUT x-nroped, OUTPUT x-msgerror).

            IF x-msgerror = 'OK' THEN x-cotizaciones-ok = x-cotizaciones-ok + 1.
        END.
    END.
    
    MESSAGE "Se procesaron " + STRING(x-cotizaciones-ok) + " de " + 
        STRING(x-cotizaciones) + " cotizaciones seleecionadas".

    {&OPEN-QUERY-BROWSE-4}

END.


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
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "FacCPedi"}

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
                                x-facdpedi.nroped = pNroPed AND
                                x-facdpedi.canped  > 0 NO-LOCK:
      x-precio = if(x-facdpedi.libre_d05 > 0) THEN x-facdpedi.implin / x-facdpedi.libre_d05 ELSE 0.
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
                                    x-facdpedi.coddoc = x-codref AND
                                    x-facdpedi.nroped = x-nroref AND
                                    (x-facdpedi.canped - x-facdpedi.canate)  > 0 NO-LOCK:
          x-precio = x-facdpedi.implin / (x-facdpedi.canped - x-facdpedi.canate).
          x-retval = x-retval + ((x-facdpedi.canped - x-facdpedi.canate) * x-precio).

      END.

  END.


  RETURN x-retval.   /* Function return value. */

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
                                x-facdpedi.canped > 0 NO-LOCK:
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
        /* La cotizacion */
        x-codref = x-faccpedi.codref.
        x-nroref = x-faccpedi.nroref.

        FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                      x-facdpedi.coddoc = x-codref AND
                                      x-facdpedi.nroped = x-nroref AND
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION estado W-Win 
FUNCTION estado RETURNS CHARACTER
    ( INPUT pCoddoc AS CHAR, INPUT pNroPed AS CHAR ) :
   /*------------------------------------------------------------------------------
     Purpose:  
       Notes:  
   ------------------------------------------------------------------------------*/
     DEFINE BUFFER x-facdpedi FOR facdpedi.
     DEFINE BUFFER x-faccpedi FOR faccpedi.

     DEFINE VAR x-retval AS CHAR INIT "???????".

     /* El pCoddoc y pNroPed es el PCO */
     FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                   x-faccpedi.coddoc = pCodDoc AND 
                                   x-faccpedi.nroped = pNroPed NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        IF x-faccpedi.flgest = 'G' THEN x-retval = "GENERADO".
        IF x-faccpedi.flgest = 'T' THEN x-retval = "AUTORIZADO".
        IF x-faccpedi.flgest = 'P' THEN x-retval = "PROCESADO".
    END.

    RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

