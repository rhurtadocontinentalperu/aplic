&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DESTINO FOR DI-RutaC.
DEFINE BUFFER B-ORIGEN FOR DI-RutaC.
DEFINE BUFFER B-RUTAC FOR DI-RutaC.
DEFINE BUFFER B-RUTAD FOR DI-RutaD.



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

DEF VAR pMensaje AS CHAR NO-UNDO.

DEF VAR x-Peso AS DEC FORMAT '>>>,>>9.99' NO-UNDO.
DEF VAR x-Volumen AS DEC FORMAT '>>>,>>9.99' NO-UNDO.
DEF VAR x-Importe AS DEC FORMAT '>>>,>>9.99' NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-Destino

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES B-DESTINO B-ORIGEN

/* Definitions for BROWSE BROWSE-Destino                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Destino B-DESTINO.CodDoc ~
B-DESTINO.NroDoc B-DESTINO.FchDoc B-DESTINO.Observ B-DESTINO.FlgEst ~
fPeso(B-DESTINO.NroDoc) @ x-Peso fImporte(B-DESTINO.NroDoc) @ x-Importe ~
fVolumen(B-DESTINO.NroDoc) @ x-Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Destino 
&Scoped-define QUERY-STRING-BROWSE-Destino FOR EACH B-DESTINO ~
      WHERE B-DESTINO.CodCia = s-codcia ~
 AND B-DESTINO.CodDiv = s-coddiv ~
 AND B-DESTINO.CodDoc = "PHR" ~
 AND B-DESTINO.FchDoc >= (TODAY - 1) ~
 AND LOOKUP(B-DESTINO.FlgEst, "P,C,A") = 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Destino OPEN QUERY BROWSE-Destino FOR EACH B-DESTINO ~
      WHERE B-DESTINO.CodCia = s-codcia ~
 AND B-DESTINO.CodDiv = s-coddiv ~
 AND B-DESTINO.CodDoc = "PHR" ~
 AND B-DESTINO.FchDoc >= (TODAY - 1) ~
 AND LOOKUP(B-DESTINO.FlgEst, "P,C,A") = 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Destino B-DESTINO
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Destino B-DESTINO


/* Definitions for BROWSE BROWSE-Origen                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Origen B-ORIGEN.CodDoc ~
B-ORIGEN.NroDoc B-ORIGEN.FchDoc B-ORIGEN.Observ B-ORIGEN.FlgEst ~
fPeso(B-ORIGEN.NroDoc) @ x-Peso fImporte(B-ORIGEN.NroDoc) @ x-Importe ~
fVolumen(B-ORIGEN.NroDoc) @ x-Volumen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Origen 
&Scoped-define QUERY-STRING-BROWSE-Origen FOR EACH B-ORIGEN ~
      WHERE B-ORIGEN.CodCia = s-codcia ~
 AND B-ORIGEN.CodDiv = s-coddiv ~
 AND B-ORIGEN.CodDoc = "PHR" ~
 AND B-ORIGEN.FlgEst = "PX" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-Origen OPEN QUERY BROWSE-Origen FOR EACH B-ORIGEN ~
      WHERE B-ORIGEN.CodCia = s-codcia ~
 AND B-ORIGEN.CodDiv = s-coddiv ~
 AND B-ORIGEN.CodDoc = "PHR" ~
 AND B-ORIGEN.FlgEst = "PX" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Origen B-ORIGEN
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Origen B-ORIGEN


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-Destino}~
    ~{&OPEN-QUERY-BROWSE-Origen}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-Origen BROWSE-Destino ~
BUTTON-Refrescar BUTTON-Consolidar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImporte W-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Consolidar 
     LABEL "CONSOLIDAR PHR's" 
     SIZE 27 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Destino FOR 
      B-DESTINO SCROLLING.

DEFINE QUERY BROWSE-Origen FOR 
      B-ORIGEN SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Destino W-Win _STRUCTURED
  QUERY BROWSE-Destino NO-LOCK DISPLAY
      B-DESTINO.CodDoc FORMAT "x(3)":U
      B-DESTINO.NroDoc FORMAT "X(9)":U WIDTH 8.14
      B-DESTINO.FchDoc FORMAT "99/99/9999":U
      B-DESTINO.Observ COLUMN-LABEL "Observaciones" FORMAT "x(60)":U
      B-DESTINO.FlgEst FORMAT "x(2)":U
      fPeso(B-DESTINO.NroDoc) @ x-Peso COLUMN-LABEL "Peso kg"
      fImporte(B-DESTINO.NroDoc) @ x-Importe COLUMN-LABEL "Importe"
      fVolumen(B-DESTINO.NroDoc) @ x-Volumen COLUMN-LABEL "Volumen m3"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 69 BY 12.65
         FONT 4
         TITLE "PHR DESTINO" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-Origen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Origen W-Win _STRUCTURED
  QUERY BROWSE-Origen NO-LOCK DISPLAY
      B-ORIGEN.CodDoc FORMAT "x(3)":U
      B-ORIGEN.NroDoc FORMAT "X(9)":U WIDTH 8.14
      B-ORIGEN.FchDoc FORMAT "99/99/9999":U
      B-ORIGEN.Observ COLUMN-LABEL "Observaciones" FORMAT "x(60)":U
      B-ORIGEN.FlgEst FORMAT "x(2)":U
      fPeso(B-ORIGEN.NroDoc) @ x-Peso COLUMN-LABEL "Peso kg"
      fImporte(B-ORIGEN.NroDoc) @ x-Importe COLUMN-LABEL "Importe"
      fVolumen(B-ORIGEN.NroDoc) @ x-Volumen COLUMN-LABEL "Volumen m3"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 69 BY 12.65
         FONT 4
         TITLE "PHR ORIGEN (Selección múltiple)" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-Origen AT ROW 1.27 COL 2 WIDGET-ID 200
     BROWSE-Destino AT ROW 1.27 COL 74 WIDGET-ID 300
     BUTTON-Refrescar AT ROW 14.19 COL 3 WIDGET-ID 2
     BUTTON-Consolidar AT ROW 15.54 COL 3 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 16.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DESTINO B "?" ? INTEGRAL DI-RutaC
      TABLE: B-ORIGEN B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RUTAC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RUTAD B "?" ? INTEGRAL DI-RutaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSOLIDACION DE PHR's"
         HEIGHT             = 16.27
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
/* BROWSE-TAB BROWSE-Origen 1 F-Main */
/* BROWSE-TAB BROWSE-Destino BROWSE-Origen F-Main */
ASSIGN 
       BROWSE-Origen:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Destino
