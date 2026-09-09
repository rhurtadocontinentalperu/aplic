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
DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-DESALM AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE almdmov.
DEFINE NEW SHARED VAR S-TPOMOV AS CHAR INIT 'S'.
DEFINE NEW SHARED VAR S-MOVTRF AS INTEGER.
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */
DEFINE NEW SHARED VARIABLE S-MOVVAL  AS LOGICAL.
DEFINE NEW SHARED VARIABLE C-CODALM  AS CHAR.

/* UBICAMOS LOS MOVIMIENTOS VALIDOS */
FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
     Almtmovm.Tipmov = "S" AND
     Almtmovm.MovTrf NO-LOCK NO-ERROR.
IF AVAILABLE Almtmovm THEN S-MOVTRF = Almtmovm.Codmov.
IF NOT AVAILABLE Almtmovm THEN DO:
    MESSAGE 'No se ha definido ningun movimiento de Salida por Transferencia'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/*FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
 *      Almtmovm.Tipmov = "S" AND
 *      Almtmovm.CodMov = 03  NO-LOCK NO-ERROR.
 * IF AVAILABLE Almtmovm THEN S-MOVTRF = Almtmovm.Codmov.*/

/* CHEQUEAMOS LA CONFIGURACION DE MOVIENTOS POR ALMACEN */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA AND
     Almtdocm.CodAlm = S-CODALM AND
     Almtdocm.TipMov = "S" AND
     Almtdocm.CodMov = S-MOVTRF NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
   MESSAGE "No existen movimientos asignados al almacen" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

/* UBICAMOS EL CORRELATIVO POR DIVISION Y ALMACEN Y DOCUMENTO = G/R */
FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.CodDoc = "G/R" AND
           FacCorre.CodAlm = S-CODALM AND
           FacCorre.TipMov = 'S' AND
           FacCorre.CodMov = s-MovTrf
           NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Correlativo de Guia de Remision no esta configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

S-NROSER = FacCorre.NroSer.

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
&Scoped-Define ENABLED-OBJECTS B-Material Btn-GenPed B-Producto B-Merma 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-salida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpsal2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpsal3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-alctrf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-trfsal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-movmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-trfsal-03 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Material 
     LABEL "OP/Materiales" 
     SIZE 10.29 BY .96.

DEFINE BUTTON B-Merma 
     LABEL "OP/Merma" 
     SIZE 10.29 BY .96.

DEFINE BUTTON B-Producto 
     LABEL "OP/Pro.Termin" 
     SIZE 10.29 BY .96.

DEFINE BUTTON Btn-GenPed 
     LABEL "Req.Material" 
     SIZE 10.29 BY .96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     B-Material AT ROW 7.23 COL 77.29
     Btn-GenPed AT ROW 7.42 COL 77.14
     B-Producto AT ROW 8.31 COL 77.43
     B-Merma AT ROW 9.35 COL 77.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 1
         SIZE 88.43 BY 15.27
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
         TITLE              = "Salida de Material a Produccion/Convertidoras"
         HEIGHT             = 15.38
         WIDTH              = 89.29
         MAX-HEIGHT         = 18.62
         MAX-WIDTH          = 111
         VIRTUAL-HEIGHT     = 18.62
         VIRTUAL-WIDTH      = 111
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Salida de Material a Produccion/Convertidoras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Salida de Material a Produccion/Convertidoras */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Material
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Material W-Win
ON CHOOSE OF B-Material IN FRAME F-Main /* OP/Materiales */
DO:
  RUN Asigna-Orden-Materiales IN h_v-trfsal-03.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Merma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Merma W-Win
ON CHOOSE OF B-Merma IN FRAME F-Main /* OP/Merma */
DO:
  RUN Asigna-Orden-Merma IN h_v-trfsal-03.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Producto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Producto W-Win
ON CHOOSE OF B-Producto IN FRAME F-Main /* OP/Pro.Termin */
DO:
  RUN Asigna-Orden-Productos IN h_v-trfsal-03.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-GenPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-GenPed W-Win
