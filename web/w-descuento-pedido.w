&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
DEF INPUT PARAMETER pParam AS CHAR NO-UNDO.

/* Sintaxis: usar como separador ":" (sin comillas)
    web/w-descuento-pedido.w(<Doc>:<FlgEst>:<CodOrigen>:>NroOrigen>)
    <Doc> Documento. Por ejemplo COT
    <FlgEst> Por ejemplo DA (Descuento Administrador)
    <CodOrigen> Ejemplo RIQRA
    <NroOrigen> Ejemplo HORIZONTAL
*/    

IF NUM-ENTRIES(pParam,':') <> 4 THEN DO:
    MESSAGE 'Debe comparar correctamente los parámetros de arranque:' SKIP(1)
        'Sintaxis: usar como separador ":" (sin comillas)' SKIP
        'web/w-descuento-pedido.w(<Doc>:<FlgEst>:<CodOrigen>:<NroOrigen>)' SKIP
        '<Doc> Documento. Por ejemplo COT' SKIP
        '<FlgEst> Por ejemplo DA (Descuento Administrador)' SKIP
        '<CodOrigen> Ejemplo RIQRA' SKIP
        '<NroOrigen> Ejemplo HORIZONTAL'
        VIEW-AS ALERT-BOX WARNING.
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
    RETURN ERROR.
END.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INTE.

DEF NEW SHARED VAR s-CodDoc AS CHAR INIT "COT".
DEF NEW SHARED VAR s-flgest AS CHAR.
DEF NEW SHARED VARIABLE s-CodOrigen AS CHAR.
DEF NEW SHARED VARIABLE s-NroOrigen AS CHAR.
DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-nivel AS CHAR.
DEF NEW SHARED VAR s-DtoMax     AS DECIMAL.
DEF NEW SHARED VAR s-nrodec AS INT INIT 4.

DEFINE NEW SHARED VARIABLE S-TPOCMB   AS DECIMAL.  
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Faccpedi.PorIgv.
DEFINE NEW SHARED VARIABLE pCodDiv AS CHAR.

ASSIGN
    s-CodDoc = ENTRY(1,pParam,':')
    s-FlgEst = ENTRY(2,pParam,':')
    s-CodOrigen = ENTRY(3,pParam,':')
    s-NroOrigen = ENTRY(4,pParam,':')
    .

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 COMBO-NroSer BUTTON-Genera-PED ~
B-MARGEN 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cotizacion-sunat-flash-v2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv98 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-descuento-pedido AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotizacion-dcto-sunat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-descuento-pedido AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-MARGEN 
     LABEL "VER MARGEN" 
     SIZE 15 BY 1.23 TOOLTIP "Margen Cotizacion en Base al Ultimo Costo, Solo Personas Autorizadas".

