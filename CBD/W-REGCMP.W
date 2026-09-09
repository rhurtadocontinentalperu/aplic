&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5".

DEFINE        VARIABLE P-config  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina " NO-UNDO.
DEFINE        VARIABLE c-Copias  AS INTEGER NO-UNDO.
DEFINE        VARIABLE x-Detalle LIKE Modulos.Detalle NO-UNDO.
DEFINE        VARIABLE i           AS INTEGER NO-UNDO.
DEFINE        VARIABLE j           AS INTEGER NO-UNDO.
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
IF LINE-COUNTER( report ) > (P-Largo - 10 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

/*VARIABLES PARTICULARES DE LA RUTINA */
DEFINE VARIABLE x-conreg   AS INTEGER   INITIAL 0.
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-moneda   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE x-titulo   AS CHARACTER FORMAT "X(80)" NO-UNDO 
    INIT "RESUMEN DEL MAYOR GENERAL".
DEFINE VARIABLE P-VARIOS    AS CHAR.    
DEFINE VARIABLE C-IGV       AS CHAR.
DEFINE VARIABLE x-op AS CHAR .
DEFINE VARIABLE x-codope LIKE cb-dmov.codope.
DEFINE VARIABLE y-codope LIKE cb-dmov.codope.
DEFINE VARIABLE x-Coddiv LIKE cb-dmov.coddiv.

DEFINE VARIABLE n-421    AS INTEGER.
DEFINE VARIABLE x-debe    LIKE cb-dmov.IMPMN1.
DEFINE VARIABLE x-haber   LIKE cb-dmov.IMPMN1.

DEFINE VARIABLE x-NomOpe   LIKE cb-oper.NomOpe NO-UNDO.
DEFINE VARIABLE x-NomDiv   LIKE cb-auxi.Nomaux    NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 10.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 4.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER FORMAT "X(40)".
DEFINE {&NEW} SHARED VARIABLE x-DIRCIA AS CHARACTER FORMAT "X(40)".

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

FIND cb-cfgg WHERE cb-cfgg.CODCIA = cb-codcia AND cb-cfgg.CODCFG = "R01"
    NO-LOCK NO-ERROR.
IF NOT AVAIL cb-cfgg THEN DO:
   MESSAGE "No esta configurado el registro de Compras" VIEW-AS 
   ALERT-BOX ERROR.
   RETURN.
END.    
/* Configuraciones */
C-IGV     = cb-cfgg.CODAUX[1].
P-VARIOS  = cb-cfgg.CODAUX[2].


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
                                                  
DEF VAR x-Fecha     AS DATE FORMAT "99/99/99" LABEL "F.Emision".
DEF VAR x-CodPro    LIKE cb-dmov.codaux.
DEF VAR x-NomPro    LIKE gn-prov.nompro FORMAT "X(40)".
DEF VAR x-ruc       LIKE cb-dmov.nroruc.
DEF VAR x-CodDoc    LIKE cb-dmov.coddoc.
DEF VAR x-NroDoc    LIKE cb-dmov.nrodoc format "xxx-xxxxxxx".
DEF VAR x-NroAst    LIKE cb-dmov.nroast.
DEF VAR x-glodoc    LIKE cb-dmov.glodoc.
DEF VAR x-SimMon    AS CHAR FORMAT "XXX" LABEL "Mon" INIT "S/.".
DEF VAR x-Afecta    LIKE cb-dmov.impmn1.
DEF VAR x-NoAfecta  LIKE cb-dmov.impmn1.
DEF VAR x-Igv       LIKE cb-dmov.impmn1.
DEF VAR l-Igv       AS LOGICAL.
DEF VAR x-Impuestos LIKE cb-dmov.impmn1.
DEF VAR x-Totalc    LIKE cb-dmov.impmn1.
DEF VAR x-dolares   LIKE cb-dmov.impmn1.
DEF VAR x-as        AS CHAR FORMAT "X" INIT " ".
DEF VAR x-ct        AS CHAR FORMAT "X" INIT " ".
DEF VAR x-cuentas   LIKE cb-dmov.glodoc FORMAT "X(25)".

DEF VAR     t-igv         AS DECIMAL.
DEF VAR     t-impuestos   AS DECIMAL.
DEF VAR     t-afecta      AS DECIMAL.
DEF VAR     t-noafecta    AS DECIMAL.
DEF VAR     t-totalc      AS DECIMAL.

 DEFINE FRAME f-cab
        x-codope   COLUMN-LABEL "Ope"
        x-nroast   COLUMN-LABEL "Nro.!Regis."
        x-coddiv   LABEL "Cod!Div"
        x-Fecha    
        x-codpro   COLUMN-LABEL "Cod.!Aux."
        x-nompro   COLUMN-LABEL "Razon Social del Proveedor"
        x-ruc      COLUMN-LABEL " R.U.C."
        x-CodDoc   COLUMN-LABEL "Tipo!Doc."
        x-nrodoc   COLUMN-LABEL "Nro.!Documento"
        x-glodoc   COLUMN-LABEL "C o n c e p t o"
        x-SimMon
        x-Afecta   COLUMN-LABEL "Monto!Afecta    "
        x-NoAfecta COLUMN-LABEL "Imponible      !No Afecta   "
        x-IGV      COLUMN-LABEL "I m p u e!I.G.V.    "
        x-Impuestos COLUMN-LABEL "s t o s        !Otros      "
        x-Totalc   COLUMN-LABEL "Importe    !Total     "
        x-dolares  COLUMN-LABEL "Importe!Total US$" 
        x-cuentas  COLUMN-LABEL "Cuentas" 
        x-as       NO-LABEL
        x-ct       NO-LABEL
        HEADER
        empresas.nomcia
        "FECHA : " TO 236 TODAY TO 245  
        SKIP
        empresas.direccion
        "PAGINA :" TO 236 c-pagina FORMAT "ZZ9" to  253  
        SKIP
        x-titulo   FORMAT "X(255)"   
        SKIP    
        pinta-mes  FORMAT "X(255)"
        SKIP
        x-expres   FORMAT "X(255)"
        SKIP(3)
        WITH WIDTH 282 NO-BOX DOWN STREAM-IO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-10 RECT-5 RADIO-SET-1 RECT-6 ~
x-codmon B-impresoras B-imprime RECT-12 x-Div s-op B-cancela T-Div resumen ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 x-codmon x-Div s-op T-Div ~
resumen RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE x-Div AS CHARACTER FORMAT "X(5)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1
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
     SIZE 10 BY 1.77 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 15 BY 2.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 4.85.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 5.81.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 2.

DEFINE VARIABLE s-op AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 10 BY 2.96
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE resumen AS LOGICAL INITIAL no 
     LABEL "Resumen" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .77 NO-UNDO.

DEFINE VARIABLE T-Div AS LOGICAL INITIAL no 
     LABEL "General" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     RADIO-SET-1 AT ROW 8 COL 2 NO-LABEL
     x-codmon AT ROW 2.35 COL 6 NO-LABEL
     B-impresoras AT ROW 9 COL 15
     b-archivo AT ROW 10 COL 15
     B-imprime AT ROW 12 COL 18
     RB-OUTPUT-FILE AT ROW 10.27 COL 19 COLON-ALIGNED NO-LABEL
     x-Div AT ROW 2.08 COL 39 COLON-ALIGNED
     s-op AT ROW 3.15 COL 41 NO-LABEL
     B-cancela AT ROW 12 COL 48
     T-Div AT ROW 1.81 COL 58
     resumen AT ROW 2.62 COL 58.14
     RB-NUMBER-COPIES AT ROW 8 COL 64 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9 COL 64 COLON-ALIGNED
     RB-END-PAGE AT ROW 10 COL 64 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .38 AT ROW 1.54 COL 3
     RECT-10 AT ROW 2.08 COL 3
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 74 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 7.5 COL 1
     RECT-6 AT ROW 11.5 COL 1
     RECT-12 AT ROW 1.54 COL 27
     "Operaciones:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 3.15 COL 28
     SPACE(35.00) SKIP(9.73)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Registro de Compras".

 

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
   Default                                                              */
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
ON GO OF FRAME DIALOG-1 /* Registro de Compras */
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
      ASSIGN T-DIV resumen.
      x-op = ENTRY(1, s-op:SCREEN-VALUE).
      DO i = 2 TO NUM-ENTRIES(s-op:SCREEN-VALUE) :
           x-op = x-op + "," +
           ENTRY(i, s-op:SCREEN-VALUE).
      END.
      IF x-op = ? OR x-op = "" THEN DO:
         Message "NO se ha seleccionado ninguna operaci¢n" 
            VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.   
      END.
      ASSIGN
               x-codmon
               x-div
               s-op.
        IF x-div <> "" AND
             NOT CAN-FIND(FIRST GN-DIVI WHERE  GN-DIVI.codcia = S-codcia 
                                          AND  GN-DIVI.CODDIV = x-div)
                                        
        THEN DO:
            BELL.
            MESSAGE "Divisi¢n no registrada"
                    VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO x-div.
            RETURN NO-APPLY.
        END.
        
   
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).

    IF x-codmon = 1 THEN DO:
        x-moneda = "NUEVOS SOLES".
        x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    END.
    ELSE DO:
        x-moneda = "DOLARES".
        x-expres = "(EXPRESADO EN DOLARES)".
    END.
    P-Ancho  = FRAME f-cab:WIDTH - 30 .        
    RUN bin/_centrar.p ( INPUT pinta-mes, P-ancho  , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-moneda,  P-ancho  , OUTPUT x-moneda ).
    RUN bin/_centrar.p ( INPUT x-expres,  P-ancho   , OUTPUT x-expres ).
    x-titulo = "R E G I S T R O   D E   C O M P R A S".
    RUN bin/_centrar.p ( INPUT x-titulo,  P-ancho  , OUTPUT x-titulo ).
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
ON F8 OF x-Div IN FRAME DIALOG-1 /* Divisi¢n */
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

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  PTO                  = SESSION:SET-WAIT-STATE("").    
  l-immediate-display  = SESSION:IMMEDIATE-DISPLAY.
  s-op:LIST-ITEMS IN FRAME {&FRAME-NAME} = cb-cfgg.codope.
  s-op:SCREEN-VALUE = ENTRY( 1 , cb-cfgg.codope ).
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
  DISPLAY RADIO-SET-1 x-codmon x-Div s-op T-Div resumen RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-10 RECT-5 RADIO-SET-1 RECT-6 x-codmon B-impresoras 
         B-imprime RECT-12 x-Div s-op B-cancela T-Div resumen RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIME1 DIALOG-1 
