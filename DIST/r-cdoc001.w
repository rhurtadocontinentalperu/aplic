&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-CodDiv LIKE s-coddiv.

x-CodDiv = s-CodDiv.

&SCOPED-DEFINE Condicion CntDocum.CodCia = s-codcia ~
AND CntDocum.CodDiv = x-coddiv ~
AND DATE(CntDocum.FchDoc) >= FILL-IN-Fecha-1 ~
AND DATE(CntDocum.FchDoc) <= FILL-IN-Fecha-2 ~
AND CntDocum.TipMov = RADIO-SET-TipMov

DEF STREAM REPORTE.

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
&Scoped-define INTERNAL-TABLES CntDocum

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CntDocum.FchDoc CntDocum.CodDoc ~
CntDocum.NroDoc CntDocum.NomCli CntDocum.NroBul CntDocum.Observac ~
CntDocum.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH CntDocum ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CntDocum ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CntDocum
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CntDocum


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Divisiones RADIO-SET-TipMov ~
BUTTON-Excel FILL-IN-Fecha-1 FILL-IN-Fecha-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Divisiones RADIO-SET-TipMov ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62 TOOLTIP "Exportar a Excel".

DEFINE VARIABLE COMBO-BOX-Divisiones AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TipMov AS CHARACTER INITIAL "S" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Salida", "S",
"Ingreso", "I"
     SIZE 12 BY 2.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CntDocum SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      CntDocum.FchDoc COLUMN-LABEL "Fecha - Hora" FORMAT "99/99/9999 HH:MM:SS":U
      CntDocum.CodDoc FORMAT "x(3)":U
      CntDocum.NroDoc FORMAT "X(9)":U WIDTH 10.14
      CntDocum.NomCli FORMAT "x(60)":U
      CntDocum.NroBul COLUMN-LABEL "Bultos" FORMAT "->,>>>,>>9":U
      CntDocum.Observac COLUMN-LABEL "Observaciones" FORMAT "x(40)":U
            WIDTH 43
      CntDocum.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 14
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Divisiones AT ROW 1.27 COL 9 COLON-ALIGNED WIDGET-ID 2
     RADIO-SET-TipMov AT ROW 1.27 COL 93 NO-LABEL WIDGET-ID 14
     BUTTON-Excel AT ROW 1.27 COL 135 WIDGET-ID 12
     FILL-IN-Fecha-1 AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Fecha-2 AT ROW 2.35 COL 39 COLON-ALIGNED WIDGET-ID 10
     BROWSE-2 AT ROW 3.69 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.43 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE MOVIMIENTOS"
         HEIGHT             = 17
         WIDTH              = 144.43
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 148.43
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 148.43
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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-Fecha-2 fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.CntDocum"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.CntDocum.FchDoc
"FchDoc" "Fecha - Hora" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.CntDocum.CodDoc
     _FldNameList[3]   > INTEGRAL.CntDocum.NroDoc
"NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CntDocum.NomCli
"NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CntDocum.NroBul
"NroBul" "Bultos" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CntDocum.Observac
"Observac" "Observaciones" "x(40)" "character" ? ? ? ? ? ? no ? no no "43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CntDocum.usuario
"usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONSULTA DE MOVIMIENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONSULTA DE MOVIMIENTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel wWin
ON CHOOSE OF BUTTON-Excel IN FRAME fMain /* Button 3 */
DO:
  ASSIGN
      COMBO-BOX-Divisiones 
      FILL-IN-Fecha-1 
      FILL-IN-Fecha-2 
      RADIO-SET-TipMov.
  RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Divisiones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Divisiones wWin
ON VALUE-CHANGED OF COMBO-BOX-Divisiones IN FRAME fMain /* División */
DO:
    ASSIGN {&self-name}.
    x-CodDiv = ENTRY(1, SELF:SCREEN-VALUE, ' - ').
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-1 wWin
ON LEAVE OF FILL-IN-Fecha-1 IN FRAME fMain /* Desde */
DO:
    ASSIGN {&self-name}.
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Fecha-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Fecha-2 wWin
ON LEAVE OF FILL-IN-Fecha-2 IN FRAME fMain /* Hasta */
DO:
    ASSIGN {&self-name}.
   {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-TipMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-TipMov wWin
ON VALUE-CHANGED OF RADIO-SET-TipMov IN FRAME fMain
DO:
    ASSIGN {&self-name}.
   {&OPEN-QUERY-{&BROWSE-NAME}}
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
  DISPLAY COMBO-BOX-Divisiones RADIO-SET-TipMov FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Divisiones RADIO-SET-TipMov BUTTON-Excel FILL-IN-Fecha-1 
         FILL-IN-Fecha-2 BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Titulo AS CHAR NO-UNDO.
DEF VAR x-linea AS CHAR NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).

x-Titulo = 'Fecha-Hora|Cod|Numero|Nombre|Bultos|Observaciones|Usuario|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTE x-Titulo SKIP.

FOR EACH CntDocum NO-LOCK WHERE {&Condicion}:
    x-linea = STRING ( cntdocum.fchdoc, '99/99/9999 hh:mm:ss') + '|' +
        cntdocum.coddoc + '|' +
        cntdocum.nrodoc + '|' +
        cntdocum.nomcli + '|' +
        STRING (cntdocum.nrobul, '->>>9') + '|' +
        cntdocum.observ + '|' +
        cntdocum.usuario + '|'.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-linea SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Detallado', YES).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Fecha-1 = DATETIME( TODAY - DAY(TODAY) + 1, MTIME)
      FILL-IN-Fecha-2 = DATETIME( TODAY, MTIME).
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia WITH FRAME {&FRAME-NAME}:
       COMBO-BOX-Divisiones:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv).
       IF s-coddiv = gn-divi.coddiv THEN COMBO-BOX-Divisiones = (gn-divi.coddiv + ' - ' + gn-divi.desdiv).
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

