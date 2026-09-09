&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
SESSION:DATE-FORMAT = "dmy".
DEFINE {&NEW} SHARED    VAR S-PERIODO AS INTEGER INIT 1996.
DEFINE {&NEW} SHARED    VAR S-CODCIA AS INTEGER  INIT 1.
DEFINE {&NEW} SHARED    VAR S-NOMCIA AS CHAR INIT "ICOMECSA".
DEFINE VAR    x-NomAlm  LIKE Almacen.Descripcion FORMAT "X(64)".
DEFINE VARIABLE P-Largo    AS INTEGER.
DEFINE VARIABLE P-Ancho    AS INTEGER.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9".
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9".
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)".

DEFINE VARIABLE P-detalle  AS CHAR.
DEFINE VARIABLE P-comando  AS CHAR.
DEFINE VARIABLE P-device   AS CHAR.
DEFINE VARIABLE P-name     AS CHAR.

DEFINE VARIABLE P-Reset    AS CHARACTER.
DEFINE VARIABLE P-Flen     AS CHARACTER.
DEFINE VARIABLE P-6lpi     AS CHARACTER.
DEFINE VARIABLE P-8lpi     AS CHARACTER.
DEFINE VARIABLE P-10cpi    AS CHARACTER.
DEFINE VARIABLE P-12cpi    AS CHARACTER.
DEFINE VARIABLE P-15cpi    AS CHARACTER.
DEFINE VARIABLE P-20cpi    AS CHARACTER.
DEFINE VARIABLE P-Landscap AS CHARACTER.
DEFINE VARIABLE P-Portrait AS CHARACTER.
DEFINE VARIABLE P-DobleOn  AS CHARACTER.
DEFINE VARIABLE P-DobleOff AS CHARACTER.
DEFINE VARIABLE P-BoldOn   AS CHARACTER.
DEFINE VARIABLE P-BoldOff  AS CHARACTER.
DEFINE VARIABLE P-UlineOn  AS CHARACTER.
DEFINE VARIABLE P-UlineOff AS CHARACTER.
DEFINE VARIABLE P-ItalOn   AS CHARACTER.
DEFINE VARIABLE P-ItalOff  AS CHARACTER.
DEFINE VARIABLE P-SuperOn  AS CHARACTER.
DEFINE VARIABLE P-SuperOff AS CHARACTER.
DEFINE VARIABLE P-SubOn    AS CHARACTER.
DEFINE VARIABLE P-SubOff   AS CHARACTER.
DEFINE VARIABLE P-Proptnal AS CHARACTER.
DEFINE VARIABLE P-Lpi      AS CHARACTER.
DEFINE VARIABLE l-immediate-display  AS LOGICAL.

/*
DEFINE {&NEW} SHARED VARIABLE x-Term     AS CHARACTER INITIAL "".
*/
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
/*DEFINE {&NEW} SHARED VARIABLE x-modulo  LIKE integral.Modulos.Modulo.*/
DEFINE {&NEW} SHARED VARIABLE x-userid  LIKE _user._userid.


DEFINE        VARIABLE P-config  AS CHARACTER.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina ".
DEFINE        VARIABLE c-Copias  AS INTEGER.
/*DEFINE        VARIABLE X-Detalle LIKE integral.Modulos.Detalle.*/
DEFINE        VARIABLE OKpressed AS LOGICAL.
DEFINE        VARIABLE PTO        AS LOGICAL.

/*
&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 6 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE
*/

&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER(report)  + 5 > 66 OR c-Pagina = 0 ~
THEN RUN NEW-PAGE


DEFINE STREAM report.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG\print"
     SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Mensaje
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
          SKIP
     Fi-Mensaje NO-LABEL
          FONT 8          
     SKIP     
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 4.5 COL 12
          FONT 8          
     SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Imprimiendo ...".

 DEF VAR K AS INTEGER INIT 0 FORMAT "ZZZ9" COLUMN-LABEL "Item".
  DEF VAR x-NomRep AS CHAR FORMAT "X(64)".
  DEF VAR x-NomPer AS CHAR FORMAT "X(64)".
  DEF VAR x-CodMat    LIKE almdmov.CodMat.
  DEF VAR x-DesMat    LIKE almmmatg.DesMat .
  DEF VAR x-CodFam    LIKE almtfami.CodFam COLUMN-LABEL "Cod!Fam".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RADIO-SET-1 RECT-6 B-imprime ~
