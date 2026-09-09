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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-CodPed AS CHAR INIT 'HPK' NO-UNDO.

DEF VAR pUsrChq AS CHAR NO-UNDO.
DEF VAR pZonaPickeo AS CHAR NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.
DEF VAR pSituacion AS LOG NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 FILL-IN-NroPed ~
COMBO-BOX-Situacion Btn_OK Btn_Nuevo BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NroPed FILL-IN-NroRef ~
FILL-IN-Cliente FILL-IN-UsrChq x-NomChq COMBO-BOX-Situacion 

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
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_Nuevo AUTO-GO 
     LABEL "NUEVA HPK" 
     SIZE 19 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "CERRAR HPK" 
     SIZE 19 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-Situacion AS LOGICAL FORMAT "yes/no":U INITIAL YES 
     LABEL "Situación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "TODO OK",yes,
                     "CON OBSERVACION",no
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-ZonaPick AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona de Pickeo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cliente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de HPK" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroRef AS CHARACTER FORMAT "X(256)":U 
     LABEL "# ORDEN" 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UsrChq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY 1 NO-UNDO.

DEFINE VARIABLE x-NomChq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64.72 BY 1.88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64.72 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-NroPed AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-NroRef AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Cliente AT ROW 4.5 COL 2 NO-LABEL WIDGET-ID 18
     FILL-IN-UsrChq AT ROW 6.92 COL 2 NO-LABEL WIDGET-ID 24
     x-NomChq AT ROW 8 COL 2 NO-LABEL WIDGET-ID 28
     COMBO-BOX-ZonaPick AT ROW 9.62 COL 19 COLON-ALIGNED WIDGET-ID 32
     COMBO-BOX-Situacion AT ROW 10.69 COL 19 COLON-ALIGNED WIDGET-ID 34
     Btn_OK AT ROW 12.85 COL 2 WIDGET-ID 38
     Btn_Nuevo AT ROW 12.85 COL 22 WIDGET-ID 42
     BtnDone AT ROW 12.85 COL 57 WIDGET-ID 12
     "Cliente" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.69 COL 2 WIDGET-ID 20
          BGCOLOR 9 FGCOLOR 15 
     "Responsable" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 6.12 COL 2 WIDGET-ID 26
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 3.96 COL 1 WIDGET-ID 22
     RECT-2 AT ROW 6.38 COL 1 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.72 BY 14.38
         FONT 11 WIDGET-ID 100.


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
         TITLE              = "CIERRE DE PICKING DE HPK"
         HEIGHT             = 14.38
         WIDTH              = 64.72
         MAX-HEIGHT         = 32.23
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.23
         VIRTUAL-WIDTH      = 205.72
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
/* SETTINGS FOR COMBO-BOX COMBO-BOX-ZonaPick IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       COMBO-BOX-ZonaPick:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Cliente IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UsrChq IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN x-NomChq IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CIERRE DE PICKING DE HPK */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CIERRE DE PICKING DE HPK */
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


&Scoped-define SELF-NAME Btn_Nuevo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Nuevo W-Win
ON CHOOSE OF Btn_Nuevo IN FRAME F-Main /* NUEVA HPK */
DO:
  RUN Limpia-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* CERRAR HPK */
DO:
  IF TRUE <> (FILL-IN-NroPed:SCREEN-VALUE > '') THEN RETURN.

  ASSIGN FILL-IN-NroPed COMBO-BOX-ZonaPick FILL-IN-UsrChq COMBO-BOX-Situacion.
  IF COMBO-BOX-Situacion = NO THEN DO:
      MESSAGE 'Usted ha seleccionado CON OBSERVACIONES' SKIP
          'La orden NO se va a quedar pendiente hasta que se resuelvan las diferencias' SKIP
          'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
          UPDATE rpta AS LOG.
      IF rpta = NO THEN DO:
          APPLY 'ENTRY':U TO COMBO-BOX-Situacion IN FRAME {&FRAME-NAME}.
          RETURN NO-APPLY.
      END.
  END.
  pUsrChq = FILL-IN-UsrChq.
  pZonaPickeo = COMBO-BOX-ZonaPick.
  pEstado = 'OK'.
  pSituacion = COMBO-BOX-Situacion.

  /* *************************************************************************** */
  pError = "".
  RUN Cierre-de-guia.

  RUN Limpia-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-ZonaPick
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-ZonaPick W-Win
ON VALUE-CHANGED OF COMBO-BOX-ZonaPick IN FRAME F-Main /* Zona de Pickeo */
DO:
    pUsrChq = "".
    pZonaPickeo = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* # de HPK */
