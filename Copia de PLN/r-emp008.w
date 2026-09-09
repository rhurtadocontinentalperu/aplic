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
DEFINE SHARED VAR s-periodo AS INT.
DEFINE SHARED VAR s-nromes AS INT.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE STREAM REPORTE.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE monto_pagar AS CHARACTER NO-UNDO.
DEFINE VARIABLE fecha_emision AS CHARACTER NO-UNDO.
DEFINE VARIABLE fecha_pago AS CHARACTER NO-UNDO.
DEFINE VARIABLE monto_letras AS CHARACTER NO-UNDO.
DEFINE VARIABLE archivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE meses AS CHARACTER INITIAL
    "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
DEFINE VARIABLE cCTipoVia AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNTipoVia AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDireccion AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDistrito AS CHARACTER NO-UNDO.
DEFINE VARIABLE total_ingresos AS DECIMAL NO-UNDO.
DEFINE VARIABLE total_dias AS DECIMAL NO-UNDO.
DEFINE VARIABLE s-task-no AS INT INITIAL 0 NO-UNDO.
DEFINE VARIABLE x-Periodo AS CHAR NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE Word AS COM-HANDLE.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

/* VARIABLES DE IMPRESION */
DEFINE VARIABLE RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEFINE VARIABLE RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEFINE VARIABLE RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEFINE VARIABLE RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEFINE VARIABLE RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE detalle
    FIELD codper LIKE pl-pers.codper
    FIELD valcal-mes AS DEC EXTENT 4000.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-4 BUTTON-3 TOGGLE-save ~
COMBO-BOX-Periodo FILL-IN-fecdoc FILL-IN-fecpag FILL-IN-renta ~
RADIO-SET-print COMBO-seccion FILL-IN-codemp FILL-IN-codemp-2 BUTTON-1 ~
BUTTON-2 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-save COMBO-BOX-Periodo ~
FILL-IN-fecdoc FILL-IN-fecpag FILL-IN-renta RADIO-SET-print COMBO-seccion ~
FILL-IN-codemp FILL-IN-codemp-2 

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
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 5 BY 1.35.

DEFINE BUTTON BUTTON-4 
     LABEL "HOJA DE TRABAJO EN EXCEL" 
     SIZE 25 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-seccion AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sección" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-codemp AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Empleado" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-codemp-2 AS INTEGER FORMAT "999999":U INITIAL 999999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecdoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha Documento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecpag AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha Pago" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-renta AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Renta Anual" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-print AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Listado", 1,
"Liquidación", 2,
"Recibo (recalculado)", 3,
"Recibo (ya calculado)", 4
     SIZE 18 BY 2.31 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 64 BY 6.5.

