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
DEFINE {&NEW} SHARED VARIABLE cb-niveles  AS CHARACTER INITIAL "2,3,5".
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
DEFINE VARIABLE x-clfaux   AS CHARACTER FORMAT "X(3)".
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
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 11.
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

 DEFINE FRAME f-cab
        cb-dmov.fchdoc COLUMN-LABEL " Fecha!  Doc."
        cb-dmov.coddiv COLUMN-LABEL "Div"
        cb-dmov.cco    COLUMN-LABEL "C.Cos"
        cb-dmov.nroast COLUMN-LABEL "Compro!bante"
        cb-dmov.codope COLUMN-LABEL "Li-!bro"
        cb-dmov.nromes LABEL        "Mes"
        cb-dmov.coddoc COLUMN-LABEL "C¢digo! Doc."  
        cb-dmov.nrodoc COLUMN-LABEL "  Nro.!Documento"
        cb-dmov.nroref
        cb-dmov.fchvto COLUMN-LABEL " Fecha!  Vto."
        cb-dmov.glodoc FORMAT "X(50)"          
        x-importe  
        x-debe
        x-haber  
        x-saldo
        HEADER
        S-NOMCIA                                     
        "C U E N T A S   P E N D I E N T E S  P O R  C U E N T A" AT 71
        "FECHA : " TO 170 TODAY TO 180
        SKIP
      /*  
        empresas.direccion
      */  
        pinta-mes AT 75
        "PAGINA :" TO 170 c-pagina FORMAT "ZZ9" TO 180
        SKIP
        x-expres  AT 75
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
&Scoped-Define ENABLED-OBJECTS RECT-4 x-div RECT-11 x-codmon x-codcta ~
x-auxiliar RECT-5 RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE ~
RB-END-PAGE RECT-6 B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS x-div x-codmon x-codcta x-auxiliar ~
RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-codcta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-div AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisi¢n" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 16 BY 3.

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
     x-div AT ROW 1.81 COL 41 COLON-ALIGNED
     x-codmon AT ROW 3.5 COL 7 NO-LABEL
     x-codcta AT ROW 3.15 COL 41 COLON-ALIGNED
     x-auxiliar AT ROW 4.5 COL 41 COLON-ALIGNED
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
          SIZE 8 BY .62 AT ROW 2 COL 4
     RECT-11 AT ROW 3 COL 4
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 74 BY .62 AT ROW 6.81 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 7.5 COL 1
     RECT-6 AT ROW 11.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Cuentas Pendientes  por Cuenta".

 

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
ON GO OF FRAME DIALOG-1 /* Cuentas Pendientes  por Cuenta */
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
    ASSIGN x-codmon 
           x-auxiliar
           x-codcta.
   find cb-ctas WHERE cb-ctas.codcia = cb-codcia and
                      cb-ctas.codcta = x-codcta 
                      NO-LOCK NO-ERROR.
                      
   IF NOT avail cb-ctas THEN                      
       DO: 
            BELL.
            MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
   ELSE
           x-clfAux = cb-ctas.clfaux.
            
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
ON F8 OF x-codcta IN FRAME DIALOG-1 /* Cuenta */
OR "MOUSE-SELECT-DBLCLICK":U OF X-CODCTA DO:
    DEF VAR RECID-stack AS RECID.
    RUN cbd/q-ctas2.w(cb-codcia,SELF:SCREEN-VALUE, OUTPUT RECID-stack).
    IF RECID-stack <> 0
    THEN DO:
        find cb-ctas WHERE RECID(cb-ctas) = RECID-stack NO-LOCK NO-ERROR.
        IF avail cb-ctas
        THEN DO:
            SELF:SCREEN-VALUE = cb-ctas.CodCta.
         
    
        END.
        ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR
            BUTTONS OK.
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
  DISPLAY x-div x-codmon x-codcta x-auxiliar RADIO-SET-1 RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 x-div RECT-11 x-codmon x-codcta x-auxiliar RECT-5 RADIO-SET-1 
         RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE RECT-6 
         B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
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
    p-config = p-20cpi.
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    x-Raya   = FILL("-", P-Ancho).
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".
    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-nomclf,  50 , OUTPUT x-nomclf ).
 
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                            AND cb-dmov.periodo = s-periodo 
                            AND cb-dmov.nromes <= s-NroMes
                            AND cb-dmov.CodDiv BEGINS (x-div)
                            AND cb-dmov.codcta BEGINS (x-codcta)
                            AND cb-dmov.codaux BEGINS (x-auxiliar)
                 
            BREAK
                  BY cb-dmov.codcta
                  BY cb-dmov.codaux
                  BY cb-dmov.coddoc
                  BY cb-dmov.nrodoc
                  BY cb-dmov.nromes ON ERROR UNDO, LEAVE:
        IF FIRST-OF (cb-dmov.codaux) THEN DO:
            x-nomaux = "".
            RUN p-nom-aux.
            x-nomaux = cb-dmov.codaux + " " + x-nomaux.
            imp-aux  = YES.
        END.
        IF FIRST-OF (cb-dmov.codcta) THEN DO:
            find cb-ctas WHERE cb-ctas.codcia = cb-codcia
                            AND cb-ctas.codcta = cb-dmov.codcta
                            NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN
                x-nomcta = cb-dmov.codcta + " " + cb-ctas.nomcta.
            imp-cta = YES.
        END.
        IF FIRST-OF(cb-dmov.nrodoc) THEN RUN verifica.
        x-glodoc = cb-dmov.glodoc.
        /* Buscando la cabezera correspondiente */
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
        IF cb-dmov.codmon = x-codmon THEN 
            x-importe = 0.
        ELSE DO:
            CASE cb-dmov.codmon:
            WHEN 1 THEN 
                x-importe = cb-dmov.ImpMn1.
            WHEN 2 THEN 
                x-importe = cb-dmov.ImpMn2.
            WHEN 3 THEN 
                x-importe = cb-dmov.ImpMn3.
            END CASE.
        END.
         IF NOT (x-haber = 0 AND x-debe = 0) AND x-haber <> ? AND x-debe <> ?
            AND imprime THEN DO:
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.nrodoc).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.nrodoc).
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.codcta).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.codcta).
            ACCUMULATE x-debe  (SUB-TOTAL BY cb-dmov.codaux).
            ACCUMULATE x-haber (SUB-TOTAL BY cb-dmov.codaux).
            IF imp-cta THEN DO:
                {&NEW-PAGE}.
                DISPLAY STREAM report WITH FRAME f-cab.
                PUT STREAM report CONTROL P-dobleon.
                PUT STREAM report x-nomcta.
                PUT STREAM report CONTROL P-dobleoff.
                DOWN STREAM report WITH FRAME f-cab.
                imp-cta = NO.
            END.
            IF imp-aux THEN DO:
                {&NEW-PAGE}.            
                              
                DISPLAY STREAM report "AUXILIAR" @ cb-dmov.fchvto
                        x-nomaux @ cb-dmov.glodoc WITH FRAME f-cab.
                DOWN STREAM report WITH FRAME f-cab.
                imp-aux = NO.
            END.
            {&NEW-PAGE}.
            DISPLAY STREAM report 
                                cb-dmov.fchdoc  WHEN (fchdoc <> ?)
                                cb-dmov.coddiv
                                cb-dmov.cco
                                cb-dmov.nroast
                                cb-dmov.codope
                                cb-dmov.nromes
                                cb-dmov.coddoc   
                                cb-dmov.nrodoc
                                cb-dmov.nroref
                                cb-dmov.fchvto    WHEN (fchvto <> ?)
                                x-glodoc @ cb-dmov.glodoc           
                                x-importe WHEN (x-importe <> 0) 
                                x-debe    WHEN (x-debe    <> 0)
                                x-haber   WHEN (x-haber   <> 0)
                  WITH FRAME f-cab.
                  DOWN STREAM REPORT  WITH FRAME f-cab.
                  x-conreg = x-conreg + 1.
                  i = i + 1.
        END.            
        IF LAST-OF (cb-dmov.nrodoc) AND x-conreg > 0 THEN DO:
            x-saldo = (ACCUM SUB-TOTAL BY cb-dmov.nrodoc x-debe) -
                      (ACCUM SUB-TOTAL BY cb-dmov.nrodoc x-haber).
            DISPLAY STREAM report x-saldo  WITH FRAME f-cab.
            {&NEW-PAGE}.
            DOWN STREAM report WITH FRAME f-cab.
            DISPLAY STREAM report "........" @ cb-dmov.fchdoc
                                "....."      @ cb-dmov.coddiv
                                "....."      @ cb-dmov.cco
                                "......"     @ cb-dmov.nroast
                                "..."        @ cb-dmov.nromes
                                "..."        @ cb-dmov.codope
                                "......"     @ cb-dmov.coddoc
                                ".........." @ cb-dmov.nrodoc
                                ".........." @ cb-dmov.nroref
                                "........"   @ cb-dmov.fchvto
                                ".............................." @ cb-dmov.glodoc
                                "..............." @ x-importe  
                                "..............." @ x-debe 
                                "..............." @ x-haber
                                "..............." @ x-saldo
                            WITH FRAME f-cab.
            DOWN STREAM report  WITH FRAME f-cab.                
            x-conreg = 0.
            x-condoc = x-condoc + 1.
        END.
        
        IF LAST-OF (cb-dmov.codaux) AND i > 0 THEN DO:
            x-glodoc = "** TOTAL AUXILIAR " + cb-dmov.codaux + " **".
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report
                        x-glodoc                                   @ cb-dmov.glodoc
                        ACCUM SUB-TOTAL BY cb-dmov.codaux x-debe   @ x-debe
                        ACCUM SUB-TOTAL BY cb-dmov.codaux x-haber  @ x-haber
                       (ACCUM SUB-TOTAL BY cb-dmov.codaux x-debe) -
                       (ACCUM SUB-TOTAL BY cb-dmov.codaux x-haber) @ x-saldo
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
             UNDERLINE STREAM report cb-dmov.fchdoc
                                    cb-dmov.coddiv
                                    cb-dmov.cco
                                    cb-dmov.nroast
                                    cb-dmov.nromes
                                    cb-dmov.codope
                                    cb-dmov.coddoc
                                    cb-dmov.nrodoc
                                    cb-dmov.nroref
                                    cb-dmov.fchvto
                                    cb-dmov.glodoc
                                    x-importe  
                                    x-debe 
                                    x-haber
                                    x-saldo
                    WITH FRAME f-cab.
                    i = 0.          
 
         END.
        IF LAST-OF (cb-dmov.codcta) AND x-condoc > 0 THEN DO:
            x-glodoc = "** TOTAL CUENTA " + cb-dmov.codcta + " **".
            {&NEW-PAGE}.
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report
                        x-glodoc                                   @ cb-dmov.glodoc
                        ACCUM SUB-TOTAL BY cb-dmov.codcta x-debe   @ x-debe
                        ACCUM SUB-TOTAL BY cb-dmov.codcta x-haber  @ x-haber
                       (ACCUM SUB-TOTAL BY cb-dmov.codcta x-debe) -
                       (ACCUM SUB-TOTAL BY cb-dmov.codcta x-haber) @ x-saldo
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
             DISPLAY STREAM report "========" @ cb-dmov.fchdoc
                                "====="      @ cb-dmov.coddiv
                                "====="      @ cb-dmov.cco
                                "======"     @ cb-dmov.nroast
                                "==="        @ cb-dmov.nromes
                                "==="        @ cb-dmov.codope
                                "======"     @ cb-dmov.coddoc
                                "==========" @ cb-dmov.nrodoc
                                "==========" @ cb-dmov.nroref
                                "========"   @ cb-dmov.fchvto
                                "==============================" @ cb-dmov.glodoc
                                "===============" @ x-importe  
                                "===============" @ x-debe 
                                "===============" @ x-haber
                                "===============" @ x-saldo
                    WITH FRAME f-cab.
                       
            x-condoc = 0.
        
        END.
    /*    i = i + 1. */
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
                IF AVAILABLE gn-clie THEN
                    x-nomaux = gn-clie.nomcli.
            END.
            WHEN "@PV" THEN DO:
                FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                                AND gn-prov.CodCia = pv-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE gn-prov THEN 
                    x-nomaux = gn-prov.nompro.
            END.
            WHEN "@CT" THEN DO:
                find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                                AND cb-ctas.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN 
                    x-nomaux = cb-ctas.nomcta.
            END.
            OTHERWISE DO:
                FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                                AND cb-auxi.codaux = cb-dmov.codaux
                                AND cb-auxi.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-auxi THEN 
                    x-nomaux = cb-auxi.nomaux.
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
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    x-debe  = 0.
    x-haber = 0.
    imprime = YES.
    FOR EACH detalle WHERE   detalle.codcia = cb-dmov.CodCia
                        AND detalle.periodo = cb-dmov.periodo
                        AND detalle.codaux  = cb-dmov.codaux
                        AND detalle.codcta  = cb-dmov.codcta
                        AND detalle.coddoc  = cb-dmov.coddoc
                        AND detalle.nrodoc  = cb-dmov.nrodoc:
        IF detalle.nromes <= s-NroMes THEN
            IF NOT detalle.tpomov THEN DO:
                CASE x-codmon:
                WHEN 1 THEN
                    x-debe  = x-debe + detalle.ImpMn1.
                WHEN 2 THEN
                    x-debe  = x-debe + detalle.ImpMn2.
                WHEN 3 THEN
                    x-debe  = x-debe + detalle.ImpMn3.
                END CASE.
            END.
            ELSE DO:      
                CASE x-codmon:
                WHEN 1 THEN
                    x-haber = x-haber + detalle.ImpMn1.
                WHEN 2 THEN
                    x-haber = x-haber + detalle.ImpMn2.
                WHEN 3 THEN
                    x-haber = x-haber + detalle.ImpMn3.
                END CASE.
            END.
    END.
    x-saldo = x-debe - x-haber.
    IF x-saldo = 0 OR x-saldo = ? THEN imprime = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


