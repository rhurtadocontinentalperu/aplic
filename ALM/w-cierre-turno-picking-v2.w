&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE Condicion ( PikSacadores.CodCia = s-codcia ~
    AND PikSacadores.CodDiv = s-coddiv ~
    AND PikSacadores.FlgEst = "A" )

DEF VAR x-NomPer AS CHAR NO-UNDO.
DEF VAR x-CodPed LIKE VtaCDocu.CodPed NO-UNDO.
DEF VAR x-NroPed LIKE VtaCDocu.NroPed NO-UNDO.
DEF VAR x-FchIni LIKE VtaCDocu.FchInicio NO-UNDO.
DEF VAR x-FchFin LIKE VtaCDocu.FchFin NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PikSacadores PL-PERS VtaCDocu

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 ~
(IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea ~
PikSacadores.CodPer fNomPer() @ x-NomPer PikSacadores.Fecha ~
PikSacadores.Sector VtaCDocu.CodPed VtaCDocu.NroPed VtaCDocu.FchInicio ~
VtaCDocu.FchFin VtaCDocu.Items 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH PikSacadores ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST PL-PERS OF PikSacadores NO-LOCK, ~
      LAST VtaCDocu WHERE VtaCDocu.CodCia = PikSacadores.CodCia ~
  AND VtaCDocu.UsrSac = PikSacadores.CodPer ~
 ~
  AND VtaCDocu.DivDes = PikSacadores.CodDiv OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH PikSacadores ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST PL-PERS OF PikSacadores NO-LOCK, ~
      LAST VtaCDocu WHERE VtaCDocu.CodCia = PikSacadores.CodCia ~
  AND VtaCDocu.UsrSac = PikSacadores.CodPer ~
 ~
  AND VtaCDocu.DivDes = PikSacadores.CodDiv OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 PikSacadores PL-PERS VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 PikSacadores
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-3 VtaCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 BUTTON-Refrescar ~
BUTTON-Cierra-Marcados BUTTON-Cierra-Todos BROWSE-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Cierra-Marcados 
     LABEL "CIERRA SELECCIONADOS" 
     SIZE 24 BY 1.12.

DEFINE BUTTON BUTTON-Cierra-Todos 
     LABEL "CIERRA TODOS" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY .96
     BGCOLOR 9 FGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      PikSacadores, 
      PL-PERS, 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      (IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea COLUMN-LABEL "Estado" FORMAT "x(10)":U
            WIDTH 7.43
      PikSacadores.CodPer FORMAT "X(10)":U WIDTH 6.72
      fNomPer() @ x-NomPer COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(40)":U
            WIDTH 33.14
      PikSacadores.Fecha COLUMN-LABEL "Fecha Inicio Turno" FORMAT "99/99/9999 HH:MM":U
            WIDTH 13.86
      PikSacadores.Sector FORMAT "x(20)":U WIDTH 14.43
      VtaCDocu.CodPed COLUMN-LABEL "Docum." FORMAT "x(3)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      VtaCDocu.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 10.14
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      VtaCDocu.FchInicio COLUMN-LABEL "Inicio Tarea" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      VtaCDocu.FchFin COLUMN-LABEL "Fin de Tarea" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      VtaCDocu.Items COLUMN-LABEL "#Items" FORMAT ">>>,>>9":U WIDTH 8.29
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 139 BY 22.88
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Refrescar AT ROW 1 COL 2 WIDGET-ID 4
     BUTTON-Cierra-Marcados AT ROW 1 COL 17 WIDGET-ID 6
     BUTTON-Cierra-Todos AT ROW 1 COL 41 WIDGET-ID 10
     BROWSE-3 AT ROW 2.92 COL 3 WIDGET-ID 200
     "DATOS DE LA ULTIMA TAREA O TAREA EN CURSO" VIEW-AS TEXT
          SIZE 44 BY .5 AT ROW 2.15 COL 89 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Seleccione uno mas registros" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 25.81 COL 3 WIDGET-ID 8
          BGCOLOR 9 FGCOLOR 15 
     RECT-3 AT ROW 1.96 COL 81 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "CIERRE DE TURNO DE SACADORES DEL DIA"
         HEIGHT             = 25.85
         WIDTH              = 144.29
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-3 BUTTON-Cierra-Todos F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.PikSacadores,INTEGRAL.PL-PERS OF INTEGRAL.PikSacadores,INTEGRAL.VtaCDocu WHERE INTEGRAL.PikSacadores ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, LAST OUTER"
     _Where[1]         = "{&Condicion}"
     _JoinCode[3]      = "VtaCDocu.CodCia = PikSacadores.CodCia
  AND VtaCDocu.UsrSac = PikSacadores.CodPer

  AND VtaCDocu.DivDes = PikSacadores.CodDiv"
     _FldNameList[1]   > "_<CALC>"
"(IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea" "Estado" "x(10)" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.PikSacadores.CodPer
"PikSacadores.CodPer" ? ? "character" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fNomPer() @ x-NomPer" "Apellidos y Nombres" "x(40)" ? ? ? ? ? ? ? no ? no no "33.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PikSacadores.Fecha
"PikSacadores.Fecha" "Fecha Inicio Turno" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no "13.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PikSacadores.Sector
"PikSacadores.Sector" ? "x(20)" "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaCDocu.CodPed
"VtaCDocu.CodPed" "Docum." ? "character" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Número" ? "character" 11 0 ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaCDocu.FchInicio
"VtaCDocu.FchInicio" "Inicio Tarea" "99/99/9999 HH:MM:SS" "datetime" 11 0 ? ? ? ? no ? no no "15.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.VtaCDocu.FchFin
"VtaCDocu.FchFin" "Fin de Tarea" "99/99/9999 HH:MM:SS" "datetime" 11 0 ? ? ? ? no ? no no "15.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaCDocu.Items
"VtaCDocu.Items" "#Items" ? "integer" 11 0 ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CIERRE DE TURNO DE SACADORES DEL DIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CIERRE DE TURNO DE SACADORES DEL DIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cierra-Marcados
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cierra-Marcados W-Win
ON CHOOSE OF BUTTON-Cierra-Marcados IN FRAME F-Main /* CIERRA SELECCIONADOS */
DO:
   RUN Cierra-Marcados.
   IF AVAILABLE(PikSacadores) THEN RELEASE PikSacadores.
   APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Cierra-Todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Cierra-Todos W-Win
ON CHOOSE OF BUTTON-Cierra-Todos IN FRAME F-Main /* CIERRA TODOS */
DO:
  RUN Cierra-Todos.
  IF AVAILABLE(PikSacadores) THEN RELEASE PikSacadores.
  APPLY 'CHOOSE':U TO BUTTON-Refrescar IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Marcados W-Win 
PROCEDURE Cierra-Marcados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Se va a cerrar el turno de todos los sacadores SELECCIONADOS' SKIP
    'que estén LIBRES, sin tareas pendientes' SKIP
    'Continuamos con el proceso?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
DEF VAR k AS INT NO-UNDO.
RLOOP:
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT PikSacadores EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN NEXT RLOOP.
        IF PikSacadores.FlgTarea = "O" THEN NEXT RLOOP.
        ASSIGN
            PikSacadores.FlgEst = "C"
            PikSacadores.FchCierre = DATETIME(TODAY,MTIME)
            PikSacadores.UsrCierre = s-user-id.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Todos W-Win 
PROCEDURE Cierra-Todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Se va a cerrar el turno de TODOS los sacadores' SKIP
    'que estén LIBRES, sin tareas pendientes' SKIP
    'Continuamos con el proceso?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
DEF VAR k AS INT NO-UNDO.
RLOOP:
FOR EACH PikSacadores WHERE {&Condicion} EXCLUSIVE-LOCK ON ERROR UNDO, NEXT ON STOP UNDO, NEXT:
    IF PikSacadores.FlgTarea = "O" THEN NEXT RLOOP.
    ASSIGN
        PikSacadores.FlgEst = "C"
        PikSacadores.FchCierre = DATETIME(TODAY,MTIME)
        PikSacadores.UsrCierre = s-user-id.
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
  ENABLE RECT-3 BUTTON-Refrescar BUTTON-Cierra-Marcados BUTTON-Cierra-Todos 
         BROWSE-3 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "PikSacadores"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "VtaCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE PikSacadores THEN DO:
      DEF VAR pNomPer AS CHAR NO-UNDO.
      RUN gn/nombre-personal (s-codcia, PikSacadores.CodPer, OUTPUT pNomPer).
      RETURN pNomPer.
  END.
  RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

