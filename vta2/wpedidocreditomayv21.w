&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: Fecha de Entrega determinada por el sistema
          
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
/* FORMATO EJEMPLO PED,M    Pedido Contrato Marco (M) */
DEF INPUT PARAMETER pParametro AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "PED".

DEFINE NEW SHARED VARIABLE s-codref   AS CHAR INITIAL "COT".
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE NEW SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE NEW SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE NEW SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE NEW SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE NEW SHARED VARIABLE s-FlgIgv LIKE Faccpedi.FlgIgv.
DEFINE NEW SHARED VARIABLE s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VARIABLE s-TpoPed AS CHAR.
DEFINE NEW SHARED VARIABLE s-TpoPed2 AS CHAR.
DEFINE NEW SHARED VARIABLE s-FmaPgo AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroDec AS INT INIT 4.

ASSIGN
    s-CodDoc = ENTRY(1, pParametro)
    s-TpoPed = ENTRY(2, pParametro).

    s-TpoPed2 = ''.
    IF NUM-ENTRIES(pParametro) > 2 THEN DO:
        s-TpoPed2 = ENTRY(3, pParametro).  /* ValesUtilex */
    END.
    

/* Valores para s-TpoPed
CR: CRédito
*/   

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX WARNING.
   RETURN ERROR.
END.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-CodAlm AS CHAR. /* NOTA: Puede contener mas de un almacen */

/* RHC 31/01/2018 Valores por defecto pero dependen de la COTIZACION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
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
&Scoped-Define ENABLED-OBJECTS RECT-25 BUTTON-Despachar COMBO-NroSer ~
Btn-Excel btn-margen BTN-CCTE B-AGTRANS BUTTON-REDONDEO 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-pedido-cred AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv04 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedido AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-pedido-cred AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-pedido-cred-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vpedidocreditomayv21 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-AGTRANS 
     LABEL "TRANSPORTISTA" 
     SIZE 15 BY 1.

DEFINE BUTTON BTN-CCTE 
     LABEL "CTA.CTE." 
     SIZE 15 BY 1.

DEFINE BUTTON Btn-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Excel" 
     SIZE 8 BY 1.35 TOOLTIP "Salida a excel".

DEFINE BUTTON btn-margen 
     LABEL "MARGEN" 
     SIZE 15 BY 1.

DEFINE BUTTON BUTTON-Despachar 
     LABEL "PEDIDO LISTO PARA DESPACHAR" 
     SIZE 28 BY 1.12.

DEFINE BUTTON BUTTON-REDONDEO 
     LABEL "REDONDEO" 
     SIZE 15 BY 1.

DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121 BY 10.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Despachar AT ROW 1 COL 116 WIDGET-ID 28
     COMBO-NroSer AT ROW 1.27 COL 79.71 WIDGET-ID 4
     Btn-Excel AT ROW 2.35 COL 136 WIDGET-ID 20
     btn-margen AT ROW 7.54 COL 125 WIDGET-ID 2
     BTN-CCTE AT ROW 8.5 COL 125 WIDGET-ID 22
     B-AGTRANS AT ROW 9.46 COL 125 WIDGET-ID 24
     BUTTON-REDONDEO AT ROW 10.42 COL 125 WIDGET-ID 26
     "Buscar el número:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.54 COL 92 WIDGET-ID 8
     RECT-25 AT ROW 2.35 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143.43 BY 24.81
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "NEW SHARED" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDO MAYORISTA AL CREDITO"
         HEIGHT             = 24.81
         WIDTH              = 143.43
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 167.29
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 167.29
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
ON END-ERROR OF W-Win /* PEDIDO MAYORISTA AL CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDO MAYORISTA AL CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-AGTRANS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-AGTRANS W-Win
ON CHOOSE OF B-AGTRANS IN FRAME F-Main /* TRANSPORTISTA */
DO:
   RUN Asigna-datos IN h_vpedidocreditomayv21.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BTN-CCTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BTN-CCTE W-Win
ON CHOOSE OF BTN-CCTE IN FRAME F-Main /* CTA.CTE. */
DO:
    /*RUN vta2/d-ctactepend.*/
    RUN ccb/w-consul-cctv3.w(s-codcli).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Excel W-Win
ON CHOOSE OF Btn-Excel IN FRAME F-Main /* Excel */
DO:

  RUN Excel IN h_vpedidocreditomayv21.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-margen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-margen W-Win
ON CHOOSE OF btn-margen IN FRAME F-Main /* MARGEN */
DO:
  RUN Margen IN h_vpedidocreditomayv21.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Despachar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Despachar W-Win
ON CHOOSE OF BUTTON-Despachar IN FRAME F-Main /* PEDIDO LISTO PARA DESPACHAR */
DO:
  RUN Despachar-Pedido IN h_vpedidocreditomayv21.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-REDONDEO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-REDONDEO W-Win
