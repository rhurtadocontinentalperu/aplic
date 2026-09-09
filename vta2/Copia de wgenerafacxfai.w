&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Cabecera NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE CcbDDocu.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR s-CodMov LIKE Facdocum.codmov NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.
DEF VAR iCountGuide AS INTEGER NO-UNDO.

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = s-CodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" s-CodDoc "no configurado" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-CodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.FlgEst = YES:
    /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
    FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
        AND CcbDTerm.CodDiv = s-coddiv
        AND CcbDTerm.CodDoc = s-CodDoc
        AND CcbDTerm.NroSer = FacCorre.NroSer
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDTerm THEN DO:
        /* Verificamos la cabecera */
        FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
        IF AVAILABLE CcbCTerm THEN NEXT.
    END.
    cOk = YES.
END.
IF cOk = NO THEN DO:
    MESSAGE
        "Codigo de Documento" s-CodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
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
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.NomCli ~
(IF CcbCDocu.CodMon = 1 THEN "S/." ELSE "US$") @ x-Moneda CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDoc = "FAI" ~
 AND CcbCDocu.CodDiv = s-coddiv ~
 AND CcbCDocu.FlgEst = "P" ~
 AND CcbCDocu.CodCli = COMBO-BOX-Clientes NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDoc = "FAI" ~
 AND CcbCDocu.CodDiv = s-coddiv ~
 AND CcbCDocu.FlgEst = "P" ~
 AND CcbCDocu.CodCli = COMBO-BOX-Clientes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 Btn_OK BtnDone COMBO-BOX-Clientes ~
COMBO-NroSer BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Division COMBO-BOX-Clientes ~
COMBO-NroSer FILL-IN-NroDoc FILL-IN-items 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Clientes AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione un cliente" 
     LABEL "Cliente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Seleccione un cliente","Seleccione un cliente"
     DROP-DOWN-LIST
     SIZE 77 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY 1
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Comproibante" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 1.92
     BGCOLOR 11 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U WIDTH 5.43
      CcbCDocu.NroDoc FORMAT "X(9)":U WIDTH 9.43
      CcbCDocu.FchDoc FORMAT "99/99/9999":U WIDTH 9.43
      CcbCDocu.CodRef FORMAT "x(3)":U WIDTH 6.43
      CcbCDocu.NroRef FORMAT "X(9)":U WIDTH 9.43
      CcbCDocu.NomCli FORMAT "x(50)":U
      (IF CcbCDocu.CodMon = 1 THEN "S/." ELSE "US$") @ x-Moneda COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 11.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 12.88
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Division AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 1.19 COL 76 WIDGET-ID 32
     BtnDone AT ROW 1.19 COL 88 WIDGET-ID 34
     COMBO-BOX-Clientes AT ROW 2.92 COL 9 COLON-ALIGNED WIDGET-ID 12
     COMBO-NroSer AT ROW 3.88 COL 3.43 WIDGET-ID 2
     FILL-IN-NroDoc AT ROW 3.88 COL 15.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 3.88 COL 49 COLON-ALIGNED WIDGET-ID 18
     BROWSE-4 AT ROW 4.85 COL 2 WIDGET-ID 200
     RECT-2 AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100.86 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: Cabecera T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: Detalle T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE FACTURAS INTERNAS (FAI)"
         HEIGHT             = 17
         WIDTH              = 100.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 120.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 120.86
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
/* BROWSE-TAB BROWSE-4 FILL-IN-items F-Main */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "CcbCDocu.CodCia = s-codcia
 AND CcbCDocu.CodDoc = ""FAI""
 AND CcbCDocu.CodDiv = s-coddiv
 AND CcbCDocu.FlgEst = ""P""
 AND CcbCDocu.CodCli = COMBO-BOX-Clientes"
     _FldNameList[1]   > INTEGRAL.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" ? ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" ? ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodRef
"CcbCDocu.CodRef" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.NroRef
"CcbCDocu.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.CcbCDocu.NomCli
     _FldNameList[7]   > "_<CALC>"
