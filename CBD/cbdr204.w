&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*
    @PRINTER2.W    VERSION 1.0
*/    
DEFINE STREAM report.
DEFINE BUFFER B-Cuentas FOR cb-ctas.

/* VARIABLES GENERALES :  IMPRESION,SISTEMA,MODULO,USUARIO */
DEFINE VARIABLE P-Largo    AS INTEGER NO-UNDO.
DEFINE VARIABLE P-Ancho    AS INTEGER NO-UNDO.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9" NO-UNDO.
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9" NO-UNDO.
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)" NO-UNDO.

DEFINE VARIABLE P-detalle  LIKE TermImp.Detalle NO-UNDO.
DEFINE VARIABLE P-comando  LIKE TermImp.Comando NO-UNDO.
DEFINE VARIABLE P-device   LIKE TermImp.Device NO-UNDO.
DEFINE VARIABLE P-name     LIKE TermImp.p-name NO-UNDO.

DEFINE VARIABLE P-Reset    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Flen     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-6lpi     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-8lpi     AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-10cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-12cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-15cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-20cpi    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Landscap AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Portrait AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-DobleOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-DobleOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-BoldOn   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-BoldOff  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-UlineOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-UlineOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-ItalOn   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-ItalOff  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SuperOn  AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SuperOff AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SubOn    AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-SubOff   AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Proptnal AS CHARACTER NO-UNDO.
DEFINE VARIABLE P-Lpi      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-immediate-display AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(150)" NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5".

DEFINE               VARIABLE x-max-nivel     as integer.
define               variable x-digitos       as integer.
x-max-nivel = integer(entry(num-entries(cb-niveles),cb-niveles)).
def var x-codope as char.
DEFINE        VARIABLE P-config  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina " NO-UNDO.
DEFINE        VARIABLE c-Copias  AS INTEGER NO-UNDO.
DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
DEFINE        VARIABLE Ult-Nivel   AS INTEGER NO-UNDO.
DEFINE        VARIABLE Max-Digitos AS INTEGER NO-UNDO.
    

DEFINE        VARIABLE cb-codcia AS INTEGER NO-UNDO.
DEFINE        VARIABLE pv-codcia AS INTEGER NO-UNDO.
DEFINE        VARIABLE cl-codcia AS INTEGER NO-UNDO.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO.


/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE


&GLOBAL-DEFINE CONDICION substring(cb-dmov.Codcta ,1 , x-digitos)  
 



/*VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE x-conreg   AS INTEGER   INITIAL 0.
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-titulo   AS CHARACTER FORMAT "X(80)" NO-UNDO 
    INIT "RESUMEN DEL MAYOR GENERAL".

DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.
DEFINE VARIABLE x-NomCta   LIKE cb-ctas.NomCta NO-UNDO.
DEFINE VARIABLE x-NomOpe   LIKE cb-oper.NomOpe NO-UNDO.
DEFINE VARIABLE x-NomDiv   LIKE cb-auxi.Nomaux    NO-UNDO.


DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "C a r g o s" NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "A b o n o s" NO-UNDO.
                           
DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL      "S a l d o!Deudor" NO-UNDO.
DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "S a l d o!Acreedor" NO-UNDO.
                           
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 9.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".
cb-codcia = 0.
FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.







/*reglas de desicion */

DEF VAR R1 AS LOGICAL INITIAL FALSE.
DEF VAR R2 AS LOGICAL INITIAL FALSE.
DEF VAR R3 AS LOGICAL INITIAL FALSE.
DEF VAR R4 AS LOGICAL INITIAL FALSE.

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

define temp-table t-oper 
    FIELD codope as char format "X(3)" column-label "Código"
    FIELD nomope as char format "X(35)" column-label "O p e r a c i o n e s "
    FIELD caja   as logical format "Si/No" COLUMN-LABEL "Caja!Bancos".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-oper

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 codope nomope caja   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH t-oper.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 t-oper
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 t-oper


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-13 x-codmon q-div q-ope o-auto ~
RECT-5 RADIO-SET-1 RECT-6 B-impresoras B-imprime C-3 C-1 C-2 x-Div ~
x-cta-ini x-cta-fin r-oper BROWSE-1 B-cancela RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS x-codmon q-div q-ope o-auto RADIO-SET-1 ~
C-3 C-1 C-2 x-Div x-cta-ini x-cta-fin r-oper RB-NUMBER-COPIES RB-BEGIN-PAGE ~
RB-END-PAGE 

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
     SIZE 11 BY .85.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY .85.

DEFINE VARIABLE C-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-3 AS CHARACTER FORMAT "9":U 
     LABEL "Dígitos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
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
     SIZE 43.29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-cta-fin AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-cta-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE r-oper AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todas las operaciones", 1,
"Operaciones de Caja y Bancos", 2,
"Selectivo", 3
     SIZE 30 BY 2.15 NO-UNDO.

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
     SIZE 9 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 11 BY 1.88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83.57 BY 8.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83.72 BY 3.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 83.72 BY 1.46.

