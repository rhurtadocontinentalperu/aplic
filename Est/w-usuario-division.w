&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

DEF SHARED VAR s-codcia AS INT.
DEFINE VAR lDivisiones AS CHARACTER.
DEFINE VAR lDivisiones_del_usuario AS CHARACTER.

lDivisiones = ?.

FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
    IF lDivisiones = ? THEN lDivisiones = gn-divi.coddiv + " " + gn-divi.desdiv.
    ELSE lDivisiones = lDivisiones + "," + gn-divi.coddiv + " " + gn-divi.desdiv.
END.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS SELECT-usuarios SELECT-usr_div ~
SELECT-divisiones BUTTON-add BUTTON-remove BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS SELECT-usuarios SELECT-usr_div ~
SELECT-divisiones FILL-IN-user FILL-IN-nombre 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-add 
     LABEL "<< Añadir" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-remove 
     LABEL "Remover >>" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-nombre AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-user AS CHARACTER FORMAT "X(256)":U 
     LABEL "User" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE SELECT-divisiones AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 34 BY 12.65 NO-UNDO.

DEFINE VARIABLE SELECT-usr_div AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 32 BY 12.65 NO-UNDO.

DEFINE VARIABLE SELECT-usuarios AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 35.72 BY 12.69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     SELECT-usuarios AT ROW 2.85 COL 2.29 NO-LABEL WIDGET-ID 2
     SELECT-usr_div AT ROW 2.88 COL 40.86 NO-LABEL WIDGET-ID 6
     SELECT-divisiones AT ROW 2.88 COL 90.72 NO-LABEL WIDGET-ID 8
     BUTTON-add AT ROW 5.31 COL 74 WIDGET-ID 16
     BUTTON-remove AT ROW 6.77 COL 74.14 WIDGET-ID 18
     BUTTON-1 AT ROW 12.85 COL 74 WIDGET-ID 24
     FILL-IN-user AT ROW 15.77 COL 9 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-nombre AT ROW 15.81 COL 33 COLON-ALIGNED WIDGET-ID 22
     "Divisiones disponibles" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 2.04 COL 96.29 WIDGET-ID 14
          FONT 6
     "Divisiones del Usuario" VIEW-AS TEXT
          SIZE 19.14 BY .62 AT ROW 1.96 COL 45 WIDGET-ID 10
          FONT 6
     "      Usuarios" VIEW-AS TEXT
          SIZE 35.57 BY 1.08 AT ROW 1.77 COL 2.43 WIDGET-ID 4
          FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.14 BY 16.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Mantenimiento de Usuario - Division."
         HEIGHT             = 16.08
         WIDTH              = 125.14
         MAX-HEIGHT         = 32.23
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.23
         VIRTUAL-WIDTH      = 205.72
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-nombre IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-user IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Mantenimiento de Usuario - Division. */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Mantenimiento de Usuario - Division. */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Grabar */
DO:
    DEFINE VAR z AS INTEGER.
    DEFINE VAR lUsuario AS CHARACTER.

     lUsuario = FILL-IN-user:SCREEN-VALUE IN FRAME f-Main.

    /* Borro los anteriores */
    FOR EACH dwh_usuario_division WHERE dwh_usuario_division.codcia = s-codcia AND 
            dwh_usuario_division.user-id = lUsuario EXCLUSIVE-LOCK:
        DELETE dwh_usuario_division.
    END.
    DO z = 1 TO NUM-ENTRIES(SELECT-usr_div:LIST-ITEMS):
        CREATE dwh_usuario_division.
        ASSIGN dwh_usuario_division.codcia = s-codcia
            dwh_usuario_division.USER-ID = lUsuario
            dwh_usuario_division.coddiv = substring(ENTRY(z, SELECT-usr_div:LIST-ITEMS),1,5).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-add W-Win
ON CHOOSE OF BUTTON-add IN FRAME F-Main /* << Añadir */
DO:
      IF SELECT-divisiones:SCREEN-VALUE = ? THEN RETURN NO-APPLY.

    DEFINE VARIABLE estado AS LOGICAL.

    ASSIGN
        ESTADO = SELECT-usr_div:ADD-LAST(SELECT-divisiones:SCREEN-VALUE)
        ESTADO = SELECT-divisiones:DELETE(SELECT-divisiones:SCREEN-VALUE).

    IF Button-remove:SENSITIVE = FALSE THEN ASSIGN Button-remove:SENSITIVE = TRUE.
    IF SELECT-divisiones:LIST-ITEMS = ? THEN
        ASSIGN Button-add:SENSITIVE = FALSE.
    ELSE
        ASSIGN
            SELECT-divisiones:SCREEN-VALUE =
            SELECT-divisiones:ENTRY(SELECT-divisiones:NUM-ITEMS).
    ASSIGN
        SELECT-usr_div:SCREEN-VALUE =
        SELECT-usr_div:ENTRY(SELECT-usr_div:NUM-ITEMS).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-remove W-Win
