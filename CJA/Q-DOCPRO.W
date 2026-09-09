&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME W-Consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Consulta 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 06/26/95 - 12:00 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT  PARAMETER y-codcia AS INTEGER.
    DEFINE OUTPUT PARAMETER x-coddoc AS CHARACTER.
&ELSE
    DEFINE VARIABLE x-coddoc AS CHARACTER.
    DEFINE VARIABLE y-codcia AS INTEGER INITIAL 0.
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE Lista-mod AS CHARACTER NO-UNDO.
DEFINE VARIABLE Lista-cod AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE pto       AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

FOR EACH cp-tpro NO-LOCK WHERE cp-tpro.codcia = y-Codcia:
    IF LOOKUP(cp-tpro.coddoc,lista-cod) = 0 THEN DO:
       FIND cb-tabl WHERE cb-tabl.tabla = "02" AND
                    cb-tabl.codigo = cp-tpro.coddoc NO-LOCK NO-ERROR.
       IF AVAIL cb-tabl THEN DO:
          lista-mod = lista-mod + STRING(cp-tpro.coddoc,"X(4)") + "  " + 
                 cb-tabl.nombre + ",".
          lista-cod = lista-cod + STRING(cp-tpro.coddoc,"X(4)") + ",".
          i = i + 1.
       END.
    END.
END.
IF i = 0 THEN DO:
   MESSAGE "No existen codigos de" SKIP
           "documento en provisiones" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.
ELSE DO:
  lista-mod = SUBSTRING(lista-mod,1,(LENGTH(lista-mod,"CHARACTER") - 1),"CHARACTER").
  lista-cod = SUBSTRING(lista-cod,1,(LENGTH(lista-cod,"CHARACTER") - 1),"CHARACTER").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME W-Consulta

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 SELECT-MOD RECT-2 b-acepta b-cancela ~
b-ayuda 
&Scoped-Define DISPLAYED-OBJECTS SELECT-MOD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-acepta AUTO-GO 
     LABEL "&Acepta" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-ayuda 
     LABEL "A&yuda" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-cancela AUTO-END-KEY 
     LABEL "&Cancela" 
     SIZE 9.72 BY 1.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 35 BY 2.19
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 35 BY 8.96
     BGCOLOR 8 .

DEFINE VARIABLE SELECT-MOD AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SIZE 29 BY 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Consulta
     SELECT-MOD AT ROW 1.5 COL 4 NO-LABEL
     b-acepta AT ROW 10.5 COL 3
     b-cancela AT ROW 10.5 COL 14
     b-ayuda AT ROW 10.5 COL 25
     RECT-3 AT ROW 1 COL 1
     RECT-2 AT ROW 10 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Documentos".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX W-Consulta
   Default                                                              */
ASSIGN 
       FRAME W-Consulta:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-acepta W-Consulta
ON CHOOSE OF b-acepta IN FRAME W-Consulta /* Acepta */
DO:
      APPLY "GO" TO SELECT-MOD.
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-MOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-MOD W-Consulta
ON GO OF SELECT-MOD IN FRAME W-Consulta
DO:
    IF SELECT-MOD:SCREEN-VALUE = ?
    THEN DO:
        MESSAGE "No seleccion¢  ning£n"
                "c¢digo de documento" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-coddoc = (ENTRY(LOOKUP(SELECT-MOD:SCREEN-VALUE, lista-mod), lista-cod)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-MOD W-Consulta
ON MOUSE-SELECT-DBLCLICK OF SELECT-MOD IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-acepta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-MOD W-Consulta
ON RETURN OF SELECT-MOD IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-acepta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Consulta 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
 
SELECT-MOD:LIST-ITEMS   IN FRAME W-Consulta = Lista-mod.
SELECT-MOD:SCREEN-VALUE IN FRAME W-Consulta = ENTRY( 1, Lista-mod ).


FRAME W-Consulta:X    = CURRENT-WINDOW:WIDTH-PIXELS -
                          FRAME W-Consulta:WIDTH-PIXELS.
FRAME W-Consulta:Y    = CURRENT-WINDOW:HEIGHT-PIXELS -
                         FRAME W-Consulta:HEIGHT-PIXELS + 20.
 
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF SELECT-MOD:SCREEN-VALUE = ?
  THEN SELECT-MOD:SCREEN-VALUE = ENTRY(1, SELECT-MOD:LIST-ITEMS).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Consulta _DEFAULT-DISABLE
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
  HIDE FRAME W-Consulta.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Consulta _DEFAULT-ENABLE
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
  DISPLAY SELECT-MOD 
      WITH FRAME W-Consulta.
  ENABLE RECT-3 SELECT-MOD RECT-2 b-acepta b-cancela b-ayuda 
      WITH FRAME W-Consulta.
  {&OPEN-BROWSERS-IN-QUERY-W-Consulta}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


