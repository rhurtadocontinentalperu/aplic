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
DEFINE {&NEW} SHARED VARIABLE cb-niveles   AS CHARACTER INITIAL "2,3,5".

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
    

DEFINE SHARED VARIABLE cb-codcia AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE cl-codcia AS INTEGER NO-UNDO.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO.


/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE


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
DEFINE VARIABLE T-NOMDIV   AS CHARACTER .
                         
DEFINE VARIABLE x-sdo-m     AS DECIMAL.
DEFINE VARIABLE x-sdo-2     AS DECIMAL.
                           
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 9.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE S-DIRCIA AS CHARACTER FORMAT "X(40)".
/* cb-codcia = 0.                                          */
/* FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK. */
/* IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia. */


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

&GLOBAL-DEFINE CONDICION SUBSTRING(CB-DMOV.CODCTA , 1 , 2 )

DEFINE TEMP-TABLE T-REPORT
  FIELD SUBCTA AS CHAR      FORMAT "X(2)"  COLUMN-LABEL "Cta"
  FIELD CODDIV AS CHAR      FORMAT "X(5)"  COLUMN-LABEL "Divi."
  FIELD CODCTA AS CHAR      FORMAT "X(8)"  COLUMN-LABEL "Cuenta"
  FIELD NOMCTA AS CHAR      FORMAT "X(50)" COLUMN-LABEL "Nombre / Descripción"
  FIELD SALDO  AS DECIMAL  FORMAT "-ZZZZZZZZ.99" COLUMN-LABEL "Saldo"
  FIELD MES    AS DECIMAL  EXTENT 13 FORMAT "-ZZZZZZZZ.99" 
  INDEX IDX01 CODCTA 
  INDEX IDX02 CODDIV CODCTA 
  INDEX IDX03 SUBCTA .

DEF VAR X-FORMATO AS INTEGER INIT 1.

DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".

DEFINE BUFFER B-T-REPORT FOR T-REPORT.

DEFINE FRAME F-AUXILIAR
X-MENSAJE
WITH TITLE "Espere un momento por favor ... "  NO-LABELS CENTERED VIEW-AS DIALOG-BOX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-oper

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 codope nomope caja   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH t-oper
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH t-oper.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 t-oper
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 t-oper


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-6 RECT-5 RECT-13 r-oper ~
C-formato BROWSE-1 x-codmon C-1 C-2 x-Div o-auto x-cta-ini x-cta-fin ~
RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE ~
B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS r-oper C-formato x-codmon C-1 C-2 x-Div ~
o-auto x-cta-ini x-cta-fin RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE ~
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
     DROP-DOWN-LIST
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 10 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-formato AS CHARACTER FORMAT "X(256)":U INITIAL "Acumulado" 
     LABEL "Formato" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Acumulado","Mensual: Apertura, Enero, Febrero, Marzo,.." 
     DROP-DOWN-LIST
     SIZE 33.43 BY 1
     BGCOLOR 15  NO-UNDO.

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
     SIZE 42.29 BY .69
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
     SIZE 82.57 BY 8.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 82.86 BY 3.38.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 82.86 BY 1.46.

DEFINE VARIABLE o-auto AS LOGICAL INITIAL yes 
     LABEL "Omitir Automaticas" 
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
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 41 BY 5.12
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     r-oper AT ROW 1.27 COL 44.43 NO-LABEL
     C-formato AT ROW 1.38 COL 8.14 COLON-ALIGNED
     BROWSE-1 AT ROW 3.65 COL 42.29
     x-codmon AT ROW 3.77 COL 5 NO-LABEL
     C-1 AT ROW 4.58 COL 29.57 COLON-ALIGNED
     C-2 AT ROW 5.38 COL 29.57 COLON-ALIGNED
     x-Div AT ROW 6.19 COL 29.57 COLON-ALIGNED
     o-auto AT ROW 6.92 COL 3
     x-cta-ini AT ROW 7 COL 29.57 COLON-ALIGNED
     x-cta-fin AT ROW 7.81 COL 29.57 COLON-ALIGNED
     RADIO-SET-1 AT ROW 9.88 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 10 COL 73.57 COLON-ALIGNED
     B-impresoras AT ROW 10.88 COL 15
     RB-BEGIN-PAGE AT ROW 11 COL 73.57 COLON-ALIGNED
     b-archivo AT ROW 11.88 COL 15
     RB-END-PAGE AT ROW 12 COL 73.57 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 12.15 COL 19 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 13.46 COL 18
     B-cancela AT ROW 13.46 COL 48
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .65 AT ROW 2.69 COL 4
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 82.86 BY .62 AT ROW 9.08 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-4 AT ROW 1 COL 1.29
     RECT-6 AT ROW 13.12 COL 1
     RECT-5 AT ROW 9.73 COL 1
     RECT-13 AT ROW 3.5 COL 4
     SPACE(68.86) SKIP(9.23)
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 C-formato DIALOG-1 */
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
        DEF VAR P-LARGO AS INTEGER.
        ASSIGN C-formato
               x-cta-ini 
               x-cta-fin
               x-codmon
               x-div
               c-1
               c-2
               o-auto
               R-oper.
   
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-CodCia AND GN-DIVI.CodDiv = X-Div
        NO-LOCK NO-ERROR.
        
   IF AVAILABLE GN-DIVI THEN T-NOMDIV = X-DIV + " " + GN-DIVI.DesDiv.
      ELSE T-NOMDIV = "".
   
    if X-CTA-INI = "" then X-CTA-INI = FILL("0",x-max-nivel).
    if X-CTA-FIN = "" then X-CTA-FIN = FILL("9",x-max-nivel). 
    if length(X-CTA-INI) < x-max-nivel THEN 
       X-CTA-INI = substring(X-CTA-INI + FILL("0",x-max-nivel), 1, x-max-nivel).
    if length(X-CTA-FIN) < x-max-nivel THEN 
       X-CTA-FIN = substring(X-CTA-FIN + FILL("9",x-max-nivel), 1, x-max-nivel).
        IF x-cta-fin < x-cta-ini 
        THEN DO:
            BELL.
            MESSAGE "La cuenta fin es menor" SKIP
                    "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO x-cta-ini.
            RETURN NO-APPLY.
        END.
        IF x-div <> "" AND
             NOT CAN-FIND(FIRST GN-DIVI  WHERE GN-DIVI.codcia = S-codcia 
                                          AND  GN-DIVI.codDIV = x-div)
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
    /*
    IF C-1 = 0 AND R-OPER = 2 THEN X-CODOPE = X-CODOPE + "000,".
    */
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
    IF X-FORMATO = 1 THEN P-LARGO = 130.
                     ELSE P-LARGO = 240.
                         
    RUN bin/_centrar.p ( INPUT pinta-mes, P-LARGO , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-moneda,  P-LARGO , OUTPUT x-moneda ).
    RUN bin/_centrar.p ( INPUT x-expres,  P-LARGO , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-titulo,  P-LARGO , OUTPUT x-titulo ).
    
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


