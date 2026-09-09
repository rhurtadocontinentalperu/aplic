&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CcbCDocu FOR CcbCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF VAR cl-codcia AS INT NO-UNDO.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.

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
&Scoped-define INTERNAL-TABLES CcbCDocu B-CcbCDocu

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.ImpTot CcbCDocu.CodRef CcbCDocu.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDiv = s-coddiv ~
 AND (CcbCDocu.CodDoc = "FAC") ~
 AND CcbCDocu.FlgEst = "P" ~
 AND CcbCDocu.CodCli = x-codcli NO-LOCK ~
    BY CcbCDocu.FchDoc DESCENDING ~
       BY CcbCDocu.NroDoc
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDiv = s-coddiv ~
 AND (CcbCDocu.CodDoc = "FAC") ~
 AND CcbCDocu.FlgEst = "P" ~
 AND CcbCDocu.CodCli = x-codcli NO-LOCK ~
    BY CcbCDocu.FchDoc DESCENDING ~
       BY CcbCDocu.NroDoc.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CcbCDocu


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 B-CcbCDocu.CodDoc B-CcbCDocu.NroDoc ~
B-CcbCDocu.FchDoc B-CcbCDocu.CodRef B-CcbCDocu.NroRef B-CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH B-CcbCDocu ~
      WHERE B-CcbCDocu.CodCia = s-codcia ~
 AND B-CcbCDocu.CodDoc = 'G/R' ~
 AND B-CcbCDocu.FlgEst <> 'A' ~
 AND B-CcbCDocu.CodCli = x-codcli ~
 AND B-CcbCDocu.CodDiv = s-coddiv ~
 AND B-CcbCDocu.CodCli <> '' ~
 AND B-CcbCDocu.TpoFac = 'R' NO-LOCK ~
    BY B-CcbCDocu.FchDoc DESCENDING ~
       BY B-CcbCDocu.NroDoc
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH B-CcbCDocu ~
      WHERE B-CcbCDocu.CodCia = s-codcia ~
 AND B-CcbCDocu.CodDoc = 'G/R' ~
 AND B-CcbCDocu.FlgEst <> 'A' ~
 AND B-CcbCDocu.CodCli = x-codcli ~
 AND B-CcbCDocu.CodDiv = s-coddiv ~
 AND B-CcbCDocu.CodCli <> '' ~
 AND B-CcbCDocu.TpoFac = 'R' NO-LOCK ~
    BY B-CcbCDocu.FchDoc DESCENDING ~
       BY B-CcbCDocu.NroDoc.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 B-CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 B-CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 Btn_Done x-CodCli BROWSE-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodCli x-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "&Done" 
     SIZE 6 BY 1.35 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\select-u":U
     IMAGE-DOWN FILE "adeicon\select-d":U
     LABEL "Button 2" 
     SIZE 6 BY 1.35 TOOLTIP "Asigna Guias".

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      CcbCDocu SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      B-CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(9)":U
      CcbCDocu.FchDoc FORMAT "99/99/99":U
      CcbCDocu.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>>,>>9.99":U
      CcbCDocu.CodRef COLUMN-LABEL "Referc." FORMAT "x(3)":U
      CcbCDocu.NroRef FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 80 BY 6.35
         FONT 2
         TITLE "SELECCIONE LA FACTURA".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      B-CcbCDocu.CodDoc FORMAT "x(3)":U
      B-CcbCDocu.NroDoc FORMAT "X(9)":U
      B-CcbCDocu.FchDoc FORMAT "99/99/9999":U
      B-CcbCDocu.CodRef FORMAT "x(3)":U
      B-CcbCDocu.NroRef FORMAT "X(9)":U
      B-CcbCDocu.ImpTot COLUMN-LABEL "Importe" FORMAT ">>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 59 BY 6.35
         FONT 2
         TITLE "MARQUE LAS GUIAS A RELACIONAR CON LA FACTURA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.19 COL 3
     Btn_Done AT ROW 1.19 COL 9
     x-CodCli AT ROW 2.92 COL 7 COLON-ALIGNED
     x-NomCli AT ROW 2.92 COL 20 COLON-ALIGNED NO-LABEL
     BROWSE-1 AT ROW 4.46 COL 3
     BROWSE-2 AT ROW 11.19 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CcbCDocu B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ASIGNACION DE GUIAS A FACTURAS"
         HEIGHT             = 17.12
         WIDTH              = 83.57
         MAX-HEIGHT         = 18.54
         MAX-WIDTH          = 83.57
         VIRTUAL-HEIGHT     = 18.54
         VIRTUAL-WIDTH      = 83.57
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-1 x-NomCli F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.CcbCDocu"
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.CcbCDocu.FchDoc|no,INTEGRAL.CcbCDocu.NroDoc|yes"
     _Where[1]         = "CcbCDocu.CodCia = s-codcia
 AND CcbCDocu.CodDiv = s-coddiv
 AND (CcbCDocu.CodDoc = ""FAC"")
 AND CcbCDocu.FlgEst = ""P""
 AND CcbCDocu.CodCli = x-codcli"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   = INTEGRAL.CcbCDocu.NroDoc
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" ? "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" "Importe" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCDocu.CodRef
"CcbCDocu.CodRef" "Referc." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.NroRef
"CcbCDocu.NroRef" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "B-CcbCDocu"
     _Options          = "NO-LOCK"
     _OrdList          = "B-CcbCDocu.FchDoc|no,B-CcbCDocu.NroDoc|yes"
     _Where[1]         = "B-CcbCDocu.CodCia = s-codcia
 AND B-CcbCDocu.CodDoc = 'G/R'
 AND B-CcbCDocu.FlgEst <> 'A'
 AND B-CcbCDocu.CodCli = x-codcli
 AND B-CcbCDocu.CodDiv = s-coddiv
 AND B-CcbCDocu.CodCli <> ''
 AND B-CcbCDocu.TpoFac = 'R'"
     _FldNameList[1]   = Temp-Tables.B-CcbCDocu.CodDoc
     _FldNameList[2]   = Temp-Tables.B-CcbCDocu.NroDoc
     _FldNameList[3]   = Temp-Tables.B-CcbCDocu.FchDoc
     _FldNameList[4]   = Temp-Tables.B-CcbCDocu.CodRef
     _FldNameList[5]   = Temp-Tables.B-CcbCDocu.NroRef
     _FldNameList[6]   > Temp-Tables.B-CcbCDocu.ImpTot
