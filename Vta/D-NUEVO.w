&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
/*DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE TEMP-TABLE NOTCRE LIKE CCBCDOCU.  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE VAR W-ImporteS AS DECIMAL EXTENT 6 INIT 0.
DEFINE VAR W-ImporteD AS DECIMAL EXTENT 6 INIT 0.
 

 DEFINE VAR F-ImpBrt AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpDto AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR F-ImpVta AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpExo AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIgv AS DECIMAL FORMAT "(>>>,>>9.99)".
 DEFINE VAR F-ImpTot AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIsc AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR JJ       AS INTEGER NO-UNDO.
 DEFINE VAR F-TOTCON AS DECIMAL EXTENT 6 INITIAL 0.
 DEFINE VAR F-TOTCRE AS DECIMAL EXTENT 6 INITIAL 0.
 C = 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-50 RECT-48 RECT-49 RECT-5 RECT-51 ~
R-S-TipImp RADIO-SET-1 FILL-IN-CodDiv FILL-IN-efesol B-impresoras B-imprime ~
FILL-IN-efedol B-cancela FILL-IN-remesol f-desde BUTTON-3 FILL-IN-remedol ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS R-S-TipImp RADIO-SET-1 FILL-IN-CodDiv ~
FILL-IN-efesol FILL-IN-efedol FILL-IN-remesol f-desde FILL-IN-remedol ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "Button 3" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 1 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-efedol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "US$/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-efesol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-remedol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "US$/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-remesol AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "S/." 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     FONT 8 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
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
     SIZE 29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE R-S-TipImp AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detalle", 1,
"Cierre", 2
     SIZE 14.72 BY 1.5
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla ", 2,
"Impresora", 1,
"Archivo  ", 3
     SIZE 12 BY 3
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.86 BY 6.08.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 1.69.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 3.92.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39.43 BY 2.62.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.14 BY 2.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     R-S-TipImp AT ROW 2.38 COL 3.29 NO-LABEL
     RADIO-SET-1 AT ROW 8.27 COL 3.86 NO-LABEL
     FILL-IN-CodDiv AT ROW 1.31 COL 3.15
     FILL-IN-efesol AT ROW 5.5 COL 19 RIGHT-ALIGNED
     B-impresoras AT ROW 9.27 COL 16.86
     b-archivo AT ROW 10.27 COL 16.86
     B-imprime AT ROW 11.96 COL 19.86
     RB-OUTPUT-FILE AT ROW 10.5 COL 21.14 COLON-ALIGNED NO-LABEL
     FILL-IN-efedol AT ROW 5.5 COL 24.14 COLON-ALIGNED
     B-cancela AT ROW 12 COL 36.14
     FILL-IN-remesol AT ROW 5.5 COL 44.14 COLON-ALIGNED
     f-desde AT ROW 2.19 COL 49.29 COLON-ALIGNED
     BUTTON-3 AT ROW 12 COL 51.29
     FILL-IN-remedol AT ROW 5.5 COL 65.29 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 8.42 COL 71.29 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9.42 COL 71.29 COLON-ALIGNED
     RB-END-PAGE AT ROW 10.42 COL 71.29 COLON-ALIGNED
     RECT-50 AT ROW 4.35 COL 3
     RECT-48 AT ROW 1.04 COL 1.57
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 7.23 COL 1.72
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-49 AT ROW 1.65 COL 45
     "Remesas" VIEW-AS TEXT
          SIZE 12.14 BY .85 AT ROW 4.58 COL 58.57
          FONT 8
     "Efectivo" VIEW-AS TEXT
          SIZE 10.86 BY 1 AT ROW 4.54 COL 18.86
          FONT 12
     RECT-5 AT ROW 7.88 COL 1.43
     RECT-51 AT ROW 4.35 COL 42.72
     SPACE(1.57) SKIP(6.79)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Cierre Por Usuario".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodDiv IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-efesol IN FRAME D-Dialog
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       RECT-48:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Cierre Por Usuario */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo D-Dialog
ON CHOOSE OF b-archivo IN FRAME D-Dialog /* Archivos.. */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras D-Dialog
ON CHOOSE OF B-impresoras IN FRAME D-Dialog
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime D-Dialog
ON CHOOSE OF B-imprime IN FRAME D-Dialog /* Imprimir */
DO:
   
  ASSIGN f-Desde R-S-TipImp FILL-IN-CodDiv
         FILL-IN-efesol FILL-IN-efedol FILL-IN-remesol FILL-IN-remedol.
  
  
  IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  
 
  /*IF R-S-TipImp = 2 AND (FILL-IN-efesol = 0 OR FILL-IN-efedol = 0 OR
 *      FILL-IN-remesol = 0 OR FILL-IN-remedol = 0)  then do: MESSAGE "Ingrese los Importes ... " VIEW-AS ALERT-BOX.
 *      APPLY "ENTRY":U to FILL-IN-efesol.
 *      RETURN NO-APPLY.   
 *   END.*/

  
  T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
          
  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
     
  IF P-select = 2 
     THEN P-archivo = SESSION:TEMP-DIRECTORY + 
          STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
  ELSE RUN setup-print.      
     IF P-select <> 1 
     THEN P-copias = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

