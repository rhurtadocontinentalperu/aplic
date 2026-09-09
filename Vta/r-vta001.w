&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
{src/bin/_prns.i}
{lib/def-prn.i}    

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.

DEF VAR l-immediate-display AS LOGICAL.
DEF VAR PTO                 AS LOGICAL.
DEF VAR xTerm     AS CHARACTER INITIAL "".

DEF TEMP-TABLE T-Reporte
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodCli LIKE CcbCDocu.CodCli
    FIELD NomCli LIKE Gn-Clie.NomCli
    FIELD ImpMes AS DEC EXTENT 12
    FIELD ImpTot AS DEC
    INDEX Llave01 AS PRIMARY CodCli
    INDEX Llave02 CodCia ImpTot DESCENDING.

DEF VAR x-CodDiv   AS CHAR NO-UNDO.

DEF FRAME F-Proceso
    "Procesando Division"
    ccbcdocu.coddiv SKIP
    "Dia" 
    ccbcdocu.fchdoc
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES GN-DIVI

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH GN-DIVI ~
      WHERE GN-DIVI.CodCia = s-codcia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-44 RECT-45 BUTTON-1 FILL-IN-Periodo ~
BROWSE-1 BUTTON-2 RADIO-SET-1 B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE ~
RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo RADIO-SET-1 ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.73.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.73.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 5.58.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 8.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      GN-DIVI.CodDiv COLUMN-LABEL "Division" FORMAT "XX-XXX":U
      GN-DIVI.DesDiv FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 38 BY 5.38
         FONT 4
         TITLE "DIVISIONES".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.96 COL 63
     FILL-IN-Periodo AT ROW 2.15 COL 25 COLON-ALIGNED
     BROWSE-1 AT ROW 3.31 COL 11
     BUTTON-2 AT ROW 3.88 COL 63
     RADIO-SET-1 AT ROW 11.19 COL 10 NO-LABEL
     B-impresoras AT ROW 11.96 COL 23
     b-archivo AT ROW 13.12 COL 23
     RB-OUTPUT-FILE AT ROW 13.31 COL 28 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 14.85 COL 18 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 14.85 COL 33 COLON-ALIGNED
     RB-END-PAGE AT ROW 14.85 COL 47 COLON-ALIGNED
     "Marque la(s) división(es) a imprimir" VIEW-AS TEXT
          SIZE 24 BY .5 AT ROW 8.69 COL 11
          BGCOLOR 1 FGCOLOR 15 
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 14.27 COL 42
          FONT 6
     "Configuración de Impresión" VIEW-AS TEXT
          SIZE 38 BY .5 AT ROW 10.23 COL 6
          BGCOLOR 1 FGCOLOR 15 
     RECT-44 AT ROW 10.42 COL 3
     RECT-45 AT ROW 1.58 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 15.62
         FONT 4.


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
         TITLE              = "Ventas por Cliente Mensual"
         HEIGHT             = 15.69
         WIDTH              = 79.86
         MAX-HEIGHT         = 27.73
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.73
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 FILL-IN-Periodo F-Main */
/* SETTINGS FOR BUTTON b-archivo IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.GN-DIVI"
     _Where[1]         = "INTEGRAL.GN-DIVI.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ventas por Cliente Mensual */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ventas por Cliente Mensual */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo W-Win
ON CHOOSE OF b-archivo IN FRAME F-Main /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresi¢n ..."
        FILTERS    "Archivos Impresi¢n (*.txt)"   "*.txt",
                   "Todos (*.*)"   "*.*"
        INITIAL-DIR "./txt"
        MUST-EXIST
        USE-FILENAME
        UPDATE OKpressed.
      
    IF OKpressed = TRUE THEN
        RB-OUTPUT-FILE:SCREEN-VALUE = RB-OUTPUT-FILE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-impresoras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras W-Win