DEFINE VARIABLE TOGGLE-save AS LOGICAL INITIAL no 
     LABEL "Guardar cálculo de utilidades" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-4 AT ROW 8 COL 2 WIDGET-ID 6
     BUTTON-3 AT ROW 8 COL 29 WIDGET-ID 4
     TOGGLE-save AT ROW 6.65 COL 38 WIDGET-ID 2
     COMBO-BOX-Periodo AT ROW 1.81 COL 15 COLON-ALIGNED
     FILL-IN-fecdoc AT ROW 2.77 COL 15 COLON-ALIGNED
     FILL-IN-fecpag AT ROW 3.73 COL 15 COLON-ALIGNED
     FILL-IN-renta AT ROW 4.69 COL 15 COLON-ALIGNED
     RADIO-SET-print AT ROW 1.81 COL 43 NO-LABEL
     COMBO-seccion AT ROW 4.69 COL 36 COLON-ALIGNED
     FILL-IN-codemp AT ROW 5.65 COL 36 COLON-ALIGNED
     FILL-IN-codemp-2 AT ROW 5.65 COL 50 COLON-ALIGNED
     BUTTON-1 AT ROW 8 COL 34
     BUTTON-2 AT ROW 8 COL 50
     "Imprimir:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2 COL 37
     RECT-2 AT ROW 1.27 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.86 BY 8.81
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
         TITLE              = "Cáculo de Distribución de Utilidades"
         HEIGHT             = 8.81
         WIDTH              = 65.86
         MAX-HEIGHT         = 8.81
         MAX-WIDTH          = 65.86
         VIRTUAL-HEIGHT     = 8.81
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
   FRAME-NAME Custom                                                    */
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
ON END-ERROR OF W-Win /* Cáculo de Distribución de Utilidades */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cáculo de Distribución de Utilidades */
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
            FILL-IN-renta
            FILL-IN-fecdoc
            FILL-IN-fecpag
            RADIO-SET-print
            FILL-IN-codemp
            FILL-IN-codemp-2
            COMBO-seccion
            TOGGLE-save.
    END.
    IF RADIO-SET-print = 4 
        THEN RUN proc_Carga_Temporal-1.
    ELSE RUN proc_Carga_Temporal.
    HIDE FRAME F-Proceso.
    CASE RADIO-SET-print:
        WHEN 1 OR WHEN 2 THEN RUN proc_Imprime.
        WHEN 3 THEN RUN proc_Recibo.
        WHEN 4 THEN RUN proc_Recibo-1.
    END CASE.

    IF CAN-FIND(FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id
        NO-LOCK) THEN DO:
        IF TOGGLE-save THEN DO:
            MESSAGE
                "¿Realmente desea guardar el monto de utilidades" SKIP
                "para este criterio de selección de empleados?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                UPDATE rpta AS LOGICAL.
            IF rpta THEN RUN guarda_calculo.
        END.
        /* Borra temporal */
        FOR EACH w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id.
            DELETE w-report.
        END.
    END.

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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-BOX-Periodo
            FILL-IN-renta
            FILL-IN-fecdoc
            FILL-IN-fecpag
            RADIO-SET-print
            FILL-IN-codemp
            FILL-IN-codemp-2
            COMBO-seccion
            TOGGLE-save.
    END.
    RUN proc_Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* HOJA DE TRABAJO EN EXCEL */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-BOX-Periodo
            FILL-IN-renta
            FILL-IN-fecdoc
            FILL-IN-fecpag
            RADIO-SET-print
            FILL-IN-codemp
            FILL-IN-codemp-2
            COMBO-seccion
            TOGGLE-save.
    END.
     RUN Hoja-Trabajo-Excel.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-print W-Win
ON VALUE-CHANGED OF RADIO-SET-print IN FRAME F-Main
DO:
  IF INPUT {&self-name} <> 1 THEN button-3:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  ELSE button-3:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
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
  DISPLAY TOGGLE-save COMBO-BOX-Periodo FILL-IN-fecdoc FILL-IN-fecpag 
          FILL-IN-renta RADIO-SET-print COMBO-seccion FILL-IN-codemp 
          FILL-IN-codemp-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-4 BUTTON-3 TOGGLE-save COMBO-BOX-Periodo FILL-IN-fecdoc 
         FILL-IN-fecpag FILL-IN-renta RADIO-SET-print COMBO-seccion 
         FILL-IN-codemp FILL-IN-codemp-2 BUTTON-1 BUTTON-2 RECT-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE guarda_calculo W-Win 
PROCEDURE guarda_calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dMontoPagar AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cCodPer AS CHARACTER NO-UNDO.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I >= FILL-IN-codemp AND
        w-report.Llave-I <= FILL-IN-codemp-2 AND
        (COMBO-seccion = "Todas" OR
        w-report.Campo-C[3] BEGINS COMBO-seccion) NO-LOCK:
        cCodPer = STRING(w-report.Llave-I,"999999").
        DISPLAY
            "   Personal: " + cCodPer @ Fi-Mensaje NO-LABEL FORMAT "X(22)"
            WITH FRAME F-Proceso.
        dMontoPagar =
            (w-report.campo-f[1] * (FILL-IN-renta * 0.5) / total_ingresos) +
            (w-report.campo-f[2] * (FILL-IN-renta * 0.5) / total_dias).
        FIND pl-mov-mes WHERE
            pl-mov-mes.CodCia  = s-CodCia AND
            pl-mov-mes.Periodo = s-periodo AND
            pl-mov-mes.NroMes  = s-nromes AND
            pl-mov-mes.CodPln  = 01 AND
            pl-mov-mes.CodCal  = 0 AND
            pl-mov-mes.codper  = cCodPer AND
            pl-mov-mes.codmov  = 137 NO-ERROR.
        IF NOT AVAILABLE pl-mov-mes THEN DO:
            CREATE pl-mov-mes.
            ASSIGN
                pl-mov-mes.CodCia = s-CodCia
                pl-mov-mes.Periodo = s-periodo
                pl-mov-mes.NroMes = s-nromes
                pl-mov-mes.codpln = 01
                pl-mov-mes.codcal = 0
                pl-mov-mes.codper = cCodper
                pl-mov-mes.CodMov = 137.
        END.
        ASSIGN
            pl-mov-mes.valcal-mes = dMontoPagar
            pl-mov-mes.flgreg-mes = FALSE.
        RELEASE pl-mov-mes.
    END.

    HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hoja-Trabajo-Excel W-Win 
