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
DEFINE VAR I-NroMes  AS INTEGER NO-UNDO.

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
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                                                LABEL "Debe      ".
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                                                LABEL "Haber     ".
DEFINE VARIABLE x-totdebe  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-tothabe  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-".
DEFINE VARIABLE x-codope   LIKE cb-cmov.Codope.
DEFINE VARIABLE x-nom-ope  LIKE cb-oper.nomope.
DEFINE VARIABLE x-nroast   LIKE cb-dmov.Nroast.
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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".


 DEFINE FRAME f-cab
        cb-cmov.fchast         COLUMN-LABEL " Fecha!Asiento"
        cb-dmov.nroast         COLUMN-LABEL "Compro!bante"
        cb-dmov.fchdoc         COLUMN-LABEL "  Fecha!Documento"
        cb-dmov.coddoc         COLUMN-LABEL "Cod.!Doc."
        cb-dmov.nrodoc 
        cb-dmov.fchvto         COLUMN-LABEL " Fecha!  Vto."
        cb-dmov.clfaux         COLUMN-LABEL "Clf!Aux"
        cb-dmov.codaux         COLUMN-LABEL "Auxiliar"
        cb-dmov.cco            COLUMN-LABEL "Cco."
        cb-dmov.coddiv
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
        "PAGINA :" TO 140 c-pagina FORMAT "ZZZ9" TO 150    SKIP(2)
        x-nom-ope FORMAT "X(100)" SKIP(2)
        WITH WIDTH 165 NO-BOX DOWN STREAM-IO.

def var t-d as decimal init 0.
def var t-h as decimal init 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-4 RECT-10 RECT-5 x-codmon ~
RADIO-SET-1 B-impresoras B-imprime y-codope B-cancela CB-Mes ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS x-codmon RADIO-SET-1 y-codope CB-Mes ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE CB-Mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Apertura","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre","Cierre" 
     SIZE 16.72 BY 1
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