PROCEDURE IMPRIME1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME F-CAB :
    t-igv          = 0 .
    t-impuestos    = 0 .
    t-afecta       = 0 .
    t-noafecta     = 0 .
    t-totalc       = 0 . 

    DO i = 1 TO NUM-ENTRIES(x-op) :
       y-codope = ENTRY(i, x-op).
       IF CAN-FIND(FIRST cb-dmov WHERE cb-dmov.codcia  = s-codcia AND
                                 cb-dmov.periodo = s-periodo    AND
                                 cb-dmov.nromes  = s-NroMes    AND
                                 cb-dmov.codope  = y-codope) 
                                
       THEN DO:                          
         FOR EACH cb-dmov  NO-LOCK WHERE cb-dmov.codcia  = s-codcia    AND
                                         cb-dmov.periodo = s-periodo       AND
                                         cb-dmov.nromes  = s-NroMes       AND
                                         cb-dmov.codope  = y-codope    AND
                                         cb-dmov.coddiv  BEGINS (x-div) AND
                                         cb-dmov.tpoitm <> "A"
                                         BREAK BY cb-dmov.nroast :
              
              IF FIRST-OF(cb-dmov.NROAST) THEN DO:
                n-421 = 0.                   
                x-codope = cb-dmov.codope.
                x-nroast = cb-dmov.nroast.
                x-glodoc = "".
                x-totalc = 0.
                x-igv    = 0.
                x-coddoc = "".
                x-nrodoc = "".
                x-ruc    = "".
                x-Fecha  = ? .
                x-CodPro = "".
                x-NomPro = "".
                x-Afecta    = 0.
                x-NoAfecta  = 0.
                x-Impuestos = 0.
                x-Totalc    = 0.
                x-as        = "".
                x-ct        = "".
                x-cuentas   = "".
                x-dolares   = 0.
                FIND cb-cmov WHERE cb-cmov.CODCIA  = cb-dmov.CODCIA  AND
                                   cb-cmov.PERIODO = cb-dmov.PERIODO AND
                                   cb-cmov.CODOPE  = cb-dmov.CODOPE  AND
                                   cb-cmov.NROMES  = cb-dmov.NROMES  AND
                                   cb-cmov.NROAST  = cb-dmov.NROAST  
                                   NO-LOCK NO-ERROR.
                 IF AVAIL cb-cmov THEN DO:
                               X-GLODOC = cb-cmov.NOTAST.                  
                               X-FECHA  = cb-cmov.FCHAST.
                 END.              
              END. /* FIN DEL FIRS-OF cb-cmov */
              
              /*DETERMINACION DEL IMPORTE */
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
            x-coddiv = cb-dmov.coddiv.  
              /*TOTAL DE LA FACTURA */ 
            IF cb-dmov.codcta BEGINS "421" 
              THEN DO:
                    n-421 = n-421 + 1.
                    IF n-421 = 1 THEN DO :
                       x-codpro = cb-dmov.codaux.
                       x-ruc    = cb-dmov.nroruc.
                      IF LOOKUP(x-codpro,P-VARIOS) > 0 THEN DO:
                         x-nompro = cb-dmov.glodoc.
                       END.
                       ELSE DO:
                            FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                     AND gn-prov.CodCia = pv-codcia
                                     NO-LOCK NO-ERROR.                      
                             IF AVAILABLE gn-prov THEN DO:
                                x-nompro = gn-prov.nompro.
                                if x-ruc = "" then x-ruc  = gn-prov.ruc.
                             END.
                       END.      
                       x-coddoc    = cb-dmov.coddoc.
                       x-nrodoc    = cb-dmov.nrodoc.
                       IF cb-dmov.fchdoc <> ? THEN x-fecha = cb-dmov.fchdoc.
                       IF x-glodoc = "" AND  x-nompro <> cb-dmov.glodoc THEN 
                          x-glodoc = cb-dmov.glodoc.
                       END. /* FIN DEL n-421*/     
                       X-SimMon = IF cb-dmov.CODMON = 1 THEN "S/." ELSE "US$".     
                  if x-codmon = 1 AND cb-dmov.codmon = 2 THEN DO:
                     if cb-dmov.tpomov THEN x-dolares = x-dolares + cb-dmov.impmn2.
                                       ELSE x-dolares = x-dolares - cb-dmov.impmn2.
                  END.               
                  find cb-ctas WHERE cb-ctas.CODCTA = cb-dmov.CODCTA 
                    NO-LOCK NO-ERROR.
                  IF NOT avail cb-ctas THEN X-CT = "".
                  ELSE DO:
                      IF cb-dmov.CODMON = 1 AND cb-ctas.CODMON = 2 THEN X-CT = ":".
                      IF cb-dmov.CODMON = 2 AND cb-ctas.CODMON = 1 THEN X-CT = ":".
                  END.    
                  x-totalc = x-totalc + x-haber - x-debe.    
               END. 
               ELSE
                  IF cb-dmov.CODCTA BEGINS "40"  THEN DO:
                    l-igv = FALSE.
                    /*SI ES CUENTA DE IGV*/
                      IF LOOKUP(cb-dmov.CODCTA,C-IGV) > 0 THEN DO:
                         x-igv = x-igv + x-debe - x-haber.      
                      END.
                      ELSE x-impuestos = x-impuestos + x-debe - x-haber.                 
                  END. /*FIN DEL CODCTA BEGINS "40" */                      
                  ELSE DO: /*DETERMINACION DE LOS MONTOS AFECTOS-INAFECTOS */
                       x-cuentas = x-cuentas + cb-dmov.codcta + ",".                   
                       CASE cb-dmov.TM :
                          WHEN 1 THEN x-afecta   = x-afecta   + x-debe - x-haber.
                          WHEN 2 THEN x-noafecta = x-noafecta + x-debe - x-haber.
                       END CASE.
                  END. /*FIN DE LOS MONTOS AFECTOS INAFECTOS */                   
         IF LAST-OF(cb-dmov.NROAST)   THEN DO:
            t-igv        = t-igv       +  x-igv.
            t-impuestos  = t-impuestos + x-impuestos.
            t-afecta     = t-afecta    + x-afecta.
            t-noafecta   = t-noafecta  + x-noafecta.
            t-totalc     = t-totalc    + x-totalc. 
            IF ABS(x-totalc - x-igv - x-impuestos - x-afecta - x-noafecta) >= 0.01 THEN x-as = ".".
            IF LENGTH(x-cuentas) > 1  THEN DO:
               j = LENGTH(x-cuentas) - 1 .
               x-cuentas = SUBSTRING(x-cuentas, 1 , j ).
            END.    
            IF  (NOT RESUMEN) THEN DO:
            {&NEW-PAGE}.    
            DISPLAY STREAM report
                    x-coddiv
                    x-Fecha    
                    x-codpro FORMAT "X(8)"
                    x-nompro   
                    x-ruc 
                    x-CodDoc 
                    x-nrodoc   
                    x-codope 
                    x-nroast  
                    x-glodoc  
                    x-simmon
                    x-Afecta    when x-afecta     <> 0
                    x-NoAfecta  when x-noafecta   <> 0
                    x-IGV       when x-igv        <> 0
                    x-Impuestos when x-impuestos  <> 0
                    x-Totalc    when x-totalc     <> 0
                    x-dolares   when x-dolares    <> 0
                    x-cuentas 
                    x-as     
                    x-ct
                    WITH FRAME F-CAB.
                    
            DOWN STREAM REPORT WITH FRAME F-CAB.   
            END.
         END.
                                  
         END. /*FIN DEL FOR EACH */                        
         
       END. /* FIN DE IF CAN-FIND */
                    
              
       
 END. /*FIN DEL DO i= 1 to */
       {&NEW-PAGE}.    
       UNDERLINE STREAM report
                    x-coddiv
                    x-Fecha    
                    x-codpro  
                    x-nompro   
                    x-ruc 
                    x-CodDoc 
                    x-nrodoc   
                    x-codope 
                    x-nroast  
                    x-glodoc  
                    x-Afecta    
                    x-NoAfecta  
                    x-IGV       
                    x-Impuestos 
                    x-Totalc    
                    x-cuentas 
                    WITH FRAME F-CAB.
      DOWN STREAM REPORT WITH FRAME f-cab.              
      x-glodoc     = "***   T O T A L E S   ***".
      x-Afecta     = t-afecta.   
      x-NoAfecta   = t-noafecta.
      x-IGV        = t-igv.
      x-impuestos  = t-Impuestos. 
      x-Totalc     = t-Totalc.    
      {&NEW-PAGE}.    
      DISPLAY STREAM report
                    x-glodoc  
                    x-Afecta    when x-afecta     <> 0
                    x-NoAfecta  when x-noafecta   <> 0
                    x-IGV       when x-igv        <> 0
                    x-Impuestos when x-impuestos  <> 0
                    x-Totalc    when x-totalc     <> 0
                    WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.   
