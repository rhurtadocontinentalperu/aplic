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
DEFINE SHARED VAR s-ruccia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE s-CodPln LIKE PL-FLG-MES.codpln NO-UNDO.
DEFINE VARIABLE x-periodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-RUCCia AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VAR fInicial AS DATE NO-UNDO.
DEFINE VAR fFinal   AS DATE NO-UNDO.

s-CodPln = 1.   /* Ojo */
x-RucCia = STRING (s-RucCia, '99999999999').

DEFINE STREAM strm1.
DEFINE STREAM strm2.
DEFINE STREAM strm3.
DEFINE STREAM strm4.
DEFINE STREAM strm5.
DEFINE STREAM strm6.
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-mes ~
FILL-IN-FecIng-1 FILL-IN-FecIng-2 FILL-IN-Cese-1 FILL-IN-Cese-2 BUTTON-8 ~
TOGGLE-1 TOGGLE-2 TOGGLE-3 TOGGLE-4 TOGGLE-5 TOGGLE-6 TOGGLE-7 TOGGLE-8 ~
BUTTON-2 BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-mes ~
FILL-IN-FecIng-1 FILL-IN-FecIng-2 FILL-IN-Cese-1 FILL-IN-Cese-2 ~
FILL-IN-Directorio TOGGLE-1 FILL-IN-1 TOGGLE-2 FILL-IN-2 TOGGLE-3 FILL-IN-3 ~
TOGGLE-4 FILL-IN-4 TOGGLE-5 FILL-IN-5 TOGGLE-6 FILL-IN-6 TOGGLE-7 FILL-IN-7 ~
TOGGLE-8 FILL-IN-8 FILL-IN-9 

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

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datos prestador de servicios" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cese-1 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Cesaron el día" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Cese-2 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Hasta el día" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Directorio AS CHARACTER FORMAT "X(256)":U 
     LABEL "Carpeta de destino" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FecIng-1 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Ingresaron el día" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FecIng-2 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Hasta el día" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-3 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-4 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-5 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-6 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-7 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-8 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-9 AS LOGICAL INITIAL no 
     LABEL "Incluir Personal Periodo Anterior" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.58 COL 11 COLON-ALIGNED
     COMBO-BOX-mes AT ROW 1.58 COL 23 COLON-ALIGNED
     FILL-IN-FecIng-1 AT ROW 2.54 COL 23 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-FecIng-2 AT ROW 2.54 COL 39 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Cese-1 AT ROW 3.5 COL 23 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-Cese-2 AT ROW 3.5 COL 39 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Directorio AT ROW 4.65 COL 23 COLON-ALIGNED WIDGET-ID 12
     BUTTON-8 AT ROW 4.65 COL 43 WIDGET-ID 14
     TOGGLE-1 AT ROW 6.38 COL 29.57
     FILL-IN-1 AT ROW 6.38 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-2 AT ROW 7.19 COL 29.57
     FILL-IN-2 AT ROW 7.19 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-3 AT ROW 8 COL 29.57
     FILL-IN-3 AT ROW 8 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-4 AT ROW 8.81 COL 29.57
     FILL-IN-4 AT ROW 8.81 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-5 AT ROW 9.62 COL 29.57
     FILL-IN-5 AT ROW 9.62 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-6 AT ROW 10.42 COL 29.57
     FILL-IN-6 AT ROW 10.42 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-7 AT ROW 11.23 COL 29.57
     FILL-IN-7 AT ROW 11.23 COL 30.57 COLON-ALIGNED NO-LABEL
     TOGGLE-8 AT ROW 12.04 COL 29.57
     FILL-IN-8 AT ROW 12.04 COL 30.57 COLON-ALIGNED NO-LABEL
     FILL-IN-9 AT ROW 12.85 COL 30.57 COLON-ALIGNED
     TOGGLE-9 AT ROW 13.88 COL 29.57
     BUTTON-2 AT ROW 15.62 COL 56
     BUTTON-1 AT ROW 15.65 COL 41
     "Personal en formación:" VIEW-AS TEXT
          SIZE 16.29 BY .5 AT ROW 10.54 COL 27.86 RIGHT-ALIGNED
     "Datos principales del trabajador:" VIEW-AS TEXT
          SIZE 21.57 BY .5 AT ROW 6.5 COL 27.57 RIGHT-ALIGNED
     "Establecimientos del trabajador:" VIEW-AS TEXT
          SIZE 21.29 BY .5 AT ROW 11.35 COL 7.14
     "Datos del trabajador:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 7.31 COL 27.57 RIGHT-ALIGNED
     "Datos de períodos:" VIEW-AS TEXT
          SIZE 13.29 BY .5 AT ROW 8.12 COL 27.58 RIGHT-ALIGNED
     "Derechohabientes ALTAS:" VIEW-AS TEXT
          SIZE 18.29 BY .5 AT ROW 8.92 COL 27.86 RIGHT-ALIGNED
     "Comprobantes prestadores servicios:" VIEW-AS TEXT
          SIZE 25.29 BY .5 AT ROW 12.15 COL 28.29 RIGHT-ALIGNED
     "Derechohabientes BAJAS:" VIEW-AS TEXT
          SIZE 18.29 BY .5 AT ROW 9.65 COL 27.86 RIGHT-ALIGNED WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.57 BY 17.04
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
         TITLE              = "T-REGISTRO"
         HEIGHT             = 17.04
         WIDTH              = 77.57
         MAX-HEIGHT         = 17.04
         MAX-WIDTH          = 77.57
         VIRTUAL-HEIGHT     = 17.04
         VIRTUAL-WIDTH      = 77.57
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
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-6 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-7 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-8 IN FRAME F-Main
   NO-ENABLE DEF-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-9 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Directorio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-9 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       TOGGLE-9:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR TEXT-LITERAL "Datos principales del trabajador:"
          SIZE 21.57 BY .5 AT ROW 6.5 COL 27.57 RIGHT-ALIGNED           */

/* SETTINGS FOR TEXT-LITERAL "Datos del trabajador:"
          SIZE 14 BY .5 AT ROW 7.31 COL 27.57 RIGHT-ALIGNED             */

/* SETTINGS FOR TEXT-LITERAL "Datos de períodos:"
          SIZE 13.29 BY .5 AT ROW 8.12 COL 27.58 RIGHT-ALIGNED          */

/* SETTINGS FOR TEXT-LITERAL "Derechohabientes ALTAS:"
          SIZE 18.29 BY .5 AT ROW 8.92 COL 27.86 RIGHT-ALIGNED          */

/* SETTINGS FOR TEXT-LITERAL "Derechohabientes BAJAS:"
          SIZE 18.29 BY .5 AT ROW 9.65 COL 27.86 RIGHT-ALIGNED          */

/* SETTINGS FOR TEXT-LITERAL "Personal en formación:"
          SIZE 16.29 BY .5 AT ROW 10.54 COL 27.86 RIGHT-ALIGNED         */

