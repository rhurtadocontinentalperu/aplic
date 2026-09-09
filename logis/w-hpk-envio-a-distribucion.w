&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-ChkTareas FOR ChkTareas.
DEFINE BUFFER b-VtaCDocu FOR VtaCDocu.



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
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-cantidad-sku-col AS INT.
DEFINE VAR x-cantidad-bultos-col AS INT.
DEFINE VAR x-tiempo-observado-col AS CHAR.
DEFINE VAR x-nom-chequeador-col AS CHAR.
DEFINE VAR x-cliente-col AS CHAR.
DEFINE VAR x-es-crossdocking-col AS CHAR.

DEFINE VAR x-nro-phr AS CHAR.

DEFINE VAR x-codped AS CHAR.
DEFINE VAR x-nroped AS CHAR.

DEFINE TEMP-TABLE ttOrdenes
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
.
DEFINE TEMP-TABLE ttOrdenesHPR
    FIELDS  tcoddoc     AS  CHAR    FORMAT  'x(5)'
    FIELDS  tnrodoc     AS  CHAR    FORMAT  'x(15)'
.

DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER x-vtacdocu FOR vtacdocu.

DEFINE VAR x-col-estado AS CHAR.

DEF VAR pMensaje AS CHAR NO-UNDO.                                       
DEF VAR pZona LIKE logiszonadist.Zona NO-UNDO.

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ChkTareas VtaCDocu FacCPedi

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 ChkTareas.CodDoc ChkTareas.NroPed ~
VtaCDocu.CodRef VtaCDocu.NroRef ~
estado-de-orden(vtacdocu.codref, vtacdocu.nroref) @ x-col-estado ~
jalar-nro-phr(ChkTareas.CodDoc, ChkTareas.NroPed ) @ x-nro-phr ~
cliente(chktareas.coddoc, chktareas.nroped) @ x-cliente-col ~
cantidad-sku(chktareas.coddoc, chktareas.nroped) @ x-cantidad-sku-col ~
cantidad-bultos(chktareas.coddoc, chktareas.nroped) @ x-cantidad-bultos-col ~
es-crossdocking(chktareas.coddoc, chktareas.nroped) @ x-es-crossdocking-col ~
ChkTareas.Embalaje ChkTareas.Mesa ~
chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col ~
tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
ChkTareas.FlgEst = 'T' ~
 AND ChkTareas.CodDiv = s-coddiv ~
 AND ChkTareas.CodDoc = "HPK" NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia and ~
 VtaCDocu.CodPed =  ChkTareas.CodDoc and ~
  VtaCDocu.NroPed =  ChkTareas.NroPed ~
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv ~
      AND (fill-in-phr = "" or vtacdocu.nroori = fill-in-phr) NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = VtaCDocu.CodCia ~
  AND FacCPedi.CodDoc = VtaCDocu.CodRef ~
  AND FacCPedi.NroPed = VtaCDocu.NroRef ~
      AND FacCPedi.FlgEst <> "C" NO-LOCK ~
    BY VtaCDocu.CodRef ~
       BY VtaCDocu.NroRef
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH ChkTareas ~
      WHERE ChkTareas.codcia = s-codcia and ~
