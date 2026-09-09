&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER FACTURA FOR CcbCDocu.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
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

/* Local Variable Definitions ---                                       */
DEF NEW SHARED VAR s-coddiv AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
   MESSAGE "No existen periodos asignados para " skip
            "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
P-LIST = SUBSTRING ( P-LIST , 1, LENGTH(P-LIST) - 1 ).

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
&Scoped-define INTERNAL-TABLES T-CDOCU GN-DIVI

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-CDOCU.CodDiv GN-DIVI.DesDiv ~
T-CDOCU.CodDoc T-CDOCU.NroDoc T-CDOCU.FchDoc T-CDOCU.CodCli T-CDOCU.NomCli ~
T-CDOCU.ImpTot T-CDOCU.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-CDOCU NO-LOCK, ~
      EACH GN-DIVI OF T-CDOCU NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-CDOCU NO-LOCK, ~
      EACH GN-DIVI OF T-CDOCU NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-CDOCU GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-CDOCU
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 GN-DIVI


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-12 FILL-PERIODO-1 F-mes ~
BUTTON-1 fDesde fHasta FILL-IN-FchDoc BUTTON-2 COMBO-BOX-NroSer BROWSE-2 ~
BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-PERIODO-1 F-mes fDesde fHasta ~
FILL-IN-FchDoc COMBO-BOX-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Aplicar Filtros" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "GENERAR NUEVOS COMPROBANTES" 
     SIZE 32 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL "Eliminar Registro" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie de los nuevos Comprobantes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",01,
                     "Febrero",02,
                     "Marzo",03,
                     "Abril",04,
                     "Mayo",05,
                     "Junio",06,
                     "Julio",07,
                     "Agosto",08,
                     "Setiembre",09,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12,
                     "13",14
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-PERIODO-1 AS DECIMAL FORMAT "9999":U INITIAL ? 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE fHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha para los nuevos Comprobantes" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 2.12.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 2.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-CDOCU, 
      GN-DIVI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-CDOCU.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U WIDTH 6.43
      GN-DIVI.DesDiv FORMAT "X(40)":U
      T-CDOCU.CodDoc FORMAT "x(3)":U
      T-CDOCU.NroDoc FORMAT "X(12)":U WIDTH 13
      T-CDOCU.FchDoc FORMAT "99/99/9999":U
      T-CDOCU.CodCli FORMAT "x(11)":U WIDTH 11.72
      T-CDOCU.NomCli FORMAT "x(50)":U
      T-CDOCU.ImpTot FORMAT "->>,>>>,>>9.99":U
      T-CDOCU.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 140 BY 19.81
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-PERIODO-1 AT ROW 1.38 COL 9 COLON-ALIGNED WIDGET-ID 18
     F-mes AT ROW 1.38 COL 27 COLON-ALIGNED HELP
          "Mes Actual" WIDGET-ID 20
     BUTTON-1 AT ROW 1.38 COL 51 WIDGET-ID 28
     fDesde AT ROW 2.35 COL 9 COLON-ALIGNED WIDGET-ID 22
     fHasta AT ROW 2.35 COL 27 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-FchDoc AT ROW 3.5 COL 49 COLON-ALIGNED WIDGET-ID 30
     BUTTON-2 AT ROW 3.69 COL 65 WIDGET-ID 38
     COMBO-BOX-NroSer AT ROW 4.46 COL 49 COLON-ALIGNED WIDGET-ID 36
     BROWSE-2 AT ROW 5.62 COL 3 WIDGET-ID 200
     BUTTON-3 AT ROW 25.62 COL 4 WIDGET-ID 40
     RECT-11 AT ROW 1.19 COL 3 WIDGET-ID 32
     RECT-12 AT ROW 3.31 COL 3 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.85
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
      TABLE: FACTURA B "?" ? INTEGRAL CcbCDocu
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CANJE DE COMPROBANTES RECHAZADOS POR SUNAT"
         HEIGHT             = 25.85
         WIDTH              = 144.29
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-NroSer F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-CDOCU,INTEGRAL.GN-DIVI OF Temp-Tables.T-CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-CDOCU.CodDiv
"T-CDOCU.CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.GN-DIVI.DesDiv
     _FldNameList[3]   = Temp-Tables.T-CDOCU.CodDoc
     _FldNameList[4]   > Temp-Tables.T-CDOCU.NroDoc
