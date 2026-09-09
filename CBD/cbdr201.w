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
DEFINE        VARIABLE x-con-reg    AS INTEGER NO-UNDO.
DEFINE        VARIABLE x-smon       AS CHARACTER FORMAT "X(3)".

DEFINE        VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO .


/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

/*VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                LABEL "Debe      ".
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-" 
                                                LABEL "Haber     ".
DEFINE VARIABLE x-totdebe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-tothabe  AS DECIMAL FORMAT "ZZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-codope   LIKE cb-cmov.Codope.
DEFINE VARIABLE x-nom-ope  LIKE cb-oper.nomope.
DEFINE VARIABLE x-nroast   LIKE cb-cmov.Nroast.
DEFINE VARIABLE x-fecha    LIKE cb-cmov.fchast.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc.



DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 10.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 4.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".

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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".


 DEFINE FRAME f-cab
        cb-cmov.fchast         COLUMN-LABEL " Fecha!Asiento"
        cb-cmov.nroast         COLUMN-LABEL "Compro!bante"
        cb-dmov.fchdoc         COLUMN-LABEL " Fecha!  Doc."
        cb-dmov.coddoc         COLUMN-LABEL "Cod.!Doc."
        cb-dmov.nrodoc 
        cb-dmov.fchvto         COLUMN-LABEL " Fecha!  Vto."
        cb-dmov.clfaux         COLUMN-LABEL "Clf!Aux"
        cb-dmov.codaux         COLUMN-LABEL "Auxi-!liar"
        cb-dmov.cco            COLUMN-LABEL "Cco."
        cb-dmov.coddiv         COLUMN-LABEL "Div."          FORMAT 'x(5)'
        cb-dmov.codcta         
        x-glodoc 
        x-debe 
        x-haber 
        HEADER
        s-nomcia
        "D I A R I O   G E N E R A L" TO 79
        /*"FECHA : " TO 140 TODAY TO 150*/
        SKIP
        pinta-mes AT 46
        "PAGINA :" TO 140 c-pagina FORMAT "ZZZZ9" TO 150 
        SKIP
        "L I B R O" TO 68 x-codope TO 72
        SKIP
        x-nom-ope AT 46
        SKIP(2)
        WITH WIDTH 165 NO-BOX DOWN STREAM-IO.