/* SETTINGS FOR TEXT-LITERAL "Comprobantes prestadores servicios:"
          SIZE 25.29 BY .5 AT ROW 12.15 COL 28.29 RIGHT-ALIGNED         */

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
ON END-ERROR OF W-Win /* T-REGISTRO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* T-REGISTRO */
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
            FILL-IN-1
            FILL-IN-2
            FILL-IN-3
            FILL-IN-4
            FILL-IN-5
            FILL-IN-6
            FILL-IN-7
            FILL-IN-8
            FILL-IN-9
            TOGGLE-1
            TOGGLE-2
            TOGGLE-3
            TOGGLE-4
            TOGGLE-5
            TOGGLE-6
            TOGGLE-7
            TOGGLE-8
            TOGGLE-9.
        ASSIGN
             FILL-IN-Cese-1 FILL-IN-Cese-2 FILL-IN-FecIng-1 FILL-IN-FecIng-2 FILL-IN-Directorio.
    END.
    IF FILL-IN-Directorio = '' THEN DO:
        MESSAGE 'Debe seleccionar una carpeta de destino' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
    IF TOGGLE-1 OR TOGGLE-2 OR TOGGLE-3 OR TOGGLE-4 OR
        TOGGLE-5 OR TOGGLE-6 OR TOGGLE-7 OR TOGGLE-8 THEN DO:
        RUN proc_create-files-EMP.  /* Empleados */
        /* 
        RUN proc_create-files-OBR.  /* Obreros */
        */
        MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
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
    ASSIGN
        FILL-IN-1 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".ide"
        FILL-IN-2 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".tra"
        FILL-IN-3 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".per"
        FILL-IN-4 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia +
        STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
        "_ALTA" + ".txt"
        FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + 
        STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
        "_BAJA" + ".txt"
        FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".pfl"
        FILL-IN-7 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".est"
        FILL-IN-8 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".4ta"
        FILL-IN-9 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".t03".
    DISPLAY 
        FILL-IN-Directorio 
        FILL-IN-1 
        FILL-IN-2 
        FILL-IN-3 
        FILL-IN-4 
        FILL-IN-5 
        FILL-IN-6 
        FILL-IN-7 
        FILL-IN-8 
        FILL-IN-9
        WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-mes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-mes W-Win
ON VALUE-CHANGED OF COMBO-BOX-mes IN FRAME F-Main /* Mes */
DO:

    ASSIGN COMBO-BOX-mes COMBO-BOX-Periodo.
    iNroMes = LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS).
    RUN src/bin/_dateif (COMBO-BOX-Periodo, iNroMes, OUTPUT fInicial, OUTPUT fFinal).
    ASSIGN
        FILL-IN-Cese-1 = DAY(fInicial)
        FILL-IN-Cese-2 = DAY(fFinal)
        FILL-IN-FecIng-1 = DAY(fInicial)
        FILL-IN-FecIng-2 = DAY(fFinal).
    DISPLAY 
        FILL-IN-Cese-1
        FILL-IN-Cese-2
        FILL-IN-FecIng-1
        FILL-IN-FecIng-2
        WITH FRAME {&FRAME-NAME}.

/*     FILL-IN-5 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".jor". */
/*     FILL-IN-6 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".rem". */
/*     FILL-IN-7 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".tes". */
/*     FILL-IN-8 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".4ta". */
/*                                                                                          */
/*     DISPLAY FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 WITH FRAME {&FRAME-NAME}.            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Periodo W-Win
ON VALUE-CHANGED OF COMBO-BOX-Periodo IN FRAME F-Main /* Periodo */
DO:
    ASSIGN COMBO-BOX-mes COMBO-BOX-Periodo.
    iNroMes = LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS).
    RUN src/bin/_dateif (COMBO-BOX-Periodo, iNroMes, OUTPUT fInicial, OUTPUT fFinal).
    ASSIGN
        FILL-IN-Cese-1 = DAY(fInicial)
        FILL-IN-Cese-2 = DAY(fFinal)
        FILL-IN-FecIng-1 = DAY(fInicial)
        FILL-IN-FecIng-2 = DAY(fFinal).
    DISPLAY 
        FILL-IN-Cese-1
        FILL-IN-Cese-2
        FILL-IN-FecIng-1
        FILL-IN-FecIng-2
        WITH FRAME {&FRAME-NAME}.


/*     FILL-IN-5 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".jor". */
/*     FILL-IN-6 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".rem". */
/*     FILL-IN-7 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".tes". */
/*     FILL-IN-8 = "M:\" + "0601" + STRING(COMBO-BOX-Periodo,"9999") +                      */
/*         STRING(LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS),"99") + x-RUCCia + ".4ta". */
/*                                                                                          */
/*     DISPLAY FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 WITH FRAME {&FRAME-NAME}.            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-1 W-Win
ON VALUE-CHANGED OF TOGGLE-1 IN FRAME F-Main
DO:
    /*FILL-IN-1:SENSITIVE = INPUT TOGGLE-1.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-2 W-Win
ON VALUE-CHANGED OF TOGGLE-2 IN FRAME F-Main
DO:
    /*FILL-IN-2:SENSITIVE = INPUT TOGGLE-2.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-3 W-Win
ON VALUE-CHANGED OF TOGGLE-3 IN FRAME F-Main
DO:
    /*FILL-IN-3:SENSITIVE = INPUT TOGGLE-3.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-4 W-Win
ON VALUE-CHANGED OF TOGGLE-4 IN FRAME F-Main
DO:
    /*FILL-IN-4:SENSITIVE = INPUT TOGGLE-4.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-5 W-Win
ON VALUE-CHANGED OF TOGGLE-5 IN FRAME F-Main
DO:
    /*FILL-IN-5:SENSITIVE = INPUT TOGGLE-5.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-6 W-Win
ON VALUE-CHANGED OF TOGGLE-6 IN FRAME F-Main
DO:
    /*FILL-IN-6:SENSITIVE = INPUT TOGGLE-6.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-7 W-Win
ON VALUE-CHANGED OF TOGGLE-7 IN FRAME F-Main
DO:
    /*FILL-IN-7:SENSITIVE = INPUT TOGGLE-7.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-8 W-Win
ON VALUE-CHANGED OF TOGGLE-8 IN FRAME F-Main
DO:
    /*FILL-IN-8:SENSITIVE = INPUT TOGGLE-8.
    FILL-IN-9:SENSITIVE = INPUT TOGGLE-8.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-9 W-Win
ON VALUE-CHANGED OF TOGGLE-9 IN FRAME F-Main /* Incluir Personal Periodo Anterior */
DO:
    FILL-IN-8:SENSITIVE = INPUT TOGGLE-8.
    FILL-IN-9:SENSITIVE = INPUT TOGGLE-8.
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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-mes FILL-IN-FecIng-1 FILL-IN-FecIng-2 
          FILL-IN-Cese-1 FILL-IN-Cese-2 FILL-IN-Directorio TOGGLE-1 FILL-IN-1 
          TOGGLE-2 FILL-IN-2 TOGGLE-3 FILL-IN-3 TOGGLE-4 FILL-IN-4 TOGGLE-5 
          FILL-IN-5 TOGGLE-6 FILL-IN-6 TOGGLE-7 FILL-IN-7 TOGGLE-8 FILL-IN-8 
          FILL-IN-9 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo COMBO-BOX-mes FILL-IN-FecIng-1 FILL-IN-FecIng-2 
         FILL-IN-Cese-1 FILL-IN-Cese-2 BUTTON-8 TOGGLE-1 TOGGLE-2 TOGGLE-3 
         TOGGLE-4 TOGGLE-5 TOGGLE-6 TOGGLE-7 TOGGLE-8 BUTTON-2 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTelefono AS CHARACTER FORMAT "X(10)" NO-UNDO.

IF NUM-ENTRIES(PL-PERS.telefo,"/") > 1 THEN cTelefono = ENTRY(1,PL-PERS.telefo,"/").
ELSE cTelefono = PL-PERS.telefo.
cTelefono = REPLACE(cTelefono, '|' , ' ').
IF cTelefono = "" THEN cTelefono = "|".
ELSE cTelefono = "1|" + TRIM(cTelefono).
PUT STREAM strm1 UNFORMATTED
    STRING(PL-PERS.TpoDocId, 'x(2)') "|"
    STRING(PL-PERS.NroDocId, 'x(8)') "|".
