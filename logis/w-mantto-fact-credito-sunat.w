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

/* ********************************************************************************** */
/* RHC 20/07/2015 definimos s-codcia s-codalm s-desalm y s-coddiv SOLO para ALMACENES */
{alm/windowalmacen.i}
/* ********************************************************************************** */

DEF INPUT PARAMETER pParametro AS CHAR.

DEF NEW SHARED VAR s-permiso-anulacion AS LOG.

ASSIGN s-permiso-anulacion = LOGICAL(pParametro) NO-ERROR.
IF s-permiso-anulacion = ? THEN DO:
    MESSAGE 'El parámetro debe ser un YES o NO' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE NEW SHARED VARIABLE S-CODDOC   AS CHAR INITIAL "FAC".
DEFINE NEW SHARED VARIABLE S-TPOFAC   AS CHAR INITIAL "CR,F".     /* CREDITO FAI */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE NEW SHARED VARIABLE S-IMPFLE   AS DECIMAL.

DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.

DEFINE VARIABLE L-NROSER   AS CHAR NO-UNDO.

FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND 
           LOOKUP(FacCorre.CodDoc, 'FAC,BOL,TCK') > 0 AND 
           FacCorre.CodDiv = S-CODDIV 
           NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEF NEW SHARED VAR s-Sunat-Activo AS LOG INIT NO.
FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia 
    AND GN-DIVI.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'NO está configurada la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
s-Sunat-Activo = gn-divi.campo-log[10].

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
&Scoped-Define ENABLED-OBJECTS RECT-66 RECT-67 BUTTON-1 BUTTON-KITS ~
BUTTON-8 BUTTON-9 BUTTON-11 BtnDone C-CodDoc C-NroSer 
&Scoped-Define DISPLAYED-OBJECTS C-CodDoc C-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-mantto-fact-credito AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-mantto-fact-credito-gr AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-docmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-mantto-fact-credito AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     LABEL "Salir" 
     SIZE 10 BY .81
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\excel":U
     LABEL "" 
     SIZE 10 BY 1.35 TOOLTIP "Migrar a Excel".

DEFINE BUTTON BUTTON-11 
     LABEL "Buscar" 
     SIZE 10 BY .81.

DEFINE BUTTON BUTTON-8 
     LABEL "Eliminar" 
     SIZE 10 BY .81.

DEFINE BUTTON BUTTON-9 
     LABEL "Imprimir" 
     SIZE 10 BY .81.

DEFINE BUTTON BUTTON-KITS 
     LABEL "ANEXO KITS" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE C-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "FAC","BOL","FAI","TCK" 
     DROP-DOWN-LIST
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE C-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 42 BY 1.35
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-67
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 130 BY 7.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 121
     BUTTON-KITS AT ROW 1.19 COL 103 WIDGET-ID 20
     BUTTON-8 AT ROW 1.27 COL 3 WIDGET-ID 8
     BUTTON-9 AT ROW 1.27 COL 13 WIDGET-ID 12
     BUTTON-11 AT ROW 1.27 COL 23 WIDGET-ID 18
     BtnDone AT ROW 1.27 COL 33 WIDGET-ID 14
     C-CodDoc AT ROW 1.27 COL 46.14
     C-NroSer AT ROW 1.27 COL 63.71
     "Buscar el número:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 1.54 COL 76 WIDGET-ID 6
     RECT-66 AT ROW 1 COL 2 WIDGET-ID 10
     RECT-67 AT ROW 2.35 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.57 BY 25.42
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
         TITLE              = "REGISTRO FACTURAS"
         HEIGHT             = 25.42
         WIDTH              = 142.57
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
/* SETTINGS FOR COMBO-BOX C-CodDoc IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX C-NroSer IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REGISTRO FACTURAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REGISTRO FACTURAS */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main
DO:
  RUN Excel IN h_v-mantto-fact-credito.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 W-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Buscar */
