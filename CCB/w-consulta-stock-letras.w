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
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-cuales AS INT INIT 0.  /* 0 : Con Stock  1 : Sin Stock  2 : Todos  */
DEFINE VAR x-codclie AS CHAR.
DEFINE VAR x-tpomov AS CHAR.

DEFINE VAR x-estado-doc AS CHAR.
DEFINE VAR x-pedidos AS CHAR.
DEFINE VAR x-filter AS CHAR INIT "". /*vacio:Todos, R:Recepcionados E:Emitidos M:Malogrados*/

DEFINE TEMP-TABLE ttExcel
    FIELD   tCodclie    AS  CHAR    FORMAT  'x(11)'
    FIELD   tnomcli     AS  CHAR    FORMAT  'x(80)'
    FIELD   tqstklet    AS  INT     FORMAT  '->>,>>>,>>9'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-7

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ccbstklet gn-clie ccbmovlet CcbCDocu

/* Definitions for BROWSE BROWSE-7                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-7 ccbstklet.codclie gn-clie.NomCli ~
ccbstklet.qstklet 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-7 
&Scoped-define QUERY-STRING-BROWSE-7 FOR EACH ccbstklet ~
      WHERE ccbstklet.codcia = s-codcia and  ~
((x-cuales = 2) or  ~
 (x-cuales = 0 and ccbstklet.qstklet > 0) or ~
 (x-cuales = 1 and ccbstklet.qstklet <= 0) ~
) NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = 0 and ~
 gn-clie.CodCli =  ccbstklet.codclie NO-LOCK ~
    BY gn-clie.NomCli
&Scoped-define OPEN-QUERY-BROWSE-7 OPEN QUERY BROWSE-7 FOR EACH ccbstklet ~
      WHERE ccbstklet.codcia = s-codcia and  ~
((x-cuales = 2) or  ~
 (x-cuales = 0 and ccbstklet.qstklet > 0) or ~
 (x-cuales = 1 and ccbstklet.qstklet <= 0) ~
) NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCia = 0 and ~
 gn-clie.CodCli =  ccbstklet.codclie NO-LOCK ~
    BY gn-clie.NomCli.
&Scoped-define TABLES-IN-QUERY-BROWSE-7 ccbstklet gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-7 ccbstklet
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-7 gn-clie


/* Definitions for BROWSE BROWSE-8                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-8 ~
fTipoMov(ccbmovlet.tpomov) @ x-tpomov ccbmovlet.fchmov ccbmovlet.qletras ~
ccbmovlet.nrodoc ccbmovlet.coddiv ccbmovlet.usrcrea CcbCDocu.CodRef ~
CcbCDocu.NroRef fEstadoDoc(CcbCDocu.CodDoc,CcbCDocu.FlgEst) @  x-estado-doc ~
fpedidos-del-canje(CcbCDocu.CodRef,CcbCDocu.NroRef) @ x-pedidos 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-8 
&Scoped-define QUERY-STRING-BROWSE-8 FOR EACH ccbmovlet ~
      WHERE ccbmovlet.codcia = s-codcia and  ~
ccbmovlet.codclie = x-codclie and ~
(x-filter = "" or ccbmovlet.tpomov = x-filter) NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia =  ccbmovlet.codcia and ~
ccbcdocu.coddoc = 'LET' and ~
ccbcdocu.nrodoc = ccbmovlet.nrodoc OUTER-JOIN NO-LOCK ~
    BY ccbmovlet.fchmov INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-8 OPEN QUERY BROWSE-8 FOR EACH ccbmovlet ~
      WHERE ccbmovlet.codcia = s-codcia and  ~
ccbmovlet.codclie = x-codclie and ~
(x-filter = "" or ccbmovlet.tpomov = x-filter) NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodCia =  ccbmovlet.codcia and ~
ccbcdocu.coddoc = 'LET' and ~
ccbcdocu.nrodoc = ccbmovlet.nrodoc OUTER-JOIN NO-LOCK ~
    BY ccbmovlet.fchmov INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-8 ccbmovlet CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-8 ccbmovlet
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-8 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-7}~
    ~{&OPEN-QUERY-BROWSE-8}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BROWSE-7 BROWSE-8 BUTTON-1 ~
RADIO-SET-1 rdsCuales 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 rdsCuales 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDoc W-Win 
FUNCTION fEstadoDoc RETURNS CHARACTER
  (INPUT pCodDOc AS CHAR, INPUT pFlag AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPedidos-del-canje W-Win 
FUNCTION fPedidos-del-canje RETURNS CHARACTER
  (INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTipoMov W-Win 
FUNCTION fTipoMov RETURNS CHARACTER
  ( INPUT pTipoMov AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Enviar a Excel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", "",
"Recepcionados", "R",
"Emitidos", "E",
"Malogrados", "M"
     SIZE 50 BY 1.08 NO-UNDO.

DEFINE VARIABLE rdsCuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Con Stock", 0,
"Sin Stock", 1,
"Todos", 2
     SIZE 38 BY 1.15 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-7 FOR 
      ccbstklet, 
      gn-clie SCROLLING.

DEFINE QUERY BROWSE-8 FOR 
      ccbmovlet, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-7 W-Win _STRUCTURED
  QUERY BROWSE-7 NO-LOCK DISPLAY
      ccbstklet.codclie FORMAT "x(11)":U
      gn-clie.NomCli FORMAT "x(250)":U WIDTH 62.86
      ccbstklet.qstklet FORMAT "->>,>>>,>>9":U WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 92 BY 14.62 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-8 W-Win _STRUCTURED
  QUERY BROWSE-8 NO-LOCK DISPLAY
      fTipoMov(ccbmovlet.tpomov) @ x-tpomov COLUMN-LABEL "Tipo Mov." FORMAT "x(12)":U
            WIDTH 9.43
      ccbmovlet.fchmov FORMAT "99/99/9999":U
      ccbmovlet.qletras COLUMN-LABEL "Cant." FORMAT "->,>>>,>>9":U
            WIDTH 6.72
      ccbmovlet.nrodoc COLUMN-LABEL "Nro.Letra" FORMAT "x(15)":U
      ccbmovlet.coddiv FORMAT "x(6)":U
      ccbmovlet.usrcrea FORMAT "x(15)":U WIDTH 10
      CcbCDocu.CodRef COLUMN-LABEL "C.Ref" FORMAT "x(3)":U
      CcbCDocu.NroRef COLUMN-LABEL "Nro. Refer." FORMAT "X(12)":U
            WIDTH 11.29
      fEstadoDoc(CcbCDocu.CodDoc,CcbCDocu.FlgEst) @  x-estado-doc COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 11.14
      fpedidos-del-canje(CcbCDocu.CodRef,CcbCDocu.NroRef) @ x-pedidos COLUMN-LABEL "Nro de Pedidos" FORMAT "x(60)":U
            WIDTH 18.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 11.15 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 6.77 COL 97 WIDGET-ID 14
     BROWSE-7 AT ROW 2.54 COL 2 WIDGET-ID 200
     BROWSE-8 AT ROW 18.5 COL 2 WIDGET-ID 300
     BUTTON-1 AT ROW 17.27 COL 58 WIDGET-ID 12
     RADIO-SET-1 AT ROW 17.35 COL 2.43 NO-LABEL WIDGET-ID 6
     rdsCuales AT ROW 1.19 COL 5 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.86 BY 28.96 WIDGET-ID 100.


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
         TITLE              = "Stock de letras"
         HEIGHT             = 28.96
         WIDTH              = 114.86
         MAX-HEIGHT         = 28.96
         MAX-WIDTH          = 116.29
         VIRTUAL-HEIGHT     = 28.96
         VIRTUAL-WIDTH      = 116.29
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
/* BROWSE-TAB BROWSE-7 1 F-Main */
/* BROWSE-TAB BROWSE-8 BROWSE-7 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-7
/* Query rebuild information for BROWSE BROWSE-7
     _TblList          = "INTEGRAL.ccbstklet,INTEGRAL.gn-clie WHERE INTEGRAL.ccbstklet ..."
     _Options          = "NO-LOCK"
     _OrdList          = "INTEGRAL.gn-clie.NomCli|yes"
     _Where[1]         = "ccbstklet.codcia = s-codcia and 
((x-cuales = 2) or 
 (x-cuales = 0 and ccbstklet.qstklet > 0) or
 (x-cuales = 1 and ccbstklet.qstklet <= 0)
)"
     _JoinCode[2]      = "gn-clie.CodCia = 0 and
 gn-clie.CodCli =  ccbstklet.codclie"
     _FldNameList[1]   = INTEGRAL.ccbstklet.codclie
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "62.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ccbstklet.qstklet
"ccbstklet.qstklet" ? ? "integer" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-7 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-8
/* Query rebuild information for BROWSE BROWSE-8
     _TblList          = "INTEGRAL.ccbmovlet,INTEGRAL.CcbCDocu WHERE INTEGRAL.ccbmovlet ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _OrdList          = "INTEGRAL.ccbmovlet.fchmov|yes"
     _Where[1]         = "ccbmovlet.codcia = s-codcia and 
ccbmovlet.codclie = x-codclie and
(x-filter = """" or ccbmovlet.tpomov = x-filter)"
     _JoinCode[2]      = "CcbCDocu.CodCia =  ccbmovlet.codcia and
ccbcdocu.coddoc = 'LET' and
ccbcdocu.nrodoc = ccbmovlet.nrodoc"
     _FldNameList[1]   > "_<CALC>"
"fTipoMov(ccbmovlet.tpomov) @ x-tpomov" "Tipo Mov." "x(12)" ? ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.ccbmovlet.fchmov
     _FldNameList[3]   > INTEGRAL.ccbmovlet.qletras
"ccbmovlet.qletras" "Cant." ? "integer" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ccbmovlet.nrodoc
"ccbmovlet.nrodoc" "Nro.Letra" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.ccbmovlet.coddiv
     _FldNameList[6]   > INTEGRAL.ccbmovlet.usrcrea
"ccbmovlet.usrcrea" ? ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.CodRef
"CcbCDocu.CodRef" "C.Ref" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.NroRef
"CcbCDocu.NroRef" "Nro. Refer." ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fEstadoDoc(CcbCDocu.CodDoc,CcbCDocu.FlgEst) @  x-estado-doc" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"fpedidos-del-canje(CcbCDocu.CodRef,CcbCDocu.NroRef) @ x-pedidos" "Nro de Pedidos" "x(60)" ? ? ? ? ? ? ? no ? no no "18.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-8 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Stock de letras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Stock de letras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-7
&Scoped-define SELF-NAME BROWSE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON ENTRY OF BROWSE-7 IN FRAME F-Main
DO:
    x-codclie = "".
    IF AVAILABLE ccbstklet THEN x-codclie = ccbstklet.codclie.
    {&OPEN-QUERY-BROWSE-8}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON MOUSE-SELECT-CLICK OF BROWSE-7 IN FRAME F-Main
DO:
    x-codclie = "".
  IF AVAILABLE ccbstklet THEN x-codclie = ccbstklet.codclie.
  {&OPEN-QUERY-BROWSE-8}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-7 W-Win
ON VALUE-CHANGED OF BROWSE-7 IN FRAME F-Main
DO:
    x-codclie = "".
  IF AVAILABLE ccbstklet THEN x-codclie = ccbstklet.codclie.
  {&OPEN-QUERY-BROWSE-8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Enviar a Excel */