PROCEDURE Hoja-Trabajo-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE detalle.

/* Empleados */ 
/* Boleta de Remuneraciones */
FOR EACH PL-MOV-MES NO-LOCK WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    PL-MOV-MES.CodCal = 01 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 101 OR                                 /* Basico */
    PL-MOV-MES.CodMov = 103 OR                                  /* Asig. Familiar */
    PL-MOV-MES.CodMov = 106 OR                                  /* Vacacional */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones Trabajadas*/
    PL-MOV-MES.CodMov = 108 OR                                  /* Vacaciones Truncas */
    PL-MOV-MES.CodMov = 118 OR                                  /* Descanso medico */
    PL-MOV-MES.CodMov = 125 OR                                  /* HE 25% */
    PL-MOV-MES.CodMov = 126 OR                                  /* HE 100% */
    PL-MOV-MES.CodMov = 127 OR                                  /* HE 35% */
    PL-MOV-MES.CodMov = 131 OR                                  /* Bonificacion Incentivo */
    PL-MOV-MES.CodMov = 134 OR                                  /* Bonificacion Especial */
    PL-MOV-MES.CodMov = 136 OR                                  /* Reintegro */
    PL-MOV-MES.CodMov = 138 OR                                  /* Asignación Extraordinaria */
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 100)                                    /* Dias Efectivos */
    :
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[pl-mov-mes.codmov] = detalle.valcal-mes[pl-mov-mes.codmov] + pl-mov-mes.valcal-mes.
END.
/* Boleta de Gratificaciones */
DEF VAR x-codmov AS INT.
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 212                                     /* Gratificacion */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    x-CodMov = pl-mov-mes.codmov + 1000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139)                                     /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    x-CodMov = pl-mov-mes.codmov + 2000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion de Eventuales */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611)                                    /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    x-CodMov = pl-mov-mes.codmov + 3000.
    FIND detalle WHERE detalle.codper = pl-mov-mes.codper NO-ERROR.
    IF NOT AVAILABLE detalle THEN CREATE detalle.
    ASSIGN
        detalle.codper = pl-mov-mes.codper
        detalle.valcal-mes[x-codmov] = detalle.valcal-mes[x-codmov] + pl-mov-mes.valcal-mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
HIDE FRAME F-Proceso.


DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-linea AS CHAR FORMAT 'x(1000)'.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-linea = 'PERSONAL|101|103|106|107|108|118|125|126|127|131|134|136|138|139|801|802|803|130|146|209|'.
x-linea = x-linea + '212|'.
x-linea = x-linea + '431|139|'.
x-linea = x-linea + '431|611|'.
x-linea = x-linea + 'DIAS EFECTIVOS|'.
x-linea = REPLACE(x-linea, '|', CHR(9)).
PUT STREAM REPORTE UNFORMATTED x-linea SKIP.
FOR EACH detalle, FIRST pl-pers WHERE pl-pers.codper = detalle.codper NO-LOCK:
    x-linea = detalle.codper + ' - ' +
                TRIM (pl-pers.patper) + TRIM (pl-pers.matper) + ', ' + 
                TRIM(pl-pers.nomper) + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[101], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[103], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[106], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[107], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[108], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[118], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[125], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[126], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[127], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[131], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[134], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[136], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[138], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[139], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[801], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[802], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[803], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[130], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[146], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[209], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[1212], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[2431], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[2139], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[3431], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[3611], '>>>,>>9.99') + '|'.
    x-linea = x-linea + STRING (detalle.valcal-mes[99], '>>>,>>9.99') + '|'.
    x-linea = REPLACE(x-linea, '|', CHR(9)).
    PUT STREAM REPORTE UNFORMATTED x-linea SKIP.