def var t-d as decimal init 0.
def var t-h as decimal init 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-5 RECT-10 RECT-4 x-Div v-fecha-1 ~
x-codmon y-codope v-fecha-2 x-a1 x-a2 RADIO-SET-1 RB-NUMBER-COPIES ~
B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-Div v-fecha-1 x-codmon y-codope ~
v-fecha-2 x-a1 x-a2 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     SIZE 11 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY 1.5.

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 1" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

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
     SIZE 26.43 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE v-fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde la Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE v-fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta la Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-a1 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Del Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-a2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Al Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10 BY 3 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 12.57 BY 1.35 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 17 BY 1.81.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63.14 BY 4.12.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63.14 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63.14 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-Div AT ROW 1.81 COL 26.72 COLON-ALIGNED
     v-fecha-1 AT ROW 1.81 COL 48 COLON-ALIGNED HELP
          "EN BLANCO ACEPTA TODAS LA FECHAS DEL MES"
     x-codmon AT ROW 2.58 COL 5.14 NO-LABEL
     y-codope AT ROW 2.58 COL 26.72 COLON-ALIGNED
     v-fecha-2 AT ROW 2.58 COL 48 COLON-ALIGNED
     x-a1 AT ROW 3.35 COL 48 COLON-ALIGNED
     x-a2 AT ROW 4.12 COL 48 COLON-ALIGNED
     RADIO-SET-1 AT ROW 6.38 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 6.5 COL 55.43 COLON-ALIGNED
     B-impresoras AT ROW 7.38 COL 12.72
     RB-BEGIN-PAGE AT ROW 7.5 COL 55.43 COLON-ALIGNED
     b-archivo AT ROW 8.38 COL 12.72
     RB-END-PAGE AT ROW 8.5 COL 55.43 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 8.65 COL 16.72 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 10.15 COL 6
     B-cancela AT ROW 10.15 COL 20
     BUTTON-2 AT ROW 10.15 COL 34 WIDGET-ID 2
     BUTTON-1 AT ROW 10.15 COL 49
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .65 AT ROW 1.46 COL 3.14
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 63.14 BY .69 AT ROW 5.19 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-6 AT ROW 9.88 COL 1
     RECT-5 AT ROW 5.88 COL 1
     RECT-10 AT ROW 2.38 COL 3.14
     RECT-4 AT ROW 1 COL 1
     SPACE(0.00) SKIP(6.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Libro Diario General".


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

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Libro Diario General */
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
        ASSIGN v-fecha-1
               v-fecha-2
               x-codmon
               y-CodOpe
               x-a1
               x-a2
               x-div.
        IF s-NroMes = 0 OR s-NroMes = 13 THEN
        IF x-codmon = 1 THEN x-smon = "S/.".
        ELSE                 x-smon = "US$".
        IF y-codope <> "" AND
             NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                            cb-oper.codope = y-codope)
        THEN DO:
            BELL.
            MESSAGE "Código de operación no existe " + Y-CODOPE
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO y-codope.
            RETURN NO-APPLY.
        END.
        IF x-div  <> "" AND
             NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                                GN-DIVI.codDIV = x-div) 
        THEN DO:                                        
             BELL.
             MESSAGE "División No Registrada" + Y-CODOPE
                    VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO x-div.
             RETURN NO-APPLY.
        END.                                            
                                                
    
    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".
    
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 DIALOG-1
ON CHOOSE OF BUTTON-1 IN FRAME DIALOG-1 /* Button 1 */
DO:
    ASSIGN v-fecha-1
           v-fecha-2
           x-codmon
           y-CodOpe
           x-a1
           x-a2
           x-div.
    IF s-NroMes = 0 OR s-NroMes = 13 THEN
    IF x-codmon = 1 THEN x-smon = "S/.".
    ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "Código de operación no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
    IF x-div  <> "" AND
         NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                            GN-DIVI.codDIV = x-div) 
    THEN DO:                                        
         BELL.
         MESSAGE "División No Registrada" + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO x-div.
         RETURN NO-APPLY.
    END.                                            
    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".

  RUN Texto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 DIALOG-1
ON CHOOSE OF BUTTON-2 IN FRAME DIALOG-1 /* Button 2 */
DO:
    ASSIGN v-fecha-1
           v-fecha-2
           x-codmon
           y-CodOpe
           x-a1
           x-a2
           x-div.
    IF s-NroMes = 0 OR s-NroMes = 13 THEN
    IF x-codmon = 1 THEN x-smon = "S/.".
    ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "Código de operación no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
    IF x-div  <> "" AND
         NOT CAN-FIND(FIRST GN-DIVI   WHERE GN-DIVI.codcia = S-codcia AND
                                            GN-DIVI.codDIV = x-div) 
    THEN DO:                                        
         BELL.
         MESSAGE "División No Registrada" + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO x-div.
         RETURN NO-APPLY.
    END.                                            
    IF v-fecha-1 = ?   THEN v-fecha-1 = DATE(1,1,1).
    IF v-fecha-2 = ?   THEN v-fecha-2 = DATE(12,31,9999).
    IF x-a1      = ""  THEN x-a1      = "000000".
    IF x-a2      = ""  THEN x-a2      = "999999".

  RUN Excel.

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


