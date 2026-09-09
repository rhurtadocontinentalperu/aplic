&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE TEMP-TABLE PEDIDO NO-UNDO LIKE FacCPedi.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion ( ~
FacCPedi.CodCia = s-codcia AND ~
FacCPedi.DivDes = s-CodDiv AND ~
LOOKUP(FacCpedi.FlgEst, 'P,C') > 0 AND ~
LOOKUP(FacCPedi.CodDoc, 'O/D,O/M,OTR') > 0 AND ~
FacCPedi.FchEnt >= (TODAY - 7) AND ~
(FILL-IN_NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN_NomCli) > 0) AND ~
(FILL-IN_NroPed = '' OR FacCPedi.NroPed = FILL-IN_NroPed) ~
)



/*
FacCPedi.Libre_c02
*/

DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-Sku AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 GN-DIVI.DesDiv FacCPedi.CodDoc ~
FacCPedi.NroPed FacCPedi.FchPed FacCPedi.FchEnt FacCPedi.NomCli ~
fPeso() @ x-Peso fVolumen() @ x-Volumen fSku() @ x-Sku 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi  NO-LOCK ~
    BY FacCPedi.NomCli ~
       BY FacCPedi.FchEnt INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST GN-DIVI OF FacCPedi  NO-LOCK ~
    BY FacCPedi.NomCli ~
       BY FacCPedi.FchEnt INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 FILL-IN_FchEnt BUTTON-1 BUTTON-21 ~
BtnDone FILL-IN_NomCli BUTTON-Filtrar FILL-IN_NroPed BUTTON-Limpiar ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_FchEnt FILL-IN_NomCli ~
FILL-IN_NroPed 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSku W-Win 
FUNCTION fSku RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 9 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.35.

DEFINE BUTTON BUTTON-21 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 21" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN_FchEnt AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.35
     FGCOLOR 0 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(12)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 140 BY 2.69
     BGCOLOR 15 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi, 
      GN-DIVI
    FIELDS(GN-DIVI.DesDiv) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      GN-DIVI.DesDiv COLUMN-LABEL "Solicitante" FORMAT "X(30)":U
            WIDTH 27.43
      FacCPedi.CodDoc COLUMN-LABEL "Docum." FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      FacCPedi.FchPed COLUMN-LABEL "Fecha Emisión" FORMAT "99/99/9999":U
      FacCPedi.FchEnt FORMAT "99/99/9999":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      FacCPedi.NomCli FORMAT "x(60)":U WIDTH 44.43
      fPeso() @ x-Peso COLUMN-LABEL "Peso en kg" WIDTH 9.43
      fVolumen() @ x-Volumen COLUMN-LABEL "Volumen en m3" WIDTH 10.72
      fSku() @ x-Sku COLUMN-LABEL "# SKU" FORMAT ">>>9":U WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 20.46
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_FchEnt AT ROW 1.27 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 1.27 COL 62 WIDGET-ID 50
     BUTTON-21 AT ROW 1.27 COL 71 WIDGET-ID 12
     BtnDone AT ROW 1.27 COL 134 WIDGET-ID 10
     FILL-IN_NomCli AT ROW 3.42 COL 17 COLON-ALIGNED WIDGET-ID 52
     BUTTON-Filtrar AT ROW 3.42 COL 69 WIDGET-ID 56
     FILL-IN_NroPed AT ROW 4.23 COL 17 COLON-ALIGNED WIDGET-ID 54
     BUTTON-Limpiar AT ROW 4.5 COL 69 WIDGET-ID 58
     BROWSE-2 AT ROW 5.85 COL 3 WIDGET-ID 200
     "Filtros" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 2.88 COL 3 WIDGET-ID 62
          BGCOLOR 9 FGCOLOR 15 
     "Nueva Fecha de Entrega:" VIEW-AS TEXT
          SIZE 35 BY 1.08 AT ROW 1.38 COL 11.57 WIDGET-ID 4
          FONT 11
     RECT-11 AT ROW 3.15 COL 3 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPROGRAMACION DE FECHA DE ENTREGA"
         HEIGHT             = 25.85
         WIDTH              = 144.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 BUTTON-Limpiar F-Main */
