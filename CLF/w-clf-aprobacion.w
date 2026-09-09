&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Clf_Calc_Calculos NO-UNDO LIKE Clf_Calc_Calculos.
DEFINE TEMP-TABLE t-Clf_Calc_Parameters NO-UNDO LIKE Clf_Calc_Parameters.



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

DEFINE IMAGE IMAGE-1 FILENAME "IMG\Coti.ico" SIZE 12 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
    SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
    SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

DEF SHARED VAR s-user-id AS CHAR.


DEFINE VAR hProc AS HANDLE NO-UNDO.

FIND FIRST Clf_Connect NO-LOCK NO-ERROR.
IF NOT AVAILABLE Clf_Connect THEN DO:
    MESSAGE "No se ha configurado los parámetros de conexión a la base de datos".
    RETURN 'ADM-ERROR'.
END.

DEF VAR x-DataBase AS CHAR.
DEF VAR x-LogDataBase AS CHAR.
DEF VAR x-Ip AS CHAR.
DEF VAR x-Service AS CHAR.
DEF VAR x-Protocol AS CHAR.
DEF VAR x-User AS CHAR.
DEF VAR x-Password AS CHAR.

DEF VAR x-Connection AS CHAR.
ASSIGN
    x-Database = Clf_Connect.Clf_DataBase
    x-LogDatabase = Clf_Connect.Clf_LogDataBase
    x-ip = Clf_Connect.Clf_IP
    x-service = Clf_Connect.Clf_Service
    x-protocol = Clf_Connect.Clf_Protocol
    x-user = Clf_Connect.Clf_User
    x-password = Clf_Connect.Clf_Password.

/* Fijamos el nombre de la base de datos */
x-LogDatabase = "continental".

ASSIGN
    x-Connection = "-db " + x-database + " " +
    "-ld " + x-logdatabase + " " +
    "-H " + x-ip + " " +
    "-S " + x-service + " " +
    "-U " + x-user + " " +
    "-P " + x-password.

CONNECT VALUE(x-connection) NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    MESSAGE "No se pudo conectar a la base de datos" + CHR(10) +
        "Revisar los parámetros de conexión".
    RETURN 'ADM-ERROR'.
END.

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Aprobar BUTTON-Search 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-clf_temp_calculos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-clf_temp_parameters AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Aprobar 
     LABEL "APROBAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Search 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 2" 
     SIZE 6 BY 1.62 TOOLTIP "Buscar Artículo".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Aprobar AT ROW 1.27 COL 165 WIDGET-ID 2
     BUTTON-Search AT ROW 8.27 COL 186 WIDGET-ID 4
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
   Temp-Tables and Buffers:
      TABLE: t-Clf_Calc_Calculos T "?" NO-UNDO integral Clf_Calc_Calculos
      TABLE: t-Clf_Calc_Parameters T "?" NO-UNDO integral Clf_Calc_Parameters
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "MANTENIMIENTO / APROBACION PRE-CALCULO"
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

{src/adm-vm/method/vmviewer.i}
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
ON END-ERROR OF W-Win /* MANTENIMIENTO / APROBACION PRE-CALCULO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MANTENIMIENTO / APROBACION PRE-CALCULO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  RUN clf/clf_continental_library PERSISTENT SET hProc.
  RUN Disconnect_Continental IN hProc.
  DELETE PROCEDURE hProc.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aprobar W-Win
ON CHOOSE OF BUTTON-Aprobar IN FRAME F-Main /* APROBAR */
DO:
  DEF VAR pRowid AS ROWID NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN Capture-Rowid IN h_b-clf_temp_parameters ( OUTPUT pRowid /* ROWID */).
  IF pRowid = ? THEN RETURN NO-APPLY.

  MESSAGE 'Se va a proceder con la aprobación' SKIP
      'Continuamos?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN DO:
      RETURN NO-APPLY.
  END.

  RUN clf/clf_continental_library PERSISTENT SET hProc.

/*   RUN Connect_Continental IN hProc (OUTPUT pMensaje).                   */
/*   IF ERROR-STATUS:ERROR = YES THEN DO:                                  */
/*       DELETE PROCEDURE hProc.                                           */
/*       IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING. */
/*       RETURN NO-APPLY.                                                  */
/*   END.                                                                  */

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Aprobar (INPUT pRowid, OUTPUT pMensaje).
  SESSION:SET-WAIT-STATE('').
  IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
  ELSE MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  RUN dispatch IN h_b-clf_temp_parameters ('open-query':U).
  
