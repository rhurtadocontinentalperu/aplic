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

/* Sectores a mostrar */
DEF VAR x-Sectores AS CHAR INIT 'Todos' NO-UNDO.

DEFINE VAR lPiksacadores AS INT INIT 1.

&SCOPED-DEFINE Condicion ( PikSacadores.CodCia = s-codcia ~
    AND PikSacadores.CodDiv = s-coddiv ~
    AND PikSacadores.FlgEst = "A" ~
        AND ( lPikSacadores = 3 OR (lPiksacadores = 1 AND PikSacadores.flgtarea = 'L') OR (lPiksacadores = 2 AND PikSacadores.flgtarea = 'O') ) ~
    )
        
        /* ~
    AND (rsPiksacadores = 3 OR (rspiksacadores = 1 AND PikSacadores.flgtarea = 'L') ~
         OR (rsPiksacadores = 2 AND piksacadores.flgtarea = 'O') ) ~
        )                            */

&SCOPED-DEFINE Condiciontareas ( Piktareas.CodCia = s-codcia ~
    AND Piktareas.CodDiv = s-coddiv ~
    AND Piktareas.codper = piksacadores.codper ~
    AND (rsTareas = 3 OR (rsTareas = 1 AND (piktareas.usuariofin = ? OR piktareas.usuariofin = '' )) ~
         OR (rsTareas = 2 AND (piktareas.usuariofin <> ? AND piktareas.usuariofin <> '' )) ~
         ) ~
    )

DEF VAR x-NomPer AS CHAR NO-UNDO.
DEF VAR x-Tiempo AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PikSacadores PL-PERS PikTareas

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 ~
(IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea ~
PikSacadores.CodPer fNomPer() @ x-NomPer PikSacadores.Sector 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define QUERY-STRING-BROWSE-6 FOR EACH PikSacadores ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST PL-PERS OF PikSacadores NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH PikSacadores ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST PL-PERS OF PikSacadores NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 PikSacadores PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 PikSacadores
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-6 PL-PERS


/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 PikTareas.CodPed PikTareas.NroPed ~
PikTareas.FchInicio PikTareas.UsuarioInicio PikTareas.FchFin ~
PikTareas.UsuarioFin fTiempo() @ x-Tiempo PikTareas.Items PikTareas.Importe ~
PikTareas.Peso PikTareas.Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH PikTareas ~
      WHERE {&Condiciontareas} NO-LOCK ~
    BY PikTareas.FchInicio DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH PikTareas ~
      WHERE {&Condiciontareas} NO-LOCK ~
    BY PikTareas.FchInicio DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 PikTareas
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 PikTareas


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-6}~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-1 rsPiksacadores ~
rsTareas BROWSE-6 BROWSE-8 
&Scoped-Define DISPLAYED-OBJECTS rsPiksacadores rsTareas 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE rsPiksacadores AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Libres", 1,
"Ocupados", 2,
"Ambos", 3
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE rsTareas AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendientes", 1,
"Terminados", 2,
"Ambos", 3
     SIZE 35 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.86 BY 1.04.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 1.04.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      PikSacadores, 
      PL-PERS SCROLLING.

