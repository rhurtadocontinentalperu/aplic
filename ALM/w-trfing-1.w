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
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE NEW SHARED VAR lh_Handle   AS HANDLE.
DEFINE NEW SHARED VAR S-NROSER AS INTEGER.
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE almdmov.
DEFINE NEW SHARED VAR S-TPOMOV AS CHAR INIT 'I'.
DEFINE NEW SHARED VAR S-MOVTRF AS INTEGER.
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */
DEFINE NEW SHARED VARIABLE S-MOVVAL  AS LOGICAL.
DEFINE NEW SHARED VARIABLE S-CODMOV  AS INTEGER.
DEFINE NEW SHARED VARIABLE ORDTRB    AS CHAR.

/* CHEQUEAMOS LA CONFIGURACION DE MOVIMIENTOS */
FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
                     AND  Almtmovm.Tipmov = "I" 
                     AND  Almtmovm.MovTrf 
                    NO-LOCK NO-ERROR.
IF AVAILABLE Almtmovm THEN S-MOVTRF = Almtmovm.Codmov.
IF NOT AVAILABLE Almtmovm THEN DO:
   MESSAGE "No existe movimiento de Ingreso por Transferencia" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

/* CHEQUEAMOS LA CONFIGURACION DE CORRELATIVOS */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA 
                     AND  Almtdocm.CodAlm = S-CODALM 
                     AND  Almtdocm.TipMov = "I"
                     AND  Almtdocm.Codmov = Almtmovm.Codmov
                    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
   MESSAGE "No esta asignado el movimiento" SKIP
           "de Ingreso por Transferencia" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
S-CODMOV = Almtdocm.Codmov.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ingrso AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpin2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-alctrf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-trfing AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-movmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-trfing-1 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Transf 
     LABEL "Procesar" 
     SIZE 11 BY 1.04
     FONT 0.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn-Transf AT ROW 7.35 COL 76.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.72 BY 13.96
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
         TITLE              = "Ingresos por Transferencia"
         HEIGHT             = 13.96
         WIDTH              = 87.43
         MAX-HEIGHT         = 17.73
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17.73
         VIRTUAL-WIDTH      = 91.43
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
/* SETTINGS FOR BUTTON Btn-Transf IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       Btn-Transf:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Ingresos por Transferencia */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Ingresos por Transferencia */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Transf W-Win
ON CHOOSE OF Btn-Transf IN FRAME F-Main /* Procesar */
DO:
  RUN Procesar-Documento-Origen IN h_v-trfing-1.
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
             INPUT  'alm/v-movmto.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-movmto ).
       RUN set-position IN h_v-movmto ( 1.00 , 12.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 58.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-trfing-1.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-trfing-1 ).
       RUN set-position IN h_v-trfing-1 ( 2.35 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.31 , 87.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 5.54 , 21.72 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.42 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 5.58 , 39.57 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.42 , 48.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/q-trfing.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-trfing ).
       RUN set-position IN h_q-trfing ( 1.15 , 71.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.00 , 14.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-alctrf.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-alctrf ).
       RUN set-position IN h_q-alctrf ( 5.81 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-movmto. */
       RUN add-link IN adm-broker-hdl ( h_q-trfing , 'Record':U , h_v-movmto ).

       /* Links to SmartViewer h_v-trfing-1. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-trfing-1 ).
       RUN add-link IN adm-broker-hdl ( h_q-alctrf , 'Record':U , h_v-trfing-1 ).

       /* Links to SmartQuery h_q-alctrf. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-alctrf ).
       RUN add-link IN adm-broker-hdl ( h_q-trfing , 'Record':U , h_q-alctrf ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-movmto ,
             Btn-Transf:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-trfing-1 ,
             h_v-movmto , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_v-trfing-1 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-trfing ,
             Btn-Transf:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-alctrf ,
             h_q-trfing , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-ingrso.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ingrso ).
       RUN set-position IN h_b-ingrso ( 7.08 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-ingrso ( 7.23 , 86.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ingrso. */
       RUN add-link IN adm-broker-hdl ( h_q-alctrf , 'Record':U , h_b-ingrso ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ingrso ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-tmpintr.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpin2 ).
       RUN set-position IN h_b-tmpin2 ( 7.04 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-tmpin2 ( 7.92 , 72.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 8.62 , 76.86 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 5.08 , 11.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpin2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpin2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpin2 ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             Btn-Transf:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 2 ).

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
  VIEW FRAME F-Main IN WINDOW W-Win.
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
  ASSIGN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " [ " + S-CODALM + " - " + S-DESALM + " ]".
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
         RUN dispatch IN h_b-ingrso ('open-query':U).
         RUN dispatch IN h_b-tmpin2 ('open-query':U).
      END.
    WHEN "Pagina1" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         Btn-Transf:VISIBLE = NO.
         RUN dispatch IN h_b-ingrso ('open-query':U).
      END.
    WHEN "Pagina2" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         Btn-Transf:VISIBLE = YES.
         RUN dispatch IN h_b-tmpin2 ('open-query':U).
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

