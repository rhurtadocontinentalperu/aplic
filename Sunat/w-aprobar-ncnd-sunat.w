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
DEF INPUT PARAMETER pParametro AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-coddiv AS CHAR NO-UNDO.
DEF VAR x-TpoFac AS CHAR NO-UNDO.
DEF VAR x-Moneda AS CHAR NO-UNDO.

ASSIGN
    /*x-CodDiv = s-CodDiv*/
    x-TpoFac = "REBATE".

DEF VAR s-CodDoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-CndCre AS CHAR INIT 'N' NO-UNDO.
DEF VAR s-TpoFac AS CHAR INIT '' NO-UNDO.

IF NUM-ENTRIES(pParametro,'|') > 1 THEN s-CndCre = ENTRY(2,pParametro,'|').
IF NUM-ENTRIES(pParametro,'|') > 2 THEN s-TpoFac = ENTRY(3,pParametro,'|').

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
&Scoped-define BROWSE-NAME BROWSE-10

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCDocu CcbDDocu CcbTabla

/* Definitions for BROWSE BROWSE-10                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-10 CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.FchDoc CcbCDocu.NomCli ~
IF (CcbCDocu.CodMon = 1) THEN ("S/.") ELSE ("US$") @ x-Moneda ~
CcbCDocu.ImpTot CcbDDocu.codmat CcbTabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-10 
&Scoped-define QUERY-STRING-BROWSE-10 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDoc = s-CodDoc ~
 AND CcbCDocu.CodDiv = x-coddiv ~
 AND CcbCDocu.CndCre = s-CndCre ~
 AND CcbCDocu.TpoFac = s-TpoFac ~
 AND CcbCDocu.FlgEst = "X" NO-LOCK, ~
      EACH CcbDDocu OF CcbCDocu NO-LOCK, ~
      EACH CcbTabla WHERE CcbTabla.CodCia = CcbDDocu.CodCia ~
  AND CcbTabla.Tabla = CcbDDocu.CodDoc ~
  AND CcbTabla.Codigo = CcbDDocu.codmat NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-10 OPEN QUERY BROWSE-10 FOR EACH CcbCDocu ~
      WHERE CcbCDocu.CodCia = s-codcia ~
 AND CcbCDocu.CodDoc = s-CodDoc ~
 AND CcbCDocu.CodDiv = x-coddiv ~
 AND CcbCDocu.CndCre = s-CndCre ~
 AND CcbCDocu.TpoFac = s-TpoFac ~
 AND CcbCDocu.FlgEst = "X" NO-LOCK, ~
      EACH CcbDDocu OF CcbCDocu NO-LOCK, ~
      EACH CcbTabla WHERE CcbTabla.CodCia = CcbDDocu.CodCia ~
  AND CcbTabla.Tabla = CcbDDocu.CodDoc ~
  AND CcbTabla.Codigo = CcbDDocu.codmat NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-10 CcbCDocu CcbDDocu CcbTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-10 CcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-10 CcbDDocu
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-10 CcbTabla


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-10}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS SELECT-CodDiv BUTTON-9 BUTTON-10 BROWSE-10 
&Scoped-Define DISPLAYED-OBJECTS SELECT-CodDiv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "RECHAZAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-9 
     LABEL "APROBAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE SELECT-CodDiv AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "uno","uno" 
     SIZE 66 BY 4.62 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-10 FOR 
      CcbCDocu, 
      CcbDDocu, 
      CcbTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-10 wWin _STRUCTURED
  QUERY BROWSE-10 NO-LOCK DISPLAY
      CcbCDocu.CodDoc FORMAT "x(3)":U
      CcbCDocu.NroDoc FORMAT "X(9)":U WIDTH 12
      CcbCDocu.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      CcbCDocu.NomCli COLUMN-LABEL "Cliente" FORMAT "x(50)":U
      IF (CcbCDocu.CodMon = 1) THEN ("S/.") ELSE ("US$") @ x-Moneda COLUMN-LABEL "Moneda" FORMAT "x(3)":U
      CcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U
      CcbDDocu.codmat COLUMN-LABEL "Concepto" FORMAT "x(6)":U
      CcbTabla.Nombre FORMAT "x(40)":U WIDTH 19.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 121 BY 13.46
         FONT 4
         TITLE "Selecciones los documentos presionando Ctrl + Clic simultáneamente" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     SELECT-CodDiv AT ROW 1.58 COL 2 NO-LABEL WIDGET-ID 10
     BUTTON-9 AT ROW 2.54 COL 89 WIDGET-ID 14
     BUTTON-10 AT ROW 3.69 COL 89 WIDGET-ID 16
     BROWSE-10 AT ROW 6.58 COL 2 WIDGET-ID 200
     "Seleccione una división" VIEW-AS TEXT
          SIZE 17 BY .5 AT ROW 1 COL 2 WIDGET-ID 12
          BGCOLOR 9 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.43 BY 20.08
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
         TITLE              = "APROBACION O RECHAZO DE NOTAS DE CREDITO"
         HEIGHT             = 20.08
         WIDTH              = 123.43
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
/* BROWSE-TAB BROWSE-10 BUTTON-10 fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-10
/* Query rebuild information for BROWSE BROWSE-10
     _TblList          = "INTEGRAL.CcbCDocu,INTEGRAL.CcbDDocu OF INTEGRAL.CcbCDocu,INTEGRAL.CcbTabla WHERE INTEGRAL.CcbDDocu ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.CcbCDocu.CodCia = s-codcia
 AND INTEGRAL.CcbCDocu.CodDoc = s-CodDoc
 AND INTEGRAL.CcbCDocu.CodDiv = x-coddiv
 AND INTEGRAL.CcbCDocu.CndCre = s-CndCre
 AND INTEGRAL.CcbCDocu.TpoFac = s-TpoFac
 AND INTEGRAL.CcbCDocu.FlgEst = ""X"""
     _JoinCode[3]      = "INTEGRAL.CcbTabla.CodCia = INTEGRAL.CcbDDocu.CodCia
  AND INTEGRAL.CcbTabla.Tabla = INTEGRAL.CcbDDocu.CodDoc
  AND INTEGRAL.CcbTabla.Codigo = INTEGRAL.CcbDDocu.codmat"
     _FldNameList[1]   = INTEGRAL.CcbCDocu.CodDoc
     _FldNameList[2]   > INTEGRAL.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"IF (CcbCDocu.CodMon = 1) THEN (""S/."") ELSE (""US$"") @ x-Moneda" "Moneda" "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.CcbCDocu.ImpTot
     _FldNameList[7]   > INTEGRAL.CcbDDocu.codmat
"CcbDDocu.codmat" "Concepto" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.CcbTabla.Nombre
"CcbTabla.Nombre" ? ? "character" ? ? ? ? ? ? no ? no no "19.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-10 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* APROBACION O RECHAZO DE NOTAS DE CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* APROBACION O RECHAZO DE NOTAS DE CREDITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 wWin
ON CHOOSE OF BUTTON-10 IN FRAME fMain /* RECHAZAR */
DO:
    MESSAGE '¿Procedemos rechazar las notas de crédito?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.

    RUN Rechazar-Rebate.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN NO-APPLY.

    {&OPEN-QUERY-{&BROWSE-NAME}}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 wWin
