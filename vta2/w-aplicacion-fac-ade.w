&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Adelantos FOR CcbCDocu.
DEFINE BUFFER B-Facturas FOR CcbCDocu.
DEFINE BUFFER B-NC FOR CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "A/C".
DEF VAR cCodDoc AS CHAR INIT "N/C".
DEF VAR x-Moneda AS CHAR FORMAT 'x(10)'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES B-Adelantos CcbCDocu B-Facturas

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.FchVto fMoneda(B-Adelantos.CodMon) @ x-Moneda ~
B-Adelantos.ImpTot B-Adelantos.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH B-Adelantos ~
      WHERE B-Adelantos.CodCia = s-codcia ~
 AND B-Adelantos.CodDoc = s-coddoc ~
 /*AND B-Adelantos.CodDiv = s-coddiv*/ ~
 AND B-Adelantos.FlgEst = "P" ~
 AND B-Adelantos.CodCli = FILL-IN-CodCli NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = B-Adelantos.CodCia ~
  AND CcbCDocu.CodDoc = B-Adelantos.CodRef ~
  AND CcbCDocu.NroDoc = B-Adelantos.NroRef NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH B-Adelantos ~
      WHERE B-Adelantos.CodCia = s-codcia ~
 AND B-Adelantos.CodDoc = s-coddoc ~
 /*AND B-Adelantos.CodDiv = s-coddiv*/ ~
 AND B-Adelantos.FlgEst = "P" ~
 AND B-Adelantos.CodCli = FILL-IN-CodCli NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = B-Adelantos.CodCia ~
  AND CcbCDocu.CodDoc = B-Adelantos.CodRef ~
  AND CcbCDocu.NroDoc = B-Adelantos.NroRef NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 B-Adelantos CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 B-Adelantos
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 B-Facturas.CodDoc B-Facturas.NroDoc ~
B-Facturas.FchDoc B-Facturas.FchVto fMoneda(B-Facturas.CodMon) @ x-Moneda ~
B-Facturas.ImpTot B-Facturas.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH B-Facturas ~
      WHERE B-Facturas.CodCia = s-codcia ~
 AND B-Facturas.DivOri = s-coddiv ~
 AND B-Facturas.CodCli = FILL-IN-CodCli ~
 AND B-Facturas.FlgEst = "P" ~
 AND (B-Facturas.CodDoc = "FAC" ~
  OR B-Facturas.CodDoc = "BOL") NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH B-Facturas ~
      WHERE B-Facturas.CodCia = s-codcia ~
 AND B-Facturas.DivOri = s-coddiv ~
 AND B-Facturas.CodCli = FILL-IN-CodCli ~
 AND B-Facturas.FlgEst = "P" ~
 AND (B-Facturas.CodDoc = "FAC" ~
  OR B-Facturas.CodDoc = "BOL") NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 B-Facturas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 B-Facturas


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 FILL-IN-CodCli BUTTON-1 ~
COMBO-NroSer BROWSE-2 BROWSE-3 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpTot-1 FILL-IN-ImpTot-2 ~
FILL-IN-CodCli FILL-IN-NomCli COMBO-NroSer FILL-IN-NroDoc 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda wWin 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT iCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR N/ CREDITO" 
     SIZE 20 BY 1.12.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Seleccione la serie de la N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Código del Cliente:" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot-1 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Soles" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot-2 AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Dólares" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 2.69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 1.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26 BY 2.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      B-Adelantos, 
      CcbCDocu SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      B-Facturas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CcbCDocu.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(9)":U WIDTH 9.57
      CcbCDocu.FchDoc COLUMN-LABEL "Fecha de Emisión" FORMAT "99/99/9999":U
      CcbCDocu.FchVto COLUMN-LABEL "Fecha de Vencimiento" FORMAT "99/99/9999":U
      fMoneda(B-Adelantos.CodMon) @ x-Moneda COLUMN-LABEL "Moneda"
      B-Adelantos.ImpTot FORMAT "->>,>>>,>>9.99":U
      B-Adelantos.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 4.31
         FONT 4
         TITLE "SELECCIONE EL ANTICIPO DE CAMPAÑA A ASIGNAR" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 wWin _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      B-Facturas.CodDoc COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 3.43
      B-Facturas.NroDoc FORMAT "X(9)":U WIDTH 9.43
      B-Facturas.FchDoc COLUMN-LABEL "Fecha de Emisión" FORMAT "99/99/9999":U
            WIDTH 12.43
      B-Facturas.FchVto COLUMN-LABEL "Fecha de Vencimiento" FORMAT "99/99/9999":U
            WIDTH 14.43
      fMoneda(B-Facturas.CodMon) @ x-Moneda COLUMN-LABEL "Moneda"
            WIDTH 6.43
      B-Facturas.ImpTot FORMAT "->>,>>>,>>9.99":U
      B-Facturas.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 81 BY 9.42
         FONT 4
         TITLE "SELECCIONE LOS COMPROBANTES A AFECTAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-2 AT ROW 4.23 COL 66 WIDGET-ID 48
     FILL-IN-ImpTot-1 AT ROW 12.31 COL 92 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-ImpTot-2 AT ROW 13.12 COL 92 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-CodCli AT ROW 1.54 COL 15 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.54 COL 66 WIDGET-ID 8
     FILL-IN-NomCli AT ROW 2.88 COL 16 COLON-ALIGNED WIDGET-ID 6
     COMBO-NroSer AT ROW 4.5 COL 6.43 WIDGET-ID 28
     FILL-IN-NroDoc AT ROW 4.5 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     BROWSE-2 AT ROW 5.85 COL 3 WIDGET-ID 200
     BROWSE-3 AT ROW 10.42 COL 3 WIDGET-ID 300
     "Total Comprobantes Seleccionados" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 11.5 COL 86 WIDGET-ID 44
          BGCOLOR 1 FGCOLOR 15 
     "Comprobante a Generar" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 3.96 COL 4 WIDGET-ID 36
          BGCOLOR 1 FGCOLOR 15 
     "Filtros" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1 COL 4 WIDGET-ID 32
          BGCOLOR 1 FGCOLOR 15 
     RECT-2 AT ROW 1.27 COL 3 WIDGET-ID 30
     RECT-3 AT ROW 3.96 COL 3 WIDGET-ID 34
     RECT-4 AT ROW 11.77 COL 85 WIDGET-ID 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 111.72 BY 19.5
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-Adelantos B "?" ? INTEGRAL CcbCDocu
      TABLE: B-Facturas B "?" ? INTEGRAL CcbCDocu
      TABLE: B-NC B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "APLICACION DE ANTICIPOS DE CAMPAÑA"
         HEIGHT             = 19.5
         WIDTH              = 111.72
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 FILL-IN-NroDoc fMain */
/* BROWSE-TAB BROWSE-3 BROWSE-2 fMain */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME fMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot-1 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot-2 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "B-Adelantos,INTEGRAL.CcbCDocu WHERE B-Adelantos ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "B-Adelantos.CodCia = s-codcia
 AND B-Adelantos.CodDoc = s-coddoc
 /*AND B-Adelantos.CodDiv = s-coddiv*/
 AND B-Adelantos.FlgEst = ""P""
 AND B-Adelantos.CodCli = FILL-IN-CodCli"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = B-Adelantos.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = B-Adelantos.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = B-Adelantos.NroRef"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Fecha de Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FchVto