IF PL-PERS.TpoDocId = "07"
    THEN PUT STREAM strm1 UNFORMATTED "604|".
    ELSE PUT STREAM strm1 UNFORMATTED "604|".
PUT STREAM strm1 UNFORMATTED
    STRING(PL-PERS.fecnac, '99/99/9999') '|'
    STRING(PL-PERS.patper, 'x(40)') "|"
    STRING(PL-PERS.matper, 'x(40)') "|"
    STRING(PL-PERS.nomper, 'x(40)') "|"
    STRING(PL-PERS.sexper, 'x') "|"
    STRING(PL-PERS.CodNac, 'x(4)') "|"
    /*"1|"*/
    cTelefono "|".
PUT STREAM strm1 UNFORMATTED "|".
PUT STREAM strm1 UNFORMATTED
     STRING(PL-PERS.TipoVia, 'x(2)') "|"
     STRING(PL-PERS.dirper, "x(20)") "|"
     PL-PERS.DirNumero "|"
     "|"
     PL-PERS.DirInterior "|"
     "|"
     "|"
     "|"
     "|"
     "|"
     PL-PERS.TipoZona "|"
     PL-PERS.NomZona "|"
     PL-PERS.DirReferen "|"
     PL-PERS.Ubigeo "|" 
     "||||||||||||||1|"
     SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 W-Win 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    PUT STREAM strm2 UNFORMATTED
        PL-PERS.TpoDocId "|"
        PL-PERS.NroDocId /*FORMAT 'x(15)'*/ "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|").
    PUT STREAM strm2 UNFORMATTED
        "01|"
        PL-FLG-MES.NivEducat "|"
        PL-FLG-MES.Ocupacion "|"
        PL-FLG-MES.Discapaci "|"
        PL-FLG-MES.nroafp "|".
    PUT STREAM strm2 UNFORMATTED
        "|"
        PL-FLG-MES.TpoConTra "|"
        PL-FLG-MES.Jornada[1] "|"
        PL-FLG-MES.Jornada[2] "|"
        PL-FLG-MES.Jornada[3] "|"
        "0|"
        PL-FLG-MES.PeriodIng "|"
        "|"    /* Monto de la remuneración (¿?) Preguntar a RRHH */
        "1|"
        PL-FLG-MES.IndRenta "|"
        PL-FLG-MES.SitEspeci "|"
        PL-FLG-MES.TpoPago "|"
        "0" PL-FLG-MES.Campo-C[2]  "|"
        "0|"
        "|"
        SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 W-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* aquí se generan 4 registros 
preguntar as Carmen Alvarez como es eso */

/* 1ro */
    PUT STREAM strm3 UNFORMATTED
        STRING(PL-PERS.TpoDocId, '99') "|"
        STRING(PL-PERS.NroDocId, 'x(8)') "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|")
        "1|"
        "1|"
        STRING(PL-FLG-MES.FecIng, '99/99/9999') "|".
    IF PL-FLG-MES.VContr = ? 
        THEN PUT STREAM strm3 UNFORMATTED  "|" .
        ELSE PUT STREAM strm3 UNFORMATTED  STRING(PL-FLG-MES.VContr, "99/99/9999") "|".
    PUT STREAM strm3 UNFORMATTED
        PL-FLG-MES.MotivoFin "|"
        "|"
        SKIP.
/* 2do */
    PUT STREAM strm3 UNFORMATTED
        STRING(PL-PERS.TpoDocId, '99') "|"
        STRING(PL-PERS.NroDocId, 'x(8)') "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|")
        "1|"
        "2|"
        STRING(PL-FLG-MES.FecIng, '99/99/9999') "|".
    IF PL-FLG-MES.VContr = ? 
        THEN PUT STREAM strm3 UNFORMATTED  "|" .
        ELSE PUT STREAM strm3 UNFORMATTED  STRING(PL-FLG-MES.VContr, "99/99/9999") "|".
    PUT STREAM strm3 UNFORMATTED
        STRING(INTEGER(PL-FLG-MES.TpoTrabaj), '99') "|"
        "|"
        SKIP.
/* 3ro */
    PUT STREAM strm3 UNFORMATTED
        STRING(PL-PERS.TpoDocId, '99') "|"
        STRING(PL-PERS.NroDocId, 'x(8)') "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|")
        "1|"
        "3|"
        STRING(PL-FLG-MES.FecIng, '99/99/9999') "|".
    IF PL-FLG-MES.VContr = ? 
        THEN PUT STREAM strm3 UNFORMATTED  "|" .
        ELSE PUT STREAM strm3 UNFORMATTED  STRING(PL-FLG-MES.VContr, "99/99/9999") "|".
    PUT STREAM strm3 UNFORMATTED
        STRING(INTEGER(PL-FLG-MES.AfilEPS), '99') "|"
        PL-FLG-MES.CodEPS "|"
        SKIP.
/* 4to */
    PUT STREAM strm3 UNFORMATTED
        STRING(PL-PERS.TpoDocId, '99') "|"
        STRING(PL-PERS.NroDocId, 'x(8)') "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|")
        "1|"
        "4|"
        STRING(PL-FLG-MES.FecIng, '99/99/9999') "|".
    IF PL-FLG-MES.VContr = ? 
        THEN PUT STREAM strm3 UNFORMATTED  "|" .
        ELSE PUT STREAM strm3 UNFORMATTED  STRING(PL-FLG-MES.VContr, "99/99/9999") "|".
    PUT STREAM strm3 UNFORMATTED
        STRING(INTEGER(PL-FLG-MES.RegPensio), '99') "|"
        "|"
        SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-4 W-Win 
PROCEDURE Formato-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Derechohabientes */
FOR EACH PL-DHABIENTE WHERE
    PL-DHABIENTE.CodCia = PL-FLG-MES.CodCia AND
    PL-DHABIENTE.Periodo = PL-FLG-MES.Periodo AND
    PL-DHABIENTE.CodPln = PL-FLG-MES.CodPln AND
    PL-DHABIENTE.NroMes = PL-FLG-MES.NroMes AND
    PL-DHABIENTE.CodPer = PL-FLG-MES.CodPer NO-LOCK:
    /* verificamos la fecha del alta */
    IF NOT ( YEAR(PL-DHABIENTE.FchAlta) = PL-FLG-MES.Periodo
        AND MONTH(PL-DHABIENTE.FchAlta) = PL-FLG-MES.NroMes )
        THEN NEXT.
    PUT STREAM strm4
        PL-PERS.TpoDocId "|"
        PL-PERS.NroDocId "|"
        PL-DHABIENTE.TpoDocId "|"
        PL-DHABIENTE.NroDocId "|"
        "|"
        PL-DHABIENTE.FecNac FORMAT "99/99/9999" "|"
        PL-DHABIENTE.PatPer "|"
        PL-DHABIENTE.MatPer "|"
        PL-DHABIENTE.NomPer "|"
        PL-DHABIENTE.Sexo "|"
        PL-DHABIENTE.VinculoFam "|"
        PL-DHABIENTE.TpoDocPat "|"
        PL-DHABIENTE.NroDocPat "|"
        "|"
        PL-DHABIENTE.TpoVia "|"
        PL-DHABIENTE.NomVia "|"
        PL-DHABIENTE.NroVia "|"
        "|"
        PL-DHABIENTE.IntVia "|"
        "|"
        "|"
        "|"
        "|"
        "|"
        PL-DHABIENTE.TpoZona "|"
        PL-DHABIENTE.NomZona "|"
        PL-DHABIENTE.DirReferen "|"
        PL-DHABIENTE.Ubigeo "|"
        "||||||||||||||"
        "1|"
        "|"
        "|"
        /*
        PL-DHABIENTE.TpoBaja "|"
        PL-DHABIENTE.FchBaja FORMAT "99/99/9999" "|"
        PL-DHABIENTE.NroRelDir "|"
        PL-DHABIENTE.IndDomici "|"
        */
        SKIP.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-5 W-Win 
