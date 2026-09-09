&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
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
DEFINE VARIABLE l-immediate-display AS LOGICAL.

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5".
DEFINE               VARIABLE x-max-nivel     as integer.
x-max-nivel = integer(entry(num-entries(cb-niveles),cb-niveles)).
DEFINE VAR    x-digitos AS INTEGER INIT 2.
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
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "S u m!Debe      ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
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
                           COLUMN-LABEL "Resultado por!Pérdidas    ".
DEFINE VARIABLE x-ganXnat  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "Naturaleza     !Ganancias   ".
DEFINE VARIABLE x-perXfun  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Resultado!Pérdidas    ".
DEFINE VARIABLE x-ganXfun  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "por Función    !Ganancias   ".
DEFINE VARIABLE x-NomDiv   AS CHAR FORMAT "X(40)" INITIAL "C O N S O L I D A D O".
DEFINE VARIABLE impca1     AS DECIMAL.
DEFINE VARIABLE impca2     AS DECIMAL.
DEFINE VARIABLE impca3     AS DECIMAL.
DEFINE VARIABLE impca4     AS DECIMAL.
DEFINE VARIABLE impca5     AS DECIMAL.
DEFINE VARIABLE impca6     AS DECIMAL.
DEFINE VARIABLE x-balance  AS INTEGER INIT 1.

DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
FIND cb-cfga WHERE cb-cfga.CODCIA = cb-codcia NO-LOCK NO-ERROR.

DEFINE VAR x-cuenta AS CHAR NO-UNDO.
DEFINE VAR x-saldo  AS DECIMAL EXTENT 13 FORMAT "->>>>>>>9.99" NO-UNDO.
DEFINE BUFFER b-cb-ctas FOR cb-ctas.

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
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-10 RECT-13 RECT-6 C-1 ~
x-Div O-mayor x-cta-ini x-cta-fin C-2 C-3 x-codmon RADIO-SET-1 ~
RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS C-1 x-Div O-mayor x-cta-ini x-cta-fin C-2 ~
C-3 x-codmon RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     SIZE 11 BY 1.35.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY 1.35.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.35.

DEFINE VARIABLE C-1 AS CHARACTER FORMAT "9":U 
     LABEL "Dígitos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-3 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-cta-fin AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-cta-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE O-mayor AS LOGICAL 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Mayor", yes,
"Diario", no
     SIZE 7 BY 1.88 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 8 BY 1.23 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 12 BY 1.62.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 10 BY 2.42.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.29 BY 5.81.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.43 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 66.43 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     C-1 AT ROW 1.31 COL 10.43 COLON-ALIGNED
     x-Div AT ROW 1.31 COL 33.86 COLON-ALIGNED
     O-mayor AT ROW 1.96 COL 52 NO-LABEL
     x-cta-ini AT ROW 2.12 COL 33.86 COLON-ALIGNED
     x-cta-fin AT ROW 2.85 COL 33.86 COLON-ALIGNED
     C-2 AT ROW 3.92 COL 34 COLON-ALIGNED
     C-3 AT ROW 4.73 COL 34 COLON-ALIGNED
     x-codmon AT ROW 5.04 COL 53 NO-LABEL
     RADIO-SET-1 AT ROW 8 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 8.08 COL 58.57 COLON-ALIGNED
     B-impresoras AT ROW 8.92 COL 12.43
     RB-BEGIN-PAGE AT ROW 9.08 COL 58.57 COLON-ALIGNED
     b-archivo AT ROW 9.92 COL 12.43
     RB-END-PAGE AT ROW 10.08 COL 58.57 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 10.19 COL 16.43 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 11.77 COL 6
     B-cancela AT ROW 11.77 COL 20
     BUTTON-2 AT ROW 11.77 COL 34 WIDGET-ID 2
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 66.43 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .42 AT ROW 4.23 COL 51
     "Origen" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.15 COL 51
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 7.5 COL 1
     RECT-10 AT ROW 4.77 COL 51
     RECT-13 AT ROW 1.69 COL 51
     RECT-6 AT ROW 11.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Balance de Comprobación".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   FRAME-NAME                                                           */
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


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo DIALOG-1
ON CHOOSE OF b-archivo IN FRAME DIALOG-1 /* Archivos.. */
DO:
     SYSTEM-DIALOG GET-FILE RB-OUTPUT-FILE
        TITLE      "Archivo de Impresión ..."
        FILTERS    "Archivos Impresión (*.txt)"   "*.txt",
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
    DEF VAR TMP1 AS CHAR.
    DEF VAR TMP2 AS CHAR.
    DEF VAR I AS INTEGER.
    DEF VAR OK AS LOGICAL.

    ASSIGN x-codmon C-1 C-2 C-3
           X-CTA-INI X-CTA-FIN x-Div
           o-mayor.
    X-DIGITOS = INTEGER(C-1:SCREEN-VALUE).
    ASSIGN
        x-Cta-Ini = SUBSTRING(TRIM(x-Cta-Ini) + FILL("z",x-max-nivel), 1, x-max-nivel)
        x-Cta-Fin = SUBSTRING(TRIM(x-Cta-Fin) + FILL("9",x-max-nivel), 1, x-max-nivel).
    DISPLAY x-Cta-Ini x-Cta-Fin WITH FRAME {&FRAME-NAME}.
