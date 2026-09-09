&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'H/R'.
DEF NEW SHARED VAR lh_Handle  AS HANDLE.

DEF NEW SHARED VAR s-Dias-Limite AS INT INIT 3 NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 BUTTON-Atencion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-rut001a-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-rut001b-v3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-rut001c AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-dirutac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-rut001-v3 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Atencion 
     LABEL "Hoja de Atencion al Cliente" 
     SIZE 20 BY 1.12.

DEFINE BUTTON BUTTON-PreHR 
     LABEL "Importar Pre-Hoja de Ruta" 
     SIZE 20 BY 1.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 125 BY 11.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-PreHR AT ROW 16.31 COL 108 WIDGET-ID 6
     BUTTON-Atencion AT ROW 17.38 COL 108 WIDGET-ID 4
     RECT-2 AT ROW 2.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.86 BY 24.5
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "INGRESO DE LA HOJA DE RUTA - TIENDA"
         HEIGHT             = 24.5
         WIDTH              = 128.86
         MAX-HEIGHT         = 25.27
         MAX-WIDTH          = 132.14
         VIRTUAL-HEIGHT     = 25.27
         VIRTUAL-WIDTH      = 132.14
         MAX-BUTTON         = no
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
/* SETTINGS FOR BUTTON BUTTON-PreHR IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-PreHR:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INGRESO DE LA HOJA DE RUTA - TIENDA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INGRESO DE LA HOJA DE RUTA - TIENDA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Atencion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Atencion W-Win
ON CHOOSE OF BUTTON-Atencion IN FRAME F-Main /* Hoja de Atencion al Cliente */
DO:
  RUN dispatch IN h_v-rut001-v3 ('um-imprimir-hoja-de-atencion':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-PreHR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-PreHR W-Win
ON CHOOSE OF BUTTON-PreHR IN FRAME F-Main /* Importar Pre-Hoja de Ruta */
DO:
   RUN Importar-Prehoja.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/*
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}
*/

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
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.54 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv01 ).
       RUN set-position IN h_p-updv01 ( 1.00 , 20.00 ) NO-ERROR.
       RUN set-size IN h_p-updv01 ( 1.42 , 73.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/v-rut001-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-rut001-v3 ).
       RUN set-position IN h_v-rut001-v3 ( 2.73 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.58 , 119.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Fac Bol|Transferencia|Itinerante' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 14.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 10.77 , 105.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-dirutac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-dirutac ).
       RUN set-position IN h_q-dirutac ( 1.00 , 119.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.65 , 8.29 ) */

       /* Links to SmartViewer h_v-rut001-v3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv01 , 'TableIO':U , h_v-rut001-v3 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_v-rut001-v3 ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-dirutac. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-dirutac ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv01 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-rut001-v3 ,
             h_p-updv01 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_v-rut001-v3 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001a-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001a-v3 ).
       RUN set-position IN h_b-rut001a-v3 ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001a-v3 ( 8.81 , 90.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 16.73 , 95.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 5.77 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001a-v3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-rut001a-v3 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001a-v3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001a-v3 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001b-v3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001b-v3 ).
       RUN set-position IN h_b-rut001b-v3 ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001b-v3 ( 8.46 , 58.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 16.81 , 73.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 5.19 , 11.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001b-v3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_b-rut001b-v3 ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001b-v3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001b-v3 ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dist/b-rut001c.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-rut001c ).
       RUN set-position IN h_b-rut001c ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-rut001c ( 6.92 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-3 ).
       RUN set-position IN h_p-updv12-3 ( 17.04 , 89.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-3 ( 5.19 , 11.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-rut001c. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-3 , 'TableIO':U , h_b-rut001c ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-rut001c ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-rut001c ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-3 ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  ENABLE RECT-2 BUTTON-Atencion 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Prehoja W-Win 
PROCEDURE Importar-Prehoja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Ic - 04Oct2017, H/R pendientes NO ADICIONAR, Fernan Oblitas/Harold Segura */
  /* Levantamos la libreria a memoria */
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  RUN dist/dist-librerias PERSISTENT SET hProc.
  RUN HR-Pendiente IN hProc (INPUT s-CodDiv,
                             INPUT s-Dias-Limite,
                             INPUT YES).
  DELETE PROCEDURE hProc.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.


ASSIGN
    input-var-1 = s-coddiv
    input-var-2 = 'PHR'
    input-var-3 = 'P'
    output-var-1 = ?.
RUN lkup/c-pre-hojaruta ('PRE-HOJAS DE RUTA PENDIENTES').
IF output-var-1 = ? THEN RETURN.

DEF BUFFER B-RUTAC FOR di-rutac.
DEF BUFFER B-RUTAG FOR di-rutag.
DEF BUFFER B-RUTAD FOR di-rutad.

DEF VAR pRowid AS ROWID NO-UNDO.

DEF VAR pMensaje AS CHAR INIT '' NO-UNDO.
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND B-RUTAC WHERE ROWID(B-RUTAC) = output-var-1 EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
        pmensaje = 'YA no está disponible la Pre-Hoja de Ruta'.
        UNDO, LEAVE.
    END.
    {lib/lock-genericov21.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA AND FacCorre.CodDiv = S-CODDIV AND FacCorre.CodDoc = S-CODDOC" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Intentos="5"~
        &Mensaje="YES" ~
        &TipoError="DO: ~
        pMensaje = 'Control de Correlativo en uso por otro usuario'. ~
        UNDO, LEAVE. ~
        END" ~
        }

    CREATE DI-RutaC.
    BUFFER-COPY B-RUTAC TO DI-RutaC
        ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P".     /* Pendiente */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pRowid = ROWID(DI-RutaC).
    
    /* Detalle */
    FOR EACH B-RUTAD OF B-RUTAC NO-LOCK:
        CREATE DI-RutaD.
        BUFFER-COPY B-RUTAD TO Di-RutaD
            ASSIGN
            DI-RutaD.CodCia = DI-RutaC.CodCia
            DI-RutaD.CodDiv = DI-RutaC.CodDiv
            DI-RutaD.CodDoc = DI-RutaC.CodDoc
            DI-RutaD.NroDoc = DI-RutaC.NroDoc.
    END.
    FOR EACH B-RUTAG OF B-RUTAC NO-LOCK:
        CREATE DI-RutaG.
        BUFFER-COPY B-RUTAG TO Di-RutaG
            ASSIGN 
            Di-RutaG.CodCia = Di-RutaC.CodCia
            Di-RutaG.CodDiv = Di-RutaC.CodDiv
            Di-RutaG.CodDoc = Di-RutaC.CodDoc
            Di-RutaG.NroDoc = Di-RutaC.NroDoc.
    END.
    ASSIGN B-RUTAC.FlgEst = "C".
END.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(B-RUTAC)  THEN RELEASE B-RUTAC.
IF AVAILABLE(DI-RutaC) THEN RELEASE DI-RutaC.
IF AVAILABLE(DI-RutaG) THEN RELEASE DI-RutaG.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
RUN dispatch IN h_q-dirutac ('open-query':U).
RUN Posiciona-Registro IN h_q-dirutac ( INPUT pRowid ).
RUN INFORMA-ESTADO IN h_p-updv01.
RUN Choose-Update IN h_p-updv01.

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
  lh_handle = THIS-PROCEDURE.
  RUN Procesa-Handle ("Inicializa").
  
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
DEFINE INPUT PARAMETER p-State AS CHAR.

CASE p-State:
    WHEN "Pagina0"  THEN DO:
          RUN select-page(0).
          RUN dispatch IN h_folder ('hide':U).
          BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
          BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      END.
    WHEN "Pagina1"  THEN DO:
        RUN dispatch IN h_folder ('view':U).
        RUN select-page(1).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      END.
    WHEN "Pagina2"  THEN DO:
        RUN select-page(2).
      END.
    WHEN 'pinta-viewer' THEN DO:
        RUN dispatch IN h_v-rut001-v3 ('display-fields':U).
    END.
    WHEN 'disable-header' THEN DO:
        RUN dispatch IN h_p-updv01 ('disable':U).
        RUN dispatch IN h_q-dirutac ('disable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    WHEN 'disable-detail' THEN DO:
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        IF h_b-rut001a-v3 <> ? THEN RUN dispatch IN h_p-updv12 ('disable':U).
        IF h_b-rut001b-v3 <> ? THEN RUN dispatch IN h_p-updv12-2 ('disable':U).
        IF h_b-rut001c <> ? THEN RUN dispatch IN h_p-updv12-3 ('disable':U).
    END.
    WHEN 'enable-header' THEN DO:
        RUN dispatch IN h_p-updv01 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    WHEN 'enable-detail' THEN DO:
        RUN dispatch IN h_p-updv01 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        IF h_b-rut001a-v3 <> ? THEN RUN dispatch IN h_p-updv12 ('enable':U).
        IF h_b-rut001b-v3 <> ? THEN RUN dispatch IN h_p-updv12-2 ('enable':U).
        IF h_b-rut001c <> ? THEN RUN dispatch IN h_p-updv12-3 ('enable':U).
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

