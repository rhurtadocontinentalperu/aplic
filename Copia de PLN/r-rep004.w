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

DEF TEMP-TABLE Detalle
    FIELD periodo       AS INT
    FIELD nromes        AS INT
    FIELD Personal      AS CHAR FORMAT 'x(80)'
    FIELD CodCal        AS CHAR FORMAT 'x(40)'
    FIELD CodMov        LIKE PL-BOLE.CodMov
    FIELD ValCal-Mes    LIKE PL-MOV-MES.valcal-mes
    FIELD Cargos        AS CHAR FORMAT 'x(40)'
    FIELD Seccion       AS CHAR FORMAT 'x(40)'.

DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR lOptions AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Periodo FILL-IN-CodPer ~
COMBO-BOX-CodCal SELECT-TpoBol BUTTON-12 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Periodo FILL-IN-CodPer ~
FILL-IN-NomPer COMBO-BOX-CodCal SELECT-TpoBol FILL-IN-Mensaje 

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

DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 12" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-CodCal AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Cálculo" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Periodo AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE SELECT-TpoBol AS CHARACTER INITIAL "Remuneraciones" 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "Remuneraciones","Descuentos","Aportes" 
     SIZE 19 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     FILL-IN-Periodo AT ROW 1.19 COL 19 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-CodPer AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-NomPer AT ROW 2.35 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     COMBO-BOX-CodCal AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 14
     SELECT-TpoBol AT ROW 4.77 COL 21 NO-LABEL WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 7.15 COL 8 NO-LABEL WIDGET-ID 16
     BUTTON-12 AT ROW 8.27 COL 49 WIDGET-ID 12
     BtnDone AT ROW 8.27 COL 64 WIDGET-ID 18
     "Tipo:" VIEW-AS TEXT
          SIZE 6 BY .62 AT ROW 4.85 COL 15 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.38 WIDGET-ID 100.


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
         TITLE              = "CONCEPTOS DE CALCULOS - ANUAL"
         HEIGHT             = 9.38
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CONCEPTOS DE CALCULOS - ANUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CONCEPTOS DE CALCULOS - ANUAL */
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


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 wWin
ON CHOOSE OF BUTTON-12 IN FRAME fMain /* Button 12 */
DO:
  ASSIGN
      COMBO-BOX-CodCal FILL-IN-Periodo SELECT-TpoBol FILL-IN-CodPer.

   RUN lib/tt-file-to-text (OUTPUT pOptions, OUTPUT pArchivo).
   IF pOptions = "" THEN RETURN NO-APPLY.

   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporal.
   SESSION:SET-WAIT-STATE('').
   FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

   FIND FIRST Detalle NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Detalle THEN DO:
       MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
   END.
   pOptions = pOptions.

   RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).

   MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPer wWin
ON LEAVE OF FILL-IN-CodPer IN FRAME fMain /* Personal */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND pl-pers WHERE pl-pers.codper = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE pl-pers THEN DO:
      MESSAGE 'Personal NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FILL-IN-NomPer:SCREEN-VALUE = TRIM(PL-PERS.patper) + ' ' + TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper.
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

EMPTY TEMP-TABLE Detalle.

FOR EACH pl-mov-mes NO-LOCK WHERE pl-mov-mes.codcia = s-codcia
    AND pl-mov-mes.periodo = FILL-IN-Periodo
    AND PL-MOV-MES.codpln = 01
    AND (FILL-IN-CodPer = "" OR pl-mov-mes.codper = FILL-IN-CodPer)
    AND (COMBO-BOX-CodCal = 'Todos' OR PL-MOV-MES.codcal = INTEGER(ENTRY(1, COMBO-BOX-CodCal, ' - ')) ),
    FIRST pl-flg-mes OF pl-mov-mes NO-LOCK,
    FIRST pl-calc NO-LOCK WHERE PL-CALC.codcal = pl-mov-mes.codcal
    AND PL-CALC.codpln = pl-mov-mes.codpln,
    FIRST pl-bole OF pl-mov-mes NO-LOCK WHERE PL-BOLE.TpoBol = SELECT-TpoBol,
    FIRST pl-pers NO-LOCK WHERE pl-pers.codper = pl-mov-mes.codper:
    CREATE Detalle.
    ASSIGN
        Detalle.periodo = pl-mov-mes.periodo
        Detalle.nromes = pl-mov-mes.nromes
        Detalle.Personal = pl-pers.codper + ' ' +
                            TRIM(pl-pers.patper) + ' ' +
                            TRIM(pl-pers.matper) + ', ' + pl-pers.nomper
        Detalle.CodCal = STRING(pl-calc.codpln, '999') + ' ' + PL-CALC.descal
        Detalle.CodMov = pl-mov-mes.codmov
        Detalle.valcal-mes = pl-mov-mes.valcal-mes
        Detalle.Cargos = pl-flg-mes.cargos
        Detalle.Seccion = pl-flg-mes.seccion.

    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        'PERSONAL: ' + pl-mov-mes.codper + ' ' +
        'MES: ' + STRING (pl-mov-mes.nromes, '99') + ' ' +
        'CONCEPTO: ' + STRING(pl-mov-mes.codmov, '999').

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
  DISPLAY FILL-IN-Periodo FILL-IN-CodPer FILL-IN-NomPer COMBO-BOX-CodCal 
          SELECT-TpoBol FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE FILL-IN-Periodo FILL-IN-CodPer COMBO-BOX-CodCal SELECT-TpoBol 
         BUTTON-12 BtnDone 
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
  FILL-IN-Periodo = YEAR(TODAY).
  FOR EACH pl-calc NO-LOCK WHERE PL-CALC.codpln = 01
      WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodCal:ADD-LAST( STRING(PL-CALC.codcal, '999') + ' - ' + PL-CALC.descal).
  END.
/*   FIND FIRST pl-calc WHERE PL-CALC.codpln = 01 NO-LOCK NO-ERROR.                                       */
/*   IF AVAILABLE pl-calc THEN COMBO-BOX-CodCal = STRING(PL-CALC.codcal, '999') + ' - ' + PL-CALC.descal. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
PROCEDURE recoge-parametros :
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