DEFINE VARIABLE o-auto AS LOGICAL INITIAL yes 
     LABEL "Omitir Automaticas" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

DEFINE VARIABLE q-div AS LOGICAL INITIAL no 
     LABEL "Quiebre por División" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.

DEFINE VARIABLE q-ope AS LOGICAL INITIAL no 
     LABEL "Quiebre por Operación" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      t-oper SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 DIALOG-1 _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      codope
nomope
caja
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 39.86 BY 5.12
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-codmon AT ROW 2.08 COL 4 NO-LABEL
     q-div AT ROW 3.96 COL 3
     q-ope AT ROW 4.77 COL 3
     o-auto AT ROW 5.58 COL 3
     RADIO-SET-1 AT ROW 9.88 COL 2 NO-LABEL
     B-impresoras AT ROW 10.88 COL 15
     b-archivo AT ROW 11.88 COL 15
     B-imprime AT ROW 13.46 COL 18
     RB-OUTPUT-FILE AT ROW 11.88 COL 19 COLON-ALIGNED NO-LABEL
     C-3 AT ROW 3.69 COL 31.86 COLON-ALIGNED
     C-1 AT ROW 4.5 COL 31.86 COLON-ALIGNED
     C-2 AT ROW 5.31 COL 31.86 COLON-ALIGNED
     x-Div AT ROW 6.12 COL 31.86 COLON-ALIGNED
     x-cta-ini AT ROW 6.92 COL 31.86 COLON-ALIGNED
     x-cta-fin AT ROW 7.73 COL 31.86 COLON-ALIGNED
     r-oper AT ROW 1.31 COL 44.43 NO-LABEL
     BROWSE-1 AT ROW 3.62 COL 44.29
     B-cancela AT ROW 13.42 COL 54.29
     RB-NUMBER-COPIES AT ROW 10.31 COL 75.57 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 11.08 COL 75.57 COLON-ALIGNED
     RB-END-PAGE AT ROW 11.88 COL 75.57 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .38 AT ROW 1.27 COL 3
     RECT-13 AT ROW 1.81 COL 3
     " Configuraci¾n de Impresi¾n" VIEW-AS TEXT
          SIZE 83.72 BY .62 AT ROW 9.08 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 9.62 COL 1
     RECT-6 AT ROW 13.12 COL 1
     SPACE(0.00) SKIP(0.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Análisis de Saldos".


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
                                                                        */
/* BROWSE-TAB BROWSE-1 r-oper DIALOG-1 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY BROWSE-1 FOR EACH t-oper.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Análisis de Saldos */
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
        ASSIGN x-cta-ini 
               x-cta-fin
               x-codmon
               x-div
               q-div
               q-ope
               c-1
               c-2
               c-3
               o-auto
               R-oper.
    X-DIGITOS = INTEGER(C-3:SCREEN-VALUE).
    if X-CTA-INI = "" then X-CTA-INI = FILL("0",x-max-nivel).
    if X-CTA-FIN = "" then X-CTA-FIN = FILL("9",x-max-nivel). 
    if length(X-CTA-INI) < x-digitos THEN 
       X-CTA-INI = substring(X-CTA-INI + FILL("0",x-digitos), 1, x-digitos).
    if length(X-CTA-FIN) < x-digitos THEN 
       X-CTA-FIN = substring(X-CTA-FIN + FILL("9",x-digitos), 1, x-digitos).
        IF x-cta-fin < x-cta-ini 
        THEN DO:
            BELL.
            MESSAGE "La cuenta fin es menor" SKIP
                    "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO x-cta-ini.
            RETURN NO-APPLY.
        END.
        IF x-div <> "" AND
             NOT CAN-FIND(FIRST GN-DIVI WHERE GN-DIVI.codcia = S-codcia 
                                          AND GN-DIVI.codDIV = x-div)
        THEN DO:
            BELL.
            MESSAGE "División no registrada"
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO x-div.
            RETURN NO-APPLY.
        END.
    x-codope = "".
    CASE R-OPER :
        WHEN 1 THEN FOR EACH T-OPER :
                     x-codope = x-codope + t-oper.codope + ",".
                    END.
        WHEN 2 THEN FOR EACH T-OPER where t-oper.caja :
                     x-codope = x-codope + t-oper.codope + ",".
                    END.
        
        
        WHEN 3 THEN 
               DO i = 1 TO BROWSE-1:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} :
                  OK  = BROWSE-1:FETCH-SELECTED-ROW(i).
               IF OK  THEN x-codope = x-codope + t-oper.codope + ",".
               END.           
     
    
    END CASE .
    IF LENGTH(X-codope) < 3 THEN DO:
       MESSAGE "Operación no valida" 
       VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    X-codope = SUBSTRING (X-codope , 1 , LENGTH(X-codope) - 1 ).
       
    RUN bin/_mes.p ( INPUT C-1 , 1,  OUTPUT TMP1 ).
    RUN bin/_mes.p ( INPUT C-2 , 1,  OUTPUT TMP2 ).
    IF C-1 <> C-2 THEN  
        pinta-mes = "MES DE " + TMP1 + " A " + TMP2 + " DE " + STRING( s-periodo , "9999" ).
    ELSE 
        pinta-mes = "MES DE " + TMP1 + " DE " + STRING( s-periodo , "9999" ).
    
    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "EXPRESADO EN NUEVOS SOLES".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = " EXPRESADO EN DOLARES".
    END.
     x-titulo = "A N A L I S I S   D E  S A L D O S ".
    CASE R-OPER :
         WHEN 1 THEN x-expres =  "(TODAS LAS OPERACIONES " + X-expres + ")".
         WHEN 2 THEN do:
                x-titulo = "F L U J O   D E   C A J A   E J E C U T A D O".
                x-expres = "(" + x-expres + ")".
                end.
         WHEN 3 THEN x-expres =  "(OPERACIONES: " + x-codope + " " + X-expres + ")".       
    END CASE.
    RUN bin/_centrar.p ( INPUT pinta-mes, 130 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-moneda,  130 , OUTPUT x-moneda ).
    RUN bin/_centrar.p ( INPUT x-expres,  130 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-titulo,  130 , OUTPUT x-titulo ).
    P-largo  = 66.
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


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DIALOG-1
ON VALUE-CHANGED OF BROWSE-1 IN FRAME DIALOG-1
DO:
    r-oper:screen-value = "3".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-3 DIALOG-1
