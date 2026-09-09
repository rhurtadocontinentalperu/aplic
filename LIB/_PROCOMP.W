&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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

  Created: 07/27/95 - 12:10 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE SELECT-DIR AS CHARACTER.
DEFINE VARIABLE ITEM-DIR   AS CHARACTER.
DEFINE VARIABLE TARGET     AS CHARACTER.
DEFINE VARIABLE SOURCE     AS CHARACTER.
DEFINE VARIABLE I          AS INTEGER.
DEFINE STREAM dirlist.
DEFINE VARIABLE PTO        AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 SELECT-1 p-direc BUTTON-2 SELECT-2 ~
BUTTON-3 BUTTON-4 COMBO-BOX-1 
&Scoped-Define DISPLAYED-OBJECTS SELECT-1 p-direc SELECT-2 COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "&Compilar" 
     SIZE 15 BY 1.08.

DEFINE BUTTON BUTTON-2 
     LABEL "&Marcar Todo" 
     SIZE 15 BY 1.08.

DEFINE BUTTON BUTTON-3 AUTO-END-KEY 
     LABEL "&Salir" 
     SIZE 15 BY 1.08.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "IMG/valmiesa"
     LABEL "" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "*.W,*.P","*.W","*.P" 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE p-direc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE SELECT-1 AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE NO-DRAG SORT SCROLLBAR-VERTICAL 
     SIZE 31 BY 5.92
     FONT 2 NO-UNDO.

