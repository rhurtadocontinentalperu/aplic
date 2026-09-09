&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEFINE VARIABLE pto AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT  PARAMETER a-Menu AS CHARACTER.
    DEFINE OUTPUT PARAMETER RegAct AS RECID.
&ELSE
    DEFINE VARIABLE a-Menu AS CHARACTER INITIAL "CBD".
    DEFINE VARIABLE RegAct AS RECID.
&ENDIF
RegAct = 0.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  W-Consulta
&Scoped-define BROWSE-NAME brw-consulta

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE brw-consulta                                  */
&Scoped-define FIELDS-IN-QUERY-brw-consulta integral.Menus.CodMnu ~
integral.Menus.Etiqueta 
&Scoped-define OPEN-QUERY-brw-consulta OPEN QUERY brw-consulta FOR EACH integral.Menus ~
      WHERE Menus.Modulo = a-Menu ~
 AND Menus.Etiqueta BEGINS busca:SCREEN-VALUE NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-brw-consulta integral.Menus
&Scoped-define TABLES-IN-QUERY-brw-consulta integral.Menus 

/* Definitions for DIALOG-BOX W-Consulta                                */
&Scoped-define FIELDS-IN-QUERY-W-Consulta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-W-Consulta 
&Scoped-define OPEN-BROWSERS-IN-QUERY-W-Consulta ~
    ~{&OPEN-QUERY-brw-consulta}

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-aceptar AUTO-GO 
     LABEL "&Acepta" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-ayuda 
     LABEL "A&yuda" 
     SIZE 9.72 BY 1.08.

DEFINE BUTTON b-cancelar AUTO-END-KEY 
     LABEL "&Cancela" 
     SIZE 9.72 BY 1.08.

DEFINE VARIABLE Busca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY 1
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 47 BY 2.19
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 4 GRAPHIC-EDGE  
     SIZE 47 BY 10.46
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY brw-consulta FOR integral.Menus SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE brw-consulta QUERY brw-consulta NO-LOCK DISPLAY 
      integral.Menus.CodMnu
      integral.Menus.Etiqueta
    WITH SEPARATORS SIZE 43 BY 8
         BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Consulta
     brw-consulta AT ROW 1.5 COL 3 HELP
          "`"
     Busca AT ROW 10 COL 3 NO-LABEL
     b-aceptar AT ROW 12 COL 5
     b-cancelar AT ROW 12 COL 20
     b-ayuda AT ROW 12 COL 34
     RECT-3 AT ROW 1.04 COL 1.14
     RECT-2 AT ROW 11.5 COL 1.14
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Opciones del Men£".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME W-Consulta:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN Busca IN FRAME W-Consulta
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-consulta
/* Query rebuild information for BROWSE brw-consulta
     _TblList          = "integral.Menus"
     _Options          = "NO-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "Menus.Modulo = a-Menu
 AND Menus.Etiqueta BEGINS busca:SCREEN-VALUE"
     _FldNameList[1]   = integral.Menus.CodMnu
     _FldNameList[2]   = integral.Menus.Etiqueta
     _Query            is OPENED
*/  /* BROWSE brw-consulta */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-aceptar W-Consulta
ON CHOOSE OF b-aceptar IN FRAME W-Consulta /* Acepta */
DO:
      RegAct = RECID( {&FIRST-TABLE-IN-QUERY-brw-consulta} ).
      APPLY "GO" TO brw-consulta.
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brw-consulta
&Scoped-define SELF-NAME brw-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON ANY-PRINTABLE OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "ENTRY" TO Busca.
    APPLY LASTKEY TO Busca. 
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON GO OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-aceptar.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON MOUSE-SELECT-DBLCLICK OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-aceptar.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON RETURN OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-aceptar.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Busca W-Consulta
ON LEAVE OF Busca IN FRAME W-Consulta
DO:
    {&OPEN-QUERY-brw-consulta}
    APPLY "ENTRY" TO brw-consulta.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Busca W-Consulta
ON RETURN OF Busca IN FRAME W-Consulta
DO:
    APPLY "ENTRY" TO brw-consulta.
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

FRAME W-Consulta:X    = CURRENT-WINDOW:WIDTH-PIXELS -
                          FRAME W-Consulta:WIDTH-PIXELS.
FRAME W-Consulta:Y    = CURRENT-WINDOW:HEIGHT-PIXELS -
                         FRAME W-Consulta:HEIGHT-PIXELS + 20.
 
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
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
  DISPLAY Busca 
      WITH FRAME W-Consulta.
  ENABLE RECT-3 brw-consulta Busca RECT-2 b-aceptar b-cancelar b-ayuda 
      WITH FRAME W-Consulta.
  {&OPEN-BROWSERS-IN-QUERY-W-Consulta}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
