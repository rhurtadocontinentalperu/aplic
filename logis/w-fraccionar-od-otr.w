&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADOCU FOR CcbADocu.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.
DEFINE NEW SHARED TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.
DEFINE NEW SHARED TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi.



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

DEF NEW SHARED VAR lh_handle AS HANDLE.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEF VAR x-Articulo-ICBPer AS CHAR NO-UNDO.
x-Articulo-ICBPer = '099268'.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 PEDI.codmat Almmmatg.DesMat ~
PEDI.CanPed PEDI.canate PEDI.UndVta 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH PEDI ~
      WHERE PEDI.CanAte < PEDI.CanPed NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH PEDI ~
      WHERE PEDI.CanAte < PEDI.CanPed NO-LOCK, ~
      EACH Almmmatg OF PEDI NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodPed FILL-IN-NroPed RECT-1 ~
RECT-2 RECT-3 RECT-4 BROWSE-2 BUTTON-Seleccionado BUTTON-Todos BUTTON-2 ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodPed FILL-IN-NroPed ~
FILL-IN-Peso FILL-IN-Volumen FILL-IN-Importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-updv14 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-fraccionar-od-otr-cab AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-fraccionar-od-otr-det AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-fraccionar-od-otr-pre AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/down.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-3 
     LABEL "FRACCIONAR ORDEN" 
     SIZE 44 BY 1.62
     FONT 8.

DEFINE BUTTON BUTTON-Seleccionado 
     IMAGE-UP FILE "img/right.ico":U
     LABEL "Button 1" 
     SIZE 6 BY 1.62 TOOLTIP "Solo el registro seleccionado".

DEFINE BUTTON BUTTON-Todos 
     IMAGE-UP FILE "img/next.ico":U
     LABEL "Button 3" 
     SIZE 6 BY 1.62 TOOLTIP "Todos los registros".

DEFINE VARIABLE COMBO-BOX-CodPed AS CHARACTER FORMAT "X(256)":U INITIAL "O/D" 
     LABEL "Doc" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "O/D","OTR" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 191 BY 13.23
     BGCOLOR 15 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 1.62.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 1.62.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      PEDI.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 5.43
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 51.14
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U
      PEDI.canate COLUMN-LABEL "Fraccionado" FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta FORMAT "x(8)":U WIDTH 7.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 91 BY 9.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodPed AT ROW 1 COL 22 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NroPed AT ROW 1 COL 41 COLON-ALIGNED WIDGET-ID 2
     BROWSE-2 AT ROW 2.08 COL 2 WIDGET-ID 200
     BUTTON-Seleccionado AT ROW 3.15 COL 94 WIDGET-ID 6
     BUTTON-Todos AT ROW 5.04 COL 94 WIDGET-ID 10
     BUTTON-2 AT ROW 12.04 COL 93 WIDGET-ID 8
     FILL-IN-Peso AT ROW 12.69 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-Volumen AT ROW 12.69 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Importe AT ROW 12.69 COL 71 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     BUTTON-3 AT ROW 21.19 COL 56 WIDGET-ID 14
     "Importe" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 12.19 COL 73 WIDGET-ID 32
     "Peso kg" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 12.19 COL 45 WIDGET-ID 28
     "Volumen m3" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 12.19 COL 59 WIDGET-ID 30
     "(2)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 6.65 COL 95 WIDGET-ID 36
          BGCOLOR 15 FGCOLOR 0 FONT 8
     "(3)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 10.96 COL 95 WIDGET-ID 38
          BGCOLOR 15 FGCOLOR 0 FONT 8
     "(4)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 21.19 COL 50 WIDGET-ID 40
          BGCOLOR 15 FGCOLOR 0 FONT 8
     "(1)" VIEW-AS TEXT
          SIZE 5 BY 1.08 AT ROW 1 COL 58 WIDGET-ID 34
          BGCOLOR 15 FGCOLOR 0 FONT 8
     RECT-1 AT ROW 13.92 COL 1 WIDGET-ID 12
     RECT-2 AT ROW 12.04 COL 44 WIDGET-ID 26
     RECT-3 AT ROW 12.04 COL 58 WIDGET-ID 16
     RECT-4 AT ROW 12.04 COL 72 WIDGET-ID 18
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
   Temp-Tables and Buffers:
      TABLE: B-ADOCU B "?" ? INTEGRAL CcbADocu
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
      TABLE: T-CPEDI T "NEW SHARED" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-DPEDI T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "FRACCIONAMIENTO DE LA ORDEN"
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
/* BROWSE-TAB BROWSE-2 RECT-4 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.PEDI.CanAte < Temp-Tables.PEDI.CanPed"
     _FldNameList[1]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "51.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.PEDI.CanPed
     _FldNameList[4]   > Temp-Tables.PEDI.canate
"PEDI.canate" "Fraccionado" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* FRACCIONAMIENTO DE LA ORDEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* FRACCIONAMIENTO DE LA ORDEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  MESSAGE 'Seguro de Genberar Sub-Orden?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Aceptar-Fraccionado IN h_t-fraccionar-od-otr-pre.
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* FRACCIONAR ORDEN */
DO:
  RUN Genera-Ordenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Seleccionado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Seleccionado W-Win
