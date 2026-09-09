&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/31/95 -  6:23 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE STREAM report.
DEFINE VARIABLE P-Largo    AS INTEGER.
DEFINE VARIABLE P-Ancho    AS INTEGER.
DEFINE VARIABLE P-pagini   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-pagfin   AS INTEGER FORMAT ">>>9".
DEFINE VARIABLE P-copias   AS INTEGER FORMAT ">9".
DEFINE VARIABLE P-select   AS INTEGER FORMAT "9".
DEFINE VARIABLE P-archivo  AS CHARACTER FORMAT "x(30)".

DEFINE VARIABLE P-detalle  LIKE TermImp.Detalle.
DEFINE VARIABLE P-comando  LIKE TermImp.Comando.
DEFINE VARIABLE P-device   LIKE TermImp.Device.
DEFINE VARIABLE P-name     LIKE TermImp.p-name.


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
DEFINE VARIABLE l-immediate-display AS LOGICAL.

DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.


DEFINE        VARIABLE P-config  AS CHARACTER.
DEFINE        VARIABLE c-Pagina  AS INTEGER LABEL "                 Imprimiendo Pagina ".
DEFINE        VARIABLE c-Copias  AS INTEGER.
DEFINE        VARIABLE X-Detalle LIKE Modulos.Detalle.
DEFINE        VARIABLE i         AS INTEGER.
DEFINE        VARIABLE OKpressed AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER init 0.
DEFINE        VARIABLE Prv-CodCia AS INTEGER.
DEFINE        VARIABLE PTO        AS LOGICAL.

&GLOBAL-DEFINE NEW-PAGE READKEY PAUSE 0. ~
IF LASTKEY = KEYCODE("F10") THEN RETURN ERROR. ~
IF LINE-COUNTER( report ) > (P-Largo - 8 ) OR c-Pagina = 0 ~
THEN RUN NEW-PAGE

DEFINE VARIABLE x-mensaje  AS CHARACTER FORMAT "X(50)"  COLUMN-LABEL "Error Descripcion".
DEFINE VARIABLE x-dm1      AS DECIMAL.
DEFINE VARIABLE x-hm1      AS DECIMAL.
DEFINE VARIABLE x-dm2      AS DECIMAL.
DEFINE VARIABLE x-hm2      AS DECIMAL.
DEFINE VARIABLE delta      AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)" COLUMN-LABEL "Diferencia".
DEFINE VARIABLE Max-Error  AS DECIMAL.
DEFINE VARIABLE x-GenAut   AS INTEGER.
DEFINE VARIABLE x-Cta-Auto LIKE  cb-cfga.genaut.
DEFINE VARIABLE x-Cc1Cta   LIKE  cb-cfga.cc1cta6.
DEFINE VARIABLE x-a-cc1cta LIKE  cb-cfga.cc1cta6.
DEFINE VARIABLE x-An1Cta   LIKE  cb-cfga.genaut.


DEFINE VARIABLE x-llave    AS CHARACTER.
DEFINE VARIABLE l-an1cta   AS LOGICAL.
DEFINE VARIABLE l-cc1cta   AS LOGICAL.

DEFINE BUFFER   detalle    FOR cb-dmov.


DEFINE {&NEW} SHARED VARIABLE s-NroMes AS INTEGER INITIAL 8.
DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER INITIAL 1996.
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.



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
        cb-dmov.nromes 
        cb-dmov.codope  COLUMN-LABEL "Ope"
        cb-dmov.nroast
        cb-dmov.nroitm  COLUMN-LABEL "Itm"
        cb-dmov.codcta
        x-mensaje
        HEADER
        empresas.nomcia SKIP
        "REPORTE DE CONSISTENCIA - CUENTAS AUTOMATICAS" TO 87  
        "FECHA  :" TO 120 TODAY  TO 131 SKIP
        "PAGINA :" TO 120 c-pagina FORMAT "ZZ9" TO 131 SKIP
        
        WITH WIDTH 140 NO-BOX DOWN STREAM-IO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 R-CTAS C-1 C-2 ~
RADIO-SET-1 RB-NUMBER-COPIES B-impresoras RB-BEGIN-PAGE RB-END-PAGE ~
B-imprime B-cancela 
&Scoped-Define DISPLAYED-OBJECTS R-CTAS C-1 C-2 RADIO-SET-1 ~
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

