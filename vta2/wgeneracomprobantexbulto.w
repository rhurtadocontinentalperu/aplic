&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE FACXBULTO NO-UNDO LIKE ControlOD
       FIELD t-Rowid AS ROWID.
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-2 NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.
DEFINE TEMP-TABLE T-ControlOD NO-UNDO LIKE ControlOD
       FIELD t-Rowid AS ROWID.



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

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDoc AS CHARACTER.
DEFINE SHARED VARIABLE cl-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-user-id AS CHARACTER.

IF s-CodDiv = '00506' THEN DO:
    MESSAGE 'Restringido para la división' s-coddiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

&SCOPED-DEFINE Condicion FacCPedi.CodCia = s-CodCia ~
      AND FacCPedi.CodDoc = "O/D" ~
      AND FacCPedi.DivDes = s-CodDiv  ~
      AND FacCPedi.FlgEst = "P" ~
      AND FacCPedi.FlgSit = "C" ~
      AND FacCPedi.Cmpbnte = RADIO-SET-TipDoc

/* Variables para la Facturacion */
DEFINE VARIABLE cCodDoc AS CHARACTER INIT "FAC" NO-UNDO.
DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodMov AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE cObser      AS CHARACTER NO-UNDO.
DEFINE VARIABLE rwParaRowID AS ROWID NO-UNDO.

FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
    AND FacDocum.CodDoc = cCodDoc 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
    MESSAGE
        "Codigo de Documento" cCodDoc "no configurado" SKIP
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
cCodMov = FacDocum.CodMov.

DEF VAR cOk AS LOG NO-UNDO.
cOk = NO.
FOR EACH FacCorre NO-LOCK WHERE 
    FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDiv = s-CodDiv AND 
    FacCorre.CodDoc = cCodDoc AND
    FacCorre.FlgEst = YES:
    /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
    FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
        AND CcbDTerm.CodDiv = s-coddiv
        AND CcbDTerm.CodDoc = cCodDoc
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
        "Codigo de Documento" cCodDoc "no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia 
    AND FacCorre.CodDiv = s-CodDiv 
    AND FacCorre.CodDoc = "G/R"
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE
        "Código de Documento G/R no configurado"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEFINE BUFFER B-ADocu FOR CcbADocu.

DEF VAR s-FechaI AS DATETIME NO-UNDO.
DEF VAR s-FechaT AS DATETIME NO-UNDO.

s-FechaI = DATETIME(TODAY, MTIME).

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
&Scoped-define INTERNAL-TABLES FacCPedi ControlOD

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ControlOD.OrdCmp ControlOD.Sede ~
ControlOD.CodDoc ControlOD.NroDoc ControlOD.NroEtq ControlOD.CantArt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCli = FILL-IN-CodCli ~
 AND {&Condicion}  NO-LOCK, ~
      EACH ControlOD WHERE ControlOD.CodCia = FacCPedi.CodCia ~
  AND ControlOD.CodDoc = FacCPedi.CodDoc ~
  AND ControlOD.NroDoc = FacCPedi.NroPed ~
      AND ControlOD.CodDiv = s-CodDiv ~
 AND ControlOD.OrdCmp = COMBO-BOX-OrdCmp NO-LOCK ~
    BY ControlOD.OrdCmp ~
       BY ControlOD.Sede ~
        BY ControlOD.CodDoc ~
         BY ControlOD.NroDoc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCli = FILL-IN-CodCli ~
 AND {&Condicion}  NO-LOCK, ~
      EACH ControlOD WHERE ControlOD.CodCia = FacCPedi.CodCia ~
  AND ControlOD.CodDoc = FacCPedi.CodDoc ~
  AND ControlOD.NroDoc = FacCPedi.NroPed ~
      AND ControlOD.CodDiv = s-CodDiv ~
 AND ControlOD.OrdCmp = COMBO-BOX-OrdCmp NO-LOCK ~
    BY ControlOD.OrdCmp ~
       BY ControlOD.Sede ~
        BY ControlOD.CodDoc ~
         BY ControlOD.NroDoc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi ControlOD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 ControlOD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-25 RADIO-SET-TipDoc FILL-IN-CodCli ~