PROCEDURE Formato-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Derechohabientes */
FOR EACH PL-DHABIENTE WHERE
    PL-DHABIENTE.CodCia = PL-FLG-MES.CodCia AND
    PL-DHABIENTE.Periodo = PL-FLG-MES.Periodo AND
    PL-DHABIENTE.CodPln = PL-FLG-MES.CodPln AND
    PL-DHABIENTE.NroMes = PL-FLG-MES.NroMes AND
    PL-DHABIENTE.CodPer = PL-FLG-MES.CodPer NO-LOCK:
    /* verificamos la fecha del alta */
    IF NOT ( YEAR(PL-DHABIENTE.FchBaja) = PL-FLG-MES.Periodo
        AND MONTH(PL-DHABIENTE.FchBaja) = PL-FLG-MES.NroMes )
        THEN NEXT.
    PUT STREAM strm5
        PL-PERS.TpoDocId "|"
        PL-PERS.NroDocId "|"
        PL-DHABIENTE.TpoDocId "|"
        PL-DHABIENTE.NroDocId "|"
        "|"
        PL-DHABIENTE.FecNac FORMAT "99/99/9999" "|"
        PL-DHABIENTE.PatPer "|"
        PL-DHABIENTE.MatPer "|"
        PL-DHABIENTE.NomPer "|"
        PL-DHABIENTE.VinculoFam "|"
        PL-DHABIENTE.FchBaja FORMAT "99/99/9999" "|"
        PL-DHABIENTE.TpoBaja
        SKIP.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-6 W-Win 
PROCEDURE Formato-6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cTelefono AS CHARACTER FORMAT "X(10)" NO-UNDO.

IF NUM-ENTRIES(PL-PERS.telefo,"/") > 1 THEN cTelefono = ENTRY(1,PL-PERS.telefo,"/").
ELSE cTelefono = PL-PERS.telefo.
cTelefono = REPLACE(cTelefono, '|' , ' ').
PUT STREAM strm6
    PL-PERS.TpoDocId FORMAT 'x(2)' "|"
    PL-PERS.NroDocId /*FORMAT 'x(15)'*/ "|".
IF PL-PERS.TpoDocId = "07"
    THEN PUT STREAM strm6 "604|".
    ELSE PUT STREAM strm6 "|".
PUT STREAM strm6
    "01|"
    "2|"
    PL-FLG-MES.NivEducat "|"
    PL-FLG-MES.Ocupacion "|"
    "0|"
    PL-FLG-MES.Discapaci "|"
    "4|"
    PL-FLG-MES.Jornada[3]
    SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-7 W-Win 
PROCEDURE Formato-7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cSeccion AS CHARACTER FORMAT "X(4)" NO-UNDO.

    cSeccion = "0000".
    FIND pl-secc OF pl-flg-mes NO-LOCK NO-ERROR.
    IF AVAILABLE pl-secc THEN DO:
        cSeccion = pl-secc.codant.
        IF NUM-ENTRIES(pl-secc.codant,"-") > 1 THEN cSeccion = TRIM(ENTRY(1, pl-secc.CodAnt,"-")).
    END.
    PUT STREAM strm7 UNFORMATTED 
        PL-PERS.TpoDocId "|"
        PL-PERS.NroDocId /*FORMAT 'X(15)'*/ "|"
        (IF PL-PERS.TpoDocId = "07" THEN "604|" ELSE "604|")
        x-RUCCia FORMAT 'X(11)' "|"
        cSeccion FORMAT 'X(4)' '|'
        SKIP.

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
        RUN src/bin/_dateif (s-NroMes, s-Periodo, OUTPUT fInicial, OUTPUT fFinal).
        ASSIGN
            FILL-IN-Cese-1 = DAY(fInicial)
            FILL-IN-Cese-2 = DAY(fFinal)
            FILL-IN-FecIng-1 = DAY(fInicial)
            FILL-IN-FecIng-2 = DAY(fFinal).

        FIND gn-cias WHERE
            gn-cias.codcia = s-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE gn-cias THEN x-RUCCia = GN-CIAS.LIBRE-C[1].
        ELSE x-RUCCia = "FALTARUC".
        FILL-IN-1 = "RP_" + x-RUCCia + ".ide".
        FILL-IN-2 = "RP_" + x-RUCCia + ".tra".
        FILL-IN-3 = "RP_" + x-RUCCia + ".per".
        FILL-IN-4 = "RD_" + x-RUCCia + 
            STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
            "_ALTA.txt".
        FILL-IN-5 = "RD_" + x-RUCCia + 
            STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
            "_BAJA.txt".
        FILL-IN-6 = "RP_" + x-RUCCia + ".pfl".
        FILL-IN-7 = "RP_" + x-RUCCia + ".est".
        FILL-IN-8 = "RP_" + x-RUCCia + ".4ta".
        FILL-IN-9 =  x-RUCCia + ".t03".
        ASSIGN
            FILL-IN-1 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".ide"
            FILL-IN-2 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".tra"
            FILL-IN-3 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".per"
            FILL-IN-4 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia +
            STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
            "_ALTA" + ".txt"
            FILL-IN-5 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + 
            STRING(DAY(TODAY),'99') + STRING(MONTH(TODAY),'99') + STRING(YEAR(TODAY),'9999') +
            "_BAJA" + ".txt"
            FILL-IN-6 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".pfl"
            FILL-IN-7 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".est"
            FILL-IN-8 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".4ta"
            FILL-IN-9 = TRIM(FILL-IN-Directorio) + "\" + "RP_" + x-RUCCia + ".t03".
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
DEFINE VARIABLE fFchIng-1 AS DATE NO-UNDO.
DEFINE VARIABLE fFchIng-2 AS DATE NO-UNDO.
DEFINE VARIABLE fVContr-1 AS DATE NO-UNDO.
DEFINE VARIABLE fVContr-2 AS DATE NO-UNDO.

DEFINE BUFFER b_FLG-MES FOR PL-FLG-MES.

DEFINE VARIABLE dDias AS DECIMAL NO-UNDO.
DEFINE VARIABLE dHoras AS DECIMAL NO-UNDO.
DEFINE VARIABLE dMinutos AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    iNroMes = LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS).
END.

IF TOGGLE-1 THEN OUTPUT STREAM strm1 TO VALUE(FILL-IN-1).
IF TOGGLE-2 THEN OUTPUT STREAM strm2 TO VALUE(FILL-IN-2).
IF TOGGLE-3 THEN OUTPUT STREAM strm3 TO VALUE(FILL-IN-3).
IF TOGGLE-4 THEN OUTPUT STREAM strm4 TO VALUE(FILL-IN-4).
IF TOGGLE-5 THEN OUTPUT STREAM strm5 TO VALUE(FILL-IN-5).
IF TOGGLE-6 THEN OUTPUT STREAM strm6 TO VALUE(FILL-IN-6).
IF TOGGLE-7 THEN OUTPUT STREAM strm7 TO VALUE(FILL-IN-7).