DEFINE VARIABLE C-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7.72 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE C-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 14
     LIST-ITEMS "00","01","02","03","04","05","06","07","08","09","10","11","12","13" 
     DROP-DOWN-LIST
     SIZE 7.72 BY 1
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
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-CTAS AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cuentas Automáticas", 1,
"Registro en Cuentas Automáticas", 2,
"Cuentas no Registradas", 3,
"Cuentas que no debieron generar Automáticas", 4
     SIZE 35.14 BY 2.96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65.72 BY 4.08.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65.57 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65.57 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     R-CTAS AT ROW 1.23 COL 29.57 NO-LABEL
     C-1 AT ROW 1.38 COL 14.29 COLON-ALIGNED
     C-2 AT ROW 2.42 COL 14.29 COLON-ALIGNED
     RADIO-SET-1 AT ROW 6.31 COL 2 NO-LABEL
     RB-NUMBER-COPIES AT ROW 6.5 COL 57.86 COLON-ALIGNED
     B-impresoras AT ROW 7.35 COL 12.14
     RB-BEGIN-PAGE AT ROW 7.5 COL 57.86 COLON-ALIGNED
     b-archivo AT ROW 8.35 COL 12.14
     RB-END-PAGE AT ROW 8.5 COL 57.86 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 8.62 COL 16.14 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 10.27 COL 12.72
     B-cancela AT ROW 10.31 COL 41.86
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 65.72 BY .62 AT ROW 5.15 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 5.81 COL 1
     RECT-6 AT ROW 9.81 COL 1
     SPACE(0.15) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Consistencia de Cuentas".


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
    ASSIGN R-CTAS
           C-1
           C-2. 
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
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

ASSIGN C-1 = s-NroMes
       C-2 = s-NroMes.
       
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
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN IMPRIMIR.
        OUTPUT STREAM report CLOSE.        
  END.
  OUTPUT STREAM report CLOSE.        
  SESSION:IMMEDIATE-DISPLAY = l-immediate-display.
  IF NOT LASTKEY = KEYCODE("ESC") AND P-select = 2 THEN DO: 
        RUN bin/_vcat.p ( P-archivo ). 
        OS-DELETE VALUE ( P-archivo ). 
  END.    
  HIDE FRAME F-Mensaje.  
  RETURN.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cons-reg DIALOG-1 
PROCEDURE cons-reg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
define  input parameter x-GenAut   as integer.
define  input parameter x-cta-auto as char.
define  input parameter x-a-cc1cta as char.
define  input parameter s-NroMes      as integer.
def var k as integer.
def var marca as logical.
def var total as decimal.
DO i = 1 TO NUM-ENTRIES( x-cta-auto ):
    x-llave = ENTRY(i,  x-cta-auto).
    FOR EACH cb-dmov WHERE cb-dmov.codcia  = s-codcia  AND
                           cb-dmov.periodo = s-periodo AND
                           cb-dmov.nromes  = s-NroMes  AND
                           cb-dmov.codcta  BEGINS (x-llave)  
                           NO-LOCK :
        /*Determinando la cuenta automatica */
        FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
                           cb-ctas.codcta = cb-dmov.codcta 
                           NO-LOCK NO-ERROR.
        IF avail cb-ctas  THEN DO: 
           IF x-genaut = 1 THEN DO:
              If cb-ctas.clfaux = "@CT" THEN x-an1cta = cb-dmov.codaux.
                 ELSE x-an1cta = cb-ctas.an1cta.                              
           END.  
           ELSE  x-an1cta = cb-ctas.an1cta.
           FIND cb-ctas WHERE cb-ctas.codcia =  cb-codcia  AND 
                              cb-ctas.codcta =  x-an1cta 
                              NO-LOCK NO-ERROR.
           IF NOT avail cb-ctas THEN DO:
              x-mensaje = "Cuenta Aut. no Registrada en Plan Ctas: " + x-an1cta.
              RUN imp-detalle.
              NEXT.
           END.                    
           x-cc1cta = cb-ctas.cc1cta.
           if x-cc1cta  = "" THEN  x-cc1cta = x-a-cc1cta.
           FIND cb-ctas WHERE cb-ctas.codcia =  cb-codcia  AND 
                              cb-ctas.codcta =  x-Cc1cta
                              NO-LOCK NO-ERROR.
           IF NOT avail cb-ctas THEN DO:
              x-mensaje = "Contra cuenta Aut. no Registrada en Plan Ctas: " + x-cc1cta.
              RUN imp-detalle.
              NEXT.
           END.                    
           l-an1cta = FALSE.
           l-cc1cta = FALSE.
           k = 0 .                  
           marca = FALSE.
           TOTAL = 0.
           FOR EACH detalle  WHERE  detalle.relacion = recid(cb-dmov) NO-LOCK : 
               IF DETALLE.TPOMOV THEN TOTAL = TOTAL - DETALLE.IMPMN1.
                  ELSE TOTAL = TOTAL + DETALLE.IMPMN1.
               IF detalle.tpoitm <> "A" then marca = TRUE.
               k = k + 1.
           END.            
           IF MARCA THEN DO:
              x-mensaje = "Cuenta aut. no marcada com <A>".
              {&NEW-PAGE}.
              RUN imp-detalle.
           END.
           IF TOTAL <> 0 THEN DO:
              x-mensaje = "Cuenta aut. mal generada".
              {&NEW-PAGE}.
              RUN imp-detalle.
           END.
           IF k > 2 THEN DO:
              x-mensaje = "Genero : " + string(k,"99") + "cuentas Automáticas".
              {&NEW-PAGE}. 
              RUN imp-detalle.           
           END.                                                                   
        END.
        ELSE  DO: 
           x-mensaje = "Cuenta Generadora no Registrada en Plan Ctas".
           {&NEW-PAGE}.
           RUN  imp-detalle.                              
        END.                        
            
    END. /*FIN  DEL FOR EACH cb-dmov */                                                                                               
    