"(IF CcbCDocu.CodMon = 1 THEN ""S/."" ELSE ""US$"") @ x-Moneda" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE FACTURAS INTERNAS (FAI) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE FACTURAS INTERNAS (FAI) */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
         COMBO-NroSer FILL-IN-Division FILL-IN-items FILL-IN-NroDoc.
    IF FILL-IN-Division BEGINS 'Seleccione' THEN RETURN NO-APPLY.

/*     IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO: */
/*         MESSAGE "Seleccione al manos 1 registro"                            */
/*             VIEW-AS ALERT-BOX ERROR.                                        */
/*         RETURN NO-APPLY.                                                    */
/*     END.                                                                    */

    MESSAGE
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    /* UN SOLO PROCESO */
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Generacion-de-Factura.
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN
        MESSAGE
            "Ninguna Factura fue generada"
            VIEW-AS ALERT-BOX WARNING.
    ELSE DO:
        MESSAGE
            "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
/*     COMBO-BOX-Clientes = "Seleccione un cliente".        */
/*     DISPLAY COMBO-BOX-Clientes WITH FRAME {&FRAME-NAME}. */
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Clientes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Clientes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Clientes W-Win
ON VALUE-CHANGED OF COMBO-BOX-Clientes IN FRAME F-Main /* Cliente */
DO:
  ASSIGN {&self-name}.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON RETURN OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    APPLY 'Tab':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie FAC */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc = "".
    DISPLAY FILL-IN-NroDoc WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicacion-de-Adelantos W-Win 
PROCEDURE Aplicacion-de-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') = 0 THEN RETURN.
RUN vtagn/p-aplica-factura-adelantada (ROWID(Ccbcdocu)).

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
  DISPLAY FILL-IN-Division COMBO-BOX-Clientes COMBO-NroSer FILL-IN-NroDoc 
          FILL-IN-items 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 Btn_OK BtnDone COMBO-BOX-Clientes COMBO-NroSer BROWSE-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generacion-de-Factura W-Win 
PROCEDURE Generacion-de-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR lCreaHeader AS LOG NO-UNDO.
DEF VAR lItemOk AS LOG NO-UNDO.
DEF VAR iCountItem AS INT NO-UNDO.

