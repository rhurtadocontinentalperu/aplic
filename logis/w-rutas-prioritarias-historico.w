&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tw-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.


DEF TEMP-TABLE Detalle NO-UNDO
    FIELD Prioridad AS CHAR FORMAT 'x(8)' LABEL 'Prioridad'
    FIELD Fecha AS DATE FORMAT '99/99/9999' LABEL 'Fecha'
    FIELD PHR AS CHAR FORMAT 'x(15)' LABEL 'PHR'
    FIELD CodDoc AS CHAR FORMAT 'x(8)' LABEL 'Doc.'
    FIELD NroDoc AS CHAR FORMAT 'x(15)' LABEL 'Numero'
    FIELD Hora AS CHAR FORMAT 'x(5)' LABEL 'Hora'
    FIELD NroHPK AS CHAR FORMAT 'x(15)' LABEL 'HPK'
    FIELD EstHPK AS CHAR FORMAT "x(20)" LABEL 'Estado HPK'
    FIELD CodCli AS CHAR FORMAT 'x(15)' LABEL 'Cliente'
    FIELD NomCli AS CHAR FORMAT 'x(100)' LABEL 'Nombre o Razon Social'
    FIELD Peso AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Peso de la Orden en kgs'
    FIELD Items AS INTE FORMAT '->>>,>>>,>>9' LABEL 'Items de la Orden'
    FIELD PesoHPK AS DECI FORMAT '->>>,>>>,>>9.99' LABEL 'Peso de la HPK en kgs'
    FIELD ItemsHPK AS INTE FORMAT '->>>,>>>,>>9' LABEL 'Items de la HPK'
    FIELD LogActual AS CHAR FORMAT 'x(20)' LABEL 'Log Actual'
    FIELD LogAnterior AS CHAR FORMAT 'x(20)' LABEL 'Log Anterior'
    INDEX Idx00 AS PRIMARY Fecha Prioridad PHR
    .
    
DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEF VAR cLog_01 AS CHAR FORMAT 'x(20)' NO-UNDO.
DEF VAR cLog_02 AS CHAR FORMAT 'x(20)' NO-UNDO.
/* 99/99/9999 99:99:99
   12345678901234567890 
   */

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
&Scoped-define INTERNAL-TABLES tw-report

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tw-report.Campo-C[1] ~
tw-report.Campo-D[1] tw-report.Campo-C[3] tw-report.Campo-C[4] ~
tw-report.Campo-C[5] tw-report.Campo-C[11] tw-report.Campo-C[7] ~
tw-report.Campo-C[10] tw-report.Campo-C[8] tw-report.Campo-C[9] ~
tw-report.Campo-F[1] tw-report.Campo-F[2] tw-report.Campo-F[3] ~
tw-report.Campo-F[4] fLogPHR(BUFFER tw-report, 1) @ cLog_01 ~
fLogPHR(BUFFER tw-report, 2) @ cLog_02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tw-report NO-LOCK ~
    BY tw-report.Llave-I ~
       BY tw-report.Campo-C[2] ~
        BY tw-report.Campo-C[3] ~
         BY tw-report.Campo-C[4] ~
          BY tw-report.Campo-C[5] ~
           BY tw-report.Campo-C[6] ~
            BY tw-report.Campo-C[7] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tw-report NO-LOCK ~
    BY tw-report.Llave-I ~
       BY tw-report.Campo-C[2] ~
        BY tw-report.Campo-C[3] ~
         BY tw-report.Campo-C[4] ~
          BY tw-report.Campo-C[5] ~
           BY tw-report.Campo-C[6] ~
            BY tw-report.Campo-C[7] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tw-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tw-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON_Filtrar ~