ASSIGN
    fFchIng-1 = DATE(iNroMes, FILL-IN-FecIng-1, COMBO-BOX-Periodo)
    fFchIng-2 = DATE(iNroMes, FILL-IN-FecIng-2, COMBO-BOX-Periodo)
    fVContr-1 = DATE(iNroMes, FILL-IN-Cese-1, COMBO-BOX-Periodo)
    fVContr-2 = DATE(iNroMes, FILL-IN-Cese-2, COMBO-BOX-Periodo).

EMPTY TEMP-TABLE wrk_pdt.

/* Personal del Periodo Anterior */
/* IF (TOGGLE-1 OR TOGGLE-2) AND TOGGLE-9 THEN FOR EACH pl-pers NO-LOCK: */
/*     /* Verifica Movimiento en Periodo Anterior */                     */
/*     FIND LAST PL-FLG-MES WHERE                                        */
/*         PL-FLG-MES.CodCia = s-codcia AND                              */
/*         PL-FLG-MES.Periodo = COMBO-BOX-Periodo - 1 AND                */
/*         PL-FLG-MES.codpln = s-CodPln AND                              */
/*         PL-FLG-MES.nromes >= 1 AND                                    */
/*         PL-FLG-MES.codper = PL-PERS.codper                            */
/*         NO-LOCK NO-ERROR.                                             */
/*     IF NOT AVAILABLE PL-FLG-MES THEN NEXT.                            */
/*     /* Verifica Movimiento en Periodo Actual */                       */
/*     FIND b_FLG-MES WHERE                                              */
/*         b_FLG-MES.CodCia = s-codcia AND                               */
/*         b_FLG-MES.Periodo = COMBO-BOX-Periodo AND                     */
/*         b_FLG-MES.codpln = s-CodPln AND                               */
/*         b_FLG-MES.nromes = iNroMes AND                                */
/*         b_FLG-MES.codper = PL-PERS.codper                             */
/*         NO-LOCK NO-ERROR.                                             */
/*     IF AVAILABLE b_FLG-MES THEN NEXT.                                 */
/*     Fi-Mensaje = "  Procesando : " + PL-PERS.codper.                  */
/*     DISPLAY Fi-Mensaje WITH FRAME F-Proceso.                          */
/*     IF TOGGLE-1 THEN DO:                                              */
/*         RUN Formato-1.                                                */
/*     END.                                                              */
/*     IF TOGGLE-2 THEN DO:                                              */
/*         RUN Formato-2.                                                */
/*     END.                                                              */
/* END.                                                                  */

FOR EACH PL-FLG-MES WHERE PL-FLG-MES.CodCia = s-codcia 
    AND PL-FLG-MES.Periodo = COMBO-BOX-Periodo 
    AND PL-FLG-MES.codpln = s-CodPln 
    AND PL-FLG-MES.NROMES = iNroMes 
    AND ( ( PL-FLG-MES.FecIng >= fFchIng-1 AND PL-FLG-MES.FecIng <= fFchIng-2 ) 
          OR ( PL-FLG-MES.VContr >= fVContr-1 AND PL-FLG-MES.VContr <= fVContr-2 ) )
    NO-LOCK,
    FIRST PL-PERS WHERE PL-PERS.codper = PL-FLG-MES.codper NO-LOCK:
    Fi-Mensaje = "  Procesando : " + PL-PERS.codper.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    IF TOGGLE-1 THEN DO:
        RUN Formato-1.
    END.
    IF TOGGLE-2 THEN DO:
        RUN Formato-2.
    END.
    IF TOGGLE-3 THEN DO:
        RUN Formato-3.
    END.
    IF TOGGLE-4 THEN DO:
        RUN Formato-4.
    END.
    IF TOGGLE-5 THEN DO:
        RUN Formato-5.
    END.
    IF TOGGLE-6 THEN DO:
        RUN Formato-6.
    END.
    IF TOGGLE-7 THEN DO:
        RUN Formato-7.
    END.
END.    /* FOR EACH PL-FLG-MES... */

RUN proc_output-files-EMP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Create-files-OBR W-Win 
PROCEDURE proc_Create-files-OBR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iNroMes LIKE PL-FLG-MES.NroMes NO-UNDO.
DEFINE VARIABLE iNroSem1 LIKE PL-FLG-SEM.NroSem NO-UNDO.
DEFINE VARIABLE iNroSem2 LIKE PL-FLG-SEM.NroSem NO-UNDO.
DEFINE VARIABLE cTelefono AS CHARACTER FORMAT "X(10)" NO-UNDO.
DEFINE VARIABLE cSeccion AS CHARACTER FORMAT "X(4)" NO-UNDO.
DEFINE VARIABLE dDiasTrabajados LIKE PL-MOV-SEM.ValCal-Sem NO-UNDO.
DEFINE VARIABLE iDiaMes AS INTEGER NO-UNDO.

DEFINE BUFFER b_FLG-SEM FOR PL-FLG-SEM.

DEFINE VARIABLE dDias AS DECIMAL NO-UNDO.
DEFINE VARIABLE dHoras AS DECIMAL NO-UNDO.
DEFINE VARIABLE dMinutos AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    iNroMes = LOOKUP(COMBO-BOX-Mes,COMBO-BOX-Mes:LIST-ITEMS).
END.

FOR EACH PL-SEM WHERE
    PL-SEM.CodCia = s-CodCia AND
    PL-SEM.Periodo = s-Periodo AND
    PL-SEM.NroMes = iNroMes NO-LOCK:
    IF iNroSem1 = 0 THEN iNroSem1 = PL-SEM.NroSem.
    iNroSem2 = PL-SEM.NroSem.
END.

IF TOGGLE-1 THEN OUTPUT STREAM strm1 TO VALUE(FILL-IN-1) APPEND.
IF TOGGLE-2 THEN OUTPUT STREAM strm2 TO VALUE(FILL-IN-2) APPEND.
IF TOGGLE-3 THEN OUTPUT STREAM strm3 TO VALUE(FILL-IN-3) APPEND.
IF TOGGLE-4 THEN OUTPUT STREAM strm4 TO VALUE(FILL-IN-4) APPEND.
IF TOGGLE-7 THEN OUTPUT STREAM strm7 TO VALUE(FILL-IN-7) APPEND.

FOR EACH wrko_obr: DELETE wrko_obr. END.

