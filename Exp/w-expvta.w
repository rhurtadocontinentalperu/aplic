&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CDOC NO-UNDO LIKE INTEGRAL.CcbCDocu.
DEFINE TEMP-TABLE T-DDOC NO-UNDO LIKE INTEGRAL.CcbDDocu.


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

/* Local Variable Definitions ---                                       */

DEF FRAME F-Mensaje
    " Procesando informacion " SKIP
    " Un momento por favor " SKIP
    " Documento:" ccbcdocu.coddoc SKIP
    "    Numero:" ccbcdocu.nrodoc SKIP
    "       Dia:" ccbcdocu.fchdoc
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX WIDTH 30 TITLE "Mensaje".

DEF VAR s-Button-1 AS LOGICAL INIT TRUE.
DEF VAR s-Button-2 AS LOGICAL INIT FALSE.

DEF VAR x-CodCia LIKE T-CDOC.CodCia.
DEF VAR x-CodDoc LIKE T-CDOC.CodDoc.
DEF VAR x-NroDoc LIKE T-CDOC.NroDoc.

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
&Scoped-define INTERNAL-TABLES T-CDOC T-DDOC Almmmatg

/* Definitions for BROWSE BROWSE-CMOV                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-CMOV T-CDOC.CodDiv T-CDOC.CodDoc ~
T-CDOC.NroDoc T-CDOC.FchDoc T-CDOC.FlgEst T-CDOC.CodCli T-CDOC.CodMon ~
T-CDOC.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CMOV 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-CMOV
&Scoped-define OPEN-QUERY-BROWSE-CMOV OPEN QUERY BROWSE-CMOV FOR EACH T-CDOC NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-CMOV T-CDOC
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CMOV T-CDOC


/* Definitions for BROWSE BROWSE-DMOV                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-DMOV T-DDOC.codmat Almmmatg.DesMat ~
T-DDOC.CanDes T-DDOC.UndVta T-DDOC.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-DMOV 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-DMOV
&Scoped-define OPEN-QUERY-BROWSE-DMOV OPEN QUERY BROWSE-DMOV FOR EACH T-DDOC ~
      WHERE T-DDOC.CodCia = x-codcia ~
 AND T-DDOC.CodDoc = x-coddoc ~
 AND T-DDOC.NroDoc = x-nrodoc NO-LOCK, ~
      EACH Almmmatg OF T-DDOC NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-DMOV T-DDOC Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-DMOV T-DDOC


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-CMOV}~
    ~{&OPEN-QUERY-BROWSE-DMOV}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 FILL-IN-FchIni FILL-IN-FchFin ~
BUTTON-1 BUTTON-3 BROWSE-CMOV BROWSE-DMOV 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodDiv FILL-IN-DesDiv ~
FILL-IN-FchIni FILL-IN-FchFin 

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
     SIZE 11 BY 1.73 TOOLTIP "Exportar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 3" 
     SIZE 11 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE FILL-IN-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 1.15.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66 BY 1.15.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-CMOV FOR 
      T-CDOC SCROLLING.

DEFINE QUERY BROWSE-DMOV FOR 
      T-DDOC, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-CMOV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-CMOV W-Win _STRUCTURED
  QUERY BROWSE-CMOV DISPLAY
      T-CDOC.CodDiv COLUMN-LABEL "Division"
      T-CDOC.CodDoc
      T-CDOC.NroDoc COLUMN-LABEL "<<Numero>>"
      T-CDOC.FchDoc COLUMN-LABEL "Fecha Emision"
      T-CDOC.FlgEst COLUMN-LABEL "Flag"
      T-CDOC.CodCli COLUMN-LABEL "Codigo Cliente"
      T-CDOC.CodMon COLUMN-LABEL "Mon."
      T-CDOC.ImpTot COLUMN-LABEL "<<Importe Total>>"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 66 BY 6.92
         FONT 4.

DEFINE BROWSE BROWSE-DMOV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-DMOV W-Win _STRUCTURED
  QUERY BROWSE-DMOV NO-LOCK DISPLAY
      T-DDOC.codmat
      Almmmatg.DesMat FORMAT "X(30)"
      T-DDOC.CanDes COLUMN-LABEL "<<<Cantidad>>>"
      T-DDOC.UndVta COLUMN-LABEL "Undidad"
      T-DDOC.ImpLin COLUMN-LABEL "<<<Importe>>>"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 66 BY 6.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodDiv AT ROW 1.38 COL 8 COLON-ALIGNED
     FILL-IN-DesDiv AT ROW 1.38 COL 18 COLON-ALIGNED NO-LABEL
     FILL-IN-FchIni AT ROW 2.73 COL 12 COLON-ALIGNED
     FILL-IN-FchFin AT ROW 2.73 COL 33 COLON-ALIGNED
     BUTTON-1 AT ROW 3.88 COL 3
     BUTTON-2 AT ROW 3.88 COL 15
     BUTTON-3 AT ROW 3.88 COL 27
     BROWSE-CMOV AT ROW 5.81 COL 3
     BROWSE-DMOV AT ROW 12.92 COL 3
     RECT-1 AT ROW 2.54 COL 3
     RECT-2 AT ROW 1.19 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.29 BY 18.88
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CDOC T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DDOC T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Exportación de Movimientos de Ventas"
         HEIGHT             = 18.92
         WIDTH              = 70.29
         MAX-HEIGHT         = 21.12
         MAX-WIDTH          = 94.29
         VIRTUAL-HEIGHT     = 21.12
         VIRTUAL-WIDTH      = 94.29
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
/* SETTINGS FOR FILL-IN FILL-IN-CodDiv IN FRAME F-Main
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
     _TblList          = "Temp-Tables.T-CDOC"
     _FldNameList[1]   > Temp-Tables.T-CDOC.CodDiv
"T-CDOC.CodDiv" "Division" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = Temp-Tables.T-CDOC.CodDoc
     _FldNameList[3]   > Temp-Tables.T-CDOC.NroDoc
"T-CDOC.NroDoc" "<<Numero>>" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.T-CDOC.FchDoc
"T-CDOC.FchDoc" "Fecha Emision" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.T-CDOC.FlgEst
"T-CDOC.FlgEst" "Flag" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > Temp-Tables.T-CDOC.CodCli
"T-CDOC.CodCli" "Codigo Cliente" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[7]   > Temp-Tables.T-CDOC.CodMon
"T-CDOC.CodMon" "Mon." ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[8]   > Temp-Tables.T-CDOC.ImpTot
"T-CDOC.ImpTot" "<<Importe Total>>" ? "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-CMOV */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-DMOV
/* Query rebuild information for BROWSE BROWSE-DMOV
     _TblList          = "Temp-Tables.T-DDOC,INTEGRAL.Almmmatg OF Temp-Tables.T-DDOC"
     _Options          = "NO-LOCK"
     _Where[1]         = "Temp-Tables.T-DDOC.CodCia = x-codcia
 AND Temp-Tables.T-DDOC.CodDoc = x-coddoc
 AND Temp-Tables.T-DDOC.NroDoc = x-nrodoc"
     _FldNameList[1]   = Temp-Tables.T-DDOC.codmat
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > Temp-Tables.T-DDOC.CanDes
"T-DDOC.CanDes" "<<<Cantidad>>>" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   > Temp-Tables.T-DDOC.UndVta
"T-DDOC.UndVta" "Undidad" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > Temp-Tables.T-DDOC.ImpLin
"T-DDOC.ImpLin" "<<<Importe>>>" ? "decimal" ? ? ? ? ? ? no ?
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
ON END-ERROR OF W-Win /* Exportación de Movimientos de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Exportación de Movimientos de Ventas */
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
    x-CodCia = T-CDOC.CodCia
    x-CodDoc = T-CDOC.CodDoc
    x-NroDoc = T-CDOC.NroDoc.
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
    ASSIGN FILL-IN-FchIni FILL-IN-FchFin.
    RUN Carga-Temporal.
    BUTTON-1:LOAD-IMAGE-UP('adeicon/stop-u').
    ASSIGN
        FILL-IN-FchIni:SENSITIVE = NO
        FILL-IN-FchFin:SENSITIVE = NO
        BUTTON-2:SENSITIVE = YES
        s-Button-1 = NO
        s-Button-2 = YES.

  END.
  ELSE DO:
    BUTTON-1:LOAD-IMAGE-UP('img/proces').
    ASSIGN
        FILL-IN-FchIni:SENSITIVE = YES
        FILL-IN-FchFin:SENSITIVE = YES
        BUTTON-2:SENSITIVE = NO
        s-Button-1 = YES
        s-Button-2 = NO.
    APPLY 'ENTRY':U TO FILL-IN-FchIni.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Exporta.
  IF RETURN-VALUE = 'ADM-ERROR':U
  THEN RETURN NO-APPLY.
  ASSIGN
    FILL-IN-FchIni:SENSITIVE = YES
    FILL-IN-FchFin:SENSITIVE = YES
    BUTTON-2:SENSITIVE = NO
    s-Button-1 = YES
    s-Button-2 = NO.
  BUTTON-1:LOAD-IMAGE-UP('img/proces').
  APPLY 'ENTRY':U TO FILL-IN-FchIni.
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
    VIEW FRAME F-Mensaje.
    FOR EACH T-CDOC:
      DELETE T-CDOC.
    END.
    FOR EACH T-DDOC:
      DELETE T-DDOC.
    END.
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddiv = s-coddiv
            AND ccbcdocu.fchdoc >= FILL-IN-FchIni
            AND ccbcdocu.fchdoc <= FILL-IN-FchFin
            NO-LOCK:
        DISPLAY ccbcdocu.coddoc ccbcdocu.nrodoc ccbcdocu.fchdoc WITH FRAME F-Mensaje.
        CREATE T-CDOC.
        BUFFER-COPY ccbcdocu TO T-CDOC.
        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:  
            CREATE T-DDOC.
            BUFFER-COPY ccbddocu TO T-DDOC.
        END.
    END. 
    HIDE FRAME F-Mensaje.           
    FIND FIRST T-CDOC NO-ERROR.
    IF AVAILABLE T-CDOC
    THEN ASSIGN
            x-CodCia = T-CDOC.codcia
            x-CodDoc = T-CDOC.coddoc
            x-NroDoc = T-CDOC.nrodoc.
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
  DISPLAY FILL-IN-CodDiv FILL-IN-DesDiv FILL-IN-FchIni FILL-IN-FchFin 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 FILL-IN-FchIni FILL-IN-FchFin BUTTON-1 BUTTON-3 
         BROWSE-CMOV BROWSE-DMOV 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Cab AS CHAR NO-UNDO.
  DEF VAR x-Det AS CHAR NO-UNDO.

  ASSIGN
    x-Cab = "C:\TMP\CCBCDOCU." + S-CODDIV
    x-Det = "C:\TMP\CCBDDOCU." + S-CODDIV.

  FIND FIRST T-CDOC NO-ERROR.
  IF NOT AVAILABLE T-CDOC
  THEN DO:
    MESSAGE "No hay movimientos que exportar" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  OUTPUT TO VALUE(x-Cab).
  FOR EACH T-CDOC:
    EXPORT T-CDOC.
  END.
  OUTPUT CLOSE.
  FOR EACH T-CDOC:
    DELETE T-CDOC.
  END.
  OUTPUT TO VALUE(x-Det).
  FOR EACH T-DDOC:
    EXPORT T-DDOC.
  END.
  OUTPUT CLOSE.
  FOR EACH T-DDOC:
    DELETE T-DDOC.
  END.
  {&OPEN-QUERY-BROWSE-CMOV}
  {&OPEN-QUERY-BROWSE-DMOV}
  MESSAGE "Proceso Terminado" SKIP
    "Se ha generado los archivos en" x-Cab "y" x-Det 
    VIEW-AS ALERT-BOX WARNING.

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
  FILL-IN-FchIni = TODAY.
  FILL-IN-FchFin = TODAY.
  FILL-IN-CodDiv = s-CodDiv.
  FILL-IN-DesDiv = gn-divi.desdiv.

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
  {src/adm/template/snd-list.i "T-DDOC"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "T-CDOC"}

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


