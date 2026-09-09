&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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
DEFINE BUFFER detalle FOR cb-dmov.
DEFINE VARIABLE x-nomclf   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-nomaux   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE x-nomcta   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE imp-aux    AS LOGICAL.
DEFINE VARIABLE imprime    AS LOGICAL INITIAL YES.
DEFINE VARIABLE imp-cta    AS LOGICAL INITIAL YES.
DEFINE VARIABLE x-conreg   AS INTEGER.
DEFINE VARIABLE x-condoc   AS INTEGER.
DEFINE VARIABLE prov-cia   AS INTEGER.
DEFINE VARIABLE clie-cia   AS INTEGER.
DEFINE VARIABLE x-glodoc   LIKE cb-dmov.glodoc.


DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Cargos     ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Abonos     ".
DEFINE VARIABLE x-importe  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           LABEL "Importe    ".
DEFINE VARIABLE x-saldo    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Actual    ".

/*VARIABLES GLOBALES */
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 7.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 4.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(50)".
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


DEF VAR X-CLFAUX AS CHAR INIT "".

DEFINE VAR X-MENSAJE AS CHAR FORMAT "X(40)".
DEFINE FRAME F-AUXILIAR
     X-MENSAJE
WITH TITLE "Espere un momento por fabor" VIEW-AS DIALOG-BOX CENTERED
          NO-LABELS.

DEF VAR T-Q AS INTEGER.
T-Q = 1.
define temp-table t-rep
FIELD        fchdoc like cb-dmov.fchdoc
FIELD        nroast like cb-dmov.nroast
FIELD        coddiv like cb-dmov.coddiv
FIELD        cco    like cb-dmov.cco
FIELD        codope like cb-dmov.codope
FIELD        nromes like cb-dmov.nromes
FIELD        coddoc like cb-dmov.coddoc
FIELD        nrodoc like cb-dmov.nrodoc
FIELD        nroref like cb-dmov.nroref
FIELD        fchvto like cb-dmov.fchvto
FIELD        glodoc like cb-dmov.GLODOC
FIELD        importe  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" LABEL "Importe!Original"
FIELD        debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" LABEL "Cargos"
FIELD        haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" LABEL "Abonos"
FIELD        saldo    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" LABEL "Saldo!Actual"
FIELD        CLFAUX   AS CHAR 
FIELD        codaux   LIKE CB-DMOV.CODAUX
FIELD        codcta   LIKE CB-DMOV.CODCTA
INDEX IDX01  CODCTA CODAUX FCHDOC
INDEX IDX02  CODAUX CODCTA FCHDOC
INDEX IDX03  FCHDOC .

        
        
        
 DEFINE FRAME f-cab
        t-rep.fchdoc COLUMN-LABEL " Fecha!  Doc."
        t-rep.nroast COLUMN-LABEL "Compro!bante"
        t-rep.coddiv COLUMN-LABEL "Div"
        t-rep.cco    COLUMN-LABEL "C.Cos"
        t-rep.codope COLUMN-LABEL "Li-!bro"
        t-rep.nromes LABEL        "Mes"
        t-rep.coddoc COLUMN-LABEL "C¢digo! Doc."  
        t-rep.nrodoc COLUMN-LABEL "  Nro.!Documento"
        t-rep.nroref
        t-rep.fchvto COLUMN-LABEL " Fecha!  Vto."
        t-rep.glodoc FORMAT "X(50)"          
        t-rep.importe  
        t-rep.debe
        t-rep.haber  
        t-rep.saldo
        HEADER
        S-NOMCIA
        "SALDO  DE  DOCUEMENTOS  PENDIENTES"  AT 71
        "FECHA : " TO 180 TODAY TO 190
        SKIP
      /*  
        empresas.direccion
      */ 
        pinta-mes AT 68
        "PAGINA :" TO 180 c-pagina FORMAT "ZZ9" TO 190
        x-nomclf  AT 63
        x-expres  AT 68
        SKIP(2)
        WITH WIDTH 255 NO-BOX DOWN STREAM-IO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-11 x-codmon X-DIV C-Mes x-cuenta ~
