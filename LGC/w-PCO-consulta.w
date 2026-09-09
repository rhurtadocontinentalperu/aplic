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
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.

FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
    faccpedi.coddoc = pCodDoc AND 
    faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "PCO no existe".
    RETURN ERROR.
END.

DEFINE VAR xCaso AS CHAR INIT "".

&SCOPED-DEFINE CONDICION ( ~
                integral.faccpedi.tipvta BEGINS xCaso).

DEF VAR x-PorAtender AS DEC NO-UNDO.
DEF VAR x-StkAct     AS DEC NO-UNDO.

DEFINE VAR x-imp-col AS DEC.
DEFINE VAR x-peso-col AS DEC.

DEFINE NEW SHARED VARIABLE S-CODMAT   AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 FacDPedi.NroItm FacDPedi.codmat ~
Almmmatg.DesMat Almmmatg.DesMar FacDPedi.UndVta FacDPedi.CanPed ~
peso-item() @ x-peso-col FacDPedi.Libre_c01 FacDPedi.Libre_c02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH FacDPedi ~
      WHERE facdpedi.codcia = s-codcia and  ~
facdpedi.coddoc = pCodDoc and ~
facdpedi.nroped = pNroDoc and ~
facdpedi.tipvta begins xCaso NO-LOCK, ~
      FIRST Almmmatg OF FacDPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH FacDPedi ~
      WHERE facdpedi.codcia = s-codcia and  ~
facdpedi.coddoc = pCodDoc and ~
facdpedi.nroped = pNroDoc and ~
facdpedi.tipvta begins xCaso NO-LOCK, ~
      FIRST Almmmatg OF FacDPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cboCaso BROWSE-5 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.RucCli FacCPedi.DirCli FacCPedi.FchPed ~
FacCPedi.FchEnt FacCPedi.DivDes FacCPedi.LugEnt2 FacCPedi.FmaPgo ~
FacCPedi.CodDiv 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS cboCaso FILL-IN-imptot FILL-IN-pesotot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAlmDes W-Win 
FUNCTION fAlmDes RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fStkAct W-Win 
FUNCTION fStkAct RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD peso-item W-Win 
FUNCTION peso-item RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cboCaso AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caso" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D"
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-imptot AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-pesotot AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      FacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      FacDPedi.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 4.43
      FacDPedi.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "X(6)":U
            WIDTH 7.57
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 40.43
      Almmmatg.DesMar FORMAT "X(30)":U WIDTH 12.43
      FacDPedi.UndVta FORMAT "x(8)":U WIDTH 4.43
      FacDPedi.CanPed COLUMN-LABEL "Cantidad!Autorizada" FORMAT ">,>>>,>>9.9999":U
            WIDTH 12.14
      peso-item() @ x-peso-col COLUMN-LABEL "Peso" FORMAT "->>,>>>,>>9.99":U
            WIDTH 10.72
      FacDPedi.Libre_c01 COLUMN-LABEL "Caso" FORMAT "x(3)":U
      FacDPedi.Libre_c02 COLUMN-LABEL "Dspcho" FORMAT "x(10)":U
            WIDTH 21
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126.86 BY 14.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.19 COL 11 COLON-ALIGNED WIDGET-ID 40
          LABEL "PCO" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.CodCli AT ROW 1.19 COL 38 COLON-ALIGNED WIDGET-ID 8
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.NomCli AT ROW 1.19 COL 54.72 COLON-ALIGNED NO-LABEL WIDGET-ID 36 FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 51.43 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.RucCli AT ROW 1.19 COL 115 COLON-ALIGNED WIDGET-ID 38
          LABEL "R.U.C" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.DirCli AT ROW 2.31 COL 11 COLON-ALIGNED WIDGET-ID 12
          LABEL "Direccion" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 76 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.FchPed AT ROW 2.31 COL 96.57 COLON-ALIGNED WIDGET-ID 18
          LABEL "Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.FchEnt AT ROW 2.35 COL 120.14 COLON-ALIGNED WIDGET-ID 16
          LABEL "F.Entrega" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.DivDes AT ROW 3.5 COL 12.86 COLON-ALIGNED WIDGET-ID 14
          LABEL "Div.Despacho" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 9.43 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.LugEnt2 AT ROW 3.5 COL 38.86 COLON-ALIGNED WIDGET-ID 34
          LABEL "Alm. Despacho" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 20.14 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FacCPedi.FmaPgo AT ROW 3.5 COL 80.72 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
          BGCOLOR 15 FGCOLOR 9 
     cboCaso AT ROW 3.5 COL 100 COLON-ALIGNED WIDGET-ID 42
     FacCPedi.CodDiv AT ROW 3.69 COL 126 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
          BGCOLOR 15 FGCOLOR 9 
     FILL-IN-imptot AT ROW 4.77 COL 36.43 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-pesotot AT ROW 4.85 COL 13 COLON-ALIGNED WIDGET-ID 44
     BROWSE-5 AT ROW 6.27 COL 3.14 WIDGET-ID 200
     "F8 : Stock Almacenes" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 5.62 COL 90.57 WIDGET-ID 48
          FGCOLOR 4 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.43 BY 20.73 WIDGET-ID 100.


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
         TITLE              = "Consulta de Cotizacion"
         HEIGHT             = 20.73
         WIDTH              = 136.43
         MAX-HEIGHT         = 20.73
         MAX-WIDTH          = 136.43
         VIRTUAL-HEIGHT     = 20.73
         VIRTUAL-WIDTH      = 136.43
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
/* BROWSE-TAB BROWSE-5 FILL-IN-pesotot F-Main */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.DivDes IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.FchEnt IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-imptot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-pesotot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.LugEnt2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.FacDPedi,INTEGRAL.Almmmatg OF INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST,"
     _Where[1]         = "facdpedi.codcia = s-codcia and 