"CcbCDocu.FchVto" "Fecha de Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fMoneda(B-Adelantos.CodMon) @ x-Moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.B-Adelantos.ImpTot
     _FldNameList[7]   > Temp-Tables.B-Adelantos.SdoAct
"B-Adelantos.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "B-Facturas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "B-Facturas.CodCia = s-codcia
 AND B-Facturas.DivOri = s-coddiv
 AND B-Facturas.CodCli = FILL-IN-CodCli
 AND B-Facturas.FlgEst = ""P""
 AND (B-Facturas.CodDoc = ""FAC""
  OR B-Facturas.CodDoc = ""BOL"")"
     _FldNameList[1]   > Temp-Tables.B-Facturas.CodDoc
"B-Facturas.CodDoc" "Doc." ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.B-Facturas.NroDoc
"B-Facturas.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.B-Facturas.FchDoc
"B-Facturas.FchDoc" "Fecha de Emisión" ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.B-Facturas.FchVto
"B-Facturas.FchVto" "Fecha de Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fMoneda(B-Facturas.CodMon) @ x-Moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.B-Facturas.ImpTot
     _FldNameList[7]   > Temp-Tables.B-Facturas.SdoAct
"B-Facturas.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* APLICACION DE ANTICIPOS DE CAMPAÑA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* APLICACION DE ANTICIPOS DE CAMPAÑA */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON ROW-DISPLAY OF BROWSE-2 IN FRAME fMain /* SELECCIONE EL ANTICIPO DE CAMPAÑA A ASIGNAR */
DO:
/*   IF {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodMon = 1 THEN FILL-IN-Importe-NC:LABEL = "Importe en SOLES".   */
/*   IF {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.CodMon = 2 THEN FILL-IN-Importe-NC:LABEL = "Importe en DOLARES". */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 wWin
ON VALUE-CHANGED OF BROWSE-2 IN FRAME fMain /* SELECCIONE EL ANTICIPO DE CAMPAÑA A ASIGNAR */
DO:
  {&OPEN-QUERY-BROWSE-3}
  RUN Pinta-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 wWin
