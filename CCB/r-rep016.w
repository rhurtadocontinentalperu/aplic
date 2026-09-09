&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE DETALLE NO-UNDO LIKE CcbDMvto.



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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF VAR x-Moneda  AS CHAR NO-UNDO.
DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR cDivi     AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES DETALLE CcbCMvto gn-clie

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCMvto.CodCli gn-clie.NomCli ~
DETALLE.CodRef DETALLE.NroRef DETALLE.FchEmi DETALLE.FchVto ~
_Moneda(CcbCMvto.CodMon) @ x-Moneda DETALLE.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH DETALLE NO-LOCK, ~
      EACH CcbCMvto WHERE CcbCMvto.CodCia = DETALLE.CodCia ~
  AND CcbCMvto.CodDoc = DETALLE.CodDoc ~
  AND CcbCMvto.NroDoc = DETALLE.NroDoc NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = DETALLE.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH DETALLE NO-LOCK, ~
      EACH CcbCMvto WHERE CcbCMvto.CodCia = DETALLE.CodCia ~
  AND CcbCMvto.CodDoc = DETALLE.CodDoc ~
  AND CcbCMvto.NroDoc = DETALLE.NroDoc NO-LOCK, ~
      EACH gn-clie WHERE gn-clie.CodCli = DETALLE.CodCli ~
      AND gn-clie.CodCia = cl-codcia NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 DETALLE CcbCMvto gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 DETALLE
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 CcbCMvto
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-1 gn-clie


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-10 x-FchDoc-1 x-FchDoc-2 BUTTON-2 ~
BUTTON-1 Btn_Done BROWSE-1 BUTTON-9 
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 x-ImpMn x-Mensaje ~
x-ImpMe FILL-IN-Division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _Moneda W-Win 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 6 BY 1.54 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print-2":U
     LABEL "Button 1" 
     SIZE 6 BY 1.54 TOOLTIP "Imprimir".

DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 10" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\filter-u":U
     IMAGE-DOWN FILE "adeicon\filter-d":U
     LABEL "" 
     SIZE 6 BY 1.62 TOOLTIP "Aplicar Filtro".

DEFINE BUTTON BUTTON-9 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE FILL-IN-Division AS CHARACTER FORMAT "X(60)":U INITIAL "00000" 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-ImpMe AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "TOTAL $" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-ImpMn AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "TOTAL S/." 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      DETALLE, 
      CcbCMvto, 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      CcbCMvto.CodCli COLUMN-LABEL "<<<Cliente>>>" FORMAT "x(11)":U
      gn-clie.NomCli COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(50)":U
      DETALLE.CodRef FORMAT "x(3)":U
      DETALLE.NroRef COLUMN-LABEL "<<Numero>>" FORMAT "X(12)":U
      DETALLE.FchEmi FORMAT "99/99/99":U
      DETALLE.FchVto COLUMN-LABEL "F.Vencimiento" FORMAT "99/99/99":U
      _Moneda(CcbCMvto.CodMon) @ x-Moneda COLUMN-LABEL "Moneda"
      DETALLE.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 99 BY 12.88
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-10 AT ROW 1.27 COL 87 WIDGET-ID 8
     x-FchDoc-1 AT ROW 2.35 COL 8 COLON-ALIGNED
     x-FchDoc-2 AT ROW 2.35 COL 33 COLON-ALIGNED
     BUTTON-2 AT ROW 1.23 COL 73.72
     BUTTON-1 AT ROW 1.27 COL 80.43
     Btn_Done AT ROW 1.27 COL 93.72
     BROWSE-1 AT ROW 3.27 COL 2
     x-ImpMn AT ROW 16.31 COL 85 COLON-ALIGNED
     x-Mensaje AT ROW 16.88 COL 2 COLON-ALIGNED NO-LABEL
     x-ImpMe AT ROW 17.23 COL 85 COLON-ALIGNED
     BUTTON-9 AT ROW 1.27 COL 53.86 WIDGET-ID 4
     FILL-IN-Division AT ROW 1.35 COL 8 COLON-ALIGNED WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 103 BY 17.46
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DETALLE T "?" NO-UNDO INTEGRAL CcbDMvto
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "LETRAS SIN CANJE"
         HEIGHT             = 17.46
         WIDTH              = 103
         MAX-HEIGHT         = 17.46
         MAX-WIDTH          = 103
         VIRTUAL-HEIGHT     = 17.46
         VIRTUAL-WIDTH      = 103
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
/* BROWSE-TAB BROWSE-1 Btn_Done F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpMe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-ImpMn IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.DETALLE,INTEGRAL.CcbCMvto WHERE Temp-Tables.DETALLE ...,INTEGRAL.gn-clie WHERE Temp-Tables.DETALLE ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ",,,"
     _JoinCode[2]      = "INTEGRAL.CcbCMvto.CodCia = Temp-Tables.DETALLE.CodCia
  AND INTEGRAL.CcbCMvto.CodDoc = Temp-Tables.DETALLE.CodDoc
  AND INTEGRAL.CcbCMvto.NroDoc = Temp-Tables.DETALLE.NroDoc"
     _JoinCode[3]      = "INTEGRAL.gn-clie.CodCli = Temp-Tables.DETALLE.CodCli"
     _Where[3]         = "INTEGRAL.gn-clie.CodCia = cl-codcia"
     _FldNameList[1]   > INTEGRAL.CcbCMvto.CodCli
"CcbCMvto.CodCli" "<<<Cliente>>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-clie.NomCli
"gn-clie.NomCli" "Nombre o Razon Social" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = Temp-Tables.DETALLE.CodRef
     _FldNameList[4]   > Temp-Tables.DETALLE.NroRef
"DETALLE.NroRef" "<<Numero>>" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DETALLE.FchEmi
"DETALLE.FchEmi" ? "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DETALLE.FchVto
"DETALLE.FchVto" "F.Vencimiento" "99/99/99" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"_Moneda(CcbCMvto.CodMon) @ x-Moneda" "Moneda" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DETALLE.ImpTot
"DETALLE.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* LETRAS SIN CANJE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* LETRAS SIN CANJE */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 10 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main
DO:
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 FILL-IN-Division.
  RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Divisiones AS CHAR.
    x-Divisiones = FILL-IN-Division:SCREEN-VALUE.
    RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
    FILL-IN-Division:SCREEN-VALUE = x-Divisiones.
    cDivi = x-Divisiones.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Division W-Win
