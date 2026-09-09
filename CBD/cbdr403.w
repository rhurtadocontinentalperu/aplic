&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*
    @PRINTER2.W    VERSION 1.0
*/    
DEFINE STREAM report.


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
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE x-expres   AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-nomaux   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE x-nomcta   AS CHARACTER FORMAT "X(70)".
DEFINE VARIABLE x-nomclf   AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE imp-aux    AS LOGICAL.
DEFINE VARIABLE x-conreg   AS INTEGER.
/*MLR* 09/01/08 ***
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Cargos     ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-" 
                           LABEL "Abonos     ".
DEFINE VARIABLE x-saldoac  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Actual    ".
DEFINE VARIABLE x-saldoan  AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99-"
                           COLUMN-LABEL "Saldo     !Anterior   ".
*** */
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "->>>,>>>,>>9.99" 
                           LABEL "Cargos     ". 
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "->>>,>>>,>>9.99" 
                           LABEL "Abonos     ".
DEFINE VARIABLE x-saldoac  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
                           COLUMN-LABEL "Saldo     !Actual    ".
DEFINE VARIABLE x-saldoan  AS DECIMAL FORMAT "->>>,>>>,>>9.99"
                           COLUMN-LABEL "Saldo     !Anterior   ".



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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-5 RECT-4 x-codcta x-codmon ~
RADIO-SET-1 RB-BEGIN-PAGE RB-NUMBER-COPIES B-impresoras RB-END-PAGE ~
B-imprime BUTTON-1 B-cancela 
&Scoped-Define DISPLAYED-OBJECTS x-codcta x-codmon RADIO-SET-1 ~
RB-BEGIN-PAGE RB-NUMBER-COPIES RB-END-PAGE 

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

DEFINE BUTTON BUTTON-1 
     LABEL "Excel" 
     SIZE 11 BY 1.08.

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
     SIZE 31.57 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-codcta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Cuenta" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 10.14 BY 3 NO-UNDO.

