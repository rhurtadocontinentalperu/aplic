&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE Almmmatg.



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

  DEF VAR pCodMat LIKE Almmmatg.codmat.
  DEF VAR pCanDes AS DEC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETALLE

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 DETALLE.codmat DETALLE.DesMat ~
DETALLE.DesMar DETALLE.UndBas DETALLE.TpoArt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH DETALLE NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DETALLE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DETALLE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DETALLE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET_TpoArt x-CodBrr BUTTON-3 BROWSE-1 ~
RECT-1 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_TpoArt x-DesMar x-CodBrr ~
x-DesMat x-CodMat x-UndBas x-Cantidad 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     LABEL "OTRO CODIGO" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-Cantidad AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodBrr AS CHARACTER FORMAT "X(20)":U 
     LABEL "Código de Barras" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Código Interno" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-DesMar AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-UndBas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE RADIO-SET_TpoArt AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activado", "A":U,
"Desactivado", "D":U,
"Baja Rotación", "B":U,
"?", ""
     SIZE 15 BY 2.42 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 11.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DETALLE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      DETALLE.codmat COLUMN-LABEL "Código!Artículo" FORMAT "X(6)":U
      DETALLE.DesMat FORMAT "X(45)":U WIDTH 30.57
      DETALLE.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      DETALLE.UndBas FORMAT "X(7)":U WIDTH 8.57
      DETALLE.TpoArt FORMAT "X(1)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 68 BY 4.5
         BGCOLOR 1 FGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET_TpoArt AT ROW 3.69 COL 41 NO-LABEL WIDGET-ID 4
     x-DesMar AT ROW 2.92 COL 15 COLON-ALIGNED WIDGET-ID 2
     x-CodBrr AT ROW 1.38 COL 15 COLON-ALIGNED
     BUTTON-3 AT ROW 11 COL 54
     x-DesMat AT ROW 2.15 COL 15 COLON-ALIGNED
     x-CodMat AT ROW 3.69 COL 15 COLON-ALIGNED
     x-UndBas AT ROW 4.46 COL 15 COLON-ALIGNED
     x-Cantidad AT ROW 5.23 COL 15 COLON-ALIGNED
     BROWSE-1 AT ROW 6.19 COL 3
     RECT-1 AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONSULTA DE CODIGOS DE BARRA"
         HEIGHT             = 11.54
         WIDTH              = 71.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 86.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 86.57
         MAX-BUTTON         = no
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 x-Cantidad F-Main */
/* SETTINGS FOR FILL-IN x-Cantidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-UndBas IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DETALLE"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.DETALLE.codmat
"DETALLE.codmat" "Código!Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.DETALLE.DesMat
"DETALLE.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "30.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.DETALLE.DesMar
"DETALLE.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DETALLE.UndBas
"DETALLE.UndBas" ? "X(7)" "character" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.DETALLE.TpoArt
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSULTA DE CODIGOS DE BARRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE CODIGOS DE BARRA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* OTRO CODIGO */
DO:
  ASSIGN
    x-CodBrr:SCREEN-VALUE = ''
    x-CodMat:SCREEN-VALUE = ''
    x-DesMat:SCREEN-VALUE = ''
    x-DesMar:SCREEN-VALUE = ''
    x-UndBas:SCREEN-VALUE = ''.
  APPLY 'ENTRY':U TO x-CodBrr.
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodBrr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodBrr W-Win
ON LEAVE OF x-CodBrr IN FRAME F-Main /* Código de Barras */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  pCodMat = SELF:SCREEN-VALUE.
  RUN alm/p-codbrr (INPUT-OUTPUT pCodMat, INPUT-OUTPUT pCanDes, s-codcia).
/*  IF pcodmat = '' THEN DO:
 *     RETURN NO-APPLY.
 *   END.*/
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
/*  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
 *     AND Almmmatg.codbrr = SELF:SCREEN-VALUE
 *     AND Almmmatg.tpoart <> 'D'
 *     NO-LOCK NO-ERROR.*/
  ASSIGN
    x-DesMat:SCREEN-VALUE = '?'
    x-DesMar:SCREEN-VALUE = '?'
    x-CodMat:SCREEN-VALUE = '?'
    x-UndBas:SCREEN-VALUE = '?'.
  IF AVAILABLE Almmmatg 
  THEN ASSIGN
            x-DesMat:SCREEN-VALUE = Almmmatg.desmat
            x-DesMar:SCREEN-VALUE = Almmmatg.desmar
            x-CodMat:SCREEN-VALUE = Almmmatg.codmat
            x-UndBas:SCREEN-VALUE = Almmmatg.undbas
            x-Cantidad:SCREEN-VALUE = STRING(pCanDes)
            RADIO-SET_TpoArt:SCREEN-VALUE = Almmmatg.TpoArt
      .
  RUN Carga-Detalle.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle W-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Item AS INT NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* NORMAL */
    FOR EACH Almmmatg WHERE Almmmatg.CodCia = s-codcia
            AND Almmmatg.CodMat = pCodMat 
            AND Almmmatg.tpoart <> 'D' NO-LOCK:
        FIND DETALLE OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
        END.
    END.        
    /* EAN 13 */
    FOR EACH Almmmatg WHERE Almmmatg.CodCia = s-codcia
            AND Almmmatg.CodBrr = x-CodBrr:SCREEN-VALUE
            AND Almmmatg.CodBrr <> "" 
            AND Almmmatg.tpoart <> 'D' 
            NO-LOCK:
        FIND DETALLE OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE THEN DO:
            CREATE DETALLE.
            BUFFER-COPY Almmmatg TO DETALLE.
        END.
    END.        
    /* EAN 14 */
    DO x-Item = 1 TO 3:
        FOR EACH Almmmat1 NO-LOCK WHERE Almmmat1.codcia = s-codcia
                AND Almmmat1.Barras[x-Item] = x-CodBrr:SCREEN-VALUE,
                FIRST Almmmatg OF Almmmat1 WHERE Almmmatg.TpoArt <> 'D'
                NO-LOCK:
            FIND DETALLE OF Almmmatg NO-LOCK NO-ERROR.
            IF NOT AVAILABLE DETALLE THEN DO:
                CREATE DETALLE.
                BUFFER-COPY Almmmatg TO DETALLE
                    ASSIGN DETALLE.CodBrr = Almmmat1.Barras[x-Item].
            END.
        END.
    END.
  END.
  
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
  DISPLAY RADIO-SET_TpoArt x-DesMar x-CodBrr x-DesMat x-CodMat x-UndBas 
          x-Cantidad 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET_TpoArt x-CodBrr BUTTON-3 BROWSE-1 RECT-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DETALLE"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

