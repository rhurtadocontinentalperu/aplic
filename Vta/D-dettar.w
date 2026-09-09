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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

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

DEFINE VARIABLE f-tipos  AS CHAR FORMAT "X(3)".
DEFINE VARIABLE T-CMPBTE AS CHAR INIT "".
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE T-CLIEN  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-TIP    AS CHAR FORMAT "X(2)".
DEFINE VAR C AS INTEGER.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

 DEFINE VAR W-TotBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-TotVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-ConBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-ConVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-CreBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-CreVen AS DECIMAL EXTENT 6 INIT 0.
 
 DEFINE VAR W-NCBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NCVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR W-NDBru AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDDsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDExo AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVal AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIsc AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDIgv AS DECIMAL EXTENT 6 INIT 0.
 DEFINE VAR W-NDVen AS DECIMAL EXTENT 6 INIT 0.

 DEFINE VAR F-ImpBrt AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpDto AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR F-ImpVta AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpExo AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIgv AS DECIMAL FORMAT "(>>>,>>9.99)".
 DEFINE VAR F-ImpTot AS DECIMAL FORMAT "(>>>>,>>9.99)".
 DEFINE VAR F-ImpIsc AS DECIMAL FORMAT "(>,>>9.99)".
 DEFINE VAR JJ       AS INTEGER NO-UNDO.
 DEFINE VAR F-TOTCON AS DECIMAL EXTENT 6 INITIAL 0.
 DEFINE VAR F-TOTCRE AS DECIMAL EXTENT 6 INITIAL 0.
 C = 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-49 RECT-48 RECT-5 RECT-52 RADIO-SET-1 ~
F-DIVISION f-nrocard R-S-TipImp B-impresoras B-imprime B-cancela BUTTON-3 ~
f-desde f-hasta RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 F-DIVISION f-nrocard ~
R-S-TipImp F-DESDIV f-nomcard f-desde f-hasta RB-NUMBER-COPIES ~
RB-BEGIN-PAGE RB-END-PAGE 

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

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-DESDIV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .69 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE f-nomcard AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 27.29 BY .69 NO-UNDO.

DEFINE VARIABLE f-nrocard AS CHARACTER FORMAT "XXXXXX":U 
     LABEL "NroCard" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69
     BGCOLOR 15  NO-UNDO.

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