/* Cargamos todos los items a facturar */
EMPTY TEMP-TABLE Cabecera.
EMPTY TEMP-TABLE Detalle.
DEF VAR k AS INT NO-UNDO.
trloop:
DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
    /* 1ro. RESUMIMOS LOS FAI */
    GET FIRST {&browse-name}.
    REPEAT WHILE AVAILABLE Ccbcdocu:
        FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
        ASSIGN
            Ccbcdocu.FlgEst = "C"
            Ccbcdocu.SdoAct = 0
            CcbCDocu.FchAnu = TODAY
            CcbCDocu.UsuAnu = s-user-id.
        /* REGISTRO DE CONTROL */
        FIND FIRST Cabecera NO-ERROR.
        IF NOT AVAILABLE Cabecera THEN CREATE Cabecera.
        BUFFER-COPY Ccbcdocu TO Cabecera.
        /* ******************* */
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
            FIND Detalle WHERE Detalle.codmat = Ccbddocu.codmat NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.CodCia = Ccbcdocu.codcia
                Detalle.CodDiv = Ccbcdocu.coddiv
                Detalle.CodCli = Ccbcdocu.codcli
                Detalle.codmat = Ccbddocu.codmat
                Detalle.UndVta = Ccbddocu.undvta
                Detalle.AlmDes = Ccbddocu.almdes
                Detalle.AftIgv = Ccbddocu.aftigv
                Detalle.AftIsc = Ccbddocu.aftisc
                Detalle.CanDes = Detalle.CanDes + Ccbddocu.candes   /* OJO */
                Detalle.Factor = Ccbddocu.factor
                Detalle.ImpLin = Detalle.implin + Ccbddocu.implin   /* OJO */
                Detalle.PesMat = Detalle.PesMat + Ccbddocu.PesMat.  /* OJO */
            /* Recalculamos */
            ASSIGN
                Detalle.PreUni = Detalle.ImpLin / Detalle.CanDes
                Detalle.PreBas = Detalle.ImpLin / Detalle.CanDes.
            IF Detalle.AftIsc 
            THEN Detalle.ImpIsc = ROUND(Detalle.PreBas * Detalle.CanDes * (Almmmatg.PorIsc / 100),4).
            ELSE Detalle.ImpIsc = 0.
            IF Detalle.AftIgv 
            THEN Detalle.ImpIgv = Detalle.ImpLin - ROUND( Detalle.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
            ELSE Detalle.ImpIgv = 0.
        END.
        GET NEXT {&browse-name}.
    END.
/*     DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}: */
/*         IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN NEXT.           */
/*     END.                                                                 */
    /* 2do. GENERAMOS LOS COMPROBANTES */
    iCountGuide = 0.
    lCreaHeader = TRUE.
    lItemOk = FALSE.
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = s-CodDoc AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(COMBO-NroSer)
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Error en el control de correlativo' s-CodDoc s-CodDiv COMBO-NroSer
            VIEW-AS ALERT-BOX ERROR.
        UNDO trloop, RETURN 'ADM-ERROR'.
    END.

    FOR EACH Detalle , FIRST Almmmatg OF Detalle NO-LOCK BREAK BY Detalle.CodCia:
        /* Crea Cabecera */
        IF lCreaHeader THEN DO:
            /* Cabecera de Guía */
            RUN proc_CreaCabecera.
            ASSIGN
                iCountGuide = iCountGuide + 1
                lCreaHeader = FALSE.
        END.
        /* Crea Detalle */
        CREATE CcbDDocu.
        BUFFER-COPY Detalle 
            TO CcbDDocu
            ASSIGN
            CcbDDocu.NroItm = iCountItem
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.CodDiv = CcbcDocu.CodDiv
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
        /* CORREGIMOS IMPORTES */
        ASSIGN
            Ccbddocu.ImpLin = ROUND ( Ccbddocu.CanDes * Ccbddocu.PreUni * 
                                      ( 1 - Ccbddocu.Por_Dsctos[1] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[2] / 100 ) *
                                      ( 1 - Ccbddocu.Por_Dsctos[3] / 100 ), 2 ).
        IF Ccbddocu.Por_Dsctos[1] = 0 AND Ccbddocu.Por_Dsctos[2] = 0 AND Ccbddocu.Por_Dsctos[3] = 0 
            THEN Ccbddocu.ImpDto = 0.
        ELSE Ccbddocu.ImpDto = Ccbddocu.CanDes * Ccbddocu.PreUni - Ccbddocu.ImpLin.
        ASSIGN
            Ccbddocu.ImpLin = ROUND(Ccbddocu.ImpLin, 2)
            Ccbddocu.ImpDto = ROUND(Ccbddocu.ImpDto, 2).
        IF Ccbddocu.AftIsc 
            THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        ELSE Ccbddocu.ImpIsc = 0.
        IF Ccbddocu.AftIgv 
            THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
        ELSE Ccbddocu.ImpIgv = 0.
        lItemOk = TRUE.
        iCountItem = iCountItem + 1.
        IF iCountItem > FILL-IN-items OR LAST-OF(Detalle.CodCia) THEN DO:
            RUN proc_GrabaTotales.
            /* APLICACION DE ADELANTOS */
            RUN Aplicacion-de-Adelantos.
            /* EN CASO DE CERRAR LAS FACTURAS APLICAMOS EL REDONDEO */
/*             IF LAST-OF(Detalle.CodCia) AND Faccpedi.Importe[2] <> 0 THEN DO:                                                 */
/*                 /* NOS ASEGURAMOS QUE SEA EL ULTIMO REGISTRO */                                                              */
/*                 IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0                     */
/*                                 NO-LOCK) THEN DO:                                                                            */
/*                     ASSIGN                                                                                                   */
/*                         Ccbcdocu.ImpTot = Ccbcdocu.ImpTot + Faccpedi.Importe[2]                                              */
/*                         CcbCDocu.Libre_d02 = Faccpedi.Importe[2]                                                             */
/*                         Ccbcdocu.ImpVta = ROUND ( (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5])/ ( 1 + Ccbcdocu.PorIgv / 100 ) , 2) */
/*                         Ccbcdocu.ImpIgv = (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]) - Ccbcdocu.ImpVta                           */
/*                         Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta + Ccbcdocu.ImpDto + Ccbcdocu.ImpExo                                */
/*                         Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.                                                                   */
/*                 END.                                                                                                         */
/*             END.                                                                                                             */
            /* FIN DE REDONDEO */

            /* GENERACION DE CONTROL DE PERCEPCIONES */
            RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /* ************************************* */
            /* RHC 12.07.2012 limpiamos campos para G/R */
            ASSIGN
                Ccbcdocu.codref = ""
                Ccbcdocu.nroref = "".
            /* RHC 30-11-2006 Transferencia Gratuita */
            IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
            IF Ccbcdocu.sdoact <= 0 
            THEN ASSIGN
                    Ccbcdocu.fchcan = TODAY
                    Ccbcdocu.flgest = 'C'.
            /* OJO: NO DESCARGA ALMACENES, YA LOS HIZO EL FAI */
/*             RUN vta2\act_alm (ROWID(CcbCDocu)).                                 */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'. */
            /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
            RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). 
        END.
        /* RHC 11/11/2013 QUEBRAMOS POR ZONA */
        IF iCountItem > FILL-IN-items THEN DO:
            iCountItem = 1.
            lCreaHeader = TRUE.
            lItemOk = FALSE.
        END.
    END. /* FOR EACH FacDPedi... */
    /* GRABACIONES FINALES */
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    
END. /* DO TRANSACTION... */