COMBO-BOX-OrdCmp BROWSE-2 COMBO-NroSer COMBO-BOX-Guias COMBO-NroSer-Guia ~
FILL-IN-LugEnt FILL-IN-Glosa Btn_OK BtnDone 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-TipDoc FILL-IN-CodCli ~
FILL-IN-NomCli COMBO-BOX-OrdCmp COMBO-NroSer FILL-IN-NroDoc FILL-IN-items ~
COMBO-BOX-Guias COMBO-NroSer-Guia FILL-IN-NroDoc-GR FILL-IN-LugEnt ~
FILL-IN-Glosa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54.

DEFINE VARIABLE COMBO-BOX-Guias AS CHARACTER FORMAT "X(256)":U INITIAL "SI" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "SI","NO" 
     DROP-DOWN-LIST
     SIZE 6 BY 1
     FONT 6 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-OrdCmp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Orden de Compra" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Seleccione la orden" 
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-NroSer-Guia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Serie G/R" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Glosa AS CHARACTER FORMAT "X(60)":U 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-LugEnt AS CHARACTER FORMAT "X(60)":U 
     LABEL "Entregar en" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-GR AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TipDoc AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Facturas Normales", "FAC",
"Boletas de Venta", "BOL"
     SIZE 33 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 6.15
     BGCOLOR 15 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi, 
      ControlOD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ControlOD.OrdCmp COLUMN-LABEL "Orden de Compra" FORMAT "X(12)":U
      ControlOD.Sede FORMAT "x(30)":U WIDTH 25
      ControlOD.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U
      ControlOD.NroDoc FORMAT "X(12)":U
      ControlOD.NroEtq COLUMN-LABEL "# de Etiqueta del Bulto" FORMAT "x(25)":U
      ControlOD.CantArt COLUMN-LABEL "Items por Bulto" FORMAT ">>>,>>>,>>9":U
            WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 13.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-TipDoc AT ROW 1.19 COL 24 NO-LABEL WIDGET-ID 8
     FILL-IN-CodCli AT ROW 2.15 COL 22 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-NomCli AT ROW 2.15 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     COMBO-BOX-OrdCmp AT ROW 3.12 COL 22 COLON-ALIGNED WIDGET-ID 6
     BROWSE-2 AT ROW 4.27 COL 2 WIDGET-ID 200
     COMBO-NroSer AT ROW 18.12 COL 10.43 WIDGET-ID 40
     FILL-IN-NroDoc AT ROW 18.12 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-items AT ROW 18.12 COL 47 COLON-ALIGNED WIDGET-ID 18
     COMBO-BOX-Guias AT ROW 18.88 COL 67 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     COMBO-NroSer-Guia AT ROW 18.92 COL 16 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroDoc-GR AT ROW 18.92 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     FILL-IN-LugEnt AT ROW 19.73 COL 16 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Glosa AT ROW 20.54 COL 16 COLON-ALIGNED WIDGET-ID 42
     Btn_OK AT ROW 21.58 COL 51 WIDGET-ID 48
     BtnDone AT ROW 21.58 COL 63 WIDGET-ID 50
     "Parámetros de Facturación" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 17.54 COL 4 WIDGET-ID 54
          BGCOLOR 9 FGCOLOR 15 
     "Seleccione el Comprobante:" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 1.19 COL 5 WIDGET-ID 44
     "<<=== Generamos Guía de Remisión?:" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 19.19 COL 37 WIDGET-ID 38
          BGCOLOR 12 FGCOLOR 15 FONT 6
     RECT-25 AT ROW 17.73 COL 2 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 23.31
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: FACXBULTO T "?" NO-UNDO INTEGRAL ControlOD
      ADDITIONAL-FIELDS:
          FIELD t-Rowid AS ROWID
      END-FIELDS.
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDI-2 T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
      TABLE: T-ControlOD T "?" NO-UNDO INTEGRAL ControlOD
      ADDITIONAL-FIELDS:
          FIELD t-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE COMPROBANTES X BULTOS"
         HEIGHT             = 23.31
         WIDTH              = 85.72
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.43
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.43
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 COMBO-BOX-OrdCmp F-Main */
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-items IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroDoc-GR IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.ControlOD WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.ControlOD.OrdCmp|yes,INTEGRAL.ControlOD.Sede|yes,INTEGRAL.ControlOD.CodDoc|yes,INTEGRAL.ControlOD.NroDoc|yes"
     _Where[1]         = "FacCPedi.CodCli = FILL-IN-CodCli
 AND {&Condicion} "
     _JoinCode[2]      = "INTEGRAL.ControlOD.CodCia = INTEGRAL.FacCPedi.CodCia
  AND INTEGRAL.ControlOD.CodDoc = INTEGRAL.FacCPedi.CodDoc
  AND INTEGRAL.ControlOD.NroDoc = INTEGRAL.FacCPedi.NroPed"
     _Where[2]         = "ControlOD.CodDiv = s-CodDiv
 AND ControlOD.OrdCmp = COMBO-BOX-OrdCmp"
     _FldNameList[1]   > INTEGRAL.ControlOD.OrdCmp