DEFINE QUERY BROWSE-8 FOR 
      PikTareas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 W-Win _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      (IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea COLUMN-LABEL "Estado" FORMAT "x(15)":U
      PikSacadores.CodPer FORMAT "X(10)":U
      fNomPer() @ x-NomPer COLUMN-LABEL "Apellidos y Nombres" FORMAT "x(40)":U
            WIDTH 36.14
      PikSacadores.Sector FORMAT "x(30)":U WIDTH 33.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 6.73
         FONT 4.

DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 W-Win _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      PikTareas.CodPed COLUMN-LABEL "CodDoc" FORMAT "x(8)":U
      PikTareas.NroPed COLUMN-LABEL "Numero" FORMAT "x(15)":U
      PikTareas.FchInicio COLUMN-LABEL "Fecha!Inicio" FORMAT "99/99/9999 HH:MM:SS":U
      PikTareas.UsuarioInicio COLUMN-LABEL "Usuario!Inicio" FORMAT "x(10)":U
      PikTareas.FchFin COLUMN-LABEL "Fecha!Devol." FORMAT "99/99/9999 HH:MM:SS":U
      PikTareas.UsuarioFin COLUMN-LABEL "Usuario!Devol" FORMAT "x(10)":U
      fTiempo() @ x-Tiempo COLUMN-LABEL "Tiempo usado" FORMAT "x(20)":U
      PikTareas.Items FORMAT ">>>,>>9":U
      PikTareas.Importe FORMAT "->>>,>>>,>>9.99":U
      PikTareas.Peso COLUMN-LABEL "Peso!Kgrs" FORMAT "->>>,>>9.99":U
      PikTareas.Volumen COLUMN-LABEL "Volumen!cm3" FORMAT "->>>,>>9.99":U
            WIDTH 10.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 14.81
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.5 COL 3.57 WIDGET-ID 2
     rsPiksacadores AT ROW 1.65 COL 22 NO-LABEL WIDGET-ID 6
     rsTareas AT ROW 1.65 COL 56 NO-LABEL WIDGET-ID 14
     BROWSE-6 AT ROW 3.12 COL 2 WIDGET-ID 200
     BROWSE-8 AT ROW 9.96 COL 2 WIDGET-ID 300
     " Tareas" VIEW-AS TEXT
          SIZE 7.29 BY .5 AT ROW 1.23 COL 56.72 WIDGET-ID 20
          FGCOLOR 4 FONT 6
     " Sacadores" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.23 COL 22.14 WIDGET-ID 10
          FGCOLOR 4 FONT 6
     RECT-1 AT ROW 1.54 COL 21.14 WIDGET-ID 12
     RECT-2 AT ROW 1.54 COL 55 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 121.57 BY 24.62
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
         TITLE              = "CONTROL DE TAREA DE LOS SACADORES"
         HEIGHT             = 24.62
         WIDTH              = 121.57
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-6 rsTareas F-Main */
/* BROWSE-TAB BROWSE-8 BROWSE-6 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "INTEGRAL.PikSacadores,INTEGRAL.PL-PERS OF INTEGRAL.PikSacadores"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > "_<CALC>"
"(IF PikSacadores.FlgTarea = 'L' THEN 'LIBRE' ELSE 'OCUPADO') @ PikSacadores.FlgTarea" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.PikSacadores.CodPer
     _FldNameList[3]   > "_<CALC>"
"fNomPer() @ x-NomPer" "Apellidos y Nombres" "x(40)" ? ? ? ? ? ? ? no ? no no "36.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PikSacadores.Sector
"PikSacadores.Sector" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "33.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "INTEGRAL.PikTareas"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.PikTareas.FchInicio|no"
     _Where[1]         = "{&Condiciontareas}"
     _FldNameList[1]   > INTEGRAL.PikTareas.CodPed
"PikTareas.CodPed" "CodDoc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.PikTareas.NroPed
"PikTareas.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PikTareas.FchInicio
"PikTareas.FchInicio" "Fecha!Inicio" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PikTareas.UsuarioInicio
"PikTareas.UsuarioInicio" "Usuario!Inicio" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PikTareas.FchFin
"PikTareas.FchFin" "Fecha!Devol." "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.PikTareas.UsuarioFin
"PikTareas.UsuarioFin" "Usuario!Devol" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fTiempo() @ x-Tiempo" "Tiempo usado" "x(20)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.PikTareas.Items
     _FldNameList[9]   = INTEGRAL.PikTareas.Importe
     _FldNameList[10]   > INTEGRAL.PikTareas.Peso
"PikTareas.Peso" "Peso!Kgrs" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.PikTareas.Volumen
"PikTareas.Volumen" "Volumen!cm3" ? "decimal" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 2.54
       COLUMN          = 97
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 4
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(rsTareas:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONTROL DE TAREA DE LOS SACADORES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONTROL DE TAREA DE LOS SACADORES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 W-Win
ON VALUE-CHANGED OF BROWSE-6 IN FRAME F-Main
DO:
    ASSIGN rsPikSacadores rsTareas.
  {&OPEN-QUERY-BROWSE-8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-8
&Scoped-define SELF-NAME BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-8 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-8 IN FRAME F-Main
DO:
    DEFINE VARIABLE iRowHeight   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLastY       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRow         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hCell        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iTopRowY     AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE dRow         AS DEC     NO-UNDO.
    
    /* See if there are ANY rows in view... */
    IF SELF:NUM-ITERATIONS = 0 THEN 
    DO:
       /* No rows, the user clicked on an empty browse widget */
       RETURN NO-APPLY. 
    END.
    
    /* We don't know which row was clicked on, we have to calculate it from the mouse coordinates and the row heights. No really. */
    SELF:SELECT-ROW(1).               /* Select the first row so we can get the first cell. */
    hCell      = SELF:FIRST-COLUMN.   /* Get the first cell so we can get the Y coord of the first row, and the height of cells. */
    iTopRowY   = hCell:Y - 1.         /* The Y coord of the top of the top row relative to the browse widget. Had to subtract 1 pixel to get it accurate. */
    iRowHeight = hCell:HEIGHT-PIXELS. /* SELF:ROW-HEIGHT-PIXELS is not the same as hCell:HEIGHT-PIXELS for some reason */
    iLastY     = LAST-EVENT:Y.        /* The Y position of the mouse event (relative to the browse widget) */
    
    /* calculate which row was clicked. Truncate so that it doesn't round clicks past the middle of the row up to the next row. */
    dRow       = 1 + (iLastY - iTopRowY) / iRowHeight.
    iRow       = 1 + TRUNCATE((iLastY - iTopRowY) / iRowHeight, 0).
    
    IF iRow = 1  THEN DO:
        IF dRow > 1  THEN DO:
            iRow = iRow + 1.
        END.
    END.
    ELSE DO:
        iRow = iRow + 1.
    END.
    
    
    IF iRow > 0 AND iRow <= SELF:NUM-ITERATIONS THEN 
    DO:
      /* The user clicked on a populated row */
      /*Your coding here, for example:*/
        SELF:SELECT-ROW(iRow).
    
        MESSAGE piktareas.codped piktareas.nroped.
    END.
    ELSE DO:
      /* The click was on an empty row. */
      SELF:DESELECT-ROWS().
    
      RETURN NO-APPLY.
END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* REFRESCAR */
DO:
    ASSIGN rsPikSacadores rsTareas.

   /*MESSAGE s-codcia s-coddiv rsPikSacadores rsTareas.*/

    lPiksacadores = rsPikSacadores.

  {&OPEN-QUERY-BROWSE-6}
  {&OPEN-QUERY-BROWSE-8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

/*{&OPEN-QUERY-{&BROWSE-NAME}}*/
/*
    ASSIGN rsPikSacadores rsTareas.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  {&OPEN-QUERY-BROWSE-8}
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-6
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-control-picking.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-control-picking.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY rsPiksacadores rsTareas 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-1 rsPiksacadores rsTareas BROWSE-6 BROWSE-8 
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
  {src/adm/template/snd-list.i "PikTareas"}
  {src/adm/template/snd-list.i "PikSacadores"}
  {src/adm/template/snd-list.i "PL-PERS"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo W-Win 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF AVAILABLE PikTareas 
  THEN DO: 
      IF PikTareas.FchFin <> ? THEN RUN lib/_time-passed (PikTareas.FchInicio, PikTareas.FchFin, OUTPUT x-Tiempo).
      ELSE RUN lib/_time-passed (PikTareas.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
  END.
  ELSE x-Tiempo = "".   /* Function return value. */
  RETURN x-Tiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

