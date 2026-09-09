&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME WINDOW-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/13/95 - 12:16 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/


CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER.
DEFINE VARIABLE y-CodCia                     AS INTEGER INITIAL 0.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN y-CodCia = s-codcia.

DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRAME-A

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-cfga

/* Definitions for FRAME FRAME-A                                        */
&Scoped-define FIELDS-IN-QUERY-FRAME-A cb-cfga.GenAut9 cb-cfga.Cc1Cta9 ~
cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut cb-cfga.DetCfg ~
cb-cfga.CodDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-FRAME-A cb-cfga.GenAut9 ~
cb-cfga.Cc1Cta9 cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut ~
cb-cfga.DetCfg cb-cfga.CodDiv 
&Scoped-define ENABLED-TABLES-IN-QUERY-FRAME-A cb-cfga
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-FRAME-A cb-cfga

&Scoped-define FIELD-PAIRS-IN-QUERY-FRAME-A~
 ~{&FP1}GenAut9 ~{&FP2}GenAut9 ~{&FP3}~
 ~{&FP1}Cc1Cta9 ~{&FP2}Cc1Cta9 ~{&FP3}~
 ~{&FP1}GenAut6 ~{&FP2}GenAut6 ~{&FP3}~
 ~{&FP1}Cc1Cta6 ~{&FP2}Cc1Cta6 ~{&FP3}~
 ~{&FP1}GenAut ~{&FP2}GenAut ~{&FP3}~
 ~{&FP1}DetCfg ~{&FP2}DetCfg ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}
&Scoped-define OPEN-QUERY-FRAME-A OPEN QUERY FRAME-A FOR EACH cb-cfga ~
      WHERE cb-cfga.CodCia = y-CodCia ~
 AND cb-cfga.CodCfg = 1 SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-FRAME-A cb-cfga
&Scoped-define FIRST-TABLE-IN-QUERY-FRAME-A cb-cfga


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cfga.GenAut9 cb-cfga.Cc1Cta9 ~
cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut cb-cfga.DetCfg ~
cb-cfga.CodDiv 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}GenAut9 ~{&FP2}GenAut9 ~{&FP3}~
 ~{&FP1}Cc1Cta9 ~{&FP2}Cc1Cta9 ~{&FP3}~
 ~{&FP1}GenAut6 ~{&FP2}GenAut6 ~{&FP3}~
 ~{&FP1}Cc1Cta6 ~{&FP2}Cc1Cta6 ~{&FP3}~
 ~{&FP1}GenAut ~{&FP2}GenAut ~{&FP3}~
 ~{&FP1}DetCfg ~{&FP2}DetCfg ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}
&Scoped-define ENABLED-TABLES cb-cfga
&Scoped-define FIRST-ENABLED-TABLE cb-cfga
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 B-aceptar B-cancelar 
&Scoped-Define DISPLAYED-FIELDS cb-cfga.GenAut9 cb-cfga.Cc1Cta9 ~
cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut cb-cfga.DetCfg ~
cb-cfga.CodDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR WINDOW-1 AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.08.

DEFINE BUTTON B-cancelar AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10.72 BY 1.08.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 80.57 BY 2.96
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 80.57 BY 5.38
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 80.57 BY 2
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY FRAME-A FOR 
      cb-cfga SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     B-aceptar AT ROW 9.77 COL 5.29 HELP
          "Acepta los datos ingresados"
     B-cancelar AT ROW 9.77 COL 19.29 HELP
          "Cancela los datos ingresados"
     cb-cfga.GenAut9 AT ROW 4.54 COL 22.72 COLON-ALIGNED HELP
          "Ingrese por ejemplo: 60,61,62,..."
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     cb-cfga.Cc1Cta9 AT ROW 5.46 COL 22.72 COLON-ALIGNED FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     cb-cfga.GenAut6 AT ROW 6.38 COL 22.57 COLON-ALIGNED HELP
          "Ingrese por ejemplo: 60,61,62,..."
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     cb-cfga.Cc1Cta6 AT ROW 7.19 COL 22.72 COLON-ALIGNED FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     cb-cfga.GenAut AT ROW 8.04 COL 22.57 COLON-ALIGNED HELP
          "Ingrese por ejemplo: 60,61,62,..."
          VIEW-AS FILL-IN 
          SIZE 51.43 BY .69
     cb-cfga.DetCfg AT ROW 1.54 COL 37.86 COLON-ALIGNED HELP
          "Ingrese por ejemplo: XX.X.XX"
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .69
          FONT 0
     cb-cfga.CodDiv AT ROW 2.42 COL 37.86 COLON-ALIGNED HELP
          "Configura Divisionaria"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     RECT-4 AT ROW 1 COL 1
     RECT-5 AT ROW 3.96 COL 1
     RECT-6 AT ROW 9.35 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 15.69
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW WINDOW-1 ASSIGN
         HIDDEN             = YES
         TITLE              = "Configuración Contable"
         COLUMN             = 8.72
         ROW                = 4.08
         HEIGHT             = 10.42
         WIDTH              = 80.57
         MAX-HEIGHT         = 15.69
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 15.69
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW WINDOW-1
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-A
                                                                        */
