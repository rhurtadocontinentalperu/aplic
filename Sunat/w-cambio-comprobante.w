&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.



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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Definimos la división de trabajo */
DEF NEW SHARED VAR s-coddiv AS CHAR INIT '99999'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for FRAME F-Main                                         */
&Scoped-define QUERY-STRING-F-Main FOR EACH CcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-F-Main OPEN QUERY F-Main FOR EACH CcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-F-Main CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-F-Main CcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 COMBO-BOX-CodDoc ~
BUTTON-2 BUTTON-3 FILL-IN-NroDoc FILL-IN_ImpCtrl COMBO-BOX-NewSerie ~
COMBO-BOX-NewSerieNC BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodDoc FILL-IN-NroDoc ~
FILL-IN_CodCli FILL-IN_NomCli FILL-IN_ImpCtrl FILL-IN_FchDoc FILL-IN_CodDiv ~
COMBO-BOX-CodMon FILL-IN_ImpTot FILL-IN_NewCli COMBO-BOX-NewSerie ~
FILL-IN-NewNro COMBO-BOX-NewSerieNC FILL-IN-NewNroNC 

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
     SIZE 15 BY 1.54 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-buscar.ico":U
     LABEL "Button 2" 
     SIZE 5 BY 1.12 TOOLTIP "Buscar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-borra.ico":U
     LABEL "Button 3" 
     SIZE 5 BY 1.12 TOOLTIP "Nuevo".

DEFINE VARIABLE COMBO-BOX-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Comprobante (*)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Factura","FAC"
     DROP-DOWN-LIST
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodMon AS INTEGER FORMAT "9":U INITIAL 1 
     LABEL "Moneda" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Soles",1,
                     "Dolares",2
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NewSerie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la serie (*)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NewSerieNC AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la serie (*)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NewNro AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NewNroNC AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "x(11)":U 
     LABEL "Número (*)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente (*)" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_CodDiv AS CHARACTER FORMAT "x(5)" INITIAL "00000" 
     LABEL "C.Div" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81.

DEFINE VARIABLE FILL-IN_FchDoc AS DATE FORMAT "99/99/9999" INITIAL 07/01/16 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE FILL-IN_ImpCtrl AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Importe Total (*)" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "->>,>>>,>>9.99" INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_NewCli AS CHARACTER FORMAT "x(11)" 
     LABEL "Cliente (*)" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 11 FGCOLOR 0 .

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "x(80)" 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 7.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 3.08.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY F-Main FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodDoc AT ROW 2.35 COL 17 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 2.35 COL 33 WIDGET-ID 54
     BUTTON-3 AT ROW 2.35 COL 38 WIDGET-ID 60
     FILL-IN-NroDoc AT ROW 3.31 COL 17 COLON-ALIGNED WIDGET-ID 6
     FILL-IN_CodCli AT ROW 4.27 COL 17 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_NomCli AT ROW 4.27 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     FILL-IN_ImpCtrl AT ROW 5.23 COL 17 COLON-ALIGNED WIDGET-ID 56
     FILL-IN_FchDoc AT ROW 6.19 COL 17 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_CodDiv AT ROW 7.15 COL 17 COLON-ALIGNED WIDGET-ID 10
     COMBO-BOX-CodMon AT ROW 8.12 COL 17 COLON-ALIGNED WIDGET-ID 22
     FILL-IN_ImpTot AT ROW 8.12 COL 37 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_NewCli AT ROW 10.04 COL 17 COLON-ALIGNED WIDGET-ID 62
     COMBO-BOX-NewSerie AT ROW 11 COL 17 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-NewNro AT ROW 11 COL 35 COLON-ALIGNED WIDGET-ID 32
     COMBO-BOX-NewSerieNC AT ROW 13.12 COL 17 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-NewNroNC AT ROW 13.12 COL 35 COLON-ALIGNED WIDGET-ID 42
     BUTTON-1 AT ROW 15.23 COL 55 WIDGET-ID 44
     BtnDone AT ROW 15.23 COL 70 WIDGET-ID 46
     "(*): Campos obligatorios" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 8.88 COL 68 WIDGET-ID 58
          BGCOLOR 14 FGCOLOR 0 
     "Datos para el nuevo comprobante" VIEW-AS TEXT
          SIZE 30 BY .5 AT ROW 9.27 COL 4 WIDGET-ID 36
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Datos para el nueva Nota de Crédito" VIEW-AS TEXT
          SIZE 31 BY .5 AT ROW 12.35 COL 4 WIDGET-ID 38
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Datos del comprobante Rechazado por SUNAT" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 1.58 COL 4 WIDGET-ID 34
          BGCOLOR 9 FGCOLOR 15 FONT 6
     RECT-1 AT ROW 1.77 COL 3 WIDGET-ID 48
     RECT-2 AT ROW 9.65 COL 3 WIDGET-ID 50
     RECT-3 AT ROW 12.73 COL 3 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95 BY 16.46
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CAMBIO DE COMPROBANTE"
         HEIGHT             = 16.46
         WIDTH              = 95
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
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NewNro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NewNroNC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NewCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _TblList          = "INTEGRAL.CcbCDocu"
     _Query            is OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CAMBIO DE COMPROBANTE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CAMBIO DE COMPROBANTE */
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


