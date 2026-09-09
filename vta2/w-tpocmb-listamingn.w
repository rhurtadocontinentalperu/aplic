&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

&SCOPED-DEFINE condicion vtalistaming.codcia = s-codcia ~
AND ( COMBO-BOX-Familia BEGINS 'Selecc' OR almmmatg.codfam = ENTRY(1, COMBO-BOX-Familia, ' - ') )

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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaListaMinGn Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaListaMinGn.codmat ~
VtaListaMinGn.DesMat VtaListaMinGn.MonVta VtaListaMinGn.TpoCmb ~
VtaListaMinGn.Chr__01 VtaListaMinGn.PreOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaListaMinGn ~
      WHERE vtalistaming.codcia = s-codcia NO-LOCK, ~
      FIRST Almmmatg OF VtaListaMinGn ~
      WHERE COMBO-BOX-Familia BEGINS 'Selecc' OR almmmatg.codfam = ENTRY(1, COMBO-BOX-Familia, ' - ') NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaListaMinGn ~
      WHERE vtalistaming.codcia = s-codcia NO-LOCK, ~
      FIRST Almmmatg OF VtaListaMinGn ~
      WHERE COMBO-BOX-Familia BEGINS 'Selecc' OR almmmatg.codfam = ENTRY(1, COMBO-BOX-Familia, ' - ') NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaListaMinGn Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaListaMinGn
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Familia BUTTON-8 FILL-IN-TpoCmb ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Familia FILL-IN-TpoCmb ~
FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-8 
     LABEL "APLICAR TIPO DE CAMBIO" 
     SIZE 23 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Familia AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione una familia" 
     LABEL "Familia" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Seleccione una familia" 
     DROP-DOWN-LIST
     SIZE 70 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TpoCmb AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "Tipo de Cambio a aplicar" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaListaMinGn, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaListaMinGn.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "X(6)":U
      VtaListaMinGn.DesMat FORMAT "X(60)":U WIDTH 59.86
      VtaListaMinGn.MonVta COLUMN-LABEL "Moneda!Venta" FORMAT "9":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      VtaListaMinGn.TpoCmb FORMAT "Z9.9999":U
      VtaListaMinGn.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      VtaListaMinGn.PreOfi COLUMN-LABEL "Precio Venta" FORMAT ">,>>>,>>9.9999":U
            WIDTH 11.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 112 BY 14.27
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Familia AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-8 AT ROW 2.08 COL 99 WIDGET-ID 6
     FILL-IN-TpoCmb AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Mensaje AT ROW 2.35 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BROWSE-2 AT ROW 3.69 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.86 BY 17
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "TIPO DE CAMBIO POR FAMILIA - LISTA MINORISTA GENERAL"
         HEIGHT             = 17
         WIDTH              = 128.86
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" wWin _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-2 FILL-IN-Mensaje fMain */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaListaMinGn,INTEGRAL.Almmmatg OF INTEGRAL.VtaListaMinGn"
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "vtalistaming.codcia = s-codcia"
     _Where[2]         = "COMBO-BOX-Familia BEGINS 'Selecc' OR almmmatg.codfam = ENTRY(1, COMBO-BOX-Familia, ' - ')"
     _FldNameList[1]   > INTEGRAL.VtaListaMinGn.codmat
"VtaListaMinGn.codmat" "Codigo!Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaListaMinGn.DesMat
"VtaListaMinGn.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "59.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaListaMinGn.MonVta
"VtaListaMinGn.MonVta" "Moneda!Venta" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[4]   = INTEGRAL.VtaListaMinGn.TpoCmb
     _FldNameList[5]   > INTEGRAL.VtaListaMinGn.Chr__01
"VtaListaMinGn.Chr__01" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.VtaListaMinGn.PreOfi
"VtaListaMinGn.PreOfi" "Precio Venta" ? "decimal" ? ? ? ? ? ? no ? no no "11.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* TIPO DE CAMBIO POR FAMILIA - LISTA MINORISTA GENERAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* TIPO DE CAMBIO POR FAMILIA - LISTA MINORISTA GENERAL */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 wWin
ON CHOOSE OF BUTTON-8 IN FRAME fMain /* APLICAR TIPO DE CAMBIO */
DO:
   RUN Aplicar-Tipo-de-Cambio.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Familia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Familia wWin
ON VALUE-CHANGED OF COMBO-BOX-Familia IN FRAME fMain /* Familia */
DO:
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-TpoCmb wWin
ON LEAVE OF FILL-IN-TpoCmb IN FRAME fMain /* Tipo de Cambio a aplicar */
DO:
  ASSIGN {&self-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aplicar-Tipo-de-Cambio wWin 
PROCEDURE Aplicar-Tipo-de-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CtoTot AS DEC.
DEF VAR f-Factor AS DEC NO-UNDO.

IF COMBO-BOX-Familia BEGINS 'Selecc' OR FILL-IN-TpoCmb <= 0 THEN RETURN.

MESSAGE 'Aplicamos el nuevo tipo de cambio a esta familia?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH VtaListaMinGn WHERE VtaListaMinGn.codcia = s-codcia,
    FIRST Almmmatg OF VtaListaMinGn NO-LOCK WHERE Almmmatg.codfam = ENTRY(1, COMBO-BOX-Familia, ' - '):
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "PROCESANDO " + VtaListaMinGn.codmat + ' ' + almmmatg.desmat.
    ASSIGN
        VtaListaMinGn.TpoCmb = FILL-IN-TpoCmb
        VtaListaMinGn.usuario = s-user-id
        VtaListaMinGn.FchAct = TODAY.
    /* Margen de Utilidad */
    IF Almmmatg.monvta = VtaListaMinGn.monvta THEN x-CtoTot = Almmmatg.CtoTot.
    ELSE IF VtaListaMinGn.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
    ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMinGn.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.  
    ASSIGN
        VtaListaMinGn.Dec__01 = ( (VtaListaMinGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
END.
{&OPEN-QUERY-{&BROWSE-NAME}}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
SESSION:SET-WAIT-STATE('').

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
  DISPLAY COMBO-BOX-Familia FILL-IN-TpoCmb FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Familia BUTTON-8 FILL-IN-TpoCmb BROWSE-2 
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
  FOR EACH almtfami NO-LOCK WHERE codcia = s-codcia:
      COMBO-BOX-Familia:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