"T-CDOCU.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.T-CDOCU.FchDoc
     _FldNameList[6]   > Temp-Tables.T-CDOCU.CodCli
"T-CDOCU.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.T-CDOCU.NomCli
     _FldNameList[8]   = Temp-Tables.T-CDOCU.ImpTot
     _FldNameList[9]   > Temp-Tables.T-CDOCU.SdoAct
"T-CDOCU.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CANJE DE COMPROBANTES RECHAZADOS POR SUNAT */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CANJE DE COMPROBANTES RECHAZADOS POR SUNAT */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN fDesde fHasta FILL-PERIODO-1 F-mes FILL-IN-FchDoc COMBO-BOX-NroSer.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Filtro Aplicado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* GENERAR NUEVOS COMPROBANTES */
DO:
  MESSAGE 'Procedemos con la generación de los nuevos comprobantes?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  ASSIGN fDesde fHasta FILL-PERIODO-1 F-mes FILL-IN-FchDoc COMBO-BOX-NroSer.
  RUN Proceso-Principal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Proceso Concluido'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Eliminar Registro */
DO:
  DEF VAR rRowid AS ROWID NO-UNDO.

  rRowid = ?.
  DEF BUFFER B-CDOCU FOR T-CDOCU.
  IF AVAILABLE T-CDOCU THEN DO:
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(T-CDOCU) NO-LOCK.
      FIND NEXT B-CDOCU NO-LOCK NO-ERROR.
      IF AVAILABLE B-CDOCU THEN rRowid = ROWID(B-CDOCU).
      ELSE DO:
          FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(T-CDOCU) NO-LOCK.
          FIND PREV B-CDOCU NO-LOCK NO-ERROR.
          IF AVAILABLE B-CDOCU THEN rRowid = ROWID(B-CDOCU).
      END.
      DELETE T-CDOCU.
      {&OPEN-QUERY-{&BROWSE-NAME}}
      IF rRowid <> ? THEN REPOSITION {&BROWSE-NAME} TO ROWID rRowid.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSer W-Win
ON VALUE-CHANGED OF COMBO-BOX-NroSer IN FRAME F-Main /* Serie de los nuevos Comprobantes */
DO:
  ASSIGN {&self-name}.
  FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia
      AND FacCorre.NroSer = COMBO-BOX-NroSer
      AND FacCorre.FlgEst = YES 
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre THEN s-CodDiv = FacCorre.CodDiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-mes W-Win
ON VALUE-CHANGED OF F-mes IN FRAME F-Main /* Mes */
DO:
    ASSIGN {&self-name}.
    RUN src\bin\_dateif (F-mes, FILL-PERIODO-1, OUTPUT fDesde, OUTPUT fHasta).
    DISPLAY fDesde fHasta WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fDesde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fDesde W-Win
ON LEAVE OF fDesde IN FRAME F-Main /* Desde */
DO:
  DEF VAR xHasta AS DATE NO-UNDO.
  IF YEAR(INPUT {&self-name}) <> FILL-PERIODO-1
      OR MONTH(INPUT {&self-name}) <> F-mes THEN DO:
      MESSAGE 'Ingrese correctamente la fecha' VIEW-AS ALERT-BOX WARNING.
      RUN src\bin\_dateif (F-mes, FILL-PERIODO-1, OUTPUT fDesde, OUTPUT xHasta).
      DISPLAY fDesde WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fHasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fHasta W-Win
ON LEAVE OF fHasta IN FRAME F-Main /* Hasta */
DO:
    DEF VAR xDesde AS DATE NO-UNDO.
    IF YEAR(INPUT {&self-name}) <> FILL-PERIODO-1
        OR MONTH(INPUT {&self-name}) <> F-mes THEN DO:
        MESSAGE 'Ingrese correctamente la fecha' VIEW-AS ALERT-BOX WARNING.
        RUN src\bin\_dateif (F-mes, FILL-PERIODO-1, OUTPUT xDesde, OUTPUT fHasta).
        DISPLAY fHasta WITH FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-PERIODO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-PERIODO-1 W-Win
ON VALUE-CHANGED OF FILL-PERIODO-1 IN FRAME F-Main /* Periodo */
DO:
    ASSIGN {&self-name}.
    RUN src\bin\_dateif (F-mes, FILL-PERIODO-1, OUTPUT fDesde, OUTPUT fHasta).
    DISPLAY fDesde fHasta WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ePos W-Win 
