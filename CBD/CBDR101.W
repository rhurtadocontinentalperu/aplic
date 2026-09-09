&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/31/95 -  6:23 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE P-Largo    AS INTEGER.
DEFINE VARIABLE P-Ancho    AS INTEGER.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9".
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9".
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)".

DEFINE VARIABLE P-detalle  LIKE TermImp.Detalle.
DEFINE VARIABLE P-comando  LIKE TermImp.Comando.
DEFINE VARIABLE P-device   LIKE TermImp.Device.
DEFINE VARIABLE P-name     LIKE TermImp.p-name.

DEFINE VARIABLE P-Reset    AS CHARACTER.
DEFINE VARIABLE P-Flen     AS CHARACTER.
DEFINE VARIABLE P-6lpi     AS CHARACTER.
DEFINE VARIABLE P-8lpi     AS CHARACTER.
DEFINE VARIABLE P-10cpi    AS CHARACTER.
DEFINE VARIABLE P-12cpi    AS CHARACTER.
DEFINE VARIABLE P-15cpi    AS CHARACTER.
DEFINE VARIABLE P-20cpi    AS CHARACTER.
DEFINE VARIABLE P-Landscap AS CHARACTER.
DEFINE VARIABLE P-Portrait AS CHARACTER.
DEFINE VARIABLE P-DobleOn  AS CHARACTER.
DEFINE VARIABLE P-DobleOff AS CHARACTER.
DEFINE VARIABLE P-BoldOn   AS CHARACTER.
DEFINE VARIABLE P-BoldOff  AS CHARACTER.
DEFINE VARIABLE P-UlineOn  AS CHARACTER.
DEFINE VARIABLE P-UlineOff AS CHARACTER.
DEFINE VARIABLE P-ItalOn   AS CHARACTER.
DEFINE VARIABLE P-ItalOff  AS CHARACTER.
DEFINE VARIABLE P-SuperOn  AS CHARACTER.
DEFINE VARIABLE P-SuperOff AS CHARACTER.
DEFINE VARIABLE P-SubOn    AS CHARACTER.
DEFINE VARIABLE P-SubOff   AS CHARACTER.
DEFINE VARIABLE P-Proptnal AS CHARACTER.
DEFINE VARIABLE P-Lpi      AS CHARACTER.
DEFINE VARIABLE l-immediate-display  AS LOGICAL.

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,4,5".


DEFINE        VARIABLE P-config  AS CHARACTER.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina ".
DEFINE        VARIABLE c-Copias  AS INTEGER.
DEFINE        VARIABLE X-Detalle LIKE Modulos.Detalle.
DEFINE        VARIABLE i         AS INTEGER.
DEFINE        VARIABLE j         AS INTEGER.
DEFINE        VARIABLE k         AS INTEGER.
DEFINE        VARIABLE OKpressed AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER.
DEFINE        VARIABLE Prv-CodCia AS INTEGER.
DEFINE        VARIABLE PTO        AS LOGICAL.
/*VARIABLES PARA EL FRAME DE REPORTE DEL PLAN DE  CUENTAS */  
DEFINE        VARIABLE X-codcta   AS CHARACTER FORMAT "X(10)" LABEL "Cuenta".
DEFINE        VARIABLE X-clfaux   LIKE cb-ctas.clfaux.          
DEFINE        VARIABLE X-nomcta   LIKE cb-ctas.nomcta.
DEFINE        VARIABLE s-nomcia   LIKE empresa.nomcia.     
 

&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE



DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

DEFINE STREAM report.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG/print"
     SIZE 5 BY 1.5.

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          font 4
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          font 4
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          font 4          
     SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RADIO-SET-1 RECT-6 ~
B-impresoras B-imprime cta-ini cta-fin RECT-7 l-margen B-cancela ~
R-tipo-reporte RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 cta-ini cta-fin l-margen ~
R-tipo-reporte RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     LABEL "&Cancelar" 
     SIZE 11 BY 1.08.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY 1.08.

DEFINE VARIABLE cta-fin AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cta-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "P gina Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .85
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "P gina Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .85
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .85
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .73
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE R-tipo-reporte AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detallado", 2
     SIZE 12 BY 1.5 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 6.31.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 2.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 21 BY 2.5.

