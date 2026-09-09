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
/* MOVIMIENTO RESERVADO */
DEF INPUT PARAMETER pCodMov AS CHAR.

/* RHC 20/07/2015 definimos s-codcia s-codalm y s-coddiv SOLO para ALMACENES */
{alm/windowalmacen.i}
/* ************************************************************************* */

/* Local Variable Definitions ---                                       */
/* DEFINE SHARED VAR S-CODALM AS CHAR.    */
/* DEFINE SHARED VAR S-DESALM AS CHAR.    */
/* DEFINE SHARED VAR S-CODCIA AS INTEGER. */
/* DEFINE SHARED VAR S-CODDIV AS CHAR.    */

DEFINE NEW SHARED VARIABLE S-TPOMOV AS CHAR INIT 'S'.   /* Salidas */
DEFINE NEW SHARED VARIABLE C-CODMOV AS CHAR.    /* Mov Válidos */
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */

FIND FIRST Almtmov WHERE Almtmov.CodCia = S-CODCIA 
    AND Almtmovm.TipMov = S-TPOMOV 
    AND Almtmovm.CodMov = INTEGER (pCodMov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtmovm THEN DO:
    MESSAGE 'El código de movimiento de salida' pCodMov SKIP
        'NO está definido en la tabla de movimientos'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
IF Almtmovm.Indicador[1] = NO THEN DO:
    MESSAGE 'El código de movimiento de salida' pCodMov SKIP
        'NO es un movimiento reservado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    c-CodMov = TRIM(STRING(Almtmovm.codmov)).
/* CHEQUEAMOS LA CONFIGURACION DE CORRELATIVOS */
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA AND
     Almtdocm.CodAlm = S-CODALM AND
     Almtdocm.TipMov = S-TPOMOV AND
     LOOKUP(TRIM(STRING(Almtdocm.CodMov)), c-CodMov) > 0 NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
   MESSAGE "No existen movimientos asignados al almacen" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

DEFINE NEW SHARED TEMP-TABLE ITEM LIKE almdmov.

DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE NEW SHARED VARIABLE S-MOVVAL  AS LOGICAL.
DEFINE NEW SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE NEW SHARED VARIABLE ORDTRB    AS CHAR.

/* UBICAMOS EL CORRELATIVO POR DIVISION Y ALMACEN Y DOCUMENTO = G/R */
/* FIND FIRST FacCorre WHERE                                                                 */
/*            FacCorre.CodCia = S-CODCIA AND                                                 */
/*            FacCorre.CodDiv = S-CODDIV AND                                                 */
/*            FacCorre.CodDoc = "G/R" AND                                                    */
/*            FacCorre.CodAlm = S-CODALM                                                     */
/*            NO-LOCK NO-ERROR.                                                              */
/* IF NOT AVAILABLE FacCorre THEN DO:                                                        */
/*    MESSAGE "Correlativo de Guia de Remision no esta configurado" VIEW-AS ALERT-BOX ERROR. */
/*    RETURN ERROR.                                                                          */
/* END.                                                                                      */
/* S-NROSER = FacCorre.NroSer.                                                               */

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
&Scoped-Define ENABLED-OBJECTS BUTTON-items-pi 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ingres AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-salida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-tmpsal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-imp-excel-plantilla AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-alcmov AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-salida AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-ing-solovalor AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-movmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-salida AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-items-pi 
     LABEL "Items del PI" 
     SIZE 15 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-items-pi AT ROW 19.58 COL 101 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 115.57 BY 21.31
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 4
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Salidas de Almacen"
         HEIGHT             = 21.31
         WIDTH              = 115.57
         MAX-HEIGHT         = 22.31
         MAX-WIDTH          = 115.57
         VIRTUAL-HEIGHT     = 22.31
         VIRTUAL-WIDTH      = 115.57
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
ON END-ERROR OF W-Win /* Salidas de Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Salidas de Almacen */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-items-pi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-items-pi W-Win
ON CHOOSE OF BUTTON-items-pi IN FRAME F-Main /* Items del PI */
DO:
  RUN refrescar-items IN h_v-salida.
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
       RUN set-position IN h_v-movmto ( 1.00 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 58.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 72.43 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.31 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/v-salida.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-salida ).
       RUN set-position IN h_v-salida ( 2.35 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.65 , 101.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico-2 ).
       RUN set-position IN h_p-navico-2 ( 8.00 , 22.86 ) NO-ERROR.
       RUN set-size IN h_p-navico-2 ( 1.35 , 18.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 8.04 , 41.14 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.31 , 59.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/q-salida.r':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-salida ).
       RUN set-position IN h_q-salida ( 1.04 , 60.43 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 9.57 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/q-alcmov.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-alcmov ).
       RUN set-position IN h_q-alcmov ( 8.15 , 2.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-movmto. */
       RUN add-link IN adm-broker-hdl ( h_q-salida , 'Record':U , h_v-movmto ).

       /* Links to SmartViewer h_v-salida. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-salida ).
       RUN add-link IN adm-broker-hdl ( h_q-alcmov , 'Record':U , h_v-salida ).

       /* Links to SmartQuery h_q-salida. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-salida ).

       /* Links to SmartQuery h_q-alcmov. */
       RUN add-link IN adm-broker-hdl ( h_p-navico-2 , 'Navigation':U , h_q-alcmov ).
       RUN add-link IN adm-broker-hdl ( h_q-salida , 'Record':U , h_q-alcmov ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-movmto ,
             BUTTON-items-pi:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-movmto , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-salida ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico-2 ,
             h_v-salida , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-salida ,
             BUTTON-items-pi:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-alcmov ,
             h_q-salida , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-salida.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-salida ).
       RUN set-position IN h_b-salida ( 9.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-salida ( 11.92 , 103.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-salida. */
       RUN add-link IN adm-broker-hdl ( h_q-alcmov , 'Record':U , h_b-salida ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-salida ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'alm/b-tmpsal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-tmpsal ).
       RUN set-position IN h_b-tmpsal ( 9.46 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-tmpsal ( 12.54 , 98.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 9.46 , 100.57 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 5.23 , 11.57 ) NO-ERROR.

       /* Links to SmartBrowser h_b-tmpsal. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-tmpsal ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-tmpsal ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_b-tmpsal , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/t-ing-solovalor.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-ing-solovalor ).
       RUN set-position IN h_t-ing-solovalor ( 9.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-ing-solovalor ( 11.31 , 89.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12-2 ).
       RUN set-position IN h_p-updv12-2 ( 10.42 , 92.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12-2 ( 5.65 , 10.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/f-imp-excel-plantilla.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-imp-excel-plantilla ).
       RUN set-position IN h_f-imp-excel-plantilla ( 16.08 , 92.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.08 , 17.00 ) */

       /* Links to SmartBrowser h_t-ing-solovalor. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12-2 , 'TableIO':U , h_t-ing-solovalor ).
       RUN add-link IN adm-broker-hdl ( h_q-salida , 'Record':U , h_t-ing-solovalor ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-ing-solovalor ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12-2 ,
             h_t-ing-solovalor , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-imp-excel-plantilla ,
             h_p-updv12-2 , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-ingres.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ingres ).
       RUN set-position IN h_b-ingres ( 9.62 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ingres ( 7.85 , 92.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-ingres. */
       RUN add-link IN adm-broker-hdl ( h_q-alcmov , 'Record':U , h_b-ingres ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ingres ,
             h_p-updv05 , 'AFTER':U ).
    END. /* Page 4 */

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
  ENABLE BUTTON-items-pi 
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
  RUN Procesa-Handle("Pagina1").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones W-Win 
PROCEDURE Procesa-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParam AS CHAR NO-UNDO.

CASE pParam:
    WHEN "Importar-Excel" THEN DO:
        RUN Importar-Excel IN h_t-ing-solovalor.
    END.
END CASE.

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
          RUN dispatch IN h_b-tmpsal ('open-query':U).
       END.
    WHEN "Inactiva" THEN RUN dispatch IN h_b-salida ('hide':U).
    WHEN "Activa"   THEN RUN dispatch IN h_b-salida ('view':U).
    WHEN "Pagina1"  THEN DO:
          RUN select-page(1).
          RUN dispatch IN h_b-salida ('open-query':U).
          RUN dispatch IN h_q-alcmov ('enable':U).
          button-items-PI:VISIBLE IN FRAME {&FRAME-NAME} = NO.
      END.
    WHEN "Pagina2"  THEN DO:
          RUN select-page(2).
          RUN dispatch IN h_b-tmpsal ('open-query':U).
          
          button-items-PI:VISIBLE = NO.
          IF S-TPOMOV = 'S' AND INTEGER(C-CODMOV) = 30 THEN DO:
            button-items-PI:VISIBLE IN FRAME {&FRAME-NAME} = YES.
            RUN dispatch IN h_p-updv12 ('hide':U).
          END.
      END.
    WHEN "Pagina3" THEN DO:
           RUN select-page(3).
           RUN dispatch IN h_t-ing-solovalor ('open-query':U).
           RUN dispatch IN h_q-alcmov ('disable':U).
      END.
    WHEN "Pagina4" THEN DO:
           RUN select-page(4).
           RUN dispatch IN h_b-ingres ('open-query':U).
           RUN dispatch IN h_q-alcmov ('enable':U).
           button-items-PI:VISIBLE IN FRAME {&FRAME-NAME} = NO.
      END.
    WHEN "Carga-Series" THEN RUN Carga-Series IN h_q-salida.
    WHEN "RefrescarItems" THEN RUN dispatch IN h_b-tmpsal ('open-query':U).

        
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