END.
OUTPUT CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Utilidades', YES).



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
            FILL-IN-fecdoc = TODAY
            FILL-IN-fecpag = TODAY
            COMBO-BOX-Periodo:LIST-ITEMS = x-Periodo
            COMBO-BOX-Periodo = s-periodo.
        DO i = 1 TO NUM-ENTRIES(x-Periodo):
            IF ENTRY(i,x-Periodo) = "" THEN pto = COMBO-BOX-Periodo:DELETE("").
        END.
        FOR EACH pl-secc NO-LOCK:
            IF pl-secc.seccion <> "" THEN
                COMBO-seccion:ADD-LAST(pl-secc.seccion).
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    /* Tipo de Via */
    FOR EACH PL-TABLA WHERE
        pl-tabla.codcia = 0 AND
        pl-tabla.tabla = '05' NO-LOCK:
        IF cCTipoVia = '' THEN cCTipoVia = pl-tabla.codigo.
        ELSE cCTipoVia = cCTipoVia + ',' + pl-tabla.codigo.
        IF cNTipoVia = '' THEN cNTipoVia = pl-tabla.nombre.
        ELSE cNTipoVia = cNTipoVia + ',' + pl-tabla.nombre.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Carga_Temporal W-Win 
PROCEDURE proc_Carga_Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CALCULO BASE */
{pln/r-emp008.i}

/*
total_ingresos = 0.
total_dias = 0.

REPEAT:
    s-task-no = RANDOM(1, 999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
END.

/* Empleados */ 
/* Boleta de Remuneraciones */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    PL-MOV-MES.CodCal = 01 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 101 OR                                 /* Basico */
    PL-MOV-MES.CodMov = 103 OR                                  /* Asig. Familiar */
    PL-MOV-MES.CodMov = 106 OR                                  /* Vacacional */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones Trabajadas*/
    PL-MOV-MES.CodMov = 108 OR                                  /* Vacaciones Truncas */
    PL-MOV-MES.CodMov = 118 OR                                  /* Descanso medico */
    PL-MOV-MES.CodMov = 125 OR                                  /* HE 25% */
    PL-MOV-MES.CodMov = 126 OR                                  /* HE 100% */
    PL-MOV-MES.CodMov = 127 OR                                  /* HE 35% */
    PL-MOV-MES.CodMov = 131 OR                                  /* Bonificacion Incentivo */
    PL-MOV-MES.CodMov = 134 OR                                  /* Bonificacion Especial */
    PL-MOV-MES.CodMov = 136 OR                                  /* Reintegro */
    PL-MOV-MES.CodMov = 138 OR                                  /* Asignación Extraordinaria */
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 100)                                    /* Dias Calendarios */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 100 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.
/* Boleta de Gratificaciones */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 212                                     /* Gratificacion */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139)                                     /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
/* Liquidacion de Eventuales */
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611)                                    /* Gratificacion Trunca */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
    total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Carga_Temporal-1 W-Win 
PROCEDURE proc_Carga_Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dMontoPagar AS DECIMAL NO-UNDO.
    DEFINE VARIABLE cCodPer AS CHARACTER NO-UNDO.

    REPEAT:
        s-task-no = RANDOM(1, 999999).
        FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN LEAVE.
    END.
    FOR EACH pl-mov-mes NO-LOCK WHERE pl-mov-mes.CodCia  = s-CodCia 
        AND pl-mov-mes.Periodo = s-periodo 
        AND pl-mov-mes.NroMes  = s-nromes 
        AND pl-mov-mes.CodPln  = 01 
        AND pl-mov-mes.CodCal  = 0 
        AND pl-mov-mes.codmov  = 137:
        DISPLAY
            "   Mes: " + STRING(PL-MOV-MES.NroMes) @
            Fi-Mensaje NO-LABEL
            FORMAT "X(16)"
            WITH FRAME F-Proceso.
        FIND FIRST w-report WHERE w-report.Task-No = s-task-no 
            AND w-report.Llave-C = s-user-id 
            AND w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
            NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
            FIND pl-pers WHERE pl-pers.CodPer = PL-MOV-MES.CodPer
                NO-LOCK NO-ERROR.
            IF AVAILABLE pl-pers THEN DO:
                ASSIGN
                    w-report.Campo-C[1] = PL-PERS.patper + " " +
                                            PL-PERS.matper + " " + PL-PERS.nomper
                    w-report.Campo-C[2] = PL-PERS.NroDocId.
                FIND LAST PL-FLG-MES WHERE PL-FLG-MES.codpln = PL-MOV-MES.CodPln 
                    AND PL-FLG-MES.CodCia = s-codcia 
                    AND PL-FLG-MES.Periodo = PL-MOV-MES.Periodo 
                    AND PL-FLG-MES.NROMES >= 0 
                    AND PL-FLG-MES.codper = PL-PERS.codper
                    NO-LOCK NO-ERROR.
                IF AVAILABLE PL-FLG-MES THEN DO:
                    w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                    w-report.Campo-C[3] = PL-FLG-MES.Seccion.
                END.
            END.
            ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
            w-report.Campo-F[1] = pl-mov-mes.valcal-mes.
        END.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Carga_Temporal_Old W-Win 
