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

    DEF NEW SHARED VAR input-var-1 AS CHAR.
    DEF NEW SHARED VAR input-var-2 AS CHAR.
    DEF NEW SHARED VAR input-var-3 AS CHAR.
    DEF NEW SHARED VAR output-var-1 AS ROWID.
    DEF NEW SHARED VAR output-var-2 AS CHAR.
    DEF NEW SHARED VAR output-var-3 AS CHAR.

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
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,4,5".
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

/*VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(08)" NO-UNDO.
DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(08)" NO-UNDO.
DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(08)" NO-UNDO.
/*
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(2)" NO-UNDO.
DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
*/
DEFINE VARIABLE x-nromes   LIKE cb-dmov.nromes NO-UNDO.
DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
DEFINE VARIABLE x-nomaux   LIKE cb-auxi.nomaux NO-UNDO.
DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.
DEFINE VARIABLE x-Div      LIKE cb-dmov.CodDiv NO-UNDO.
DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.
DEFINE VARIABLE x-ClfAux   LIKE cb-dmov.ClfAux NO-UNDO.
DEFINE VARIABLE x-Coddoc   LIKE cb-dmov.CodDoc NO-UNDO.

DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-" 
                           COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
DEFINE VARIABLE y-saldoi   AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
DEFINE VARIABLE q-saldoi   AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.

DEFINE VARIABLE x-saldof   AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZZZZZZZ,ZZ9.99-" 
                           COLUMN-LABEL "A c t u a l    !Acreedor   " NO-UNDO.
DEFINE VARIABLE x-importe AS DECIMAL FORMAT "->>>>,>>9.99" 
                           COLUMN-LABEL "Importe S/." NO-UNDO. 

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


DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 5.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1997.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE s-DIRCIA AS CHARACTER FORMAT "X(40)".

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

DEFINE FRAME f-cab
        x-nromes       COLUMN-LABEL "Mes"
        x-fchast       COLUMN-LABEL "Dia"
        x-nroast       COLUMN-LABEL "Compro!bante"  
        x-codope       COLUMN-LABEL "Li-!bro"
        x-div          COLUMN-LABEL "Div"
        x-cco          FORMAT "xx" COLUMN-LABEL "CC"
        x-clfaux       COLUMN-LABEL "Clf!Aux"
        x-codaux       COLUMN-LABEL "Cod.!Auxiliar"
        x-fchdoc       COLUMN-LABEL "Fecha! Doc."
        x-coddoc       FORMAT "xx" COLUMN-LABEL "Co!Do"
        x-nrodoc
        x-nroref   
        x-glodoc       FORMAT "X(20)"      
        x-debe
        x-haber  
        x-importe
        x-saldof       COLUMN-LABEL "Saldo     !Final     "
        HEADER
        s-nomcia FORMAT "X(50)"
        "L I B R O   M A Y O R   G E N E R A L  A C U M U L A D O" TO 114
        /*"FECHA : " TO 162 TODAY TO 172    */
        SKIP
        pinta-mes AT 67
        "PAGINA :" TO 150 c-pagina FORMAT "ZZZ9" TO 160 skip
        x-expres  AT 67
        "HORA   :" TO 150 STRING(TIME,"HH:MM AM") TO 160  SKIP(2)
        WITH WIDTH 260 NO-BOX DOWN STREAM-IO.

DEFINE FRAME f-cab2
        x-nromes       COLUMN-LABEL "Mes"
        x-fchast       COLUMN-LABEL "Dia"
        x-nroast       COLUMN-LABEL "Compro!bante"  
        x-codope       COLUMN-LABEL "Li-!bro"
        x-div          COLUMN-LABEL "Div"
        x-cco          FORMAT "xx" COLUMN-LABEL "CC"
        x-clfaux       COLUMN-LABEL "Clf!Aux"
        x-codaux       COLUMN-LABEL "Cod.!Auxiliar"
        x-fchdoc       COLUMN-LABEL "Fecha! Doc."
        x-coddoc       FORMAT "xx" COLUMN-LABEL "Co!Do"
        x-nrodoc
        cb-dmov.OrdCmp COLUMN-LABEL "Orden!Compra"  
        x-glodoc       FORMAT "X(20)"      
        x-debe
        x-haber  
        x-importe
        x-saldof       COLUMN-LABEL "Saldo     !Final     "
        HEADER
        s-nomcia FORMAT "X(50)"
        "L I B R O   M A Y O R   G E N E R A L  A C U M U L A D O" TO 114
        /*"FECHA : " TO 162 TODAY TO 172    */
        SKIP
        pinta-mes AT 67
        "PAGINA :" TO 150 c-pagina FORMAT "ZZZ9" TO 160 skip
        x-expres  AT 67
        "HORA   :" TO 150 STRING(TIME,"HH:MM AM") TO 160  SKIP(2)
        WITH WIDTH 260 NO-BOX DOWN STREAM-IO.


def var x-clfaux-1 as char.
def var x-clfaux-2 as char.
def var x-codmon as integer init 1.

DEF  VAR G-NOMCTA AS CHAR FORMAT "X(60)".

def var x-mtmp as char.

DEF BUFFER b-cb-ctas FOR cb-ctas.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 C-Moneda X-CodDiv ~
cCodOpe C-Mes x-cta-ini x-cta-fin tg-ordcmp T-resumen x-Clasificacion ~
x-auxiliar TOGGLE-Sustento FILL-IN-Cco RADIO-SET-1 RB-NUMBER-COPIES ~
B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime btn-excel BUTTON-1 ~
BUTTON-2 B-cancela 
&Scoped-Define DISPLAYED-OBJECTS C-Moneda X-CodDiv cCodOpe C-Mes x-cta-ini ~
x-cta-fin tg-ordcmp T-resumen x-Clasificacion x-auxiliar TOGGLE-Sustento ~
FILL-IN-Cco RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Cancelar" 
     SIZE 11 BY 1.42.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "&Imprimir" 
     SIZE 11 BY 1.42.

DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 3" 
     SIZE 11 BY 1.42.

DEFINE BUTTON BUTTON-1 
     LABEL "TEXTO PLANO" 
     SIZE 15 BY 1.35.

DEFINE BUTTON BUTTON-2 
     LABEL "EXCEL PLANO" 
     SIZE 15 BY 1.35.

DEFINE VARIABLE C-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","Dólares" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cCodOpe AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Cco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
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

DEFINE VARIABLE x-Clasificacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Clasificacion" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
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

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69.72 BY 5.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69.72 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69.72 BY 2.

DEFINE VARIABLE T-resumen AS LOGICAL INITIAL no 
     LABEL "Saldo Apertura Resumido" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.14 BY .69 NO-UNDO.