B-impresoras x-periodo-1 x-Periodo-2 B-cancela RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 x-periodo-1 x-Periodo-2 ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "img/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 11 BY .81.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "img/pvprint":U
     IMAGE-DOWN FILE "img/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     LABEL "&Imprimir" 
     SIZE 11 BY .81.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "P gina Desde" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "P gina Hasta" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 19.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-periodo-1 AS INTEGER FORMAT "9,999":U INITIAL 0 
     LABEL "Del Periodo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE x-Periodo-2 AS INTEGER FORMAT "9,999":U INITIAL 0 
     LABEL "Hasta el Per¡odo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 15 FONT 4 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10.57 BY 3
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 57.86 BY 2.42.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 57.86 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 57.86 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     RADIO-SET-1 AT ROW 4.77 COL 2 NO-LABEL
     B-imprime AT ROW 8.73 COL 8.57
     B-impresoras AT ROW 5.77 COL 13.29
     b-archivo AT ROW 6.77 COL 13.29
     RB-OUTPUT-FILE AT ROW 6.73 COL 17.29 COLON-ALIGNED NO-LABEL
     x-periodo-1 AT ROW 1.31 COL 24.86 COLON-ALIGNED
     x-Periodo-2 AT ROW 2.15 COL 24.86 COLON-ALIGNED
     B-cancela AT ROW 8.77 COL 38.72
     RB-NUMBER-COPIES AT ROW 4.77 COL 49.14 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 5.77 COL 49.14 COLON-ALIGNED
     RB-END-PAGE AT ROW 6.77 COL 49.14 COLON-ALIGNED
     RECT-4 AT ROW 1 COL 1
     " Configuraci¢n de Impresi¢n" VIEW-AS TEXT
          SIZE 57.43 BY .62 AT ROW 3.5 COL 1.14
          BGCOLOR 1 FGCOLOR 15 
     RECT-5 AT ROW 4.19 COL 1
     RECT-6 AT ROW 8.27 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Indices Mensuales (IPM)".

 

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
ON GO OF FRAME DIALOG-1 /* Indices Mensuales (IPM) */
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
    Assign 
           x-periodo-1
           x-periodo-2.
           
    if x-periodo-2 < x-periodo-1 then do:
       message "Periodos no validos"
       view-as alert-box error.
       apply "ENTRY" to x-periodo-1.
       return no-apply.
    end.     
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */

ASSIGN  X-PERIODO-2 = S-PERIODO.

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
  DO c-Copias = 1 to P-copias ON ERROR UNDO, LEAVE
                                ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 66.
        c-Pagina = 0.
        RUN IMPRIMIR.
        OUTPUT STREAM report CLOSE.        
  END.
  HIDE FRAME F-Mensaje.  
  OUTPUT STREAM report CLOSE.        
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN BIN/_vcat.p ( P-archivo ). 
        OS-DELETE VALUE ( P-archivo ). 
  END.    
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
  DISPLAY RADIO-SET-1 x-periodo-1 x-Periodo-2 RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RADIO-SET-1 RECT-6 B-imprime B-impresoras x-periodo-1 
         x-Periodo-2 B-cancela RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR DIALOG-1 