&Scoped-define SELF-NAME C-formato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-formato DIALOG-1
ON VALUE-CHANGED OF C-formato IN FRAME DIALOG-1 /* Formato */
DO:
   IF INPUT C-FORMATO BEGINS "A" THEN X-FORMATO = 1.
                                 ELSE X-FORMATO = 2.
                                 
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
OR "MOUSE-SELECT-DBLCLICK":U OF x-cta-fin DO:
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
OR "MOUSE-SELECT-DBLCLICK":U OF x-cta-ini DO: 
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
/*
ASSIGN C-3:LIST-ITEMS   = "5".

ASSIGN C-3:SCREEN-VALUE = ENTRY(1,cb-niveles).
*/

IF AVAIL cb-cfga THEN DO:
   ASSIGN  x-cta-ini:FORMAT    = cb-cfga.DETCFG.
   ASSIGN  x-cta-fin:FORMAT    = cb-cfga.DETCFG.
END.

FOR EACH cb-oper WHERE 
         cb-oper.CODCIA = cb-codcia AND
         CB-OPER.CODOPE <> "" NO-LOCK:
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
 /* 
  VIEW FRAME F-Mensaje.  
  PAUSE 0.           
 */ 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo DIALOG-1 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE JJ        AS INTEGER NO-UNDO.
