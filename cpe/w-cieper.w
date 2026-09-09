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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cpetrased PL-PERS almtabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 cpetrased.CodPer ~
fNomPer(cpetrased.CodPer) @ PL-PERS.nomper cpetrased.FechaReg ~
cpetrased.CodArea almtabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH cpetrased ~
      WHERE cpetrased.CodCia = s-codcia ~
 AND cpetrased.CodDiv = s-coddiv ~
 AND cpetrased.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = cpetrased.CodPer NO-LOCK, ~
      EACH almtabla WHERE almtabla.Codigo = cpetrased.CodArea ~
      AND almtabla.Tabla = "AS" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH cpetrased ~
      WHERE cpetrased.CodCia = s-codcia ~
 AND cpetrased.CodDiv = s-coddiv ~
 AND cpetrased.FlgEst = "P" NO-LOCK, ~
      EACH PL-PERS WHERE PL-PERS.codper = cpetrased.CodPer NO-LOCK, ~
      EACH almtabla WHERE almtabla.Codigo = cpetrased.CodArea ~
      AND almtabla.Tabla = "AS" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 cpetrased PL-PERS almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 cpetrased
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 PL-PERS
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-2 almtabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BtnDone BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Cierre_del_dia_por_persona LABEL "Cierre del dia por persona".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.88 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "CIERRE DEL DIA" 
     SIZE 15 BY 1.88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      cpetrased, 
      PL-PERS, 
      almtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      cpetrased.CodPer COLUMN-LABEL "Personal" FORMAT "X(6)":U
      fNomPer(cpetrased.CodPer) @ PL-PERS.nomper COLUMN-LABEL "Nombre" FORMAT "x(40)":U
            WIDTH 34.57
      cpetrased.FechaReg COLUMN-LABEL "Fecha-Hora" FORMAT "99/99/9999 HH:MM:SS":U
            WIDTH 15
      cpetrased.CodArea FORMAT "x(3)":U WIDTH 5.43
      almtabla.Nombre COLUMN-LABEL "Descripción" FORMAT "x(20)":U
            WIDTH 29.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 96 BY 14
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.27 COL 75 WIDGET-ID 14
     BtnDone AT ROW 1.27 COL 90 WIDGET-ID 10
     BROWSE-2 AT ROW 3.42 COL 2 WIDGET-ID 200
     "EL CIERRE DEL DIA CIERRA TODAS LAS TAREAS PENDIENTES INCLUSIVE" VIEW-AS TEXT
          SIZE 58 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 12
          BGCOLOR 7 FGCOLOR 15 
     "Para hacer el cierre de una persona presione el botón derecho del mouse" VIEW-AS TEXT
          SIZE 51 BY .5 AT ROW 2.88 COL 2 WIDGET-ID 16
          BGCOLOR 12 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 17
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
         TITLE              = "CIERRE DEL DIA"
         HEIGHT             = 17
         WIDTH              = 99
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 122.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 122.57
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 BtnDone F-Main */
ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-2:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.cpetrased,INTEGRAL.PL-PERS WHERE INTEGRAL.cpetrased ...,INTEGRAL.almtabla WHERE INTEGRAL.cpetrased ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.cpetrased.CodCia = s-codcia
 AND INTEGRAL.cpetrased.CodDiv = s-coddiv
 AND INTEGRAL.cpetrased.FlgEst = ""P"""
     _JoinCode[2]      = "INTEGRAL.PL-PERS.codper = INTEGRAL.cpetrased.CodPer"
     _JoinCode[3]      = "INTEGRAL.almtabla.Codigo = INTEGRAL.cpetrased.CodArea"
     _Where[3]         = "INTEGRAL.almtabla.Tabla = ""AS"""
     _FldNameList[1]   > INTEGRAL.cpetrased.CodPer
"cpetrased.CodPer" "Personal" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"fNomPer(cpetrased.CodPer) @ PL-PERS.nomper" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no "34.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.cpetrased.FechaReg
"cpetrased.FechaReg" "Fecha-Hora" "99/99/9999 HH:MM:SS" "datetime" ? ? ? ? ? ? no ? no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.cpetrased.CodArea
"cpetrased.CodArea" ? "x(3)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" "Descripción" "x(20)" "character" ? ? ? ? ? ? no ? no no "29.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CIERRE DEL DIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CIERRE DEL DIA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CIERRE DEL DIA */
DO:
  MESSAGE '¿Procedemos con el cierre del día?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cierre-del-dia.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Cierre_del_dia_por_persona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Cierre_del_dia_por_persona W-Win