&Scoped-define SELF-NAME x-Div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Div DIALOG-1
ON F8 OF x-Div IN FRAME DIALOG-1 /* División */
OR "MOUSE-SELECT-DBLCLICK":U OF X-DIV DO:
 
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
  DISPLAY x-Div v-fecha-1 x-codmon y-codope v-fecha-2 x-a1 x-a2 RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-5 RECT-10 RECT-4 x-Div v-fecha-1 x-codmon y-codope 
         v-fecha-2 x-a1 x-a2 RADIO-SET-1 RB-NUMBER-COPIES B-impresoras 
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

    t-d = 0.
    t-h = 0.
    x-totdebe = 0.
    x-tothabe = 0.

    VIEW FRAME f-mensaje.
    PAUSE 0.

    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
        AND cb-cmov.periodo = s-periodo           
        AND cb-cmov.nromes  = s-NroMes           
        AND cb-cmov.codope BEGINS (y-codope)  
        AND cb-cmov.fchast >= v-fecha-1       
        AND cb-cmov.fchast <= v-fecha-2       
        AND cb-cmov.nroast >= x-a1            
        AND cb-cmov.nroast <= x-a2 
        BREAK BY cb-cmov.codope 
        WITH FRAME f-cab:
        IF FIRST-OF(cb-cmov.codope) THEN DO:
            /* titulos */
            RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
            pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
            FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND 
                                   cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
            x-codope = cb-oper.codope.                     
            RUN bin/_centrar.p ( INPUT cb-oper.nomope, 40 , OUTPUT x-nom-ope ).
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "D I A R I O    G E N E R A L".
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = pinta-mes.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "L I B R O " + x-codope.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nom-ope.
            iCount = iCount + 2.
            /* set the column names for the Worksheet */
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Asiento".
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "Comprobante".
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Doc.".
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = "Cod. Doc.".
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = "Nro. Doc.".
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = "Fecha Vcto.".
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = "Clf. Aux.".
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = "Auxiliar".
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = "C. Costo".
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = "División".
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = "Cuenta".
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "Glosa".
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = "Debe".
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = "Haber".
            iCount = iCount + 1.
        END.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
            AND cb-dmov.periodo = s-periodo           
            AND cb-dmov.nromes  = s-NroMes           
            AND cb-dmov.codope  = cb-cmov.codope  
            AND cb-dmov.nroast  = cb-cmov.nroast  
            AND cb-dmov.coddiv  BEGINS (x-div) 
            BREAK BY (cb-dmov.nroast):
            x-glodoc = glodoc.
            IF x-glodoc = "" THEN RUN p-nom-aux.
            IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
            IF NOT tpomov THEN 
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
            ELSE 
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
                
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
                x-totdebe = x-totdebe + x-debe.
                x-tothabe = x-tothabe + x-haber.
                t-d       = t-d       + x-debe.
                t-h       = t-h       + x-haber.
                ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
                ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
                IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0) THEN DO:
                    x-glodoc = SUBSTRING(x-glodoc,1,11).
                    IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                    x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
                END.
                cColumn = STRING(iCount).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.fchdoc.
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-cmov.coddoc.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.nrodoc.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.fchvto.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.clfaux.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.cco.
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.coddiv.
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = cb-dmov.codcta.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-debe.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-haber.
                iCount = iCount + 1.
                x-con-reg = x-con-reg + 1.
            END.    
            IF LAST-OF (cb-dmov.nroast) AND x-con-reg > 0
            THEN DO:
                x-glodoc = "                TOTALES : " + x-smon.
                cColumn = STRING(iCount).
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-glodoc.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe).
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = (ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber).
                iCount = iCount + 1.
            END.
        END.  /* FIN DEL FOR EACH cb-dmov */
        IF cb-cmov.flgest = "A" THEN DO:
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "******* A N U L A D O *******".
            iCount = iCount + 1.
        END.      
        IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN DO:
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.notast.
            iCount = iCount + 1.
        END.    
        x-con-reg = 0.
        IF LAST-OF (cb-cmov.codope) THEN DO:
            cColumn = STRING(iCount).
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = "** TOTAL OPERACION ** " + x-smon.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = x-totdebe.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = x-tothabe.
            iCount = iCount + 1.
            x-tothabe = 0.
            x-totdebe = 0.
        END.
    END.
    cColumn = STRING(iCount).
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "** TOTAL GENERAL ** " + x-smon.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = t-d.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = t-h.
    iCount = iCount + 1.
    HIDE FRAME f-mensaje.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp-lin DIALOG-1 
