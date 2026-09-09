&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/* Local Variable Definitions ---                                       */
/*
    @PRINTER2.W    VERSION 1.0
*/
{lib/def-prn.i}    
DEFINE STREAM report.
/*DEFINE VARIABLE x-Raya     AS CHARACTER FORMAT "X(145)".
DEFINE {&NEW} SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE {&NEW} SHARED VARIABLE s-user-id  LIKE _user._userid.*/

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-TIPO   AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.


def temp-table t-codven01 field codven as char init ""
                          field desven as char init ""
                          field acc-soles as deci init 0
                          field acc-dolar as deci init 0
                          field acc-dolar-pen as deci init 0
                          field acc-dolar-anu as deci init 0
                          field acc-dolar-ate as deci init 0
                          field acc-dolar-des as deci init 0
/*ML01*/                    FIELDS acc-dolar-ven AS DECI INIT 0
/*ML01*/                    FIELDS acc-dolar-pap AS DECI INIT 0
                          field iColumn as integer init 0
                          field acc-dolar-ped as deci init 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 r-tipo f-desde f-hasta RADIO-SET-1 ~
B-impresoras RB-NUMBER-COPIES RB-BEGIN-PAGE Btn_OK RB-END-PAGE Btn_Cancel ~
RECT-41 RECT-43 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS r-tipo FILL-IN-3 f-desde f-hasta ~
RADIO-SET-1 RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "" 
     SIZE 5.57 BY 1.42 TOOLTIP "Exportar a Excel - más simple, rápido e innovador - SISTEMAS siempre contigo".

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-NUMBER-COPIES AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "No. Copias" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-OUTPUT-FILE AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE r-tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Listado General", 1,
"Por Vendedor", 2
     SIZE 16.14 BY 1.42 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 3.27.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.86 BY 4.04.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.14 BY 6.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BUTTON-2 AT ROW 9.08 COL 55
     r-tipo AT ROW 2.54 COL 7.57 NO-LABEL
     FILL-IN-3 AT ROW 1.38 COL 1.86
     f-desde AT ROW 3.15 COL 39.43 COLON-ALIGNED
     f-hasta AT ROW 3.15 COL 56 COLON-ALIGNED
     RADIO-SET-1 AT ROW 6 COL 4.14 NO-LABEL
     B-impresoras AT ROW 7.04 COL 17.29
     b-archivo AT ROW 8.04 COL 17.43
     RB-OUTPUT-FILE AT ROW 8.19 COL 21.29 COLON-ALIGNED NO-LABEL
     RB-NUMBER-COPIES AT ROW 9.73 COL 11.86 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 9.73 COL 26.57 COLON-ALIGNED
     Btn_OK AT ROW 5.15 COL 56
     RB-END-PAGE AT ROW 9.73 COL 40.72 COLON-ALIGNED
     Btn_Cancel AT ROW 6.88 COL 56.14
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .62 AT ROW 2.27 COL 46
          FONT 6
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 49.86 BY .62 AT ROW 5.08 COL 2.86
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 9.12 COL 35
          FONT 6
     RECT-41 AT ROW 1.15 COL 1.43
     RECT-43 AT ROW 4.69 COL 54.57
     RECT-5 AT ROW 4.65 COL 2.14
     SPACE(19.43) SKIP(0.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte De Cotizaciones Oficina".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte De Cotizaciones Oficina */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-archivo D-Dialog
ON CHOOSE OF b-archivo IN FRAME D-Dialog /* Archivos.. */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-impresoras D-Dialog
ON CHOOSE OF B-impresoras IN FRAME D-Dialog
DO:
    SYSTEM-DIALOG PRINTER-SETUP.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN f-Desde f-hasta R-tipo.

  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
  IF R-tipo = 1  THEN T-tipo = "Relacion General " .
  IF R-tipo = 2  THEN T-tipo = "Por Vendedor     " .

  P-largo   = 66.
  P-Copias  = INPUT FRAME D-DIALOG RB-NUMBER-COPIES.
  P-pagIni  = INPUT FRAME D-DIALOG RB-BEGIN-PAGE.
  P-pagfin  = INPUT FRAME D-DIALOG RB-END-PAGE.
  P-select  = INPUT FRAME D-DIALOG RADIO-SET-1.
  P-archivo = INPUT FRAME D-DIALOG RB-OUTPUT-FILE.
  P-detalle = "Impresora Local (EPSON)".
  P-name    = "Epson E/F/J/RX/LQ".
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 D-Dialog
ON CHOOSE OF BUTTON-2 IN FRAME D-Dialog
DO:
  assign f-desde f-hasta.
  RUN GRAFICO.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
ASSIGN FILL-IN-3 = S-CODDIV
       F-DESDE   = TODAY
       F-HASTA   = TODAY .
       R-TIPO.
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

  FRAME F-Mensaje:TITLE =  FRAME D-DIALOG:TITLE.
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
  SESSION:IMMEDIATE-DISPLAY =   l-immediate-display.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal D-Dialog 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY r-tipo FILL-IN-3 f-desde f-hasta RADIO-SET-1 RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE BUTTON-2 r-tipo f-desde f-hasta RADIO-SET-1 B-impresoras 
         RB-NUMBER-COPIES RB-BEGIN-PAGE Btn_OK RB-END-PAGE Btn_Cancel RECT-41 
         RECT-43 RECT-5 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
    
 DEFINE FRAME f-cab
        FacCpedi.NroPed FORMAT "XXX-XXXXXX"
        FacCpedi.FchPed 
        FacCpedi.NomCli FORMAT "X(30)"
        FacCpedi.RucCli FORMAT "X(8)"
        FacCpedi.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        FacCpedi.ImpBrt FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpDto FORMAT "->>,>>9.99"
        FacCpedi.ImpVta FORMAT "->,>>>,>>9.99"
        FacCpedi.ImpIgv FORMAT "->>,>>9.99"
        FacCpedi.ImpTot FORMAT "->,>>>,>>9.99"
        X-EST           FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "RESUMEN DE PEDIDOS DE OFICINA"  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 96 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 109 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-TIPO AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 124 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "    No.      FECHA                                                       T O T A L      TOTAL       VALOR                  P R E C I O        " SKIP
        "  PEDIDO    EMISION   C L I E N T E                   R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA       I.G.V.      V E N T A   ESTADO" SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.

 PUT CONTROL {&PRN0} + {&PRN5A} + CHR(62) + {&PRN3}.       

 FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "PED"    AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta 
         
     BY FacCpedi.NroPed:

     IF FacCpedi.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".

     CASE FacCpedi.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + FacCpedi.ImpBrt.   
                w-totdsc [1] = w-totdsc [1] + FacCpedi.ImpDto.
                w-totval [1] = w-totval [1] + FacCpedi.ImpVta.
                w-totigv [1] = w-totigv [1] + FacCpedi.ImpIgv.
                w-totven [1] = w-totven [1] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + FacCpedi.ImpBrt.   
                w-totdsc [2] = w-totdsc [2] + FacCpedi.ImpDto.
                w-totval [2] = w-totval [2] + FacCpedi.ImpVta.
                w-totigv [2] = w-totigv [2] + FacCpedi.ImpIgv.
                w-totven [2] = w-totven [2] + FacCpedi.ImpTot.                
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + FacCpedi.ImpBrt.   
                w-totdsc [3] = w-totdsc [3] + FacCpedi.ImpDto.
                w-totval [3] = w-totval [3] + FacCpedi.ImpVta.
                w-totigv [3] = w-totigv [3] + FacCpedi.ImpIgv.
                w-totven [3] = w-totven [3] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + FacCpedi.ImpBrt.   
                w-totdsc [4] = w-totdsc [4] + FacCpedi.ImpDto.
                w-totval [4] = w-totval [4] + FacCpedi.ImpVta.
                w-totigv [4] = w-totigv [4] + FacCpedi.ImpIgv.
                w-totven [4] = w-totven [4] + FacCpedi.ImpTot.                
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF FacCpedi.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + FacCpedi.ImpBrt.   
                w-totdsc [5] = w-totdsc [5] + FacCpedi.ImpDto.
                w-totval [5] = w-totval [5] + FacCpedi.ImpVta.
                w-totigv [5] = w-totigv [5] + FacCpedi.ImpIgv.
                w-totven [5] = w-totven [5] + FacCpedi.ImpTot.
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + FacCpedi.ImpBrt.   
                w-totdsc [6] = w-totdsc [6] + FacCpedi.ImpDto.
                w-totval [6] = w-totval [6] + FacCpedi.ImpVta.
                w-totigv [6] = w-totigv [6] + FacCpedi.ImpIgv.
                w-totven [6] = w-totven [6] + FacCpedi.ImpTot.                
             END.                
          END.   
     END.        
               
     DISPLAY STREAM REPORT 
        FacCpedi.NroPed 
        FacCpedi.FchPed 
        FacCpedi.NomCli 
        FacCpedi.RucCli 
        FacCpedi.Codven
        X-MON           
        FacCpedi.ImpVta 
        FacCpedi.ImpDto 
        FacCpedi.ImpBrt 
        FacCpedi.ImpIgv 
        FacCpedi.ImpTot 
        X-EST WITH FRAME F-Cab.

 END.
 DO WHILE LINE-COUNTER(REPORT) < PAGE-SIZE(REPORT) - 8 :
    PUT STREAM REPORT "" skip. 
 END. 
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES        DOLARES   " SPACE(4) "TOTAL PENDIENTES       SOLES        DOLARES   " SPACE(4) "TOTAL ANULADAS         SOLES        DOLARES   " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(4) "----------------------------------------------" SPACE(4) "----------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->,>>>,>>9.99" w-totbru[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 119 FORMAT "->,>>>,>>9.99" w-totbru[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->,>>>,>>9.99" w-totdsc[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 119 FORMAT "->,>>>,>>9.99" w-totdsc[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->,>>>,>>9.99" w-totval[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 119 FORMAT "->,>>>,>>9.99" w-totval[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->,>>>,>>9.99" w-totigv[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 119 FORMAT "->,>>>,>>9.99" w-totigv[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->,>>>,>>9.99" w-totven[2] AT 84  FORMAT "->,>>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 119 FORMAT "->,>>>,>>9.99" w-totven[6] AT 134 FORMAT "->,>>>,>>9.99" SKIP.

 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 D-Dialog 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.
 DEFINE FRAME f-cab
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles   FORMAT ">>,>>>,>>>,>>9.99" 
        x-dolares FORMAT ">>,>>>,>>>,>>9.99" 
        x-flgest  FORMAT "X(3)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "REPORTE DE COTIZACIONES DE OFICINA"  AT 40 FORMAT "X(37)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 89 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 102 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-TIPO AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 114 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                               " SKIP
        "  Numero     Fecha       Codigo        Razon Social                           Vendedor             SOLES       DOLARES  EST    " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH FacCpedi NO-LOCK WHERE
           FacCpedi.CodCia = S-CODCIA AND
           FacCpedi.CodDiv = S-CODDIV AND
           FacCpedi.CodDoc = "COT"    AND
           FacCpedi.FchPed >= F-desde AND
           FacCpedi.FchPed <= F-hasta 
           BREAK BY Nroped :
           

     {&new-page}.
     X-SOLES   = 0.
     X-DOLARES = 0.
     
     CASE FaccPedi.FlgEst:
          WHEN "A" THEN x-flgest = "ANU" .
          WHEN "C" THEN x-flgest = "ATE" .
          WHEN "P" THEN x-flgest = "PEN" .
          WHEN "V" THEN x-flgest = "VEN" .
     END CASE.         

     IF FaccPedi.FlgEst <> 'A' THEN DO:
      IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
      IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
     END.
    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.

     DISPLAY STREAM REPORT 
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles
        x-dolares
        x-flgest
        WITH FRAME F-Cab.
        
     
 END.
   PUT STREAM REPORT " " SKIP.  
   PUT STREAM REPORT   "T O T A L   P E R I O D O     : "  AT 40.
   PUT STREAM REPORT  TX-SOLES format ">>,>>>,>>9.99" AT 85.
   PUT STREAM REPORT  TX-DOLARES format ">>,>>>,>>9.99" AT 110.

 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 D-Dialog 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.
 DEFINE VAR x-desven  AS CHAR.

 DEFINE FRAME f-cab
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles   FORMAT ">>,>>>,>>>,>>9.99" 
        x-dolares FORMAT ">>,>>>,>>>,>>9.99" 
        x-flgest  FORMAT "X(3)"

        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + FacCpedi.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + "REPORTE DE COTIZACIONES DE OFICINA"  AT 40 FORMAT "X(37)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 89 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 102 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-TIPO AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 114 STRING(TIME,"HH:MM:SS") SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                                               " SKIP
        "  Numero     Fecha       Codigo        Razon Social                           Vendedor             SOLES       DOLARES  EST    " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 
       
  FOR EACH FacCpedi NO-LOCK WHERE
           FacCpedi.CodCia = S-CODCIA AND
           FacCpedi.CodDiv = S-CODDIV AND
           FacCpedi.CodDoc = "COT"    AND
           FacCpedi.FchPed >= F-desde AND
           FacCpedi.FchPed <= F-hasta 
           BREAK BY CodVen 
                 BY NroPed:

      
     {&new-page}.
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
   /*  DOWN STREAM REPORT WITH FRAME F-cab.*/

     X-SOLES = 0.
     X-DOLARES = 0.
     CASE FaccPedi.FlgEst:
          WHEN "A" THEN x-flgest = "ANU" .
          WHEN "C" THEN x-flgest = "ATE" .
          WHEN "P" THEN x-flgest = "PEN" .
          WHEN "V" THEN x-flgest = "VEN" .
     END CASE.         

     IF FaccPedi.FlgEst <> 'A' THEN DO:
       IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
       IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
     END.
    ACCUM X-SOLES   (SUB-TOTAL BY FaccPedi.CodVen).   
    ACCUM X-DOLARES (SUB-TOTAL BY FaccPedi.CodVen).   

    TX-SOLES = TX-SOLES + X-SOLES.
    TX-DOLARES = TX-DOLARES + X-DOLARES.
    
    IF FIRST-OF(FaccPedi.CodVen) THEN DO:
       FIND GN-VEN WHERE GN-VEN.CODCIA = S-CODCIA AND
                         GN-VEN.CODVEN = FaccPedi.CodVen
                         NO-LOCK NO-ERROR.
       x-desven = " ".
       IF AVAILABLE GN-VEN THEN x-desven = GN-VEN.NOMVEN .                 
       
       PUT STREAM REPORT  " VENDEDOR  :  "  FaccPedi.CodVen " " x-desven  FORMAT "X(100)" SKIP. 
       PUT STREAM REPORT  " ------------------------------------------------------ "   SKIP.
       /*PUT STREAM REPORT " " SKIP. */

     END.


     DISPLAY STREAM REPORT 
        FaccPedi.Nroped
        FaccPedi.FchPed
        FaccPedi.CodCli
        FaccPedi.Nomcli
        FaccPedi.CodVen
        x-soles
        x-dolares
        x-flgest
        WITH FRAME F-Cab.
   
    /*  DOWN STREAM REPORT WITH FRAME F-cab.*/
      
      IF LAST-OF(faccPedi.CodVen) THEN DO:
        UNDERLINE STREAM REPORT 
            x-soles format ">,>>>,>>9.99"
            x-dolares format ">,>>>,>>9.99"
        WITH FRAME F-CAB.
        DISPLAY STREAM REPORT 
            ("TOTAL  : " + FaccPedi.CodVen) @ FaccPedi.Nomcli
            (ACCUM SUB-TOTAL BY FaccPedi.CodVen x-soles ) @ x-soles 
            (ACCUM SUB-TOTAL BY FaccPedi.CodVen x-dolares) @ x-dolares SKIP
            
            WITH FRAME F-CAB.
      END.   
    

 END.
 PUT STREAM REPORT " " SKIP.
 PUT STREAM REPORT "T O T A L    P E R I O D O    : "  AT 40 .
 PUT STREAM REPORT TX-SOLES    AT 85  FORMAT ">>,>>>,>>>,>>9.99" .
 PUT STREAM REPORT TX-DOLARES  AT 105 FORMAT ">>,>>>,>>>,>>9.99" .


 CASE s-salida-impresion:
      WHEN 1 OR WHEN 3 THEN RUN LIB/d-README.R(s-print-file). 
 END CASE.                                             
 OUTPUT STREAM REPORT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 D-Dialog 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-soles   AS DECIMAL INIT 0.   
 DEFINE VAR x-dolares AS DECIMAL INIT 0.   
 DEFINE VAR TX-soles   AS DECIMAL INIT 0.   
 DEFINE VAR Tx-dolares AS DECIMAL INIT 0.   
 DEFINE VAR x-flgest  AS CHAR.

   FOR EACH FacCpedi NO-LOCK WHERE
           FacCpedi.CodCia = S-CODCIA AND
           FacCpedi.CodDiv = S-CODDIV AND
           FacCpedi.CodDoc = "COT"    AND
           FacCpedi.FchPed >= F-desde AND
           FacCpedi.FchPed <= F-hasta 
           BREAK BY Nroped :


     X-SOLES   = 0.
     X-DOLARES = 0.
     IF FaccPedi.FlgEst <> 'A' THEN DO:
     IF FaccPedi.CodMon = 1 THEN X-SOLES   = FaccPedi.ImpTot.
     IF FaccPedi.CodMon = 2 THEN X-DOLARES = FaccPedi.ImpTot.
     end.

      CASE FaccPedi.FlgEst:
           WHEN "A" THEN x-flgest = "ANU" .
           WHEN "C" THEN x-flgest = "ATE" .
           WHEN "P" THEN x-flgest = "PEN" .
           WHEN "V" THEN x-flgest = "VEN" .
      END CASE.         


export delimiter "|"
         FaccPedi.Nroped
         FaccPedi.FchPed
         FaccPedi.CodCli
         FaccPedi.Nomcli
         FaccPedi.CodVen
         x-soles
         x-dolares
         x-flgest.
         end.




 OUTPUT STREAM REPORT CLOSE.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grafico D-Dialog 
PROCEDURE Grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".
DEFINE BUFFER b-faccpedi for faccpedi.


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/*ML01* ***
/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.
*ML01* ***/

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 6.
chWorkSheet:Columns("B"):ColumnWidth = 30.
chWorkSheet:Columns("C"):ColumnWidth = 20.
chWorkSheet:Columns("D"):ColumnWidth = 20.
chWorkSheet:Columns("E"):ColumnWidth = 20.
chWorkSheet:Columns("F"):ColumnWidth = 20.
chWorkSheet:Columns("G"):ColumnWidth = 20.


chWorkSheet:Range("A1:G1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Nombre".
chWorkSheet:Range("C1"):Value = "Acum US$ Ate".
chWorkSheet:Range("D1"):Value = "Acum US$ Pen".
chWorkSheet:Range("E1"):Value = "Acum US$ Des".
/*ML01* ***
chWorkSheet:Range("F1"):Value = "Acum US$ Todas".
chWorkSheet:Range("G1"):Value = "Acum US$ Pedidos".
*ML01* ***/
/*ML01*/ chWorkSheet:Range("F1"):Value = "Acum US$ Vencidos".
/*ML01*/ chWorkSheet:Range("G1"):Value = "Acum US$ X Aprobar".
/*ML01*/ chWorkSheet:Range("H1"):Value = "Acum US$ Todas".
/*ML01*/ chWorkSheet:Range("I1"):Value = "Acum US$ Pedidos".


/*********************** poniendo titulos en pagina 2 ***********/

chWorkSheet = chExcelApplication:Sheets:Item("hoja2").

/* set the column names for the Worksheet */
chWorkSheet:Columns("A"):ColumnWidth = 10.
chWorkSheet:Columns("B"):ColumnWidth = 9.
chWorkSheet:Columns("C"):ColumnWidth = 12.
chWorkSheet:Columns("D"):ColumnWidth = 8.
chWorkSheet:Columns("E"):ColumnWidth = 40.
chWorkSheet:Columns("F"):ColumnWidth = 10.
chWorkSheet:Columns("G"):ColumnWidth = 10.
chWorkSheet:Columns("H"):ColumnWidth = 10.
chWorkSheet:Columns("I"):ColumnWidth = 10.
chWorkSheet:Columns("J"):ColumnWidth = 10.

chWorkSheet:Range("A1: J1"):Font:Bold = TRUE.
chWorkSheet:Range("A1"):Value = "Codigo".
chWorkSheet:Range("B1"):Value = "Numero".
chWorkSheet:Range("C1"):Value = "Fecha".
chWorkSheet:Range("D1"):Value = "Codcli".
chWorkSheet:Range("E1"):Value = "Razon Social".
chWorkSheet:Range("F1"):Value = "Vendedor".
chWorkSheet:Range("G1"):Value = "Soles".
chWorkSheet:Range("H1"):Value = "Dolares".
chWorkSheet:Range("I1"):Value = "Estado".
chWorkSheet:Range("J1"):Value = "Pedidos en Dolares".


/* cambia de hoja  */

chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */

FOR EACH faccpedi where faccpedi.codcia = S-CODCIA
                    and faccpedi.coddiv = S-CODDIV
                    and faccpedi.coddoc = "COT"
                    and faccpedi.flgest ne "A"
                    and faccpedi.fchped >= F-DESDE
                    and faccpedi.fchped <= F-HASTA 
                    NO-LOCK:
                    
find  t-codven01 where t-codven01.codven = faccpedi.codven no-lock no-error.

if not avail t-codven01 then do: 
    find gn-ven  where gn-ven.codcia = 1
                  and  gn-ven.codven = faccpedi.codven no-lock no-error.
    if not avail gn-ven then         
    message "ERROR CODIGO DE VENDEDOR NO REGISTRADO" skip
            faccpedi.codven    skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box . 

    create t-codven01.
    t-codven01.codven = faccpedi.codven.
    if available gn-ven then t-codven01.desven = gn-ven.NomVen.
    t-Column = t-Column + 1.
    iColumn = t-Column.
end.

 x-valor = faccpedi.Imptot.
 if codmon = 1 then x-valor = x-valor / faccpedi.tpocmb.
 
 acc-dolar = acc-dolar + x-valor.

 case faccpedi.flgest:
   when "A" then  assign acc-dolar-anu = acc-dolar-anu + x-valor
                         f-estado = "ANULADO".
   when "P" then  assign acc-dolar-pen = acc-dolar-pen + x-valor
                         f-estado = "PENDIENTE".
   when "C" then  assign acc-dolar-ate = acc-dolar-ate + x-valor
                         f-estado = "ATENDIDO".
   when "X" then  assign acc-dolar-des = acc-dolar-des + x-valor
                         f-estado = "CERRADA".
/*ML01* Inicio de bloque ***/
   when "V" then  assign acc-dolar-ven = acc-dolar-ven + x-valor
                         f-estado = "VENCIDO".
   when "E" then  assign acc-dolar-pap = acc-dolar-pap + x-valor
                         f-estado = "X APROBAR".
/*ML01* Fin de bloque ***/
   otherwise 
   message "ERROR TIPO DE ESTADO NO REGISTRADO" skip
            faccpedi.codcia faccpedi.coddiv faccpedi.coddoc faccpedi.nroped faccpedi.FLGEST   skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box . 
  
 end.
    
if lookup(string(codmon),"1,2") = 0 then
    message "ERROR TIPO DE MONEDA NO REGISTRADO" skip
            faccpedi.codcia faccpedi.coddiv faccpedi.coddoc faccpedi.nroped faccpedi.codmon   skip
            "CONSULTE A LA DIVSIÓN DE SISTEMAS"
            view-as alert-box.  
iCount = iCount + 1.

/******************* bucamos las ordenes **********************/

x-valor = 0.
for each b-faccpedi where b-faccpedi.codcia = s-codcia
                      and b-faccpedi.coddiv = s-coddiv
                      and b-faccpedi.coddoc = "PED"
                      and b-faccpedi.flgest ne "A"
                      and b-faccpedi.nroref = faccpedi.nroped:
/*                      use-index nnnnnnn*/                    
x-valor = b-faccpedi.Imptot.
if codmon = 1 then x-valor = x-valor / b-faccpedi.tpocmb.
t-codven01.acc-dolar-ped = t-codven01.acc-dolar-ped +  x-valor.
end.

/****************** guardando en el excel pagina 2 ******************************************/


chWorkSheet = chExcelApplication:Sheets:Item("hoja2").

    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.Coddoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.nroped.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.fchped.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.codcli.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.nomcli.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.codven.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.imptot * lookup(string(faccpedi.codmon),"1").
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = faccpedi.imptot * lookup(string(faccpedi.codmon),"2").
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = f-estado.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = x-valor.

    
/******************************************************************************************/

chWorkSheet = chExcelApplication:Sheets:Item(1).    
    
                
end.


f-Column = "G" + string(t-Column).

for each t-codven01:
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codven01.Codven.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = t-codven01.Desven.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-ate.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-pen.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-des.
/*ML01* ***
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-ped.
*ML01* ***/
/*ML01* Inicio de bloque ***/
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-ven.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-pap.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = acc-dolar-ped.
/*ML01* Fin de bloque ***/


END.

chWorkSheet:Range("C2:" + f-column):Select().
/*chExcelApplication:Selection:Style = "Currency".*/

/* create embedded chart using the data in the Worksheet */
chWorksheetRange = chWorksheet:Range("B1:" + f-Column).
chWorksheet:ChartObjects:Add(10,150,425,300):Activate.
chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 3, 1, 2, 1, 1, TRUE,
    "Reporte De Cotizaciones", "Vendedores", "Venta Dolares").

/* create chart using the data in the Worksheet */
chChart=chExcelApplication:Charts:Add().
chChart:Name = "Grafico 1".
chChart:Type = 11.
chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 11,,,1,1, TRUE,
    "Reporte De Cotizaciones desde " + string(f-desde) + " hasta " + string(f-hasta), "Vendedores", "Venta Dolares").



/*chChart:Title = "  ".*/
/*chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 11, 1, 2, 1, 3, TRUE,
 *     "Reporte De Cotizaciones", "Vendedores", "Venta Dolares").*/


chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
RELEASE OBJECT chChart.
RELEASE OBJECT chWorksheetRange. 

FOR EACH  T-CODVEN01:
DELETE T-CODVEN01.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF R-tipo = 1 THEN RUN Formato1.
IF R-tipo = 2 THEN RUN Formato2.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NEW-PAGE D-Dialog 
PROCEDURE NEW-PAGE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remvar D-Dialog 
PROCEDURE remvar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup-Print D-Dialog 
PROCEDURE Setup-Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

