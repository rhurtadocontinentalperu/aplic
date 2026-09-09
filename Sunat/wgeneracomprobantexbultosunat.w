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
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.
DEFINE TEMP-TABLE T-ControlOD NO-UNDO LIKE ControlOD
       FIELD t-Rowid AS ROWID.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */

DEFINE SHARED VARIABLE s-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-CodDiv AS CHARACTER.
DEFINE SHARED VARIABLE s-CodDoc AS CHARACTER.
DEFINE SHARED VARIABLE cl-CodCia AS INTEGER.
DEFINE SHARED VARIABLE s-user-id AS CHARACTER.

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

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-FormatoFAC  AS CHAR INIT '999-999999' NO-UNDO.
DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.

RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).

DEF VAR pMensaje AS CHAR NO-UNDO.

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
BUTTON-4 Btn_OK BtnDone 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-TipDoc FILL-IN-CodCli ~
FILL-IN-NomCli COMBO-BOX-OrdCmp COMBO-NroSer FILL-IN-NroDoc FILL-IN-items ~
COMBO-BOX-Guias COMBO-NroSer-Guia FILL-IN-NroDoc-GR 

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

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/api-vy.ico":U
     LABEL "Button 4" 
     SIZE 12 BY 1.54 TOOLTIP "Ingresar datos del transportista".

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