DEFINE BUTTON BUTTON-Genera-PED 
     LABEL "GENERAR PEDIDO LOGISTICO" 
     SIZE 30 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129 BY 6.19.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-NroSer AT ROW 1.54 COL 39.71 WIDGET-ID 6
     BUTTON-Genera-PED AT ROW 2.62 COL 131 WIDGET-ID 14
     B-MARGEN AT ROW 7.46 COL 166 WIDGET-ID 10
     RECT-2 AT ROW 2.62 COL 2 WIDGET-ID 8
     RECT-3 AT ROW 1 COL 36 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 184.57 BY 23.62
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DESCUENTO PEDIDOS COMERCIALES AL CREDITO"
         HEIGHT             = 23.62
         WIDTH              = 184.57
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
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DESCUENTO PEDIDOS COMERCIALES AL CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DESCUENTO PEDIDOS COMERCIALES AL CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-MARGEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-MARGEN W-Win
ON CHOOSE OF B-MARGEN IN FRAME F-Main /* VER MARGEN */
DO:
  RUN Margen IN h_v-descuento-pedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Genera-PED
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Genera-PED W-Win
ON CHOOSE OF BUTTON-Genera-PED IN FRAME F-Main /* GENERAR PEDIDO LOGISTICO */
DO:
  MESSAGE 'Desea generar el Pedido Logístico y/o la Orden de Despacho?' SKIP
      'Este proceso es irreversible'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Genera-Pedido-Logistico (OUTPUT pMensaje).
  IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
  ELSE MESSAGE 'Proceso culminado con éxito' VIEW-AS ALERT-BOX INFORMATION.
  RUN dispatch IN h_q-descuento-pedido ('open-query':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    RUN dispatch IN h_q-descuento-pedido ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

CASE s-CodDoc:
    WHEN 'C/M' THEN W-Win:TITLE = "DESCUENTO COTIZACIONES MOSTRADOR".
    WHEN 'P/M' THEN W-Win:TITLE = "DESCUENTO PEDIDOS MOSTRADOR".
    WHEN 'PED' THEN W-Win:TITLE = "DESCUENTO PEDIDOS LOGISTICOS AL CREDITO".
    WHEN 'COT' THEN W-Win:TITLE = "DESCUENTO PEDIDOS COMERCIALES AL CREDITO".
END CASE.
W-Win:TITLE = W-Win:TITLE + " - " + s-CodOrigen + " " + s-NroOrigen.
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
             INPUT  'adm-vm/objects/p-updv98.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv98 ).
       RUN set-position IN h_p-updv98 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv98 ( 1.54 , 34.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/web/v-descuento-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-descuento-pedido ).
       RUN set-position IN h_v-descuento-pedido ( 2.88 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.65 , 124.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-descuento-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-updv98 , 'TableIO':U , h_v-descuento-pedido ).
       RUN add-link IN adm-broker-hdl ( h_q-descuento-pedido , 'Record':U , h_v-descuento-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv98 ,
             COMBO-NroSer:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-descuento-pedido ,
             BUTTON-Genera-PED:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 113.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.62 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/web/b-cotizacion-sunat-flash-v2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cotizacion-sunat-flash-v2 ).
       RUN set-position IN h_b-cotizacion-sunat-flash-v2 ( 8.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-cotizacion-sunat-flash-v2 ( 13.46 , 182.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/web/q-descuento-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-descuento-pedido ).
       RUN set-position IN h_q-descuento-pedido ( 1.54 , 52.00 ) NO-ERROR.
       /* Size in UIB:  ( 0.81 , 7.00 ) */

       /* Links to SmartBrowser h_b-cotizacion-sunat-flash-v2. */
       RUN add-link IN adm-broker-hdl ( h_q-descuento-pedido , 'Record':U , h_b-cotizacion-sunat-flash-v2 ).

       /* Links to SmartQuery h_q-descuento-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-descuento-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_p-updv98 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cotizacion-sunat-flash-v2 ,
             B-MARGEN:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-descuento-pedido ,
             h_b-cotizacion-sunat-flash-v2 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'web/t-descuento-pedido.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotizacion-dcto-sunat ).
       RUN set-position IN h_t-cotizacion-dcto-sunat ( 8.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-cotizacion-dcto-sunat ( 15.62 , 181.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 22.54 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 1.54 , 26.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-cotizacion-dcto-sunat. */
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_t-cotizacion-dcto-sunat ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotizacion-dcto-sunat ,
             B-MARGEN:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv96 ,
             h_t-cotizacion-dcto-sunat , 'AFTER':U ).
    END. /* Page 2 */

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
  DISPLAY COMBO-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 RECT-3 COMBO-NroSer BUTTON-Genera-PED B-MARGEN 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido-Logistico W-Win 
PROCEDURE Genera-Pedido-Logistico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* 1) Capturamos en Documento */
DEF VAR pCodDoc AS CHAR NO-UNDO.
DEF VAR pNroPed AS CHAR NO-UNDO.

RUN Send-Document IN h_q-descuento-pedido
    ( OUTPUT pCodDoc /* CHARACTER */,
      OUTPUT pNroPed /* CHARACTER */).
IF TRUE <> (pCodDoc > '') THEN RETURN.

/* 2) Generamos Pedido Logístico */
DEFINE VAR cNewCodDoc AS CHAR.
DEFINE VAR cNewNroDoc AS CHAR.
DEFINE VAR cMsgRet AS CHAR.

DEFINE VAR dFecha AS DATE.
DEFINE VAR cHora AS CHAR.