ON LEAVE OF C-3 IN FRAME DIALOG-1 /* Dígitos */
DO:
    ASSIGN X-DIGITOS = INTEGER(C-1:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-oper DIALOG-1
ON VALUE-CHANGED OF r-oper IN FRAME DIALOG-1
DO:
   if self:screen-value = "2" then do:
       o-auto = yes.
       display o-auto with frame {&FRAME-NAME}.
   end.
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
DO:
   DEF VAR RECID-stack AS RECID.
    RUN cbd/q-ctas2.w(cb-codcia,SELF:SCREEN-VALUE, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF AVAIL cb-ctas
        THEN DO:
            SELF:SCREEN-VALUE = cb-ctas.CodCta.
         /*   DISPLAY SELF:SCREEN-VALUE WITH FRAME {&FRAME-NAME}.*/
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-ini DIALOG-1
ON F8 OF x-cta-ini IN FRAME DIALOG-1 /* Desde la Cuenta */
DO: 
    DEF VAR RECID-stack AS RECID.
    RUN cbd/q-ctas2.w(cb-codcia,SELF:SCREEN-VALUE, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        FIND cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF AVAIL cb-ctas
        THEN DO:
            SELF:SCREEN-VALUE = cb-ctas.CodCta.
            
           /* DISPLAY SELF:SCREEN-VALUE WITH FRAME {&FRAME-NAME}.*/
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
    END.
    RETURN NO-APPLY.
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

ASSIGN C-1 = s-NroMes
       C-2 = s-NroMes.
ASSIGN C-3:LIST-ITEMS   = cb-niveles.
ASSIGN C-3:SCREEN-VALUE = ENTRY(1,cb-niveles).
IF AVAIL cb-cfga THEN DO:
   ASSIGN  x-cta-ini:FORMAT    = cb-cfga.DETCFG.
   ASSIGN  x-cta-fin:FORMAT    = cb-cfga.DETCFG.
END.
FOR EACH cb-oper WHERE cb-oper.CODCIA = cb-codcia 
                           NO-LOCK:
    CREATE T-OPER.
    ASSIGN T-OPER.CODOPE = cb-oper.CODOPE
           T-OPER.NOMOPE = cb-oper.NOMOPE
           T-OPER.CAJA   = cb-oper.resume.


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
  STATUS INPUT OFF.  
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
  DISPLAY x-codmon q-div q-ope o-auto RADIO-SET-1 C-3 C-1 C-2 x-Div x-cta-ini 
          x-cta-fin r-oper RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-13 x-codmon q-div q-ope o-auto RECT-5 RADIO-SET-1 RECT-6 
         B-impresoras B-imprime C-3 C-1 C-2 x-Div x-cta-ini x-cta-fin r-oper 
         BROWSE-1 B-cancela RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilita DIALOG-1 
PROCEDURE habilita :
DO WITH FRAME {&FRAME-NAME} :
{&OPEN-QUERY-{&BROWSE-NAME}}
{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
GET FIRST {&BROWSE-NAME}.
DO WHILE AVAIL T-OPER :
   IF {&BROWSE-NAME}:SELECT-FOCUSED-ROW( ) THEN .

END.
END.
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
    
    P-largo  = 88. /* En el caso de 88 lineas por página usando 8 lpi ( P-8lpi )
                      hay que definir en el triger "CHOOSE" de b-imprime en 66 
                      Líneas por página y aqui en 88.
                      Si se usa 6 lpi ( Default ) solo basta definir en
                      b-imprime.
                      ** OJO ** en b-imprime el P-largo configura a la impresora
                      a saltar en ese largo por página
                      */
                       
    P-Config = P-20cpi + P-8lpi.
    x-Raya   = FILL("-", P-Ancho).

    /*DEFINICION DE LAS REGLAS DE DECICION */
    R1 =       Q-DIV   AND         Q-OPE .
    R2 =  (NOT Q-DIV)  AND    (NOT Q-OPE).
    R3 =       Q-DIV   AND    (NOT Q-OPE).
    R4 =  (NOT Q-DIV)  AND         Q-OPE .
    IF R1 THEN RUN PROCESO1.
    IF R2 THEN RUN PROCESO2.
    IF R3 THEN RUN PROCESO3.
    IF R4 THEN RUN PROCESO4. 
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO1 DIALOG-1 
PROCEDURE PROCESO1 :
/* R1 =       Q-DIV   AND         Q-OPE . */
 x-conreg = 0.
 
 DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Div."
        cb-dmov.codope LABEL "Cod!Ope"
        cb-dmov.codcta LABEL "Cuenta"  
        x-nomcta       LABEL "         D e s c r i p c i ó n"
        x-debe
        x-haber
        x-deudor  
        x-acreedor
        HEADER
        empresas.nomcia
        "FECHA : " TO 115 TODAY TO 123
        SKIP
        empresas.direccion
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9"  TO 123  
        SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123  
        SKIP(2)
        x-titulo   FORMAT "X(130)"   
        SKIP    
        pinta-mes  FORMAT "X(130)"
        SKIP
        x-expres   FORMAT "X(130)"
        SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
    P-Ancho  = FRAME f-cab:WIDTH.        

DO WITH FRAME F-CAB :

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                        AND cb-dmov.periodo = s-periodo 
                        AND cb-dmov.nromes  >= c-1
                        AND cb-dmov.nromes  <= c-2
                        AND cb-dmov.codcta >= x-cta-ini
                        AND cb-dmov.codcta <= x-cta-fin
                        AND cb-dmov.coddiv BEGINS (x-div)
                        AND lookup (cb-dmov.codope ,x-codope ) > 0
            BREAK BY cb-dmov.coddiv            
                  BY cb-dmov.codope
                  BY {&CONDICION} 
                  ON ERROR UNDO, LEAVE:
        IF FIRST-OF (cb-dmov.coddiv)  THEN DO:
            X-nomdiv = "".           
            FIND GN-DIVI WHERE  GN-DIVI.CODCIA = S-codcia AND
                                GN-DIVI.CODDIV = cb-dmov.CODDIV
                                NO-LOCK NO-ERROR.
            {&NEW-PAGE}.
            IF AVAIL GN-DIVI THEN x-nomdiv =  GN-DIVI.DESDIV.
               DISPLAY STREAM report 
                          cb-dmov.codDIV 
                          x-nomdiv        @ x-nomcta
                WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.   
            {&NEW-PAGE}.
             UNDERLINE  STREAM report 
                          cb-dmov.codDIV 
                          x-nomcta
             WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.   
        END.
                      
        IF FIRST-OF (cb-dmov.codope) THEN DO:
            {&NEW-PAGE}.
            x-nomope = "".
            FIND cb-oper WHERE cb-oper.CODCIA = cb-codcia AND
                                  cb-oper.CODOPE = cb-dmov.CODOPE
                                  NO-LOCK NO-ERROR.
            IF AVAIL cb-oper THEN x-nomope = cb-oper.NOMOPE.                     
            DISPLAY STREAM report  cb-dmov.codope           
                                   x-nomope        @ x-nomcta
            WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.    
            UNDERLINE STREAM report  cb-dmov.codope           
                                     x-nomcta 
                                     WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.    
        END.
        IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
        IF NOT tpomov THEN DO:
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
                x-haber = 0.
            END.
            WHEN 3 THEN DO:
                x-debe  = ImpMn3.
                x-haber = 0.
            END.
            END CASE.
        END.
        ELSE DO:      
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn2.
            END.
            WHEN 3 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn3.
            END.
            END CASE.            
        END.
        {&NEW-PAGE}.
        IF  (x-debe <> ? AND x-haber <> ?)
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY {&CONDICION} ).
            ACCUMULATE x-haber (SUB-TOTAL BY {&CONDICION}).
            
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.coddiv).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.coddiv).
            
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.codope).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.codope).
            
            ACCUMULATE x-debe  (TOTAL).
            ACCUMULATE x-haber (TOTAL).
            x-conreg = x-conreg + 1.     
        END.
                    
        IF LAST-OF ({&CONDICION}) AND x-conreg > 0 THEN DO:
           x-debe      = (ACCUM SUB-TOTAL BY {&CONDICION} x-debe    ).
           x-haber     = (ACCUM SUB-TOTAL BY {&CONDICION} x-haber   ).
           x-deudor = x-debe - x-haber.
           x-acreedor = 0.
           IF x-deudor < 0 THEN DO:
                   x-acreedor = - x-deudor.
                   x-deudor   = 0.
           END.
           ACCUMULATE x-deudor   (SUB-TOTAL BY cb-dmov.coddiv).
           ACCUMULATE x-acreedor (SUB-TOTAL BY cb-dmov.coddiv).
            
           ACCUMULATE x-deudor   (SUB-TOTAL BY cb-dmov.codope).
           ACCUMULATE x-acreedor (SUB-TOTAL BY cb-dmov.codope).
           x-codcta = {&CONDICION}.
           FIND cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                              cb-ctas.CODCTA = {&CONDICION}
                              NO-LOCK NO-ERROR.
           IF AVAIL cb-ctas THEN X-NOMCTA = cb-ctas.NOMCTA.                   
           
           DISPLAY STREAM report 
                {&CONDICION} @ cb-dmov.codcta
                x-nomcta                                     
                x-debe      when  x-debe     <> 0
                x-haber     when  x-haber    <> 0
                x-deudor    when  x-deudor   <> 0
                x-acreedor  when  x-acreedor <> 0
                WITH FRAME f-cab.
             DOWN STREAM REPORT WITH FRAME F-CAB.    
        END.
        
        IF LAST-OF(cb-dmov.codope) THEN DO:
            UNDERLINE STREAM REPORT
                cb-dmov.codope 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   " + x-nomope + "  ***".
            x-debe     = ACCUM SUB-TOTAL BY cb-dmov.codope x-debe. 
            x-haber    = ACCUM SUB-TOTAL BY cb-dmov.codope x-haber.
            x-deudor   = ACCUM SUB-TOTAL BY cb-dmov.codope x-deudor.
            x-acreedor = ACCUM SUB-TOTAL BY cb-dmov.codope x-acreedor.
            DISPLAY STREAM report 
                    cb-dmov.codope
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                cb-dmov.codope 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.
        END.
        IF LAST-OF(cb-dmov.coddiv) THEN DO:
            x-nomdiv = "***  T O T A L   " + x-nomdiv + "  ***".
            UNDERLINE STREAM REPORT
                cb-dmov.coddiv 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-debe     = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-debe.
            x-haber    = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-haber.
            x-deudor   = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-deudor.
            x-acreedor = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-acreedor.
            DISPLAY STREAM report
                    cb-dmov.coddiv
                    x-nomdiv                        @ x-nomcta 
                    x-debe     WHEN X-DEBE     <> 0   
                    x-haber    WHEN X-HABER    <> 0   
                    x-deudor   WHEN X-DEUDOR   <> 0   
                    x-acreedor WHEN X-ACREEDOR <> 0 
                WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME F-CAB.                
            UNDERLINE STREAM REPORT
                cb-dmov.coddiv 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.
        END.        
    END.