DEFINE VARIABLE tg-ordcmp AS LOGICAL INITIAL no 
     LABEL "Incluir Orden de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sustento AS LOGICAL INITIAL no 
     LABEL "Filtrar por Gastos NO Sustentados" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     C-Moneda AT ROW 1.31 COL 9.57 COLON-ALIGNED
     X-CodDiv AT ROW 1.38 COL 53.43 COLON-ALIGNED
     cCodOpe AT ROW 2.08 COL 53.43 COLON-ALIGNED
     C-Mes AT ROW 2.31 COL 9.43 COLON-ALIGNED
     x-cta-ini AT ROW 2.85 COL 53.43 COLON-ALIGNED
     x-cta-fin AT ROW 3.62 COL 53.43 COLON-ALIGNED
     tg-ordcmp AT ROW 3.69 COL 3 WIDGET-ID 2
     T-resumen AT ROW 4.46 COL 3
     x-Clasificacion AT ROW 4.46 COL 32 COLON-ALIGNED
     x-auxiliar AT ROW 4.46 COL 53.43 COLON-ALIGNED
     TOGGLE-Sustento AT ROW 5.31 COL 3 WIDGET-ID 8
     FILL-IN-Cco AT ROW 5.31 COL 53.43 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET-1 AT ROW 7.46 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 7.65 COL 58.72 COLON-ALIGNED
     B-impresoras AT ROW 8.46 COL 15
     RB-BEGIN-PAGE AT ROW 8.65 COL 58.72 COLON-ALIGNED
     b-archivo AT ROW 9.46 COL 15
     RB-END-PAGE AT ROW 9.65 COL 58.72 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 9.73 COL 19 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 11.19 COL 2
     btn-excel AT ROW 11.19 COL 13 WIDGET-ID 4
     BUTTON-1 AT ROW 11.19 COL 23 WIDGET-ID 6
     BUTTON-2 AT ROW 11.19 COL 39 WIDGET-ID 12
     B-cancela AT ROW 11.19 COL 54
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 69.72 BY .62 AT ROW 6.38 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 6.96 COL 1
     RECT-6 AT ROW 10.92 COL 1
     SPACE(0.27) SKIP(0.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Libro Mayor General Acumulado".


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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Libro Mayor General Acumulado */
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
        ASSIGN x-cta-ini 
               x-cta-fin
               c-mes
               x-auxiliar
               x-coddiv
               cCodOpe
               t-resumen
               tg-ordcmp
            FILL-IN-Cco
            TOGGLE-Sustento.
               
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
    x-mtmp = pinta-mes.
    pinta-mes = "AL MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

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


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel DIALOG-1
ON CHOOSE OF btn-excel IN FRAME DIALOG-1 /* Button 3 */
DO:

    ASSIGN 
        x-cta-ini 
        x-cta-fin
        c-mes
        x-auxiliar
        x-coddiv
        cCodOpe
        t-resumen
        tg-ordcmp
        FILL-IN-Cco
        TOGGLE-Sustento.
    
    IF x-cta-fin < x-cta-ini THEN DO:
        BELL.
        MESSAGE "La cuenta fin es menor" SKIP
                "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-cta-ini.
        RETURN NO-APPLY.
    END.
    ASSIGN x-Cta-Fin = SUBSTR( x-Cta-Fin + "9999999999", 1, 10).
    RUN bin/_mes.p ( INPUT c-Mes , 1,  OUTPUT pinta-mes ).
    x-mtmp = pinta-mes.
    pinta-mes = "AL MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.
    IF tg-ordcmp THEN RUN ExcelT.
    ELSE RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 DIALOG-1
ON CHOOSE OF BUTTON-1 IN FRAME DIALOG-1 /* TEXTO PLANO */
DO:
    ASSIGN 
        x-cta-ini 
        x-cta-fin
        c-mes
        x-auxiliar
        x-coddiv
        cCodOpe
        FILL-IN-Cco
        t-resumen
        tg-ordcmp.
    
    IF x-cta-fin < x-cta-ini THEN DO:
        BELL.
        MESSAGE "La cuenta fin es menor" SKIP
                "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-cta-ini.
        RETURN NO-APPLY.
    END.
    ASSIGN x-Cta-Fin = SUBSTR( x-Cta-Fin + "9999999999", 1, 10).
    RUN bin/_mes.p ( INPUT c-Mes , 1,  OUTPUT pinta-mes ).
    x-mtmp = pinta-mes.
    pinta-mes = "AL MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.
    /*RUN Excel-2.*/
    RUN Texto-Plano.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 DIALOG-1
ON CHOOSE OF BUTTON-2 IN FRAME DIALOG-1 /* EXCEL PLANO */
DO:
    ASSIGN 
        x-cta-ini 
        x-cta-fin
        c-mes
        x-auxiliar
        x-coddiv
        cCodOpe
        FILL-IN-Cco
        t-resumen
        tg-ordcmp.
    
    IF x-cta-fin < x-cta-ini THEN DO:
        BELL.
        MESSAGE "La cuenta fin es menor" SKIP
                "que la cuenta inicio" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-cta-ini.
        RETURN NO-APPLY.
    END.
    ASSIGN x-Cta-Fin = SUBSTR( x-Cta-Fin + "9999999999", 1, 10).
    RUN bin/_mes.p ( INPUT c-Mes , 1,  OUTPUT pinta-mes ).
    x-mtmp = pinta-mes.
    pinta-mes = "AL MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    Ult-Nivel   = NUM-ENTRIES(cb-niveles).
    Max-Digitos = INTEGER( ENTRY( Ult-Nivel, cb-niveles) ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.
    RUN Excel-2.
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


&Scoped-define SELF-NAME cCodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodOpe DIALOG-1
ON LEFT-MOUSE-DBLCLICK OF cCodOpe IN FRAME DIALOG-1 /* Operación */
OR F8 OF ccodope DO:
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


&Scoped-define SELF-NAME FILL-IN-Cco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Cco DIALOG-1
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-Cco IN FRAME DIALOG-1 /* Centro de Costo */
OR F8 OF FILL-IN-Cco
DO:
  ASSIGN
    input-var-1 = 'CCO'
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-auxil ('Centro de Costos').
  IF output-var-1 <> ?
  THEN DO:
    FIND cb-auxi WHERE ROWID(cb-auxi) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi
    THEN DO:
        SELF:SCREEN-VALUE = cb-auxi.codaux.
        RETURN NO-APPLY.
    END.
  END.
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
ON LEFT-MOUSE-DBLCLICK OF x-auxiliar IN FRAME DIALOG-1 /* Auxiliar */
OR F8 OF x-auxiliar DO:

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


&Scoped-define SELF-NAME x-Clasificacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Clasificacion DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF x-Clasificacion IN FRAME DIALOG-1 /* Clasificacion */
OR "F8" OF x-Clasificacion
DO:
   DEFINE VAR RECID-STACK AS RECID NO-UNDO.
   RUN cbd/q-clfaux.w("01", OUTPUT RECID-stack).
   IF RECID-stack <> 0 THEN DO:
      FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack NO-LOCK  NO-ERROR.
      IF AVAIL cb-tabl THEN x-Clasificacion:SCREEN-VALUE = cb-tabl.codigo.
      ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-CodDiv DIALOG-1
ON LEFT-MOUSE-DBLCLICK OF X-CodDiv IN FRAME DIALOG-1 /* División */
OR F8 OF x-coddiv DO:
   {CBD/H-DIVI01.I NO SELF}
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

SESSION:DATE-FORMAT = 'dmy'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-Aux DIALOG-1 
PROCEDURE Cfg-Aux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pAuxiliar AS CHAR.
CASE cb-dmov.ClfAux:
    WHEN "@PV" THEN DO:
        FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND 
            gn-prov.CodPro = cb-dmov.CodAux NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN pAuxiliar = gn-prov.NomPro.
    END.
    WHEN "@CL" THEN DO:
        FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
            gn-clie.CodCli = cb-dmov.CodAux NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN pAuxiliar = gn-clie.nomcli.
    END.
    WHEN "@CT"  THEN DO:         
            IF LENGTH(cb-dmov.Codaux) <> INTEGER(ENTRY(NUM-ENTRIES(cb-niveles),cb-niveles)) THEN RETURN.
            pAuxiliar = CB-CTAS.NomCta.
    END.  
    OTHERWISE DO:
        FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
            cb-auxi.ClfAux = cb-dmov.ClfAux AND
            cb-auxi.CodAux = cb-dmov.CodAux
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN pAuxiliar = cb-auxi.NomAux.
    END.
END CASE.

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
  DISPLAY C-Moneda X-CodDiv cCodOpe C-Mes x-cta-ini x-cta-fin tg-ordcmp 
          T-resumen x-Clasificacion x-auxiliar TOGGLE-Sustento FILL-IN-Cco 
          RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RECT-6 C-Moneda X-CodDiv cCodOpe C-Mes x-cta-ini 
         x-cta-fin tg-ordcmp T-resumen x-Clasificacion x-auxiliar 
         TOGGLE-Sustento FILL-IN-Cco RADIO-SET-1 RB-NUMBER-COPIES B-impresoras 
         RB-BEGIN-PAGE RB-END-PAGE B-imprime btn-excel BUTTON-1 BUTTON-2 
         B-cancela 
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
    DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'mdy'.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "L I B R O   M A Y O R    G E N E R A L".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = pinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-expres.
    iCount = iCount + 2.

    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dia".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Comprobante".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Libro".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Div".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CC".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Clf. Aux.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Aux.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Doc.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Refer.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Detalle".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cargos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Abonos".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Final".
    iCount = iCount + 1.

    /*formato de columnas*/
    chWorkSheet:Columns("B"):NumberFormat = "dd/MM/yyyy".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "dd/mm/yyyy".
    chWorkSheet:Columns("J"):NumberFormat = "@".

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.

    FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
    VIEW FRAME F-Mensaje.  
    PAUSE 0.

    ASSIGN 
        t-debe   = 0
        t-haber  = 0.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = YES)
        BREAK BY (cb-ctas.Codcta):
/*         ON ERROR UNDO, LEAVE: */
        x-CodCta = cb-ctas.CodCta.
        ASSIGN t-debe   = 0
               t-haber  = 0
               a-debe   = 0
               a-haber  = 0
               x-saldoi = 0
               y-saldoi = 0
               t-saldoi = 0.

        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  <= c-mes
            AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
            AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
            AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
            AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
            AND cb-dmov.codcta  = x-CodCta
            AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
            AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
            BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
            IF X-INI = 0 THEN DO: 
                X-INI = 1.
                G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.                
                cColumn = STRING(iCount).
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = G-NOMCTA.
                iCount = iCount + 1. 
            END.
    
            IF FIRST-OF( cb-dmov.nromes ) THEN DO:
                x-nromes = cb-dmov.nromes.
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                 ASSIGN x-fchast = ""
                        x-codope = ""
                        x-fchDoc = ""
                        x-nroDoc = ""
                        x-fchVto = ""
                        x-nroref = ""
                        x-glodoc = "**** " + x-glodoc + " ****".
    
                IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN DO:                         
                    cColumn = STRING(iCount).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-Nromes.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nroast.
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-codope.
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchdoc.
                    cRange = "K" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nrodoc.
                    cRange = "L" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nroref.
                    cRange = "M" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-glodoc.
                    cRange = "P" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-saldoi.
                    iCount = iCount + 1.       
                END.
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       y-saldoi = x-saldoi .
            END.
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                       AND cb-cmov.periodo = cb-dmov.periodo 
                       AND cb-cmov.nromes  = cb-dmov.nromes
                       AND cb-cmov.codope  = cb-dmov.codope
                       AND cb-cmov.nroast  = cb-dmov.nroast
                       NO-LOCK NO-ERROR.
            
            IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast, '99/99/9999').
            ASSIGN
                x-nromes = cb-dmov.nromes
                x-glodoc = cb-dmov.glodoc
                x-NroAst = cb-dmov.NroAst
                x-CodOpe = cb-dmov.CodOpe
                x-codaux = cb-dmov.codaux
                x-NroDoc = cb-dmov.NroDoc
                x-NroRef = cb-dmov.NroRef
                x-div    = cb-dmov.coddiv
                x-cco    = cb-dmov.cco
                x-clfaux = cb-dmov.clfaux
                x-coddoc = cb-dmov.coddoc.
    
            IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
            IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                            AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                            AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        FIND b-cb-ctas WHERE b-cb-ctas.codcta = cb-dmov.codaux
                            AND b-cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-ctas THEN x-glodoc = b-cb-ctas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                            AND cb-auxi.codaux = cb-dmov.codaux
                            AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
    
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
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
                x-importe = ImpMn1 * -1.
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
    
            x-fchdoc = STRING(cb-dmov.fchdoc, '99/99/9999').  
            x-fchvto = STRING(cb-dmov.fchvto, '99/99/9999').
            /* Acumulando */
            DO i = 1 to 10:
                v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
                v-Haber[ i ] = v-Haber[ i ] + x-Haber.
            END.
            t-Debe  = t-Debe  + x-Debe.
            t-Haber = t-Haber + x-Haber.
            a-Debe  = a-Debe  + x-Debe.
            a-Haber = a-Haber + x-Haber.
    
            IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN DO:            
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Nromes.
                IF (x-fchast <> ?) THEN
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchast.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroast.
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codope.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = x-div.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = x-cco.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = x-clfaux.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codaux.
                IF x-fchdoc <> ? THEN DO:
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchdoc.
                END.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = x-coddoc.
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nrodoc.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroref.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                IF x-debe <> 0 THEN DO:
                    cRange = "N" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-debe.
                END.
                IF x-haber <> 0 THEN DO:
                    cRange = "O" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-haber.
                END.
                IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                    cRange = "P" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-importe.
                END.
                iCount = iCount + 1.                
            END.
            x-conreg = x-conreg + 1.
    
            IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0 THEN DO:
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                ASSIGN x-nromes = cb-dmov.nromes
                    x-Glodoc = " Total " + x-GloDoc
                    x-debe   = a-debe
                    x-haber  = a-haber
                    x-SaldoF = t-Debe - t-Haber
                    x-saldoi = x-saldof .
                   
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Nromes.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                IF y-saldoi <> 0 THEN DO:
                    cRange = "N" + cColumn.
                    chWorkSheet:Range(cRange):Value = y-saldoi.
                END.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldof.
                iCount = iCount + 1.              
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       x-conreg = 0.
            END.
        END.
        IF LAST-OF(cb-ctas.Codcta) THEN DO:
            IF X-INI > 0 THEN DO:
                ASSIGN 
                    x-Debe   = t-Debe
                    x-Haber  = t-Haber
                    x-SaldoF = x-Debe - x-Haber
                    x-nroast = x-codcta
                    x-fchast = ""
                    x-codope = ""
                    x-fchDoc = ""
                    x-nrodoc = "TOTAL"
                    x-nroref = cb-ctas.Codcta
                    x-GloDoc = "ACUMULADO DE " + x-mtmp .
                
                cColumn = STRING(iCount).
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroref.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Saldof.      
                iCount = iCount + 1.
            END.
            X-INI = 0.
        END.
    END.

    

    HIDE FRAME f-Mensaje.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'dmy'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 DIALOG-1 