DEFINE VARIABLE C-CODOPE  AS CHAR NO-UNDO.
DEFINE VARIABLE F-IMPORTE AS DECIMAL NO-UNDO.

   DO JJ = 1 TO NUM-ENTRIES(x-codope) :
      C-CODOPE = ENTRY(JJ,x-codope).
      X-SDO-M = 0.
      FOR EACH cb-dmov NO-LOCK WHERE 
               cb-dmov.codcia  = s-codcia    AND 
               cb-dmov.periodo = s-periodo   AND 
               cb-dmov.codope  = C-CODOPE    AND 
               cb-dmov.codcta >= x-cta-ini   AND 
               cb-dmov.codcta <= x-cta-fin   AND 
               cb-dmov.nromes  >= c-1        AND 
               cb-dmov.nromes  <= c-2        AND 
               cb-dmov.coddiv BEGINS (x-div)  
               BREAK BY cb-dmov.codcia
                     BY cb-dmov.periodo
                     BY cb-dmov.codope
                     BY CB-DMOV.CODCTA
               ON ERROR UNDO, LEAVE:
          IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
          IF FIRST-OF(CB-DMOV.CODCTA) THEN DO:
              DISPLAY "Procesando cuenta: " + cb-dmov.codcta + " - " + cb-dmov.codOpe @ x-mensaje WITH FRAME F-AUXILIAR.
              PAUSE 0.
              X-SDO-M = 0.
              FIND FIRST T-REPORT WHERE T-REPORT.CODCTA = cb-dmov.codcta NO-ERROR.
              IF NOT AVAILABLE T-REPORT THEN CREATE T-REPORT.
              ASSIGN T-REPORT.CODCTA = cb-dmov.codcta
                     T-REPORT.SUBCTA = SUBSTRING(cb-dmov.codcta,1,2).
              FIND cb-ctas WHERE 
                   cb-ctas.CODCIA = cb-codcia AND
                   cb-ctas.CODCTA = cb-dmov.codcta  NO-LOCK NO-ERROR. 
              IF AVAIL cb-ctas THEN T-REPORT.NOMCTA = cb-ctas.NOMCTA.
          END. 
          F-IMPORTE = IF x-codmon = 1 THEN cb-dmov.impmn1 ELSE cb-dmov.impmn2.
          F-IMPORTE = IF NOT tpomov THEN F-IMPORTE ELSE (-1 * F-IMPORTE) .
          x-sdo-m = x-sdo-m + F-IMPORTE.
          T-REPORT.MES[CB-DMOV.NROMES + 1] = T-REPORT.MES[CB-DMOV.NROMES + 1] + F-IMPORTE.
          
          IF LAST-OF (CB-DMOV.CODCTA) THEN 
             ASSIGN T-REPORT.SALDO = T-REPORT.SALDO  + X-SDO-M.
             
      END. /* FIN DEL FOR EACH */        
   END. /* FIN DEL DO */        
   
   FOR EACH T-REPORT 
       BREAK BY T-REPORT.SUBCTA:
       ACCUMULATE T-REPORT.SALDO    (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 1]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 2]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 3]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 4]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 5]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 6]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 7]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 8]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[ 9]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[10]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[11]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[12]  (TOTAL BY T-REPORT.SUBCTA ).
       ACCUMULATE T-REPORT.MES[13]  (TOTAL BY T-REPORT.SUBCTA ).
       IF LAST-OF(T-REPORT.SUBCTA) THEN DO:
          CREATE B-T-REPORT.
          ASSIGN B-T-REPORT.CODCTA = SUBSTRING(cb-dmov.codcta,1,2).
                 B-T-REPORT.SUBCTA = SUBSTRING(cb-dmov.codcta,1,2).
          FIND FIRST cb-ctas WHERE 
                     cb-ctas.CODCIA = cb-codcia AND
                     cb-ctas.CODCTA = B-T-REPORT.CODCTA NO-LOCK NO-ERROR.
          IF AVAIL cb-ctas THEN B-T-REPORT.NOMCTA = cb-ctas.NOMCTA.
          ASSIGN  B-T-REPORT.MES[ 1] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 1]
                  B-T-REPORT.MES[ 2] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 2]
                  B-T-REPORT.MES[ 3] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 3]
                  B-T-REPORT.MES[ 4] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 4]
                  B-T-REPORT.MES[ 5] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 5]
                  B-T-REPORT.MES[ 6] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 6]
                  B-T-REPORT.MES[ 7] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 7]
                  B-T-REPORT.MES[ 8] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 8]
                  B-T-REPORT.MES[ 9] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[ 9]
                  B-T-REPORT.MES[10] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[10]
                  B-T-REPORT.MES[11] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[11]
                  B-T-REPORT.MES[12] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[12]
                  B-T-REPORT.MES[13] = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.MES[13]
                  T-REPORT.SALDO     = ACCUM TOTAL BY T-REPORT.SUBCTA T-REPORT.SALDO.
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
  DISPLAY r-oper C-formato x-codmon C-1 C-2 x-Div o-auto x-cta-ini x-cta-fin 
          RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-6 RECT-5 RECT-13 r-oper C-formato BROWSE-1 x-codmon C-1 
         C-2 x-Div o-auto x-cta-ini x-cta-fin RADIO-SET-1 RB-NUMBER-COPIES 
         B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela 
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
P-largo  = 88. 
P-Config = P-20cpi + P-8lpi.
x-Raya   = FILL("-", P-Ancho).
RUN PROCESO2.      
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO2 DIALOG-1 
PROCEDURE PROCESO2 :
DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR x-Total-Mes AS DEC EXTENT 13 NO-UNDO.

DEFINE FRAME f-cab
       SPACE(15)
       T-REPORT.CODCTA
       T-REPORT.NOMCTA
       T-REPORT.SALDO
     HEADER
        S-NOMCIA
        "FECHA : " TO 115 TODAY TO 123                     SKIP
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9" TO 123     SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123   SKIP(2)
        x-titulo   FORMAT "X(130)"                         SKIP    
        pinta-mes  FORMAT "X(130)"                         SKIP
        x-expres   FORMAT "X(130)"                         SKIP
        T-NOMDIV   FORMAT "X(130)"                         SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
        P-Ancho  = FRAME f-cab:WIDTH.        

DEFINE FRAME f-cab-1
       T-REPORT.CODCTA
       T-REPORT.NOMCTA FORMAT "X(40)"
       T-REPORT.MES[ 1] COLUMN-LABEL "Apertura" 
       T-REPORT.MES[ 2] COLUMN-LABEL "Enero"
       T-REPORT.MES[ 3] COLUMN-LABEL "Febrero"
       T-REPORT.MES[ 4] COLUMN-LABEL "Marzo"
       T-REPORT.MES[ 5] COLUMN-LABEL "Abril"
       T-REPORT.MES[ 6] COLUMN-LABEL "Mayo"
       T-REPORT.MES[ 7] COLUMN-LABEL "Junio"
       T-REPORT.MES[ 8] COLUMN-LABEL "Julio"
       T-REPORT.MES[ 9] COLUMN-LABEL "Agosto"
       T-REPORT.MES[10] COLUMN-LABEL "Septiembre"
       T-REPORT.MES[11] COLUMN-LABEL "Octubre"
       T-REPORT.MES[12] COLUMN-LABEL "Noviembre"
       T-REPORT.MES[13] COLUMN-LABEL "Diciembre"
       T-REPORT.SALDO   COLUMN-LABEL "Total"
    HEADER
        S-NOMCIA       "FECHA : " TO 220 TODAY TO 230        SKIP
        "PAGINA :" TO 220 c-pagina FORMAT "ZZ9"   TO 230     SKIP
        "HORA   :" TO 220 STRING(TIME,"HH:MM AM") TO 230     SKIP(2)
        x-titulo   FORMAT "X(245)"                           SKIP    
        pinta-mes  FORMAT "X(245)"                           SKIP
        x-expres   FORMAT "X(245)"                           SKIP
        T-NOMDIV   FORMAT "X(245)"                           SKIP(2)
        WITH WIDTH 280 NO-BOX DOWN STREAM-IO.