PROCEDURE imp-lin :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
                  DISPLAY STREAM report 
                                      cb-cmov.fchast 
                                      cb-cmov.nroast 
                                      cb-dmov.fchdoc 
                                      cb-dmov.coddoc
                                      cb-dmov.nrodoc 
                                      cb-dmov.fchvto 
                                      cb-dmov.clfaux
                                      cb-dmov.codaux 
                                      cb-dmov.cco
                                      cb-dmov.coddiv
                                      cb-dmov.codcta 
                                      x-glodoc
                                      x-debe   WHEN (x-debe  <> 0)
                                      x-haber  WHEN (x-haber <> 0) 
                                WITH FRAME f-cab.
                 DOWN STREAM report 1 WITH FRAME f-cab.   
  
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
    p-largo = 88.
    def var linact as integer.
    P-Config = P-20cpi + P-8lpi.
    x-Raya   = FILL("-", P-Ancho).
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    
    t-d = 0.
    t-h = 0.
    x-totdebe = 0.
    x-tothabe = 0.
    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         AND
                                   cb-cmov.periodo = s-periodo           AND
                                   cb-cmov.nromes  = s-NroMes           AND
                                   cb-cmov.codope BEGINS (y-codope)  AND
                                   cb-cmov.fchast >= v-fecha-1       AND
                                   cb-cmov.fchast <= v-fecha-2       AND
                                   cb-cmov.nroast >= x-a1            AND
                                   cb-cmov.nroast <= x-a2 
                          BREAK BY cb-cmov.codope 
                          WITH FRAME f-cab 
                          /*ON ERROR UNDO, LEAVE*/:
        FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND 
                               cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
        x-codope = cb-oper.codope.                     
        RUN bin/_centrar.p ( INPUT cb-oper.nomope, 40 , OUTPUT x-nom-ope ).
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  AND
                                       cb-dmov.periodo = s-periodo           AND
                                       cb-dmov.nromes  = s-NroMes           AND
                                       cb-dmov.codope  = cb-cmov.codope  AND
                                       cb-dmov.nroast  = cb-cmov.nroast  AND
                                       cb-dmov.coddiv  BEGINS (x-div) 
                             BREAK BY (cb-dmov.nroast) /*ON ERROR UNDO, LEAVE*/:
            x-glodoc = glodoc.
            IF x-glodoc = "" THEN RUN p-nom-aux.
            IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
            IF NOT tpomov THEN 
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
            ELSE 
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
                
            IF NOT (x-haber = 0 AND x-debe = 0) 
                            AND x-debe <> ? AND x-haber <> ?
            THEN DO:
                x-totdebe = x-totdebe + x-debe.
                x-tothabe = x-tothabe + x-haber.
                t-d       = t-d       + x-debe.
                t-h       = t-h       + x-haber.
                
                ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
                ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
                {&NEW-PAGE}.
                IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0)
                    THEN DO:
                       x-glodoc = SUBSTRING(x-glodoc,1,11).
                       IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                       x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
                    END.
                RUN imp-lin.
                x-con-reg = x-con-reg + 1.
            END.    
            
            IF LAST-OF (cb-dmov.nroast) AND x-con-reg > 0
            THEN DO:
                x-glodoc = "                TOTALES : " + x-smon.
                {&NEW-PAGE}.
                UNDERLINE STREAM report x-debe x-haber WITH FRAME f-cab.
                DOWN STREAM  REPORT  WITH FRAME F-CAB. 
                DISPLAY STREAM report x-glodoc 
                        ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                        ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                    WITH FRAME f-cab.
                DOWN STREAM report WITH FRAME f-cab.    
            END.
           
        END.  /* FIN DEL FOR EACH cb-dmov */
      
        IF cb-cmov.flgest = "A" THEN
            DO:
            {&NEW-PAGE}.    
            DISPLAY STREAM report fchast cb-cmov.nroast 
                        "******* A N U L A D O *******" @ x-glodoc
                 WITH FRAME f-cab.
            DOWN STREAM report  WITH FRAME f-cab. 
            END.      
        IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN
            DO:
            {&NEW-PAGE}.
            DISPLAY STREAM report cb-cmov.fchast  cb-cmov.nroast 
                        cb-cmov.notast @ x-glodoc
                WITH FRAME f-cab.
            DOWN STREAM report  WITH FRAME f-cab.
            END.    
        x-con-reg = 0.
        {&NEW-PAGE}.
        UNDERLINE STREAM report fchast 
                                      cb-cmov.nroast 
                                      cb-dmov.fchdoc
                                      cb-dmov.coddoc 
                                      cb-dmov.nrodoc 
                                      cb-dmov.fchvto 
                                      cb-dmov.clfaux
                                      cb-dmov.codaux 
                                      cb-dmov.codcta 
                                      x-glodoc 
                                      x-debe   
                                      x-haber  
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        IF LAST-OF (cb-cmov.codope) THEN DO:
            {&NEW-PAGE}.
            DISPLAY STREAM report "** TOTAL OPERACION ** " + x-smon @ x-glodoc 
                                      x-totdebe @ x-debe
                                      x-tothabe @ x-haber
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.    
            
            IF LINE-COUNTER( report ) < (P-Largo - 8 ) THEN DO :
               RUN NEW-PAGE.    
            END.
            x-tothabe = 0.
            x-totdebe = 0.
         END.
      
    END.
    
        {&NEW-PAGE}.
        UNDERLINE STREAM report fchast 
                                      cb-cmov.nroast 
                                      cb-dmov.fchdoc
                                      cb-dmov.coddoc 
                                      cb-dmov.nrodoc 
                                      cb-dmov.fchvto 
                                      cb-dmov.clfaux
                                      cb-dmov.codaux 
                                      cb-dmov.codcta 
                                      x-glodoc 
                                      x-debe   
                                      x-haber  
                                WITH FRAME f-cab.
        DOWN STREAM report 1 WITH  FRAME f-cab.                        
        {&NEW-PAGE}.
         DISPLAY STREAM report "** TOTAL GENERAL ** " + x-smon @ x-glodoc 
                                      t-d @ x-debe
                                      t-h @ x-haber
         WITH FRAME f-cab.

    
     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE p-nom-aux DIALOG-1 
