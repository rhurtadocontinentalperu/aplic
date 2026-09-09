&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    DIALOG-1
&Scoped-define FRAME-NAME     DIALOG-1
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
DEFINE STREAM report.
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

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,4,5".

DEFINE        VARIABLE P-config  AS CHARACTER.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina ".
DEFINE        VARIABLE c-Copias  AS INTEGER.
DEFINE        VARIABLE X-Detalle LIKE Modulos.Detalle.
DEFINE        VARIABLE i         AS INTEGER.
DEFINE        VARIABLE OKpressed AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER.
DEFINE        VARIABLE Prv-CodCia AS INTEGER.
DEFINE        VARIABLE PTO        AS LOGICAL.

&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-tipobal  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-dircia  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-substr   AS INTEGER.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "S u m!Debe      ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "a s            !Haber     ".
DEFINE VARIABLE x-activo   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "I n v e n!Activo     ".
DEFINE VARIABLE x-pasivo   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "t a r i o      !Pasivo     ".
DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l!Deudor    ".
DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "d o s          !Acreedor   ".
DEFINE VARIABLE x-perXnat  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Resultado por!P²rdidas    ".
DEFINE VARIABLE x-ganXnat  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "Naturaleza     !Ganancias   ".
DEFINE VARIABLE x-perXfun  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Resultado!P²rdidas    ".
DEFINE VARIABLE x-ganXfun  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "por Funci½n    !Ganancias   ".
DEFINE VARIABLE impca1     AS DECIMAL.
DEFINE VARIABLE impca2     AS DECIMAL.
DEFINE VARIABLE impca3     AS DECIMAL.
DEFINE VARIABLE impca4     AS DECIMAL.
DEFINE VARIABLE impca5     AS DECIMAL.
DEFINE VARIABLE impca6     AS DECIMAL.


DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 2.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.



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
/*
DEFINE FRAME f-cab 
    SPACE(10) 
    X-codcta 
    X-clfaux COLUMN-LABEL "Aux."
    X-nomcta
    HEADER
    s-nomcia "FECHA :" TO 69 TODAY TO 78 SKIP
    "OFICINA DE CONTABILIDAD" "PAGINA :" TO 69
    c-Pagina FORMAT "ZZ9" TO 78 SKIP
    "PLAN DE CUENTAS" AT 33 SKIP
    WITH DOWN NO-BOX STREAM-IO.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  DIALOG-1

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop"
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 11 BY 1.08.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint"
     IMAGE-DOWN FILE "IMG/pvprintd"
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY 1.08.

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

DEFINE VARIABLE x-digitos AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "D¡gitos" 
     VIEW-AS FILL-IN 
     SIZE 4 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE VARIABLE x-balance AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Mensual", 1,
"Acumulado", 2
     SIZE 15 BY 1.5 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"D¢lares",2
     SIZE 12 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 5.81.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-digitos AT ROW 2 COL 13 COLON-ALIGNED
     x-balance AT ROW 2 COL 40 NO-LABEL
     x-codmon AT ROW 2 COL 58 NO-LABEL
     RADIO-SET-1 AT ROW 8 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 8 COL 64 COLON-ALIGNED
     B-impresoras AT ROW 9 COL 15
     RB-BEGIN-PAGE AT ROW 9 COL 64 COLON-ALIGNED
     b-archivo AT ROW 10 COL 15
     RB-END-PAGE AT ROW 10 COL 64 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 10.27 COL 19 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 12 COL 18
     B-cancela AT ROW 12 COL 48
     RECT-4 AT ROW 1 COL 1
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 74 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 7.5 COL 1
     RECT-6 AT ROW 11.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Plan de Cuentas".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
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
    ASSIGN x-balance x-codmon.
    
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


&Scoped-define SELF-NAME x-digitos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-digitos DIALOG-1
ON LEAVE OF x-digitos IN FRAME DIALOG-1 /* D¡gitos */
DO:
        ASSIGN x-digitos.
        IF LOOKUP(STRING(x-digitos), cb-niveles) = 0
            THEN DO:
                BELL.
                MESSAGE "Nivel de cuenta" SKIP 
                        "no configurado"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO x-digitos.
                RETURN NO-APPLY.
            END.
    
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
  PTO = SESSION:SET-WAIT-STATE("").    
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
RUN disable_UI.

  FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
  VIEW FRAME F-Mensaje.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca-cfg DIALOG-1 
