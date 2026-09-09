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

DEFINE        VARIABLE OKpressed   AS LOGICAL NO-UNDO.
    

DEFINE        VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL NO-UNDO.


/* MACRO NUEVA-PAGINA */
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

/*VARIABLES PARTICULARES DE LA RUTINA */

DEFINE BUFFER detalle FOR cb-dmov.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(25)" NO-UNDO.
DEFINE VARIABLE x-fchast   AS CHARACTER FORMAT "X(2)" NO-UNDO.

DEFINE VARIABLE x-codref   LIKE cb-dmov.coddoc NO-UNDO.
DEFINE VARIABLE x-nom-cta  as char format "x(70)".
DEFINE VARIABLE x-cta-aux  LIKE cb-dmov.codcta NO-UNDO.
DEFINE VARIABLE x-coddoc   LIKE cb-dmov.coddoc NO-UNDO.
DEFINE VARIABLE x-nrodoc   LIKE cb-dmov.nrodoc NO-UNDO.
DEFINE VARIABLE x-nroref   LIKE cb-dmov.nroref NO-UNDO.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc NO-UNDO FORMAT "X(35)".
DEFINE VARIABLE x-nomaux   LIKE cb-dmov.glodoc NO-UNDO.

DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZZ,ZZ9.99-" 
                           COLUMN-LABEL "M o v i m i!Cargos     " NO-UNDO. 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZZ,ZZ9.99-" 
                           COLUMN-LABEL "e n t o s      !Abonos     " NO-UNDO.
DEFINE VARIABLE x-saldoi   AS DECIMAL FORMAT "(ZZZZ,ZZ9.99)"
                           COLUMN-LABEL "Saldo     !Inicial    " NO-UNDO.

DEFINE VARIABLE impca1     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca2     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca3     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca4     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca5     AS DECIMAL NO-UNDO.
DEFINE VARIABLE impca6     AS DECIMAL NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 10.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-codmon AS INTEGER INITIAL 1.


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

DEFINE VAR X-NroReg as char FORMAT "X(10)" COLUMN-LABEL "Nro.!Registro".
DEFINE VAR X-CodDiv LIKE cb-dmov.coddiv COLUMN-LABEL "Cod!Div".
DEFINE FRAME f-cab
        x-fchast       COLUMN-LABEL "Dia"
        x-coddoc       COLUMN-LABEL "Cod.!Doc."
        x-nrodoc       COLUMN-LABEL "Nro.!Dcmto."
        x-NroReg  
        x-CodDiv   
        x-glodoc       COLUMN-LABEL "C o n c e p t o"
        x-nomaux       COLUMN-LABEL "Girado por / Para"    
        x-codref       COLUMN-LABEL "Tpo!Doc"
        x-nroref       COLUMN-LABEL "Dcmto.!Cancelado"
        x-debe         COLUMN-LABEL "Depositos!N/Abono"
        x-haber        COLUMN-LABEL "Cheques!N/Cargo" 
        x-saldoi       COLUMN-LABEL "Saldo"
        HEADER
        empresas.nomcia
        "PAGINA :" TO 137 c-pagina FORMAT "ZZ9" TO 152 
        SKIP
        empresas.direccion         
        "MOVIMIENTO LIBRO BANCOS" AT  64
        "FECHA  :" TO 137 TODAY TO 152 
        SKIP
        pinta-mes AT 56
        "HORA   :" TO 137 STRING(time,"hh:mm:ss") TO 152
        SKIP(2)
        "Cuenta: "
        x-cta-aux
        x-nom-cta     
        x-moneda
        SKIP
        x-Raya AT 1 FORMAT "X(168)"
        SKIP
        WITH WIDTH 192 NO-BOX DOWN STREAM-IO.

define var x-mov as integer.
x-mov = 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 c-mes x-codcta f-TpoPag ~
f-CodDoc F-desde F-Hasta COMBO-BOX-1 RADIO-SET-1 RB-NUMBER-COPIES ~
B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS c-mes x-codcta Desctadesde f-TpoPag ~
f-CodDoc F-desde F-Hasta COMBO-BOX-1 RADIO-SET-1 RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE c-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Ingresos" 
     LABEL "Tipo de Movimientos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Ingresos ","Salidas","Ingresos y Salidas" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 50 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-TpoPag AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Forma de Pago" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 50 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE Desctadesde AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-desde AS DATE FORMAT "99/99/99":U 
     LABEL "Desde el" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Hasta AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta el" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
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