x-auxiliar c-orden RECT-5 RADIO-SET-1 RB-NUMBER-COPIES B-impresoras ~
RB-BEGIN-PAGE RB-END-PAGE RECT-6 B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS x-codmon X-DIV C-Mes x-cuenta x-auxiliar ~
c-orden RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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

DEFINE VARIABLE C-Mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Al Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 13
     LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10","11","12" 
     SIZE 8 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE c-orden AS CHARACTER FORMAT "X(256)":U INITIAL "Cuenta, Auxiliar" 
     LABEL "Ordenado por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Cuenta, Auxiliar","Auxiliar , Cuenta","Fecha" 
     SIZE 16.86 BY 1
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

DEFINE VARIABLE x-auxiliar AS CHARACTER FORMAT "X(10)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-cuenta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE X-DIV AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .85
     BGCOLOR 15  NO-UNDO.

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
"D¢lares", 2
     SIZE 8.43 BY 1.77 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 10.86 BY 2.15.

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
     x-codmon AT ROW 2.42 COL 9 NO-LABEL
     X-DIV AT ROW 2.12 COL 32.29 COLON-ALIGNED
     C-Mes AT ROW 2.04 COL 58 COLON-ALIGNED
     x-cuenta AT ROW 3.19 COL 32.29 COLON-ALIGNED
     x-auxiliar AT ROW 4.27 COL 32.29 COLON-ALIGNED
     c-orden AT ROW 5.46 COL 32.29 COLON-ALIGNED
     RADIO-SET-1 AT ROW 8 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 8 COL 64 COLON-ALIGNED
     B-impresoras AT ROW 9 COL 15
     RB-BEGIN-PAGE AT ROW 9 COL 64 COLON-ALIGNED
     b-archivo AT ROW 10 COL 15
     RB-OUTPUT-FILE AT ROW 10.27 COL 19 COLON-ALIGNED NO-LABEL
     RB-END-PAGE AT ROW 10 COL 64 COLON-ALIGNED
     B-imprime AT ROW 12 COL 18
     B-cancela AT ROW 12 COL 48
     RECT-4 AT ROW 1 COL 1
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.5 COL 7.43
     RECT-11 AT ROW 2.27 COL 7.29
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 74 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 7.5 COL 1
     RECT-6 AT ROW 11.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Saldo de Documentos Pendientes".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


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

&Scoped-define SELF-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DIALOG-1 DIALOG-1
ON GO OF FRAME DIALOG-1 /* Saldo de Documentos Pendientes */
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
    ASSIGN x-div
           x-codmon 
           c-mes     
           x-auxiliar
           x-cuenta.
           
     IF X-CUENTA  = "" THEN DO:
        MESSAGE "Cuenta no puede ser blanco"
        VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO X-CUENTA.
        RETURN NO-APPLY.
     END.   
     
     /*DETERMINANDO EL NOMBRE DE LA CLASIFICACION DE  AUXILIAR */  
            CASE x-clfaux :
                WHEN "@CT" THEN  x-nomclf = "<< C U E N T A S >>".
                WHEN "@CL" THEN  x-nomclf = "<< C L I E N T E S >>".
                WHEN "@PV" THEN  x-nomclf = "<< P R O V E E D O R E S >>".
                OTHERWISE 
                    DO:
                        FIND cb-tabl WHERE cb-tabl.tabla = "01"
                                AND cb-tabl.codigo = x-clfaux
                               NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-tabl THEN x-nomclf = "<<" + cb-tabl.nombre + ">>".
                        ELSE x-nomclf = "".
                    END.
            END CASE.    
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


&Scoped-define SELF-NAME c-orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-orden DIALOG-1
ON VALUE-CHANGED OF c-orden IN FRAME DIALOG-1 /* Ordenado por */
DO:
   case INPUT C-ORDEN :
   
        WHEN "C" THEN T-Q = 1 .  
        WHEN "A" THEN T-Q = 2 .  
        WHEN "F" THEN T-Q = 3 .  
   end case .
         
                                
  
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
ON ENTRY OF x-auxiliar IN FRAME DIALOG-1 /* Auxiliar */
DO:
  
   X-CLFAUX = "".
   FIND CB-CTAS WHERE CB-CTAS.CODCIA = CB-CODCIA AND
                      CB-CTAS.CODCTA = X-CUENTA:SCREEN-VALUE
                      NO-LOCK NO-ERROR.
   IF AVAIL CB-CTAS THEN X-CLFAUX = CB-CTAS.CLFAUX.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-auxiliar DIALOG-1