DO:
  RUN enviar-excel(INPUT BROWSE-8:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Excel */
DO:
  RUN stock-a-excel(INPUT BROWSE-7:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 W-Win
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME F-Main
DO:
  x-filter = RADIO-SET-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  {&OPEN-QUERY-BROWSE-8}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rdsCuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rdsCuales W-Win
ON VALUE-CHANGED OF rdsCuales IN FRAME F-Main
DO:
    x-cuales = INTEGER(rdscuales:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
    {&OPEN-QUERY-BROWSE-7}  
    APPLY 'ENTRY' TO BROWSE-7 IN FRAME {&FRAME-NAME} .
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
  DISPLAY RADIO-SET-1 rdsCuales 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 BROWSE-7 BROWSE-8 BUTTON-1 RADIO-SET-1 rdsCuales 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-excel W-Win 
PROCEDURE enviar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-browse as handle no-undo.

   def var h-excel as com-handle no-undo.
   def var h-book as com-handle no-undo.
   def var h-sheet as com-handle no-undo.
   def var v-item as char no-undo.
   def var v-alpha as char extent 26 no-undo init ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","x","y","Z"].
   def var i as int no-undo.
   def var v-line as int no-undo.
   def var v-qu as log no-undo.
   def var v-handle as handle no-undo.
   v-qu = session:set-wait-state("General").
   CREATE "Excel.Application" h-Excel.
   h-book = h-Excel:Workbooks:Add().
   h-Sheet = h-Excel:Sheets:Item(1).
   
   v-line = 1.
   v-item = v-alpha[2] + string(v-line).
   h-sheet:range(v-item):value = "COD.CLIENTE :".
   v-item = v-alpha[3] + string(v-line).
   h-sheet:range(v-item):value = "'" + ccbstklet.codclie.
   v-line = v-line + 1.
   v-item = v-alpha[2] + string(v-line).
   h-sheet:range(v-item):value = "NOMBRE CLIENTE :".
   v-item = v-alpha[3] + string(v-line).
   h-sheet:range(v-item):value = gn-clie.nomcli.
   v-line = v-line + 1.
   v-item = v-alpha[2] + string(v-line).
   h-sheet:range(v-item):value = "STOCK :".
   v-item = v-alpha[3] + string(v-line).
   h-sheet:range(v-item):value = ccbstklet.qstklet.

   v-line = v-line + 1.
   do i = 1 to p-browse:num-columns:
      v-handle = p-browse:get-browse-column(i).
      /*v-item = v-alpha[i] + "1".*/
      v-item = v-alpha[i] + string(v-line).
      h-sheet:range(v-item):value = v-handle:label.      
   end.

   repeat:
      if v-line = 4 /*1*/ then 
         v-qu = p-browse:select-row(1).
      else v-qu = p-browse:select-next-row().
      if v-qu = no then leave.
      v-line = v-line + 1.
      do i = 1 to p-browse:num-columns:
         v-handle = p-browse:get-browse-column(i).
         v-item = v-alpha[i] + string(v-line).
         IF v-handle:data-type begins "char" OR v-handle:data-type begins "longchar" then assign
            h-sheet:range(v-item):Numberformat = "@"
            h-sheet:range(v-item):value = v-handle:screen-value.
         ELSE if v-handle:data-type begins "dec" then assign
            h-sheet:range(v-item):value = dec(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###,###,##0.00"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else if v-handle:data-type begins "int" then assign
            h-sheet:range(v-item):value = int(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###,###,##0"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else h-sheet:range(v-item):value = v-handle:screen-value.

      end.
   end.
   do i = 1 to p-browse:num-columns:
      v-qu = h-sheet:Columns(i):AutoFit.
   end.
   h-excel:visible = yes.
   release object h-sheet no-error.
   release object h-book no-error.
   release object h-excel no-error.
   v-qu = session:set-wait-state("").


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
  {src/adm/template/snd-list.i "ccbmovlet"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "ccbstklet"}
  {src/adm/template/snd-list.i "gn-clie"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stock-a-excel W-Win 
PROCEDURE stock-a-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


   def input parameter p-browse as handle no-undo.

   def var h-excel as com-handle no-undo.
   def var h-book as com-handle no-undo.
   def var h-sheet as com-handle no-undo.
   def var v-item as char no-undo.
   def var v-alpha as char extent 26 no-undo init ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","x","y","Z"].
   def var i as int no-undo.
   def var v-line as int no-undo.
   def var v-qu as log no-undo.
   def var v-handle as handle no-undo.
   v-qu = session:set-wait-state("General").
   CREATE "Excel.Application" h-Excel.
   h-book = h-Excel:Workbooks:Add().
   h-Sheet = h-Excel:Sheets:Item(1).
   
   v-line = 1.

   do i = 1 to p-browse:num-columns:
      v-handle = p-browse:get-browse-column(i).
      /*v-item = v-alpha[i] + "1".*/
      v-item = v-alpha[i] + string(v-line).
      h-sheet:range(v-item):value = v-handle:label.      
   end.
   
   repeat:
      if v-line = 1 then 
         v-qu = p-browse:select-row(1).
      else v-qu = p-browse:select-next-row().
      if v-qu = no then leave.
      v-line = v-line + 1.
      do i = 1 to p-browse:num-columns:
         v-handle = p-browse:get-browse-column(i).
         v-item = v-alpha[i] + string(v-line).
         IF v-handle:data-type begins "char" OR v-handle:data-type begins "longchar" then assign
            h-sheet:range(v-item):Numberformat = "@"
            h-sheet:range(v-item):value = v-handle:screen-value.
         ELSE if v-handle:data-type begins "dec" then assign
            h-sheet:range(v-item):value = dec(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###,###,##0.00"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else if v-handle:data-type begins "int" then assign
            h-sheet:range(v-item):value = int(v-handle:screen-value)
            h-sheet:range(v-item):Numberformat = "###,###,##0"
            h-sheet:range(v-item):HorizontalAlignment = -4152.
         else h-sheet:range(v-item):value = v-handle:screen-value.

      end.
   end.

   do i = 1 to p-browse:num-columns:
      v-qu = h-sheet:Columns(i):AutoFit.
   end.
   h-excel:visible = yes.
   release object h-sheet no-error.
   release object h-book no-error.
   release object h-excel no-error.

   p-browse:select-row(1).

   v-qu = session:set-wait-state("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDoc W-Win 
FUNCTION fEstadoDoc RETURNS CHARACTER
  (INPUT pCodDOc AS CHAR, INPUT pFlag AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR lRetVal AS CHAR INIT "Sin estado".

    RUN gn/fFlgEstCCBv2.r (INPUT pCodDoc, INPUT pFlag, OUTPUT lRetVal).

  RETURN lRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPedidos-del-canje W-Win 
FUNCTION fPedidos-del-canje RETURNS CHARACTER
  (INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR lretval AS CHAR INIT "".
  DEFINE VAR ldocs AS CHAR INIT "BOL,FAC".

  DEFINE BUFFER x-ccbdmvto FOR ccbdmvto.
  DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

  FOR EACH x-ccbdmvto WHERE x-ccbdmvto.codcia = s-codcia AND 
                            x-ccbdmvto.coddoc = pCodDoc AND
                            x-ccbdmvto.nrodoc = pNroDoc NO-LOCK:
        IF LOOKUP(x-ccbdmvto.codref,ldocs) > 0 THEN DO:
            FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                        x-ccbcdocu.coddoc = x-ccbdmvto.codref AND
                                        x-ccbcdocu.nrodoc = x-ccbdmvto.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-ccbcdocu THEN DO:
                IF lretval <> "" THEN lRetval = lretval + ", ".
                lretval = lretval + x-ccbcdocu.nroped.
            END.            
        END.                            
  END.

  RETURN lretval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTipoMov W-Win 
FUNCTION fTipoMov RETURNS CHARACTER
  ( INPUT pTipoMov AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR lretval AS CHAR INIT 'X'.

IF pTipoMov = 'R' THEN lretval = 'Recibidos'.
IF pTipoMov = 'E' THEN lretval = 'Emitidos'.
IF pTipoMov = 'M' THEN lretval = 'Malogrados'.

RETURN lRetval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

