&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE RUTA LIKE DI-RutaC.
DEFINE NEW SHARED TEMP-TABLE T-DOSER LIKE lg-doser.



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
DEF SHARED VAR s-codcia AS INT.

DEF NEW SHARED VAR s-coddoc AS CHAR INIT 'O/S'.
DEF NEW SHARED VARIABLE lh_Handle AS HANDLE.

DEF NEW SHARED VAR s-AftIgv LIKE LG-COSER.AftIgv.

DEF NEW SHARED VAR s-CodPro LIKE GN-PROV.CodPro.
DEF NEW SHARED VAR s-HojaRuta AS LOG.

DEF TEMP-TABLE DETALLE
    FIELD CodCia LIKE Di-RutaC.CodCia
    FIELD CodDiv LIKE Di-RutaC.CodDiv
    FIELD CodDoc LIKE Di-RutaC.CodDoc
    FIELD NroDoc LIKE Di-RutaC.NroDoc
    FIELD FchDoc LIKE Di-RutaC.FchDoc
    FIELD FchSal LIKE Di-RutaC.FchSal
    FIELD CodVeh LIKE Di-RutaC.CodVeh
    FIELD CodCli LIKE Gn-clie.codcli
    FIELD CodAlm LIKE Almacen.codalm
    FIELD Despacho AS INT
    FIELD Abastecimiento AS INT
    FIELD Recojo AS INT.

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
&Scoped-Define ENABLED-OBJECTS RECT-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ordser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-ordser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-ordser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-ordser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-ordser-1 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Hoja de Ruta" 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 107 BY 9.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 87
     RECT-3 AT ROW 2.54 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.43 BY 21.38
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: RUTA T "NEW SHARED" ? INTEGRAL DI-RutaC
      TABLE: T-DOSER T "NEW SHARED" ? INTEGRAL lg-doser
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ORDENES DE SERVICIO"
         HEIGHT             = 21.42
         WIDTH              = 114.43
         MAX-HEIGHT         = 21.69
         MAX-WIDTH          = 114.43
         VIRTUAL-HEIGHT     = 21.69
         VIRTUAL-WIDTH      = 114.43
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
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ORDENES DE SERVICIO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ORDENES DE SERVICIO */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Hoja de Ruta */
DO:
  DEF VAR s-Ok AS LOG NO-UNDO.
  RUN lgc/d-ordser-1 (s-codpro, OUTPUT s-Ok).
  IF s-Ok = Yes THEN DO:
    s-HojaRuta = YES.
    RUN Detalle-por-Ruta.
  END.
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
                     Right-to-Left = First-On-Right':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.54 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv02 ).
       RUN set-position IN h_p-updv02 ( 1.00 , 20.00 ) NO-ERROR.
       RUN set-size IN h_p-updv02 ( 1.54 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/v-ordser.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-ordser ).
       RUN set-position IN h_v-ordser ( 2.73 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.46 , 104.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_v-ordser. */
       RUN add-link IN adm-broker-hdl ( h_p-updv02 , 'TableIO':U , h_v-ordser ).
       RUN add-link IN adm-broker-hdl ( h_q-ordser , 'Record':U , h_v-ordser ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv02 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-ordser ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/b-ordser.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-ordser ).
       RUN set-position IN h_b-ordser ( 12.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-ordser ( 7.12 , 107.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/v-ordser-1.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-ordser-1 ).
       RUN set-position IN h_v-ordser-1 ( 19.85 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.92 , 104.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/q-ordser.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-ordser ).
       RUN set-position IN h_q-ordser ( 1.19 , 87.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 16.43 ) */

       /* Links to SmartBrowser h_b-ordser. */
       RUN add-link IN adm-broker-hdl ( h_q-ordser , 'Record':U , h_b-ordser ).

       /* Links to SmartViewer h_v-ordser-1. */
       RUN add-link IN adm-broker-hdl ( h_q-ordser , 'Record':U , h_v-ordser-1 ).

       /* Links to SmartQuery h_q-ordser. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-ordser ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-ordser ,
             h_v-ordser , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-ordser-1 ,
             h_b-ordser , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-ordser ,
             h_v-ordser-1 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/lgc/t-ordser.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-ordser ).
       RUN set-position IN h_t-ordser ( 12.54 , 1.72 ) NO-ERROR.
       RUN set-size IN h_t-ordser ( 9.04 , 112.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 20.23 , 3.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to SmartBrowser h_t-ordser. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_t-ordser ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-ordser ,
             h_v-ordser , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             h_t-ordser , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Detalle-por-Ruta W-Win 
PROCEDURE Detalle-por-Ruta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
    
  /* Acumulamos por servicio */
  FOR EACH RUTA:
    /* Despachos */
    FOR EACH Di-RutaD OF RUTA NO-LOCK,
            EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Di-rutad.codcia
                AND Ccbcdocu.coddoc = Di-rutad.codref
                AND Ccbcdocu.nrodoc = Di-rutad.nroref:
        FIND DETALLE OF RUTA WHERE DETALLE.CodCli = Ccbcdocu.codcli
            EXCLUSIVE-LOCK  NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY RUTA TO DETALLE
                ASSIGN
                    DETALLE.CodCli = Ccbcdocu.codcli.
                    DETALLE.Despacho = 1.
        END.
    END.
    /* Abastecimiento */
    FOR EACH Di-RutaG OF RUTA NO-LOCK:
        FIND DETALLE OF RUTA WHERE DETALLE.CodAlm = Di-RutaG.CodAlm
            EXCLUSIVE-LOCK  NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY RUTA TO DETALLE
                ASSIGN
                    DETALLE.CodAlm = Di-RutaG.CodAlm.
                    DETALLE.Abastecimiento = 1.
        END.
    END.
    FOR EACH Di-RutaDG OF RUTA NO-LOCK WHERE Di-RutaDG.Tipo = 'E':
        FIND DETALLE OF RUTA WHERE DETALLE.CodAlm = Di-RutaDG.CodAlm
            EXCLUSIVE-LOCK  NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY RUTA TO DETALLE
                ASSIGN
                    DETALLE.CodAlm = Di-RutaDG.CodAlm.
                    DETALLE.Recojo = 1.
        END.
    END.
    /* Recojo */
    FOR EACH Di-RutaDG OF RUTA NO-LOCK WHERE Di-RutaDG.Tipo = 'R':
        CREATE DETALLE.
        BUFFER-COPY RUTA TO DETALLE
            ASSIGN
                DETALLE.Recojo = 1.
    END.
  END.
  /* Detalle por cada día */
  DEF VAR x-Despacho AS INT NO-UNDO.
  DEF VAR x-Abastecimiento AS INT NO-UNDO.
  DEF VAR x-Recojo AS INT NO-UNDO.
  DEF VAR x-desser AS CHAR NO-UNDO.
  DEF VAR s-PorIgv AS DEC INIT 0.

  FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  IF AVAILABLE Faccfggn THEN s-PorIgv = Faccfggn.porigv.

  FOR EACH DETALLE,
        FIRST Gn-Vehic WHERE Gn-Vehic.codcia = s-codcia
            AND gn-Vehic.placa = DETALLE.CodVeh
        BREAK BY DETALLE.CodVeh BY DETALLE.FchSal:
    IF FIRST-OF(DETALLE.CodVeh) OR FIRST-OF(DETALLE.FchSal)
    THEN ASSIGN
            x-Despacho = 0
            x-Abastecimiento = 0
            x-Recojo = 0
            x-DesSer = ''.
    ASSIGN
        x-Despacho = x-Despacho + DETALLE.Despacho
        x-Abastecimiento = x-Abastecimiento + DETALLE.Abastecimiento
        x-Recojo = x-Recojo + DETALLE.Recojo.
    IF LAST-OF(DETALLE.CodVeh) OR LAST-OF(DETALLE.FchSal) THEN DO:
        CREATE T-DOSER.
        ASSIGN
            T-DOSER.CodCia = s-codcia
            T-DOSER.codser = 'S0000019'
            T-DOSER.desser = ' ' + STRING(DETALLE.FchSal) +
                            ' ' + DETALLE.CodVeh
            T-DOSER.CanAten = 1 
            T-DOSER.PreUni = gn-vehic.Costo
            T-DOSER.UndCmp = 'DIA'
            T-DOSER.DisCco = 000
            T-DOSER.Cco = '19'.
        IF x-Despacho > 0
        THEN x-desser = STRING(x-Despacho, '99') + ' despacho(s) '.
        IF x-Abastecimiento > 0
        THEN x-desser = x-desser + STRING(x-Abastecimiento, '99') + ' abastecimiento(s) '.
        IF x-Recojo > 0
        THEN x-desser = x-desser + STRING(x-Recojo, '99') + ' recojo(s) '.
        T-DOSER.desser = x-desser + T-DOSER.desser.
    
        ASSIGN
            T-DOSER.ImpTot = T-DOSER.canaten * T-DOSER.preuni
            T-DOSER.AftIgv = s-AftIgv
            T-DOSER.IgvMat = ( IF s-AftIgv = YES THEN s-PorIgv ELSE 0 )
            T-DOSER.ImpIgv = T-DOSER.imptot / (1 + T-DOSER.igvmat / 100) * T-DOSER.igvmat / 100.
    END.
  END.
  RUN Procesa-Handle ('browse-add').
  
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
  ENABLE RECT-3 
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
  lh_handle = THIS-PROCEDURE.

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
    WHEN "browse-add"   THEN DO:
           RUN dispatch IN h_t-ordser ('open-query':U).
       END.
    WHEN "browse"   THEN DO:
           RUN dispatch IN h_b-ordser ('open-query':U).
           RUN dispatch IN h_t-ordser ('open-query':U).
       END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         ASSIGN
            BUTTON-1:SENSITIVE = NO
            BUTTON-1:HIDDEN = YES.
       END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         ASSIGN
            BUTTON-1:SENSITIVE = YES
            BUTTON-1:HIDDEN = NO.
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

