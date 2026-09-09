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

DEF VAR x-FlgSit LIKE vtactrkped.FlgSit NO-UNDO INIT 'P'.
DEF VAR x-CodDiv LIKE s-CodDiv NO-UNDO.
DEF VAR x-NomCli LIKE gn-clie.nomcli NO-UNDO.
DEF VAR x-TiempoTranscurrido AS CHAR FORMAT 'x(30)' NO-UNDO.

DEF BUFFER b-ctrk FOR vtactrkped.

x-CodDiv = s-CodDiv.

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
&Scoped-define INTERNAL-TABLES vtactrkped

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 vtactrkped.CodDiv vtactrkped.CodDoc ~
vtactrkped.NroPed vtactrkped.CodCli fNomCli() @ x-NomCli vtactrkped.CodUbic ~
vtactrkped.FechaI vtactrkped.FechaT fTiempo() @ x-TiempoTranscurrido 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH vtactrkped ~
      WHERE vtactrkped.CodCia = s-codcia ~
 AND vtactrkped.FlgSit = x-flgsit ~
 AND (x-coddiv = 'Todas' OR vtactrkped.CodDiv = x-coddiv) ~
 AND date(vtactrkped.FechaI) >= today NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH vtactrkped ~
      WHERE vtactrkped.CodCia = s-codcia ~
 AND vtactrkped.FlgSit = x-flgsit ~
 AND (x-coddiv = 'Todas' OR vtactrkped.CodDiv = x-coddiv) ~
 AND date(vtactrkped.FechaI) >= today NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 vtactrkped
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 vtactrkped


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division RADIO-SET-FlgSit BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division RADIO-SET-FlgSit 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fNomCli wWin 
FUNCTION fNomCli RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FlgSit AS CHARACTER INITIAL "P" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Pendiente", "P",
"Cerrado", "C",
"Suspendido", "S",
"Anulado", "A"
     SIZE 36 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      vtactrkped SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      vtactrkped.CodDiv FORMAT "x(5)":U
      vtactrkped.CodDoc FORMAT "x(3)":U
      vtactrkped.NroPed COLUMN-LABEL "Numero Pedido" FORMAT "X(9)":U
      vtactrkped.CodCli COLUMN-LABEL "<<< Cliente >>>" FORMAT "x(11)":U
      fNomCli() @ x-NomCli COLUMN-LABEL "Nombre" FORMAT "x(40)":U
      vtactrkped.CodUbic FORMAT "x(5)":U
      vtactrkped.FechaI COLUMN-LABEL "Inicio" FORMAT "99/99/9999 HH:MM":U
      vtactrkped.FechaT COLUMN-LABEL "Término" FORMAT "99/99/9999 HH:MM":U
      fTiempo() @ x-TiempoTranscurrido COLUMN-LABEL "Tiempo" FORMAT "x(35)":U
            WIDTH 24.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125 BY 14.54
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Division AT ROW 1 COL 9 COLON-ALIGNED WIDGET-ID 10
     RADIO-SET-FlgSit AT ROW 2.08 COL 11 NO-LABEL WIDGET-ID 4
     BROWSE-2 AT ROW 3.15 COL 4 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 130.72 BY 17
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
         TITLE              = "CONSULTA TRACKING DE PEDIDOS"
         HEIGHT             = 17
         WIDTH              = 130.72
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
/* BROWSE-TAB BROWSE-2 RADIO-SET-FlgSit fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.vtactrkped"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "vtactrkped.CodCia = s-codcia
 AND vtactrkped.FlgSit = x-flgsit
 AND (x-coddiv = 'Todas' OR vtactrkped.CodDiv = x-coddiv)
 AND date(vtactrkped.FechaI) >= today"
     _FldNameList[1]   = INTEGRAL.vtactrkped.CodDiv
     _FldNameList[2]   = INTEGRAL.vtactrkped.CodDoc
     _FldNameList[3]   > INTEGRAL.vtactrkped.NroPed
"vtactrkped.NroPed" "Numero Pedido" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.vtactrkped.CodCli
"vtactrkped.CodCli" "<<< Cliente >>>" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"fNomCli() @ x-NomCli" "Nombre" "x(40)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.vtactrkped.CodUbic
     _FldNameList[7]   > INTEGRAL.vtactrkped.FechaI
"vtactrkped.FechaI" "Inicio" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.vtactrkped.FechaT
"vtactrkped.FechaT" "Término" "99/99/9999 HH:MM" "datetime" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"fTiempo() @ x-TiempoTranscurrido" "Tiempo" "x(35)" ? ? ? ? ? ? ? no ? no no "24.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fMain:HANDLE
       ROW             = 1
       COLUMN          = 91
       HEIGHT          = 3.85
       WIDTH           = 14.29
       WIDGET-ID       = 2
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(COMBO-BOX-Division:HANDLE IN FRAME fMain).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONSULTA TRACKING DE PEDIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONSULTA TRACKING DE PEDIDOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division wWin
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME fMain /* Division */
DO:
  ASSIGN {&self-name}.
  x-CodDiv = {&self-name}.
  IF x-CodDiv <> 'Todas' 
  THEN x-CodDiv = SUBSTRING({&self-name}, 1, INDEX({&self-name}, ' - ') - 1).
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame wWin OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
/* cada 30 segundos (30000) */
DEF VAR TimeOut AS INTEGER NO-UNDO.
DEF VAR TimeNow AS INTEGER NO-UNDO.

