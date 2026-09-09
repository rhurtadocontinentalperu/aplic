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

DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE s-aplic-id AS CHARACTER.
DEFINE {&NEW} SHARED VARIABLE XPROG    AS CHARACTER.
DEFINE {&NEW} SHARED VARIABLE MultiMod AS LOGICAL.

DEFINE VARIABLE LISTA-MOD AS CHARACTER NO-UNDO.
DEFINE VARIABLE LISTA-COD AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE xdet      AS CHARACTER NO-UNDO.

XPROG = ?.

IF s-user-id = "MASTER"
THEN DO:
    /* CARGAMOS TODOS LOS MODULOS */
    FIND FIRST Modulos NO-LOCK NO-ERROR.
    IF AVAILABLE Modulos
    THEN DO:
        lista-mod = Modulos.Detalle. 
        lista-cod = Modulos.Modulo.                   
        i = i + 1.               
        REPEAT:
            FIND NEXT Modulos NO-LOCK.
            lista-mod = lista-mod + "," + Modulos.Detalle .
            lista-cod = lista-cod + "," + Modulos.Modulo.
            i   = i + 1.
        END.
    END.
END.   
ELSE DO:
    FIND FIRST UserMod WHERE Usuario = s-user-id NO-LOCK NO-ERROR.
    IF AVAILABLE UserMod
    THEN DO:
        FIND Modulos WHERE Modulos.Modulo = UserMod.Modulo NO-LOCK NO-ERROR.
        IF AVAILABLE Modulos
        THEN xdet = Modulos.Detalle.
        ELSE xdet = "Modulo " + UserMod.Modulo .
        lista-mod = xdet.
        lista-cod = UserMod.Modulo.
        i = i + 1.
        REPEAT:
            FIND NEXT UserMod WHERE Usuario = s-user-id NO-LOCK NO-ERROR.
            IF AVAILABLE UserMod
            THEN DO:
                FIND NEXT Modulos WHERE Modulos.Modulo = UserMod.Modulo
                    NO-LOCK.
                IF AVAILABLE Modulos
                THEN xdet = Modulos.Detalle.
                ELSE xdet = "Modulo " + UserMod.Modulo.
                IF LOOKUP( xdet , lista-mod ) = 0
                THEN DO:
                    lista-mod = lista-mod + "," + xdet.
                    lista-cod = lista-cod + "," + UserMod.Modulo.
                    i   = i + 1.
                END.
            END.
            ELSE LEAVE.
        END.
    END.
END.

DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").


CASE i:        
    WHEN 0 THEN DO:
        MESSAGE "No existe Modulos Asignados"
            SKIP "al Usuario"  s-user-id VIEW-AS ALERT-BOX ERROR.
        QUIT.
    END.    
    WHEN 1 THEN DO:
        MultiMod = FALSE.
        s-aplic-id = lista-cod.
        XPROG    =  s-aplic-id + "\" + s-aplic-id + "0000.w".
        RETURN.
    END.
END CASE.

Multimod = TRUE.

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

DEFINE VARIABLE SELECT-MOD AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SIZE 45 BY 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Consulta
     SELECT-MOD AT ROW 1.5 COL 2 NO-LABEL
     b-acepta AT ROW 10.5 COL 5
     b-cancela AT ROW 10.5 COL 20
     b-ayuda AT ROW 10.5 COL 34
     RECT-3 AT ROW 1.04 COL 1.14
     RECT-2 AT ROW 10 COL 1
     SPACE(0.14) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Modulos".

 


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
        MESSAGE "NO SELECCIONO UNA OPCION" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    s-aplic-id = LC( ENTRY( LOOKUP(SELECT-MOD:SCREEN-VALUE, lista-mod)
            , lista-cod ) ).
    XPROG    =  s-aplic-id + "/" + s-aplic-id + "0000.w".
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
  DISPLAY SELECT-MOD 
      WITH FRAME W-Consulta.
  ENABLE RECT-3 SELECT-MOD RECT-2 b-acepta b-cancela b-ayuda 
      WITH FRAME W-Consulta.
  {&OPEN-BROWSERS-IN-QUERY-W-Consulta}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
