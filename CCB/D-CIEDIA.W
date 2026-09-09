&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.
DEFINE VARIABLE T-DIA    AS CHAR INIT "".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-5 RECT-50 RADIO-SET-1 ~
B-impresoras f-fecha Btn_OK RB-NUMBER-COPIES Btn_Cancel RB-BEGIN-PAGE ~
Btn_Help RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 RADIO-SET-1 f-fecha ~
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

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

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

DEFINE VARIABLE f-fecha AS DATE FORMAT "99/99/9999":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
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
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.14 BY 2.27.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.14 BY 6.12.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15.57 BY 8.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-3 AT ROW 1.23 COL 2.43
     RADIO-SET-1 AT ROW 4.46 COL 2.86 NO-LABEL
     B-impresoras AT ROW 5.5 COL 16
     b-archivo AT ROW 6.5 COL 16.14
     f-fecha AT ROW 2.19 COL 22 COLON-ALIGNED NO-LABEL
     RB-OUTPUT-FILE AT ROW 6.65 COL 20 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 2.04 COL 53
     RB-NUMBER-COPIES AT ROW 8.19 COL 10.57 COLON-ALIGNED
     Btn_Cancel AT ROW 4.42 COL 53.14
     RB-BEGIN-PAGE AT ROW 8.19 COL 25.29 COLON-ALIGNED
     Btn_Help AT ROW 6.65 COL 53.14
     RB-END-PAGE AT ROW 8.19 COL 39.43 COLON-ALIGNED
     RECT-49 AT ROW 1 COL 1
     RECT-5 AT ROW 3.31 COL 1
     RECT-50 AT ROW 1 COL 50.86
     "Fecha  :" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 2.27 COL 15.86
          FONT 6
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 3.54 COL 1.57
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 7.58 COL 33.72
          FONT 6
     SPACE(25.69) SKIP(1.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Cierre del Dia".

 

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
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Cierre del Dia */
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
  
  ASSIGN f-fecha.
  
  T-DIA  = "CIERRE DIA - " + STRING(f-fecha,"99/99/9999").

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

ASSIGN FILL-IN-3 = S-CODDIV
       F-FECHA   = TODAY
       FRAME {&FRAME-NAME}:TITLE  = "[ Cierre del Dia ]".

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
  DISPLAY FILL-IN-3 RADIO-SET-1 f-fecha RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-49 RECT-5 RECT-50 RADIO-SET-1 B-impresoras f-fecha Btn_OK 
         RB-NUMBER-COPIES Btn_Cancel RB-BEGIN-PAGE Btn_Help RB-END-PAGE 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

  RUN lisCie.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LisCie D-Dialog 
PROCEDURE LisCie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                                                     
 /*** DEFINE VARIABLES TOTALES-Vendedor ***/
 DEFINE VARIABLE T-CTSOLES AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-CTDOLAR AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-CRSOLES AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-CRDOLAR AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".

 DEFINE VARIABLE T-NOTCSOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-NOTCDOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".

 DEFINE VARIABLE T-NOTDSOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-NOTDDOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".

 DEFINE VARIABLE T-DSCTSOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-DSCTDOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
  
 DEFINE VARIABLE T-ANULSOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-ANULDOL AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
   
 DEFINE VARIABLE T-FACT    AS INTEGER INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-BOLE    AS INTEGER INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-ANUL    AS INTEGER INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE T-NOTC    AS INTEGER INIT 0 FORMAT "->,>>>,>>9.99". 
 DEFINE VARIABLE T-NOTD    AS INTEGER INIT 0 FORMAT "->,>>>,>>9.99".
  
 DEFINE VARIABLE V-CTSOLES AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE V-CTDOLAR AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE V-CRSOLES AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE V-CRDOLAR AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE F-SOLES AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 DEFINE VARIABLE F-DOLAR AS DECIMAL INIT 0 FORMAT "->,>>>,>>9.99".
 
 DEFINE VARIABLE P-DSCTO AS DECIMAL INIT 0 FORMAT ">>9.99".
 DEFINE VAR W-DIA   AS INTEGER FORMAT "99"  INIT 0.
 DEFINE VAR f-moned AS CHAR    FORMAT "XXX" INIT 0.
       
 DEFINE FRAME f-cab
        TvtvVen0.VenCodig  FORMAT "XXX"
        gn-ven.NomVen      FORMAT "X(25)"
        TvtvVen0.VenNrfac  FORMAT "ZZZ9"
        TvtvVen0.VenNrBol  FORMAT "ZZZ9"
        V-CTSOLES          FORMAT "->,>>>,>>9.99"
        V-CTDOLAR          FORMAT "->,>>>,>>9.99"
        V-CRSOLES          FORMAT "->,>>>,>>9.99"
        V-CRDOLAR          FORMAT "->,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 105 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "( " + TvtvVen0.VenDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN3} + "Fecha : " AT 89 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" SKIP 
        "Hora  : " AT 117 STRING(TIME,"HH:MM:SS") + {&PRN2} SKIP
        {&PRN2} + {&PRN6A} + T-DIA + {&PRN6B} + {&PRN2} AT 52 FORMAT "X(35)" SKIP(2)
        {&PRN2} + " DE           :  ADMINISTRACION" AT 32 FORMAT "X(40)"
        {&PRN2} + " PARA         :  GERENCIA"       AT 32 FORMAT "X(40)"
        {&PRN2} + " ASUNTO       :  CIERRE DE VENTAS " AT 32 FORMAT "X(60)" SKIP (1)
        "===============================================================================================" SKIP(1)        
        {&PRN2} + {&PRN7A} + {&PRN6A} + "VENTAS" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
        "                                                C O N T A D O               C R E D I T O      " SKIP
        "         VENDEDOR             FACT/BOLE      SOLES       DOLARES         SOLES       DOLARES   " SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
/******* 999-1234567890123456789012345 9999 9999 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99 ->,>>>,>>9.99***/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
         

DEFINE FRAME f-cab11                          /***  Notas de Credito ***/
        CcbCDocu.CodDoc  FORMAT "XXX"
        CcbCDocu.NroDoc  FORMAT "XXX-XXXXXX"
        CcbCDocu.NomCli  FORMAT "X(28)"
        CcbCDocu.FchDoc  FORMAT "99/99/9999"
        CcbCDocu.CodRef  FORMAT "XXX"
        CcbCDocu.NroRef  FORMAT "XXX-XXXXXX"
        F-SOLES          FORMAT ">,>>>,>>9.99"
        F-DOLAR          FORMAT ">,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + "NOTAS DE CREDITO" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
        "   DOCUMENTO   C L I E N T E                  FECHA    DOC.REFERENCIA      SOLES      DOLARES  " SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
/******* FAC 999-123456 1234567890123456789012345678 99/99/9999 XXX 999-123456 9,999,999.99 9,999,999.99***/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME f-cab12                         /***  Notas de Debito  ***/        
        CcbCDocu.CodDoc  FORMAT "XXX"
        CcbCDocu.NroDoc  FORMAT "XXX-XXXXXX"
        CcbCDocu.NomCli  FORMAT "X(28)"
        CcbCDocu.FchDoc  FORMAT "99/99/9999"
        CcbCDocu.CodRef  FORMAT "XXX"
        CcbCDocu.NroRef  FORMAT "XXX-XXXXXX"
        F-SOLES          FORMAT ">,>>>,>>9.99"
        F-DOLAR          FORMAT ">,>>>,>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + "NOTAS DE DEBITO" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
        "   DOCUMENTO   C L I E N T E                  FECHA    DOC.REFERENCIA      SOLES      DOLARES  " SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
/******* FAC 999-123456 1234567890123456789012345678 99/99/9999 XXX 999-123456 9,999,999.99 9,999,999.99***/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


DEFINE FRAME f-cab1
        CcbCDocu.CodDoc  FORMAT "XXX"
        CcbCDocu.NroDoc  FORMAT "XXX-XXXXXX"
        CcbCDocu.NomCli  FORMAT "X(27)"
        CcbCDocu.FchDoc  FORMAT "99/99/9999"
        CcbCDocu.CodVen  FORMAT "XXX"
        F-SOLES          FORMAT ">,>>>,>>9.99"
        F-DOLAR          FORMAT ">,>>>,>>9.99"
        CcbCDocu.UsuAnu  FORMAT "X(11)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + "ANULADOS" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
        "   DOCUMENTO   C L I E N T E                 FECHA    VEN      SOLES      DOLARES   RESPONSABLE" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
 /****** FAC 999-123456 123456789012345678901234567 99/99/9999 XXX 9,999,999.99 9,999,999.99 XXXXXXXXXXX****/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

DEFINE FRAME f-cab2
        CcbCDocu.CodDoc   FORMAT "XXX"
        CcbCDocu.NroDoc   FORMAT "XXX-XXXXXX"
        CcbCDocu.NomCli   FORMAT "X(31)"
        CcbCDocu.CodVen   FORMAT "XXX"
        f-moned           FORMAT "XXX"
        CcbCDocu.ImpBrt   FORMAT "->>>,>>9.99"        
        CcbCDocu.ImpDto   FORMAT ">>,>>9.99"
        P-DSCTO           FORMAT ">>9.99"
        CcbCDocu.UsrDscto FORMAT "X(11)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + "DESCUENTOS" + {&PRN6B} + {&PRN7B} + {&PRN2} FORMAT "X(40)" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
        "   DOCUMENTO   C L I E N T E                   VEN MON TOTAL BRUTO DESCUENTO %DSCTO RESPONSABLE" SKIP
        "-----------------------------------------------------------------------------------------------" SKIP
 /****** FAC 999-123456 1234567890123456789012345678901 XXX XXX 9999,999.99 99,999.99 999.99 XXXXXXXXXXX**/
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

         
 /*** Procesa Total Por Vendedores ***/

 {&new-page}.

 w-dia = day(f-fecha).

 FOR EACH TvtvVen0 WHERE TvtvVen0.VenCia = S-CODCIA AND 
                         TvtvVen0.VenDiv = S-CODDIV AND 
                        (TvtvVen0.VenVtcrd[w-dia] + TvtvVen0.VenVtcrs[w-dia] +
                         TvtvVen0.VenVtcts[w-dia] + TvtvVen0.VenVtcts[w-dia]) > 0
                         NO-LOCK, 
          EACH integral.gn-ven WHERE integral.gn-ven.CodVen = integral.TvtvVen0.VenCodig NO-LOCK
          BY TvtvVen0.VenCodig :

     V-CTSOLES = VenVtctS[w-dia].
     V-CTDOLAR = VenVtctD[w-dia].
     V-CRSOLES = VenVtcrS[w-dia].
     V-CRDOLAR = VenVtcrD[w-dia].

     T-FACT    = T-FACT + TvtvVen0.VenNrfac.  
     T-BOLE    = T-BOLE + TvtvVen0.VenNrBol.  
     T-CTSOLES = T-CTSOLES + V-CTSOLES.
     T-CTDOLAR = T-CTDOLAR + V-CTDOLAR.
     T-CRSOLES = T-CRSOLES + V-CRSOLES.
     T-CRDOLAR = T-CRDOLAR + V-CRDOLAR.
        
     DISPLAY STREAM REPORT
     TvtvVen0.VenCodig  
     gn-ven.NomVen      
     TvtvVen0.VenNrfac  
     TvtvVen0.VenNrBol  
     V-CTSOLES WHEN V-CTSOLES > 0         
     V-CTDOLAR WHEN V-CTDOLAR > 0         
     V-CRSOLES WHEN V-CRSOLES > 0         
     V-CRDOLAR WHEN V-CRDOLAR > 0
     WITH FRAME F-Cab.

 END. 
 PUT STREAM REPORT "-----------------------------------------------------------------------------------------------" SKIP.
 PUT STREAM REPORT "T O T A L E S :" AT 25
                    T-CTSOLES  AT 41 FORMAT "->,>>>,>>9.99"
                    T-CTDOLAR  AT 55 FORMAT "->,>>>,>>9.99"
                    T-CRSOLES  AT 69 FORMAT "->,>>>,>>9.99"
                    T-CRDOLAR  AT 83 FORMAT "->,>>>,>>9.99" 
                    SKIP (2).
                


 /**** Procesa NOTAS DE CREDITO ****/
 
 FOR EACH CcbcDocu WHERE CcbcDocu.CodCia  =  S-CODCIA AND CcbcDocu.CodDiv  =  S-CODDIV AND 
                         CcbcDocu.FchDoc  =  f-fecha  AND CcbcDocu.CodDoc  =  "N/C"    AND
                         CcbcDocu.FlgEst <>  "A" NO-LOCK ,
          EACH gn-clie WHERE gn-clie.Codcli = CcbcDocu.CodCli NO-LOCK
          BY CcbcDocu.NroDoc :
    
     IF CcbCDocu.CodMon = 1 THEN DO:
        F-SOLES = CcbCDocu.Imptot.
        F-DOLAR = 0.
     END.   
     IF CcbCDocu.CodMon = 2 THEN DO:
        F-SOLES = 0.
        F-DOLAR = CcbCDocu.Imptot.
     END.   

     T-NOTCSOL = T-NOTCSOL + F-SOLES.
     T-NOTCDOL = T-NOTCDOL + F-DOLAR.
     T-NOTC = T-NOTC + 1.
      
     DISPLAY STREAM REPORT
             CcbCDocu.CodDoc    
             CcbCDocu.NroDoc    
             CcbCDocu.NomCli    
             CcbCDocu.FchDoc    
             CcbCDocu.CodRef
             CcbCdocu.NroRef
             F-SOLES WHEN F-SOLES > 0             
             F-DOLAR WHEN F-DOLAR > 0             
             WITH FRAME F-Cab11.
 END. 
 IF T-NOTCSOL + T-NOTCDOL <> 0 THEN DO :
    PUT STREAM REPORT "-----------------------------------------------------------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL NOTAS DE CREDITO  : " AT 05
                       T-NOTC     AT 36 FORMAT "ZZ9"
                       T-NOTCSOL  AT 71 FORMAT ">,>>>,>>9.99"
                       T-NOTCDOL  AT 84 FORMAT ">,>>>,>>9.99"
                       SKIP (2).
 END. 



 /**** Procesa Notas de Debito  ****/
 FOR EACH CcbcDocu WHERE CcbcDocu.CodCia  =  S-CODCIA AND
                         CcbcDocu.CodDiv  =  S-CODDIV AND
                         CcbcDocu.FchDoc  =  f-fecha  AND
                         CcbcDocu.CodDoc  =  "N/D"    AND
                         CcbcDocu.FlgEst <>  "A" NO-LOCK ,
          EACH gn-clie WHERE gn-clie.Codcli = CcbcDocu.CodCli NO-LOCK
          BY CcbcDocu.NroDoc :
    
     IF CcbCDocu.CodMon = 1 THEN DO:
        F-SOLES = CcbCDocu.Imptot.
        F-DOLAR = 0.
     END.   
     IF CcbCDocu.CodMon = 2 THEN DO:
        F-SOLES = 0.
        F-DOLAR = CcbCDocu.Imptot.
     END.   

     T-NOTDSOL = T-NOTDSOL + F-SOLES.
     T-NOTDDOL = T-NOTDDOL + F-DOLAR.
     T-NOTD = T-NOTD + 1.
      
     DISPLAY STREAM REPORT
             CcbCDocu.CodDoc    
             CcbCDocu.NroDoc    
             CcbCDocu.NomCli    
             CcbCDocu.FchDoc    
             CcbCDocu.CodRef
             CcbCdocu.NroRef
             F-SOLES WHEN F-SOLES > 0             
             F-DOLAR WHEN F-DOLAR > 0             
             WITH FRAME F-Cab12.
 END. 
 IF T-NOTDSOL + T-NOTDDOL <> 0 THEN DO :
    PUT STREAM REPORT "-----------------------------------------------------------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL NOTAS DE DEBITO   : " AT 05
                       T-NOTD     AT 36 FORMAT "ZZ9"
                       T-NOTDSOL  AT 71 FORMAT ">,>>>,>>9.99"
                       T-NOTDDOL  AT 84 FORMAT ">,>>>,>>9.99"
                       SKIP (2).
 END.                          
                         

 /**** Procesa Anuladas ****/ 
 
 FOR EACH CcbcDocu WHERE CcbcDocu.CodCia = S-CODCIA AND CcbcDocu.CodDiv = S-CODDIV 
                         AND ( CcbcDocu.CodDoc = "FAC" OR CcbcDocu.CodDoc = "BOL" 
                            OR CcbcDocu.CodDoc = "N/C" OR CcbcDocu.CodDoc = "N/D" )
                         AND CcbcDocu.FchDoc = f-fecha AND CcbcDocu.FlgEst = "A" NO-LOCK, 
          EACH gn-clie WHERE gn-clie.Codcli = CcbcDocu.CodCli NO-LOCK                         
          BY CcbcDocu.NroDoc :
    
     IF CcbCDocu.CodMon = 1 THEN DO:
        F-SOLES = CcbCDocu.Imptot.
        F-DOLAR = 0.
     END.   
     IF CcbCDocu.CodMon = 2 THEN DO:
        F-SOLES = 0.
        F-DOLAR = CcbCDocu.Imptot.
     END.   

     T-ANULSOL = T-ANULSOL + F-SOLES.
     T-ANULDOL = T-ANULDOL + F-DOLAR.
     T-ANUL = T-ANUL + 1.
      
     DISPLAY STREAM REPORT
     CcbCDocu.CodDoc    
     CcbCDocu.NroDoc    
     CcbCDocu.NomCli    
     CcbCDocu.CodVen
     CcbCDocu.FchDoc    
     F-SOLES WHEN F-SOLES > 0             
     F-DOLAR WHEN F-DOLAR > 0             
     CcbCDocu.UsuAnu
     WITH FRAME F-Cab1.
 END. 
 IF T-ANULSOL + T-ANULDOL <> 0 THEN DO :
    PUT STREAM REPORT "-----------------------------------------------------------------------------------------------" SKIP.
    PUT STREAM REPORT "TOTAL DOCUMENTOS ANULADOS : " AT 05
                       T-ANUL     AT 36 FORMAT "ZZ9"   
                       T-ANULSOL  AT 59 FORMAT ">,>>>,>>9.99"
                       T-ANULDOL  AT 72 FORMAT ">,>>>,>>9.99" 
                       SKIP (2).
 END.                  

 /**** Procesa Documentos c/Dscto. ****/ 

 FOR EACH CcbcDocu WHERE CcbcDocu.CodCia = S-CODCIA AND CcbcDocu.CodDiv = S-CODDIV 
                         AND CcbcDocu.FchDoc = f-fecha 
                         AND ( CcbcDocu.CodDoc = "FAC" OR CcbcDocu.CodDoc = "BOL" )
                         AND CcbcDocu.ImpDto > 0 NO-LOCK, 
          EACH gn-clie WHERE gn-clie.Codcli = CcbcDocu.CodCli NO-LOCK                         
          BY CcbcDocu.NroDoc :
    
     IF CcbCDocu.CodMon = 1 THEN DO:
        F-MONED = "S/.".
     END.   
     IF CcbCDocu.CodMon = 2 THEN DO:
        F-MONED = "US$".        
     END.   

     P-DSCTO =  ( CcbCDocu.ImpDto / ( CcbCDocu.ImpBrt + CcbCDocu.ImpDto ) ) * 100.
     
     DISPLAY STREAM REPORT
     CcbCDocu.CodDoc    
     CcbCDocu.NroDoc
     CcbCDocu.NomCli    
     CcbCDocu.CodVen
     f-moned
     CcbCDocu.ImpDto
     CcbCDocu.ImpBrt
     P-DSCTO WHEN P-DSCTO > 0
     CcbCDocu.UsrDscto
     WITH FRAME F-Cab2.
 END. 

 DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 6 :
    PUT STREAM Report "" skip.
 END.
 PUT STREAM Report "   -------------------------                -------------------------       "  AT 15 SKIP.
 PUT STREAM Report "      VoBo. ADMINISTRADOR                        Vo.Bo.  GERENCIA           "  AT 15 SKIP.
 PUT STREAM Report " "  SKIP(1).
 PUT STREAM Report " ** ADMINISTRACION ** " AT 70 SKIP.
 OUTPUT STREAM Report CLOSE.


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


