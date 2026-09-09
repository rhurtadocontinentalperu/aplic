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
/* DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0. */
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.

 DEFINE VAR ESTADO AS CHARACTER.

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
&Scoped-Define ENABLED-OBJECTS R-Condic R-Estado RADIO-SET-1 f-tipo f-clien ~
f-vende f-desde f-hasta B-imprime B-impresoras r-sortea B-cancela ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE BUTTON-3 RECT-48 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS R-Condic R-Estado FILL-IN-3 RADIO-SET-1 ~
f-tipo f-clien f-vende f-desde f-hasta f-nomcli f-nomven r-sortea ~
RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-archivo 
     IMAGE-UP FILE "IMG/pvstop":U
     LABEL "&Archivos.." 
     SIZE 5 BY 1.

DEFINE BUTTON B-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 13 BY 1.5.

DEFINE BUTTON B-impresoras 
     IMAGE-UP FILE "IMG/pvprint":U
     IMAGE-DOWN FILE "IMG/pvprintd":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON B-imprime AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Imprimir" 
     SIZE 13 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "Button 3" 
     SIZE 13 BY 1.5.

DEFINE VARIABLE f-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Tipo Cmpbte." 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Todos","Boleta","Factura","N/C","N/D","Letras" 
     DROP-DOWN-LIST
     SIZE 12 BY 1
     BGCOLOR 15 FGCOLOR 4 FONT 6 NO-UNDO.

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "XXXXXXXXXXX":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-nomven AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .69 NO-UNDO.

DEFINE VARIABLE f-vende AS CHARACTER FORMAT "XXX":U 
     LABEL "Vendedor" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .69
     FONT 6 NO-UNDO.

DEFINE VARIABLE RB-BEGIN-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 1 
     LABEL "Página Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RB-END-PAGE AS INTEGER FORMAT "ZZZ9":U INITIAL 9999 
     LABEL "Página Hasta" 
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
     SIZE 29 BY .69
     BGCOLOR 15 FGCOLOR 0 FONT 12 NO-UNDO.

