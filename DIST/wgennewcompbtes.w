&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CFAC NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-CGR NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-CMOV NO-UNDO LIKE Almcmov.
DEFINE TEMP-TABLE T-CNC NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DFAC NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-DGR NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-DMOV NO-UNDO LIKE Almdmov.
DEFINE TEMP-TABLE T-DNC NO-UNDO LIKE CcbDDocu.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE BUFFER B-ADocu FOR CcbADocu.
DEFINE BUFFER B-CDOCU FOR Ccbcdocu.
DEFINE BUFFER B-DDOCU FOR Ccbddocu.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbDDocu Almmmatg

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 CcbDDocu.NroItm CcbDDocu.codmat ~
Almmmatg.DesMat CcbDDocu.UndVta CcbDDocu.CanDes 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH CcbDDocu ~
      WHERE CcbDDocu.CodCia = s-codcia ~
 AND CcbDDocu.CodDoc = "G/R" ~
 AND CcbDDocu.NroDoc = FILL-IN-NroDoc NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK ~
    BY CcbDDocu.NroItm INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH CcbDDocu ~
      WHERE CcbDDocu.CodCia = s-codcia ~
 AND CcbDDocu.CodDoc = "G/R" ~
 AND CcbDDocu.NroDoc = FILL-IN-NroDoc NO-LOCK, ~
      EACH Almmmatg OF CcbDDocu NO-LOCK ~
    BY CcbDDocu.NroItm INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 CcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 CcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-3 Almmmatg


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN-NroDoc BROWSE-3 ~
COMBO-BOX-SerNC 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroDoc FILL-IN-Codref ~
FILL-IN-NroRef FILL-IN-CodCli FILL-IN-NomCli FILL-IN-DirCli COMBO-BOX-SerNC ~
FILL-IN-NroNC FILL-IN-SerFac FILL-IN-NroFac FILL-IN-SerGR FILL-IN-NroGR 

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
     SIZE 6 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR NUEVOS COMPROBANTES" 
     SIZE 31 BY 1.12.

