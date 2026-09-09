&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
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
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR s-codalm AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

    DEF VAR s-pagina-actual AS INTE INIT 1 NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 FILL-IN-DesMat ~
RADIO-SET-TpoArt BUTTON-3 COMBO-BOX-CodFam BUTTON-4 FILL-IN-CodPro ~
FILL-IN-Marca FILL-IN-codigo 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DesMat RADIO-SET-TpoArt ~
COMBO-BOX-CodFam FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Marca FILL-IN-codigo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bmate-matg-p1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bmate-matg-p2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dmate-matg-p1 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dmate-matg-p2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "APLICAR FILTROS" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-4 
     LABEL "LIMPIAR FILTROS" 
     SIZE 18 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Línea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codigo AS CHARACTER FORMAT "X(14)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(15)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TpoArt AS CHARACTER INITIAL "A" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activado", "A",
"Desactivado", "D"
     SIZE 24 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123 BY 3.77.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-DesMat AT ROW 1.27 COL 14 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET-TpoArt AT ROW 1.27 COL 65 NO-LABEL WIDGET-ID 42
     BUTTON-3 AT ROW 1.27 COL 93 WIDGET-ID 14
     COMBO-BOX-CodFam AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 12
     BUTTON-4 AT ROW 2.35 COL 93 WIDGET-ID 28
     FILL-IN-CodPro AT ROW 2.88 COL 14 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-NomPro AT ROW 2.88 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     FILL-IN-Marca AT ROW 3.69 COL 14 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-codigo AT ROW 5.15 COL 14 COLON-ALIGNED WIDGET-ID 2
     "F8 : Stocks x Almacenes F7 : Pedidos F9 : Ingresos en Tránsito" VIEW-AS TEXT
          SIZE 63 BY .5 AT ROW 26.04 COL 2 WIDGET-ID 6
          FONT 0
     "F3: Multiubicación" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 26.04 COL 66 WIDGET-ID 30
          FONT 0
     "  Buscar el codigo en los registros que se muestran en pantalla" VIEW-AS TEXT
          SIZE 43 BY .5 AT ROW 4.5 COL 3 WIDGET-ID 34
          BGCOLOR 4 FGCOLOR 15 
     RECT-2 AT ROW 1 COL 2 WIDGET-ID 16
     RECT-3 AT ROW 4.77 COL 2 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.72 BY 25.92
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 1
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE STOCK POR ALMACEN"
         HEIGHT             = 25.92
         WIDTH              = 125.72
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
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONSULTA DE STOCK POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONSULTA DE STOCK POR ALMACEN */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* APLICAR FILTROS */
DO:
    ASSIGN
        COMBO-BOX-CodFam FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro FILL-IN-Marca .
    ASSIGN
        RADIO-SET-TpoArt.

    RUN Selecciona-Pagina.
    CASE RETURN-VALUE:
        WHEN "1" THEN DO:
            /* QUERY Base */
            DYNAMIC-FUNCTION('setBaseQuery' IN h_dmate-matg-p1,
                             "FOR EACH Almmmate NO-LOCK, FIRST Almmmatg OF Almmmate NO-LOCK").
            /* LIMPIAR filtros */
            DYNAMIC-FUNCTION('setQueryWhere' IN h_dmate-matg-p1, "").
            /* FILTROS para ALMMMATE */
            DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,
                             "Almmmate.codcia = " + STRING(s-codcia),
                             "Almmmate",
                             ""
                             ).
            DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,
                             "Almmmate.codalm = '" + s-codalm + "'",
                             "Almmmate",
                             "AND"
                             ).
            /* FILTROS para ALMMMATG */
            DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,
                             "Almmmatg.tpoart = '" + RADIO-SET-TpoArt + "'",
                             "Almmmatg",
                             ""
                             ).