"B-CcbCDocu.ImpTot" "Importe" ">>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ASIGNACION DE GUIAS A FACTURAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ASIGNACION DE GUIAS A FACTURAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Asigna-Guias.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCli W-Win
ON LEAVE OF x-CodCli IN FRAME F-Main /* Cliente */
OR RETURN OF {&SELF-NAME}
DO:
  IF SELF:SCREEN-VALUE <> {&SELF-NAME} THEN DO:
    x-NomCli:SCREEN-VALUE = ''.
    ASSIGN {&SELF-NAME}.
    FIND GN-clie WHERE Gn-clie.codcia = cl-codcia
        AND Gn-clie.codcli = {&SELF-NAME}
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-clie THEN x-NomCli:SCREEN-VALUE = Gn-clie.nomcli.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias W-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR i AS INT NO-UNDO.
  DEF VAR x-NroRef AS CHAR NO-UNDO.
  
  MESSAGE 'Está seguro de asignar las Guias a la Factura?'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE RPta AS LOG.
  IF Rpta = NO THEN RETURN.
  
  DO WITH FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    IF BROWSE-2:NUM-SELECTED-ROWS = 0 THEN RETURN.
    FIND CURRENT Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
    DO i = 1 TO BROWSE-2:NUM-SELECTED-ROWS:
        IF BROWSE-2:FETCH-SELECTED-ROW(i) THEN DO:
            FIND CURRENT B-Ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE B-Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
            IF x-NroRef = ''
            THEN x-NroRef = TRIM(B-Ccbcdocu.nrodoc).
            ELSE x-NroRef = x-NroRef + ',' + TRIM(B-Ccbcdocu.nrodoc).
            ASSIGN
                B-Ccbcdocu.codref = Ccbcdocu.coddoc
                B-Ccbcdocu.nroref = Ccbcdocu.nrodoc.
            RELEASE B-Ccbcdocu.
        END.
    END.
    ASSIGN
        Ccbcdocu.codref = 'G/R'
        Ccbcdocu.nroref = x-NroRef.
    RELEASE Ccbcdocu.
  END.

  DO WITH FRAME {&FRAME-NAME}:
    MESSAGE 'Asignación exitosa' VIEW-AS ALERT-BOX INFORMATION.
    ASSIGN
        x-CodCli = ''
        x-NomCli = ''.
    DISPLAY x-CodCli x-NomCli.
    {&OPEN-QUERY-BROWSE-1}
    {&OPEN-QUERY-BROWSE-2}
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
  DISPLAY x-CodCli x-NomCli 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 Btn_Done x-CodCli BROWSE-1 BROWSE-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "B-CcbCDocu"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

