&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CMOV NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE T-DMOV NO-UNDO LIKE INTEGRAL.Almdmov.


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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.

/* Local Variable Definitions ---                                       */

DEF FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Un momento por favor " SKIP
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX WIDTH 30 TITLE "Mensaje".

DEF VAR s-Button-1 AS LOGICAL INIT TRUE.
DEF VAR s-Button-2 AS LOGICAL INIT FALSE.

DEF VAR x-CodCia LIKE T-CMOV.CodCia.
DEF VAR x-CodAlm LIKE T-CMOV.CodAlm.
DEF VAR x-TipMov LIKE T-CMOV.TipMov.
DEF VAR x-CodMov LIKE T-CMOV.CodMov.
DEF VAR x-NroDoc LIKE T-CMOV.NroDoc.

/* Consistencia de division */
FIND GN-DIVI WHERE codcia = s-codcia AND coddiv = s-coddiv
        NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi
THEN DO:
    MESSAGE "Division" s-coddiv "no está configurada en los maestros"
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-CMOV

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CMOV T-DMOV Almmmatg

/* Definitions for BROWSE BROWSE-CMOV                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-CMOV T-CMOV.FchDoc T-CMOV.CodAlm ~
T-CMOV.AlmDes T-CMOV.TipMov T-CMOV.CodMov T-CMOV.NroDoc T-CMOV.FlgEst ~
T-CMOV.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CMOV 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-CMOV
&Scoped-define OPEN-QUERY-BROWSE-CMOV OPEN QUERY BROWSE-CMOV FOR EACH T-CMOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-CMOV T-CMOV
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CMOV T-CMOV


/* Definitions for BROWSE BROWSE-DMOV                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-DMOV T-DMOV.codmat Almmmatg.DesMat ~
T-DMOV.Factor T-DMOV.CanDes T-DMOV.PreUni T-DMOV.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-DMOV 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-DMOV
&Scoped-define OPEN-QUERY-BROWSE-DMOV OPEN QUERY BROWSE-DMOV FOR EACH T-DMOV ~
      WHERE T-DMOV.CodCia = x-codcia ~
 AND T-DMOV.CodAlm = x-codalm ~
 AND T-DMOV.TipMov = x-tipmov ~
 AND T-DMOV.CodMov = x-codmov ~
 AND T-DMOV.NroDoc = x-nrodoc NO-LOCK, ~
      EACH Almmmatg OF T-DMOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-DMOV T-DMOV Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-DMOV T-DMOV


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-CMOV}~
    ~{&OPEN-QUERY-BROWSE-DMOV}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-CodAlm BUTTON-1 BUTTON-3 ~
BROWSE-CMOV BROWSE-DMOV 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm COMBO-BOX-CodDiv ~
FILL-IN-DesDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\proces":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73 TOOLTIP "Generar Temporal".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\rbuild%":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Importar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 3" 
     SIZE 11 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division Origen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 1.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-CMOV FOR 
      T-CMOV SCROLLING.

DEFINE QUERY BROWSE-DMOV FOR 
      T-DMOV, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-CMOV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-CMOV W-Win _STRUCTURED
  QUERY BROWSE-CMOV DISPLAY
      T-CMOV.FchDoc COLUMN-LABEL "Fecha Emision"
      T-CMOV.CodAlm COLUMN-LABEL "Almacén!Origen"
      T-CMOV.AlmDes
      T-CMOV.TipMov COLUMN-LABEL "Tip.!Mov."
      T-CMOV.CodMov COLUMN-LABEL "Cod.!Mov."
      T-CMOV.NroDoc
      T-CMOV.FlgEst
      T-CMOV.usuario COLUMN-LABEL "Usuarios"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 54 BY 6.92
         FONT 4.

DEFINE BROWSE BROWSE-DMOV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-DMOV W-Win _STRUCTURED
  QUERY BROWSE-DMOV NO-LOCK DISPLAY
      T-DMOV.codmat
      Almmmatg.DesMat FORMAT "X(30)"
      T-DMOV.Factor
      T-DMOV.CanDes
      T-DMOV.PreUni
      T-DMOV.ImpLin
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 86 BY 6.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-CodAlm AT ROW 1.38 COL 8 COLON-ALIGNED
     COMBO-BOX-CodDiv AT ROW 1.38 COL 27 COLON-ALIGNED
     FILL-IN-DesDiv AT ROW 1.38 COL 35 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 2.54 COL 3
     BUTTON-2 AT ROW 2.54 COL 15
     BUTTON-3 AT ROW 2.54 COL 27
     BROWSE-CMOV AT ROW 4.46 COL 3
     BROWSE-DMOV AT ROW 11.58 COL 3
     RECT-2 AT ROW 1.19 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.86 BY 17.58
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CMOV T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: T-DMOV T "?" NO-UNDO INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Importación de Movimientos de Transferencia entre Almacen"
         HEIGHT             = 17.58
         WIDTH              = 90
         MAX-HEIGHT         = 19.65
         MAX-WIDTH          = 94.72
         VIRTUAL-HEIGHT     = 19.65
         VIRTUAL-WIDTH      = 94.72
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
   L-To-R                                                               */
