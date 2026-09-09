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
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchdoc   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-fchvto   AS CHARACTER FORMAT "X(5)" NO-UNDO.
DEFINE VARIABLE x-clfaux   LIKE cb-dmov.clfaux NO-UNDO.
DEFINE VARIABLE x-codaux   LIKE cb-dmov.codaux NO-UNDO.
DEFINE VARIABLE x-nroast   LIKE cb-dmov.nroast NO-UNDO.
DEFINE VARIABLE x-codope   LIKE cb-dmov.codope NO-UNDO.
DEFINE VARIABLE x-coddoc   LIKE cb-dmov.coddoc NO-UNDO.
DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO.
DEFINE VARIABLE x-CodCta   LIKE cb-dmov.CodCta NO-UNDO.

DEFINE VARIABLE x-Cco      LIKE cb-dmov.Cco    NO-UNDO.

DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.
DEFINE VARIABLE x-saldof   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-deudor   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "S a l d o!Deudor    " NO-UNDO.
DEFINE VARIABLE x-acreedor AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "A c t u a l    !Acreedor   " NO-UNDO.


DEFINE VARIABLE x-debes     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-habers    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 

DEFINE VARIABLE x-debed     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-haberd    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 


DEFINE VARIABLE c-debe     AS DECIMAL NO-UNDO.
DEFINE VARIABLE c-haber    AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-debe     AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-haber    AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-saldoi   AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-saldof   AS DECIMAL NO-UNDO.
DEFINE VARIABLE t-debes    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" NO-UNDO.
DEFINE VARIABLE t-debed    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" NO-UNDO.

DEFINE VARIABLE x-conreg   AS INTEGER NO-UNDO.

DEFINE VARIABLE v-Saldoi   AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-Debe     AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-Haber    AS DECIMAL   EXTENT 10 NO-UNDO.
DEFINE VARIABLE v-CodCta   AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE x-fec      AS DATE.

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




def var x-codmon as integer init 1.
def var x-clfaux-1 as char.
def var x-clfaux-2 as char.

DEF VAR G-NOMCTA AS CHAR FORMAT "X(60)".
DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
DEFINE FRAME F-AUXILIAR
     X-MENSAJE
WITH TITLE "Espere un momento por favor" VIEW-AS DIALOG-BOX CENTERED
          NO-LABELS.

DEFINE VARIABLE x-saldosi   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldodi   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldosf   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-saldodf   AS DECIMAL FORMAT "ZZ,ZZZ,ZZ9.99-".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-5 RECT-4 RADIO-SET-1 B-imprime ~
C-Moneda B-impresoras B-cancela y-CodDiv x-cta F-Fecha RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 C-Moneda C-Mes y-CodDiv ~
y-codope x-cta F-Fecha RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-Moneda AS CHARACTER FORMAT "X(256)":U INITIAL "Soles" 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Soles","Dólares" 
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
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