COMBO-BOX_CodDoc BUTTON_Texto BtnDone FILL-IN_FchDoc-1 BUTTON-1 ~
FILL-IN_FchDoc-2 BUTTON-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDoc FILL-IN_NroDoc ~
FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLogPHR W-Win 
FUNCTION fLogPHR RETURNS CHARACTER
  (   BUFFER btw-report FOR tw-report,
      INPUT iLog AS INTE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 1" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 2" 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON_Filtrar 
     LABEL "FILTRAR" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "TEXTO" 
     SIZE 9 BY 1.62 TOOLTIP "EXPORTAR A TEXTO".

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "X(12)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 163 BY 3.23.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 3.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tw-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tw-report.Campo-C[1] COLUMN-LABEL "Prioridad" FORMAT "X(8)":U
            WIDTH 7.43 COLUMN-FONT 6 LABEL-FONT 6
      tw-report.Campo-D[1] COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      tw-report.Campo-C[3] COLUMN-LABEL "PHR" FORMAT "X(15)":U
      tw-report.Campo-C[4] COLUMN-LABEL "Doc." FORMAT "X(8)":U
      tw-report.Campo-C[5] COLUMN-LABEL "Número" FORMAT "X(15)":U
      tw-report.Campo-C[11] COLUMN-LABEL "Hora" FORMAT "X(5)":U
            WIDTH 5.57
      tw-report.Campo-C[7] COLUMN-LABEL "HPK" FORMAT "X(15)":U
      tw-report.Campo-C[10] COLUMN-LABEL "Estado HPK" FORMAT "X(20)":U
            WIDTH 18.14
      tw-report.Campo-C[8] COLUMN-LABEL "Cliente" FORMAT "X(15)":U
      tw-report.Campo-C[9] COLUMN-LABEL "Nombre o Razón Social" FORMAT "X(80)":U
            WIDTH 65.14
      tw-report.Campo-F[1] COLUMN-LABEL "Peso de la Orden!en kgs" FORMAT "->>>,>>>,>>9.99":U
      tw-report.Campo-F[2] COLUMN-LABEL "Total Items!de la Orden" FORMAT "->>>,>>>,>>9":U
      tw-report.Campo-F[3] COLUMN-LABEL "Peso de la HPK!en kgs" FORMAT "->>>,>>>,>>9.99":U
      tw-report.Campo-F[4] COLUMN-LABEL "Total Items!HPK" FORMAT "->>>,>>>,>>9":U
            WIDTH 8.14
      fLogPHR(BUFFER tw-report, 1) @ cLog_01 COLUMN-LABEL "Log Actual"
            WIDTH 15.43
      fLogPHR(BUFFER tw-report, 2) @ cLog_02 COLUMN-LABEL "Log Anterior"
            WIDTH 15.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 186 BY 20.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON_Filtrar AT ROW 1.27 COL 81 WIDGET-ID 16
     COMBO-BOX_CodDoc AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_NroDoc AT ROW 1.54 COL 35 COLON-ALIGNED WIDGET-ID 12
     BUTTON_Texto AT ROW 1.81 COL 168 WIDGET-ID 34
     BtnDone AT ROW 1.81 COL 180 WIDGET-ID 2
     FILL-IN_FchDoc-1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 26
     BUTTON-1 AT ROW 2.62 COL 30 WIDGET-ID 30
     FILL-IN_FchDoc-2 AT ROW 2.62 COL 39 COLON-ALIGNED WIDGET-ID 28
     BUTTON-2 AT ROW 2.62 COL 50 WIDGET-ID 32
     BROWSE-2 AT ROW 4.23 COL 3 WIDGET-ID 200
     RECT-1 AT ROW 1 COL 3 WIDGET-ID 8
     RECT-2 AT ROW 1 COL 166 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 189.86 BY 24.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tw-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE RUTAS PRIORITARIAS - HISTORICO"
         HEIGHT             = 24.27
         WIDTH              = 189.86
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 189.86
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 189.86
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
/* BROWSE-TAB BROWSE-2 BUTTON-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tw-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tw-report.Llave-I|yes,Temp-Tables.tw-report.Campo-C[2]|yes,Temp-Tables.tw-report.Campo-C[3]|yes,Temp-Tables.tw-report.Campo-C[4]|yes,Temp-Tables.tw-report.Campo-C[5]|yes,Temp-Tables.tw-report.Campo-C[6]|yes,Temp-Tables.tw-report.Campo-C[7]|yes"
     _FldNameList[1]   > Temp-Tables.tw-report.Campo-C[1]
"tw-report.Campo-C[1]" "Prioridad" ? "character" ? ? 6 ? ? 6 no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tw-report.Campo-D[1]
"tw-report.Campo-D[1]" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tw-report.Campo-C[3]
"tw-report.Campo-C[3]" "PHR" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tw-report.Campo-C[4]
"tw-report.Campo-C[4]" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tw-report.Campo-C[5]
"tw-report.Campo-C[5]" "Número" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tw-report.Campo-C[11]
"tw-report.Campo-C[11]" "Hora" "X(5)" "character" ? ? ? ? ? ? no ? no no "5.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tw-report.Campo-C[7]
"tw-report.Campo-C[7]" "HPK" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tw-report.Campo-C[10]
"tw-report.Campo-C[10]" "Estado HPK" "X(20)" "character" ? ? ? ? ? ? no ? no no "18.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tw-report.Campo-C[8]
"tw-report.Campo-C[8]" "Cliente" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tw-report.Campo-C[9]
"tw-report.Campo-C[9]" "Nombre o Razón Social" "X(80)" "character" ? ? ? ? ? ? no ? no no "65.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tw-report.Campo-F[1]
"tw-report.Campo-F[1]" "Peso de la Orden!en kgs" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tw-report.Campo-F[2]
"tw-report.Campo-F[2]" "Total Items!de la Orden" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tw-report.Campo-F[3]
"tw-report.Campo-F[3]" "Peso de la HPK!en kgs" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.tw-report.Campo-F[4]
"tw-report.Campo-F[4]" "Total Items!HPK" "->>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"fLogPHR(BUFFER tw-report, 1) @ cLog_01" "Log Actual" ? ? ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"fLogPHR(BUFFER tw-report, 2) @ cLog_02" "Log Anterior" ? ? ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE RUTAS PRIORITARIAS - HISTORICO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE RUTAS PRIORITARIAS - HISTORICO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

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
  DISPLAY RETURN-VALUE @ FILL-IN_FchDoc-1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN src/bin/_calenda.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  DISPLAY RETURN-VALUE @ FILL-IN_FchDoc-2 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Filtrar W-Win
ON CHOOSE OF BUTTON_Filtrar IN FRAME F-Main /* FILTRAR */
DO:
    ASSIGN 
        COMBO-BOX_CodDoc FILL-IN_NroDoc 
        FILL-IN_FchDoc-1 FILL-IN_FchDoc-2
        .
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* TEXTO */
DO:
    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Carga-Texto.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodDoc W-Win
ON VALUE-CHANGED OF COMBO-BOX_CodDoc IN FRAME F-Main /* Documento */
DO:
  IF SELF:SCREEN-VALUE = "Todos" THEN DO:
      FILL-IN_NroDoc:SCREEN-VALUE = "".
      FILL-IN_NroDoc:SENSITIVE = NO.
  END.
  ELSE DO:
      FILL-IN_NroDoc:SENSITIVE = YES.
      APPLY "ENTRY":U TO FILL-IN_NroDoc.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo cargamos los que tengan orden de prioridad
------------------------------------------------------------------------------*/

DEF VAR iPrioridad AS INTE NO-UNDO.
DEF VAR pcStatus AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion  ~
    Di-RutaC FIELDS(codcia coddiv coddoc nrodoc fchdoc flgest codrut) NO-LOCK  ~
    WHERE Di-RutaC.codcia = s-codcia ~
        AND Di-RutaC.coddoc = "PHR" ~
        AND (Di-RutaC.fchdoc >= FILL-IN_FchDoc-1 AND Di-RutaC.fchdoc <= FILL-IN_FchDoc-2) ~
        AND Di-RutaC.coddiv = s-coddiv ~
        AND (Di-RutaC.flgest = "C" OR Di-RutaC.flgest = "P"), ~
    EACH Di-RutaD OF Di-RutaC NO-LOCK, ~
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia ~
        AND Faccpedi.coddoc = Di-RutaD.codref           /* OD u OTR */ ~
        AND Faccpedi.nroped = Di-RutaD.nroref
            
&SCOPED-DEFINE Filtros ~
    IF TRUE <> (Di-RutaC.codrut > "") THEN NEXT. ~
    ASSIGN iPrioridad = INTEGER(Di-RutaC.codrut) NO-ERROR. ~
    IF ERROR-STATUS:ERROR = YES THEN NEXT. ~
    IF COMBO-BOX_CodDoc <> "Todos" AND Di-RutaD.codref <> COMBO-BOX_CodDoc THEN NEXT. ~
    IF COMBO-BOX_CodDoc <> "Todos" AND FILL-IN_NroDoc > "" AND Di-RutaD.nroref <> FILL-IN_NroDoc THEN NEXT. 

EMPTY TEMP-TABLE tw-report.                  
/* 1ro. Los que tienen HPK */
FOR EACH {&Condicion} :
    /* FILTROS */
    {&Filtros}

    FOR EACH Vtacdocu FIELDS(codcia coddiv codped nroped codref nroref codcli nomcli peso items) NO-LOCK 
        WHERE Vtacdocu.codcia = s-codcia
        AND Vtacdocu.codref = Di-RutaD.codref       /* OD OTR */
        AND Vtacdocu.nroref = Di-RutaD.nroref
        AND Vtacdocu.codped = "HPK"
        AND Vtacdocu.coddiv = s-coddiv
        AND Vtacdocu.flgest <> "A":
        /* Creamos el registro de control */
        CREATE tw-report.
        ASSIGN
            tw-report.Campo-D[1] = Di-RutaC.fchdoc.
        ASSIGN
            tw-report.Llave-I  = INTEGER(Di-RutaC.codrut)
            tw-report.Campo-C[1] = Di-RutaC.codrut
            tw-report.Campo-C[2] = Di-RutaC.coddoc      /* PHR */
            tw-report.Campo-C[3] = Di-RutaC.nrodoc
            tw-report.Campo-C[4] = Vtacdocu.codref      /* OD OTR */
            tw-report.Campo-C[5] = Vtacdocu.nroref
            tw-report.Campo-C[6] = Vtacdocu.codped      /* HPK */
            tw-report.Campo-C[7] = Vtacdocu.nroped
            .
        ASSIGN
            tw-report.Campo-C[8] = Vtacdocu.codcli
            tw-report.Campo-C[9] = Vtacdocu.nomcli
            .
        ASSIGN
            tw-report.Campo-F[1] = ROUND(Faccpedi.Peso,2)        /* Peso Total OD u OTR */
            tw-report.Campo-F[2] = Faccpedi.Items       /* Items totales OD u OTR */
        .
        ASSIGN
            tw-report.Campo-F[3] = ROUND(Vtacdocu.Peso,2)        /* Peso Total HPK */
            tw-report.Campo-F[4] = Vtacdocu.Items       /* Items totales HPK */
            .
        /* Avance por cada HPK*/
        FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
            ASSIGN
                tw-report.Campo-F[5] = tw-report.Campo-F[5] + (VtaDDocu.CanPed * VtaDDocu.Factor)
                tw-report.Campo-F[6] = tw-report.Campo-F[6] + VtaDDocu.CanPick
                .
        END.
        /* Seguimiento HPK */
        pcStatus = "".
        RUN gn/p-status-hpk (INPUT Vtacdocu.codped, INPUT Vtacdocu.nroped, OUTPUT pcStatus).
        tw-report.Campo-C[10] = pcStatus.
    END.
END.

/* % de avance */
FOR EACH tw-report:
    FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND
        Faccpedi.coddoc = tw-report.Campo-C[4] AND
        Faccpedi.nroped = tw-report.Campo-C[5]
        NO-LOCK NO-ERROR.
    IF AVAILABLE Faccpedi THEN tw-report.Campo-C[11] = SUBSTRING(Faccpedi.Hora,1,5).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Texto W-Win 
PROCEDURE Carga-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

GET FIRST {&browse-name}.
DO WHILE NOT QUERY-OFF-END("{&browse-name}"):
    CREATE Detalle.
    ASSIGN
        Detalle.Prioridad = tw-report.Campo-C[1] 
        Detalle.LogActual = fLogPHR(BUFFER tw-report, 1) 
        Detalle.LogAnterior = fLogPHR(BUFFER tw-report, 2) 
        Detalle.Fecha = tw-report.Campo-D[1]
        Detalle.PHR = tw-report.Campo-C[3]
        Detalle.CodDoc = tw-report.Campo-C[4]
        Detalle.NroDoc = tw-report.Campo-C[5]
        Detalle.Hora  = tw-report.Campo-C[11]
        Detalle.CodDoc = tw-report.Campo-C[4]
        Detalle.NroHPK = tw-report.Campo-C[7]
        Detalle.CodCli = tw-report.Campo-C[8]
        Detalle.NomCli = tw-report.Campo-C[9]
        Detalle.Peso  = tw-report.Campo-F[1]
        Detalle.Items = tw-report.Campo-F[2]
        Detalle.PesoHPK = tw-report.Campo-F[3]
        Detalle.ItemsHPK = tw-report.Campo-F[4]
        Detalle.EstHPK = tw-report.Campo-C[10]
    .

    GET NEXT {&browse-name}.
END.

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
  DISPLAY COMBO-BOX_CodDoc FILL-IN_NroDoc FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON_Filtrar COMBO-BOX_CodDoc BUTTON_Texto BtnDone 
         FILL-IN_FchDoc-1 BUTTON-1 FILL-IN_FchDoc-2 BUTTON-2 BROWSE-2 
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
  FILL-IN_FchDoc-1 = TODAY.
  FILL-IN_FchDoc-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "tw-report"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLogPHR W-Win 
FUNCTION fLogPHR RETURNS CHARACTER
  (   BUFFER btw-report FOR tw-report,
      INPUT iLog AS INTE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF NOT AVAILABLE btw-report THEN RETURN "".
  DEF VAR iContador AS INTE NO-UNDO.

  FOR EACH LogisLogControl NO-LOCK WHERE LogisLogControl.CodCia = s-codcia AND
      LogisLogControl.CodDiv = s-coddiv AND
      LogisLogControl.CodDoc = "PHR" AND
      LogisLogControl.NroDoc = btw-report.Campo-C[3] AND
      LogisLogControl.Evento = "PHR_PRIORITY"
      BY LogisLogControl.Fecha DESC BY LogisLogControl.Hora DESC:
      iContador = iContador + 1.
      IF iContador = iLog THEN RETURN STRING(LogisLogControl.Fecha, "99/99/9999") + " " + LogisLogControl.Hora.
  END.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

