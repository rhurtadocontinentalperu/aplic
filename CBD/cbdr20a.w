&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,4,5".
DEFINE        VARIABLE P-config  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina " NO-UNDO.
DEFINE        VARIABLE c-Copias  AS INTEGER NO-UNDO.
DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
DEFINE        VARIABLE Ult-Nivel   AS INTEGER NO-UNDO.
DEFINE        VARIABLE Max-Digitos AS INTEGER NO-UNDO.
    

DEFINE        VARIABLE cb-codcia AS INTEGER NO-UNDO INIT 0.
DEFINE        VARIABLE pv-codcia AS INTEGER NO-UNDO INIT 0.
DEFINE        VARIABLE cl-codcia AS INTEGER NO-UNDO INIT 0.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO .


/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

/*VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-ClfAux   LIKE cb-dmov.ClfAux NO-UNDO.
DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
DEFINE VARIABLE x-CodDoc   LIKE cb-dmov.CodDoc NO-UNDO.
DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
DEFINE VARIABLE XsCodDiv   LIKE cb-dmov.CodDiv NO-UNDO.
DEFINE VARIABLE XsNomDiv   LIKE cb-dmov.GLODOC NO-UNDO.
DEFINE VARIABLE XlDiv      AS LOGICAL NO-UNDO .
DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.

DEFINE VARIABLE Xfdiv1     AS DECIMAL.
DEFINE VARIABLE Xfdiv2     AS DECIMAL.
DEFINE VARIABLE Xfdiv3     AS DECIMAL.
DEFINE VARIABLE Xfdiv4     AS DECIMAL.

DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
DEFINE VARIABLE x-saldof   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "A c t u a l    !Acreedor   " NO-UNDO.

DEFINE VARIABLE a-debe     AS DECIMAL NO-UNDO.
DEFINE VARIABLE a-haber    AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-debe     AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-haber    AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-saldoi   AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-saldof   AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-deudor   AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-acreedor AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-conreg   AS INTEGER NO-UNDO.
DEFINE VARIABLE impca1     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca2     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca3     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca4     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca5     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca6     AS DECIMAL NO-UNDO.

DEFINE VARIABLE v-Saldoi   AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-Debe     AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-Haber    AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-CodCta   AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-CodDiv   AS CHARACTER EXTENT 10 NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 3.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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


def var x-coddiv like cb-dmov.coddiv.
DEFINE FRAME f-cab
        x-coddiv       COLUMN-LABEL "Cod.!Div."
        x-cco          COLUMN-LABEL "C.Cos"
        x-fchast       COLUMN-LABEL "Fecha! Ast."
        x-nroast       COLUMN-LABEL "Compro!bante"  
        x-codope       COLUMN-LABEL "Li-!bro"
        x-ClfAux       COLUMN-LABEL "Clf!Aux"
        x-codaux       COLUMN-LABEL "Cod.!Auxiliar"
        x-fchdoc       COLUMN-LABEL "Fecha! Doc."
        x-CodDoc       COLUMN-LABEL "Cod!Doc"
        x-nrodoc   
        x-fchvto       COLUMN-LABEL "Fecha! Vto."
        x-nroref   
        x-glodoc       FORMAT "X(50)"     
        x-saldoi  
        x-debe
        x-haber  
        x-saldof       COLUMN-LABEL "Saldo     !Final     "
        HEADER
        S-NOMCIA FORMAT "X(50)"
        "L I B R O   M A Y O R   G E N E R A L   P O R   D I V I S I O N" TO 117
        /*"FECHA : " TO 180 TODAY TO 190*/
        SKIP
        pinta-mes AT 67
        "PAGINA :" TO 180 c-pagina FORMAT "ZZ9" TO 190 
        x-expres  AT 67
        "HORA   :" TO 180 STRING(TIME,"HH:MM AM") TO 190
        SKIP(2)
        WITH WIDTH 255 NO-BOX DOWN STREAM-IO.