/*             DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,             */
/*                              "Almmmate.codcia = " + STRING(s-codcia),        */
/*                              "Almmmate",                                     */
/*                              ""                                              */
/*                              ).                                              */
/*             DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,             */
/*                              "Almmmate.codalm = '" + s-codalm + "'",         */
/*                              "Almmmate",                                     */
/*                              "AND"                                           */
/*                              ).                                              */
/*             DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p1,             */
/*                              "Almmmatg.tpoart = '" + RADIO-SET-TpoArt + "'", */
/*                              "Almmmatg",                                     */
/*                              ""                                              */
/*                              ).                                              */
            DYNAMIC-FUNCTION('openQuery' IN h_dmate-matg-p1).
        END.
        WHEN "2" THEN DO:
            DEF VAR LocalOrden AS INTE NO-UNDO.
            DEF VAR LocalCadena AS CHAR NO-UNDO.

            LocalCadena = "".
            DO LocalOrden = 1 TO NUM-ENTRIES(FILL-IN-DesMat, " "):
                LocalCadena = LocalCadena + (IF TRUE <> (LocalCadena > '') THEN "" ELSE " ") + 
                    "*" + TRIM(ENTRY(LocalOrden,FILL-IN-DesMat, " ")) + "*".
            END.

            /* QUERY Base */
            DYNAMIC-FUNCTION('setBaseQuery' IN h_dmate-matg-p2,
                             "FOR EACH Almmmatg NO-LOCK, FIRST Almmmate OF Almmmatg NO-LOCK").
            /* LIMPIAR filtros */
            DYNAMIC-FUNCTION('setQueryWhere' IN h_dmate-matg-p2, "").

            /* FILTROS para ALMMMATE */
            DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmate.codalm = '" + s-codalm + "'",
                             "Almmmate",
                             ""
                             ).
            /* FILTROS para ALMMMATG */
            DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmatg.tpoart = '" + RADIO-SET-TpoArt + "'",
                             "Almmmatg",
                             ""
                             ).

            IF FILL-IN-DesMat > '' THEN
                DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmatg.desmat MATCHES '" + LocalCadena + "'" ,
                             "Almmmatg",
                             "AND"
                             ).
            IF FILL-IN-Marca > '' THEN
                DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmatg.desmar BEGINS '" + FILL-IN-Marca + "'" ,
                             "Almmmatg",
                             "AND"
                             ).
            IF FILL-IN-CodPro > '' THEN
                DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmatg.codpr1 = '" + FILL-IN-CodPro + "'" ,
                             "Almmmatg",
                             "AND"
                             ).
            IF COMBO-BOX-CodFam <> 'Todos' THEN
                DYNAMIC-FUNCTION('addQueryWhere' IN h_dmate-matg-p2,
                             "Almmmatg.codfam = '" + COMBO-BOX-CodFam + "'" ,
                             "Almmmatg",
                             "AND"
                             ).


            DYNAMIC-FUNCTION('openQuery' IN h_dmate-matg-p2).
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 wWin
ON CHOOSE OF BUTTON-4 IN FRAME fMain /* LIMPIAR FILTROS */
DO:
  /*CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.*/
  DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-CodPro = ''.
      FILL-IN-DesMat = ''.
      FILL-IN-NomPro = ''.
      FILL-IN-Marca = ''.
      COMBO-BOX-CodFam:SCREEN-VALUE = 'Todos'.
      RADIO-SET-TpoArt = "A".
      DISPLAY FILL-IN-CodPro FILL-IN-DesMat FILL-IN-NomPro FILL-IN-Marca RADIO-SET-TpoArt.
      APPLY 'CHOOSE':U TO BUTTON-3.
  END.
  RUN Selecciona-Pagina.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Línea */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codigo wWin
