&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
/*
    @PRINTER2.W    VERSION 1.0
*/

{lib/def-prn.i}    
DEFINE STREAM REPORT.

/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE SHARED VARIABLE cb-codcia AS INTEGER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE        VARIABLE L-FIN      AS LOGICAL.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/*** DEFINE VARIABLES SUB-TOTALES ***/

DEFINE VAR C-DESMOV      AS CHAR NO-UNDO.
DEFINE VAR C-OP          AS CHAR NO-UNDO.
DEFINE VAR X-PROCEDENCIA AS CHAR NO-UNDO.
DEFINE VAR x-codmov      AS CHAR NO-UNDO.
DEFINE VAR X-CODPRO      AS CHAR NO-UNDO.

DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
DEFINE VAR x-titulo2 AS CHAR NO-UNDO.

/*DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.*/
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR F-DESDE AS DATE NO-UNDO.
DEFINE VAR F-HASTA AS DATE NO-UNDO.

DEFINE TEMP-TABLE T-MOVI 
   FIELD codcia LIKE Almtmovm.CodCia 
   FIELD codmat LIKE Almdmov.codmat
   FIELD codund LIKE Almdmov.codund
   FIELD codpro LIKE Almcmov.codpro
   FIELD nrorf1 LIKE Almcmov.nrorf1
   FIELD Ipieza LIKE Almdmov.Candes
   FIELD Ikilos LIKE Almdmov.Candes
   FIELD Cpieza LIKE Almdmov.Candes
   FIELD Ckilos LIKE Almdmov.Candes
   FIELD Tpieza LIKE Almdmov.Candes
   FIELD Vpieza LIKE Almdmov.Candes
   FIELD Vkilos LIKE Almdmov.Candes
   FIELD Spieza LIKE Almdmov.Candes
   FIELD Skilos LIKE Almdmov.Candes
   FIELD Precio LIKE Almdmov.preuni.

DEFINE TEMP-TABLE T-VENTA
   FIELD codmat LIKE Almdmov.codmat
   FIELD Saldo  LIKE Almdmov.Candes
   FIELD Stock  LIKE Almdmov.Candes
   FIELD Venta  LIKE Almdmov.Candes.

DEFINE TEMP-TABLE T-DETALLE
   FIELD codcia LIKE Almdmov.codcia
   FIELD codpro LIKE Almcmov.codpro
   FIELD nrorf1 LIKE Almcmov.nrorf1
   FIELD codmat LIKE Almdmov.codmat
   FIELD codund LIKE Almdmov.codund
   FIELD coddoc LIKE CcbCDocu.coddoc
   FIELD nrodoc LIKE CcbCDocu.nrodoc
   FIELD fchdoc LIKE Almdmov.fchdoc
   FIELD candes LIKE Almdmov.candes
   FIELD cansal LIKE Almdmov.candes
   FIELD implin LIKE Almdmov.implin.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-Mes F-Periodo F-Codfam1 F-Codfam2 F-Codmat ~
R-Codmon R-Presenta RADIO-SET-1 B-impresoras Btn_OK RB-NUMBER-COPIES ~
Btn_Cancel RB-BEGIN-PAGE Btn_Help RB-END-PAGE RECT-49 RECT-5 RECT-50 ~
RECT-57 RECT-58 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 F-Mes F-Periodo F-Codfam1 ~
F-Codfam2 F-Codmat R-Codmon R-Presenta RADIO-SET-1 RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

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
     SIZE 5 BY 1.12.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.08.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6.29 BY 1 NO-UNDO.

DEFINE VARIABLE F-Codfam1 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-Codfam2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-Codmat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .69
     FONT 6 NO-UNDO.

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

DEFINE VARIABLE R-Codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 18.29 BY .77 NO-UNDO.

DEFINE VARIABLE R-Presenta AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", "R",
"Detallado", "D"
     SIZE 9.72 BY 1.46 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 2.73
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 62.57 BY 5.19.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.14 BY 5.77.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.57 BY 1.19.

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35.86 BY 1.31.