/*     if X-CTA-INI = "" then X-CTA-INI = FILL("0",x-max-nivel).                */
/*     if X-CTA-FIN = "" then X-CTA-FIN = FILL("9",x-max-nivel).                */
/*     if length(X-CTA-INI) < x-digitos THEN                                    */
/*        X-CTA-INI = substring(X-CTA-INI + FILL("0",x-digitos), 1, x-digitos). */
/*     if length(X-CTA-FIN) < x-digitos THEN                                    */
/*        X-CTA-FIN = substring(X-CTA-FIN + FILL("9",x-digitos), 1, x-digitos). */
    if X-CTA-INI > X-CTA-FIN THEN DO:
       Message "Cuentas invalidas"  skip
               "Cuentas Desde debe ser menor que" skip
               "Cuenta Hasta"
               VIEW-AS ALERT-BOX.
               
    END.    

    RUN bin/_mes.p ( INPUT C-2 , 1,  OUTPUT TMP1 ).
    RUN bin/_mes.p ( INPUT C-3 , 1,  OUTPUT TMP2 ).
    IF C-2 <> C-3 THEN  
        pinta-mes = "MES DE " + TMP1 + " A " + TMP2 + " DE " + STRING( s-periodo , "9999" ).
    ELSE 
        pinta-mes = "MES DE " + TMP1 + " DE " + STRING( s-periodo , "9999" ).
    
    IF X-DIV = "" THEN X-NOMDIV = "C O N S O L I D A D O".
    ELSE DO:
         FIND GN-DIVI WHERE GN-DIVI.CODCIA = S-cODcia AND
                            GN-DIVI.CODDIV = X-DIV
                        NO-LOCK NO-ERROR.
        IF AVAIL GN-DIVI THEN X-NOMDIV = GN-DIVI.DESDIV.
        ELSE DO:
                MESSAGE "División No Registrada" VIEW-AS ALERT-BOX
                        ERROR.
                APPLY "ENTRY" TO X-DIV IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.        
        END.                    
    END.                    
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 DIALOG-1
ON CHOOSE OF BUTTON-2 IN FRAME DIALOG-1 /* Button 2 */
DO:
    DEF VAR TMP1 AS CHAR.
    DEF VAR TMP2 AS CHAR.
    DEF VAR I AS INTEGER.
    DEF VAR OK AS LOGICAL.

    ASSIGN x-codmon C-1 C-2 C-3
           X-CTA-INI X-CTA-FIN x-Div
           o-mayor.
    X-DIGITOS = INTEGER(C-1:SCREEN-VALUE).
    ASSIGN
        x-Cta-Ini = SUBSTRING(TRIM(x-Cta-Ini) + FILL("z",x-max-nivel), 1, x-max-nivel)
        x-Cta-Fin = SUBSTRING(TRIM(x-Cta-Fin) + FILL("9",x-max-nivel), 1, x-max-nivel).
    DISPLAY x-Cta-Ini x-Cta-Fin WITH FRAME {&FRAME-NAME}.