DEFINE VARIABLE l-margen AS LOGICAL INITIAL no 
     LABEL "Indentado" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     RADIO-SET-1 AT ROW 8 COL 2 NO-LABEL
     B-impresoras AT ROW 9 COL 15
     b-archivo AT ROW 10 COL 15
     B-imprime AT ROW 12 COL 18
     cta-ini AT ROW 2 COL 21 COLON-ALIGNED
     cta-fin AT ROW 4 COL 21 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 10.27 COL 19 COLON-ALIGNED NO-LABEL
     l-margen AT ROW 5.5 COL 47
     B-cancela AT ROW 12 COL 48
     R-tipo-reporte AT ROW 3 COL 51 NO-LABEL
     RB-NUMBER-COPIES AT ROW 8 COL 64 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9 COL 64 COLON-ALIGNED
     RB-END-PAGE AT ROW 10 COL 64 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 74 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 7.5 COL 1
     RECT-6 AT ROW 11.5 COL 1
     "Formato" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.81 COL 47
     RECT-7 AT ROW 2.5 COL 47
     SPACE(7.00) SKIP(8.50)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Plan de Cuentas".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   Default                                                              */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Plan de Cuentas */
DO:
    APPLY "CHOOSE" TO B-imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo DIALOG-1
ON CHOOSE OF b-archivo IN FRAME DIALOG-1 /* Archivos.. */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras DIALOG-1
ON CHOOSE OF B-impresoras IN FRAME DIALOG-1
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime DIALOG-1
ON CHOOSE OF B-imprime IN FRAME DIALOG-1 /* Imprimir */
DO:
    ASSIGN R-tipo-reporte l-margen.
    cta-ini = cta-ini:SCREEN-VALUE.
    cta-fin = cta-fin:SCREEN-VALUE.
    cta-fin = cta-fin + "9999999999".
    IF cta-fin < cta-ini THEN 
       DO:
          BELL.
          MESSAGE "La cuenta fin es menor" SKIP
                  "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO cta-ini.
          RETURN NO-APPLY.
       END.
   /* 
    find cb-ctas WHERE codcta = cta-ini NO-LOCK NO-ERROR.
    IF (NOT AVAILABLE cuentas)  THEN 
       DO: 
          BELL.
          MESSAGE "Cuenta de Inicio no existe," SKIP
                  "Intente otra vez" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO cta-ini.
          RETURN NO-APPLY.
       END.
    */   
    P-Copias = INPUT FRAME DIALOG-1 RB-NUMBER-COPIES.
    P-pagIni = INPUT FRAME DIALOG-1 RB-BEGIN-PAGE.
    P-pagfin = INPUT FRAME DIALOG-1 RB-END-PAGE.
    P-select = INPUT FRAME DIALOG-1 RADIO-SET-1.
    P-archivo= INPUT FRAME DIALOG-1 RB-OUTPUT-FILE.
    P-detalle = "Impresora Local (EPSON)".
    P-name  = "Epson E/F/J/RX/LQ".
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 DIALOG-1
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME DIALOG-1
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
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

  FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
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
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
        OS-DELETE VALUE ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET-1 cta-ini cta-fin l-margen R-tipo-reporte RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RADIO-SET-1 RECT-6 B-impresoras B-imprime cta-ini 
         cta-fin RECT-7 l-margen B-cancela R-tipo-reporte RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  i = INTEGER(ENTRY(1,cb-niveles)).
  .
  
  DEFINE FRAME f-cab 
    SPACE(10) 
    X-codcta 
    X-clfaux COLUMN-LABEL "Aux."
    X-nomcta
    HEADER 
    empresas.nomcia "FECHA :" TO 69 TODAY TO 78 SKIP
    "OFICINA DE CONTABILIDAD" "PAGINA :" TO 69
    c-Pagina FORMAT "ZZ9" TO 78 SKIP
    "PLAN DE CUENTAS" AT 33 SKIP
    WITH DOWN NO-BOX STREAM-IO.

  DEFINE FRAME f-cab2
    X-codcta 
    X-clfaux COLUMN-LABEL "Aux."
    X-nomcta
    cb-ctas.aftdcb COLUMN-LABEL "Dif!Cmb"
    cb-ctas.codmon COLUMN-LABEL "Cod!Mon"
    cb-ctas.tpocmb COLUMN-LABEL "Tpo!Cmb"
    cb-ctas.piddoc COLUMN-LABEL "Pid!Doc"
    cb-ctas.coddoc COLUMN-LABEL "Cod!Doc"
    cb-ctas.pidref COLUMN-LABEL "Pid!Ref"
    cb-ctas.An1Cta COLUMN-LABEL "Cuenta!Autom."
    cb-ctas.Cc1Cta COLUMN-LABEL "Contra!Cuenta"    
    HEADER
    empresas.NomCia "FECHA :" TO 91 TODAY TO 100 SKIP
    "OFICINA DE CONTABILIDAD" "PAGINA :" TO 91
    c-Pagina FORMAT "ZZ9" TO 100 SKIP
    "PLAN DE CUENTAS":C100  SKIP(2)
    WITH DOWN NO-BOX STREAM-IO WIDTH 160.

    
    P-Largo = 66.    /* Largo de Pagina */ 
    