/* BROWSE-TAB BROWSE-CMOV BUTTON-3 F-Main */
/* BROWSE-TAB BROWSE-DMOV BROWSE-CMOV F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-CMOV
/* Query rebuild information for BROWSE BROWSE-CMOV
     _TblList          = "Temp-Tables.T-CMOV"
     _FldNameList[1]   > Temp-Tables.T-CMOV.FchDoc
"T-CMOV.FchDoc" "Fecha Emision" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.T-CMOV.CodAlm
"T-CMOV.CodAlm" "Almacén!Origen" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = Temp-Tables.T-CMOV.AlmDes
     _FldNameList[4]   > Temp-Tables.T-CMOV.TipMov
"T-CMOV.TipMov" "Tip.!Mov." ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.T-CMOV.CodMov
"T-CMOV.CodMov" "Cod.!Mov." ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[6]   = Temp-Tables.T-CMOV.NroDoc
     _FldNameList[7]   = Temp-Tables.T-CMOV.FlgEst
     _FldNameList[8]   > Temp-Tables.T-CMOV.usuario
"T-CMOV.usuario" "Usuarios" ? "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-CMOV */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-DMOV
/* Query rebuild information for BROWSE BROWSE-DMOV
     _TblList          = "Temp-Tables.T-DMOV,INTEGRAL.Almmmatg OF Temp-Tables.T-DMOV"
     _Options          = "NO-LOCK"
     _Where[1]         = "Temp-Tables.T-DMOV.CodCia = x-codcia
 AND Temp-Tables.T-DMOV.CodAlm = x-codalm
 AND Temp-Tables.T-DMOV.TipMov = x-tipmov
 AND Temp-Tables.T-DMOV.CodMov = x-codmov
 AND Temp-Tables.T-DMOV.NroDoc = x-nrodoc"
     _FldNameList[1]   = Temp-Tables.T-DMOV.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   = Temp-Tables.T-DMOV.Factor
     _FldNameList[4]   = Temp-Tables.T-DMOV.CanDes
     _FldNameList[5]   = Temp-Tables.T-DMOV.PreUni
     _FldNameList[6]   = Temp-Tables.T-DMOV.ImpLin
     _Query            is OPENED
*/  /* BROWSE BROWSE-DMOV */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Importación de Movimientos de Transferencia entre Almacen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Importación de Movimientos de Transferencia entre Almacen */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-CMOV
&Scoped-define SELF-NAME BROWSE-CMOV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-CMOV W-Win
ON VALUE-CHANGED OF BROWSE-CMOV IN FRAME F-Main
DO:
  ASSIGN
    x-CodCia = T-CMOV.CodCia
    x-CodAlm = T-CMOV.CodAlm
    x-TipMov = T-CMOV.TipMov
    x-CodMov = T-CMOV.CodMov
    x-NroDoc = T-CMOV.NroDoc.
  {&OPEN-QUERY-BROWSE-DMOV}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  IF s-Button-1 = YES
  THEN DO:
    ASSIGN COMBO-BOX-CodDiv.
    RUN Carga-Temporal.
    BUTTON-1:LOAD-IMAGE-UP('adeicon/stop-u').
    ASSIGN
        COMBO-BOX-CodDiv:SENSITIVE = NO
        BUTTON-2:SENSITIVE = YES
        s-Button-1 = NO
        s-Button-2 = YES.

  END.
  ELSE DO:
    BUTTON-1:LOAD-IMAGE-UP('img/proces').
    ASSIGN
        COMBO-BOX-CodDiv:SENSITIVE = YES
        BUTTON-2:SENSITIVE = NO
        s-Button-1 = YES
        s-Button-2 = NO.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Importa.
  IF RETURN-VALUE = 'ADM-ERROR':U
  THEN RETURN NO-APPLY.
  ASSIGN
    COMBO-BOX-CodDiv:SENSITIVE = YES
    BUTTON-2:SENSITIVE = NO
    s-Button-1 = YES
    s-Button-2 = NO.
  BUTTON-1:LOAD-IMAGE-UP('img/proces').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Almacen */
DO:
  FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DO:
    COMBO-BOX-CodDiv:SCREEN-VALUE = Almacen.coddiv.
    APPLY 'VALUE-CHANGED' TO COMBO-BOX-CodDiv.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodDiv W-Win