DEFINE VARIABLE R-S-TipImp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Detalle", 1,
"Resumen", 2
     SIZE 27.57 BY .54 NO-UNDO.

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
     SIZE 83.86 BY 2.77.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 1.69.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 4 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 3.92.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.86 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     RADIO-SET-1 AT ROW 5.04 COL 2.57 NO-LABEL
     F-DIVISION AT ROW 1.19 COL 6.29 COLON-ALIGNED
     f-nrocard AT ROW 1.92 COL 6.29 COLON-ALIGNED
     R-S-TipImp AT ROW 2.96 COL 10.72 NO-LABEL
     B-impresoras AT ROW 6.04 COL 15.57
     b-archivo AT ROW 7.04 COL 15.57
     F-DESDIV AT ROW 1.23 COL 14.86 COLON-ALIGNED NO-LABEL
     f-nomcard AT ROW 1.96 COL 17 NO-LABEL
     B-imprime AT ROW 8.73 COL 18.57
     RB-OUTPUT-FILE AT ROW 7.27 COL 19.86 COLON-ALIGNED NO-LABEL
     B-cancela AT ROW 8.77 COL 34.86
     BUTTON-3 AT ROW 8.77 COL 50
     f-desde AT ROW 2.19 COL 49.29 COLON-ALIGNED
     f-hasta AT ROW 2.19 COL 66.57 COLON-ALIGNED
     RB-NUMBER-COPIES AT ROW 5.19 COL 70 COLON-ALIGNED
     RB-BEGIN-PAGE AT ROW 6.19 COL 70 COLON-ALIGNED
     RB-END-PAGE AT ROW 7.19 COL 70 COLON-ALIGNED
     RECT-49 AT ROW 1.65 COL 45
     RECT-48 AT ROW 1 COL 1
     " Configuración de Impresión" VIEW-AS TEXT
          SIZE 83.43 BY .62 AT ROW 3.88 COL 1.29
          BGCOLOR 1 FGCOLOR 15 FONT 6
     " Rango de Fechas" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 1.31 COL 54.86
          BGCOLOR 8 FONT 6
     RECT-5 AT ROW 4.62 COL 1
     RECT-52 AT ROW 2.77 COL 5.29
     SPACE(40.85) SKIP(6.96)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Registro de Ventas Gestion".


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
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-archivo IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       b-archivo:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN F-DESDIV IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-nomcard IN FRAME D-Dialog
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Registro de Ventas Gestion */
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
   
  ASSIGN f-Desde f-hasta R-S-TipImp f-division F-NROCARD.
  
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
  
  T-cmpbte = "  RESUMEN DE COMPROBANTES   ". 
          
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


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION D-Dialog
ON LEAVE OF F-DIVISION IN FRAME D-Dialog /* Division */
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN F-DIVISION.
    IF F-DIVISION <> "" THEN DO:        
       FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                          Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION .
            RETURN NO-APPLY.
       END.
       F-DESDIV =  Gn-Divi.Desdiv .           
    END.
    DISPLAY F-DESDIV @ F-DESDIV .
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-nrocard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-nrocard D-Dialog
ON LEAVE OF f-nrocard IN FRAME D-Dialog /* NroCard */
DO:
  DO WITH FRAME {&FRAME-NAME}:
 
  ASSIGN F-NroCard.
    
  IF F-NroCard = "" THEN F-NomCard = "" .
  
  IF F-NroCard <> "" THEN DO: 
     FIND Gn-Card WHERE Gn-Card.NroCard = F-NroCard
                  NO-LOCK NO-ERROR.
     IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE "Numero de Tarjeta NO Existe"
                VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO F-NroCard.
        RETURN NO-APPLY.
     END.
     F-NomCard = Gn-Card.NomCard.
  END.
  DISPLAY F-NomCard @ F-NomCard .
  END.  
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

ASSIGN f-division = S-CODDIV
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
        CASE R-S-TipImp :
             WHEN  1 THEN RUN IMPRIMIR.
             WHEN  2 THEN RUN RESUMEN.
        END.
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
  DISPLAY RADIO-SET-1 F-DIVISION f-nrocard R-S-TipImp F-DESDIV f-nomcard f-desde 
          f-hasta RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
      WITH FRAME D-Dialog.
  ENABLE RECT-49 RECT-48 RECT-5 RECT-52 RADIO-SET-1 F-DIVISION f-nrocard 
         R-S-TipImp B-impresoras B-imprime B-cancela BUTTON-3 f-desde f-hasta 
         RB-NUMBER-COPIES RB-BEGIN-PAGE RB-END-PAGE 
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
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR X-PUNTOS AS DECI    NO-UNDO INIT 0.
  DEFINE VAR X-NOMCARD AS CHAR INIT "".
  DEFINE FRAME f-cab
        CcbcDocu.CodDoc FORMAT "XXX"
        CcbcDocu.NroDoc FORMAT "XXX-XXXXXX"
        CcbcDocu.FchDoc 
        CcbcDocu.CodCli FORMAT "X(8)"
        CcbcDocu.NomCli FORMAT "X(23)"
        X-MON           FORMAT "X(4)"
        X-TPOCMB        FORMAT ">>>9.9999"
        F-ImpTot 
        X-PUNTOS        FORMAT "->>>>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + F-DIVISION + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " Ventas Tarjeta Cliente Exclusivo "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "---------------------------------------------------------------------------------------------------------------------" SKIP
        "        No.      FECHA                                                              T O T A L      TOTAL   " SKIP
        "DOC  DOCUMENTO  EMISION   C L I E N T E                    MONEDA  T/C                VENTA        PUNTOS  " SKIP
        "---------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  
  FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
                             AND  CcbcDocu.CodDiv = f-division
                             AND  CcbcDocu.FchDoc >= F-desde 
                             AND  CcbcDocu.FchDoc <= F-hasta 
                             AND  CcbcDocu.CodDoc BEGINS "" /*LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 */
                             AND  CcbcDocu.CodDoc <> "G/R" 
                             AND  CcbcDocu.FlgEst <> "A" 
                             AND  CcbcDocu.NroCard BEGINS F-NroCard
                             AND  CcbcDocu.NroCard <> ""
                            USE-INDEX LLAVE10
                            BREAK BY CcbCDocu.codcia 
                                  BY CcbCDocu.NroCard 
                                  BY CcbCDocu.Coddoc 
                                  BY CcbCDocu.NroDoc:
                                  
     X-TPOCMB = 0.
     {&NEW-PAGE}.