PROCEDURE busca-cfg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    x-perXnat = 0.
    x-ganXnat = 0.
    x-perXfun = 0.
    x-ganXfun = 0.
    i = LOOKUP(STRING(x-digitos), cb-niveles).
    DO i = i TO 1 BY -1:
        x-substr = INTEGER(ENTRY(i, cb-niveles)).
        FIND FIRST cb-cfgc WHERE cb-cfgc.codcia = cb-codcia
                AND cb-cfgc.codcta = SUBSTR(cb-ctas.codcta,1,x-substr)
                AND cb-cfgc.codcfg = 4 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-cfgc THEN DO:                               
            x-perXfun = x-deudor.             
            x-ganXfun = x-acreedor.
        END.
        FIND FIRST cb-cfgc WHERE cb-cfgc.codcia = cb-codcia
                AND cb-cfgc.codcta = SUBSTR(cb-ctas.codcta,1,x-substr)
                AND cb-cfgc.codcfg = 3 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-cfgc THEN DO:
            x-perXnat = x-deudor.
            x-ganXnat = x-acreedor.
        END.
    END.               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY x-digitos x-balance x-codmon RADIO-SET-1 RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 x-digitos x-balance x-codmon RECT-5 RADIO-SET-1 
         RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE RECT-6 
         B-imprime B-cancela 
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
    P-largo = 66.
    P-Ancho = 210.
    P-Config = P-15cpi.
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

    IF x-codmon = 1 THEN
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE 
        x-expres = "(EXPRESADO EN DOLARES)".

    IF x-balance = 1 THEN
        x-tipobal = "(MENSUAL)".
    ELSE
        x-tipobal = "(ACUMULADO)".
    
    DEFINE FRAME f-cab
        cb-ctas.codcta
        nomcta
        x-debe
        x-haber  
        x-deudor
        x-acreedor
        x-activo
        x-pasivo
        x-perXnat
        x-ganXnat
        x-perXfun
        x-ganXfun
        HEADER
        empresas.nomcia
        "B A L A N C E   D E   C O M P R O B A C I O N" TO 127
        "FECHA : " TO 199 TODAY TO 208
        SKIP
        x-dircia
        x-tipobal AT 85
        "PAGINA :" TO 198 c-pagina FORMAT "ZZ9" TO 208 
        SKIP
        pinta-mes AT 85
        SKIP
        x-expres  AT 85
        SKIP(2)
        WITH WIDTH 209 NO-BOX DOWN STREAM-IO. 

    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-tipobal, 40 , OUTPUT x-tipobal).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    
