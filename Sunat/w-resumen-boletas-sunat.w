&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-FELogComprobantes NO-UNDO LIKE FELogComprobantes.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

DEFINE VAR x-emitidos-desde AS DATE.
DEFINE VAR x-emitidos-hasta AS DATE.
DEFINE VAR x-emitidos AS DATE.
DEFINE VAR x-col-moneda AS CHAR. 

x-emitidos-desde = TODAY - 45.
x-emitidos-hasta = TODAY.
x-emitidos = 01/01/1990.

DEFINE TEMP-TABLE t-fersmcomprobcab LIKE fersmcomprobcab.
DEFINE TEMP-TABLE t-fersmcomprobdtl LIKE fersmcomprobdtl.
DEFINE BUFFER b-felogcomprobantes FOR felogcomprobantes.

/* De la Empresa */
DEFINE VAR cRucEmpresa AS CHAR FORMAT 'x(11)'.
DEFINE VAR cRazonSocial AS CHAR.
DEFINE VAR cNombreComercial AS CHAR.
DEFINE VAR cURLDocumento AS CHAR.
DEFINE VAR cDirecEmisor AS CHAR.
DEFINE VAR cUBIGEO AS CHAR.

cRucEmpresa = "20100038146".
cRazonSocial = "Continental S.A.C.".
cNombreComercial = cRazonSocial.
cDirecEmisor = "CAL.RENE DESCARTES Nro.114 URB.SANTA RAQUEL II ETAPA, LIMA-LIMA-ATE".
cUBIGEO = "150103".

DEFINE VAR x-xml-data AS LONGCHAR.
DEFINE VAR x-xml-header AS LONGCHAR.
DEFINE VAR x-xml-detail AS LONGCHAR.

DEFINE VAR x-url-consulta-documento-electronico AS CHAR.
DEFINE VAR x-servidor-ip AS CHAR.
DEFINE VAR x-servidor-puerto AS CHAR.
DEFINE VAR x-fecha-emision AS CHAR.
DEFINE VAR x-fecha-envio AS CHAR.
DEFINE VAR x-fecha-envio-resumen AS DATE.
DEFINE VAR gcCRLF AS CHAR.
DEFINE VAR x-xml-hashcode AS LONGCHAR.

ASSIGN gcCRLF = CHR(13) + CHR(10).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-12

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-FELogComprobantes CcbCDocu tt-w-report

/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 tt-FELogComprobantes.Campo-Log[1] ~
tt-FELogComprobantes.CodDiv tt-FELogComprobantes.CodDoc ~
tt-FELogComprobantes.NroDoc tt-FELogComprobantes.LogDate CcbCDocu.FchDoc ~
CcbCDocu.CodCli CcbCDocu.NomCli ~
if(ccbcdocu.codmon = 2) then "USD" else "S/" @ x-col-moneda CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 ~
tt-FELogComprobantes.Campo-Log[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-12 tt-FELogComprobantes
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-12 tt-FELogComprobantes
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH tt-FELogComprobantes NO-LOCK, ~
      EACH CcbCDocu WHERE ccbcdocu.codcia = tt-felogcomprobantes.codcia and ~
ccbcdocu.coddoc = tt-felogcomprobantes.coddoc and ~
ccbcdocu.nrodoc = tt-felogcomprobantes.nrodoc ~
 ~
      AND ccbcdocu.fchdoc = x-emitidos NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH tt-FELogComprobantes NO-LOCK, ~
      EACH CcbCDocu WHERE ccbcdocu.codcia = tt-felogcomprobantes.codcia and ~
ccbcdocu.coddoc = tt-felogcomprobantes.coddoc and ~
ccbcdocu.nrodoc = tt-felogcomprobantes.nrodoc ~
 ~
      AND ccbcdocu.fchdoc = x-emitidos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 tt-FELogComprobantes CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 tt-FELogComprobantes
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-12 CcbCDocu


/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 tt-w-report.Llave-D ~
tt-w-report.Llave-I 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-12}~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-12 BUTTON-31 BUTTON-29 FILL-IN-desde ~
FILL-IN-hasta BUTTON-1 BROWSE-6 TOGGLE-fac TOGGLE-nc TOGGLE-nd ~
FILL-IN-coddiv BUTTON-32 RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-2 FILL-IN-desde FILL-IN-hasta ~
TOGGLE-fac TOGGLE-nc TOGGLE-nd FILL-IN-coddiv FILL-IN-desdiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aceptar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-29 
     LABEL "Enviar Resumen de BOLETAS" 
     SIZE 29.72 BY 1.12
     BGCOLOR 2 FGCOLOR 2 .

DEFINE BUTTON BUTTON-31 
     LABEL "Marcar Todos" 
     SIZE 16 BY .77.