/*IMPRIMIENTO TOTALES  */

   
    UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   G E N E R A L   ***".
            x-debe     = ACCUM TOTAL  x-debe. 
            x-haber    = ACCUM TOTAL  x-haber.
            x-deudor   = x-debe - x-haber.
            x-acreedor = 0.
            IF x-deudor < 0 THEN DO:
               x-acreedor = - x-deudor.
               x-deudor   = 0.
            END.
             
            DISPLAY STREAM report 
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.

END. /* FIN DEL DO WITH FRAME F-CAB */   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso2 DIALOG-1 
PROCEDURE proceso2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* R2 =  (NOT Q-DIV)  AND    (NOT Q-OPE).*/
  x-conreg = 0.
 DEFINE FRAME f-cab
        cb-dmov.codcta LABEL "Cuenta"  
        x-nomcta       LABEL "         D e s c r i p c i ó n"
        x-debe
        x-haber
        x-deudor  
        x-acreedor
        HEADER
        empresas.nomcia
        "FECHA : " TO 115 TODAY TO 123
        SKIP
        empresas.direccion
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9" TO 123  
        SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123  
        SKIP(2)
        x-titulo   FORMAT "X(130)"   
        SKIP    
        pinta-mes  FORMAT "X(130)"
        SKIP
        x-expres   FORMAT "X(130)"
        SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
    P-Ancho  = FRAME f-cab:WIDTH.        