ON CHOOSE OF B-impresoras IN FRAME F-Main
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
    FILL-IN-Periodo.
  /* consistencia */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE 'Debe seleccionar al menos una division'
        VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  P-largo   = 62.
  P-Copias  = INPUT FRAME {&FRAME-NAME} RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME {&FRAME-NAME} RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME {&FRAME-NAME} RB-END-PAGE.
  P-select  = INPUT FRAME {&FRAME-NAME} RADIO-SET-1.
  P-archivo = INPUT FRAME {&FRAME-NAME} RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
  IF P-select = 2 
  THEN P-archivo = SESSION:TEMP-DIRECTORY + 
                    STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
  IF P-select <> 1 THEN P-copias = 1.
  RUN Imprimir.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  APPLY 'ENTRY':U TO FILL-IN-Periodo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
    IF SELF:SCREEN-VALUE = "3"
    THEN ASSIGN b-archivo:VISIBLE = YES
                RB-OUTPUT-FILE:VISIBLE = YES
                b-archivo:SENSITIVE = YES
                RB-OUTPUT-FILE:SENSITIVE = YES.
    ELSE ASSIGN b-archivo:VISIBLE = NO
                RB-OUTPUT-FILE:VISIBLE = NO
                b-archivo:SENSITIVE = NO
                RB-OUTPUT-FILE:SENSITIVE = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
  DEF VAR x-FchDoc-2 AS DATE NO-UNDO.
  DEF VAR x-ImpTot   AS DEC  NO-UNDO.
  DEF VAR x-Mes      AS INT  NO-UNDO.
  DEF VAR i          AS INT  NO-UNDO.
  
  ASSIGN
    x-FchDoc-1 = DATE(01,01,FILL-IN-Periodo)
    x-FchDoc-2 = DATE(12,31,FILL-IN-Periodo).
    
  x-CodDiv = ''.
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) IN FRAME {&FRAME-NAME}
    THEN DO:
        IF i = 1
        THEN x-CodDiv = TRIM(gn-divi.coddiv).
        ELSE x-CodDiv = x-CodDiv + ',' + TRIM(gn-divi.coddiv).
    END.
  END.
  
  FOR EACH T-Reporte:
    DELETE T-Reporte.
  END.
  
  FOR EACH CcbCDocu WHERE ccbcdocu.CodCia = s-codcia
        AND LOOKUP(TRIM(coddoc), 'FAC,BOL,N/D') > 0
        AND flgest <> 'A'
        AND fchdoc >= x-FchDoc-1
        AND fchdoc <= x-FchDoc-2
        AND LOOKUP(TRIM(ccbcdocu.coddiv), x-CodDiv) > 0
        NO-LOCK:
    DISPLAY ccbcdocu.coddiv ccbcdocu.fchdoc WITH FRAME F-Proceso.
    x-Mes = MONTH(ccbcdocu.fchdoc).
    /* todo a Soles */
    IF ccbcdocu.codmon = 1
    THEN x-ImpTot = ccbcdocu.imptot.
    ELSE x-ImpTot = ccbcdocu.imptot * ccbcdocu.tpocmb.

    FIND T-Reporte WHERE T-Reporte.codcli = ccbcdocu.codcli
        NO-ERROR.
    IF NOT AVAILABLE T-Reporte
    THEN CREATE T-Reporte.
    ASSIGN
        T-Reporte.codcia = ccbcdocu.codcia
        T-Reporte.codcli = ccbcdocu.codcli
        T-Reporte.ImpMes[x-Mes] = T-Reporte.ImpMes[x-Mes] + x-ImpTot
        T-Reporte.ImpTot = T-Reporte.ImpTot + x-ImpTot.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ccbcdocu.codcli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie
    THEN T-Reporte.nomcli = gn-clie.nomcli.
    ELSE T-Reporte.nomcli = ccbcdocu.nomcli.
  END.
  HIDE FRAME F-Proceso.
  
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
  DISPLAY FILL-IN-Periodo RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-44 RECT-45 BUTTON-1 FILL-IN-Periodo BROWSE-1 BUTTON-2 RADIO-SET-1 
         B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-CAB-1
    t-reporte.codcli     FORMAT 'x(11)'
    t-reporte.nomcli FORMAT 'x(30)'
    t-reporte.impmes[1]  FORMAT '->>>,>>>,>>9.99' 
    t-reporte.impmes[2]  FORMAT '->>>,>>>,>>9.99' 
    t-reporte.impmes[3]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[4]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[5]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[6]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[7]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[8]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[9]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[10] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[11] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[12] FORMAT '->>>,>>>,>>9.99'
    t-reporte.imptot     FORMAT '->>>,>>>,>>9.99' SKIP    
    HEADER
        {&PRN4} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + 'VENTAS POR CLIENTE MENSUAL' + {&PRN6B} + {&PRN4} FORMAT 'x(30)' AT 43
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + 'PERIODO ' + STRING(FILL-IN-Periodo, '9999') + {&PRN6B} + {&PRN4}  FORMAT 'x(30)' AT 43
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISON(NES): " x-CodDiv FORMAT 'x(80)' SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
        "CODIGO      NOMBRE O RAZON SOCIAL                   ENERO         FEBRERO           MARZO           ABRIL            MAYO          JUNIO           JULIO          AGOSTO        SETIEMBRE         OCTUBRE        NOVIEMBRE      DICIEMBRE         TOTAL   " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