IF R-tipo-reporte = 1 THEN
   DO:
    P-Ancho = 90.   /* Ancho de P gina */
    /* Configurando Setup de Impresora */
    P-Config = P-10cpi.
    FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND codcta >= cta-ini
        AND codcta <= cta-fin
        NO-LOCK
        BREAK BY SUBSTRING(codcta,1,2) ON ERROR UNDO, LEAVE:
       {&NEW-PAGE}. 
        IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN 
          DO:
            X-codcta = "".
            X-clfaux = "".
            X-nomcta = "".
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab.
            X-nomcta = FILL("=", LENGTH(nomcta)).
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab.
            X-codcta = cb-ctas.codcta.
            X-nomcta = cb-ctas.nomcta.
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab.
            X-codcta = "".
            X-nomcta = FILL("=",LENGTH(nomcta)).
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab.
          END.
       ELSE
          DO:
              IF l-margen  THEN x-codcta = FILL(" ",LENGTH(cb-ctas.codcta) - i) + cb-ctas.codcta.
              ELSE X-codcta = cb-ctas.codcta.
              X-clfaux = cb-ctas.clfaux.
              X-nomcta = cb-ctas.nomcta.
              DISPLAY STREAM report X-codcta X-clfaux X-nomcta
                      WITH FRAME f-cab.
              IF LAST-OF (SUBSTRING(codcta,1,2)) THEN 
                  DOWN STREAM report WITH FRAME f-cab.                
          END.
   END.
   RETURN.
END.
       
    
    P-Ancho = 160.   /* Ancho de P gina */
    /* Configurando Setup de Impresora */
    P-Config = P-20cpi.
    FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
        codcta >= cta-ini AND codcta <= cta-fin NO-LOCK
        BREAK BY SUBSTRING(codcta,1,2) ON ERROR UNDO, LEAVE:
       {&NEW-PAGE}. 
    
       IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN 
          DO:
            X-codcta = "".
            X-clfaux = "".
            X-nomcta = "".
            DOWN STREAM report 1 WITH FRAME f-cab2.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab2.
            X-nomcta = FILL("=", LENGTH(nomcta)).
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab2.
            X-codcta = cb-ctas.codcta.
            X-nomcta = cb-ctas.nomcta.
            DOWN STREAM report 1 WITH FRAME f-cab2.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab2.
            X-codcta = "".
            X-nomcta = FILL("=",LENGTH(nomcta)).
            DOWN STREAM report 1 WITH FRAME f-cab2.
            DISPLAY STREAM report X-codcta X-clfaux X-nomcta WITH FRAME f-cab2.
          END.
       ELSE
          DO:
              IF l-margen  THEN x-codcta = FILL(" ",LENGTH(cb-ctas.codcta) - i) + cb-ctas.codcta.
              ELSE X-codcta = cb-ctas.codcta.
              X-clfaux = cb-ctas.clfaux.
              X-nomcta = cb-ctas.nomcta.
              DISPLAY STREAM report X-codcta X-clfaux X-nomcta
                       cb-ctas.aftdcb
                       cb-ctas.codmon 
                       cb-ctas.tpocmb 
                       cb-ctas.piddoc 
                       cb-ctas.coddoc 
                       cb-ctas.pidref 
                       cb-ctas.An1Cta 
                       cb-ctas.Cc1Cta 
              WITH FRAME f-cab2.
              IF LAST-OF (SUBSTRING(codcta,1,2)) THEN 
                  DOWN STREAM report WITH FRAME f-cab2.                          
          END.
   END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE DIALOG-1 
PROCEDURE NEW-PAGE :
/* -----------------------------------------------------------
  Purpose: Imprimir las cabezeras de los reportes     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nivel DIALOG-1 
PROCEDURE nivel :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar DIALOG-1 
PROCEDURE remvar :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setup-print DIALOG-1 
PROCEDURE setup-print :
/* -----------------------------------------------------------
  Purpose: Configura los codigos de escape de impresi¢n
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
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