END. /* FIN DEL WITH FRAME f-cab */         

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
    
    P-largo  = 88. /* En el caso de 88 lineas por p gina usando 8 lpi ( P-8lpi )
                      hay que definir en el triger "CHOOSE" de b-imprime en 66 
                      L¡neas por p gina y aqui en 88.
                      Si se usa 6 lpi ( Default ) solo basta definir en
                      b-imprime.
                      ** OJO ** en b-imprime el P-largo configura a la impresora
                      a saltar en ese largo por p gina
                      */
                       
    P-Config = P-20cpi + P-8lpi.
IF T-DIV THEN DO:
  RUN IMPRIME1.
  RETURN.
END.    

DO WITH FRAME F-CAB :
    t-igv          = 0 .
    t-impuestos    = 0 .
    t-afecta       = 0 .
    t-noafecta     = 0 .
    t-totalc       = 0 . 

    DO i = 1 TO NUM-ENTRIES(x-op) :
       y-codope = ENTRY(i, x-op).
       IF CAN-FIND(FIRST cb-dmov WHERE cb-dmov.codcia  = s-codcia AND
                                 cb-dmov.periodo = s-periodo    AND
                                 cb-dmov.nromes  = s-NroMes    AND
                                 cb-dmov.codope  = y-codope) 
                                
       THEN DO:                          
         FOR EACH cb-dmov  NO-LOCK WHERE cb-dmov.codcia  = s-codcia    AND
                                         cb-dmov.periodo = s-periodo       AND
                                         cb-dmov.nromes  = s-NroMes       AND
                                         cb-dmov.codope  = y-codope    AND
                                         cb-dmov.coddiv  BEGINS (x-div) AND
                                         cb-dmov.tpoitm <> "A"
                                         BREAK BY cb-dmov.coddiv
                                               BY cb-dmov.nroast :
              IF FIRST-OF(cb-dmov.CODDIV) AND (NOT RESUMEN) THEN DO:
                 x-coddiv  = cb-dmov.coddiv.
                 x-nompro  = "D I V I S I O N".
                 
                 FIND GN-DIVI WHERE  GN-DIVI.CODCIA = S-codcia AND
                                     GN-DIVI.CODDIV = x-coddiv
                                     NO-LOCK NO-ERROR.
                 IF AVAIL GN-DIVI THEN  DO:
                    x-glodoc = GN-DIVI.DESDIV.
                    x-nomdiv = GN-DIVI.DESDIV.
                 END.   
                 {&NEW-PAGE}.    
                  DISPLAY STREAM report
                    x-coddiv
                    x-nompro   
                    x-glodoc  WITH FRAME F-CAB.
                 DOWN STREAM report WITH FRAME F-CAB.
                 UNDERLINE STREAM report
                    x-coddiv
                    x-nompro   
                    x-glodoc  
                 WITH FRAME F-CAB.
                 DOWN STREAM REPORT WITH FRAME f-cab.              
                                     
              END. /*FIN DEL FIRST-OF(cb-dmov.CODDIV) */                                 
              
              IF FIRST-OF(cb-dmov.NROAST) THEN DO:
                n-421 = 0.                   
                x-codope = cb-dmov.codope.
                x-nroast = cb-dmov.nroast.
                x-glodoc = "".
                x-totalc = 0.
                x-igv    = 0.
                x-coddoc = "".
                x-nrodoc = "".
                x-ruc    = "".
                x-Fecha  = ? .
                x-CodPro = "".
                x-NomPro = "".
                x-Afecta    = 0.
                x-NoAfecta  = 0.
                x-Impuestos = 0.
                x-Totalc    = 0.
                x-as        = "".
                x-ct        = "".
                x-cuentas   = "".
                x-dolares   = 0.
                FIND cb-cmov WHERE cb-cmov.CODCIA  = cb-dmov.CODCIA  AND
                                   cb-cmov.PERIODO = cb-dmov.PERIODO AND
                                   cb-cmov.CODOPE  = cb-dmov.CODOPE  AND
                                   cb-cmov.NROMES  = cb-dmov.NROMES  AND
                                   cb-cmov.NROAST  = cb-dmov.NROAST  
                                   NO-LOCK NO-ERROR.
                 IF AVAIL cb-cmov THEN DO:
                               X-GLODOC = cb-cmov.NOTAST.                  
                               X-FECHA  = cb-cmov.FCHAST.
                 END.              
              END. /* FIN DEL FIRS-OF cb-cmov */
              
              /*DETERMINACION DEL IMPORTE */
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
            x-coddiv = cb-dmov.coddiv.  
              /*TOTAL DE LA FACTURA */ 
            IF cb-dmov.codcta BEGINS "421" 
              THEN DO:
                    n-421 = n-421 + 1.
                    IF n-421 = 1 THEN DO :
                       x-codpro = cb-dmov.codaux.
                       x-ruc    = cb-dmov.nroruc.
                       IF LOOKUP(x-codpro,P-VARIOS) > 0 THEN DO:
                         x-nompro = cb-dmov.glodoc.
                       END.
                       ELSE DO:
                            FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                     AND gn-prov.CodCia = pv-codcia
                                     NO-LOCK NO-ERROR.                      
                             IF AVAILABLE gn-prov THEN DO:
                                x-nompro = gn-prov.nompro.
                                if x-ruc = "" then x-ruc  = gn-prov.ruc.
                             END.
                       END.      
                       x-coddoc    = cb-dmov.coddoc.
                       x-nrodoc    = cb-dmov.nrodoc.
                       IF cb-dmov.fchdoc <> ? THEN x-fecha = cb-dmov.fchdoc.
                       IF x-glodoc = "" AND  x-nompro <> cb-dmov.glodoc THEN 
                          x-glodoc = cb-dmov.glodoc.
                       END. /* FIN DEL n-421*/     
                       X-SimMon = IF cb-dmov.CODMON = 1 THEN "S/." ELSE "US$".     
                  if x-codmon = 1 AND cb-dmov.codmon = 2 THEN DO:
                     if cb-dmov.tpomov THEN x-dolares = x-dolares + cb-dmov.impmn2.
                                       ELSE x-dolares = x-dolares - cb-dmov.impmn2.
                  END.               
                  find cb-ctas WHERE cb-ctas.CODCTA = cb-dmov.CODCTA 
                    NO-LOCK NO-ERROR.
                  IF NOT avail cb-ctas THEN X-CT = "".
                  ELSE DO:
                      IF cb-dmov.CODMON = 1 AND cb-ctas.CODMON = 2 THEN X-CT = ":".
                      IF cb-dmov.CODMON = 2 AND cb-ctas.CODMON = 1 THEN X-CT = ":".
                  END.    
                  x-totalc = x-totalc + x-haber - x-debe.    
               END. 
               ELSE
                  IF cb-dmov.CODCTA BEGINS "40"  THEN DO:
                    l-igv = FALSE.
                    /*SI ES CUENTA DE IGV*/
                      IF LOOKUP(cb-dmov.CODCTA,C-IGV) > 0 THEN DO:
                         x-igv = x-igv + x-debe - x-haber.      
                      END.
                      ELSE x-impuestos = x-impuestos + x-debe - x-haber.                 
                  END. /*FIN DEL CODCTA BEGINS "40" */                      
                  ELSE DO: /*DETERMINACION DE LOS MONTOS AFECTOS-INAFECTOS */
                       x-cuentas = x-cuentas + cb-dmov.codcta + ",".                   
                       CASE cb-dmov.TM :
                          WHEN 1 THEN x-afecta   = x-afecta   + x-debe - x-haber.
                          WHEN 2 THEN x-noafecta = x-noafecta + x-debe - x-haber.
                       END CASE.
                  END. /*FIN DE LOS MONTOS AFECTOS INAFECTOS */     
                  
         IF LAST-OF(cb-dmov.NROAST)  THEN DO:
            t-igv        = t-igv       +  x-igv.
            t-impuestos  = t-impuestos + x-impuestos.
            t-afecta     = t-afecta    + x-afecta.
            t-noafecta   = t-noafecta  + x-noafecta.
            t-totalc     = t-totalc    + x-totalc. 
            ACCUMULATE   x-igv       (SUB-TOTAL BY cb-dmov.CODDIV).
            ACCUMULATE   x-impuestos (SUB-TOTAL BY cb-dmov.CODDIV).
            ACCUMULATE   x-afecta    (SUB-TOTAL BY cb-dmov.CODDIV).
            ACCUMULATE   x-noafecta  (SUB-TOTAL BY cb-dmov.CODDIV).
            ACCUMULATE   x-totalc    (SUB-TOTAL BY cb-dmov.CODDIV).
            IF ABS(x-totalc - x-igv - x-impuestos - x-afecta - x-noafecta) >= 0.01 THEN x-as = ".".
            IF LENGTH(x-cuentas) > 1  THEN DO:
               j = LENGTH(x-cuentas) - 1 .
               x-cuentas = SUBSTRING(x-cuentas, 1 , j ).
            END.  
            IF  (NOT RESUMEN) THEN DO:  
            {&NEW-PAGE}.    
            DISPLAY STREAM report
                    x-coddiv
                    x-Fecha    
                    x-codpro FORMAT "X(8)"
                    x-nompro   
                    x-ruc 
                    x-CodDoc 
                    x-nrodoc   
                    x-codope 
                    x-nroast  
                    x-glodoc  
                    x-simmon
                    x-Afecta    when x-afecta     <> 0
                    x-NoAfecta  when x-noafecta   <> 0
                    x-IGV       when x-igv        <> 0
                    x-Impuestos when x-impuestos  <> 0
                    x-Totalc    when x-totalc     <> 0
                    x-dolares   when x-dolares    <> 0
                    x-cuentas 
                    x-as     
                    x-ct
                    WITH FRAME F-CAB.
                    
            DOWN STREAM REPORT WITH FRAME F-CAB.   
            END.
         END.
         IF LAST-OF(cb-dmov.CODDIV) THEN DO:
            {&NEW-PAGE}.
            x-nompro     = "T O T A L   D I V I S I O N ".
            x-glodoc     = x-nomdiv.
            x-afecta     = ACCUM SUB-TOTAL BY cb-dmov.CODDIV x-afecta.
            x-noafecta   = ACCUM SUB-TOTAL BY cb-dmov.CODDIV x-noafecta.
            x-igv        = ACCUM SUB-TOTAL BY cb-dmov.CODDIV x-igv.
            x-impuestos  = ACCUM SUB-TOTAL BY cb-dmov.CODDIV x-impuestos.
            x-totalc     = ACCUM SUB-TOTAL BY cb-dmov.CODDIV x-totalc.
             UNDERLINE STREAM report
                    x-coddiv
                    x-nompro   
                    x-glodoc  
                    x-afecta
                    x-noafecta
                    x-igv
                    x-impuestos
                    x-totalc
                 WITH FRAME F-CAB.
                 DOWN STREAM REPORT WITH FRAME f-cab.              
             DISPLAY STREAM  report
                    x-coddiv
                    x-nompro   
                    x-glodoc  
                    x-afecta
                    x-noafecta
                    x-igv
                    x-impuestos
                    x-totalc
                 WITH FRAME F-CAB.
                 DOWN STREAM REPORT 2 WITH FRAME f-cab.              
               
         END. /*FIN DEL LAST-OF(cb-dmov.CODDIV) */
                                  
         END. /*FIN DEL FOR EACH */                        
         
       END. /* FIN DE IF CAN-FIND */
                    
              
       
 END. /*FIN DEL DO i= 1 to */
       {&NEW-PAGE}.    
       UNDERLINE STREAM report
                    x-coddiv
                    x-Fecha    
                    x-codpro  
                    x-nompro   
                    x-ruc 
                    x-CodDoc 
                    x-nrodoc   
                    x-codope 
                    x-nroast  
                    x-glodoc  
                    x-Afecta    
                    x-NoAfecta  
                    x-IGV       
                    x-Impuestos 
                    x-Totalc    
                    x-cuentas 
                    WITH FRAME F-CAB.
      DOWN STREAM REPORT WITH FRAME f-cab.              
      x-glodoc     = "***   T O T A L E S   ***".
      x-Afecta     = t-afecta.   
      x-NoAfecta   = t-noafecta.
      x-IGV        = t-igv.
      x-impuestos  = t-Impuestos. 
      x-Totalc     = t-Totalc.    
      {&NEW-PAGE}.    
      DISPLAY STREAM report
                    x-glodoc  
                    x-Afecta    when x-afecta     <> 0
                    x-NoAfecta  when x-noafecta   <> 0
                    x-IGV       when x-igv        <> 0
                    x-Impuestos when x-impuestos  <> 0
                    x-Totalc    when x-totalc     <> 0
                    WITH FRAME F-CAB.
            DOWN STREAM REPORT WITH FRAME F-CAB.   
