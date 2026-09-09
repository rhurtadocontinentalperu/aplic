&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ADOCU FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER bCcbCDocu FOR CcbCDocu.
DEFINE TEMP-TABLE T-CcbADocu NO-UNDO LIKE CcbADocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE tgre_cmpte_1 NO-UNDO LIKE gre_cmpte.
DEFINE TEMP-TABLE tgre_cmpte_2 NO-UNDO LIKE gre_cmpte.



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


DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF VAR x-FormatoGUIA AS CHAR INIT '999-999999' NO-UNDO.
DEFINE VARIABLE FILL-IN-LugEnt AS CHARACTER FORMAT "X(60)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE_Destino

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tgre_cmpte_2 CcbCDocu tgre_cmpte_1 FacCPedi ~
DI-RutaD

/* Definitions for BROWSE BROWSE_Destino                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE_Destino CcbCDocu.FchDoc ~
CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.ImpTot CcbCDocu.Glosa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE_Destino 
&Scoped-define QUERY-STRING-BROWSE_Destino FOR EACH tgre_cmpte_2 NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodDoc = tgre_cmpte_2.coddoc ~
  AND CcbCDocu.NroDoc = tgre_cmpte_2.nrodoc ~
      AND CcbCDocu.CodCia = s-codcia NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE_Destino OPEN QUERY BROWSE_Destino FOR EACH tgre_cmpte_2 NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodDoc = tgre_cmpte_2.coddoc ~
  AND CcbCDocu.NroDoc = tgre_cmpte_2.nrodoc ~
      AND CcbCDocu.CodCia = s-codcia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE_Destino tgre_cmpte_2 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE_Destino tgre_cmpte_2
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE_Destino CcbCDocu


/* Definitions for BROWSE BROWSE_Origen                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE_Origen CcbCDocu.FchDoc ~
CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.ImpTot CcbCDocu.Glosa FacCPedi.NroPed DI-RutaD.NroDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE_Origen 
&Scoped-define QUERY-STRING-BROWSE_Origen FOR EACH tgre_cmpte_1 NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodDoc = tgre_cmpte_1.coddoc ~
  AND CcbCDocu.NroDoc = tgre_cmpte_1.nrodoc ~
      AND CcbCDocu.CodCia = s-codcia NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia ~
  AND FacCPedi.CodDoc = CcbCDocu.Libre_c01 ~
  AND FacCPedi.NroPed = CcbCDocu.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = FacCPedi.CodCia ~
  AND DI-RutaD.CodRef = FacCPedi.CodDoc ~
  AND DI-RutaD.NroRef = FacCPedi.NroPed ~
      AND DI-RutaD.CodDoc = "PHR" OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE_Origen OPEN QUERY BROWSE_Origen FOR EACH tgre_cmpte_1 NO-LOCK, ~
      FIRST CcbCDocu WHERE CcbCDocu.CodDoc = tgre_cmpte_1.coddoc ~
  AND CcbCDocu.NroDoc = tgre_cmpte_1.nrodoc ~
      AND CcbCDocu.CodCia = s-codcia NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia ~
  AND FacCPedi.CodDoc = CcbCDocu.Libre_c01 ~
  AND FacCPedi.NroPed = CcbCDocu.Libre_c02 OUTER-JOIN NO-LOCK, ~
      FIRST DI-RutaD WHERE DI-RutaD.CodCia = FacCPedi.CodCia ~
  AND DI-RutaD.CodRef = FacCPedi.CodDoc ~
  AND DI-RutaD.NroRef = FacCPedi.NroPed ~
      AND DI-RutaD.CodDoc = "PHR" OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE_Origen tgre_cmpte_1 CcbCDocu FacCPedi ~
DI-RutaD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE_Origen tgre_cmpte_1
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE_Origen CcbCDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE_Origen FacCPedi
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE_Origen DI-RutaD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE_Destino}~
    ~{&OPEN-QUERY-BROWSE_Origen}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-71 RECT-72 BROWSE_Origen ~
BUTTON_Refrescar COMBO-BOX_CodDoc BUTTON-9 BUTTON-8 BROWSE_Destino ~
COMBO-BOX_NroSer BUTTON_Transport BUTTON-5 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_CodDoc FILL-IN_FchDoc-1 ~
FILL-IN_FchDoc-2 COMBO-BOX_NroSer FILL-IN_Formato FILL-IN_Correlativo 

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
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "GENERAR GUIAS DE REMISION" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "IMG/upblue.bmp":U
     LABEL "Button 8" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "IMG/down.ico":U
     LABEL "Button 9" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON_Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12
     BGCOLOR 11 FGCOLOR 0 .

DEFINE BUTTON BUTTON_Transport 
     IMAGE-UP FILE "img/api-vy.ico":U
     LABEL "Button 4" 
     SIZE 15 BY 1.62 TOOLTIP "Ingresar datos del transportista".

DEFINE VARIABLE COMBO-BOX_CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Seleccione el comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "FAI","FAI"
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la serie de la G/R" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Correlativo AS INTEGER FORMAT "999999999":U INITIAL 0 
     LABEL "Siguiente Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

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

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 11.31.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 9.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE_Destino FOR 
      tgre_cmpte_2, 
      CcbCDocu SCROLLING.

DEFINE QUERY BROWSE_Origen FOR 
      tgre_cmpte_1, 
      CcbCDocu, 
      FacCPedi
    FIELDS(FacCPedi.NroPed), 
      DI-RutaD
    FIELDS(DI-RutaD.NroDoc) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE_Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE_Destino W-Win _STRUCTURED
  QUERY BROWSE_Destino NO-LOCK DISPLAY
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 12.86
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 12.29
      CcbCDocu.NomCli FORMAT "x(50)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.Glosa FORMAT "x(60)":U WIDTH 44.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 135 BY 9.96
         BGCOLOR 10 FGCOLOR 0 FONT 4
         TITLE BGCOLOR 10 FGCOLOR 0 "COMPROBANTES SELECCIONADOS PARA GENERAR GUIAS DE REMISION" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE_Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE_Origen W-Win _STRUCTURED
  QUERY BROWSE_Origen NO-LOCK DISPLAY
      CcbCDocu.FchDoc FORMAT "99/99/9999":U
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 10.29
      CcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      CcbCDocu.NomCli FORMAT "x(50)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.Glosa FORMAT "x(60)":U WIDTH 43.29
      FacCPedi.NroPed COLUMN-LABEL "# de O/D" FORMAT "X(15)":U
            WIDTH 10.57
      DI-RutaD.NroDoc COLUMN-LABEL "# de PHR" FORMAT "X(12)":U
            WIDTH 9.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 151 BY 11.31
         BGCOLOR 11 FGCOLOR 0 FONT 4
         TITLE BGCOLOR 11 FGCOLOR 0 "SELECCIONE LOS COMPROBANTES A GENERAR GUIAS DE REMISION" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE_Origen AT ROW 1.27 COL 2 WIDGET-ID 200
     BUTTON_Refrescar AT ROW 1.54 COL 173 WIDGET-ID 46
     COMBO-BOX_CodDoc AT ROW 2.88 COL 171 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_FchDoc-1 AT ROW 3.69 COL 171 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_FchDoc-2 AT ROW 4.5 COL 171 COLON-ALIGNED WIDGET-ID 6
     BUTTON-9 AT ROW 12.85 COL 3 WIDGET-ID 50
     BUTTON-8 AT ROW 12.85 COL 12 WIDGET-ID 48
     BROWSE_Destino AT ROW 14.73 COL 2 WIDGET-ID 300
     COMBO-BOX_NroSer AT ROW 15.81 COL 159 COLON-ALIGNED WIDGET-ID 8
     BUTTON_Transport AT ROW 15.81 COL 169 WIDGET-ID 40
     FILL-IN_Formato AT ROW 16.62 COL 159 COLON-ALIGNED WIDGET-ID 44
     FILL-IN_Correlativo AT ROW 17.42 COL 159 COLON-ALIGNED WIDGET-ID 56
     BUTTON-5 AT ROW 20.38 COL 141 WIDGET-ID 10
     BtnDone AT ROW 20.38 COL 156 WIDGET-ID 42
     RECT-71 AT ROW 1.27 COL 153 WIDGET-ID 52
     RECT-72 AT ROW 14.73 COL 137 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 190.57 BY 24.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ADOCU B "?" ? INTEGRAL CcbADocu
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: bCcbCDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: T-CcbADocu T "?" NO-UNDO INTEGRAL CcbADocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: tgre_cmpte_1 T "?" NO-UNDO INTEGRAL gre_cmpte
      TABLE: tgre_cmpte_2 T "?" NO-UNDO INTEGRAL gre_cmpte
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE GUIAS DE REMISION MANUAL"
         HEIGHT             = 24.27
         WIDTH              = 190.57
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 191.14
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 191.14
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
/* BROWSE-TAB BROWSE_Origen RECT-72 F-Main */
/* BROWSE-TAB BROWSE_Destino BUTTON-8 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_Correlativo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Formato IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE_Destino
/* Query rebuild information for BROWSE BROWSE_Destino
     _TblList          = "Temp-Tables.tgre_cmpte_2,INTEGRAL.CcbCDocu WHERE Temp-Tables.tgre_cmpte_2 ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST,"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodDoc = Temp-Tables.tgre_cmpte_2.coddoc
  AND INTEGRAL.CcbCDocu.NroDoc = Temp-Tables.tgre_cmpte_2.nrodoc"
     _Where[2]         = "INTEGRAL.CcbCDocu.CodCia = s-codcia"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[3]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCDocu.NomCli
     _FldNameList[6]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[7]   > INTEGRAL.CcbCDocu.Glosa
"CcbCDocu.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "44.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE_Destino */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE_Origen
/* Query rebuild information for BROWSE BROWSE_Origen
     _TblList          = "Temp-Tables.tgre_cmpte_1,INTEGRAL.CcbCDocu WHERE Temp-Tables.tgre_cmpte_1 ...,INTEGRAL.FacCPedi WHERE INTEGRAL.CcbCDocu ...,INTEGRAL.DI-RutaD WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST OUTER USED, FIRST OUTER USED"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodDoc = Temp-Tables.tgre_cmpte_1.coddoc
  AND INTEGRAL.CcbCDocu.NroDoc = Temp-Tables.tgre_cmpte_1.nrodoc"
     _Where[2]         = "INTEGRAL.CcbCDocu.CodCia = s-codcia"
     _JoinCode[3]      = "INTEGRAL.FacCPedi.CodCia = INTEGRAL.CcbCDocu.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = INTEGRAL.CcbCDocu.Libre_c01
  AND INTEGRAL.FacCPedi.NroPed = INTEGRAL.CcbCDocu.Libre_c02"
     _JoinCode[4]      = "INTEGRAL.DI-RutaD.CodCia = INTEGRAL.FacCPedi.CodCia
  AND INTEGRAL.DI-RutaD.CodRef = INTEGRAL.FacCPedi.CodDoc
  AND INTEGRAL.DI-RutaD.NroRef = INTEGRAL.FacCPedi.NroPed"
     _Where[4]         = "INTEGRAL.DI-RutaD.CodDoc = ""PHR"""
     _FldNameList[1]   = INTEGRAL.CcbCDocu.FchDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[3]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.CcbCDocu.NomCli
     _FldNameList[6]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[7]   > INTEGRAL.CcbCDocu.Glosa
"CcbCDocu.Glosa" ? ? "character" ? ? ? ? ? ? no ? no no "43.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "# de O/D" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.DI-RutaD.NroDoc
"DI-RutaD.NroDoc" "# de PHR" "X(12)" "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE_Origen */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE GUIAS DE REMISION MANUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE GUIAS DE REMISION MANUAL */
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
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* GENERAR GUIAS DE REMISION */
DO:
  IF NOT CAN-FIND(FIRST tgre_cmpte_2 NO-LOCK) THEN RETURN NO-APPLY.

  GET FIRST BROWSE_Destino.
  REPEAT WHILE NOT QUERY-OFF-END("BROWSE_Destino"):
      FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
          Faccpedi.coddoc = Ccbcdocu.libre_c01 AND
          Faccpedi.nroped = Ccbcdocu.libre_c02 NO-LOCK NO-ERROR.
      IF AVAILABLE(Faccpedi) AND NOT CAN-FIND(FIRST t-Ccbadocu WHERE t-Ccbadocu.codcia = s-codcia AND
                                              t-Ccbadocu.coddiv = Faccpedi.coddiv AND
                                              t-Ccbadocu.coddoc = Faccpedi.coddoc AND
                                              t-Ccbadocu.nrodoc = Faccpedi.nroped NO-LOCK) THEN DO:
          MESSAGE 'NO ha registrado el transportista' SKIP
              Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc SKIP
              Faccpedi.coddoc + " " + Faccpedi.nroped SKIP
              'Está seguro de continuar?' VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO UPDATE rpta1 AS LOG.
          IF rpta1 = NO THEN RETURN NO-APPLY.
      END.
      GET NEXT BROWSE_Destino.
  END.

  MESSAGE 'Estamos listos!!!' SKIP
      'Procedemos con la generación de la G/R?' 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  ASSIGN COMBO-BOX_NroSer.

  RUN Genera-GR (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Proceso exitoso' VIEW-AS ALERT-BOX INFORMATION.
  RUN Carga-Temporal.
  EMPTY TEMP-TABLE tgre_cmpte_2.
  EMPTY TEMP-TABLE t-Ccbadocu.
  {&OPEN-QUERY-BROWSE_Origen}
  {&OPEN-QUERY-BROWSE_Destino}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
    DEF VAR iRegistro AS INTE NO-UNDO.

    DO iRegistro = 1 TO BROWSE_Destino:NUM-SELECTED-ROWS:
        IF BROWSE_Destino:FETCH-SELECTED-ROW(iRegistro) THEN DO:
            /* 02/06/2026: Eliminamos datos del transportista por O/D */
            FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND
                Faccpedi.coddoc = Ccbcdocu.libre_c01 AND        /* O/D */
                Faccpedi.nroped = Ccbcdocu.libre_c02
                NO-LOCK NO-ERROR.
            IF AVAILABLE Faccpedi THEN DO:
                FIND t-CcbADocu WHERE t-CcbADocu.codcia = s-codcia AND
                    t-CcbADocu.coddiv = Faccpedi.coddiv AND
                    t-CcbADocu.coddoc = Faccpedi.coddoc AND
                    t-CcbADocu.nrodoc = Faccpedi.nroped NO-LOCK NO-ERROR.
                IF AVAILABLE t-CcbADocu THEN DELETE t-CcbADocu.
            END.

            CREATE tgre_cmpte_1.
            BUFFER-COPY tgre_cmpte_2 TO tgre_cmpte_1.
            DELETE tgre_cmpte_2.

        END.
    END.
    {&OPEN-QUERY-BROWSE_Origen}
    {&OPEN-QUERY-BROWSE_Destino}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
  DEF VAR iRegistro AS INTE NO-UNDO.

  DO iRegistro = 1 TO BROWSE_Origen:NUM-SELECTED-ROWS:
      IF BROWSE_Origen:FETCH-SELECTED-ROW(iRegistro) THEN DO:
          IF CAN-FIND(bCcbcdocu WHERE bCcbcdocu.codcia = s-codcia 
                      AND bCcbcdocu.coddoc = "G/R"
                      AND bCcbcdocu.codref = Ccbcdocu.coddoc
                      AND bCcbcdocu.nroref = Ccbcdocu.nrodoc
                      AND bCcbcdocu.flgest <> "A" NO-LOCK)
              THEN DO:
              MESSAGE 'El comprobante' Ccbcdocu.coddoc Ccbcdocu.nrodoc 'YA tiene registrada al menos una Guía de Remisión'
                  VIEW-AS ALERT-BOX WARNING.
              NEXT.
          END.
          /* 02/06/2026: Pasamos datos del transportista por O/D */
          IF AVAILABLE Faccpedi THEN DO:
              FIND FIRST CcbADocu WHERE CcbADocu.codcia = s-codcia AND
                  CcbADocu.coddiv = Faccpedi.coddiv AND
                  CcbADocu.coddoc = Faccpedi.coddoc AND
                  CcbADocu.nrodoc = Faccpedi.nroped NO-LOCK NO-ERROR.
              IF AVAILABLE CcbADocu THEN DO:
                  FIND t-CcbADocu WHERE t-CcbADocu.codcia = s-codcia AND
                      t-CcbADocu.coddiv = Faccpedi.coddiv AND
                      t-CcbADocu.coddoc = Faccpedi.coddoc AND
                      t-CcbADocu.nrodoc = Faccpedi.nroped NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE t-CcbADocu THEN CREATE t-CcbADocu.
                  BUFFER-COPY CcbADocu TO t-CcbADocu.
              END.
          END.

          CREATE tgre_cmpte_2.
          BUFFER-COPY tgre_cmpte_1 TO tgre_cmpte_2.
          DELETE tgre_cmpte_1.

      END.
  END.
  {&OPEN-QUERY-BROWSE_Origen}
  {&OPEN-QUERY-BROWSE_Destino}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Refrescar W-Win
ON CHOOSE OF BUTTON_Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
   RUN Carga-Temporal.
   EMPTY TEMP-TABLE tgre_cmpte_2.
   EMPTY TEMP-TABLE t-Ccbadocu.
   {&OPEN-QUERY-BROWSE_Origen}
   {&OPEN-QUERY-BROWSE_Destino}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Transport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Transport W-Win
ON CHOOSE OF BUTTON_Transport IN FRAME F-Main /* Button 4 */
DO:
  IF NOT AVAILABLE(Ccbcdocu) THEN RETURN NO-APPLY.

  DEF VAR pcCodDiv AS CHAR NO-UNDO.
  DEF VAR pcCodDoc AS CHAR NO-UNDO.
  DEF VAR pcNroPed AS CHAR NO-UNDO.

  FIND FIRST FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia
      AND FacCPedi.CodDoc = CcbCDocu.Libre_c01
      AND FacCPedi.NroPed = CcbCDocu.Libre_c02
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN NO-APPLY.
  IF Faccpedi.DT = YES THEN DO:
      MESSAGE 'La Orden es para DEJAR EN TIENDA' SKIP
          'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  ASSIGN
      pcCodDiv = Faccpedi.coddiv
      pcCodDoc = Faccpedi.coddoc
      pcNroPed = Faccpedi.nroped.

  /*
  IF NOT CAN-FIND(FIRST tgre_cmpte_2 NO-LOCK) THEN RETURN NO-APPLY.

  /* Barremos el browse */
  DEF BUFFER btgre_cmpte_2 FOR tgre_cmpte_2.


  FOR EACH btgre_cmpte_2 NO-LOCK,
      FIRST CcbCDocu WHERE CcbCDocu.CodDoc = btgre_cmpte_2.coddoc
        AND CcbCDocu.NroDoc = btgre_cmpte_2.nrodoc
        AND CcbCDocu.CodCia = s-codcia NO-LOCK,
      FIRST FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia
        AND FacCPedi.CodDoc = CcbCDocu.Libre_c01
        AND FacCPedi.NroPed = CcbCDocu.Libre_c02:
      IF Faccpedi.DT = YES THEN DO:
          MESSAGE 'La Orden es para DEJAR EN TIENDA' SKIP
              'Acceso Denegado' VIEW-AS ALERT-BOX INFORMATION.
          RETURN NO-APPLY.
      END.
      ASSIGN
          pcCodDiv = Faccpedi.coddiv
          pcCodDoc = Faccpedi.coddoc
          pcNroPed = Faccpedi.nroped.
  END.
  */

  RUN logis/d-transportista-gr-manuales (INPUT-OUTPUT TABLE t-CcbADocu,
                                         INPUT TABLE tgre_cmpte_2,
                                         s-codcia,
                                         pcCodDiv,
                                         pcCodDoc,
                                         pcNroPed
                                         ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_CodDoc W-Win
ON VALUE-CHANGED OF COMBO-BOX_CodDoc IN FRAME F-Main /* Seleccione el comprobante */
DO:
  ASSIGN {&SELF-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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
  IF AVAILABLE Faccorre THEN DO:
      FILL-IN_Formato:SCREEN-VALUE = Faccorre.nroimp.
      DISPLAY FacCorre.Correlativo @ FILL-IN_Correlativo WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-1 W-Win
ON LEAVE OF FILL-IN_FchDoc-1 IN FRAME F-Main /* Emitidos desde */
DO:
    ASSIGN {&SELF-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-2 W-Win
ON LEAVE OF FILL-IN_FchDoc-2 IN FRAME F-Main /* Emitidos hasta */
DO:
    ASSIGN {&SELF-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE_Destino
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/*
ON FIND OF Ccbcdocu DO:
    IF CAN-FIND(bCcbcdocu WHERE bCcbcdocu.codcia = s-codcia 
                AND bCcbcdocu.coddoc = "G/R"
                AND bCcbcdocu.codref = Ccbcdocu.coddoc
                AND bCcbcdocu.nroref = Ccbcdocu.nrodoc
                AND bCcbcdocu.flgest <> "A" NO-LOCK)
        THEN RETURN ERROR.
END.

*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tgre_cmpte_1.

FOR EACH gre_cmpte WHERE gre_cmpte.fechaemision >= FILL-IN_FchDoc-1
        AND gre_cmpte.fechaemision <= FILL-IN_FchDoc-2
        AND gre_cmpte.estado = "CMPTE GENERADO"
        AND gre_cmpte.coddoc = COMBO-BOX_CodDoc
        AND gre_cmpte.coddivdesp = s-coddiv NO-LOCK,
    FIRST CcbCDocu WHERE CcbCDocu.CodDoc = gre_cmpte.coddoc
        AND CcbCDocu.NroDoc = gre_cmpte.nrodoc
        AND CcbCDocu.CodCia = s-codcia NO-LOCK,
    EACH FacCPedi WHERE FacCPedi.CodCia = CcbCDocu.CodCia
        AND FacCPedi.CodDoc = CcbCDocu.Libre_c01
        AND FacCPedi.NroPed = CcbCDocu.Libre_c02 NO-LOCK:
    CREATE tgre_cmpte_1.
    BUFFER-COPY gre_cmpte TO tgre_cmpte_1.
END.


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
  DISPLAY COMBO-BOX_CodDoc FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 COMBO-BOX_NroSer 
          FILL-IN_Formato FILL-IN_Correlativo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-71 RECT-72 BROWSE_Origen BUTTON_Refrescar COMBO-BOX_CodDoc 
         BUTTON-9 BUTTON-8 BROWSE_Destino COMBO-BOX_NroSer BUTTON_Transport 
         BUTTON-5 BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-GR W-Win 
PROCEDURE Genera-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.

    DEF VAR pCodDpto AS CHAR NO-UNDO.
    DEF VAR pCodProv AS CHAR NO-UNDO.
    DEF VAR pCodDist AS CHAR NO-UNDO.
    DEF VAR pZona    AS CHAR NO-UNDO.
    DEF VAR pSubZona AS CHAR NO-UNDO.
    DEF VAR pCodPos  AS CHAR NO-UNDO.

    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

    /* Cargamos temporal de control */
    DO TRANSACTION:
        EMPTY TEMP-TABLE Reporte.
        GET FIRST BROWSE_Destino.
        REPEAT WHILE NOT QUERY-OFF-END("BROWSE_Destino"):
            CREATE Reporte.
            BUFFER-COPY Ccbcdocu TO Reporte.
            GET NEXT BROWSE_Destino.
        END.
        IF NOT CAN-FIND(FIRST Reporte NO-LOCK) THEN RETURN.
        /* *************************************** */
        /* RHC 11/05/2020 NO va el flete en la G/R */
        /* RHC 13/07/2020 NO va productos DROP SHIPPING */
        /* *************************************** */
        EMPTY TEMP-TABLE T-DDOCU.
        FOR EACH Reporte NO-LOCK WHERE LOOKUP(Reporte.CodDoc, 'FAC,BOL,FAI') > 0, 
            FIRST B-CDOCU OF Reporte NO-LOCK, 
            EACH B-DDOCU OF B-CDOCU NO-LOCK,
            FIRST Almmmatg OF B-DDOCU NO-LOCK,
            FIRST Almtfami OF Almmmatg NO-LOCK:
            CASE TRUE:
                WHEN Almtfami.Libre_c01 = "SV" THEN NEXT.
                OTHERWISE DO:
                    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
                        VtaTabla.Tabla = "DROPSHIPPING" AND
                        VtaTabla.Llave_c1 = B-DDOCU.CodMat 
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE VtaTabla THEN NEXT.
                END.
            END CASE.
            CREATE T-DDOCU.
            BUFFER-COPY B-DDOCU TO T-DDOCU.
        END.
    END.

    /* **************************************************************************** */
    /* 04/07/2022 Registros por cada GR */
    /* **************************************************************************** */
    DEF VAR x-Items_Guias AS INTE NO-UNDO.
    DEF VAR pFormatoImpresion AS CHAR NO-UNDO.

    DEFINE VAR hLibAlmacen AS HANDLE NO-UNDO.
    RUN alm/almacen-library.p PERSISTENT SET hLibAlmacen.

    RUN GR_Formato_Items IN hLibAlmacen (INPUT COMBO-BOX_NroSer,
                                         OUTPUT pFormatoImpresion,
                                         OUTPUT x-Items_Guias).
    DELETE PROCEDURE hLibAlmacen.
    /* **************************************************************************** */
    /* **************************************************************************** */

    ASSIGN
        lCreaHeader = TRUE.
    pMensaje = "".
    trloop:
    DO TRANSACTION ON ERROR UNDO trloop, RETURN 'ADM-ERROR' ON STOP UNDO trloop, RETURN 'ADM-ERROR':
        /* Correlativo */
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = 'G/R' ~
            AND FacCorre.CodDiv = s-CodDiv ~
            AND FacCorre.NroSer = INTEGER(COMBO-BOX_NroSer)" ~
            &Bloqueo= "EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'" ~
            }

        /* Barremos Factura x Factura */
        FOR EACH T-DDOCU NO-LOCK, FIRST Almmmatg OF T-DDOCU NO-LOCK,
            FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia
                AND B-CDOCU.coddoc = T-DDOCU.coddoc
                AND B-CDOCU.nrodoc = T-DDOCU.nrodoc,
            FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
                AND Faccpedi.coddoc = B-CDOCU.libre_c01
                AND Faccpedi.nroped = B-CDOCU.libre_c02
            BREAK BY T-DDOCU.NroDoc BY T-DDOCU.NroItm:
            /* Cabecera */
            IF lCreaHeader THEN DO:
                /* ************************************* */
                /* También Bloqueamos la tabla GRE_CMPTE */
                /* ************************************* */
                FIND gre_cmpte WHERE gre_cmpte.coddoc = B-CDOCU.coddoc
                    AND gre_cmpte.nrodoc = B-CDOCU.nrodoc EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF NOT AVAILABLE gre_cmpte THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                    UNDO trloop, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    gre_cmpte.estado = "MANUAL".        /* OJO */
                RELEASE gre_cmpte.
                /* ************************************* */
                CREATE CcbCDocu.
                BUFFER-COPY B-CDOCU
                    TO CcbCDocu
                    ASSIGN
                    CcbCDocu.CodDiv = s-CodDiv
                    CcbCDocu.CodDoc = "G/R"
                    CcbCDocu.NroDoc =  STRING(FacCorre.NroSer,ENTRY(1,x-FormatoGUIA,'-')) + 
                                        STRING(FacCorre.Correlativo,ENTRY(2,x-FormatoGUIA,'-')) 
                    CcbCDocu.FchDoc = TODAY
                    CcbCDocu.CodRef = B-CDOCU.CodDoc
                    CcbCDocu.NroRef = B-CDOCU.NroDoc
                    CcbCDocu.FlgEst = "F"   /* FACTURADO */
                    CcbCDocu.usuario = S-USER-ID
                    CcbCDocu.TpoFac = "A"     /* AUTOMATICA (No descarga stock) */
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pMensaje = "Mal configurado el correlativo de la G/R o duplicado".
                    UNDO trloop, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                /* ************************************************************* */
                /* RHC De acuerdo a la sede le cambiamos la dirección de entrega */
                /* ************************************************************* */
                RUN logis/p-lugar-de-entrega (INPUT Faccpedi.CodDoc,
                                              INPUT Faccpedi.NroPed,
                                              OUTPUT FILL-IN-LugEnt).
                ASSIGN
                    CcbCDocu.LugEnt  = FILL-IN-LugEnt.
                RUN gn/fUbigeo (INPUT Faccpedi.CodDiv,
                                INPUT Faccpedi.CodDoc,
                                INPUT Faccpedi.NroPed,
                                OUTPUT pCodDpto,
                                OUTPUT pCodProv,
                                OUTPUT pCodDist,
                                OUTPUT pCodPos,
                                OUTPUT pZona,
                                OUTPUT pSubZona).

                ASSIGN
                    CcbCDocu.CodDpto = pCodDpto
                    CcbCDocu.CodProv = pCodProv
                    CcbCDocu.CodDist = pCodDist.
                /* ************************************************************* */
                /* ************************************************************* */
                /* RHC 22/07/2015 COPIAMOS DATOS DEL TRANSPORTISTA */
                FIND FIRST T-CcbADocu WHERE T-CcbADocu.codcia = s-codcia AND
                    T-CcbADocu.coddiv = Faccpedi.coddiv AND
                    T-CcbADocu.coddoc = Faccpedi.coddoc AND
                    T-CcbADocu.nrodoc = Faccpedi.nroped
                    NO-LOCK NO-ERROR.
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
                    FIND gn-provd WHERE gn-provd.CodCia = pv-codcia AND
                        gn-provd.CodPro = B-ADOCU.Libre_C[9] AND
                        gn-provd.Sede   = B-ADOCU.Libre_C[20] AND
                        CAN-FIND(FIRST gn-prov OF gn-provd NO-LOCK)
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-provd THEN
                        ASSIGN
                        CcbCDocu.CodAge  = gn-provd.CodPro
                        CcbCDocu.CodDpto = gn-provd.CodDept 
                        CcbCDocu.CodProv = gn-provd.CodProv 
                        CcbCDocu.CodDist = gn-provd.CodDist 
                        CcbCDocu.LugEnt2 = gn-provd.DirPro.
                END.
                ASSIGN
                    lCreaHeader = FALSE.
            END.
            /* Detalle */
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU 
                TO Ccbddocu
                ASSIGN
                    CcbDDocu.NroItm = iCountItem
                    Ccbddocu.coddiv = Ccbcdocu.coddiv
                    Ccbddocu.coddoc = Ccbcdocu.coddoc
                    Ccbddocu.nrodoc = Ccbcdocu.nrodoc.                        
            iCountItem = iCountItem + 1.
            IF iCountItem > x-Items_Guias OR LAST-OF(T-DDOCU.NroDoc) THEN DO:
                {vta2/graba-totales-factura-cred.i}
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END.
    END.

    RETURN "OK".

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
  FILL-IN_FchDoc-1 = ADD-INTERVAL(TODAY,-30,'days'). FILL-IN_FchDoc-2 = TODAY.
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
      FILL-IN_Correlativo = FacCorre.Correlativo.
  END.

  RUN Carga-Temporal.

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
  {src/adm/template/snd-list.i "tgre_cmpte_1"}
  {src/adm/template/snd-list.i "CcbCDocu"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "DI-RutaD"}
  {src/adm/template/snd-list.i "tgre_cmpte_2"}

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

