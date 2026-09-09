&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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
IF TODAY >= 01/05/2010 AND TODAY <= 01/06/2010 THEN DO:
    MESSAGE 'EVENTO CIERRAPUERTAS EN UCAYALI' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "PET".
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CODIGV   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE NEW SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE NEW SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE NEW SHARED VARIABLE S-NROTAR   AS CHAR.
DEFINE NEW SHARED VARIABLE CL-CODCIA  AS INTEGER INIT 000.
DEFINE NEW SHARED VARIABLE S-TPOPED   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODPRO   AS CHAR.

DEFINE NEW SHARED VARIABLE s-nropag   AS INT.
DEFINE NEW SHARED VARIABLE s-nroCOT   AS CHAR.

DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODTER   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE     SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE            VARIABLE S-OK       AS CHAR.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEF NEW SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasAmpCot LIKE GN-DIVI.DiasAmpCot.
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion LIKE GN-DIVI.FlgRotacion.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV and
     Faccorre.Codalm = S-CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

FIND EMPRESAS WHERE EMPRESAS.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-DiasAmpCot = GN-DIVI.DiasAmpCot    
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-FlgRotacion = GN-DIVI.FlgRotacion.

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
&Scoped-Define ENABLED-OBJECTS RECT-69 B-CCTE BUTTON-COT BUTTON-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cotexp-2-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv06 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-pedido2x AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-cotexp-2x-1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-precotiza-1 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-CCTE 
     LABEL "Cuenta Corriente" 
     SIZE 16 BY 1.15.

DEFINE BUTTON BUTTON-2 
     LABEL "POR ATENDER" 
     SIZE 12 BY 1.42
     FONT 1.

DEFINE BUTTON BUTTON-6 
     LABEL "COTIZAR" 
     SIZE 10.57 BY 1.42.

DEFINE BUTTON BUTTON-COT 
     LABEL "Historico Cotizaciones" 
     SIZE 16 BY 1.12.

DEFINE RECTANGLE RECT-69
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 133 BY 11.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-CCTE AT ROW 1.27 COL 121 WIDGET-ID 8
     BUTTON-COT AT ROW 2.46 COL 121 WIDGET-ID 10
     BUTTON-6 AT ROW 9.88 COL 89 WIDGET-ID 6
     BUTTON-2 AT ROW 9.88 COL 100
     RECT-69 AT ROW 11.42 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 137.14 BY 22.08
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI2 T "NEW SHARED" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Pre Cotización Provincia"
         HEIGHT             = 22.08
         WIDTH              = 137.14
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 140.14
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 140.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("adeicon/icfdev.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/icfdev.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Pre Cotización Provincia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Pre Cotización Provincia */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-CCTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-CCTE W-Win
ON CHOOSE OF B-CCTE IN FRAME F-Main /* Cuenta Corriente */
DO:
  run vta/d-concli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* POR ATENDER */
DO:
  RUN vtaexp/d-exp002.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* COTIZAR */
DO:
    RUN Asigna-Cotizacion IN h_v-precotiza-1.  
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-COT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-COT W-Win
ON CHOOSE OF BUTTON-COT IN FRAME F-Main /* Historico Cotizaciones */
DO:
  RUN vta/wconcotcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
             INPUT  'v-precotiza-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-precotiza-1 ).
       RUN set-position IN h_v-precotiza-1 ( 1.27 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.23 , 111.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 9.88 , 10.72 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.46 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv06.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv06 ).
       RUN set-position IN h_p-updv06 ( 9.88 , 29.00 ) NO-ERROR.
       RUN set-size IN h_p-updv06 ( 1.42 , 57.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/q-pedido2x.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-pedido2x ).
       RUN set-position IN h_q-pedido2x ( 10.00 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.04 , 8.29 ) */

       /* Links to SmartViewer h_v-precotiza-1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv06 , 'TableIO':U , h_v-precotiza-1 ).
       RUN add-link IN adm-broker-hdl ( h_q-pedido2x , 'Record':U , h_v-precotiza-1 ).

       /* Links to SmartQuery h_q-pedido2x. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-pedido2x ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-precotiza-1 ,
             B-CCTE:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             BUTTON-COT:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv06 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-pedido2x ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-cotexp-2-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cotexp-2-1 ).
       RUN set-position IN h_b-cotexp-2-1 ( 11.62 , 2.72 ) NO-ERROR.
       RUN set-size IN h_b-cotexp-2-1 ( 10.65 , 130.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-cotexp-2-1. */
       RUN add-link IN adm-broker-hdl ( h_q-pedido2x , 'Record':U , h_b-cotexp-2-1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-cotexp-2-1 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/t-cotexp-2x-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-cotexp-2x-1 ).
       RUN set-position IN h_t-cotexp-2x-1 ( 11.50 , 3.00 ) NO-ERROR.
       RUN set-size IN h_t-cotexp-2x-1 ( 11.08 , 131.57 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-cotexp-2x-1 ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  ENABLE RECT-69 B-CCTE BUTTON-COT BUTTON-6 
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
          IF h_t-cotexp-2x-1 <> ? THEN RUN dispatch IN h_t-cotexp-2x-1 ('open-query':U).
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         BUTTON-2:SENSITIVE = YES.
         BUTTON-6:SENSITIVE = YES.
         RUN adm-open-query IN h_b-cotexp-2-1.
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).         
         BUTTON-2:SENSITIVE = NO.
         BUTTON-6:SENSITIVE = NO.
      END.
    WHEN "Recalculo" THEN DO WITH FRAME {&FRAME-NAME}:
        RUN Recalcular-Precios IN h_t-cotexp-2x-1.
      END.
    WHEN "Disable-Head" THEN DO:
        RUN dispatch IN h_p-updv06 ('disable':U).
      END.
    WHEN "Enable-Head" THEN DO:
        RUN dispatch IN h_p-updv06 ('enable':U).
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