RETURN 'OK'.


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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.FlgEst = YES:
          /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
          FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
              AND CcbDTerm.CodDiv = s-coddiv
              AND CcbDTerm.CodDoc = s-CodDoc
              AND CcbDTerm.NroSer = FacCorre.NroSer
              NO-LOCK NO-ERROR.
          IF AVAILABLE CcbDTerm THEN DO:
              /* Verificamos la cabecera */
              FIND FIRST CcbCTerm OF CcbDTerm NO-LOCK NO-ERROR.
              IF AVAILABLE CcbCTerm THEN NEXT.
          END.
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer:LIST-ITEMS = cListItems
          COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS)
          FILL-IN-items = FacCfgGn.Items_Guias.
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-CodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
  
      FIND gn-divi WHERE gn-divi.codcia = s-codcia
          AND gn-divi.coddiv = s-coddiv
          NO-LOCK.
      FILL-IN-Division = "DIVISIÓN: " + gn-divi.coddiv + " " + GN-DIVI.DesDiv.
      COMBO-BOX-Clientes:DELIMITER = '|'.
      FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
          AND ccbcdocu.coddoc = "FAI"
          AND ccbcdocu.coddiv = s-coddiv
          AND ccbcdocu.flgest = "P"
          BREAK BY ccbcdocu.codcli:
          IF FIRST-OF(ccbcdocu.codcli) THEN DO:
              /*COMBO-BOX-Clientes:ADD-LAST( ccbcdocu.codcli + ' ' + REPLACE(ccbcdocu.nomcli, ',', ' ') , ccbcdocu.codcli ).*/
              COMBO-BOX-Clientes:ADD-LAST( ccbcdocu.codcli + ' ' + ccbcdocu.nomcli , ccbcdocu.codcli ).
          END.
      END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaCabecera W-Win 
PROCEDURE proc_CreaCabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Se basa en el registro de "Cabecera" */

    CREATE CcbCDocu.
    BUFFER-COPY Cabecera    /* <<< OJO */
        TO Ccbcdocu
        ASSIGN
        CcbCDocu.CodCia = s-codcia
        CcbCDocu.CodDiv = s-coddiv
        CcbCDocu.CodDoc = s-CodDoc
        CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = TODAY
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoFac = "CR"                  /* CREDITO */
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm').
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /*RDP*/    
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales W-Win 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-factura-cred.i}

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