ChkTareas.FlgEst = 'T' ~
 AND ChkTareas.CodDiv = s-coddiv ~
 AND ChkTareas.CodDoc = "HPK" NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia =  ChkTareas.CodCia and ~
 VtaCDocu.CodPed =  ChkTareas.CodDoc and ~
  VtaCDocu.NroPed =  ChkTareas.NroPed ~
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv ~
      AND (fill-in-phr = "" or vtacdocu.nroori = fill-in-phr) NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = VtaCDocu.CodCia ~
  AND FacCPedi.CodDoc = VtaCDocu.CodRef ~
  AND FacCPedi.NroPed = VtaCDocu.NroRef ~
      AND FacCPedi.FlgEst <> "C" NO-LOCK ~
    BY VtaCDocu.CodRef ~
       BY VtaCDocu.NroRef.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 ChkTareas VtaCDocu FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 ChkTareas
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-14 VtaCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-14 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-14}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-14 BUTTON-Envio FILL-IN-phr 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-phr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD estado-de-orden W-Win 
FUNCTION estado-de-orden RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD jalar-nro-phr W-Win 
FUNCTION jalar-nro-phr RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD situacion W-Win 
FUNCTION situacion RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR, INPUT pFlgSit AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Envio 
     LABEL "ENVIAR A DESPACHO" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(256)":U 
     LABEL "PHR" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      ChkTareas, 
      VtaCDocu, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 W-Win _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      ChkTareas.CodDoc COLUMN-LABEL "Cod." FORMAT "x(3)":U WIDTH 3.43
            COLUMN-FONT 0
      ChkTareas.NroPed COLUMN-LABEL "Nro.Documento" FORMAT "X(12)":U
            WIDTH 12.43 COLUMN-FONT 0
      VtaCDocu.CodRef COLUMN-LABEL "CodOrden" FORMAT "x(3)":U WIDTH 7.43
      VtaCDocu.NroRef COLUMN-LABEL "NroOrden" FORMAT "X(15)":U
            WIDTH 12
      estado-de-orden(vtacdocu.codref, vtacdocu.nroref) @ x-col-estado COLUMN-LABEL "Estado Orden" FORMAT "x(15)":U
            WIDTH 13.43
      jalar-nro-phr(ChkTareas.CodDoc, ChkTareas.NroPed ) @ x-nro-phr COLUMN-LABEL "Nro PHR" FORMAT "x(15)":U
            WIDTH 10.86 COLUMN-BGCOLOR 11
      cliente(chktareas.coddoc, chktareas.nroped) @ x-cliente-col COLUMN-LABEL "Nombre Cliente" FORMAT "x(50)":U
            WIDTH 39.43 COLUMN-FONT 0
      cantidad-sku(chktareas.coddoc, chktareas.nroped) @ x-cantidad-sku-col COLUMN-LABEL "Cant. SKU" FORMAT ">>,>>9":U
            WIDTH 8.43 COLUMN-FONT 0
      cantidad-bultos(chktareas.coddoc, chktareas.nroped) @ x-cantidad-bultos-col COLUMN-LABEL "No. Bultos"
      es-crossdocking(chktareas.coddoc, chktareas.nroped) @ x-es-crossdocking-col COLUMN-LABEL "CrossDocking" FORMAT "x(5)":U
            COLUMN-FONT 0
      ChkTareas.Embalaje COLUMN-LABEL "Embalado" FORMAT "SI/NO":U
            WIDTH 9.57 COLUMN-FONT 0
      ChkTareas.Mesa FORMAT "x(8)":U WIDTH 9.29 COLUMN-FONT 0
      chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col COLUMN-LABEL "Chequeador" FORMAT "x(40)":U
            WIDTH 20 COLUMN-FONT 0
      tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col COLUMN-LABEL "Hora Terminado" FORMAT "x(25)":U
            WIDTH 2.14 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 146 BY 21.15
         FONT 4
         TITLE "Bandeja de ordenes terminadas" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-14 AT ROW 2.19 COL 2 WIDGET-ID 200
     BUTTON-Envio AT ROW 1 COL 91 WIDGET-ID 10
     FILL-IN-phr AT ROW 1.08 COL 7 COLON-ALIGNED WIDGET-ID 8
     "Envio a Distribucion - Considera documentos HPK" VIEW-AS TEXT
          SIZE 62 BY .96 AT ROW 1.04 COL 26.72 WIDGET-ID 6
          BGCOLOR 15 FGCOLOR 4 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.57 BY 22.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-ChkTareas B "?" ? INTEGRAL ChkTareas
      TABLE: b-VtaCDocu B "?" ? INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Gestion de Ordenes terminadas"
         HEIGHT             = 22.46
         WIDTH              = 147.43
         MAX-HEIGHT         = 24.12
         MAX-WIDTH          = 173.86
         VIRTUAL-HEIGHT     = 24.12
         VIRTUAL-WIDTH      = 173.86
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
/* BROWSE-TAB BROWSE-14 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "INTEGRAL.ChkTareas,INTEGRAL.VtaCDocu WHERE INTEGRAL.ChkTareas ...,INTEGRAL.FacCPedi WHERE INTEGRAL.VtaCDocu ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST, FIRST"
     _OrdList          = "INTEGRAL.VtaCDocu.CodRef|yes,INTEGRAL.VtaCDocu.NroRef|yes"
     _Where[1]         = "ChkTareas.codcia = s-codcia and
ChkTareas.FlgEst = 'T'
 AND ChkTareas.CodDiv = s-coddiv
 AND ChkTareas.CodDoc = ""HPK"""
     _JoinCode[2]      = "VtaCDocu.CodCia =  ChkTareas.CodCia and
 VtaCDocu.CodPed =  ChkTareas.CodDoc and
  VtaCDocu.NroPed =  ChkTareas.NroPed
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv"
     _Where[2]         = "(fill-in-phr = """" or vtacdocu.nroori = fill-in-phr)"
     _JoinCode[3]      = "INTEGRAL.FacCPedi.CodCia = VtaCDocu.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = VtaCDocu.CodRef
  AND INTEGRAL.FacCPedi.NroPed = VtaCDocu.NroRef"
     _Where[3]         = "FacCPedi.FlgEst <> ""C"""
     _FldNameList[1]   > INTEGRAL.ChkTareas.CodDoc
"ChkTareas.CodDoc" "Cod." ? "character" ? ? 0 ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ChkTareas.NroPed
"ChkTareas.NroPed" "Nro.Documento" ? "character" ? ? 0 ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCDocu.CodRef
"VtaCDocu.CodRef" "CodOrden" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.NroRef
"VtaCDocu.NroRef" "NroOrden" ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"estado-de-orden(vtacdocu.codref, vtacdocu.nroref) @ x-col-estado" "Estado Orden" "x(15)" ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"jalar-nro-phr(ChkTareas.CodDoc, ChkTareas.NroPed ) @ x-nro-phr" "Nro PHR" "x(15)" ? 11 ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"cliente(chktareas.coddoc, chktareas.nroped) @ x-cliente-col" "Nombre Cliente" "x(50)" ? ? ? 0 ? ? ? no ? no no "39.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"cantidad-sku(chktareas.coddoc, chktareas.nroped) @ x-cantidad-sku-col" "Cant. SKU" ">>,>>9" ? ? ? 0 ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"cantidad-bultos(chktareas.coddoc, chktareas.nroped) @ x-cantidad-bultos-col" "No. Bultos" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"es-crossdocking(chktareas.coddoc, chktareas.nroped) @ x-es-crossdocking-col" "CrossDocking" "x(5)" ? ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.ChkTareas.Embalaje
"ChkTareas.Embalaje" "Embalado" ? "logical" ? ? 0 ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.ChkTareas.Mesa
"ChkTareas.Mesa" ? ? "character" ? ? 0 ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"chequeador(chktareas.coddoc, chktareas.nroped) @ x-nom-chequeador-col" "Chequeador" "x(40)" ? ? ? 0 ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tiempo-observado(chktareas.fechafin, chktareas.horafin) @ x-tiempo-observado-col" "Hora Terminado" "x(25)" ? ? ? 0 ? ? ? no ? no no "2.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Gestion de Ordenes terminadas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Gestion de Ordenes terminadas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&Scoped-define SELF-NAME BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON ENTRY OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas */
DO:
    x-codped = "".
    x-nroped = "".
    /*browse-15:TITLE = "".*/
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.

          /*browse-15:TITLE = chktareas.coddoc + " " + x-nroped + " " + faccpedi.nomcli.*/
    END.

    RUN recopilar-ordenes(INPUT x-nroped, INPUT x-nroped).

    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON LEFT-MOUSE-DBLCLICK OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas */
DO:
/*   IF NOT AVAILABLE ChkTareas THEN RETURN NO-APPLY. */
/*   MESSAGE 'Procedemos el envío a distribución?'    */
/*       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO    */
/*       UPDATE rpta AS LOG.                          */
/*   IF rpta = NO THEN RETURN.                        */
/*   RUN Envio-a-Distribucion.                        */
/*   {&OPEN-QUERY-BROWSE-14}                          */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-14 W-Win
ON VALUE-CHANGED OF BROWSE-14 IN FRAME F-Main /* Bandeja de ordenes terminadas */
DO:
  x-codped = "".
  x-nroped = "".

  /*browse-15:TITLE = "".*/
 
  IF AVAILABLE chktareas THEN DO:
        x-codped = chktareas.coddoc.
        x-nroped = chktareas.nroped.
  END.
  
  RUN recopilar-ordenes(INPUT x-nroped, INPUT x-nroped).

  /*{&open-query-browse-15}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Envio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Envio W-Win
ON CHOOSE OF BUTTON-Envio IN FRAME F-Main /* ENVIAR A DESPACHO */
DO:
    IF NOT AVAILABLE ChkTareas THEN RETURN NO-APPLY.
    MESSAGE 'Procedemos el envío a distribución?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Envio-a-Distribucion.
    {&OPEN-QUERY-BROWSE-14}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-phr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-phr W-Win
