&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-VVALE LIKE integral.VtaVVale.


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
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedm.
DEFINE NEW SHARED VARIABLE S-CODDOC   AS CHAR INITIAL "P/M".
DEFINE NEW SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE NEW SHARED VARIABLE S-CODMON   AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-VENTA    AS INTEGER INITIAL 1.
DEFINE NEW SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE NEW SHARED VARIABLE S-CNDVTA   AS CHAR INIT "000".
DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.
DEFINE NEW SHARED VARIABLE S-IMPTOT   AS DEC.

DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE     SHARED VARIABLE S-LisNiv   AS CHAR.

/* RHC 20-02-04 para evitar conflictos con los P/M al credito lo rastreamos por el almacen de despacho */
FIND FacUsers WHERE facusers.codcia = s-codcia AND facusers.usuario = s-user-id NO-LOCK.
s-CodAlm = FacUsers.codalm.      /* OJO */

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
               AND  FacCorre.CodDoc = S-CODDOC 
               AND  FacCorre.CodDiv = S-CODDIV 
               AND  FacCorre.CodAlm = S-CODALM      /* OJO solo definir un P/M por almacen */
              NO-LOCK NO-ERROR.

IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.
ELSE ASSIGN S-CodAlm = FacCorre.CodAlm.     /* Redundante pero que importa */

DEFINE NEW SHARED VARIABLE input-var-1 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE input-var-3 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-1 AS ROWID.
DEFINE NEW SHARED VARIABLE output-var-2 AS CHARACTER.
DEFINE NEW SHARED VARIABLE output-var-3 AS CHARACTER.

DEF NEW SHARED TEMP-TABLE T-CcbDDocu LIKE CcbDDocu.
DEF NEW SHARED TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEF NEW SHARED VAR s-codcja AS CHAR INITIAL "I/C".
DEF NEW SHARED VAR s-ptovta AS INT.
DEF NEW SHARED VAR s-sercja AS INT.
DEF NEW SHARED VAR s-tipo   AS CHAR INITIAL "MOSTRADOR".
DEF NEW SHARED VAR s-codmov LIKE Almtmovm.Codmov.
DEF NEW SHARED VARIABLE s-PorDto  AS DEC.

DEF SHARED VAR s-codter LIKE ccbcterm.codter.

FIND FIRST ccbdterm WHERE CcbDTerm.CodCia = s-codcia AND
     CcbDTerm.CodDiv = s-coddiv AND
     CcbDTerm.CodDoc = s-codcja AND
     CcbDTerm.CodTer = s-codter NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbdterm
THEN DO:
    MESSAGE "EL Documento de Caja no sta configurada en este terminal" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-sercja = ccbdterm.nroser.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 BUTTON-2 BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-tmpvtm AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-vtamos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-vtamos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-vtamo1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-vtamos AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\caja3":U
     LABEL "" 
     SIZE 7.43 BY 1.38.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\integral":U
     LABEL "C/Factura" 
     SIZE 7.43 BY 1.38.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 8.57 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 7.54 COL 73
     BUTTON-1 AT ROW 7.54 COL 80.86
     RECT-19 AT ROW 7.54 COL 80
     "F11  Registrar Cantidad" VIEW-AS TEXT
          SIZE 35.72 BY .5 AT ROW 18.5 COL 2
          FONT 0
     "F12  Repetir Ultimo ITEM" VIEW-AS TEXT
          SIZE 36.14 BY .5 AT ROW 19.08 COL 2
          FONT 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 19.85
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-VVALE T "NEW SHARED" ? integral VtaVVale
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Venta Mostrador"
         HEIGHT             = 19.85
         WIDTH              = 89.43
         MAX-HEIGHT         = 25.88
         MAX-WIDTH          = 137.14
         VIRTUAL-HEIGHT     = 25.88
         VIRTUAL-WIDTH      = 137.14
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
ON END-ERROR OF W-Win /* Venta Mostrador */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Venta Mostrador */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main
DO:
  RUN Cancelar-Pedido IN h_v-vtamos.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* C/Factura */