ASSIGN FILL-IN-Coddiv = S-CODDIV
       F-DESDE   = TODAY.
       
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
  SESSION:IMMEDIATE-DISPLAY = YES.

  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
       
    OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.
  
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ANULADOS D-Dialog 
PROCEDURE ANULADOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO AS CHAR.
  X-MOVTO = 'ANULADO'.
 
 
  

  DEFINE FRAME f-cab
        NOTCRE.CodDoc FORMAT "XXX"
        NOTCRE.NroDoc FORMAT "XXX-XXXXXX"
        NOTCRE.FchDoc 
        NOTCRE.Codcli FORMAT "X(10)"
        NOTCRE.NomCli FORMAT "X(35)"
        X-MON         FORMAT "X(4)"
        F-ImpTot 
        NOTCRE.fmapgo format "x(4)"
        X-GLO         FORMAT "X(16)"
        X-CODREF      FORMAT "XXX"
        X-NROREF      FORMAT "XXX-XXXXXX"
        X-FECHA
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " REPORTE DE DOCUMENTOS ANULADOS"  AT 41 FORMAT "X(45)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
         "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                                  TOTAL                                         " SKIP
        "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
     FOR EACH NOTCRE WHERE 
             NOTCRE.Flgest = 'A'
             BREAK BY NOTCRE.codcia BY NOTCRE.Fchdoc  BY NOTCRE.FmaPgo BY (NOTCRE.FmaPgo + NOTCRE.Coddoc)
             BY NOTCRE.Nrodoc:
   
     x-tpocmb = NOTCRE.Tpocmb.
           
     
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.
     x-anula  = "----- A N U L A D O -------".
     x-mon    = "".
     x-ven    = "".
     x-ruc    = "".
     
     IF NOTCRE.Flgest = 'A'  THEN DO:
       
        F-Imptot = ImpTot.
        x-anula  = NOTCRE.Nomcli.
        x-ven    = NOTCRE.Codven.
        x-ruc    = NOTCRE.Ruccli.
        IF NOTCRE.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
       
     END.
     
     IF FIRST-OF(NOTCRE.fmapgo) THEN DO:
          ASSIGN  XX-SOL = 0 XX-DOL = 0.     
          x-titu2 = " ".
          FIND gn-convt WHERE gn-convt.codig   = NOTCRE.fmapgo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-convt THEN do:
            x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     IF FIRST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          ASSIGN X-SOL = 0 X-DOL = 0.
          x-titu1 = " ".
          FIND facdocum WHERE facdocum.codcia  = NOTCRE.codcia and facdocum.coddoc = NOTCRE.coddoc NO-LOCK NO-ERROR.
          IF AVAILABLE facdocum THEN do:
            x-titu1 = TRIM(facdocum.NomDoc) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     X = 1.
     X-GLO    = ' '.
     X-CODREF = ' '.
     X-NROREF = ' '.
     
   
     IF NOTCRE.codmon = 1 THEN DO:
       X-SOL  = X-SOL  + ( X * F-IMPTOT ).
       XX-SOL = XX-SOL + ( X * F-IMPTOT ).
       END.
     ELSE DO:
       X-DOL  = X-DOL  + (X * F-IMPTOT ).
       XX-DOL = XX-DOL + (X * F-IMPTOT ).
     END. 

     IF R-S-TipImp = 1 THEN DO:
                 
        DISPLAY STREAM REPORT 
              NOTCRE.CodDoc 
              NOTCRE.NroDoc 
              NOTCRE.FchDoc 
              NOTCRE.Codcli
              TRIM(x-anula)  @ NOTCRE.NomCli 
              X-MON           
              F-ImpTot WHEN F-ImpTot <> 0
              NOTCRE.Fmapgo
              /*X-GLO 
 *               X-CODREF
 *               X-NROREF 
 *               X-FECHA WHEN NOTCRE.Coddoc = 'N/C'*/
              WITH FRAME F-Cab.
              
          
        
        IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
        IF LAST-OF(NOTCRE.Fmapgo) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
     END.
     /*IF R-S-TipImp = 2 THEN DO:
 *         IF LAST-OF(NOTCRE.Coddoc) OR LAST-OF(NOTCRE.Fmapgo) THEN DO:
 *           display  STREAM REPORT.
 *           PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
 *         END.
 *      END.*/
 
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-notcre D-Dialog 
PROCEDURE carga-notcre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH CcbcDocu NO-LOCK WHERE 
           CcbcDocu.CodCia = S-CODCIA AND
           CcbcDocu.CodDiv = FILL-IN-CodDiv AND 
           CcbcDocu.FchDoc = F-desde AND
           CcbcDocu.Usuario = S-user-id AND
           LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 
           USE-INDEX LLAVE10:
  CREATE notcre.
  RAW-TRANSFER Ccbcdocu TO notcre.
  
 END.
 FOR EACH notcre WHERE LOOKUP(notcre.CodDoc,"N/C,N/D") > 0 :
    find ccbcdocu where ccbcdocu.codcia = s-codcia and
         ccbcdocu.coddiv = FILL-IN-CodDiv and
         ccbcdocu.coddoc = notcre.codref  and 
         ccbcdocu.nrodoc = notcre.nroref USE-INDEX LLAVE00 no-lock no-error.
    if available ccbcdocu then do:
      notcre.fmapgo = ccbcdocu.fmapgo.
    end.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chequeresu D-Dialog 
PROCEDURE chequeresu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.
 DEFINE VAR X-SOLDEPO    AS DECIMAL INIT 0.
 DEFINE VAR X-DOLDEPO    AS DECIMAL INIT 0.

 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
     
                
        

 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[2] <> 0 OR CcbcCaja.ImpNac[3] <> 0 OR
          CcbcCaja.ImpUsa[2] <> 0 OR CcbcCaja.ImpUsa[3] <> 0 OR 
          CcbcCaja.ImpUsa[5] <> 0 OR CcbcCaja.ImpNac[5] <> 0 ) AND