P-Ancho  = FRAME f-cab:WIDTH.        
                     
DO  WITH FRAME F-CAB :
    IF C-COPIAS = 1 THEN DO:
       DISPLAY "Seleccionando información solicitada" @ X-MENSAJE WITH FRAME F-AUXILIAR.
       PAUSE 0.
       RUN CARGA-TEMPO.
    END.
       
    HIDE FRAME F-AUXILIAR.
    VIEW FRAME F-MENSAJE.
    PAUSE 0.
    IF X-FORMATO = 1 THEN DO:
       FOR EACH T-REPORT USE-INDEX IDX01:
           IF LENGTH(T-REPORT.CODCTA) = 2 THEN DO:
              {&NEW-PAGE}.
              DISPLAY STREAM REPORT WITH FRAME F-CAB.
              DOWN STREAM REPORT WITH FRAME F-CAB.
           END.
           IF LENGTH(T-REPORT.CODCTA) = X-MAX-NIVEL THEN DO:
              ACCUMULATE T-REPORT.SALDO  (TOTAL).       
           END.
           {&NEW-PAGE}.
           DISPLAY STREAM report
                   T-REPORT.CODCTA
                   T-REPORT.NOMCTA
                   T-REPORT.SALDO WITH FRAME F-CAB.
           DOWN STREAM REPORT WITH FRAME F-CAB.
       END.
       {&NEW-PAGE}.
       UNDERLINE STREAM report
                 T-REPORT.CODCTA
                 T-REPORT.NOMCTA
                 T-REPORT.SALDO  WITH FRAME F-CAB.    
       DOWN STREAM REPORT WITH FRAME F-CAB.
       DISPLAY  STREAM report
                "....T o t a l "       @ T-REPORT.NOMCTA
            ACCUM TOTAL T-REPORT.SALDO @ T-REPORT.SALDO    WITH FRAME F-CAB.    
       RETURN.
    END.
END. /* FIN DEL DO WITH */

DO WITH FRAME F-CAB-1 :
   FOR EACH T-REPORT USE-INDEX IDX01:
       IF LENGTH(T-REPORT.CODCTA) = X-MAX-NIVEL THEN DO:
            ACCUMULATE T-REPORT.SALDO    (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 1]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 2]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 3]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 4]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 5]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 6]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 7]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 8]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 9]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[10]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[11]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[12]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[13]  (TOTAL).       
       END.
       IF LENGTH(T-REPORT.CODCTA) = 2 THEN DO:
           {&NEW-PAGE}.
           DISPLAY STREAM REPORT WITH FRAME F-CAB-1.
           DOWN STREAM REPORT WITH FRAME F-CAB-1.
       END.
       {&NEW-PAGE}.
       DISPLAY STREAM report
            T-REPORT.CODCTA
            T-REPORT.NOMCTA
            T-REPORT.MES[ 1]  WHEN  T-REPORT.MES[ 1] <> 0
            T-REPORT.MES[ 2]  WHEN  T-REPORT.MES[ 2] <> 0
            T-REPORT.MES[ 3]  WHEN  T-REPORT.MES[ 3] <> 0
            T-REPORT.MES[ 4]  WHEN  T-REPORT.MES[ 4] <> 0
            T-REPORT.MES[ 5]  WHEN  T-REPORT.MES[ 5] <> 0
            T-REPORT.MES[ 6]  WHEN  T-REPORT.MES[ 6] <> 0
            T-REPORT.MES[ 7]  WHEN  T-REPORT.MES[ 7] <> 0
            T-REPORT.MES[ 8]  WHEN  T-REPORT.MES[ 8] <> 0
            T-REPORT.MES[ 9]  WHEN  T-REPORT.MES[ 9] <> 0
            T-REPORT.MES[10]  WHEN  T-REPORT.MES[10] <> 0
            T-REPORT.MES[11]  WHEN  T-REPORT.MES[11] <> 0
            T-REPORT.MES[12]  WHEN  T-REPORT.MES[12] <> 0
            T-REPORT.MES[13]  WHEN  T-REPORT.MES[13] <> 0
            T-REPORT.SALDO
            WITH FRAME F-CAB-1.    
       DOWN STREAM REPORT WITH FRAME F-CAB-1.
   END.
   {&NEW-PAGE}.
   UNDERLINE STREAM report
            T-REPORT.CODCTA
            T-REPORT.NOMCTA
            T-REPORT.MES[ 1]
            T-REPORT.MES[ 2]
            T-REPORT.MES[ 3]
            T-REPORT.MES[ 4]
            T-REPORT.MES[ 5]
            T-REPORT.MES[ 6]
            T-REPORT.MES[ 7]
            T-REPORT.MES[ 8]
            T-REPORT.MES[ 9]
            T-REPORT.MES[10]
            T-REPORT.MES[11]
            T-REPORT.MES[12]
            T-REPORT.MES[13]
            T-REPORT.SALDO
        WITH FRAME F-CAB-1.    
   DOWN STREAM REPORT WITH FRAME F-CAB-1.
   ASSIGN
    x-Total-Mes[ 1] = ACCUM TOTAL T-REPORT.MES[ 1] 
    x-Total-Mes[ 2] = ACCUM TOTAL T-REPORT.MES[ 2] 
    x-Total-Mes[ 3] = ACCUM TOTAL T-REPORT.MES[ 3] 
    x-Total-Mes[ 4] = ACCUM TOTAL T-REPORT.MES[ 4] 
    x-Total-Mes[ 5] = ACCUM TOTAL T-REPORT.MES[ 5] 
    x-Total-Mes[ 6] = ACCUM TOTAL T-REPORT.MES[ 6] 
    x-Total-Mes[ 7] = ACCUM TOTAL T-REPORT.MES[ 7] 
    x-Total-Mes[ 8] = ACCUM TOTAL T-REPORT.MES[ 8] 
    x-Total-Mes[ 9] = ACCUM TOTAL T-REPORT.MES[ 9] 
    x-Total-Mes[10] = ACCUM TOTAL T-REPORT.MES[10] 
    x-Total-Mes[11] = ACCUM TOTAL T-REPORT.MES[11] 
    x-Total-Mes[12] = ACCUM TOTAL T-REPORT.MES[12]
    x-Total-Mes[13] = ACCUM TOTAL T-REPORT.MES[13]
    x-Total = x-Total-Mes[1] + x-Total-Mes[2] + x-Total-Mes[3] + x-Total-Mes[4] + x-Total-Mes[5] + x-Total-Mes[6] + 
                x-Total-Mes[7] + x-Total-Mes[8] + x-Total-Mes[9] + x-Total-Mes[10] + x-Total-Mes[11] + x-Total-Mes[12] +
                x-Total-Mes[13].
   DISPLAY  STREAM report
            "Total "         @ T-REPORT.CODCTA
        ACCUM TOTAL T-REPORT.MES[ 1] @ T-REPORT.MES[ 1]
        ACCUM TOTAL T-REPORT.MES[ 2] @ T-REPORT.MES[ 2]
        ACCUM TOTAL T-REPORT.MES[ 3] @ T-REPORT.MES[ 3]
        ACCUM TOTAL T-REPORT.MES[ 4] @ T-REPORT.MES[ 4]
        ACCUM TOTAL T-REPORT.MES[ 5] @ T-REPORT.MES[ 5]
        ACCUM TOTAL T-REPORT.MES[ 6] @ T-REPORT.MES[ 6]
        ACCUM TOTAL T-REPORT.MES[ 7] @ T-REPORT.MES[ 7]
        ACCUM TOTAL T-REPORT.MES[ 8] @ T-REPORT.MES[ 8]
        ACCUM TOTAL T-REPORT.MES[ 9] @ T-REPORT.MES[ 9]
        ACCUM TOTAL T-REPORT.MES[10] @ T-REPORT.MES[10]
        ACCUM TOTAL T-REPORT.MES[11] @ T-REPORT.MES[11]
        ACCUM TOTAL T-REPORT.MES[12] @ T-REPORT.MES[12]
        ACCUM TOTAL T-REPORT.MES[13] @ T-REPORT.MES[13]
        /*ACCUM TOTAL T-REPORT.SALDO   @ T-REPORT.SALDO */
        x-Total                      @ T-REPORT.SALDO
        WITH FRAME F-CAB-1.    