PROCEDURE IMPRIMIR :
P-Largo = 66.    /* Largo de Pagina */ 
    P-Ancho = 180.   /* Ancho de Pagina */
    /* Configurando Setup de Impresora */
    P-Config = P-15cpi. 
    K = 0 .
    
    x-NomRep = "INDICES MENSUALES IPM PARA AJUSTES POR INFLACION".
  DEFINE FRAME f-cab 
     aj-inme.Periodo    COLUMN-LABEL "A¤o"
     aj-inme.Indice[1]   COLUMN-LABEL "Enero"
     aj-inme.Indice[2]   COLUMN-LABEL "Febrero"
     aj-inme.Indice[3]   COLUMN-LABEL "Marzo"
     aj-inme.Indice[4]   COLUMN-LABEL "Abril"
     aj-inme.Indice[5]   COLUMN-LABEL "Mayo"
     aj-inme.Indice[6]   COLUMN-LABEL "Junio"
     aj-inme.Indice[7]   COLUMN-LABEL "Julio"
     aj-inme.Indice[8]   COLUMN-LABEL "Agosto"
     aj-inme.Indice[9]   COLUMN-LABEL "Septiembre"
     aj-inme.Indice[10]  COLUMN-LABEL "Octubre"
     aj-inme.Indice[11]  COLUMN-LABEL "Noviembre"
     aj-inme.Indice[12]  COLUMN-LABEL "Diciembre"
   
  HEADER  
       s-nomcia FORMAT "X(70)"
                   "Fecha  :" to 200 TODAY    to 210   SKIP
                   "P gina :" to 200 c-pagina to 210   SKIP
                   "Hora   :" to 200 STRING(TIME, "HH:MM AM") to 210 SKIP
       x-NomRep AT  70  SKIP(2)
  WITH DOWN NO-BOX STREAM-IO  WIDTH 255.

    FOR EACH aj-inme NO-LOCK  WHERE     aj-inme.periodo >= X-periodo-1
                                AND     aj-inme.periodo <= x-periodo-2 :
                             
       PAUSE 0.
        {&NEW-PAGE}.
        K = K + 1.
        DISPLAY STREAM REPORT
            aj-inme.Periodo    
            aj-inme.Indice[1]  WHEN aj-inme.Indice[1]  <> 0
            aj-inme.Indice[2]  WHEN aj-inme.Indice[2]  <> 0
            aj-inme.Indice[3]  WHEN aj-inme.Indice[3]  <> 0
            aj-inme.Indice[4]  WHEN aj-inme.Indice[4]  <> 0
            aj-inme.Indice[5]  WHEN aj-inme.Indice[5]  <> 0
            aj-inme.Indice[6]  WHEN aj-inme.Indice[6]  <> 0
            aj-inme.Indice[7]  WHEN aj-inme.Indice[7]  <> 0
            aj-inme.Indice[8]  WHEN aj-inme.Indice[8]  <> 0
            aj-inme.Indice[9]  WHEN aj-inme.Indice[9]  <> 0
            aj-inme.Indice[10] WHEN aj-inme.Indice[10]  <> 0
            aj-inme.Indice[11] WHEN aj-inme.Indice[11]  <> 0
            aj-inme.Indice[12] WHEN aj-inme.Indice[12]  <> 0
        WITH FRAME F-CAB.   
        DOWN STREAM REPORT WITH FRAME F-CAB. 
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
               OUTPUT STREAM report TO PRINTER /*NO-MAP NO-CONVERT 
                UNBUFFERED */ PAGED PAGE-SIZE 66.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL. 
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) /*NO-MAP NO-CONVERT */
              /* UNBUFFERED */
                 PAGED PAGE-SIZE 66.
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
FIND PF-P001 WHERE PF-P001.P-Code = P-name NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PF-P001
    THEN DO:
        MESSAGE "Invalido Tabla de Impresora" SKIP
                "configurado al Terminal" /* XTerm*/
                VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
    END.
    /* Configurando Variables de Impresion */
    RUN RemVar (INPUT PF-P001.Reset,    OUTPUT P-Reset).
    RUN RemVar (INPUT PF-P001.Flen,     OUTPUT P-Flen).
    RUN RemVar (INPUT PF-P001.C6lpi,    OUTPUT P-6lpi).
    RUN RemVar (INPUT PF-P001.C8lpi,    OUTPUT P-8lpi).
    RUN RemVar (INPUT PF-P001.C10cpi,   OUTPUT P-10cpi).
    RUN RemVar (INPUT PF-P001.C12cpi,   OUTPUT P-12cpi).
    RUN RemVar (INPUT PF-P001.C15cpi,   OUTPUT P-15cpi).
    RUN RemVar (INPUT PF-P001.C20cpi,   OUTPUT P-20cpi).
    RUN RemVar (INPUT PF-P001.Landscap, OUTPUT P-Landscap).
    RUN RemVar (INPUT PF-P001.Portrait, OUTPUT P-Portrait).
    RUN RemVar (INPUT PF-P001.DobleOn,  OUTPUT P-DobleOn).
    RUN RemVar (INPUT PF-P001.DobleOff, OUTPUT P-DobleOff).
    RUN RemVar (INPUT PF-P001.BoldOn,   OUTPUT P-BoldOn).
    RUN RemVar (INPUT PF-P001.BoldOff,  OUTPUT P-BoldOff).
    RUN RemVar (INPUT PF-P001.UlineOn,  OUTPUT P-UlineOn).
    RUN RemVar (INPUT PF-P001.UlineOff, OUTPUT P-UlineOff).
    RUN RemVar (INPUT PF-P001.ItalOn,   OUTPUT P-ItalOn).
    RUN RemVar (INPUT PF-P001.ItalOff,  OUTPUT P-ItalOff).
    RUN RemVar (INPUT PF-P001.SuperOn,  OUTPUT P-SuperOn).
    RUN RemVar (INPUT PF-P001.SuperOff, OUTPUT P-SuperOff).
    RUN RemVar (INPUT PF-P001.SubOn,    OUTPUT P-SubOn).
    RUN RemVar (INPUT PF-P001.SubOff,   OUTPUT P-SubOff).
    RUN RemVar (INPUT PF-P001.Proptnal, OUTPUT P-Proptnal).
    RUN RemVar (INPUT PF-P001.Lpi,      OUTPUT P-Lpi).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