END. /* FIN DEL WITH FRAME f-cab */         

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
    UNDERLINE STREAM report x-glodoc x-afecta x-noafecta
                            x-igv x-impuestos x-totalc
    WITH FRAME F-CAB.
    DOWN STREAM REPORT WITH FRAME F-CAB.                        
    DISPLAY STREAM report
                    "......Van...." @ x-glodoc  
                    t-afecta        WHEN t-afecta    <> 0  @ x-Afecta    
                    t-NoAfecta      WHEN t-noafecta  <> 0  @ x-noafecta  
                    t-IGV           WHEN t-igv       <> 0  @ x-igv       
                    t-Impuestos     WHEN t-impuestos <> 0 @ x-impuestos 
                    t-Totalc        WHEN t-Totalc    <> 0 @ x-Totalc    
                    WITH FRAME F-CAB.
    DOWN STREAM REPORT WITH FRAME F-CAB.   
    c-Pagina = c-Pagina + 1.
    IF c-Pagina > P-pagfin
    THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.

    DISPLAY STREAM report
                    "......Vienen...." @ x-glodoc  
                    t-afecta        WHEN t-afecta    <> 0  @ x-Afecta    
                    t-NoAfecta      WHEN t-noafecta  <> 0  @ x-noafecta  
                    t-IGV           WHEN t-igv       <> 0  @ x-igv       
                    t-Impuestos     WHEN t-impuestos <> 0 @ x-impuestos 
                    t-Totalc        WHEN t-Totalc    <> 0 @ x-Totalc    
                     WITH FRAME F-CAB.
     DOWN STREAM REPORT WITH FRAME F-CAB.                                         
     UNDERLINE STREAM report x-glodoc x-afecta x-noafecta
                            x-igv x-impuestos x-totalc
     WITH FRAME F-CAB.
    DOWN STREAM REPORT WITH FRAME F-CAB.                                         
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


