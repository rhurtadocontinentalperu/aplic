&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History:
    Modificó    Fecha       Objetivo
    --------    ----------- --------------------------------------------
    MLR-1       03/Ago/2008 Modificación de estructura de archivo .jor.
                            Captura las horas y minutos ordinarios trabajados
                            así como las horas y minutos de los sobretiempos.
    MLR-2       17/Set/2008 Muestra campos para "Afliciación Asegura tu
                            Pensión" (PL-FLG-MES.Campo-C[1]), "Categoría
                            Ocupacional del Trabajador" (PL-FLG-MES.Campo-C[2])
                            y "Convenio para Evitar Doble Tributación"
                            (PL-FLG-MES.Campo-C[3]) en archivo .t01.

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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-periodo AS INT.
DEFINE SHARED VAR s-nromes AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE s-CodPln LIKE PL-FLG-MES.codpln NO-UNDO.
DEFINE VARIABLE x-periodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-RUCCia AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

s-CodPln = 1.   /* Ojo */

DEFINE STREAM strm1.
DEFINE STREAM strm2.
DEFINE STREAM strm3.
DEFINE STREAM strm4.
DEFINE STREAM strm7.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE TEMP-TABLE wrk_pdt NO-UNDO
    FIELDS wrk_tabla AS CHARACTER
    FIELDS wrk_TpoDocId LIKE PL-PERS.TpoDocId
    FIELDS wrk_NroDocId LIKE PL-PERS.NroDocId
    FIELDS wrk_char AS CHARACTER EXTENT 10 
    FIELDS wrk_int AS INTEGER EXTENT 10
    FIELDS wrk_dec AS DECIMAL EXTENT 10
    FIELDS wrk_date AS DATE EXTENT 10
    INDEX IDX01 IS PRIMARY wrk_tabla wrk_TpoDocId wrk_NroDocId.

DEFINE TEMP-TABLE wrko_obr NO-UNDO
    FIELDS wrko_codper AS CHARACTER
    INDEX IDX01 IS PRIMARY wrko_codper.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
        SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

DEFINE VARIABLE iNroMes LIKE PL-FLG-MES.NROMES NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 COMBO-BOX-Periodo COMBO-BOX-mes ~
BUTTON-8 TOGGLE-5 FILL-IN-5 TOGGLE-6 FILL-IN-6 BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-mes ~
FILL-IN-Directorio TOGGLE-5 FILL-IN-5 TOGGLE-6 FILL-IN-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-8 
     LABEL "..." 
     SIZE 4 BY .77.

DEFINE VARIABLE COMBO-BOX-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Directorio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Carpeta de destino" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.5.

DEFINE VARIABLE TOGGLE-5 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-6 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.58 COL 11 COLON-ALIGNED
     COMBO-BOX-mes AT ROW 1.58 COL 23 COLON-ALIGNED
     FILL-IN-Directorio AT ROW 2.73 COL 17 COLON-ALIGNED WIDGET-ID 12
     BUTTON-8 AT ROW 2.73 COL 37 WIDGET-ID 14
     TOGGLE-5 AT ROW 5.23 COL 29
     FILL-IN-5 AT ROW 5.23 COL 30 COLON-ALIGNED NO-LABEL
     TOGGLE-6 AT ROW 6.04 COL 29
     FILL-IN-6 AT ROW 6.04 COL 30 COLON-ALIGNED NO-LABEL
     BUTTON-2 AT ROW 7.54 COL 44
     BUTTON-1 AT ROW 7.58 COL 29
     " Generar archivos para:" VIEW-AS TEXT
          SIZE 16.29 BY .5 AT ROW 4.46 COL 4
     "Remuneración del trabajador:" VIEW-AS TEXT
          SIZE 20.29 BY .5 AT ROW 6.15 COL 27.29 RIGHT-ALIGNED
     "Jornada laboral por Trabajador:" VIEW-AS TEXT
          SIZE 21.29 BY .5 AT ROW 5.35 COL 27.29 RIGHT-ALIGNED
     RECT-2 AT ROW 4.85 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.57 BY 8.62
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Planilla Electrónica"
         HEIGHT             = 8.62
         WIDTH              = 62.57
         MAX-HEIGHT         = 15.27
         MAX-WIDTH          = 65.86
         VIRTUAL-HEIGHT     = 15.27
         VIRTUAL-WIDTH      = 65.86
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   DEF-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME F-Main
   DEF-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Directorio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TEXT-LITERAL "Jornada laboral por Trabajador:"
          SIZE 21.29 BY .5 AT ROW 5.35 COL 27.29 RIGHT-ALIGNED          */