END.

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
/*
DEFINE VARIABLE JJ AS INTEGER NO-UNDO.
DEFINE VARIABLE C-CODOPE AS CHAR NO-UNDO.

DEFINE FRAME f-cab
       SPACE(15)
       T-REPORT.CODCTA
       T-REPORT.NOMCTA
       T-REPORT.SALDO
     HEADER
        S-NOMCIA
        "FECHA : " TO 115 TODAY TO 123                     SKIP
        "PAGINA :" TO 114 c-pagina FORMAT "ZZ9" TO 123     SKIP
        "HORA   :" TO 114 STRING(TIME,"HH:MM AM") TO 123   SKIP(2)
        x-titulo   FORMAT "X(130)"                         SKIP    
        pinta-mes  FORMAT "X(130)"                         SKIP
        x-expres   FORMAT "X(130)"                         SKIP
        T-NOMDIV   FORMAT "X(130)"                         SKIP(2)
        WITH WIDTH 130 NO-BOX DOWN STREAM-IO.
P-Ancho  = FRAME f-cab:WIDTH.        

DEFINE FRAME f-cab-1
       T-REPORT.CODCTA
       T-REPORT.NOMCTA FORMAT "X(40)"
       T-REPORT.MES[ 1] COLUMN-LABEL "Apertura" 
       T-REPORT.MES[ 2] COLUMN-LABEL "Enero"
       T-REPORT.MES[ 3] COLUMN-LABEL "Febrero"
       T-REPORT.MES[ 4] COLUMN-LABEL "Marzo"
       T-REPORT.MES[ 5] COLUMN-LABEL "Abril"
       T-REPORT.MES[ 6] COLUMN-LABEL "Mayo"
       T-REPORT.MES[ 7] COLUMN-LABEL "Junio"
       T-REPORT.MES[ 8] COLUMN-LABEL "Julio"
       T-REPORT.MES[ 9] COLUMN-LABEL "Agosto"
       T-REPORT.MES[10] COLUMN-LABEL "Septiembre"
       T-REPORT.MES[11] COLUMN-LABEL "Octubre"
       T-REPORT.MES[12] COLUMN-LABEL "Noviembre"
       T-REPORT.MES[13] COLUMN-LABEL "Diciembre"
       T-REPORT.SALDO   COLUMN-LABEL "Total"
    HEADER
        S-NOMCIA       "FECHA : " TO 220 TODAY TO 230        SKIP
        "PAGINA :" TO 220 c-pagina FORMAT "ZZ9"   TO 230     SKIP
        "HORA   :" TO 220 STRING(TIME,"HH:MM AM") TO 230     SKIP(2)
        x-titulo   FORMAT "X(245)"                           SKIP    
        pinta-mes  FORMAT "X(245)"                           SKIP
        x-expres   FORMAT "X(245)"                           SKIP
        T-NOMDIV   FORMAT "X(245)"                           SKIP(2)
        WITH WIDTH 280 NO-BOX DOWN STREAM-IO.

P-Ancho  = FRAME f-cab:WIDTH.        
                     
DO  WITH FRAME F-CAB :
    IF C-COPIAS = 1 THEN DO:
       DISPLAY "Seleccionando información solicitada" @ X-MENSAJE WITH FRAME F-AUXILIAR.
       PAUSE 0.
       DO JJ = 1 TO NUM-ENTRIES(x-codope) :
          C-CODOPE = ENTRY(JJ,x-codope).
          X-SDO-M = 0.
          FOR EACH cb-dmov NO-LOCK WHERE 
                   cb-dmov.codcia  = s-codcia    AND 
                   cb-dmov.periodo = s-periodo   AND 
                   cb-dmov.codope  = C-CODOPE    AND 
                   cb-dmov.codcta >= x-cta-ini   AND 
                   cb-dmov.codcta <= x-cta-fin   AND 
                   cb-dmov.nromes  >= c-1        AND 
                   cb-dmov.nromes  <= c-2        AND 
                   cb-dmov.coddiv BEGINS (x-div)  
                   BREAK BY cb-dmov.codcia
                         BY cb-dmov.periodo
                         BY cb-dmov.codope
                         BY {&CONDICION}
                         BY CB-DMOV.CODCTA
                   ON ERROR UNDO, LEAVE:
              IF O-AUTO AND cb-dmov.TPOITM = "A" THEN NEXT.
                
              IF FIRST-OF({&CONDICION})  THEN DO:
                  FIND FIRST T-REPORT WHERE T-REPORT.CODCTA = {&CONDICION} NO-ERROR.
                  IF NOT AVAILABLE T-REPORT THEN CREATE T-REPORT.
                  ASSIGN T-REPORT.CODCTA = {&CONDICION}.
                  FIND FIRST cb-ctas WHERE 
                       cb-ctas.CODCIA = cb-codcia AND
                       cb-ctas.CODCTA = {&CONDICION}
                       NO-LOCK NO-ERROR.
                  IF AVAIL cb-ctas THEN T-REPORT.NOMCTA = cb-ctas.NOMCTA.                   
              END. 
              IF FIRST-OF(CB-DMOV.CODCTA) THEN DO:
                  DISPLAY "Procesando cuenta: " + cb-dmov.codcta + " - " + cb-dmov.codOpe @ x-mensaje WITH FRAME F-AUXILIAR.
                  PAUSE 0.
                  X-SDO-M = 0.
                  FIND FIRST T-REPORT WHERE T-REPORT.CODCTA = cb-dmov.codcta NO-ERROR.
                  IF NOT AVAILABLE T-REPORT THEN CREATE T-REPORT.
                  ASSIGN T-REPORT.CODCTA = cb-dmov.codcta.
                  FIND cb-ctas WHERE 
                       cb-ctas.CODCIA = cb-codcia AND
                       cb-ctas.CODCTA = cb-dmov.codcta  NO-LOCK NO-ERROR. 
                  IF AVAIL cb-ctas THEN T-REPORT.NOMCTA = cb-ctas.NOMCTA.
              END. 
              IF NOT tpomov THEN DO:
                 CASE x-codmon:
                      WHEN 1 THEN DO:
                             x-sdo-m = x-sdo-m + cb-dmov.impmn1.
                             IF X-FORMATO = 2 THEN
                               T-REPORT.MES[CB-DMOV.NROMES + 1] = T-REPORT.MES[CB-DMOV.NROMES + 1] + cb-dmov.impmn1.
                          END.
                      WHEN 2 THEN DO:
                             x-sdo-m = x-sdo-m + cb-dmov.impmn2.
                             IF X-FORMATO = 2 THEN 
                                T-REPORT.MES[CB-DMOV.NROMES + 1] = T-REPORT.MES[CB-DMOV.NROMES + 1] + cb-dmov.impmn2.
                          END.
                 END CASE.
              END.
              IF tpomov THEN DO:
                 CASE x-codmon:
                      WHEN 1 THEN DO:
                             x-sdo-m = x-sdo-m - cb-dmov.impmn1.
                             IF X-FORMATO = 2 THEN
                                T-REPORT.MES[CB-DMOV.NROMES + 1] = T-REPORT.MES[CB-DMOV.NROMES + 1] - cb-dmov.impmn1.
                          END.   
                      WHEN 2 THEN DO:
                             x-sdo-m = x-sdo-m - cb-dmov.impmn2.
                             IF X-FORMATO = 2 THEN
                                T-REPORT.MES[CB-DMOV.NROMES + 1] = T-REPORT.MES[CB-DMOV.NROMES + 1] - cb-dmov.impmn2.
                          END.
                 END CASE.
              END.    
              IF LAST-OF (CB-DMOV.CODCTA) THEN DO:
                 ASSIGN T-REPORT.SALDO = T-REPORT.SALDO  + X-SDO-M.
                 FIND B-T-REPORT WHERE B-T-REPORT.CODCTA = {&CONDICION} NO-ERROR.
                 IF AVAIL B-T-REPORT THEN DO:
                    message T-REPORT.MES[ 2].
                     B-T-REPORT.SALDO  = B-T-REPORT.SALDO + + X-SDO-M.
                     IF X-FORMATO = 2 THEN 
                        ASSIGN  B-T-REPORT.MES[ 1] = B-T-REPORT.MES[ 1] + T-REPORT.MES[ 1]
                                B-T-REPORT.MES[ 2] = B-T-REPORT.MES[ 2] + T-REPORT.MES[ 2]
                                B-T-REPORT.MES[ 3] = B-T-REPORT.MES[ 3] + T-REPORT.MES[ 3]
                                B-T-REPORT.MES[ 4] = B-T-REPORT.MES[ 4] + T-REPORT.MES[ 4]
                                B-T-REPORT.MES[ 5] = B-T-REPORT.MES[ 5] + T-REPORT.MES[ 5]
                                B-T-REPORT.MES[ 6] = B-T-REPORT.MES[ 6] + T-REPORT.MES[ 6]
                                B-T-REPORT.MES[ 7] = B-T-REPORT.MES[ 7] + T-REPORT.MES[ 7]
                                B-T-REPORT.MES[ 8] = B-T-REPORT.MES[ 8] + T-REPORT.MES[ 8]
                                B-T-REPORT.MES[ 9] = B-T-REPORT.MES[ 9] + T-REPORT.MES[ 9]
                                B-T-REPORT.MES[10] = B-T-REPORT.MES[10] + T-REPORT.MES[10]
                                B-T-REPORT.MES[11] = B-T-REPORT.MES[11] + T-REPORT.MES[11]
                                B-T-REPORT.MES[12] = B-T-REPORT.MES[12] + T-REPORT.MES[12]
                                B-T-REPORT.MES[13] = B-T-REPORT.MES[13] + T-REPORT.MES[13].                 
                 END.
                 /*
                 ACCUMULATE x-SDO-M           (SUB-TOTAL BY {&CONDICION} ).
                 IF X-FORMATO = 2 THEN DO:
                        ACCUMULATE T-REPORT.MES[ 1]  (SUB-TOTAL BY {&CONDICION}).
                        ACCUMULATE T-REPORT.MES[ 2]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 3]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 4]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 5]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 6]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 7]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 8]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[ 9]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[10]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[11]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[12]  (SUB-TOTAL BY {&CONDICION} ).
                        ACCUMULATE T-REPORT.MES[13]  (SUB-TOTAL BY {&CONDICION} ).
                 END.
                 */
              END.
              /*
              IF LAST-OF ({&CONDICION})   THEN DO:
                 FIND T-REPORT WHERE T-REPORT.CODCTA = {&CONDICION} NO-ERROR.
                 IF AVAIL T-REPORT THEN 
                    T-REPORT.SALDO  = T-REPORT.SALDO + ACCUM SUB-TOTAL BY {&CONDICION} X-SDO-M .
                 
                 IF X-FORMATO = 2 THEN 
                     ASSIGN  T-REPORT.MES[ 1] = T-REPORT.MES[ 1] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 1]
                             T-REPORT.MES[ 2] = T-REPORT.MES[ 2] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 2]
                             T-REPORT.MES[ 3] = T-REPORT.MES[ 3] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 3]
                             T-REPORT.MES[ 4] = T-REPORT.MES[ 4] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 4]
                             T-REPORT.MES[ 5] = T-REPORT.MES[ 5] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 5]
                             T-REPORT.MES[ 6] = T-REPORT.MES[ 6] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 6]
                             T-REPORT.MES[ 7] = T-REPORT.MES[ 7] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 7]
                             T-REPORT.MES[ 8] = T-REPORT.MES[ 8] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 8]
                             T-REPORT.MES[ 9] = T-REPORT.MES[ 9] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[ 9]
                             T-REPORT.MES[10] = T-REPORT.MES[10] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[10]
                             T-REPORT.MES[11] = T-REPORT.MES[11] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[11]
                             T-REPORT.MES[12] = T-REPORT.MES[12] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[12]
                             T-REPORT.MES[13] = T-REPORT.MES[13] + ACCUM SUB-TOTAL BY {&CONDICION} T-REPORT.MES[13].
              END.
              */
          END. /* FIN DEL FOR EACH */        
       END.
    END.
       
    HIDE FRAME F-AUXILIAR.
    VIEW FRAME F-MENSAJE.
    PAUSE 0.
    IF X-FORMATO = 1 THEN DO:
       FOR EACH T-REPORT USE-INDEX IDX01:
           IF LENGTH(T-REPORT.CODCTA) = 2 THEN DO:
              {&NEW-PAGE}.
              DISPLAY STREAM REPORT WITH FRAME F-CAB.
              DOWN STREAM REPORT WITH FRAME F-CAB.
           END.
           IF LENGTH(T-REPORT.CODCTA) = X-MAX-NIVEL THEN DO:
              ACCUMULATE T-REPORT.SALDO  (TOTAL).       
           END.
           {&NEW-PAGE}.
           DISPLAY STREAM report
                   T-REPORT.CODCTA
                   T-REPORT.NOMCTA
                   T-REPORT.SALDO WITH FRAME F-CAB.
           DOWN STREAM REPORT WITH FRAME F-CAB.
       END.
       {&NEW-PAGE}.
       UNDERLINE STREAM report
                 T-REPORT.CODCTA
                 T-REPORT.NOMCTA
                 T-REPORT.SALDO  WITH FRAME F-CAB.    
       DOWN STREAM REPORT WITH FRAME F-CAB.
       DISPLAY  STREAM report
                "....T o t a l "       @ T-REPORT.NOMCTA
            ACCUM TOTAL T-REPORT.SALDO @ T-REPORT.SALDO    WITH FRAME F-CAB.    
       RETURN.
    END.