/*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         12345678901 123456789012345678901234567890 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99
*/

  WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME F-CAB-2
    t-reporte.impmes[7]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[8]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[9]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[10] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[11] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[12] FORMAT '->>>,>>>,>>9.99'
    t-reporte.imptot     FORMAT '->>>,>>>,>>9.99' SKIP
    HEADER
        {&PRN4} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + 'VENTAS POR CLIENTE MENSUAL' + {&PRN6B} + {&PRN4} FORMAT 'x(30)' AT 43
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + 'PERIODO ' + STRING(FILL-IN-Periodo, '9999') + {&PRN6B} + {&PRN4}  FORMAT 'x(30)' AT 43
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISON(NES): " x-CodDiv FORMAT 'x(80)' SKIP
        "---------------------------------------------------------------------------------------------------------------" SKIP
        "         JULIO          AGOSTO       SETIEMBRE         OCTUBRE       NOVIEMBRE      DICIEMBRE            TOTAL " SKIP
        "---------------------------------------------------------------------------------------------------------------" SKIP
/*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 
*/

  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH T-Reporte BREAK BY T-Reporte.CodCia BY T-Reporte.ImpTot DESCENDING ON ERROR UNDO, LEAVE:
    {&new-page}.
    IF ERROR-STATUS:ERROR = YES THEN LEAVE.
    DISPLAY STREAM REPORT
        t-reporte.impmes[7] 
        t-reporte.impmes[8] 
        t-reporte.impmes[9] 
        t-reporte.impmes[10] 
        t-reporte.impmes[11] 
        t-reporte.impmes[12] 
        t-reporte.imptot 
        WITH FRAME F-CAB-2.
  END.
  c-Pagina = 0.
  FOR EACH T-Reporte BREAK BY T-Reporte.CodCia BY T-Reporte.ImpTot DESCENDING ON ERROR UNDO, LEAVE:
    {&new-page}.
    IF ERROR-STATUS:ERROR = YES THEN LEAVE.
    DISPLAY STREAM REPORT
        t-reporte.codcli
        t-reporte.nomcli
        t-reporte.impmes[1] 
        t-reporte.impmes[2] 
        t-reporte.impmes[3] 
        t-reporte.impmes[4] 
        t-reporte.impmes[5] 
        t-reporte.impmes[6]
        t-reporte.impmes[7] 
        t-reporte.impmes[8] 
        t-reporte.impmes[9] 
        t-reporte.impmes[10] 
        t-reporte.impmes[11] 
        t-reporte.impmes[12] 
        t-reporte.imptot         
        WITH FRAME F-CAB-1.
  END.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
  END CASE.                                             

END PROCEDURE.


