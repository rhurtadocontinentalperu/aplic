&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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

&SCOPED-DEFINE Condicion ( VtaCDocu.CodCia = s-CodCia AND ~
    VtaCDocu.CodDiv = s-CodDiv AND ~
    VtaCDocu.CodPed = "HPK" AND ~
    VtaCDocu.FlgEst = "P" AND ~
    LOOKUP(VtaCDocu.FlgSit, "PC,PE") > 0 )
DEF VAR x-Info AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-12

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaCDocu FacCPedi

/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 VtaCDocu.CodPed VtaCDocu.NroPed ~
FacCPedi.CodDoc FacCPedi.NroPed FacCPedi.CodCli FacCPedi.NomCli ~
x-Info @ VtaCDocu.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH VtaCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = VtaCDocu.CodCia ~
  AND FacCPedi.CodDoc = VtaCDocu.CodRef ~
  AND FacCPedi.NroPed = VtaCDocu.NroRef ~
      AND FacCPedi.FlgEst = "P" ~
 AND LOOKUP(FacCPedi.FlgSit, "TG,T,P,PI,TI") > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH VtaCDocu ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = VtaCDocu.CodCia ~
  AND FacCPedi.CodDoc = VtaCDocu.CodRef ~
  AND FacCPedi.NroPed = VtaCDocu.NroRef ~
      AND FacCPedi.FlgEst = "P" ~
 AND LOOKUP(FacCPedi.FlgSit, "TG,T,P,PI,TI") > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 VtaCDocu FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 VtaCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-12 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-12}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-16 BUTTON-17 BROWSE-12 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-16 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-17 
     LABEL "EXTORNAR" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-12 FOR 
      VtaCDocu, 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 W-Win _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(15)":U
      FacCPedi.CodDoc FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(15)":U WIDTH 10.43
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.14
      FacCPedi.NomCli FORMAT "x(60)":U WIDTH 54.43
      x-Info @ VtaCDocu.Libre_c04 COLUMN-LABEL "Información del Chequeo"
            WIDTH 31.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 24.23
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-16 AT ROW 1 COL 2 WIDGET-ID 2
     BUTTON-17 AT ROW 1 COL 17 WIDGET-ID 4
     BROWSE-12 AT ROW 2.08 COL 2 WIDGET-ID 200
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "EXTORNO DE CHEQUEO"
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
/* BROWSE-TAB BROWSE-12 BUTTON-17 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "INTEGRAL.VtaCDocu,INTEGRAL.FacCPedi WHERE INTEGRAL.VtaCDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "FacCPedi.CodCia = VtaCDocu.CodCia
  AND FacCPedi.CodDoc = VtaCDocu.CodRef
  AND FacCPedi.NroPed = VtaCDocu.NroRef"
     _Where[2]         = "FacCPedi.FlgEst = ""P""
 AND LOOKUP(FacCPedi.FlgSit, ""TG,T,P,PI,TI"") > 0"
     _FldNameList[1]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[2]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.FacCPedi.CodDoc
     _FldNameList[4]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "54.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"x-Info @ VtaCDocu.Libre_c04" "Información del Chequeo" ? ? ? ? ? ? ? ? no ? no no "31.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* EXTORNO DE CHEQUEO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXTORNO DE CHEQUEO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 W-Win
ON CHOOSE OF BUTTON-16 IN FRAME F-Main /* REFRESCAR */
DO:
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-17 W-Win
ON CHOOSE OF BUTTON-17 IN FRAME F-Main /* EXTORNAR */
DO:
  RUN Extornar.
  APPLY 'CHOOSE':U TO BUTTON-16.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON FIND OF Vtacdocu DO:
    x-Info = ''.
    x-Info = "Chequeador: " + ENTRY(1,VtaCDocu.Libre_c04,'|').
    IF NUM-ENTRIES(VtaCDocu.Libre_c04,'|') > 1 THEN x-Info = x-Info + " Fecha: " + ENTRY(2,VtaCDocu.Libre_c04,'|').
    IF NUM-ENTRIES(VtaCDocu.Libre_c04,'|') > 2 THEN x-Info = x-Info + " Hora: " + ENTRY(3,VtaCDocu.Libre_c04,'|').


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
  ENABLE BUTTON-16 BUTTON-17 BROWSE-12 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Bultos W-Win 
PROCEDURE Extorna-Bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

