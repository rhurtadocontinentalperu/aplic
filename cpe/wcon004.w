&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEFINE TEMP-TABLE CPEDI LIKE FacCPedi
       INDEX Llave01 AS PRIMARY CodCia NroPed.
DEF TEMP-TABLE tDetalle
    FIELD CodArea LIKE CpeTraSed.CodArea
    FIELD CodPer LIKE CpeTraSed.CodPer
    FIELD Fecha AS DATETIME
    FIELD Estado LIKE CpeTrkTar.Estado
    FIELD Tiempo AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN-NroDoc 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroDoc INFO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "IMG/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE INFO AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 75 BY 11.85 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroDoc AS CHARACTER FORMAT "X(12)":U 
     LABEL "Documento" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1 COL 71 WIDGET-ID 10
     FILL-IN-NroDoc AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 4
     INFO AT ROW 2.62 COL 3 NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 14.31 WIDGET-ID 100.


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
         TITLE              = "CONSULTA DE SITUACION DE DOCUMENTOS"
         HEIGHT             = 14.31
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR EDITOR INFO IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE SITUACION DE DOCUMENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE SITUACION DE DOCUMENTOS */
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
ON LEAVE OF FILL-IN-NroDoc IN FRAME F-Main /* Documento */
OR RETURN OF FILL-IN-NroDoc
    DO:
  ASSIGN {&self-name}.
  IF {&self-name} = '' THEN RETURN.
  RUN Pinta-Información.
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
  DISPLAY FILL-IN-NroDoc INFO 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN-NroDoc 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Información W-Win 
PROCEDURE Pinta-Información :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Buscamos pedido origen del documento */
DEF VAR pCodDoc AS CHAR.
DEF VAR pNroDoc AS CHAR.
DEF VAR pCodPed AS CHAR.
DEF VAR x-Zonas AS CHAR.
DEF VAR x-Tiempo AS CHAR.
DEF VAR k AS INT.

/* RUTINA CON EL SCANNER */
CASE SUBSTRING(FILL-IN-NroDoc,1,1):
WHEN '1' THEN DO:           /* FACTURA */
    ASSIGN
        pNroDoc = SUBSTRING(FILL-IN-NroDoc,2,3) + SUBSTRING(FILL-IN-NroDoc,6,6)
        pCodDoc = 'FAC'.
END.
WHEN '9' THEN DO:           /* G/R */
    ASSIGN
        pNroDoc = SUBSTRING(FILL-IN-NroDoc,2,3) + SUBSTRING(FILL-IN-NroDoc,6,6)
        pCodDoc = 'G/R'.
END.
WHEN '3' THEN DO:           /* BOL */
    ASSIGN
        pNroDoc = SUBSTRING(FILL-IN-NroDoc,2,3) + SUBSTRING(FILL-IN-NroDoc,6,6)
        pCodDoc = 'BOL'.
END.
OTHERWISE DO:
    MESSAGE 'Error en el código de barra' VIEW-AS ALERT-BOX ERROR.
    FILL-IN-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
    APPLY 'entry':u TO FILL-IN-NroDoc.
    RETURN.
END.
END CASE.
FILL-IN-NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = pCodDoc
    AND ccbcdocu.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'Documento' pCodDoc pNroDoc 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry':u TO FILL-IN-NroDoc.
    RETURN.
END.

CASE Ccbcdocu.codped:
    WHEN 'PED' THEN pCodPed = 'O/D'.
    WHEN 'P/M' THEN pCodPed = 'O/M'.
    OTHERWISE RETURN.
END CASE.

/* Informacion base */
DEF VAR iNroItm AS INT.
iNroItm = 0.
FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    iNroItm = iNroItm + 1.
END.

INFO:Screen-Value IN FRAME {&FRAME-NAME} = Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc 
    + ' emitido el día ' + STRING(Ccbcdocu.fchdoc)
    + CHR(10) + 'N° de item(s): ' + TRIM(STRING(iNroItm))
    + CHR(10) + 'Cliente: ' + Ccbcdocu.nomcli
    + CHR(10).

