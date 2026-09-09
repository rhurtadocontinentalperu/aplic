&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

/* Variables Compartidas */
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codven AS CHAR.

/* Nuevas Variables Compartidas */
DEF NEW SHARED VAR s-CodDoc AS CHAR INIT "COT".
DEF NEW SHARED VAR s-TpoPed AS CHAR.
DEF NEW SHARED VAR pCodDiv  AS CHAR.
DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR s-CodMon AS INT.
DEF NEW SHARED VAR s-CodCli AS CHAR.
DEF NEW SHARED VAR s-fmapgo AS CHAR.
DEF NEW SHARED VAR s-tpocmb AS DEC.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-porigv AS DEC.
DEF NEW SHARED VAR s-nrodec AS INT.
DEF NEW SHARED VAR s-flgigv AS LOG.
DEF NEW SHARED VAR s-import-ibc AS LOG INIT NO.
DEF NEW SHARED VAR s-import-cissac AS LOG INIT NO.
DEF NEW SHARED TEMP-TABLE T-DPEDI LIKE FacDPedi.
DEF NEW SHARED VAR s-adm-new-record AS CHAR.
DEF NEW SHARED VAR S-NROPED AS CHAR.
DEF NEW SHARED VAR S-CMPBNTE  AS CHAR.
DEF NEW SHARED VAR S-TPOMARCO AS CHAR.      /* CASO DE CLIENTES EXCEPCIONALES */
/* CONTROL DE ALMACENES DE DESCARGA */
DEF NEW SHARED VAR s-CodAlm AS CHAR.
/* DEFINE NEW SHARED VARIABLE s-ListaTerceros AS INT. */
/* s-ListaTerceros = 0.                               */

s-TpoPed = "".
pCodDiv = s-CodDiv.

FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

CASE s-TpoPed:
    WHEN "R" THEN DO:
        /* Solo Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] = 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
    OTHERWISE DO:
        /* NO Almacenes de Remate */
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
            AND Vtaalmdiv.coddiv = s-coddiv,
            FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
            BY VtaAlmDiv.Orden:
            IF s-CodAlm = "" THEN s-CodAlm = TRIM(VtaAlmDiv.CodAlm).
            ELSE s-CodAlm = s-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
        END.
    END.
END CASE.
IF s-CodAlm = "" THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' s-coddiv VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
DEF NEW SHARED VAR s-DiasVtoCot     LIKE GN-DIVI.DiasVtoCot.
DEF NEW SHARED VAR s-DiasAmpCot     LIKE GN-DIVI.DiasAmpCot.
DEF NEW SHARED VAR s-FlgEmpaque     LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-FlgMinVenta    LIKE GN-DIVI.FlgMinVenta.
DEF NEW SHARED VAR s-FlgRotacion    LIKE GN-DIVI.FlgRotacion.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF NEW SHARED VAR s-FlgTipoVenta   LIKE GN-DIVI.FlgPreVta.
DEF NEW SHARED VAR s-MinimoPesoDia AS DEC.
DEF NEW SHARED VAR s-MaximaVarPeso AS DEC.
DEF NEW SHARED VAR s-MinimoDiasDespacho AS DEC.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot
    s-DiasAmpCot = GN-DIVI.DiasAmpCot
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta
    s-FlgRotacion = GN-DIVI.FlgRotacion
    s-VentaMayorista = GN-DIVI.VentaMayorista
    s-FlgTipoVenta = GN-DIVI.FlgPreVta
    s-MinimoPesoDia = GN-DIVI.Campo-Dec[1]
    s-MaximaVarPeso = GN-DIVI.Campo-Dec[2]
    s-MinimoDiasDespacho = GN-DIVI.Campo-Dec[3].

/* SOLO PARA EXPOLIBRERIA */
DEFINE NEW SHARED VARIABLE S-CODTER   AS CHAR.
IF s-TpoPed = "E" THEN DO:
    DEFINE            VARIABLE S-OK       AS CHAR.
    RUN vtaexp/d-exp001 (s-codcia,
                         s-CodDiv,
                         OUTPUT s-codter,
                         OUTPUT s-codven,
                         OUTPUT s-ok).
    IF s-ok = 'ADM-ERROR' THEN RETURN ERROR.
