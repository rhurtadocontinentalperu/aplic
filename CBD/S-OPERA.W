&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
    DEFINE INPUT     PARAMETER y-CodCia AS INTEGER.
    DEFINE OUTPUT    PARAMETER RegAct   AS RECID.
&ELSE
    DEFINE VARIABLE y-CodCia AS INTEGER INITIAL 0.
    DEFINE VARIABLE RegAct    AS RECID.
&ENDIF
RegAct = 0.
/* Local Variable Definitions ---                                       */
DEFINE {&NEW} SHARED VARIABLE x-codope AS CHARACTER.
DEFINE {&NEW} SHARED VARIABLE x-Nomope AS CHARACTER.
DEFINE {&NEW} SHARED VARIABLE x-selope AS LOGICAL INITIAL NO.
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER INITIAL "MASTER".
DEFINE {&NEW} SHARED VARIABLE S-ADMIN   AS LOGICAL INITIAL NO.
DEFINE {&NEW} SHARED VARIABLE s-aplic-id AS CHARACTER INITIAL "CBD".
DEFINE VARIABLE List-Ope AS  CHARACTER INITIAL "".

/* Buscamos operaciones s¢lo de cuentas por pagar (provisiones) */

IF s-aplic-id = "CXP" THEN DO:
    FOR EACH integral.cp-tpro WHERE integral.cp-tpro.CodCia = y-CodCia:
        IF LOOKUP( integral.cp-tpro.CodOpe, List-Ope ) = 0
        THEN IF List-Ope = "" THEN List-Ope = integral.cp-tpro.CodOPe.
                        ELSE List-Ope = List-Ope + "," + integral.cp-tpro.CodOPe.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME W-Consulta
&Scoped-define BROWSE-NAME brw-consulta

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-oper

/* Definitions for BROWSE brw-consulta                                  */
&Scoped-define FIELDS-IN-QUERY-brw-consulta cb-oper.Codope cb-oper.Nomope 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-consulta 
&Scoped-define FIELD-PAIRS-IN-QUERY-brw-consulta
&Scoped-define OPEN-QUERY-brw-consulta OPEN QUERY brw-consulta FOR EACH cb-oper ~
      WHERE cb-oper.CodCia = y-CodCia ~
AND cb-oper.Nomope BEGINS busca:SCREEN-VALUE ~
AND NOT cb-oper.Origen ~
AND ( ~
   S-ADMIN ~
   OR LOOKUP( s-user-id, cb-oper.Usuarios) <> 0 ~
   OR cb-oper.Usuarios = "" ~
) ~
AND ( s-aplic-id <> "CXP" OR LOOKUP(cb-oper.CodOpe, List-Ope) <> 0 ) ~
 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-consulta cb-oper
&Scoped-define FIRST-TABLE-IN-QUERY-brw-consulta cb-oper


/* Definitions for DIALOG-BOX W-Consulta                                */
&Scoped-define OPEN-BROWSERS-IN-QUERY-W-Consulta ~
    ~{&OPEN-QUERY-brw-consulta}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodOpe brw-consulta RECT-3 b-acepta ~
b-cancela Busca RECT-2 
&Scoped-Define DISPLAYED-OBJECTS F-CodOpe Busca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-acepta AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Acepta" 
     SIZE 11 BY 1.46.

DEFINE BUTTON b-cancela AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancela" 
     SIZE 11 BY 1.46.

DEFINE VARIABLE Busca AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-CodOpe AS CHARACTER FORMAT "X(3)":U 
     LABEL "Operación" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44.86 BY 2
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 44.86 BY 9.19
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brw-consulta FOR 
      cb-oper SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brw-consulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-consulta W-Consulta _STRUCTURED
  QUERY brw-consulta NO-LOCK DISPLAY
      cb-oper.Codope
      cb-oper.Nomope FORMAT "x(64)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 43.72 BY 7.77
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME W-Consulta
     F-CodOpe AT ROW 1.12 COL 8.43 COLON-ALIGNED
     brw-consulta AT ROW 2.27 COL 1.57 HELP
          "`"
     b-acepta AT ROW 11.46 COL 10.29
     b-cancela AT ROW 11.46 COL 26
     Busca AT ROW 10.15 COL 1.72 NO-LABEL
     RECT-3 AT ROW 2.08 COL 1
     RECT-2 AT ROW 11.23 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 8 FONT 4
         TITLE "Operaciones Contables".


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
   EXP-POSITION Custom                                                  */