PROCEDURE proc_Carga_Temporal_Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

total_ingresos = 0.
total_dias = 0.

/* Empleados */ 
FOR EACH PL-MOV-MES WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla */
    (PL-MOV-MES.CodCal = 01 OR PL-MOV-MES.CodCal = 04) AND      /* Cálculo */
    PL-MOV-MES.CodPer >= "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 401 OR                                 /* Total Ingresos */
    PL-MOV-MES.CodMov = 107 OR                                  /* Vacaciones */
    PL-MOV-MES.CodMov = 100 OR                                  /* Dias Efectivos */
    PL-MOV-MES.CodMov = 502 OR                                  /* Faltas Injustificadas */
    PL-MOV-MES.CodMov = 503)                                    /* Licencia SGH */
    NO-LOCK:
    IF PL-MOV-MES.ValCal-Mes = 0 THEN NEXT.
    DISPLAY
        "   Mes: " + STRING(PL-MOV-MES.NroMes) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
            FIND pl-pers WHERE
                pl-pers.CodPer = PL-MOV-MES.CodPer
                NO-LOCK NO-ERROR.
            IF AVAILABLE pl-pers THEN DO:
                ASSIGN
                    w-report.Campo-C[1] = PL-PERS.patper + " " +
                        PL-PERS.matper + " " + PL-PERS.nomper
                    w-report.Campo-C[2] = PL-PERS.NroDocId.
                FIND LAST PL-FLG-MES WHERE
                    PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                    PL-FLG-MES.CodCia = s-codcia AND
                    PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                    PL-FLG-MES.NROMES >= 0 AND
                    PL-FLG-MES.codper = PL-PERS.codper
                    NO-LOCK NO-ERROR.
                IF AVAILABLE PL-FLG-MES THEN DO:
                    w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                    w-report.Campo-C[3] = PL-FLG-MES.Seccion.
                END.
            END.
            ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
            LEAVE.
        END.
    END.
    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-MES.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-MES.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-MES WHERE
                PL-FLG-MES.codpln = PL-MOV-MES.CodPln AND
                PL-FLG-MES.CodCia = s-codcia AND
                PL-FLG-MES.Periodo = PL-MOV-MES.Periodo AND
                PL-FLG-MES.NROMES >= 0 AND
                PL-FLG-MES.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-MES THEN DO:
                w-report.Campo-D[1] = PL-FLG-MES.FecIng.
                w-report.Campo-C[3] = PL-FLG-MES.Seccion.
            END.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 401 THEN DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
        WHEN 107 THEN DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] - PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos - PL-MOV-MES.ValCal-Mes.
        END.
        WHEN 100 OR WHEN 503 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
        END.
        WHEN 502 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] - PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias - PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.