PROCEDURE Actualiza-ePos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*     RUN sunat\progress-to-ppll-v2 ( INPUT ROWID(FACTURA), OUTPUT pMensaje ). */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.coddiv,
                                    INPUT Ccbcdocu.coddoc,
                                    INPUT Ccbcdocu.nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR grabación de ePos".
        RETURN 'ADM-ERROR'.     /* ROLL-BACK */
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR confirmación de ePos".
        RETURN 'ERROR-EPOS'.     /* EXTORNO */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

EMPTY TEMP-TABLE T-CDOCU.

FOR EACH gn-divi NO-LOCK WHERE GN-DIVI.CodCia = s-codcia,
    EACH Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia
    AND CcbCDocu.CodDiv = GN-DIVI.CodDiv
    AND LOOKUP(CcbCDocu.CodDoc, 'FAC,N/C,N/D') > 0
    AND CcbCDocu.FchDoc >= fDesde
    AND CcbCDocu.FchDoc <= fHasta
    AND CcbCDocu.FlgEst <> "A":
    IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 AND Ccbcdocu.codref <> 'FAC' THEN NEXT.
    FIND FIRST FELogComprobantes OF Ccbcdocu WHERE FELogComprobantes.EstadoSunat <> 1
        NO-LOCK NO-ERROR.
    IF AVAILABLE FELogComprobantes THEN DO:
        CREATE T-CDOCU.
        BUFFER-COPY Ccbcdocu TO T-CDOCU.
    END.
END.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  DISPLAY FILL-PERIODO-1 F-mes fDesde fHasta FILL-IN-FchDoc COMBO-BOX-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-11 RECT-12 FILL-PERIODO-1 F-mes BUTTON-1 fDesde fHasta 
         FILL-IN-FchDoc BUTTON-2 COMBO-BOX-NroSer BROWSE-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-FACTURA W-Win 