def var x-codmon as integer init 1.
def var x-clfaux-1 as char.
def var x-clfaux-2 as char.

DEF VAR G-NOMCTA AS CHAR FORMAT "X(60)".
DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
DEFINE FRAME F-AUXILIAR
     X-MENSAJE
WITH TITLE "Espere un momento por favor" VIEW-AS DIALOG-BOX CENTERED
          NO-LABELS.

DEFINE VAR C-DEBE AS DECIMAL.
DEFINE VAR C-HABER AS DECIMAL.
DEFINE VAR C-SALDOI AS DECIMAL.

DEFINE TEMP-TABLE T-DIV
 FIELD CODDIV AS CHAR
 FIELD NOMDIV AS CHAR
 INDEX IDX01 CODDIV.

DEFINE BUFFER DETALLE FOR CB-DMOV.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-4 RECT-5 RADIO-SET-1 C-Moneda ~
C-Mes B-impresoras B-imprime Y-CodDiv y-codope x-cta-ini x-cta-fin ~
x-auxiliar B-cancela RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 C-Moneda C-Mes Y-CodDiv ~
y-codope x-cta-ini x-cta-fin x-auxiliar RB-NUMBER-COPIES RB-BEGIN-PAGE ~
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
     SIZE 11 BY 1.08.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY 1.08.

DEFINE VARIABLE C-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","D¾lares" 
     SIZE 16 BY 1
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

DEFINE VARIABLE x-auxiliar AS CHARACTER FORMAT "X(11)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cta-fin AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-cta-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE Y-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10.43 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64.72 BY 4.23.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64.72 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64.72 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     RADIO-SET-1 AT ROW 6.5 COL 2 NO-LABEL
     C-Moneda AT ROW 1.31 COL 9.29 COLON-ALIGNED
     C-Mes AT ROW 2.31 COL 9.14 COLON-ALIGNED
     B-impresoras AT ROW 7.5 COL 13.57
     b-archivo AT ROW 8.5 COL 13.57
     B-imprime AT ROW 10.54 COL 12
     RB-OUTPUT-FILE AT ROW 8.77 COL 17.57 COLON-ALIGNED NO-LABEL
     Y-CodDiv AT ROW 1.31 COL 41 COLON-ALIGNED
     y-codope AT ROW 2.04 COL 41 COLON-ALIGNED
     x-cta-ini AT ROW 2.73 COL 41 COLON-ALIGNED
     x-cta-fin AT ROW 3.46 COL 41 COLON-ALIGNED
     x-auxiliar AT ROW 4.19 COL 41 COLON-ALIGNED
     B-cancela AT ROW 10.54 COL 42
     RB-NUMBER-COPIES AT ROW 6.62 COL 57.57 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 7.62 COL 57.57 COLON-ALIGNED
     RB-END-PAGE AT ROW 8.62 COL 57.57 COLON-ALIGNED
     RECT-6 AT ROW 9.96 COL 1
     RECT-4 AT ROW 1 COL 1
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 64.57 BY .69 AT ROW 5.31 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 6 COL 1
     SPACE(0.00) SKIP(1.96)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Libro Mayor General x Divisi¾n".


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
ON GO OF FRAME DIALOG-1 /* Libro Mayor General x Divisi¾n */
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
        TITLE      "Archivo de Impresi¾n ..."
        FILTERS    "Archivos Impresi¾n (*.txt)"   "*.txt",
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
        ASSIGN x-cta-ini 
               x-cta-fin
               c-mes
               Y-CodDiv
               y-CodOpe
               x-auxiliar.
               
        IF x-cta-fin < x-cta-ini 
        THEN DO:
            BELL.
            MESSAGE "La cuenta fin es menor" SKIP
                    "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO x-cta-ini.
            RETURN NO-APPLY.
        END.
    ASSIGN x-Cta-Fin = SUBSTR( x-Cta-Fin + "9999999999", 1, 10).

    RUN bin/_mes.p ( INPUT c-Mes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.

    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-moneda,  40 , OUTPUT x-moneda ).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

    P-largo  = 66.
    P-Ancho  = FRAME f-cab:WIDTH.
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