DEFINE BUTTON BUTTON-32 
     LABEL "Desmarcar Todos" 
     SIZE 22 BY .77.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "GENERACION DE RESUMENES DE BOLETAS" 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1.35
     BGCOLOR 15 FGCOLOR 2 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-coddiv AS CHARACTER FORMAT "X(8)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desdiv AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 163 BY .19.

DEFINE VARIABLE TOGGLE-fac AS LOGICAL INITIAL yes 
     LABEL "BOL" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-nc AS LOGICAL INITIAL yes 
     LABEL "N/C" 
     VIEW-AS TOGGLE-BOX
     SIZE 7 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-nd AS LOGICAL INITIAL yes 
     LABEL "N/D" 
     VIEW-AS TOGGLE-BOX
     SIZE 6 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-12 FOR 
      tt-FELogComprobantes, 
      CcbCDocu SCROLLING.

DEFINE QUERY BROWSE-6 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 W-Win _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      tt-FELogComprobantes.Campo-Log[1] COLUMN-LABEL "Sele" FORMAT "yes/no":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      tt-FELogComprobantes.CodDiv COLUMN-LABEL "Divi" FORMAT "x(5)":U
            WIDTH 5.43
      tt-FELogComprobantes.CodDoc COLUMN-LABEL "CodDoc." FORMAT "x(3)":U
      tt-FELogComprobantes.NroDoc FORMAT "X(12)":U WIDTH 10.57
      tt-FELogComprobantes.LogDate FORMAT "99/99/9999 HH:MM:SS.SSS":U
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 9.86
      CcbCDocu.NomCli FORMAT "x(50)":U WIDTH 32.43
      if(ccbcdocu.codmon = 2) then "USD" else "S/" @ x-col-moneda COLUMN-LABEL "Moneda" FORMAT "x(5)":U
            WIDTH 6.43
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.72
  ENABLE
      tt-FELogComprobantes.Campo-Log[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 127 BY 19.04
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      tt-w-report.Llave-D COLUMN-LABEL "Fecha emision" FORMAT "99/99/9999":U
            WIDTH 14.43
      tt-w-report.Llave-I COLUMN-LABEL "No.Dctos" FORMAT ">>,>>9":U
            WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 32 BY 16.46
         TITLE "Fecha emision" ROW-HEIGHT-CHARS .58 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-12 AT ROW 4.69 COL 35 WIDGET-ID 400
     BUTTON-31 AT ROW 2.73 COL 107 WIDGET-ID 30
     FILL-IN-2 AT ROW 1.08 COL 86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-29 AT ROW 21.77 COL 2.57 WIDGET-ID 10
     FILL-IN-desde AT ROW 1.31 COL 16 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-hasta AT ROW 1.31 COL 39.72 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.38 COL 64 WIDGET-ID 6
     BROWSE-6 AT ROW 4.62 COL 2 WIDGET-ID 300
     TOGGLE-fac AT ROW 2.81 COL 3.14 WIDGET-ID 18
     TOGGLE-nc AT ROW 2.81 COL 11.57 WIDGET-ID 20
     TOGGLE-nd AT ROW 2.81 COL 19.86 WIDGET-ID 22
     FILL-IN-coddiv AT ROW 2.69 COL 33 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-desdiv AT ROW 2.69 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BUTTON-32 AT ROW 2.73 COL 129 WIDGET-ID 32
     RECT-1 AT ROW 4.04 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 164 BY 23.23 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-FELogComprobantes T "?" NO-UNDO INTEGRAL FELogComprobantes
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Declaracion de Resumen de Boletas"
         HEIGHT             = 23.19
         WIDTH              = 164
         MAX-HEIGHT         = 23.77
         MAX-WIDTH          = 164
         VIRTUAL-HEIGHT     = 23.77
         VIRTUAL-WIDTH      = 164
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
/* BROWSE-TAB BROWSE-12 1 F-Main */
/* BROWSE-TAB BROWSE-6 BUTTON-1 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-desdiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.tt-FELogComprobantes,INTEGRAL.CcbCDocu WHERE Temp-Tables.tt-FELogComprobantes ..."
     _Options          = "NO-LOCK"
     _JoinCode[2]      = "ccbcdocu.codcia = tt-felogcomprobantes.codcia and
ccbcdocu.coddoc = tt-felogcomprobantes.coddoc and
ccbcdocu.nrodoc = tt-felogcomprobantes.nrodoc
"
     _Where[2]         = "ccbcdocu.fchdoc = x-emitidos"
     _FldNameList[1]   > Temp-Tables.tt-FELogComprobantes.Campo-Log[1]
"tt-FELogComprobantes.Campo-Log[1]" "Sele" ? "logical" ? ? ? ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-FELogComprobantes.CodDiv
"tt-FELogComprobantes.CodDiv" "Divi" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-FELogComprobantes.CodDoc
"tt-FELogComprobantes.CodDoc" "CodDoc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-FELogComprobantes.NroDoc
"tt-FELogComprobantes.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.tt-FELogComprobantes.LogDate
     _FldNameList[6]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[7]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "32.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"if(ccbcdocu.codmon = 2) then ""USD"" else ""S/"" @ x-col-moneda" "Moneda" "x(5)" ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Llave-D
"tt-w-report.Llave-D" "Fecha emision" ? "date" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Llave-I
"tt-w-report.Llave-I" "No.Dctos" ">>,>>9" "integer" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Declaracion de Resumen de Boletas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Declaracion de Resumen de Boletas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 W-Win
ON ENTRY OF BROWSE-6 IN FRAME F-Main /* Fecha emision */
DO:
    x-emitidos = 01/01/1990.
    IF AVAILABLE tt-w-report THEN DO:
        x-emitidos = tt-w-report.llave-d.
    END.
    {&open-query-browse-12}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 W-Win
ON VALUE-CHANGED OF BROWSE-6 IN FRAME F-Main /* Fecha emision */
DO:
    x-emitidos = 01/01/1990.
    IF AVAILABLE tt-w-report THEN DO:
        x-emitidos = tt-w-report.llave-d.
    END.
    {&open-query-browse-12}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN fill-in-desde fill-in-hasta toggle-fac toggle-nc toggle-nd fill-in-coddiv.

  x-emitidos-desde = fill-in-desde.
  x-emitidos-hasta = fill-in-hasta.

  SESSION:SET-WAIT-STATE("GENERAL").
  RUN cargar-data.
  SESSION:SET-WAIT-STATE("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-29
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-29 W-Win
ON CHOOSE OF BUTTON-29 IN FRAME F-Main /* Enviar Resumen de BOLETAS */
DO:

    IF NOT AVAILABLE tt-w-report THEN RETURN NO-APPLY.

        MESSAGE 'Seguro de enviar el resumen del dia ' + STRING(tt-w-report.llave-d,"99/99/9999") + '?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN procesar-resumen.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-31
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-31 W-Win
ON CHOOSE OF BUTTON-31 IN FRAME F-Main /* Marcar Todos */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST BROWSE-12.
        DO  WHILE AVAILABLE tt-FELogcomprobantes:
            ASSIGN tt-FELogcomprobantes.campo-log[1] = YES.
            GET NEXT BROWSE-12.
        END.
        GET FIRST BROWSE-12.
        {&open-query-BROWSE-12}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-32
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-32 W-Win
ON CHOOSE OF BUTTON-32 IN FRAME F-Main /* Desmarcar Todos */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        GET FIRST BROWSE-12.
        DO  WHILE AVAILABLE tt-FELogcomprobantes:
            ASSIGN tt-FELogcomprobantes.campo-log[1] = NO.
            GET NEXT BROWSE-12.
        END.
        GET FIRST BROWSE-12.
        {&open-query-BROWSE-12}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-coddiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-coddiv W-Win
ON LEAVE OF FILL-IN-coddiv IN FRAME F-Main /* Division */
DO:
  fill-in-desdiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                            gn-divi.coddiv = fill-in-coddiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DO:
    fill-in-desdiv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-data W-Win 
PROCEDURE cargar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-doc-valido AS CHAR.

EMPTY TEMP-TABLE tt-w-report.        
EMPTY TEMP-TABLE tt-felogcomprobantes.

DEFINE VAR x-doc-principal AS CHAR.
DEFINE VAR x-doc-sunat AS CHAR.

x-doc-principal = "BOL".
x-doc-sunat = "03".

DEFINE VAR x-registro-valido AS CHAR.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH FELogcomprobantes WHERE FELogcomprobantes.codcia = s-codcia AND
        /*(felogcomprobantes.libre_c01 = "" or felogcomprobantes.libre_c01 = ?) and*/
        ((toggle-fac = YES AND FELogcomprobantes.coddoc = x-doc-principal) OR
        (toggle-nc = YES AND FELogcomprobantes.coddoc = "N/C" AND FELogcomprobantes.tipodocrefpri = '03') OR
        (toggle-nd = YES AND FELogcomprobantes.coddoc = "N/D" AND FELogcomprobantes.tipodocrefpri = '03')) AND
        (fill-in-coddiv = "" OR fill-in-coddiv = FELogcomprobantes.coddiv) NO-LOCK,          /**/
        FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = felogcomprobantes.codcia and
                ccbcdocu.coddoc = felogcomprobantes.coddoc AND ccbcdocu.nrodoc = felogcomprobantes.nrodoc
                AND (ccbcdocu.fchdoc >= x-emitidos-desde AND ccbcdocu.fchdoc <= x-emitidos-hasta) AND 
                ccbcdocu.flgest <> "A" NO-LOCK:
    /**/
    IF FELogcomprobantes.coddoc = x-doc-principal OR 
        (LOOKUP(FELogcomprobantes.coddoc,"N/C,N/D") > 0 AND FELogcomprobantes.tipodocrefpri = x-doc-sunat) THEN DO:  /* FAC y N/C-N/D q referencien BOL */
        x-registro-valido = "".

        RUN validar-documento(OUTPUT x-registro-valido).

        /* Esta aceptado por SUNAT */
        IF x-registro-valido = "OK" THEN DO:

            FIND FIRST tt-w-report WHERE tt-w-report.llave-d = ccbcdocu.fchdoc NO-ERROR.
            IF NOT AVAILABLE tt-w-report THEN DO:
                CREATE tt-w-report.
                    ASSIGN tt-w-report.llave-d = ccbcdocu.fchdoc
                            tt-w-report.llave-i = 0.            
            END.
            ASSIGN tt-w-report.llave-i = tt-w-report.llave-i + 1.
            /**/
            CREATE tt-felogcomprobantes.
            BUFFER-COPY felogcomprobantes TO tt-felogcomprobantes.
            ASSIGN tt-felogcomprobantes.campo-log[1] = YES.

        END.
    END.

END.

FIND FIRST tt-w-report NO-ERROR.
{&open-query-browse-6}

x-emitidos = 01/01/1990.
IF AVAILABLE tt-w-report THEN DO:
    x-emitidos = tt-w-report.llave-d.
END.
{&open-query-browse-12}

SESSION:SET-WAIT-STATE("").


/*
EMPTY TEMP-TABLE tt-w-report.        
        
FOR EACH FELogcomprobantes WHERE FELogcomprobantes.codcia = s-codcia AND
        FELogcomprobantes.codcia = s-codcia and
        (felogcomprobantes.libre_c01 = "" or felogcomprobantes.libre_c01 = ?) and
        ((felogcomprobantes.tipodocsunat = '03') OR (felogcomprobantes.tipodocsunat = '07' and tipodocrefpri = '03')) NO-LOCK, 
        FIRST INTEGRAL.CcbCDocu WHERE ccbcdocu.codcia = felogcomprobantes.codcia and
                ccbcdocu.coddoc = felogcomprobantes.coddoc AND ccbcdocu.nrodoc = felogcomprobantes.nrodoc
                AND (ccbcdocu.fchdoc >= x-emitidos-desde AND ccbcdocu.fchdoc <= x-emitidos-hasta) AND 
                ccbcdocu.flgest <> "A" NO-LOCK:

    x-doc-valido = "".
    RUN validar-documento(OUTPUT x-doc-valido).

    IF x-doc-valido = "OK" THEN DO:
        /**/
        FIND FIRST tt-w-report WHERE tt-w-report.llave-d = ccbcdocu.fchdoc NO-ERROR.
        IF NOT AVAILABLE tt-w-report THEN DO:
            CREATE tt-w-report.
                ASSIGN tt-w-report.llave-d = ccbcdocu.fchdoc
                        tt-w-report.llave-i = 0.            
        END.
        ASSIGN tt-w-report.llave-i = tt-w-report.llave-i + 1.

    END.

END.

FIND FIRST tt-w-report NO-ERROR.
{&open-query-browse-6}

    x-emitidos = 01/01/1990.
    IF AVAILABLE tt-w-report THEN DO:
        x-emitidos = tt-w-report.llave-d.
    END.
    {&open-query-browse-2}
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
  DISPLAY FILL-IN-2 FILL-IN-desde FILL-IN-hasta TOGGLE-fac TOGGLE-nc TOGGLE-nd 
          FILL-IN-coddiv FILL-IN-desdiv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-12 BUTTON-31 BUTTON-29 FILL-IN-desde FILL-IN-hasta BUTTON-1 
         BROWSE-6 TOGGLE-fac TOGGLE-nc TOGGLE-nd FILL-IN-coddiv BUTTON-32 
         RECT-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE envio-xml W-Win 
PROCEDURE envio-xml :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-msg AS CHAR NO-UNDO.

DEFINE VAR x-ws-ok AS CHAR.

/**/
RUN verificar-ws (OUTPUT x-ws-ok).
IF x-ws-ok <> "OK" THEN DO:
    MESSAGE x-ws-ok VIEW-AS ALERT-BOX INFORMATION.
    p-msg = x-ws-ok.
    RETURN "ADM-ERROR".
END.

/* Envio a BizLinks */
DEFIN VAR x-url-webservice AS CHAR.
DEFINE VAR x-loadXML AS LOG.

DEFINE VAR x-oXmlHttp AS COM-HANDLE NO-UNDO.
DEFINE VAR x-oXMLBody AS com-HANDLE NO-UNDO.

p-msg = "OK".

/*
&apos; = '
&quot; = " 
*/

DEFINE VAR x-tmp AS CHAR.
DEFINE VAR x-correla AS INT.
DEFINE VAR x-nro-envio AS CHAR.
DEFINE VAR x-rowid AS ROWID.
DEFINE VAR x-fecha AS CHAR.

x-tmp = session:temp-directory.

x-correla = 0.
FIND FIRST fecorrela WHERE fecorrela.codcia = s-codcia AND
                            fecorrela.tiporsm = 'RC' AND
                            fecorrela.fecha = x-fecha-envio-resumen /*tt-w-report.llave-D*/ EXCLUSIVE-LOCK NO-ERROR.
IF LOCKED fecorrela THEN DO:
    p-msg = "No se puedo capturar el correlativo de la fecha".
    RETURN "ADM-ERROR".
END.
ELSE DO:
    IF AVAILABLE fecorrela THEN x-correla = fecorrela.ncorrela.
END.

x-correla = x-correla + 1.

/* Emision */
x-fecha = STRING(tt-w-report.llave-d,"99/99/9999").
x-fecha-emision = SUBSTRING(x-fecha,7,4) + "-" + SUBSTRING(x-fecha,4,2) + "-" +
                SUBSTRING(x-fecha,1,2).
/* Envio */
x-fecha-envio-resumen = TODAY.
X-fecha = STRING(x-fecha-envio-resumen,"99/99/9999").
x-fecha-envio = SUBSTRING(x-fecha,7,4) + "-" + SUBSTRING(x-fecha,4,2) + "-" +
                SUBSTRING(x-fecha,1,2).

x-xml-header = "<summaryHeader>".
x-xml-header = x-xml-header + "<fechaEmisionComprobante>" + x-fecha-emision + "</fechaEmisionComprobante>".
x-xml-header = x-xml-header + "<fechaGeneracionResumen>" + x-fecha-envio + "</fechaGeneracionResumen>".
x-xml-header = x-xml-header + "<razonSocialEmisor>" + cRazonSocial + "</razonSocialEmisor>".
x-xml-header = x-xml-header + "<correoEmisor>-</correoEmisor>".
x-xml-header = x-xml-header + "<resumenTipo>RC</resumenTipo>".
x-xml-header = x-xml-header + "<resumenId>RC-" + REPLACE(x-fecha-envio,"-","") + "-" + STRING(x-correla,"999") + "</resumenId>".
x-xml-header = x-xml-header + "<inHabilitado>1</inHabilitado>".

x-xml-data = x-xml-header + x-xml-detail.
x-xml-data = x-xml-data + "</summaryHeader>".

x-XML-data = REPLACE(x-XML-data,"&","&amp;").
x-XML-data = REPLACE(x-XML-data,"'","&apos;").
x-XML-data = REPLACE(x-XML-data,'"',"&quot;").

/*x-xml-header = x-xml-header + "<resumenId>RA-" + REPLACE(x-fecha-envio,"-","") + "-" + STRING(x-correla,"999") + "</resumenId>".*/

/*IF USERID("DICTDB") = "MASTER" THEN DO:*/
    COPY-LOB x-XML-data TO FILE x-tmp + "RC-" + x-fecha-envio /*x-fecha-emision*/ + "-" + STRING(x-correla,"999") + ".xml" NO-ERROR.
/*END.*/


/* Correlativo */
/*x-nro-envio = REPLACE(x-fecha-emision,"-","") + "-" + STRING(x-correla,"999").*/
x-nro-envio = REPLACE(x-fecha-envio,"-","") + "-" + STRING(x-correla,"999").
x-url-webservice = "http://" + x-servidor-ip + ":" + x-servidor-puerto + "/einvoice/rest/" +
        "6/" + cRucEmpresa + "/RC/" + REPLACE(x-fecha-envio,"-","") + "-" + STRING(x-correla,"999").
                    /*"6/" + cRucEmpresa + "/RC/" + REPLACE(x-fecha-emision,"-","") + "-" + STRING(x-correla,"999").*/

CREATE "MSXML2.ServerXMLHTTP.6.0" x-oXmlHttp.
CREATE "MSXML2.DOMDocument.6.0" x-oXMLBody.

x-loadXML = x-oXMLBody:loadXML(x-XML-data) NO-ERROR. 

IF NOT x-loadXML THEN DO:    

    p-msg = "ERROR en loadXML : "  + gcCRLF + x-oXMLBody:parseError:reason.

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.
/*MESSAGE x-url-webservice.*/
x-oXmlHttp:OPEN( "PUT", x-url-webservice, NO ) .    

x-oXmlHttp:setRequestHeader( "Content-Type", "application/xml;charset=ISO-8859-1" ).

/*x-oXmlHttp:setRequestHeader( "Content-Length", LENGTH(x-xml-documento)).    */

x-oXmlHttp:setOption( 2, 13056 ) .  /*SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056*/             

x-oXmlHttp:SEND(x-oXMLBody:documentElement:XML) NO-ERROR.

IF ERROR-STATUS:GET-NUMBER(1) > 0 THEN DO:    

    p-msg = "ERROR en SEND : El XML tiene problemas de Estructura (" + 
        STRING(ERROR-STATUS:GET-NUMBER(1)) + ")" + gcCRLF +  
        ERROR-STATUS:GET-MESSAGE(1).

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

IF x-oXmlHttp:STATUS <> 200 THEN DO:
    p-msg = "ERROR en SEND (Err:200) : " + gcCRLF + x-oXmlHttp:responseText. 

    RELEASE OBJECT x-oXmlHttp NO-ERROR.
    RELEASE OBJECT x-oXMLBody NO-ERROR.
    RETURN "ADM-ERROR".
END.

/* La Respuesta */
DEFINE VAR x-rspta AS CHAR.
DEFINE VAR x-orspta AS COM-HANDLE NO-UNDO.
DEFINE var x-oMsg AS COM-HANDLE NO-UNDO.

DEFINE VAR x-status AS CHAR.
DEFINE VAR x-codestatus AS CHAR.
DEFINE VAR x-hashcode AS CHAR.

CREATE "MSXML2.DOMDocument.6.0" x-orspta.

x-rspta = x-oXmlHttp:responseText.
x-oRspta:LoadXML(x-oXmlHttp:responseText).

x-oMsg = x-oRspta:selectSingleNode( "//status" ).
x-status = x-oMsg:TEXT NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//hashCode" ).
x-hashcode = x-oMsg:TEXT NO-ERROR.
x-oMsg = x-oRspta:selectSingleNode( "//codeStatus" ).
x-codestatus = x-oMsg:TEXT NO-ERROR.

/*  */
p-msg = x-rspta.
/*
MESSAGE p-msg.
*/
IF NOT (TRUE <> (x-status > "")) THEN DO:
    IF CAPS(x-status) = "SIGNED" THEN DO:
        /* PROCESO OK */
        x-xml-hashcode = x-hashcode.
        p-msg = "OK".
    END.
    ELSE DO:
        x-oMsg = x-oRspta:selectSingleNode( "//message" ).
        x-codestatus = x-oMsg:TEXT NO-ERROR.       
        p-msg = TRIM(x-codestatus).
    END.
END.
ELSE DO:
    IF NOT (TRUE <> (x-codestatus > "") ) THEN DO:
        x-oMsg = x-oRspta:selectSingleNode( "//descriptionDetail" ).
        x-codestatus = x-oMsg:TEXT NO-ERROR.
        p-msg = TRIM(x-codestatus).
    END.
END.

RELEASE OBJECT x-oXmlHttp NO-ERROR.
RELEASE OBJECT x-oXMLBody NO-ERROR.
RELEASE OBJECT x-oRspta NO-ERROR.
RELEASE OBJECT x-oMsg NO-ERROR.

IF p-msg = "OK" THEN DO:
    
    FOR EACH t-fersmcomprobcab EXCLUSIVE-LOCK :
        ASSIGN t-fersmcomprobcab.nrorsm = x-nro-envio NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            p-msg = "t-fersmcomprobcab : No se pudo actualizar el nro de envio - " + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.
    END.
    FOR EACH t-fersmcomprobdtl EXCLUSIVE-LOCK :
        ASSIGN t-fersmcomprobdtl.nrorsm = x-nro-envio NO-ERROR.        
        IF ERROR-STATUS:ERROR = YES THEN DO:
            p-msg = "t-fersmcomprobdtl : No se pudo actualizar el nro de envio - " + ERROR-STATUS:GET-MESSAGE(1).
            RETURN "ADM-ERROR".
        END.
    END.

    p-msg = "ERROR GRAABNDO".
    GRABAR_DATOS:
        DO TRANSACTION ON ERROR UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS:
            DO:
                    IF NOT AVAILABLE fecorrela THEN DO:
                CREATE fecorrela.
                ASSIGN fecorrela.codcia = s-codcia
                        fecorrela.tiporsm = 'RC'
                        fecorrela.fecha = x-fecha-envio-resumen /*tt-w-report.llave-D*/.
            END.
            ASSIGN fecorrela.ncorrela = fecorrela.ncorrela + 1.
            /**/
            FOR EACH t-fersmcomprobcab NO-LOCK:
                CREATE fersmcomprobcab.
                BUFFER-COPY t-fersmcomprobcab TO fersmcomprobcab NO-ERROR.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    p-msg = "fersmcomprobcab : No se pudo CREAR el nuevo registro".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
            END.
            FOR EACH t-fersmcomprobdtl NO-LOCK:
                CREATE fersmcomprobdtl.
                BUFFER-COPY t-fersmcomprobdtl TO fersmcomprobdtl NO-ERROR.

                IF ERROR-STATUS:ERROR = YES THEN DO:
                    p-msg = "fersmcomprobdtl : No se pudo CREAR el nuevo registro".
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.

                FIND FIRST b-felogcomprobantes WHERE b-felogcomprobantes.codcia = s-codcia AND
                                                    b-felogcomprobantes.coddoc = t-fersmcomprobdtl.coddoc AND
                                                    b-felogcomprobantes.nrodoc = t-fersmcomprobdtl.nrodoc
                                                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE b-felogcomprobantes THEN DO:
                    p-msg = "Felogcomprobantes : Error al grabar el nro de envio " + t-fersmcomprobdtl.coddoc + "-" + t-fersmcomprobdtl.nrodoc.
                    UNDO GRABAR_DATOS, LEAVE GRABAR_DATOS.
                END.
                ASSIGN b-felogcomprobantes.libre_c01 = x-nro-envio.
            END.

            END.
        p-msg = "OK".
        END. 

END.

RETURN "OK".

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
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 45,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

  RUN cargar-data.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-resumen W-Win 
PROCEDURE procesar-resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-item AS INT.

DEFINE VAR x-fecha AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

x-xml-detail = "".

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE t-fersmcomprobcab.
EMPTY TEMP-TABLE t-fersmcomprobdtl.

/**/
CREATE t-fersmcomprobcab.
    ASSIGN t-fersmcomprobcab.codcia = s-codcia
            t-fersmcomprobcab.tiporsm = 'RC'
            t-fersmcomprobcab.nrorsm = "NUEVO"
            t-fersmcomprobcab.fchemiccmpte = tt-w-report.llave-d
            t-fersmcomprobcab.fchgenemisor = x-fecha-envio-resumen
            t-fersmcomprobcab.razonsocial = cRazonSocial
            t-fersmcomprobcab.email = '-'
            t-fersmcomprobcab.horagen = string(TIME,"HH:MM:SS")
    .

x-xml-detail = "".
DO WITH FRAME {&FRAME-NAME}:
    GET FIRST BROWSE-12.
    DO  WHILE AVAILABLE tt-FELogcomprobantes:
        IF tt-FELogcomprobantes.campo-log[1] = YES THEN DO:
            x-item = x-item + 1.
            /**/
            CREATE t-fersmcomprobdtl.
                ASSIGN t-fersmcomprobdtl.codcia = s-codcia
                        t-fersmcomprobdtl.tiporsm = 'RC' 
                        t-fersmcomprobdtl.nrorsm = 'NUEVO'
                        t-fersmcomprobdtl.nitem = x-item
                        t-fersmcomprobdtl.tipodocmnto = tt-felogcomprobantes.tipodocsunat
                        t-fersmcomprobdtl.coddoc = tt-felogcomprobantes.coddoc
                        t-fersmcomprobdtl.nrodoc = tt-felogcomprobantes.nrodoc
                .
            /**/
                /*
            MESSAGE x-item SKIP
                    ccbcdocu.nrodoc SKIP
                    ccbcdocu.codmon SKIP
                    felogcomprobantes.nrodoc SKIP
                    felogcomprobantes.logdate.
            */
            x-xml-detail = x-xml-detail + "<item>".
            x-xml-detail = x-xml-detail + "<numeroFila>" + STRING(x-item) + "</numeroFila>".   
            x-xml-detail = x-xml-detail + "<tipoDocumento>" + {&FIRST-TABLE-IN-QUERY-BROWSE-12}.tipodocsunat + "</tipoDocumento>".
            IF (ccbcdocu.codmon = 2) THEN DO:
                x-xml-detail = x-xml-detail + "<tipoMoneda>USD</tipoMoneda>".
            END.
            ELSE DO:
                x-xml-detail = x-xml-detail + "<tipoMoneda>PEN</tipoMoneda>".
            END.
            x-xml-detail = x-xml-detail + "<totalValorVentaOpGravadasConIgv>" + STRING(tt-felogcomprobantes.vvtagravada,">>>>>>>9.99") + "</totalValorVentaOpGravadasConIgv>". 
            x-xml-detail = x-xml-detail + "<totalIsc>" + STRING(tt-felogcomprobantes.totalisc,">>>>>>>9.99") + "</totalIsc>". 
            x-xml-detail = x-xml-detail + "<totalIgv>" + STRING(tt-felogcomprobantes.totaligv,">>>>>>>9.99") + "</totalIgv>". 
            x-xml-detail = x-xml-detail + "<totalVenta>" + STRING(tt-felogcomprobantes.imptetotal,">>>>>>>9.99") + "</totalVenta>". 
            x-xml-detail = x-xml-detail + "<numeroCorrelativo>B" + SUBSTRING(tt-felogcomprobantes.nrodoc,1,3)
                    + "-" + SUBSTRING(tt-felogcomprobantes.nrodoc,4) + "</numeroCorrelativo>". 
            x-xml-detail = x-xml-detail + "<numeroDocumentoAdquiriente>" + tt-felogcomprobantes.nrodocadq + "</numeroDocumentoAdquiriente>". 
            x-xml-detail = x-xml-detail + "<tipoDocumentoAdquiriente>" + tt-felogcomprobantes.tipodocadq + "</tipoDocumentoAdquiriente>". 
            IF tt-felogcomprobantes.coddoc = 'N/C' OR tt-felogcomprobantes.coddoc = 'N/D' THEN DO:
                x-xml-detail = x-xml-detail + "<numeroCorrelativoBoletaModificada>B" + 
                        SUBSTRING(tt-felogcomprobantes.nrodocrefpri,2) + "</numeroCorrelativoBoletaModificada>". 
                x-xml-detail = x-xml-detail + "<tipoDocumentoModificado>" + tt-felogcomprobantes.tipodocrefpri + "</tipoDocumentoModificado>". 
            END.
            x-xml-detail = x-xml-detail + "<estadoItem>1</estadoItem>".
            x-xml-detail = x-xml-detail + "</item>".           

        END.
        GET NEXT BROWSE-12.
    END.
END.
/*x-xml-detail = x-xml-detail + "</summaryHeader>".*/

DEFINE VAR x-proceso AS CHAR INIT "".

RUN envio-xml(OUTPUT x-proceso).

RUN cargar-data.

MESSAGE x-proceso VIEW-AS ALERT-BOX INFORMATION.

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
  {src/adm/template/snd-list.i "tt-w-report"}
  {src/adm/template/snd-list.i "tt-FELogComprobantes"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-documento W-Win 
PROCEDURE validar-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DEFINE VAR x-estado-bizlinks AS CHAR INIT "".
DEFINE VAR x-estado-sunat AS CHAR INIT "".
DEFINE VAR x-estado-doc AS CHAR INIT "".

pMsg = "NO".


RUN gn/p-estado-documento-electronico.r(INPUT FELogcomprobantes.CodDoc,
                    INPUT FELogcomprobantes.NroDoc,
                    INPUT FELogcomprobantes.CodDiv,
                    OUTPUT x-estado-bizlinks,
                    OUTPUT x-estado-sunat,
                    OUTPUT x-estado-doc).

IF ENTRY(1,x-estado-bizlinks,"|") <> "SIGNED" THEN DO:
    /* Documento aun no FIRMADO x Bizlinks */
    RETURN.
END.

IF NOT (TRUE > (FELogcomprobantes.libre_c01 <> "")) THEN DO:
    /* Ya fue enviado a SUNAT (tiene nro de envio) */
    RETURN.
END.

IF ENTRY(1,x-estado-sunat,"|") <> "PE_09" THEN DO:
    /* NO esta listo para envio */
    RETURN.
END.

pMsg = "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificar-ws W-Win 
PROCEDURE verificar-ws :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pReturn  AS CHAR.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND 
                            factabla.tabla = "CONFIG-FE-BIZLINKS" AND
                            factabla.codigo = "TODOS" NO-LOCK NO-ERROR.
IF NOT AVAILABLE factabla THEN DO:
    pReturn = "667|El Servidor del WebService no esta configurado".
    RETURN "ADM-ERROR".
END.

x-servidor-ip = TRIM(factabla.campo-c[1]).
x-servidor-puerto = TRIM(factabla.campo-c[2]).

IF (TRUE <> (x-servidor-ip > "")) OR (TRUE <> (x-servidor-puerto > "")) THEN DO:
    pReturn = "667|La IP y/o Puerto Servidor del WebService esta vacio".
    RETURN "ADM-ERROR".
END.

pReturn = "OK".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