/*     IF X-CTA-INI = "" then X-CTA-INI = FILL("0",x-max-nivel).                */
/*     IF X-CTA-FIN = "" then X-CTA-FIN = FILL("9",x-max-nivel).                */
/*     IF LENGTH(TRIM(X-CTA-INI)) < x-digitos THEN                              */
/*        X-CTA-INI = substring(X-CTA-INI + FILL("0",x-digitos), 1, x-digitos). */
/*     IF LENGTH(TRIM(X-CTA-FIN)) < x-digitos THEN                              */
/*        X-CTA-FIN = substring(X-CTA-FIN + FILL("9",x-digitos), 1, x-digitos). */

    if X-CTA-INI > X-CTA-FIN THEN DO:
       Message "Cuentas invalidas"  skip
               "Cuentas Desde debe ser menor que" skip
               "Cuenta Hasta"
               VIEW-AS ALERT-BOX.
               
    END.    

    RUN bin/_mes.p ( INPUT C-2 , 1,  OUTPUT TMP1 ).
    RUN bin/_mes.p ( INPUT C-3 , 1,  OUTPUT TMP2 ).
    IF C-2 <> C-3 THEN  
        pinta-mes = "MES DE " + TMP1 + " A " + TMP2 + " DE " + STRING( s-periodo , "9999" ).
    ELSE 
        pinta-mes = "MES DE " + TMP1 + " DE " + STRING( s-periodo , "9999" ).
    
    IF X-DIV = "" THEN X-NOMDIV = "C O N S O L I D A D O".
    ELSE DO:
         FIND GN-DIVI WHERE GN-DIVI.CODCIA = S-cODcia AND
                            GN-DIVI.CODDIV = X-DIV
                        NO-LOCK NO-ERROR.
        IF AVAIL GN-DIVI THEN X-NOMDIV = GN-DIVI.DESDIV.
        ELSE DO:
                MESSAGE "División No Registrada" VIEW-AS ALERT-BOX
                        ERROR.
                APPLY "ENTRY" TO X-DIV IN FRAME {&FRAME-NAME}.
                RETURN NO-APPLY.        
        END.                    
    END.                    
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-1 DIALOG-1
ON LEAVE OF C-1 IN FRAME DIALOG-1 /* Dígitos */
DO:
    ASSIGN X-DIGITOS = INTEGER(C-1:SCREEN-VALUE).
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