PROCEDURE p-nom-aux :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

                CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                                    AND gn-clie.CodCia = cl-codcia
                                 NO-LOCK NO-ERROR. 
                    IF AVAILABLE gn-clie THEN x-glodoc = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                    AND gn-prov.CodCia = pv-codcia
                                NO-LOCK NO-ERROR.                      
                    IF AVAILABLE gn-prov THEN x-glodoc = gn-prov.nompro.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto DIALOG-1 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
  DEF VAR x-CodDoc  AS CHAR NO-UNDO.

  DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
  DEFINE VAR VAN     AS DECI EXTENT 10.
  DEFINE VAR X-LLAVE AS LOGICAL.
 
  x-Archivo = 'Diario' + STRING(s-Periodo, '9999') + STRING(s-NroMes, '99') + '.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.


  OUTPUT STREAM REPORT TO VALUE(x-Archivo).

  FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia = s-codcia         
        AND cb-cmov.periodo = s-periodo           
        AND cb-cmov.nromes  = s-NroMes           
        AND cb-cmov.codope BEGINS (y-codope)  
        AND cb-cmov.fchast >= v-fecha-1       
        AND cb-cmov.fchast <= v-fecha-2       
        AND cb-cmov.nroast >= x-a1            
        AND cb-cmov.nroast <= x-a2 
        BREAK BY cb-cmov.codope 
        WITH FRAME f-cab :
    FIND cb-oper WHERE cb-oper.codcia = cb-codcia 
        AND cb-oper.codope = cb-cmov.codope NO-LOCK NO-ERROR.                                         
    x-codope = cb-oper.codope.                     
    RUN bin/_centrar.p ( INPUT cb-oper.nomope, 40 , OUTPUT x-nom-ope ).
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  
            AND cb-dmov.periodo = s-periodo           
            AND cb-dmov.nromes  = s-NroMes           
            AND cb-dmov.codope  = cb-cmov.codope  
            AND cb-dmov.nroast  = cb-cmov.nroast  
            AND cb-dmov.coddiv  BEGINS (x-div) 
            BREAK BY (cb-dmov.nroast):
        x-glodoc = glodoc.
        IF x-glodoc = "" THEN RUN p-nom-aux.
        IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
        IF NOT tpomov THEN 
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
        ELSE 
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
                
        IF NOT (x-haber = 0 AND x-debe = 0) 
                            AND x-debe <> ? AND x-haber <> ?
            THEN DO:
                x-totdebe = x-totdebe + x-debe.
                x-tothabe = x-tothabe + x-haber.
                t-d       = t-d       + x-debe.
                t-h       = t-h       + x-haber.
                
                ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nroast).
                ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nroast).
                IF (x-codmon = 1) AND (cb-dmov.codmon = 2) AND (cb-dmov.impmn2 > 0)
                    THEN DO:
                       x-glodoc = SUBSTRING(x-glodoc,1,11).
                       IF LENGTH(x-glodoc) < 11 THEN x-glodoc = x-glodoc + FILL(" ",14 - LENGTH(x-glodoc)).     
                       x-glodoc = x-glodoc + " ($" +  STRING(cb-dmov.impmn2,"ZZ,ZZZ,ZZ9.99") + ")". 
                    END.
                  DISPLAY STREAM report 
                                      cb-cmov.fchast 
                                      cb-cmov.nroast 
                                      cb-dmov.fchdoc 
                                      cb-dmov.coddoc
                                      cb-dmov.nrodoc 
                                      cb-dmov.fchvto 
                                      cb-dmov.clfaux
                                      cb-dmov.codaux 
                                      cb-dmov.cco
                                      cb-dmov.coddiv
                                      cb-dmov.codcta 
                                      x-glodoc
                                      x-debe   WHEN (x-debe  <> 0)
                                      x-haber  WHEN (x-haber <> 0) 
                                WITH FRAME f-cab.
                 DOWN STREAM report 1 WITH FRAME f-cab.   
                x-con-reg = x-con-reg + 1.
            END.    
            
        IF LAST-OF (cb-dmov.nroast) AND x-con-reg > 0
            THEN DO:
                x-glodoc = "                TOTALES : " + x-smon.
                UNDERLINE STREAM report x-debe x-haber WITH FRAME f-cab.
                DOWN STREAM  REPORT  WITH FRAME F-CAB. 
                DISPLAY STREAM report x-glodoc 
                        ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-debe  @ x-debe
                        ACCUM SUB-TOTAL BY (cb-dmov.nroast) x-haber @ x-haber
                    WITH FRAME f-cab.
                DOWN STREAM report WITH FRAME f-cab.    
        END.
           
    END.  /* FIN DEL FOR EACH cb-dmov */
      
    IF cb-cmov.flgest = "A" THEN
        DO:
        DISPLAY STREAM report fchast cb-cmov.nroast 
                    "******* A N U L A D O *******" @ x-glodoc
             WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME f-cab. 
        END.      
    IF x-con-reg = 0 AND cb-cmov.flgest <> "A" THEN
        DO:
        DISPLAY STREAM report cb-cmov.fchast  cb-cmov.nroast 
                    cb-cmov.notast @ x-glodoc
            WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME f-cab.
        END.    
    x-con-reg = 0.
    UNDERLINE STREAM report fchast 
                                  cb-cmov.nroast 
                                  cb-dmov.fchdoc
                                  cb-dmov.coddoc 
                                  cb-dmov.nrodoc 
                                  cb-dmov.fchvto 
                                  cb-dmov.clfaux
                                  cb-dmov.codaux 
                                  cb-dmov.codcta 
                                  x-glodoc 
                                  x-debe   
                                  x-haber  
                            WITH FRAME f-cab.
    DOWN STREAM report 1 WITH  FRAME f-cab.                        
    IF LAST-OF (cb-cmov.codope) THEN DO:
        DISPLAY STREAM report "** TOTAL OPERACION ** " + x-smon @ x-glodoc 
                                  x-totdebe @ x-debe
                                  x-tothabe @ x-haber
            WITH FRAME f-cab.
        DOWN STREAM report 1 WITH FRAME f-cab.    
        
        x-tothabe = 0.
        x-totdebe = 0.
     END.
      
  END.
    
    UNDERLINE STREAM report fchast 
                                  cb-cmov.nroast 
                                  cb-dmov.fchdoc
                                  cb-dmov.coddoc 
                                  cb-dmov.nrodoc 
                                  cb-dmov.fchvto 
                                  cb-dmov.clfaux
                                  cb-dmov.codaux 
                                  cb-dmov.codcta 
                                  x-glodoc 
                                  x-debe   
                                  x-haber  
                            WITH FRAME f-cab.
    DOWN STREAM report 1 WITH  FRAME f-cab.                        
     DISPLAY STREAM report "** TOTAL GENERAL ** " + x-smon @ x-glodoc 
                                  t-d @ x-debe
                                  t-h @ x-haber
     WITH FRAME f-cab.

  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