/* SETTINGS FOR TEXT-LITERAL "Remuneración del trabajador:"
          SIZE 20.29 BY .5 AT ROW 6.15 COL 27.29 RIGHT-ALIGNED          */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Planilla Electrónica */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Planilla Electrónica */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-BOX-Periodo
            COMBO-BOX-Mes
            FILL-IN-5
            FILL-IN-6
            TOGGLE-5
            TOGGLE-6.
    END.
    IF TOGGLE-5 OR TOGGLE-6 THEN DO:
        RUN proc_create-files-EMP.  /* Empleados */
    END.
    HIDE FRAME F-Proceso.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* ... */
DO:
    SYSTEM-DIALOG GET-DIR FILL-IN-Directorio
      TITLE 'Seleccione la carpeta de destino'.
    ASSIGN COMBO-BOX-mes COMBO-BOX-Periodo.
    ASSIGN
        FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".jor".
        FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".rem".
    DISPLAY 
        FILL-IN-Directorio 
        FILL-IN-5 
        FILL-IN-6 
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-mes W-Win
ON VALUE-CHANGED OF COMBO-BOX-mes IN FRAME F-Main /* Mes */
DO:
    ASSIGN COMBO-BOX-mes COMBO-BOX-Periodo.
    ASSIGN
        FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".jor".
        FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".rem".
    DISPLAY FILL-IN-5 FILL-IN-6 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Periodo IN FRAME F-Main /* Periodo */
DO:
    ASSIGN COMBO-BOX-mes COMBO-BOX-Periodo.
    ASSIGN
        FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".jor".
        FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +
             STRING(COMBO-BOX-Mes,"99") + x-RUCCia + ".rem".
    DISPLAY FILL-IN-5 FILL-IN-6 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-5 W-Win
ON VALUE-CHANGED OF TOGGLE-5 IN FRAME F-Main
DO:
    FILL-IN-5:SENSITIVE = INPUT TOGGLE-5.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-6 W-Win
ON VALUE-CHANGED OF TOGGLE-6 IN FRAME F-Main
DO:
    FILL-IN-6:SENSITIVE = INPUT TOGGLE-6.
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-mes FILL-IN-Directorio TOGGLE-5 FILL-IN-5 
          TOGGLE-6 FILL-IN-6 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-2 COMBO-BOX-Periodo COMBO-BOX-mes BUTTON-8 TOGGLE-5 FILL-IN-5 
         TOGGLE-6 FILL-IN-6 BUTTON-2 BUTTON-1 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

/* Code placed here will execute PRIOR to standard behavior. */
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-Periodo:LIST-ITEMS = x-Periodo
        COMBO-BOX-Periodo = s-periodo
        COMBO-BOX-Mes = ENTRY(s-nromes,COMBO-BOX-Mes:LIST-ITEMS).
    FIND gn-cias WHERE gn-cias.codcia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE gn-cias THEN x-RUCCia = GN-CIAS.LIBRE-C[1].
    ELSE x-RUCCia = "FALTARUC".
/*     ASSIGN                                                       */
/*          FILL-IN-1 = "M:\" + x-RUCCia + ".t00".                  */
/*          FILL-IN-2 = "M:\" + x-RUCCia + ".t01".                  */
/*          FILL-IN-3 = "M:\" + x-RUCCia + ".p00".                  */
/*          FILL-IN-4 = "M:\" + x-RUCCia + ".der".                  */
/*          FILL-IN-5 = "M:\" + "0601" + STRING(s-periodo,"9999") + */
/*              STRING(s-nromes,"99") + x-RUCCia + ".jor".          */
/*          FILL-IN-6 = "M:\" + "0601" + STRING(s-periodo,"9999") + */
/*              STRING(s-nromes,"99") + x-RUCCia + ".rem".          */
/*          FILL-IN-7 = "M:\" + "0601" + STRING(s-periodo,"9999") + */
/*              STRING(s-nromes,"99") + x-RUCCia + ".tes".          */
/*          FILL-IN-8 = "M:\" + "0601" + STRING(s-periodo,"9999") + */
/*              STRING(s-nromes,"99") + x-RUCCia + ".4ta".          */
/*          FILL-IN-9 = "M:\" + x-RUCCia + ".t03".                  */
    ASSIGN
        FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(s-periodo,"9999") +
             STRING(s-nromes,"99") + x-RUCCia + ".jor".
        FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "0601" + STRING(s-periodo,"9999") +
             STRING(s-nromes,"99") + x-RUCCia + ".rem".
    DO i = 1 TO NUM-ENTRIES(x-Periodo):
        IF ENTRY(i,x-Periodo) = "" THEN pto = COMBO-BOX-Periodo:DELETE("").
    END.