/* SETTINGS FOR FILL-IN cb-cfga.Cc1Cta6 IN FRAME FRAME-A
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN cb-cfga.Cc1Cta9 IN FRAME FRAME-A
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN cb-cfga.CodDiv IN FRAME FRAME-A
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN cb-cfga.DetCfg IN FRAME FRAME-A
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut IN FRAME FRAME-A
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut6 IN FRAME FRAME-A
   EXP-HELP                                                             */
/* SETTINGS FOR FILL-IN cb-cfga.GenAut9 IN FRAME FRAME-A
   EXP-HELP                                                             */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
THEN WINDOW-1:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-A
/* Query rebuild information for FRAME FRAME-A
     _TblList          = "integral.cb-cfga"
     _Where[1]         = "cb-cfga.CodCia = y-CodCia
 AND cb-cfga.CodCfg = 1"
     _Query            is OPENED
*/  /* FRAME FRAME-A */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar WINDOW-1
ON CHOOSE OF B-aceptar IN FRAME FRAME-A /* Aceptar */
DO:
    ASSIGN FRAME FRAME-A
    {&FIELDS-IN-QUERY-{&FRAME-NAME}}.
    RUN Niveles.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.Cc1Cta6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.Cc1Cta6 WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.Cc1Cta6 IN FRAME FRAME-A /* Contra Cta */
DO:
    IF LOOKUP( CHR( LASTKEY ), "0,1,2,3,4,5,6,7,8,9") = 0
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.Cc1Cta9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.Cc1Cta9 WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.Cc1Cta9 IN FRAME FRAME-A /* Contra Cta */
DO:
    IF LOOKUP( CHR( LASTKEY ), "0,1,2,3,4,5,6,7,8,9") = 0
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.DetCfg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.DetCfg WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.DetCfg IN FRAME FRAME-A /* Cuenta Contable */
DO:
    IF NOT ( LASTKEY = KEYCODE("x") OR LASTKEY = KEYCODE("X")
        OR LASTKEY = KEYCODE(".") )
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.GenAut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.GenAut WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.GenAut IN FRAME FRAME-A /* Otras */
DO:
    IF LOOKUP( CHR( LASTKEY ), "0,1,2,3,4,5,6,7,8,9,,,") = 0
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.GenAut6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.GenAut6 WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.GenAut6 IN FRAME FRAME-A /* Con Clase 6 */
DO:
    IF LOOKUP( CHR( LASTKEY ), "0,1,2,3,4,5,6,7,8,9,,,") = 0
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfga.GenAut9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfga.GenAut9 WINDOW-1
ON ANY-PRINTABLE OF cb-cfga.GenAut9 IN FRAME FRAME-A /* Con Clase 9 */
DO:
    IF LOOKUP( CHR( LASTKEY ), "0,1,2,3,4,5,6,7,8,9,,,") = 0
    THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK WINDOW-1 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON GO OF FRAME FRAME-A DO:
  APPLY "CHOOSE" TO B-aceptar.
END.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    FIND cb-cfga WHERE cb-cfga.CodCia = y-CodCia 
        AND CodCfg = 1 EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE cb-cfga THEN DO:
    CREATE cb-cfga.
           cb-cfga.CodCia = y-CodCia.
           cb-cfga.CodCfg = 1.
    END.  
    RUN enable_UI.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI WINDOW-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(WINDOW-1)
  THEN DELETE WIDGET WINDOW-1.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI WINDOW-1 _DEFAULT-ENABLE
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

  {&OPEN-QUERY-FRAME-A}
  GET FIRST FRAME-A.
  IF AVAILABLE cb-cfga THEN 
    DISPLAY cb-cfga.GenAut9 cb-cfga.Cc1Cta9 cb-cfga.GenAut6 cb-cfga.Cc1Cta6 
          cb-cfga.GenAut cb-cfga.DetCfg cb-cfga.CodDiv 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  ENABLE RECT-4 RECT-5 RECT-6 B-aceptar B-cancelar cb-cfga.GenAut9 
         cb-cfga.Cc1Cta9 cb-cfga.GenAut6 cb-cfga.Cc1Cta6 cb-cfga.GenAut 
         cb-cfga.DetCfg cb-cfga.CodDiv 
      WITH FRAME FRAME-A IN WINDOW WINDOW-1.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW WINDOW-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Niveles WINDOW-1 
PROCEDURE Niveles :
DEFI VARI j AS INTEGER.
    DEFI VARI nivel AS INTEGER INITIAL 0.

    cb-niveles = "".
    REPEAT j = 1 TO NUM-ENTRIES(cb-cfga.DetCfg, "."):
        nivel = nivel + LENGTH( ENTRY( j, cb-cfga.detCfg, ".") ).
        IF cb-niveles <> "" THEN cb-niveles = cb-niveles + ",".
        cb-niveles = cb-niveles + STRING( nivel, "9").
    END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