END.
/* ********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcotcreditodet AS HANDLE NO-UNDO.
DEFINE VARIABLE h_btcotcreditodet AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dcotcredito AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dcotcreditodet AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dtcotcreditodet AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vcotcredito AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 144.29 BY 25.69 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 2
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 25.69
         WIDTH              = 144.29
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'aplic/pruebas/dcotcredito.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedcotcreditoOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposyesToggleDataTargetsyes':U ,
             OUTPUT h_dcotcredito ).
       RUN repositionObject IN h_dcotcredito ( 1.81 , 131.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/pruebas/vcotcredito.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable?ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vcotcredito ).
       RUN repositionObject IN h_vcotcredito ( 2.08 , 2.00 ) NO-ERROR.
       /* Size in AB:  ( 10.50 , 119.00 ) */

       RUN constructObject (
             INPUT  'aplic/pruebas/dcotcreditodet.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsFacDPedi.CodCia,CodCia,FacDPedi.CodDoc,CodDoc,FacDPedi.NroPed,NroPedObjectNamedcotcreditodetOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
             OUTPUT h_dcotcreditodet ).
       RUN repositionObject IN h_dcotcreditodet ( 3.69 , 131.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/pruebas/dtcotcreditodet.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedtcotcreditodetOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
             OUTPUT h_dtcotcreditodet ).
       RUN repositionObject IN h_dtcotcreditodet ( 5.31 , 131.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenunoShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeUpdateSupportedLinksNavigation-source,Tableio-sourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionHorizontalLogicalObjectNameDisabledActionsHiddenActionsResetHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.00 , 67.14 ) NO-ERROR.

       /* Links to SmartDataObject h_dcotcredito. */
       RUN addLink ( h_dyntoolbar , 'Navigation':U , h_dcotcredito ).

       /* Links to SmartDataViewer h_vcotcredito. */
       RUN addLink ( h_dcotcredito , 'Data':U , h_vcotcredito ).
       RUN addLink ( h_vcotcredito , 'Update':U , h_dcotcredito ).
       RUN addLink ( h_dyntoolbar , 'TableIo':U , h_vcotcredito ).

       /* Links to SmartDataObject h_dcotcreditodet. */
       RUN addLink ( h_dcotcredito , 'Data':U , h_dcotcreditodet ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_vcotcredito ,
             h_dyntoolbar , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'aplic/pruebas/bcotcreditodet.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bcotcreditodet ).
       RUN repositionObject IN h_bcotcreditodet ( 12.69 , 1.29 ) NO-ERROR.
       RUN resizeObject IN h_bcotcreditodet ( 14.00 , 144.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bcotcreditodet. */
       RUN addLink ( h_dcotcreditodet , 'Data':U , h_bcotcreditodet ).
       RUN addLink ( h_bcotcreditodet , 'Update':U , h_dcotcreditodet ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bcotcreditodet ,
             h_dtcotcreditodet , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'aplic/pruebas/btcotcreditodet.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_btcotcreditodet ).
       RUN repositionObject IN h_btcotcreditodet ( 12.85 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_btcotcreditodet ( 13.19 , 142.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenunoShowBorderyesToolbaryesActionGroupsTableioTableIOTypeUpdateSupportedLinksTableio-sourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionHorizontalLogicalObjectNameDisabledActionsHiddenActionsResetHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar-2 ).
       RUN repositionObject IN h_dyntoolbar-2 ( 25.50 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar-2 ( 1.00 , 67.14 ) NO-ERROR.

       /* Links to SmartDataBrowser h_btcotcreditodet. */
       RUN addLink ( h_dtcotcreditodet , 'Data':U , h_btcotcreditodet ).
       RUN addLink ( h_btcotcreditodet , 'Update':U , h_dtcotcreditodet ).
       RUN addLink ( h_dyntoolbar-2 , 'TableIo':U , h_btcotcreditodet ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_btcotcreditodet ,
             h_dtcotcreditodet , 'AFTER':U ).
       RUN adjustTabOrder ( h_dyntoolbar-2 ,
             h_btcotcreditodet , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  VIEW FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle wWin 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER L-Handle AS CHAR. 

/*
CASE L-Handle:
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(1).
         ASSIGN
             COMBO-NroSer:SENSITIVE = YES
             B-CCTE:SENSITIVE = NO
             BUTTON-COT:SENSITIVE = NO
             BUTTON-SUPERMERCADOS:SENSITIVE = NO
             BUTTON-SUPERMERCADOS:VISIBLE = NO
             BUTTON-SUPERMERCADOS-B2B:SENSITIVE = NO
             BUTTON-SUPERMERCADOS-B2B:VISIBLE = NO
             BtnListaExpress:SENSITIVE = NO
             BtnListaExpress:VISIBLE = NO
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO
             Btn-Grupos-2:SENSITIVE = NO
             Btn-Grupos-2:VISIBLE = NO
             Btn-Excel:SENSITIVE = YES
             BtnExcVend:VISIBLE = NO
             BtnExcVend:SENSITIVE = NO
             B-CLI:SENSITIVE = NO
             BUTTON-EDI:VISIBLE = NO
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-IMP-PROV:VISIBLE = NO
             BUTTON-IMP-PROV:SENSITIVE = NO
             BUTTON-IMP-OPENORANGE:VISIBLE = NO
             BUTTON-IMP-OPENORANGE:SENSITIVE = NO
             BUTTON-IMP-HIST-COT:VISIBLE = NO
             BUTTON-IMP-HIST-COT:SENSITIVE = NO
             BUTTON-Importar-Pedido:SENSITIVE = NO
             BUTTON-Importar-Pedido:VISIBLE = NO
             BUTTON-POR-ATENDER:VISIBLE = NO
             BUTTON-POR-ATENDER:SENSITIVE = NO
             BUTTON-TRF-SDO-EXPO:VISIBLE = NO
             BUTTON-TRF-SDO-EXPO:SENSITIVE = NO
             BUTTON-IMPORTAR-EXCEL:VISIBLE = NO
             BUTTON-IMPORTAR-EXCEL:SENSITIVE = NO
             BUTTON-Excel-Trabajo:SENSITIVE = YES
             BUTTON-Excel-Trabajo:VISIBLE = YES
             BUTTON-PRECOTIZACION:SENSITIVE = NO
             BUTTON-PRECOTIZACION:VISIBLE = NO
             .
         CASE s-TpoPed:
             WHEN "R" OR WHEN "NXTL" THEN DO:
             END.
             WHEN "M" OR WHEN "I" THEN DO:
                 ASSIGN
                     BUTTON-IMPORTAR-EXCEL:VISIBLE = YES
                     BUTTON-IMPORTAR-EXCEL:SENSITIVE = YES.
             END.
             WHEN "S" THEN DO:  /* Supermercados */
                 ASSIGN
                     BUTTON-EDI:VISIBLE = YES
                     BUTTON-EDI:SENSITIVE = YES
                     BUTTON-SUPERMERCADOS-B2Bv2:SENSITIVE = YES
                     BUTTON-SUPERMERCADOS-B2Bv2:VISIBLE = YES.
             END.
             WHEN "LF" THEN DO:   /* Lista Express */
                 ASSIGN
                     BtnListaExpress:SENSITIVE = YES
                     BtnListaExpress:VISIBLE = YES.
             END.

             WHEN "E" THEN DO:      /* Eventos */
                 ASSIGN
                     BUTTON-TRF-SDO-EXPO:VISIBLE = YES
                     BUTTON-TRF-SDO-EXPO:SENSITIVE = YES
                     BUTTON-POR-ATENDER:VISIBLE = YES.
                     BUTTON-POR-ATENDER:SENSITIVE = YES.
             END.
             OTHERWISE DO:
                 ASSIGN
                     BtnExcVend:VISIBLE = YES
                     BtnExcVend:SENSITIVE = YES.
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('enable':U).
         IF h_bcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_bcotgralcredmayoristav21 ('open-query':U).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(2).
         ASSIGN
             COMBO-NroSer:SENSITIVE = NO
             B-CCTE:SENSITIVE = YES
             BUTTON-COT:SENSITIVE = YES
             Btn-Excel:SENSITIVE    = NO
             BtnExcVend:SENSITIVE = NO
             B-CLI:SENSITIVE = YES
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO
             BUTTON-TRF-SDO-EXPO:SENSITIVE = NO
             BUTTON-POR-ATENDER:SENSITIVE = NO
             BUTTON-IMPORTAR-EXCEL:SENSITIVE = NO
             BUTTON-SUPERMERCADOS-B2Bv2:SENSITIVE = NO
             BUTTON-SUPERMERCADOS-B2Bv2:VISIBLE = NO
             BtnListaExpress:SENSITIVE = NO
             BtnListaExpress:VISIBLE = NO
             BUTTON-Excel-Trabajo:SENSITIVE = NO
             BUTTON-Excel-Trabajo:VISIBLE = NO.
         CASE s-TpoPed:
             WHEN "E" THEN DO:
                 ASSIGN
                     BUTTON-Importar-Pedido:SENSITIVE = YES
                     BUTTON-Importar-Pedido:VISIBLE = YES
                     BUTTON-PRECOTIZACION:SENSITIVE = YES
                     BUTTON-PRECOTIZACION:VISIBLE = YES
                     .
             END.
             WHEN "M" OR WHEN "R" OR WHEN "NXTL" THEN DO:
             END.
             WHEN "P" THEN DO:      /* Provincias (en un futuro) */
                 ASSIGN
                     BUTTON-Importar-Pedido:SENSITIVE = YES
                     BUTTON-Importar-Pedido:VISIBLE = YES.
             END.
             WHEN "S" THEN DO:  /* Supermercados */
                 BUTTON-SUPERMERCADOS:SENSITIVE = YES.
                 BUTTON-SUPERMERCADOS:VISIBLE = YES.
                 BUTTON-SUPERMERCADOS-B2B:SENSITIVE = YES.
                 BUTTON-SUPERMERCADOS-B2B:VISIBLE = YES.
             END.
             WHEN "LF" THEN DO:  /* ListaExpress */
                 BtnListaExpress:SENSITIVE = YES.
                 BtnListaExpress:VISIBLE = YES.
             END.

             WHEN "I" THEN DO:
                 BUTTON-IMP-HIST-COT:VISIBLE = YES.
                 BUTTON-IMP-HIST-COT:SENSITIVE = YES.
             END.
             OTHERWISE DO:
                 Btn-Grupos-2:SENSITIVE = YES.
                 Btn-Grupos-2:VISIBLE = YES.
             END.
         END CASE.
         RUN dispatch IN h_q-pedido ('disable':U).
         RUN dispatch IN h_tcotgralcredmayoristav21 ('open-query':U).
      END.
    WHEN "Pagina3"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(3).
         ASSIGN
             COMBO-NroSer:SENSITIVE = NO
             B-CCTE:SENSITIVE = YES
             BUTTON-COT:SENSITIVE = YES
             Btn-Excel:SENSITIVE    = NO
             BtnExcVend:SENSITIVE = NO
             B-CLI:SENSITIVE = YES
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO
             Btn-Grupos-2:SENSITIVE = YES
             Btn-Grupos-2:VISIBLE = YES
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO.
         RUN dispatch IN h_q-pedido ('disable':U).
         RUN dispatch IN h_tcotizacioncreditomay-a ('open-query':U).
      END.
    WHEN "Pagina4"  THEN DO WITH FRAME {&FRAME-NAME}:
         RUN select-page(4).
         ASSIGN
             COMBO-NroSer:SENSITIVE = NO
             B-CCTE:SENSITIVE = YES
             BUTTON-COT:SENSITIVE = YES
             Btn-Excel:SENSITIVE    = NO
             BtnExcVend:SENSITIVE = NO
             B-CLI:SENSITIVE = YES
             BUTTON-EDI:SENSITIVE = NO
             BUTTON-CISSAC:SENSITIVE = NO
             BUTTON-CISSAC:VISIBLE = NO
             BUTTON-TRF-SDO-EXPO:SENSITIVE = NO
             BUTTON-POR-ATENDER:SENSITIVE = NO
             BUTTON-IMPORTAR-EXCEL:SENSITIVE = NO
             BUTTON-SUPERMERCADOS-B2Bv2:SENSITIVE = NO.
             BUTTON-SUPERMERCADOS-B2Bv2:VISIBLE = NO.
             BtnListaExpress:SENSITIVE = NO.
             BtnListaExpress:VISIBLE = NO.
             BtnListaExpress:SENSITIVE = YES.
             BtnListaExpress:VISIBLE = YES.
         RUN dispatch IN h_q-pedido ('disable':U).
         RUN dispatch IN h_tcotlistaexpress ('open-query':U).
      END.
    WHEN "Disable-Head" THEN DO:
        BUTTON-Importar-Pedido:SENSITIVE = NO.
        Btn-Grupos-2:SENSITIVE = NO.
        B-CCTE:SENSITIVE = NO.
        B-CLI:SENSITIVE = NO.
        BUTTON-COT:SENSITIVE = NO.
        BUTTON-IMPORTAR-EXCEL:SENSITIVE = NO.
        RUN dispatch IN h_p-updv01 ('disable':U).
        RUN dispatch IN h_vcotgralcredmayoristav21 ('disable-fields':U).
    END.
    WHEN "Enable-Head" THEN DO:
        BUTTON-Importar-Pedido:SENSITIVE = YES.
        Btn-Grupos-2:SENSITIVE = YES.
        B-CCTE:SENSITIVE = YES.
        B-CLI:SENSITIVE = YES.
        BUTTON-COT:SENSITIVE = YES.
        BUTTON-IMPORTAR-EXCEL:SENSITIVE = YES.
        RUN dispatch IN h_p-updv01 ('enable':U).
        RUN dispatch IN h_vcotgralcredmayoristav21 ('enable-fields':U).
    END.
    WHEN "Disable-Button-IBC" THEN BUTTON-SUPERMERCADOS:SENSITIVE = NO.
    WHEN "Disable-Button-IBC-B2B" THEN BUTTON-SUPERMERCADOS-B2B:SENSITIVE = NO.
    WHEN "Disable-Button-CISSAC" THEN BUTTON-CISSAC:SENSITIVE = NO.
    WHEN "Disable-btn-prepedido" THEN BUTTON-PRECOTIZACION:SENSITIVE = NO.
    WHEN "Enable-Button-Imp-Prov" THEN DO:
        ASSIGN
            BUTTON-IMP-PROV:VISIBLE = YES
            BUTTON-IMP-PROV:SENSITIVE = YES.
    END.
    WHEN "Enable-Button-Imp-OpenOrange" THEN DO:
        ASSIGN
            BUTTON-IMP-OPENORANGE:VISIBLE = YES
            BUTTON-IMP-OPENORANGE:SENSITIVE = YES.
    END.
    WHEN "browse" THEN DO:
          IF h_bcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_bcotgralcredmayoristav21 ('open-query':U).
          IF h_tcotgralcredmayoristav21 <> ? THEN RUN dispatch IN h_tcotgralcredmayoristav21 ('open-query':U). 
          IF h_tcotizacioncreditomay-a <> ? THEN RUN dispatch IN h_tcotizacioncreditomay-a ('open-query':U). 
      END.
    WHEN "Recalculo" THEN RUN Recalcular-Precios IN h_vcotgralcredmayoristav21.
    WHEN 'IBC' THEN RUN IBC-Diferencias IN h_tcotgralcredmayoristav21.
    WHEN "Add-Record"   THEN RUN notify IN h_p-updv12   ('add-record':U).
    WHEN "Add-Record-A" THEN RUN notify IN h_p-updv12-2 ('add-record':U).

END CASE.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