&Scoped-define SELF-NAME x-cta-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-fin DIALOG-1
ON F8 OF x-cta-fin IN FRAME DIALOG-1 /* Hasta la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-FIN DO:
    DEF VAR RECID-stack AS RECID.
    RUN cbd/q-ctas2.w(cb-codcia,"", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            SELF:SCREEN-VALUE = SUBSTRING(cb-ctas.CodCta,1,X-DIGITOS).
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-ini DIALOG-1
ON F8 OF x-cta-ini IN FRAME DIALOG-1 /* Desde la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-INI DO:
    DEF VAR RECID-stack AS RECID.
    RUN cbd/q-ctas2.w(cb-codcia,"", OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            SELF:SCREEN-VALUE = SUBSTRING(cb-ctas.CodCta,1,X-DIGITOS).
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Div DIALOG-1
ON F8 OF x-Div IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF X-DIV DO: 
   {CBD/H-DIVI01.I NO SELF}
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

ASSIGN O-MAYOR = YES.
ASSIGN C-1:LIST-ITEMS   = cb-niveles.
ASSIGN C-1:SCREEN-VALUE = ENTRY(1,cb-niveles).
IF AVAIL cb-cfga THEN DO:
   ASSIGN  X-Cta-INI:FORMAT    = cb-cfga.DETCFG.
   ASSIGN  X-CTA-FIN:FORMAT    = cb-cfga.DETCFG.
END.

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
  SESSION:IMMEDIATE-DISPLAY = l-immediate-display.
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
           CASE cb-cfgc.Metodo :
                WHEN "S" THEN DO :
                      IF ( x-Debe - x-Haber ) > 0 THEN DO :
                         x-perXfun = ABS(x-debe - x-Haber).
                         x-ganXfun = 0.
                      END.   
                      ELSE DO:
                         x-perXfun = 0.
                         x-ganXfun = ABS(x-debe - x-Haber).
                      END.      
                END.
                WHEN "D" THEN DO :                               
                      x-perXfun = x-debe.
                      x-ganXfun = 0.
                END.
                WHEN "H" THEN DO :                               
                      x-perXfun = 0.
                      x-ganXfun = x-haber.
                END. 
          END.           
        END.
        FIND FIRST cb-cfgc WHERE cb-cfgc.codcia = cb-codcia
                AND cb-cfgc.codcta = SUBSTR(cb-ctas.codcta,1,x-substr)
                AND cb-cfgc.codcfg = 3 NO-LOCK NO-ERROR.
        IF AVAILABLE cb-cfgc THEN DO:
           CASE cb-cfgc.Metodo :
                WHEN "S" THEN DO :
                     IF ( x-Debe - x-Haber ) > 0 THEN DO :
                          x-perXnat = ABS(x-debe - x-Haber).
                          x-ganXnat = 0.
                     END.
                     ELSE DO:
                          x-perXnat = 0.
                          x-ganXnat = ABS(x-debe - x-Haber).
                     END.     
                END.
                WHEN "D" THEN DO :                               
                      x-perXnat = x-debe.
                      x-ganXnat = 0.
                END.
                WHEN "H" THEN DO :                               
                      x-perXnat = 0.
                      x-ganXnat = x-haber.
                END. 
          END.      
        END.
    END.               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1  _DEFAULT-ENABLE
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
  DISPLAY C-1 x-Div O-mayor x-cta-ini x-cta-fin C-2 C-3 x-codmon RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RECT-10 RECT-13 RECT-6 C-1 x-Div O-mayor x-cta-ini 
         x-cta-fin C-2 C-3 x-codmon RADIO-SET-1 RB-NUMBER-COPIES B-impresoras 
         RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela BUTTON-2 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel DIALOG-1 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezados */
    DEF VAR N-ORIGEN AS CHAR FORMAT "X(30)" INIT "   P O R   M A Y O R".
     
    IF x-codmon = 1 THEN
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE 
        x-expres = "(EXPRESADO EN DOLARES)".

    IF O-MAYOR THEN N-ORIGEN = "  P O R   M A Y O R".
    ELSE            N-ORIGEN = "  P O R   D I A R I O".
    
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "R E P O R T E   D E   S A L D O S   A N U A L " + n-origen.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-NomDiv.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-tipobal.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = pinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-expres.
    /* set the column names for the Worksheet */
    iCount = iCount + 2.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cuenta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Enero".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Febrero".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marzo".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Abril".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mayo".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Junio".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Julio".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Agosto".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Setiembre".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Octubre".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Noviembre".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Diciembre".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL".

    DO i = 1 TO 13:
       x-saldo[i] = 0.
    END.

    DO WITH FRAME f-cab:
        ASSIGN
            x-saldo[1]    = 0
            x-saldo[2]    = 0
            x-saldo[3]    = 0
            x-saldo[4]    = 0
            x-saldo[5]    = 0
            x-saldo[6]    = 0
            x-saldo[7]    = 0
            x-saldo[8]    = 0
            x-saldo[9]    = 0
            x-saldo[10]    = 0
            x-saldo[11]    = 0
            x-saldo[12]    = 0
            x-saldo[13]    = 0.
        x-cuenta = "".
        FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
            AND LENGTH(TRIM(cb-ctas.codcta)) = x-digitos
            AND cb-ctas.codcta    >= X-CTA-INI 
            AND cb-ctas.codcta    <= X-CTA-FIN
            BREAK BY SUBSTRING(cb-ctas.codcta,1,2):

            IF FIRST-OF(SUBSTRING(cb-ctas.codcta,1,2)) THEN DO:
               x-cuenta = SUBSTRING(cb-ctas.codcta,1,2).
               FIND b-cb-ctas WHERE b-cb-ctas.CodCia = cb-CodCia 
                               AND  b-cb-ctas.codcta = x-cuenta
                             NO-LOCK NO-ERROR.
               iCount = iCount + 1.
               cColumn = STRING(iCount).
               cRange = "A" + cColumn.
               chWorkSheet:Range(cRange):Value = b-cb-ctas.codcta.
               cRange = "B" + cColumn.
               chWorkSheet:Range(cRange):Value = b-cb-ctas.nomcta.
            END.
            x-saldo[13] = 0.  
            DO I = C-2 TO C-3 :
                x-saldo[i] = 0. 
                IF O-MAYOR THEN                
                RUN cbd/cbd_imp.p ( INPUT  s-codcia, 
                                       cb-ctas.codcta,
                                       x-Div, 
                                       s-periodo, 
                                       I ,
                                       x-codmon,
                                OUTPUT impca1, 
                                OUTPUT impca2, 
                                OUTPUT impca3,
                                OUTPUT impca4, 
                                OUTPUT impca5, 
                                OUTPUT impca6 ).
                ELSE                
                RUN cbd/cbd_impa.p ( INPUT  s-codcia, 
                                       cb-ctas.codcta,
                                       x-Div, 
                                       s-periodo, 
                                       I,
                                       x-codmon,
                                       x-balance,
                                OUTPUT impca1, 
                                OUTPUT impca2, 
                                OUTPUT impca3,
                                OUTPUT impca4, 
                                OUTPUT impca5, 
                                OUTPUT impca6 ).                
                x-saldo[i]  = x-saldo[i]  + ( impca1 - impca2).
                x-saldo[13] = x-saldo[13] + ( impca1 - impca2).
            END.                                                                         
            IF LENGTH(TRIM(cb-ctas.codcta)) = x-digitos THEN DO: 
                ACCUM  x-saldo[1]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[2]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[3]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[4]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[5]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[6]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[7]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[8]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[9]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[10]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[11]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[12]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                ACCUM  x-saldo[13]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .

                ACCUMULATE x-saldo[1]  (TOTAL).
                ACCUMULATE x-saldo[2]  (TOTAL).
                ACCUMULATE x-saldo[3]  (TOTAL).
                ACCUMULATE x-saldo[4]  (TOTAL).
                ACCUMULATE x-saldo[5]  (TOTAL).
                ACCUMULATE x-saldo[6]  (TOTAL).
                ACCUMULATE x-saldo[7]  (TOTAL).
                ACCUMULATE x-saldo[8]  (TOTAL).
                ACCUMULATE x-saldo[9]  (TOTAL).
                ACCUMULATE x-saldo[10]  (TOTAL).
                ACCUMULATE x-saldo[11]  (TOTAL).
                ACCUMULATE x-saldo[12]  (TOTAL).
                ACCUMULATE x-saldo[13]  (TOTAL).
                iCount = iCount + 1.
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-ctas.codcta.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[1].
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[2].
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[3].
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[4].
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[5].
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[6].
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[7].
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[8].
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[9].
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[10].
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[11].
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[12].
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldo[13].
            END.
            IF LAST-OF(SUBSTRING(cb-ctas.codcta,1,2)) THEN DO:
              x-cuenta = SUBSTRING(cb-ctas.codcta,1,2).
              FIND b-cb-ctas WHERE b-cb-ctas.CodCia = cb-CodCia 
                              AND  b-cb-ctas.codcta = x-cuenta
                            NO-LOCK NO-ERROR.
              iCount = iCount + 1.
              cColumn = STRING(iCount).
              cRange = "B" + cColumn.
              chWorkSheet:Range(cRange):Value = "TOTAL CUENTA " + x-cuenta.
              cRange = "C" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[1]).
              cRange = "D" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[2]).
              cRange = "E" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[3]).
              cRange = "F" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[4]).
              cRange = "G" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[5]).
              cRange = "H" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[6]).
              cRange = "I" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[7]).
              cRange = "J" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[8]).
              cRange = "K" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[9]).
              cRange = "L" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[10]).
              cRange = "M" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[11]).
              cRange = "N" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[12]).
              cRange = "P" + cColumn.
              chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[13]).
              iCount = iCount + 1.
            END.
        END.
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "TOTAL GENERAL -------->".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[1]).
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[2]).
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[3]).
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[4]).
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[5]).
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[6]).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[7]).
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[8]).
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[9]).
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[10]).
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[11]).
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[12]).
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = (ACCUM TOTAL  x-saldo[13]).
    END.
    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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
    DEF VAR N-ORIGEN AS CHAR FORMAT "X(30)" INIT "   P O R   M A Y O R".
     
    P-largo = 66.
    P-Ancho = 210.
    P-Config = P-15cpi.
   
    IF x-codmon = 1 THEN
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE 
        x-expres = "(EXPRESADO EN DOLARES)".

    IF O-MAYOR THEN N-ORIGEN = "  P O R   M A Y O R".
    ELSE            N-ORIGEN = "  P O R   D I A R I O".
    
    DO i = 1 TO 13:
       x-saldo[i] = 0.
    END.
    
    
    
    DEFINE FRAME f-cab
        cb-ctas.codcta
        cb-ctas.nomcta
        x-saldo[1] COLUMN-LABEL "Enero"
        x-saldo[2] COLUMN-LABEL "Febrero"
        x-saldo[3] COLUMN-LABEL "Marzo"
        x-saldo[4] COLUMN-LABEL "Abril"
        x-saldo[5] COLUMN-LABEL "Mayo"
        x-saldo[6] COLUMN-LABEL "Junio"
        x-saldo[7] COLUMN-LABEL "Julio"
        x-saldo[8] COLUMN-LABEL "Agosto"
        x-saldo[9]  COLUMN-LABEL "Septiembre"
        x-saldo[10] COLUMN-LABEL "Octubre"
        x-saldo[11] COLUMN-LABEL "Noviembre"
        x-saldo[12] COLUMN-LABEL "Diciembre"
        x-saldo[13] COLUMN-LABEL "TOTAL"
        HEADER
        empresas.nomcia
        "R E P O R T E   D E   S A L D O S   A N U A L " TO 116 N-ORIGEN
        "FECHA : " TO 199 TODAY TO 208
        SKIP
        x-NomDiv AT 85
        SKIP
        x-dircia
        x-tipobal AT 85
        "PAGINA :" TO 198 c-pagina FORMAT "ZZ9" TO 208 
        SKIP
        pinta-mes AT 85
        SKIP
        x-expres  AT 85
        SKIP(2)
        WITH WIDTH 280 NO-BOX DOWN STREAM-IO. 

    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-tipobal, 40 , OUTPUT x-tipobal).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-NomDiv,  40 , OUTPUT x-NomDiv ).
    DO WITH FRAME f-cab:
                     assign
                     x-saldo[1]    = 0
                     x-saldo[2]    = 0
                     x-saldo[3]    = 0
                     x-saldo[4]    = 0
                     x-saldo[5]    = 0
                     x-saldo[6]    = 0
                     x-saldo[7]    = 0
                     x-saldo[8]    = 0
                     x-saldo[9]    = 0
                     x-saldo[10]    = 0
                     x-saldo[11]    = 0
                     x-saldo[12]    = 0
                     x-saldo[13]    = 0.
    x-cuenta = "".
    {&NEW-PAGE}. 
    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
                            AND LENGTH(TRIM(cb-ctas.codcta)) = x-digitos
                            AND cb-ctas.codcta    >= X-CTA-INI 
                            AND cb-ctas.codcta    <= X-CTA-FIN
                            BREAK BY SUBSTRING(cb-ctas.codcta,1,2) ON ERROR UNDO, LEAVE:
                            
            IF FIRST-OF(SUBSTRING(cb-ctas.codcta,1,2)) THEN DO:
               x-cuenta = SUBSTRING(cb-ctas.codcta,1,2).
               FIND b-cb-ctas WHERE b-cb-ctas.CodCia = cb-CodCia 
                               AND  b-cb-ctas.codcta = x-cuenta
                             NO-LOCK NO-ERROR.
              
               DISPLAY STREAM report  b-cb-ctas.codcta  @ cb-ctas.codcta
                                      b-cb-ctas.nomcta  @ cb-ctas.nomcta 
                                     WITH FRAME f-cab.
               DOWN STREAM report 1 WITH FRAME f-cab.
              
            END.

           x-saldo[13] = 0.  
           DO I = C-2 TO C-3 :
            x-saldo[i] = 0. 
            IF O-MAYOR THEN                
            RUN cbd/cbd_imp.p ( INPUT  s-codcia, 
                                   cb-ctas.codcta,
                                   x-Div, 
                                   s-periodo, 
                                   I ,
                                   x-codmon,
                            OUTPUT impca1, 
                            OUTPUT impca2, 
                            OUTPUT impca3,
                            OUTPUT impca4, 
                            OUTPUT impca5, 
                            OUTPUT impca6 ).
            ELSE                
            RUN cbd/cbd_impa.p ( INPUT  s-codcia, 
                                   cb-ctas.codcta,
                                   x-Div, 
                                   s-periodo, 
                                   I,
                                   x-codmon,
                                   x-balance,
                            OUTPUT impca1, 
                            OUTPUT impca2, 
                            OUTPUT impca3,
                            OUTPUT impca4, 
                            OUTPUT impca5, 
                            OUTPUT impca6 ).                


            x-saldo[i]  = x-saldo[i]  + ( impca1 - impca2).
            x-saldo[13] = x-saldo[13] + ( impca1 - impca2).
           END.                                                                         
             {&NEW-PAGE}. 
             IF LENGTH(TRIM(cb-ctas.codcta)) = x-digitos THEN DO: 
                 ACCUM  x-saldo[1]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[2]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[3]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[4]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[5]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[6]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[7]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[8]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[9]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[10]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[11]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[12]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .
                 ACCUM  x-saldo[13]  (SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2)) .

                 ACCUMULATE x-saldo[1]  (TOTAL).
                 ACCUMULATE x-saldo[2]  (TOTAL).
                 ACCUMULATE x-saldo[3]  (TOTAL).
                 ACCUMULATE x-saldo[4]  (TOTAL).
                 ACCUMULATE x-saldo[5]  (TOTAL).
                 ACCUMULATE x-saldo[6]  (TOTAL).
                 ACCUMULATE x-saldo[7]  (TOTAL).
                 ACCUMULATE x-saldo[8]  (TOTAL).
                 ACCUMULATE x-saldo[9]  (TOTAL).
                 ACCUMULATE x-saldo[10]  (TOTAL).
                 ACCUMULATE x-saldo[11]  (TOTAL).
                 ACCUMULATE x-saldo[12]  (TOTAL).
                 ACCUMULATE x-saldo[13]  (TOTAL).

                 DISPLAY STREAM report  cb-ctas.codcta 
                                        cb-ctas.nomcta 
                                        x-saldo[1] WHEN (x-saldo[1]     <> 0)
                                        x-saldo[2] WHEN (x-saldo[2]     <> 0)
                                        x-saldo[3] WHEN (x-saldo[3]     <> 0)
                                        x-saldo[4] WHEN (x-saldo[4]     <> 0)
                                        x-saldo[5] WHEN (x-saldo[5]     <> 0)
                                        x-saldo[6] WHEN (x-saldo[6]     <> 0)
                                        x-saldo[7] WHEN (x-saldo[7]     <> 0)
                                        x-saldo[8] WHEN (x-saldo[8]     <> 0)
                                        x-saldo[9] WHEN (x-saldo[9]     <> 0)
                                        x-saldo[10] WHEN (x-saldo[10]     <> 0)
                                        x-saldo[11] WHEN (x-saldo[11]     <> 0)
                                        x-saldo[12] WHEN (x-saldo[12]     <> 0)
                                        x-saldo[13] WHEN (x-saldo[13]     <> 0)
                             WITH FRAME f-cab.
             END.
             DOWN STREAM report 1 WITH FRAME f-cab.
             IF LAST-OF(SUBSTRING(cb-ctas.codcta,1,2)) THEN DO:
               x-cuenta = SUBSTRING(cb-ctas.codcta,1,2).
               FIND b-cb-ctas WHERE b-cb-ctas.CodCia = cb-CodCia 
                               AND  b-cb-ctas.codcta = x-cuenta
                             NO-LOCK NO-ERROR.
               UNDERLINE STREAM report  x-saldo[1]
                                        x-saldo[2]
                                        x-saldo[3]
                                        x-saldo[4]
                                        x-saldo[5]
                                        x-saldo[6]
                                        x-saldo[7]
                                        x-saldo[8]
                                        x-saldo[9]
                                        x-saldo[10]
                                        x-saldo[11]
                                        x-saldo[12]
                                        x-saldo[13]
               WITH FRAME f-cab.                    
               DOWN STREAM report 1 WITH FRAME f-cab.
               DISPLAY STREAM report  "TOTAL CUENTA " + x-cuenta @ cb-ctas.nomcta
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[1]) @ x-saldo[1] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[2]) @ x-saldo[2] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[3]) @ x-saldo[3] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[4]) @ x-saldo[4] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[5]) @ x-saldo[5] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[6]) @ x-saldo[6] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[7]) @ x-saldo[7] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[8]) @ x-saldo[8] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[9]) @ x-saldo[9] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[10]) @ x-saldo[10] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[11]) @ x-saldo[11] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[12]) @ x-saldo[12] 
                      (ACCUM SUB-TOTAL BY SUBSTRING(cb-ctas.codcta,1,2) x-saldo[13]) @ x-saldo[13] 
               WITH FRAME f-cab.      
               DOWN STREAM report 2 WITH FRAME f-cab.
       
             END.
             
             
             
        END.
        UNDERLINE STREAM report x-saldo[1]
                                x-saldo[2]
                                x-saldo[3]
                                x-saldo[4]
                                x-saldo[5]
                                x-saldo[6]
                                x-saldo[7]
                                x-saldo[8]
                                x-saldo[9]
                                x-saldo[10]
                                x-saldo[11]
                                x-saldo[12]
                                x-saldo[13]
        WITH FRAME f-cab.                    
        DOWN STREAM report 1 WITH FRAME f-cab.
        DISPLAY STREAM report  "TOTAL GENERAL -------->" @ cb-ctas.nomcta
            (ACCUM TOTAL  x-saldo[1]) @ x-saldo[1] 
            (ACCUM TOTAL  x-saldo[2]) @ x-saldo[2] 
            (ACCUM TOTAL  x-saldo[3]) @ x-saldo[3] 
            (ACCUM TOTAL  x-saldo[4]) @ x-saldo[4] 
            (ACCUM TOTAL  x-saldo[5]) @ x-saldo[5] 
            (ACCUM TOTAL  x-saldo[6]) @ x-saldo[6] 
            (ACCUM TOTAL  x-saldo[7]) @ x-saldo[7] 
            (ACCUM TOTAL  x-saldo[8]) @ x-saldo[8] 
            (ACCUM TOTAL  x-saldo[9]) @ x-saldo[9] 
            (ACCUM TOTAL  x-saldo[10]) @ x-saldo[10] 
            (ACCUM TOTAL  x-saldo[11]) @ x-saldo[11] 
            (ACCUM TOTAL  x-saldo[12]) @ x-saldo[12] 
            (ACCUM TOTAL  x-saldo[13]) @ x-saldo[13] 
        WITH FRAME f-cab.      
        
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
  Purpose: Configura los codigos de escape de impresión
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