ASSIGN 
       BROWSE-2:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi "
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "INTEGRAL.FacCPedi.NomCli|yes,INTEGRAL.FacCPedi.FchEnt|yes"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" "Solicitante" "X(30)" "character" ? ? ? ? ? ? no ? no no "27.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Docum." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" ? ? "date" 14 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "44.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fPeso() @ x-Peso" "Peso en kg" ? ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fVolumen() @ x-Volumen" "Volumen en m3" ? ? ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fSku() @ x-Sku" "# SKU" ">>>9" ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPROGRAMACION DE FECHA DE ENTREGA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPROGRAMACION DE FECHA DE ENTREGA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON START-SEARCH OF BROWSE-2 IN FRAME F-Main
DO:
  DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
  DEFINE VARIABLE cLabelColumn  AS CHAR.
  DEFINE VARIABLE cNameColumn  AS CHAR.
  DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

  hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
  cLabelColumn = hSortColumn:LABEL.
  cNameColumn = hSortColumn:NAME.
  IF cNameColumn = "x-Peso" OR cNameColumn = "x-Volumen" OR cNameColumn = "x-Sku" THEN RETURN NO-APPLY.
  hQueryHandle = BROWSE {&BROWSE-NAME}:QUERY.
  hQueryHandle:QUERY-CLOSE().
  hQueryHandle:QUERY-PREPARE("FOR EACH FacCPedi NO-LOCK" + " WHERE " +
                             "FacCPedi.CodCia = " + STRING(s-codcia) + " AND " +
                             "FacCPedi.DivDes = " + "'" + s-coddiv + "'" + " AND " +
                             "LOOKUP(FacCpedi.FlgEst, 'P,C') > 0 AND " +
                             "LOOKUP(FacCPedi.CodDoc, 'O/D,O/M,OTR') > 0 AND " +
                             "FacCPedi.FchEnt >= (TODAY - 7) AND " +
                             "('" + FILL-IN_NomCli + "' = '' OR INDEX(FacCPedi.NomCli, '" + FILL-IN_NomCli + "') > 0) AND " +
                             "('" + FILL-IN_NroPed + "' = '' OR FacCPedi.NroPed = '" + FILL-IN_NroPed + "')" + ", " +
                             "FIRST GN-DIVI OF FacCPedi NO-LOCK" + 
                             " BY " + hSortColumn:NAME + " INDEXED-REPOSITION").
  SESSION:SET-WAIT-STATE('GENERAL').
  hQueryHandle:QUERY-OPEN().
  SESSION:SET-WAIT-STATE('').
END.

/*
&SCOPED-DEFINE Condicion ( ~
FacCPedi.CodCia = s-codcia AND ~
FacCPedi.DivDes = s-CodDiv AND ~
LOOKUP(FacCpedi.FlgEst, 'P,C') > 0 AND ~
LOOKUP(FacCPedi.CodDoc, 'O/D,O/M,OTR') > 0 AND ~
FacCPedi.FchEnt >= (TODAY - 7) AND ~
(FILL-IN_NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN_NomCli) > 0) AND ~
(FILL-IN_NroPed = '' OR FacCPedi.NroPed = FILL-IN_NroPed) ~
)

FOR EACH FacCPedi
      WHERE {&Condicion} NO-LOCK,
      FIRST GN-DIVI OF FacCPedi  NO-LOCK
    BY INTEGRAL.FacCPedi.NomCli 
     BY INTEGRAL.FacCPedi.FchEnt INDEXED-REPOSITION:
     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN src/bin/_calenda.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  DISPLAY RETURN-VALUE @ FILL-IN_FchEnt WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-21
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-21 W-Win
ON CHOOSE OF BUTTON-21 IN FRAME F-Main /* Button 21 */
DO:
  ASSIGN FILL-IN_FchEnt.
  
  IF FILL-IN_FchEnt = ? THEN DO:
      MESSAGE 'Debe ingresar una fecha válida' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_FchEnt.
      RETURN NO-APPLY.
  END.
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
      MESSAGE 'Debe seleccionar al menos un registro' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_FchEnt.
      RETURN NO-APPLY.
  END.
  RUN Cambia-Fecha.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN FILL-IN_NomCli FILL-IN_NroPed.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR FILTRO */