DO:
  RUN Canje-Factura IN h_v-vtamos.
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
             INPUT  'aplic/vta/v-vtaaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-vtamos ).
       RUN set-position IN h_v-vtamos ( 1.00 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 6.35 , 88.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 7.54 , 9.72 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.35 , 16.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv02 ).
       RUN set-position IN h_p-updv02 ( 7.54 , 26.14 ) NO-ERROR.
       RUN set-size IN h_p-updv02 ( 1.35 , 46.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/q-vtaaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-vtamos ).
       RUN set-position IN h_q-vtamos ( 7.62 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 14.86 ) */

       /* Links to SmartViewer h_v-vtamos. */
       RUN add-link IN adm-broker-hdl ( h_p-updv02 , 'TableIO':U , h_v-vtamos ).
       RUN add-link IN adm-broker-hdl ( h_q-vtamos , 'Record':U , h_v-vtamos ).

       /* Links to SmartQuery h_q-vtamos. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-vtamos ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-vtaaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-vtamos ).
       RUN set-position IN h_b-vtamos ( 8.88 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 7.92 , 88.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vta/v-vtamo1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-vtamo1 ).
       RUN set-position IN h_v-vtamo1 ( 16.92 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.77 , 87.43 ) */

       /* Links to SmartBrowser h_b-vtamos. */
       RUN add-link IN adm-broker-hdl ( h_q-vtamos , 'Record':U , h_b-vtamos ).

       /* Links to SmartViewer h_v-vtamo1. */
       RUN add-link IN adm-broker-hdl ( h_b-vtamos , 'Record':U , h_v-vtamo1 ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta/b-tmpaut.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpvtm ).
       RUN set-position IN h_b-tmpvtm ( 8.88 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.27 , 89.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = Multiple-Records':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 18.35 , 39.43 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.31 , 48.29 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpvtm. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpvtm ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 2 ).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-pedidos W-Win 
PROCEDURE Busca-pedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    input-var-1 = "P/M".
    input-var-2 = "".
    RUN lkup\C-Pedmos.r("Pedidos por Modificar").
    IF output-var-2 <> ? THEN DO:
        FIND faccpedm WHERE faccpedm.CodCia = S-CODCIA AND
             faccpedm.usuario = S-USER-ID AND
             faccpedm.CodDoc = s-coddoc AND
             faccpedm.NroPed = SUBSTRING(output-var-2 ,4,9)
             NO-LOCK NO-ERROR.
        IF AVAILABLE faccpedm THEN output-var-1 = ROWID(faccpedm).
        ELSE output-var-1 = ?.
    
        RUN localiza IN h_q-vtamos (output-var-1).
        
        RETURN NO-APPLY.

    END.

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
  ENABLE RECT-19 BUTTON-2 BUTTON-1 
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
         RUN dispatch IN h_b-vtamos ('open-query':U).
         RUN dispatch IN h_b-tmpvtm ('open-query':U).
       END.
    WHEN "browse1" THEN DO:
/*         RUN dispatch IN h_b-vtamos ('open-query':U).*/
         RUN dispatch IN h_b-tmpvtm ('open-query':U).
         RUN dispatch IN h_b-tmpvtm ('apply-entry':U).
         RETURN NO-APPLY.
       END.
    WHEN "Pagina1" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
      END.
    WHEN "Pagina2" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
      END.
    WHEN "Recalculo" THEN DO WITH FRAME {&FRAME-NAME}:
         RUN Recalcular-Precios IN h_b-tmpvtm.
      END.
END CASE.

CASE L-Handle:
    WHEN "update-Btn-Add" THEN DO:
           RUN Proceso1 IN h_p-updv12.
       END.
    WHEN "update-Btn-Delete" THEN DO:
           RUN Proceso2 IN h_p-updv12.
       END.
    WHEN "update-Btn-Save" THEN DO:
           RUN Proceso3 IN h_p-updv12.
       END.
    WHEN "update-Btn-Cancel" THEN DO:
           RUN Proceso4 IN h_p-updv12.
           RUN dispatch IN h_b-tmpvtm ('open-query':U).
           RUN dispatch IN h_b-tmpvtm ('display-fields':U).
           RETURN NO-APPLY.
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