/* Personal del Periodo Anterior */
IF (TOGGLE-1 OR TOGGLE-2) AND TOGGLE-9 THEN FOR EACH pl-pers NO-LOCK:

    /* Verifica Movimiento en Periodo Anterior */
    FIND LAST PL-FLG-SEM WHERE
        PL-FLG-SEM.CodCia = s-codcia AND
        PL-FLG-SEM.Periodo = COMBO-BOX-Periodo - 1 AND
        PL-FLG-SEM.codpln = 2 AND
        PL-FLG-SEM.NroSem >= 1 AND
        PL-FLG-SEM.codper = PL-PERS.codper
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-FLG-SEM THEN NEXT.
    /* Verifica Movimiento en Periodo Actual */
    FIND LAST b_FLG-SEM WHERE
        b_FLG-SEM.CodCia = s-codcia AND
        b_FLG-SEM.Periodo = COMBO-BOX-Periodo AND
        b_FLG-SEM.codpln = PL-FLG-SEM.codpln AND
        b_FLG-SEM.NroSem >= 1 AND
        b_FLG-SEM.codper = PL-PERS.codper
        NO-LOCK NO-ERROR.
    IF AVAILABLE b_FLG-SEM THEN NEXT.

    Fi-Mensaje = "  Procesando : " + PL-PERS.codper.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.

    IF TOGGLE-1 THEN DO:
        IF NUM-ENTRIES(PL-PERS.telefo,"/") > 1 THEN
            cTelefono = ENTRY(1,PL-PERS.telefo,"/").
        ELSE cTelefono = PL-PERS.telefo.
        PUT STREAM strm1
            PL-PERS.TpoDocId "|"
            PL-PERS.NroDocId "|"
            PL-PERS.patper "|"
            PL-PERS.matper "|"
            PL-PERS.nomper "|"
            PL-PERS.fecnac FORMAT "99/99/9999" "|"
            PL-PERS.sexper "|"
            PL-PERS.CodNac "|"
            cTelefono "|"
            PL-PERS.E-Mail "|"
            PL-PERS.Essalud "|"
            PL-PERS.Domici "|".
        IF PL-PERS.TpoDocId <> "01" THEN
            PUT STREAM strm1
                PL-PERS.TipoVia "|"
                PL-PERS.dirper FORMAT "X(20)" "|"
                PL-PERS.DirNumero "|"
                PL-PERS.DirInterior "|"
                PL-PERS.TipoZona "|"
                PL-PERS.NomZona "|"
                PL-PERS.DirReferen "|"
                PL-PERS.Ubigeo "|"
                SKIP.
        ELSE PUT STREAM strm1 "||||||||" SKIP.
    END.
    IF TOGGLE-2 THEN DO:
        PUT STREAM strm2
            PL-PERS.TpoDocId "|"
            PL-PERS.NroDocId "|"
            PL-FLG-SEM.TpoTrabaj "|"
            PL-FLG-SEM.RegLabora "|"
            PL-FLG-SEM.NivEducat "|"
            PL-FLG-SEM.Ocupacion "|"
            PL-FLG-SEM.Discapaci "|"
            PL-FLG-SEM.RegPensio "|"
            PL-FLG-SEM.FchInsRgp FORMAT "99/99/9999" "|"
            PL-FLG-SEM.nroafp "|"
            "0|0|"
            PL-FLG-SEM.TpoConTra "|"
            PL-FLG-SEM.Jornada[1] "|"
            PL-FLG-SEM.Jornada[2] "|"
            PL-FLG-SEM.Jornada[3] "|"
            PL-FLG-SEM.QtaCatego "|"
            "0|"
            PL-FLG-SEM.PeriodIng "|"
            PL-FLG-SEM.AfilEPS "|"
            PL-FLG-SEM.CodEPS "|"
            "19|"
            PL-FLG-SEM.IndRenta "|"
            PL-FLG-SEM.SitEspeci "|"
            PL-FLG-SEM.TpoPago "|"
            PL-FLG-SEM.Campo-C[1] FORMAT "x" "|"
            PL-FLG-SEM.Campo-C[2] FORMAT "xx" "|"
            PL-FLG-SEM.Campo-C[3] FORMAT "x" "|"
            SKIP.
    END.
END.