PROCEDURE Extorna-FACTURA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        FACTURA.FlgEst = "A".
    /* ACTUALIZAMOS ALMACENES */
    CASE FACTURA.CodDoc:
        WHEN "FAC" OR WHEN "BOL" THEN DO:
            /* Movimientos de Almacén */
            FOR EACH Almcmov WHERE Almcmov.CodCia = FACTURA.codcia
                AND Almcmov.CodRef = FACTURA.coddoc
                AND Almcmov.NroRef = FACTURA.nrodoc
                AND Almcmov.FlgEst <> "A":
                ASSIGN
                    Almcmov.CodRef = B-CDOCU.coddoc
                    Almcmov.NroRef = B-CDOCU.nrodoc
                    Almcmov.CodCli = B-CDOCU.codcli
                    Almcmov.NomRef = B-CDOCU.nomcli.
            END.
            /* Guias de Remisión */
            FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = FACTURA.codcia
                AND CcbCDocu.CodDoc = "G/R"
                AND CcbCDocu.CodRef = FACTURA.coddoc
                AND CcbCDocu.NroRef = FACTURA.nrodoc
                AND CcbCDocu.FlgEst = "F":
                ASSIGN
                    CcbCDocu.CodRef = B-CDOCU.coddoc
                    CcbCDocu.NroRef = B-CDOCU.nrodoc
                    CcbCDocu.CodCli = B-CDOCU.codcli
                    CcbCDocu.DirCli = B-CDOCU.dircli
                    CcbCDocu.RucCli = B-CDOCU.ruccli
                    CcbCDocu.NomCli = B-CDOCU.nomcli.
            END.
        END.
        WHEN "N/C" THEN DO:
        END.
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-FAC-NC-ND W-Win 
PROCEDURE Genera-FAC-NC-ND :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = B-CDOCU.coddoc ~
        AND FacCorre.NroSer = COMBO-BOX-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    ASSIGN
        s-CodDiv = FacCorre.CodDiv.
    DEF VAR pFormato AS CHAR NO-UNDO.
    RUN sunat\p-formato-doc (B-CDOCU.coddoc, OUTPUT pFormato).

    CREATE FACTURA.
    BUFFER-COPY B-CDOCU
        TO FACTURA
        ASSIGN
        FACTURA.CodDiv = FacCorre.CodDiv        /* OJO */
        FACTURA.NroDoc = STRING(FacCorre.NroSer, ENTRY(1,pFormato,'-')) +
                                STRING(FacCorre.Correlativo, ENTRY(2,pFormato,'-'))
        FACTURA.FchDoc = FILL-IN-FchDoc
        /*FACTURA.Usuario= s-user-id*/
        FACTURA.FlgCie = "S"        /* OJO >>> SUNAT */
        FACTURA.FchCie = TODAY
        FACTURA.HorCie = STRING(TIME,'HH:MM:SS')
        FACTURA.NroSal = B-CDOCU.CodDoc + B-CDOCU.NroDoc    /* OJO: EL ORIGEN */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo del comprobante mal registrado o duplicado".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FACTURA.CodCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN
        ASSIGN
        FACTURA.DirCli = gn-clie.dircli
        FACTURA.NomCli = gn-clie.nomcli
        FACTURA.RucCli = gn-clie.ruc.
    FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
        CREATE Ccbddocu.
        BUFFER-COPY B-DDOCU
            TO Ccbddocu
            ASSIGN
            CcbDDocu.CodDiv = FACTURA.CodDiv        /* OJO */
            CcbDDocu.CodCli = FACTURA.CodCli
            CcbDDocu.FchDoc = FACTURA.FchDoc
            CcbDDocu.NroDoc = FACTURA.NroDoc
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo del comprobante mal registrado o duplicado".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
    END.
    /* ACTUALIZAMOS ALMACENES */
    CASE FACTURA.CodDoc:
        WHEN "FAC" OR WHEN "BOL" THEN DO:
            /* Movimientos de Almacén */
            FOR EACH Almcmov WHERE Almcmov.CodCia = B-CDOCU.codcia
                AND Almcmov.CodRef = B-CDOCU.coddoc
                AND Almcmov.NroRef = B-CDOCU.nrodoc
                AND Almcmov.FlgEst <> "A":
                ASSIGN
                    Almcmov.CodRef = FACTURA.coddoc
                    Almcmov.NroRef = FACTURA.nrodoc
                    Almcmov.CodCli = FACTURA.codcli
                    Almcmov.NomRef = FACTURA.nomcli.
            END.
            /* Guias de Remisión */
            FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = B-CDOCU.codcia
                AND CcbCDocu.CodDoc = "G/R"
                AND CcbCDocu.CodRef = B-CDOCU.coddoc
                AND CcbCDocu.NroRef = B-CDOCU.nrodoc
                AND CcbCDocu.FlgEst = "F":
                ASSIGN
                    CcbCDocu.CodRef = FACTURA.coddoc
                    CcbCDocu.NroRef = FACTURA.nrodoc
                    CcbCDocu.CodCli = FACTURA.codcli
                    CcbCDocu.DirCli = FACTURA.dircli
                    CcbCDocu.RucCli = FACTURA.ruccli
                    CcbCDocu.NomCli = FACTURA.nomcli.
            END.
        END.
        WHEN "N/C" THEN DO:
        END.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-IC W-Win 