ON LEAVE OF x-auxiliar IN FRAME DIALOG-1 /* Auxiliar */
DO:
   IF X-CLFAUX = "" THEN 
        SELF:SCREEN-VALUE = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-auxiliar DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF x-auxiliar IN FRAME DIALOG-1 /* Auxiliar */
OR "F8" OF X-AUXILIAR DO:
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  
    IF X-CLFAUX = "" THEN RETURN.
    
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


&Scoped-define SELF-NAME x-cuenta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-cuenta DIALOG-1
ON F8 OF x-cuenta IN FRAME DIALOG-1 /* Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CUENTA DO:
  
  {ADM/H-CTAS02.I NO SELF}
   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-DIV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-DIV DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF X-DIV IN FRAME DIALOG-1 /* Divisi¢n */
OR "F8" OF X-DIV DO:
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

ASSIGN C-MES = S-NROMES.
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
  DISPLAY x-codmon X-DIV C-Mes x-cuenta x-auxiliar c-orden RADIO-SET-1 
          RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-11 x-codmon X-DIV C-Mes x-cuenta x-auxiliar c-orden RECT-5 
         RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE 
         RECT-6 B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
DEF VAR X AS INTEGER.
    X= 0.
    P-config  = p-20cpi.
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-nomclf,  50 , OUTPUT x-nomclf ).
    x-Raya   = FILL("-", P-Ancho).


IF C-COPIAS = 1 THEN DO:   
DISPLAY "Seleccionando Informaci¢n Solicitada" @ x-mensaje
WITH FRAME F-AUXILIAR.
PAUSE 0.    

    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                            AND cb-dmov.periodo = s-periodo 
                            AND cb-dmov.nromes <= c-mes
                            AND cb-dmov.clfaux BEGINS (x-clfaux)
                            AND cb-dmov.codaux BEGINS (x-auxiliar)
                            AND cb-dmov.codcta BEGINS (x-cuenta)
            BREAK BY cb-dmov.codaux
                  BY cb-dmov.codcta
                  BY cb-dmov.coddoc
                  BY cb-dmov.nrodoc
                  BY cb-dmov.fchdoc :
                  
        IF FIRST-OF(cb-dmov.fchdoc) THEN DO:
           DISPLAY "Procesando: " + cb-dmov.codcta + " - " +
                                    cb-dmov.codaux + " - " +
                                    cb-dmov.coddoc + " - " +
                                    cb-dmov.nrodoc  @ x-mensaje
           WITH FRAME F-AUXILIAR.
           PAUSE 0.    
             RUN verifica.
             IF IMPRIME THEN DO:
             CASE X-CODMON :
                  WHEN 1 THEN 
                       x-importe = cb-dmov.ImpMn1.
                  WHEN 2 THEN 
                       x-importe = cb-dmov.ImpMn2.
             END CASE.
             x-glodoc = cb-dmov.glodoc.
             IF x-glodoc = "" THEN DO:
                 FIND cb-cmov WHERE cb-cmov.codcia   = cb-dmov.codcia
                                 AND cb-cmov.periodo = cb-dmov.periodo 
                                 AND cb-cmov.nromes  = cb-dmov.nromes
                                 AND cb-cmov.codope  = cb-dmov.codope
                                 AND cb-cmov.nroast  = cb-dmov.nroast
                                 NO-LOCK NO-ERROR.
                 IF AVAILABLE cb-cmov THEN
                    x-glodoc = cb-cmov.notast.
            END.
            IF x-glodoc = "" THEN DO:
                 find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codcta
                                AND cb-ctas.CodCia = cb-codcia
                                NO-LOCK NO-ERROR.                      
                 IF AVAILABLE cb-ctas THEN 
                    x-glodoc = cb-ctas.nomcta.
           END.
           CREATE T-REP.
           ASSIGN
           T-REP.fchdoc =  cb-dmov.fchdoc
           T-REP.nroast =  cb-dmov.nroast
           T-REP.coddiv =  cb-dmov.coddiv
           T-REP.cco    =  cb-dmov.cco
           T-REP.codope =  cb-dmov.codope
           T-REP.nromes =  cb-dmov.nromes
           T-REP.coddoc =  cb-dmov.coddoc
           T-REP.nrodoc =  cb-dmov.nrodoc
           T-REP.nroref =  cb-dmov.nroref
           T-REP.fchvto =  cb-dmov.fchvto
           T-REP.glodoc =  x-glodoc
           T-REP.CLFAUX =  CB-DMOV.CLFAUX
           T-REP.importe = X-IMPORTE 
           T-REP.debe    = X-DEBE
           T-REP.haber   = X-HABER
           T-REP.saldo   = X-SALDO
           T-REP.codaux  = CB-DMOV.CODAUX
           T-REP.codcta  = CB-DMOV.CODCTA.
        END. /* FIN DEL IMPRIME */       
        END.     