PROCEDURE Excel-2 :
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
    DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.
    DEFINE VAR x-Meses AS CHAR INIT 'Apertura,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre,Cierre'.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'mdy'.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cuenta".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dia".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Comprobante".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Libro".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Div".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "CC".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Clf. Aux.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Aux.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nom. Aux.".

    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Doc.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Refer.".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Detalle".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cargos".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Abonos".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Final".
    iCount = iCount + 1.

    /*formato de columnas*/
    chWorkSheet:Columns("C"):NumberFormat = "dd/MM/yyyy".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("F"):NumberFormat = "@".
    chWorkSheet:Columns("G"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "@".
    chWorkSheet:Columns("K"):NumberFormat = "dd/mm/yyyy".
    chWorkSheet:Columns("L"):NumberFormat = "@".
    chWorkSheet:Columns("M"):NumberFormat = "@".

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.

    FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
    VIEW FRAME F-Mensaje.  
    PAUSE 0.

    ASSIGN 
        t-debe   = 0
        t-haber  = 0.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        /*AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = YES)*/
        AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = NO)
        BREAK BY (cb-ctas.Codcta):
        x-CodCta = cb-ctas.CodCta.
        ASSIGN t-debe   = 0
               t-haber  = 0
               a-debe   = 0
               a-haber  = 0
               x-saldoi = 0
               y-saldoi = 0
               t-saldoi = 0.

        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  <= c-mes
            AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
            AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
            AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
            AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
            AND cb-dmov.codcta  = x-CodCta
            AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
            AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
            BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
            IF X-INI = 0 THEN DO: 
                X-INI = 1.
                G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.                
            END.
            IF FIRST-OF( cb-dmov.nromes ) THEN DO:
                x-nromes = cb-dmov.nromes.
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                 ASSIGN x-fchast = ""
                        x-codope = ""
                        x-fchDoc = ""
                        x-nroDoc = ""
                        x-fchVto = ""
                        x-nroref = ""
                        x-glodoc = "**** " + x-glodoc + " ****".
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       y-saldoi = x-saldoi .
            END.
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                       AND cb-cmov.periodo = cb-dmov.periodo 
                       AND cb-cmov.nromes  = cb-dmov.nromes
                       AND cb-cmov.codope  = cb-dmov.codope
                       AND cb-cmov.nroast  = cb-dmov.nroast
                       NO-LOCK NO-ERROR.
            
            IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast, '99/99/9999').
            ASSIGN
                x-nromes = cb-dmov.nromes
                x-glodoc = cb-dmov.glodoc
                x-NroAst = cb-dmov.NroAst
                x-CodOpe = cb-dmov.CodOpe
                x-codaux = cb-dmov.codaux
                x-NroDoc = cb-dmov.NroDoc
                x-NroRef = cb-dmov.NroRef
                x-div    = cb-dmov.coddiv
                x-cco    = cb-dmov.cco
                x-clfaux = cb-dmov.clfaux
                x-coddoc = cb-dmov.coddoc.
    
            IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
            IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                            AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                            AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        FIND b-cb-ctas WHERE b-cb-ctas.codcta = cb-dmov.codaux
                            AND b-cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-ctas THEN x-glodoc = b-cb-ctas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                            AND cb-auxi.codaux = cb-dmov.codaux
                            AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
    
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
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
                x-importe = ImpMn1 * -1.
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
    
            x-fchdoc = STRING(cb-dmov.fchdoc, '99/99/9999').  
            x-fchvto = STRING(cb-dmov.fchvto, '99/99/9999').
            /* Acumulando */
            DO i = 1 to 10:
                v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
                v-Haber[ i ] = v-Haber[ i ] + x-Haber.
            END.
            t-Debe  = t-Debe  + x-Debe.
            t-Haber = t-Haber + x-Haber.
            a-Debe  = a-Debe  + x-Debe.
            a-Haber = a-Haber + x-Haber.
    
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = G-NOMCTA.
            cColumn = STRING(iCount).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = ENTRY (x-Nromes + 1, x-Meses).
            IF (x-fchast <> ?) THEN
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = x-fchast.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nroast.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = x-codope.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = x-div.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = x-cco.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = x-clfaux.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = x-codaux.
            RUN Cfg-Aux (OUTPUT x-nomaux).
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nomaux.
            IF x-fchdoc <> ? THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = x-fchdoc.
            END.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = x-coddoc.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nrodoc.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nroref.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = x-glodoc.
            IF x-debe <> 0 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
            END.
            IF x-haber <> 0 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
            END.
            IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Value = x-importe.
            END.
            iCount = iCount + 1.                
            x-conreg = x-conreg + 1.
    
            IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0 THEN DO:
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                ASSIGN x-nromes = cb-dmov.nromes
                    x-Glodoc = " Total " + x-GloDoc
                    x-debe   = a-debe
                    x-haber  = a-haber
                    x-SaldoF = t-Debe - t-Haber
                    x-saldoi = x-saldof .
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       x-conreg = 0.
            END.
        END.
        IF LAST-OF(cb-ctas.Codcta) THEN DO:
            IF X-INI > 0 THEN DO:
                ASSIGN 
                    x-Debe   = t-Debe
                    x-Haber  = t-Haber
                    x-SaldoF = x-Debe - x-Haber
                    x-nroast = x-codcta
                    x-fchast = ""
                    x-codope = ""
                    x-fchDoc = ""
                    x-nrodoc = "TOTAL"
                    x-nroref = cb-ctas.Codcta
                    x-GloDoc = "ACUMULADO DE " + x-mtmp .
                
            END.
            X-INI = 0.
        END.
    END.

    

    HIDE FRAME f-Mensaje.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'dmy'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelT DIALOG-1 