RLOOP:            
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ******************************************************************************* */
    /* Control por O/D */
    /* ******************************************************************************* */
    FOR EACH LogisdChequeo EXCLUSIVE-LOCK WHERE logisdchequeo.CodCia = s-CodCia
        AND logisdchequeo.CodDiv = s-CodDiv
        AND logisdchequeo.CodPed = Vtacdocu.CodPed
        AND logisdchequeo.NroPed = Vtacdocu.NroPed
        BREAK BY logisdchequeo.Etiqueta
        ON ERROR UNDO, THROW:
        IF FIRST-OF(logisdchequeo.Etiqueta) THEN DO:
            /* Control de Los bultos */
            FIND FIRST ControlOD WHERE ControlOD.codcia = s-codcia AND 
                ControlOD.coddoc = faccpedi.coddoc AND 
                ControlOD.nrodoc = faccpedi.nroped AND 
                ControlOD.coddiv = s-coddiv AND
                ControlOD.nroetq = logisdchequeo.Etiqueta EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ControlOD THEN DO:
                pMensaje = "Imposible actualizar la tabla ControlOD".
                UNDO RLOOP, RETURN 'ADM-ERROR'.
            END.
            DELETE ControlOD.
        END.
        DELETE LogisDChequeo.
    END.
    /* ******************************************************************************* */
    /* Control de Bultos */
    /* RHC 31/01/2020 Control del bulto por HPK */
    /* ******************************************************************************* */
    FIND FIRST Ccbcbult WHERE ccbcbult.codcia = s-codcia AND
        ccbcbult.coddiv = s-coddiv AND
        ccbcbult.coddoc = faccpedi.coddoc AND
        ccbcbult.nrodoc = faccpedi.nroped AND
        Ccbcbult.CHR_05 = (Vtacdocu.CodPed + ',' + Vtacdocu.NroPed)     /* <<< OJO <<< */
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcbult THEN DO:
        pMensaje = "Imposible actualizar la tabla Ccbcbult".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    DELETE Ccbcbult.
END.
IF AVAILABLE(LogisDChequeo) THEN RELEASE LogisDChequeo.
IF AVAILABLE(ControlOD) THEN RELEASE ControlOD.
IF AVAILABLE(Ccbcbult) THEN RELEASE Ccbcbult.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extornar W-Win 
PROCEDURE Extornar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Vtacdocu THEN RETURN.

MESSAGE 'Procedemos con el extorno del chequeo?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR rRowid AS ROWID NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEFINE VAR x-codref AS CHAR.    /* O/D */
DEFINE VAR x-nroref AS CHAR.

rRowid = ROWID(Vtacdocu).
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos la HPK */
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="ROWID(Vtacdocu) = rRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE"}
    IF NOT {&Condicion} THEN DO:
        pMensaje = "La HPK ya no está pendiente".
        UNDO, LEAVE.
    END.
    /* ******************************************************************************* */
    /* Estado de la HPK */
    /* ******************************************************************************* */
    ASSIGN 
        Vtacdocu.flgsit = 'PO'.
    /* ******************************************************************************* */
    /* O/D */
    /* ******************************************************************************* */
    x-codref = vtacdocu.codref.
    x-nroref = vtacdocu.nroref.
    /* ******************************************************************************* */
    /* La O/D, OTR */
    /* ******************************************************************************* */
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
        faccpedi.coddoc = x-codref AND
        faccpedi.nroped = x-nroref AND
        FacCPedi.FlgEst = "P" AND 
        FacCPedi.FlgSit = "TG" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pMensaje = "La Orden ya no está pendiente".
        UNDO, LEAVE.
    END.
    /* ******************************************************************************* */
    /* 1ro. Extornamos control de bultos */
    /* ******************************************************************************* */
    RUN Extorna-Bultos (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "No se pudo extornar el control de bultos".
        UNDO, LEAVE.
    END.
    /* ******************************************************************************* */
    /* 2do. Extornamos la Tarea Cerrada */    
    /* ******************************************************************************* */
    FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
        chktareas.coddiv = s-coddiv AND 
        chktareas.coddoc = Vtacdocu.CodPed AND
        chktareas.nroped = Vtacdocu.NroPed
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE chktareas THEN DO:
        pMensaje = "No se pudo actualizar la tarea (ChkTareas)".
        UNDO, LEAVE.
    END.
    ASSIGN 
        chktareas.flgest = "P"
        chktareas.fechafin = TODAY
        chktareas.horafin = STRING(TIME,"HH:MM:SS")
        chktareas.usuariofin = s-user-id.

END.
IF AVAILABLE(ChkTareas) THEN RELEASE ChkTareas.
IF AVAILABLE(Vtacdocu)  THEN RELEASE Vtacdocu.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
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