/* Query rebuild information for BROWSE BROWSE-Destino
     _TblList          = "B-DESTINO"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "B-DESTINO.CodCia = s-codcia
 AND B-DESTINO.CodDiv = s-coddiv
 AND B-DESTINO.CodDoc = ""PHR""
 AND B-DESTINO.FchDoc >= (TODAY - 1)
 AND LOOKUP(B-DESTINO.FlgEst, ""P,C,A"") = 0"
     _FldNameList[1]   = Temp-Tables.B-DESTINO.CodDoc
     _FldNameList[2]   > Temp-Tables.B-DESTINO.NroDoc
"B-DESTINO.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.B-DESTINO.FchDoc
     _FldNameList[4]   > Temp-Tables.B-DESTINO.Observ
"B-DESTINO.Observ" "Observaciones" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.B-DESTINO.FlgEst
"B-DESTINO.FlgEst" ? "x(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fPeso(B-DESTINO.NroDoc) @ x-Peso" "Peso kg" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fImporte(B-DESTINO.NroDoc) @ x-Importe" "Importe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fVolumen(B-DESTINO.NroDoc) @ x-Volumen" "Volumen m3" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Destino */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Origen
/* Query rebuild information for BROWSE BROWSE-Origen
     _TblList          = "B-ORIGEN"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "B-ORIGEN.CodCia = s-codcia
 AND B-ORIGEN.CodDiv = s-coddiv
 AND B-ORIGEN.CodDoc = ""PHR""
 AND B-ORIGEN.FlgEst = ""PX"""
     _FldNameList[1]   = Temp-Tables.B-ORIGEN.CodDoc
     _FldNameList[2]   > Temp-Tables.B-ORIGEN.NroDoc
"B-ORIGEN.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "8.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.B-ORIGEN.FchDoc
     _FldNameList[4]   > Temp-Tables.B-ORIGEN.Observ
"B-ORIGEN.Observ" "Observaciones" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.B-ORIGEN.FlgEst
"B-ORIGEN.FlgEst" ? "x(2)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fPeso(B-ORIGEN.NroDoc) @ x-Peso" "Peso kg" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"fImporte(B-ORIGEN.NroDoc) @ x-Importe" "Importe" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"fVolumen(B-ORIGEN.NroDoc) @ x-Volumen" "Volumen m3" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Origen */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSOLIDACION DE PHR's */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSOLIDACION DE PHR's */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Consolidar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Consolidar W-Win
ON CHOOSE OF BUTTON-Consolidar IN FRAME F-Main /* CONSOLIDAR PHR's */
DO:
  IF BROWSE-Origen:NUM-SELECTED-ROWS = 0 THEN DO:
      MESSAGE 'Debe seleccionar al menos un registro en PHR ORIGEN'
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  MESSAGE "Procedemos con la consolidación de PHR's?" VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  IF NOT CAN-FIND(FIRST Faccorre WHERE Faccorre.codcia = s-CodCia AND
                  Faccorre.coddoc = 'HPK' AND
                  Faccorre.coddiv = s-CodDiv AND
                  Faccorre.flgest = YES NO-LOCK)
      THEN DO:
      MESSAGE 'NO está definido el correlativo de HPK para la división' s-coddiv
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN MASTER-TRANSACTION.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  END.
  APPLY "CHOOSE":U TO BUTTON-Refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  {&OPEN-QUERY-BROWSE-Origen}
  {&OPEN-QUERY-BROWSE-Destino}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Destino
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
  ENABLE BROWSE-Origen BROWSE-Destino BUTTON-Refrescar BUTTON-Consolidar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Pasamos B-ORIGEN a B-DESTINO