ON LEAVE OF FILL-IN-Division IN FRAME F-Main /* División */
DO:
    ASSIGN FILL-IN-Division.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Totales W-Win 
PROCEDURE Calcula-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    x-ImpMe = 0
    x-ImpMn = 0.
  DO WITH FRAME {&FRAME-NAME}:
    GET FIRST {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE CcbDMvto:
        IF CcbCMvto.CodMon = 1
        THEN x-ImpMn = x-ImpMn + CcbDMvto.ImpTot.
        ELSE x-ImpMe = x-ImpMe + CcbDMvto.ImpTot.
        GET NEXT {&BROWSE-NAME}.
    END.
    DISPLAY x-ImpMe x-ImpMn.
    
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion W-Win 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  REPEAT:
    s-task-no = RANDOM(1,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
    GET FIRST {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE DETALLE:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.campo-c[1] = gn-clie.codcli
            w-report.campo-c[2] = gn-clie.nomcli
            w-report.campo-c[3] = detalle.nrodoc
            w-report.campo-c[4] = detalle.codref
            w-report.campo-c[5] = detalle.nroref
            w-report.campo-d[1] = detalle.fchemi
            w-report.campo-d[2] = detalle.fchvto.
        IF ccbcmvto.codmon = 1
        THEN w-report.campo-f[1] = detalle.imptot.
        ELSE w-report.campo-f[2] = detalle.imptot.
        GET NEXT {&BROWSE-NAME}.
    END.
  END.
  
  
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
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  ASSIGN
    x-ImpMe = 0
    x-ImpMn = 0.
  
  FOR EACH Ccbcmvto NO-LOCK WHERE Ccbcmvto.codcia = s-codcia
        AND LOOKUP(Ccbcmvto.coddiv,cDivi) > 0
        AND (Ccbcmvto.coddoc = 'CJE' OR Ccbcmvto.coddoc = 'CLA')
        AND Ccbcmvto.flgest = 'P',
        EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.codcia = s-codcia
            AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
            AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc
            AND CcbDMvto.TpoRef = 'L'
            AND CcbDMvto.FchEmi >= x-fchdoc-1
            AND Ccbdmvto.FchEmi <= x-fchdoc-2:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' +
        Ccbdmvto.codref + ' ' + Ccbdmvto.nroref + ' ' + STRING(Ccbdmvto.fchemi).
    CREATE DETALLE.
    BUFFER-COPY Ccbdmvto TO DETALLE.
    IF CcbCMvto.CodMon = 1
    THEN x-ImpMn = x-ImpMn + CcbDMvto.ImpTot.
    ELSE x-ImpMe = x-ImpMe + CcbDMvto.ImpTot.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}       
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  DISPLAY x-ImpMe x-ImpMn WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-FchDoc-1 x-FchDoc-2 x-ImpMn x-Mensaje x-ImpMe FILL-IN-Division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-10 x-FchDoc-1 x-FchDoc-2 BUTTON-2 BUTTON-1 Btn_Done BROWSE-1 
         BUTTON-9 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 3.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.

    RUN Carga-Impresion.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */

    chWorkSheet:Range("B2"):Value = "LETRAS SIN CANJE".

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANJE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "NUMERO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "F.EMISION".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "F.VENCIMIENTO".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE $".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE S/.".


    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".

    chWorkSheet:Range("A1:J4"):Font:Bold = TRUE.

    FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-c[1].
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-c[2].
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-c[3].
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-c[4].
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-c[5].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-d[1].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-d[2].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = w-report.campo-f[1] .
    END.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PREPARANDO IMPRESION. Un momento por favor...'.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Impresion.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  SESSION:SET-WAIT-STATE('').

  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'.
  RB-REPORT-NAME = 'LETRAS SIN CANJE'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
/*  RB-FILTER = "CcbDMvto.CodCia = " + STRING(s-codcia) +
 *                 " AND (CcbDMvto.CodDoc = 'CJE' OR " +
 *                 " AND CcbDMvto.TpoRef = 'L'" +
 *                 " AND CcbCMvto.FlgEst = 'E'" +
 *                 " AND gn-clie.CodCia = " + STRING(cl-codcia).*/
  RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.
  
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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY
    cDivi = FILL-IN-Division.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Calcula-Totales.

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
  {src/adm/template/snd-list.i "CcbCMvto"}
  {src/adm/template/snd-list.i "gn-clie"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _Moneda W-Win 
FUNCTION _Moneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE pCodMon:
    WHEN 1 THEN RETURN 'S/.'.
    WHEN 2 THEN RETURN 'US$'.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