DEFINE VARIABLE x-cta AS CHARACTER FORMAT "X(20)":U INITIAL "101101,101102" 
     LABEL "Cuenta Caja" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE y-CodDiv AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(10)":U INITIAL "003,004" 
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
     SIZE 10.72 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 63.72 BY 4.54.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 63.72 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 63.72 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     RADIO-SET-1 AT ROW 6.69 COL 2 NO-LABEL
     B-imprime AT ROW 10.58 COL 10.14
     C-Moneda AT ROW 1.31 COL 9.29 COLON-ALIGNED
     C-Mes AT ROW 2.31 COL 9.14 COLON-ALIGNED
     B-impresoras AT ROW 7.65 COL 12.43
     b-archivo AT ROW 8.65 COL 12.43
     RB-OUTPUT-FILE AT ROW 8.92 COL 16.43 COLON-ALIGNED NO-LABEL
     B-cancela AT ROW 10.58 COL 40.14
     y-CodDiv AT ROW 1.31 COL 41 COLON-ALIGNED
     y-codope AT ROW 2.12 COL 41 COLON-ALIGNED
     x-cta AT ROW 2.88 COL 41 COLON-ALIGNED
     F-Fecha AT ROW 3.62 COL 41 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 6.73 COL 56.43 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 7.73 COL 56.43 COLON-ALIGNED
     RB-END-PAGE AT ROW 8.73 COL 56.43 COLON-ALIGNED
     RECT-6 AT ROW 10.12 COL 1
     RECT-5 AT ROW 6.19 COL 1
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 63.72 BY .62 AT ROW 5.58 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-4 AT ROW 1 COL 1
     SPACE(0.00) SKIP(6.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Libro Mayor General".


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

/* SETTINGS FOR COMBO-BOX C-Mes IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN 
       C-Mes:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME DIALOG-1           = TRUE.

ASSIGN 
       y-CodDiv:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN y-codope IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Libro Mayor General */
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
        ASSIGN x-cta
               f-fecha
               c-mes
               y-CodOpe
               y-coddiv.
               
        IF f-fecha = ? 
        THEN DO:
            BELL.
            MESSAGE "Fecha Incorrecta, Verifique Por favor" 
                     VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO f-fecha.
            RETURN NO-APPLY.
        END.
        x-fec = f-Fecha.
        
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
    /*P-Ancho  = FRAME f-cab:WIDTH.*/
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


&Scoped-define SELF-NAME x-cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cta DIALOG-1
ON F8 OF x-cta IN FRAME DIALOG-1 /* Cuenta Caja */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CTA DO: 
   {ADM/H-CTAS01.I NO SELF}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME y-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-CodDiv DIALOG-1
ON F8 OF y-CodDiv IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF y-CodDiv DO: 
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
  DISPLAY RADIO-SET-1 C-Moneda C-Mes y-CodDiv y-codope x-cta F-Fecha 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-5 RECT-4 RADIO-SET-1 B-imprime C-Moneda B-impresoras 
         B-cancela y-CodDiv x-cta F-Fecha RB-NUMBER-COPIES RB-BEGIN-PAGE 
         RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Detalle DIALOG-1 
PROCEDURE Imp-Detalle :
def var xi as integer init 0.
def var No-tiene-mov as logical.
DEF VAR II AS INTEGER.
DEF vAR x-ope as LOGICAL.
DEF VAR x-log AS LOGICAL .
DEF VAR x-signo AS DECI.
x-log = TRUE.

DEFINE FRAME f-cab
        cb-dmov.codcta       COLUMN-LABEL "Cuenta"
        cb-dmov.nroast       COLUMN-LABEL "Compro!bante"  
        cb-dmov.codope       COLUMN-LABEL "Libro"
        cb-dmov.ClfAux       COLUMN-LABEL "Clf!Aux"
        cb-dmov.codaux       COLUMN-LABEL "Cod.!Auxiliar"
        cb-dmov.fchdoc       COLUMN-LABEL "Fecha! Doc."
        cb-dmov.CodDoc       COLUMN-LABEL "Cod!Doc"
        cb-dmov.nrodoc       COLUMN-LABEL "Numero! Doc."
        x-glodoc       COLUMN-LABEL "Glosa " FORMAT "X(25)"     
        x-debes         COLUMN-LABEL "Mon Nacional"
        x-debed         COLUMN-LABEL "Mon Extranje"
        t-debes         COLUMN-LABEL "Mon Nacional!Saldo"
        t-debed         COLUMN-LABEL "Mon Extranje!Saldo"

        HEADER
        S-NOMCIA FORMAT "X(50)"
        "C A J A   G E N E R A L   " + STRING(x-fec,"99/99/9999") FORMAT "X(60)" TO 100
        "FECHA : " TO 135 TODAY TO 145
        SKIP
        "PAGINA :" TO 135 c-pagina FORMAT "ZZ9" TO 145 SKIP
        "HORA   :" TO 135 STRING(TIME,"HH:MM AM") TO 145
        SKIP(2)
        WITH WIDTH 230 NO-BOX DOWN STREAM-IO.




ASSIGN c-debe   = 0
       c-haber  = 0
       x-saldoi = 0 
       xi       = 0 
       No-tiene-mov = yes.

hide frame f-auxiliar.

t-debes = x-saldosi .
t-debed = x-saldodi.

DO II = 1 TO NUM-ENTRIES(y-codope) :
  x-ope = TRUE.
  t-debe  = 0.
  t-haber = 0.

  FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia  = s-codcia
                           AND cb-cmov.periodo = s-periodo 
                           AND cb-cmov.codope  = ENTRY(II,y-codope)
                           AND cb-cmov.fchast  = f-fecha:                     

    x-fchast = STRING(cb-cmov.fchast).  
    FOR EACH cb-dmov of cb-cmov:
     IF cb-dmov.tpoitm = "A" THEN NEXT.
     IF cb-dmov.codope = "003" AND LOOKUP(cb-dmov.codcta,x-cta) = 0 THEN NEXT.
     IF cb-dmov.codope = "004" AND LOOKUP(cb-dmov.codcta,x-cta) > 0 THEN NEXT.

     x-signo =  IF cb-dmov.codope = "003" THEN 1 ELSE -1.
     x-codcta = cb-dmov.codcta.
     x-codmon = cb-dmov.codmon.
     ASSIGN x-glodoc = cb-dmov.glodoc
            x-NroAst = cb-dmov.NroAst
            x-CodOpe = cb-dmov.CodOpe
            x-codaux = cb-dmov.codaux
            x-NroDoc = cb-dmov.NroDoc
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
 
    x-debed  = 0.
    x-haberd = 0.
    x-debes  = 0.
    x-habers = 0.
     
    IF NOT tpomov 
    THEN DO:   
      IF x-codmon = 2 THEN DO:
         x-debed  = ImpMn2.
         x-haberd = 0.
      END.
      ELSE DO:
         x-debes  = ImpMn1.
         x-habers = 0.
      END.
    END.
    ELSE DO:      
      IF x-codmon = 2 THEN DO:
         x-debed  = 0.
         x-haberd = ImpMn2.
      END.
      ELSE DO:
         x-debes  = 0.
         x-habers = ImpMn1.
      END.

    END.
    
    {&NEW-PAGE}.
     DO:
        x-fchdoc = STRING(cb-dmov.fchdoc).  
        
        t-Debe  = t-Debe  + x-Debe - x-haber.
        t-Haber = t-Haber + x-Haber.
        c-Debe  = c-Debe  + x-Debe.
        c-Haber = c-Haber + x-Haber.
        t-Debes  = t-Debes  + x-signo * (x-Debes - x-habers).
        t-Debed  = t-Debed  + x-signo * (x-Debed - x-haberd).
        
        {&NEW-PAGE}. 
        IF  x-log AND (x-Saldosi <> 0 OR x-Saldodi <> 0 ) THEN DO:
           DISPLAY STREAM report WITH FRAME f-cab.                              
           PUT STREAM Report "Saldo Inicial " .
           PUT STREAM Report x-saldosi AT 123 .
           PUT STREAM Report x-saldodi AT 143 .
           DOWN STREAM report WITH FRAME f-cab.           
           x-log = FALSE.
        END.
        
        IF x-ope THEN DO:
           FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND
                              cb-oper.codope = x-codope 
                              NO-LOCK NO-ERROR.
           DISPLAY STREAM report WITH FRAME f-cab.                              
           PUT STREAM Report x-codope .
           PUT STREAM Report cb-oper.NomOpe FORMAT "X(45)" AT 5.        
           DOWN STREAM report WITH FRAME f-cab.           
           x-ope = FALSE.
        END.

        DISPLAY STREAM report cb-dmov.codcta 
                              cb-dmov.nroast
                              cb-dmov.codope
                              cb-dmov.clfaux
                              cb-dmov.codaux              
                              cb-dmov.fchdoc WHEN (cb-dmov.fchdoc <> ?)
                              cb-dmov.coddoc
                              cb-dmov.nrodoc
                              x-glodoc 
                              x-debes   WHEN (x-debes  <> 0)
                              x-debed   WHEN (x-debed  <> 0)
                              t-debes  
                              t-debed                                
              WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME F-cab.
        x-conreg = x-conreg + 1.
    END.            
    END.
  END.

END.    
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Saldo-backup DIALOG-1 
PROCEDURE Imp-Saldo-backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



def var xi as integer init 0.
def var No-tiene-mov as logical.

ASSIGN c-debe   = 0
       c-haber  = 0
       x-saldoi = 0 
       xi       = 0 
       No-tiene-mov = yes.
 FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
                    cb-ctas.codcta = x-codcta
                    NO-LOCK NO-ERROR.

 FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                           AND cb-dmov.periodo  = s-periodo 
                           AND cb-dmov.codcta   = x-CodCta 
                           AND cb-dmov.FchDoc   < f-fecha:                           
     case x-codmon :
          when 1 then if (not cb-dmov.tpomov) 
                      then x-saldoi = x-saldoi + cb-dmov.impmn1.
                      else x-saldoi = x-saldoi - cb-dmov.impmn1.     
          when 2 then if (not cb-dmov.tpomov) 
                      then x-saldoi = x-saldoi + cb-dmov.impmn2.
                      else x-saldoi = x-saldoi - cb-dmov.impmn2.     
     end case.

 END.

/* t-saldoi = t-saldoi + x-saldoi.*/

ASSIGN x-nroast = x-codcta
       x-GloDoc = ""
       x-fchast = ""
       x-codope = ""
       x-fchDoc = ""
       x-nroDoc = ""
       x-fchVto = ""
       x-nroref = "".

x-GloDoc = "S a l d o  I n i c i a l " .
if x-saldoi <> 0 then do:
   xi = xi + 1.
   hide frame f-auxiliar.
   view frame f-mensaje.

   {&NEW-PAGE}.
   DISPLAY STREAM report WITH FRAME f-cab.
   PUT STREAM report CONTROL P-dobleon.
   G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
   PUT STREAM report G-NOMCTA.
   PUT STREAM report CONTROL P-dobleoff.  
  DOWN STREAM report WITH FRAME f-cab.


{&NEW-PAGE}.
DISPLAY STREAM report x-fchast
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
end.

/*

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                           AND cb-dmov.periodo = s-periodo 
                           AND cb-dmov.nromes  = c-mes
                           AND cb-dmov.codope BEGINS (y-codope)
                           AND cb-dmov.codcta  = x-CodCta
                           and cb-dmov.coddiv  begins y-coddiv
                           
                  BREAK BY cb-dmov.CodOpe
                        BY cb-dmov.NroAst
                        BY cb-dmov.NroItm:

    No-tiene-mov = no.
    
    if xi = 0 then do:
       xi = xi + 1.
       hide frame f-auxiliar.
       view frame f-mensaje.
       {&NEW-PAGE}.
       DISPLAY STREAM report WITH FRAME f-cab.
       PUT STREAM report CONTROL P-dobleon.
       G-NOMCTA = cb-ctas.codcta + " " + cb-ctas.nomcta.
       PUT STREAM report G-NOMCTA.
       PUT STREAM report CONTROL P-dobleoff.  
       DOWN STREAM report WITH FRAME f-cab.
    end.    
    
    

    
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
 
    IF NOT tpomov 
    THEN DO:
        CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
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
        {&NEW-PAGE}. 
        DISPLAY STREAM report x-coddiv
                              x-fchast WHEN (x-fchast <> ?)
                              x-nroast
                              x-codope
                              x-clfaux
                              x-codaux              
                              x-fchdoc WHEN (x-fchdoc <> ?)
                              x-coddoc
                              x-nrodoc
                              x-glodoc 
                              x-debe   WHEN (x-debe  <> 0)
                              x-haber  WHEN (x-haber <> 0)
              WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME F-cab.
        x-conreg = x-conreg + 1.
    END.            
END.

If no-tiene-mov then return.

ASSIGN x-Debe   = c-Debe
       x-Haber  = c-Haber
       x-SaldoF = x-SaldoI + x-Debe - x-Haber
       x-nroast = x-codcta
       x-fchast = ""
       x-codope = ""
       x-fchDoc = ""
       x-nroDoc = ""
       x-fchVto = "TOTAL"
       x-nroref = x-CodCta
       x-GloDoc = cb-ctas.NomCta.
{&NEW-PAGE}.
UNDERLINE STREAM report x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.
{&NEW-PAGE}.
DISPLAY STREAM report   x-GloDoc
                        x-Saldoi 
                        x-debe
                        x-haber
                        x-Saldof
              WITH FRAME f-cab.

DOWN STREAM report WITH FRAME f-cab.
{&NEW-PAGE}.
UNDERLINE STREAM report x-fchast
                        x-nroast
                        x-codope              
                        x-fchdoc
                        x-nrodoc
                        x-glodoc
                        x-Saldoi 
                        x-debe   
                        x-haber 
                        x-Saldof 
              WITH FRAME f-cab.
DOWN STREAM report WITH FRAME F-cab.
*/
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
    def var con-ctas as integer.
    ASSIGN t-debe   = 0
           t-haber  = 0
           t-saldoi = 0
           t-saldof = 0
           con-ctas = 0 .

RUN Saldo.
RUN Imp-Detalle.

hide frame f-auxiliar.

if con-ctas <= 1 then return.



   
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
     
        IF NOT v-CodCta[ i ] = "" 
           AND 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo DIALOG-1 
PROCEDURE Saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR C-MES AS INTEGER.
DEFINE VAR I AS INTEGER.
x-saldosi = 0.
x-saldodi = 0.
c-mes = MONTH(F-Fecha).

DO I = 1 TO NUM-ENTRIES(y-codope):
    FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
                       cb-ctas.codcta = ENTRY(I,x-cta)
                       NO-LOCK NO-ERROR.

    x-codmon = cb-ctas.codmon.
    
    FOR EACH CB-DMOV WHERE CB-DMOV.CODCIA  = S-CODCIA  AND
                           CB-DMOV.PERIODO = S-PERIODO AND
                           CB-DMOV.CODCTA  = ENTRY(I,x-cta)  AND
                           CB-DMOV.NROMES  < C-mes :

       
                            
        IF NOT cb-dmov.tpomov THEN 
                CASE x-codmon:
                        WHEN 1 THEN 
                            x-saldosi  = x-saldosi + cb-dmov.ImpMn1.
                        WHEN 2 THEN 
                            x-saldodi  = x-saldodi + cb-dmov.ImpMn2.
                END CASE.
        ELSE
                CASE x-codmon:
                        WHEN 1 THEN 
                            x-saldosi  = x-saldosi - cb-dmov.ImpMn1.
                        WHEN 2 THEN 
                            x-saldodi  = x-saldodi - cb-dmov.ImpMn2.
                END CASE.    
    END.                       
    
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                               AND cb-dmov.periodo = s-periodo 
                               AND cb-dmov.nromes  = c-mes
                               AND cb-dmov.codcta  = ENTRY(I,x-cta)
                               BREAK BY cb-dmov.fchdoc 
                                     by cb-dmov.codope
                                     by cb-dmov.coddoc
                                     by cb-dmov.nrodoc:
                               
        FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                       AND cb-cmov.periodo = cb-dmov.periodo 
                       AND cb-cmov.nromes  = cb-dmov.nromes
                       AND cb-cmov.codope  = cb-dmov.codope
                       AND cb-cmov.nroast  = cb-dmov.nroast
                       NO-LOCK NO-ERROR.
         IF AVAILABLE cb-cmov THEN
             DO:
              IF cb-cmov.fchast >= F-Fecha THEN NEXT.               
           
                 IF NOT cb-dmov.tpomov THEN 
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
                 ELSE       
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
                 CASE x-codmon:
                        WHEN 1 THEN 
                            x-saldosi  = x-saldosi + x-debe - x-haber.
                        WHEN 2 THEN 
                            x-saldodi  = x-saldodi + x-debe - x-haber.
                 END CASE.             
           
            END. /*FIN DEL AVAIL */
    END. 
END.


                       

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


