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
{lib/tt-file.i}

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEFINE TEMP-TABLE Detalle
    FIELD CodDiv AS CHAR FORMAT 'x(5)' LABEL 'Division'
    FIELD CodDoc AS CHAR FORMAT 'x(3)' LABEL 'Doc.'
    FIELD NroDoc AS CHAR FORMAT 'x(15)' LABEL 'Nro.'
    FIELD FchDoc AS DATE FORMAT {&tt-fmt-mdy} LABEL 'Fecha'
    FIELD Glosa AS CHAR FORMAT 'x(80)' LABEL 'Observaciones'
    FIELD CodMon AS INT FORMAT '9' LABEL 'Moneda'
    FIELD ImpTot AS DEC FORMAT '(>>>,>>>,>>9.99)' LABEL 'Importe'
    FIELD CodRef AS CHAR FORMAT 'x(3)' LABEL 'Ref.'
    FIELD NroRef AS CHAR FORMAT 'x(15)' LABEL 'Nro. Ref.'
    FIELD FchRef AS DATE FORMAT {&tt-fmt-mdy} LABEL 'Fch. Ref.'
    FIELD Usuario AS CHAR FORMAT 'x(10)' LABEL 'Usuario'
    .

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-2 ~
RADIO-SET-Tabulador BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
RADIO-SET-Tabulador 

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
     SIZE 9 BY 1.88
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 2" 
     SIZE 15 BY 1.88 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Emitidas desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tabulador AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Línea vertical (|)", 1,
"Tabulador", 2
     SIZE 20 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-FchDoc-1 AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchDoc-2 AT ROW 3.15 COL 29 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 6.38 COL 11 WIDGET-ID 14
     RADIO-SET-Tabulador AT ROW 6.38 COL 42 NO-LABEL WIDGET-ID 2
     BtnDone AT ROW 1.54 COL 61 WIDGET-ID 12
     "Separadores:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 6.65 COL 28 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.5 WIDGET-ID 100.


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
         TITLE              = "NOTAS DE CREDITO"
         HEIGHT             = 9.5
         WIDTH              = 80
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
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* NOTAS DE CREDITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* NOTAS DE CREDITO */
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



&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
  MESSAGE 'Confirmar el inicio de la exportación a texto'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  ASSIGN FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 RADIO-SET-Tabulador.
  RUN Exportar-a-Texto.

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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 RADIO-SET-Tabulador 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BUTTON-2 RADIO-SET-Tabulador BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exportar-a-Texto wWin 
PROCEDURE Exportar-a-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Ok AS LOG NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF BUFFER b-fac FOR ccbcdocu.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Texto" "*.txt"
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".txt"
    SAVE-AS
    TITLE "Defina el archivo texto"
    UPDATE x-Ok.
IF x-Ok = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE Detalle.
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 001
    AND ccbcdocu.coddoc = 'N/C'
    AND ccbcdocu.fchdoc >= FILL-IN-FchDoc-1 
    AND ccbcdocu.fchdoc <= FILL-IN-FchDoc-2
    AND ccbcdocu.flgest <> 'A',
    FIRST b-fac NO-LOCK WHERE b-fac.codcia = 001
    AND b-fac.coddoc = ccbcdocu.codref 
    AND b-fac.nrodoc = ccbcdocu.nroref:               
    CREATE Detalle.
    BUFFER-COPY Ccbcdocu TO Detalle
        ASSIGN Detalle.fchref = b-fac.fchdoc.
END.
SESSION:SET-WAIT-STATE('').

DEF VAR cOptions AS CHAR.
DEF VAR cTabulador AS CHAR.

CASE RADIO-SET-Tabulador:
    WHEN 1 THEN cTabulador = "|".
    WHEN 2 THEN cTabulador = "~011".
END CASE.

coptions = 'FileType:txt' + CHR(1) + 'Grid:Ver:yes' + CHR(1) + 'GridCharVer:' + cTabulador.
RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, x-Archivo, cOptions).
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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
  ASSIGN
      FILL-IN-FchDoc-1 = TODAY
      FILL-IN-FchDoc-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

