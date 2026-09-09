&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETA NO-UNDO LIKE CcbDDocu.



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


/* Parameters Definitions ---                                           */
/*DEF INPUT PARAMETER pParam AS CHAR.*/
DEF INPUT PARAMETER pParam AS CHAR.


/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEF NEW SHARED VAR s-cndcre AS CHAR.
DEF NEW SHARED VAR s-tpofac AS CHAR.
DEF NEW SHARED VAR s-coddoc AS CHAR INIT "N/C".
DEF NEW SHARED VAR s-NroSer AS INT  INIT 000.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-Tipo   AS CHAR INIT "CREDITO".
DEF NEW SHARED VAR S-PORDTO AS DEC.
DEF NEW SHARED VAR S-PORIGV AS DEC.
DEF NEW SHARED VAR s-NroDev AS ROWID.

/* 
Sintaxis: <TpoFac>,<CndCre>,<Tipo>

*/
ASSIGN
    s-tpofac = "DEVOLUCION"
    s-cndcre = "D".

IF pParam > '' THEN DO:
    s-tpofac = ENTRY(1,pParam).
    IF NUM-ENTRIES(pParam) > 1 THEN s-cndcre = ENTRY(2,pParam).
    IF NUM-ENTRIES(pParam) > 2 THEN s-tipo   = ENTRY(3,pParam).
END.


DEF VAR x-Formato AS CHAR NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
x-Formato = ENTRY(1, REPLACE(x-Formato, "X","9"), "-").

&SCOPED-DEFINE Condicion ~
  /* QUERY Base */                                                  ~
  DYNAMIC-FUNCTION('setBaseQuery' IN h_dccbcdocu,                   ~
                   "FOR EACH Ccbcdocu NO-LOCK").                    ~
  /* LIMPIAR filtros */                                             ~
  DYNAMIC-FUNCTION('setQueryWhere' IN h_dccbcdocu, "").             ~
                                                                    ~
  /* FILTROS */                                                     ~
  DYNAMIC-FUNCTION('addQueryWhere' IN h_dccbcdocu,                  ~
                   "Ccbcdocu.codcia = " + STRING(s-codcia),         ~
                   "ccbcdocu",                                      ~
                   ""                                               ~
                   ).                                               ~
  DYNAMIC-FUNCTION('addQueryWhere' IN h_dccbcdocu,                  ~
                   "Ccbcdocu.coddoc = '" + s-coddoc + "'",          ~
                   "Ccbcdocu",                                      ~
                   "AND"                                            ~
                   ).                                               ~
  DYNAMIC-FUNCTION('addQueryWhere' IN h_dccbcdocu,                  ~
                   "Ccbcdocu.tpofac = '" + s-tpofac + "'",          ~
                   "Ccbcdocu",                                      ~
                   "AND"                                            ~
                   ).                                               ~
                                                                    ~
  DYNAMIC-FUNCTION('addQueryWhere' IN h_dccbcdocu,                  ~
                   "Ccbcdocu.cndcre = '" + s-cndcre + "'",          ~
                   "Ccbcdocu",                                      ~
                   "AND"                                            ~
                   ).                                               ~
   DYNAMIC-FUNCTION('addQueryWhere' IN h_dccbcdocu,                  ~
                    "Ccbcdocu.nrodoc BEGINS " + ~
                    "STRING(" + STRING(s-NroSer) + ",'" + x-Formato + "')",          ~
                    "Ccbcdocu",                                      ~
                    "AND"                                            ~
                    ).

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-NroSer 
&Scoped-Define DISPLAYED-OBJECTS COMBO-NroSer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bnotacrdb-b AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bt-nota-cr-db-detail AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dccbcdocu AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dccbddocu AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dt-nota-cr-db-detail AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vnotacrdb AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vnotacrdb-totales AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 6.72 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 7.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-NroSer AT ROW 1 COL 6.71 WIDGET-ID 6
     RECT-1 AT ROW 2.08 COL 2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 142.72 BY 23.85
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 2
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: DETA T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 23.85
         WIDTH              = 142.72
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
/* SETTINGS FOR COMBO-BOX COMBO-NroSer IN FRAME fMain
   ALIGN-L                                                              */
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