PROCEDURE ExcelT :
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
    DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'mdy'.
    
    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "L I B R O   M A Y O R    G E N E R A L".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = pinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-expres.
    iCount = iCount + 2.

    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Dia".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Comprobante".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Libro".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Div".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CC".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Clf. Aux.".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Aux.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Doc.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Doc.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nro. Doc.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nº Ord.Compra".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Detalle".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cargos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Abonos".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe S/.".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Saldo Final".
    iCount = iCount + 1.

    /*formato de columnas*/
    chWorkSheet:Columns("B"):NumberFormat = "dd/MM/yyyy".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "dd/MM/yyyy".
    chWorkSheet:Columns("J"):NumberFormat = "@".
    chWorkSheet:Columns("L"):NumberFormat = "@".

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.

    FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
    VIEW FRAME F-Mensaje.  
    PAUSE 0.

    ASSIGN 
        t-debe   = 0
        t-haber  = 0.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = YES)
        BREAK BY (cb-ctas.Codcta):
/*         ON ERROR UNDO, LEAVE: */
        x-CodCta = cb-ctas.CodCta.
        ASSIGN t-debe   = 0
               t-haber  = 0
               a-debe   = 0
               a-haber  = 0
               x-saldoi = 0
               y-saldoi = 0
               t-saldoi = 0.

        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  <= c-mes
            AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
            AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
            AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
            AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
            AND cb-dmov.codcta  = x-CodCta
            AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
            AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
            BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
            IF X-INI = 0 THEN DO: 
                X-INI = 1.
                G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.                
                cColumn = STRING(iCount).
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = G-NOMCTA.
                iCount = iCount + 1. 
            END.
    
            IF FIRST-OF( cb-dmov.nromes ) THEN DO:
                x-nromes = cb-dmov.nromes.
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                 ASSIGN x-fchast = ""
                        x-codope = ""
                        x-fchDoc = ""
                        x-nroDoc = ""
                        x-fchVto = ""
                        x-nroref = ""
                        x-glodoc = "**** " + x-glodoc + " ****".
    
                IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN DO:                         
                    cColumn = STRING(iCount).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-Nromes.
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nroast.
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-codope.
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchdoc.
                    cRange = "K" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-nrodoc.
                    cRange = "L" + cColumn.
                    chWorkSheet:Range(cRange):Value = ''.
                    cRange = "M" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-glodoc.
                    cRange = "P" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-saldoi.
                    iCount = iCount + 1.       
                END.
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       y-saldoi = x-saldoi .
            END.
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                       AND cb-cmov.periodo = cb-dmov.periodo 
                       AND cb-cmov.nromes  = cb-dmov.nromes
                       AND cb-cmov.codope  = cb-dmov.codope
                       AND cb-cmov.nroast  = cb-dmov.nroast
                       NO-LOCK NO-ERROR.
            
            IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast, '99/99/9999').
            ASSIGN
                x-nromes = cb-dmov.nromes
                x-glodoc = cb-dmov.glodoc
                x-NroAst = cb-dmov.NroAst
                x-CodOpe = cb-dmov.CodOpe
                x-codaux = cb-dmov.codaux
                x-NroDoc = cb-dmov.NroDoc
                x-NroRef = cb-dmov.NroRef
                x-div    = cb-dmov.coddiv
                x-cco    = cb-dmov.cco
                x-clfaux = cb-dmov.clfaux
                x-coddoc = cb-dmov.coddoc.
    
            IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
            IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                            AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                            AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        FIND b-cb-ctas WHERE b-cb-ctas.codcta = cb-dmov.codaux
                            AND b-cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-ctas THEN x-glodoc = b-cb-ctas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                            AND cb-auxi.codaux = cb-dmov.codaux
                            AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
    
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
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
                x-importe = ImpMn1 * -1.
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
    
            x-fchdoc = STRING(cb-dmov.fchdoc, '99/99/9999').  
            x-fchvto = STRING(cb-dmov.fchvto, '99/99/9999').
            /* Acumulando */
            DO i = 1 to 10:
                v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
                v-Haber[ i ] = v-Haber[ i ] + x-Haber.
            END.
            t-Debe  = t-Debe  + x-Debe.
            t-Haber = t-Haber + x-Haber.
            a-Debe  = a-Debe  + x-Debe.
            a-Haber = a-Haber + x-Haber.
    
            IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN DO:            
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Nromes.
                IF (x-fchast <> ?) THEN
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchast.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroast.
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codope.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = x-div.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = x-cco.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = x-clfaux.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = x-codaux.
                IF x-fchdoc <> ? THEN DO:
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-fchdoc.
                END.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = x-coddoc.
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nrodoc.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.OrdCmp.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                IF x-debe <> 0 THEN DO:
                    cRange = "N" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-debe.
                END.
                IF x-haber <> 0 THEN DO:
                    cRange = "O" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-haber.
                END.
                IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                    cRange = "P" + cColumn.
                    chWorkSheet:Range(cRange):Value = x-importe.
                END.
                iCount = iCount + 1.                
            END.
            x-conreg = x-conreg + 1.
    
            IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0 THEN DO:
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                ASSIGN x-nromes = cb-dmov.nromes
                    x-Glodoc = " Total " + x-GloDoc
                    x-debe   = a-debe
                    x-haber  = a-haber
                    x-SaldoF = t-Debe - t-Haber
                    x-saldoi = x-saldof .
                   
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Nromes.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                IF y-saldoi <> 0 THEN DO:
                    cRange = "N" + cColumn.
                    chWorkSheet:Range(cRange):Value = y-saldoi.
                END.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-saldof.
                iCount = iCount + 1.              
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       x-conreg = 0.
            END.
        END.
        IF LAST-OF(cb-ctas.Codcta) THEN DO:
            IF X-INI > 0 THEN DO:
                ASSIGN 
                    x-Debe   = t-Debe
                    x-Haber  = t-Haber
                    x-SaldoF = x-Debe - x-Haber
                    x-nroast = x-codcta
                    x-fchast = ""
                    x-codope = ""
                    x-fchDoc = ""
                    x-nrodoc = "TOTAL"
                    x-nroref = cb-ctas.Codcta
                    x-GloDoc = "ACUMULADO DE " + x-mtmp .
                
                cColumn = STRING(iCount).
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-nroref.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Value = x-Saldof.      
                iCount = iCount + 1.
            END.
            X-INI = 0.
        END.
    END.

    

    HIDE FRAME f-Mensaje.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    /* FORMATO DE FECHA */
    SESSION:DATE-FORMAT = 'dmy'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Detalle DIALOG-1 