DEFINE VARIABLE FILL-IN-items AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Items por Guía" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc-GR AS CHARACTER FORMAT "XXX-XXXXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TipDoc AS CHARACTER INITIAL "FAC" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Facturas Normales", "FAC",
"Boletas de Venta", "BOL"
     SIZE 33 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 4.04
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
     FILL-IN-items AT ROW 18.12 COL 50 COLON-ALIGNED WIDGET-ID 18
     COMBO-BOX-Guias AT ROW 18.88 COL 70 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     COMBO-NroSer-Guia AT ROW 18.92 COL 16 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroDoc-GR AT ROW 18.92 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     BUTTON-4 AT ROW 19.85 COL 48 WIDGET-ID 56
     Btn_OK AT ROW 19.85 COL 60 WIDGET-ID 48
     BtnDone AT ROW 19.85 COL 72 WIDGET-ID 50
     "Parámetros de Facturación" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 17.54 COL 4 WIDGET-ID 54
          BGCOLOR 9 FGCOLOR 15 
     "Seleccione el Comprobante:" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 1.19 COL 5 WIDGET-ID 44
     "<<=== Generamos Guía de Remisión?:" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 19.19 COL 40 WIDGET-ID 38
          BGCOLOR 12 FGCOLOR 15 FONT 6
     RECT-25 AT ROW 17.73 COL 2 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.72 BY 21.15
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
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
      TABLE: T-ControlOD T "?" NO-UNDO INTEGRAL ControlOD
      ADDITIONAL-FIELDS:
          FIELD t-Rowid AS ROWID
      END-FIELDS.
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE COMPROBANTES X BULTOS"
         HEIGHT             = 21.15
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

    FIND FIRST T-Ccbadocu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Ccbadocu THEN DO:
        MESSAGE 'NO ha ingresado los datos del transportista' SKIP
            'Continuamos con la generación de comprobantes?'
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE rpta-2 AS LOG.
        IF rpta-2 = NO THEN RETURN NO-APPLY.
    END.

    ASSIGN
        COMBO-NroSer
        COMBO-NroSer-Guia
        /*FILL-IN-LugEnt*/
        /*FILL-IN-Glosa*/
        COMBO-BOX-Guias
        FILL-IN-Items.

    /* UN SOLO PROCESO */
    pMensaje = "".
    RUN Generacion-de-Factura.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = pMensaje + CHR(10) + "Ninguna Factura fue generada".
        MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE DO:
        MESSAGE
            "Se ha(n) generado" iCountGuide "Factura(s)"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
  RUN dist/d-transportista (INPUT-OUTPUT TABLE T-CcbADocu).
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
  EMPTY TEMP-TABLE T-Ccbadocu.
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
        FILL-IN-NroDoc = STRING(FacCorre.NroSer, ENTRY(1,x-FormatoFAC,'-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoFAC,'-')).
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
        FILL-IN-NroDoc-GR = STRING(FacCorre.NroSer, ENTRY(1,x-FormatoGUIA,'-')) +
                          STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoGUIA,'-')).
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
  EMPTY TEMP-TABLE T-Ccbadocu.
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
  APPLY 'LEAVE':U TO  FILL-IN-CodCli.

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
          COMBO-NroSer-Guia FILL-IN-NroDoc-GR 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 RADIO-SET-TipDoc FILL-IN-CodCli COMBO-BOX-OrdCmp BROWSE-2 
         COMBO-NroSer COMBO-BOX-Guias COMBO-NroSer-Guia BUTTON-4 Btn_OK BtnDone 
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
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = s-CodCia 
                AND Almmmate.CodAlm = PEDI.AlmDes
                AND Almmmate.CodMat = PEDI.CodMat
            BREAK BY PEDI.CodCia BY PEDI.Libre_c05 BY PEDI.Libre_c04 BY PEDI.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                RUN proc_CreaCabecera.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                ASSIGN
                    iCountGuide = iCountGuide + 1
                    lCreaHeader = FALSE.
            END.
            /* Crea Detalle */
            CREATE CcbDDocu.
            BUFFER-COPY PEDI TO CcbDDocu
            ASSIGN
                CcbDDocu.NroItm = iCountItem
                CcbDDocu.CodCia = CcbCDocu.CodCia
                CcbDDocu.CodDiv = CcbcDocu.CodDiv
                CcbDDocu.Coddoc = CcbCDocu.Coddoc
                CcbDDocu.NroDoc = CcbCDocu.NroDoc 
                CcbDDocu.FchDoc = CcbCDocu.FchDoc
                CcbDDocu.CanDes = PEDI.CanAte
                Ccbddocu.impdcto_adelanto[4] = PEDI.Libre_d02.  /* Flete Unitario */
            ASSIGN
                CcbDDocu.Pesmat = Almmmatg.Pesmat * (CcbDDocu.Candes * CcbDDocu.Factor).
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
                THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (FacCPedi.PorIgv / 100) ), 4 ).
            ELSE Ccbddocu.ImpIgv = 0.
            lItemOk = TRUE.
            iCountItem = iCountItem + 1.
            IF iCountItem > FILL-IN-items OR LAST-OF(PEDI.CodCia) /*OR LAST-OF(PEDI.Libre_c05)*/ THEN DO:
                RUN proc_GrabaTotales.
                &IF {&ARITMETICA-SUNAT} &THEN
                    /* ****************************************************************************************** */
                    /* Importes SUNAT */
                    /* ****************************************************************************************** */
                    DEF VAR hProc AS HANDLE NO-UNDO.
                    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
                    RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                                 INPUT Ccbcdocu.CodDoc,
                                                 INPUT Ccbcdocu.NroDoc,
                                                 OUTPUT pMensaje).
                    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO trloop, RETURN 'ADM-ERROR'.
                    DELETE PROCEDURE hProc.
                    /* ****************************************************************************************** */
                &ENDIF
                /* ****************************************************************************************** */
                /* GENERACION DE CONTROL DE PERCEPCIONES */
                RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* ************************************* */
                /* RHC 12.07.2012 limpiamos campos para G/R */
                ASSIGN
                    Ccbcdocu.codref = ""
                    Ccbcdocu.nroref = "".
                /* RHC 30-11-2006 Transferencia Gratuita */
                IF LOOKUP(Ccbcdocu.FmaPgo, '899,900') > 0 THEN Ccbcdocu.sdoact = 0.
                IF Ccbcdocu.sdoact <= 0 
                THEN ASSIGN
                        Ccbcdocu.fchcan = TODAY
                        Ccbcdocu.flgest = 'C'.
                /* Descarga de Almacen */
                RUN vta2\act_alm (ROWID(CcbCDocu)).
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
                /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
                /*RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). */
            END.
            /* RHC 11/11/2013 QUEBRAMOS POR ZONA */
            IF iCountItem > FILL-IN-items /*OR LAST-OF(PEDI.Libre_c05)*/ THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
                lItemOk = FALSE.
            END.
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
                    /*CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") */
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer, ENTRY(1,x-FormatoGUIA,'-')) +
                                        STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoGUIA,'-'))
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
    IF FIRST-OF(T-ControlOD.OrdCmp) THEN DO:
        ASSIGN
            x-SumaItems = 0.
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
        EMPTY TEMP-TABLE Reporte.
        RUN Genera-Comprobante.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* *************************** SUNAT *********************** */
        RUN SECOND-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        IF RETURN-VALUE = 'ERROR-POS' THEN DO:
             RUN THIRD-TRANSACTION.
             RETURN 'ADM-ERROR'.
        END.
        /* ********************************************************* */
        /* Limpiamos contadores */
        ASSIGN x-SumaItems = 0.
        EMPTY TEMP-TABLE PEDI.
        /* Volvemos a contar los items */
        FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = ControlOD.CodCia
            AND VtaDDocu.CodDiv = ControlOD.CodDiv
            AND VtaDDocu.CodPed = ControlOD.CodDoc
            AND VtaDDocu.NroPed = ControlOD.NroDoc
            AND VtaDDocu.Libre_c01 = ControlOD.NroEtq
            AND (VtaDDocu.CanPed - VtaDDocu.CanAte) > 0:
            FIND FIRST PEDI WHERE PEDI.codmat = VtaDDocu.codmat NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN x-SumaItems = x-SumaItems + 1.
        END.
    END.
    /* Acumulamos por producto, no interesa la orden ni la etiqueta */
    FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = ControlOD.CodCia
        AND VtaDDocu.CodDiv = ControlOD.CodDiv
        AND VtaDDocu.CodPed = ControlOD.CodDoc
        AND VtaDDocu.NroPed = ControlOD.NroDoc
        AND VtaDDocu.Libre_c01 = ControlOD.NroEtq
        AND (VtaDDocu.CanPed - VtaDDocu.CanAte) > 0,  /* OJO: Solos Saldos x Atender */
        FIRST Facdpedi NO-LOCK WHERE Facdpedi.codcia = s-codcia
        AND Facdpedi.coddoc = ControlOD.CodDoc
        AND Facdpedi.nroped = ControlOD.NroDoc
        AND Facdpedi.codmat = VtaDDocu.codmat:
        FIND FIRST PEDI WHERE PEDI.codmat = VtaDDocu.codmat NO-ERROR.
        IF NOT AVAILABLE PEDI THEN CREATE PEDI.
        BUFFER-COPY Facdpedi
            EXCEPT Facdpedi.canped Facdpedi.canate
            TO PEDI
            ASSIGN
            PEDI.canped     = PEDI.canped + (VtaDDocu.CanPed - VtaDDocu.CanAte)
            PEDI.canate     = PEDI.canate + (VtaDDocu.CanPed - VtaDDocu.CanAte).
    END.
    /* Control de Etiquetas (No tienen # de factura aún) */
    CREATE FACXBULTO.
    BUFFER-COPY ControlOD EXCEPT ControlOD.NroFac 
        TO FACXBULTO ASSIGN FACXBULTO.t-Rowid = ROWID(ControlOD).

    IF LAST-OF(T-ControlOD.OrdCmp) THEN DO:
        /* Generamos lo que quede */
        rwParaRowID = ROWID(Faccpedi).
        RUN Genera-Comprobante.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* *************************** SUNAT *********************** */
        RUN SECOND-TRANSACTION.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        IF RETURN-VALUE = 'ERROR-POS' THEN DO:
             RUN THIRD-TRANSACTION.
             RETURN 'ADM-ERROR'.
        END.
        /* ********************************************************* */
    END.