DEFINE VARIABLE x-codcta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Cod.Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10.29 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.14 BY 5.38.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.14 BY 3.96.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68.14 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     c-mes AT ROW 1.27 COL 57 COLON-ALIGNED
     x-codcta AT ROW 2.08 COL 14 COLON-ALIGNED
     Desctadesde AT ROW 2.08 COL 27.72 COLON-ALIGNED NO-LABEL
     f-TpoPag AT ROW 2.88 COL 14 COLON-ALIGNED WIDGET-ID 2
     f-CodDoc AT ROW 3.69 COL 14 COLON-ALIGNED
     F-desde AT ROW 4.5 COL 14 COLON-ALIGNED
     F-Hasta AT ROW 5.31 COL 14 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 5.31 COL 48.86 COLON-ALIGNED
     RADIO-SET-1 AT ROW 7.58 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 7.58 COL 59.43 COLON-ALIGNED
     B-impresoras AT ROW 8.58 COL 15
     RB-BEGIN-PAGE AT ROW 8.58 COL 59.43 COLON-ALIGNED
     b-archivo AT ROW 9.58 COL 15
     RB-END-PAGE AT ROW 9.58 COL 59.43 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 9.85 COL 19 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 11.54 COL 14.14
     B-cancela AT ROW 11.54 COL 44.14
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 68.14 BY .65 AT ROW 6.38 COL 1
          BGCOLOR 1 FGCOLOR 15 
     "Movimiento Libro Bancos" VIEW-AS TEXT
          SIZE 27.29 BY .73 AT ROW 1.35 COL 2.29
          FONT 1
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 7.12 COL 1
     RECT-6 AT ROW 11.08 COL 1
     SPACE(0.28) SKIP(0.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Libro  Bancos por Fechas".


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

/* SETTINGS FOR FILL-IN Desctadesde IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME DIALOG-1
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Libro  Bancos por Fechas */
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
    ASSIGN x-codcta  DesCtaDesde c-mes
           f-desde
           f-hasta
/*ML01*/   f-TpoPag
           f-coddoc.
           
    x-cta-aux = x-codcta.
    x-nom-cta = DesCtaDesde + " Del " + string(f-desde,"99/99/99") + " Al " + string(f-hasta,"99/99/99").
    RUN bin/_mes.p ( INPUT c-mes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    find cb-ctas  WHERE cb-ctas.codcia = cb-codcia AND
                        cb-ctas.codcta = x-codcta 
                        NO-LOCK NO-ERROR.
    IF NOT avail cb-ctas THEN do:
       message "Cuenta no Registrada" view-as alert-box error.
       return no-apply.
    end.               
    if f-hasta < f-desde or
       f-desde = ? or
       f-hasta = ? 
    then do:
       message "Fechas no validas"
       view-as alert-box error.
       return no-apply.
    end.      
    if month(f-desde) <> c-mes then do:
       message "Fecha de inicio no conincide con mes"
       view-as alert-box error.
       apply "ENTRY" to f-desde.
       return no-apply.
    end.
    if month(f-hasta) <> c-mes then do:
       message "Fecha final no conincide con mes"
       view-as alert-box error.
       apply "ENTRY" to f-hasta.
       return no-apply.
    end.
    x-codmon = cb-ctas.codmon.    
    IF x-codmon = 1 THEN DO:
        x-moneda = "(Soles)".
        
    END.
    ELSE DO:
        x-moneda = "(Dolares)".
        
    END.

    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
   
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


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 DIALOG-1
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME DIALOG-1 /* Tipo de Movimientos */
DO:
   
   x-mov = lookup(self:screen-value , combo-box-1:list-items).
   
  
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


&Scoped-define SELF-NAME x-codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codcta DIALOG-1
ON F8 OF x-codcta IN FRAME DIALOG-1 /* Cod.Cuenta */
DO:
    RUN cbd/q-ctas3.w( cb-codcia, "104", OUTPUT RECID-stack ).
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas
             WHERE RECID( cb-ctas ) = RECID-stack
             NO-LOCK  NO-ERROR.
        IF avail cb-ctas 
        THEN DO:
            DISPLAY integral.cb-ctas.Codcta @ x-codcta WITH FRAME DIALOG-1.
            Desctadesde:SCREEN-VALUE = integral.cb-ctas.Nomcta.            
        END.
        
        IF NOT avail cb-ctas
        THEN DO:
             BELL.
             MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
             BUTTONS OK.
             APPLY "ENTRY" TO x-codcta IN FRAME DIALOG-1.
             RETURN NO-APPLY.
        END.    
   END. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codcta DIALOG-1
ON LEAVE OF x-codcta IN FRAME DIALOG-1 /* Cod.Cuenta */
DO:
    IF x-codcta:SCREEN-VALUE = ""
    THEN DO:
       DISPLAY "Desde Cuenta Inicial" @ DesCtadesde WITH FRAME DIALOG-1.
       x-codcta:SCREEN-VALUE = "1".            
    END.           
    
    IF x-codcta:SCREEN-VALUE <> ""
    THEN DO:    
        find cb-ctas
            WHERE  integral.cb-ctas.CodCIA = cb-codcia AND
                   integral.cb-ctas.Codcta = x-codcta:SCREEN-VALUE
                   NO-LOCK  NO-ERROR.
        IF avail cb-ctas 
        THEN DO:
            DISPLAY integral.cb-ctas.Codcta @ x-codcta WITH FRAME DIALOG-1.
            Desctadesde:SCREEN-VALUE = integral.cb-ctas.Nomcta.            
        END.
        
        IF NOT avail cb-ctas
        THEN DO:
            BELL.
            MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
            APPLY "ENTRY" TO x-codcta IN FRAME DIALOG-1.
            RETURN NO-APPLY.
        END. 
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codcta DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF x-codcta IN FRAME DIALOG-1 /* Cod.Cuenta */
DO:
    APPLY "F8" TO x-codcta.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/*ML01*/ DEFINE VARIABLE cNombre AS CHARACTER NO-UNDO.

/* Inicializa valores */
FOR EACH Cb-Tabl NO-LOCK WHERE Tabla = '02':
    f-CodDoc:ADD-LAST(Cb-Tabl.Codigo + ' ' + Cb-Tabl.Nombre).
END.

/*ML01* Tipos de Pago */
FOR EACH cb-tabl WHERE cb-tabl.Tabla = "S01" NO-LOCK:
    cNombre = REPLACE(Cb-Tabl.Nombre,","," ").
    f-TpoPag:ADD-LAST(Cb-Tabl.Codigo + ' ' + cNombre).
END.

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
Assign c-mes = s-NroMes.
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
  DISPLAY c-mes x-codcta Desctadesde f-TpoPag f-CodDoc F-desde F-Hasta 
          COMBO-BOX-1 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RECT-6 c-mes x-codcta f-TpoPag f-CodDoc F-desde F-Hasta 
         COMBO-BOX-1 RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE 
         RB-END-PAGE B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp-lin DIALOG-1 
PROCEDURE imp-lin :
DISPLAY STREAM report x-fchast WHEN (x-fchast <> ?)
        x-coddoc 
        x-nrodoc 
        x-NroReg
        x-CodDiv
        x-glodoc 
        x-nomaux 
        x-codref
        x-nroref 
        x-debe   when x-debe  <> 0
        x-haber  when x-haber <> 0
        x-saldoi 
        WITH FRAME f-cab.
        DOWN STREAM report  WITH FRAME F-cab.
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

DEFINE VARIABLE x-ok AS LOGICAL INITIAL TRUE.

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia  = s-codcia
                           AND cb-dmov.periodo = s-periodo 
                           AND cb-dmov.nromes  = c-mes
                           AND cb-dmov.codcta  = x-CodCta
                           AND (f-CodDoc = 'Todos' OR cb-dmov.coddoc = SUBSTRING(f-coddoc,1,2))
                           AND cb-dmov.fchdoc  >= f-desde 
                           AND cb-dmov.fchdoc <=  f-hasta
                           BREAK BY cb-dmov.fchdoc 
                                 by cb-dmov.codope
                                 by cb-dmov.coddoc
                                 by cb-dmov.nrodoc:
    
    case x-mov :
         when 1 then if cb-dmov.tpomov then next.
         when 2 then if not cb-dmov.tpomov then next.   
    end case .
                           
    x-fchast = ?.
    
    x-NroReg = cb-dmov.codope + "-" + cb-dmov.nroast.
    x-CodDiv = cb-dmov.coddiv.
    x-nroref    = "".
    x-codref    = "".
    x-nomaux    = "".
    FIND cb-cmov WHERE cb-cmov.codcia  = cb-dmov.codcia
                   AND cb-cmov.periodo = cb-dmov.periodo 
                   AND cb-cmov.nromes  = cb-dmov.nromes
                   AND cb-cmov.codope  = cb-dmov.codope
                   AND cb-cmov.nroast  = cb-dmov.nroast
/*NL01*/           AND (f-TpoPag = 'Todos' OR cb-cmov.coddoc = TRIM(SUBSTRING(f-TpoPag,1,3)))
                   NO-LOCK NO-ERROR.
    IF AVAILABLE cb-cmov THEN DO:
             ASSIGN x-fchast = STRING(cb-cmov.fchast)
                 x-NroDoc = cb-cmov.NroChq
                 x-glodoc = cb-cmov.NotAst 
                 x-NomAux = cb-cmov.girado.
                 x-coddoc    = cb-dmov.coddoc.     
             IF x-nrodoc =  ""  THEN x-nrodoc = cb-dmov.nrodoc.
             IF x-nrodoc =  ""  THEN x-nrodoc = cb-dmov.nroref.
             x-ok = TRUE.
             bloque_1:
             FOR EACH detalle WHERE detalle.codcia  = cb-dmov.codcia  AND
                                    detalle.periodo = cb-dmov.periodo AND
                                    detalle.nromes  = cb-dmov.nromes  AND
                                    detalle.codope  = cb-dmov.codope  AND
                                    detalle.nroast  = cb-dmov.nroast  AND
                                    detalle.tpoitm  = "P" :
                                   
             FIND FIRST cp-tpro WHERE cp-tpro.codcia = cb-codcia  AND
                                       cp-tpro.codcta = detalle.codcta 
                                 NO-LOCK NO-ERROR.
             IF AVAIL cp-tpro THEN
                 DO:
                     x-nroref    = detalle.nrodoc.
                     x-codref    = detalle.coddoc.
                     IF x-codref = "" THEN x-codref = cp-tpro.coddoc.   
                     IF x-nomaux = "" THEN
                     CASE detalle.clfaux:
                         WHEN "@CL" THEN DO:
                             FIND gn-clie WHERE gn-clie.codcli = detalle.codaux
                                AND gn-clie.CodCia = cl-codcia
                                NO-LOCK NO-ERROR. 
                             IF AVAILABLE gn-clie THEN x-nomaux = gn-clie.nomcli.
                         END.
                         WHEN "@PV" THEN DO:
                             FIND gn-prov WHERE gn-prov.codpro = detalle.codaux
                                AND gn-prov.CodCia = pv-codcia
                                NO-LOCK NO-ERROR.                      
                             IF AVAILABLE gn-prov THEN x-nomaux = gn-prov.nompro.
                     END.
                
                     OTHERWISE DO:
                         FIND cb-auxi WHERE cb-auxi.clfaux = detalle.clfaux
                             AND cb-auxi.codaux = detalle.codaux
                             AND cb-auxi.CodCia = cb-codcia
                             NO-LOCK NO-ERROR.                      
                             IF AVAILABLE cb-auxi THEN x-nomaux = cb-auxi.nomaux.
                     END.
                 END CASE.
                 if x-codref <> "" and x-NroRef <> "" then leave bloque_1.
                 END.
              ELSE
                 DO:
                     x-nroref = "".
                     x-codref = "".
                    /* x-nomaux = "". */
                 END.   
            
             END. /*FOR EACH DETALLE */                                      
               
            
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
             x-saldoi = x-saldoi + x-debe - x-haber.
             ACCUMULATE x-debe (TOTAL) x-haber (TOTAL).
            
                        {&NEW-PAGE}.                                    
                        RUN imp-lin.
       
    END. /*FIN DEL AVAIL */
END. /*FIN DEL FOR EACH cb-dmov*/
{&NEW-PAGE}.                                    
UNDERLINE STREAM report x-debe x-haber x-saldoi WITH FRAME f-cab.
DOWN STREAM report  WITH FRAME F-cab.
DISPLAY STREAM report ACCUM TOTAL x-debe @ x-debe  ACCUM TOTAL x-haber @ x-haber x-saldoi WITH FRAME f-cab. 
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