DO WITH FRAME F-CAB :

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                        AND cb-dmov.periodo = s-periodo 
                        AND cb-dmov.nromes  >= c-1
                        AND cb-dmov.nromes  <= c-2
                        AND cb-dmov.codcta >= x-cta-ini
                        AND cb-dmov.codcta <= x-cta-fin
                        AND cb-dmov.coddiv BEGINS (x-div)
                        AND lookup (cb-dmov.codope ,x-codope ) > 0                          
            BREAK BY {&CONDICION} 
            ON ERROR UNDO, LEAVE:
         IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
        IF NOT tpomov THEN DO:
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
                x-haber = 0.
            END.
            WHEN 3 THEN DO:
                x-debe  = ImpMn3.
                x-haber = 0.
            END.
            END CASE.
        END.
        ELSE DO:      
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn2.
            END.
            WHEN 3 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn3.
            END.
            END CASE.            
        END.
        {&NEW-PAGE}.
        IF  (x-debe <> ? AND x-haber <> ?)
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY {&CONDICION} ).
            ACCUMULATE x-haber (SUB-TOTAL BY {&CONDICION} ).
            ACCUMULATE x-debe  (TOTAL).
            ACCUMULATE x-haber (TOTAL).
            x-conreg = x-conreg + 1.     
        END.
                    
        IF LAST-OF ({&CONDICION}) AND x-conreg > 0 THEN DO:
           x-debe      = (ACCUM SUB-TOTAL BY {&CONDICION} x-debe    ).
           x-haber     = (ACCUM SUB-TOTAL BY {&CONDICION} x-haber   ).
           x-deudor = x-debe - x-haber.
           x-acreedor = 0.
           IF x-deudor < 0 THEN DO:
                   x-acreedor = - x-deudor.
                   x-deudor   = 0.
           END.
           X-NOMCTA = "".
           X-CODCTA = {&CONDICION}.
           FIND cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                              cb-ctas.CODCTA = {&CONDICION}
                              NO-LOCK NO-ERROR.
           IF AVAIL cb-ctas THEN X-NOMCTA = cb-ctas.NOMCTA.                   
           DISPLAY STREAM report 
                {&CONDICION} @ cb-dmov.codcta
                x-nomcta                                     
                x-debe      when  x-debe     <> 0
                x-haber     when  x-haber    <> 0
                x-deudor    when  x-deudor   <> 0
                x-acreedor  when  x-acreedor <> 0
                WITH FRAME f-cab.
             DOWN STREAM REPORT WITH FRAME F-CAB.    
        END.
       END.