/* CANCELAMOS los P/M que ya han pasado su tiempo de espera */
FOR EACH VtaCTrkPed NO-LOCK WHERE Vtactrkped.codcia = s-codcia
        AND Vtactrkped.coddiv = s-coddiv
        AND Vtactrkped.flgsit = 'P'
        AND Vtactrkped.codubi = 'GNP'
        AND Vtactrkped.coddoc = 'P/M':
    FIND Faccpedm WHERE Faccpedm.codcia = Vtactrkped.codcia
        AND Faccpedm.coddoc = Vtactrkped.coddoc
        AND Faccpedm.nroped = Vtactrkped.nroped
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedm OR Faccpedm.flgest <> 'P' THEN NEXT.
    /* Tiempo por defecto fuera de campaña */
    FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
    TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
              (FacCfgGn.Hora-Res * 3600) + 
              (FacCfgGn.Minu-Res * 60).
    /* Tiempo dentro de campaña */
    FIND FIRST FacCfgVta WHERE Faccfgvta.codcia = s-codcia
        AND Faccfgvta.coddoc = Faccpedm.CodDoc
        AND TODAY >= Faccfgvta.fechad
        AND TODAY <= Faccfgvta.fechah
        NO-LOCK NO-ERROR.
    IF AVAILABLE FacCfgVta 
    THEN TimeOut = (FacCfgVta.Dias-Res * 24 * 3600) +
                    (FacCfgVta.Hora-Res * 3600) + 
                    (FacCfgVta.Minu-Res * 60).
    IF TimeOut > 0 THEN DO:
        TimeNow = (TODAY - Faccpedm.FchPed) * 24 * 3600.
        TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(Faccpedm.Hora, 1, 2)) * 3600) +
                  (INTEGER(SUBSTRING(Faccpedm.Hora, 4, 2)) * 60) ).
        IF TimeNow > TimeOut THEN DO:
            FIND b-ctrk WHERE ROWID(b-ctrk) = ROWID(Vtactrkped) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR THEN NEXT.
            FIND CURRENT Faccpedm EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = NO THEN Faccpedm.FlgEst = 'C'.
            RELEASE Faccpedm.
            b-ctrk.FlgSit = 'C'.
            RELEASE b-ctrk.
        END.
    END.
END.


 {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-FlgSit wWin
ON VALUE-CHANGED OF RADIO-SET-FlgSit IN FRAME fMain
DO:
  ASSIGN {&self-name}.
  x-FlgSit = SELF:SCREEN-VALUE.
  {&OPEN-QUERY-{&BROWSE-NAME}}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wWin  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-contrktimer.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "w-contrktimer.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  DISPLAY COMBO-BOX-Division RADIO-SET-FlgSit 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Division RADIO-SET-FlgSit BROWSE-2 
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
  DEF VAR i AS INT NO-UNDO.

  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + gn-divi.desdiv).
  END.
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DO i = 1 TO COMBO-BOX-Division:NUM-ITEMS:
          IF COMBO-BOX-Division:ENTRY(i) BEGINS s-CodDiv THEN DO:
              COMBO-BOX-Division:SCREEN-VALUE = COMBO-BOX-Division:ENTRY(i).
              LEAVE.
          END.
      END.
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fNomCli wWin 
FUNCTION fNomCli RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE vtactrkped.CodDoc:
      WHEN 'P/M' THEN DO:
          FIND Faccpedm WHERE Faccpedm.codcia = s-codcia
              AND Faccpedm.coddoc = Vtactrkped.coddoc
              AND Faccpedm.nroped = Vtactrkped.nroped
              NO-LOCK NO-ERROR.
          IF AVAILABLE Faccpedm THEN RETURN Faccpedm.nomcli.
      END.
      WHEN 'PED' THEN DO:
          FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
              AND Faccpedi.coddoc = Vtactrkped.coddoc
              AND Faccpedi.nroped = Vtactrkped.nroped
              NO-LOCK NO-ERROR.
          IF AVAILABLE Faccpedi THEN RETURN Faccpedi.nomcli.
      END.
  END CASE.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fTiempo wWin 
FUNCTION fTiempo RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pTiempo AS CHAR.

CASE vtactrkped.FlgSit:
    WHEN 'P' THEN RUN lib/_time-passed (vtactrkped.FechaI, DATETIME(TODAY, MTIME), OUTPUT pTiempo).
    OTHERWISE RUN lib/_time-passed (vtactrkped.FechaI, vtactrkped.FechaT, OUTPUT pTiempo).
END CASE.

RETURN pTiempo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