/*     VIEW STREAM REPORT FRAME F-CAB.*/
     IF FIRST-OF(CcbCDocu.NroCard) THEN DO:
        VIEW STREAM REPORT FRAME F-CAB.
        X-NOMCARD = "".
        FIND Gn-Card WHERE Gn-Card.NroCard = CcbCDocu.NroCard
             NO-LOCK NO-ERROR.          
        IF AVAILABLE Gn-card THEN X-NOMCARD = Gn-Card.NomCard .
        PUT STREAM REPORT  " " SKIP.
        PUT STREAM REPORT   {&PRN6A} + "Tarjeta : "     FORMAT "X(10)" AT 1 
                            {&PRN6A} + CcbCDocu.NroCard FORMAT "X(8)"  AT 15
                            {&PRN6A} + X-NOMCARD  + {&PRN6B} FORMAT "X(40)" AT 25 SKIP.
        PUT STREAM REPORT   {&PRN6B} + '------------------------------------------' FORMAT "X(50)" SKIP.
                          
     END.
     IF CcbcDocu.Codmon = 1 THEN DO:
        X-MON = "S/.".
        F-Imptot = CcbCDocu.Imptot.
     END.
     ELSE DO:
          FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCDocu.fchdoc NO-LOCK NO-ERROR.
          IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta.
          X-MON = "US$.".
          F-Imptot = CcbCDocu.Imptot * X-TPOCMB.
     END.
     X-PUNTOS = F-ImpTot / 25 .
     IF CcbcDocu.CodDoc = "N/C" THEN 
        ASSIGN 
        X-PUNTOS = X-PUNTOS * ( -1)
        F-IMPTOT = F-IMPTOT * ( -1) .
          

        DISPLAY STREAM REPORT 
              CcbcDocu.CodDoc 
              CcbcDocu.NroDoc 
              CcbcDocu.FchDoc 
              CcbcDocu.CodCli 
              CcbcDocu.NomCli 
              X-MON           
              X-TPOCMB WHEN X-TPOCMB <> 0 
              F-ImpTot 
              X-PUNTOS 
              WITH FRAME F-Cab.
        
        ACCUMULATE F-ImpTot (SUB-TOTAL BY CcbCDocu.NroCard).
        ACCUMULATE X-PUNTOS (SUB-TOTAL BY CcbCDocu.NroCard).

        IF LAST-OF(CcbCDocu.NroCArd) THEN DO:
           UNDERLINE STREAM REPORT F-Imptot X-PUNTOS WITH FRAME F-Cab.
           DISPLAY STREAM REPORT
              'TOTAL NUEVOS SOLES   ==>' @ CcbCDocu.Nomcli
              ACCUM SUB-TOTAL BY CcBCDocu.NroCArd F-ImpTot @ F-ImpTot 
              ACCUM SUB-TOTAL BY CcBCDocu.NroCArd X-PUNTOS @ X-PUNTOS 
              WITH FRAME F-Cab.
              DOWN(2) STREAM REPORT WITH FRAME F-Cab.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen D-Dialog 