PROCEDURE Imp-Detalle :
DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.

ASSIGN t-debe   = 0
       t-haber  = 0
       a-debe   = 0
       a-haber  = 0
       x-saldoi = 0
       y-saldoi = 0
       t-saldoi = 0.
       

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
    AND cb-dmov.periodo = s-periodo 
    AND cb-dmov.nromes  <= c-mes
    AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
    AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
    AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
    AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
    AND cb-dmov.codcta  = x-CodCta
    AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
    AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
    BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
    IF X-INI = 0 THEN DO: 
       X-INI = 1.
       G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
       {&NEW-PAGE}.
       DISPLAY STREAM report WITH FRAME f-cab.
       PUT STREAM report CONTROL P-dobleon.
       PUT STREAM report G-NOMCTA.
       PUT STREAM report CONTROL P-dobleoff.  
       DOWN STREAM report WITH FRAME f-cab.
    END.
    IF FIRST-OF( cb-dmov.nromes )
    THEN DO:
        x-nromes = cb-dmov.nromes.
        RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
         ASSIGN x-fchast = ""
                x-codope = ""
                x-fchDoc = ""
                x-nroDoc = ""
                x-fchVto = ""
                x-nroref = ""
                x-glodoc = "**** " + x-glodoc + " ****".

        IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN 
        DO:

        {&NEW-PAGE}.
        DISPLAY STREAM report x-Nromes
                              x-fchast
                              x-nroast
                              x-codope              
                              x-fchdoc
                              x-nrodoc
                              x-nroref
                              x-glodoc 
                              x-saldoi when x-saldoi <> 0 @ x-debe
              WITH FRAME f-cab.
              
        DOWN STREAM report WITH FRAME F-cab.

        END.

        ASSIGN a-debe   = 0
               a-haber  = 0
               y-saldoi = x-saldoi .

    END.
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
     ASSIGN x-nromes = cb-dmov.nromes
            x-glodoc = cb-dmov.glodoc
            x-NroAst = cb-dmov.NroAst
            x-CodOpe = cb-dmov.CodOpe
            x-codaux = cb-dmov.codaux
            x-NroDoc = cb-dmov.NroDoc
            x-NroRef = cb-dmov.NroRef
            x-div    = cb-dmov.coddiv
            x-cco    = cb-dmov.cco
            x-clfaux = cb-dmov.clfaux
            x-coddoc = cb-dmov.coddoc.
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

    IF NOT tpomov 
    THEN DO:
        x-importe = ImpMn1.
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
        x-importe = ImpMn1 * -1.
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
        x-fchdoc = STRING(cb-dmov.fchdoc).  
        x-fchvto = STRING(cb-dmov.fchvto).
        /* Acumulando */
        DO i = 1 to 10:
            v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
            v-Haber[ i ] = v-Haber[ i ] + x-Haber.
        END.
        t-Debe  = t-Debe  + x-Debe.
        t-Haber = t-Haber + x-Haber.
        a-Debe  = a-Debe  + x-Debe.
        a-Haber = a-Haber + x-Haber.
        IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN 
        DO:
        {&NEW-PAGE}.
        DISPLAY STREAM report x-nromes
                              x-fchast WHEN (x-fchast <> ?)
                              x-nroast
                              x-codope
                              x-div
                              x-cco
                              x-clfaux
                              x-codaux              
                              x-fchdoc WHEN (x-fchdoc <> ?)
                              x-coddoc
                              x-nrodoc
