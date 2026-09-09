&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-RutaD NO-UNDO LIKE DI-RutaD.



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

/* Nos sirve para definir el origen de la H/R */
DEF NEW SHARED VAR s-HR-Manual AS LOG INIT NO NO-UNDO.

DEF NEW SHARED VAR s-acceso-total AS LOG INIT NO.

DEF INPUT PARAMETER pParametro AS CHAR.
s-acceso-total = LOGICAL(pParametro) NO-ERROR.
IF ERROR-STATUS:ERROR THEN s-acceso-total = NO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'H/R'.
DEF NEW SHARED VAR lh_Handle  AS HANDLE.

DEF BUFFER B-RUTAC FOR di-rutac.
DEF BUFFER B-RUTAD FOR di-rutad.

DEFINE SHARED VARIABLE pRCID AS INT.

DEF TEMP-TABLE T-CREPO NO-UNDO LIKE Almcrepo .

DEF NEW SHARED VAR s-Dias-Limite AS INT INIT 3 NO-UNDO.

/* Definimos si la H/R se va a hacer MANUAL o por IMPORTACION de PHR */
FIND gn-divi WHERE gn-divi.codcia = s-CodCia AND
    gn-divi.coddiv = s-CodDiv NO-LOCK.
CASE gn-divi.Campo-Log[5]:
    WHEN YES THEN s-HR-Manual = NO.     /* CD */
    WHEN NO  THEN s-HR-Manual = YES.    /* TIENDA */
    OTHERWISE s-HR-Manual = YES.    /* TIENDA */
END CASE.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-PreHR BUTTON-Atencion RECT-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-hoja-de-ruta-d AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-hoja-de-ruta-dg AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-hoja-de-ruta-g AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv04 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-dirutac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-hoja-de-ruta AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Atencion 
     LABEL "Hoja de Atencion al Cliente" 
     SIZE 20 BY 1.35.

DEFINE BUTTON BUTTON-PreHR 
     LABEL "Importar Pre-Hoja de Ruta" 
     SIZE 20 BY 1.35.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 141 BY 11.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-PreHR AT ROW 1 COL 93 WIDGET-ID 6
     BUTTON-Atencion AT ROW 1 COL 113 WIDGET-ID 4
     RECT-2 AT ROW 2.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.72 BY 25.46
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RutaD T "?" NO-UNDO INTEGRAL DI-RutaD
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "HOJA DE RUTA - CD"
         HEIGHT             = 25.46
         WIDTH              = 142.72
         MAX-HEIGHT         = 32.23
         MAX-WIDTH          = 205.72
         VIRTUAL-HEIGHT     = 32.23
         VIRTUAL-WIDTH      = 205.72
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* HOJA DE RUTA - CD */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* HOJA DE RUTA - CD */
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
  RUN dispatch IN h_v-hoja-de-ruta ('um-imprimir-hoja-de-atencion':U).
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

lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

CASE s-acceso-total:
    WHEN YES THEN DO:
        {&WINDOW-NAME}:TITLE = 'HOJA DE RUTA SUPERVISOR'.
    END.
    WHEN NO THEN DO:
        {&WINDOW-NAME}:TITLE = 'HOJA DE RUTA'.
    END.
END CASE.

