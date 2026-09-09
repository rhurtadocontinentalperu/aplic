&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tCcbCDocu NO-UNDO LIKE CcbCDocu.



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

DEF TEMP-TABLE Reporte NO-UNDO LIKE Ccbcdocu .

/* CONTROL DE GRE ACTIVAS O NO */
DEF VAR lGRE_ONLINE AS LOG NO-UNDO.

RUN gn/gre-online (OUTPUT lGRE_ONLINE).
IF lGRE_ONLINE = YES THEN DO:
    MESSAGE "Guia de Remisión Electrónica Activa" SKIP (1) 'Acceso Denegado' 
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
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
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tCcbCDocu

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tCcbCDocu.FlgCbd tCcbCDocu.FchDoc ~
tCcbCDocu.CodDoc tCcbCDocu.NroDoc tCcbCDocu.CodCli tCcbCDocu.NomCli ~
tCcbCDocu.CodRef tCcbCDocu.NroRef tCcbCDocu.Glosa tCcbCDocu.LugEnt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 tCcbCDocu.FlgCbd 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-5 tCcbCDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-5 tCcbCDocu
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tCcbCDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tCcbCDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tCcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tCcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-70 COMBO-BOX_NroSer BUTTON-6 BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX_NroSer FILL-IN_FchDoc-1 ~
FILL-IN_FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     LABEL "ANULAR GUIA DE REMISION" 
     SIZE 28 BY 1.88
     FONT 6.

DEFINE VARIABLE COMBO-BOX_NroSer AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Seleccione la serie de la G/R" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidos hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 188 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tCcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tCcbCDocu.FlgCbd COLUMN-LABEL "" FORMAT "yes/no":U VIEW-AS TOGGLE-BOX
      tCcbCDocu.FchDoc FORMAT "99/99/9999":U
      tCcbCDocu.CodDoc FORMAT "x(3)":U
      tCcbCDocu.NroDoc FORMAT "X(12)":U
      tCcbCDocu.CodCli FORMAT "x(11)":U WIDTH 12.43
      tCcbCDocu.NomCli FORMAT "x(50)":U
      tCcbCDocu.CodRef FORMAT "x(3)":U
      tCcbCDocu.NroRef FORMAT "X(12)":U WIDTH 13
      tCcbCDocu.Glosa FORMAT "x(60)":U
      tCcbCDocu.LugEnt FORMAT "x(60)":U WIDTH 4.14
  ENABLE
      tCcbCDocu.FlgCbd
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 188 BY 22.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX_NroSer AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 50
     BUTTON-6 AT ROW 1.81 COL 147 WIDGET-ID 58
     FILL-IN_FchDoc-1 AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 52
     FILL-IN_FchDoc-2 AT ROW 2.88 COL 29 COLON-ALIGNED WIDGET-ID 54
     BROWSE-5 AT ROW 4.23 COL 2 WIDGET-ID 200
     RECT-70 AT ROW 1 COL 2 WIDGET-ID 60
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
      TABLE: tCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ANULAR GUIAS DE REMISION MANUAL"
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
/* BROWSE-TAB BROWSE-5 FILL-IN_FchDoc-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FchDoc-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tCcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tCcbCDocu.FlgCbd
"tCcbCDocu.FlgCbd" "" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   = Temp-Tables.tCcbCDocu.FchDoc
     _FldNameList[3]   = Temp-Tables.tCcbCDocu.CodDoc
     _FldNameList[4]   = Temp-Tables.tCcbCDocu.NroDoc
     _FldNameList[5]   > Temp-Tables.tCcbCDocu.CodCli
"tCcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.tCcbCDocu.NomCli
     _FldNameList[7]   = Temp-Tables.tCcbCDocu.CodRef
     _FldNameList[8]   > Temp-Tables.tCcbCDocu.NroRef
"tCcbCDocu.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = Temp-Tables.tCcbCDocu.Glosa
     _FldNameList[10]   > Temp-Tables.tCcbCDocu.LugEnt
"tCcbCDocu.LugEnt" ? ? "character" ? ? ? ? ? ? no ? no no "4.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANULAR GUIAS DE REMISION MANUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANULAR GUIAS DE REMISION MANUAL */
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
&Scoped-define SELF-NAME tCcbCDocu.FlgCbd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.FlgCbd BROWSE-5 _BROWSE-COLUMN W-Win
ON LEAVE OF tCcbCDocu.FlgCbd IN BROWSE BROWSE-5
DO:
  ASSIGN tCcbcdocu.FlgCbd = LOGICAL(SELF:SCREEN-VALUE).

  /* OJO: Marca/Desmarca todas las G/R relacionadas a la misma FAC */
