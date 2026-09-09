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
DEF SHARED VAR cb-codcia AS INT.

&SCOPED-DEFINE Condicion cb-cmov.codcia = s-codcia ~
AND cb-cmov.periodo = COMBO-BOX-Periodo ~
AND cb-cmov.nromes = COMBO-BOX-NroMes ~
AND ( COMBO-BOX-CodOpe = 'Todas' OR cb-cmov.codope = COMBO-BOX-CodOpe) ~
AND (TOGGLE-1 = NO OR (cb-cmov.fchast >= FILL-IN-FchAst-1 AND cb-cmov.fchast <= FILL-IN-FchAst-2))

&SCOPED-DEFINE Condicion2 OOCb-cmov.codcia = s-codcia ~
AND OOCb-cmov.periodo = COMBO-BOX-Periodo ~
AND OOCb-cmov.nromes = COMBO-BOX-NroMes ~
AND ( COMBO-BOX-CodOpe = 'Todas' OR OOCb-cmov.codope = COMBO-BOX-CodOpe) ~
AND (TOGGLE-1 = NO OR (OOCb-cmov.fchast >= FILL-IN-FchAst-1 AND OOCb-cmov.fchast <= FILL-IN-FchAst-2))

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
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-cmov

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 cb-cmov.CodDiv cb-cmov.CodOpe ~
cb-cmov.NroAst cb-cmov.FchAst cb-cmov.NotAst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH cb-cmov ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH cb-cmov ~
      WHERE {&Condicion} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 cb-cmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 cb-cmov


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone BUTTON-3 COMBO-BOX-Periodo ~
COMBO-BOX-NroMes TOGGLE-1 COMBO-BOX-CodOpe BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes ~
TOGGLE-1 FILL-IN-FchAst-1 FILL-IN-FchAst-2 COMBO-BOX-CodOpe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.54 TOOLTIP "Migrar a OpenOrange".

DEFINE VARIABLE COMBO-BOX-CodOpe AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Operación" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todas","Todas"
     DROP-DOWN-LIST
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Seleccione el Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Por Rango de fechas" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      cb-cmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 wWin _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      cb-cmov.CodDiv FORMAT "X(5)":U
      cb-cmov.CodOpe FORMAT "X(3)":U
      cb-cmov.NroAst FORMAT "X(6)":U
      cb-cmov.FchAst FORMAT "99/99/9999":U
      cb-cmov.NotAst FORMAT "X(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 19.42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BtnDone AT ROW 1.19 COL 104 WIDGET-ID 14
     BUTTON-3 AT ROW 1.38 COL 52 WIDGET-ID 16
     COMBO-BOX-Periodo AT ROW 1.38 COL 31 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-NroMes AT ROW 2.54 COL 31 COLON-ALIGNED WIDGET-ID 4
     TOGGLE-1 AT ROW 3.88 COL 4 WIDGET-ID 6
     FILL-IN-FchAst-1 AT ROW 3.69 COL 31 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchAst-2 AT ROW 3.69 COL 52 COLON-ALIGNED WIDGET-ID 10
     COMBO-BOX-CodOpe AT ROW 4.85 COL 31 COLON-ALIGNED WIDGET-ID 12
     BROWSE-5 AT ROW 6.19 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 114.43 BY 25.31 WIDGET-ID 100.


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
         TITLE              = "MIGRACION DE PROGRESS A OPENORANGE"
         HEIGHT             = 25.31
         WIDTH              = 114.43
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-5 COMBO-BOX-CodOpe fMain */
/* SETTINGS FOR FILL-IN FILL-IN-FchAst-1 IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchAst-2 IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.cb-cmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.cb-cmov.CodDiv
     _FldNameList[2]   = INTEGRAL.cb-cmov.CodOpe
     _FldNameList[3]   = INTEGRAL.cb-cmov.NroAst
     _FldNameList[4]   = INTEGRAL.cb-cmov.FchAst
     _FldNameList[5]   = INTEGRAL.cb-cmov.NotAst
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* MIGRACION DE PROGRESS A OPENORANGE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* MIGRACION DE PROGRESS A OPENORANGE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* Button 3 */
DO:
    MESSAGE 'Procedemos con la migracióna aOpenOrange?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS lo.
    IF rpta = NO THEN RETURN NO-APPLY.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Migracion.
    SESSION:SET-WAIT-STATE('').
    {&OPEN-QUERY-{&BROWSE-NAME}}
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodOpe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodOpe wWin
ON VALUE-CHANGED OF COMBO-BOX-CodOpe IN FRAME fMain /* Operación */
DO:
    ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroMes wWin