DEFINE VARIABLE COMBO-BOX-SerNC AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie Nota de Crédito" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Codref AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DirCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Direccion" 
     VIEW-AS FILL-IN 
     SIZE 57 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(15)":U 
     LABEL "Guia de Remisión" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroFac AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroGR AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroNC AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Correlativo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SerFac AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie del Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-SerGR AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie de la G/R" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      CcbDDocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      CcbDDocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U
      CcbDDocu.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 52.43
      CcbDDocu.UndVta COLUMN-LABEL "Unidad" FORMAT "XXXX":U
      CcbDDocu.CanDes FORMAT ">,>>>,>>9.9999":U WIDTH 11.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.04
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.19 COL 81 WIDGET-ID 26
     FILL-IN-NroDoc AT ROW 1.38 COL 14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Codref AT ROW 2.35 COL 14 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-NroRef AT ROW 2.35 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-CodCli AT ROW 3.31 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomCli AT ROW 3.31 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-DirCli AT ROW 4.27 COL 14 COLON-ALIGNED WIDGET-ID 14
     BROWSE-3 AT ROW 5.23 COL 2 WIDGET-ID 200
     COMBO-BOX-SerNC AT ROW 15.54 COL 19 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-NroNC AT ROW 15.54 COL 34 COLON-ALIGNED WIDGET-ID 20
     BUTTON-2 AT ROW 15.62 COL 51 WIDGET-ID 28
     FILL-IN-SerFac AT ROW 16.62 COL 19 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NroFac AT ROW 16.62 COL 34 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-SerGR AT ROW 17.54 COL 19 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-NroGR AT ROW 17.54 COL 34 COLON-ALIGNED WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97.29 BY 17.88
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CFAC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-CGR T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-CMOV T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: T-CNC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DFAC T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-DGR T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-DMOV T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: T-DNC T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 17.88
         WIDTH              = 97.29
         MAX-HEIGHT         = 17.88
         MAX-WIDTH          = 97.29
         VIRTUAL-HEIGHT     = 17.88
         VIRTUAL-WIDTH      = 97.29
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
/* BROWSE-TAB BROWSE-3 FILL-IN-DirCli F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Codref IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroFac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroGR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroNC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SerFac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SerGR IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.CcbDDocu,INTEGRAL.Almmmatg OF INTEGRAL.CcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.CcbDDocu.NroItm|yes"
     _Where[1]         = "CcbDDocu.CodCia = s-codcia
 AND CcbDDocu.CodDoc = ""G/R""
 AND CcbDDocu.NroDoc = FILL-IN-NroDoc"
     _FldNameList[1]   > INTEGRAL.CcbDDocu.NroItm
"CcbDDocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbDDocu.codmat
"CcbDDocu.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "52.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbDDocu.UndVta
"CcbDDocu.UndVta" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbDDocu.CanDes
"CcbDDocu.CanDes" ? ? "decimal" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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


&Scoped-define SELF-NAME FILL-IN-NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroDoc W-Win
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Guia de Remisión */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddiv = s-coddiv
      AND Ccbcdocu.coddoc = 'G/R'
      AND Ccbcdocu.nrodoc = INPUT {&self-name}
      NO-LOCK NO-ERROR.
  /* Filtros */
  IF NOT AVAILABLE Ccbcdocu 
      OR Ccbcdocu.flgest <> "P" 
      OR TODAY - Ccbcdocu.fchdoc <= 2 THEN DO:
      MESSAGE 'Documento NO válido' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* Fin de filtros */
  DISPLAY
      CcbCDocu.CodRef @ FILL-IN-Codref 
      CcbCDocu.NroRef @ FILL-IN-NroRef
      CcbCDocu.CodCli @ FILL-IN-CodCli 
      CcbCDocu.NomCli @ FILL-IN-NomCli 
      CcbCDocu.DirCli @ FILL-IN-DirCli
      WITH FRAME {&FRAME-NAME}.
  /* Otros documentos */
  DISPLAY
      SUBSTRING(CcbCDocu.NroRef,1,3) @ FILL-IN-SerFac
      SUBSTRING(Ccbcdocu.nrodoc,1,3) @ FILL-IN-SerGR
      WITH FRAME {&FRAME-NAME}.
  /* Buscamos correlativos */
  FIND FacCorre WHERE  FacCorre.CodCia = s-codcia
      AND FacCorre.CodDoc = CcbCDocu.CodRef
      AND FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroRef,1,3))
      NO-LOCK.
  DISPLAY FacCorre.Correlativo @ FILL-IN-NroFac WITH FRAME {&FRAME-NAME}.
  FIND FacCorre WHERE  FacCorre.CodCia = s-codcia
      AND FacCorre.CodDoc = CcbCDocu.CodDoc
      AND FacCorre.NroSer = INTEGER(SUBSTRING(CcbCDocu.NroDoc,1,3))
      NO-LOCK.
  DISPLAY FacCorre.Correlativo @ FILL-IN-NroGR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Devolucion W-Win 
PROCEDURE Carga-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CMOV.
EMPTY TEMP-TABLE T-DMOV.

DEF VAR s-codmov AS INT INIT 09 NO-UNDO.

/* Buscamos la Factura */
FIND Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = FILL-IN-Codref 
    AND Ccbcdocu.nrodoc = FILL-IN-NroRef
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu 
    OR Ccbcdocu.flgest <> 'P'
    OR Ccbcdocu.imptot <> Ccbcdocu.sdoact THEN DO:
    MESSAGE 'ERROR en el comprobante:' FILL-IN-Codref FILL-IN-NroRef SKIP
        'Generación abortada'
        VIEW-AS ALERT-BOX ERROR
        TITLE 'CARGA DEVOLUCION'.
END.
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
CREATE T-CMOV.
ASSIGN
    T-CMOV.CodCia = S-CodCia 
    T-CMOV.CodAlm = s-CodAlm
    T-CMOV.TipMov = "I"
    T-CMOV.CodMov = S-CodMov 
    T-CMOV.NroSer = 000
    T-CMOV.FchDoc = TODAY
    T-CMOV.TpoCmb = FacCfgGn.Tpocmb[1]
    T-CMOV.FlgEst = "P"
    T-CMOV.HorRcp = STRING(TIME,"HH:MM:SS")
    T-CMOV.usuario = S-USER-ID
    T-CMOV.NomRef  = Ccbcdocu.nomcli
    T-CMOV.CodRef = FILL-IN-Codref
    T-CMOV.NroRef = FILL-IN-NroRef
    T-CMOV.CodCli = Ccbcdocu.codcli
    T-CMOV.CodMon = Ccbcdocu.codmon
    T-CMOV.CodVen = Ccbcdocu.codven.