/*IMPRIMIENTO TOTALES  */

   
    UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   G E N E R A L   ***".
            x-debe     = ACCUM TOTAL  x-debe. 
            x-haber    = ACCUM TOTAL  x-haber.
            x-deudor   = x-debe - x-haber.
            x-acreedor = 0.
            IF x-deudor < 0 THEN DO:
               x-acreedor = - x-deudor.
               x-deudor   = 0.
            END.
             
            DISPLAY STREAM report 
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.

END. /* FIN DEL DO WITH FRAME F-CAB */   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso3 DIALOG-1 
PROCEDURE proceso3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* R3 =       Q-DIV   AND    (NOT Q-OPE). */
 x-conreg = 0.
 DEFINE FRAME f-cab
        cb-dmov.coddiv LABEL "Div."
        cb-dmov.codcta LABEL "Cuenta"  
        x-nomcta       LABEL "         D e s c r i p c i ó n"
        x-debe
        x-haber
        x-deudor  
        x-acreedor
        HEADER
        empresas.nomcia
        "FECHA : " TO 115 TODAY TO 123
        SKIP
        empresas.direccion
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9" TO 123  
        SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123  
        SKIP(2)
        x-titulo   FORMAT "X(130)"   
        SKIP    
        pinta-mes  FORMAT "X(130)"
        SKIP
        x-expres   FORMAT "X(130)"
        SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
    P-Ancho  = FRAME f-cab:WIDTH.        