FOR EACH PL-FLG-SEM WHERE
    PL-FLG-SEM.CodCia = s-codcia AND
    PL-FLG-SEM.Periodo = COMBO-BOX-Periodo AND
    PL-FLG-SEM.codpln = 2 AND
    PL-FLG-SEM.NroSem >= iNroSem1 AND
    PL-FLG-SEM.NroSem <= iNroSem2 NO-LOCK,
    FIRST PL-PERS WHERE PL-PERS.codper = PL-FLG-SEM.codper NO-LOCK:
    Fi-Mensaje = "  Procesando : " + PL-PERS.codper.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    /* Verifica Obrero Creado */
    FIND FIRST wrko_obr WHERE
        wrko_obr.wrko_codper = PL-FLG-SEM.codper
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wrko_obr THEN DO:
        CREATE wrko_obr.
        ASSIGN wrko_obr.wrko_codper = PL-FLG-SEM.codper.
        IF TOGGLE-1 THEN DO:
            IF NUM-ENTRIES(PL-PERS.telefo,"/") > 1 THEN
                cTelefono = ENTRY(1,PL-PERS.telefo,"/").
            ELSE cTelefono = PL-PERS.telefo.
            PUT STREAM strm1
                PL-PERS.TpoDocId "|"
                PL-PERS.NroDocId "|"
                PL-PERS.patper "|"
                PL-PERS.matper "|"
                PL-PERS.nomper "|"
                PL-PERS.fecnac FORMAT "99/99/9999" "|"
                PL-PERS.sexper "|"
                PL-PERS.CodNac "|"
                cTelefono "|"
                PL-PERS.E-Mail "|"
                PL-PERS.Essalud "|"
                PL-PERS.Domici "|".
            IF PL-PERS.TpoDocId <> "01" THEN
                PUT STREAM strm1
                    PL-PERS.TipoVia "|"
                    PL-PERS.dirper FORMAT "X(20)" "|"
                    PL-PERS.DirNumero "|"
                    PL-PERS.DirInterior "|"
                    PL-PERS.TipoZona "|"
                    PL-PERS.NomZona "|"
                    PL-PERS.DirReferen "|"
                    PL-PERS.Ubigeo "|"
                    SKIP.
            ELSE PUT STREAM strm1 "||||||||" SKIP.
        END.
        IF TOGGLE-2 THEN DO:
            PUT STREAM strm2
                PL-PERS.TpoDocId "|"
                PL-PERS.NroDocId "|"
                PL-FLG-SEM.TpoTrabaj "|"
                PL-FLG-SEM.RegLabora "|"
                PL-FLG-SEM.NivEducat "|"
                PL-FLG-SEM.Ocupacion "|"
                PL-FLG-SEM.Discapaci "|"
                PL-FLG-SEM.RegPensio "|"
                PL-FLG-SEM.FchInsRgp FORMAT "99/99/9999" "|"
                PL-FLG-SEM.nroafp "|"
                "0|0|"
                PL-FLG-SEM.TpoConTra "|"
                PL-FLG-SEM.Jornada[1] "|"
                PL-FLG-SEM.Jornada[2] "|"
                PL-FLG-SEM.Jornada[3] "|"
                PL-FLG-SEM.QtaCatego "|"
                "0|"
                PL-FLG-SEM.PeriodIng "|"
                PL-FLG-SEM.AfilEPS "|"
                PL-FLG-SEM.CodEPS "|"
                PL-FLG-SEM.Situacion "|"
                PL-FLG-SEM.IndRenta "|"
                PL-FLG-SEM.SitEspeci "|"
                PL-FLG-SEM.TpoPago "|"
                PL-FLG-SEM.Campo-C[1] FORMAT "x" "|"
                PL-FLG-SEM.Campo-C[2] FORMAT "xx" "|"
                PL-FLG-SEM.Campo-C[3] FORMAT "x" "|"
                SKIP.
        END.
        IF TOGGLE-3 THEN DO:
            PUT STREAM strm3
                PL-PERS.TpoDocId "|"
                PL-PERS.NroDocId "|"
                PL-FLG-SEM.Categoria "|"
                PL-FLG-SEM.FecIng FORMAT "99/99/9999" "|"
                PL-FLG-SEM.Vcontr FORMAT "99/99/9999" "|"
                PL-FLG-SEM.MotivoFin "|"
                PL-FLG-SEM.ModFormat "|"
                SKIP.
        END.
        IF TOGGLE-4 THEN
            /* Derechohabientes */
            FOR EACH PL-DHABIENTE WHERE
                PL-DHABIENTE.CodCia = PL-FLG-SEM.CodCia AND
                PL-DHABIENTE.Periodo = PL-FLG-SEM.Periodo AND
                PL-DHABIENTE.CodPln = PL-FLG-SEM.CodPln AND
                PL-DHABIENTE.NroMes = iNroMes AND
                PL-DHABIENTE.CodPer = PL-FLG-SEM.CodPer NO-LOCK:
                PUT STREAM strm4
                    PL-PERS.TpoDocId "|"
                    PL-PERS.NroDocId "|"
                    PL-DHABIENTE.TpoDocId "|"
                    PL-DHABIENTE.NroDocId "|"
                    PL-DHABIENTE.PatPer "|"
                    PL-DHABIENTE.MatPer "|"
                    PL-DHABIENTE.NomPer "|"
                    PL-DHABIENTE.FecNac FORMAT "99/99/9999" "|"
                    PL-DHABIENTE.Sexo "|"
                    PL-DHABIENTE.VinculoFam "|"
                    PL-DHABIENTE.TpoDocPat "|"
                    PL-DHABIENTE.NroDocPat "|"
                    PL-DHABIENTE.SitDerHab "|"
                    PL-DHABIENTE.FchAlta FORMAT "99/99/9999" "|"
                    PL-DHABIENTE.TpoBaja "|"
                    PL-DHABIENTE.FchBaja FORMAT "99/99/9999" "|"
                    PL-DHABIENTE.NroRelDir "|"
                    PL-DHABIENTE.IndDomici "|"
                    PL-DHABIENTE.TpoVia "|"
                    PL-DHABIENTE.NomVia "|"
                    PL-DHABIENTE.NroVia "|"
                    PL-DHABIENTE.IntVia "|"
                    PL-DHABIENTE.TpoZona "|"
                    PL-DHABIENTE.NomZona "|"
                    PL-DHABIENTE.DirReferen "|"
                    PL-DHABIENTE.Ubigeo "|"
                    SKIP.
            END.
    
        IF TOGGLE-5 THEN DO:    /* Jornada Laboral */
            dDiasTrabajados = 0.
            FOR EACH PL-MOV-SEM WHERE
                PL-MOV-SEM.CodCia = PL-FLG-SEM.CodCia AND
                PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
                PL-MOV-SEM.NroSem >= iNroSem1 AND
                PL-MOV-SEM.NroSem <= iNroSem2 AND
                PL-MOV-SEM.CodPln = PL-FLG-SEM.CodPln AND
                PL-MOV-SEM.CodCal = 1 AND
                PL-MOV-SEM.CodPer = PL-FLG-SEM.CodPer AND
                PL-MOV-SEM.CodMov = 100 NO-LOCK:
                dDiasTrabajados = dDiasTrabajados + PL-MOV-SEM.ValCal-Sem.
            END.
            IF dDiasTrabajados = 0 THEN DO:
                CREATE wrk_pdt.
                ASSIGN
                    wrk_tabla = "jor"
                    wrk_TpoDocId = PL-PERS.TpoDocId
                    wrk_NroDocId = PL-PERS.NroDocId.
                dHoras = dDias * 8.
                dMinutos = dHoras - TRUNCATE(dHoras,0).
                dHoras = dHoras - dMinutos.
                dMinutos = dMinutos * 60.
                wrk_int[1] = dHoras.
                wrk_int[2] = dMinutos.
            END.
            dHoras = 0.
            FOR EACH PL-MOV-SEM WHERE
                PL-MOV-SEM.CodCia = PL-FLG-SEM.CodCia AND
                PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
                PL-MOV-SEM.NroSem >= iNroSem1 AND
                PL-MOV-SEM.NroSem <= iNroSem2 AND
                PL-MOV-SEM.CodPln = PL-FLG-SEM.CodPln AND
                PL-MOV-SEM.CodCal = 0 AND
                PL-MOV-SEM.CodPer = PL-FLG-SEM.CodPer AND
                LOOKUP(STRING(PL-MOV-SEM.CodMov),"125,126,127") > 0 NO-LOCK:
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
                dHoras = dHoras + PL-MOV-SEM.ValCal-Sem.
            END.
            IF dHoras > 0 THEN DO:
                dMinutos = dHoras - TRUNCATE(dHoras,0).
                dHoras = dHoras - dMinutos.
                dMinutos = dMinutos * 60.
                wrk_int[3] = dHoras.
                wrk_int[4] = dMinutos.
            END.
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
                PL-BOLE.CodPln = PL-FLG-SEM.CodPln AND
                PL-BOLE.CodCal >= 1 AND
                PL-BOLE.CodCal <> 2 AND
                PL-BOLE.TpoBol <> "Otros",
                EACH PL-MOV-SEM WHERE
                PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia AND
                PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo AND
                PL-MOV-SEM.NroSem  >= iNroSem1 AND
                PL-MOV-SEM.NroSem  <= iNroSem2 AND
                PL-MOV-SEM.CodPln  = PL-FLG-SEM.CodPln AND
                PL-MOV-SEM.CodCal  = PL-BOLE.codcal AND
                PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
                PL-MOV-SEM.CodMov  = PL-BOLE.CodMov NO-LOCK:
                FIND FIRST PL-TABLA WHERE
                    PL-TABLA.CodCia = 0 AND
                    PL-TABLA.Tabla = "22" AND
                    PL-TABLA.Digito = PL-MOV-SEM.CodMov
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
                wrk_dec[1] = wrk_dec[1] + PL-MOV-SEM.ValCal-Sem.
                wrk_dec[2] = wrk_dec[2] + PL-MOV-SEM.ValCal-Sem.
            END.
        END.
    
        IF TOGGLE-7 THEN DO:
            IF NUM-ENTRIES(PL-FLG-SEM.Seccion,"-") > 1 THEN
                cSeccion = TRIM(ENTRY(1,PL-FLG-SEM.Seccion,"-")).
            ELSE cSeccion = "0000".
            PUT STREAM strm7
                PL-PERS.TpoDocId "|"
                PL-PERS.NroDocId "|"
                x-RUCCia "|"
                cSeccion "||"
                SKIP.
        END.
    END.
END.    /* FOR EACH PL-FLG-SEM... */

IF TOGGLE-1 THEN OUTPUT STREAM strm1 CLOSE.
IF TOGGLE-2 THEN OUTPUT STREAM strm2 CLOSE.
IF TOGGLE-3 THEN OUTPUT STREAM strm3 CLOSE.
IF TOGGLE-4 THEN OUTPUT STREAM strm4 CLOSE.
IF TOGGLE-7 THEN OUTPUT STREAM strm7 CLOSE.

IF TOGGLE-5 THEN DO:
    OUTPUT STREAM strm1 TO VALUE(FILL-IN-5) APPEND.
    FOR EACH wrk_pdt WHERE wrk_tabla = "jor" NO-LOCK:
        PUT STREAM strm1
            wrk_TpoDocId "|"
            wrk_NroDocId "|".
        PUT STREAM strm1 UNFORMATTED
            wrk_int[1] "|"
            wrk_int[2] "|"
            wrk_int[3] "|"
            wrk_int[4] "|"
            SKIP.
    END.
    OUTPUT STREAM strm1 CLOSE.
END.

IF TOGGLE-6 THEN DO:
    OUTPUT STREAM strm1 TO VALUE(FILL-IN-6) APPEND.
    FOR EACH wrk_pdt WHERE wrk_tabla = "rem" NO-LOCK:
        PUT STREAM strm1
            wrk_TpoDocId "|"
            wrk_NroDocId "|"
            wrk_int[1] FORMAT "9999" "|".
        PUT STREAM strm1 UNFORMATTED
            wrk_dec[1] "|"
            wrk_dec[2] "|"
            SKIP.
    END.
    OUTPUT STREAM strm1 CLOSE.
