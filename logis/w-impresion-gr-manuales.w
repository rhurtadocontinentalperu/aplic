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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-User-Id AS CHARACTER.
DEFINE SHARED VARIABLE pv-codcia AS INTEGER.

IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
                AND FacCorre.CodDiv = s-coddiv
                AND FacCorre.CodDoc = "G/R"
                AND FacCorre.FlgEst = YES
                AND FacCorre.Id_Pos = "CLASICA"
                AND (FacCorre.Id_Pos2 = "VENTAS" OR (TRUE <> (FacCorre.Id_Pos2 > '')))
                AND FacCorre.NroSer <> 0
                NO-LOCK)
    THEN DO:
    MESSAGE 'NO se ha definido una serie válida' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* CONTROL DE GRE ACTIVAS O NO */
DEF VAR lGRE_ONLINE AS LOG NO-UNDO.

RUN gn/gre-online (OUTPUT lGRE_ONLINE).
IF lGRE_ONLINE = YES THEN DO:
    MESSAGE "Guia de Remisión Electrónica Activa" SKIP (1) 'Acceso Denegado' 
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCDocu.FchDoc CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.Glosa CcbCDocu.LugEnt   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH CcbCDocu USE-INDEX Llave10       WHERE CcbCDocu.CodCia = s-codcia  AND CcbCDocu.CodDiv = s-coddiv  AND CcbCDocu.FchDoc >= FILL-IN_FchDoc-1  AND CcbCDocu.FchDoc <= FILL-IN_FchDoc-2  AND CcbCDocu.CodDoc = "G/R"  AND CcbCDocu.FlgEst = "F"  AND CcbCDocu.NroDoc BEGINS STRING(COMBO-BOX_NroSer, ~
      '999') NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu USE-INDEX Llave10       WHERE CcbCDocu.CodCia = s-codcia  AND CcbCDocu.CodDiv = s-coddiv  AND CcbCDocu.FchDoc >= FILL-IN_FchDoc-1  AND CcbCDocu.FchDoc <= FILL-IN_FchDoc-2  AND CcbCDocu.CodDoc = "G/R"  AND CcbCDocu.FlgEst = "F"  AND CcbCDocu.NroDoc BEGINS STRING(COMBO-BOX_NroSer, ~
      '999') NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-69 COMBO-BOX_NroSer BUTTON-5 BtnDone ~
FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_NroSer FILL-IN_Formato ~
FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 11 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/b-print.bmp":U
     LABEL "Button 5" 
     SIZE 12 BY 2.15.

DEFINE VARIABLE COMBO-BOX_NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la serie de la G/R" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_Formato AS CHARACTER FORMAT "X(256)":U 
     LABEL "Formato de impresión" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 188 BY 3.23.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _FREEFORM
  QUERY BROWSE-1 NO-LOCK DISPLAY
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 12.86
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 11.43
      CcbCDocu.NomCli FORMAT "x(50)":U
      CcbCDocu.CodRef FORMAT "x(3)":U
      CcbCDocu.NroRef FORMAT "X(12)":U WIDTH 13
      CcbCDocu.Glosa FORMAT "x(60)":U
      CcbCDocu.LugEnt FORMAT "x(60)":U WIDTH 11.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 188 BY 22.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_NroSer AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 46
     FILL-IN_Formato AT ROW 1.27 COL 54 COLON-ALIGNED WIDGET-ID 48
     BUTTON-5 AT ROW 1.54 COL 166 WIDGET-ID 10
     BtnDone AT ROW 1.54 COL 178 WIDGET-ID 42
     FILL-IN_FchDoc-1 AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_FchDoc-2 AT ROW 2.88 COL 29 COLON-ALIGNED WIDGET-ID 6
     BROWSE-1 AT ROW 4.23 COL 3 WIDGET-ID 200
     RECT-69 AT ROW 1 COL 3 WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
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
         TITLE              = "IMPRESION DE GUIAS DE REMISION MANUAL"
         HEIGHT             = 26.15
         WIDTH              = 191.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
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
/* BROWSE-TAB BROWSE-1 FILL-IN_FchDoc-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_Formato IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH CcbCDocu USE-INDEX Llave10
      WHERE CcbCDocu.CodCia = s-codcia
 AND CcbCDocu.CodDiv = s-coddiv
 AND CcbCDocu.FchDoc >= FILL-IN_FchDoc-1
 AND CcbCDocu.FchDoc <= FILL-IN_FchDoc-2
 AND CcbCDocu.CodDoc = "G/R"
 AND CcbCDocu.FlgEst = "F"
 AND CcbCDocu.NroDoc BEGINS STRING(COMBO-BOX_NroSer,'999') NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "CcbCDocu.CodCia = s-codcia
 AND CcbCDocu.CodDiv = s-coddiv
 AND CcbCDocu.FchDoc >= FILL-IN_FchDoc-1
 AND CcbCDocu.FchDoc <= FILL-IN_FchDoc-2
 AND CcbCDocu.CodDoc = ""G/R""
 AND CcbCDocu.FlgEst = ""F""
 AND CcbCDocu.NroDoc BEGINS STRING(COMBO-BOX_NroSer,'999')"
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPRESION DE GUIAS DE REMISION MANUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPRESION DE GUIAS DE REMISION MANUAL */
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


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    RUN logis/d-formato-gr-manuales.r (ROWID(Ccbcdocu) ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_NroSer W-Win
ON VALUE-CHANGED OF COMBO-BOX_NroSer IN FRAME F-Main /* Seleccione la serie de la G/R */
DO:
  FIND Faccorre WHERE Faccorre.codcia = s-codcia
      AND Faccorre.coddoc = "G/R"
      AND Faccorre.nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK NO-ERROR.
  IF AVAILABLE Faccorre THEN FILL-IN_Formato:SCREEN-VALUE = Faccorre.nroimp.
  ASSIGN {&SELF-NAME}.
  SESSION:SET-WAIT-STATE('GENERAL').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-1 W-Win
ON LEAVE OF FILL-IN_FchDoc-1 IN FRAME F-Main /* Emitidos desde */
DO:
    ASSIGN {&SELF-NAME}.
    SESSION:SET-WAIT-STATE('GENERAL').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-2 W-Win
ON LEAVE OF FILL-IN_FchDoc-2 IN FRAME F-Main /* Emitidos hasta */
DO:
    ASSIGN {&SELF-NAME}.
    SESSION:SET-WAIT-STATE('GENERAL').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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
  DISPLAY COMBO-BOX_NroSer FILL-IN_Formato FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-69 COMBO-BOX_NroSer BUTTON-5 BtnDone FILL-IN_FchDoc-1 
         FILL-IN_FchDoc-2 BROWSE-1 
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
  FILL-IN_FchDoc-1 = ADD-INTERVAL(TODAY,-7,'days'). FILL-IN_FchDoc-2 = TODAY.
  COMBO-BOX_NroSer:DELETE(1) IN FRAME {&FRAME-NAME}.

  FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = "G/R"
      AND FacCorre.FlgEst = YES
      AND FacCorre.Id_Pos = "CLASICA"
      AND (FacCorre.Id_Pos2 = "VENTAS" OR (TRUE <> (FacCorre.Id_Pos2 > '')))
      AND FacCorre.NroSer <> 0
      BY FacCorre.NroSer DESC:
      COMBO-BOX_NroSer:ADD-LAST(STRING(FacCorre.NroSer,'999')) IN FRAME {&FRAME-NAME}.
      COMBO-BOX_NroSer = FacCorre.NroSer.
      FILL-IN_Formato = FacCorre.NroImp.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