DEFINE RECTANGLE RECT-58
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 19.14 BY 1.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-3 AT ROW 1.88 COL 3.28
     F-Mes AT ROW 1.88 COL 19.71
     F-Periodo AT ROW 1.88 COL 35.43 COLON-ALIGNED
     F-Codfam1 AT ROW 4.85 COL 11 COLON-ALIGNED
     F-Codfam2 AT ROW 4.85 COL 26.29 COLON-ALIGNED
     F-Codmat AT ROW 4.85 COL 47.29 COLON-ALIGNED
     R-Codmon AT ROW 3.08 COL 27.43 NO-LABEL
     R-Presenta AT ROW 2.04 COL 50.86 NO-LABEL
     RADIO-SET-1 AT ROW 7.42 COL 3.43 NO-LABEL
     B-impresoras AT ROW 8.19 COL 16.57
     b-archivo AT ROW 9.31 COL 16.57
     RB-OUTPUT-FILE AT ROW 9.15 COL 20.43 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 6.35 COL 51.29
     RB-NUMBER-COPIES AT ROW 10.77 COL 11.14 COLON-ALIGNED
     Btn_Cancel AT ROW 8.46 COL 51.43
     RB-BEGIN-PAGE AT ROW 10.77 COL 25.86 COLON-ALIGNED
     Btn_Help AT ROW 10.27 COL 51.43
     RB-END-PAGE AT ROW 10.77 COL 40 COLON-ALIGNED
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 6.5 COL 2
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Paginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 10.12 COL 34.57
          FONT 6
     "Moneda :" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.19 COL 16.72
          FONT 6
     " Familia" VIEW-AS TEXT
          SIZE 7.14 BY .5 AT ROW 4.31 COL 6.43
          FONT 6
     " Producto" VIEW-AS TEXT
          SIZE 9.14 BY .5 AT ROW 4.31 COL 43.29
          FONT 6
     RECT-49 AT ROW 1.04 COL 1
     RECT-5 AT ROW 6.27 COL 1.57
     RECT-50 AT ROW 2.81 COL 26.29
     RECT-57 AT ROW 4.5 COL 4.43
     RECT-58 AT ROW 4.46 COL 41.57
     SPACE(3.14) SKIP(6.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Productos en Consignacion".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR COMBO-BOX F-Mes IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Productos en Consignacion */
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


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancelar */
DO:
  L-FIN = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN F-Mes R-Codmon F-Periodo R-Presenta F-Codfam1 F-Codfam2 F-Codmat.

  F-Desde = DATE(F-Mes,01,F-Periodo).
  F-Hasta = IF F-Mes = 12 THEN DATE(F-MES,31,F-Periodo) ELSE DATE(F-Mes + 1, 01, F-Periodo) - 1.
  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
  P-device  = "PRN".
  
  IF F-Codfam2 = '' THEN F-Codfam2 = 'ZZZ'.
     
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

ASSIGN F-MES = MONTH(TODAY)
       F-Periodo = YEAR(TODAY)
       FILL-IN-3 = S-CODALM
       FRAME {&FRAME-NAME}:TITLE  = "[ Productos en Consignacion ]".

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
  RETURN.
END.


RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Dato-Mes D-Dialog 
PROCEDURE Carga-Dato-Mes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-tipmov AS CHAR.
DEFINE INPUT PARAMETER x-codmov AS INTEGER.
DEFINE INPUT PARAMETER x-factor AS INTEGER.

FOR EACH Almcmov NO-LOCK WHERE 
         Almcmov.codcia = s-codcia AND 
         Almcmov.codalm = s-codalm AND 
         Almcmov.Tipmov = x-tipmov AND
         Almcmov.codmov = x-codmov AND 
         Almcmov.Fchdoc >= F-Desde AND
         Almcmov.Fchdoc <= F-Hasta,
         EACH Almdmov OF Almcmov NO-LOCK:
         
    DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + 
            STRING(Almdmov.nrodoc, '999999') @ Fi-Mensaje LABEL " Movimiento "
            FORMAT "X(11)" WITH FRAME F-Proceso.
            
    FIND T-MOVI WHERE 
         T-MOVI.codcia = s-codcia AND
         T-MOVI.Codmat = Almdmov.codmat AND
         T-MOVI.Codpro = Almcmov.codpro AND
         T-MOVI.nrorf1 = Almcmov.nrorf1 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MOVI THEN DO:
       CREATE T-MOVI.
       ASSIGN T-MOVI.Codcia = s-codcia
              T-MOVI.Codmat = Almdmov.codmat
              T-MOVI.Codpro = Almcmov.codpro
              T-MOVI.nrorf1 = Almcmov.nrorf1.
    END.
    ASSIGN
       T-MOVI.Cpieza = T-MOVI.Cpieza + (Almdmov.candes * Almdmov.factor * x-factor)
       T-MOVI.Tpieza = T-MOVI.Tpieza + (Almdmov.candes * Almdmov.factor * x-factor).
       
    FIND T-VENTA WHERE T-VENTA.codmat = Almdmov.codmat NO-ERROR.
    IF NOT AVAILABLE T-VENTA THEN DO:
       CREATE T-VENTA.
       ASSIGN
          T-VENTA.Codmat = Almdmov.codmat.
    END.
    ASSIGN
       T-VENTA.Saldo = T-VENTA.Saldo + (Almdmov.candes * Almdmov.factor * x-factor).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-DatosCmp D-Dialog 
PROCEDURE Carga-DatosCmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-tipmov AS CHAR.
DEFINE INPUT PARAMETER x-codmov AS INTEGER.
DEFINE INPUT PARAMETER x-factor AS INTEGER.

FOR EACH Almcmov NO-LOCK WHERE 
         Almcmov.codcia = s-codcia AND 
         Almcmov.codalm = s-codalm AND 
         Almcmov.Tipmov = x-tipmov AND
         Almcmov.codmov = x-codmov AND 
         Almcmov.Fchdoc >= F-Desde AND
         Almcmov.fchdoc <= F-Hasta,
         EACH Almdmov OF Almcmov NO-LOCK WHERE 
              Almdmov.codmat BEGINS F-Codmat ,
         FIRST Almmmatg OF Almdmov NO-LOCK WHERE 
               Almmmatg.codfam >= F-Codfam1 AND
               Almmmatg.codfam <= F-Codfam2 :
               
    DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + 
            STRING(Almdmov.nrodoc, '999999') @ Fi-Mensaje LABEL " Movimiento "
            FORMAT "X(11)" WITH FRAME F-Proceso.
    /*        
    FIND T-MOVI WHERE 
         T-MOVI.codcia = s-codcia AND
         T-MOVI.Codmat = Almdmov.codmat AND
         T-MOVI.Codpro = Almcmov.codpro AND
         T-MOVI.nrorf1 = Almcmov.nrorf1 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MOVI THEN DO:
       CREATE T-MOVI.
       ASSIGN T-MOVI.Codcia = s-codcia
              T-MOVI.Codmat = Almdmov.codmat
              T-MOVI.Codpro = Almcmov.codpro.
              T-MOVI.nrorf1 = Almcmov.nrorf1.
    END.
    ASSIGN T-MOVI.Cpieza = T-MOVI.Cpieza + (Almdmov.candes * Almdmov.factor * x-factor).
           T-MOVI.Tpieza = T-MOVI.Tpieza + (Almdmov.candes * Almdmov.factor * x-factor).
    */
    FIND T-VENTA WHERE T-VENTA.codmat = Almdmov.codmat NO-ERROR.
    /*
    IF NOT AVAILABLE T-VENTA THEN DO:
       CREATE T-VENTA.
       ASSIGN
          T-VENTA.Codmat = Almdmov.codmat.
    END.
    */
    IF AVAILABLE T-VENTA THEN DO:
       ASSIGN  T-VENTA.Stock = T-VENTA.Stock + (Almdmov.candes * Almdmov.factor * x-factor).
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-DatosCsg D-Dialog 
PROCEDURE Carga-DatosCsg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-tipmov AS CHAR.
DEFINE INPUT PARAMETER x-codmov AS INTEGER.
DEFINE INPUT PARAMETER x-factor AS INTEGER.

FOR EACH Almcmov NO-LOCK WHERE 
         Almcmov.codcia = s-codcia AND 
         Almcmov.codalm = s-codalm AND 
         Almcmov.Tipmov = x-tipmov AND
         Almcmov.codmov = x-codmov AND 
         Almcmov.Fchdoc >= F-Desde AND
         Almcmov.fchdoc <= F-Hasta,
         EACH Almdmov OF Almcmov NO-LOCK WHERE 
              Almdmov.codmat BEGINS F-Codmat ,
         FIRST Almmmatg OF Almdmov NO-LOCK WHERE 
               Almmmatg.codfam >= F-Codfam1 AND
               Almmmatg.codfam <= F-Codfam2 :
               
    DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + 
            STRING(Almdmov.nrodoc, '999999') @ Fi-Mensaje LABEL " Movimiento "
            FORMAT "X(11)" WITH FRAME F-Proceso.
            
    FIND T-MOVI WHERE 
         T-MOVI.codcia = s-codcia AND
         T-MOVI.Codmat = Almdmov.codmat AND
         T-MOVI.Codpro = Almcmov.codpro AND
         T-MOVI.nrorf1 = Almcmov.nrorf1 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MOVI THEN DO:
       CREATE T-MOVI.
       ASSIGN T-MOVI.Codcia = s-codcia
              T-MOVI.Codmat = Almdmov.codmat
              T-MOVI.CodUnd = Almmmatg.UndStk
              T-MOVI.Codpro = Almcmov.codpro.
              T-MOVI.nrorf1 = Almcmov.nrorf1.
    END.
    ASSIGN T-MOVI.Cpieza = T-MOVI.Cpieza + (Almdmov.candes * Almdmov.factor * x-factor).
           T-MOVI.Tpieza = T-MOVI.Tpieza + (Almdmov.candes * Almdmov.factor * x-factor).
    FIND T-VENTA WHERE T-VENTA.codmat = Almdmov.codmat NO-ERROR.
    IF NOT AVAILABLE T-VENTA THEN DO:
       CREATE T-VENTA.
       ASSIGN
          T-VENTA.Codmat = Almdmov.codmat.
    END.
    ASSIGN
       T-VENTA.Saldo = T-VENTA.Saldo + (Almdmov.candes * Almdmov.factor * x-factor).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/***     S A L D O    A N T E R I O R      ***/
/* CARGAMOS LOS INGRESOS POR CONSIGNACION */
RUN Carga-DatosCsg('I',90,1).
/* DESCARGAMOS LA DEVOLUCION DE CONSIGNACION */
RUN Carga-DatosCsg('S',75,-1).

/* CARGAMOS LOS INGRESOS POR COMPRA DEL MES */ 
FOR EACH Almtmovm WHERE 
         Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.Tipmov = 'I'      AND 
         Almtmovm.MovCmp NO-LOCK:
    RUN Carga-DatosCmp('I',Almtmovm.CodMov,1).
END.
/* DESCARGAM0S LAS DEVOLUCIONES POR COMPRA */ 
FOR EACH Almtmovm WHERE 
         Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.Tipmov = 'S'      AND 
         Almtmovm.MovCmp NO-LOCK:
    RUN Carga-DatosCmp('S',Almtmovm.CodMov,-1).
END.


/***          V E N T A S    D E L    M E S          ***/
/*** por cada documento, si es que tienen # codigos de movimiento ***/

FIND FacDocum WHERE 
     FacDocum.codcia = s-codcia AND
     FacDocum.coddoc = 'G/R' NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN DO:
   RUN Carga-Ventas('S',FacDocum.codmov,1).
END.
/*
FIND FacDocum WHERE 
     FacDocum.codcia = s-codcia AND
     FacDocum.coddoc = 'FAC' NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN DO:
   RUN Carga-Ventas('S',FacDocum.codmov,1).
END.
*/
/*
FIND FacDocum WHERE 
     FacDocum.codcia = s-codcia AND
     FacDocum.coddoc = 'BOL' NO-LOCK NO-ERROR.
IF AVAILABLE FacDocum THEN DO:
   RUN Carga-Ventas('S',FacDocum.codmov,1).
END. 
*/
/*
FOR EACH Almtmovm WHERE 
         Almtmovm.CodCia = s-codcia AND
         Almtmovm.Tipmov = 'S'      AND 
         Almtmovm.PidODT NO-LOCK:
    RUN Carga-Ventas('S',Almtmovm.codmov,1).
END.
*/
/*  POR CAMBIO DE CODIGO */
/*
RUN Carga-Ventas('S',78,1).
*/

/***  DISTRUBUYO LAS VENTAS DEL MES ENTRE LAS CONSIGNACIONES  ***/
FOR EACH T-VENTA :
    IF T-VENTA.Venta = 0 THEN NEXT.
    FIND LAST Almdmov WHERE 
              Almdmov.codcia = s-codcia AND
              Almdmov.codmat = T-VENTA.Codmat AND 
              Almdmov.Fchdoc < F-Desde NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN ASSIGN T-VENTA.Stock = T-VENTA.Stock + Almdmov.Stksub.
    ASSIGN T-VENTA.Stock = T-VENTA.Stock + T-VENTA.Saldo - T-VENTA.Venta.
    IF T-VENTA.Stock >= T-VENTA.Saldo THEN 
       ASSIGN T-VENTA.Venta = 0.
    ELSE
       ASSIGN T-VENTA.Venta = T-VENTA.Saldo - T-VENTA.Stock.
END. 

FOR EACH T-MOVI 
         BREAK BY T-MOVI.codcia 
               BY T-MOVI.Codmat:
    FIND T-VENTA WHERE T-VENTA.Codmat = T-MOVI.Codmat NO-ERROR.
    IF T-VENTA.Venta > T-MOVI.Tpieza THEN
       ASSIGN T-MOVI.Vpieza = T-MOVI.Tpieza.
    ELSE
       ASSIGN T-MOVI.Vpieza = T-VENTA.Venta.
    ASSIGN
       T-VENTA.Venta = T-VENTA.Venta  - T-MOVI.Vpieza.
END.

HIDE FRAME F-Proceso.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas D-Dialog 
PROCEDURE Carga-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER x-tipmov AS CHAR.
DEFINE INPUT PARAMETER x-codmov AS INTEGER.
DEFINE INPUT PARAMETER x-factor AS INTEGER.

FOR EACH Almdmov NO-LOCK WHERE 
         Almdmov.codcia = s-codcia AND 
         Almdmov.codalm = s-codalm AND 
         Almdmov.Tipmov = x-tipmov AND
         Almdmov.codmov = x-codmov AND 
         Almdmov.Fchdoc >= F-Desde AND
         Almdmov.Fchdoc <= F-Hasta AND 
         Almdmov.codmat BEGINS F-Codmat,
         FIRST Almmmatg OF Almdmov NO-LOCK WHERE 
               Almmmatg.codfam >= F-Codfam1 AND
               Almmmatg.codfam <= F-Codfam2 :
                
    DISPLAY Almdmov.Tipmov + STRING(Almdmov.codmov, '99') + '-' + STRING(Almdmov.nrodoc, '999999') @ Fi-Mensaje LABEL " Movimiento "
         FORMAT "X(11)" WITH FRAME F-Proceso.

    FIND FIRST T-VENTA WHERE T-VENTA.Codmat = Almdmov.codmat NO-ERROR.
    IF NOT AVAILABLE T-VENTA THEN DO:
       CREATE T-VENTA.
       ASSIGN T-VENTA.Codmat = Almdmov.codmat.
    END.
    ASSIGN
       T-VENTA.Venta = T-VENTA.Venta + (Almdmov.candes * Almdmov.factor).
    CREATE T-DETALLE.
    ASSIGN
       T-DETALLE.Codcia = s-codcia 
       T-DETALLE.codmat = Almdmov.codmat
       T-DETALLE.CodUnd = Almmmatg.UndStk
       T-DETALLE.coddoc = STRING(Almdmov.codmov,'99')
       T-DETALLE.nrodoc = STRING(Almdmov.nroser,'99') + STRING(Almdmov.nrodoc,'999999')
       T-DETALLE.fchdoc = Almdmov.fchdoc
       T-DETALLE.candes = Almdmov.candes * Almdmov.factor
       T-DETALLE.cansal = Almdmov.candes * Almdmov.factor
       T-DETALLE.implin = ROUND(Almdmov.implin / T-DETALLE.candes, 2).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-3 F-Mes F-Periodo F-Codfam1 F-Codfam2 F-Codmat R-Codmon 
          R-Presenta RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE F-Mes F-Periodo F-Codfam1 F-Codfam2 F-Codmat R-Codmon R-Presenta 
         RADIO-SET-1 B-impresoras Btn_OK RB-NUMBER-COPIES Btn_Cancel 
         RB-BEGIN-PAGE Btn_Help RB-END-PAGE RECT-49 RECT-5 RECT-50 RECT-57 
         RECT-58 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Detalle D-Dialog 
PROCEDURE Formato-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo3 AS CHAR NO-UNDO.
  DEFINE VAR x-candes  AS DECIMAL NO-UNDO.
  DEFINE VAR x-cansal  AS DECIMAL NO-UNDO.
  DEFINE VAR x-totpes  AS DECIMAL NO-UNDO.
  DEFINE VAR x-totcan  AS DECIMAL NO-UNDO.

  x-titulo1 = 'LIQUIDACION DE CONSIGNACION - DETALLE'.
  x-titulo2 = ENTRY(F-Mes,'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE').
  x-titulo2 = TRIM(x-titulo2) + '-' + STRING(F-Periodo, '9999').
  x-titulo3 = 'Expresado en ' + (IF R-Codmon = 1 THEN 'Nuevos Soles' ELSE 'Dolares Americanos').
  
  DEFINE FRAME F-REP
         T-DETALLE.codmat
         Almmmatg.desmat  FORMAT 'X(40)'
         Almmmatg.UndStk  FORMAT 'X(4)'
         T-DETALLE.coddoc 
         T-DETALLE.nrodoc
         T-DETALLE.fchdoc FORMAT "99/99/9999"
         x-CanDes         FORMAT "->,>>>,>>9.99"
         T-DETALLE.Implin FORMAT "->,>>>,>>9.99"
         WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
         
  DEFINE FRAME H-REP
     HEADER
         {&PRN2} + {&Prn7a} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
         {&PRN2} + {&PRN6A} + "( " + S-CODALM + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
         {&PRN6A} + x-titulo1 AT 37 FORMAT "X(40)"
         {&PRN3} + {&PRN6B} + "Pag.  : " AT 87 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN2} + {&PRN6A} + x-titulo2 AT 57 FORMAT "X(40)" 
         {&PRN3} + "Fecha : " AT 87 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
         x-titulo3 + {&PRN6B} + {&PRN3}  FORMAT "X(40)"  SKIP
         "-------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                                   Precio    " SKIP
         "Codigo Descripcion                              UND  Cod Numero      Fecha         Cantidad         Venta    " SKIP
         "-------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH T-DETALLE:
      ASSIGN T-DETALLE.cansal = T-DETALLE.Candes.
  END.
  FOR EACH T-MOVI WHERE T-MOVI.Vpieza > 0,
           FIRST Almmmatg WHERE 
                 Almmmatg.codcia = s-codcia AND 
                 Almmmatg.codmat = T-MOVI.codmat
           BREAK BY T-MOVI.Codcia 
                 BY T-MOVI.Codpro 
                 BY T-MOVI.nrorf1 
                 BY T-MOVI.Codmat:
      {&new-page}.        
      VIEW STREAM REPORT FRAME H-REP.
      IF FIRST-OF(T-MOVI.Codpro) OR FIRST-OF(T-MOVI.nrorf1) THEN DO:
         FIND gn-prov WHERE 
              gn-prov.CodCia = pv-codcia AND
              gn-prov.CodPro = T-MOVI.Codpro NO-LOCK NO-ERROR.
         IF AVAILABLE gn-prov THEN 
            DISPLAY STREAM REPORT 
               'G.' + TRIM(T-MOVI.nrorf1) + ' ' + gn-prov.NomPro @ Almmmatg.desmat WITH FRAME F-REP.
         UNDERLINE STREAM REPORT Almmmatg.desmat WITH FRAME F-REP.
      END.
      x-candes = 0.
      x-cansal = T-MOVI.Vpieza.
      DO WHILE x-cansal > 0 :
         FIND FIRST T-Detalle WHERE 
                    T-Detalle.codmat = T-MOVI.Codmat AND
                    T-Detalle.Cansal > 0 NO-ERROR.
         IF AVAILABLE T-Detalle THEN DO:
            x-candes = T-Detalle.Cansal.
            IF x-candes > x-cansal THEN x-candes = x-cansal.
            x-cansal = x-cansal - x-candes.
            T-Detalle.Cansal = T-Detalle.Cansal - x-candes.
            DISPLAY STREAM REPORT 
                    T-DETALLE.codmat 
                    Almmmatg.desmat FORMAT 'X(40)' 
                    Almmmatg.UndStk 
                    T-DETALLE.coddoc 
                    T-DETALLE.nrodoc 
                    T-DETALLE.fchdoc 
                    x-CanDes 
                    T-DETALLE.Implin 
                    WITH FRAME F-REP.
            DOWN STREAM  REPORT WITH FRAME F-REP.
            ACCUMULATE T-DETALLE.Implin (TOTAL).
            ACCUMULATE x-Candes (TOTAL).
            ACCUMULATE T-DETALLE.Implin (SUB-TOTAL BY T-MOVI.nrorf1).
            ACCUMULATE x-Candes (SUB-TOTAL BY T-MOVI.nrorf1).
         END.
      END.
      IF LAST-OF(T-MOVI.nrorf1) THEN DO:
         x-totcan = x-totcan + (ACCUM TOTAL x-candes).
         UNDERLINE STREAM REPORT
            x-candes WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            ACCUM SUB-TOTAL  BY T-MOVI.nrorf1 x-candes      @ x-candes
            WITH FRAME F-REP.
         DOWN(2) STREAM REPORT WITH FRAME F-REP.
      END.