dFecha = TODAY.
cHora = STRING(TIME,"hh:mm:ss").

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    /* Actualizamos FlgEst = "P" */
    {lib/lock-genericov3.i ~
        &Tabla="FacCPedi" ~
        &Condicion="FacCPedi.codcia = s-codcia AND ~
        FacCPedi.coddiv = s-coddiv AND ~
        FacCPedi.coddoc = pCodDoc AND ~
        FacCPedi.nroped = pNroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
        
    /* Verificamos por si acaso */
    IF Faccpedi.flgest <> s-FlgEst THEN DO:
        pMensaje = "Registro ha sido modificado por otro usuario" + CHR(10)+
            "Se va a refrescar la pantalla".
        RETURN.
    END.
    ASSIGN
         FacCPedi.FlgEst = "P".     /* OJO: Estado que arranca el proceso */
    
    /* Generar PED Logistico */
    RUN web/generacion-pedido-logistico (INPUT pCodDoc,    /* COT */
                                         INPUT pNroPed,
                                         OUTPUT cNewCodDoc,
                                         OUTPUT cNewNroDoc,
                                         OUTPUT cMsgRet).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pMensaje = "ERROR al generar Pedido Logístico" + CHR(10) + cMsgRet.
        UNDO, RETURN.
    END.
    FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND                                
        logproceso.coddoc = pCodDoc AND 
        logproceso.nrodoc = pNroPed AND 
        logproceso.newcoddoc = cNewCodDoc AND 
        logproceso.newnrodoc = cNewNroDoc 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN 
            logproceso.coddoc = pCodDoc
            logproceso.nrodoc = pNroPed
            logproceso.fchareg = TODAY
            logproceso.horareg = STRING(TIME,"hh:mm:ss").
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN 
            logproceso.fchaproc = dFecha
            logproceso.horaproc = cHora
            logproceso.mensaje = cMsgRet.
    END.
    /**/
    ASSIGN 
        logproceso.newcoddoc = cNewCodDoc
        logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.

    /* Generar O/D Logistico */
    DEFINE VAR cCodDoc1 AS CHAR.
    DEFINE VAR cNroDoc1 AS CHAR.

    cCodDoc1 = cNewCodDoc.
    cNroDoc1 = cNewNroDoc.
    cNewCodDoc = "".
    cNewNroDoc = "".
    cMsgRet = "".
    dFecha = TODAY.
    cHora = STRING(TIME,"hh:mm:ss").

    RUN web/generacion-orden-despacho (INPUT cCodDoc1,     /* PED */
                                       INPUT cNroDoc1,
                                       OUTPUT cNewCodDoc,
                                       OUTPUT cNewNroDoc,
                                       OUTPUT cMsgRet).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        /* OJO: Ya generó el Pedido Logístico, así que el proceso se debe continuar manualmante */
        pMensaje = "ERROR al generar Orden de Despacho" + CHR(10) + "ERROR: " + cMsgRet + CHR(10) + CHR(10) +
            "Solo se pudo generar el Pedido Logístico # " + cNroDoc1.
        RETURN.
    END.

    FIND FIRST logproceso WHERE logproceso.fchaproc = dFecha AND                            
        logproceso.coddoc = cCodDoc1 AND logproceso.nrodoc = cNroDoc1 AND
        logproceso.newcoddoc = cNewCodDoc AND logproceso.newnrodoc = cNewNroDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE logproceso THEN DO:
        CREATE logproceso.
        ASSIGN 
            logproceso.coddoc = cCodDoc1
            logproceso.nrodoc = cNroDoc1
            logproceso.fchareg = TODAY
            logproceso.horareg = STRING(TIME,"hh:mm:ss").
    END.
    FIND CURRENT logproceso EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE logproceso THEN DO:
        ASSIGN 
            logproceso.fchaproc = dFecha
            logproceso.horaproc = cHora
            logproceso.mensaje = cMsgRet.
    END.
    /**/
    ASSIGN logproceso.newcoddoc = cNewCodDoc
            logproceso.newnrodoc = cNewNroDoc.
    RELEASE logproceso NO-ERROR.

    IF AVAILABLE(FacCPedi) THEN RELEASE FacCPedi.

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
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
  FOR EACH FacCorre NO-LOCK WHERE 
      FacCorre.CodCia = s-CodCia AND
      FacCorre.CodDoc = s-CodDoc AND
      FacCorre.CodDiv = s-CodDiv:
      IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
      ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle ('Pagina1').

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

DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "browse" THEN DO:
          RUN dispatch IN h_b-cotizacion-sunat-flash-v2 ('open-query':U).
          RUN dispatch IN h_t-cotizacion-dcto-sunat ('open-query':U).
      END.
    WHEN "Recalcular-Precios" THEN DO:
        RUN dispatch IN h_t-cotizacion-dcto-sunat ('recalcular-precios':U).
    END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         COMBO-NroSer:SENSITIVE = YES.
         BUTTON-Genera-PED:SENSITIVE = YES.
         B-MARGEN:SENSITIVE = YES.
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         COMBO-NroSer:SENSITIVE = NO.
         BUTTON-Genera-PED:SENSITIVE = NO.
         B-MARGEN:SENSITIVE = NO.        
      END.
    WHEN "Enable-Head" THEN DO WITH FRAME {&FRAME-NAME}:
        RUN dispatch IN h_p-updv98 ('enable':U).
        /*RUN dispatch IN h_v-descuento-pedido ('enable':U).*/
    END.
    WHEN "Disable-Head" THEN DO WITH FRAME {&FRAME-NAME}:
        RUN dispatch IN h_p-updv98 ('disable':U).
        /*RUN dispatch IN h_v-descuento-pedido ('disable':U).*/
    END.
    WHEN "Open-Query" THEN RUN dispatch IN h_q-descuento-pedido ('open-query':U).
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