END.
HIDE FRAME F-AUXILIAR.
VIEW FRAME F-MENSAJE.
PAUSE 0.

END.


CASE T-Q :
     WHEN 1 THEN RUN PROCESO-1.
     WHEN 2 THEN RUN PROCESO-2.
     WHEN 3 THEN RUN PROCESO-3.
END CASE.



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
CASE T-REP.clfaux:

            WHEN "@CL" THEN DO:
                FIND gn-clie WHERE gn-clie.codcli = T-REP.codaux
                                AND gn-clie.CodCia = cl-codcia
                            NO-LOCK NO-ERROR. 
                IF AVAILABLE gn-clie THEN
                    x-nomaux = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = T-REP.codaux
                                AND gn-prov.CodCia = pv-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE gn-prov THEN 
                    x-nomaux = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = T-REP.codaux
                                AND cb-ctas.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN 
                    x-nomaux = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = T-REP.clfaux
                                AND cb-auxi.codaux = T-REP.codaux
                                AND cb-auxi.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN 
                    x-nomaux = cb-auxi.nomaux.
            END.
            END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO-1 DIALOG-1 
PROCEDURE PROCESO-1 :
FOR EACH T-REP NO-LOCK USE-INDEX IDX01
                             BREAK
                             BY CODCTA
                             BY CODAUX
                             BY FCHDOC :
   
        IF FIRST-OF (T-REP.codcta) THEN DO:
            find cb-ctas WHERE cb-ctas.codcia  = cb-codcia
                            AND cb-ctas.codcta = T-REP.codcta
                            NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN
                x-nomcta = T-REP.codcta + " " + cb-ctas.nomcta.
            {&NEW-PAGE}.
            DISPLAY STREAM report WITH FRAME f-cab.
            PUT STREAM report CONTROL P-dobleon.
            PUT STREAM report x-nomcta.
            PUT STREAM report CONTROL P-dobleoff.  
            DOWN STREAM report  WITH FRAME f-cab.
   
        END.
        
        IF FIRST-OF (T-REP.codaux) THEN DO:
            x-nomaux = "".
            RUN p-nom-aux.
            x-nomaux = T-REP.codaux + " " + x-nomaux.
            {&NEW-PAGE}.
            DISPLAY STREAM report WITH FRAME f-cab.
            PUT STREAM report CONTROL P-dobleon.
            PUT STREAM report x-nomaux.
            PUT STREAM report CONTROL P-dobleoff.
            DOWN STREAM report   WITH FRAME f-cab.
        END.
   
   
        ACCUM T-REP.DEBE  (SUB-TOTAL BY T-REP.CODCTA).
        ACCUM T-REP.HABER (SUB-TOTAL BY T-REP.CODCTA).
        ACCUM T-REP.SALDO (SUB-TOTAL BY T-REP.CODCTA).
        
        ACCUM T-REP.DEBE  (SUB-TOTAL BY T-REP.CODAUX).
        ACCUM T-REP.HABER (SUB-TOTAL BY T-REP.CODAUX).
        ACCUM T-REP.SALDO (SUB-TOTAL BY T-REP.CODAUX).

        
        ACCUM T-REP.DEBE  (TOTAL).
        ACCUM T-REP.HABER (TOTAL).
        ACCUM T-REP.SALDO (TOTAL).
        
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe    WHEN T-REP.DEBE  <> 0
        T-REP.haber   WHEN T-REP.HABER <> 0
        T-REP.saldo   WHEN T-REP.SALDO <> 0
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
   

        IF LAST-OF (T-REP.codaux) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "Total Auxiliar " + t-rep.codaux             @ t-rep.GLODOC
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.DEBE  @ T-REP.DEBE
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.HABER @ T-REP.HABER       
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report WITH FRAME f-cab.
        END.
        
        IF LAST-OF (T-REP.codCTA) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "Total Cuenta " + t-rep.codCTA             @ t-rep.GLODOC
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.DEBE  @ T-REP.DEBE
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.HABER @ T-REP.HABER       
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report 2  WITH FRAME f-cab.
        END.