/* Obreros */
FOR EACH PL-MOV-SEM WHERE
    PL-MOV-SEM.CodCia = s-codcia AND
    PL-MOV-SEM.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-SEM.NroSem >= 1 AND PL-MOV-SEM.NroSem <= 53) AND    /* Todo el Año */
    PL-MOV-SEM.CodPln = 02 AND                                  /* Planilla */
    (PL-MOV-SEM.CodCal = 01 OR PL-MOV-SEM.CodCal = 04) AND      /* Cálculo */
    PL-MOV-SEM.CodPer >= "" AND                                 /* Todos los Empl */
    (PL-MOV-SEM.CodMov = 401 OR                                 /* Total Ingresos */
    PL-MOV-SEM.CodMov = 107 OR                                  /* Vacaciones */
    PL-MOV-SEM.CodMov = 100 OR                                  /* Dias Trabajados */
    PL-MOV-SEM.CodMov = 502 OR                                  /* Faltas Injustificadas */
    PL-MOV-SEM.CodMov = 503)                                    /* Licencia SGH */
    NO-LOCK:
    IF PL-MOV-SEM.ValCal-Sem = 0 THEN NEXT.
    DISPLAY
        "   Semana: " + STRING(PL-MOV-SEM.NroSem) @
        Fi-Mensaje NO-LABEL
        FORMAT "X(16)"
        WITH FRAME F-Proceso.
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Llave-I = INTEGER(PL-MOV-SEM.CodPer).
            FIND pl-pers WHERE
                pl-pers.CodPer = PL-MOV-SEM.CodPer
                NO-LOCK NO-ERROR.
            IF AVAILABLE pl-pers THEN DO:
                ASSIGN
                    w-report.Campo-C[1] = PL-PERS.patper + " " +
                        PL-PERS.matper + " " + PL-PERS.nomper
                    w-report.Campo-C[2] = PL-PERS.NroDocId.
                FIND LAST PL-FLG-SEM WHERE
                    PL-FLG-SEM.codpln = PL-MOV-SEM.CodPln AND
                    PL-FLG-SEM.CodCia = s-codcia AND
                    PL-FLG-SEM.Periodo = PL-MOV-SEM.Periodo AND
                    PL-FLG-SEM.NROSEM >= 0 AND
                    PL-FLG-SEM.codper = PL-PERS.codper
                    NO-LOCK NO-ERROR.
                IF AVAILABLE PL-FLG-SEM THEN
                    w-report.Campo-D[1] = PL-FLG-SEM.FecIng.
            END.
            ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
            LEAVE.
        END.
    END.
    FIND FIRST w-report WHERE
        w-report.Task-No = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I = INTEGER(PL-MOV-SEM.CodPer)
        NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No = s-task-no
            w-report.Llave-C = s-user-id
            w-report.Llave-I = INTEGER(PL-MOV-SEM.CodPer).
        FIND pl-pers WHERE
            pl-pers.CodPer = PL-MOV-SEM.CodPer
            NO-LOCK NO-ERROR.
        IF AVAILABLE pl-pers THEN DO:
            ASSIGN
                w-report.Campo-C[1] = PL-PERS.patper + " " +
                    PL-PERS.matper + " " + PL-PERS.nomper
                w-report.Campo-C[2] = PL-PERS.NroDocId.
            FIND LAST PL-FLG-SEM WHERE
                PL-FLG-SEM.codpln = PL-MOV-SEM.CodPln AND
                PL-FLG-SEM.CodCia = s-codcia AND
                PL-FLG-SEM.Periodo = PL-MOV-SEM.Periodo AND
                PL-FLG-SEM.NROSEM >= 0 AND
                PL-FLG-SEM.codper = PL-PERS.codper
                NO-LOCK NO-ERROR.
            IF AVAILABLE PL-FLG-SEM THEN
                w-report.Campo-D[1] = PL-FLG-SEM.FecIng.
        END.
        ELSE w-report.Campo-C[1] = "FUNCIONARIO NO EXISTE!!!".
    END.
    CASE PL-MOV-SEM.CodMov:
        WHEN 401 THEN DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-SEM.ValCal-Sem.
            total_ingresos = total_ingresos + PL-MOV-SEM.ValCal-Sem.
        END.
        WHEN 107 THEN DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] - PL-MOV-SEM.ValCal-Sem.
            total_ingresos = total_ingresos - PL-MOV-SEM.ValCal-Sem.
        END.
        WHEN 100 OR WHEN 503 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-SEM.ValCal-Sem.
            total_dias = total_dias + PL-MOV-SEM.ValCal-Sem.
        END.
        WHEN 502 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] - PL-MOV-SEM.ValCal-sem.
            total_dias = total_dias - PL-MOV-SEM.ValCal-Sem.
        END.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Excel W-Win 