ON CHOOSE OF BUTTON-Seleccionado IN FRAME F-Main /* Button 1 */
DO:
  IF NOT AVAILABLE PEDI THEN RETURN NO-APPLY.
  DEF VAR pRaw AS RAW NO-UNDO.

  RAW-TRANSFER PEDI TO pRaw.
  RUN Captura-Registro IN h_t-fraccionar-od-otr-pre ( INPUT pRaw /* RAW */).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

  ASSIGN
      PEDI.CanAte = PEDI.CanPed.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  RUN Totales.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Todos W-Win
ON CHOOSE OF BUTTON-Todos IN FRAME F-Main /* Button 3 */
DO:
    IF NOT AVAILABLE PEDI THEN RETURN NO-APPLY.
    DEF VAR pRaw AS RAW NO-UNDO.

    FOR EACH PEDI WHERE PEDI.CanAte < PEDI.CanPed:
        RAW-TRANSFER PEDI TO pRaw.
        RUN Captura-Registro IN h_t-fraccionar-od-otr-pre ( INPUT pRaw /* RAW */).
        IF RETURN-VALUE = 'ADM-ERROR' THEN NEXT.
        ASSIGN
            PEDI.CanAte = PEDI.CanPed.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* Número */
DO:
  ASSIGN COMBO-BOX-CodPed FILL-IN-NroPed.
  FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
      Faccpedi.divdes = s-coddiv AND
      Faccpedi.coddoc = COMBO-BOX-CodPed AND
      Faccpedi.nroped = FILL-IN-NroPed AND
      Faccpedi.flgest = 'P' AND
      Faccpedi.flgsit = 'T' NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN DO:
      MESSAGE 'Orden NO se puede fraccionar' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CanAte > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE Facdpedi THEN DO:
      MESSAGE 'El código' Facdpedi.codmat 'presenta una atención' SKIP 
          'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
     SELF:SCREEN-VALUE = ''.
     RETURN NO-APPLY.
  END.
  /* RHC 14/10/2019 SI esta' en una PHR => NO VA */
  FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = s-codcia AND
      DI-RutaD.CodDiv = s-coddiv AND 
      DI-RutaD.CodDoc = 'PHR' AND
      DI-RutaD.CodRef = Faccpedi.coddoc AND
      DI-RutaD.NroRef = Faccpedi.nroped AND
      CAN-FIND(FIRST Di-RutaC OF Di-RutaD WHERE Di-RutaD.flgest <> 'A' NO-LOCK)
      NO-LOCK NO-ERROR.
  IF AVAILABLE Di-RutaD THEN DO:
      MESSAGE 'La Orden está en la PHR:' Di-RutaD.coddoc Di-RutaD.nrodoc SKIP
          'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
     SELF:SCREEN-VALUE = ''.
     RETURN NO-APPLY.
  END.
  /* RHC 14/10/2019 Si tiene una HPK => NO VA */
  FIND FIRST Vtacdocu WHERE Vtacdocu.CodCia = s-codcia AND
      Vtacdocu.CodDiv = s-coddiv AND 
      Vtacdocu.CodPed = 'HPK' AND
      Vtacdocu.CodRef = Faccpedi.coddoc AND
      Vtacdocu.NroRef = Faccpedi.nroped AND
      Vtacdocu.flgest <> 'A' NO-LOCK NO-ERROR.
  IF AVAILABLE Vtacdocu THEN DO:
      MESSAGE 'La Orden ya tiene una HPK:' Vtacdocu.codped Vtacdocu.nroped SKIP
          'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
     SELF:SCREEN-VALUE = ''.
     RETURN NO-APPLY.
  END.

  /* ******************************************* */
  COMBO-BOX-CodPed:SENSITIVE = NO.
  SELF:SENSITIVE = NO.
  EMPTY TEMP-TABLE T-CPEDI.
  EMPTY TEMP-TABLE T-DPEDI.
  RUN Carga-PEDI.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/t-fraccionar-od-otr-pre.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-fraccionar-od-otr-pre ).
       RUN set-position IN h_t-fraccionar-od-otr-pre ( 2.08 , 101.00 ) NO-ERROR.
       RUN set-size IN h_t-fraccionar-od-otr-pre ( 11.58 , 89.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv14.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv14 ).
       RUN set-position IN h_p-updv14 ( 12.04 , 101.00 ) NO-ERROR.
       RUN set-size IN h_p-updv14 ( 1.42 , 42.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/t-fraccionar-od-otr-cab.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-fraccionar-od-otr-cab ).
       RUN set-position IN h_t-fraccionar-od-otr-cab ( 14.19 , 56.00 ) NO-ERROR.
       RUN set-size IN h_t-fraccionar-od-otr-cab ( 6.69 , 44.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/t-fraccionar-od-otr-det.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-fraccionar-od-otr-det ).
       RUN set-position IN h_t-fraccionar-od-otr-det ( 14.19 , 101.00 ) NO-ERROR.
       RUN set-size IN h_t-fraccionar-od-otr-det ( 11.85 , 89.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-fraccionar-od-otr-pre. */
       RUN add-link IN adm-broker-hdl ( h_p-updv14 , 'TableIO':U , h_t-fraccionar-od-otr-pre ).

       /* Links to SmartBrowser h_t-fraccionar-od-otr-det. */
       RUN add-link IN adm-broker-hdl ( h_t-fraccionar-od-otr-cab , 'Record':U , h_t-fraccionar-od-otr-det ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-fraccionar-od-otr-pre ,
             BROWSE-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv14 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-fraccionar-od-otr-cab ,
             FILL-IN-Importe:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-fraccionar-od-otr-det ,
             h_t-fraccionar-od-otr-cab , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Fraccionado W-Win 
PROCEDURE Carga-Fraccionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ITEM.

/* Buscamos último registro grabado */
DEF VAR x-Control AS INT NO-UNDO.

x-Control = 01.
FOR EACH T-CPEDI BY T-CPEDI.NroPed:
    x-Control = x-Control + 1.
END.
DEF VAR x-NroPed AS CHAR NO-UNDO.

x-NroPed = Faccpedi.NroPed + '-' + STRING(x-Control, '99').
CREATE T-CPEDI.
BUFFER-COPY Faccpedi TO T-CPEDI
    ASSIGN T-CPEDI.NroPed = x-NroPed.
FOR EACH ITEM:
    CREATE T-DPEDI.
    BUFFER-COPY ITEM TO T-DPEDI
        ASSIGN 
            T-DPEDI.NroPed = x-NroPed
            T-DPEDI.CanPed = ITEM.CanAte
            T-DPEDI.CanAte = 0.
END.
 RUN dispatch IN h_t-fraccionar-od-otr-cab ('open-query':U).
 RUN dispatch IN h_t-fraccionar-od-otr-det ('open-query':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-PEDI W-Win 
PROCEDURE Carga-PEDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PEDI.

FOR EACH Facdpedi OF Faccpedi NO-LOCK:
    CREATE PEDI.
    BUFFER-COPY Facdpedi TO PEDI
        ASSIGN PEDI.CanAte = 0.     /* COntrol de Atenciones */
END.
{&OPEN-QUERY-{&BROWSE-NAME}}
RUN Totales.

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
  DISPLAY COMBO-BOX-CodPed FILL-IN-NroPed FILL-IN-Peso FILL-IN-Volumen 
          FILL-IN-Importe 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-CodPed FILL-IN-NroPed RECT-1 RECT-2 RECT-3 RECT-4 BROWSE-2 
         BUTTON-Seleccionado BUTTON-Todos BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-PEDI W-Win 
PROCEDURE Extorna-PEDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCantidad AS DEC.

FIND PEDI WHERE PEDI.CodMat = pCodMat.
ASSIGN
    PEDI.CanAte = PEDI.CanAte + pCantidad.
{&OPEN-QUERY-{&BROWSE-NAME}}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-SubOrden W-Win 
PROCEDURE Extorna-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CuentaError AS INT NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    REPEAT:
        FIND FIRST Vtacdocu WHERE VtaCDocu.CodCia = B-CPEDI.codcia
            AND VtaCDocu.CodDiv = B-CPEDI.coddiv
            AND VtaCDocu.CodPed = B-CPEDI.coddoc
            AND VtaCDocu.NroPed BEGINS B-CPEDI.nroped
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaCDocu THEN LEAVE.
        FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="x-CuentaError"}
             UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        REPEAT:
            FIND FIRST Vtaddocu OF Vtacdocu NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtaddocu THEN LEAVE.
            FIND CURRENT Vtaddocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="x-CuentaError"}
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            DELETE Vtaddocu.
        END.
        DELETE Vtacdocu.
    END.
END.
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR s-PorIgv LIKE Faccpedi.PorIgv NO-UNDO.
DEFINE VAR hMaster AS HANDLE NO-UNDO.

RUN gn/master-library PERSISTENT SET hMaster.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Correlativo de la división de origen de la orden */
    FIND FIRST Faccorre WHERE FacCorre.CodCia = B-CPEDI.CodCia AND
        FacCorre.CodDiv = B-CPEDI.CodDiv AND
        FacCorre.CodDoc = B-CPEDI.CodDoc AND
        FacCorre.NroSer = INTEGER(SUBSTRING(B-CPEDI.NroPed,1,3)) AND
        FacCorre.FlgEst = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        pMensaje = "Correlativo de la" + B-CPEDI.CodDoc + " NO configurado en la división " + B-CPEDI.coddiv.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = B-CPEDI.CodCia AND ~
        FacCorre.CodDiv = B-CPEDI.CodDiv AND ~
        FacCorre.CodDoc = B-CPEDI.CodDoc AND ~
        FacCorre.NroSer = INTEGER(SUBSTRING(B-CPEDI.NroPed,1,3))" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* 2do. Creamos Orden */
    CREATE Faccpedi.
    BUFFER-COPY B-CPEDI TO Faccpedi
        ASSIGN
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* ************************************************************************** */
    /* TRACKING */
    /* ******************************************************************** */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOD',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* ******************************************************************** */
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    /* ******************************************************************** */
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = B-CPEDI.codcia
        AND Ccbadocu.coddiv = B-CPEDI.coddiv
        AND Ccbadocu.coddoc = B-CPEDI.coddoc
        AND Ccbadocu.nrodoc = B-CPEDI.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Faccpedi.codcia
            AND B-ADOCU.coddiv = Faccpedi.coddiv
            AND B-ADOCU.coddoc = Faccpedi.coddoc
            AND B-ADOCU.nrodoc = Faccpedi.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed
            NO-ERROR.
    END.
    /* ******************************************************************** */
    /* 3ro. Detalle */
    /* ******************************************************************** */
    s-PorIgv = Faccpedi.PorIgv.
    FOR EACH T-DPEDI OF T-CPEDI NO-LOCK, FIRST Almmmatg OF T-DPEDI:
        CREATE Facdpedi.
        BUFFER-COPY T-DPEDI TO Facdpedi
            ASSIGN
            Facdpedi.codcia = Faccpedi.codcia
            Facdpedi.coddiv = Faccpedi.coddiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.nroped = Faccpedi.nroped
            Facdpedi.canapr = 0
            Facdpedi.canate = 0
            Facdpedi.canpedweb = 0
            Facdpedi.canpick = 0
            Facdpedi.cansol = 0
            Facdpedi.cantrf = 0.
        {vta2/calcula-linea-detalle.i &Tabla="Facdpedi"}
    END.
    /* ******************************************************************** */
    /* 4to. Totales */
    /* ******************************************************************** */
    {vta2/graba-totales-cotizacion-cred.i}
    /* ******************************************************************** */
    /* 5to. Genera Sub-Pedidos si fuera el caso */
    /* ******************************************************************** */
    /* RHC 01/10/2019 Caso especial CANAL MODERNO */
    IF FacCPedi.FlgSit = "T" THEN DO:
        RUN Genera-SubOrden IN hMaster (INPUT ROWID(Faccpedi),
                                        INPUT Faccpedi.DivDes,     /* División de Despacho */
                                        OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
    END.
    /* *************************************************************************** */
END.
DELETE PROCEDURE hMaster.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(FacCpedi) THEN RELEASE FacCpedi.
IF AVAILABLE(FacDpedi) THEN RELEASE FacDpedi.
IF AVAILABLE(B-ADOCU) THEN RELEASE B-ADOCU.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ordenes W-Win 
PROCEDURE Genera-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia */
IF CAN-FIND(FIRST PEDI WHERE PEDI.CanAte < PEDI.CanPed NO-LOCK)
    THEN DO:
    MESSAGE 'Primero tiene que fraccionar TODA la orden' VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.
DEF VAR pOk AS LOG NO-UNDO.
RUN Verifica-Registros IN h_t-fraccionar-od-otr-pre
    ( OUTPUT pOk /* LOGICAL */).
IF pOk = NO THEN DO:
    MESSAGE 'Primero tiene que fraccionar TODA la orden' VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

MESSAGE 'Procedemos a FRACCIONAR la Orden?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

RUN MASTER-TRANSACTION.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    ELSE MESSAGE 'NO se pudo fraccionar la orden' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Limpiamos todos los temporales y reactivamos campos */
RUN Limpiar-Todo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Todo W-Win 
PROCEDURE Limpiar-Todo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ENABLE FILL-IN-NroPed COMBO-BOX-CodPed.
    EMPTY TEMP-TABLE T-CPEDI.
    EMPTY TEMP-TABLE T-DPEDI.
    EMPTY TEMP-TABLE PEDI.
    RUN dispatch IN h_t-fraccionar-od-otr-cab ('open-query':U).
    RUN dispatch IN h_t-fraccionar-od-otr-det ('open-query':U).
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

pMensaje = ''.
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPEDI.codcia = s-codcia AND ~
        B-CPEDI.divdes = s-coddiv AND ~
        B-CPEDI.coddoc = COMBO-BOX-CodPed AND ~
        B-CPEDI.nroped = FILL-IN-NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* Verificamos Orden */        
    IF NOT (B-CPEDI.flgest = 'P' AND B-CPEDI.flgsit = 'T') THEN DO:
        pMensaje = "La Orden ya NO se puede fraccionar".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Facdpedi OF B-CPEDI WHERE Facdpedi.CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN DO:
        pMensaje = 'El código ' + Facdpedi.codmat + ' presenta una atención' + CHR(10) +
            'Acceso Denegado'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Por cada Fracción generamos una orden */
    FOR EACH T-CPEDI:
        RUN FIRST-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* Extornamos Sub-Ordenes si fuera el caso */
    RUN Extorna-SubOrden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* Anulamos la original */
    ASSIGN 
        B-CPEDI.FlgEst = "A"
        B-CPEDI.Glosa = " A N U L A D O".

END.
IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
RETURN 'OK'.

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
  {src/adm/template/snd-list.i "PEDI"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-PEDI FOR PEDI.
DEF BUFFER B-ALMMMATG FOR Almmmatg.

ASSIGN
    FILL-IN-Importe = 0
    FILL-IN-Peso = 0
    FILL-IN-Volumen = 0.
FOR EACH B-PEDI, FIRST B-ALMMMATG OF B-PEDI NO-LOCK:
    ASSIGN
        FILL-IN-Importe = FILL-IN-Importe + (B-PEDI.PreUni * B-PEDI.CanPed)
        FILL-IN-Peso = FILL-IN-Peso + (B-PEDI.CanPed  * B-PEDI.Factor * B-ALMMMATG.PesMat)
        FILL-IN-Volumen = FILL-IN-Volumen + (B-PEDI.CanPed * B-PEDI.Factor * B-ALMMMATG.Libre_d02 / 1000000).
END.
DISPLAY FILL-IN-Importe FILL-IN-Peso FILL-IN-Volumen WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