&Scoped-define SELF-NAME COMBO-BOX-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDoc W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDoc IN FRAME F-Main /* Comprobante (*) */
DO:
    FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
        AND FacCorre.CodDiv = s-coddiv 
        AND FacCorre.CodDoc = SELF:SCREEN-VALUE 
        AND FacCorre.FlgEst = YES:
        COMBO-BOX-NewSerie:ADD-LAST(STRING(FacCorre.NroSer, '999')).
    END.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NewSerie.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NewSerie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NewSerie W-Win
ON VALUE-CHANGED OF COMBO-BOX-NewSerie IN FRAME F-Main /* Seleccione la serie (*) */
DO:
    FIND FacCorre WHERE FacCorre.CodCia = s-codcia
        AND FacCorre.CodDiv = s-coddiv
        AND FacCorre.CodDoc = COMBO-BOX-CodDoc:SCREEN-VALUE
        AND FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre 
        THEN DISPLAY FacCorre.Correlativo @ FILL-IN-NewNro WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NewSerieNC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NewSerieNC W-Win
ON VALUE-CHANGED OF COMBO-BOX-NewSerieNC IN FRAME F-Main /* Seleccione la serie (*) */
DO:
  FIND FacCorre WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.CodDiv = s-coddiv
      AND FacCorre.CodDoc = "N/C"
      AND FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre 
      THEN DISPLAY FacCorre.Correlativo @ FILL-IN-NewNroNC WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc W-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Número (*) */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = INPUT COMBO-BOX-CodDoc
      AND Ccbcdocu.nrodoc = INPUT FILL-IN-NroDoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN DO:
      MESSAGE 'Comprobante NO registrado' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE =''.
      RETURN NO-APPLY.
  END.
  FIND FELogComprobantes WHERE FELogComprobantes.CodCia = Ccbcdocu.codcia
      AND FELogComprobantes.CodDoc = Ccbcdocu.coddoc
      AND FELogComprobantes.NroDoc = Ccbcdocu.nrodoc
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FELogComprobantes OR FELogComprobantes.EstadoSunat = 1
      THEN DO:
      MESSAGE 'Comprobante NO está Rechazado por SUNAT' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE =''.
      RETURN NO-APPLY.
  END.
  DISPLAY
      Ccbcdocu.codcli @ FILL-IN_CodCli 
      Ccbcdocu.nomcli @ FILL-IN_NomCli
      Ccbcdocu.fchdoc @ FILL-IN_FchDoc 
      Ccbcdocu.coddiv @ FILL-IN_CodDiv 
      Ccbcdocu.imptot @ FILL-IN_ImpTot 
      WITH FRAME {&FRAME-NAME}.
  COMBO-BOX-CodMon = Ccbcdocu.codmon.
  DISPLAY COMBO-BOX-CodMon WITH FRAME {&FRAME-NAME}.
  
  DEF VAR x-Ok AS LOG NO-UNDO.
  DEF VAR x-Lista AS CHAR NO-UNDO.

  x-Lista = COMBO-BOX-NewCli:LIST-ITEM-PAIRS.
  ASSIGN x-Ok = COMBO-BOX-NewCli:DELETE(x-Lista) NO-ERROR.
  COMBO-BOX-NewCli:ADD-LAST(Ccbcdocu.codcli + ' - ' + Ccbcdocu.nomcli,Ccbcdocu.codcli).
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
      AND gn-clie.CodCli = '20100038146'
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN COMBO-BOX-NewCli:ADD-LAST(gn-clie.codcli + ' - ' + gn-clie.nomcli,gn-clie.codcli).
  COMBO-BOX-NewCli = Ccbcdocu.codcli.
  DISPLAY COMBO-BOX-NewCli WITH FRAME {&FRAME-NAME}.
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

  {&OPEN-QUERY-F-Main}
  GET FIRST F-Main.
  DISPLAY COMBO-BOX-CodDoc FILL-IN-NroDoc FILL-IN_CodCli FILL-IN_NomCli 
          FILL-IN_ImpCtrl FILL-IN_FchDoc FILL-IN_CodDiv COMBO-BOX-CodMon 
          FILL-IN_ImpTot FILL-IN_NewCli COMBO-BOX-NewSerie FILL-IN-NewNro 
          COMBO-BOX-NewSerieNC FILL-IN-NewNroNC 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 RECT-3 COMBO-BOX-CodDoc BUTTON-2 BUTTON-3 FILL-IN-NroDoc 
         FILL-IN_ImpCtrl COMBO-BOX-NewSerie COMBO-BOX-NewSerieNC BUTTON-1 
         BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobantes W-Win 