ON CHOOSE OF BUTTON-remove IN FRAME F-Main /* Remover >> */
DO:
  
    IF SELECT-usr_div:SCREEN-VALUE = ? THEN RETURN NO-APPLY.

    DEFINE VARIABLE estado AS LOGICAL.

    ASSIGN
        ESTADO = SELECT-divisiones:ADD-LAST(SELECT-usr_div:SCREEN-VALUE)
        ESTADO = SELECT-usr_div:DELETE(SELECT-usr_div:SCREEN-VALUE).

    IF Button-add:SENSITIVE = FALSE THEN ASSIGN Button-add:SENSITIVE = TRUE.
    IF SELECT-usr_div:LIST-ITEMS = ? THEN ASSIGN Button-remove:SENSITIVE = FALSE.

    IF SELECT-divisiones:LIST-ITEMS = ? THEN
        ASSIGN Button-remove:SENSITIVE = FALSE.
    ELSE
        ASSIGN
            SELECT-usr_div:SCREEN-VALUE =
            SELECT-usr_div:ENTRY(SELECT-usr_div:NUM-ITEMS).
    ASSIGN
        SELECT-divisiones:SCREEN-VALUE =
        SELECT-divisiones:ENTRY(SELECT-divisiones:NUM-ITEMS).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-usuarios
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-usuarios W-Win
ON VALUE-CHANGED OF SELECT-usuarios IN FRAME F-Main
DO:
  
  IF SELECT-usuarios:SCREEN-VALUE = ? THEN RETURN NO-APPLY.

  ASSIGN FILL-IN-user:SCREEN-VALUE = ENTRY(1,SELECT-usuarios:SCREEN-VALUE," ").
  ASSIGN FILL-IN-nombre:SCREEN-VALUE = ENTRY(2,SELECT-usuarios:SCREEN-VALUE," ").
 
  RUN carga_divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_divisiones W-Win 
PROCEDURE carga_divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 DEFINE VARIABLE i      AS INTEGER.
 DEFINE VAR z AS INTEGER.
 DEFINE VARIABLE estado AS LOGICAL.
 DEFINE VARIABLE lUsuario AS CHARACTER.
 DEFINE VARIABLE lDivision AS CHARACTER.
 DEFINE VARIABLE lUser-divi AS CHARACTER.
 DEFINE VAR lExiste AS LOGICAL.

 IF SELECT-usuarios:SCREEN-VALUE IN FRAME f-Main = ? THEN RETURN NO-APPLY.

 lUsuario = FILL-IN-user:SCREEN-VALUE IN FRAME f-Main.
 lUser-divi = ?.

FOR EACH dwh_usuario_division WHERE dwh_usuario_division.codcia = s-codcia AND dwh_usuario_division.user-id = lUsuario NO-LOCK:
    FIND FIRST gn-divi WHERE gn-divi.codcia = dwh_usuario_division.codcia AND gn-divi.coddiv = dwh_usuario_division.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        IF trim(dwh_usuario_division.coddiv) = '' THEN NEXT.
        IF lUser-divi = ? THEN lUser-divi = dwh_usuario_division.coddiv + " " + gn-divi.desdiv.
        ELSE lUser-divi = lUser-divi + "," + dwh_usuario_division.coddiv + " " + gn-divi.desdiv.
    END.
END.


ASSIGN SELECT-usr_div:LIST-ITEMS IN FRAME F-Main = "".
ASSIGN SELECT-usr_div:LIST-ITEMS IN FRAME F-Main = lUser-divi.

lDivision = ?.
DO z = 1 TO NUM-ENTRIES(lDivisiones):
    lExiste = NO.
    IF SELECT-usr_div:LIST-ITEMS = ? OR LOOKUP(ENTRY(z, lDivisiones), SELECT-usr_div:LIST-ITEMS) = 0 THEN DO:
        IF lDivision = ? THEN lDivision = ENTRY(z, lDivisiones).
        ELSE lDivision = lDivision + "," + ENTRY(z, lDivisiones).
    END.
END.

ASSIGN SELECT-divisiones:LIST-ITEMS IN FRAME F-Main = "".
ASSIGN SELECT-divisiones:LIST-ITEMS IN FRAME F-Main = lDivision.

Button-remove:SENSITIVE = TRUE.
IF SELECT-usr_div:LIST-ITEMS = ? OR SELECT-usr_div:LIST-ITEMS = "" THEN DO:
    Button-remove:SENSITIVE = FALSE.    
END.

Button-add:SENSITIVE = TRUE.
IF SELECT-divisiones:LIST-ITEMS = ? OR SELECT-divisiones:LIST-ITEMS = "" THEN DO:
   Button-add:SENSITIVE = FALSE.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY SELECT-usuarios SELECT-usr_div SELECT-divisiones FILL-IN-user 
          FILL-IN-nombre 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE SELECT-usuarios SELECT-usr_div SELECT-divisiones BUTTON-add 
         BUTTON-remove BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE list-user AS CHARACTER.
  DEFINE VARIABLE usuario  AS CHARACTER.

  /*FOR EACH pf-G004 WHERE pf-G004.Aplic-Id = s-aplic-id NO-LOCK:*/
  FOR EACH pf-G004 WHERE pf-G004.Aplic-Id = 'EST' NO-LOCK:
      FIND FIRST dictDB._user WHERE dictDB._user._userid = pf-G004.USER-ID NO-LOCK NO-ERROR.
      IF AVAILABLE dictDB._user THEN DO:      
        IF list-user = "" THEN DO :
            ASSIGN list-user = pf-G004.USER-ID + " " + dictDB._user._user-name.
        END.
        ELSE DO:
            IF LOOKUP(pf-G004.User-Id, list-user) = 0 THEN
                ASSIGN list-user = list-user + "," + pf-G004.User-Id + " " + dictDB._user._user-name.
        END.
      END.
  END.

  ASSIGN SELECT-usuarios:LIST-ITEMS IN FRAME F-Main = list-user.

  IF SELECT-usuarios:LIST-ITEMS <> ? THEN
      ASSIGN SELECT-usuarios:SCREEN-VALUE = SELECT-usuarios:ENTRY(1).

        ASSIGN FILL-IN-user:SCREEN-VALUE = ENTRY(1,SELECT-usuarios:SCREEN-VALUE," ").
        ASSIGN FILL-IN-nombre:SCREEN-VALUE = ENTRY(2,SELECT-usuarios:SCREEN-VALUE," ").

   RUN carga_divisiones.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