/* ************************************** ASI ERA MEJOR
  DEFINE FRAME F-CAB
    t-reporte.codcli
    t-reporte.impmes[1]  FORMAT '->>>,>>>,>>9.99' AT 32
    t-reporte.impmes[2]  FORMAT '->>>,>>>,>>9.99' 
    t-reporte.impmes[3]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[4]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[5]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[6]  FORMAT '->>>,>>>,>>9.99' SKIP
    t-reporte.nomcli FORMAT 'x(30)'
    t-reporte.impmes[7]  FORMAT '->>>,>>>,>>9.99' AT 32
    t-reporte.impmes[8]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[9]  FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[10] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[11] FORMAT '->>>,>>>,>>9.99'
    t-reporte.impmes[12] FORMAT '->>>,>>>,>>9.99'
    t-reporte.imptot     FORMAT '->>>,>>>,>>9.99' SKIP
    HEADER
        {&PRN4} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + 'VENTAS POR CLIENTE MENSUAL' + {&PRN6B} + {&PRN4} FORMAT 'x(30)' AT 43
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN6A} + 'PERIODO ' + STRING(FILL-IN-Periodo, '9999') + {&PRN6B} + {&PRN4}  FORMAT 'x(30)' AT 43
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
        "DIVISON(NES): " x-CodDiv FORMAT 'x(80)' SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "CODIGO                                  ENERO         FEBRERO           MARZO           ABRIL            MAYO          JUNIO                  " SKIP
        "NOMBRE                                  JULIO          AGOSTO       SETIEMBRE         OCTUBRE       NOVIEMBRE      DICIEMBRE            TOTAL " SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         12345678901                    ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 
         123456789012345678901234567890 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 ->>>,>>>,>>9.99 
*/

  WITH WIDTH 160 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH T-Reporte BREAK BY T-Reporte.CodCia BY T-Reporte.ImpTot DESCENDING ON ERROR UNDO, LEAVE:
    {&new-page}.
    IF ERROR-STATUS:ERROR = YES THEN LEAVE.
    DISPLAY STREAM REPORT
        t-reporte.codcli
        t-reporte.nomcli
        t-reporte.impmes[1] 
        t-reporte.impmes[2] 
        t-reporte.impmes[3] 
        t-reporte.impmes[4] 
        t-reporte.impmes[5] 
        t-reporte.impmes[6] 
        t-reporte.impmes[7] 
        t-reporte.impmes[8] 
        t-reporte.impmes[9] 
        t-reporte.impmes[10] 
        t-reporte.impmes[11] 
        t-reporte.impmes[12] 
        t-reporte.imptot 
        WITH FRAME F-CAB.
  END.

  CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
  END CASE.                                             
  OUTPUT STREAM REPORT CLOSE.
********************************************************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN Carga-Temporal.
  FIND FIRST T-Reporte NO-ERROR.
  IF NOT AVAILABLE T-Reporte
  THEN DO:
    MESSAGE 'No hay registros a imprimir'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
  END.

  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  FRAME F-Mensaje:TITLE =  FRAME {&FRAME-NAME}:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
    OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
    c-Pagina = 0.
    RUN Formato.
    OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY = l-immediate-display.
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
    RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  

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
  FILL-IN-Periodo = YEAR(TODAY).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE New-Page W-Win 
PROCEDURE New-Page :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina 
    THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1 
        THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RemVar W-Win 
PROCEDURE RemVar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER IN-VAR AS CHARACTER.
    DEFINE OUTPUT PARAMETER OU-VAR AS CHARACTER.
    DEFINE VARIABLE P-pos AS INTEGER.
    OU-VAR = IN-VAR.
    IF P-select = 2 THEN DO:
        OU-VAR = "".
        RETURN.
    END.
    P-pos =  INDEX(OU-VAR, "[NULL]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
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
  {src/adm/template/snd-list.i "GN-DIVI"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print W-Win 
PROCEDURE Setup-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND integral.P-Codes WHERE integral.P-Codes.Name = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.P-Codes
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" XTerm
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT integral.P-Codes.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT integral.P-Codes.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT integral.P-Codes.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT integral.P-Codes.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT integral.P-Codes.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT integral.P-Codes.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT integral.P-Codes.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT integral.P-Codes.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT integral.P-Codes.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT integral.P-Codes.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT integral.P-Codes.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT integral.P-Codes.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT integral.P-Codes.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT integral.P-Codes.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT integral.P-Codes.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT integral.P-Codes.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT integral.P-Codes.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT integral.P-Codes.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT integral.P-Codes.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT integral.P-Codes.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT integral.P-Codes.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT integral.P-Codes.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT integral.P-Codes.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT integral.P-Codes.Lpi,      OUTPUT P-Lpi).

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