END. /*FIN DEL DO  */

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
  DISPLAY R-CTAS C-1 C-2 RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-4 RECT-5 RECT-6 R-CTAS C-1 C-2 RADIO-SET-1 RB-NUMBER-COPIES 
         B-impresoras RB-BEGIN-PAGE RB-END-PAGE B-imprime B-cancela 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp-detalle DIALOG-1 
PROCEDURE imp-detalle :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 {&NEW-PAGE}. 
 DISPLAY STREAM report 
     cb-dmov.nromes 
     cb-dmov.codope  COLUMN-LABEL "Ope"
     cb-dmov.nroast
     cb-dmov.nroitm  COLUMN-LABEL "Itm"
     cb-dmov.codcta
     x-mensaje
     WITH FRAME f-cab.
 DOWN STREAM  report WITH FRAME f-cab.             
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
    DEFINE VAR k-mes as integer.
    
    P-largo = 66.
    P-Ancho = 210.
    P-Config = P-20cpi + P-8Lpi.
    max-error = 0.01.
    CASE R-CTAS :
         WHEN 2 THEN DO:
              RUN reg-auto.
              RETURN.
         END.
    
         WHEN 3 THEN DO:
              RUN TODAS-CTAS.
              RETURN.
         END.
         WHEN 4 THEN DO:
              RUN NO-AUTO.
              RETURN.
         END.                             
    END CASE.
        
    x-GenAut = 0.
    FIND cb-cfga WHERE codcia = cb-codcia NO-LOCK NO-ERROR.
    
    DO K-MES = C-1 TO C-2 :
        IF cb-cfga.genaut9  <> "" THEN DO: 
           x-GenAut   = 1.
           x-cta-auto = cb-cfga.genaut9.
           x-a-cc1cta   = cb-cfga.cc1cta9.
           RUN cons-reg(x-GenAut ,x-Cta-auto, x-a-cc1cta,K-MES).           
        END.   
             
        IF cb-cfga.genaut6  <> "" THEN DO:
           x-GenAut   = 2.
           x-cta-auto = cb-cfga.genaut6.
           x-a-cc1cta   = cb-cfga.cc1cta6.  
           RUN cons-reg(x-GenAut ,x-Cta-auto, x-a-cc1cta,K-MES).
        END.    
            
        IF cb-cfga.genaut  <> ""  THEN DO: 
           x-GenAut   = 3.
           x-cta-auto = cb-cfga.genaut.
           x-a-cc1cta   = "". 
           RUN cons-reg(x-GenAut ,x-Cta-auto, x-a-cc1cta,K-MES).
        END.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NO-AUTO DIALOG-1 