END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_create-files-EMP W-Win 
PROCEDURE proc_create-files-EMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTelefono AS CHARACTER FORMAT "X(10)" NO-UNDO.
DEFINE VARIABLE cSeccion AS CHARACTER FORMAT "X(4)" NO-UNDO.
DEFINE VARIABLE dDiasTrabajados LIKE PL-MOV-MES.ValCal-Mes NO-UNDO.
DEFINE VARIABLE iDiaMes AS INTEGER NO-UNDO.

DEFINE BUFFER b_FLG-MES FOR PL-FLG-MES.

/*MLR-1*/ DEFINE VARIABLE dDias AS DECIMAL NO-UNDO.
/*MLR-1*/ DEFINE VARIABLE dHoras AS DECIMAL NO-UNDO.
/*MLR-1*/ DEFINE VARIABLE dMinutos AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    iNroMes = LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS).
END.

EMPTY TEMP-TABLE wrk_pdt.

FOR EACH PL-FLG-MES WHERE
    PL-FLG-MES.CodCia = s-codcia AND
    PL-FLG-MES.Periodo = COMBO-BOX-Periodo AND
    PL-FLG-MES.codpln = s-CodPln AND
    PL-FLG-MES.NROMES = iNroMes NO-LOCK,
    FIRST PL-PERS WHERE PL-PERS.codper = PL-FLG-MES.codper NO-LOCK:
    Fi-Mensaje = "  Procesando : " + PL-PERS.codper.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    IF TOGGLE-5 THEN DO:    /* Jornada Laboral */
        FIND PL-MOV-MES WHERE
            PL-MOV-MES.CodCia = PL-FLG-MES.CodCia AND
            PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
            PL-MOV-MES.NroMes = PL-FLG-MES.NroMes AND
            PL-MOV-MES.CodPln = PL-FLG-MES.CodPln AND
            PL-MOV-MES.CodCal = 1 AND
            PL-MOV-MES.CodPer = PL-FLG-MES.CodPer AND
            PL-MOV-MES.CodMov = 100 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-MES THEN DO:
            CREATE wrk_pdt.
            ASSIGN
                wrk_tabla = "jor"
                wrk_TpoDocId = PL-PERS.TpoDocId
                wrk_NroDocId = PL-PERS.NroDocId.
            IF PL-MOV-MES.NroMes <> 2 THEN DO:
/*MLR-1*/       dDias = PL-MOV-MES.ValCal-Mes.
            END.
            ELSE DO:
                dDiasTrabajados = PL-MOV-MES.ValCal-Mes.
                iDiaMes = DAY(DATE(PL-MOV-MES.NroMes + 1,1,PL-MOV-MES.Periodo) - 1).
                IF dDiasTrabajados > iDiaMes THEN
                    dDiasTrabajados = iDiaMes.
/*MLR-1* ***    wrk_int[1] = dDiasTrabajados. */
/*MLR-1* ***    wrk_int[2] = dDiasTrabajados * 8. */
/*MLR-1*/       dDias = dDiasTrabajados.
            END.
/*MLR-1* Inicio de Bloque */
            dHoras = dDias * 8.
            dMinutos = dHoras - TRUNCATE(dHoras,0).
            dHoras = dHoras - dMinutos.
            dMinutos = dMinutos * 60.
            wrk_int[1] = dHoras.
            wrk_int[2] = dMinutos.
/*MLR-1* Fin de Bloque */
        END.
/*MLR-1*/ dHoras = 0.
        FOR EACH PL-MOV-MES WHERE
            PL-MOV-MES.CodCia = PL-FLG-MES.CodCia AND
            PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
            PL-MOV-MES.NroMes = PL-FLG-MES.NroMes AND
            PL-MOV-MES.CodPln = PL-FLG-MES.CodPln AND
            PL-MOV-MES.CodCal = 0 AND
            PL-MOV-MES.CodPer = PL-FLG-MES.CodPer AND
            LOOKUP(STRING(PL-MOV-MES.CodMov),"125,126,127") > 0 NO-LOCK:
            IF NOT CAN-FIND(FIRST wrk_pdt WHERE
                wrk_tabla = "jor" AND
                wrk_TpoDocId = PL-PERS.TpoDocId AND
                wrk_NroDocId = PL-PERS.NroDocId) THEN DO:
                CREATE wrk_pdt.
                ASSIGN
                    wrk_tabla = "jor"
                    wrk_TpoDocId = PL-PERS.TpoDocId
                    wrk_NroDocId = PL-PERS.NroDocId.
            END.