DO:
  RUN dispatch IN h_q-docmto ('qbusca':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Eliminar */
DO:
   RUN dispatch IN h_v-mantto-fact-credito ('delete-record':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Imprimir */
DO:
  RUN dispatch IN h_v-mantto-fact-credito ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-KITS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-KITS W-Win
ON CHOOSE OF BUTTON-KITS IN FRAME F-Main /* ANEXO KITS */
DO:
   RUN Anexo-Kits IN h_v-mantto-fact-credito.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-CodDoc W-Win
ON VALUE-CHANGED OF C-CodDoc IN FRAME F-Main /* Comprobante */
DO:
   FIND FIRST FacCorre WHERE 
              FacCorre.CodCia = S-CODCIA AND
              FacCorre.CodDoc = C-CODDOC:SCREEN-VALUE AND
              FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
   IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   ASSIGN C-CODDOC 
          S-CODDOC = C-CODDOC.
   RUN Carga-Series.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-NroSer W-Win
ON VALUE-CHANGED OF C-NroSer IN FRAME F-Main /* Serie */
DO:
  ASSIGN C-NroSer.
  S-NROSER = INTEGER(ENTRY(LOOKUP(C-NroSer,C-NroSer:LIST-ITEMS),C-NroSer:LIST-ITEMS)).
  RUN dispatch IN h_q-docmto ('open-query':U).
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
             INPUT  'adm/objects/p-navico.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.35 , 132.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 5.12 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/v-mantto-fact-credito-sunat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-mantto-fact-credito ).
       RUN set-position IN h_v-mantto-fact-credito ( 2.62 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.27 , 128.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Detalle del Comprobante|Guias de Remision Relacionadas':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 10.15 , 1.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 16.15 , 142.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta2/q-docmto.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-docmto ).
       RUN set-position IN h_q-docmto ( 1.00 , 88.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.04 , 11.00 ) */

       /* Links to SmartViewer h_v-mantto-fact-credito. */
       RUN add-link IN adm-broker-hdl ( h_q-docmto , 'Record':U , h_v-mantto-fact-credito ).

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Links to SmartQuery h_q-docmto. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-docmto ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             C-NroSer:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-mantto-fact-credito ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             h_v-mantto-fact-credito , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-docmto ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'logis/b-mantto-fact-credito-sunat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-mantto-fact-credito ).
       RUN set-position IN h_b-mantto-fact-credito ( 11.23 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-mantto-fact-credito ( 14.27 , 140.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-mantto-fact-credito. */
       RUN add-link IN adm-broker-hdl ( h_q-docmto , 'Record':U , h_b-mantto-fact-credito ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-mantto-fact-credito ,
             h_tab95 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/b-mantto-fact-credito-gr.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-mantto-fact-credito-gr ).
       RUN set-position IN h_b-mantto-fact-credito-gr ( 11.50 , 3.00 ) NO-ERROR.
       RUN set-size IN h_b-mantto-fact-credito-gr ( 14.00 , 45.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-mantto-fact-credito-gr. */
       RUN add-link IN adm-broker-hdl ( h_q-docmto , 'Record':U , h_b-mantto-fact-credito-gr ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-mantto-fact-credito-gr ,
             h_tab95 , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  L-NROSER = "".
  FOR EACH FacCorre NO-LOCK WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = S-CODDOC AND
           FacCorre.CodDiv = S-CODDIV:
      IF L-NROSER = "" THEN L-NROSER = STRING(FacCorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(FacCorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NROSER.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
  END.
  
  RUN dispatch IN h_q-docmto ('open-query':U).

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
  DISPLAY C-CodDoc C-NroSer 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-66 RECT-67 BUTTON-1 BUTTON-KITS BUTTON-8 BUTTON-9 BUTTON-11 
         BtnDone C-CodDoc C-NroSer 
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
  lh_Handle = THIS-PROCEDURE.
  RUN Procesa-Handle ("Pagina1").
  C-CodDoc = S-CODDOC.
  DISPLAY C-CodDoc WITH FRAME {&FRAME-NAME}.
  RUN Carga-Series.
    
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
          RUN dispatch IN h_b-mantto-fact-credito ('open-query':U).
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