PROCEDURE NO-AUTO :
DEF VAR K-MES AS INTEGER.
 def var p-tipo as integer.
 DO K-MES = C-1 TO C-2 :
    FOR EACH cb-dmov no-lock WHERE 
                           cb-dmov.codcia  = s-codcia      AND
                           cb-dmov.periodo = s-periodo     AND
                           cb-dmov.nromes  = k-mes         AND
                           cb-dmov.tpoitm  = "A"        
                           BREAK BY cb-dmov.codcta     :
        find detalle where recid(detalle) = cb-dmov.relacion
             no-lock no-error.
        if avail detalle then do:                        
           p-tipo = ?.
           run adm/cb-tpoat.p( cb-codcia , 
                               detalle.codcta,
                               output p-tipo ).
                                          
           if p-tipo = ? then do:
               x-mensaje = "Cuenta generadora no es automática".
               {&NEW-PAGE}.
               RUN  imp-detalle.                              
           end.        
        
        end.
        else do:
             x-mensaje = "No existe Cuenta generadora".
             {&NEW-PAGE}.
             RUN  imp-detalle.                              
        end.       
        END. /*FIN  DEL FOR EACH cb-dmov */                                                                                               
 END.       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE REG-AUTO DIALOG-1 
PROCEDURE REG-AUTO :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 DEF VAR K-MES AS INTEGER.
 
 DO K-MES = C-1 TO C-2 :
 
    FOR EACH cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                           cb-ctas.AN1CTA <> "" 
                           BREAK BY cb-ctas.AN1CTA:
        IF FIRST-OF(AN1CTA) THEN DO:
           FIND FIRST cb-dmov WHERE cb-dmov.codcia  = s-codcia        AND
                                    cb-dmov.periodo = s-periodo           AND
                                    cb-dmov.nromes  = k-mes           AND
                                    cb-dmov.codcta  = cb-ctas.an1cta  AND
                                    cb-dmov.tpoitm  <> "A" 
                                    NO-LOCK NO-ERROR .
           DO WHILE AVAIL cb-dmov :                   
               x-mensaje = "Registro en Cuenta Automática".
               {&NEW-PAGE}.
               RUN  imp-detalle.                              
               FIND NEXT cb-dmov WHERE cb-dmov.codcia  = s-codcia        AND
                                        cb-dmov.periodo = s-periodo           AND
                                        cb-dmov.nromes  = k-mes           AND
                                        cb-dmov.codcta  = cb-ctas.an1cta  AND
                                        cb-dmov.tpoitm  <> "A" 
                                        NO-LOCK NO-ERROR. 
                     
           END.
        END.  /* FIN DEL FIRST-OF */                 
                           
    END. /* FIN DEL FOR EACH */                      
    FOR EACH cb-ctas WHERE cb-ctas.CODCIA = cb-codcia AND
                           cb-ctas.CC1CTA <> "" 
                           BREAK BY cb-ctas.CC1CTA:
        IF FIRST-OF(cc1CTA) THEN DO:
           FIND FIRST cb-dmov WHERE cb-dmov.codcia  = s-codcia        AND
                                    cb-dmov.periodo = s-periodo           AND
                                    cb-dmov.nromes  = k-mes           AND
                                    cb-dmov.codcta  = cb-ctas.CC1cta  AND
                                    cb-dmov.tpoitm  <> "A" 
                                    NO-LOCK NO-ERROR .
           DO WHILE AVAIL cb-dmov :                   
               x-mensaje = "Registro en Cuenta Automática".
               {&NEW-PAGE}.
               RUN  imp-detalle.                              
               FIND NEXT cb-dmov WHERE cb-dmov.codcia  = s-codcia        AND
                                        cb-dmov.periodo = s-periodo           AND
                                        cb-dmov.nromes  = k-mes           AND
                                        cb-dmov.codcta  = cb-ctas.CC1cta  AND
                                        cb-dmov.tpoitm  <> "A" 
                                        NO-LOCK NO-ERROR. 
                     
           END.
        END.  /* FIN DEL FIRST-OF */                 
                           
    END. /* FIN DEL FOR EACH */                      
    
    
 
 
     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TODAS-CTAS DIALOG-1 
PROCEDURE TODAS-CTAS :
DEF VAR K-MES AS INTEGER.
 
 DO K-MES = C-1 TO C-2 :
    FOR EACH cb-dmov no-lock WHERE cb-dmov.codcia  = s-codcia        AND
                                   cb-dmov.periodo = s-periodo           AND
                                   cb-dmov.nromes  = k-mes           
                           BREAK BY cb-dmov.codcta     :
        find cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
                           cb-ctas.codcta = cb-dmov.codcta 
                           NO-LOCK NO-ERROR.
        IF NOT avail cb-ctas  THEN 
           DO: 
               x-mensaje = "Cuenta no Registrada en Plan Ctas".
               {&NEW-PAGE}.
               RUN  imp-detalle.                              
           END.    
        END. /*FIN  DEL FOR EACH cb-dmov */                                                                                               
 END.       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

