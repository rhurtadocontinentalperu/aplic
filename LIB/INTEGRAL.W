&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    W-Logo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Logo 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 06/21/95 -  8:49 am

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
DEFINE NEW GLOBAL SHARED VARIABLE XTerm       AS CHARACTER INITIAL "LOCAL".
DEFINE NEW GLOBAL SHARED VARIABLE XNReg       AS CHARACTER FORMAT "X(23)".
DEFINE NEW GLOBAL SHARED VARIABLE XNSer       AS CHARACTER FORMAT "X(23)".
DEFINE NEW GLOBAL SHARED VARIABLE XPROG       AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE s-codcia    AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE s-nomcia    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE x-DirCia    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE S-ADMIN      AS LOGICAL.
DEFINE NEW GLOBAL SHARED VARIABLE s-aplic-id    LIKE Modulos.Modulo.
DEFINE NEW GLOBAL SHARED VARIABLE s-user-id    LIKE _user._userid.
DEFINE NEW GLOBAL SHARED VARIABLE x-user-name LIKE _user._user-name.
DEFINE NEW GLOBAL SHARED VARIABLE x-Grupo     AS CHARACTER.

DEFINE NEW GLOBAL SHARED VARIABLE P-pagini  AS INTEGER FORMAT ">>>9".
DEFINE NEW GLOBAL SHARED VARIABLE P-pagfin  AS INTEGER FORMAT ">>>9".
DEFINE NEW GLOBAL SHARED VARIABLE P-copias  AS INTEGER FORMAT ">9".
DEFINE NEW GLOBAL SHARED VARIABLE P-select  AS INTEGER FORMAT "9".
DEFINE NEW GLOBAL SHARED VARIABLE P-archivo AS CHARACTER FORMAT "x(30)".

DEFINE NEW GLOBAL SHARED VARIABLE P-comando LIKE integral.TermImp.Comando.
DEFINE NEW GLOBAL SHARED VARIABLE P-device  LIKE integral.TermImp.Device.
DEFINE NEW GLOBAL SHARED VARIABLE P-Name    LIKE integral.TermImp.P-Name.
DEFINE NEW GLOBAL SHARED VARIABLE P-detalle LIKE integral.TermImp.Detalle. 

DEFINE NEW GLOBAL SHARED VARIABLE P-Reset    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Flen     AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-6lpi     AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-8lpi     AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-10cpi    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-12cpi    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-15cpi    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-20cpi    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Landscap AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Portrait AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-DobleOn  AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-DobleOff AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-BoldOn   AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-BoldOff  AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-UlineOn  AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-UlineOff AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-ItalOn   AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-ItalOff  AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-SuperOn  AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-SuperOff AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-SubOn    AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-SubOff   AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Proptnal AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Lpi      AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE P-Largo    AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE P-ancho  AS INTEGER.



/* Hacemos que el ENTER actue como TAB en modo GRAFICO */

SESSION:DATA-ENTRY-RETURN = TRUE.
SESSION:DATE-FORMAT = "dmy".

XTerm = OS-GETENV("TERMINAL").
IF XTerm = ?
THEN DO:    
    XTerm = "LOCAL".
    &IF OPSYS = "unix" &THEN
       INPUT THROUGH tty NO-ECHO.
        SET XTerm.
        INPUT CLOSE.
    &ENDIF
END.

/* TOMANDO LA CONFIGURACION */         
DEFINE VARIABLE ENCRIPTA AS CHARACTER.
DEFINE VARIABLE TEMP     AS CHARACTER.
DEFINE VARIABLE I        AS INTEGER.

FILE-INFO:FILE-NAME = "integral.cfg".
IF FILE-INFO:PATHNAME = ?
THEN RUN _Instala.w.

INPUT FROM integral.CFG NO-MAP NO-CONVERT.
IMPORT UNFORMATTED XNReg.
IMPORT UNFORMATTED XNSer.
IMPORT UNFORMATTED ENCRIPTA.
INPUT CLOSE.          

/* Nro. de Serie Bueno */
RUN series.p ( XNSer, OUTPUT Temp).
IF Temp = "BAD"
THEN DO:
    MESSAGE "ARCHIVO DE CONFIGURACION DA¥ADO" VIEW-AS ALERT-BOX ERROR.
    QUIT.
END.

/* Chequeamos si el No. de control es el correcto */
Temp = ENCODE( ENCODE( LC( XNReg ) ) + ENCODE( LC( XNSer ) ) ).
Temp = CAPS( Temp ).
IF NOT Temp BEGINS ENCRIPTA OR ENCRIPTA = ""
THEN DO:
    MESSAGE "Tarjeta de Registro mal Ingresada." VIEW-AS ALERT-BOX ERROR.
    QUIT.
END.

/* Pide Usuario del Sistema */
DEFINE NEW        SHARED VARIABLE MultiMod     AS LOGICAL.
DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("GENERAL").
RUN user.w.
pto = SESSION:SET-WAIT-STATE("").    
IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
THEN QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  F-Logo

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for FRAME F-Logo                                         */
&Scoped-define FIELDS-IN-QUERY-F-Logo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-Logo 

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Logo AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-XNREG AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81
     font 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-XNSER AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     font 4 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "IMG/logo-4"
     SIZE 61 BY 11.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Logo
     FILL-IN-XNREG AT ROW 4 COL 41 COLON-ALIGNED NO-LABEL
     FILL-IN-XNSER AT ROW 13 COL 39 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 3 COL 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 15.69
         BGCOLOR 8 FGCOLOR 0 .

 

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Logo ASSIGN
         HIDDEN             = YES
         TITLE              = "Sistema integral Valmiesa"
         COLUMN             = 1
         ROW                = 1
         HEIGHT             = 15.69
         WIDTH              = 90.43
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 90.43
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = 0
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Logo:LOAD-ICON("IMG/valmiesa") THEN
    MESSAGE "Unable to load icon: IMG/valmiesa"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Logo
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FILL-IN FILL-IN-XNREG IN FRAME F-Logo
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-XNSER IN FRAME F-Logo
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Logo)
THEN W-Logo:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Logo 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  RETURN NO-APPLY.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  RETURN NO-APPLY.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
REPEAT:
  DISPLAY IMAGE-1 XNSER @ FILL-IN-XNSER  XNREG @ FILL-IN-XNREG
      WITH FRAME F-Logo IN WINDOW W-Logo.
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  RUN q-modu.w.
  IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
  THEN QUIT.
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  RUN q-cias.w.
  IF LOOKUP(LAST-EVENT:FUNCTION, "ENDKEY,ERROR,END-ERROR") <> 0
  THEN QUIT.
  /* Ejecutando el Modulo */
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  RUN VALUE(XPROG).
  pto = SESSION:SET-WAIT-STATE("").    
  pto = CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW").
  IF NOT MultiMod THEN QUIT. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Logo _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U THEN DELETE WIDGET W-Logo.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Logo _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY FILL-IN-XNREG FILL-IN-XNSER 
      WITH FRAME F-Logo IN WINDOW W-Logo.
  ENABLE IMAGE-1 
      WITH FRAME F-Logo IN WINDOW W-Logo.
  {&OPEN-BROWSERS-IN-QUERY-F-Logo}
  VIEW W-Logo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