/*   DEF VAR rRowid AS ROWID NO-UNDO.                                   */
/*                                                                      */
/*   DEF BUFFER btCcbcdocu FOR tCcbcdocu.                               */
/*   IF AVAILABLE tCcbcdocu THEN DO:                                    */
/*       rRowid = ROWID(tCcbcdocu).                                     */
/*       FOR EACH btCcbCDocu WHERE btCcbCDocu.codref = tCcbCDocu.codref */
/*           AND btCcbCDocu.nroref = tCcbCDocu.nroref                   */
/*           AND ROWID(btCcbCDocu) <> rRowid:                           */
/*           btCcbCDocu.FlgCbd = tCcbCDocu.FlgCbd.                      */
/*       END.                                                           */
/*       {&OPEN-QUERY-{&BROWSE-NAME}}                                   */
/*       REPOSITION {&BROWSE-NAME} TO ROWID rRowid NO-ERROR.            */
/*   END.                                                               */
  /* ************************************************************* */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.FlgCbd BROWSE-5 _BROWSE-COLUMN W-Win
ON LEFT-MOUSE-CLICK OF tCcbCDocu.FlgCbd IN BROWSE BROWSE-5
DO:
  APPLY 'LEAVE':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* ANULAR GUIA DE REMISION */
DO:
  ASSIGN
      COMBO-BOX_NroSer FILL-IN_FchDoc-1 FILL-IN_FchDoc-2.

  IF NOT CAN-FIND(FIRST tCcbcdocu WHERE tCcbcdocu.FlgCbd NO-LOCK) THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN validate-delete ( OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = (IF pMensaje > '' THEN pMensaje + CHR(13) + "Proceso Abortado" ELSE "Proceso ABortado").
      MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.


  /* Motivo de anulacion */
/*   DEF VAR cReturnValue AS CHAR NO-UNDO.               */
/*   RUN ccb/d-motanu (INPUT ccbcdocu.codcia,            */
/*                     INPUT ccbcdocu.coddoc,            */
/*                     INPUT ccbcdocu.nrodoc,            */
/*                     INPUT s-user-id,                  */
/*                     OUTPUT cReturnValue).             */
/*   IF cReturnValue = 'ADM-ERROR' THEN RETURN NO-APPLY. */

  MESSAGE 'Procedemos con la anulación?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  RUN delete-record (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = (IF pMensaje > '' THEN pMensaje + CHR(13) + "Proceso Abortado" ELSE "Proceso ABortado").
      MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_NroSer W-Win
ON VALUE-CHANGED OF COMBO-BOX_NroSer IN FRAME F-Main /* Seleccione la serie de la G/R */
DO:
  ASSIGN {&SELF-NAME}.
  SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-1 W-Win
ON LEAVE OF FILL-IN_FchDoc-1 IN FRAME F-Main /* Emitidos desde */
DO:
    ASSIGN {&SELF-NAME}.
    SESSION:SET-WAIT-STATE('GENERAL').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchDoc-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchDoc-2 W-Win
ON LEAVE OF FILL-IN_FchDoc-2 IN FRAME F-Main /* Emitidos hasta */
DO:
    ASSIGN {&SELF-NAME}.
    SESSION:SET-WAIT-STATE('GENERAL').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON FIND OF Ccbcdocu DO:
   IF Ccbcdocu.tpofac = "A"
       AND Ccbcdocu.flgest = "P"
       AND Ccbcdocu.codref = "FAI"
       AND TRUE <> (Ccbcdocu.nroref > '')
       THEN RETURN ERROR.
   RETURN.
END.

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

EMPTY TEMP-TABLE tCcbcdocu.
FOR EACH CcbCDocu USE-INDEX Llave10 WHERE CcbCDocu.CodCia = s-codcia
    AND CcbCDocu.CodDiv = s-coddiv
    AND CcbCDocu.FchDoc >= FILL-IN_FchDoc-1
    AND CcbCDocu.FchDoc <= FILL-IN_FchDoc-2
    AND CcbCDocu.CodDoc = "G/R"
    AND CcbCDocu.NroDoc BEGINS STRING(COMBO-BOX_NroSer,'999')
    AND CcbCDocu.FlgEst = "F"
    AND CcbCDocu.TpoFac = "A"
    NO-LOCK:
    CREATE tCcbcdocu.
    BUFFER-COPY Ccbcdocu TO tCcbcdocu ASSIGN tCcbcdocu.flgcbd = NO.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-record W-Win 
PROCEDURE delete-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

   DEF VAR pHojRut   AS CHAR.
   DEF VAR pFlgEst-1 AS CHAR.
   DEF VAR pFlgEst-2 AS CHAR.
   DEF VAR pFchDoc   AS DATE.
   DEF VAR iCuenta AS INTE.

   RLOOP:
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
       FOR EACH tCcbcdocu NO-LOCK WHERE tCcbcdocu.FlgCbd ON ERROR UNDO, THROW:
           FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia 
               AND Ccbcdocu.coddoc = tCcbcdocu.coddoc
               AND Ccbcdocu.nrodoc = tCcbcdocu.nrodoc
               NO-LOCK NO-ERROR.
           RUN dist/p-rut002 ( "G/R",
                               Ccbcdocu.coddoc,
                               Ccbcdocu.nrodoc,
                               "",
                               "",
                               "",
                               0,
                               0,
                               OUTPUT pHojRut,
                               OUTPUT pFlgEst-1,     /* de Di-RutaC */
                               OUTPUT pFlgEst-2,     /* de Di-RutaG */
                               OUTPUT pFchDoc).
           IF pHojRut > '' AND pFlgEst-1 <> 'A' THEN DO:
               pMensaje = "NO se puede anular " + tCcbcdocu.coddoc + " " + tCcbcdocu.nrodoc + CHR(13) 
                   +  "Revisar la Hoja de Ruta: " + pHojRut.
               UNDO RLOOP, RETURN "ADM-ERROR".
           END.
           /* **************************************************************************** */
           /* Fecha de Cierre */
           /* **************************************************************************** */
           DEF VAR dFchCie AS DATE.
           RUN gn/fecha-de-cierre (OUTPUT dFchCie).
           IF ccbcdocu.fchdoc <= dFchCie THEN DO:
               pMensaje = 'NO se puede anular ningún documento antes del ' +  STRING((dFchCie + 1),'99/99/9999').
               RETURN 'ADM-ERROR'.
           END.

           /* Anulamos guia */
           FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
           IF ERROR-STATUS:ERROR THEN DO:
               {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
               UNDO RLOOP, RETURN 'ADM-ERROR'.
           END.
           ASSIGN 
              Ccbcdocu.FlgEst = "A"
              Ccbcdocu.SdoAct = 0
              Ccbcdocu.Glosa  = "A N U L A D O"
              Ccbcdocu.FchAnu = TODAY
              Ccbcdocu.Usuanu = S-USER-ID. 
           /* ANULAMOS TRACKING */
           RUN vtagn/pTracking-04 (Ccbcdocu.CodCia,
                             Ccbcdocu.CodDiv,
                             Ccbcdocu.CodPed,
                             Ccbcdocu.NroPed,
                             s-User-Id,
                             'EGUI',
                             'A',
                             DATETIME(TODAY, MTIME),
                             DATETIME(TODAY, MTIME),
                             Ccbcdocu.coddoc,
                             Ccbcdocu.nrodoc,
                             Ccbcdocu.Libre_C01,
                             Ccbcdocu.Libre_C02).

           /* Anulamos control GRE_CMPBT */
           FIND gre_cmpte WHERE gre_cmpte.coddoc = Ccbcdocu.codref
               AND gre_cmpte.nrodoc = Ccbcdocu.nroref EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
           IF NOT AVAILABLE gre_cmpte AND LOCKED(gre_cmpte) THEN DO:
               {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
               UNDO RLOOP, RETURN 'ADM-ERROR'.
           END.
           IF AVAILABLE gre_cmpte THEN gre_cmpte.estado = "CMPTE GENERADO".     /* Estado Anterior */

           IF AVAILABLE Ccbcdocu THEN RELEASE Ccbcdocu.
           IF AVAILABLE gre_cmpte THEN RELEASE gre_cmpte.
       END.
   END.
   RETURN 'OK'.

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
  DISPLAY COMBO-BOX_NroSer FILL-IN_FchDoc-1 FILL-IN_FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 COMBO-BOX_NroSer BUTTON-6 BROWSE-5 
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
  FILL-IN_FchDoc-1 = ADD-INTERVAL(TODAY,-7,'days').
  FILL-IN_FchDoc-2 = TODAY.
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
  {src/adm/template/snd-list.i "tCcbCDocu"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-delete W-Win 
PROCEDURE validate-delete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
   

   DEFINE VAR RPTA AS CHAR.
   DEF VAR pHojRut   AS CHAR.
   DEF VAR pFlgEst-1 AS CHAR.
   DEF VAR pFlgEst-2 AS CHAR.
   DEF VAR pFchDoc   AS DATE.

   FOR EACH tCcbcdocu NO-LOCK WHERE tCcbcdocu.FlgCbd:
       IF tCcbCDocu.FlgEst = "A" THEN DO:
           pMensaje = 'El documento ' + tCcbcdocu.CodDoc + ' ' + tCcbcdocu.NroDoc + 
               ' se encuentra anulado...'.
           RETURN 'ADM-ERROR'.
       END.
       /* **************************************************************************** */
       /* RHC 23/02/2021 NO anular GR Consolidadas */
       /* **************************************************************************** */
       IF tCcbCDocu.tpofac = "A"
           AND tCcbCDocu.flgest = "P"
           AND tCcbCDocu.codref = "FAI"
           AND TRUE <> (tCcbCDocu.nroref > '')
           THEN DO:
           pMensaje = 'NO se puede anular una GR CONSOLIDADA por esta opción'.
           RETURN 'ADM-ERROR'.
       END.
       /* **************************************************************************** */
       /* **************************************************************************** */
       /* RHC 30/&06/2020 F.O.V. NO anular la G/R si está en una H/R */
       /* **************************************************************************** */
       RUN dist/p-rut002 ( "G/R",
                           tCcbCDocu.coddoc,
                           tCcbCDocu.nrodoc,
                           "",
                           "",
                           "",
                           0,
                           0,
                           OUTPUT pHojRut,
                           OUTPUT pFlgEst-1,     /* de Di-RutaC */
                           OUTPUT pFlgEst-2,     /* de Di-RutaG */
                           OUTPUT pFchDoc).
       IF pHojRut > '' AND pFlgEst-1 <> 'A' THEN DO:
           MESSAGE "NO se puede anular" SKIP "Revisar la Hoja de Ruta:" pHojRut
               VIEW-AS ALERT-BOX ERROR.
           RETURN "ADM-ERROR".
       END.
    /*    IF s-TpoFac = "A" AND tCcbCDocu.FchDoc <> TODAY THEN DO: */
    /*        MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.  */
    /*        RETURN 'ADM-ERROR'.                                 */
    /*    END.                                                    */
       /* **************************************************************************** */
       /* Fecha de Cierre */
       /* **************************************************************************** */
       DEF VAR dFchCie AS DATE.
       RUN gn/fecha-de-cierre (OUTPUT dFchCie).
       IF tCcbCDocu.fchdoc <= dFchCie THEN DO:
           MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
               VIEW-AS ALERT-BOX WARNING.
           RETURN 'ADM-ERROR'.
       END.
   END.

   /* Validamos que se seleccionen todas las guías relacionadas */
   /* Cargamos las facturas relacionadas */
   EMPTY TEMP-TABLE Reporte.
   FOR EACH tCcbcdocu NO-LOCK WHERE tCcbcdocu.FlgCbd:
       FIND Reporte WHERE Reporte.coddoc = tCcbcdocu.codref 
           AND Reporte.nrodoc = tCcbcdocu.nroref
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Reporte THEN DO:
           CREATE Reporte.
           ASSIGN
               Reporte.coddoc = tCcbcdocu.codref
               Reporte.nrodoc = tCcbcdocu.nroref.
       END.
   END.
   FOR EACH Reporte NO-LOCK:
       FOR EACH tCcbcdocu WHERE tCcbcdocu.codref = Reporte.coddoc
           AND tCcbcdocu.nroref = Reporte.nrodoc:
           IF tCcbcdocu.flgcbd = NO THEN DO:
               pMensaje = 'Debe seleccionar todas las Guías de Remisión del comprobante ' +
                   Reporte.coddoc + " " + Reporte.nrodoc.
               RETURN 'ADM-ERROR'.
           END.
       END.
   END.
   /* fin de consistencia */
   RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