DO WITH FRAME F-CAB :

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                        AND cb-dmov.periodo = s-periodo 
                        AND cb-dmov.nromes  >= c-1
                        AND cb-dmov.nromes  <= c-2
                        AND cb-dmov.codcta >= x-cta-ini
                        AND cb-dmov.codcta <= x-cta-fin
                        AND lookup (cb-dmov.codope ,x-codope ) > 0                          
                        AND cb-dmov.coddiv BEGINS (x-div)
            BREAK BY cb-dmov.coddiv            
                  BY {&CONDICION}  ON ERROR UNDO, LEAVE:
        IF FIRST-OF (cb-dmov.coddiv)  THEN DO:
            X-nomdiv = "".           
            FIND GN-DIVI WHERE  GN-DIVI.CODCIA = S-codcia AND
                                GN-DIVI.CODDIV = cb-dmov.CODDIV
                                NO-LOCK NO-ERROR.
            {&NEW-PAGE}.
            IF AVAIL cb-auxi THEN x-nomdiv =  GN-DIVI.DESDIV.
               DISPLAY STREAM report 
                          cb-dmov.codDIV 
                          x-nomdiv        @ x-nomcta
                WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.   
            {&NEW-PAGE}.
             UNDERLINE  STREAM report 
                          cb-dmov.codDIV 
                          x-nomcta
             WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.   
        END.
        IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
        IF NOT tpomov THEN DO:
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
                x-haber = 0.
            END.
            WHEN 3 THEN DO:
                x-debe  = ImpMn3.
                x-haber = 0.
            END.
            END CASE.
        END.
        ELSE DO:      
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn2.
            END.
            WHEN 3 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn3.
            END.
            END CASE.            
        END.
        {&NEW-PAGE}.
        IF  (x-debe <> ? AND x-haber <> ?)
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY {&CONDICION}).
            ACCUMULATE x-haber (SUB-TOTAL BY {&CONDICION}).
            
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.coddiv).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.coddiv).
            
            ACCUMULATE x-debe  (TOTAL).
            ACCUMULATE x-haber (TOTAL).
            x-conreg = x-conreg + 1.     
        END.
                    
        IF LAST-OF ({&CONDICION}) AND x-conreg > 0 THEN DO:
           x-debe      = (ACCUM SUB-TOTAL BY {&CONDICION} x-debe    ).
           x-haber     = (ACCUM SUB-TOTAL BY {&CONDICION} x-haber   ).
           x-deudor = x-debe - x-haber.
           x-acreedor = 0.
           IF x-deudor < 0 THEN DO:
                   x-acreedor = - x-deudor.
                   x-deudor   = 0.
           END.
           ACCUMULATE x-deudor   (SUB-TOTAL BY cb-dmov.coddiv).
           ACCUMULATE x-acreedor (SUB-TOTAL BY cb-dmov.coddiv).
           X-CODCTA = {&CONDICION}.
           X-NOMCTA = "".
           FIND cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                              cb-ctas.CODCTA = {&CONDICION}
                              NO-LOCK NO-ERROR.
           IF AVAIL cb-ctas THEN X-NOMCTA = cb-ctas.NOMCTA.                   
           DISPLAY STREAM report 
                {&CONDICION} @ cb-dmov.codcta
                x-nomcta                                     
                x-debe      when  x-debe     <> 0
                x-haber     when  x-haber    <> 0
                x-deudor    when  x-deudor   <> 0
                x-acreedor  when  x-acreedor <> 0
                WITH FRAME f-cab.
             DOWN STREAM REPORT WITH FRAME F-CAB.    
        END.
        IF LAST-OF(cb-dmov.coddiv)  THEN DO:
            x-nomdiv = "***  T O T A L   " + x-nomdiv + "  ***".
            UNDERLINE STREAM REPORT
                cb-dmov.coddiv 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-debe     = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-debe.
            x-haber    = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-haber.
            x-deudor   = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-deudor.
            x-acreedor = ACCUM SUB-TOTAL BY cb-dmov.coddiv x-acreedor.
            DISPLAY STREAM report
                    cb-dmov.coddiv
                    x-nomdiv                        @ x-nomcta 
                    x-debe     WHEN X-DEBE     <> 0   
                    x-haber    WHEN X-HABER    <> 0   
                    x-deudor   WHEN X-DEUDOR   <> 0   
                    x-acreedor WHEN X-ACREEDOR <> 0 
                WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME F-CAB.                
            UNDERLINE STREAM REPORT
                cb-dmov.coddiv 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.
        END.        
    END.
/*IMPRIMIENTO TOTALES  */

   
    UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   G E N E R A L   ***".
            x-debe     = ACCUM TOTAL  x-debe. 
            x-haber    = ACCUM TOTAL  x-haber.
            x-deudor   = x-debe - x-haber.
            x-acreedor = 0.
            IF x-deudor < 0 THEN DO:
               x-acreedor = - x-deudor.
               x-deudor   = 0.
            END.
             
            DISPLAY STREAM report 
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.

END. /* FIN DEL DO WITH FRAME F-CAB */   
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso4 DIALOG-1 
PROCEDURE proceso4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*  R4 =  (NOT Q-DIV)  AND         Q-OPE . */
   x-conreg = 0.
 DEFINE FRAME f-cab
        cb-dmov.codope LABEL "Cod!Ope"
        cb-dmov.codcta LABEL "Cuenta"  
        x-nomcta       LABEL "         D e s c r i p c i ó n"
        x-debe
        x-haber
        x-deudor  
        x-acreedor
        HEADER
        empresas.nomcia
        "FECHA : " TO 115 TODAY TO 123
        SKIP
        empresas.direccion
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9" TO 123  
        SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123  
        SKIP(2)
        x-titulo   FORMAT "X(130)"   
        SKIP    
        pinta-mes  FORMAT "X(130)"
        SKIP
        x-expres   FORMAT "X(130)"
        SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
    P-Ancho  = FRAME f-cab:WIDTH.        

