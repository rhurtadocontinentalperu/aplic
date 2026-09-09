&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
/* El evento dura solo unos días */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-FchIni AS DATE NO-UNDO.
DEF VAR x-FchFin AS DATE NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    IF gn-divi.campo-date[1] <> ? AND gn-divi.campo-date[2] <> ? 
        THEN ASSIGN x-FchIni = gn-divi.campo-date[1] x-FchFin = gn-divi.campo-date[2].
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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-Codigo BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-eventos-control-asistencia AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "BUSCAR POR NOMBRE" 
     SIZE 40 BY 1.35
     FONT 9.

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(15)":U 
     LABEL "Ingrese/Escanee el código del cliente" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.35
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Codigo AT ROW 1.27 COL 49 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.27 COL 77 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15 WIDGET-ID 100.


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
         TITLE              = "REGISTRO DE ASISTENCIA"
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REGISTRO DE ASISTENCIA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REGISTRO DE ASISTENCIA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* BUSCAR POR NOMBRE */
DO:
  DEF VAR pCodCli AS CHAR NO-UNDO.
  RUN web/d-eventos-control-asistencia.w (OUTPUT pCodCli).
  FILL-IN-Codigo:SCREEN-VALUE = pCodCli.
  APPLY 'ENTRY':U TO FILL-IN-Codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Codigo W-Win
