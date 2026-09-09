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
DEFINE INPUT  PARAMETER cCodCli AS CHAR.
DEFINE OUTPUT PARAMETER cBlock  AS CHAR.
DEFINE OUTPUT PARAMETER cCodVen AS CHAR.
DEFINE OUTPUT PARAMETER cNomVen AS CHAR.
DEFINE OUTPUT PARAMETER iTurno  AS INT.
/*
DEFINE OUTPUT PARAMETER iDigita  AS INT.
*/

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-Pendientes    AS INT  NO-UNDO.
DEF VAR x-Interconsulta AS INT  NO-UNDO.
DEF VAR x-Tipo          AS CHAR NO-UNDO.

DEF BUFFER B-TURNO FOR ExpTurno.

DEF VAR x-UltAtencion AS CHAR.
DEF VAR x-AtencionAct AS CHAR.
DEF VAR x-Turno AS CHAR.
DEF VAR x-PorAtender AS INT.

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
&Scoped-define INTERNAL-TABLES ExpTermi gn-ven

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ExpTermi.Block gn-ven.NomVen ~
fTurno() @ x-Turno fAtencionAct() @ x-AtencionAct ~
fUltAtencion() @ x-UltAtencion fPorAtender() @ x-PorAtender 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ExpTermi ~
      WHERE ExpTermi.CodCia = s-codcia ~
 AND ExpTermi.CodDiv = s-coddiv NO-LOCK, ~
      EACH gn-ven WHERE gn-ven.CodCia = ExpTermi.CodCia ~
  AND gn-ven.CodVen = ExpTermi.CodVen NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ExpTermi ~
      WHERE ExpTermi.CodCia = s-codcia ~
 AND ExpTermi.CodDiv = s-coddiv NO-LOCK, ~
      EACH gn-ven WHERE gn-ven.CodCia = ExpTermi.CodCia ~
  AND gn-ven.CodVen = ExpTermi.CodVen NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ExpTermi gn-ven
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ExpTermi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 gn-ven


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-3 BUTTON-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAtencionAct W-Win 
FUNCTION fAtencionAct RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPorAtender W-Win 
FUNCTION fPorAtender RETURNS INTEGER
  ( /*INPUT pParm1 AS CHAR*/ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTurno W-Win 
FUNCTION fTurno RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fUltAtencion W-Win 
FUNCTION fUltAtencion RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Interconsulta LABEL "Interconsulta" 
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ExpTermi, 
      gn-ven SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ExpTermi.Block FORMAT "x":U
      gn-ven.NomVen FORMAT "X(40)":U WIDTH 45
      fTurno() @ x-Turno COLUMN-LABEL "TURNO!SIGUIENTE"
      fAtencionAct() @ x-AtencionAct COLUMN-LABEL "En Vendedor"
      fUltAtencion() @ x-UltAtencion COLUMN-LABEL "Utl. Atencion"
      fPorAtender() @ x-PorAtender COLUMN-LABEL "Por atender" WIDTH 13
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 12.65
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.27 COL 2 WIDGET-ID 200
     BUTTON-3 AT ROW 14.19 COL 63 WIDGET-ID 2
     BUTTON-4 AT ROW 14.19 COL 79 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.43 BY 15.31
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 15.31
         WIDTH              = 94.43
         MAX-HEIGHT         = 18.77
         MAX-WIDTH          = 112.86
         VIRTUAL-HEIGHT     = 18.77
         VIRTUAL-WIDTH      = 112.86
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
/* BROWSE-TAB BROWSE-2 1 F-Main */
ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-2:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.ExpTermi,INTEGRAL.gn-ven WHERE INTEGRAL.ExpTermi ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "ExpTermi.CodCia = s-codcia
 AND ExpTermi.CodDiv = s-coddiv"
     _JoinCode[2]      = "gn-ven.CodCia = ExpTermi.CodCia
  AND gn-ven.CodVen = ExpTermi.CodVen"
     _FldNameList[1]   = INTEGRAL.ExpTermi.Block
     _FldNameList[2]   > INTEGRAL.gn-ven.NomVen
"gn-ven.NomVen" ? ? "character" ? ? ? ? ? ? no ? no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fTurno() @ x-Turno" "TURNO!SIGUIENTE" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"fAtencionAct() @ x-AtencionAct" "En Vendedor" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fUltAtencion() @ x-UltAtencion" "Utl. Atencion" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fPorAtender() @ x-PorAtender" "Por atender" ? ? ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:
    x-Tipo = 'V'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    RUN Valida.
    /*IF NOT RETURN-VALUE = "adm-error" THEN RUN Graba-Turno.*/
    IF NOT RETURN-VALUE = "adm-error" THEN RUN Asigna-Turno.

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


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    ASSIGN
        cBlock  = ''
        cCodven = ''
        cNomVen = ''
        iTurno  = 0
        .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Turno W-Win 
PROCEDURE Asigna-Turno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Turno AS INT INIT 1 NO-UNDO. 
    
    FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
        AND b-turno.coddiv = s-coddiv
        AND b-turno.block  = ExpTermi.Block
        AND b-turno.fecha  = TODAY
        AND b-turno.tipo   = 'V' BY B-TURNO.Turno:
        x-Turno = b-turno.turno + 1.
    END.
    ASSIGN 
        iTurno  = x-Turno
        cBlock  = ExpTermi.BLOCK    
        cCodven = ExpTermi.CodVen.

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
  ENABLE BROWSE-2 BUTTON-3 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Turno W-Win 
PROCEDURE Graba-Turno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR x-Turno AS INT INIT 1 NO-UNDO. 
  DEF VAR iNroDig AS INT        NO-UNDO.
          
  FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
      AND b-turno.coddiv = s-coddiv
      AND b-turno.block  = ExpTermi.Block
      AND b-turno.fecha  = TODAY
      AND b-turno.tipo   = 'V' BY B-TURNO.Turno:
      x-Turno = b-turno.turno + 1.
  END.

  /*Número Página*/
  iNroDig = 1.
  FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
      AND b-turno.coddiv = s-coddiv
      AND b-turno.fecha  = TODAY :
      iNroDig = iNroDig + 1.
  END.

  FIND FIRST ExpTurno WHERE ExpTurno.CodCia = s-codcia
      AND ExpTurno.CodDiv  = s-coddiv
      AND ExpTurno.BLOCK   = ExpTermi.Block
      AND ExpTurno.Fecha   = TODAY
      AND ExpTurno.CodCli  = cCodCli NO-LOCK NO-ERROR.
  IF NOT AVAIL ExpTurno THEN DO:
      MESSAGE "Crea: " SKIP 
          s-coddiv SKIP exptermi.BLOCK SKIP cCodCli.
      CREATE ExpTurno.
      ASSIGN
          ExpTurno.CodCia  = s-CodCia
          ExpTurno.CodDiv  = s-CodDiv
          ExpTurno.Block   = ExpTermi.Block
          ExpTurno.Fecha   = TODAY
          ExpTurno.Hora    = STRING(TIME, 'HH:MM')
          ExpTurno.Tipo    = 'V'
          ExpTurno.Usuario = s-user-id
          ExpTurno.CodVen  = ExpTermi.CodVen
          ExpTurno.Turno   = x-Turno
          ExpTurno.CodCli  = cCodCli
          ExpTurno.Libre_d01 = iNroDig.
  END.
  FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia
      AND gn-ven.codven = ExpTermi.CodVen NO-LOCK NO-ERROR.
  IF AVAIL gn-ven THEN cNomVen = Gn-ven.NomVen.
  ASSIGN 
      iTurno  = ExpTurno.Turno
      cBlock  = ExpTurno.BLOCK
      cCodven = ExpTurno.CodVen 
      /*
      iDigita = INT(ExpTurno.Libre_d01)
      */ .

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
  {src/adm/template/snd-list.i "ExpTermi"}
  {src/adm/template/snd-list.i "gn-ven"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida W-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*     FIND LAST B-TURNO WHERE B-TURNO.codcia = Exptermi.codcia              */
/*         AND B-TURNO.coddiv = Exptermi.coddiv                              */
/*         AND B-TURNO.codcli = cCodCli                                      */
/*         AND B-TURNO.fecha = TODAY NO-LOCK NO-ERROR.                       */
/*     IF AVAILABLE B-TURNO THEN DO:                                         */
/*         MESSAGE 'El cliente YA tiene un turno' VIEW-AS ALERT-BOX WARNING. */
/*         RETURN "adm-error".                                               */
/*     END.                                                                  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAtencionAct W-Win 
FUNCTION fAtencionAct RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FOR FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = ExpTermi.codcia AND
    Faccpedi.coddiv = ExpTermi.coddiv AND
    Faccpedi.coddoc = 'COT' AND
    Faccpedi.codven = ExpTermi.codven AND
    Faccpedi.flgest = 'W' AND
    Faccpedi.fchped >= TODAY - 1
    BY Faccpedi.libre_d01:
    FIND ExpTurno WHERE ROWID(ExpTurno) = TO-ROWID(FacCPedi.Libre_c02) NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN RETURN (ExpTurno.BLOCK + ' - '  + STRING(ExpTurno.Turno)).
END.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPorAtender W-Win 
FUNCTION fPorAtender RETURNS INTEGER
  ( /*INPUT pParm1 AS CHAR*/ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR pParm2 AS INT NO-UNDO.
  
  pParm2 = 0.
  FOR EACH ExpTurno OF ExpTermi NO-LOCK WHERE ExpTurno.codcia = s-codcia
      AND ExpTurno.coddiv = s-coddiv
      AND ExpTurno.estado <> "C"
      AND ExpTurno.BLOCK = ExpTermi.BLOCK
      AND ExpTurno.fecha = TODAY:
      pParm2 = pParm2 + 1.
  END.
  RETURN pParm2.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTurno W-Win 
FUNCTION fTurno RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-Turno AS INT INIT 1 NO-UNDO. 
    
    FOR EACH B-TURNO NO-LOCK WHERE b-turno.codcia = s-CodCia
        AND b-turno.coddiv = s-coddiv
        AND b-turno.block  = ExpTermi.Block
        AND b-turno.fecha  = TODAY
        AND b-turno.tipo   = 'V' BY B-TURNO.Turno:
        x-Turno = b-turno.turno + 1.
    END.
    RETURN ExpTermi.BLOCK + ' - '  + STRING(x-Turno).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fUltAtencion W-Win 
FUNCTION fUltAtencion RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

FOR LAST Faccpedi NO-LOCK WHERE Faccpedi.codcia = ExpTermi.codcia AND
    Faccpedi.coddiv = ExpTermi.coddiv AND
    Faccpedi.coddoc = 'COT' AND
    Faccpedi.codven = ExpTermi.codven AND
    Faccpedi.flgest = 'P' AND
    Faccpedi.fchped >= TODAY - 1
    BY Faccpedi.libre_d01:
    FIND ExpTurno WHERE ROWID(ExpTurno) = TO-ROWID(FacCPedi.Libre_c02) NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTurno THEN RETURN (ExpTurno.BLOCK + ' - '  + STRING(ExpTurno.Turno)).
END.
RETURN "".   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