EMPTY TEMP-TABLE CPEDI.
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddoc = pCodPed
    AND Faccpedi.divdes = s-coddiv
    AND Faccpedi.codref = Ccbcdocu.codped
    AND Faccpedi.nroref = Ccbcdocu.nroped
    AND Faccpedi.flgest <> 'A'
    BY Faccpedi.FchPed BY Faccpedi.Hora
    WITH FRAME {&FRAME-NAME}:
    /* Informacion */
    INFO:Screen-Value = INFO:Screen-Value
                        + CHR(10) + 'REFERENCIAS:' 
                        + Faccpedi.codref + ' ' + Faccpedi.nroref 
                        + ' ' + Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /* Cargamos las ZONAS de los productos */
    ASSIGN
        x-Zonas = ''.
    FOR EACH facdpedi OF faccpedi NO-LOCK,
        FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = Facdpedi.codcia
        AND Almmmate.codalm = Facdpedi.almdes
        AND Almmmate.codmat = Facdpedi.codmat,
        FIRST Almtubic OF Almmmate NO-LOCK
        BREAK BY Facdpedi.almdes BY Almtubic.codzona:
        IF FIRST-OF(Facdpedi.AlmDes) OR FIRST-OF(Almtubic.codzona) 
            THEN IF x-Zonas = ''
                THEN x-Zonas = TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
                ELSE x-Zonas = x-Zonas + '|'  + TRIM(Facdpedi.almdes) + ',' + TRIM(Almtubic.codzona).
    END.
    DO k = 1 TO NUM-ENTRIES(x-Zonas, '|'):
        CREATE CPEDI.
        BUFFER-COPY Faccpedi TO CPEDI.
        /* Almacén, División y # de Items */
        ASSIGN
            CPEDI.CodAlm = ENTRY(1, ENTRY(k, x-Zonas, '|'))
            CPEDI.Libre_c04 = ENTRY(2, ENTRY(k, x-Zonas, '|')).
        /* Determinamos Ubicación */
        EMPTY TEMP-TABLE tDetalle.
        FOR LAST CpeTrkTar NO-LOCK WHERE CpeTrkTar.CodCia = s-codcia
            AND CpeTrkTar.CodDiv = s-coddiv
            AND CpeTrkTar.CodOD = Faccpedi.CodDoc
            AND CpeTrkTar.NroOD = Faccpedi.NroPed
            AND CpeTrkTar.CodAlm = CPEDI.CodAlm
            AND CpeTrkTar.CodZona = CPEDI.Libre_c04
            BY CpeTrkTar.Fecha:
            IF CpeTrkTar.FchFin = ? 
            THEN RUN lib/_time-passed (CpeTrkTar.FchInicio, DATETIME(TODAY, MTIME), OUTPUT x-Tiempo).
            ELSE RUN lib/_time-passed (CpeTrkTar.FchInicio, CpeTrkTar.FchFin, OUTPUT x-Tiempo).
            CREATE tDetalle.
            ASSIGN
                tDetalle.CodArea = CpeTrkTar.CodArea
                tDetalle.CodPer  = CpeTrkTar.CodPer
                tDetalle.Fecha   = CpeTrkTar.Fecha
                tDetalle.Estado  = CpeTrkTar.Estado
                CPEDI.Libre_c05  = fNomPer(CpeTrkTar.CodPer)
                tDetalle.Tiempo  = x-Tiempo.
        END.
        CPEDI.Libre_c03 = 'Almacén'.
        FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Asignada' NO-ERROR.
        IF AVAILABLE tDetalle THEN DO:
            /* Tiene una tarea asignada */
            IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Distribución'.
            IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Almacén'.
            IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Chequeo'.
        END.
        ELSE DO:
            FIND LAST tDetalle WHERE tDetalle.Estado = 'Tarea Cerrada' NO-ERROR.
            IF AVAILABLE tDetalle THEN DO:
                /* Tiene una tarea asignada */
                IF tDetalle.CodArea = 'DIS' THEN CPEDI.Libre_c03 = 'Entrega'.
                IF tDetalle.CodArea = 'CHE' THEN CPEDI.Libre_c03 = 'Distribución'.
                IF tDetalle.CodArea = 'ALM' THEN CPEDI.Libre_c03 = 'Chequeo'.
            END.
        END.
        /* Informacion */
        IF AVAILABLE tDetalle THEN DO:
            INFO:Screen-Value = INFO:Screen-Value
                + CHR(10) + CPEDI.CodAlm + ' ' + CPEDI.Libre_c04 + ': '
                + tDetalle.Estado 
                + CHR(10) + 'Trabajador: ' + CPEDI.Libre_c05 
                + ' Tiempo: ' + tDetalle.Tiempo
                + CHR(10) + 'Actualmente se encuentra en la zona de ' + CPEDI.Libre_c03.
        END.
    END.
END.

/* control de H/R */
DEF VAR pCodRef AS CHAR.
DEF VAR pNroRef AS CHAR.
DEF VAR x-Estado AS CHAR.

ASSIGN
    pCodRef = pCodDoc
    pNroRef = pNroDoc.

/* Buscamos las G/R */
CASE pCodDoc:
    WHEN 'FAC' OR WHEN 'BOL' THEN DO:
        FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = "G/R"
            AND Ccbcdocu.coddiv = s-coddiv
            AND Ccbcdocu.codref = pCodDoc
            AND Ccbcdocu.nroref = pNroDoc
            AND Ccbcdocu.flgest <> "A":
            FOR LAST di-rutad NO-LOCK WHERE di-rutad.codcia = s-codcia
                AND di-rutad.coddoc = 'H/R'
                AND di-rutad.coddiv = s-coddiv
                AND di-rutad.codref = Ccbcdocu.coddoc
                AND di-rutad.nroref = Ccbcdocu.nrodoc,
                FIRST di-rutac OF di-rutad BY di-rutac.fchdoc DESC:
                RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).
                INFO:SCREEN-VALUE IN FRAME {&FRAME-NAME} = INFO:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                                        + CHR(10) + 'La ' + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc
                                        + ' en la Hoja de Ruta ' + di-rutac.nrodoc 
                                        + ' se encuentra ' +  LC(x-Estado).
            END.
        END.
    END.
    WHEN 'G/R' THEN DO:
        FOR LAST di-rutad NO-LOCK WHERE di-rutad.codcia = s-codcia
            AND di-rutad.coddoc = 'H/R'
            AND di-rutad.coddiv = s-coddiv
            AND di-rutad.codref = pCodRef
            AND di-rutad.nroref = pNroRef,
            FIRST di-rutac OF di-rutad BY di-rutac.fchdoc DESC:
            RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).
            INFO:SCREEN-VALUE IN FRAME {&FRAME-NAME} = INFO:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                                    + CHR(10) + 'La ' + pCodRef + ' ' + pNroRef
                                    + ' en la Hoja de Ruta ' + di-rutac.nrodoc 
                + ' se encuentra ' +  LC(x-Estado).
        END.
    END.
END CASE.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomPer W-Win 
FUNCTION fNomPer RETURNS CHARACTER
  ( INPUT pCodPer AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND pl-pers WHERE pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers 
      THEN RETURN TRIM(pl-pers.patper) + ' ' + TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    ELSE RETURN ''.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