/* Devolución TOTAL */
EMPTY TEMP-TABLE T-DMOV.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    CREATE T-DMOV.
    ASSIGN 
        T-DMOV.CodCia = T-CMOV.CodCia 
        T-DMOV.CodAlm = T-CMOV.CodAlm 
        T-DMOV.TipMov = T-CMOV.TipMov 
        T-DMOV.CodMov = T-CMOV.CodMov 
        T-DMOV.NroSer = T-CMOV.NroSer
        T-DMOV.NroDoc = T-CMOV.NroDoc   /* Aún no definido */
        T-DMOV.CodMon = T-CMOV.CodMon 
        T-DMOV.FchDoc = T-CMOV.FchDoc 
        T-DMOV.TpoCmb = T-CMOV.TpoCmb 
        T-DMOV.codmat = Ccbddocu.codmat
        T-DMOV.CanDes = Ccbddocu.CanDes
        T-DMOV.CodUnd = Ccbddocu.UndVta
        T-DMOV.Factor = Ccbddocu.Factor
        T-DMOV.AftIsc = Ccbddocu.AftIsc 
        T-DMOV.AftIgv = Ccbddocu.AftIgv 
        T-DMOV.ImpLin = Ccbddocu.ImpLin - Ccbddocu.ImpDto2
        T-DMOV.PreUni = Ccbddocu.ImpLin / T-DMOV.CanDes
        T-DMOV.HraDoc     = T-CMOV.HorRcp.
    IF T-DMOV.AftIgv = YES THEN T-DMOV.ImpIgv = ROUND(T-DMOV.ImpLin / ( 1 + Ccbcdocu.PorIgv / 100) * Ccbcdocu.PorIgv / 100, 2).
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Nueva-Fac W-Win 
PROCEDURE Carga-Nueva-Fac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE T-CFAC.
EMPTY TEMP-TABLE T-DFAC.

FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = FILL-IN-Codref 
    AND Ccbcdocu.nrodoc = FILL-IN-NroRef
    NO-LOCK.
CREATE T-CFAC.
BUFFER-COPY Ccbcdocu TO T-CFAC
    ASSIGN
    T-CFAC.SdoAct = Ccbcdocu.ImpTot
    T-CFAC.FlgEst = "P"
    T-CFAC.Usuario = s-user-id.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    CREATE T-DFAC.
    BUFFER-COPY Ccbddocu TO T-DFAC.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Nueva-GR W-Win 
PROCEDURE Carga-Nueva-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CGR.
EMPTY TEMP-TABLE T-DGR.

FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = "G/R"
    AND Ccbcdocu.nrodoc = FILL-IN-NroDoc
    NO-LOCK.
CREATE T-CGR.
BUFFER-COPY Ccbcdocu TO T-CGR.
FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
    CREATE T-DGR.
    BUFFER-COPY Ccbddocu TO T-DGR.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Nueva-NC W-Win 
PROCEDURE Carga-Nueva-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CNC.
EMPTY TEMP-TABLE T-DNC.

FIND FIRST T-CMOV.  /* Devolución de Mercadería */
FIND Ccbcdocu WHERE CcbCDocu.CodCia = s-codcia  /* Factura */
    AND CcbCDocu.CodDoc = FILL-IN-Codref
    AND CcbCDocu.NroDoc = FILL-IN-NroRef
    NO-LOCK NO-ERROR.
BUFFER-COPY Ccbcdocu TO T-CNC 
    ASSIGN 
    T-CNC.coddoc = "N/C"
    T-CNC.codref = Ccbcdocu.coddoc
    T-CNC.nroref = Ccbcdocu.nrodoc
    T-CNC.FchVto = TODAY
    T-CNC.FlgEst = "P"
    T-CNC.CndCre = 'D'
    T-CNC.Tipo   = "OFICINA"
    T-CNC.usuario = S-USER-ID
    T-CNC.SdoAct = CcbCDocu.Imptot
    T-CNC.CodAlm = T-CMOV.CodAlm
    T-CNC.CodMov = T-CMOV.CodMov.
ASSIGN
    T-CMOV.FlgEst = "C".
/* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
FIND GN-VEN WHERE gn-ven.codcia = Ccbcdocu.codcia
    AND gn-ven.codven = Ccbcdocu.codven
    NO-LOCK NO-ERROR.
IF AVAILABLE GN-VEN THEN T-CNC.cco = gn-ven.cco.
FOR EACH T-DMOV:
    CREATE T-DNC.
    ASSIGN
        T-DNC.CodCia = T-DMOV.CodCia
        T-DNC.codmat = T-DMOV.codmat
        T-DNC.PreUni = T-DMOV.PreUni
        T-DNC.CanDes = T-DMOV.CanDes
        T-DNC.Factor = T-DMOV.Factor
        T-DNC.ImpIsc = T-DMOV.ImpIsc
        T-DNC.ImpIgv = T-DMOV.ImpIgv
        T-DNC.ImpLin = T-DMOV.ImpLin
        T-DNC.PorDto = T-DMOV.PorDto
        T-DNC.PreBas = T-DMOV.PreBas
        T-DNC.ImpDto = T-DMOV.ImpDto
        T-DNC.AftIgv = T-DMOV.AftIgv
        T-DNC.AftIsc = T-DMOV.AftIsc
        T-DNC.UndVta = T-DMOV.CodUnd
        T-DNC.Por_Dsctos[1] = T-DMOV.Por_Dsctos[1]
        T-DNC.Por_Dsctos[2] = T-DMOV.Por_Dsctos[2]
        T-DNC.Por_Dsctos[3] = T-DMOV.Por_Dsctos[3]
        T-DNC.Flg_factor = T-DMOV.Flg_factor.
    FIND CcbDDocu OF Ccbcdocu WHERE CcbDDocu.CodMat = T-DNC.codMat NO-LOCK NO-ERROR.
    IF AVAILABLE CcbDDocu THEN T-DNC.ImpCto = CcbDDocu.ImpCto * ( ( T-DNC.Candes * T-DNC.Factor ) / (CcbDDocu.Candes * CcbDDocu.Factor) ). 
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
  DISPLAY FILL-IN-NroDoc FILL-IN-Codref FILL-IN-NroRef FILL-IN-CodCli 
          FILL-IN-NomCli FILL-IN-DirCli COMBO-BOX-SerNC FILL-IN-NroNC 
          FILL-IN-SerFac FILL-IN-NroFac FILL-IN-SerGR FILL-IN-NroGR 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN-NroDoc BROWSE-3 COMBO-BOX-SerNC 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Devolucion W-Win 
PROCEDURE Graba-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE S-CODDOC   AS CHAR INITIAL "D/F".
DEFINE VARIABLE S-CODMOV   AS INTEGER.

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA 
    AND FacDocum.CodDoc = S-CODDOC 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
   MESSAGE "Codigo de Documento:" s-CodDoc "NO configurado" VIEW-AS ALERT-BOX ERROR TITLE "DEVOLUCION" .
   RETURN ERROR.
END.
S-CODMOV = FacDocum.CodMov.
FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    AND FacCorre.CodAlm = S-CODALM 
    AND FacCorre.TipMov = 'I' 
    AND FacCorre.CodMov = S-CODMOV 
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Correlativo:" s-CodDoc "NO configurado" VIEW-AS ALERT-BOX ERROR TITLE "DEVOLUCION" .
   RETURN ERROR.
END.

/* Consistencias */
FIND FIRST T-CMOV.
FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA 
    AND  CcbCDocu.CodDoc = T-CMOV.CodRef
    AND  CcbCDocu.NroDoc = T-CMOV.NroRf1
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbCDocu THEN DO:
    MESSAGE "DOCUMENTO:" T-CMOV.codref T-CMOV.nrorf1 "NO EXISTE" VIEW-AS ALERT-BOX ERROR TITLE "DEVOLUCION".
    RETURN ERROR.
END.
IF LOOKUP(CcbCDocu.FlgEst,"C,P") = 0 THEN DO:
    MESSAGE "DOCUMENTO:" T-CMOV.codref T-CMOV.nrorf1 "NO VALIDO" VIEW-AS ALERT-BOX ERROR TITLE "DEVOLUCION".
    RETURN ERROR.
END.
IF CcbCDocu.FlgSit = "D" THEN DO:
    MESSAGE "El documento:" T-CMOV.codref T-CMOV.nrorf1 "ya fue devuelto" VIEW-AS ALERT-BOX ERROR TITLE "DEVOLUCION".
    RETURN ERROR.