END.
/* Cierre final de todo el proceso */
FOR EACH FACXBULTO, 
    FIRST ControlOD WHERE ROWID(ControlOD) = FACXBULTO.t-Rowid:
    ASSIGN
        ControlOD.NroFac  = FACXBULTO.NroFac 
        ControlOD.UsrFac = FACXBULTO.UsrFac 
        ControlOD.FchFac = FACXBULTO.FchFac.
END.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
IF AVAILABLE ControlOD THEN RELEASE ControlOD.

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
      /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
      RUN sunat\p-formato-doc (INPUT cCodDoc, OUTPUT x-FormatoFAC).
      FIND FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = cCodDoc AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc = STRING(FacCorre.NroSer, ENTRY(1,x-FormatoFAC,'-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoFAC,'-')).
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
      /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
      RUN sunat\p-formato-doc (INPUT "G/R", OUTPUT x-FormatoGUIA).
      FIND FIRST FacCorre WHERE
          FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDiv = s-CodDiv AND
          FacCorre.CodDoc = "G/R" AND
          FacCorre.NroSer = INTEGER(COMBO-NroSer-Guia)
          NO-LOCK NO-ERROR.
      IF AVAILABLE FacCorre THEN
          FILL-IN-NroDoc-GR = STRING(FacCorre.NroSer, ENTRY(1,x-FormatoGUIA,'-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoGUIA,'-')).

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
          APPLY 'VALUE-CHANGED' TO COMBO-BOX-Guias.
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
    CREATE CcbCDocu.
    BUFFER-COPY FacCPedi 
        TO CcbCDocu
        ASSIGN
        CcbCDocu.CodDiv = s-CodDiv
        CcbCDocu.DivOri = FacCPedi.CodDiv    /* OJO: division de estadisticas */
        CcbCDocu.CodAlm = FacCPedi.CodAlm   /* OJO: Almacén despacho */
        CcbCDocu.CodDoc = cCodDoc
        /*CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")*/
        CcbCDocu.NroDoc =  STRING(FacCorre.NroSer, ENTRY(1,x-FormatoFAC,'-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2,x-FormatoFAC,'-'))
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.CodMov = cCodMov
        CcbCDocu.CodRef = FacCPedi.CodDoc           /* CONTROL POR DEFECTO */
        CcbCDocu.NroRef = FacCPedi.NroPed
        CcbCDocu.Libre_c01 = FacCPedi.CodDoc        /* CONTROL ADICIONAL */
        CcbCDocu.Libre_c02 = FacCPedi.NroPed
        CcbCDocu.Libre_c03 = "ControlOD"            /* TABLA DE CONTROL */
        Ccbcdocu.CodPed = FacCPedi.CodRef
        Ccbcdocu.NroPed = FacCPedi.NroRef
        CcbCDocu.FchVto = TODAY
        CcbCDocu.CodAnt = FacCPedi.Atencion     /* DNI */
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.NroOrd = FacCPedi.ordcmp
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoFac = "CR"                  /* CREDITO */
        CcbCDocu.Tipo   = "CREDITO" 
        CcbCDocu.CndCre = "PLAZA VEA"           /* OJO: Control para anulación */
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME,'hh:mm')
        /*CcbCDocu.LugEnt = FILL-IN-LugEnt*/
        CcbCDocu.LugEnt2 = FacCPedi.LugEnt2
        /*CcbCDocu.Glosa = FILL-IN-Glosa*/
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
    /* Factura x Etiqueta */
    FOR EACH FACXBULTO WHERE FACXBULTO.NroFac = '':
        ASSIGN
            FACXBULTO.NroFac = Ccbcdocu.nrodoc
            FACXBULTO.FchFac = Ccbcdocu.fchdoc
            FACXBULTO.UsrFac = Ccbcdocu.usuario.
    END.
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

/*{vta2/graba-totales-factura-cred.i}*/
{vtagn/i-total-factura-sunat.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

/* RHC 12/12/2015 Actualizamos saldos */
DEF VAR x-CanDes AS DEC NO-UNDO.
DEF VAR x-CanAte AS DEC NO-UNDO.
FOR EACH FACXBULTO WHERE FACXBULTO.NroFac = Ccbcdocu.nrodoc:
    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
        x-CanDes = Ccbddocu.candes.
        /* Buscamos en los controles */
        FOR EACH Vtaddocu WHERE VtaDDocu.CodCia = FACXBULTO.codcia
            AND VtaDDocu.CodDiv = FACXBULTO.coddiv
            AND VtaDDocu.CodPed = FACXBULTO.coddoc
            AND VtaDDocu.NroPed = FACXBULTO.nrodoc
            AND VtaDDocu.Libre_c01 = FACXBULTO.nroetq
            AND VtaDDocu.CodMat = Ccbddocu.codmat,
            FIRST Facdpedi WHERE Facdpedi.codcia = s-codcia
            AND Facdpedi.coddoc = Vtaddocu.codped
            AND Facdpedi.nroped = Vtaddocu.nroped
            AND Facdpedi.codmat = Vtaddocu.codmat,
            FIRST ORDEN WHERE ORDEN.codcia = Facdpedi.codcia
            AND ORDEN.coddiv = Facdpedi.coddiv
            AND ORDEN.coddoc = Facdpedi.coddoc
            AND ORDEN.nroped = Facdpedi.nroped:
            x-CanAte = MINIMUM((VtaDDocu.CanPed - VtaDDocu.CanAte), x-CanDes).
            VtaDDocu.CanAte = VtaDDocu.CanAte + x-CanAte.
            Facdpedi.CanAte = Facdpedi.CanAte + x-CanAte.
            x-CanDes = x-CanDes - x-CanAte.
            IF NOT CAN-FIND(FIRST Facdpedi OF ORDEN WHERE (FacDPedi.CanPed - FacDPedi.CanAte) > 0
                        NO-LOCK) THEN ORDEN.FlgEst = "C".
            IF x-CanDes <= 0 THEN LEAVE.
        END.
    END.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION W-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iNumOrden AS INT INIT 0 NO-UNDO.   /* COntrola la cantidad de comprobantes procesados */
pMensaje = "".
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
    iNumOrden = iNumOrden + 1.
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*     RUN sunat\progress-to-ppll-v2 ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ). */
    RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
    IF iNumOrden = 1 AND RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /* Falló al primer intento */
        IF pMensaje = "" THEN pMensaje = "ERROR conexión de ePos".
        RETURN 'ADM-ERROR'.     /* ROLL-BACK TODO */
    END.
    IF RETURN-VALUE = "ADM-ERROR" OR RETURN-VALUE = "ERROR-EPOS" THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR grabación de ePos".
        RETURN 'ERROR-EPOS'.    /* ANULAMOS TODO */
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE THIRD-TRANSACTION W-Win 
PROCEDURE THIRD-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-CDOCU FOR Ccbcdocu.                   
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte:
    ASSIGN 
        Ccbcdocu.FlgEst = "A"
        Ccbcdocu.SdoAct = 0
        Ccbcdocu.UsuAnu = S-USER-ID
        Ccbcdocu.FchAnu = TODAY
        Ccbcdocu.Glosa  = "A N U L A D O".
      /* DESCARGA ALMACENES */
      RUN vta2/des_alm (ROWID(CcbCDocu)).
      /* ANULAMOS LA GUIA DE REMISION */
      IF Ccbcdocu.CodRef = "G/R" THEN DO:
          FOR EACH B-CDOCU WHERE B-CDOCU.CodCia = Ccbcdocu.CodCia 
              AND B-CDOCU.CodDoc = Ccbcdocu.CodRef
              AND B-CDOCU.NroDoc = Ccbcdocu.NroRef
              AND B-CDOCU.FlgEst = "F":
              ASSIGN 
                  B-CDOCU.FlgEst = "A"
                  B-CDOCU.SdoAct = 0
                  B-CDOCU.UsuAnu = S-USER-ID
                  B-CDOCU.FchAnu = TODAY
                  B-CDOCU.Glosa  = "A N U L A D O".
          END.
      END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