&Scoped-define SELF-NAME C-Moneda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Moneda DIALOG-1
ON VALUE-CHANGED OF C-Moneda IN FRAME DIALOG-1 /* Moneda */
DO:
  
  x-codmon = lookup (self:screen-value,c-moneda:list-items).
  
                                   
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


&Scoped-define SELF-NAME x-auxiliar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-auxiliar DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF x-auxiliar IN FRAME DIALOG-1 /* Auxiliar */
OR "F8" OF X-AUXILIAR DO:

x-clfaux = "".
assign
  x-clfaux-1 = ""
  x-clfaux-2 = "".
  
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-ini:screen-value
                   no-lock no-error.
                   
if avail cb-ctas then  x-clfaux-1 = cb-ctas.clfaux.
                      
find cb-ctas where cb-ctas.codcia = cb-codcia and
                   cb-ctas.codcta = x-cta-fin:screen-value
                   no-lock no-error.
if avail cb-ctas then  x-clfaux-2 = cb-ctas.clfaux.

if x-clfaux-1 = x-clfaux-2 then x-clfaux = x-clfaux-1.

if x-clfaux-1 <> "" and  x-clfaux-2  = "" then return no-apply.
if x-clfaux-1 =  "" and  x-clfaux-2 <> "" then return no-apply.


if x-clfaux = "" then return.
  

  
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  

    
    CASE X-CLFAUX :
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov
            THEN  SELF:SCREEN-VALUE  = gn-prov.CodPro.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie
            THEN SELF:SCREEN-VALUE  = gn-clie.codcli.
        END.
    END.
    WHEN "@CT" THEN DO:
            RUN cbd/q-ctas2.w(cb-codcia, "9", OUTPUT T-RECID).
            IF T-RECID <> ?
            THEN DO:
                find cb-ctas WHERE RECID(cb-ctas) = T-RECID NO-LOCK  NO-ERROR.
                IF avail cb-ctas
                THEN  self:screen-value = cb-ctas.CodCta.
            END.
  
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia, X-ClfAux , OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN self:screen-value = cb-auxi.CodAux.
        END.
    END.
    END CASE.
  
  
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-fin DIALOG-1
ON F8 OF x-cta-fin IN FRAME DIALOG-1 /* Hasta la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-FIN DO:
   {ADM/H-CTAS01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-cta-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta-ini DIALOG-1
ON F8 OF x-cta-ini IN FRAME DIALOG-1 /* Desde la Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA-INI DO: 
   {ADM/H-CTAS01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Y-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Y-CodDiv DIALOG-1
ON F8 OF Y-CodDiv IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CodDiv DO: 
   {CBD/H-DIVI01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-codope DIALOG-1
ON F8 OF y-codope IN FRAME DIALOG-1 /* Operación */
DO:
   DEF VAR X AS RECID.
   RUN cbd/q-oper(cb-codcia,output X).
   FIND cb-oper WHERE RECID(cb-oper) = X
        NO-LOCK NO-ERROR.
   IF AVAILABLE cb-oper THEN DO:
        ASSIGN {&SELF-NAME} = cb-oper.CodOpe.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
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
assign c-mes = s-nromes.
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
  DISPLAY RADIO-SET-1 C-Moneda C-Mes Y-CodDiv y-codope x-cta-ini x-cta-fin 
          x-auxiliar RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-4 RECT-5 RADIO-SET-1 C-Moneda C-Mes B-impresoras B-imprime 
         Y-CodDiv y-codope x-cta-ini x-cta-fin x-auxiliar B-cancela 
         RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Detalle DIALOG-1 
