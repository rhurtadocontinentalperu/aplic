&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-Destino NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE T-Origen NO-UNDO LIKE FacCPedi.



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

&SCOPED-DEFINE Sorteo T-Origen.NomCli

&SCOPED-DEFINE Condicion TRUE

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Destino

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-Destino T-Origen

/* Definitions for BROWSE BROWSE-Destino                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Destino T-Destino.CodDoc ~
T-Destino.NroPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Destino 
&Scoped-define QUERY-STRING-BROWSE-Destino FOR EACH T-Destino NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Destino OPEN QUERY BROWSE-Destino FOR EACH T-Destino NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Destino T-Destino
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Destino T-Destino


/* Definitions for BROWSE BROWSE-Origen                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Origen T-Origen.usuario T-Origen.CodDoc T-Origen.NroPed T-Origen.FchPed T-Origen.CodCli T-Origen.NomCli T-Origen.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Origen   
&Scoped-define SELF-NAME BROWSE-Origen
&Scoped-define QUERY-STRING-BROWSE-Origen FOR EACH T-Origen       WHERE {&Condicion} NO-LOCK     BY {&Sorteo}
&Scoped-define OPEN-QUERY-BROWSE-Origen OPEN QUERY {&SELF-NAME} FOR EACH T-Origen       WHERE {&Condicion} NO-LOCK     BY {&Sorteo}.
&Scoped-define TABLES-IN-QUERY-BROWSE-Origen T-Origen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Origen T-Origen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Destino}~
    ~{&OPEN-QUERY-BROWSE-Origen}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Origen FILL-IN-Destino BUTTON-8 ~
BUTTON-12 BtnDone BROWSE-Origen BROWSE-Destino BUTTON-5 BUTTON-4 BUTTON-6 ~
BUTTON-7 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Origen FILL-IN-Destino 

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
     SIZE 7 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "Button 12" 
     SIZE 7 BY 1.35 TOOLTIP "Grabar".

DEFINE BUTTON BUTTON-4 
     LABEL ">" 
     SIZE 5 BY 1.12 TOOLTIP "Solo seleccionados"
     FONT 6.

DEFINE BUTTON BUTTON-5 
     LABEL ">>" 
     SIZE 5 BY 1.12 TOOLTIP "Todos"
     FONT 6.

DEFINE BUTTON BUTTON-6 
     LABEL "<" 
     SIZE 5 BY 1.12 TOOLTIP "Solo seleccionados"
     FONT 6.

DEFINE BUTTON BUTTON-7 
     LABEL "<<" 
     SIZE 5 BY 1.12 TOOLTIP "Todos"
     FONT 6.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "" 
     SIZE 7 BY 1.35 TOOLTIP "Filtrar ORIGEN".

DEFINE VARIABLE FILL-IN-Destino AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario DESTINO" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Origen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario ORIGEN" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Destino FOR 
      T-Destino SCROLLING.

DEFINE QUERY BROWSE-Origen FOR 
      T-Origen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Destino W-Win _STRUCTURED
  QUERY BROWSE-Destino NO-LOCK DISPLAY
      T-Destino.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U
      T-Destino.NroPed COLUMN-LABEL "Número" FORMAT "X(9)":U WIDTH 12.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 19 BY 15.19
         FONT 4
         TITLE "DESTINO" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Origen W-Win _FREEFORM
  QUERY BROWSE-Origen NO-LOCK DISPLAY
      T-Origen.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
            WIDTH 7.43
      T-Origen.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U WIDTH 4.43
      T-Origen.NroPed COLUMN-LABEL "Número" FORMAT "X(9)":U WIDTH 9.43
      T-Origen.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      T-Origen.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 12
      T-Origen.NomCli FORMAT "x(50)":U WIDTH 50.43
      T-Origen.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 11.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 110 BY 15.19
         FONT 4
         TITLE "ORIGEN" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Origen AT ROW 1.38 COL 41 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Destino AT ROW 2.35 COL 41 COLON-ALIGNED WIDGET-ID 12
     BUTTON-8 AT ROW 1.19 COL 2 WIDGET-ID 14
     BUTTON-12 AT ROW 1.19 COL 9 WIDGET-ID 16
     BtnDone AT ROW 1.19 COL 16 WIDGET-ID 20
     BROWSE-Origen AT ROW 3.5 COL 2 WIDGET-ID 400
     BROWSE-Destino AT ROW 3.5 COL 124 WIDGET-ID 300
     BUTTON-5 AT ROW 4.65 COL 116 WIDGET-ID 4
     BUTTON-4 AT ROW 5.81 COL 116 WIDGET-ID 2
     BUTTON-6 AT ROW 8.5 COL 116 WIDGET-ID 6
     BUTTON-7 AT ROW 9.65 COL 116 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 18.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Destino T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-Origen T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REASIGNACION DE COTIZACIONES"
         HEIGHT             = 18.15
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-Origen BtnDone F-Main */
/* BROWSE-TAB BROWSE-Destino BROWSE-Origen F-Main */
ASSIGN 
       BROWSE-Origen:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Destino