DEFINE VARIABLE x-codmon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dólares", 2
     SIZE 10 BY 1.77 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 51.43 BY 3.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 51.43 BY 4.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 51.43 BY 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     x-codcta AT ROW 1.88 COL 7.43 COLON-ALIGNED
     x-codmon AT ROW 1.92 COL 36.29 NO-LABEL
     RADIO-SET-1 AT ROW 5.19 COL 2 NO-LABEL
     RB-BEGIN-PAGE AT ROW 5.23 COL 43.29 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 5.27 COL 22.14 COLON-ALIGNED
     B-impresoras AT ROW 6.19 COL 12.72
     RB-END-PAGE AT ROW 6.23 COL 43.29 COLON-ALIGNED
     b-archivo AT ROW 7.19 COL 12.72
     RB-OUTPUT-FILE AT ROW 7.46 COL 16.72 COLON-ALIGNED NO-LABEL
     B-imprime AT ROW 9.19 COL 5.86
     BUTTON-1 AT ROW 9.19 COL 19.86 WIDGET-ID 4
     B-cancela AT ROW 9.19 COL 34.57
     " Moneda" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 1.92 COL 26.29
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 51.29 BY .62 AT ROW 4.04 COL 1
          BGCOLOR 1 FGCOLOR 15 
     RECT-6 AT ROW 8.69 COL 1
     RECT-5 AT ROW 4.69 COL 1
     RECT-4 AT ROW 1.04 COL 1
     SPACE(0.00) SKIP(6.65)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4
         TITLE "Saldo de Cuentas".


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
ON GO OF FRAME DIALOG-1 /* Saldo de Cuentas */
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
    ASSIGN x-codmon.
  /*  
    IF x-formato = 1 THEN 
        DO:
        
   
            ASSIGN  x-clfaux.
            x-clfaux = CAPS(x-clfaux).
            IF NOT CAN-FIND(FIRST cb-dmov WHERE cb-dmov.clfaux = x-clfaux) THEN 
                DO: 
                    BELL.
                    MESSAGE "Clasificacion de auxiliar no tiene" SKIP
                        "movimiento" VIEW-AS ALERT-BOX ERROR.
                    APPLY "ENTRY" TO x-clfaux.
                    RETURN NO-APPLY.
                END.
            ELSE 
                CASE x-clfaux:
                WHEN "@CT" THEN
                    x-nomclf = "<< C U E N T A S >>".
                WHEN "@CL" THEN
                    x-nomclf = "<< C L I E N T E S >>".
                WHEN "@PV" THEN
                    x-nomclf = "<< P R O V E E D O R E S >>".
                OTHERWISE 
                    DO:
                        FIND cb-tabl WHERE cb-tabl.tabla = "01"
                                AND cb-tabl.codigo = x-clfaux
                                NO-LOCK NO-ERROR.                      
                        IF AVAILABLE cb-tabl THEN 
                            x-nomclf = "<< " + cb-tabl.nombre + " >>".
                        ELSE
                            x-nomclf = "CLASIFICACION SIN NOMBRE".
                    END.
                END CASE.    
            x-clfaux:SCREEN-VALUE = x-clfaux.
        END.
        ELSE 
            DO:
       */     
       
                ASSIGN  x-codcta.
                FIND  cb-ctas WHERE cb-ctas.codcta = x-codcta and
                                    cb-ctas.codcia = cb-codcia  
                                    no-lock no-error.
                IF NOT AVAIL cb-ctas                    
                THEN
                    DO: 
                        BELL.
                        MESSAGE "Cuenta no registrada" SKIP
                        VIEW-AS ALERT-BOX ERROR.
                        APPLY "ENTRY" TO x-codcta.
                        RETURN NO-APPLY.
                    END.
                x-nomcta = cb-ctas.codcta + " " + cb-ctas.nomcta.
                    
                    
         /*   
            END.
         */   
         
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 DIALOG-1
ON CHOOSE OF BUTTON-1 IN FRAME DIALOG-1 /* Excel */
DO:
    ASSIGN 
        x-codmon
        x-codcta.

    FIND  cb-ctas WHERE cb-ctas.codcta = x-codcta and
        cb-ctas.codcia = cb-codcia  NO-LOCK NO-ERROR.
    IF NOT AVAIL cb-ctas THEN DO: 
        MESSAGE "Cuenta no registrada" SKIP
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO x-codcta.
        RETURN NO-APPLY.
    END.
    x-nomcta = cb-ctas.codcta + " " + cb-ctas.nomcta.
    RUN excel.
  
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
ON MOUSE-SELECT-DBLCLICK OF x-codcta IN FRAME DIALOG-1 /* Cuenta */
or "F8" OF x-codcta DO:
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
  DISPLAY x-codcta x-codmon RADIO-SET-1 RB-BEGIN-PAGE RB-NUMBER-COPIES 
          RB-END-PAGE 
      WITH FRAME DIALOG-1.
  ENABLE RECT-6 RECT-5 RECT-4 x-codcta x-codmon RADIO-SET-1 RB-BEGIN-PAGE 
         RB-NUMBER-COPIES B-impresoras RB-END-PAGE B-imprime BUTTON-1 B-cancela 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.

    DEFINE VARIABLE pinta-mes AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-expres  AS CHARACTER   NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO DE CUENTAS".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = pinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-expres.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "COD AUX".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO ANTERIOR".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "CARGOS".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "ABONOS".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO ACT".


    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = x-codcta.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nomcta.
    
    chWorkSheet:Columns("A"):NumberFormat = "@".
    
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
        AND cb-dmov.periodo = s-periodo 
        AND cb-dmov.nromes <= s-NroMes
        AND cb-dmov.codcta  = x-codcta
        BREAK  BY cb-dmov.codaux ON ERROR UNDO, LEAVE:
        
        IF NOT tpomov THEN DO:
            CASE x-codmon:
                WHEN 1 THEN 
                    ASSIGN 
                        x-debe  = ImpMn1
                        x-haber = 0.
                WHEN 2 THEN 
                    ASSIGN 
                        x-debe  = ImpMn2
                        x-haber = 0.
            END CASE.
        END.
        ELSE DO:      
            CASE x-codmon:
                WHEN 1 THEN 
                    ASSIGN
                        x-debe  = 0
                        x-haber = ImpMn1.
                WHEN 2 THEN 
                    ASSIGN 
                        x-debe  = 0
                        x-haber = ImpMn2.
            END CASE.            
        END.

        IF NOT (x-haber = 0 AND x-debe = 0) AND x-haber <> ? AND x-debe <> ? THEN DO:
            IF cb-dmov.nromes = s-NroMes THEN DO:
                ACCUMULATE x-debe    (TOTAL). 
                ACCUMULATE x-haber   (TOTAL).
                ACCUMULATE x-debe    (SUB-TOTAL BY cb-dmov.codaux).
                ACCUMULATE x-haber   (SUB-TOTAL BY cb-dmov.codaux).
            END.
            ELSE DO:
                x-saldoan = x-debe - x-haber.
                ACCUMULATE x-saldoan (SUB-TOTAL BY cb-dmov.codaux).
                ACCUMULATE x-saldoan (TOTAL).
            END.
            x-saldoac = x-debe - x-haber.
            ACCUMULATE x-saldoac (SUB-TOTAL BY cb-dmov.codaux).
            ACCUMULATE x-saldoac (TOTAL).
        END.

        IF LAST-OF (cb-dmov.codaux) THEN DO:
            ASSIGN 
                x-saldoan = ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoan
                x-haber   = ACCUM SUB-TOTAL BY cb-dmov.codaux x-haber
                x-debe    = ACCUM SUB-TOTAL BY cb-dmov.codaux x-debe
                x-saldoac = ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoac.

            IF x-saldoan = 0 and x-haber = 0 and x-debe = 0 and x-saldoac = 0 THEN NEXT.

            x-nomaux = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    FIND gn-clie WHERE gn-clie.codcli = cb-dmov.codaux
                        AND gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR. 
                    IF AVAILABLE gn-clie THEN x-nomaux = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    FIND gn-prov WHERE gn-prov.codpro = cb-dmov.codaux
                        AND gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.                      
                    IF AVAILABLE gn-prov THEN x-nomaux = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codaux
                        AND cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                    IF AVAILABLE cb-ctas THEN x-nomaux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    FIND cb-auxi WHERE cb-auxi.clfaux = cb-dmov.clfaux
                        AND cb-auxi.codaux = cb-dmov.codaux
                        AND cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.                      
                    IF AVAILABLE cb-auxi THEN x-nomaux = cb-auxi.nomaux.
                END.
            END CASE.
            /************************/
            
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nomaux.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = x-saldoan.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = x-debe.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = x-haber.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = x-saldoac.

            x-debe    = 0.
            x-haber   = 0.
            x-saldoan = 0.
            x-saldoac = 0.
        END.
        IF LAST(cb-dmov.codaux) THEN DO:
            x-nomaux = "** TOTAL CUENTA " + X-CODCTA + " **".
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = x-nomaux.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL x-saldoan.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL x-debe.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL x-haber.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = ACCUM TOTAL x-saldoac.
        END.
    END.            

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


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
   P-Config = P-20cpi.