------------------------------------------------------------------------------*/

RLOOP:
DO WITH FRAME {&FRAME-NAME} TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* NO el mismo origen y destino */
    IF B-ORIGEN.NroDoc = B-DESTINO.NroDoc THEN RETURN 'OK'.
    /* Bloqueamos Registro */
    {lib/lock-genericov3.i ~
        &Tabla="B-RUTAC" ~
        &Condicion="ROWID(B-RUTAC) = ROWID(B-ORIGEN)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* Verificamos su estado */
    IF NOT B-RUTAC.FlgEst = "PX" THEN DO:
        pMensaje = "La PHR ORIGEN" + B-ORIGEN.NroDoc + " YA no es válida".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Pasamos TODO el detalle al DESTINO */
    REPEAT:
        FIND FIRST B-RUTAD OF B-RUTAC NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-RUTAD THEN LEAVE.
        FIND CURRENT B-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE B-RUTAD THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        CREATE DI-RutaD.
        BUFFER-COPY B-RUTAD TO DI-RutaD
            ASSIGN DI-RutaD.NroDoc = B-DESTINO.NroDoc.
        DELETE B-RUTAD.
        /* Actualizamo FlgSit de la referencia */
        IF B-DESTINO.FlgEst = "PX" THEN DO:
            FIND Faccpedi WHERE Faccpedi.codcia = s-CodCia AND
                Faccpedi.coddoc = DI-RutaD.CodRef AND
                Faccpedi.nroped = DI-RutaD.NroRef EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE Faccpedi THEN DO:
                pMensaje = "NO se pudo actualizar la referencia: " + DI-RutaD.CodRef + " " + DI-RutaD.NroRef.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "T" THEN Faccpedi.FlgSit = "TG".
        END.
    END.
    /* Marcamos el ORIGEN como anulado */
    ASSIGN
        B-RUTAC.FlgEst = "A"
        B-RUTAC.Libre_f05 = TODAY
        B-RUTAC.Libre_c05 = s-user-id.
END.
IF AVAILABLE(B-RUTAC) THEN RELEASE B-RUTAC.
IF AVAILABLE(B-RUTAD) THEN RELEASE B-RUTAD.
IF AVAILABLE(DI-RutaD) THEN RELEASE DI-RutaD.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE B-DESTINO THEN RETURN.
pMensaje = ''.
RLOOP:
DO WITH FRAME {&FRAME-NAME} TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Bloqueamos el destino DESTINO */
    {lib/lock-genericov3.i ~
        &Tabla="DI-RutaC" ~
        &Condicion="ROWID(DI-RutaC) = ROWID(B-DESTINO)" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* Verificamos su estado */
    IF LOOKUP(DI-RutaC.FlgEst, "P,C,A") > 0 THEN DO:
        pMensaje = "La PHR DESTINO YA no es válida".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Pasamos cada una de la PHR ORIGEN a su destino */
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO BROWSE-Origen:NUM-SELECTED-ROWS:
        IF BROWSE-Origen:FETCH-SELECTED-ROW(k) THEN DO:
            RUN FIRST-TRANSACTION.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo consolidar la PHR " + B-ORIGEN.NroDoc.
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    /* Generamos las HPK si fuera necesario */
    IF DI-RutaC.FlgEst <> "PX" THEN DO:
        RUN logis/p-genera-solo-hpk (INPUT ROWID(Di-RutaC), OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.
END.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.

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
  {src/adm/template/snd-list.i "B-ORIGEN"}
  {src/adm/template/snd-list.i "B-DESTINO"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImporte W-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-Importe AS DEC NO-UNDO.

    ASSIGN
        x-Importe = 0.   /* Peso */
    FOR EACH DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.NroDoc = pNroDoc.
        ASSIGN
            x-Importe = x-Importe + Di-rutad.Libre_d02.
    END.

  RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso W-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-Peso AS DEC NO-UNDO.

    ASSIGN
        x-Peso = 0.   /* Peso */
    FOR EACH DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.NroDoc = pNroDoc.
        ASSIGN
            x-Peso = x-Peso + Di-rutad.Libre_d01.
    END.

  RETURN x-Peso.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen W-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( INPUT pNroDoc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-Volumen AS DEC NO-UNDO.

    ASSIGN
        x-Volumen = 0.   /* Peso */
    FOR EACH DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.NroDoc = pNroDoc.
        ASSIGN
            x-Volumen = x-Volumen + Di-rutad.ImpCob.
    END.

  RETURN x-Volumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