PROCEDURE Imp-Detalle :
def var xi as integer init 0.
ASSIGN c-debe   = 0
       c-haber  = 0
       c-saldoi = 0
       x-saldoi = 0 
       xi       = 0 .
       hide frame f-auxiliar.
       view frame f-mensaje.
       {&NEW-PAGE}.
       DISPLAY STREAM report WITH FRAME f-cab.
       PUT STREAM report CONTROL P-dobleon.
       G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
       PUT STREAM report G-NOMCTA.
       PUT STREAM report CONTROL P-dobleoff.  
       DOWN STREAM report WITH FRAME f-cab.
       
FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                           AND cb-dmov.periodo = s-periodo 
                           AND cb-dmov.nromes  = c-mes
                           AND cb-dmov.codope BEGINS (y-codope)
                           AND cb-dmov.codcta  = x-CodCta
                           AND cb-dmov.codaux  begins x-auxiliar
                           and cb-dmov.coddiv  begins y-coddiv
                  BREAK BY cb-dmov.coddiv
                        BY cb-dmov.CodOpe
                        BY cb-dmov.NroAst:
    
      if y-codope   = "" and
         y-coddiv   = "" and
         x-auxiliar = "" and
         FIRST-OF(cb-dmov.coddiv)
      then  
      DO:
      x-conreg = 0.
      FOR EACH T-DIV WHERE T-DIV.CODDIV <= CB-DMOV.CODDIV :
         ASSIGN x-saldoi = 0.      
         FOR EACH DETALLE NO-LOCK WHERE DETALLE.codcia  = s-codcia
                                 AND DETALLE.periodo = s-periodo 
                                 AND DETALLE.NROMES  < c-mes
                                 AND DETALLE.CODCTA  = x-CodCta 
                                 AND DETALLE.CODDIV  = T-DIV.CODDIV :
                           
             case x-codmon :
                when 1 then if (not detalle.tpomov) 
                       then x-saldoi = x-saldoi + DETALLE.impmn1.
                       else x-saldoi = x-saldoi - DETALLE.impmn1.     
                when 2 then if (not DETALLE.tpomov) 
                       then x-saldoi = x-saldoi + DETALLE.impmn2.
                       else x-saldoi = x-saldoi - DETALLE.impmn2.     
            end case.

        END.
        t-saldoi = t-saldoi + x-saldoi.
        c-saldoi = c-saldoi + x-saldoi.

        ASSIGN x-nroast = x-codcta
               x-GloDoc = ""
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = ""
               x-fchVto = ""
               x-nroref = ""
               x-coddiv = t-div.coddiv.


       if x-saldoi <> 0 then do:
         x-GloDoc = "S a l d o  I n i c i a l " .
         xi = xi + 1.
         hide frame f-auxiliar.
         view frame f-mensaje.
        {&NEW-PAGE}.
        DISPLAY STREAM report WITH FRAME f-cab.
        PUT STREAM report CONTROL P-dobleon.
        G-NOMCTA = T-DIV.CODDIV  + " " + T-DIV.NOMDIV.
        PUT STREAM report G-NOMCTA.
        PUT STREAM report CONTROL P-dobleoff.  
        DOWN STREAM report WITH FRAME f-cab.
        {&NEW-PAGE}.
        DISPLAY STREAM report x-fchast
                      x-coddiv
                      x-nroast
                      x-codope              
                      x-fchdoc
                      x-nrodoc
                      x-fchvto
                      x-nroref
                      x-glodoc 
                      x-saldoi
              WITH FRAME f-cab.
       DOWN STREAM report WITH FRAME F-cab.
    end. /* FIN DEL SALDO INICIAL */
    END. /* FIN DEL FOR EACH T-DIV */
   
    FOR EACH T-DIV WHERE T-DIV.CODDIV <= CB-DMOV.CODDIV :      
        DELETE T-DIV.
    END.
    END. /* FIN DEL PRIMER IF */
     
    /* Buscando la cabecera correspondiente */
    x-fchast = ?.
    FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                   AND cb-cmov.periodo = cb-dmov.periodo 
                   AND cb-cmov.nromes  = cb-dmov.nromes
                   AND cb-cmov.codope  = cb-dmov.codope
                   AND cb-cmov.nroast  = cb-dmov.nroast
                   NO-LOCK NO-ERROR.
     IF AVAILABLE cb-cmov 
     THEN x-fchast = STRING(cb-cmov.fchast).
     ASSIGN x-glodoc = cb-dmov.glodoc
            x-NroAst = cb-dmov.NroAst
            x-CodOpe = cb-dmov.CodOpe
            x-codaux = cb-dmov.codaux
            x-NroDoc = cb-dmov.NroDoc
            x-NroRef = cb-dmov.NroRef
            x-coddiv = cb-dmov.CodDiv
            x-clfaux = cb-dmov.clfaux
            x-coddoc = cb-dmov.coddoc
            x-cco    = cb-dmov.cco.
            
     IF x-glodoc = "" 
     THEN IF AVAILABLE cb-cmov 
          THEN x-glodoc = cb-cmov.notast.
     IF  x-glodoc = ""
     THEN DO:
        CASE cb-dmov.clfaux:
            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                AND gn-clie.CodCia = cl-codcia
                            NO-LOCK NO-ERROR. 
                IF AVAILABLE gn-clie THEN
                    x-glodoc = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                AND gn-prov.CodCia = pv-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE gn-prov THEN 
                    x-glodoc = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                                AND cb-ctas.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN 
                    x-glodoc = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                AND cb-auxi.codaux = cb-dmov.codaux
                                AND cb-auxi.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN 
                    x-glodoc = cb-auxi.nomaux.
            END.
        END CASE.
    END.
 
    IF NOT cb-dmov.tpomov 
    THEN DO:
        CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = cb-dmov.ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = cb-dmov.ImpMn2.
                x-haber = 0.
            END.
        END CASE.
    END.
    ELSE DO:      
        CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = cb-dmov.ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = cb-dmov.ImpMn2.
            END.
        END CASE.            
    END.
    {&NEW-PAGE}.
    IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ?
    THEN DO:
        x-fchdoc = STRING(cb-dmov.fchdoc).  
        x-fchvto = STRING(cb-dmov.fchvto).
        /* Acumulando 
        DO i = 1 to 10:
            v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
            v-Haber[ i ] = v-Haber[ i ] + x-Haber.
        END.
        */
        
        t-Debe  = t-Debe  + x-Debe.
        t-Haber = t-Haber + x-Haber.
        c-Debe  = c-Debe  + x-Debe.
        c-Haber = c-Haber + x-Haber.
        
        ACCUMULATE x-debe   ( SUB-TOTAL BY cb-dmov.coddiv).
        ACCUMULATE x-haber  ( SUB-TOTAL BY cb-dmov.coddiv).
        
        DISPLAY STREAM report x-coddiv
                              x-cco 
                              x-fchast WHEN (x-fchast <> ?)
                              x-nroast
                              x-codope
                              x-clfaux
                              x-codaux              
                              x-fchdoc WHEN (x-fchdoc <> ?)
                              x-coddoc
                              x-nrodoc
                              x-fchvto WHEN (x-fchvto <> ?)
                              x-nroref
                              x-glodoc 
                              x-debe   WHEN (x-debe  <> 0)
                              x-haber  WHEN (x-haber <> 0)
              WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME F-cab.
        x-conreg = x-conreg + 1.
    END.            
    
    if y-codope   = "" and
       y-coddiv   = "" and
       x-auxiliar = "" and
       LAST-OF(cb-dmov.coddiv) and
       x-conreg > 0 
       then do:
        ASSIGN x-nroast = x-codcta
               x-GloDoc = ""
               x-fchast = ""
               x-codope = ""
               x-fchDoc = ""
               x-nroDoc = ""
               x-fchVto = ""
               x-nroref = ""
               x-GloDoc = "T o t a l  D i v i s i ¾ n" 
               x-SaldoF = x-SaldoI  +
                          (accum sub-total by cb-dmov.coddiv x-debe ) -
                          (accum sub-total by cb-dmov.coddiv x-haber) .
                          
        {&NEW-PAGE}.
        DISPLAY STREAM report x-fchast
                      x-coddiv
                      x-nroast
                      x-codope              
                      x-fchdoc
                      x-nrodoc
                      x-fchvto
                      x-nroref
                      x-glodoc 
                      x-saldoi
                      accum sub-total by cb-dmov.coddiv x-debe   @ x-debe
                      accum sub-total by cb-dmov.coddiv x-haber  @ x-haber
                      x-saldof
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.
        UNDERLINE STREAM report x-fchast
                      x-coddiv
                      x-nroast
                      x-codope              
                      x-fchdoc
                      x-nrodoc
                      x-fchvto
                      x-nroref
                      x-glodoc 
                      x-saldoi
                      x-debe
                      x-haber
                      x-saldof
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.
         
    end.