/* Query rebuild information for BROWSE BROWSE-Destino
     _TblList          = "Temp-Tables.T-Destino"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-Destino.CodDoc
"T-Destino.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-Destino.NroPed
"T-Destino.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Destino */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Origen
/* Query rebuild information for BROWSE BROWSE-Origen
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH T-Origen
      WHERE {&Condicion} NO-LOCK
    BY {&Sorteo}.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.T-Origen.NomCli|yes"
     _Where[1]         = "{&Condicion}"
     _Query            is OPENED
*/  /* BROWSE BROWSE-Origen */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REASIGNACION DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REASIGNACION DE COTIZACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Origen
&Scoped-define SELF-NAME BROWSE-Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Origen W-Win
ON START-SEARCH OF BROWSE-Origen IN FRAME F-Main /* ORIGEN */
DO:
  CASE BROWSE-Origen:CURRENT-COLUMN:LABEL:
      WHEN 'Nombre' THEN DO:
          &Scoped-define Sorteo T-Origen.NomCli
          &Scoped-define OPEN-QUERY-BROWSE-Origen OPEN QUERY {&SELF-NAME} FOR EACH T-Origen       WHERE {&Condicion} NO-LOCK     BY {&Sorteo}.
          MESSAGE '{&OPEN-QUERY-BROWSE-Origen}'.
          {&OPEN-QUERY-BROWSE-Origen}
      END.
          OTHERWISE DO:
          &Scoped-define Sorteo T-Origen.NroPed
          &Scoped-define OPEN-QUERY-BROWSE-Origen OPEN QUERY {&SELF-NAME} FOR EACH T-Origen       WHERE {&Condicion} NO-LOCK     BY {&Sorteo}.
          {&OPEN-QUERY-BROWSE-Origen}
          END.
  END CASE.

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



&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* > */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Destino.
    DEF VAR k AS INT NO-UNDO.

    DO k = 1 TO BROWSE-Origen:NUM-SELECTED-ROWS:
        IF BROWSE-Origen:FETCH-SELECTED-ROW(k) THEN DO:
            CREATE T-Destino.
            BUFFER-COPY T-Origen TO T-Destino.
            DELETE T-Origen.
        END.
    END.
    {&OPEN-QUERY-BROWSE-Origen}
    {&OPEN-QUERY-BROWSE-Destino}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* >> */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  EMPTY TEMP-TABLE T-Destino.
  FOR EACH T-Origen:
      CREATE T-Destino.
      BUFFER-COPY T-Origen TO T-Destino.
      DELETE T-Origen.
  END.
  {&OPEN-QUERY-BROWSE-Origen}
  {&OPEN-QUERY-BROWSE-Destino}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* << */
DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    FOR EACH T-Destino:
        CREATE T-Origen.
        BUFFER-COPY T-Destino TO T-Origen.
        DELETE T-DEstino.
    END.
    {&OPEN-QUERY-BROWSE-Origen}
    {&OPEN-QUERY-BROWSE-Destino}
    SESSION:SET-WAIT-STATE('').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  EMPTY TEMP-TABLE T-Origen.
  EMPTY TEMP-TABLE T-DEstino.
  DEF VAR x-FlgEst AS CHAR INIT 'P,T,E' NO-UNDO.
  DEF VAR k AS INT NO-UNDO.

  DO k = 1 TO NUM-ENTRIES(x-FlgEst):
      FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = "COT"
          AND Faccpedi.coddiv = s-coddiv
          AND Faccpedi.flgest = ENTRY(k,x-FlgEst)
          AND Faccpedi.usuario = FILL-IN-Origen:SCREEN-VALUE:
          CREATE T-Origen.
          BUFFER-COPY Faccpedi TO T-Origen.
      END.
  END.
  {&OPEN-QUERY-BROWSE-Origen}
  {&OPEN-QUERY-BROWSE-Destino}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Destino
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
  DISPLAY FILL-IN-Origen FILL-IN-Destino 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Origen FILL-IN-Destino BUTTON-8 BUTTON-12 BtnDone 
         BROWSE-Origen BROWSE-Destino BUTTON-5 BUTTON-4 BUTTON-6 BUTTON-7 
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
  {src/adm/template/snd-list.i "T-Origen"}
  {src/adm/template/snd-list.i "T-Destino"}

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