ON LEAVE OF FILL-IN-Codigo IN FRAME F-Main /* Ingrese/Escanee el código del cliente */
OR RETURN OF FILL-IN-Codigo DO:
  IF TRUE <> (SELF:SCREEN-VALUE > '') THEN RETURN.

  /* Verificar la Longitud */
  DEFINE VAR x-data AS CHAR.

  x-data = TRIM(SELF:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.
  SELF:SCREEN-VALUE = x-data.

  /* Verificamos si ya fue registrado en ASISTENCIA */
  FIND EvenAsistentes WHERE EvenAsistentes.CodCia = s-codcia AND
      EvenAsistentes.CodDiv = s-coddiv AND
      EvenAsistentes.CodCli = SELF:SCREEN-VALUE AND
      EvenAsistentes.Fecha = TODAY
      NO-LOCK NO-ERROR.
  IF AVAILABLE EvenAsistentes THEN DO:
      MESSAGE 'Ya ha sido registrada su asistencia el día de hoy a las' EvenAsistentes.Hora
          VIEW-AS ALERT-BOX INFORMATION.
      SELF:SCREEN-VALUE = "".
      APPLY "ENTRY":U TO FILL-IN-Codigo.
      RETURN NO-APPLY.
  END.

  /* Registramos la asistencia */
  RUN Rutina-de-Control.

  SELF:SCREEN-VALUE = "".
  APPLY "ENTRY":U TO FILL-IN-Codigo.
  RETURN NO-APPLY.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/web/b-eventos-control-asistencia.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-eventos-control-asistencia ).
       RUN set-position IN h_b-eventos-control-asistencia ( 3.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-eventos-control-asistencia ( 23.69 , 179.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-eventos-control-asistencia ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencia-del-cliente W-Win 
PROCEDURE Consistencia-del-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.
DEF OUTPUT PARAMETER pNomCli AS CHAR.
DEF OUTPUT PARAMETER pDNI AS CHAR.
DEF OUTPUT PARAMETER pRUC AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Origen del Cliente:
1. Invitado
2. Del Maestro de Clientes
3. Del Maestro de Clientes "Nuevos"
*/

/* Caso 1 */
FIND FIRST ExpAsist WHERE ExpAsist.CodCia = s-codcia AND
    ExpAsist.CodDiv = s-coddiv AND
    ExpAsist.CodCli = pCodCli AND 
    ExpAsist.FecPro >= x-FchIni AND
    ExpAsist.FecPro <= x-FchFin AND
    ExpAsist.Estado[2] <> "N"   /* NO estuvo invitado pero se registro su asistencia */
    NO-LOCK NO-ERROR.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
IF AVAILABLE ExpAsist THEN DO:
    /* Se supone que el cliente está correctamente registrado en el maestro de clientes */
    pEstado = "INVITADO".
    pNomCli = ExpAsist.NomCli.
    IF AVAILABLE gn-clie THEN
        ASSIGN
        pNomCli = gn-clie.nomcli
        pDNI = gn-clie.DNI
        pRUC = gn-clie.RUC.
    RETURN.
END.

/* Caso 2 */
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = pCodCli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    IF gn-clie.Flgsit <> "A" THEN DO:
        pMensaje = "Cliente no está activo" + CHR(10) +
            'Comunicarse con el Gestor del Maestro de Clientes'.
        RETURN "ADM-ERROR".
    END.
    /* Domicilio fiscal */
    FIND FIRST Gn-ClieD WHERE Gn-ClieD.CodCia = cl-codcia AND
        Gn-ClieD.CodCli = pCodCli AND
        Gn-ClieD.Sede = "@@@"
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-ClieD THEN DO:
        pMensaje = "Cliente no tiene registrado su domicilio fiscal" + CHR(10) +
            'Comunicarse con el Gestor del Maestro de Clientes'.
        RETURN "ADM-ERROR".
    END.
    IF Gn-ClieD.DomFiscal = NO OR
        TRUE <> (Gn-ClieD.CodDept > '') OR
        TRUE <> (Gn-ClieD.CodProv > '') OR
        TRUE <> (Gn-ClieD.CodDist > '') 
        THEN DO:
        pMensaje = "Cliente tiene mal registrado su domicilio fiscal" + CHR(10) +
            'Comunicarse con el Gestor del Maestro de Clientes'.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        pNomCli = gn-clie.nomcli
        pDNI = gn-clie.DNI
        pRUC = gn-clie.RUC
        pEstado = "NO INVITADO".
    RETURN.
END.

/* Caso 3 */
FIND gn-cliente-potencial WHERE gn-cliente-potencial.CodCia = cl-codcia AND 
    gn-cliente-potencial.CodCli = pCodCli AND
    gn-cliente-potencial.Estado <> "C"
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-cliente-potencial THEN DO:
    pEstado = "NUEVO".
    pNomCli = gn-cliente-potencial.NomCli.
    pDNI = gn-cliente-potencial.DNI.
    pRUC = gn-cliente-potencial.Ruc.
    RETURN.
END.

/* Si todo falla */
pMensaje = 'Cliente ' + pCodCli + ' no registrado' + CHR(10) +
    'Invite al asistente a registrarse como CLIENTE NUEVO'.
RETURN "ADM-ERROR".

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
  DISPLAY FILL-IN-Codigo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Codigo BUTTON-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Cliente W-Win 
PROCEDURE Registra-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       NO se va a registrar el la tabla de ExpAsist los clientes NO INVITADOS
                para no distorsionar el dato
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pEstado AS CHAR.
DEF INPUT PARAMETER pNomCli AS CHAR.
DEF INPUT PARAMETER pDNI AS CHAR.
DEF INPUT PARAMETER pRUC AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pRowid AS ROWID NO-UNDO.

/* Consistencia rápida */
/* Si ya se registró, entonces no se registra nuevamente */
IF CAN-FIND(EvenAsistentes WHERE EvenAsistentes.CodCia = s-codcia AND
            EvenAsistentes.CodDiv = s-coddiv AND
            EvenAsistentes.CodCli = pCodCli AND
            EvenAsistentes.Fecha = TODAY
            NO-LOCK)
    THEN RETURN.

CASE pEstado:
    /* Solo grabamos por compatibilidad */
    WHEN "INVITADO" THEN DO:
        FIND FIRST ExpAsist WHERE ExpAsist.CodCia = s-codcia AND
            ExpAsist.CodDiv = s-coddiv AND
            ExpAsist.CodCli = pCodCli AND 
            ExpAsist.FecPro >= x-FchIni AND
            ExpAsist.FecPro <= x-FchFin NO-LOCK NO-ERROR.
        pRowid = ROWID(ExpAsist).
        {lib/lock-genericov3.i ~
            &Tabla="ExpAsist" ~
            &Condicion="ROWID(ExpAsist) = pRowid" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
            }
        ASSIGN
            ExpAsist.Estado[1]     = 'C'
            ExpAsist.Fecha         = TODAY
            ExpAsist.Hora          = STRING(TIME,"HH:MM") 
            ExpAsist.usuario       = s-user-id
            .
        IF ExpAsist.FecAsi[1] = ? THEN 
            ASSIGN 
            ExpAsist.FecAsi[1]  = TODAY
            ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM").
        ELSE IF ExpAsist.FecAsi[1] = TODAY THEN ExpAsist.HoraAsi[1] = STRING(TIME,"HH:MM").
        ELSE IF ExpAsist.FecAsi[2] = ? THEN 
            ASSIGN 
            ExpAsist.FecAsi[2]  = TODAY
            ExpAsist.HoraAsi[2] = STRING(TIME,"HH:MM").
        ELSE IF ExpAsist.FecAsi[2] = TODAY THEN ExpAsist.HoraAsi[2] = STRING(TIME,"HH:MM").
        ELSE 
            ASSIGN 
                ExpAsist.FecAsi[3]  = TODAY
                ExpAsist.HoraAsi[3] = STRING(TIME,"HH:MM").
        ASSIGN ExpAsist.libre_d05 = "GEN3EROS".
        RELEASE ExpAsist.
    END.
    OTHERWISE DO:
        /* NO se registran clientes NO INVITADOS ni NUEVOS */
        /* La tabla de INVITADOS no se altera */
    END.
END CASE.

/* Grabación */
CREATE EvenAsistentes.
ASSIGN
    /*EvenAsistentes.Asistentes */
    EvenAsistentes.CodCia       = s-codcia 
    EvenAsistentes.CodCli       = pCodCli
    EvenAsistentes.CodDiv       = s-coddiv
    EvenAsistentes.DNI          = pDNI 
    EvenAsistentes.Fecha        = TODAY  
    EvenAsistentes.Hora         = STRING(TIME,"HH:MM")
    EvenAsistentes.NomCli       = pNomCli
    EvenAsistentes.Ruc          = pRuc
    EvenAsistentes.Usuario      = s-user-id
    EvenAsistentes.Estado       = pEstado
    NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
    UNDO, RETURN "ADM-ERROR".
END.

/* Abrimos el query */
RUN dispatch IN h_b-eventos-control-asistencia ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rutina-de-Control W-Win 
PROCEDURE Rutina-de-Control :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia del código del cliente */
DEF VAR pCodCli AS CHAR NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.    /* INVITADO, NO INVITADO, NUEVO */
DEF VAR pNomCli AS CHAR NO-UNDO.
DEF VAR pDNI AS CHAR NO-UNDO.
DEF VAR pRUC AS CHAR NO-UNDO.

pCodCli = FILL-IN-Codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

RUN Consistencia-del-cliente (INPUT pCodCli, 
                              OUTPUT pEstado, 
                              OUTPUT pNomCli,
                              OUTPUT pDNI,
                              OUTPUT pRUC,
                              OUTPUT pMensaje).
IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

RUN Registra-Cliente (INPUT pCodCli, 
                      INPUT pEstado, 
                      INPUT pNomCli,
                      INPUT pDNI,
                      INPUT pRUC,
                      OUTPUT pMensaje).
IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
    RETURN.
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