END.


ASSIGN x-Debe   = c-Debe
       x-Haber  = c-Haber
       x-saldoi = c-saldoi
       x-SaldoF = x-SaldoI + x-Debe - x-Haber
       x-nroast = x-codcta
       x-fchast = ""
       x-codope = ""
       x-fchDoc = ""
       x-nroDoc = ""
       x-fchVto = "TOTAL"
       x-nroref = x-CodCta
       x-GloDoc = cb-ctas.NomCta.

UNDERLINE STREAM report x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.

DISPLAY STREAM report   x-fchvto
                        x-nroRef
                        x-GloDoc
                        x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.

UNDERLINE STREAM report x-fchast
                        x-nroast
                        x-codope              
                        x-fchdoc
                        x-nrodoc
                        x-fchvto
                        x-nroref
                        x-glodoc
                        x-Saldoi 
                        x-debe   
                        x-haber 
                        x-Saldof 
              WITH FRAME f-cab.
DOWN STREAM report WITH FRAME F-cab.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
P-largo  = 88. /* En el caso de 88 lineas por pßgina usando 8 lpi ( P-8lpi )
                      hay que definir en el triger "CHOOSE" de b-imprime en 66 
                      LÝneas por pßgina y aqui en 88.
                      Si se usa 6 lpi ( Default ) solo basta definir en
                      b-imprime.
                      ** OJO ** en b-imprime el P-largo configura a la impresora
                      a saltar en ese largo por pßgina
                      */
                       
    P-Config = P-20cpi + P-8lpi.
    x-Raya   = FILL("-", P-Ancho).
    def var con-ctas as integer.
    ASSIGN t-debe   = 0
           t-haber  = 0
           t-saldoi = 0
           t-saldof = 0
           con-ctas = 0 .

    display "Seleccionando informaci¾n solicitada" @ x-mensaje with frame f-auxiliar.
    pause 0.
    FOR EACH GN-DIVI WHERE GN-DIVI.CODCIA   = S-CODCIA AND
                     LENGTH(GN-DIVI.CODDIV) = 5 NO-LOCK :
        
        CREATE T-DIV.
        ASSIGN T-DIV.CODDIV = GN-DIVI.CODDIV
               T-DIV.NOMDIV = GN-DIVI.DESDIV.
    
    END.    

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
                               AND cb-ctas.codcta >= x-cta-ini
                               AND cb-ctas.codcta <= x-cta-fin
                               AND cb-ctas.CodCta <> ""
                               AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
            BREAK BY (cb-ctas.Codcta)
            ON ERROR UNDO, LEAVE:
        
        x-CodCta = cb-ctas.CodCta.

