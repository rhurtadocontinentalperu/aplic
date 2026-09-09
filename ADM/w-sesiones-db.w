&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-pc-user AS CHAR.

        define var x-sort-direccion as char init "".
        define var x-sort-column as char init "".
        define var x-sort-command as char init "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 tt-w-report.Campo-I[1] ~
tt-w-report.Campo-C[1] tt-w-report.Campo-C[2] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-I[2] tt-w-report.Campo-I[3] ~
tt-w-report.Campo-I[4] tt-w-report.Campo-I[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[1] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH tt-w-report NO-LOCK ~
    BY tt-w-report.Campo-C[1] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 FILL-IN-usuario FILL-IN-conexion ~
BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-usuario FILL-IN-conexion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pc-de-usuario W-Win 
FUNCTION pc-de-usuario RETURNS CHARACTER
  ( INPUT pNroConex AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Refresh" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-conexion AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Conexion" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-usuario AS CHARACTER FORMAT "X(25)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY 1
     FONT 4 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      tt-w-report.Campo-I[1] COLUMN-LABEL "Conexion" FORMAT "->>>>9":U
      tt-w-report.Campo-C[1] COLUMN-LABEL "Usuario" FORMAT "X(15)":U
            WIDTH 16.86
      tt-w-report.Campo-C[2] COLUMN-LABEL "Dispositivo" FORMAT "X(25)":U
            WIDTH 21.43
      tt-w-report.Campo-C[3] COLUMN-LABEL "PC-Usuario" FORMAT "X(25)":U
            WIDTH 19.43
      tt-w-report.Campo-C[4] COLUMN-LABEL "Inicio Conexion" FORMAT "X(25)":U
            WIDTH 21.86
      tt-w-report.Campo-I[2] COLUMN-LABEL "PID" FORMAT "->>>>>>9":U
            WIDTH 10.43
      tt-w-report.Campo-I[3] COLUMN-LABEL "DB Acceso" FORMAT "->>,>>>,>>>,>>9":U
            WIDTH 14.57
      tt-w-report.Campo-I[4] COLUMN-LABEL "DB Lectura" FORMAT "->>,>>>,>>>,>>9":U
            WIDTH 14.86
      tt-w-report.Campo-I[5] COLUMN-LABEL "DB Escritura" FORMAT "->>>,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 144 BY 15.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.08 COL 106 WIDGET-ID 2
     FILL-IN-usuario AT ROW 1.19 COL 58.43 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-conexion AT ROW 1.19 COL 85.57 COLON-ALIGNED WIDGET-ID 8
     BROWSE-4 AT ROW 2.42 COL 3 WIDGET-ID 300
     "   Usuarios conectados al sistema" VIEW-AS TEXT
          SIZE 48 BY 1.15 AT ROW 1.12 COL 3.43 WIDGET-ID 4
          BGCOLOR 15 FGCOLOR 1 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 147.86 BY 17.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Conexions de la Base de Datos"
         HEIGHT             = 17.58
         WIDTH              = 147.86
         MAX-HEIGHT         = 17.58
         MAX-WIDTH          = 147.86
         VIRTUAL-HEIGHT     = 17.58
         VIRTUAL-WIDTH      = 147.86
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
/* BROWSE-TAB BROWSE-4 FILL-IN-conexion F-Main */
ASSIGN 
       BROWSE-4:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-w-report.Campo-C[1]|yes"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-I[1]
"tt-w-report.Campo-I[1]" "Conexion" "->>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Usuario" "X(15)" "character" ? ? ? ? ? ? no ? no no "16.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[2]
"tt-w-report.Campo-C[2]" "Dispositivo" "X(25)" "character" ? ? ? ? ? ? no ? no no "21.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"tt-w-report.Campo-C[3]" "PC-Usuario" "X(25)" "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Inicio Conexion" "X(25)" "character" ? ? ? ? ? ? no ? no no "21.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-I[2]
"tt-w-report.Campo-I[2]" "PID" "->>>>>>9" "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-I[3]
"tt-w-report.Campo-I[3]" "DB Acceso" "->>,>>>,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-I[4]
"tt-w-report.Campo-I[4]" "DB Lectura" "->>,>>>,>>>,>>9" "integer" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-I[5]
"tt-w-report.Campo-I[5]" "DB Escritura" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Conexions de la Base de Datos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Conexions de la Base de Datos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
&Scoped-define SELF-NAME BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-4 IN FRAME F-Main
DO:
  
  IF NOT AVAILABLE tt-w-report THEN RETURN NO-APPLY.

    MESSAGE 'Seguro de CERRAR la siguiente sesion ?' SKIP
            '----------------------------------------------' SKIP
            'Nro. de Sesion  :' tt-w-report.campo-i[1] SKIP
            'Usuario             :' tt-w-report.campo-c[1] SKIP
            'Dispositivo        :' tt-w-report.campo-c[2] SKIP
            'PC Usuario        :' tt-w-report.campo-c[3]
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.

  IF rpta = NO THEN RETURN NO-APPLY.

  CREATE shut_user.
    ASSIGN shut_user.shut_status = YES
            shut_user.shut_id = tt-w-report.campo-i[1]
            shut_user.pc_user = tt-w-report.campo-c[3]
            shut_user.USER_db = tt-w-report.campo-c[1]
            shut_user.fcreacion = NOW
            shut_user.codcia = s-codcia
    .

    RELEASE shut_user.

    RUN cargar-conexiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-4 W-Win
ON START-SEARCH OF BROWSE-4 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-4:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    /*MESSAGE lColumName hSortColumn:LABEL.*/
    lColumName = "".
    IF hSortColumn:LABEL = "Conexion" THEN lColumName = "campo-i[1]".
    IF hSortColumn:LABEL = "Usuario" THEN lColumName = "campo-c[1]".
    IF hSortColumn:LABEL = "Dispositivo" THEN lColumName = "campo-c[2]".
    IF hSortColumn:LABEL = "PC-Usuario" THEN lColumName = "campo-c[3]".
    IF hSortColumn:LABEL = "Inicio Conexion" THEN lColumName = "campo-c[4]".
    IF hSortColumn:LABEL = "DB Acceso" THEN lColumName = "campo-i[3]".
    IF hSortColumn:LABEL = "DB Lectura" THEN lColumName = "campo-i[4]".
    IF hSortColumn:LABEL = "DB Escritura" THEN lColumName = "campo-i[5]".

    IF lColumName = "" THEN RETURN.
    
    IF CAPS(lColumName) <> CAPS(x-sort-column) THEN DO:
        x-sort-direccion = "".
    END.
    ELSE DO:
        IF x-sort-direccion = "" THEN DO:
            x-sort-direccion = "DESC".
        END.
        ELSE DO:            
            x-sort-direccion = "".
        END.
    END.
    x-sort-column = lColumName.
    x-sort-command = "BY " + lColumName + " " + x-sort-direccion.


    hQueryHandle = BROWSE BROWSE-4:QUERY.
    hQueryHandle:QUERY-CLOSE().
    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */
    hQueryHandle:QUERY-PREPARE("FOR EACH tt-w-report " + x-sort-command).
    hQueryHandle:QUERY-OPEN().
  
END.

/*
EACH Temp-Tables.tt-w-report NO-LOCK
    BY tt-w-report.Campo-C[1] INDEXED-REPOSITION
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Refresh */
DO:
    RUN cargar-conexiones.
  {&OPEN-QUERY-BROWSE-4}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-conexiones W-Win 
PROCEDURE cargar-conexiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-w-report.

SESSION:SET-WAIT-STATE("GENERAL").
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-conexion fill-in-usuario .
END.

FOR EACH _Connect WHERE _Connect._Connect-Type = "REMC" NO-LOCK:

    IF NOT (fill-in-conexion <= 0 OR fill-in-conexion = _Connect._Connect-Usr) THEN NEXT.
    IF NOT (fill-in-usuario = "" OR _Connect._Connect-name BEGINS fill-in-usuario) THEN NEXT.

    /*
    FIND LAST AdmCtrlUsers WHERE AdmCtrlUsers.num-PID = INT(logvtatabla.valor[2]) /*_Connect._Connect-pid*/ AND
                                AdmCtrlUsers.fechinicio <= TODAY NO-LOCK NO-ERROR.
*/

    CREATE tt-w-report.
        ASSIGN tt-w-report.campo-i[1] = _Connect._Connect-Usr
                tt-w-report.campo-c[1] = _Connect._Connect-name
                tt-w-report.campo-c[2] = _Connect._Connect-device                
                tt-w-report.campo-c[4] = _Connect._Connect-Time 
                tt-w-report.campo-i[2] = _Connect._Connect-PID
                tt-w-report.campo-i[3] = 0
                tt-w-report.campo-i[4] = 0
                tt-w-report.campo-i[5] = 0.
    
    IF TRUE <> (_Connect._Connect-name > "") THEN DO:
            ASSIGN tt-w-report.campo-c[1] = "¿DATADIGGER?".
    END.
    ELSE DO:
        ASSIGN tt-w-report.campo-c[3] = pc-de-usuario(_Connect-PID). /*pc-de-usuario(_Connect._Connect-Usr)*/
    END.
    FIND FIRST _UserIO WHERE _UserIO._userio-id = _Connect._Connect-id AND
                            _UserIO._userio-usr = _Connect._Connect-usr NO-LOCK NO-ERROR.
    IF AVAILABLE _UserIO THEN DO:
        ASSIGN  tt-w-report.campo-i[3] = _UserIO._userio-DbAccess
                tt-w-report.campo-i[4] = _UserIO._userio-DbRead
                tt-w-report.campo-i[5] = _UserIO._userio-DbWrite.

    END.
END.

{&open-query-browse-4}

SESSION:SET-WAIT-STATE("").

/*OPEN QUERY {&SELF-NAME} FOR EACH _Connect WHERE _Connect._Connect-Type = "REMC" BY _Connect._connect-name.*/

END PROCEDURE.

/*
      _Connect._Connect-Usr       FORMAT '>>99'       COLUMN-LABEL "Conexion" 
_Connect._Connect-Name      FORMAT 'x(12)'      COLUMN-LABEL "Usuario"
_Connect._Connect-device    FORMAT 'x(25)'      COLUMN-LABEL "Dispositivo"
pc-de-usuario(_Connect._Connect-Usr) @ x-pc-user FORMAT 'x(25)'      COLUMN-LABEL "PC del Usuario"
_Connect._Connect-Time      COLUMN-LABEL "Inicio conexion"
_Connect._Connect-PID       FORMAT '>>>>>9'       COLUMN-LABEL "Nro. PID"
_Connect._Connect-Wait
_Connect._Connect-Wait1
_Connect._Connect-TransID
_Connect._Connect-Server
_Connect._Connect-Type

*/

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
  DISPLAY FILL-IN-usuario FILL-IN-conexion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 FILL-IN-usuario FILL-IN-conexion BROWSE-4 
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
  RUN cargar-conexiones.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pc-de-usuario W-Win 
FUNCTION pc-de-usuario RETURNS CHARACTER
  ( INPUT pNroConex AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR INIT "".

    /*    
    FIND FIRST AdmCtrlUsers WHERE AdmCtrlUsers.num-PID = pNroConex AND
                                    AdmCtrlUsers.fechinicio >= TODAY - 2 NO-LOCK NO-ERROR.
    */
    FIND LAST AdmCtrlUsers WHERE AdmCtrlUsers.num-PID = pNroConex AND
                                    AdmCtrlUsers.fechinicio <= TODAY AND 
                                    AdmCtrlUsers.UserDb = tt-w-report.campo-c[1] NO-LOCK NO-ERROR.

    IF AVAILABLE AdmCtrlUsers THEN DO:

        x-retval = AdmCtrlUsers.pcusuario.

    END.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