&Scoped-define SELF-NAME COMBO-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-NroSer wWin
ON VALUE-CHANGED OF COMBO-NroSer IN FRAME fMain /* Serie */
DO:
    ASSIGN COMBO-NroSer.
    s-NroSer = INTEGER(COMBO-NroSer).
    RUN dispatch IN h_dccbcdocu ('open-query':U).
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
             INPUT  'aplic/ccb/dccbcdocu.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedccbcdocuOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
             OUTPUT h_dccbcdocu ).
       RUN repositionObject IN h_dccbcdocu ( 2.88 , 128.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/ccb/vnotacrdb.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable?ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vnotacrdb ).
       RUN repositionObject IN h_vnotacrdb ( 2.35 , 3.00 ) NO-ERROR.
       /* Size in AB:  ( 7.27 , 122.43 ) */

       RUN constructObject (
             INPUT  'aplic/ccb/dccbddocu.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsCcbDDocu.CodCia,CodCia,CcbDDocu.CodDiv,CodDiv,CcbDDocu.CodDoc,CodDoc,CcbDDocu.NroDoc,NroDocObjectNamedccbddocuOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
             OUTPUT h_dccbddocu ).
       RUN repositionObject IN h_dccbddocu ( 4.77 , 128.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsCopy,Delete,UpdateFlatButtonsyesMenunoShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeUpdateSupportedLinksNavigation-source,Tableio-sourceToolbarBandsToolbarAutoSizenoToolbarDrawDirectionHorizontalLogicalObjectNameDisabledActionsCopy,Delete,UpdateHiddenActionsResetHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 21.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.00 , 40.29 ) NO-ERROR.

       /* Links to SmartDataObject h_dccbcdocu. */
       RUN addLink ( h_dyntoolbar , 'Navigation':U , h_dccbcdocu ).

       /* Links to SmartDataViewer h_vnotacrdb. */
       RUN addLink ( h_dccbcdocu , 'Data':U , h_vnotacrdb ).
       RUN addLink ( h_vnotacrdb , 'Update':U , h_dccbcdocu ).
       RUN addLink ( h_dyntoolbar , 'TableIo':U , h_vnotacrdb ).

       /* Links to SmartDataObject h_dccbddocu. */
       RUN addLink ( h_dccbcdocu , 'Data':U , h_dccbddocu ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             COMBO-NroSer:HANDLE IN FRAME fMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_vnotacrdb ,
             h_dyntoolbar , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'aplic/ccb/bnotacrdb-b.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bnotacrdb-b ).
       RUN repositionObject IN h_bnotacrdb-b ( 9.88 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bnotacrdb-b ( 12.92 , 140.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'aplic/ccb/vnotacrdb-totales.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EnabledObjFldsToDisable?ModifyFields(All)DataSourceNamesUpdateTargetNamesLogicalObjectNameLogicalObjectNamePhysicalObjectNameDynamicObjectnoRunAttributeHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vnotacrdb-totales ).
       RUN repositionObject IN h_vnotacrdb-totales ( 22.54 , 2.00 ) NO-ERROR.
       /* Size in AB:  ( 1.35 , 139.00 ) */

       /* Initialize other pages that this page requires. */
       RUN initPages ('2':U) NO-ERROR.

       /* Links to SmartDataBrowser h_bnotacrdb-b. */
       RUN addLink ( h_dccbddocu , 'Data':U , h_bnotacrdb-b ).
       RUN addLink ( h_bnotacrdb-b , 'Update':U , h_dt-nota-cr-db-detail ).

       /* Links to SmartDataViewer h_vnotacrdb-totales. */
       RUN addLink ( h_dccbcdocu , 'Data':U , h_vnotacrdb-totales ).
       RUN addLink ( h_vnotacrdb , 'GroupAssign':U , h_vnotacrdb-totales ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bnotacrdb-b ,
             h_dccbddocu , 'AFTER':U ).
       RUN adjustTabOrder ( h_vnotacrdb-totales ,
             h_bnotacrdb-b , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'aplic/ccb/dt-nota-cr-db-detail.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedt-nota-cr-db-detailOpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposnoToggleDataTargetsyes':U ,
             OUTPUT h_dt-nota-cr-db-detail ).
       RUN repositionObject IN h_dt-nota-cr-db-detail ( 6.65 , 128.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/ccb/bt-nota-cr-db-detail.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bt-nota-cr-db-detail ).
       RUN repositionObject IN h_bt-nota-cr-db-detail ( 9.88 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bt-nota-cr-db-detail ( 14.54 , 140.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bt-nota-cr-db-detail. */
       RUN addLink ( h_dt-nota-cr-db-detail , 'Data':U , h_bt-nota-cr-db-detail ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bt-nota-cr-db-detail ,
             h_dccbddocu , 'AFTER':U ).
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
  DISPLAY COMBO-NroSer 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-1 COMBO-NroSer 
      WITH FRAME fMain IN WINDOW wWin.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table wWin 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR DETA.

RUN Export-Temp-Table IN h_vnotacrdb ( OUTPUT TABLE DETA).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.

  {sunat\i-lista-series.i &CodCia=s-CodCia ~
      &CodDiv=s-CodDiv ~
      &CodDoc=s-CodDoc ~
      &FlgEst='TODOS' ~          /* En blanco si quieres solo ACTIVOS */
      &Tipo=s-Tipo ~
      &ListaSeries=cListItems ~
      }

  DO WITH FRAME {&FRAME-NAME}:
      COMBO-NroSer:LIST-ITEMS = cListItems.
      COMBO-NroSer = ENTRY(1,COMBO-NroSer:LIST-ITEMS).
      s-NroSer = INTEGER(COMBO-NroSer).
  END.

  {&Condicion}


  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

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

DEF VAR pTotal AS DECI NO-UNDO.

CASE L-Handle:
    WHEN "Disable-Head" THEN COMBO-NroSer:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    WHEN "Enable-Head"  THEN COMBO-NroSer:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    WHEN "browse" THEN DO:
        IF h_bt-nota-cr-db-detail <> ? THEN DO:
           RUN Import-Temp-Table IN h_vnotacrdb (OUTPUT TABLE DETA).
           RUN Export-Temp-Table IN h_dt-nota-cr-db-detail (INPUT TABLE DETA, OUTPUT pTotal).
           RUN Pinta-Total IN h_bt-nota-cr-db-detail ( INPUT pTotal /* DECIMAL */).
           /*RUN dispatch IN h_t-nota-cr-db ('open-query':U).*/
        END.
/*           RUN dispatch IN h_b-mantto-fact-credito-sunat ('open-query':U). */
/*           RUN dispatch IN h_t-nota-cr-db ('open-query':U).                */
      END.
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:    /* Origen Ninguna */
         RUN SelectPage(1).
      END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:    /* Temporal Ninguna */
         RUN SelectPage(2).
      END.
END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