/*MLR* *07/Mar/2008* ***
                              x-fchvto WHEN (x-fchvto <> ?)
* ***/
                              x-nroref
                              x-glodoc 
                              x-debe   WHEN (x-debe  <> 0)
                              x-haber  WHEN (x-haber <> 0)
                              x-importe WHEN (x-importe <> 0 AND x-codmon = 2)
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.
        END.
        x-conreg = x-conreg + 1.
  
    
    IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0
    THEN DO:
        RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
        ASSIGN x-nromes = cb-dmov.nromes
               x-Glodoc = " Total " + x-GloDoc
               x-debe   = a-debe
               x-haber  = a-haber
               x-SaldoF = t-Debe - t-Haber
               x-saldoi = x-saldof .
        {&NEW-PAGE}.
        UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                                x-debe
                                x-haber
                                x-SaldoF
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.         

        DISPLAY STREAM report x-nromes
                              x-Glodoc
                              y-saldoi when y-saldoi <> 0 @ x-debe 
                              x-debe
                              x-haber
                              x-SaldoF
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.         
        UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                                x-debe
                                x-haber
                                x-SaldoF
              WITH FRAME f-cab.
        DOWN STREAM report WITH FRAME F-cab.         

        ASSIGN a-debe   = 0
               a-haber  = 0
               x-conreg = 0.
    END.
END.

IF X-INI > 0 THEN DO:
   ASSIGN x-Debe   = t-Debe
          x-Haber  = t-Haber
          x-SaldoF = x-Debe - x-Haber
          x-nroast = x-codcta
          x-fchast = ""
          x-codope = ""
          x-fchDoc = ""
/*MLR* *07/Mar/2008* ***
          x-nroDoc = ""
          x-fchVto = "TOTAL"
* ***/
          x-nrodoc = "TOTAL"
          x-nroref = x-CodCta
          x-GloDoc = "ACUMULADO DE " + x-mtmp .
   {&NEW-PAGE}.
   UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                           x-debe
                           x-haber
                           x-Saldof  WITH FRAME f-cab.
   DOWN STREAM report WITH FRAME f-cab.
   DISPLAY STREAM report  /* x-fchvto *MLR* *07/Mar/2008* ***/
                           x-nroRef
                           x-GloDoc
                           x-debe
                           x-haber
                           x-Saldof WITH FRAME f-cab.
   DOWN STREAM report WITH FRAME f-cab.
   {&NEW-PAGE}.
   UNDERLINE STREAM report /* x-fchvto *MLR* *07/Mar/2008* ***/
                           x-nroref
                           x-glodoc
/*MLR* *07/Mar/2008* ***
                           x-saldoi
* ***/
                           x-debe   
                           x-haber 
                           x-Saldof WITH FRAME f-cab.
   DOWN STREAM report WITH FRAME F-cab.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Detalle2 DIALOG-1 
PROCEDURE Imp-Detalle2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.