ON CHOOSE OF BUTTON-REDONDEO IN FRAME F-Main /* REDONDEO */
DO:
  MESSAGE 'Deshabilitado hasta nuevo aviso' VIEW-AS ALERT-BOX WARNING.
  RETURN NO-APPLY.
  RUN Redondeo IN h_vpedidocreditomayv21.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer W-Win
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME F-Main /* Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    RUN dispatch IN h_q-pedido ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/
CASE s-CodDoc:
    WHEN "PED" THEN {&WINDOW-NAME}:TITLE = "PEDIDOS AL CREDITO - MAYORISTA".
END CASE.
CASE s-TpoPed:
    WHEN "E" THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + "- EXPOLIBRERIA".
    WHEN "S" THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + "- CANAL MODERNO".
    WHEN "M" THEN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + "- CONTRATO MARCO".
END CASE.

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
             INPUT  'adm-vm/objects/p-updv04.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv04 ).
       RUN set-position IN h_p-updv04 ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv04 ( 1.35 , 75.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.35 , 125.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 5.12 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/vpedidocreditomayv21.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vpedidocreditomayv21 ).
       RUN set-position IN h_vpedidocreditomayv21 ( 2.62 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.69 , 119.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/qpedidocreditomay.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedido ).
       RUN set-position IN h_q-pedido ( 1.00 , 106.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.35 , 9.00 ) */

       /* Links to SmartViewer h_vpedidocreditomayv21. */
       RUN add-link IN adm-broker-hdl ( h_p-updv04 , 'TableIO':U , h_vpedidocreditomayv21 ).
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_vpedidocreditomayv21 ).

       /* Links to SmartQuery h_q-pedido. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-pedido ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv04 ,
             BUTTON-Despachar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             COMBO-NroSer:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vpedidocreditomayv21 ,
             Btn-Excel:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedido ,
             BUTTON-REDONDEO:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-cotizacion-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pedido-cred ).
       RUN set-position IN h_b-pedido-cred ( 12.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pedido-cred ( 13.08 , 141.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-pedido-cred. */
       RUN add-link IN adm-broker-hdl ( h_q-pedido , 'Record':U , h_b-pedido-cred ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pedido-cred ,
             BUTTON-REDONDEO:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/t-pedido-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-pedido-cred ).
       RUN set-position IN h_t-pedido-cred ( 12.58 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-pedido-cred ( 12.12 , 141.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv95 ).
       RUN set-position IN h_p-updv95 ( 24.15 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv95 ( 1.42 , 34.00 ) NO-ERROR.

       /* Links to SmartBrowser h_t-pedido-cred. */
       RUN add-link IN adm-broker-hdl ( h_p-updv95 , 'TableIO':U , h_t-pedido-cred ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-pedido-cred ,
             BUTTON-REDONDEO:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv95 ,
             h_t-pedido-cred , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/t-pedido-cred.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-pedido-cred-2 ).
       RUN set-position IN h_t-pedido-cred-2 ( 11.77 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-pedido-cred-2 ( 12.12 , 141.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-pedido-cred-2 ,
             BUTTON-REDONDEO:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  DISPLAY COMBO-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-25 BUTTON-Despachar COMBO-NroSer Btn-Excel btn-margen BTN-CCTE 
         B-AGTRANS BUTTON-REDONDEO 
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
  ASSIGN lh_Handle = THIS-PROCEDURE.
  RUN Procesa-Handle ("Pagina1").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-handle W-Win 
PROCEDURE Procesa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER L-Handle AS CHAR.

CASE L-Handle:
    WHEN "browse" THEN DO:
          IF h_b-pedido-cred <> ? THEN RUN dispatch IN h_b-pedido-cred ('open-query':U).
          IF h_t-pedido-cred <> ? THEN RUN dispatch IN h_t-pedido-cred ('open-query':U).
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
        RUN select-page(1).
        BUTTON-Despachar:SENSITIVE = YES.
        Btn-Margen:SENSITIVE = YES.
        Btn-Ccte:SENSITIVE = NO.
        Btn-Excel:SENSITIVE = TRUE.
        B-AGTRANS:SENSITIVE = YES.
        BUTTON-REDONDEO:SENSITIVE = YES.
        IF h_b-pedido-cred <> ? THEN RUN dispatch IN h_b-pedido-cred ('open-query':U).
        RUN dispatch IN h_q-pedido ('enable':U).
        ASSIGN
           COMBO-NroSer:SENSITIVE = YES.
     END.
   WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
       RUN select-page(2).
       BUTTON-Despachar:SENSITIVE = NO.
       Btn-Margen:SENSITIVE = NO.
       Btn-Ccte:SENSITIVE = YES.
       Btn-Excel:SENSITIVE = FALSE.
       B-AGTRANS:SENSITIVE = NO.
       BUTTON-REDONDEO:SENSITIVE = NO.
       IF h_t-pedido-cred <> ? THEN RUN dispatch IN h_t-pedido-cred ('open-query':U).
       RUN dispatch IN h_q-pedido ('disable':U).
       ASSIGN
         COMBO-NroSer:SENSITIVE = NO.
   END.
    WHEN "Pagina3"  THEN DO WITH FRAME {&FRAME-NAME}:
        RUN select-page(3).
        BUTTON-Despachar:SENSITIVE = NO.
        Btn-Margen:SENSITIVE = NO.
        Btn-Ccte:SENSITIVE = YES.
        Btn-Excel:SENSITIVE = FALSE.
        B-AGTRANS:SENSITIVE = NO.
        BUTTON-REDONDEO:SENSITIVE = NO.
        IF h_t-pedido-cred <> ? THEN RUN dispatch IN h_t-pedido-cred ('open-query':U).
        RUN dispatch IN h_q-pedido ('disable':U).
        ASSIGN
          COMBO-NroSer:SENSITIVE = NO.
    END.
 WHEN "Disable-Head" THEN DO:
     RUN dispatch IN h_p-updv04 ('disable':U).
     RUN dispatch IN h_vpedidocreditomayv21 ('disable-fields').
   END.
 WHEN "Enable-Head" THEN DO:
     RUN dispatch IN h_p-updv04 ('enable':U).
     RUN dispatch IN h_vpedidocreditomayv21 ('enable-fields').
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