DEFINE VARIABLE SELECT-2 AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 25 BY 6.19
     FONT 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BUTTON-1 AT ROW 1.27 COL 61
     SELECT-1 AT ROW 2.08 COL 2 NO-LABEL
     p-direc AT ROW 2.08 COL 33 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 2.62 COL 61
     SELECT-2 AT ROW 3.15 COL 35 NO-LABEL
     BUTTON-3 AT ROW 3.96 COL 61
     BUTTON-4 AT ROW 6.5 COL 65
     COMBO-BOX-1 AT ROW 8.27 COL 2 NO-LABEL
     " Archivos:" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 1.27 COL 2
          BGCOLOR 1 FGCOLOR 15 
     " Directorios:" VIEW-AS TEXT
          SIZE 25 BY .62 AT ROW 1.27 COL 35
          BGCOLOR 1 FGCOLOR 15 
     SPACE(16.85) SKIP(7.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Compilador".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 DIALOG-1
ON CHOOSE OF BUTTON-1 IN FRAME DIALOG-1 /* Compilar */
DO:
  SOURCE = p-direc + "/" + SELECT-2:SCREEN-VALUE + "/".
  TARGET = SOURCE.
/*  TARGET = "./GUI/" + SELECT-2:SCREEN-VALUE + "/". */
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  PAUSE 0.
  DO I = 1 TO NUM-ENTRIES( SELECT-1:SCREEN-VALUE ):
    ITEM-DIR  = SOURCE + ENTRY( I, SELECT-1:SCREEN-VALUE ).
    
    DISPLAY "Compilando.." ENTRY( I, SELECT-1:SCREEN-VALUE ) FORMAT "X(15)"
        "->" TARGET FORMAT "X(15)" WITH FRAME F-MENSAJE VIEW-AS DIALOG-BOX 
        10 DOWN NO-LABEL USE-TEXT.
    COMPILE VALUE(ITEM-DIR) SAVE INTO VALUE(TARGET).
    DOWN WITH FRAME F-MENSAJE.
  END. 
  SELECT-1:SCREEN-VALUE      = "".
  pto = SESSION:SET-WAIT-STATE("").
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 DIALOG-1
ON CHOOSE OF BUTTON-2 IN FRAME DIALOG-1 /* Marcar Todo */
DO:
    SELECT-1:SCREEN-VALUE = SELECT-1:LIST-ITEMS.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 DIALOG-1
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME DIALOG-1
DO:
    APPLY "VALUE-CHANGED" TO SELECT-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-1 DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF SELECT-1 IN FRAME DIALOG-1
DO:
  /*
  SOURCE = p-direc + "/" + SELECT-2:SCREEN-VALUE + "/".
  TARGET = "./GUI/" + SELECT-2:SCREEN-VALUE + "/".
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  ITEM-DIR  = SOURCE + ?.
  DISPLAY "Compilado.." ? FORMAT "X(15)"
      "->" TARGET FORMAT "X(15)" WITH FRAME F-MENSAJE VIEW-AS DIALOG-BOX 
      10 DOWN NO-LABEL USE-TEXT.
  COMPILE VALUE(ITEM-DIR) SAVE INTO VALUE(TARGET).
  pto = SESSION:SET-WAIT-STATE("").
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-2 DIALOG-1
ON VALUE-CHANGED OF SELECT-2 IN FRAME DIALOG-1
DO:
  pto = SESSION:SET-WAIT-STATE("GENERAL").
  SELECT-DIR = "".
  IF SELECT-2:SCREEN-VALUE <> ?
  THEN DO:
      SOURCE = p-direc + "/" + SELECT-2:SCREEN-VALUE.
      INPUT STREAM dirlist FROM OS-DIR (SOURCE).
      REPEAT:    
          IMPORT STREAM dirlist ITEM-DIR.
          LASO-1:
          DO:
              CASE COMBO-BOX-1:SCREEN-VALUE:
              WHEN "*.W,*.P" THEN 
                  IF NOT (INDEX(ITEM-DIR, ".W") <> 0 OR INDEX(ITEM-DIR, ".P") <> 0)
                  THEN LEAVE LASO-1.
              WHEN "*.W" THEN 
                  IF NOT INDEX(ITEM-DIR, ".W") <> 0 
                  THEN LEAVE LASO-1.
              WHEN "*.P" THEN 
                  IF NOT INDEX(ITEM-DIR, ".P") <> 0 
                  THEN LEAVE LASO-1.
              OTHERWISE LEAVE LASO-1.
              END CASE.
              IF SELECT-DIR = "" THEN SELECT-DIR = ITEM-DIR.
                                 ELSE SELECT-DIR = SELECT-DIR + "," + ITEM-DIR.
          END.
      END.
      INPUT CLOSE.
  END. 
  SELECT-1:LIST-ITEMS      = SELECT-DIR.
  pto = SESSION:SET-WAIT-STATE("").
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
  

  FILE-INFO:FILE-NAME = "./SRC".  
  IF FILE-INFO:FILE-TYPE = ? OR INDEX(FILE-INFO:FILE-TYPE, "D" ) = 0
  THEN DO:
      BELL.
      MESSAGE "No existe directorio de programas" VIEW-AS ALERT-BOX ERROR.
      LEAVE MAIN-BLOCK.
  END.
  p-direc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = FILE-INFO:FULL-PATHNAME.
  ASSIGN p-direc.
  SELECT-DIR = "".
  INPUT STREAM dirlist FROM OS-DIR (P-direc).
  REPEAT:    
      IMPORT STREAM dirlist ITEM-DIR.
      FILE-INFO:FILE-NAME = p-direc + "/" + ITEM-DIR.
      IF NOT ( ITEM-DIR = "." OR ITEM-DIR = ".." OR ITEM-DIR = "TEMPLATE" ) 
          AND INDEX(FILE-INFO:FILE-TYPE, "D" ) <> 0
      THEN IF SELECT-DIR = "" THEN SELECT-DIR = ITEM-DIR.
                              ELSE SELECT-DIR = SELECT-DIR + "," + ITEM-DIR.
  END.
  INPUT CLOSE.
  SELECT-2:LIST-ITEMS      = SELECT-DIR.
  COMBO-BOX-1:SCREEN-VALUE = ENTRY( 1, COMBO-BOX-1:LIST-ITEMS).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
  DISPLAY SELECT-1 p-direc SELECT-2 COMBO-BOX-1 
      WITH FRAME DIALOG-1.
  ENABLE BUTTON-1 SELECT-1 p-direc BUTTON-2 SELECT-2 BUTTON-3 BUTTON-4 
         COMBO-BOX-1 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