/*   RUN Disconnect_Continental IN hProc. */

  DELETE PROCEDURE hProc.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Search
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Search W-Win
ON CHOOSE OF BUTTON-Search IN FRAME F-Main /* Button 2 */
DO:
  RUN Captura-Llaves IN h_b-clf_temp_parameters
    ( OUTPUT input-var-1 /* CHARACTER */,
      OUTPUT input-var-2 /* CHARACTER */).
  IF TRUE <> (input-var-1 > '') OR TRUE <> (input-var-2 > '') THEN RETURN NO-APPLY.
  RUN clf/c-clf_temp_calculos.w('Artículo').
  IF output-var-1 <> ? THEN DO:
      RUN Posiciona-Registro IN h_b-clf_temp_calculos ( INPUT output-var-1 /* ROWID */).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

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
             INPUT  'aplic/clf/b-clf_temp_parameters.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-clf_temp_parameters ).
       RUN set-position IN h_b-clf_temp_parameters ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-clf_temp_parameters ( 6.69 , 163.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/clf/b-clf_temp_calculos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-clf_temp_calculos ).
       RUN set-position IN h_b-clf_temp_calculos ( 8.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-clf_temp_calculos ( 16.96 , 184.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 25.23 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-clf_temp_calculos. */
       RUN add-link IN adm-broker-hdl ( h_b-clf_temp_parameters , 'Record':U , h_b-clf_temp_calculos ).
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_b-clf_temp_calculos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-clf_temp_parameters ,
             BUTTON-Aprobar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-clf_temp_calculos ,
             BUTTON-Aprobar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             BUTTON-Search:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar W-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

EMPTY TEMP-TABLE t-Clf_Calc_Parameters.
EMPTY TEMP-TABLE t-Clf_Calc_Calculos.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1) Bloqueamos cabecera */
    DISPLAY "Preparando información " @ Fi-Mensaje WITH FRAME F-Proceso.
    FIND Clf_Temp_Parameters WHERE ROWID(Clf_Temp_Parameters) = pRowid
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        HIDE FRAME F-Proceso.
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* 2) Pasamos informacion de la cabecera y detalle a las tablas temporales */
    CREATE t-Clf_Calc_Parameters.
    BUFFER-COPY Clf_Temp_Parameters TO t-Clf_Calc_Parameters NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        HIDE FRAME F-Proceso.
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH Clf_Temp_Calculos EXCLUSIVE-LOCK WHERE 
        Clf_Temp_Calculos.Id_Agrupador = Clf_Temp_Parameters.Id_Agrupador AND 
        Clf_Temp_Calculos.Id_Periodo = Clf_Temp_Parameters.Id_Periodo
        ON ERROR UNDO, THROW:
        CREATE t-Clf_Calc_Calculos.
        BUFFER-COPY Clf_Temp_Calculos TO t-Clf_Calc_Calculos NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            HIDE FRAME F-Proceso.
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        DELETE Clf_Temp_Calculos.
    END.
    DELETE Clf_Temp_Parameters.
    /* 3) Pasamos temporales a las tablas finales */
    DISPLAY "Actualizando información " @ Fi-Mensaje WITH FRAME F-Proceso.
    FIND FIRST t-Clf_Calc_Parameters NO-LOCK.
    CREATE Clf_Calc_Parameters.
    BUFFER-COPY t-Clf_Calc_Parameters 
        TO Clf_Calc_Parameters 
        ASSIGN
            Clf_Calc_Parameters.Fecha_Origen = t-Clf_Calc_Parameters.Ult_Fecha
            Clf_Calc_Parameters.Hora_Origen = t-Clf_Calc_Parameters.Ult_Hora
            Clf_Calc_Parameters.Usuario_Origen = t-Clf_Calc_Parameters.Ult_Usuario
            Clf_Calc_Parameters.Ult_Fecha = TODAY
            Clf_Calc_Parameters.Ult_Hora = STRING(TIME, 'HH:MM:SS')
            Clf_Calc_Parameters.Ult_Usuario = s-user-id
            NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        HIDE FRAME F-Proceso.
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* Definimos los parámetros para actualizar CONTINENTAL.FacTabla */
    FOR EACH t-Clf_Calc_Calculos NO-LOCK ON ERROR UNDO, THROW:
        CREATE Clf_Calc_Calculos.
        BUFFER-COPY t-Clf_Calc_Calculos TO Clf_Calc_Calculos NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            HIDE FRAME F-Proceso.
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        /* Actualizamos CONTINENTAL */
        RUN UPDATE_Continental IN hProc (Clf_Calc_Parameters.Codigo,
                                         Clf_Calc_Parameters.Tipo,
                                         Clf_Calc_Calculos.CodMat,
                                         Clf_Calc_Calculos.Clasificacion,
                                         OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    IF AVAILABLE(Clf_Temp_Parameters) THEN RELEASE Clf_Temp_Parameters.
    IF AVAILABLE(Clf_Temp_Calculos) THEN RELEASE Clf_Temp_Calculos.
    IF AVAILABLE(Clf_Calc_Parameters) THEN RELEASE Clf_Calc_Parameters.
    IF AVAILABLE(Clf_Calc_Calculos) THEN RELEASE Clf_Calc_Calculos.
END.
HIDE FRAME F-Proceso.
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
  ENABLE BUTTON-Aprobar BUTTON-Search 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'Disable-Buttons' THEN DO:
        DISABLE  BUTTON-Aprobar BUTTON-Search WITH FRAME {&FRAME-NAME} .
    END.
    WHEN 'Enable-Buttons' THEN DO:
        ENABLE  BUTTON-Aprobar BUTTON-Search WITH FRAME {&FRAME-NAME} .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Update_Continental W-Win 
PROCEDURE Update_Continental :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