PROCEDURE Genera-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    RUN Genera-factura.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN Genera-nc.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-factura W-Win 
PROCEDURE Genera-factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT COMBO-BOX-CodDoc, OUTPUT x-Formato).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos comprobante base */
    FIND B-CDOCU WHERE Ccbcdocu.CodCia = s-CodCia ~
        AND Ccbcdocu.CodDoc = COMBO-BOX-CodDoc ~
        AND Ccbcdocu.NroDoc = FILL-IN-NroDoc ~
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN UNDO, RETURN 'ADM-ERROR'.
    /* Bloqueamos correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = COMBO-BOX-CodDoc ~
        AND FacCorre.NroSer = COMBO-BOX-NewSerieNC" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    /* Generamos nuevo comprobante */
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU TO Ccbcdocu.
    ASSIGN
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.usuario = S-USER-ID.
    IF Ccbcdocu.codcli <> COMBO-BOX-NewCli THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = COMBO-BOX-NewCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                CcbCDocu.CodCli = gn-clie.CodCli
                Ccbcdocu.NomCli = gn-clie.NomCli
                Ccbcdocu.RucCli = gn-clie.Ruc
                Ccbcdocu.DirCli = gn-clie.DirCli.
        END.
    END.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCli = CcbCDocu.CodCli 
            CcbDDocu.CodDiv = CcbCDocu.CodDiv 
            CcbDDocu.CodDoc = CcbCDocu.CodDoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc.
    END.
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-NewCli:DELIMITER = '|'.
      FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
          AND FacCorre.CodDiv = s-coddiv 
          AND FacCorre.CodDoc = "N/C" 
          AND FacCorre.FlgEst = YES:
          COMBO-BOX-NewSerieNC:ADD-LAST(STRING(FacCorre.NroSer, '999')).
      END.
      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NewSerieNC.
      FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
          AND FacCorre.CodDiv = s-coddiv 
          AND FacCorre.CodDoc = "FAC" 
          AND FacCorre.FlgEst = YES:
          COMBO-BOX-NewSerie:ADD-LAST(STRING(FacCorre.NroSer, '999')).
      END.
      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NewSerie.
  END.

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