ASSIGN t-debe   = 0
       t-haber  = 0
       a-debe   = 0
       a-haber  = 0
       x-saldoi = 0
       y-saldoi = 0
       t-saldoi = 0.
       

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
    AND cb-dmov.periodo = s-periodo 
    AND cb-dmov.nromes  <= c-mes
    AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
    AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
    AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
    AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
    AND cb-dmov.codcta  = x-CodCta
    AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
    AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
    BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
    IF X-INI = 0 THEN DO: 
       X-INI = 1.
       G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
       {&NEW-PAGE}.
       DISPLAY STREAM report WITH FRAME f-cab2.
       PUT STREAM report CONTROL P-dobleon.
       PUT STREAM report G-NOMCTA.
       PUT STREAM report CONTROL P-dobleoff.  
       DOWN STREAM report WITH FRAME f-cab2.
    END.
    IF FIRST-OF( cb-dmov.nromes )
    THEN DO:
        x-nromes = cb-dmov.nromes.
        RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
         ASSIGN x-fchast = ""
                x-codope = ""
                x-fchDoc = ""
                x-nroDoc = ""
                x-fchVto = ""
                x-nroref = ""
                x-glodoc = "**** " + x-glodoc + " ****".

        IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN 
        DO:

        {&NEW-PAGE}.
        DISPLAY STREAM report x-Nromes
                              x-fchast
                              x-nroast
                              x-codope              
                              x-fchdoc
                              x-nrodoc
                              ''
                              x-glodoc 
                              x-saldoi when x-saldoi <> 0 @ x-debe
              WITH FRAME f-cab2.
              
        DOWN STREAM report WITH FRAME f-cab2.

        END.

        ASSIGN a-debe   = 0
               a-haber  = 0
               y-saldoi = x-saldoi .

    END.
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
     ASSIGN x-nromes = cb-dmov.nromes
            x-glodoc = cb-dmov.glodoc
            x-NroAst = cb-dmov.NroAst
            x-CodOpe = cb-dmov.CodOpe
            x-codaux = cb-dmov.codaux
            x-NroDoc = cb-dmov.NroDoc
            x-NroRef = cb-dmov.NroRef
            x-div    = cb-dmov.coddiv
            x-cco    = cb-dmov.cco
            x-clfaux = cb-dmov.clfaux
            x-coddoc = cb-dmov.coddoc.
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
 
    IF NOT tpomov 
    THEN DO:
        x-importe = ImpMn1.
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
        x-importe = ImpMn1 * -1.
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
        x-fchdoc = STRING(cb-dmov.fchdoc).  
        x-fchvto = STRING(cb-dmov.fchvto).
        /* Acumulando */
        DO i = 1 to 10:
            v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
            v-Haber[ i ] = v-Haber[ i ] + x-Haber.
        END.
        t-Debe  = t-Debe  + x-Debe.
        t-Haber = t-Haber + x-Haber.
        a-Debe  = a-Debe  + x-Debe.
        a-Haber = a-Haber + x-Haber.
        IF NOT (T-RESUMEN AND CB-DMOV.NROMES = 0) THEN 
        DO:
        {&NEW-PAGE}.
        DISPLAY STREAM report x-nromes
                              x-fchast WHEN (x-fchast <> ?)
                              x-nroast
                              x-codope
                              x-div
                              x-cco
                              x-clfaux
                              x-codaux              
                              x-fchdoc WHEN (x-fchdoc <> ?)
                              x-coddoc
                              x-nrodoc
                              cb-dmov.OrdCmp
                              x-glodoc 
                              x-debe   WHEN (x-debe  <> 0)
                              x-haber  WHEN (x-haber <> 0)
                              x-importe WHEN (x-importe <> 0 AND x-codmon = 2)
              WITH FRAME f-cab2.
        DOWN STREAM report WITH FRAME f-cab2.
        END.
        x-conreg = x-conreg + 1.
  
    
    IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0
    THEN DO:
        RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
        ASSIGN x-nromes = cb-dmov.nromes
               x-Glodoc = " Total " + x-GloDoc
               x-debe   = a-debe
               x-haber  = a-haber
               x-SaldoF = t-Debe - t-Haber
               x-saldoi = x-saldof .
        {&NEW-PAGE}.
        UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                                x-debe
                                x-haber
                                x-SaldoF
              WITH FRAME f-cab2.
        DOWN STREAM report WITH FRAME f-cab2.         

        DISPLAY STREAM report x-nromes
                              x-Glodoc
                              y-saldoi when y-saldoi <> 0 @ x-debe 
                              x-debe
                              x-haber
                              x-SaldoF
              WITH FRAME f-cab2.
        DOWN STREAM report WITH FRAME f-cab2.         
        UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                                x-debe
                                x-haber
                                x-SaldoF
              WITH FRAME f-cab2.
        DOWN STREAM report WITH FRAME f-cab2.         

        ASSIGN a-debe   = 0
               a-haber  = 0
               x-conreg = 0.
    END.
END.

IF X-INI > 0 THEN DO:
   ASSIGN x-Debe   = t-Debe
          x-Haber  = t-Haber
          x-SaldoF = x-Debe - x-Haber
          x-nroast = x-codcta
          x-fchast = ""
          x-codope = ""
          x-fchDoc = ""
/*MLR* *07/Mar/2008* ***
          x-nroDoc = ""
          x-fchVto = "TOTAL"
* ***/
          x-nrodoc = "TOTAL"
          x-nroref = x-codcta
          x-GloDoc = "ACUMULADO DE " + x-mtmp .
   {&NEW-PAGE}.
   UNDERLINE STREAM report /* x-saldoi *MLR* *07/Mar/2008* ***/
                           x-debe
                           x-haber
                           x-Saldof  WITH FRAME f-cab2.
   DOWN STREAM report WITH FRAME f-cab2.
   DISPLAY STREAM report  /* x-fchvto *MLR* *07/Mar/2008* ***/
                           x-nroref @ cb-dmov.OrdCmp
                           x-GloDoc
                           x-debe
                           x-haber
                           x-Saldof WITH FRAME f-cab2.
   DOWN STREAM report WITH FRAME f-cab2.
   {&NEW-PAGE}.
   UNDERLINE STREAM report /* x-fchvto *MLR* *07/Mar/2008* ***/
                           x-nroref
                           x-glodoc
/*MLR* *07/Mar/2008* ***
                           x-saldoi
* ***/
                           x-debe   
                           x-haber 
                           x-Saldof WITH FRAME f-cab2.
   DOWN STREAM report WITH FRAME f-cab2.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
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

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = YES)
        BY Cb-ctas.codcta:
        x-CodCta = cb-ctas.CodCta.
        IF NOT tg-ordcmp THEN RUN Imp-Detalle.
        ELSE RUN Imp-Detalle2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto-Plano DIALOG-1 