PROCEDURE Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-tpocmb AS DECIMAL NO-UNDO.
  DEFINE VAR X-PUNTOS AS DECI    NO-UNDO INIT 0.
  DEFINE VAR X-NOMCARD AS CHAR INIT "".
  DEFINE FRAME f-cab-2
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP
        {&PRN2} + {&PRN6A} + "( " + F-DIVISION + ")" + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(15)"
        {&PRN6A} + " Ventas Tarjeta Cliente Exclusivo "  AT 43 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") + {&PRN6B} + {&PRN3} FORMAT "X(12)"
        {&PRN3} + "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "-----------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                     T O T A L            TOTAL   " SKIP
        "  TARJETA         C L I E N T E                                       VENTA S/.           PUNTOS  " SKIP
        "-----------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  {&NEW-PAGE}.
  VIEW STREAM REPORT FRAME F-CAB-2.
  FOR EACH CcbcDocu NO-LOCK WHERE CcbcDocu.CodCia = S-CODCIA 
                             AND  CcbcDocu.CodDiv = f-division
                             AND  CcbcDocu.FchDoc >= F-desde 
                             AND  CcbcDocu.FchDoc <= F-hasta 
                             AND  CcbcDocu.CodDoc BEGINS "" /*LOOKUP(CcbcDocu.CodDoc,"BOL,FAC,N/C,N/D") > 0 */
                             AND  CcbcDocu.CodDoc <> "G/R" 
                             AND  CcbcDocu.FlgEst <> "A" 
                             AND  CcbcDocu.NroCard BEGINS F-NroCard
                             AND  CcbcDocu.NroCard <> ""
                            USE-INDEX LLAVE10
                            BREAK BY CcbCDocu.codcia 
                                  BY CcbCDocu.NroCard 
                                  BY CcbCDocu.Coddoc 
                                  BY CcbCDocu.NroDoc:
                                  
     X-TPOCMB = 0.
      IF CcbcDocu.Codmon = 1 THEN DO:
        X-MON = "S/.".
        F-Imptot = CcbCDocu.Imptot.
     END.
     ELSE DO:
          FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCDocu.fchdoc NO-LOCK NO-ERROR.
          IF AVAILABLE gn-tcmb THEN x-tpocmb = gn-tcmb.venta.
          X-MON = "US$.".
          F-Imptot = CcbCDocu.Imptot * X-TPOCMB.
     END.
     X-PUNTOS = F-ImpTot / 25 .

     IF CcbcDocu.CodDoc = "N/C" THEN 
        ASSIGN 
        X-PUNTOS = X-PUNTOS * ( -1)
        F-IMPTOT = F-IMPTOT * ( -1) .          
        
        ACCUMULATE F-ImpTot (SUB-TOTAL BY CcbCDocu.NroCard).
        ACCUMULATE X-PUNTOS (SUB-TOTAL BY CcbCDocu.NroCard).

        IF LAST-OF(CcbCDocu.NroCArd) THEN DO:
           X-NOMCARD = "".
           FIND Gn-Card WHERE Gn-Card.NroCard = CcbCDocu.NroCard
                NO-LOCK NO-ERROR.          
           IF AVAILABLE Gn-card THEN X-NOMCARD = Gn-Card.NomCard .
           PUT STREAM REPORT  " " SKIP.
           PUT STREAM REPORT   {&PRN6A} + "Tarjeta : "     FORMAT "X(10)" AT 1 
                               {&PRN6A} + CcbCDocu.NroCard FORMAT "X(8)"  AT 15
                               {&PRN6A} + X-NOMCARD  + {&PRN6B} FORMAT "X(40)" AT 25 
                                ACCUM SUB-TOTAL BY CcBCDocu.NroCArd F-ImpTot AT 70 
                                ACCUM SUB-TOTAL BY CcBCDocu.NroCArd X-PUNTOS AT 90  .
          DOWN STREAM REPORT WITH FRAME F-Cab.
        END.
 END.

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