ON LEAVE OF FILL-IN-phr IN FRAME F-Main /* PHR */
DO:
  ASSIGN FILL-IN-phr.

  SESSION:SET-WAIT-STATE("GENERAL").
  {&open-query-browse-14}
  SESSION:SET-WAIT-STATE("").

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
  DISPLAY FILL-IN-phr 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-14 BUTTON-Envio FILL-IN-phr 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envio-a-Distribucion W-Win 
PROCEDURE Envio-a-Distribucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Solicitamos Zona de Distribución */
RUN logis/d-zona-distribucion (OUTPUT pZona).
IF pZona = ? THEN RETURN 'ADM-ERROR'.

DEF VAR n-Item AS INT NO-UNDO.

DO n-Item = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(n-Item) THEN DO:
        pMensaje = ''.
        RUN Grabar-Estado.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar la " + ChkTareas.CodDoc + ' ' + ChkTareas.NroPed.
            pMensaje = pMensaje + CHR(10) + 'Se continuará con el siguiente registro'.
            MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
        END.
    END.
END.
IF AVAILABLE ChkTareas THEN RELEASE ChkTareas.
IF AVAILABLE Vtacdocu  THEN RELEASE Vtacdocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales W-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID .

{lib/lock-genericov3.i &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        &Intentos=5 ~
        }

{vta2/graba-totales-cotizacion-cred.i}

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Estado W-Win 
PROCEDURE Grabar-Estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pCambios AS LOG NO-UNDO.

ASSIGN
    pRowid = ROWID(Faccpedi).