OR RETURN OF FILL-IN-NroPed 
DO:
    IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").
    ASSIGN {&SELF-NAME}.
    IF LENGTH(FILL-IN-NroPed) > 12 THEN DO:
        /* Transformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia AND Facdocum.codcta[8] = SUBSTRING(FILL-IN-NroPed,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            IF x-CodPed <> Facdocu.coddoc THEN DO:
                MESSAGE 'NO es un número de HPK' VIEW-AS ALERT-BOX ERROR.
                SELF:SCREEN-VALUE = ''.
                RETURN NO-APPLY.
            END.
            FILL-IN-NroPed = SUBSTRING(FILL-IN-NroPed,4).
            DISPLAY FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ASSIGN FILL-IN-NroPed.
    /* Buscamos Sub-Orden */
    FIND FIRST Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.coddiv = s-CodDiv
        AND Vtacdocu.codped = x-CodPed
        AND Vtacdocu.nroped = FILL-IN-NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
    IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'TP') THEN DO:
        MESSAGE 'El documento NO está pendiente de cierre' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /* *************************************************************************** */
    /* Pintamos data */
    ASSIGN
        FILL-IN-Cliente = Vtacdocu.codcli + ' ' + Vtacdocu.nomcli
        FILL-IN-NroRef = Vtacdocu.nroref
        FILL-IN-UsrChq = Vtacdocu.usrsac.
    DISPLAY FILL-IN-Cliente FILL-IN-NroRef FILL-IN-UsrChq WITH FRAME {&FRAME-NAME}.
    COMBO-BOX-ZonaPick:DELETE(COMBO-BOX-ZonaPick:LIST-ITEMS).
    FOR EACH Almtabla NO-LOCK WHERE almtabla.Tabla = "ZP":
        COMBO-BOX-ZonaPick:ADD-LAST(almtabla.Codigo).
    END.
    APPLY 'LEAVE':U TO FILL-IN-UsrChq.
    {&self-name}:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-UsrChq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-UsrChq W-Win