ON CHOOSE OF MENU-ITEM m_Cierre_del_dia_por_persona /* Cierre del dia por persona */
DO:
    MESSAGE '¿Procedemos con el cierre del día de la persona seleccionada?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Cierre-del-dia-por-persona.
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-del-dia W-Win 
PROCEDURE Cierre-del-dia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Cierre de tareas pendientes */
    FOR EACH CpeTareas WHERE CpeTareas.CodCia = s-codcia
        AND CpeTareas.CodDiv = s-coddiv
        AND CpeTareas.FlgEst = "P":
        ASSIGN
            CpeTareas.FchFin = DATETIME(TODAY, MTIME)
            CpeTareas.FlgEst = 'C'.
        FIND CpeTraSed WHERE CpeTraSed.CodCia = s-codcia
            AND CpeTraSed.CodDiv = s-coddiv
            AND CpeTraSed.CodPer = CpeTareas.CodPer
            AND CpeTraSed.FlgEst = 'P'
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CpeTraSed THEN FlgTarea = 'L'.       /* Libre */
        /* Tracking de Tareas */
        CREATE CpeTrkTar.
        BUFFER-COPY CpeTareas TO CpeTrkTar.
        ASSIGN
            CpeTrkTar.Estado = 'Tarea Cerrada'
            CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
            CpeTrkTar.Usuario = s-user-id.
    END.
    /* Cierre de Entregas */
    FOR EACH CpeEntrega WHERE CpeEntrega.CodCia = s-codcia
        AND CpeEntrega.CodDiv = s-coddiv
        AND CpeEntrega.FlgEst = 'P':
        CpeEntrega.FlgEst = 'C'.
    END.
    /* Cierre del Personal del dia */
    FOR EACH cpetrased WHERE cpetrased.CodCia = s-codcia
        AND cpetrased.CodDiv = s-coddiv
        AND cpetrased.FlgEst = "P":
        ASSIGN
            CpeTraSed.FechaCier = DATETIME(TODAY, MTIME)
            CpeTraSed.FlgEst = 'C'
            CpeTraSed.UsuarioCie = s-user-id.
    END.
    IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
    IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.
    IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-del-dia-por-persona W-Win 
PROCEDURE Cierre-del-dia-por-persona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Cierre del Personal del dia */
    FIND CURRENT CpeTraSed EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE CpeTraSed THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        CpeTraSed.FechaCier = DATETIME(TODAY, MTIME)
        CpeTraSed.FlgEst = 'C'
        CpeTraSed.FlgTarea = 'L'
        CpeTraSed.UsuarioCie = s-user-id.
    /* Cierre de tareas pendientes */
    FOR EACH CpeTareas WHERE CpeTareas.CodCia = s-codcia
        AND CpeTareas.CodDiv = s-coddiv
        AND CpeTareas.FlgEst = "P"
        AND CpeTareas.CodPer = cpetrased.CodPer:
        ASSIGN
            CpeTareas.FchFin = DATETIME(TODAY, MTIME)
            CpeTareas.FlgEst = 'C'.
        /* Tracking de Tareas */
        CREATE CpeTrkTar.
        BUFFER-COPY CpeTareas TO CpeTrkTar.
        ASSIGN
            CpeTrkTar.Estado = 'Tarea Cerrada'
            CpeTrkTar.Fecha = DATETIME(TODAY, MTIME)
            CpeTrkTar.Usuario = s-user-id.
    END.
    IF AVAILABLE(CpeTareas) THEN RELEASE CpeTareas.
    IF AVAILABLE(CpeTrkTar) THEN RELEASE CpeTrkTar.
    IF AVAILABLE(CpeTraSed) THEN RELEASE CpeTraSed.
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
  ENABLE BUTTON-1 BtnDone BROWSE-2 
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
  {src/adm/template/snd-list.i "cpetrased"}
  {src/adm/template/snd-list.i "PL-PERS"}
  {src/adm/template/snd-list.i "almtabla"}

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
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 
  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