END. /* FIN DEL DO WITH */

DO WITH FRAME F-CAB-1 :
   FOR EACH T-REPORT USE-INDEX IDX01:
       IF LENGTH(T-REPORT.CODCTA) = X-MAX-NIVEL THEN DO:
            ACCUMULATE T-REPORT.SALDO    (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 1]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 2]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 3]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 4]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 5]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 6]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 7]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 8]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[ 9]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[10]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[11]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[12]  (TOTAL).       
            ACCUMULATE T-REPORT.MES[13]  (TOTAL).       
       END.
       IF LENGTH(T-REPORT.CODCTA) = 2 THEN DO:
           {&NEW-PAGE}.
           DISPLAY STREAM REPORT WITH FRAME F-CAB-1.
           DOWN STREAM REPORT WITH FRAME F-CAB-1.
       END.
       {&NEW-PAGE}.
       DISPLAY STREAM report
            T-REPORT.CODCTA
            T-REPORT.NOMCTA
            T-REPORT.MES[ 1]  WHEN  T-REPORT.MES[ 1] <> 0
            T-REPORT.MES[ 2]  WHEN  T-REPORT.MES[ 2] <> 0
            T-REPORT.MES[ 3]  WHEN  T-REPORT.MES[ 3] <> 0
            T-REPORT.MES[ 4]  WHEN  T-REPORT.MES[ 4] <> 0
            T-REPORT.MES[ 5]  WHEN  T-REPORT.MES[ 5] <> 0
            T-REPORT.MES[ 6]  WHEN  T-REPORT.MES[ 6] <> 0
            T-REPORT.MES[ 7]  WHEN  T-REPORT.MES[ 7] <> 0
            T-REPORT.MES[ 8]  WHEN  T-REPORT.MES[ 8] <> 0
            T-REPORT.MES[ 9]  WHEN  T-REPORT.MES[ 9] <> 0
            T-REPORT.MES[10]  WHEN  T-REPORT.MES[10] <> 0
            T-REPORT.MES[11]  WHEN  T-REPORT.MES[11] <> 0
            T-REPORT.MES[12]  WHEN  T-REPORT.MES[12] <> 0
            T-REPORT.MES[13]  WHEN  T-REPORT.MES[13] <> 0
            T-REPORT.SALDO
            WITH FRAME F-CAB-1.    
       DOWN STREAM REPORT WITH FRAME F-CAB-1.
   END.
   {&NEW-PAGE}.
   UNDERLINE STREAM report
            T-REPORT.CODCTA
            T-REPORT.NOMCTA
            T-REPORT.MES[ 1]
            T-REPORT.MES[ 2]
            T-REPORT.MES[ 3]
            T-REPORT.MES[ 4]
            T-REPORT.MES[ 5]
            T-REPORT.MES[ 6]
            T-REPORT.MES[ 7]
            T-REPORT.MES[ 8]
            T-REPORT.MES[ 9]
            T-REPORT.MES[10]
            T-REPORT.MES[11]
            T-REPORT.MES[12]
            T-REPORT.MES[13]
            T-REPORT.SALDO
        WITH FRAME F-CAB-1.    
   DOWN STREAM REPORT WITH FRAME F-CAB-1.
   DISPLAY  STREAM report
            "Total "         @ T-REPORT.CODCTA
        ACCUM TOTAL T-REPORT.MES[ 1] @ T-REPORT.MES[ 1]
        ACCUM TOTAL T-REPORT.MES[ 2] @ T-REPORT.MES[ 2]
        ACCUM TOTAL T-REPORT.MES[ 3] @ T-REPORT.MES[ 3]
        ACCUM TOTAL T-REPORT.MES[ 4] @ T-REPORT.MES[ 4]
        ACCUM TOTAL T-REPORT.MES[ 5] @ T-REPORT.MES[ 5]
        ACCUM TOTAL T-REPORT.MES[ 6] @ T-REPORT.MES[ 6]
        ACCUM TOTAL T-REPORT.MES[ 7] @ T-REPORT.MES[ 7]
        ACCUM TOTAL T-REPORT.MES[ 8] @ T-REPORT.MES[ 8]
        ACCUM TOTAL T-REPORT.MES[ 9] @ T-REPORT.MES[ 9]
        ACCUM TOTAL T-REPORT.MES[10] @ T-REPORT.MES[10]
        ACCUM TOTAL T-REPORT.MES[11] @ T-REPORT.MES[11]
        ACCUM TOTAL T-REPORT.MES[12] @ T-REPORT.MES[12]
        ACCUM TOTAL T-REPORT.MES[13] @ T-REPORT.MES[13]
        ACCUM TOTAL T-REPORT.SALDO   @ T-REPORT.SALDO 
        WITH FRAME F-CAB-1.    
END.
*/
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