ON CHOOSE OF BUTTON-9 IN FRAME fMain /* APROBAR */
DO:
   MESSAGE '¿Procedemos con la aprobación?' VIEW-AS ALERT-BOX QUESTION
       BUTTONS YES-NO UPDATE rpta AS LOG.
   IF rpta = NO THEN RETURN NO-APPLY.

   RUN Aprobar-Rebate.
   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN NO-APPLY.

   {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SELECT-CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SELECT-CodDiv wWin
ON VALUE-CHANGED OF SELECT-CodDiv IN FRAME fMain
DO:
  x-CodDiv = SELF:SCREEN-VALUE.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-10
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Rebate wWin 
PROCEDURE Aprobar-Rebate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-Rowid AS ROWID NO-UNDO.

DO k = {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} TO 1 BY -1 
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
        x-Rowid = ROWID(Ccbcdocu).
        {lib/lock-wait.i &Tabla="Ccbcdocu" &Condicion="ROWID(Ccbcdocu) = x-Rowid"}
        ASSIGN
            Ccbcdocu.FlgEst = "P"
            CcbCDocu.UsuAnu = s-user-id.

        /* RHC 02-07-2012 ASIENTO DE TRANSFERENCIA PARA SPEED */
        RUN aplic/sypsa/registroventas (INPUT ROWID(ccbcdocu), INPUT "I", YES) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'NO se pudo actualizar el SPEED' VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        FIND CURRENT Ccbcdocu NO-LOCK.
    END.
END.

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
  DISPLAY SELECT-CodDiv 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE SELECT-CodDiv BUTTON-9 BUTTON-10 BROWSE-10 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-AC wWin 
PROCEDURE Extorna-AC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DEF BUFFER B-CDOCU FOR Ccbcdocu.                                              */
/*                                                                               */
/* FOR EACH Ccbdmov WHERE Ccbdmov.codcia = s-codcia                              */
/*     AND Ccbdmov.codref = Ccbcdocu.coddoc                                      */
/*     AND Ccbdmov.nroref = Ccbcdocu.nrodoc                                      */
/*     AND Ccbdmov.coddoc = "A/C"                                                */
/*     ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':       */
/*     {lib/lock-wait.i &Tabla="B-CDOCU" &Condicion="B-CDOCU.codcia = s-codcia ~ */
/*         AND B-CDOCU.coddoc = Ccbdmov.coddoc ~                                 */
/*         AND B-CDOCU.nrodoc = Ccbdmov.nrodoc"}                                 */
/*     ASSIGN                                                                    */
/*         B-CDOCU.SdoAct = B-CDOCU.SdoAct + Ccbdmov.imptot                      */
/*         B-CDOCU.FlgEst = "P"                                                  */
/*         B-CDOCU.FchCan = ?.                                                   */
/* END.                                                                          */
/* IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.                                   */


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
  SELECT-CodDiv:DELETE(1) IN FRAME {&FRAME-NAME}.
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
       SELECT-CodDiv:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv, gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar-Rebate wWin 
PROCEDURE Rechazar-Rebate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DEF VAR x-Rowid AS ROWID NO-UNDO.

DO k = {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} TO 1 BY -1 
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
        x-Rowid = ROWID(Ccbcdocu).
        {lib/lock-wait.i &Tabla="Ccbcdocu" &Condicion="ROWID(Ccbcdocu) = x-Rowid"}
        ASSIGN
            Ccbcdocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.

        IF x-TpoFac = "ADELANTO" THEN DO:
            /* Extornamos Amortizaciones de A/C si las hubiera */
            RUN vta2/extorna-ac (ROWID(Ccbcdocu)).
            IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
        END.

        FIND CURRENT Ccbcdocu NO-LOCK.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