DO WITH FRAME F-CAB :

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                        AND cb-dmov.periodo = s-periodo 
                        AND cb-dmov.nromes  >= c-1
                        AND cb-dmov.nromes  <= c-2
                        AND cb-dmov.codcta >= x-cta-ini
                        AND cb-dmov.codcta <= x-cta-fin
                        AND cb-dmov.coddiv BEGINS (x-div)
                        AND lookup (cb-dmov.codope ,x-codope ) > 0                          
            BREAK BY cb-dmov.codope
                  BY {&CONDICION} ON ERROR UNDO, LEAVE:
        IF FIRST-OF (cb-dmov.codope) THEN DO:
            {&NEW-PAGE}.
            x-nomope = "".
            FIND cb-oper WHERE cb-oper.CODCIA = cb-codcia AND
                                  cb-oper.CODOPE = cb-dmov.CODOPE
                                  NO-LOCK NO-ERROR.
            IF AVAIL cb-oper THEN x-nomope = cb-oper.NOMOPE.                     
            DISPLAY STREAM report  cb-dmov.codope           
                                   x-nomope        @ x-nomcta
            WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.    
            UNDERLINE STREAM report  cb-dmov.codope           
                                     x-nomcta 
                                     WITH FRAME f-cab.
            DOWN STREAM REPORT WITH FRAME f-cab.    
        END.
        IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
        IF NOT tpomov THEN DO:
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
                x-haber = 0.
            END.
            WHEN 3 THEN DO:
                x-debe  = ImpMn3.
                x-haber = 0.
            END.
            END CASE.
        END.
        ELSE DO:      
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn2.
            END.
            WHEN 3 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn3.
            END.
            END CASE.            
        END.
        {&NEW-PAGE}.
        IF  (x-debe <> ? AND x-haber <> ?)
        THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY {&CONDICION}).
            ACCUMULATE x-haber (SUB-TOTAL BY {&CONDICION}).
            
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.codope).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.codope).
            
            ACCUMULATE x-debe  (TOTAL).
            ACCUMULATE x-haber (TOTAL).
            x-conreg = x-conreg + 1.     
        END.
                    
        IF LAST-OF ({&CONDICION}) AND x-conreg > 0 THEN DO:
           x-debe      = (ACCUM SUB-TOTAL BY {&CONDICION} x-debe    ).
           x-haber     = (ACCUM SUB-TOTAL BY {&CONDICION} x-haber   ).
           x-deudor = x-debe - x-haber.
           x-acreedor = 0.
           IF x-deudor < 0 THEN DO:
                   x-acreedor = - x-deudor.
                   x-deudor   = 0.
           END.
            
           ACCUMULATE x-deudor   (SUB-TOTAL BY cb-dmov.codope).
           ACCUMULATE x-acreedor (SUB-TOTAL BY cb-dmov.codope).
           
           FIND cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                              cb-ctas.CODCTA = {&CONDICION}
                              NO-LOCK NO-ERROR.
           IF AVAIL cb-ctas THEN X-NOMCTA = cb-ctas.NOMCTA.                   
          
           DISPLAY STREAM report 
                {&CONDICION} @ cb-dmov.codcta
                x-nomcta                                     
                x-debe      when  x-debe     <> 0
                x-haber     when  x-haber    <> 0
                x-deudor    when  x-deudor   <> 0
                x-acreedor  when  x-acreedor <> 0
                WITH FRAME f-cab.
             DOWN STREAM REPORT WITH FRAME F-CAB.    
        END.
        
        IF LAST-OF(cb-dmov.codope) THEN DO:
            UNDERLINE STREAM REPORT
                cb-dmov.codope 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   " + x-nomope + "  ***".
            x-debe     = ACCUM SUB-TOTAL BY cb-dmov.codope x-debe. 
            x-haber    = ACCUM SUB-TOTAL BY cb-dmov.codope x-haber.
            x-deudor   = ACCUM SUB-TOTAL BY cb-dmov.codope x-deudor.
            x-acreedor = ACCUM SUB-TOTAL BY cb-dmov.codope x-acreedor.
            DISPLAY STREAM report 
                    cb-dmov.codope
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                cb-dmov.codope 
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.
        END.
    END.
/*IMPRIMIENTO TOTALES  */

   
    UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.
            x-nomope   = "***  T O T A L   G E N E R A L   ***".
            x-debe     = ACCUM TOTAL  x-debe. 
            x-haber    = ACCUM TOTAL  x-haber.
            x-deudor   = x-debe - x-haber.
            x-acreedor = 0.
            IF x-deudor < 0 THEN DO:
               x-acreedor = - x-deudor.
               x-deudor   = 0.
            END.
             
            DISPLAY STREAM report 
                    x-nomope                            @ x-nomcta 
                    x-debe       WHEN x-debe     <> 0 
                    x-haber      WHEN x-haber    <> 0 
                    x-deudor     WHEN x-deudor   <> 0 
                    x-acreedor   WHEN x-acreedor <> 0 
            WITH FRAME f-cab.
            UNDERLINE STREAM REPORT
                x-nomcta   
                x-debe
                x-haber
                x-deudor  
                x-acreedor WITH FRAME F-CAB.
            DOWN STREAM REPORT 2 WITH FRAME F-CAB.

END. /* FIN DEL DO WITH FRAME F-CAB */   

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