PROCEDURE Texto-Plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR X-INI AS INTEGER INIT 0  NO-UNDO.
    DEFINE VAR x-Meses AS CHAR INIT 'Apertura,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre,Cierre'.
    DEFINE VAR x-Archivo AS CHAR NO-UNDO.
    DEFINE VAR x-Texto AS CHAR NO-UNDO.
    DEFINE VAR rpta AS LOG NO-UNDO.

    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS "Texto" "*.txt"
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        TITLE "Archivo de salida"
        UPDATE rpta.
    IF rpta = NO THEN RETURN.

    /* Encabezado */

    DEF VAR con-ctas AS INTEGER.
    DEF VAR xi AS INTEGER INIT 0.
    DEF VAR No-tiene-mov AS LOGICAL.

    FRAME F-Mensaje:TITLE =  FRAME DIALOG-1:TITLE.
    VIEW FRAME F-Mensaje.
    PAUSE 0.

    ASSIGN 
        t-debe   = 0
        t-haber  = 0.

    OUTPUT STREAM REPORT TO VALUE(x-Archivo).
    PUT STREAM REPORT UNFORMATTED ~
        "Cuenta|Mes|Dia|Comprobante|Libro|Div|CC|Clf. Aux.|Cod. Aux.|Nom. Aux.|Fecha Doc|~
        Cod. Doc.|Nro. Doc.|Nro. Refer.|Detalle|Cargos|Abonos|Importe S/.|Saldo Final"
        SKIP.

    FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia
        AND cb-ctas.codcta >= x-cta-ini
        AND cb-ctas.codcta <= x-cta-fin
        AND cb-ctas.CodCta <> ""
        AND LENGTH( cb-ctas.CodCta ) = Max-Digitos
        AND (TOGGLE-Sustento = NO OR Cb-Ctas.Sustento = YES)
        BREAK BY (cb-ctas.Codcta):
        x-CodCta = cb-ctas.CodCta.
        ASSIGN t-debe   = 0
               t-haber  = 0
               a-debe   = 0
               a-haber  = 0
               x-saldoi = 0
               y-saldoi = 0
               t-saldoi = 0.

        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
            AND cb-dmov.periodo = s-periodo 
            AND cb-dmov.nromes  <= c-mes
            AND (cCodOpe = '' OR cb-dmov.codope = cCodOpe)
            AND (x-CodDiv = '' OR cb-dmov.coddiv = x-coddiv)
            AND (x-Clasificacion = '' OR cb-dmov.clfaux = x-Clasificacion)
            AND (cb-dmov.codaux begins x-auxiliar or cb-dmov.cco begins x-auxiliar)
            AND cb-dmov.codcta  = x-CodCta
            AND (TOGGLE-Sustento = NO OR cb-dmov.LOG_01 = NO)
            AND (FILL-IN-Cco = '' OR cb-dmov.cco = FILL-IN-Cco)
            BREAK BY cb-dmov.nromes BY cb-dmov.CodOpe BY cb-dmov.NroAst:
    
            IF X-INI = 0 THEN DO: 
                X-INI = 1.
                G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.                
            END.
            IF FIRST-OF( cb-dmov.nromes ) THEN DO:
                x-nromes = cb-dmov.nromes.
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                 ASSIGN x-fchast = ""
                        x-codope = ""
                        x-fchDoc = ""
                        x-nroDoc = ""
                        x-fchVto = ""
                        x-nroref = ""
                        x-glodoc = "**** " + x-glodoc + " ****".
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       y-saldoi = x-saldoi .
            END.
            /* Buscando la cabecera correspondiente */
            x-fchast = ?.
            FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                       AND cb-cmov.periodo = cb-dmov.periodo 
                       AND cb-cmov.nromes  = cb-dmov.nromes
                       AND cb-cmov.codope  = cb-dmov.codope
                       AND cb-cmov.nroast  = cb-dmov.nroast
                       NO-LOCK NO-ERROR.
            
            IF AVAILABLE cb-cmov THEN x-fchast = STRING(cb-cmov.fchast, '99/99/9999').
            ASSIGN
                x-nromes = cb-dmov.nromes
                x-glodoc = cb-dmov.glodoc
                x-NroAst = cb-dmov.NroAst
                x-CodOpe = cb-dmov.CodOpe
                x-codaux = cb-dmov.codaux
                x-NroDoc = cb-dmov.NroDoc
                x-NroRef = cb-dmov.NroRef
                x-div    = cb-dmov.coddiv
                x-cco    = cb-dmov.cco
                x-clfaux = cb-dmov.clfaux
                x-coddoc = cb-dmov.coddoc.
    
            IF x-glodoc = "" THEN IF AVAILABLE cb-cmov THEN x-glodoc = cb-cmov.notast.
            IF  x-glodoc = "" THEN DO:
                CASE cb-dmov.clfaux:
                    WHEN "@CL" THEN DO:
                        FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                            AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR. 
                        IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                    END.
                    WHEN "@PV" THEN DO:
                        FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                            AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                        IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
                    END.
                    WHEN "@CT" THEN DO:
                        FIND b-cb-ctas WHERE b-cb-ctas.codcta = cb-dmov.codaux
                            AND b-cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-ctas THEN x-glodoc = b-cb-ctas.nomcta.
                    END.
                    OTHERWISE DO:
                        FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                            AND cb-auxi.codaux = cb-dmov.codaux
                            AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-auxi THEN x-glodoc = cb-auxi.nomaux.
                    END.
                END CASE.
            END.
    
            IF NOT tpomov THEN DO:
                x-importe = ImpMn1.
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
                x-importe = ImpMn1 * -1.
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
    
            x-fchdoc = STRING(cb-dmov.fchdoc, '99/99/9999').  
            x-fchvto = STRING(cb-dmov.fchvto, '99/99/9999').
            /* Acumulando */
            DO i = 1 to 10:
                v-Debe[ i ]  = v-Debe[ i ] + x-Debe.
                v-Haber[ i ] = v-Haber[ i ] + x-Haber.
            END.
            t-Debe  = t-Debe  + x-Debe.
            t-Haber = t-Haber + x-Haber.
            a-Debe  = a-Debe  + x-Debe.
            a-Haber = a-Haber + x-Haber.
    
            RUN Cfg-Aux (OUTPUT x-Texto).
            RUN lib/limpiar-texto (x-Texto, "", OUTPUT x-NomAux).
            x-Texto = x-GloDoc.
            RUN lib/limpiar-texto (x-Texto, "", OUTPUT x-GloDoc).

            PUT STREAM REPORT UNFORMATTED
                G-NOMCTA '|'
                ENTRY (x-Nromes + 1, x-Meses) '|'
                x-fchast '|'
                x-nroast '|'
                x-codope '|'
                x-div '|'
                x-cco '|'
                x-clfaux '|'
                x-codaux '|'
                x-nomaux '|'
                x-fchdoc '|'
                x-coddoc '|'
                x-nrodoc '|'
                x-nroref '|'
                x-glodoc '|'
                x-debe '|'
                x-haber '|'.
            IF x-importe <> 0 AND x-codmon = 2 THEN DO:
                PUT STREAM REPORT UNFORMATTED x-importe SKIP.
            END.
            ELSE PUT STREAM REPORT UNFORMATTED '' SKIP. 
            x-conreg = x-conreg + 1.
    
            IF LAST-OF( cb-dmov.nromes ) AND x-conreg > 0 THEN DO:
                RUN bin/_mes.p ( INPUT cb-dmov.nromes , 1,  OUTPUT x-GloDoc ).
                ASSIGN x-nromes = cb-dmov.nromes
                    x-Glodoc = " Total " + x-GloDoc
                    x-debe   = a-debe
                    x-haber  = a-haber
                    x-SaldoF = t-Debe - t-Haber
                    x-saldoi = x-saldof .
                ASSIGN a-debe   = 0
                       a-haber  = 0
                       x-conreg = 0.
            END.
        END.
        IF LAST-OF(cb-ctas.Codcta) THEN DO:
            IF X-INI > 0 THEN DO:
                ASSIGN 
                    x-Debe   = t-Debe
                    x-Haber  = t-Haber
                    x-SaldoF = x-Debe - x-Haber
                    x-nroast = x-codcta
                    x-fchast = ""
                    x-codope = ""
                    x-fchDoc = ""
                    x-nrodoc = "TOTAL"
                    x-nroref = cb-ctas.Codcta
                    x-GloDoc = "ACUMULADO DE " + x-mtmp .
            END.
            X-INI = 0.
        END.
    END.
    OUTPUT STREAM REPORT CLOSE.
    HIDE FRAME f-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