/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
     
        X-IMPO   = 0.
        IF CcbCCaja.ImpNac[2] <> 0 OR CcbCCaja.ImpNac[3] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpNac[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpNac[3].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[2] <> 0 OR CcbCCaja.ImpUsa[3] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpUsa[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpUsa[3].
          x-dol     = x-dol + x-impo.
        END.   

        IF CcbCCaja.ImpNac[5] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpNac[5].
          x-soldepo = x-soldepo + x-impo.
        END.   
        
        IF CcbCCaja.ImpUsa[5] <> 0 THEN DO:
          x-impo    = CcbCCaja.ImpUsa[5].
          x-doldepo = x-doldepo + x-impo.
        END.   

                
                
 END. 
 
 T-MOVTO  = "CHEQUES (recepcionados)".
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
 PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO  AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
 DISPLAY STREAM REPORT.
 PUT STREAM REPORT X-SOL AT 80 X-DOL AT 110.

 T-MOVTO  = "DEPOSITOS (recepcionados)".
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
 PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
 DISPLAY STREAM REPORT.
 PUT STREAM REPORT X-SOLDEPO AT 80 X-DOLDEPO AT 110.
 
RUN PENDIENTE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CHEQUES D-Dialog 
PROCEDURE CHEQUES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.
 DEFINE FRAME f-cab3
        CcbcCaja.Tipo FORMAT "X(10)"
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbcCaja.Voucher[2]
        CcbcCaja.CodBco[2]
        CcbcCaja.CodCta[2]
        CcbcCaja.Fchvto[2]
        x-mon
        CcbcCaja.ImpNac[2]
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE CHEQUES RECEPCIONADOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                     NUMERO                                FECHA                                      " SKIP   
        " TIPO       FECHA     CODIGO     NOMBRE              CHEQUE             BANCO   CUENTA      VCTO   MONEDA          IMPORTE            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

      
 
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[2] <> 0 OR CcbcCaja.ImpNac[3] <> 0 OR
          CcbcCaja.ImpUsa[2] <> 0 OR CcbcCaja.ImpUsa[3] <> 0) AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID      NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
       
     
        X-IMPO   = 0.
        T-MOVTO  = "CHEQUES ".
        IF X-CONT = 0 THEN DO:
          DISPLAY STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-CAB3.
          PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(40)".  
          X-CONT = 1.       
        END.   
        IF CcbCCaja.ImpNac[2] <> 0 OR CcbCCaja.ImpNac[3] <> 0 THEN DO:
          x-mon     = 'S/.'.
          x-impo    = CcbCCaja.ImpNac[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpNac[3].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[2] <> 0 OR CcbCCaja.ImpUsa[3] <> 0 THEN DO:
          x-mon     = 'US$.'.
          x-impo    = CcbCCaja.ImpUsa[2].
          IF x-impo = 0 THEN x-impo = CcbCCaja.ImpUsa[3].
          x-dol     = x-dol + x-impo.
        END.   
       
        DISPLAY STREAM REPORT
          CcbcCaja.Tipo   
          CcbcCaja.Fchdoc
          CcbcCaja.Codcli
          CcbcCaja.Nomcli
          CcbcCaja.Voucher[2]
          CcbcCaja.CodBco[2]
          CcbcCaja.CodCta[2]
          CcbcCaja.Fchvto[2]
          x-mon
          x-impo
          WITH FRAME f-cab3.
                
 END. 

 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT.
 PUT STREAM REPORT SKIP(2).
 PUT STREAM REPORT 
 {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
 PUT STREAM REPORT   
 {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
       

 
RUN DEPOSITOS.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deporesu D-Dialog 
PROCEDURE deporesu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.

 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
     
        T-MOVTO  = "BOLETAS  DE DEPOSITO".
        DISPLAY STREAM REPORT.
        DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
        PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(35)".  
 

 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[5] <> 0 OR CcbcCaja.ImpUsa[5] <> 0)
/*        CcbCCaja.CodCaja = S-CODTER AND 
          CcbCCaja.usuario = S-USER-ID    */   NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
     
        X-IMPO   = 0.
                IF CcbCCaja.ImpNac[5] <> 0  THEN DO:
          x-mon     = 'S/.'.
          x-impo    = CcbCCaja.ImpNac[5].
        END.   

        IF CcbCCaja.ImpUsa[5] <> 0  THEN DO:
          x-mon     = 'US$.'.
          x-impo    = CcbCCaja.ImpUsa[5].
        END.   
       
        DISPLAY STREAM REPORT
          CcbcCaja.Tipo   
          CcbcCaja.Fchdoc
          CcbcCaja.Codcli
          CcbcCaja.Nomcli
          CcbcCaja.Voucher[5]
          CcbcCaja.CodBco[5]
          CcbcCaja.CodCta[5]
          CcbcCaja.Fchvto[5]
          x-mon
          x-impo
          WITH FRAME f-cab3.
                
 END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DEPOSITOS D-Dialog 
PROCEDURE DEPOSITOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR X-impo   AS DECIMAL.
 DEFINE VAR T-MOVTO  AS CHAR.
 DEFINE VAR X-CONT   AS INTEGER INIT 0.
 DEFINE VAR X-SOL    AS DECIMAL INIT 0.
 DEFINE VAR X-DOL    AS DECIMAL INIT 0.

 DEFINE FRAME f-cab3
        CcbcCaja.Tipo FORMAT "X(10)"
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbcCaja.Voucher[5]
        CcbcCaja.CodBco[5]
        CcbcCaja.CodCta[5]
        CcbcCaja.Fchvto[5]
        x-mon
        CcbcCaja.ImpNac[5]
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE DEPOSITOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                     NUMERO                                FECHA                                      " SKIP   
        " TIPO       FECHA     CODIGO     NOMBRE             B. DEPOSITO         BANCO   CUENTA      VCTO   MONEDA          IMPORTE            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

      
 
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          CCbcCaja.Flgest  <> 'A' AND
         (CcbcCaja.ImpNac[5] <> 0 OR CcbcCaja.ImpUsa[5] <> 0) AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo  
                BY CcbcCaja.NroDoc:
           
       {&new-page}.
            
     
        X-IMPO   = 0.
        T-MOVTO  = "BOLETAS  DE DEPOSITO".
        IF X-CONT = 0 THEN DO:
          DISPLAY STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-CAB3.
          PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(60)".  
          X-CONT = 1.       
        END.   
        IF CcbCCaja.ImpNac[5] <> 0  THEN DO:
          x-mon     = 'S/.'.
          x-impo    = CcbCCaja.ImpNac[5].
          x-sol     = x-sol + x-impo.
        END.   

        IF CcbCCaja.ImpUsa[5] <> 0  THEN DO:
          x-mon     = 'US$.'.
          x-impo    = CcbCCaja.ImpUsa[5].
          x-dol     = x-dol + x-impo.
        END.   
       
        DISPLAY STREAM REPORT
          CcbcCaja.Tipo   
          CcbcCaja.Fchdoc
          CcbcCaja.Codcli
          CcbcCaja.Nomcli
          CcbcCaja.Voucher[5]
          CcbcCaja.CodBco[5]
          CcbcCaja.CodCta[5]
          CcbcCaja.Fchvto[5]
          x-mon
          x-impo
          WITH FRAME f-cab3.
                
 END. 
 DISPLAY STREAM REPORT.
 DOWN(1) STREAM REPORT.
 PUT STREAM REPORT SKIP(2).
 PUT STREAM REPORT 
 {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
 PUT STREAM REPORT   
 {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
       


 
RUN PENDIENTE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY R-S-TipImp RADIO-SET-1 FILL-IN-CodDiv FILL-IN-efesol FILL-IN-efedol 
          FILL-IN-remesol f-desde FILL-IN-remedol RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-50 RECT-48 RECT-49 RECT-5 RECT-51 R-S-TipImp RADIO-SET-1 
         FILL-IN-CodDiv FILL-IN-efesol B-impresoras B-imprime FILL-IN-efedol 
         B-cancela FILL-IN-remesol f-desde BUTTON-3 FILL-IN-remedol 
         RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
./*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 
 
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO  AS CHAR.


  X-MOVTO  = '(emitido)'. 
  run carga-notcre.

  DEFINE FRAME f-cab2
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " C I E R R E   D E   C A J A "  AT 35 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)"  STRING(TIME,"HH:MM:SS") SKIP 
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                      " SKIP
        "          C O N C E P T O S                                                            SOLES                       DOLARES            " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME f-cab
        NOTCRE.CodDoc FORMAT "XXX"
        NOTCRE.NroDoc FORMAT "XXX-XXXXXX"
        NOTCRE.FchDoc 
        NOTCRE.Codcli FORMAT "X(10)"
        NOTCRE.NomCli FORMAT "X(35)"
        X-MON         FORMAT "X(4)"
        F-ImpTot      
        NOTCRE.fmapgo format "x(4)"
        X-GLO         FORMAT "X(16)"
        X-CODREF      FORMAT "XXX"
        X-NROREF      FORMAT "XXX-XXXXXX"
        X-FECHA
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " REPORTE DE DOCUMENTOS EMITIDOS"  AT 41 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)"  STRING(TIME,"HH:MM:SS") SKIP 
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                                  TOTAL                                         " SKIP
        "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 /* FOR EACH NOTCRE NO-LOCK WHERE 
 *            NOTCRE.CodCia = S-CODCIA AND
 *            NOTCRE.CodDiv = FILL-IN-CodDiv AND 
 *            NOTCRE.FchDoc >= F-desde AND
 *            NOTCRE.FchDoc <= F-hasta AND 
 *            LOOKUP(NOTCRE.CodDoc,"BOL,FAC,N/C,N/D") > 0 
 *            NOTCRE.Flgest <> "A"
 *            USE-INDEX LLAVE10
  *  */ 
    FOR EACH NOTCRE WHERE 
             NOTCRE.Flgest <> 'A'
             BREAK BY NOTCRE.codcia BY NOTCRE.Fchdoc  BY NOTCRE.FmaPgo BY (NOTCRE.FmaPgo + NOTCRE.Coddoc)
             BY NOTCRE.Nrodoc:
   

     IF R-S-TipImp = 1 THEN  {&NEW-PAGE}.
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.
     x-anula  = "----- A N U L A D O -------".
     x-mon    = "".
     x-ven    = "".
     x-ruc    = "".
     IF NOTCRE.Flgest = 'A' THEN NEXT.
     IF NOTCRE.Flgest <> 'A'  THEN DO:
        F-ImpBrt = ImpBrt.
        F-ImpDto = ImpDto.
        F-ImpExo = ImpExo.
        F-ImpVta = ImpVta.
        F-ImpIgv = ImpIgv.
        F-Imptot = ImpTot.
        x-anula  = NOTCRE.Nomcli.
        x-ven    = NOTCRE.Codven.
        x-ruc    = NOTCRE.Ruccli.
        IF NOTCRE.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
       
     END.
     
     IF FIRST-OF(NOTCRE.fmapgo) THEN DO:
          ASSIGN  XX-SOL = 0 XX-DOL = 0.     
          x-titu2 = " ".
          FIND gn-convt WHERE gn-convt.codig   = NOTCRE.fmapgo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-convt THEN do:
            x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     IF FIRST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          ASSIGN X-SOL = 0 X-DOL = 0.
          x-titu1 = " ".
          FIND facdocum WHERE facdocum.codcia  = NOTCRE.codcia and facdocum.coddoc = NOTCRE.coddoc NO-LOCK NO-ERROR.
          IF AVAILABLE facdocum THEN do:
            x-titu1 = facdocum.NomDoc.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     X = 1.
     X-GLO    = ' '.
     X-CODREF = ' '.
     X-NROREF = ' '.
     
     IF NOTCRE.Coddoc = 'N/C' THEN DO:
       X-CODREF = NOTCRE.Codref.
       X-NROREF = NOTCRE.Nroref.
       X-GLO    = 'DEVOLUCION'.
       X        = -1.
       IF NOTCRE.Cndcre = 'N' THEN DO:
       FIND CCBDDOCU WHERE CCBDDOCU.CODCIA = NOTCRE.Codcia AND 
                          CCBDDOCU.CODDOC = NOTCRE.Coddoc AND
                          CCBDDOCU.NRODOC = NOTCRE.Nrodoc NO-LOCK USE-INDEX LLAVE01.
        IF AVAILABLE CCBDDOCU THEN DO:
         FIND CCBTABLA WHERE CCBTABLA.CODCIA = CCBDDOCU.Codcia AND
                             CCBTABLA.TABLA  = 'N/C' AND
                             CCBTABLA.CODIGO = CCBDDOCU.CODMAT NO-LOCK.
         IF AVAILABLE CCBTABLA THEN x-glo = CCBTABLA.Nombre.                  
        END.
       END. 
       FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = NOTCRE.Codcia AND 
                           CCBCDOCU.CODDOC = NOTCRE.Coddoc AND
                           CCBCDOCU.NRODOC = NOTCRE.Nrodoc NO-LOCK USE-INDEX LLAVE01.
       IF AVAILABLE CCBCDOCU THEN X-FECHA = CCBCDOCU.FCHDOC. 
     END.
     IF NOTCRE.codmon = 1 THEN DO:
       X-SOL  = X-SOL  + ( X * F-IMPTOT ).
       XX-SOL = XX-SOL + ( X * F-IMPTOT ).
       END.
     ELSE DO:
       X-DOL  = X-DOL  + (X * F-IMPTOT ).
       XX-DOL = XX-DOL + (X * F-IMPTOT ).
     END. 

     IF R-S-TipImp = 1 THEN DO:
                 
        DISPLAY STREAM REPORT 
              NOTCRE.CodDoc 
              NOTCRE.NroDoc 
              NOTCRE.FchDoc 
              NOTCRE.Codcli
              TRIM(x-anula)  @ NOTCRE.NomCli 
              X-MON           
              F-ImpTot         WHEN F-ImpTot <> 0
              NOTCRE.Fmapgo
              X-GLO 
              X-CODREF 
              X-NROREF 
              X-FECHA          WHEN NOTCRE.Coddoc = 'N/C'
              WITH FRAME F-Cab.
              
        IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
        IF LAST-OF(NOTCRE.Fmapgo) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55 {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55 {&PRN3} + {&PRN6B} SKIP(5). 
        END.
     END.
     IF R-S-TipImp = 2 THEN DO:
          IF LAST-OF(NOTCRE.Fmapgo + NOTCRE.Coddoc) THEN DO:
            display  STREAM REPORT.
            PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
          END.
     END.
 
 END.

 
 /**********************************************/
 
 IF R-S-TipImp = 2 THEN DO:
  RUN RECIBORESU.
 END.
 ELSE DO:
  RUN RECIBOS.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir-2 D-Dialog 
PROCEDURE imprimir-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  DEFINE FRAME F-RESU
 *          HEADER
 *         {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
 *         {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
 *         {&PRN6A} + " RESUMEN DE VENTAS "  AT 43 FORMAT "X(35)"
 *         {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
 *         "Vendedor : " 
 *         {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
 *         {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
 *         "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
 *         WITH PAGE-TOP NO-LABEL NO-UNDERLINE NO-BOX WIDTH 165 STREAM-IO DOWN.         
 * 
 *  IF R-S-TipImp <> 2 THEN DO:
 *     IF C = 0 THEN {&NEW-PAGE}.
 *     IF C = 1 THEN PAGE STREAM REPORT.
 *     VIEW STREAM REPORT FRAME F-RESU.
 *     PUT STREAM REPORT {&PRN6A} + " T O T A L    C O N T A D O" + {&PRN6B} FORMAT "X(50)" SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "Total Bruto     :" AT 1 W-ConBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Total Bruto     :"      W-ConBru[1] AT 69  FORMAT "->>,>>9.99"    W-ConBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
 *                       "Total Bruto     :"      W-ConBru[5] AT 116 FORMAT "->>,>>9.99"    W-ConBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 *     PUT STREAM REPORT "Descuento       :" AT 1 W-ConDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-ConDsc[1] AT 69  FORMAT "->>,>>9.99"    W-ConDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-ConDsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Exonerado       :" AT 1 W-ConExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-ConExo[1] AT 69  FORMAT "->>,>>9.99"    W-ConExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-ConExo[5] AT 116 FORMAT "->>,>>9.99"    W-ConExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Valor de Venta  :" AT 1 W-ConVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-ConVal[1] AT 69  FORMAT "->>,>>9.99"    W-ConVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-ConVal[5] AT 116 FORMAT "->>,>>9.99"    W-ConVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.S.C.          :" AT 1 W-ConIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-ConIsc[1] AT 69  FORMAT "->>,>>9.99"    W-ConIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-ConIsc[5] AT 116 FORMAT "->>,>>9.99"    W-ConIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.G.V.          :" AT 1 W-ConIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-ConIgv[1] AT 69  FORMAT "->>,>>9.99"    W-ConIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-ConIgv[5] AT 116 FORMAT "->>,>>9.99"    W-ConIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Precio de Venta :" AT 1 W-ConVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-ConVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-ConVen[1] AT 69  FORMAT "->>,>>9.99"    W-ConVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-ConVen[5] AT 116 FORMAT "->>,>>9.99"    W-ConVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
 *         
 *     PUT STREAM REPORT {&PRN6A} + " T O T A L    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "Total Bruto     :" AT 1 W-CreBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Total Bruto     :"      W-CreBru[1] AT 69  FORMAT "->>,>>9.99"    W-CreBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
 *                       "Total Bruto     :"      W-CreBru[5] AT 116 FORMAT "->>,>>9.99"    W-CreBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 *     PUT STREAM REPORT "Descuento       :" AT 1 W-CreDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-CreDsc[1] AT 69  FORMAT "->>,>>9.99"    W-CreDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-CreDsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Exonerado       :" AT 1 W-CreExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-CreExo[1] AT 69  FORMAT "->>,>>9.99"    W-CreExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-CreExo[5] AT 116 FORMAT "->>,>>9.99"    W-CreExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Valor de Venta  :" AT 1 W-CreVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-CreVal[1] AT 69  FORMAT "->>,>>9.99"    W-CreVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-CreVal[5] AT 116 FORMAT "->>,>>9.99"    W-CreVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.S.C.          :" AT 1 W-CreIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-CreIsc[1] AT 69  FORMAT "->>,>>9.99"    W-CreIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-CreIsc[5] AT 116 FORMAT "->>,>>9.99"    W-CreIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.G.V.          :" AT 1 W-CreIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-CreIgv[1] AT 69  FORMAT "->>,>>9.99"    W-CreIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-CreIgv[5] AT 116 FORMAT "->>,>>9.99"    W-CreIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Precio de Venta :" AT 1 W-CreVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-CreVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-CreVen[1] AT 69  FORMAT "->>,>>9.99"    W-CreVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-CreVen[5] AT 116 FORMAT "->>,>>9.99"    W-CreVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
 *     PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    D E B I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "Total Bruto     :" AT 1 W-NDBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Total Bruto     :"      W-NDBru[1] AT 69  FORMAT "->>,>>9.99"    W-NDBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
 *                       "Total Bruto     :"      W-NDBru[5] AT 116 FORMAT "->>,>>9.99"    W-NDBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 *     PUT STREAM REPORT "Descuento       :" AT 1 W-NDDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-NDDsc[1] AT 69  FORMAT "->>,>>9.99"    W-NDDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-NDDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NDDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Exonerado       :" AT 1 W-NDExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-NDExo[1] AT 69  FORMAT "->>,>>9.99"    W-NDExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-NDExo[5] AT 116 FORMAT "->>,>>9.99"    W-NDExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NDVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-NDVal[1] AT 69  FORMAT "->>,>>9.99"    W-NDVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-NDVal[5] AT 116 FORMAT "->>,>>9.99"    W-NDVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.S.C.          :" AT 1 W-NDIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-NDIsc[1] AT 69  FORMAT "->>,>>9.99"    W-NDIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-NDIsc[5] AT 116 FORMAT "->>,>>9.99"    W-NDIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.G.V.          :" AT 1 W-NDIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-NDIgv[1] AT 69  FORMAT "->>,>>9.99"    W-NDIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-NDIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NDIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Precio de Venta :" AT 1 W-NDVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NDVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-NDVen[1] AT 69  FORMAT "->>,>>9.99"    W-NDVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-NDVen[5] AT 116 FORMAT "->>,>>9.99"    W-NDVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
 *     PUT STREAM REPORT {&PRN6A} + " T O T A L    N O T A S    D E    C R E D I T O" + {&PRN6B} FORMAT "X(50)" SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "Total Bruto     :" AT 1 W-NCBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Total Bruto     :"      W-NCBru[1] AT 69  FORMAT "->>,>>9.99"    W-NCBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
 *                       "Total Bruto     :"      W-NCBru[5] AT 116 FORMAT "->>,>>9.99"    W-NCBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 *     PUT STREAM REPORT "Descuento       :" AT 1 W-NCDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-NCDsc[1] AT 69  FORMAT "->>,>>9.99"    W-NCDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-NCDsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Exonerado       :" AT 1 W-NCExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-NCExo[1] AT 69  FORMAT "->>,>>9.99"    W-NCExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-NCExo[5] AT 116 FORMAT "->>,>>9.99"    W-NCExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Valor de Venta  :" AT 1 W-NCVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-NCVal[1] AT 69  FORMAT "->>,>>9.99"    W-NCVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-NCVal[5] AT 116 FORMAT "->>,>>9.99"    W-NCVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.S.C.          :" AT 1 W-NCIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-NCIsc[1] AT 69  FORMAT "->>,>>9.99"    W-NCIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-NCIsc[5] AT 116 FORMAT "->>,>>9.99"    W-NCIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.G.V.          :" AT 1 W-NCIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-NCIgv[1] AT 69  FORMAT "->>,>>9.99"    W-NCIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-NCIgv[5] AT 116 FORMAT "->>,>>9.99"    W-NCIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Precio de Venta :" AT 1 W-NCVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-NCVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-NCVen[1] AT 69  FORMAT "->>,>>9.99"    W-NCVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-NCVen[5] AT 116 FORMAT "->>,>>9.99"    W-NCVen[6] AT 128 FORMAT "->>,>>9.99" SKIP(1).
 * 
 *     PUT STREAM REPORT {&PRN6A} + " T O T A L    G E N E R A L" + {&PRN6B} FORMAT "X(50)" SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 *     PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 *     PUT STREAM REPORT "Total Bruto     :" AT 1 W-TotBru[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotBru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Total Bruto     :"      W-TotBru[1] AT 69  FORMAT "->>,>>9.99"    W-TotBru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) 
 *                       "Total Bruto     :"      W-TotBru[5] AT 116 FORMAT "->>,>>9.99"    W-TotBru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 *     PUT STREAM REPORT "Descuento       :" AT 1 W-TotDsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotDsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-TotDsc[1] AT 69  FORMAT "->>,>>9.99"    W-TotDsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Descuento       :"      W-TotDsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotDsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Exonerado       :" AT 1 W-TotExo[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotExo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-TotExo[1] AT 69  FORMAT "->>,>>9.99"    W-TotExo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Exonerado       :"      W-TotExo[5] AT 116 FORMAT "->>,>>9.99"    W-TotExo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Valor de Venta  :" AT 1 W-TotVal[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVal[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-TotVal[1] AT 69  FORMAT "->>,>>9.99"    W-TotVal[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Valor de Venta  :"      W-TotVal[5] AT 116 FORMAT "->>,>>9.99"    W-TotVal[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.S.C.          :" AT 1 W-TotIsc[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-TotIsc[1] AT 69  FORMAT "->>,>>9.99"    W-TotIsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.S.C.          :"      W-TotIsc[5] AT 116 FORMAT "->>,>>9.99"    W-TotIsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "I.G.V.          :" AT 1 W-TotIgv[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotIgv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-TotIgv[1] AT 69  FORMAT "->>,>>9.99"    W-TotIgv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "I.G.V.          :"      W-TotIgv[5] AT 116 FORMAT "->>,>>9.99"    W-TotIgv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *     PUT STREAM REPORT "Precio de Venta :" AT 1 W-TotVen[3] AT 19  FORMAT "->,>>>,>>9.99" W-TotVen[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-TotVen[1] AT 69  FORMAT "->>,>>9.99"    W-TotVen[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) 
 *                       "Precio de Venta :"      W-TotVen[5] AT 116 FORMAT "->>,>>9.99"    W-TotVen[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 *  END.
 * */
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE D-Dialog 
PROCEDURE NEW-PAGE :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PENDIENTE D-Dialog 
PROCEDURE PENDIENTE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR x-titu1  AS CHAR.
  DEFINE VAR x-titu2  AS CHAR.
  DEFINE VAR x-anula  As CHAR.
  DEFINE VAR X-SOL    AS DECIMAL.
  DEFINE VAR X-DOL    AS DECIMAL. 
  DEFINE VAR XX-SOL   AS DECIMAL.
  DEFINE VAR XX-DOL   AS DECIMAL. 
  DEFINE VAR X-RUC    AS CHAR.
  DEFINE VAR X-VEN    AS CHAR.
  DEFINE VAR X        AS INTEGER INIT 1.
  DEFINE VAR X-GLO    AS CHAR FORMAT "X(20)".
  DEFINE VAR X-CODREF AS CHAR.
  DEFINE VAR X-NROREF AS CHAR.
  DEFINE VAR X-FECHA  AS DATE.
  DEFINE VAR X-MOVTO  AS CHAR.
  X-MOVTO = '(pendiente)'.
  DEFINE FRAME f-cab2
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  DEFINE FRAME f-cab
        CCBCDOCU.CodDoc FORMAT "XXX"
        CCBCDOCU.NroDoc FORMAT "XXX-XXXXXX"
        CCBCDOCU.FchDoc 
        CCBCDOCU.Codcli FORMAT "X(10)"
        CCBCDOCU.NomCli FORMAT "X(35)"
        X-MON         FORMAT "X(4)"
        F-ImpTot      
        CCBCDOCU.fmapgo format "x(4)"
        X-GLO         FORMAT "X(16)"
        X-CODREF      FORMAT "XXX"
        X-NROREF      FORMAT "XXX-XXXXXX"
        X-FECHA
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " CONTRA ENTREGA PENDIENTES "  AT 41 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Al : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                                  TOTAL                                         " SKIP
        "DOC  DOCUMENTO  EMISION    CODIGO             C L I E N T E               MON.          IMPORTE                                       " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  FOR EACH CCBCDOCU NO-LOCK WHERE 
           CCBCDOCU.CodCia = S-CODCIA AND
           CCBCDOCU.Flgest = 'P'      AND
           CCBCDOCU.CodDiv = FILL-IN-CodDiv AND
           CCBCDOCU.Fchdoc < F-desde AND
           CCBCDOCU.FmaPgo = '001'  AND 
           LOOKUP(CCBCDOCU.CodDoc,"BOL,FAC") > 0 AND
           CCBCDOCU.Flgest <> "A"
           USE-INDEX LLAVE03
    
            BREAK BY CCBCDOCU.codcia  BY CCBCDOCU.FmaPgo BY (CCBCDOCU.FmaPgo + CCBCDOCU.Coddoc)
             BY CCBCDOCU.Nrodoc:
     
     x-tpocmb = CCBCDOCU.Tpocmb.
     IF R-S-TipImp = 1 THEN  {&NEW-PAGE}.
     F-Impbrt = 0.
     F-Impdto = 0.
     F-Impexo = 0.
     F-Impvta = 0.
     F-Impigv = 0.
     F-Imptot = 0.
     x-anula  = "----- A N U L A D O -------".
     x-mon    = "".
     x-ven    = "".
     x-ruc    = "".
     IF CCBCDOCU.Flgest = 'A' THEN NEXT.
     IF CCBCDOCU.Flgest <> 'A'  THEN DO:
        
        F-Imptot = CCBCDOCU.SdoAct.    /*ImpTot.*/
        x-anula  = CCBCDOCU.Nomcli.
        x-ven    = CCBCDOCU.Codven.
        x-ruc    = CCBCDOCU.Ruccli.
        IF CCBCDOCU.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
       
     END.
     
     IF FIRST-OF(CCBCDOCU.fmapgo) THEN DO:
          ASSIGN  XX-SOL = 0 XX-DOL = 0.     
          x-titu2 = " ".
          FIND gn-convt WHERE gn-convt.codig   = CCBCDOCU.fmapgo NO-LOCK NO-ERROR.
          IF AVAILABLE gn-convt THEN do:
            x-titu2 = TRIM(gn-convt.Nombr) + ' ' + X-MOVTO.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu2 at 3 FORMAT "X(50)" + {&PRN3} + {&PRN6B} .
     END.
     IF FIRST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
          ASSIGN X-SOL = 0 X-DOL = 0.
          x-titu1 = " ".
          FIND facdocum WHERE facdocum.codcia  = CCBCDOCU.codcia and facdocum.coddoc = CCBCDOCU.coddoc NO-LOCK NO-ERROR.
          IF AVAILABLE facdocum THEN do:
            x-titu1 = facdocum.NomDoc.
          end.
          display  STREAM REPORT.
          IF R-S-TipImp = 1 THEN DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          END.
          ELSE DO:
            DOWN(1) STREAM REPORT WITH FRAME F-Cab2.
          END.
          put stream report
          {&PRN2} + {&PRN6A} + x-titu1 at 10 FORMAT "X(35)" + {&PRN3} + {&PRN6B} .
     END.
     X = 1.
     X-GLO    = ' '.
     X-CODREF = ' '.
     X-NROREF = ' '.
     
     
     IF CCBCDOCU.codmon = 1 THEN DO:
       X-SOL  = X-SOL  + ( X * F-IMPTOT ).
       XX-SOL = XX-SOL + ( X * F-IMPTOT ).
       END.
     ELSE DO:
       X-DOL  = X-DOL  + (X * F-IMPTOT ).
       XX-DOL = XX-DOL + (X * F-IMPTOT ).
     END. 

     IF R-S-TipImp = 1 THEN DO:
                 
        DISPLAY STREAM REPORT 
              CCBCDOCU.CodDoc 
              CCBCDOCU.NroDoc 
              CCBCDOCU.FchDoc 
              CCBCDOCU.Codcli
              TRIM(x-anula)  @ CCBCDOCU.NomCli 
              X-MON           
              F-ImpTot         WHEN F-ImpTot <> 0
              CCBCDOCU.Fmapgo
              X-GLO 
              X-CODREF 
              X-NROREF 
              X-FECHA          WHEN CCBCDOCU.Coddoc = 'N/C'
              WITH FRAME F-Cab.
              
        IF LAST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'   AT 20 FORMAT "X(20)" " S/." AT 50 X-SOL AT 55  {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 X-DOL AT 55  {&PRN3} + {&PRN6B}.
        END.
        IF LAST-OF(CCBCDOCU.Fmapgo) THEN DO:
          display  STREAM REPORT.
          DOWN(1) STREAM REPORT WITH FRAME F-Cab.
          PUT STREAM REPORT 
          {&PRN2} + {&PRN6A} + 'TOTALES      :'   AT 20 FORMAT "X(20)" " S/." AT 50 XX-SOL AT 55 {&PRN3} + {&PRN6B} SKIP.
          PUT STREAM REPORT   
          {&PRN2} + {&PRN6A} + '              '   AT 20 FORMAT "X(20)" "US$." AT 50 XX-DOL AT 55 {&PRN3} + {&PRN6B} SKIP(5). 
        END.
     END.
     IF R-S-TipImp = 2 THEN DO:
          IF LAST-OF(CCBCDOCU.Fmapgo + CCBCDOCU.Coddoc) THEN DO:
            display  STREAM REPORT.
            PUT STREAM REPORT  X-SOL AT 80 X-DOL AT 110 .
          END.
     END.
 
 END.
 
 IF  R-S-TipImp = 2 THEN DO:
  display  STREAM REPORT.
  DOWN(4) STREAM REPORT .
  PUT STREAM REPORT skip(5).
  PUT STREAM REPORT
  'Bajo la presente constancia declaro en honor a la verdad que lo aqui detallado corresponde al total de pagos' SKIP.
  PUT STREAM REPORT
  'por los cuales debo emitir recibos, segun procedimiento de FNP, que declaro conocer. ' SKIP(3).
  PUT STREAM REPORT
  '_______________________________'   AT 10 '_______________________________' AT 90  SKIP.
  PUT STREAM REPORT   
  ' Cajera(o)                     '   AT 10 'Administrador                  ' AT 90 . 


 END.

 IF  R-S-TipImp = 1 THEN RUN ANULADOS.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reciboresu D-Dialog 
PROCEDURE reciboresu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR T-MOVTO   AS CHAR .
 DEFINE VAR T-EFESOL AS DECIMAL.
 DEFINE VAR T-EFEDOL AS DECIMAL.
 DEFINE VAR T-CHDSOL AS DECIMAL.
 DEFINE VAR T-CHDDOL AS DECIMAL.
 DEFINE VAR T-CHFSOL AS DECIMAL.
 DEFINE VAR T-CHFDOL AS DECIMAL.
 DEFINE VAR T-NCRSOL AS DECIMAL.
 DEFINE VAR T-NCRDOL AS DECIMAL.
 DEFINE VAR T-DEPSOL AS DECIMAL.
 DEFINE VAR T-DEPDOL AS DECIMAL.
 DEFINE VAR X-MOVTO  AS CHAR.
 X-MOVTO = '(emitido)'.
 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

        
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + 'TOTAL EFECTIVO (declarado)'   AT 3 FORMAT "X(35)" +  {&PRN6B} + {&PRN3}.  
         PUT STREAM REPORT FILL-IN-efesol AT 80  FILL-IN-efedol AT 107.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + 'TOTAL REMESAS (declarado)'   AT 3 FORMAT "X(35)" +  {&PRN6B} + {&PRN3} .  
         PUT STREAM REPORT FILL-IN-remesol AT 80 FILL-IN-remedol AT 110.

        
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          ( CCbcCaja.tipo    = 'CFAC' OR CcbCcAja.Tipo = 'CANCELACION' )  AND
          CCbcCaja.Flgest  <> 'A' AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo   
                BY CcbDcaja.NroDoc
                BY CcbDcaja.Nroref:
           
      
     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        T-EFESOL = 0.
        T-EFEDOL = 0.
        T-CHDSOL = 0.
        T-CHDDOL = 0.
        T-CHFSOL = 0.
        T-CHFDOL = 0.
        T-NCRSOL = 0.
        T-NCRDOL = 0.
        T-DEPSOL = 0.
        T-DEPDOL = 0.
        T-MOVTO  = " ".
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CANCELACION" OR CcbcCaja.Tipo = "CFAC" THEN T-MOVTO = "RECIBOS" + ' ' + X-MOVTO.
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO  AT 3 FORMAT "X(35)" + {&PRN6B} + {&PRN3}.  
     END.     
     IF CcbDCaja.CodMon = 1 THEN DO:
        x-mon       = 'S/.'.
        G-EFESOL    = G-EFESOL + CcbDCaja.Imptot.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        x-mon       = 'US$.'.
        G-EFEDOL    = G-EFEDOL + CcbDCaja.Imptot.
     END.   
     IF CcbCcaja.Flgest <> "A"  THEN DO:
        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[6].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[6].
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].
        
     END.
                
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
/*        G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT G-EFESOL AT 80 G-EFEDOL AT 110.
     END.
 END. 
 RUN CHEQUERESU. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RECIBOS D-Dialog 
PROCEDURE RECIBOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR G-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-CHDSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-CHDDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-CHFDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRSOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.
 DEFINE VAR G-NCRDOL AS DECIMAL FORMAT "->>>,>>9.99"  INIT 0.  
 DEFINE VAR G-DEPSOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 DEFINE VAR G-DEPDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
 
 DEFINE VAR D-IMPORT AS DECIMAL FORMAT "->>>,>>9.99" INIT 0 EXTENT 2.
 DEFINE VAR T-MOVTO   AS CHAR .
 DEFINE VAR T-EFESOL AS DECIMAL.
 DEFINE VAR T-EFEDOL AS DECIMAL.
 DEFINE VAR T-CHDSOL AS DECIMAL.
 DEFINE VAR T-CHDDOL AS DECIMAL.
 DEFINE VAR T-CHFSOL AS DECIMAL.
 DEFINE VAR T-CHFDOL AS DECIMAL.
 DEFINE VAR T-NCRSOL AS DECIMAL.
 DEFINE VAR T-NCRDOL AS DECIMAL.
 DEFINE VAR T-DEPSOL AS DECIMAL.
 DEFINE VAR T-DEPDOL AS DECIMAL.


 
 DEFINE VAR X-FMAPGO AS CHAR FORMAT "X(5)".
 DEFINE VAR X-FECHA  AS DATE.


 DEFINE FRAME f-cab4
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 DEFINE FRAME f-cab8
        CcbcCaja.Coddoc
        CcbcCaja.Nrodoc
        CcbcCaja.Tipo
        CcbcCaja.Fchdoc
        CcbcCaja.Codcli
        CcbcCaja.Nomcli
        CcbdCaja.Codref
        CcbdCaja.Nroref
        CcbdCaja.Fchdoc
        X-FMAPGO
        x-mon
        CcbdCaja.Imptot
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + S-CODDIV + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " RELACION DE RECIBOS EMITIDOS "  AT 45 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Del : " AT 55 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Caja : " AT 1 FORMAT "X(10)"  {&PRN6A} + S-USER-ID AT 12 FORMAT "X(15)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(10)" STRING(TIME,"HH:MM:SS") SKIP 

        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                                      " SKIP
        "          C O N C E P T O S                                                                                                           " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

      
        
 FOR EACH CcbCcaja WHERE 
          CcbcCaja.CodCia  = S-CODCIA AND 
          CcbcCaja.CodDiv  = S-CODDIV AND 
          CcbcCaja.CodDoc  = "I/C"    AND
          CcbcCaja.FchDoc  = F-desde  AND 
          ( CCbcCaja.tipo    = 'CFAC' OR CcbCcAja.Tipo = 'CANCELACION' )  AND
          CCbcCaja.Flgest  <> 'A' AND
/*        CcbCCaja.CodCaja = S-CODTER AND */
          CcbCCaja.usuario = S-USER-ID       NO-LOCK USE-INDEX LLAVE07,
          EACH CcbDCaja OF CcbCcaja 
          BREAK BY CcbcCaja.CodCia 
                BY CcbCcaja.Tipo   
                BY CcbDcaja.NroDoc
                BY CcbDcaja.Nroref:
           
          
      
     IF FIRST-OF(CcbcCaja.Tipo) THEN DO:
        T-EFESOL = 0.
        T-EFEDOL = 0.
        T-CHDSOL = 0.
        T-CHDDOL = 0.
        T-CHFSOL = 0.
        T-CHFDOL = 0.
        T-NCRSOL = 0.
        T-NCRDOL = 0.
        T-DEPSOL = 0.
        T-DEPDOL = 0.
        T-MOVTO  = " ".
        IF CcbcCaja.Tipo = "CAFA" THEN T-MOVTO = "CANCELACION DE FACTURAS".
        IF CcbcCaja.Tipo = "CABO" THEN T-MOVTO = "CANCELACION DE BOLETAS".
        IF CcbcCaja.Tipo = "CANCELACION" OR CcbcCaja.Tipo = "CFAC" THEN T-MOVTO = "RECIBOS".
        IF  R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS' THEN DO:
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB8.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(35)".  
        END.
        IF  R-S-TipImp = 2 THEN DO:
         DISPLAY STREAM REPORT.
         DOWN(1) STREAM REPORT WITH FRAME F-CAB4.
         PUT STREAM REPORT {&PRN2} + {&PRN6A} + T-MOVTO +  {&PRN6B} + {&PRN3} AT 3 FORMAT "X(35)".  
        END.
     END.     
            
              
     IF CcbDCaja.CodMon = 1 THEN DO:
        x-mon       = 'S/.'.
        G-EFESOL    = G-EFESOL + CcbDCaja.Imptot.
     END.   
     IF CcbDCaja.CodMon = 2 THEN DO:
        x-mon       = 'US$.'.
        G-EFEDOL    = G-EFEDOL + CcbDCaja.Imptot.
     END.   
     X-FMAPGO = ' '.        
     FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = CcbcCaja.Codcia AND 
                         CCBCDOCU.CODDOC = CcbDCaja.CodRef AND
                         CCBCDOCU.NRODOC = ccbDCaja.NroRef NO-LOCK USE-INDEX LLAVE01.
     IF AVAILABLE CCBCDOCU THEN DO:
      X-FMAPGO = CCBCDOCU.FMAPGO. 
      X-FECHA  = CCBCDOCU.FCHDOC.
     END.
     ELSE X-FMAPGO = 'S/N'.
             
     IF CcbCcaja.Flgest <> "A"  THEN DO:
             
        T-EFESOL = T-EFESOL + ( CcbcCaja.ImpNac[1] - CcbCCaja.VueNac ).
        T-EFEDOL = T-EFEDOL + ( CcbcCaja.ImpUsa[1] - CcbCCaja.VueUsa ).
        T-CHDSOL = T-CHDSOL + CcbcCaja.ImpNac[2].
        T-CHDDOL = T-CHDDOL + CcbcCaja.ImpUsa[2].
        T-CHFSOL = T-CHFSOL + CcbcCaja.ImpNac[3].
        T-CHFDOL = T-CHFDOL + CcbcCaja.ImpUsa[3].
        T-NCRSOL = T-NCRSOL + CcbcCaja.ImpNac[6].
        T-NCRDOL = T-NCRDOL + CcbcCaja.ImpUsa[6].
        T-DEPSOL = T-DEPSOL + CcbcCaja.ImpNac[5].
        T-DEPDOL = T-DEPDOL + CcbcCaja.ImpUsa[5].
  
        IF R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS' THEN DO: 
          DISPLAY STREAM REPORT
          CcbcCaja.Coddoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Nrodoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Tipo   WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Fchdoc WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Codcli WHEN FIRST-OF(CcbdCaja.NroDoc)
          CcbcCaja.Nomcli WHEN FIRST-OF(CcbdCaja.NroDoc)
          CCbdCaja.Codref
          CcbdCaja.Nroref
          x-fecha @ CcbdCaja.Fchdoc
          x-fmapgo
          x-mon
          CcbdCaja.Imptot
          WITH FRAME f-cab8.
        END.  
          
       END.
    

                 
     IF LAST-OF(CcbcCaja.Tipo) THEN DO:
       IF  R-S-TipImp = 2  THEN DO:
/*        G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT G-EFESOL AT 80 G-EFEDOL AT 110.
       END.   
       IF  R-S-TipImp = 1 AND T-MOVTO = 'RECIBOS'  THEN DO:
        /*G-EFESOL =  T-EFESOL + T-CHDSOL + T-CHFSOL + T-NCRSOL + T-DEPSOL.
 *         G-EFEDOL =  T-EFEDOL + T-CHDDOL + T-CHFDOL + T-NCRDOL + T-DEPDOL.*/
        DISPLAY STREAM REPORT.
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} + 'SUBTOTALES   :'  AT 20 FORMAT "X(20)" " S/." AT 50 G-EFESOL AT 55  {&PRN3} + {&PRN6B} SKIP.
        PUT STREAM REPORT   
        {&PRN2} + {&PRN6A} + '              '  AT 20 FORMAT "X(20)" "US$." AT 50 G-EFEDOL AT 55  {&PRN3} + {&PRN6B} SKIP(10).
       
       END.
     END.
                
 END. 
 
RUN CHEQUES. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar D-Dialog 
PROCEDURE remvar :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