/*    {b_print.i "START"}. */
    DO WITH FRAME f-cab:
        
    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
                            AND LENGTH(cb-ctas.codcta) <= x-digitos
                            ON ERROR UNDO, LEAVE:
            RUN cbd_imp.p ( INPUT  s-codcia, 
                                   cb-ctas.codcta,
                                   "", 
                                   s-periodo, 
                                   s-NroMes,
                                   x-codmon,
                            OUTPUT impca1, 
                            OUTPUT impca2, 
                            OUTPUT impca3,
                            OUTPUT impca4, 
                            OUTPUT impca5, 
                            OUTPUT impca6 ).
            IF x-balance = 1 THEN DO:
                x-debe  = impca1.
                x-haber = impca2.
            END.
            ELSE DO:
                x-debe  = impca4.
                x-haber = impca5. 
            END.
            IF NOT (x-haber = 0 AND x-debe = 0) THEN DO:
               {&NEW-PAGE}. 
                DISPLAY STREAM report cb-ctas.codcta nomcta WITH FRAME f-cab.
                IF LENGTH(cb-ctas.codcta) = x-digitos THEN DO: 
                    x-deudor   = x-debe - x-haber.    
                    x-acreedor = 0.
                    IF x-deudor < 0
                    THEN ASSIGN x-acreedor = - x-deudor
                                x-deudor   = 0.
                    IF codcta < "6" THEN DO:
                        x-activo = x-deudor. 
                        x-pasivo = x-acreedor.
                    END.
                    ELSE DO:
                        RUN busca-cfg.
                        x-activo = 0. 
                        x-pasivo = 0.
                    END.
                    ACCUMULATE x-haber    (TOTAL).
                    ACCUMULATE x-debe     (TOTAL).
                    ACCUMULATE x-deudor   (TOTAL).            
                    ACCUMULATE x-acreedor (TOTAL).
                    ACCUMULATE x-activo   (TOTAL).            
                    ACCUMULATE x-pasivo   (TOTAL).
                    ACCUMULATE x-perXnat  (TOTAL).            
                    ACCUMULATE x-ganXnat  (TOTAL).
                    ACCUMULATE x-perXfun  (TOTAL).            
                    ACCUMULATE x-ganXfun  (TOTAL).
                    DISPLAY STREAM report
                                      x-debe     WHEN (x-debe     <> 0)
                                      x-haber    WHEN (x-haber    <> 0)
                                      x-deudor   WHEN (x-deudor   <> 0)
                                      x-acreedor WHEN (x-acreedor <> 0)
                                      x-activo   WHEN (x-activo   <> 0)
                                      x-pasivo   WHEN (x-pasivo   <> 0)
                                      x-perXnat  WHEN (x-perXnat  <> 0)
                                      x-ganXnat  WHEN (x-ganXnat  <> 0)
                                      x-perXfun  WHEN (x-perXfun  <> 0)
                                      x-ganXfun  WHEN (x-ganXfun  <> 0)
                                WITH FRAME f-cab.
                END.
                DOWN STREAM report 1 WITH FRAME f-cab.
            END.
        END.
        UNDERLINE STREAM report x-debe    x-haber    
                                x-deudor  x-acreedor 
                                x-activo  x-pasivo   
                                x-perXnat x-ganXnat  
                                x-perXfun x-ganXfun
                    WITH FRAME f-cab.
        ASSIGN
            x-debe     = ACCUM TOTAL x-debe    
            x-haber    = ACCUM TOTAL x-haber   
            x-deudor   = ACCUM TOTAL x-deudor  
            x-acreedor = ACCUM TOTAL x-acreedor
            x-activo   = ACCUM TOTAL x-activo  
            x-pasivo   = ACCUM TOTAL x-pasivo  
            x-perXnat  = ACCUM TOTAL x-perXnat 
            x-ganXnat  = ACCUM TOTAL x-ganXnat 
            x-perXfun  = ACCUM TOTAL x-perXfun 
            x-ganXfun  = ACCUM TOTAL x-ganXfun.
        DISPLAY STREAM report x-debe    x-haber
                              x-deudor  x-acreedor
                              x-activo  x-pasivo  
                              x-perXnat x-ganXnat 
                              x-perXfun x-ganXfun 
                    WITH FRAME f-cab.
        DOWN STREAM report 1 WITH FRAME f-cab.
        IF x-activo > x-pasivo
        THEN DO:
            DISPLAY STREAM report (x-activo - x-pasivo) @ x-pasivo
                        WITH FRAME f-cab.
            x-pasivo = x-activo.
         END.
         ELSE DO:
            DISPLAY STREAM report (x-pasivo - x-activo) @ x-activo
                        WITH FRAME f-cab.
            x-activo = x-pasivo.
         END.
         IF x-perXnat > x-ganXnat
         THEN DO:
            DISPLAY STREAM report (x-perXnat - x-ganXnat) @ x-ganXnat
                        WITH FRAME f-cab.
            x-ganXnat = x-perXnat.
         END.
         ELSE DO:
            DISPLAY STREAM report (x-ganXnat - x-perXnat) @ x-perXnat
                        WITH FRAME f-cab.
            x-perXnat = x-ganXnat.
         END.
         IF x-perXfun > x-ganXfun
         THEN DO:
            DISPLAY STREAM report (x-perXfun - x-ganXfun) @ x-ganXfun
                        WITH FRAME f-cab.
            x-ganXfun = x-perXfun.
         END.
         ELSE DO:
            DISPLAY STREAM report (x-ganXfun - x-perXfun) @ x-perXfun
                        WITH FRAME f-cab.
            x-perXfun = x-ganXfun.
         END.
         DOWN STREAM report 1 WITH FRAME f-cab.
         UNDERLINE STREAM report x-activo  x-pasivo   
                                 x-perXnat x-ganXnat  
                                 x-perXfun x-ganXfun
                    WITH FRAME f-cab.
         DOWN STREAM report 1 WITH FRAME f-cab.
         DISPLAY STREAM report x-activo  x-pasivo  
                               x-perXnat x-ganXnat 
                               x-perXfun x-ganXfun 
                    WITH FRAME f-cab.
    END.
    
/*{b_print.i "STOP"}.*/
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
               OUTPUT STREAM report TO PRINTER
                    PAGED PAGE-SIZE 1000.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo )
                 PAGED PAGE-SIZE 1000.
            IF P-select = 3 THEN
                PUT STREAM report CONTROL P-reset P-flen P-config.
        END.
    END.
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


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