facdpedi.coddoc = pCodDoc and
facdpedi.nroped = pNroDoc and
facdpedi.tipvta begins xCaso"
     _FldNameList[1]   > INTEGRAL.FacDPedi.NroItm
"FacDPedi.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Codigo!Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "40.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacDPedi.UndVta
"FacDPedi.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" "Cantidad!Autorizada" ? "decimal" ? ? ? ? ? ? no ? no no "12.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"peso-item() @ x-peso-col" "Peso" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacDPedi.Libre_c01
"FacDPedi.Libre_c01" "Caso" "x(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacDPedi.Libre_c02
"FacDPedi.Libre_c02" "Dspcho" "x(10)" "character" ? ? ? ? ? ? no ? no no "21" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Cotizacion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Cotizacion */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 W-Win
ON F8 OF BROWSE-5 IN FRAME F-Main
DO:
    IF AVAILABLE facdpedi THEN DO:
        S-CODMAT = facdpedi.CodMat.
        RUN alm/d-stkalm.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboCaso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboCaso W-Win
ON VALUE-CHANGED OF cboCaso IN FRAME F-Main /* Caso */
DO:
  ASSIGN {&self-name}.

  xCaso = {&self-name}.

  {&OPEN-QUERY-BROWSE-5}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-totales W-Win 
PROCEDURE calcula-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-ImpTot AS DEC NO-UNDO.
DEFINE VAR x-PesoTot AS DEC NO-UNDO.

DEFINE BUFFER x-facdpedi FOR facdpedi.
x-ImpTot = 0.
x-PesoTot = 0.

FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND 
                            x-facdpedi.coddoc = pCodDoc AND 
                            x-facdpedi.nroped = pNroDoc NO-LOCK:
    FIND FIRST almmmatg OF x-facdpedi NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        x-PesoTot = x-PesoTot + ((x-facdpedi.canped * x-facdpedi.factor) * almmmatg.pesmat).
    END.
    x-ImpTot = x-ImpTot + (x-facdpedi.canped * (x-facdpedi.implin / x-facdpedi.libre_d05)).
END.

fill-in-pesotot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-PesoTot,"->>,>>>,>>9.99").
fill-in-imptot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-ImpTot,"->>,>>>,>>9.99").

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
  DISPLAY cboCaso FILL-IN-imptot FILL-IN-pesotot 
      WITH FRAME F-Main IN WINDOW W-Win.
  IF AVAILABLE FacCPedi THEN 
    DISPLAY FacCPedi.NroPed FacCPedi.CodCli FacCPedi.NomCli FacCPedi.RucCli 
          FacCPedi.DirCli FacCPedi.FchPed FacCPedi.FchEnt FacCPedi.DivDes 
          FacCPedi.LugEnt2 FacCPedi.FmaPgo FacCPedi.CodDiv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cboCaso BROWSE-5 
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

  RUN calcula-totales.

  {&OPEN-QUERY-BROWSE-5}

/*
  IF NOT AVAILABLE faccpedi THEN DO:
    /* --- */
    MESSAGE "Cotizacion no EXISTE".
    RETURN "ADM-ERROR".
  END.
*/

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
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAlmDes W-Win 
FUNCTION fAlmDes RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NUM-ENTRIES(Faccpedi.LugEnt2) NE 4 THEN RETURN FacDPedi.AlmDes.
  CASE FacDPedi.TipVta:
      WHEN "A" THEN RETURN ENTRY(1,Faccpedi.LugEnt2).
      WHEN "B" THEN RETURN ENTRY(2,Faccpedi.LugEnt2).
      WHEN "C" THEN RETURN ENTRY(3,Faccpedi.LugEnt2).
      WHEN "D" THEN RETURN ENTRY(4,Faccpedi.LugEnt2).
  END CASE.

  RETURN FacDPedi.AlmDes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fStkAct W-Win 
FUNCTION fStkAct RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pAlmDes AS CHAR NO-UNDO.
  pAlmDes = fAlmDes().
  IF pAlmDes > '' THEN DO:
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = pAlmDes
          AND Almmmate.codmat = Facdpedi.codmat
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN RETURN (Almmmate.StkAct - Almmmate.StkComprometido).
  END.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION peso-item W-Win 
FUNCTION peso-item RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-retval AS DEC.

    x-retval = (facdpedi.canped * facdpedi.factor) * almmmatg.pesmat.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