END.

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

/* IF TOGGLE-3 THEN DO:                                    */
/*     FOR EACH wrk_pdt NO-LOCK WHERE wrk_tabla = 'datos': */
/*         PUT STREAM strm3                                */
/*             wrk_TpoDocId "|"                            */
/*             wrk_NroDocId "|".                           */
/*         PUT STREAM strm3 UNFORMATTED                    */
/*             wrk_Char[1] "|".                            */
/*         PUT STREAM strm3                                */
/*             wrk_Date[1] FORMAT "99/99/9999" "|"         */
/*             wrk_Date[2] FORMAT "99/99/9999" "|".        */
/*         PUT STREAM strm3 UNFORMATTED                    */
/*             wrk_Char[2] "|"                             */
/*             wrk_Char[3] "|"                             */
/*             SKIP.                                       */
/*     END.                                                */
/* END.                                                    */

IF TOGGLE-1 THEN OUTPUT STREAM strm1 CLOSE.
IF TOGGLE-2 THEN OUTPUT STREAM strm2 CLOSE.
IF TOGGLE-3 THEN OUTPUT STREAM strm3 CLOSE.
IF TOGGLE-4 THEN OUTPUT STREAM strm4 CLOSE.
IF TOGGLE-7 THEN OUTPUT STREAM strm7 CLOSE.

/* IF TOGGLE-5 THEN DO:                                  */
/*     OUTPUT STREAM strm1 TO VALUE(FILL-IN-5).          */
/*     FOR EACH wrk_pdt WHERE wrk_tabla = "jor" NO-LOCK: */
/*         PUT STREAM strm1                              */
/*             wrk_TpoDocId "|"                          */
/*             wrk_NroDocId "|".                         */
/*         PUT STREAM strm1 UNFORMATTED                  */
/*             wrk_int[1] "|"                            */
/*             wrk_int[2] "|"                            */
/*             wrk_int[3] "|"                            */
/*               k_int[4] "|"                            */
/*             SKIP.                                     */
/*     END.                                              */
/*     OUTPUT STREAM strm1 CLOSE.                        */
/* END.                                                  */

/* IF TOGGLE-6 THEN DO:                                  */
/*     OUTPUT STREAM strm1 TO VALUE(FILL-IN-6).          */
/*     FOR EACH wrk_pdt WHERE wrk_tabla = "rem" NO-LOCK: */
/*         PUT STREAM strm1                              */
/*             wrk_TpoDocId "|"                          */
/*             wrk_NroDocId "|"                          */
/*             wrk_int[1] FORMAT "9999" "|".             */
/*         PUT STREAM strm1 UNFORMATTED                  */
/*             wrk_dec[1] "|"                            */
/*             wrk_dec[2] "|"                            */
/*             SKIP.                                     */
/*     END.                                              */
/*     OUTPUT STREAM strm1 CLOSE.                        */
/* END.                                                  */

/* 4ta Categoría */
IF TOGGLE-8 THEN DO:
    FOR EACH cb-cmov NO-LOCK WHERE
        cb-cmov.CodCia = s-CodCia AND
        cb-cmov.Periodo = COMBO-BOX-Periodo AND
        cb-cmov.NroMes = iNroMes AND
        LOOKUP(cb-cmov.CodOpe,"002,058,092,076") > 0 AND
        cb-cmov.NroAst >= "",
        EACH cb-dmov NO-LOCK WHERE
            cb-dmov.CodCia = cb-cmov.CodCia AND
            cb-dmov.Periodo = cb-cmov.Periodo AND
            cb-dmov.NroMes = cb-cmov.NroMes AND
            cb-dmov.CodOpe = cb-cmov.CodOpe AND
            cb-dmov.NroAst = cb-cmov.NroAst AND
            cb-dmov.CodDoc = "02" AND
            (cb-dmov.CodCta = "42411110" OR
            cb-dmov.CodCta = "42411120"):
        IF cb-dmov.NroRuc = "" THEN NEXT.
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.Ruc = cb-dmov.NroRuc NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-prov THEN NEXT.
        Fi-Mensaje = "  Procesando 4Ta : " + gn-prov.codpro.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        CREATE wrk_pdt.
        ASSIGN
            wrk_tabla = "4ta"
            wrk_TpoDocId = "06"
            wrk_NroDocId = gn-prov.Ruc
            wrk_char[1] = "R"
            wrk_char[2] = STRING(INTEGER(ENTRY(1,cb-dmov.NroDoc,"-")),"9999")
            wrk_char[3] = string(INTEGER(ENTRY(2,cb-dmov.NroDoc,"-")),">>>>>>>9")
/*MLR-2*    wrk_dec[1] = cb-dmov.ImpMn1 */
/*MLR-2*/   wrk_dec[1] = IF cb-cmov.codmon = 1 THEN cb-dmov.ImpMn1 ELSE ROUND((cb-dmov.ImpMn2 * cb-cmov.TpoCmb),2)
            wrk_date[1] = cb-dmov.FchDoc
            wrk_date[2] = cb-cmov.FchAst
            /* Datos del proveedor */
            wrk_char[5] = gn-prov.ApePat
            wrk_char[6] = gn-prov.ApeMat
            wrk_char[7] = gn-prov.Nombre.
        IF cb-dmov.ImpMn1 > 1500 THEN wrk_char[4] = "1".
        ELSE wrk_char[4] = "0".
    END.
    IF CAN-FIND (FIRST wrk_pdt WHERE wrk_tabla = "4ta") THEN DO:

        IF NOT TOGGLE-1 THEN OUTPUT STREAM strm1 TO VALUE(FILL-IN-1).
        ELSE OUTPUT STREAM strm1 TO VALUE(FILL-IN-1) APPEND.
        OUTPUT STREAM strm2 TO VALUE(FILL-IN-8).
        OUTPUT STREAM strm3 TO VALUE(FILL-IN-9).

        FOR EACH wrk_pdt WHERE wrk_tabla = "4ta" NO-LOCK
            BREAK BY wrk_tabla BY wrk_TpoDocId BY wrk_NroDocId:
            IF FIRST-OF(wrk_NroDocId) THEN DO:
                x_NroDocId = wrk_NroDocId.
                PUT STREAM strm1
                    wrk_TpoDocId "|"
                    wrk_NroDocId "|"
                    wrk_char[5] FORMAT "X(40)" "|"
                    wrk_char[6] FORMAT "X(40)" "|"
                    wrk_char[7] FORMAT "X(40)" "|"
                    "|1|9589||||1|||||||||"
                    SKIP.
                PUT STREAM strm3
                    wrk_TpoDocId "|"
                    /*wrk_char[2] wrk_char[3] "|"*/
                    x_NroDocId   FORMAT "X(15)" "|"
                    wrk_NroDocId FORMAT "X(11)" "|"
/*MLR-2*/           "0|"
                    SKIP.
            END.
            PUT STREAM strm2 UNFORMATTED
                wrk_TpoDocId "|"
                wrk_NroDocId "|"
                wrk_char[1] "|"
                wrk_char[2] "|"
                TRIM(wrk_char[3]) "|"
                wrk_dec[1] "|".
            PUT STREAM strm2
                wrk_date[1] FORMAT "99/99/9999" "|"
                wrk_date[2] FORMAT "99/99/9999" "|"
                wrk_char[4] FORMAT "X" "|"
                SKIP.
        END.
        OUTPUT STREAM strm1 CLOSE.
        OUTPUT STREAM strm2 CLOSE.
        OUTPUT STREAM strm3 CLOSE.
    END.
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

