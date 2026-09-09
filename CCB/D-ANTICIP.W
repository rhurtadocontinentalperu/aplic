&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
/*DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.*/
  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE cb-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CAJA   AS CHAR INIT "".
DEFINE VARIABLE T-CJRO   AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODTER AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.


/*** DEFINE VARIABLES SUB-TOTALES ***/
DEFINE VAR T-EFESOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-EFEDOL AS DECIMAL FORMAT "->>>>,>>9.99" INIT 0.
DEFINE VAR T-CHDSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-CHDDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-CHFDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRSOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.
DEFINE VAR T-NCRDOL AS DECIMAL FORMAT "->>>>>9.99"   INIT 0.  
DEFINE VAR T-DEPSOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-DEPDOL AS DECIMAL FORMAT "->>>>>>9.99"  INIT 0.
DEFINE VAR T-MOVTO  AS CHAR INIT "".

/* define variable para subtotales" */
def var x-filename as char init "".
def var x-imptot as deci extent 2.
def var x-sdoact as deci extent 2.
def var x-codmon as char init "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS R-estado RECT-49 RECT-5 RECT-50 RECT-64 ~
RADIO-SET-1 B-impresoras f-desde f-hasta Btn_OK RB-NUMBER-COPIES Btn_Cancel ~
RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS R-estado FILL-IN-3 RADIO-SET-1 f-desde ~
f-hasta RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
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

DEFINE VARIABLE R-estado AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", " ",
"Pendiente", "P",
"Cancelado", "C",
"Anulado", "A"
     SIZE 10.14 BY 2.5 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 2,
