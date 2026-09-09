&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE T-CPEDI NO-UNDO LIKE FacCPedi.



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

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-Listas BUTTON-Divisiones ~
BUTTON-Filtrar FILL-IN-FchPed-1 FILL-IN-FchPed-2 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-Divisiones EDITOR-Listas ~
FILL-IN-FchPed-1 FILL-IN-FchPed-2 FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cambio-de-codigo AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-cambio-de-codigo-cot AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Aplicar 
     LABEL "CAMBIAR CODIGOS" 
     SIZE 37 BY 1.62
     FONT 8.

DEFINE BUTTON BUTTON-Divisiones 
     LABEL "..." 
     SIZE 4 BY 1.12.

DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTROS" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-Listas 
     LABEL "..." 
     SIZE 4 BY 1.12.

DEFINE VARIABLE EDITOR-Divisiones AS CHARACTER INITIAL "00015" 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.15
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE EDITOR-Listas AS CHARACTER INITIAL "00015" 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.15
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Emitidas Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 8.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-Divisiones AT ROW 2.88 COL 8 NO-LABEL WIDGET-ID 6
     BUTTON-Listas AT ROW 2.88 COL 43 WIDGET-ID 16
     EDITOR-Listas AT ROW 2.88 COL 48 NO-LABEL WIDGET-ID 10
     BUTTON-Divisiones AT ROW 3.15 COL 3 WIDGET-ID 14
     BUTTON-Filtrar AT ROW 5.31 COL 60 WIDGET-ID 26
     FILL-IN-FchPed-1 AT ROW 5.58 COL 15 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-FchPed-2 AT ROW 5.58 COL 34 COLON-ALIGNED WIDGET-ID 20
     BUTTON-Limpiar AT ROW 6.65 COL 60 WIDGET-ID 28
     BUTTON-Aplicar AT ROW 10.69 COL 103 WIDGET-ID 30
     FILL-IN-Mensaje AT ROW 12.58 COL 101 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     "Filtros" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 
     "Divisiones a considerar:" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 2.08 COL 8 WIDGET-ID 8
     "Con estas listas de precios:" VIEW-AS TEXT
          SIZE 19 BY .5 AT ROW 2.08 COL 48 WIDGET-ID 12
     RECT-1 AT ROW 1.54 COL 2 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 186.72 BY 25.42
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: T-CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CAMBIO DE CODIGO DE PRODUCTO - COTIZACIONES"
         HEIGHT             = 25.42
         WIDTH              = 186.72
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
/* SETTINGS FOR BUTTON BUTTON-Aplicar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Limpiar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-Listas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CAMBIO DE CODIGO DE PRODUCTO - COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CAMBIO DE CODIGO DE PRODUCTO - COTIZACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Aplicar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Aplicar W-Win
ON CHOOSE OF BUTTON-Aplicar IN FRAME F-Main /* CAMBIAR CODIGOS */
DO:
  MESSAGE 'Procedemos con el cambio de códigos?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cambiar-Codigos.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  APPLY "CHOOSE":U TO BUTTON-Limpiar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Divisiones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Divisiones W-Win
ON CHOOSE OF BUTTON-Divisiones IN FRAME F-Main /* ... */
DO:
    DEF VAR pCodigos AS CHAR NO-UNDO.

    pCodigos = EDITOR-Divisiones:SCREEN-VALUE.
    RUN gn/d-filtro-eventos (INPUT-OUTPUT pCodigos,
                             INPUT "Selecciona Divisiones").
    EDITOR-Divisiones:SCREEN-VALUE = pCodigos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTROS */
DO:
  ASSIGN EDITOR-Divisiones EDITOR-Listas FILL-IN-FchPed-1 FILL-IN-FchPed-2.
  RUN Aplicar-Filtros IN h_b-cambio-de-codigo-cot
    ( INPUT EDITOR-Divisiones /* CHARACTER */,
      INPUT EDITOR-Listas /* CHARACTER */,
      INPUT FILL-IN-FchPed-1 /* DATE */,
      INPUT FILL-IN-FchPed-2 /* DATE */).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO hay Cotizaciones válidas con estos filtros' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  /* Deshabilitamos filtros */
  DISABLE BUTTON-Divisiones BUTTON-Filtrar BUTTON-Listas 
      EDITOR-Divisiones EDITOR-Listas 
      FILL-IN-FchPed-1 FILL-IN-FchPed-2
      WITH FRAME {&FRAME-NAME}.
  ENABLE BUTTON-Limpiar BUTTON-Aplicar
      WITH FRAME {&FRAME-NAME}.
  /* Habilitamos Artículos a intercambiar */
  RUN dispatch IN h_p-updv10 ('enable':U).
  /* Listas Validas */
  RUN Listas-Validas IN h_b-cambio-de-codigo ( INPUT EDITOR-Listas /* CHARACTER */).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
  /* Deshabilitamos filtros */
  ENABLE BUTTON-Divisiones BUTTON-Filtrar BUTTON-Listas BUTTON-Aplicar
      FILL-IN-FchPed-1 FILL-IN-FchPed-2
      WITH FRAME {&FRAME-NAME}.
  DISABLE BUTTON-Limpiar WITH FRAME {&FRAME-NAME}.
  EDITOR-Divisiones = '00015'.
  EDITOR-Listas = '00015'.
  DISPLAY EDITOR-Divisiones EDITOR-Listas WITH FRAME {&FRAME-NAME}.
  /* Deshabilitamos Artículos a intercambiar */
  RUN Limpiar-Filtros IN h_b-cambio-de-codigo.
  RUN Limpiar-Filtros IN h_b-cambio-de-codigo-cot.
  RUN dispatch IN h_p-updv10 ('disable':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Listas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Listas W-Win
ON CHOOSE OF BUTTON-Listas IN FRAME F-Main /* ... */
DO:
  DEF VAR pCodigos AS CHAR NO-UNDO.

  pCodigos = EDITOR-Listas:SCREEN-VALUE.
  RUN gn/d-filtro-listaprecios (INPUT-OUTPUT pCodigos,
                           INPUT "Selecciona la Lista de Precios").
  EDITOR-Listas:SCREEN-VALUE = pCodigos.
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
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 1.54 , 82.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/b-cambio-de-codigo.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cambio-de-codigo ).
       RUN set-position IN h_b-cambio-de-codigo ( 2.88 , 82.00 ) NO-ERROR.
       RUN set-size IN h_b-cambio-de-codigo ( 6.69 , 104.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/b-cambio-de-codigo-cot.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cambio-de-codigo-cot ).
       RUN set-position IN h_b-cambio-de-codigo-cot ( 9.88 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cambio-de-codigo-cot ( 15.88 , 99.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cambio-de-codigo. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-cambio-de-codigo ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             EDITOR-Divisiones:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cambio-de-codigo ,
             EDITOR-Listas:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cambio-de-codigo-cot ,
             BUTTON-Limpiar:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cambiar-Codigos W-Win 
PROCEDURE Cambiar-Codigos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro. Capturamos Temporales */
EMPTY TEMP-TABLE ITEM.
RUN Captura-Temporal IN h_b-cambio-de-codigo ( OUTPUT TABLE ITEM).
IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
    MESSAGE 'NO ha definido los códigos a cambiar' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

EMPTY TEMP-TABLE T-CPEDI.
RUN Captura-Temporal IN h_b-cambio-de-codigo-cot ( OUTPUT TABLE T-CPEDI).
IF NOT CAN-FIND(FIRST T-CPEDI NO-LOCK) THEN DO:
    MESSAGE 'NO existen Cotizaciones Válidas' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* 2do. transaccion */
FOR EACH T-CPEDI NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PROCESANDO COTIZACION " + T-CPEDI.NroPed.
    pMensaje = "".
    RUN Graba-Registro.
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        MESSAGE "ERROR en la COTIZACION " T-CPEDI.NroPed SKIP
            pMensaje SKIP 
            'Se continuará con la siguiente cotizacion'
            VIEW-AS ALERT-BOX ERROR.
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY EDITOR-Divisiones EDITOR-Listas FILL-IN-FchPed-1 FILL-IN-FchPed-2 
          FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-Listas BUTTON-Divisiones BUTTON-Filtrar FILL-IN-FchPed-1 
         FILL-IN-FchPed-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro W-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Una transaccion por cada Cotizacion
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Alcance="FIRST" ~
        &Condicion="FacCPedi.CodCia = T-CPEDI.CodCia AND ~
        FacCPedi.CodDiv = T-CPEDI.CodDiv AND ~
        FacCPedi.CodDoc = T-CPEDI.CodDoc AND ~
        FacCPedi.NroPed = T-CPEDI.NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    /* Verificamos si las condiciones son las correctas */
    IF Faccpedi.FlgEst <> "P" OR 
        CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK) THEN DO:
        pMensaje = "Ya no se encuentra pendiente de atención".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Verificamos que no esté ya registrado el código nuevo */
    FOR EACH ITEM NO-LOCK:
        IF NOT CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CodMat = ITEM.CodMat NO-LOCK)
            THEN NEXT.
        IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CodMat = ITEM.CodMatWeb NO-LOCK)
            THEN DO:
            pMensaje = "NO puede estar registrado en la cotización el código nuevo " + ITEM.CodMatWeb.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* Listo para procesar */
    FOR EACH ITEM NO-LOCK:
        FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.CodMat = ITEM.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN NEXT.
        FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "NO se pudo bloquear el registro con el artículo" + ITEM.CodMat.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Facdpedi.CodMat = ITEM.CodMatWeb.
    END.
END.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.


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
  FILL-IN-FchPed-1 = TODAY.
  FILL-IN-FchPed-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* NO habilitadas por defecto */
  RUN dispatch IN h_p-updv10 ('disable':U).


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