/*MLR-1***  wrk_int[3] = wrk_int[3] + PL-MOV-MES.ValCal-Mes. */
/*MLR-1*/   dHoras = dHoras + PL-MOV-MES.ValCal-Mes.
        END.
/*MLR-1* Inicio de Bloque */
        IF dHoras > 0 THEN DO:
            dMinutos = dHoras - TRUNCATE(dHoras,0).
            dHoras = dHoras - dMinutos.
            dMinutos = dMinutos * 60.
            wrk_int[3] = dHoras.
            wrk_int[4] = dMinutos.
        END.
/*MLR-1* Fin de Bloque */
    END.
    IF TOGGLE-6 THEN DO:    /* Remuneraciones */
        /* Datos por Default que siempre deben llevar cero como valor inicial */
        CREATE wrk_pdt.
        ASSIGN
            wrk_tabla = "rem"
            wrk_TpoDocId = PL-PERS.TpoDocId
            wrk_NroDocId = PL-PERS.NroDocId
            wrk_int[1] = 605.
        CREATE wrk_pdt.
        ASSIGN
            wrk_tabla = "rem"
            wrk_TpoDocId = PL-PERS.TpoDocId
            wrk_NroDocId = PL-PERS.NroDocId
            wrk_int[1] = 807.
        FOR EACH PL-BOLE NO-LOCK WHERE
            PL-BOLE.CodPln = PL-FLG-MES.CodPln AND
            PL-BOLE.CodCal >= 1 AND
            PL-BOLE.CodCal <> 2 AND
            PL-BOLE.TpoBol <> "Otros",
            EACH PL-MOV-MES WHERE
            PL-MOV-MES.CodCia  = PL-FLG-MES.CodCia AND
            PL-MOV-MES.Periodo = PL-FLG-MES.Periodo AND
            PL-MOV-MES.NroMes  = PL-FLG-MES.NroMes AND
            PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
            PL-MOV-MES.CodCal  = PL-BOLE.codcal AND
            PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
            PL-MOV-MES.CodMov  = PL-BOLE.CodMov NO-LOCK:
            FIND FIRST PL-TABLA WHERE
                PL-TABLA.CodCia = 0 AND
                PL-TABLA.Tabla = "22" AND
                PL-TABLA.Digito = PL-MOV-MES.CodMov
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PL-TABLA THEN NEXT.
            FIND FIRST wrk_pdt WHERE
                wrk_tabla = "rem" AND
                wrk_TpoDocId = PL-PERS.TpoDocId AND
                wrk_NroDocId = PL-PERS.NroDocId AND
                wrk_int[1] = INTEGER(PL-TABLA.Codigo) NO-ERROR.
            IF NOT AVAILABLE wrk_pdt THEN DO:
                CREATE wrk_pdt.
                ASSIGN
                    wrk_tabla = "rem"
                    wrk_TpoDocId = PL-PERS.TpoDocId
                    wrk_NroDocId = PL-PERS.NroDocId
                    wrk_int[1] = INTEGER(PL-TABLA.Codigo).
            END.
            wrk_dec[1] = wrk_dec[1] + PL-MOV-MES.ValCal-Mes.
            wrk_dec[2] = wrk_dec[2] + PL-MOV-MES.ValCal-Mes.
        END.
    END.
END.    /* FOR EACH PL-FLG-MES... */