PROCEDURE proc_Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN proc_Carga_Temporal.
    HIDE FRAME F-Proceso.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No Existen Registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
    DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
    DEF VAR x-Archivo AS CHAR NO-UNDO.
    DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.

    x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

    OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
    x-Titulo = '||Remuneración|Dias|Participacion|Participacion|'.
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
    PUT STREAM REPORTE x-Titulo SKIP.
    x-Titulo = 'Codigo|Nombre|Percibida|Laborados|por Remuneracion|por dias Laborados|'.
    x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
    PUT STREAM REPORTE x-Titulo SKIP.

    FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
        AND w-report.llave-c = s-user-id:
        x-Llave = STRING (w-report.llave-i, '999999') + '|'.
        x-Llave = x-Llave + w-report.campo-c[1] + '|'.
        x-Llave = x-Llave + STRING (w-report.campo-f[1], '>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING (w-report.campo-f[2], '>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING (w-report.campo-f[1] * FILL-IN-renta * 0.5 / TOTAL_ingresos  , '>>>>>>9.99') + '|'.
        x-Llave = x-Llave + STRING (w-report.campo-f[2] * FILL-IN-renta * 0.5 / TOTAL_dias  , '>>>>>>9.99') + '|'.
        x-Llave = REPLACE ( x-Llave, '|', CHR(9) ).
        PUT STREAM REPORTE x-LLave SKIP.
    END.
    OUTPUT STREAM REPORTE CLOSE.

    IF CAN-FIND(FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id
        NO-LOCK) THEN DO:
        IF TOGGLE-save THEN DO:
            MESSAGE
                "¿Realmente desea guardar el monto de utilidades" SKIP
                "para este criterio de selección de empleados?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                UPDATE rpta AS LOGICAL.
            IF rpta THEN RUN guarda_calculo.
        END.
        /* Borra temporal */
        FOR EACH w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id.
            DELETE w-report.
        END.
    END.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Utilidades', YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Imprime W-Win 
PROCEDURE proc_Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE s-titulo AS CHARACTER.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No Existen Registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'pln/reporte.prl'.

    CASE RADIO-SET-print:
        WHEN 1 THEN RB-REPORT-NAME = 'Distribución Utilidades'.
        WHEN 2 THEN RB-REPORT-NAME = 'Liquidación Utilidades'.        
    END CASE.

    s-titulo =
        "PARTICIPACIÓN EN LAS UTILIDADES POR EL EJERCICIO GRAVABLE" +
        " " + STRING(COMBO-BOX-Periodo,"9999").

    FIND GN-CIAS WHERE GN-CIAS.CodCia = s-codcia NO-LOCK NO-ERROR.

    RB-INCLUDE-RECORDS = "O".
    RB-FILTER =
        "w-report.task-no = " + STRING(s-task-no) +
        " AND w-report.Llave-C = '" + s-user-id + "'" +
        " AND w-report.Llave-I >= " + STRING(FILL-IN-codemp) +
        " AND w-report.Llave-I <= " + STRING(FILL-IN-codemp-2).
    RB-OTHER-PARAMETERS =
        "s-nomcia = " + s-nomcia +        
        "~ns-ruccia = " + GN-CIAS.LIBRE-C[1] +
        "~ns-titulo = " + s-titulo +
        "~ns-fecha = " + STRING(FILL-IN-fecdoc) +
        "~ns-renta = " + STRING(FILL-IN-renta) +
        "~ns-total_ingresos = " + STRING(total_ingresos) +
        "~ns-total_dias = " + STRING(total_dias).

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Imprime_Recibo W-Win 
PROCEDURE proc_Imprime_Recibo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_codper LIKE pl-pers.codper.
    DEFINE INPUT PARAMETER para_importe AS DECIMAL.

    CREATE "Word.Application" Word.

    FIND Pl-pers WHERE Pl-Pers.Codper = para_codper NO-LOCK NO-ERROR.

    RUN bin/_numero(para_importe, 2, 1, OUTPUT monto_letras).
    monto_pagar = STRING(para_importe) + "(" + monto_letras + ")".
    fecha_pago = STRING(DAY(FILL-IN-fecpag)) + " de " +
        ENTRY(MONTH(FILL-IN-fecpag),meses) + " del " + STRING(YEAR(FILL-IN-fecpag)).
    fecha_emision = STRING(DAY(FILL-IN-fecdoc)) + " de " +
        ENTRY(MONTH(FILL-IN-fecdoc),meses) + " del " + STRING(YEAR(FILL-IN-fecdoc)).

    Word:Documents:Add("Prestamo_02").

    /* Distrito */
    FIND TabDistr WHERE
        TabDistr.CodDepto = SUBSTRING(PL-PERS.ubigeo,1,2) AND
        TabDistr.CodProvi = SUBSTRING(PL-PERS.ubigeo,3,2) AND
        TabDistr.CodDistr = SUBSTRING(PL-PERS.ubigeo,5,2)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TabDistr THEN cDistrito = "".
    ELSE cDistrito = TabDistr.NomDistr.

    cDireccion =
        ENTRY(LOOKUP(PL-PERS.TipoVia, cCTipoVia), cNTipoVia) + " " + TRIM(pl-pers.dirper).
    IF PL-PERS.dirnumero <> "" THEN
        cDireccion = cDireccion + " Nro " + PL-PERS.dirnumero.
    IF PL-PERS.dirinterior <> "" THEN
        cDireccion = cDireccion + " Int " + PL-PERS.dirinterior.
    cDireccion = cDireccion + " " + TRIM(cDistrito).

    RUN proc_Reemplazo(
        INPUT "NOMPER",
        INPUT (TRIM(pl-pers.nomper) + " " +
            TRIM(pl-pers.patper) + " " +
            TRIM(pl-pers.matper)),
        INPUT 1).
    RUN proc_Reemplazo(
        INPUT "DIRPER",
        INPUT cDireccion,
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "DNIPER",
        INPUT (pl-pers.NroDocId),
        INPUT 0).
    RUN proc_Reemplazo(
        INPUT "SUEPER",
        INPUT (monto_pagar),
        INPUT 0).
    /*
    RUN proc_Reemplazo(
        INPUT "FECPGO",
        INPUT (fecha_pago),
        INPUT 0).
        */
    RUN proc_Reemplazo(
        INPUT "FECEMI",
        INPUT (fecha_emision),
        INPUT 0).

    Word:ActiveDocument:PrintOut().

    archivo = "recibo" + pl-pers.codper.
    Word:ChangeFileOpenDirectory("M:\").
    Word:ActiveDocument:SaveAs(archivo).
    Word:Quit().

    RELEASE OBJECT Word NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Recibo W-Win 
PROCEDURE proc_Recibo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dMontoPagar AS DECIMAL NO-UNDO.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I >= FILL-IN-codemp AND
        w-report.Llave-I <= FILL-IN-codemp-2 AND
        (COMBO-seccion = "Todas" OR
        w-report.Campo-C[3] BEGINS COMBO-seccion) NO-LOCK:
        DISPLAY
            "   Personal: " + STRING(w-report.Llave-I,"999999") @
            Fi-Mensaje NO-LABEL FORMAT "X(22)"
            WITH FRAME F-Proceso.
        dMontoPagar =
            (w-report.campo-f[1] * (FILL-IN-renta * 0.5) / total_ingresos) +
            (w-report.campo-f[2] * (FILL-IN-renta * 0.5) / total_dias).
        RUN proc_Imprime_Recibo(
            INPUT STRING(w-report.Llave-I,"999999"),
            INPUT ROUND(dMontoPagar,2)).
    END.

    HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Recibo-1 W-Win 
PROCEDURE proc_Recibo-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dMontoPagar AS DECIMAL NO-UNDO.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Llave-I >= FILL-IN-codemp AND
        w-report.Llave-I <= FILL-IN-codemp-2 AND
        (COMBO-seccion = "Todas" OR
        w-report.Campo-C[3] BEGINS COMBO-seccion) NO-LOCK:
        DISPLAY
            "   Personal: " + STRING(w-report.Llave-I,"999999") @
            Fi-Mensaje NO-LABEL FORMAT "X(22)"
            WITH FRAME F-Proceso.
        dMontoPagar = w-report.campo-f[1].
        RUN proc_Imprime_Recibo(
            INPUT STRING(w-report.Llave-I,"999999"),
            INPUT ROUND(dMontoPagar,2)).
    END.

    HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Reemplazo W-Win 
PROCEDURE proc_Reemplazo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER campo AS CHARACTER.
    DEFINE INPUT PARAMETER registro AS CHARACTER.
    DEFINE INPUT PARAMETER mayuscula AS LOGICAL.

    DEFINE VARIABLE cBuffer AS CHARACTER.

    Word:Selection:Goto(-1 BY-VARIANT-POINTER,,,campo BY-VARIANT-POINTER).
    Word:Selection:Select().
    IF mayuscula = TRUE THEN cBuffer = CAPS(registro).
    ELSE cBuffer = registro.

    Word:Selection:Typetext(cBuffer).

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