/* BROWSE-TAB brw-consulta F-CodOpe W-Consulta */
ASSIGN 
       FRAME W-Consulta:SCROLLABLE       = FALSE
       FRAME W-Consulta:ROW              = 5
       FRAME W-Consulta:COLUMN           = 38.

/* SETTINGS FOR FILL-IN Busca IN FRAME W-Consulta
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-consulta
/* Query rebuild information for BROWSE brw-consulta
     _TblList          = "integral.cb-oper"
     _Options          = "NO-LOCK"
     _Where[1]         = "cb-oper.CodCia = y-CodCia
AND cb-oper.Nomope BEGINS busca:SCREEN-VALUE
AND NOT cb-oper.Origen
AND (
   S-ADMIN
   OR LOOKUP( s-user-id, cb-oper.Usuarios) <> 0
   OR cb-oper.Usuarios = """"
)
AND ( s-aplic-id <> ""CXP"" OR LOOKUP(cb-oper.CodOpe, List-Ope) <> 0 )
"
     _FldNameList[1]   = integral.cb-oper.Codope
     _FldNameList[2]   > integral.cb-oper.Nomope
"cb-oper.Nomope" ? "x(64)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE brw-consulta */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-acepta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-acepta W-Consulta
ON CHOOSE OF b-acepta IN FRAME W-Consulta /* Acepta */
DO:
      RegAct = RECID( {&FIRST-TABLE-IN-QUERY-brw-consulta} ).
      x-CodOpe = cb-oper.CodOpe.
      x-NomOpe = cb-oper.NomOpe.
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
    APPLY "CHOOSE" TO B-acepta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON MOUSE-SELECT-DBLCLICK OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO B-acepta.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-consulta W-Consulta
ON RETURN OF brw-consulta IN FRAME W-Consulta
DO:
    APPLY "CHOOSE" TO b-acepta.
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


&Scoped-define SELF-NAME F-CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodOpe W-Consulta
ON LEAVE OF F-CodOpe IN FRAME W-Consulta /* Operación */
DO:
  ASSIGN F-CodOpe.
  IF F-CodOpe <> "" THEN RUN Busca-Codigo.
  F-CodOpe:SCREEN-VALUE = "".
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
/*
FRAME W-Consulta:X    = CURRENT-WINDOW:WIDTH-PIXELS -
                          FRAME W-Consulta:WIDTH-PIXELS.
FRAME W-Consulta:Y    = CURRENT-WINDOW:HEIGHT-PIXELS -
                         FRAME W-Consulta:HEIGHT-PIXELS + 20.
*/

/* Verificando si puede ser seleccionable */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  GET FIRST BRW-Consulta NO-LOCK.
  IF NOT AVAILABLE cb-oper
  THEN DO:
    MESSAGE "No existe Operaciones Disponibles" SKIP
            "Para el usuario " + s-user-id VIEW-AS ALERT-BOX ERROR.
    RUN disable_UI.
    RETURN ERROR.
  END.
  x-codope = cb-oper.CodOpe.
  x-selope = FALSE.
  GET NEXT BRW-Consulta NO-LOCK.
  IF AVAILABLE cb-oper
  THEN x-selope = TRUE.
  ELSE DO:
    RUN disable_UI.
    RETURN ERROR.
  END.

  GET FIRST BRW-Consulta NO-LOCK.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Codigo W-Consulta 
PROCEDURE Busca-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR OUTPUT-VAR-1 AS ROWID.
OUTPUT-VAR-1 = ?.
FIND cb-oper WHERE cb-oper.CodCia = Y-codcia AND
                   cb-oper.CodOpe = F-CodOpe No-LOCK
                   NO-ERROR.
IF AVAILABLE cb-oper THEN OUTPUT-VAR-1 = ROWID(cb-oper).
IF OUTPUT-VAR-1 <> ? THEN DO:   
   REPOSITION {&BROWSE-NAME} TO ROWID OUTPUT-VAR-1 NO-ERROR.   
END.   
ELSE DO :
      MESSAGE "Registro no se encuentra en la actual selección"
              VIEW-AS ALERT-BOX ERROR. 

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY F-CodOpe Busca 
      WITH FRAME W-Consulta.
  ENABLE F-CodOpe brw-consulta RECT-3 b-acepta b-cancela Busca RECT-2 
      WITH FRAME W-Consulta.
  {&OPEN-BROWSERS-IN-QUERY-W-Consulta}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