/* RHC 11.05.2010 En caso de utilidades SOLO se graba en el cáculo 000 */
IF TOGGLE-6 THEN DO:
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.CodCia = s-codcia
        AND PL-MOV-MES.Periodo = COMBO-BOX-Periodo
        AND PL-MOV-MES.NroMes = iNroMes
        AND PL-MOV-MES.CodPln = s-CodPln
        AND PL-MOV-MES.CodCal = 000
        AND PL-MOV-MES.CodMov = 137,        /* UTILIDADES */
        FIRST PL-PERS OF PL-MOV-MES NO-LOCK,
        FIRST PL-TABLA NO-LOCK WHERE PL-TABLA.CodCia = 0 
        AND PL-TABLA.Tabla = "22" 
        AND PL-TABLA.Digito = PL-MOV-MES.CodMov:
        FIND FIRST wrk_pdt WHERE wrk_tabla = "rem" 
            AND wrk_TpoDocId = PL-PERS.TpoDocId 
            AND wrk_NroDocId = PL-PERS.NroDocId 
            AND wrk_int[1] = INTEGER(PL-TABLA.Codigo) NO-ERROR.
        IF NOT AVAILABLE wrk_pdt THEN DO:
            CREATE wrk_pdt.
            ASSIGN
                wrk_tabla = "rem"
                wrk_TpoDocId = PL-PERS.TpoDocId
                wrk_NroDocId = PL-PERS.NroDocId
                wrk_int[1] = INTEGER(PL-TABLA.Codigo).
        END.
        wrk_dec[1] = wrk_dec[1] + PL-MOV-MES.ValCal-Mes.
        wrk_dec[2] = wrk_dec[2] + PL-MOV-MES.ValCal-Mes.
    END.
    /* Retención de 5ta por Utilidades */
    FOR EACH PL-MOV-MES NO-LOCK WHERE PL-MOV-MES.CodCia = s-codcia
        AND PL-MOV-MES.Periodo = COMBO-BOX-Periodo
        AND PL-MOV-MES.NroMes = iNroMes
        AND PL-MOV-MES.CodPln = s-CodPln
        AND PL-MOV-MES.CodCal = 020         /* Boleta de Utilidades */
        AND PL-MOV-MES.CodMov = 907,        /* Retención 5ta */
        FIRST PL-PERS OF PL-MOV-MES NO-LOCK,
        FIRST PL-TABLA NO-LOCK WHERE PL-TABLA.CodCia = 0 
        AND PL-TABLA.Tabla = "22" 
        AND PL-TABLA.Digito = 215:      /* Impuesto a la Renta 5ta */
        FIND FIRST wrk_pdt WHERE wrk_tabla = "rem" 
            AND wrk_TpoDocId = PL-PERS.TpoDocId 
            AND wrk_NroDocId = PL-PERS.NroDocId 
            AND wrk_int[1] = INTEGER(PL-TABLA.Codigo) NO-ERROR.
        IF NOT AVAILABLE wrk_pdt THEN DO:
            CREATE wrk_pdt.
            ASSIGN
                wrk_tabla = "rem"
                wrk_TpoDocId = PL-PERS.TpoDocId
                wrk_NroDocId = PL-PERS.NroDocId
                wrk_int[1] = INTEGER(PL-TABLA.Codigo).
        END.
        wrk_dec[1] = wrk_dec[1] + PL-MOV-MES.ValCal-Mes.
        wrk_dec[2] = wrk_dec[2] + PL-MOV-MES.ValCal-Mes.
    END.
END.

RUN proc_output-files-EMP.

MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_output-files-EMP W-Win 
PROCEDURE proc_output-files-EMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x_NroDocId LIKE wrk_NroDocId.

IF TOGGLE-5 THEN DO:
    OUTPUT STREAM strm1 TO VALUE(FILL-IN-5).
    FOR EACH wrk_pdt WHERE wrk_tabla = "jor" NO-LOCK:
        PUT STREAM strm1 UNFORMATTED 
            wrk_TpoDocId "|"
            wrk_NroDocId "|".
        PUT STREAM strm1 UNFORMATTED
            wrk_int[1] "|"
            wrk_int[2] "|"
            wrk_int[3] "|"
/*MLR-1*/   wrk_int[4] "|"
            SKIP.
    END.
    OUTPUT STREAM strm1 CLOSE.
END.

IF TOGGLE-6 THEN DO:
    OUTPUT STREAM strm1 TO VALUE(FILL-IN-6).
    FOR EACH wrk_pdt WHERE wrk_tabla = "rem" NO-LOCK:
        PUT STREAM strm1 UNFORMATTED
            wrk_TpoDocId "|"
            wrk_NroDocId "|"
            STRING(wrk_int[1], "9999") "|".
        PUT STREAM strm1 UNFORMATTED
            TRIM(STRING(wrk_dec[1], ">>>>>9.99")) "|"
            TRIM(STRING(wrk_dec[2], ">>>>>9.99")) "|"
            SKIP.
    END.
    OUTPUT STREAM strm1 CLOSE.
END.


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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