/*      IF LAST-OF(T-MOVI.Codpro) THEN DO:
         UNDERLINE STREAM REPORT
            T-DETALLE.Implin WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '        TOTAL ===>  : '  @ Almmmatg.desmat
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-DETALLE.Implin @ T-DETALLE.Implin
            WITH FRAME F-REP.
         DOWN(2) STREAM REPORT WITH FRAME F-REP.
      END.*/
      IF LAST-OF(T-MOVI.Codcia) THEN DO:
         UNDERLINE STREAM REPORT
            x-candes WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '        TOTAL ===>  : '  @ Almmmatg.desmat
            ACCUM TOTAL  x-candes      @ x-candes
            WITH FRAME F-REP.
      END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Resumen D-Dialog 
PROCEDURE Formato-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-titulo1 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo2 AS CHAR NO-UNDO.
  DEFINE VAR x-titulo3 AS CHAR NO-UNDO.
  x-titulo1 = 'LIQUIDACION DE CONSIGNACION'.
  x-titulo2 = ENTRY(F-Mes,'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE').
  x-titulo2 = TRIM(x-titulo2) + '-' + STRING(F-Periodo, '9999').
  x-titulo3 = 'Expresado en ' + (IF R-Codmon = 1 THEN 'Nuevos Soles' ELSE 'Dolares Americanos').
  
  DEFINE FRAME F-REP
         T-MOVI.Codmat
         Almmmatg.desmat FORMAT 'X(40)'
         Almmmatg.UndStk FORMAT 'X(4)'
         T-MOVI.Cpieza FORMAT '>>,>>>,>>9.99'
         T-MOVI.Vpieza FORMAT '>>,>>>,>>9.99'
         T-MOVI.Spieza FORMAT '>>,>>>,>>9.99'
         WITH WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
         
  DEFINE FRAME H-REP
     HEADER
         {&PRN2} + {&Prn7a} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
         {&PRN2} + {&PRN6A} + "( " + S-CODALM + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
         {&PRN6A} + x-titulo1 AT 40 FORMAT "X(40)"
         {&PRN3} + {&PRN6B} + "Pag.  : " AT 85 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
         {&PRN2} + {&PRN6A} + x-titulo2 AT 47 FORMAT "X(40)" 
         {&PRN3} + "Fecha : " AT 85 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP
         {&PRN6B} + {&PRN3}  FORMAT "X(40)" SKIP
         "--------------------------------------------------------------------------------------------------" SKIP
         "Codigo     Descripcion                          UND       INGRESOS        VENTAS     S A L D O    " SKIP
         "--------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH T-MOVI ,
           FIRST Almmmatg WHERE 
                 Almmmatg.codcia = s-codcia AND 
                 Almmmatg.codmat = T-MOVI.codmat 
           BREAK BY T-MOVI.Codcia 
                 BY T-MOVI.Codpro 
                 BY T-MOVI.nrorf1 
                 BY T-MOVI.Codmat:
      {&new-page}.        
      VIEW STREAM REPORT FRAME H-REP.
      IF FIRST-OF(T-MOVI.Codpro) THEN DO:
         FIND gn-prov WHERE 
              gn-prov.CodCia = pv-codcia AND
              gn-prov.CodPro = T-MOVI.Codpro NO-LOCK NO-ERROR.
         IF AVAILABLE gn-prov THEN 
            DISPLAY STREAM REPORT 
               gn-prov.NomPro @ Almmmatg.desmat WITH FRAME F-REP.
         UNDERLINE STREAM REPORT Almmmatg.desmat WITH FRAME F-REP.
      END.
      IF FIRST-OF(T-MOVI.nrorf1) THEN DO:
         DISPLAY STREAM REPORT 
            ' ' @ Almmmatg.desmat WITH FRAME F-REP.
         DOWN STREAM REPORT WITH FRAME F-REP.
         DISPLAY STREAM REPORT 
            'GUIA : ' + TRIM(T-MOVI.nrorf1) @ Almmmatg.desmat WITH FRAME F-REP.
         DOWN STREAM REPORT WITH FRAME F-REP.
      END.
      T-MOVI.Spieza = T-MOVI.Ipieza + T-MOVI.Cpieza - T-MOVI.Vpieza.
      DISPLAY STREAM REPORT 
         T-MOVI.Codmat
         Almmmatg.desmat
         Almmmatg.UndStk
         T-MOVI.Cpieza 
         T-MOVI.Vpieza 
         T-MOVI.Spieza 
         WITH FRAME F-REP.
      ACCUMULATE T-MOVI.Cpieza (TOTAL).
      ACCUMULATE T-MOVI.Vpieza (TOTAL).
      ACCUMULATE T-MOVI.Spieza (TOTAL).

      ACCUMULATE T-MOVI.Cpieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Vpieza (SUB-TOTAL BY T-MOVI.Codpro).
      ACCUMULATE T-MOVI.Spieza (SUB-TOTAL BY T-MOVI.Codpro).

      IF LAST-OF(T-MOVI.Codpro) THEN DO:
         UNDERLINE STREAM REPORT
            T-MOVI.Cpieza 
            T-MOVI.Vpieza 
            T-MOVI.Spieza 
            WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '        TOTAL ===>  : '  @ Almmmatg.desmat
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM SUB-TOTAL BY T-MOVI.Codpro T-MOVI.Spieza @ T-MOVI.Spieza
            WITH FRAME F-REP.
         DOWN(2) STREAM REPORT WITH FRAME F-REP.
      END.
      IF LAST-OF(T-MOVI.Codcia) THEN DO:
         UNDERLINE STREAM REPORT
            T-MOVI.Cpieza 
            T-MOVI.Vpieza 
            T-MOVI.Spieza 
            WITH FRAME F-REP.
         DISPLAY STREAM REPORT
            ' '                       @ T-MOVI.Codmat
            '      TOTAL GENERAL : '  @ Almmmatg.desmat
            ACCUM TOTAL T-MOVI.Cpieza @ T-MOVI.Cpieza
            ACCUM TOTAL T-MOVI.Vpieza @ T-MOVI.Vpieza
            ACCUM TOTAL T-MOVI.Spieza @ T-MOVI.Spieza
            WITH FRAME F-REP.
      END.
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Carga-Temporal.
IF R-Presenta = 'R' THEN RUN Formato-Resumen.
ELSE RUN Formato-Detalle.

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
    IF c-Pagina > P-pagfin  THEN DO:
       RETURN ERROR.
    END.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina  THEN DO:
        OUTPUT STREAM report CLOSE.
        IF P-select = 1  THEN DO:
               OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED
               PAGED PAGE-SIZE 62.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 62.
            IF P-select = 3 THEN
                 PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