DO:
    ASSIGN 
        FILL-IN_NomCli = ''
        FILL-IN_NroPed = ''.
    DISPLAY FILL-IN_NomCli FILL-IN_NroPed WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cambia-Fecha W-Win 
PROCEDURE Cambia-Fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.

/* RHC 19/10/2017 Consistencia de fecha de entrega */
/* IF FILL-IN_FchEnt <= TODAY THEN DO:                            */
/*     MESSAGE 'Fecha de Entrega Errada' VIEW-AS ALERT-BOX ERROR. */
/*     APPLY 'ENTRY':U TO FILL-IN_FchEnt IN FRAME {&FRAME-NAME}.  */
/*     RETURN.                                                    */
/* END.                                                           */
/* DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:                   */
/*     IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:                                   */
/*         IF {&Condicion} THEN DO:                                                       */
/*             IF FILL-IN_FchEnt > FacCPedi.FchEnt THEN DO:                               */
/*                 MESSAGE 'ERROR en el documento:'  FacCPedi.CodDoc FacCPedi.NroPed SKIP */
/*                     '      Fecha de entrega:' FacCPedi.Fchent SKIP                     */
/*                     'Nueva Fecha de entrega:' FILL-IN_FchEnt SKIP                      */
/*                     'La nueva fecha debe ser mayor' SKIP                               */
/*                     'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.                      */
/*                 APPLY 'ENTRY':U TO FILL-IN_FchEnt IN FRAME {&FRAME-NAME}.              */
/*                 RETURN.                                                                */
/*             END.                                                                       */
/*         END.                                                                           */
/*     END.                                                                               */
/* END.                                                                                   */

DEFINE BUFFER xb-VtaCDocu FOR VtaCDocu.
DEFINE BUFFER b-faccpedi FOR Faccpedi.
DEFINE VAR x-rowid AS ROWID.
DEFINE VAR pMensaje AS CHAR NO-UNDO.


DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        IF {&Condicion} THEN DO:
            /* Filtro de fecha */
            IF ABS(FILL-IN_FchEnt - Faccpedi.FchEnt) > 3 THEN DO:
                MESSAGE 'ERROR documento:' Faccpedi.coddoc Faccpedi.nroped SKIP
                    'La nueva fecha de entrega NO debe ser mayor o menor a tres días' SKIP
                    'del día' Faccpedi.fchent SKIP
                    'Pasamos al siguiente registro' VIEW-AS ALERT-BOX ERROR.
                NEXT.
            END.
            /* **************** */
            FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(Faccpedi) EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN NEXT.
            ASSIGN
                B-CPEDI.FchEnt = FILL-IN_FchEnt.
            ASSIGN
                B-CPEDI.FchVen = B-CPEDI.FchEnt + 7
                B-CPEDI.FecAct = TODAY
                B-CPEDI.HorAct = STRING(TIME,'HH:MM:SS')
                B-CPEDI.UsrAct = s-user-id.
            /* *********************** */
            /* RHC 24/01/2020 Caso O/D */
            /* *********************** */
            IF B-CPEDI.CodDoc = "O/D" THEN DO:
                FIND FIRST PEDIDO WHERE PEDIDO.codcia = B-CPEDI.codcia AND
                    PEDIDO.coddoc = B-CPEDI.codref AND
                    PEDIDO.nroped = B-CPEDI.nroref AND
                    PEDIDO.flgest <> "A" NO-LOCK NO-ERROR.
                IF AVAILABLE PEDIDO THEN DO:
                    FIND CURRENT PEDIDO EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                        UNDO, LEAVE.
                    END.
                    ASSIGN
                        PEDIDO.FchEnt = B-CPEDI.FchEnt.
                END.
            END.
            /* *********************** */
            IF B-CPEDI.CodDoc = "OTR" AND B-CPEDI.CodRef = "R/A" AND b-cpedi.tpoped <> 'XD' THEN DO:
                FIND FIRST Almcrepo WHERE almcrepo.CodCia = B-CPEDI.codcia AND
                    almcrepo.AlmPed = B-CPEDI.codalm AND 
                    almcrepo.NroSer = INTEGER(SUBSTRING(B-CPEDI.nroref,1,3)) AND
                    almcrepo.NroDoc = INTEGER(SUBSTRING(B-CPEDI.nroref,4))
                    EXCLUSIVE-LOCK NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    MESSAGE 'R/A ' B-CPEDI.nroref 'en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                    UNDO, LEAVE.
                END.
                ASSIGN
                    Almcrepo.Fecha = B-CPEDI.FchEnt.
                RELEASE Almcrepo.
            END.
            IF B-CPEDI.CodDoc = "OTR" AND B-CPEDI.CodRef = "PED" THEN DO:
                FIND b-faccpedi WHERE b-faccpedi.codcia = s-codcia
                    AND b-faccpedi.coddoc = B-CPEDI.codref
                    AND b-faccpedi.nroped = B-CPEDI.nroref
                    EXCLUSIVE-LOCK NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    MESSAGE 'Este documento' B-CPEDI.codref B-CPEDI.nroref 'en uso por otro usuario' VIEW-AS ALERT-BOX ERROR.
                    UNDO, LEAVE.
                END.
                ASSIGN
                    b-FacCPedi.FchEnt = B-CPEDI.FchEnt.
                RELEASE b-faccpedi.
            END.
            /* Ic - 18Ene2018, debe considerar SubOrdenes */
            FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                            VtaCDocu.codped = B-CPEDI.CodDoc AND 
                            VtaCDocu.nroped BEGINS B-CPEDI.nroped NO-LOCK:                
                x-rowid = ROWID(VtaCDocu).
                FIND FIRST xb-VtaCDocu WHERE ROWID(xb-VtaCDocu) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE xb-VtaCDocu THEN xb-VtaCDocu.fchent = B-CPEDI.FchEnt.
            END.
            /* RHC 29/11/2019 HPK */
            FOR EACH VtaCDocu WHERE VtaCDocu.codcia = s-codcia AND 
                VtaCDocu.coddiv = s-coddiv AND
                VtaCDocu.codped = "HPK" AND
                VtaCDocu.codref = B-CPEDI.CodDoc AND 
                VtaCDocu.nroref = B-CPEDI.nroped NO-LOCK:                
                x-rowid = ROWID(VtaCDocu).
                FIND FIRST xb-VtaCDocu WHERE ROWID(xb-VtaCDocu) = x-rowid EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE xb-VtaCDocu THEN xb-VtaCDocu.fchent = B-CPEDI.FchEnt.
            END.
            IF AVAILABLE(PEDIDO) THEN RELEASE PEDIDO.
            RELEASE xb-VtaCDocu.
            RELEASE B-CPEDI.
        END.
    END.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY FILL-IN_FchEnt FILL-IN_NomCli FILL-IN_NroPed 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-11 FILL-IN_FchEnt BUTTON-1 BUTTON-21 BtnDone FILL-IN_NomCli 
         BUTTON-Filtrar FILL-IN_NroPed BUTTON-Limpiar BROWSE-2 
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
  {src/adm/template/snd-list.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Peso AS DEC NO-UNDO.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Peso = x-Peso + (FacDPedi.CanPed * FacDPedi.Factor * Almmmatg.Pesmat).
  END.
  RETURN x-Peso.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSku W-Win 
FUNCTION fSku RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-SKU AS DEC NO-UNDO.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      x-SKU = x-SKU + 1.
  END.
  RETURN x-SKU.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Volumen AS DEC NO-UNDO.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Volumen = x-Volumen + (FacDPedi.CanPed * FacDPedi.Factor * Almmmatg.Libre_d02 / 1000000).
  END.
  RETURN x-Volumen.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

