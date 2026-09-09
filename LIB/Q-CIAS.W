&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    W-Consulta
&Scoped-define FRAME-NAME     W-Consulta
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

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER INITIAL "JORGE".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id AS CHARACTER INITIAL "CBD".
DEFINE {&NEW} SHARED VARIABLE x-Grupo  AS CHARACTER INITIAL "9".
DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER   INITIAL 0.
DEFINE {&NEW} SHARED VARIABLE s-nomcia AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE x-DirCia AS CHARACTER INITIAL "".
DEFINE {&NEW} SHARED VARIABLE S-ADMIN   AS LOGICAL   INITIAL FALSE.
DEFINE VARIABLE LISTA-CIA AS CHARACTER NO-UNDO.
DEFINE VARIABLE LISTA-COD AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER   NO-UNDO INITIAL 0.
DEFINE VARIABLE xdet      AS CHARACTER NO-UNDO.
DEFINE VARIABLE MultiCia  AS LOGICAL   NO-UNDO INITIAL NO.

IF s-user-id = "MASTER"
THEN DO:
    MultiCia = YES.
    x-Grupo = " ".
END.
ELSE DO:
    FIND FIRST UserMod WHERE UserMod.Usuario = s-user-id 
                AND UserMod.Modulo = s-aplic-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE UserMod
    THEN DO:
        MESSAGE "No existen Empresas Inscritas al Usuario"
                 VIEW-AS ALERT-BOX ERROR.
        QUIT.
    END.
    IF UserMod.CodCia = 0 THEN MultiCia = Yes.
    S-ADMIN  = UserMod.admin.
    x-Grupo   =  UserMod.Grupo.
END. 
            
IF MultiCia
THEN DO:
    FIND FIRST Empresas NO-LOCK NO-ERROR.
    IF AVAILABLE Empresas
    THEN DO:
        lista-cia = Empresas.NomCia. 
        lista-cod = STRING(Empresas.CodCia, "999").                   
        s-codcia  = Empresas.CodCia.
        s-nomcia  = Empresas.NomCia.
        i = i + 1.               
        REPEAT:
            FIND NEXT Empresas NO-LOCK.
            lista-cia = lista-cia + "," + Empresas.NomCia.
            lista-cod = lista-cod + "," + STRING(Empresas.CodCia, "999").
            i   = i + 1.
        END.
    END.
END.
ELSE DO:
    FOR EACH UserMod WHERE UserMod.Usuario = s-user-id      
                       AND UserMod.Modulo = s-aplic-id 
                        NO-LOCK:
        FIND Empresas WHERE Empresas.CodCia = UserMod.CodCia
                NO-LOCK NO-ERROR.
        IF AVAILABLE Empresas
        THEN DO:
            IF Lista-cia = ""
            THEN DO:
                s-codcia  = Empresas.CodCia.
                s-nomcia  = Empresas.NomCia.
                x-DirCia  = Empresas.Direccion.
                lista-cia = Empresas.NomCia.
                lista-cod = STRING(Empresas.CodCia, "999").
            END.
            ELSE DO:
                lista-cia = lista-cia + "," + Empresas.NomCia.
                lista-cod = lista-cod + "," + STRING(Empresas.CodCia, "999").
            END.
            i   = i + 1.
        END.
    END.
END.

DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

IF i = 0
THEN DO:
    MESSAGE "No existen Empresas Inscritas al Usuario"
             VIEW-AS ALERT-BOX ERROR.
    QUIT.
END.

IF i = 1
THEN RETURN.

s-codcia = ?.
s-nomcia = ?.
x-DirCia = ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  W-Consulta

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for DIALOG-BOX W-Consulta                                */
&Scoped-define FIELDS-IN-QUERY-W-Consulta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-W-Consulta 

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
     SIZE 47 BY 2.19
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 47 BY 8.96
     BGCOLOR 8 .

DEFINE VARIABLE SELECT-CIA AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SIZE 45 BY 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Consulta
     SELECT-CIA AT ROW 1.5 COL 2 NO-LABEL
     b-acepta AT ROW 10.5 COL 5
     b-cancela AT ROW 10.5 COL 20
     b-ayuda AT ROW 10.5 COL 34
     RECT-3 AT ROW 1.04 COL 1.14
     RECT-2 AT ROW 10 COL 1
     SPACE(0.14) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Compa¤ias".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-Consulta:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-acepta W-Consulta
ON CHOOSE OF b-acepta IN FRAME W-Consulta /* Acepta */
DO:
      APPLY "GO" TO SELECT-CIA.
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-CIA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CIA W-Consulta
ON GO OF SELECT-CIA IN FRAME W-Consulta
DO:
    IF SELECT-CIA:SCREEN-VALUE = ?
    THEN DO:
        MESSAGE "NO SELECCIONO UNA OPCION" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    s-codcia = INTEGER( ENTRY( LOOKUP(SELECT-CIA:SCREEN-VALUE, lista-CIA)
            , lista-cod ) ).
    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE Empresas
    THEN ASSIGN s-nomcia = Empresas.NomCia
                X-DirCia = Empresas.Direccion.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CIA W-Consulta
ON MOUSE-SELECT-DBLCLICK OF SELECT-CIA IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-acepta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CIA W-Consulta
ON RETURN OF SELECT-CIA IN FRAME W-Consulta
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
 
SELECT-CIA:LIST-ITEMS   IN FRAME W-Consulta = Lista-cia.
SELECT-CIA:SCREEN-VALUE IN FRAME W-Consulta = ENTRY( 1, Lista-cia ).

FRAME W-Consulta:X    = CURRENT-WINDOW:WIDTH-PIXELS -
                          FRAME W-Consulta:WIDTH-PIXELS.
FRAME W-Consulta:Y    = CURRENT-WINDOW:HEIGHT-PIXELS -
                         FRAME W-Consulta:HEIGHT-PIXELS + 20.
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF SELECT-CIA:SCREEN-VALUE = ?
  THEN SELECT-CIA:SCREEN-VALUE = ENTRY( 1, SELECT-CIA:LIST-ITEMS ).

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Consulta _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME W-Consulta.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Consulta _DEFAULT-ENABLE
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
  DISPLAY SELECT-CIA 
      WITH FRAME W-Consulta.
  ENABLE RECT-3 SELECT-CIA RECT-2 b-acepta b-cancela b-ayuda 
      WITH FRAME W-Consulta.
  {&OPEN-BROWSERS-IN-QUERY-W-Consulta}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