"ControlOD.OrdCmp" "Orden de Compra" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ControlOD.Sede
"ControlOD.Sede" ? "x(30)" "character" ? ? ? ? ? ? no ? no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ControlOD.CodDoc
"ControlOD.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.ControlOD.NroDoc
"ControlOD.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.ControlOD.NroEtq
"ControlOD.NroEtq" "# de Etiqueta del Bulto" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ControlOD.CantArt
"ControlOD.CantArt" "Items por Bulto" ">>>,>>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE COMPROBANTES X BULTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE COMPROBANTES X BULTOS */
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
    MESSAGE
        "¿Todos los datos son correctos?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOGICAL.
    IF rpta <> TRUE THEN RETURN NO-APPLY.

    ASSIGN
        COMBO-NroSer
        COMBO-NroSer-Guia
        FILL-IN-LugEnt
        FILL-IN-Glosa
        COMBO-BOX-Guias
        FILL-IN-Items.

    /* UN SOLO PROCESO */
    RUN Generacion-de-Factura.
    IF RETURN-VALUE = 'ADM-ERROR' THEN
        MESSAGE
            "Ninguna Factura fue generada"
            VIEW-AS ALERT-BOX WARNING.
    ELSE DO:
        MESSAGE
            "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Guias
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Guias W-Win
ON VALUE-CHANGED OF COMBO-BOX-Guias IN FRAME F-Main
DO:
  ASSIGN {&self-name}.
  IF {&SELF-name} = "SI" THEN COMBO-NroSer-Guia:SENSITIVE = YES.
  ELSE COMBO-NroSer-Guia:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-OrdCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-OrdCmp W-Win