ON LEAVE OF FILL-IN-UsrChq IN FRAME F-Main
OR RETURN OF FILL-IN-UsrChq
DO:
  DEF VAR pNombre AS CHAR.
  DEF VAR pOrigen AS CHAR.
  RUN logis/p-busca-por-dni (FILL-IN-UsrChq:SCREEN-VALUE,
                             OUTPUT pNombre,
                             OUTPUT pOrigen).
  x-NomCHq:SCREEN-VALUE = pNombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ON 'RETURN':U OF FILL-IN-NroPed
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-guia W-Win 
PROCEDURE Cierre-de-guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR lOrdenLista AS LOG NO-UNDO.
  DEFINE BUFFER b-vtacdocu FOR vtacdocu.
  DEF VAR x-CodRef AS CHAR NO-UNDO.
  DEF VAR x-NroRef AS CHAR NO-UNDO.

  DEFINE VAR lCodCliente AS CHAR INIT "".
  DEFINE VAR lCodDoc AS CHAR INIT "".

  lOrdenLista = YES.    /* Por defecto TODO cerrado */
  pError = "".

  DEF VAR x-Rowid AS ROWID NO-UNDO.
  x-Rowid = ROWID(Vtacdocu).
  CICLO:
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      
      /* Bloqueado el comprobante */
      {lib/lock-genericov3.i
          &Tabla="Vtacdocu"
          &Condicion="ROWID(Vtacdocu) = x-Rowid"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT"
          &Accion="RETRY"
          &Mensaje="NO"
          &txtMensaje="pError"
          &TipoError="UNDO, LEAVE"
          }
      ASSIGN
          x-CodRef = Vtacdocu.codped
          x-NroRef = Vtacdocu.nroped.
      
      /* Volvemos a chequear las condiciones */
      IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'TP') THEN DO:
          pError =  'ERROR ka HPK ya NO está pendiente de Cierre de Pickeo'.
          UNDO, LEAVE CICLO.
      END.
      /* ********************************************************************************* */
      IF pSituacion = NO THEN Vtacdocu.flgsit = 'TX'.       /* Pickeado CON OBSERVACIONES */
      ELSE Vtacdocu.flgsit = 'P'.                           /* Pickeo Cerrado de la SUB-ORDEN */
      ASSIGN 
          Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + pUsrChq
          Vtacdocu.usrsacrecep = s-user-id
          /*Vtacdocu.zonapickeo = pZonaPickeo*/
          Vtacdocu.fchfin = NOW
          Vtacdocu.usuariofin = s-user-id.
      FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK:
          ASSIGN Vtaddocu.CanBase = Vtaddocu.CanPed.
      END.
      
      /* Verificamos si ya se puede cerrar la orden original */
      FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = VtaCDocu.codcia
          AND b-vtacdocu.coddiv = VtaCDocu.coddiv
          AND b-vtacdocu.codped = VtaCDocu.codped      /* HPK */
          AND b-vtacdocu.codref = VtaCDocu.codref      /* O/D OTR */
          AND b-vtacdocu.nroref = VtaCDocu.nroref:
          IF b-vtacdocu.flgsit <> "P" THEN DO:
              lOrdenLista = NO.
              LEAVE.
          END.
      END.
      
      /* Marco la ORDEN como COMPLETADO o FALTANTES */
      x-NroRef = ENTRY(1,FILL-IN-NroPed,'-').
      FOR EACH b-vtacdocu EXCLUSIVE-LOCK WHERE b-vtacdocu.codcia = VtaCDocu.codcia
          AND b-vtacdocu.coddiv = VtaCDocu.coddiv
          AND b-vtacdocu.codped = VtaCDocu.codped
          AND b-vtacdocu.codref = VtaCDocu.codref
          AND b-vtacdocu.nroref = VtaCDocu.nroref ON ERROR UNDO, THROW:
          ASSIGN 
              b-VtacDocu.libre_c05 = IF(lOrdenLista = YES) THEN "COMPLETADO" ELSE "FALTANTES".
      END.
      
      /* RHC 09/05/2020 Si todas las HPK está COMPLETADO => O/D cambiamos FlgSit = "PI" */
      IF lOrdenLista = YES THEN DO:
          /* Marcamos la O/D como PICADO COMPLETO */
          FIND FIRST Faccpedi WHERE FacCPedi.CodCia = Vtacdocu.CodCia AND
              FacCPedi.CodDoc = Vtacdocu.CodRef AND
              FacCPedi.NroPed = Vtacdocu.NroRef
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pError"}
               UNDO CICLO, LEAVE CICLO.
          END.
          ASSIGN
              Faccpedi.FlgSit = "PI".
          RELEASE Faccpedi.
      END.
      IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
      IF AVAILABLE(b-vtacdocu) THEN RELEASE b-vtacdocu.
  END.
/*   /* *************************************************************************** */ */
/*   /* ALERTA */                                                                      */
/*   /* *************************************************************************** */ */
/*   RUN logis/d-alerta-phr-reasign (x-CodRef,  x-NroRef).                             */
/*   /* *************************************************************************** */ */
/*   /* *************************************************************************** */ */
  IF pError > "" THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  RETURN "OK".

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
  DISPLAY FILL-IN-NroPed FILL-IN-NroRef FILL-IN-Cliente FILL-IN-UsrChq x-NomChq 
          COMBO-BOX-Situacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 FILL-IN-NroPed COMBO-BOX-Situacion Btn_OK Btn_Nuevo 
         BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Variables W-Win 
PROCEDURE Limpia-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-Situacion:SCREEN-VALUE = 'YES'.
    COMBO-BOX-ZonaPick:SCREEN-VALUE = ''.
    FILL-IN-Cliente:SCREEN-VALUE = ''.
    FILL-IN-NroPed:SCREEN-VALUE = ''.
    FILL-IN-NroRef:SCREEN-VALUE = ''.
    FILL-IN-UsrChq:SCREEN-VALUE = ''.
    x-NomChq:SCREEN-VALUE = ''.
    FILL-IN-NroPed:SENSITIVE = YES.
    APPLY 'ENTRY':U TO FILL-IN-NroPed.
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
   RUN Limpia-Variables.

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