/*
    IF x-formato = 1 THEN DO:
        RUN proceso1.
    END.
    ELSE DO:
        RUN proceso2.
    END.
*/
   run proceso2.
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO1 DIALOG-1 
PROCEDURE PROCESO1 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".
    DEFINE FRAME f-cab
        cb-dmov.codcta  LABEL "Cuenta"
        x-nomcta        LABEL "Descripcion"
        x-saldoan  
        x-debe     
        x-haber  
        x-saldoac
        HEADER
        s-nomcia
        "S A L D O   D E   C U E N T A S" AT 43
        /*"FECHA : " TO 107 TODAY TO 115*/
        SKIP
     /*   
        empresas.direccion
     */   
        pinta-mes  AT 43
        "PAGINA :" TO 106 c-pagina FORMAT "ZZ9" TO 115
        x-expres   AT 38
        x-nomclf   AT 33
        SKIP(2)
        WITH WIDTH 115 NO-BOX DOWN STREAM-IO. 
    P-Ancho  = FRAME f-cab:WIDTH.
    x-Raya   = FILL("-", P-Ancho).
    RUN bin/_centrar.p ( INPUT pinta-mes, 30 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    RUN bin/_centrar.p ( INPUT x-nomclf,  50 , OUTPUT x-nomclf ).
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-codcia
                            AND cb-dmov.periodo = s-periodo 
                            AND cb-dmov.nromes <= s-NroMes
                         /*   
                            AND cb-dmov.clfaux  = x-clfaux
                          */  
                            
            BREAK BY cb-dmov.codaux
                  BY cb-dmov.codcta ON ERROR UNDO, LEAVE:
        IF FIRST-OF (cb-dmov.codaux) THEN DO:
            x-nomaux = "".
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
            x-nomaux = cb-dmov.codaux + " " + x-nomaux.
            imp-aux  = YES.
        END.
        IF FIRST-OF (cb-dmov.codcta) THEN DO:
            find cb-ctas WHERE cb-ctas.codcia = cb-codcia
                            AND cb-ctas.codcta = cb-dmov.codcta
                            NO-LOCK NO-ERROR.
            IF AVAILABLE cb-ctas THEN
                x-nomcta =  cb-ctas.nomcta.
            x-debe  = 0.
            x-haber = 0.
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
        
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-haber <> ? AND x-debe <> ?
        THEN DO:
            IF cb-dmov.nromes = s-NroMes THEN DO:
                ACCUMULATE x-debe    (SUB-TOTAL BY cb-dmov.codcta).
                ACCUMULATE x-haber   (SUB-TOTAL BY cb-dmov.codcta).
                ACCUMULATE x-debe    (SUB-TOTAL BY cb-dmov.codaux).
                ACCUMULATE x-haber   (SUB-TOTAL BY cb-dmov.codaux).
                x-saldoac = x-debe - x-haber.
                ACCUMULATE x-saldoac (SUB-TOTAL BY cb-dmov.codcta).
                ACCUMULATE x-saldoac (SUB-TOTAL BY cb-dmov.codaux).
            END.
            ELSE DO:
                x-saldoan = x-debe - x-haber.
                ACCUMULATE x-saldoan (SUB-TOTAL BY cb-dmov.codcta).
                ACCUMULATE x-saldoan (SUB-TOTAL BY cb-dmov.codaux).
            END.
        END.
        IF LAST-OF (cb-dmov.codcta) THEN DO:
            x-saldoan = ACCUM SUB-TOTAL BY cb-dmov.codcta x-saldoan.
            x-haber   = ACCUM SUB-TOTAL BY cb-dmov.codcta x-haber.
            x-debe    = ACCUM SUB-TOTAL BY cb-dmov.codcta x-debe.
            x-saldoac = ACCUM SUB-TOTAL BY cb-dmov.codcta x-saldoac.
            IF NOT ( x-saldoan = 0 AND x-debe = 0 AND x-haber = 0 ) THEN DO:
                IF imp-aux THEN DO:
                    {&NEW-PAGE}.
                    DISPLAY STREAM report WITH FRAME f-cab.
                    PUT STREAM report CONTROL P-dobleon.
                    PUT STREAM report x-nomaux.
                    PUT STREAM report CONTROL P-dobleoff.
                    DOWN STREAM report WITH FRAME f-cab.
                    imp-aux = NO.
                END.
                {&NEW-PAGE}.
                DISPLAY STREAM report cb-dmov.codcta
                                             x-nomcta
                                             x-saldoan  
                                             x-debe     WHEN x-debe <> 0  
                                             x-haber    WHEN x-debe <> 0
                                             x-saldoac
                              WITH FRAME f-cab.
                DOWN STREAM report WITH FRAME f-cab.              
                x-conreg = x-conreg + 1.
            END.  
        END.            
        IF LAST-OF (cb-dmov.codaux) AND x-conreg > 0 THEN DO:
            x-nomcta = "** TOTAL AUXILIAR " + cb-dmov.codaux + " **".
            {&NEW-PAGE}.  
            DISPLAY STREAM report "----------" @ cb-dmov.codcta
                          "----------------------------------------" @ x-nomcta
                          "---------------" @ x-saldoan  
                          "---------------" @ x-debe 
                          "---------------" @ x-haber
                          "---------------" @ x-saldoac
                    WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
            DISPLAY STREAM report
                        x-nomcta                                     @ x-nomcta
                         ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoan @ x-saldoan
                         ACCUM SUB-TOTAL BY cb-dmov.codaux x-haber   @ x-haber
                         ACCUM SUB-TOTAL BY cb-dmov.codaux x-debe    @ x-debe
                         ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoac @ x-saldoac
                WITH FRAME f-cab.
            DOWN STREAM report 1 WITH FRAME f-cab.
            {&NEW-PAGE}.
            DISPLAY STREAM report "==========" @ cb-dmov.codcta
                          "========================================" @ x-nomcta
                          "===============" @ x-saldoan  
                          "===============" @ x-debe 
                          "===============" @ x-haber
                          "===============" @ x-saldoac
                    WITH FRAME f-cab.
            DOWN STREAM report WITH FRAME f-cab.        
            x-conreg = 0.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESO2 DIALOG-1 
PROCEDURE PROCESO2 :
RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
    pinta-mes = "MES DE " + pinta-mes + " DE " + STRING( s-periodo , "9999" ).
    IF x-codmon = 1 THEN x-expres = "(EXPRESADO EN NUEVOS SOLES)".
    ELSE x-expres = "(EXPRESADO EN DOLARES)".
    DEFINE FRAME f-cab
        cb-dmov.codaux  LABEL "Auxiliar"
        x-nomaux        LABEL "Descripcion"
        x-saldoan  
        x-debe
        x-haber  
        x-saldoac
        HEADER
        s-nomcia
        "S A L D O   D E   C U E N T A S" AT 48
        /*"FECHA : " TO 117 TODAY TO 125*/
        SKIP
      /*  empresas.direccion*/
        pinta-mes  AT 48
        "PAGINA :" TO 117 c-pagina FORMAT "ZZ9" TO 125
        x-expres   AT 43
        SKIP(2)
        WITH WIDTH 126 NO-BOX DOWN STREAM-IO. 
    P-Ancho  = FRAME f-cab:WIDTH.
    x-Raya   = FILL("-", P-Ancho).
    RUN bin/_centrar.p ( INPUT pinta-mes, 30 , OUTPUT pinta-mes).
    RUN bin/_centrar.p ( INPUT x-expres,  40 , OUTPUT x-expres ).
    HIDE FRAME f-aviso NO-PAUSE.
    {&NEW-PAGE}.
    DISPLAY STREAM report WITH FRAME f-cab.
    PUT STREAM report CONTROL P-dobleon.
    PUT STREAM report x-nomcta.
    PUT STREAM report CONTROL P-dobleoff.
    DOWN STREAM report WITH FRAME f-cab.

x-debe    = 0.
x-haber   = 0.
x-saldoan = 0.
x-saldoac = 0.


DO WITH FRAME F-CAB :
        
    FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = s-codcia
                            AND cb-dmov.periodo = s-periodo 
                            AND cb-dmov.nromes <= s-NroMes
                            AND cb-dmov.codcta  = x-codcta
            BREAK  BY cb-dmov.codaux ON ERROR UNDO, LEAVE:
        
        IF FIRST-OF (cb-dmov.codaux) THEN DO:
            
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
        IF NOT (x-haber = 0 AND x-debe = 0) AND x-haber <> ? AND x-debe <> ?
        THEN DO:
        
            IF cb-dmov.nromes = s-NroMes THEN DO:
                ACCUMULATE x-debe    (TOTAL). 
                ACCUMULATE x-haber   (TOTAL).
                ACCUMULATE x-debe    (SUB-TOTAL BY cb-dmov.codaux).
                ACCUMULATE x-haber   (SUB-TOTAL BY cb-dmov.codaux).
            END.
            ELSE DO:
                x-saldoan = x-debe - x-haber.
                ACCUMULATE x-saldoan (SUB-TOTAL BY cb-dmov.codaux).
                ACCUMULATE x-saldoan (TOTAL).
            END.
            x-saldoac = x-debe - x-haber.
            ACCUMULATE x-saldoac (SUB-TOTAL BY cb-dmov.codaux).
            ACCUMULATE x-saldoac (TOTAL).
        END.
        IF LAST-OF (cb-dmov.codaux) THEN DO:

            x-saldoan = ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoan.
            x-haber   = ACCUM SUB-TOTAL BY cb-dmov.codaux x-haber.
            x-debe    = ACCUM SUB-TOTAL BY cb-dmov.codaux x-debe.
            x-saldoac = ACCUM SUB-TOTAL BY cb-dmov.codaux x-saldoac.

            IF x-saldoan = 0 and x-haber = 0 and x-debe = 0 and x-saldoac = 0 THEN NEXT.
/***********************/

            x-nomaux = "".
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
/************************/

            
                {&NEW-PAGE}.
                DISPLAY STREAM report cb-dmov.codaux
                                             x-nomaux
                                             x-saldoan
                                             x-debe       WHEN x-debe  <> 0   
                                             x-haber      WHEN x-haber <> 0
                                             x-saldoac
                              WITH FRAME f-cab.
                DOWN STREAM report WITH FRAME f-cab.              

            x-debe    = 0.
            x-haber   = 0.
            x-saldoan = 0.
            x-saldoac = 0.


        END.            
END.

                underline STREAM report 
                               x-nomaux
                               x-saldoan 
                               x-debe  
                               x-haber 
                               x-saldoac 
                              WITH FRAME f-cab.
                              
                DOWN STREAM report WITH FRAME f-cab.              

                {&NEW-PAGE}.
                x-nomaux = "** TOTAL CUENTA " + X-CODCTA + " **".
                DISPLAY STREAM report 
                                             x-nomaux
                               ACCUM TOTAL   x-saldoan  @ x-saldoan
                               ACCUM TOTAL   x-debe     @ x-debe  
                               ACCUM TOTAL   x-haber    @ x-haber  
                               ACCUM TOTAL   x-saldoac  @ x-saldoac
                              WITH FRAME f-cab.
                              
                DOWN STREAM report WITH FRAME f-cab.              



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