/*        
        if x-codope   = "" and
           y-coddiv   = "" and
           x-auxiliar = "" then
        RUN Quiebre.
 */
        
        RUN Imp-Detalle.
        con-ctas = con-ctas + 1 .
    END.
    /*
    x-CodCta = "".
    if x-codope   = "" and
       y-coddiv   = "" and
       x-auxiliar = "" then
       RUN Quiebre.
   */
   
hide frame f-auxiliar.

if con-ctas <= 1 then return.
   
ASSIGN x-saldoi = t-saldoi
       x-Debe   = t-Debe
       x-Haber  = t-Haber
       x-SaldoF = t-SaldoI + x-Debe - x-Haber
       x-nroast = x-codcta
       x-fchast = ""
       x-codope = ""
       x-fchDoc = ""
       x-nroDoc = ""
       x-fchVto = ""
       x-nroref = ""
       x-GloDoc = "T O T A L   G E N E R A L ".

UNDERLINE STREAM report x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.

DISPLAY STREAM report   x-fchvto
                        x-nroRef
                        x-GloDoc
                        x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.

UNDERLINE STREAM report x-fchast
                        x-nroast
                        x-codope              
                        x-fchdoc
                        x-nrodoc
                        x-fchvto
                        x-nroref
                        x-glodoc
                        x-Saldoi 
                        x-debe   
                        x-haber 
                        x-Saldof 
              WITH FRAME f-cab.
