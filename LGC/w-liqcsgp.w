&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.

DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED TEMP-TABLE ITEM2 LIKE lg-liqcsgd.
DEFINE NEW SHARED VAR lh_Handle AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CODPRO   AS CHAR .
DEFINE NEW SHARED VARIABLE S-TIPO     AS CHAR INITIAL " ".

/*
FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.CodDoc = "LIQ" 
           NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Correlativo de Liquidaciones no esta configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-64 BUTTON-1 BUTTON-7 BUTTON-8 BUTTON-6 ~
B-Imprimir BUTTON-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-B-Imprimir 
       MENU-ITEM m_Proveedor    LABEL "Proveedor"     
       MENU-ITEM m_Almacen      LABEL "Archivo"       
       MENU-ITEM m_contabilidad LABEL "Contabilidad"  
       MENU-ITEM m_Detalle-Mov  LABEL "Detalle-Mov."  .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-liquida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpliq AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-liquida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-liqcsgp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-totcsg AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Imprimir 
     LABEL "&Imprimir" 
     SIZE 8 BY 1.

DEFINE BUTTON BUTTON-1 
     LABEL "Seleccionar Todo" 
     SIZE 18 BY .85.

DEFINE BUTTON BUTTON-2 
     LABEL "Procesa" 
     SIZE 9.14 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "Eliminar No Seleccionados" 
     SIZE 18 BY .85.

DEFINE BUTTON BUTTON-7 
     LABEL "Deseleccionar Todo" 
     SIZE 18 BY .85.

DEFINE BUTTON BUTTON-8 
     LABEL "Eliminar Seleccionados" 
     SIZE 18 BY .85.

DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 8  NO-FILL 
     SIZE 76.14 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 14.65 COL 3.43
     BUTTON-7 AT ROW 14.65 COL 21.57
     BUTTON-8 AT ROW 14.65 COL 39.57
     BUTTON-6 AT ROW 14.65 COL 58.14
     B-Imprimir AT ROW 5.54 COL 79.14
     BUTTON-2 AT ROW 6.73 COL 79.14
     RECT-64 AT ROW 14.23 COL 1.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.14 BY 15
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Liquidacion Consignacion Proveedores"
         HEIGHT             = 15
         WIDTH              = 89.29
         MAX-HEIGHT         = 17.12
         MAX-WIDTH          = 92
         VIRTUAL-HEIGHT     = 17.12
         VIRTUAL-WIDTH      = 92
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
ASSIGN 
       B-Imprimir:POPUP-MENU IN FRAME F-Main       = MENU POPUP-MENU-B-Imprimir:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Liquidacion Consignacion Proveedores */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Liquidacion Consignacion Proveedores */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir W-Win
ON CHOOSE OF B-Imprimir IN FRAME F-Main /* Imprimir */
DO:
    Message "Seleccione Impresión con el " SKIP
            "Click Derecho de su Mouse"    
            VIEW-AS ALERT-BOX INFORMA.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Seleccionar Todo */
DO:
  RUN Seleccionar-Items IN h_b-tmpliq.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Procesa */
DO:
  RUN Procesa-Consignacion IN h_v-liqcsgp.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Eliminar No Seleccionados */
DO:
  RUN Eliminar-DesMar IN h_b-tmpliq.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Deseleccionar Todo */
DO:
  RUN Desmarcar-Items IN h_b-tmpliq.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Eliminar Seleccionados */
DO:
  RUN Eliminar-Items IN h_b-tmpliq.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Almacen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Almacen W-Win
ON CHOOSE OF MENU-ITEM m_Almacen /* Archivo */
DO:  
   RUN Imprime-Almacen IN h_v-liqcsgp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_contabilidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_contabilidad W-Win
ON CHOOSE OF MENU-ITEM m_contabilidad /* Contabilidad */
DO:
   RUN Imprime-Contabilidad IN h_v-liqcsgp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Detalle-Mov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle-Mov W-Win
ON CHOOSE OF MENU-ITEM m_Detalle-Mov /* Detalle-Mov. */
DO:
   RUN Imprime-detalle IN h_v-liqcsgp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Proveedor W-Win
ON CHOOSE OF MENU-ITEM m_Proveedor /* Proveedor */
DO:
   RUN Imprime-Proveedor IN h_v-liqcsgp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
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
             INPUT  'lgc/v-liqcsgp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-liqcsgp ).
       RUN set-position IN h_v-liqcsgp ( 1.08 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 4.19 , 87.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 5.31 , 21.43 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.42 , 19.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 5.31 , 40.57 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.42 , 38.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/q-liqcsgp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-liquida ).
       RUN set-position IN h_q-liquida ( 5.31 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-liqcsgp. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-liqcsgp ).
       RUN add-link IN adm-broker-hdl ( h_q-liquida , 'Record':U , h_v-liqcsgp ).

       /* Links to SmartQuery h_q-liquida. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-liquida ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-liqcsgp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-liquida ).
       RUN set-position IN h_b-liquida ( 6.69 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 87.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/v-totcsg.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-totcsg ).
       RUN set-position IN h_v-totcsg ( 14.31 , 1.29 ) NO-ERROR.
       /* Size in UIB:  ( 1.38 , 80.57 ) */

       /* Links to SmartBrowser h_b-liquida. */
       RUN add-link IN adm-broker-hdl ( h_q-liquida , 'Record':U , h_b-liquida ).

       /* Links to SmartViewer h_v-totcsg. */
       RUN add-link IN adm-broker-hdl ( h_q-liquida , 'Record':U , h_v-totcsg ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-tmpliqcp.w':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpliq ).
       RUN set-position IN h_b-tmpliq ( 6.73 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 7.50 , 77.14 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = Multiple-Records':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 7.81 , 78.86 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 6.35 , 9.29 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpliq. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpliq ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 2 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  ENABLE RECT-64 BUTTON-1 BUTTON-7 BUTTON-8 BUTTON-6 B-Imprimir BUTTON-2 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN lh_Handle = THIS-PROCEDURE.
  ASSIGN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE .
  RUN Procesa-Handle("Pagina1").

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
         RUN get-attribute ("CURRENT-PAGE").
         IF INTEGER(RETURN-VALUE) = 1 THEN 
              RUN dispatch IN h_b-liquida ('open-query':U).
         ELSE RUN dispatch IN h_b-tmpliq ('open-query':U).
      END.
    WHEN "Pagina1" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         B-Imprimir:HIDDEN = NO.

      END.
    WHEN "Pagina2" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         B-Imprimir:HIDDEN = YES.
      END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