ON CHOOSE OF Btn-GenPed IN FRAME F-Main /* Req.Material */
DO:
  RUN Asigna-Documento IN h_v-trfsal-03.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}
  
  ASSIGN lh_Handle = THIS-PROCEDURE.

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
       RUN set-position IN h_v-movmto ( 1.00 , 13.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 58.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pro/v-salmat-03.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-trfsal-03 ).
       RUN set-position IN h_v-trfsal-03 ( 2.31 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 3.58 , 87.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 5.81 , 21.29 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 16.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 5.81 , 38.43 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.31 , 49.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-trfsal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-trfsal ).
       RUN set-position IN h_q-trfsal ( 1.19 , 73.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 15.43 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-alctrf.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-alctrf ).
       RUN set-position IN h_q-alctrf ( 6.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-movmto. */
       RUN add-link IN adm-broker-hdl ( h_q-trfsal , 'Record':U , h_v-movmto ).

       /* Links to SmartViewer h_v-trfsal-03. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-trfsal-03 ).
       RUN add-link IN adm-broker-hdl ( h_q-alctrf , 'Record':U , h_v-trfsal-03 ).

       /* Links to SmartQuery h_q-alctrf. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-alctrf ).
       RUN add-link IN adm-broker-hdl ( h_q-trfsal , 'Record':U , h_q-alctrf ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-movmto ,
             B-Material:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-trfsal-03 ,
             h_v-movmto , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_v-trfsal-03 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-alctrf ,
             B-Merma:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pro/b-salida.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-salida ).
       RUN set-position IN h_b-salida ( 7.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-salida ( 8.62 , 75.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-salida. */
       RUN add-link IN adm-broker-hdl ( h_q-alctrf , 'Record':U , h_b-salida ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-salida ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pro/b-tmpsal2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpsal2 ).
       RUN set-position IN h_b-tmpsal2 ( 7.19 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-tmpsal2 ( 7.69 , 75.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 10.58 , 76.86 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.81 , 11.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpsal2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpsal2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpsal2 ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             B-Merma:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'pro/b-tmpsal3.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpsal3 ).
       RUN set-position IN h_b-tmpsal3 ( 7.23 , 1.43 ) NO-ERROR.
       RUN set-size IN h_b-tmpsal3 ( 7.69 , 75.14 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 10.04 , 76.72 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 5.08 , 11.14 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpsal3. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_b-tmpsal3 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpsal3 ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             B-Merma:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 3 */

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
  ENABLE B-Material Btn-GenPed B-Producto B-Merma 
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
  ASSIGN {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " [ " + S-CODALM + " - " + S-DESALM + " ]".
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
    WHEN "browse"   THEN DO:
          RUN dispatch IN h_b-salida ('open-query':U).
          RUN dispatch IN h_b-tmpsal2 ('open-query':U).
       END.
    WHEN "browse3"   THEN DO:
          RUN dispatch IN h_b-salida ('open-query':U).
          RUN dispatch IN h_b-tmpsal3 ('open-query':U).
       END.

    WHEN "Inactiva" THEN RUN dispatch IN h_b-salida ('hide':U).
    WHEN "Activa"   THEN RUN dispatch IN h_b-salida ('view':U).
    WHEN "Pagina1"  THEN DO:
         RUN select-page(1).
         Btn-GenPed:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Material:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Producto:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Merma:VISIBLE IN FRAME {&FRAME-NAME} = NO.

         RUN dispatch IN h_b-salida ('open-query':U).
    END.
    WHEN "Pagina2"  THEN DO:
         RUN select-page(2).
         Btn-GenPed:VISIBLE IN FRAME {&FRAME-NAME} = YES.
         B-Material:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Producto:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Merma:VISIBLE IN FRAME {&FRAME-NAME} = NO.         
         RUN dispatch IN h_b-tmpsal2 ('open-query':U).
    END.
    WHEN "Pagina3"  THEN DO:
         RUN select-page(3).
         Btn-GenPed:VISIBLE IN FRAME {&FRAME-NAME} = NO.
         B-Material:VISIBLE IN FRAME {&FRAME-NAME} = YES.
         B-Producto:VISIBLE IN FRAME {&FRAME-NAME} = YES.
         B-Merma:VISIBLE IN FRAME {&FRAME-NAME} = YES.
         RUN dispatch IN h_b-tmpsal3 ('open-query':U).

    END.
    WHEN "Carga-Series" THEN RUN Carga-Series IN h_q-trfsal.
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