ON VALUE-CHANGED OF COMBO-BOX-NroMes IN FRAME fMain /* Mes */
DO:
    ASSIGN {&self-name}.
    RUN src\bin\_dateif ( INPUT COMBO-BOX-NroMes,
                        INPUT COMBO-BOX-Periodo, 
                        OUTPUT FILL-IN-FchAst-1, 
                        OUTPUT FILL-IN-FchAst-2).
    DISPLAY FILL-IN-FchAst-1 FILL-IN-FchAst-2 WITH FRAME {&FRAME-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo wWin
ON VALUE-CHANGED OF COMBO-BOX-Periodo IN FRAME fMain /* Seleccione el Periodo */
DO:
    ASSIGN {&self-name}.
    RUN src\bin\_dateif ( INPUT COMBO-BOX-NroMes,
                        INPUT COMBO-BOX-Periodo, 
                        OUTPUT FILL-IN-FchAst-1, 
                        OUTPUT FILL-IN-FchAst-2).
    DISPLAY FILL-IN-FchAst-1 FILL-IN-FchAst-2 WITH FRAME {&FRAME-NAME}.

    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchAst-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchAst-1 wWin
ON LEAVE OF FILL-IN-FchAst-1 IN FRAME fMain /* Desde */
DO:
  IF YEAR(INPUT {&SELF-NAME}) <> COMBO-BOX-Periodo
      OR MONTH(INPUT {&SELF-NAME}) <> COMBO-BOX-NroMes
      THEN DO:
      MESSAGE 'Ingrese la fecha correctamente' VIEW-AS ALERT-BOX ERROR.
      DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
  END.
  ASSIGN {&self-name}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchAst-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchAst-2 wWin
ON LEAVE OF FILL-IN-FchAst-2 IN FRAME fMain /* Hasta */
DO:
    IF YEAR(INPUT {&SELF-NAME}) <> COMBO-BOX-Periodo
        OR MONTH(INPUT {&SELF-NAME}) <> COMBO-BOX-NroMes
        THEN DO:
        MESSAGE 'Ingrese la fecha correctamente' VIEW-AS ALERT-BOX ERROR.
        DISPLAY {&SELF-NAME} WITH FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
    END.
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 wWin
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME fMain /* Por Rango de fechas */
DO:
  ASSIGN {&self-name}.
  IF {&self-name} THEN ASSIGN  FILL-IN-FchAst-1:SENSITIVE = YES FILL-IN-FchAst-2:SENSITIVE = YES.
  ELSE ASSIGN  FILL-IN-FchAst-1:SENSITIVE = NO FILL-IN-FchAst-2:SENSITIVE = NO.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-NroMes TOGGLE-1 FILL-IN-FchAst-1 
          FILL-IN-FchAst-2 COMBO-BOX-CodOpe 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BtnDone BUTTON-3 COMBO-BOX-Periodo COMBO-BOX-NroMes TOGGLE-1 
         COMBO-BOX-CodOpe BROWSE-5 
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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Periodo:DELETE(1).
      FOR EACH cb-peri NO-LOCK WHERE cb-peri.codcia = s-codcia:
          COMBO-BOX-Periodo:ADD-LAST(STRING(CB-PERI.Periodo)).
      END.
      IF LOOKUP(STRING(YEAR(TODAY)), COMBO-BOX-Periodo:LIST-ITEMS) = 0 
          THEN COMBO-BOX-Periodo:ADD-LAST(STRING(YEAR(TODAY))).
      COMBO-BOX-Periodo = YEAR(TODAY).
      COMBO-BOX-NroMes = MONTH(TODAY).
      RUN src\bin\_dateif ( INPUT COMBO-BOX-NroMes,
                            INPUT COMBO-BOX-Periodo, 
                            OUTPUT FILL-IN-FchAst-1, 
                            OUTPUT FILL-IN-FchAst-2).
      COMBO-BOX-CodOpe:DELIMITER = '|'.
      FOR EACH cb-oper NO-LOCK WHERE cb-oper.CodCia = cb-codcia:
          COMBO-BOX-CodOpe:ADD-LAST(cb-oper.Codope + ' - ' + cb-oper.Nomope, cb-oper.Codope).
      END.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Migracion wWin 
PROCEDURE Migracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro borramos datos */
FOR EACH OOCb-cmov WHERE {&Condicion2}:
    FOR EACH OOCb-dmov OF OOCb-cmov:
        DELETE OOCb-dmov.
    END.
    DELETE OOCb-cmov.
END.
/* 2do. migramos */
DEF VAR x-NroItm AS INT NO-UNDO.
FOR EACH Cb-cmov NO-LOCK WHERE {&Condicion}:
    FIND OOCb-cmov OF Cb-cmov EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE OOCb-cmov THEN DO:
        FOR EACH OOCb-dmov OF OOCb-cmov:
            DELETE OOCb-dmov.
        END.
        DELETE OOCb-cmov.
    END.
    CREATE OOCb-cmov.
    BUFFER-COPY Cb-cmov
        TO OOCb-cmov
        ASSIGN
        OOCb-cmov.FlagMigracion = "N"
        OOCb-cmov.FlagFecha = TODAY
        OOCb-cmov.FlagHora = STRING(TIME, 'HH:MM:SS').
    x-NroItm = 1.
    FOR EACH Cb-dmov OF Cb-cmov NO-LOCK BY Cb-dmov.NroItm:
        CREATE OOCb-dmov.
        BUFFER-COPY Cb-dmov
            TO OOCb-dmov
            ASSIGN
            OOCb-dmov.FlagMigracion = "N"
            OOCb-dmov.FlagFecha = OOCb-cmov.FlagFecha
            OOCb-dmov.FlagHora = OOCb-cmov.FlagHora
            OOCb-dmov.NroItm = x-NroItm
            OOCb-dmov.MasterID = STRING(ROWID(Cb-dmov)).
        x-NroItm = x-NroItm + 1.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