{&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " - " +
                        TRIM(gn-divi.coddiv) + " - " + 
                        GN-DIVI.DesDiv.

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
             INPUT  'adm-vm/objects/p-updv04.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv04 ).
       RUN set-position IN h_p-updv04 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv04 ( 1.42 , 73.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 75.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.54 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/v-hoja-de-ruta.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-hoja-de-ruta ).
       RUN set-position IN h_v-hoja-de-ruta ( 2.73 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.58 , 139.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Fac Bol|Transferencia|Itinerante' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 14.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 11.85 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-dirutac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-dirutac ).
       RUN set-position IN h_q-dirutac ( 1.00 , 135.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.65 , 8.29 ) */

       /* Links to SmartViewer h_v-hoja-de-ruta. */
       RUN add-link IN adm-broker-hdl ( h_p-updv04 , 'TableIO':U , h_v-hoja-de-ruta ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_v-hoja-de-ruta ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-dirutac. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-dirutac ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv04 ,
             BUTTON-PreHR:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_p-updv04 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-hoja-de-ruta ,
             BUTTON-Atencion:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_v-hoja-de-ruta , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/b-hoja-de-ruta-d.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hoja-de-ruta-d ).
       RUN set-position IN h_b-hoja-de-ruta-d ( 16.35 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-hoja-de-ruta-d ( 8.81 , 90.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 17.69 , 95.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 5.65 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-hoja-de-ruta-d. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-hoja-de-ruta-d ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-hoja-de-ruta-d ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hoja-de-ruta-d ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-hoja-de-ruta-d , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/b-hoja-de-ruta-g.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hoja-de-ruta-g ).
       RUN set-position IN h_b-hoja-de-ruta-g ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-hoja-de-ruta-g ( 8.46 , 58.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 17.42 , 63.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 5.12 , 10.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-hoja-de-ruta-g. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_b-hoja-de-ruta-g ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-hoja-de-ruta-g ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hoja-de-ruta-g ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             h_b-hoja-de-ruta-g , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/b-hoja-de-ruta-dg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-hoja-de-ruta-dg ).
       RUN set-position IN h_b-hoja-de-ruta-dg ( 16.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-hoja-de-ruta-dg ( 6.92 , 85.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-3 ).
       RUN set-position IN h_p-updv12-3 ( 16.88 , 90.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-3 ( 5.38 , 11.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-hoja-de-ruta-dg. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-3 , 'TableIO':U , h_b-hoja-de-ruta-dg ).
       RUN add-link IN adm-broker-hdl ( h_q-dirutac , 'Record':U , h_b-hoja-de-ruta-dg ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-hoja-de-ruta-dg ,
             h_folder , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-3 ,
             h_b-hoja-de-ruta-dg , 'AFTER':U ).
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
  ENABLE BUTTON-PreHR BUTTON-Atencion RECT-2 
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

/* ********************************************************************************** */
/* Ic - 04Oct2017, H/R pendientes NO ADICIONAR, Fernan Oblitas/Harold Segura */
/* Levantamos la libreria a memoria */
/* ********************************************************************************** */
/* Buscamos configuración de días */
s-Dias-Limite = 3.  /* Por defecto */
FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
    VtaTabla.Tabla = "CONFIG-HR" AND
    VtaTabla.Llave_c1 = "DIAS-IMPORT-PHR" 
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN s-Dias-Limite = VtaTabla.Valor[1].

IF s-user-id = "ADMIN" THEN s-Dias-Limite = 0.

IF s-Dias-Limite > 0 THEN DO:
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN dist/dist-librerias PERSISTENT SET hProc.

    RUN HR-Pendiente IN hProc (INPUT s-CodDiv,
                               INPUT s-Dias-Limite,
                               INPUT YES).
    DELETE PROCEDURE hProc.
    /*IF s-user-id <> 'ADMIN' THEN IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.*/
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
END.
/* ********************************************************************************** */
/* ********************************************************************************** */
/* Buscamos PHR pendiente*/
/* ********************************************************************************** */
DEF VAR pNroPHR AS CHAR NO-UNDO.    /* Números de PHR separados por comas */
RUN logis/d-selecciona-phr (OUTPUT pNroPHR).
IF NUM-ENTRIES(pNroPHR) = 0 THEN RETURN 'ADM-ERROR'.

DEF VAR k AS INT NO-UNDO.
DO k = 1 TO NUM-ENTRIES(pNroPHR):
    FIND FIRST B-RUTAC WHERE B-RUTAC.codcia = s-CodCia AND
        B-RutaC.CodDiv = s-CodDiv AND
        B-RutaC.CodDoc = "PHR" AND
        B-RutaC.NroDoc = ENTRY(k, pNroPHR) NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-RUTAC OR B-RUTAC.FlgEst <> "P" THEN DO:
        MESSAGE 'YA no está disponible la Pre-Hoja de Ruta' ENTRY(k, pNroPHR) 
            SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.

/* ********************************************************************************** */
/* Importamos la PHR */
/* ********************************************************************************** */
DEF VAR pRowid AS ROWID NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

RUN dist/dist-librerias.r PERSISTENT SET hProc.
SESSION:SET-WAIT-STATE('GENERAL').
RUN Import-PHR-Multiple IN hProc (INPUT pNroPHR, OUTPUT pRowid, OUTPUT pMensaje).
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

IF RETURN-VALUE = "ADM-ERROR" THEN DO:
    IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la H/R".
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
/* ********************************************************************************** */
RUN dispatch IN h_q-dirutac ('open-query':U).
RUN Posiciona-Registro IN h_q-dirutac ( INPUT pRowid ).
RUN INFORMA-ESTADO IN h_p-updv04.
RUN Choose-Update IN h_p-updv04.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Valida W-Win 
PROCEDURE Importar-Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF BUFFER ORDENES FOR Faccpedi.
DEF BUFFER PEDIDO  FOR Faccpedi.

DEF VAR pBloqueados AS INT NO-UNDO.
DEF VAR pTotales AS INT NO-UNDO.

ASSIGN
    pBloqueados = 0
    pTotales = 0.

EMPTY TEMP-TABLE T-RutaD.

RLOOP:
FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = B-RutaC.CodCia
    AND B-RutaD.CodDiv = B-RutaC.CodDiv
    AND B-RutaD.CodDoc = B-RutaC.CodDoc
    AND B-RutaD.NroDoc = B-RutaC.NroDoc:
    pTotales = pTotales + 1.
    CASE B-RutaD.CodRef:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            /* Buscamos la ORDEN (O/D u O/M) */
            FIND ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = ORDENES.CodRef
                AND PEDIDO.nroped = ORDENES.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            /* Ya debe haber pasado por FACTURACION */
            FIND FIRST Ccbcdocu USE-INDEX Llave15 WHERE Ccbcdocu.codcia = s-codcia
                AND Ccbcdocu.codped = PEDIDO.coddoc
                AND Ccbcdocu.nroped = PEDIDO.nroped
                AND Ccbcdocu.coddoc = 'G/R'
                AND Ccbcdocu.flgest = "F"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcdocu THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
        WHEN "OTR" THEN DO:
            /* Buscamos la ORDEN (OTR) */
            FIND ORDENES WHERE ORDENES.codcia = s-codcia
                AND ORDENES.coddoc = B-RutaD.CodRef
                AND ORDENES.nroped = B-RutaD.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE ORDENES THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
            FIND FIRST Almcmov USE-INDEX Almc07 WHERE Almcmov.CodCia = s-CodCia
                AND Almcmov.CodRef = ORDENES.CodDoc     /* OTR */
                AND Almcmov.NroRef = ORDENES.NroPed
                AND Almcmov.TipMov = "S"
                AND Almcmov.FlgEst <> "A"
                AND CAN-FIND(FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia
                             AND Almtmovm.Tipmov = Almcmov.TipMov
                             AND Almtmovm.Codmov = Almcmov.CodMov
                             AND Almtmovm.MovTrf = YES NO-LOCK)
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Almcmov THEN DO:
                CREATE T-RutaD.
                BUFFER-COPY B-RutaD TO T-RutaD.
                pBloqueados = pBloqueados + 1.
                NEXT RLOOP.
            END.
        END.
    END CASE.
END.
/* ********************************************************************* */
/* RHC 30/10/18 Verificamos que todas las OTR de una R/A estén en la PHR */
/* ********************************************************************* */
DO:
    EMPTY TEMP-TABLE T-CREPO.
    FOR EACH T-RUTAD NO-LOCK WHERE T-RUTAD.CodRef = "OTR",
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
        FacCPedi.CodDoc = T-RUTAD.CodRef AND
        FacCPedi.NroPed = T-RUTAD.NroRef AND
        Faccpedi.DivDes = s-CodDiv,
        FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND
        almcrepo.CodAlm = Faccpedi.CodCli AND
        almcrepo.TipMov = "M" AND
        almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND
        almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4)):
        FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
            T-CREPO.nroser = Almcrepo.nroser AND
            T-CREPO.nrodoc = Almcrepo.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CREPO THEN DO:
            CREATE T-CREPO.
            BUFFER-COPY Almcrepo TO T-CREPO.
        END.
    END.
    FOR EACH T-RUTAD NO-LOCK WHERE T-RUTAD.CodRef = "OTR",
        FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
        FacCPedi.CodDoc = T-RUTAD.CodRef AND
        FacCPedi.NroPed = T-RUTAD.NroRef AND
        Faccpedi.DivDes = s-CodDiv,
        FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND
        almcrepo.CodAlm = Faccpedi.CodCli AND
        almcrepo.TipMov = "A" AND
        almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND
        almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4)):
        FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND
            T-CREPO.nroser = Almcrepo.nroser AND
            T-CREPO.nrodoc = Almcrepo.nrodoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE T-CREPO THEN DO:
            CREATE T-CREPO.
            BUFFER-COPY Almcrepo TO T-CREPO.
        END.
    END.
    FOR EACH T-CREPO NO-LOCK,
        EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND
            FacCPedi.CodRef = "R/A" AND
            FacCPedi.NroRef = STRING(T-CREPO.NroSer, '999') + STRING(T-CREPO.NroDoc, '999999') AND
            FacCPedi.CodDoc = "OTR":
        IF NOT CAN-FIND(FIRST T-RUTAD WHERE T-RUTAD.CodRef = Faccpedi.CodDoc AND
                        T-RUTAD.NroRef = Faccpedi.NroPed NO-LOCK)
            THEN DO:
            MESSAGE 'Falta la' Faccpedi.CodDoc Faccpedi.NroPed 'de la R/A' FacCPedi.NroRef
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/* Mensaje con la información que NO va a ser migrada */
DEF VAR pOk AS LOG NO-UNDO.
RUN dist/d-mantto-phr-del.w(pTotales, pBloqueados, INPUT TABLE T-RutaD,OUTPUT pOk).
IF pOk = NO THEN RETURN 'ADM-ERROR'.
IF pTotales = pBloqueados THEN DO:
    MESSAGE 'TODOS los documentos tiene observaciones' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
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
  IF s-HR-Manual = YES THEN BUTTON-PreHR:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  
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
        RUN dispatch IN h_v-hoja-de-ruta ('display-fields':U).
    END.
    WHEN 'disable-header' THEN DO:
        RUN dispatch IN h_p-updv04 ('disable':U).
        RUN dispatch IN h_q-dirutac ('disable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    WHEN 'disable-detail' THEN DO:
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        IF h_b-hoja-de-ruta-dg <> ? THEN RUN dispatch IN h_p-updv12-3 ('disable':U).
    END.
    WHEN 'enable-header' THEN DO:
        RUN dispatch IN h_p-updv04 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        BUTTON-Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-PreHR:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    WHEN 'enable-detail' THEN DO:
        RUN dispatch IN h_p-updv04 ('enable':U).
        RUN dispatch IN h_q-dirutac ('enable':U).
        IF h_b-hoja-de-ruta-dg <> ? THEN RUN dispatch IN h_p-updv12-3 ('enable':U).
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