ON VALUE-CHANGED OF COMBO-BOX-OrdCmp IN FRAME F-Main /* Orden de Compra */
DO:
  ASSIGN {&SELF-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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
        FacCorre.CodDoc = cCodDoc AND
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


&Scoped-define SELF-NAME COMBO-NroSer-Guia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer-Guia W-Win
ON VALUE-CHANGED OF COMBO-NroSer-Guia IN FRAME F-Main /* Serie G/R */
DO:
    /* Correlativo */
    FIND FacCorre WHERE
        FacCorre.CodCia = s-CodCia AND
        FacCorre.CodDoc = "G/R" AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.NroSer = INTEGER(SELF:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN
        FILL-IN-NroDoc-GR =
            STRING(FacCorre.NroSer,"999") +
            STRING(FacCorre.Correlativo,"999999").
    ELSE FILL-IN-NroDoc-GR = "".
    DISPLAY FILL-IN-NroDoc-GR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  ASSIGN {&SELF-NAME}.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = FILL-IN-CodCli
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
  /* Buscamos o/d por facturar */
  COMBO-BOX-OrdCmp:DELETE(COMBO-BOX-OrdCmp:LIST-ITEMS).
  COMBO-BOX-OrdCmp:ADD-LAST('Seleccione la orden').
  COMBO-BOX-OrdCmp:SCREEN-VALUE = 'Seleccione la orden'.
  
  FOR EACH Faccpedi WHERE {&Condicion} AND Faccpedi.codcli = FILL-IN-CodCli,
      EACH PEDIDO NO-LOCK WHERE PEDIDO.codcia = s-codcia
      AND PEDIDO.coddoc = Faccpedi.codref
      AND PEDIDO.nroped = Faccpedi.nroref
      AND PEDIDO.flgest <> 'A',
      EACH COTIZACION NO-LOCK WHERE COTIZACION.codcia = s-codcia
      AND COTIZACION.coddoc = PEDIDO.codref
      AND COTIZACION.nroped = PEDIDO.nroref
      AND COTIZACION.flgest <> 'A'
      BREAK BY COTIZACION.ordcmp:
      IF FIRST-OF(COTIZACION.ordcmp) THEN COMBO-BOX-OrdCmp:ADD-LAST(COTIZACION.ordcmp).
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-TipDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-TipDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-TipDoc IN FRAME F-Main
DO:
  ASSIGN {&self-name}.

  cCodDoc = {&SELF-NAME}.
  /* Validamos el comprobante */
  FIND FacDocum WHERE FacDocum.CodCia = s-CodCia 
      AND FacDocum.CodDoc = cCodDoc 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
      MESSAGE "Codigo de Documento" cCodDoc "no configurado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  cCodMov = FacDocum.CodMov.
  /* Verificamos control de correlativos */
  DEF VAR cOk AS LOG NO-UNDO.
  cOk = NO.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDiv = s-CodDiv AND 
      FacCorre.CodDoc = cCodDoc AND
      FacCorre.FlgEst = YES:
      /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
      FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
          AND CcbDTerm.CodDiv = s-coddiv
          AND CcbDTerm.CodDoc = cCodDoc
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
      MESSAGE "Codigo de Documento" cCodDoc "no configurado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  RUN dispatch IN THIS-PROCEDURE ('initialize':U).

  DISPLAY COMBO-BOX-Guias COMBO-NroSer COMBO-NroSer-Guia FILL-IN-NroDoc FILL-IN-NroDoc-GR
      WITH FRAME {&FRAME-NAME}.

  {&OPEN-QUERY-{&BROWSE-NAME}}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicacion-de-Adelantos W-Win 
PROCEDURE Aplicacion-de-Adelantos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FacCPedi.TpoLic = NO THEN RETURN.
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
  DISPLAY RADIO-SET-TipDoc FILL-IN-CodCli FILL-IN-NomCli COMBO-BOX-OrdCmp 
          COMBO-NroSer FILL-IN-NroDoc FILL-IN-items COMBO-BOX-Guias 
          COMBO-NroSer-Guia FILL-IN-NroDoc-GR FILL-IN-LugEnt FILL-IN-Glosa 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 RADIO-SET-TipDoc FILL-IN-CodCli COMBO-BOX-OrdCmp BROWSE-2 
         COMBO-NroSer COMBO-BOX-Guias COMBO-NroSer-Guia FILL-IN-LugEnt 
         FILL-IN-Glosa Btn_OK BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobante W-Win 
PROCEDURE Genera-Comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       PEDI no pasa de 13 items
------------------------------------------------------------------------------*/

    FIND FIRST PEDI NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDI THEN RETURN.

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.

    DEF BUFFER B-CDOCU FOR Ccbcdocu.
    DEF BUFFER B-DDOCU FOR Ccbddocu.


    EMPTY TEMP-TABLE Reporte.
    /* RHC 04/02/2016 LISTA EXPRESS-> Viene los códigos repetidos */
    EMPTY TEMP-TABLE ITEM.      /* Aqui vamos a guardar el Facdpedi original */
    FOR EACH PEDI BY PEDI.codmat:
        CREATE ITEM.
        BUFFER-COPY PEDI TO ITEM.
    END.
    /* ********************************************************** */
    
    /* Cargamos informacion de Zonas y Ubicaciones */
    FOR EACH PEDI:
        ASSIGN
            PEDI.Libre_c04 = "G-0"
            PEDI.Libre_c05 = "G-0".
        FIND FIRST Almmmate WHERE Almmmate.CodCia = s-CodCia
            AND Almmmate.CodAlm = PEDI.AlmDes
            AND Almmmate.CodMat = PEDI.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN DO:
            ASSIGN 
                PEDI.Libre_c04 = Almmmate.CodUbi.
            FIND Almtubic WHERE Almtubic.codcia = s-codcia
                AND Almtubic.codubi = Almmmate.codubi
                AND Almtubic.codalm = Almmmate.codalm
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almtubic THEN PEDI.Libre_c05 = Almtubic.CodZona.
        END.
    END.

    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /* 1RA PARTE: GENERAMOS LAS FACTURAS */
        FIND FacCPedi WHERE ROWID(FacCPedi) = rwParaRowID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE FacCPedi THEN DO:
            MESSAGE
                "Registro de O/D no disponible"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        IF NOT (FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "C") THEN DO:
            MESSAGE
                "Registro de O/D ya no está 'PENDIENTE'"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.

        /* Verifica Detalle */
        lItemOk = TRUE.
        FOR EACH PEDI:
            FIND Almmmate WHERE
                Almmmate.CodCia = PEDI.CodCia AND
                Almmmate.CodAlm = PEDI.AlmDes AND
                Almmmate.codmat = PEDI.CodMat 
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                MESSAGE
                    "Artículo" PEDI.CodMat "NO está asignado al almacén" PEDI.almdes
                    VIEW-AS ALERT-BOX ERROR.
                lItemOk = FALSE.
            END.
        END.
        IF NOT lItemOk THEN RETURN 'ADM-ERROR'.

        iCountGuide = 0.
        lCreaHeader = TRUE.
        lItemOk = FALSE.

        /* Correlativo */
        FIND FacCorre WHERE
            FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = cCodDoc AND
            FacCorre.CodDiv = s-CodDiv AND
            FacCorre.NroSer = INTEGER(COMBO-NroSer)
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'Error en el control de correlativo' cCodDoc s-CodDiv COMBO-NroSer
                VIEW-AS ALERT-BOX ERROR.
            UNDO trloop, RETURN 'ADM-ERROR'.
        END.

        FOR EACH PEDI,
            FIRST Almmmatg OF PEDI NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = FacCPedi.CodCia 
                AND Almmmate.CodAlm = PEDI.AlmDes
                AND Almmmate.CodMat = PEDI.CodMat
            /*FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = PEDI.codmat*/
            BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat:

            {vta2/d-genera-factura-cred.i}

        END. /* FOR EACH FacDPedi... */

        /* 2DA PARTE: GENERACION DE GUIAS */
        IF COMBO-BOX-Guias = "SI" THEN DO:
            /* Correlativo */
            FIND FacCorre WHERE
                FacCorre.CodCia = s-CodCia AND
                FacCorre.CodDoc = "G/R" AND
                FacCorre.CodDiv = s-CodDiv AND
                FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                MESSAGE 'Error en el control de correlativo G/R' s-CodDiv COMBO-NroSer-Guia
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            FOR EACH Reporte, FIRST B-CDOCU OF Reporte:
                CREATE CcbCDocu.
                BUFFER-COPY B-CDOCU
                    TO CcbCDocu
                    ASSIGN
                    CcbCDocu.CodDiv = s-CodDiv
                    CcbCDocu.CodDoc = "G/R"
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.CodRef = B-CDOCU.CodDoc
                    CcbCDocu.NroRef = B-CDOCU.NroDoc
                    CcbCDocu.FlgEst = "F"   /* FACTURADO */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.TpoFac = "A".    /* AUTOMATICA (No descarga stock) */
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                ASSIGN
                    B-CDOCU.CodRef = Ccbcdocu.coddoc
                    B-CDOCU.NroRef = Ccbcdocu.nrodoc.
                /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
                FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
                IF AVAILABLE T-CcbADocu THEN DO:
                    FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
                        AND B-ADOCU.coddiv = Ccbcdocu.coddiv
                        AND B-ADOCU.coddoc = Ccbcdocu.coddoc
                        AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
                        NO-ERROR.
                    IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
                    BUFFER-COPY T-CcbADocu 
                        TO B-ADOCU
                        ASSIGN
                            B-ADOCU.CodCia = Ccbcdocu.CodCia
                            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
                END.
                /* *********************************************** */
                FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
                    CREATE Ccbddocu.
                    BUFFER-COPY B-DDOCU 
                        TO Ccbddocu
                        ASSIGN
                            Ccbddocu.coddiv = Ccbcdocu.coddiv
                            Ccbddocu.coddoc = Ccbcdocu.coddoc
                            Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
                END.
            END.
        END.
        /* GRABACIONES FINALES */
        /* Cierra la O/D */
        FIND FIRST Facdpedi OF Faccpedi WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN FacCPedi.FlgEst = "C".

        FIND CURRENT FacCPedi NO-LOCK.
        IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
        IF AVAILABLE(Ccbcdocu) THEN FIND CURRENT Ccbcdocu NO-LOCK.  /* Para no peder el puntero */
        IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
        IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
        IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
        IF AVAILABLE(w-repor)  THEN RELEASE w-report.
        IF AVAILABLE(Gn-clie)  THEN RELEASE Gn-clie.
    END. /* DO TRANSACTION... */

    RETURN 'OK'.

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

/* Barremos los bultos por O/D y tratamos de acumular factura por factura */
DEF VAR x-SumaItems AS INT NO-UNDO.
DEF VAR x-GeneraComprobante AS LOG NO-UNDO.

EMPTY TEMP-TABLE PEDI.
EMPTY TEMP-TABLE T-CONTROLOD.
EMPTY TEMP-TABLE Reporte.
EMPTY TEMP-TABLE FACXBULTO.

/* Cargamos O/D y Bultos */
GET FIRST {&BROWSE-NAME}.
REPEAT WHILE AVAILABLE ControlOD:
    CREATE T-ControlOD.
    BUFFER-COPY ControlOD TO T-ControlOD ASSIGN T-ControlOD.t-Rowid = ROWID(ControlOD).
    CREATE FACXBULTO.
    BUFFER-COPY ControlOD TO FACXBULTO   ASSIGN T-ControlOD.t-Rowid = ROWID(ControlOD).
    GET NEXT {&BROWSE-NAME}.
END.
/* Generamos una FAC x cada O/D y 13 items */
FOR EACH T-ControlOD, 
    FIRST ControlOD WHERE ROWID(ControlOD) = T-ControlOD.t-Rowid,
    FIRST Faccpedi WHERE FacCPedi.CodCia = T-ControlOD.codcia
    AND FacCPedi.DivDes = s-CodDiv
    AND FacCPedi.CodDoc = T-ControlOD.coddoc
    AND FacCPedi.NroPed = T-ControlOD.nrodoc
    BREAK BY T-ControlOD.OrdCmp:
    /*MESSAGE FacCPedi.CodDoc FacCPedi.NroPed ControlOD.NroEtq.*/
    IF FIRST-OF(T-ControlOD.OrdCmp) THEN DO:
        ASSIGN
            x-SumaItems = 0
            x-GeneraComprobante = NO.
        EMPTY TEMP-TABLE PEDI.
    END.
    /* Generamos facturas cada 13 items */
    /* Contamos los items a tomar en cuenta */
    FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = ControlOD.CodCia
        AND VtaDDocu.CodDiv = ControlOD.CodDiv
        AND VtaDDocu.CodPed = ControlOD.CodDoc
        AND VtaDDocu.NroPed = ControlOD.NroDoc
        AND VtaDDocu.Libre_c01 = ControlOD.NroEtq:
        FIND FIRST PEDI WHERE PEDI.codmat = VtaDDocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN x-SumaItems = x-SumaItems + 1.
    END.
    /* Si supera los items => generamos comprobante con los ya acumulados */
    IF x-SumaItems > FILL-IN-Items THEN DO:
        rwParaRowID = ROWID(Faccpedi).
        RUN Genera-Comprobante.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* Limpiamos contadores */
        ASSIGN
            x-SumaItems = 0.
        EMPTY TEMP-TABLE PEDI.
        /* Volvemos a contar los items */
        FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = ControlOD.CodCia
            AND VtaDDocu.CodDiv = ControlOD.CodDiv
            AND VtaDDocu.CodPed = ControlOD.CodDoc
            AND VtaDDocu.NroPed = ControlOD.NroDoc
            AND VtaDDocu.Libre_c01 = ControlOD.NroEtq:
            FIND FIRST PEDI WHERE PEDI.codmat = VtaDDocu.codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN x-SumaItems = x-SumaItems + 1.
        END.
    END.
    /* Acumulamos */
    FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = ControlOD.CodCia
        AND VtaDDocu.CodDiv = ControlOD.CodDiv
        AND VtaDDocu.CodPed = ControlOD.CodDoc
        AND VtaDDocu.NroPed = ControlOD.NroDoc
        AND VtaDDocu.Libre_c01 = ControlOD.NroEtq,
        FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = VtaDDocu.codmat:
        FIND FIRST PEDI WHERE PEDI.codmat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE PEDI THEN CREATE PEDI.
        BUFFER-COPY Facdpedi
            EXCEPT Facdpedi.canped Facdpedi.canate
            TO PEDI
            ASSIGN
            PEDI.libre_c01  = VtaDDocu.Libre_C01     /* Nro de Etiqueta */
            PEDI.canped     = PEDI.canped + VtaDDocu.CanPed
            PEDI.canate     = PEDI.canate + VtaDDocu.CanPed.
    END.
    IF LAST-OF(T-ControlOD.OrdCmp) THEN DO:
        /* Generamos lo que quede */
        rwParaRowID = ROWID(Faccpedi).
        RUN Genera-Comprobante.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
FOR EACH FACXBULTO:
    FIND ControlOD WHERE ROWID(ControlOD) = FACXBULTO.t-Rowid NO-ERROR.
    IF AVAILABLE ControlOD THEN
        ASSIGN
        ControlOD.UsrFac = FACXBULTO.usrfac
        ControlOD.NroFac = FACXBULTO.nrofac
        ControlOD.FchFac = FACXBULTO.fchfac.
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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  /*IF pTipoGuia = "A" THEN RUN Carga-Temporal.*/

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO DE FAC y BOL */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.FlgEst = YES:
          /* SOLO ACEPTA LOS QUE NO ESTEN ASIGNADOS A UNA CAJA COBRANZA */
          FIND CcbDTerm WHERE CcbDTerm.CodCia = s-codcia
              AND CcbDTerm.CodDiv = s-coddiv
              AND CcbDTerm.CodDoc = cCodDoc
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
          COMBO-NroSer:LABEL = 'SERIE DE ' + (IF cCodDoc = 'FAC' THEN 'FACTURA' ELSE 'BOLETA')
          FILL-IN-items = FacCfgGn.Items_Guias.
/*           FILL-IN-NroPed = FacCPedi.NroPed                            */
/*           FILL-IN-Glosa = FacCPedi.Glosa                              */
/*           FILL-IN-LugEnt = FacCPedi.LugEnt                            */
/*           FILL-IN-Cliente = FacCPedi.CodCli + " - " + FacCPedi.NomCli */
/*           FILL-IN-DirClie = FacCPedi.DirCli.                          */
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
      /* CORRELATIVO DE GUIAS DE REMISION */
      cListItems = "".
      FOR EACH FacCorre NO-LOCK WHERE 
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND 
          FacCorre.CodDoc = "G/R" AND
          FacCorre.FlgEst = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      ASSIGN
          COMBO-NroSer-Guia:LIST-ITEMS = cListItems
          COMBO-NroSer-Guia = ENTRY(1,COMBO-NroSer-Guia:LIST-ITEMS).
      /* Correlativo */
      FIND FIRST FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.CodDoc = "G/R" AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc-GR =
              STRING(FacCorre.NroSer,"999") +
              STRING(FacCorre.Correlativo,"999999").
      /* RHC Cargamos TRANSPORTISTA por defecto */
/*       EMPTY TEMP-TABLE T-CcbADocu.                          */
/*       FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia */
/*               AND Ccbadocu.coddiv = Faccpedi.coddiv         */
/*               AND Ccbadocu.coddoc = Faccpedi.coddoc         */
/*               AND Ccbadocu.nrodoc = Faccpedi.nroped         */
/*               NO-LOCK NO-ERROR.                             */
/*       IF AVAILABLE CcbADocu THEN DO:                        */
/*           CREATE T-CcbADocu.                                */
/*           BUFFER-COPY CcbADocu TO T-CcbADocu                */
/*               ASSIGN                                        */
/*               T-CcbADocu.CodDiv = CcbADocu.CodDiv           */
/*               T-CcbADocu.CodDoc = CcbADocu.CodDoc           */
/*               T-CcbADocu.NroDoc = CcbADocu.NroDoc.          */
/*       END.                                                  */
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /* RHC 14.08.2014 Caso de FAI */
      IF cCodDoc = "FAI" THEN DO:
          COMBO-NroSer:LABEL = "Serie FAI".
          COMBO-BOX-Guias:SCREEN-VALUE = "SI".
          COMBO-BOX-Guias:SENSITIVE = NO.
          APPLY 'VALUE->CHANGED' TO COMBO-BOX-Guias.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************* */
    /* RHC 24/11/2015 Control de LISTA DE TERCEROS */
    /* ******************************************* */
    FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = Faccpedi.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN DO:
        FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddiv = PEDIDO.coddiv
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE COTIZACION AND COTIZACION.TipBon[10] > 0 THEN DO:
            FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
                AND Gn-clie.codcli = Faccpedi.codcli
                EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR AND LOCKED(Gn-clie) THEN DO:
                MESSAGE 'NO se pudo actualizar el control de LISTA DE TERCEROS en el cliente'
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            ASSIGN
                Gn-clie.Libre_d01 = MAXIMUM(Gn-clie.Libre_d01, COTIZACION.TipBon[10]).
        END.
    END.
    /* ******************************************* */
    CREATE CcbCDocu.
    BUFFER-COPY FacCPedi 
        TO CcbCDocu
        ASSIGN
        CcbCDocu.CodDiv = s-CodDiv
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        CcbCDocu.CodDoc = cCodDoc
        CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = cCodMov
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        Ccbcdocu.CodPed = FacCPedi.CodRef
        Ccbcdocu.NroPed = FacCPedi.NroRef
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoFac = "CR"                  /* CREDITO */
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        CcbCDocu.LugEnt = FILL-IN-LugEnt
        CcbCDocu.LugEnt2 = FacCPedi.LugEnt2
        CcbCDocu.Glosa = FILL-IN-Glosa
        CcbCDocu.FlgCbd = FacCPedi.FlgIgv.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /*RDP*/    
    FIND FIRST Reporte WHERE Reporte.codcia = Ccbcdocu.codcia
        AND Reporte.coddiv = Ccbcdocu.coddiv
        AND Reporte.coddoc = Ccbcdocu.coddoc
        AND Reporte.nrodoc = Ccbcdocu.nrodoc
        NO-ERROR.
    IF NOT AVAILABLE Reporte THEN CREATE Reporte.
    ASSIGN 
        Reporte.CodCia = CcbCDocu.CodCia
        Reporte.CodDiv = CcbCDocu.CodDiv
        Reporte.CodDoc = CcbCDocu.CodDoc
        Reporte.NroDoc = CcbCDocu.NroDoc.
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = CcbCDocu.CodCli 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN
            CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
    END.
    /* Guarda Centro de Costo */
    FIND gn-ven WHERE
        gn-ven.codcia = s-codcia AND
        gn-ven.codven = ccbcdocu.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN ccbcdocu.cco = gn-ven.cco.
    /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST T-CcbADocu NO-LOCK NO-ERROR.
    IF AVAILABLE T-CcbADocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
            AND B-ADOCU.coddiv = Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY T-CcbADocu 
            TO B-ADOCU
            ASSIGN
                B-ADOCU.CodCia = Ccbcdocu.CodCia
                B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* TRACKING GUIAS */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Ccbcdocu.CodPed,
                            Ccbcdocu.NroPed,
                            s-User-Id,
                            'EFAC',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Ccbcdocu.coddoc,
                            Ccbcdocu.nrodoc,
                            CcbCDocu.Libre_c01,
                            CcbCDocu.Libre_c02).
    /* RHC FAC x BULTO */
    FIND FACXBULTO WHERE FACXBULTO.coddoc = PEDI.coddoc
        AND FACXBULTO.nrodoc = PEDI.nroped
        AND FACXBULTO.nroetq = PEDI.libre_c01
        NO-ERROR.
    IF AVAILABLE FACXBULTO THEN 
        ASSIGN
            FACXBULTO.NroFac = Ccbcdocu.nrodoc
            FACXBULTO.FchFac = Ccbcdocu.fchdoc.

    s-FechaT = DATETIME(TODAY, MTIME).
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "ControlOD"}

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