PROCEDURE Genera-IC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FACTURA.ImpTot = FACTURA.SdoAct THEN RETURN 'OK'.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Correlativo */
    {lib\lock-genericov21.i &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = 'AFE' ~
        AND FacCorre.FlgEst = YES ~
        AND FacCorre.CodDiv = s-CodDiv" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        
    CASE FACTURA.CodDoc:
        WHEN "FAC" OR WHEN "BOL" OR WHEN "N/D" THEN DO:
            CREATE Ccbdcaja.
            ASSIGN
                CcbDCaja.CodCia = FacCorre.codcia
                CcbDCaja.CodDiv = FacCorre.coddiv
                CcbDCaja.CodDoc = FacCorre.CodDoc
                CcbDCaja.NroDoc = STRING(FacCorre.NroSer,'999') + STRING(FacCorre.Correlativo,'999999')
                CcbDCaja.CodCli = FACTURA.codcli
                CcbDCaja.FchDoc = FILL-IN-FchDoc
                CcbDCaja.CodMon = FACTURA.codmon
                CcbDCaja.ImpTot = (FACTURA.ImpTot - FACTURA.SdoAct)
                CcbDCaja.CodRef = FACTURA.coddoc
                CcbDCaja.NroRef = FACTURA.nrodoc
                CcbDCaja.TpoCmb = FACTURA.tpocmb.
        END.
        WHEN "N/C" THEN DO:
            CREATE Ccbdmov.
            ASSIGN
                CCBDMOV.CodCia = FacCorre.codcia
                CCBDMOV.CodDiv = FacCorre.coddiv
                CCBDMOV.CodDoc = FACTURA.coddoc
                CCBDMOV.NroDoc = FACTURA.nrodoc
                CCBDMOV.CodRef = FacCorre.CodDoc
                CCBDMOV.NroRef = STRING(FacCorre.NroSer,'999') + STRING(FacCorre.Correlativo,'999999')
                CCBDMOV.FchDoc = FACTURA.FchDoc
                CCBDMOV.FchMov = FACTURA.FchDoc
                CCBDMOV.HraMov = STRING(TIME,'HH:MM:SS')
                CCBDMOV.CodCli = FACTURA.codcli
                CCBDMOV.CodMon = FACTURA.codmon
                CCBDMOV.ImpTot = (FACTURA.ImpTot - FACTURA.SdoAct)
                CCBDMOV.TpoCmb = FACTURA.tpocmb
                CCBDMOV.usuario= s-user-id.
        END.
    END CASE.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
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
  DO WITH FRAME {&FRAME-NAME} :
     FILL-PERIODO-1:LIST-ITEMS = P-LIST.
     FILL-PERIODO-1:SCREEN-VALUE = ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST).
     FILL-PERIODO-1 = INTEGER(ENTRY(LOOKUP(STRING(YEAR(TODAY)),P-LIST) , P-LIST)).
     F-Mes = MONTH ( TODAY).
     FILL-IN-FchDoc = TODAY.
     COMBO-BOX-NroSer:DELETE(1).
     FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia
         AND FacCorre.FlgEst = YES
         AND FacCorre.ID_Pos = "CONTABILIDAD"
         BREAK BY FacCorre.NroSer:
         IF FIRST-OF(FacCorre.NroSer) THEN DO:
             COMBO-BOX-NroSer:ADD-LAST(STRING(FacCorre.NroSer,'999')).
         END.
     END.
     COMBO-BOX-NroSer = INTEGER(ENTRY(1,COMBO-BOX-NroSer:LIST-ITEMS)).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO FILL-PERIODO-1   IN FRAME {&FRAME-NAME}.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-NroSer IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proceso-Principal W-Win 
PROCEDURE Proceso-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
FOR EACH T-CDOCU TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib\lock-genericov21.i &Tabla="B-CDOCU" ~
        &Condicion="B-CDOCU.CodCia = T-CDOCU.CodCia ~
        AND B-CDOCU.CodDiv = T-CDOCU.coddiv ~
        AND B-CDOCU.CodDoc = T-CDOCU.coddoc ~
        AND B-CDOCU.NroDoc = T-CDOCU.nrodoc" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="DO: ~
        pMensaje = 'NO se pudo bloquear el comprobante ' + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10) + ~
        'No se puede continuar el proceso'. ~
        UNDO RLOOP, LEAVE RLOOP. ~
        END. " ~
        }
    /* Creamos la copia del Comprobante */
    RUN Genera-FAC-NC-ND.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar el nuevo comprobante".
        UNDO, LEAVE.
    END.
    /* Creamos el AFE (Anticipo Factura Electrónica) */
    RUN Genera-IC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "NO se pudo generar el AFE".
        UNDO RLOOP, LEAVE RLOOP.
    END.

    /* ACTUALIZAMOS E-POS */
    RUN Actualiza-ePos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo grabar en el e-pos" .
        pMensaje = pMensaje + CHR(10) + "No se puede continuar con el proceso".
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        RUN Extorna-FACTURA.  /* EXTORNO */
        IF pMensaje = "" THEN pMensaje = "ERROR: No se pudo confirmar el comprobante en el e-pos" .
        pMensaje = pMensaje + CHR(10) + "No se puede continuar con el proceso".
        LEAVE RLOOP.
    END.
    /* Marcamos el Comprobante como ANULADO */
    ASSIGN
        B-CDOCU.UsuAnu = s-user-id
        B-CDOCU.FchAnu = TODAY
        B-CDOCU.FlgEst = "A".
    /* Limpiamos temporal */
    DELETE T-CDOCU.
END.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
IF AVAILABLE(B-DDOCU) THEN RELEASE B-DDOCU.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.

IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
{&OPEN-QUERY-{&BROWSE-NAME}}

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
  {src/adm/template/snd-list.i "T-CDOCU"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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