CICLO:                
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT ChkTareas EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE ChkTareas OR NOT AVAILABLE Vtacdocu THEN DO:
        pMensaje = 'NO se pudo actualizar el estado ' + ChkTareas.CodDoc + ' ' + ChkTareas.NroPed.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    {lib/lock-genericov3.i &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        &Intentos=5 ~
        }
    ASSIGN
        ChkTareas.FlgEst = "C".
    ASSIGN
        VtaCDocu.ZonaDistribucion = STRING(pZona)
        Vtacdocu.FlgSit = "C".
    /* *********************** */
    /* Corrección de despachos */
    /* *********************** */
    DEF VAR x-CanPed AS DEC NO-UNDO.
    pCambios = NO.
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK WHERE Vtaddocu.canped = 0,
        FIRST Almmmatg OF Vtaddocu NO-LOCK:
        FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN NEXT.
        FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.
        /* *************************************** */
        /* RHC 11/03/2020 Control de modificaciones */
        /* *************************************** */
        ASSIGN
            x-CanPed = Facdpedi.CanPed.
        /* 1ro. Extornamos la cantidad base */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor).
        /* 2do. Actualizamos la cantidad pickeada final */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed + (Vtaddocu.CanPed / Facdpedi.Factor).
        /* *************************************** */
        /* RHC 11/03/2020 Control de modificaciones */
        /* *************************************** */
        IF x-CanPed <> Facdpedi.CanPed THEN DO:
            CREATE LogTabla.
            ASSIGN
                logtabla.codcia = s-CodCia
                logtabla.Dia = TODAY
                logtabla.Evento = 'CORRECCION'
                logtabla.Hora = STRING(TIME, 'HH:MM:SS')
                logtabla.Tabla = 'FACDPEDI'
                logtabla.Usuario = s-User-Id
                logtabla.ValorLlave = Facdpedi.CodDoc + '|' +
                                        Facdpedi.NroPed + '|' +
                                        Facdpedi.CodMat + '|' +
                                        STRING(x-CanPed) + '|' +
                                        STRING(Facdpedi.CanPed).
            RUN Recalcular-Registro.
            /* OJO: Los items que están en cero se ELIMINAN */
            IF Facdpedi.CanPed <= 0 THEN DO:
                DELETE Facdpedi.    /* OJO */
            END.
            /* ******************************************** */
            pCambios = YES.
        END.
        DELETE Vtaddocu.
    END.
    IF pCambios = YES THEN DO:
        {vta2/graba-totales-cotizacion-cred.i}
    END.
    FIND CURRENT Faccpedi NO-LOCK NO-ERROR.
    /* *********************** */
    pMensaje = ''.
    /* La PHR se va a cerrar al FINALIZAR EL PICKING */
    RUN logis/p-cierra-pik-phr.r (Vtacdocu.CodPed,    /* HPK */
                                Vtacdocu.CodDiv,
                                Vtacdocu.CodRef,    /* O/D OTR */
                                Vtacdocu.NroRef,
                                Vtacdocu.CodOri,    /* PHR */
                                Vtacdocu.NroOri,
                                OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la PHR " + Vtacdocu.NroOri.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *************************************************************************** */
END.
/* *************************************************************************** */
/* ALERTA */
/* *************************************************************************** */
RUN logis/d-alerta-phr-reasign (Vtacdocu.CodPed, Vtacdocu.NroPed).
/* *************************************************************************** */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordenes-de-la-hpr W-Win 
PROCEDURE ordenes-de-la-hpr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-hpr AS CHAR.
DEFINE INPUT PARAMETER pnro-hpr AS CHAR.

DEFINE VAR x-llave AS CHAR.

DEFINE BUFFER x-vtacdocu FOR vtacdocu.
DEFINE BUFFER x-almddocu FOR almddocu.

EMPTY TEMP-TABLE ttOrdenesHPR.

FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                            x-vtacdocu.codped = 'HPK' AND
                            x-vtacdocu.codori = pcod-hpr AND
                            x-vtacdocu.nroori = pnro-hpr NO-LOCK:

    x-llave = x-vtacdocu.codped + "," + x-vtacdocu.nroped.

    IF x-vtacdocu.codter = 'ACUMULATIVO' THEN DO:
        /* Las HPK de la HPR */
        FOR EACH x-almddocu WHERE x-almddocu.codcia = s-codcia AND
                                    x-almddocu.codllave = x-llave NO-LOCK BREAK BY coddoc  BY nrodoc:
            IF FIRST-OF(coddoc) OR FIRST-OF(nrodoc) THEN DO:
                CREATE ttOrdenesHPR.
                    ASSIGN ttOrdenesHPR.tcoddoc = x-almddocu.coddoc
                            ttOrdenesHPR.tnrodoc = x-almddocu.nrodoc
                    .
            END.

        END.
    END.
    ELSE DO:
        CREATE ttOrdenesHPR.
            ASSIGN ttOrdenesHPR.tcoddoc = x-vtacdocu.codref
                    ttOrdenesHPR.tnrodoc = x-vtacdocu.nroref
            .
    END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Registro W-Win 
PROCEDURE Recalcular-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       El flete ya está aplicado en el PreUni
------------------------------------------------------------------------------*/

    /* Recalculamos el importe del registro */
    ASSIGN
        Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                              ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
    IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
        THEN Facdpedi.ImpDto = 0.
    ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
    ASSIGN
        Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
        Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
    IF Facdpedi.AftIsc 
        THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE Facdpedi.ImpIsc = 0.
    IF Facdpedi.AftIgv 
        THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
    ELSE Facdpedi.ImpIgv = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recopilar-ordenes W-Win 
PROCEDURE recopilar-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

DEFINE VAR x-llave AS CHAR.

EMPTY TEMP-TABLE ttOrdenes.

IF pCodDoc = 'HPK' THEN DO:
    DEFINE BUFFER x-vtacdocu FOR vtacdocu.
    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDOc AND
                                    x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE x-vtacdocu THEN DO:
        IF x-vtacdocu.codter = 'ACUMULATIVO' THEN DO:
            DEFINE BUFFER x-almddocu FOR almddocu.
            x-llave = pCodDoc + "," + pNroDOc.
            FOR EACH x-almddocu WHERE x-almddocu.codcia = s-codcia AND 
                                        x-almddocu.codllave = x-llave NO-LOCK
                                        BREAK BY coddoc BY nrodoc.
                IF FIRST-OF(x-almddocu.coddoc) OR FIRST-OF(x-almddocu.nrodoc) THEN DO:
                    CREATE ttOrdenes.
                        ASSIGN tcoddoc = x-almddocu.coddoc
                                tnrodoc = x-almddocu.nrodoc.
                END.
            END.
        END.
        ELSE DO:
            CREATE ttOrdenes.
                ASSIGN tcoddoc = x-vtacdocu.codref
                        tnrodoc = x-vtacdocu.nroref.
        END.
    END.
END.
ELSE DO:
    CREATE ttOrdenes.
        ASSIGN tcoddoc = pCodDoc
                tnrodoc = pNroDoc.
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
  {src/adm/template/snd-list.i "ChkTareas"}
  {src/adm/template/snd-list.i "VtaCDocu"}
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE terminar-orden W-Win 
PROCEDURE terminar-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-procesoOk AS CHAR NO-UNDO.

x-procesoOk = 'Inicio'.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-vtacdocu FOR vtacdocu.
DEFINE BUFFER b-chktareas FOR chktareas.

GRABAR_REGISTROS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* Ordenes */
    x-procesoOk = "Actualizar la orden como Pase a Districion (C)". 

  DO:
    IF chktareas.coddoc = 'HPK' THEN DO:
        x-procesoOk = "Actualizar la orden como Pase a Distribucion (C)". 
        FIND FIRST b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia AND 
                                        b-vtacdocu.codped = chktareas.coddoc AND
                                        b-vtacdocu.nroped = chktareas.nroped EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-vtacdocu THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN como Cierre de Chequeo".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-vtacdocu.flgsit = 'C'.

        /* Verificar si todas las HPKs de la HPR estan enviadas a Distribucion */
        x-procesoOk = ''.
        RUN verifica-hpks-enviadas-a-despacho(INPUT b-vtacdocu.codori, INPUT b-vtacdocu.nroori, OUTPUT x-procesoOK).

        IF x-procesoOk = 'OK' THEN DO:
            /* Las Ordenes contenidas en la HPR */
            RUN ordenes-de-la-hpr(INPUT b-vtacdocu.codori, INPUT b-vtacdocu.nroori).

            FOR EACH ttOrdenesHPR ON ERROR UNDO, THROW:
                /* O/D, OTR */
                FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                                b-faccpedi.coddoc = ttOrdenesHPR.tcoddoc AND
                                                b-faccpedi.nroped = ttOrdenesHPR.tnrodoc AND
                                                b-faccpedi.flgest <> 'A' EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE b-faccpedi THEN DO:
                    x-procesoOk = "La Orden " + ttOrdenesHPR.tcoddoc + " " + ttOrdenesHPR.tnrodoc + 
                        " no existe, puede estar anulada ó en uso por otro usuario".
                    UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
                END.
                ASSIGN b-faccpedi.flgsit = 'C'.
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                        b-faccpedi.coddoc = chktareas.coddoc AND
                                        b-faccpedi.nroped = chktareas.nroped EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-faccpedi THEN DO:
            x-procesoOk = "Error al actualizar la ORDEN " + chktareas.coddoc + " " +
                                                        chktareas.nroped + " como pase a Distribucion".
            UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
        END.
        ASSIGN b-faccpedi.flgsit = 'C'.

    END.

    /* Tarea Observacion */
    x-procesoOk = "Ponemos la tarea como Pase a Distribucion".
    FIND FIRST b-chktareas WHERE b-chktareas.codcia = chktareas.codcia AND
                                b-chktareas.coddiv = chktareas.coddiv AND 
                                b-chktareas.coddoc = chktareas.coddoc AND
                                b-chktareas.nroped = chktareas.nroped AND
                                b-chktareas.mesa = chktareas.mesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE b-chktareas THEN DO:
        x-procesoOk = "Error al actualizar la TAREA como Pase a Distribucion".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN b-chktareas.flgest = 'C' 
        b-chktareas.fechafin = TODAY
        b-chktareas.horafin = STRING(TIME,"HH:MM:SS")
        b-chktareas.usuariofin = s-user-id NO-ERROR
    .
                                
    x-procesoOk = "OK".

  END.

END. /* TRANSACTION block */

RELEASE b-faccpedi.
RELEASE b-vtacdocu.
RELEASE b-chktareas.

IF x-procesoOk = "OK" THEN DO:
    {&open-query-browse-14}

    x-codped = "".
    x-nroped = "".
    IF AVAILABLE chktareas THEN DO:
          x-codped = chktareas.coddoc.
          x-nroped = chktareas.nroped.
    END.

    RUN recopilar-ordenes(INPUT x-nroped, INPUT x-nroped).

END.
ELSE DO:
    MESSAGE x-procesoOk.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-hpks-enviadas-a-despacho W-Win 
PROCEDURE verifica-hpks-enviadas-a-despacho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-hpr AS CHAR.
DEFINE INPUT PARAMETER pnro-hpr AS CHAR.
DEFINE OUTPUT PARAMETER pCerrado AS CHAR.

pCerrado = "OK".
DEFINE BUFFER x-vtacdocu FOR vtacdocu.

/* HPKs enviadas a dsepacho */
FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                            x-vtacdocu.codped = 'HPK' AND
                            x-vtacdocu.codori = pcod-hpr AND
                            x-vtacdocu.nroori = pnro-hpr NO-LOCK:
    IF x-vtacdocu.flgsit <> 'C' THEN DO:
        pCerrado = x-vtacdocu.codped + "-" + x-vtacdocu.nroped + 'aun NO enviada a Despacho'.
    END.
        

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-bultos W-Win 
FUNCTION cantidad-bultos RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS INT INIT 0.

    RUN recopilar-ordenes(INPUT pCodDOc, INPUT pNroDoc).

    DEFINE BUFFER x-ControlOD FOR ControlOD.

    FOR EACH ttOrdenes :
        FOR EACH x-ControlOD WHERE x-ControlOD.codcia = s-codcia AND 
                                    x-ControlOD.coddoc = ttOrdenes.tCodDoc AND
                                    x-ControlOD.nrodoc = ttOrdenes.tnroDoc NO-LOCK:
            x-retval = x-retval + 1.
        END.
    END.

    RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cantidad-sku W-Win 
FUNCTION cantidad-sku RETURNS INTEGER
  ( INPUT pCodDoc AS CHAR, INPUT pNrodoc AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS INT INIT 0.

  IF pCodDoc = 'HPK' THEN DO:
      DEFINE BUFFER x-vtaddocu FOR vtaddocu.

      FOR EACH x-vtaddocu WHERE x-vtaddocu.codcia = s-codcia AND
                                    x-vtaddocu.codped = pCodDoc AND
                                    x-vtaddocu.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
  END.
  ELSE DO:
      DEFINE BUFFER x-facdpedi FOR facdpedi.

      FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                                    x-facdpedi.coddoc = pCodDoc AND
                                    x-facdpedi.nroped = pNrodoc NO-LOCK:
            x-retval = x-retval + 1.

      END.
  END.

  RETURN x-retval.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION chequeador W-Win 
FUNCTION chequeador RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroPed AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RUN recopilar-ordenes(INPUT pCodDOc, INPUT pNroped).

FIND FIRST ttOrdenes NO-ERROR.
DEFINE VAR x-retval AS CHAR INIT "".

IF AVAILABLE ttOrdenes THEN DO:
    DEFINE BUFFER x-faccpedi FOR faccpedi.    

    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                    x-faccpedi.coddoc = ttOrdenes.tcoddoc AND 
                                    x-faccpedi.nroped = ttOrdenes.tnrodoc NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        /* buscarlo si existe en la maestra de personal */
        FIND FIRST pl-pers WHERE  pl-pers.codper = x-faccpedi.usrchq NO-LOCK NO-ERROR.
        IF  AVAILABLE pl-pers THEN DO:
            x-retval = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
        END.

    END.

END.

RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cliente W-Win 
FUNCTION cliente RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDOc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR x-retval AS CHAR.

IF pCodDoc = 'HPK' THEN DO:
    DEFINE BUFFER x-vtacdocu FOR vtacdocu.
    FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                    x-vtacdocu.codped = pCodDOc AND
                                    x-vtacdocu.nroped = pNrodoc NO-LOCK NO-ERROR.
    IF AVAILABL x-vtacdocu THEN x-retval = x-vtacdocu.nomcli.
END.
ELSE DO:
    DEFINE BUFFER x-faccpedi FOR faccpedi.
    
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCoddoc AND
                                x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABL x-faccpedi THEN x-retval = x-faccpedi.nomcli.
END.

RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION es-crossdocking W-Win 
FUNCTION es-crossdocking RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR INIT "NO".

  DEFINE BUFFER x-chkcontrol FOR ChkCOntrol.

  FIND FIRST x-ChkControl WHERE x-ChkControl.codcia = s-codcia AND 
                              x-ChkControl.coddiv = s-coddiv AND 
                              x-ChkControl.coddoc = pCoddoc AND 
                              x-ChkControl.nroped = pNrodoc NO-LOCK NO-ERROR.
  IF AVAILABLE x-ChkControl THEN DO:
    IF x-ChkControl.crossdocking THEN x-retval = 'SI'.
  END.


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION estado-de-orden W-Win 
FUNCTION estado-de-orden RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS CHAR INIT "OK".

  /* Chalacazooooooooo */
  LOOP_DATA:
  FOR EACH x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                x-vtacdocu.codped = 'HPK' AND
                                x-vtacdocu.codref = pCoddoc AND
                                x-vtacdocu.nroref = pNroDOc AND
                                x-vtacdocu.flgest <> "A"
                                NO-LOCK:
      IF x-vtacdocu.flgsit = 'PC' THEN DO:
          /**/
      END.
      ELSE DO:
          x-retval = "NO".
          LEAVE LOOP_DATA.
      END.
  END.

  IF x-retval = "OK" THEN DO:
      FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                    x-faccpedi.coddoc = pCodDoc AND 
                                    x-faccpedi.nroped = pNroDOc AND
                                    x-faccpedi.flgsit = 'PT' EXCLUSIVE NO-ERROR.
      IF AVAILABLE x-faccpedi THEN ASSIGN x-faccpedi.flgsit = 'PC'.

      RELEASE x-faccpedi.
  END.

  /* FIN Chalacazooooooooo */

  FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                                x-faccpedi.coddoc = pCodDoc AND 
                                x-faccpedi.nroped = pNroDOc NO-LOCK NO-ERROR.
  IF AVAILABLE x-faccpedi THEN DO:
      x-retval = situacion(x-faccpedi.flgest, x-faccpedi.flgsit).
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION jalar-nro-phr W-Win 
FUNCTION jalar-nro-phr RETURNS CHARACTER
  ( INPUT pCodDoc AS CHAR, INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS CHAR INIT "".

    DEFINE BUFFER x-vtacdocu FOR vtacdocu.

    IF pCodDoc = 'HPK' THEN DO:
        FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND
                                        x-vtacdocu.codped = pCodDOc AND
                                        x-vtacdocu.nroped = pNroDoc NO-LOCK NO-ERROR.
        IF AVAILABLE x-vtacdocu THEN x-retval = x-vtacdocu.nroori.
    END.

    RETURN x-retval.   /* Function return value. */  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION situacion W-Win 
FUNCTION situacion RETURNS CHARACTER
  ( INPUT pFlgEst AS CHAR, INPUT pFlgSit AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR.

  x-retval = pFlgSit.

    IF pFlgSit = 'T' THEN x-retval = "Orden Generada".
    IF pFlgSit = 'P' THEN x-retval = "Pickin OK".
    IF pFlgSit = 'PR' THEN x-retval = "Recepcionado".
    IF pFlgSit = 'PT' THEN x-retval = "Cola de Chequeo".
    IF pFlgSit = 'PK' THEN x-retval = "Proceso de Chequeo".
    IF pFlgSit = 'PO' THEN x-retval = "Chequeo con Observaciones".
    IF pFlgSit = 'PE' THEN x-retval = "En Embalaje".
    IF pFlgSit = 'PC' THEN x-retval = "Chequeo OK".
    IF pFlgSit = 'C' THEN x-retval = "Pase a distribucion".

    IF pFlgEst = 'C' THEN x-retval = "Facturado".


  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION tiempo-observado W-Win 
FUNCTION tiempo-observado RETURNS CHARACTER
  ( INPUT pFecha AS DATE, INPUT pHora AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-tiempo AS CHAR.

    x-Tiempo = STRING(pFecha,"99/99/9999") + " " + pHora.
    /*
    RUN lib/_time-passed ( DATETIME(STRING(pFecha,"99/99/9999") + ' ' + pHora),
                             DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).
    */
    

    RETURN x-tiempo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