DEFINE VARIABLE y-codope AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operaci¢n" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

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
     SIZE 12.57 BY 2.19 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 17 BY 2.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 4.77.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 74 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-codmon AT ROW 2.15 COL 5.14 NO-LABEL
     RADIO-SET-1 AT ROW 6.08 COL 2 NO-LABEL
     B-impresoras AT ROW 7.08 COL 15
     b-archivo AT ROW 8.08 COL 15
     B-imprime AT ROW 10.08 COL 18
     RB-OUTPUT-FILE AT ROW 8.35 COL 19 COLON-ALIGNED NO-LABEL
     y-codope AT ROW 1.96 COL 32.29 COLON-ALIGNED
     B-cancela AT ROW 10.08 COL 48
     CB-Mes AT ROW 1.96 COL 52 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 6.08 COL 64 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 7.08 COL 64 COLON-ALIGNED
     RB-END-PAGE AT ROW 8.08 COL 64 COLON-ALIGNED
     RECT-6 AT ROW 9.58 COL 1
     RECT-4 AT ROW 1 COL 1
     "Moneda" VIEW-AS TEXT
          SIZE 8 BY .38 AT ROW 1.31 COL 3.14
     RECT-10 AT ROW 1.96 COL 3.14
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 73 BY .62 AT ROW 4.88 COL 1.57
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 5.58 COL 1
     SPACE(0.28) SKIP(2.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 
         TITLE "Libro Diario General Resumido".


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
ON GO OF FRAME DIALOG-1 /* Libro Diario General Resumido */
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
    ASSIGN x-codmon CB-Mes  y-CodOpe.
    I-NroMes = LOOKUP(CB-MES,CB-MES:LIST-ITEMS) - 1.       
    IF s-NroMes = 0 OR s-NroMes = 13 THEN 
      IF x-codmon = 1 THEN x-smon = "S/.".
      ELSE                 x-smon = "US$".
    IF y-codope <> "" AND
         NOT CAN-FIND(FIRST cb-oper  WHERE cb-oper.codcia = cb-codcia AND
                                        cb-oper.codope = y-codope)
    THEN DO:
        BELL.
        MESSAGE "C¢digo de operaci¢n no existe " + Y-CODOPE
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO y-codope.
        RETURN NO-APPLY.
    END.
                                                
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


&Scoped-define SELF-NAME y-codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL y-codope DIALOG-1
ON F8 OF y-codope IN FRAME DIALOG-1 /* Operaci¢n */
OR "MOUSE-SELECT-DBLCLICK":U OF y-codope
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
  CB-Mes:SCREEN-VALUE = ENTRY(S-NroMes + 1 ,CB-Mes:LIST-ITEMS).
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
        RUN Imprimir.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalle DIALOG-1 
PROCEDURE Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR y-con-reg AS INTEGER NO-UNDO.
    
    FOR EACH cb-cmov NO-LOCK WHERE cb-cmov.codcia  = s-codcia  AND
                                   cb-cmov.periodo = s-periodo AND
                                   cb-cmov.nromes  = I-NroMes  AND
                                   cb-cmov.codope  = x-codope
                          BREAK BY cb-cmov.codope  WITH FRAME f-cab 
                          ON ERROR UNDO, LEAVE:
        x-nom-ope = "LIBRO : " + x-codope + " - " + cb-oper.nomope.
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  cb-cmov.codcia  AND
                                       cb-dmov.periodo = cb-cmov.periodo AND
                                       cb-dmov.nromes  = cb-cmov.nromes  AND
                                       cb-dmov.codope  = cb-cmov.codope  AND
                                       cb-dmov.nroast  = cb-cmov.nroast  
                             BREAK BY (cb-dmov.nroast) ON ERROR UNDO, LEAVE:
            x-glodoc = glodoc.
            IF x-glodoc = "" THEN RUN p-nom-aux.
            IF x-glodoc = "" THEN x-glodoc = cb-cmov.notast.
            IF NOT tpomov THEN DO:
                x-haber = 0.
                IF x-codmon = 1 THEN x-debe = ImpMn1.
                IF x-codmon = 2 THEN x-debe = ImpMn2.
                IF x-codmon = 3 THEN x-debe = ImpMn3.
            END.
            ELSE DO:
                x-debe = 0.
                IF x-codmon = 1 THEN x-haber = ImpMn1.
                IF x-codmon = 2 THEN x-haber = ImpMn2.
                IF x-codmon = 3 THEN x-haber = ImpMn3.
            END.
            IF NOT (x-haber = 0 AND x-debe = 0) AND x-debe <> ? AND x-haber <> ? THEN DO:
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
                y-con-reg = y-con-reg + 1.
                x-con-reg = x-con-reg + 1.
            END.    
            IF LAST-OF (cb-dmov.nroast) AND y-con-reg > 0 THEN DO:
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
            DISPLAY STREAM report fchast cb-dmov.nroast 
                        "******* A N U L A D O *******" @ x-glodoc
                 WITH FRAME f-cab.
            DOWN STREAM report  WITH FRAME f-cab. 
            END.      
        IF y-con-reg = 0 AND cb-cmov.flgest <> "A" THEN DO:
           {&NEW-PAGE}.
            DISPLAY STREAM report cb-cmov.fchast  cb-dmov.nroast 
                       cb-cmov.notast @ x-glodoc
                WITH FRAME f-cab.
            DOWN STREAM report  WITH FRAME f-cab.
         END.    
        y-con-reg = 0.
        {&NEW-PAGE}.
    END. /* FIN DEL FOR EACH cb-cmov */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY x-codmon RADIO-SET-1 y-codope CB-Mes RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-4 RECT-10 RECT-5 x-codmon RADIO-SET-1 B-impresoras 
         B-imprime y-codope B-cancela CB-Mes RB-NUMBER-COPIES RB-BEGIN-PAGE 
         RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
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
                                      cb-dmov.nroast 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir DIALOG-1 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var linact as integer.
    DEFINE VAR x-con-ope AS INTEGER.
    P-Config = P-20cpi + P-8lpi.
    x-Raya   = FILL("-", P-Ancho).
    RUN bin/_mes.p ( INPUT I-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    RUN bin/_centrar.p ( INPUT pinta-mes, 40 , OUTPUT pinta-mes).
    FOR EACH cb-oper NO-LOCK WHERE cb-oper.CodCia = cb-codcia AND
                    cb-oper.Codope BEGINS (y-codope)
                    BREAK BY cb-oper.Codope 
                    WITH FRAME f-cab 
                    ON ERROR UNDO, LEAVE:
        x-codope = cb-oper.codope.
        x-haber = 0.
        x-debe  = 0.
        IF LOOKUP(x-codope,"001") > 0 THEN RUN Detalle.
        ELSE RUN Resumen.
        IF x-con-reg > 0 THEN DO:
           {&NEW-PAGE}.
           UNDERLINE STREAM report x-glodoc 
                                   x-debe   
                                   x-haber  WITH FRAME f-cab.
           DOWN STREAM report 1 WITH  FRAME f-cab.
           IF LAST-OF (cb-oper.codope) THEN DO:
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
              x-con-reg = 0.
              x-nom-ope = "".
              x-con-ope = x-con-ope + 1.
           END.
        END.
    END.
    IF x-con-ope > 1 THEN DO:
       {&NEW-PAGE}.
       UNDERLINE STREAM report x-glodoc 
                            x-debe   
                            x-haber  
                            WITH FRAME f-cab.
       DOWN STREAM report 1 WITH  FRAME f-cab.                        
       {&NEW-PAGE}.
       DISPLAY STREAM report 
                 "** TOTAL GENERAL ** " + x-smon @ x-glodoc 
                 t-d @ x-debe
                 t-h @ x-haber WITH FRAME f-cab.
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
    IF c-Pagina > P-pagfin THEN RETURN ERROR.
    DISPLAY c-Pagina WITH FRAME f-mensaje.
    IF c-Pagina > 1 THEN PAGE STREAM report.
    IF P-pagini = c-Pagina THEN DO:
       OUTPUT STREAM report CLOSE.
       IF P-select = 1 THEN DO:
          OUTPUT STREAM report TO PRINTER NO-MAP NO-CONVERT UNBUFFERED PAGED PAGE-SIZE 1000.
          PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
       END.
       ELSE DO:
           OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED PAGED PAGE-SIZE 1000.
           IF P-select = 3 THEN PUT STREAM report CONTROL P-reset P-flen P-config.
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
    IF P-pos <> 0 THEN 
       OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) + CHR(0) + SUBSTR(OU-VAR, P-pos + 6).
    P-pos =  INDEX(OU-VAR, "[#B]" ).
    IF P-pos <> 0 THEN 
       OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) + CHR(P-Largo) + SUBSTR(OU-VAR, P-pos + 4).
    P-pos =  INDEX(OU-VAR, "[#]" ).
    IF P-pos <> 0
    THEN OU-VAR = SUBSTR(OU-VAR, 1, P-pos - 1) +
                     STRING(P-Largo, ">>9" ) + SUBSTR(OU-VAR, P-pos + 3).
    RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen DIALOG-1 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia =  s-codcia  AND
                 cb-dmov.periodo = s-periodo       AND
                 cb-dmov.nromes  = I-NroMes        AND
                 cb-dmov.codope  = x-codope       
                 BREAK BY (cb-dmov.codcta) ON ERROR UNDO, LEAVE:
            IF NOT tpomov THEN DO:
                IF x-codmon = 1 THEN x-debe = x-debe + ImpMn1.
                IF x-codmon = 2 THEN x-debe = x-debe + ImpMn2.
                IF x-codmon = 3 THEN x-debe = x-debe + ImpMn3.
            END.
            ELSE DO:
                IF x-codmon = 1 THEN x-haber = x-haber + ImpMn1.
                IF x-codmon = 2 THEN x-haber = x-haber + ImpMn2.
                IF x-codmon = 3 THEN x-haber = x-haber + ImpMn3.
            END.
            IF LAST-OF(cb-dmov.codcta) AND NOT (x-haber = 0 AND x-debe = 0) THEN DO:
               x-nom-ope = "ASIENTO DE CENTRALIZACION  DE  LIBRO : " + x-codope + " - " + cb-oper.nomope.
               {&NEW-PAGE}.
               FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
                    cb-ctas.codcta = cb-dmov.codcta NO-LOCK NO-ERROR.
               DISPLAY STREAM report 
                       cb-dmov.codcta 
                       cb-ctas.NomCta @ x-glodoc 
                       x-debe  WHEN x-debe > 0
                       x-haber WHEN x-haber > 0
                    WITH FRAME f-cab.
               DOWN STREAM report WITH FRAME f-cab.    
               x-totdebe = x-totdebe + x-debe.
               x-tothabe = x-tothabe + x-haber.
               t-d       = t-d       + x-debe.
               t-h       = t-h       + x-haber.
               x-haber = 0.
               x-debe  = 0.
               x-con-reg = x-con-reg + 1.
            END.
        END.  /* FIN DEL FOR EACH cb-dmov */

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