"Impresora", 1,
"Archivo", 3
     SIZE 12 BY 3
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.14 BY 4.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.14 BY 6.12.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15.57 BY 10.08.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 12 BY 2.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     R-estado AT ROW 2.23 COL 37.43 NO-LABEL
     FILL-IN-3 AT ROW 1.23 COL 2.43
     RADIO-SET-1 AT ROW 6.19 COL 2.86 NO-LABEL
     B-impresoras AT ROW 7.23 COL 16
     b-archivo AT ROW 8.23 COL 16.14
     f-desde AT ROW 3.23 COL 7.57 COLON-ALIGNED
     f-hasta AT ROW 4 COL 7.57 COLON-ALIGNED
     RB-OUTPUT-FILE AT ROW 8.38 COL 20 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 1.81 COL 52
     RB-NUMBER-COPIES AT ROW 9.92 COL 10.57 COLON-ALIGNED
     Btn_Cancel AT ROW 5.08 COL 52.72
     RB-BEGIN-PAGE AT ROW 9.92 COL 25.29 COLON-ALIGNED
     RB-END-PAGE AT ROW 9.92 COL 39.43 COLON-ALIGNED
     RECT-49 AT ROW 1 COL 1
     RECT-5 AT ROW 5.04 COL 1
     RECT-50 AT ROW 1 COL 50.86
     RECT-64 AT ROW 2.08 COL 36.86
     "Rango de Fechas :" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 2.54 COL 4.29
          FONT 6
     " Configuracion de Impresion" VIEW-AS TEXT
          SIZE 47.86 BY .62 AT ROW 5.27 COL 1.57
          BGCOLOR 1 FGCOLOR 15 FONT 6
     "Páginas" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 9.31 COL 33.72
          FONT 6
     "Estado" VIEW-AS TEXT
          SIZE 7.43 BY .5 AT ROW 1.58 COL 36.86
          FONT 6
     SPACE(22.84) SKIP(9.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Anticipos Recibidos".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Anticipos Recibidos */
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
  
  ASSIGN f-Desde f-hasta R-Estado.
   
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
       F-HASTA   = TODAY
       R-Estado  = "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY R-estado FILL-IN-3 RADIO-SET-1 f-desde f-hasta RB-NUMBER-COPIES 
          RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE R-estado RECT-49 RECT-5 RECT-50 RECT-64 RADIO-SET-1 B-impresoras 
         f-desde f-hasta Btn_OK RB-NUMBER-COPIES Btn_Cancel RB-BEGIN-PAGE 
         RB-END-PAGE 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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

 RUN LIstado.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa D-Dialog 
PROCEDURE Inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 T-EFESOL = 0. 
 T-EFEDOL = 0.
 T-CHDSOL = 0.
 T-CHDDOL = 0.
 T-CHFSOL = 0.
 T-CHFDOL = 0.
 T-NCRSOL = 0.
 T-NCRDOL = 0.
 T-DEPSOL = 0.
 T-DEPDOL = 0.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Listado D-Dialog 
PROCEDURE Listado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-MON AS CHAR FORMAT "X(3)".
DEFINE VAR X-EST AS CHAR FORMAT "X(5)".
DEFINE VAR X-NOMCLI AS CHAR FORMAT "X(40)".
DEFINE VAR X-IMPSOL AS DECI FORMAT "->>>,>>>,>>9.99".
DEFINE VAR X-IMPDOL AS DECI FORMAT "->>>,>>>,>>9.99".
DEFINE VAR X-SDOSOL AS DECI FORMAT "->>>,>>>,>>9.99".
DEFINE VAR X-SDODOL AS DECI FORMAT "->>>,>>>,>>9.99".

 DEFINE FRAME f-cab
        CcbAntRec.CodDiv
        CcbAntRec.NroDoc 
        CcbAntRec.FchDoc 
        CcbAntRec.Codcli
        X-NOMCLI 
        X-IMPSOL
        X-IMPDOL
        X-SDOSOL
        X-SDODOL
        CcbAntRec.usuario       
        X-EST           
        HEADER
        "R E S U M E N     A N T I C I P O S"  AT 45 FORMAT "X(35)"
        "Pag.  : " AT 105 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 050 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999")  FORMAT "X(12)" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                         I  M  P  O  R  T  E                 S  A  L  D  O                    " SKIP
        " DIVISION DOCUMENTO  FECHA        CLIENTE   NOMBRE O RAZON SOCIAL                       NACIONAL    EXTRANJERO            NACIONAL    EXTRANJERO  USUARIO  EST" SKIP
        "-------------------------------------------------------------------------------------- -----------------------------------------------------------------------" SKIP
         WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
 FOR EACH CcbAntRec WHERE CcbAntRec.CodCia = S-CODCIA AND
                          CcbAntRec.FchDoc >= F-DESDE AND
                          CcbAntRec.FchDoc <= F-HASTA AND
                          CcbAntRec.FlgEst BEGINS R-Estado
                          BREAK BY CcbAntRec.CodCia
                                BY CcbAntRec.CodDiv 
                                BY CcbAntRec.NroDoc:
                          
           
     {&new-page}.

     IF CcbAntRec.FlgEst = "C" THEN ASSIGN X-EST = "CAN".
     IF CcbAntRec.FlgEst = "A" THEN ASSIGN X-EST = "ANU".     
     IF CcbAntRec.FlgEst = "P" THEN ASSIGN X-EST = "PEN".
     X-MON = IF CcbAntRec.CodMon = 1 THEN "S/." ELSE "US$/.".

     X-SDOSOL = 0.
     X-SDODOL = 0.
     X-IMPSOL = 0.
     X-IMPDOL = 0.

     CASE CcbAntRec.CodMon :
          WHEN 1 THEN DO:
             X-SDOSOL = CcbAntRec.SdoAct.
             X-IMPSOL = CcbAntRec.ImpTot.
          END.
          WHEN 2 THEN DO:
             X-SDODOL = CcbAntRec.SdoAct.
             X-IMPDOL = CcbAntRec.ImpTot.
          END.          
     END.
     
          
     
     X-NOMCLI = "".
     FIND Gn-Clie WHERE Gn-Clie.Codcia = 0 AND
                        Gn-Clie.CodCli = CcbAntRec.Codcli
                        NO-LOCK NO-ERROR.
     IF AVAILABLE Gn-Clie THEN DO:
        X-NOMCLI = Gn-Clie.NomCli. 
     END.

     ACCUM  X-SDOSOL  (SUB-TOTAL BY CcbAntRec.CodDiv) .
     ACCUM  X-SDODOL  (SUB-TOTAL BY CcbAntRec.CodDiv) .
     ACCUM  X-SDOSOL  (TOTAL BY CcbAntRec.CodCia) .
     ACCUM  X-SDODOL  (TOTAL BY CcbAntRec.CodCia) .
/*
     IF FIRST-OF(CcbAntRec.CodDiv) THEN DO:
        PUT STREAM REPORT "DIVISION : " FORMAT "X(10)"   AT 1.
        PUT STREAM REPORT CcbAntRec.CodDiv FORMAT "X(5)" AT 13 SKIP.
        PUT STREAM REPORT "-----------------------" AT 1 SKIP.

     END.
*/                               
     DISPLAY STREAM REPORT 
        CcbAntRec.CodDiv
        CcbAntRec.NroDoc 
        CcbAntRec.FchDoc 
        CcbAntRec.Codcli
        X-NOMCLI
        X-IMPSOL
        X-IMPDOL
        X-SDOSOL
        X-SDODOL
        CcbAntRec.usuario       
        X-EST    
     WITH FRAME F-Cab.

     IF LAST-OF(CcbAntRec.CodDiv) THEN DO:
        UNDERLINE STREAM REPORT 
            X-SDOSOL
            X-SDODOL
        WITH FRAME F-Cab.

        DISPLAY STREAM REPORT 
            ("TOTAL DIVISION : " + CcbAntRec.CodDiv) @ X-NOMCLI
            (ACCUM SUB-TOTAL BY CcbAntRec.CodDiv X-SDOSOL) @ X-SDOSOL 
            (ACCUM SUB-TOTAL BY CcbAntRec.CodDiv X-SDODOL) @ X-SDODOL 
           WITH FRAME F-Cab.
     END.
  
  
     IF LAST-OF(CcbAntRec.CodCia) THEN DO:
        UNDERLINE STREAM REPORT 
            X-SDOSOL
            X-SDODOL
        WITH FRAME F-Cab.

        DISPLAY STREAM REPORT 
            ("TOTAL COMPAÑIA : " ) @ X-NOMCLI
            (ACCUM TOTAL BY CcbAntRec.CodCia X-SDOSOL) @ X-SDOSOL 
            (ACCUM TOTAL BY CcbAntRec.CodCia X-SDODOL) @ X-SDODOL 
            WITH FRAME F-Cab.

     END.
  
 END. 
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
                    PAGED PAGE-SIZE 62.
               PUT STREAM report CONTROL P-reset NULL P-flen NULL P-config NULL.
        END.
        ELSE DO:
            OUTPUT STREAM report TO VALUE ( P-archivo ) NO-MAP NO-CONVERT UNBUFFERED
                 PAGED PAGE-SIZE 62.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