END.  
        

    {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "        Total General "                     @ t-rep.GLODOC
                    ACCUM TOTAL  T-REP.DEBE  @ T-REP.DEBE
                    ACCUM TOTAL  T-REP.HABER @ T-REP.HABER       
                    ACCUM TOTAL  T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report  WITH FRAME f-cab.






END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proceso-2 DIALOG-1 
PROCEDURE proceso-2 :
FOR EACH T-REP NO-LOCK USE-INDEX IDX02
                       BREAK 
                             BY CODAUX
                             BY CODCTA 
                             BY FCHDOC :
                             
        IF FIRST-OF (T-REP.codaux) THEN DO:
            x-nomaux = "".
            RUN p-nom-aux.
            x-nomaux = T-REP.codaux + " " + x-nomaux.
            {&NEW-PAGE}.
            DISPLAY STREAM report WITH FRAME f-cab.
            PUT STREAM report CONTROL P-dobleon.
            PUT STREAM report x-nomaux.
            PUT STREAM report CONTROL P-dobleoff.
            DOWN STREAM report  WITH FRAME f-cab.
        END.
                        
        IF FIRST-OF (T-REP.codcta) THEN DO:
            find cb-ctas WHERE cb-ctas.codcia  = cb-codcia
                            AND cb-ctas.codcta = T-REP.codcta
                            NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN
                x-nomcta = T-REP.codcta + " " + cb-ctas.nomcta.
            {&NEW-PAGE}.
            DISPLAY STREAM report WITH FRAME f-cab.
            PUT STREAM report CONTROL P-dobleon.
            PUT STREAM report x-nomcta.
            PUT STREAM report CONTROL P-dobleoff.  
            DOWN STREAM report WITH FRAME f-cab.
   
        END.
        
        
        ACCUM T-REP.DEBE  (SUB-TOTAL BY T-REP.CODCTA).
        ACCUM T-REP.HABER (SUB-TOTAL BY T-REP.CODCTA).
        ACCUM T-REP.SALDO (SUB-TOTAL BY T-REP.CODCTA).
        
        ACCUM T-REP.DEBE  (SUB-TOTAL BY T-REP.CODAUX).
        ACCUM T-REP.HABER (SUB-TOTAL BY T-REP.CODAUX).
        ACCUM T-REP.SALDO (SUB-TOTAL BY T-REP.CODAUX).
        
        ACCUM T-REP.DEBE  (TOTAL).
        ACCUM T-REP.HABER (TOTAL).
        ACCUM T-REP.SALDO (TOTAL).
        
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe    WHEN T-REP.DEBE  <> 0
        T-REP.haber   WHEN T-REP.HABER <> 0
        T-REP.saldo   WHEN T-REP.SALDO <> 0
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
        
        
        IF LAST-OF (T-REP.codCTA) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "Total Cuenta " + t-rep.codCTA             @ t-rep.GLODOC
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.DEBE  @ T-REP.DEBE
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.HABER @ T-REP.HABER       
                    ACCUM SUB-TOTAL  BY T-REP.CODCTA T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report 2  WITH FRAME f-cab.
        END.

        
              IF LAST-OF (T-REP.codaux) THEN DO:
        {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "Total Auxiliar " + t-rep.codaux             @ t-rep.GLODOC
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.DEBE  @ T-REP.DEBE
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.HABER @ T-REP.HABER       
                    ACCUM SUB-TOTAL  BY T-REP.CODAUX T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report WITH FRAME f-cab.
        END.

END.  
        

    {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "        Total General "                     @ t-rep.GLODOC
                    ACCUM TOTAL  T-REP.DEBE  @ T-REP.DEBE
                    ACCUM TOTAL  T-REP.HABER @ T-REP.HABER       
                    ACCUM TOTAL  T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report  WITH FRAME f-cab.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO-3 DIALOG-1 
PROCEDURE PROCESO-3 :
DO WITH FRAME F-CAB :

            find cb-ctas WHERE cb-ctas.codcia  = cb-codcia
                            AND cb-ctas.codcta = X-CUENTA
                            NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN
                x-nomcta = X-CUENTA  + " " + cb-ctas.nomcta.
            {&NEW-PAGE}.
            DISPLAY STREAM report WITH FRAME f-cab.
            PUT STREAM report CONTROL P-dobleon.
            PUT STREAM report x-nomcta.
            PUT STREAM report CONTROL P-dobleoff.  
            DOWN STREAM report  WITH FRAME f-cab.



FOR EACH T-REP NO-LOCK USE-INDEX IDX01
                             BREAK
                             BY FCHDOC :
        ACCUM T-REP.DEBE  (TOTAL).
        ACCUM T-REP.HABER (TOTAL).
        ACCUM T-REP.SALDO (TOTAL).
        
        {&NEW-PAGE}.
        DISPLAY STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe    WHEN T-REP.DEBE  <> 0
        T-REP.haber   WHEN T-REP.HABER <> 0
        T-REP.saldo   WHEN T-REP.SALDO <> 0
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
   

END.  
        

    {&NEW-PAGE}.
        UNDERLINE STREAM REPORT     
        T-REP.fchdoc 
        T-REP.nroast 
        T-REP.coddiv 
        T-REP.cco    
        T-REP.codope 
        T-REP.nromes 
        T-REP.coddoc 
        T-REP.nrodoc 
        T-REP.nroref
        T-REP.fchvto
        T-REP.glodoc           
        T-REP.importe  
        T-REP.debe  
        T-REP.haber 
        T-REP.saldo 
        WITH FRAME F-CAB.
        DOWN STREAM REPORT WITH FRAME F-CAB.
            {&NEW-PAGE}.
            DISPLAY stream report
                    "        Total General "                     @ t-rep.GLODOC
                    ACCUM TOTAL  T-REP.DEBE  @ T-REP.DEBE
                    ACCUM TOTAL  T-REP.HABER @ T-REP.HABER       
                    ACCUM TOTAL  T-REP.SALDO @ T-REP.SALDO
                    
            with frame f-cab.
            DOWN STREAM report  WITH FRAME f-cab.


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica DIALOG-1 
PROCEDURE verifica :
x-debe  = 0.
    x-haber = 0.
    imprime = YES.
    FOR EACH detalle WHERE   detalle.codcia = cb-dmov.CodCia
                        AND detalle.periodo = cb-dmov.periodo
                        AND detalle.codaux  = cb-dmov.codaux
                        AND detalle.codcta  = cb-dmov.codcta
                        AND detalle.coddoc  = cb-dmov.coddoc
                        AND detalle.nrodoc  = cb-dmov.nrodoc
                        AND detalle.nromes <= C-MES :
                        
            IF NOT detalle.tpomov THEN DO:
                CASE x-codmon:
                WHEN 1 THEN
                    x-debe  = x-debe + detalle.ImpMn1.
                WHEN 2 THEN
                    x-debe  = x-debe + detalle.ImpMn2.
                END CASE.
            END.
            ELSE DO:      
                CASE x-codmon:
                WHEN 1 THEN
                    x-haber = x-haber + detalle.ImpMn1.
                WHEN 2 THEN
                    x-haber = x-haber + detalle.ImpMn2.
                END CASE.
            END.
    END.
    x-saldo = x-debe - x-haber.
    IF x-saldo = 0 OR x-saldo = ? THEN imprime = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