ON VALUE-CHANGED OF BROWSE-3 IN FRAME fMain /* SELECCIONE LOS COMPROBANTES A AFECTAR */
DO:
    RUN Pinta-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* FILTRAR */
DO:
  ASSIGN
      FILL-IN-CodCli.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
   RUN Pinta-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* GENERAR N/ CREDITO */
DO:
  ASSIGN
      COMBO-NroSer FILL-IN-ImpTot-1 FILL-IN-ImpTot-2.
  IF FILL-IN-ImpTot-1 + FILL-IN-ImpTot-2 <= 0 THEN DO:
      MESSAGE 'Seleccione al menos un comprobante' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Genera-NC.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
  FILL-IN-CodCli = "".
  DISPLAY FILL-IN-CodCli WITH FRAME {&FRAME-NAME}.
  APPLY "VALUE-CHANGED" TO COMBO-NroSer.
  APPLY "CHOOSE":U TO BUTTON-1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer wWin
ON RETURN OF COMBO-NroSer IN FRAME fMain /* Seleccione la serie de la N/C */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer wWin
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME fMain /* Seleccione la serie de la N/C */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = cCodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli wWin
ON LEAVE OF FILL-IN-CodCli IN FRAME fMain /* Código del Cliente: */
DO:
    FILL-IN-NomCli:SCREEN-VALUE = "".
    FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
        AND gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.NomCli.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli wWin
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME fMain /* Código del Cliente: */
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''.
    RUN vtagn/c-gn-clie-01 ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-ImpTot-1 FILL-IN-ImpTot-2 FILL-IN-CodCli FILL-IN-NomCli 
          COMBO-NroSer FILL-IN-NroDoc 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-2 FILL-IN-CodCli BUTTON-1 COMBO-NroSer BROWSE-2 BROWSE-3 RECT-2 
         RECT-3 RECT-4 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC wWin 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

/* Validación */
IF NOT AVAILABLE B-Adelantos THEN RETURN "ADM-ERROR".

DEF VAR x-Saldo-Actual AS DEC.
DEF VAR x-Monto-Aplicar AS DEC.
DEF VAR x-Importe-NC AS DEC.
DEF VAR x-Saldo-Adelanto AS DEC.
DEF VAR x-Saldo AS DEC.
DEF VAR i AS INT.
DEF VAR s-NroSer AS INT.
DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.
DEF VAR x-ImpMn AS DEC NO-UNDO.
DEF VAR x-ImpMe AS DEC NO-UNDO.

FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-tccja THEN DO:
    MESSAGE 'NO se ha registrado el T.C. de Caja'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    x-TpoCmb-Compra = Gn-Tccja.Compra
    x-TpoCmb-Venta  = Gn-Tccja.Venta.
/* SALDO ACTUAL DEL ADELANTO (POR APLICAR) */
ASSIGN
    x-Saldo-Adelanto = B-Adelantos.SdoAct
    s-NroSer = INTEGER(COMBO-NroSer).

