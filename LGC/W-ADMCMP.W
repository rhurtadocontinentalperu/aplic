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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-OrdCmp C-Situacion Btn-Aprobar ~
Btn-Aceptar Btn-Cancela Btn-Rechaza Btn-Salir 
&Scoped-Define DISPLAYED-OBJECTS C-Situacion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-cabreq AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detcmp AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-detreq AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-reqord AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv96 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Aceptar 
     LABEL "Aceptar" 
     SIZE 9 BY .85.

DEFINE BUTTON Btn-Aprobar 
     LABEL "Aprobar" 
     SIZE 9 BY .85.

DEFINE BUTTON Btn-Cancela 
     LABEL "Cancelar" 
     SIZE 9 BY .85.

DEFINE BUTTON Btn-OrdCmp 
     LABEL "Generar O/C" 
     SIZE 12.43 BY .85
     FONT 1.

DEFINE BUTTON Btn-Rechaza 
     LABEL "Rechazar" 
     SIZE 9 BY .85.

DEFINE BUTTON Btn-Salir 
     LABEL "Salir" 
     SIZE 9 BY .85
     FONT 1.

DEFINE VARIABLE C-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Solicitada" 
     LABEL "Situacion de Req." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Solicitada","Rechazada","Aprobadas","Con O/C" 
     SIZE 14.14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-OrdCmp AT ROW 5.81 COL 1.14
     C-Situacion AT ROW 5.81 COL 62.86 COLON-ALIGNED
     Btn-Aprobar AT ROW 1.19 COL 70
     Btn-Aceptar AT ROW 2.08 COL 70
     Btn-Cancela AT ROW 2.96 COL 70
     Btn-Rechaza AT ROW 3.85 COL 70
     Btn-Salir AT ROW 13.12 COL 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 79.57 BY 15.12
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
         TITLE              = "Administrador de Compras"
         HEIGHT             = 15.12
         WIDTH              = 79.57
         MAX-HEIGHT         = 15.12
         MAX-WIDTH          = 89
         VIRTUAL-HEIGHT     = 15.12
         VIRTUAL-WIDTH      = 89
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
ON END-ERROR OF W-Win /* Administrador de Compras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Administrador de Compras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Aceptar W-Win
ON CHOOSE OF Btn-Aceptar IN FRAME F-Main /* Aceptar */
DO:
  RUN dispatch IN h_p-updv96 ('hide':U).
  Btn-Aceptar:VISIBLE = NO.
  Btn-Cancela:VISIBLE = NO.
  Btn-Aprobar:VISIBLE = YES.
  Btn-Rechaza:VISIBLE = YES.
  C-Situacion:SENSITIVE = YES.
  RUN Aprobar-Requisicion IN h_b-cabreq.
  MESSAGE "Desea generar las ordenes de compra" VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO UPDATE Rpta AS LOGICA.
  IF Rpta THEN RUN Generar-Ordenes-Compra IN h_b-cabreq.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Aprobar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Aprobar W-Win
ON CHOOSE OF Btn-Aprobar IN FRAME F-Main /* Aprobar */
DO:
  RUN dispatch IN h_p-updv96 ('view':U).
  Btn-Aceptar:VISIBLE = YES.
  Btn-Cancela:VISIBLE = YES.
  Btn-Aprobar:VISIBLE = NO.
  Btn-Rechaza:VISIBLE = NO.
  C-Situacion:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Cancela W-Win
ON CHOOSE OF Btn-Cancela IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN h_p-updv96 ('hide':U).
  Btn-Aceptar:VISIBLE = NO.
  Btn-Cancela:VISIBLE = NO.
  Btn-Aprobar:VISIBLE = YES.
  Btn-Rechaza:VISIBLE = YES.
  C-Situacion:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-OrdCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-OrdCmp W-Win
ON CHOOSE OF Btn-OrdCmp IN FRAME F-Main /* Generar O/C */
DO:
  RUN Orden-de-Compra IN h_b-cabreq.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Rechaza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Rechaza W-Win
ON CHOOSE OF Btn-Rechaza IN FRAME F-Main /* Rechazar */
DO:
  RUN Rechazar-Requisicion IN h_b-cabreq. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Salir W-Win
ON CHOOSE OF Btn-Salir IN FRAME F-Main /* Salir */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-Situacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Situacion W-Win
ON VALUE-CHANGED OF C-Situacion IN FRAME F-Main /* Situacion de Req. */
DO:
  ASSIGN C-Situacion.
  Btn-Aprobar:VISIBLE = ENTRY(LOOKUP(C-Situacion,C-Situacion:LIST-ITEMS),"S,R,A,C") = "S".
  Btn-Rechaza:VISIBLE = ENTRY(LOOKUP(C-Situacion,C-Situacion:LIST-ITEMS),"S,R,A,C") = "S".
  Btn-OrdCmp:VISIBLE = ENTRY(LOOKUP(C-Situacion,C-Situacion:LIST-ITEMS),"S,R,A,C") = "A".
  IF ENTRY(LOOKUP(C-Situacion,C-Situacion:LIST-ITEMS),"S,R,A,C") = "C" THEN
       RUN select-page(2).
  ELSE DO:
      RUN select-page(1).
      RUN dispatch IN h_p-updv96 ('hide':U).
  END.
  RUN Situacion-de-Requisiciones IN h_b-cabreq
    (ENTRY(LOOKUP(C-Situacion,C-Situacion:LIST-ITEMS),"S,R,A,C")).
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
             INPUT  'lgc/b-cabreq.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-cabreq ).
       RUN set-position IN h_b-cabreq ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.73 , 68.29 ) */

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-detreq.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detreq ).
       RUN set-position IN h_b-detreq ( 6.77 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.19 , 67.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv96.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv96 ).
       RUN set-position IN h_p-updv96 ( 6.77 , 69.14 ) NO-ERROR.
       RUN set-size IN h_p-updv96 ( 3.58 , 10.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-detreq. */
       RUN add-link IN adm-broker-hdl ( h_b-cabreq , 'Record':U , h_b-detreq ).
       RUN add-link IN adm-broker-hdl ( h_p-updv96 , 'TableIO':U , h_b-detreq ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-reqord.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reqord ).
       RUN set-position IN h_b-reqord ( 6.77 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.88 , 68.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-detcmp.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detcmp ).
       RUN set-position IN h_b-detcmp ( 10.81 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.19 , 68.29 ) */

       /* Links to SmartBrowser h_b-reqord. */
       RUN add-link IN adm-broker-hdl ( h_b-cabreq , 'Record':U , h_b-reqord ).

       /* Links to SmartBrowser h_b-detcmp. */
       RUN add-link IN adm-broker-hdl ( h_b-reqord , 'Record':U , h_b-detcmp ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  DISPLAY C-Situacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn-OrdCmp C-Situacion Btn-Aprobar Btn-Aceptar Btn-Cancela Btn-Rechaza 
         Btn-Salir 
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
  
  DO WITH FRAME {&FRAME-NAME}:
     Btn-Aceptar:VISIBLE = NO.
     Btn-Cancela:VISIBLE = NO.
     Btn-OrdCmp:VISIBLE = NO.
     RUN dispatch IN h_p-updv96 ('hide':U).
  END.
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