DOWN STREAM report WITH FRAME F-cab.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Quiebre DIALOG-1 
PROCEDURE Quiebre :
/* Solo puede haber quiebres cuando son todas las operaciones 
     IF NOT CodOpe = "" THEN RETURN. */
     DO i = (Ult-Nivel - 1) TO 1 BY -1 :
        IF NOT v-CodCta[ i ] = "" AND 
            ( NOT x-CodCta BEGINS v-CodCta[ i ] OR x-CodCta = "" )
        THEN DO:
            ASSIGN x-Saldoi = v-Saldoi[ i ]
                   x-Debe   = v-Debe[ i ]
                   x-Haber  = v-Haber[ i ]
                   x-SaldoF = x-SaldoI + x-Debe - x-Haber
                   x-nroast = ""
                   x-fchast = ""
                   x-codope = ""
                   x-fchDoc = ""
                   x-CodDoc = ""
                   x-nroDoc = FILL("*", i)
                   x-fchVto = "TOTAL"
                   x-nroref = v-CodCta[ i ]
                   x-GloDoc = ""
                   v-Saldoi[ i ] = 0
                   v-Debe[ i ]   = 0
                   v-Haber[ i ]  = 0.
            FIND B-Cuentas WHERE b-cuentas.CodCia = cb-codcia
                             AND b-cuentas.CodCta = v-CodCta[ i ]
                             NO-LOCK NO-ERROR.
            IF AVAILABLE B-Cuentas THEN x-GloDoc = b-cuentas.NomCta.
            v-CodCta[ i ] = "".
            {&NEW-PAGE}.
            DISPLAY STREAM report
                                    x-nrodoc
                                    x-fchvto
                                    x-nroRef
                                    x-GloDoc
                                    x-Saldoi 
                                    x-debe
                                    x-haber
                                    x-Saldof
                          WITH FRAME f-cab.
            DOWN STREAM report WITH FRAME f-cab.

            UNDERLINE STREAM report 
                        x-fchast
                        x-nroast
                        x-codope              
                        x-fchdoc
                        x-nrodoc
                        x-fchvto
                        x-nroref
                        x-glodoc
                        x-Saldoi 
                        x-debe   
                        x-haber 
                        x-Saldof 
                      WITH FRAME f-cab.
            DOWN STREAM report WITH FRAME F-cab.
            IF i = 1 THEN RUN NEW-PAGE.
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
  Purpose: Configura los codigos de escape de impresi¾n
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