DEFINE VARIABLE R-Condic AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "C/Totales", 1,
"S/Totales", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Estado AS CHARACTER INITIAL "C" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pendientes", "P",
"Anulados", "A",
"Cancelados", "C",
"Todos", ""
     SIZE 14 BY 2.27
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE r-sortea AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documento", 1,
"Cliente", 2
     SIZE 14 BY 1.12
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-48
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.86 BY 4.85.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     R-Condic AT ROW 1.23 COL 51.29 NO-LABEL
     R-Estado AT ROW 1.23 COL 67 NO-LABEL
     FILL-IN-3 AT ROW 3.42 COL 3.86
     RADIO-SET-1 AT ROW 7.15 COL 2.57 NO-LABEL
     f-tipo AT ROW 2.69 COL 49.86 COLON-ALIGNED
     f-clien AT ROW 4.15 COL 8 COLON-ALIGNED
     f-vende AT ROW 4.88 COL 8 COLON-ALIGNED
     f-desde AT ROW 4.77 COL 51.72 COLON-ALIGNED
     f-hasta AT ROW 4.77 COL 69 COLON-ALIGNED
     B-imprime AT ROW 12.38 COL 17.86
     f-nomcli AT ROW 4.15 COL 19.29 COLON-ALIGNED NO-LABEL
     B-impresoras AT ROW 8.15 COL 15.57
     f-nomven AT ROW 4.88 COL 19.29 COLON-ALIGNED NO-LABEL
     b-archivo AT ROW 9.15 COL 15.57
     r-sortea AT ROW 1.23 COL 35.72 NO-LABEL
     RB-OUTPUT-FILE AT ROW 9.38 COL 19.86 COLON-ALIGNED NO-LABEL
     B-cancela AT ROW 12.42 COL 34.14
     RB-NUMBER-COPIES AT ROW 7.31 COL 70 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 8.31 COL 70 COLON-ALIGNED
     RB-END-PAGE AT ROW 9.31 COL 70 COLON-ALIGNED
     BUTTON-3 AT ROW 12.42 COL 49.29
     "Ordenado Por :" VIEW-AS TEXT
          SIZE 12.57 BY .62 AT ROW 1.35 COL 22.57
          BGCOLOR 8 FONT 6
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 3.85 COL 59.43
          BGCOLOR 8 FONT 6
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 6 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 6
     RECT-48 AT ROW 1 COL 1
     RECT-5 AT ROW 6.73 COL 1
     SPACE(0.85) SKIP(3.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resumen de Comprobantes".


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

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

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

/* SETTINGS FOR FILL-IN f-nomcli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomven IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN RB-OUTPUT-FILE IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       RB-OUTPUT-FILE:HIDDEN IN FRAME D-Dialog           = TRUE.

ASSIGN 
       RECT-48:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME D-Dialog:HANDLE
       ROW             = 11.15
       COLUMN          = 7.29
       HEIGHT          = .65
       WIDTH           = 71.43
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {35053A22-8589-11D1-B16A-00C0F0283628} type: ProgressBar */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Resumen de Comprobantes */
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


&Scoped-define SELF-NAME B-imprime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-imprime D-Dialog
ON CHOOSE OF B-imprime IN FRAME D-Dialog /* Imprimir */
DO:
  chCtrlFrame:ProgressBar:min = 0.
  chCtrlFrame:ProgressBar:max = integer(f-hasta).
  chCtrlFrame:ProgressBar:value = 0.
  chCtrlFrame:ProgressBar:hidden = no.
     
  message "loko".
   
  ASSIGN f-Desde f-hasta f-vende f-clien f-tipo r-sortea R-Estado R-Condic.
  
  IF f-desde = ? then do: MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
  IF f-hasta = ? then do: MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   
  IF f-desde > f-hasta then do: MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
  
  CASE f-tipo:screen-value :
       WHEN "Todos" THEN DO:
            f-tipos  = "".
            T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
       END.     
       WHEN "Boleta"  THEN DO: 
            f-tipos = "BOL". 
            T-cmpbte = "     RESUMEN DE BOLETAS     ". 
       END.            
       WHEN "Factura" THEN DO: 
            f-tipos = "FAC".
            T-cmpbte = "     RESUMEN DE FACTURAS    ". 
       END.     
       WHEN "N/C"      THEN DO: 
            f-tipos = "N/C".
            T-cmpbte = "RESUMEN DE NOTAS DE CREDITO ". 
       END.     
       WHEN "N/D"      THEN DO: 
            f-tipos = "N/D".
            T-cmpbte = " RESUMEN DE NOTAS DE DEBITO ". 
       END.
       WHEN "Letras"      THEN DO: 
            f-tipos = "LET".
            T-cmpbte = "      RESUMEN DE LETRAS     ". 
       END.                               
           
  END.          
  IF f-vende <> "" THEN T-vende = "Vendedor :  " + f-vende + "  " + f-nomven.
  IF f-clien <> "" THEN T-clien = "Cliente :  " + f-clien.
  
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


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien D-Dialog
ON LEAVE OF f-clien IN FRAME D-Dialog /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-vende
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-vende D-Dialog
ON LEAVE OF f-vende IN FRAME D-Dialog /* Vendedor */
DO:
  F-vende = "".
  IF F-vende:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = F-vende:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.
  END.
  DISPLAY F-NomVen WITH FRAME {&FRAME-NAME}.
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
       F-HASTA   = TODAY.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load D-Dialog  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "D-rescmx.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "D-rescmx.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY R-Condic R-Estado FILL-IN-3 RADIO-SET-1 f-tipo f-clien f-vende f-desde 
          f-hasta f-nomcli f-nomven r-sortea RB-NUMBER-COPIES RB-BEGIN-PAGE 
          RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE R-Condic R-Estado RADIO-SET-1 f-tipo f-clien f-vende f-desde f-hasta 
         B-imprime B-impresoras r-sortea B-cancela RB-NUMBER-COPIES 
         RB-BEGIN-PAGE RB-END-PAGE BUTTON-3 RECT-48 RECT-5 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IMPRIMIR D-Dialog 
PROCEDURE IMPRIMIR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /* P-Config = P-15cpi.*/
 
    IF r-sortea = 1 THEN 
       RUN prndoc.
    IF r-sortea = 2 THEN  
       RUN prncli.    
       
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prncli D-Dialog 
PROCEDURE prncli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.
 
 DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(23)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->,>>9.99"
        CcbcDocu.ImpVta FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->,>>9.99"
        CcbcDocu.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        CcbCDocu.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP         
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         
         
         
 FOR EACH CcbcDocu NO-LOCK WHERE
          CcbcDocu.CodCia = S-CODCIA AND
          CcbcDocu.CodDiv = S-CODDIV AND
          CcbcDocu.FchDoc >= F-desde AND
          CcbcDocu.FchDoc <= F-hasta AND 
          CcbcDocu.CodDoc BEGINS f-tipos AND
          CcbcDocu.CodDoc <> "G/R"   AND
          CcbcDocu.Codcli BEGINS f-clien AND
          CcbcDocu.CodVen BEGINS f-vende AND
          CcbcDocu.FlgEst BEGINS R-Estado
     BY CcbCDocu.NomCli:
     {&NEW-PAGE}.
     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     
     IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

     CASE CcbcDocu.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [1] = w-totdsc [1] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [2] = w-totdsc [2] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [2] = w-totexo [2] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [2] = w-totval [2] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [2] = w-totisc [2] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [2] = w-totigv [2] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [2] = w-totven [2] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [4] = w-totdsc [4] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [4] = w-totexo [4] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [4] = w-totval [4] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [4] = w-totisc [4] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [4] = w-totigv [4] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [4] = w-totven [4] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF CcbcDocu.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [6] = w-totdsc [6] + CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [6] = w-totexo [6] + CcbcDocu.ImpExo * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [6] = w-totval [6] + CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [6] = w-totisc [6] + CcbcDocu.ImpIsc * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [6] = w-totigv [6] + CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [6] = w-totven [6] + CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
     END.        

     DISPLAY STREAM REPORT 
        CcbcDocu.CodDoc 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        X-MON           
        (CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpVta
        (CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpDto
        (CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpBrt
        (CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpIgv
        (CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpTot
        X-EST 
        CcbCDocu.UsuAnu
        X-TIP WITH FRAME F-Cab.
        
 END.
 
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES  " SPACE(4) "TOTAL PENDIENTES      SOLES       DOLARES  " SPACE(4) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "--------------------------------------------" SPACE(4) "-------------------------------------------" SPACE(4) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 19  FORMAT "->,>>>,>>9.99" w-totbru[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Total Bruto     :"
                                            w-totbru[1] AT 69  FORMAT "->>,>>9.99"    w-totbru[2] AT 82  FORMAT "->>,>>9.99"  SPACE(4) "Total Bruto     :"
                                            w-totbru[5] AT 116 FORMAT "->>,>>9.99"    w-totbru[6] AT 128 FORMAT "->>,>>9.99"  SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totdsc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[1] AT 69  FORMAT "->>,>>9.99"   w-totdsc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Descuento       :"
                                            w-totdsc[5] AT 116 FORMAT "->>,>>9.99"   w-totdsc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 19  FORMAT "->,>>>,>>9.99" w-totexo[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[1] AT 69  FORMAT "->>,>>9.99"   w-totexo[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Exonerado       :"
                                            w-totexo[5] AT 116 FORMAT "->>,>>9.99"   w-totexo[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 19  FORMAT "->,>>>,>>9.99" w-totval[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[1] AT 69  FORMAT "->>,>>9.99"   w-totval[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Valor de Venta  :"
                                            w-totval[5] AT 116 FORMAT "->>,>>9.99"   w-totval[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 19  FORMAT "->,>>>,>>9.99" w-totisc[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[1] AT 69  FORMAT "->>,>>9.99"   w-totisc[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.S.C.          :"
                                            w-totisc[5] AT 116 FORMAT "->>,>>9.99"   w-totisc[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 19  FORMAT "->,>>>,>>9.99" w-totigv[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[1] AT 69  FORMAT "->>,>>9.99"   w-totigv[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "I.G.V.          :"
                                            w-totigv[5] AT 116 FORMAT "->>,>>9.99"   w-totigv[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 19  FORMAT "->,>>>,>>9.99" w-totven[4] AT 34  FORMAT "->>>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[1] AT 69  FORMAT "->>,>>9.99"   w-totven[2] AT 82  FORMAT "->>,>>9.99" SPACE(4) "Precio de Venta :"
                                            w-totven[5] AT 116 FORMAT "->>,>>9.99"   w-totven[6] AT 128 FORMAT "->>,>>9.99" SKIP.
 

 OUTPUT STREAM REPORT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prndoc D-Dialog 
PROCEDURE prndoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR M-TOTBRU AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTDSC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTEXO AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVAL AS DECIMAL EXTENT 6 INIT 0.  
 DEFINE VAR M-TOTISC AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTIGV AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR M-TOTVEN AS DECIMAL EXTENT 6 INIT 0.
 
 C = 1.    
 
 CASE R-Estado:
    WHEN "A" THEN ESTADO = "ANULADOS".
    WHEN "P" THEN ESTADO = "PENDIENTES".
    WHEN "C" THEN ESTADO = "CANCELADOS".
    WHEN "" THEN ESTADO = "TODOS".
 END CASE.
 
 DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli FORMAT "X(23)"
        CcbcDocu.RucCli FORMAT "X(11)"
        CcbcDocu.Codven FORMAT "X(4)"
        X-MON           FORMAT "X(4)"
        CcbcDocu.ImpBrt FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpDto FORMAT "->,>>9.99"
        CcbcDocu.ImpVta FORMAT "->>>>,>>9.99"
        CcbcDocu.ImpIgv FORMAT "->,>>9.99"
        CcbcDocu.ImpTot FORMAT "->>>>,>>9.99"
        X-TIP           FORMAT "X(2)"
        X-EST           FORMAT "X(3)"
        CcbCDocu.UsuAnu FORMAT "X(8)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + CcbcDocu.CodDiv + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + T-CMPBTE  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN4} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        ESTADO FORMAT "X(25)" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                   T O T A L      TOTAL       VALOR             P R E C I O         USUARIO " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E               R.U.C.  VEND MON.    BRUTO        DSCTO.      VENTA     I.G.V.   V E N T A   ESTADO ANULAC. " SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
  
  
 FOR EACH CcbcDocu NO-LOCK WHERE
          CcbcDocu.CodCia = S-CODCIA AND
          CcbcDocu.CodDiv = S-CODDIV AND
          CcbcDocu.FchDoc >= F-desde AND
          CcbcDocu.FchDoc <= F-hasta AND 
          CcbcDocu.CodDoc BEGINS f-tipos AND
          CcbcDocu.CodDoc <> "G/R" AND
          CcbcDocu.CodVen BEGINS f-vende AND
          CcbcDocu.Codcli BEGINS f-clien AND
          CcbcDocu.FlgEst BEGINS R-Estado
          USE-INDEX LLAVE10
     BREAK BY CcbcDocu.CodCia
           BY CcbcDocu.CodDiv
           BY CcbcDocu.CodDoc
     BY CcbCDocu.NroDoc:
     {&NEW-PAGE}.
  
     chCtrlFrame:ProgressBar:value = integer(ccbcdocu.fchdoc).

     IF CcbcDocu.Codmon = 1 THEN X-MON = "S/.".
        ELSE X-MON = "US$.".
     IF CcbcDocu.TipVta = "1" THEN X-TIP = "CT".
        ELSE X-TIP = "CR".   

     {vta/resdoc.i}.

     C = C + 1.
     DISPLAY STREAM REPORT 
        CcbcDocu.CodDoc 
        CcbcDocu.NroDoc 
        CcbcDocu.FchDoc 
        CcbcDocu.NomCli 
        CcbcDocu.RucCli 
        CcbcDocu.Codven
        X-MON           
        (CcbcDocu.ImpVta * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpVta
        (CcbcDocu.ImpDto * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpDto
        (CcbcDocu.ImpBrt * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpBrt
        (CcbcDocu.ImpIgv * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpIgv
        (CcbcDocu.ImpTot * (IF CcbcDocu.CodDoc = "N/C" THEN -1 ELSE 1)) @ CcbcDocu.ImpTot
        X-EST 
        CcbCDocu.UsuAnu
        X-TIP WITH FRAME F-Cab.

     IF R-Condic = 1 THEN DO:
        IF LAST-OF(CcbcDocu.CodDoc) THEN DO:
           UNDERLINE STREAM REPORT 
                     CcbcDocu.ImpVta
                     CcbcDocu.ImpDto
                     CcbcDocu.ImpBrt
                     CcbcDocu.ImpIgv
                     CcbcDocu.ImpTot
               WITH FRAME F-Cab.
               
            /***************************/
             DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
                PUT STREAM REPORT "" skip. 
             END.   
             
             PUT STREAM REPORT "TOTAL : " CcbcDocu.CodDoc SKIP.
             PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
             PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
             PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
             PUT STREAM REPORT "Total Bruto     :" AT 1 m-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Total Bruto     :"      m-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Total Bruto     :"      m-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Descuento       :" AT 1 m-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Descuento       :"      m-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Descuento       :"      m-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Exonerado       :" AT 1 m-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Exonerado       :"      m-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Exonerado       :"      m-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Valor de Venta  :" AT 1 m-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Valor de Venta  :"      m-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Valor de Venta  :"      m-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "I.S.C.          :" AT 1 m-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.S.C.          :"      m-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.S.C.          :"      m-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "I.G.V.          :" AT 1 m-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.G.V.          :"      m-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "I.G.V.          :"      m-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
             PUT STREAM REPORT "Precio de Venta :" AT 1 m-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  m-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Precio de Venta :"      m-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  m-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                               "Precio de Venta :"      m-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  m-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
            /*****************************/
            
            M-TOTBRU = 0.
            M-TOTDSC = 0.
            M-TOTEXO = 0.
            M-TOTVAL = 0.  
            M-TOTISC = 0.
            M-TOTIGV = 0.
            M-TOTVEN = 0.

         END.
     END.
 END.
 
 DO WHILE LINE-COUNTER(REPORT) < 62 - 8 :
    PUT STREAM REPORT "" skip. 
 END.   
 
 PUT STREAM REPORT "" SKIP. 
 PUT STREAM REPORT "TOTAL GENERAL " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "TOTAL CANCELADAS       SOLES       DOLARES    " SPACE(2) "TOTAL PENDIENTES      SOLES       DOLARES     " SPACE(2) "TOTAL ANULADAS       SOLES       DOLARES  " SKIP.
 PUT STREAM REPORT "----------------------------------------------" SPACE(2) "----------------------------------------------" SPACE(2) "------------------------------------------" SKIP.
 PUT STREAM REPORT "Total Bruto     :" AT 1 w-totbru[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totbru[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totbru[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Total Bruto     :"      w-totbru[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totbru[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Descuento       :" AT 1 w-totdsc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totdsc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totdsc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Descuento       :"      w-totdsc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totdsc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Exonerado       :" AT 1 w-totexo[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totexo[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totexo[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Exonerado       :"      w-totexo[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totexo[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Valor de Venta  :" AT 1 w-totval[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totval[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totval[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Valor de Venta  :"      w-totval[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totval[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.S.C.          :" AT 1 w-totisc[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totisc[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totisc[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.S.C.          :"      w-totisc[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totisc[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "I.G.V.          :" AT 1 w-totigv[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totigv[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totigv[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "I.G.V.          :"      w-totigv[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totigv[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 PUT STREAM REPORT "Precio de Venta :" AT 1 w-totven[3] AT 18  FORMAT "->>,>>>,>>9.99"  w-totven[4] AT 33  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[1] AT 66  FORMAT "->>,>>>,>>9.99"  w-totven[2] AT 81  FORMAT "->>,>>>,>>9.99" SPACE(2) 
                   "Precio de Venta :"      w-totven[5] AT 114 FORMAT "->>,>>>,>>9.99"  w-totven[6] AT 129 FORMAT "->>,>>>,>>9.99" SKIP.
 
 OUTPUT STREAM REPORT CLOSE.
 
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