ON LEAVE OF FILL-IN-codigo IN FRAME fMain /* Código */
OR RETURN OF FILL-IN-codigo DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.

    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto.r (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN DO:
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
        
    SELF:SCREEN-VALUE = pCodMat.

    IF INPUT FILL-IN-codigo = "" THEN RETURN.

    DEF VAR cRowIdent AS CHAR NO-UNDO.
    DEF VAR cSearch AS CHAR NO-UNDO.

    cSearch = "codmat = '" + pCodMat + "'".

    CASE s-pagina-actual:
        WHEN 1 THEN DO:
            cRowIdent = DYNAMIC-FUNCTION('rowidWhere' IN h_dmate-matg-p1, cSearch).
            DYNAMIC-FUNCTION('openQuery' IN h_dmate-matg-p1).
            IF cRowIdent <> ? THEN DYNAMIC-FUNCTION('fetchRowIdent' IN h_dmate-matg-p1,
                                                    cRowIdent,
                                                    '').
        END.
        WHEN 2 THEN DO:
            cRowIdent = DYNAMIC-FUNCTION('rowidWhere' IN h_dmate-matg-p2, cSearch).
            DYNAMIC-FUNCTION('openQuery' IN h_dmate-matg-p2).
            IF cRowIdent <> ? THEN DYNAMIC-FUNCTION('fetchRowIdent' IN h_dmate-matg-p2,
                                                    cRowIdent,
                                                    '').
        END.
    END CASE.
    SELF:SCREEN-VALUE = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro wWin
ON LEAVE OF FILL-IN-CodPro IN FRAME fMain /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = '' THEN FILL-IN-NomPro:SCREEN-VALUE = ''.
  FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia AND
      gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE =  gn-prov.NomPro.
  ELSE FILL-IN-NomPro:SCREEN-VALUE = ''.

       ASSIGN {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DesMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DesMat wWin
ON LEAVE OF FILL-IN-DesMat IN FRAME fMain /* Descripción */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Marca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Marca wWin
ON LEAVE OF FILL-IN-Marca IN FRAME fMain /* Marca */
DO:
    ASSIGN {&self-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

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

    WHEN 1 THEN DO:
       RUN constructObject (
             INPUT  'aplic/alm/dmate-matg-p1.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedmate-matg-p1OpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposyesToggleDataTargetsyes':U ,
             OUTPUT h_dmate-matg-p1 ).
       RUN repositionObject IN h_dmate-matg-p1 ( 2.88 , 114.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/alm/bmate-matg.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bmate-matg-p1 ).
       RUN repositionObject IN h_bmate-matg-p1 ( 6.12 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bmate-matg-p1 ( 19.65 , 123.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bmate-matg-p1. */
       RUN addLink ( h_dmate-matg-p1 , 'Data':U , h_bmate-matg-p1 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bmate-matg-p1 ,
             FILL-IN-codigo:HANDLE IN FRAME fMain , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN constructObject (
             INPUT  'aplic/alm/dmate-matg-p2.wDB-AWARE':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'AppServiceASInfoASUsePrompt?CacheDuration0CheckCurrentChangedyesDestroyStatelessyesDisconnectAppServernoServerOperatingModeNONEShareDatanoUpdateFromSourcenoForeignFieldsObjectNamedmate-matg-p2OpenOnInityesPromptColumns(NONE)PromptOnDeleteyesRowsToBatch200RebuildOnReposyesToggleDataTargetsyes':U ,
             OUTPUT h_dmate-matg-p2 ).
       RUN repositionObject IN h_dmate-matg-p2 ( 3.15 , 114.00 ) NO-ERROR.
       /* Size in AB:  ( 1.50 , 7.72 ) */

       RUN constructObject (
             INPUT  'aplic/alm/bmate-matg.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesUseSortIndicatoryesSearchFieldDataSourceNames?UpdateTargetNames?LogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bmate-matg-p2 ).
       RUN repositionObject IN h_bmate-matg-p2 ( 6.12 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bmate-matg-p2 ( 19.65 , 123.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bmate-matg-p2. */
       RUN addLink ( h_dmate-matg-p2 , 'Data':U , h_bmate-matg-p2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bmate-matg-p2 ,
             FILL-IN-codigo:HANDLE IN FRAME fMain , 'AFTER':U ).
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
  DISPLAY FILL-IN-DesMat RADIO-SET-TpoArt COMBO-BOX-CodFam FILL-IN-CodPro 
          FILL-IN-NomPro FILL-IN-Marca FILL-IN-codigo 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE RECT-2 RECT-3 FILL-IN-DesMat RADIO-SET-TpoArt BUTTON-3 
         COMBO-BOX-CodFam BUTTON-4 FILL-IN-CodPro FILL-IN-Marca FILL-IN-codigo 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-CodCia:
          COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' ' + Almtfami.desfam, Almtfami.codfam).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Selecciona-Pagina wWin 
PROCEDURE Selecciona-Pagina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Si hay datos => página 2
   caso contrario => página 1
*/

CASE TRUE:
    WHEN TRUE <> ((FILL-IN-CodPro + FILL-IN-DesMat + FILL-IN-Marca) > '') AND COMBO-BOX-CodFam = 'Todos' 
        THEN DO:
        s-pagina-actual = 1.
        RUN selectpage('1').
        RETURN '1'.
    END.
    OTHERWISE DO:
        s-pagina-actual = 2.
        RUN selectpage('2').
        RETURN '2'.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

