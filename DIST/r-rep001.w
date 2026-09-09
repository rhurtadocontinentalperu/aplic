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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

DEF TEMP-TABLE Detalle 
    FIELD CodCia LIKE Ccbcbult.codcia
    FIELD CodDoc AS CHAR FORMAT 'x(3)'  LABEL 'Código'
    FIELD NroDoc AS CHAR FORMAT 'XXX-XXXXXXX' LABEL 'Número'
    FIELD NomCli LIKE Ccbcbult.nomcli
    FIELD Bultos LIKE Ccbcbult.bultos   FORMAT ">>>,>>9"
    FIELD FchDoc LIKE Ccbcbult.fchdoc
    FIELD CHR_02 AS CHAR FORMAT 'x(6)'  LABEL 'Chequeador'
    FIELD NomPer AS CHAR FORMAT 'x(60)' LABEL 'Nombre'
    FIELD Dte_01 AS DATE FORMAT '99/99/9999' LABEL 'Día'
    FIELD CHR_03 AS CHAR FORMAT 'x(5)'  LABEL 'Hora'
    FIELD Tiempo AS CHAR FORMAT 'x(20)' LABEL 'Tiempo'.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-Chequeador BUTTON-16 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 ~
FILL-IN-Chequeador FILL-IN-NomCheq 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-16 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 16" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 5" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-Chequeador AS CHARACTER FORMAT "X(6)":U 
     LABEL "Chequeador" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCheq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-FchDoc-1 AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-FchDoc-2 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Chequeador AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomCheq AT ROW 3.42 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-5 AT ROW 4.85 COL 7 WIDGET-ID 8
     BUTTON-16 AT ROW 4.85 COL 22 WIDGET-ID 14
     BtnDone AT ROW 4.85 COL 37 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 6.04 WIDGET-ID 100.


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
         TITLE              = "REPORTE DE CONTROL DE BULTOS"
         HEIGHT             = 6.04
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-5:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomCheq IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* REPORTE DE CONTROL DE BULTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REPORTE DE CONTROL DE BULTOS */
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


&Scoped-define SELF-NAME BUTTON-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-16 wWin
ON CHOOSE OF BUTTON-16 IN FRAME fMain /* Button 16 */
DO:
  ASSIGN
      FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Chequeador.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* Button 5 */
DO:
  ASSIGN
      FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Chequeador.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Chequeador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Chequeador wWin
ON LEAVE OF FILL-IN-Chequeador IN FRAME fMain /* Chequeador */
DO:
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE pl-pers THEN FILL-IN-NomCheq:SCREEN-VALUE = TRIM(PL-PERS.patper) + ' ' +
      TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Tiempo AS CHAR.

EMPTY TEMP-TABLE Detalle.
FOR EACH Ccbcbult NO-LOCK WHERE CcbCBult.CodCia = s-codcia
    AND CcbCBult.CodDiv = s-coddiv 
    AND (CcbCBult.CodDoc =  'O/D'
         OR CcbCBult.CodDoc = 'O/M'
         OR CcbCBult.CodDoc = 'G/R'
         OR CcbCBult.CodDoc = 'TRA')
    AND CcbCBult.fchdoc >= FILL-IN-FchDoc-1
    AND CcbCBult.fchdoc <= FILL-IN-FchDoc-2
    AND (FILL-IN-Chequeador = "" OR CcbCBult.Chr_02 = FILL-IN-Chequeador):

    CREATE Detalle.
    BUFFER-COPY Ccbcbult
        TO Detalle.
    RUN lib/_time-passed ( DATETIME(STRING(Ccbcbult.dte_02) + ' ' + STRING(Ccbcbult.CHR_04)),
                           DATETIME(STRING(Ccbcbult.dte_01) + ' ' + STRING(Ccbcbult.CHR_03)), 
                           OUTPUT x-Tiempo).
    Detalle.Tiemp = x-Tiempo.
    FIND Pl-pers WHERE Pl-pers.codper = Ccbcbult.CHR_02 NO-LOCK NO-ERROR.
    IF AVAILABLE Pl-pers THEN
        Detalle.nomper = TRIM(Pl-pers.patper) + ' ' + TRIM(Pl-pers.matper) + ', ' + Pl-pers.nomper.
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
  DISPLAY FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Chequeador FILL-IN-NomCheq 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 FILL-IN-Chequeador BUTTON-16 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
PROCEDURE Excel PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.

    RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN Carga-Temporal.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    pOptions = pOptions + CHR(1) + "FieldList:CodDoc,NroDoc,NomCli,Bultos,FchDoc,Chr_02,NomPer,Dte_01,Chr_03,Tiempo".

    RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

    MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
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

GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm\rbalm.prl".
RB-REPORT-NAME = "Control de Rotulado".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "CcbCBult.CodCia = " + STRING(s-codcia) +
    " AND CcbCBult.CodDiv = '" + s-coddiv + "'" +
    " AND (CcbCBult.CodDoc =  'O/D'
     OR CcbCBult.CodDoc = 'O/M'
     OR CcbCBult.CodDoc = 'G/R'
     OR CcbCBult.CodDoc = 'TRA')".
SESSION:DATE-FORMAT = "mdy".
RB-FILTER = RB-FILTER + 
            " AND CcbCBult.fchdoc >= " + STRING(FILL-IN-FchDoc-1) +
            " AND CcbCBult.fchdoc <= " + STRING(FILL-IN-FchDoc-2).
IF FILL-IN-Chequeador <> '' 
    THEN RB-FILTER = RB-FILTER + " AND CcbCBult.Chr_02 = '" + FILL-IN-Chequeador + "'".
RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).
SESSION:DATE-FORMAT = "dmy".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros wWin 
PROCEDURE Procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-parametros wWin 
PROCEDURE Recoge-parametros :
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