END.
/* Fin de consistencias */
/*
  Tabla: "Almacen"
  Condicion: "Almacen.codcia = s-codcia AND Almacen.codalm = s-codalm"
  Bloqueo: "EXCLUSIVE-LOCK (NO-WAIT)"
  Accion: "RETRY" | "LEAVE"
  Mensaje: "YES" | "NO"
  TipoError: "RETURN "ADM-ERROR"" | "RETURN ERROR" |  "NEXT"
*/
DEFINE VARIABLE F-Des AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-Dev AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE C-SIT AS CHARACTER INIT "" NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Control de Correlativos */
    {lib/lock-genericov2.i &Tabla="Almacen" ~
        &Condicion="Almacen.CodCia = S-CODCIA AND Almacen.CodAlm = s-CodAlm" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR"}

    FIND CURRENT FacCorre EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    /* Fin de Control de Correlativos */    
    CREATE Almcmov.
    BUFFER-COPY T-CMOV TO Almcmov
        ASSIGN
        Almcmov.TipMov = "I"
        Almcmov.CodMov = S-CodMov
        Almcmov.NroSer = 000
        Almcmov.NroDoc = Almacen.CorrIng
        Almacen.CorrIng = Almacen.CorrIng + 1
        Almcmov.NroRf2 = STRING(FacCorre.Correlativo,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        Almcmov.FlgEst = "P"
        Almcmov.HorRcp = STRING(TIME,"HH:MM:SS").

    FOR EACH T-DMOV:
        CREATE almdmov.
        BUFFER-COPY T-DMOV TO Almdmov
            ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb .
        RUN ALM\ALMACSTK (ROWID(Almdmov)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN ERROR.
        /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */
        RUN alm/almacpr1 (ROWID(Almdmov), 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN ERROR.
    END.
    /* Actualizamos la Factura */
    FIND CcbCDocu WHERE CcbCDocu.CodCia = S-CODCIA 
        AND  CcbCDocu.CodDoc = Almcmov.CodRef 
        AND  CcbCDocu.NroDoc = Almcmov.NroRf1 
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        FIND FIRST CcbDDocu WHERE CcbDDocu.CodCia = Almcmov.CodCia 
            AND  CcbDDocu.CodDoc = Almcmov.CodRef 
            AND  CcbDDocu.NroDoc = Almcmov.NroRf1 
            AND  CcbDDocu.CodMat = Almdmov.CodMat 
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
        ASSIGN CcbDDocu.CanDev = CcbDDocu.CanDev + Almdmov.CanDes.
    END.
    IF Ccbcdocu.FlgEst <> 'A' THEN DO:
        FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
            F-Des = F-Des + CcbDDocu.CanDes.
            F-Dev = F-Dev + CcbDDocu.CanDev. 
        END.
        IF F-Dev > 0 THEN C-SIT = "P".
        IF F-Des = F-Dev THEN C-SIT = "D".
        ASSIGN CcbCDocu.FlgCon = C-SIT.
    END.
    /* Generamos la N/C por Devolución */
    RUN Graba-Nueva-NC NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Nueva-Fac W-Win 
PROCEDURE Graba-Nueva-Fac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR NO-UNDO.

s-CodDoc = FILL-IN-Codref.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Control de Correlativos */
    {lib/lock-genericov2.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = s-CodDoc ~
            AND FacCorre.NroSer = FILL-IN-SerFac" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR"}
    /* Fin de control de correlativos */
    FIND FIRST T-CFAC.
    CREATE Ccbcdocu.
    BUFFER-COPY T-CFAC TO Ccbcdocu
        ASSIGN
        CcbCDocu.CodDoc = s-coddoc
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
    FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
    IF AVAILABLE gn-convt THEN DO:
        CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
        CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
    END.
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND Ccbadocu WHERE Ccbadocu.codcia = Ccbcdocu.codcia
        AND Ccbadocu.coddiv = Ccbcdocu.coddiv
        AND Ccbadocu.coddoc = Ccbcdocu.codped
        AND Ccbadocu.nrodoc = Ccbcdocu.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
            AND B-ADOCU.coddiv = Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = Ccbcdocu.CodDiv
                B-ADOCU.CodDoc = Ccbcdocu.CodDoc
                B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* ******************************** */
    /* TRACKING FACTURA */
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
    /* Detalle */
    FOR EACH T-DFAC:
        CREATE Ccbddocu.
        BUFFER-COPY T-DFAC TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.CodDiv = CcbcDocu.CodDiv
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.FchDoc = CcbCDocu.FchDoc.
    END.
    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
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
    /* Descarga de Almacen */
    RUN vta2\act_alm (ROWID(CcbCDocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN ERROR.
    /* RHC 25-06-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */           
    RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES). 

    /* GUIA DE REMISION */
    FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(Ccbcdocu) EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
    RUN Graba-Nueva-GR NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Nueva-GR W-Win 
PROCEDURE Graba-Nueva-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR NO-UNDO.

s-CodDoc = "G/R".

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* Control de Correlativos */
    {lib/lock-genericov2.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = s-CodDoc ~
            AND FacCorre.NroSer = FILL-IN-SerGR" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR"}
    /* Fin de control de correlativos */
    FIND FIRST T-CGR.
    CREATE Ccbcdocu.
    BUFFER-COPY T-CGR TO Ccbcdocu
        ASSIGN
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
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND Ccbadocu WHERE Ccbadocu.codcia = B-CDOCU.codcia
        AND Ccbadocu.coddiv = B-CDOCU.coddiv
        AND Ccbadocu.coddoc = B-CDOCU.coddoc
        AND Ccbadocu.nrodoc = B-CDOCU.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Ccbcdocu.codcia
            AND B-ADOCU.coddiv = Ccbcdocu.coddiv
            AND B-ADOCU.coddoc = Ccbcdocu.coddoc
            AND B-ADOCU.nrodoc = Ccbcdocu.nrodoc
            NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
            B-ADOCU.CodDiv = Ccbcdocu.CodDiv
            B-ADOCU.CodDoc = Ccbcdocu.CodDoc
            B-ADOCU.NroDoc = Ccbcdocu.NroDoc.
    END.
    /* DETALLE */
    FOR EACH T-DGR:
        CREATE Ccbddocu.
        BUFFER-COPY T-DGR TO Ccbddocu
            ASSIGN
            Ccbddocu.coddiv = Ccbcdocu.coddiv
            Ccbddocu.coddoc = Ccbcdocu.coddoc
            Ccbddocu.nrodoc = Ccbcdocu.nrodoc.
END.


END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Nueva-NC W-Win 
PROCEDURE Graba-Nueva-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE S-CODDOC   AS CHAR INITIAL 'N/C'.
DEFINE VARIABLE S-NROSER   AS INTEGER.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND 
     FacCorre.NroSer = INTEGER(COMBO-BOX-SerNC) AND
     FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento:" s-coddoc "no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
ASSIGN S-NROSER = FacCorre.NroSer.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND FIRST T-CNC.
    /* Control de Correlativos */
    {lib/lock-genericov2.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~
        AND  FacCorre.CodDoc = S-CODDOC ~
        AND  FacCorre.CodDiv = S-CODDIV ~
        AND  FacCorre.NroSer = s-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN ERROR"}
    /* Fin de control de correlativo */        
    CREATE Ccbcdocu.
    BUFFER-COPY T-CNC TO Ccbcdocu
        ASSIGN
        CcbCDocu.CodDiv = s-coddoc
        CcbCDocu.CodDoc = s-coddoc
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        CcbCDocu.CndCre = 'D'
        CcbCDocu.Tipo   = "OFICINA"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.FlgEst = "P"
        CcbCDocu.SdoAct = CcbCDocu.Imptot
        CcbCDocu.NroPed = STRING(Almcmov.NroDoc)
        CcbCDocu.NroOrd = Almcmov.NroRf2.
    ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN Almcmov.FlgEst = "C".
    /* DETALLE */
    FOR EACH T-DNC:
        CREATE Ccbddocu.
        BUFFER-COPY T-DNC TO Ccbddocu
            ASSIGN
            CcbDDocu.CodCia = CcbCDocu.CodCia 
            CcbDDocu.Coddiv = CcbCDocu.Coddiv 
            CcbDDocu.CodDoc = CcbCDocu.CodDoc 
            CcbDDocu.NroDoc = CcbCDocu.NroDoc.
    END.
    /* TOTALES */
    {vta/graba-totales-abono.i}
    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
    /* ************************************* */
    /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
    RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES).
    /* ************************************************** */
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
      FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
          AND FacCorre.CodDiv = s-coddiv
          AND FacCorre.CodDoc = "N/C"
          AND FacCorre.FlgEst = TRUE
          BY FacCorre.NroSer DESC:
          COMBO-BOX-SerNC:ADD-LAST(STRING(FacCorre.NroSer, '999')).
          COMBO-BOX-SerNC:SCREEN-VALUE = STRING(FacCorre.NroSer, '999').
          FILL-IN-NroNC:SCREEN-VALUE = STRING(FacCorre.Correlativo, '999999').
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-Principal W-Win 
PROCEDURE Rutina-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos todo en archivos temporales y luego grabamos todo */

RUN Carga-Devolucion.
RUN Carga-Nueva-NC.
RUN Carga-Nueva-Fac.
RUN Carga-Nueva-GR.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    RUN Graba-Devolucion NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

    RUN Graba-Nueva-Fac NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
END.
MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

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
  {src/adm/template/snd-list.i "CcbDDocu"}
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