MESSAGE 'Se va a generar la Nota de Crédito' SKIP(1)
    b-adelantos.coddoc b-adelantos.nrodoc
    x-Saldo-Adelanto SKIP
    s-NroSer SKIP
    'Confirme la generación'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    ASSIGN
        x-Importe-NC = 0.
    /* APLICAMOS EL ADELANTO DE CAMPAÑA */
    AMORTIZACIONES:
    DO i = 1 TO BROWSE-3:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF BROWSE-3:FETCH-SELECTED-ROW(i) THEN DO:
            FIND CURRENT B-Facturas EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE B-Facturas THEN DO:
                MESSAGE 'NO se pudo bloquear el comprobante' B-Facturas.coddoc B-Facturas.nrodoc SKIP
                    'Proceso abortado'
                    VIEW-AS ALERT-BOX ERROR.
                UNDO PRINCIPAL, RETURN "ADM-ERROR".
            END.
            x-Saldo-Actual = B-Facturas.SdoAct.
            /* AMORTIZAMOS EL COMPROBANTE EN SU MONEDA */
            IF B-Facturas.codmon = B-Adelantos.codmon
                THEN x-Monto-Aplicar  = MINIMUM(x-Saldo-Actual, x-Saldo-Adelanto).
            ELSE IF B-Facturas.codmon = 1
                THEN x-Monto-Aplicar  = ROUND(MINIMUM(x-Saldo-Adelanto * x-TpoCmb-Compra, x-Saldo-Actual),2).
            ELSE x-Monto-Aplicar  = ROUND(MINIMUM(x-Saldo-Adelanto / x-TpoCmb-Venta , x-Saldo-Actual),2).
            CREATE Ccbdcaja.
            ASSIGN
                CcbDCaja.CodCia = B-Facturas.codcia
                CcbDCaja.CodCli = B-Facturas.codcli
                CcbDCaja.CodDiv = B-Facturas.coddiv
                CcbDCaja.CodDoc = B-Adelantos.CodDoc
                CcbDCaja.NroDoc = B-Adelantos.NroDoc
                CcbDCaja.CodMon = B-Facturas.codmon
                CcbDCaja.CodRef = B-Facturas.coddoc
                CcbDCaja.NroRef = B-Facturas.nrodoc
                CcbDCaja.FchDoc = TODAY
                CcbDCaja.ImpTot = x-Monto-Aplicar
                CcbDCaja.TpoCmb = (IF B-Facturas.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta).
            ASSIGN
                B-Facturas.SdoAct = B-Facturas.SdoAct - x-Monto-Aplicar.
            IF B-Facturas.SdoAct <= 0 
                THEN ASSIGN
                        B-Facturas.FlgEst = "C"
                        B-Facturas.FchCan = TODAY.
            /* REBAJAMOS SALDO DEL A/C */
            IF CcbDCaja.CodMon = 1 
                THEN ASSIGN
                        x-ImpMn = CcbDCaja.ImpTot
                        x-ImpMe = CcbDCaja.ImpTot / Ccbdcaja.TpoCmb.
            ELSE ASSIGN
                    x-ImpMn = CcbDCaja.ImpTot * Ccbdcaja.TpoCmb
                    x-ImpMe = CcbDCaja.ImpTot.
            RUN proc_AplicaDoc(
                B-Adelantos.CodDoc,         /* A/C */
                B-Adelantos.NroDoc,
                CcbDCaja.tpocmb,
                x-ImpMn,
                x-impMe
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            /* REDUCIMOS EL SALDO DEL ADELANTO */
            IF B-Adelantos.CodMon = 1 THEN x-Saldo-Adelanto = x-Saldo-Adelanto - x-ImpMn.
            IF B-Adelantos.CodMon = 2 THEN x-Saldo-Adelanto = x-Saldo-Adelanto - x-ImpMe.
            ASSIGN
                x-Importe-NC = x-Importe-NC + x-ImpMn.  /* ACUMULAMOS PARA LA N/C */
            IF x-Saldo-Adelanto <= 0 THEN LEAVE AMORTIZACIONES.
            /* *********************** */
        END.
    END.    /* AMORTIZACIONES */
    /* CREACION DE LA NOTA DE CREDITO EN MONEDA NACIONAL */
    /* Bloqueamos el correlativo de N/C */
    {vtagn/i-faccorre-01.i &Codigo = cCodDoc &Serie = s-nroser}
    /* Cabecera */
    CREATE B-NC.
    BUFFER-COPY B-Adelantos
        TO B-NC
        ASSIGN
        B-NC.codcia = s-codcia
        B-NC.coddiv = s-coddiv
        B-NC.coddoc = "N/C"
        B-NC.cndcre = "N"
        B-NC.nrodoc = STRING(Faccorre.nroser, '999') + STRING(Faccorre.correlativo, '999999')
        B-NC.codref = B-Adelantos.CodRef
        B-NC.nroref = B-Adelantos.NroRef
        B-NC.codmon = 1     /* Moneda Nacional */
        B-NC.tpocmb = (IF B-Adelantos.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        B-NC.fchdoc = TODAY
        B-NC.fchvto = TODAY
        B-NC.usuario = s-user-id
        B-NC.imptot = x-Importe-NC
        B-NC.sdoact = 0             /* La N/C nace aplicada */
        B-NC.fchcan = TODAY
        B-NC.flgest = "C".
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia AND GN-VEN.codven = B-NC.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN B-NC.cco = GN-VEN.cco.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    /* Detalle */
    CREATE Ccbddocu.
    BUFFER-COPY B-NC
        TO Ccbddocu
        ASSIGN
        Ccbddocu.nroitm = 1
        Ccbddocu.codmat = '00001'       /* Por ahora, debe ser parametrizable */
        Ccbddocu.candes = 1
        Ccbddocu.preuni = B-NC.imptot
        Ccbddocu.implin = B-NC.imptot
        Ccbddocu.factor = 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = 'N/C' 
        AND CcbTabla.Codigo = Ccbddocu.codmat NO-LOCK.
    IF CcbTabla.Afecto THEN
        ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = Ccbddocu.implin * ((B-NC.PorIgv / 100) / (1 + (B-NC.PorIgv / 100))).
    ELSE
        ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
    /* Totales */
    ASSIGN
        B-NC.ImpBrt = (IF Ccbddocu.AftIgv = Yes THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0)
        B-NC.ImpExo = (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.PreUni * Ccbddocu.CanDes ELSE 0)
        B-NC.ImpDto = Ccbddocu.ImpDto
        B-NC.ImpIgv = Ccbddocu.ImpIgv.

    IF B-NC.CodMon = 1 
        THEN ASSIGN
        x-ImpMn = B-NC.ImpTot
        x-ImpMe = B-NC.ImpTot / B-NC.TpoCmb.
    ELSE ASSIGN
        x-ImpMn = B-NC.ImpTot * B-NC.TpoCmb
        x-ImpMe = B-NC.ImpTot.
    RUN proc_AplicaDoc-2 (
        B-NC.CodDoc,
        B-NC.NroDoc,
        B-Adelantos.nrodoc,
        B-NC.tpocmb,
        x-ImpMn,
        x-ImpMe
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    IF AVAILABLE(B-Facturas) THEN RELEASE B-Facturas.
    IF AVAILABLE(B-NC) THEN RELEASE B-NC.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
END.
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.
  
  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC y BOL */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.FlgEst = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      /* Correlativo */
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Total wWin 
PROCEDURE Pinta-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INT.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-ImpTot-1 = 0
        FILL-IN-ImpTot-2 = 0.
    DO i = 1 TO browse-3:NUM-SELECTED-ROWS:
        IF browse-3:FETCH-SELECTED-ROW(i) THEN DO:
            IF B-Facturas.codmon = 1 THEN FILL-IN-ImpTot-1 = FILL-IN-ImpTot-1 + B-Facturas.sdoact.
            IF B-Facturas.codmon = 2 THEN FILL-IN-ImpTot-2 = FILL-IN-ImpTot-2 + B-Facturas.sdoact.
        END.
    END.
    DISPLAY FILL-IN-ImpTot-1 FILL-IN-ImpTot-2.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc wWin 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "NO se pudo bloquer el documento:" para_CodDoc para_NroDoc 
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = B-Facturas.CodDoc        /* LA FACTURA A LA CUAL SE APLICA */
            CCBDMOV.NroRef = B-Facturas.NroDoc        /* EL ADELANTO */
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        ASSIGN 
            B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.

        RELEASE B-CDocu.
        RELEASE Ccbdmov.
    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc-2 wWin 
PROCEDURE proc_AplicaDoc-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE
            B-CDocu.CodCia = s-codcia AND
            B-CDocu.CodDoc = para_CodDoc AND
            B-CDocu.NroDoc = para_NroDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            MESSAGE
                "DOCUMENTO" para_CodDoc para_NroDoc "NO REGISTRADO"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.CodDoc = B-CDocu.CodDoc     /* N/C */
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodDoc           /* A/C */
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.

        RELEASE B-CDocu.
        RELEASE Ccbdmov.
    END. /* DO TRANSACTION... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda wWin 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT iCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

IF iCodMon = 1 THEN RETURN "SOLES".
IF iCodMon = 2 THEN RETURN "DOLARES".

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