ON VALUE-CHANGED OF COMBO-BOX-CodDiv IN FRAME F-Main /* Division Origen */
DO:
  FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = SELF:SCREEN-VALUE NO-LOCK.
  FILL-IN-DesDiv:SCREEN-VALUE = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR x-Cab AS CHAR NO-UNDO.
    DEF VAR x-Det AS CHAR NO-UNDO.
    
    x-Cab = "C:\TMP\TRFCMOV." + COMBO-BOX-CodDiv.
    x-Det = "C:\TMP\TRFDMOV." + COMBO-BOX-CodDiv.

    VIEW FRAME F-Mensaje.
    FOR EACH T-CMOV:
      DELETE T-CMOV.
    END.
    FOR EACH T-DMOV:
      DELETE T-DMOV.
    END.

    INPUT FROM VALUE(x-Cab).
    REPEAT:
        CREATE T-CMOV.
        IMPORT T-CMOV.
    END.
    INPUT CLOSE.    
    
    INPUT FROM VALUE(x-Det).
    REPEAT:
        CREATE T-DMOV.
        IMPORT T-DMOV.
    END.
    INPUT CLOSE.    
    HIDE FRAME F-Mensaje.           

    FOR EACH T-CMOV WHERE T-CMOV.codalm = '':
        DELETE T-CMOV.
    END.

    FIND FIRST T-CMOV NO-ERROR.
    IF AVAILABLE T-CMOV
    THEN ASSIGN
            x-CodCia = T-CMOV.codcia
            x-CodAlm = T-CMOV.codalm
            x-TipMov = T-CMOV.tipmov
            x-CodMov = T-CMOV.codmov
            x-NroDoc = T-CMOV.nrodoc.
    {&OPEN-QUERY-BROWSE-CMOV}
    {&OPEN-QUERY-BROWSE-DMOV}

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
  DISPLAY COMBO-BOX-CodAlm COMBO-BOX-CodDiv FILL-IN-DesDiv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 COMBO-BOX-CodAlm BUTTON-1 BUTTON-3 BROWSE-CMOV BROWSE-DMOV 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importa W-Win 
PROCEDURE Importa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.

  FIND FIRST T-CMOV NO-ERROR.
  IF NOT AVAILABLE T-CMOV THEN RETURN 'ADM-ERROR':U.
  MESSAGE 'Confirme Inicio de la Importación'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE rpta-1 AS LOGICAL.
  IF rpta-1 = NO THEN RETURN 'ADM-ERROR':U.

  DISABLE TRIGGERS FOR LOAD OF almcmov.
  DISABLE TRIGGERS FOR LOAD OF almdmov.

  VIEW FRAME F-Mensaje.
  FOR EACH T-CMOV WHERE T-CMOV.codalm <> '':
    FIND almcmov OF t-cmov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE almcmov
    THEN DO:
        CREATE almcmov.
        BUFFER-COPY t-cmov TO almcmov.
    END.
    FOR EACH T-DMOV OF T-CMOV:
      FIND almdmov WHERE almdmov.codcia = t-dmov.codcia
          AND almdmov.codalm = t-dmov.codalm
          AND almdmov.tipmov = t-dmov.tipmov
          AND almdmov.codmov = t-dmov.codmov
          AND almdmov.nroser = t-dmov.nroser
          AND almdmov.nrodoc = t-dmov.nrodoc
          AND almdmov.codmat = t-dmov.codmat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE almdmov
      THEN DO:
          CREATE almdmov.
          BUFFER-COPY t-dmov TO almdmov.
      END.
    END.
  END.

  FOR EACH T-CMOV:
    DELETE T-CMOV.
  END.
  FOR EACH T-DMOV:
    DELETE T-DMOV.
  END.

  HIDE FRAME F-Mensaje.
  MESSAGE "Importación de Movimientos de Almacen Completa" VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-BROWSE-CMOV}
  {&OPEN-QUERY-BROWSE-DMOV}

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
  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv <> s-coddiv NO-LOCK:  
    COMBO-BOX-CodDiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.
  COMBO-BOX-CodDiv = COMBO-BOX-CodDiv:ENTRY(1) IN FRAME {&FRAME-NAME}.
  FIND GN-DIVI WHERE gn-divi.codcia = s-codcia 
    AND gn-divi.coddiv = COMBO-BOX-CodDiv NO-LOCK.
  FILL-IN-DesDiv = gn-divi.desdiv.

  FOR EACH Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm <> s-codalm NO-LOCK:  
    COMBO-BOX-CodAlm:ADD-LAST(Almacen.codalm) IN FRAME {&FRAME-NAME}.
  END.
  COMBO-BOX-CodAlm = COMBO-BOX-CodAlm:ENTRY(1) IN FRAME {&FRAME-NAME}.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-CodAlm IN FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-DMOV"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "T-CMOV"}

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


