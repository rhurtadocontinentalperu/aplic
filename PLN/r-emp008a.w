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
DEFINE SHARED VAR s-ruccia AS INT.
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo FILL-IN-fecdoc ~
FILL-IN-renta COMBO-seccion BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo FILL-IN-fecdoc ~
FILL-IN-renta COMBO-seccion 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "Button 1" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 15 BY 1.5.

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
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-fecdoc AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha Documento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-renta AS DECIMAL FORMAT ">>,>>>,>>9.99":U INITIAL 0 
     LABEL "Renta Anual" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.81 COL 15 COLON-ALIGNED
     FILL-IN-fecdoc AT ROW 2.77 COL 15 COLON-ALIGNED
     FILL-IN-renta AT ROW 3.69 COL 15 COLON-ALIGNED
     COMBO-seccion AT ROW 4.77 COL 15 COLON-ALIGNED
     BUTTON-1 AT ROW 6.38 COL 4
     BUTTON-2 AT ROW 6.38 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.86 BY 7.35
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
         TITLE              = "CERTIFICADO DE PARTICIPACION DE UTILIDADES"
         HEIGHT             = 7.35
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
ON END-ERROR OF W-Win /* CERTIFICADO DE PARTICIPACION DE UTILIDADES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CERTIFICADO DE PARTICIPACION DE UTILIDADES */
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
            COMBO-seccion.
    END.
    IF FILL-IN-renta <= 0 THEN DO:
        MESSAGE 'Ingrese la renta a distribuir' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO FILL-IN-renta.
        RETURN NO-APPLY.
    END.
    RUN proc_Carga_Temporal.
    HIDE FRAME F-Proceso.
    FIND FIRST w-report WHERE w-report.Task-No = s-task-no 
        AND w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
    DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
    DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
    DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
    DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

    GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'pln/reporte.prl'
        RB-REPORT-NAME = 'Certificado de Utilidades'
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                    " AND w-report.llave-c = '" + s-user-id + "'".
    ASSIGN
        RB-OTHER-PARAMETERS = 's-nomcia=' + s-nomcia + 
                                '~ns-ruccia=' + STRING (s-ruccia) +
                                '~ns-periodo=' + STRING (COMBO-BOX-Periodo, '9999') +
                                '~ntotal-dias=' + STRING(total_dias) +
                                '~ntotal-ingresos=' + STRING( TOTAL_ingresos) +
                                '~nrenta-anual=' + STRING (FILL-IN-renta).


    RUN lib/_imprime2 ( RB-REPORT-LIBRARY,
                        RB-REPORT-NAME,
                        RB-INCLUDE-RECORDS,
                        RB-FILTER,
                        RB-OTHER-PARAMETERS).
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
  DISPLAY COMBO-BOX-Periodo FILL-IN-fecdoc FILL-IN-renta COMBO-seccion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo FILL-IN-fecdoc FILL-IN-renta COMBO-seccion BUTTON-1 
         BUTTON-2 
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
            FILL-IN-fecdoc = TODAY
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


/* RHC 04.04.2012 AGREGAMOS QUINTA CATEGORIA */
FOR EACH PL-MOV-MES NO-LOCK WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados */
    ( PL-MOV-MES.CodCal = 01 OR                                 /* Remuneraciones */
      PL-MOV-MES.CodCal = 04 OR                                 /* Gratificaciones */
      PL-MOV-MES.CodCal = 05 OR                                 /* Liquidaciones */
      PL-MOV-MES.CodCal = 08 ) AND                              /* Liquidaciones Eventuales */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    PL-MOV-MES.CodMov = 215                                     /* Quinta categoria */
    , FIRST pl-pers OF pl-mov-mes NO-LOCK
    , FIRST pl-flg-mes OF pl-mov-mes NO-LOCK:
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
        ASSIGN                                            
            w-report.Campo-C[1] = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper
            w-report.Campo-C[2] = PL-PERS.NroDocId
            w-report.Campo-D[1] = PL-FLG-MES.FecIng
            w-report.Campo-C[3] = PL-FLG-MES.Seccion.
    END.
    /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
    w-report.Campo-F[3] = w-report.Campo-F[3] + PL-MOV-MES.ValCal-Mes.
END.
IF COMBO-Seccion <> 'Todas' THEN DO:
    FOR EACH w-report WHERE w-report.task-no = s-task-no
        AND w-report.llave-c = s-user-id
        AND w-report.campo-c[3] <> COMBO-Seccion:
        DELETE w-report.
    END.
END.


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
    PL-MOV-MES.CodMov = 139 OR                                  /* Gratificacion Trunca */
    PL-MOV-MES.CodMov = 801 OR                                  /* Bonificacion por Produccion */
    PL-MOV-MES.CodMov = 802 OR                                  /* Bonificacion Nocturna */
    PL-MOV-MES.CodMov = 803 OR                                  /* Subsidio Pre-Post Natal */
     PL-MOV-MES.CodMov = 130 OR                                  /* Otros Ingresos */
     PL-MOV-MES.CodMov = 146 OR                                  /* Riesgo de Caja */
     PL-MOV-MES.CodMov = 209 OR                                  /* Comisiones */
    PL-MOV-MES.CodMov = 099 OR                                   /* Dias Efectivos */
     PL-MOV-MES.CodMov = 215)                                   /* Quinta categoria */
    , FIRST pl-pers OF pl-mov-mes NO-LOCK
    , FIRST pl-flg-mes OF pl-mov-mes NO-LOCK:
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
        ASSIGN                                            
            w-report.Campo-C[1] = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper
            w-report.Campo-C[2] = PL-PERS.NroDocId
            w-report.Campo-D[1] = PL-FLG-MES.FecIng
            w-report.Campo-C[3] = PL-FLG-MES.Seccion.
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 099 THEN DO:
            w-report.Campo-F[2] = w-report.Campo-F[2] + PL-MOV-MES.ValCal-Mes.
            total_dias = total_dias + PL-MOV-MES.ValCal-Mes.
        END.
        WHEN 215 THEN DO:       /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
            w-report.Campo-F[3] = w-report.Campo-F[3] + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.

/* Boleta de Gratificaciones */
FOR EACH PL-MOV-MES NO-LOCK WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 04 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 212 OR                                    /* Gratificacion */
     PL-MOV-MES.CodMov = 215)                                   /* Quinta categoria */
    , FIRST pl-pers OF pl-mov-mes NO-LOCK
    , FIRST pl-flg-mes OF pl-mov-mes NO-LOCK:
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
        ASSIGN                                            
            w-report.Campo-C[1] = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper 
            w-report.Campo-C[2] = PL-PERS.NroDocId
            w-report.Campo-D[1] = PL-FLG-MES.FecIng
            w-report.Campo-C[3] = PL-FLG-MES.Seccion.

    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 215 THEN DO:       /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
            w-report.Campo-F[3] = w-report.Campo-F[3] + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.
/* Liquidacion */
FOR EACH PL-MOV-MES NO-LOCK WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 05 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                  /* Liq Acumulada */
    PL-MOV-MES.CodMov = 139 OR                                     /* Gratificacion Trunca */
     PL-MOV-MES.CodMov = 215)                                   /* Quinta Categoria */
    , FIRST pl-pers OF pl-mov-mes NO-LOCK
    , FIRST pl-flg-mes OF pl-mov-mes NO-LOCK:
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
        ASSIGN                                            
            w-report.Campo-C[1] = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper     
            w-report.Campo-C[2] = PL-PERS.NroDocId
            w-report.Campo-D[1] = PL-FLG-MES.FecIng
            w-report.Campo-C[3] = PL-FLG-MES.Seccion.
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 215 THEN DO:       /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
            w-report.Campo-F[3] = w-report.Campo-F[3] + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.
/* Liquidacion de Eventuales */
FOR EACH PL-MOV-MES NO-LOCK WHERE
    PL-MOV-MES.CodCia = s-codcia AND
    PL-MOV-MES.Periodo = COMBO-BOX-Periodo AND
    (PL-MOV-MES.NroMes >= 1 AND PL-MOV-MES.NroMes <= 12) AND    /* Todo el año */
    PL-MOV-MES.CodPln = 01 AND                                  /* Planilla Empleados*/
    PL-MOV-MES.CodCal = 08 AND                                  /* Cálculo */
    PL-MOV-MES.CodPer <> "" AND                                 /* Todos los Empl */
    (PL-MOV-MES.CodMov = 431 OR                                 /* Acumu. Vacaciones */
    PL-MOV-MES.CodMov = 611 OR                                    /* Gratificacion Trunca */
     PL-MOV-MES.CodMov = 215)                                   /* Quinta categoria */
    , FIRST pl-pers OF pl-mov-mes NO-LOCK
    , FIRST pl-flg-mes OF pl-mov-mes NO-LOCK:
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
        ASSIGN                                            
            w-report.Campo-C[1] = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper 
            w-report.Campo-C[2] = PL-PERS.NroDocId
            w-report.Campo-D[1] = PL-FLG-MES.FecIng
            w-report.Campo-C[3] = PL-FLG-MES.Seccion.
    END.
    CASE PL-MOV-MES.CodMov:
        WHEN 215 THEN DO:       /* ACUMULAMOS DESCUENTO POR QUINTA CATEGORIA */
            w-report.Campo-F[3] = w-report.Campo-F[3] + PL-MOV-MES.ValCal-Mes.
        END.
        OTHERWISE DO:
            w-report.Campo-F[1] = w-report.Campo-F[1] + PL-MOV-MES.ValCal-Mes.
            total_ingresos = total_ingresos + PL-MOV-MES.ValCal-Mes.
        END.
    END CASE.
END.

IF COMBO-Seccion <> 'Todas' THEN DO:
    FOR EACH w-report WHERE w-report.task-no = s-task-no
        AND w-report.llave-c = s-user-id
        AND w-report.campo-c[3] <> COMBO-Seccion:
        DELETE w-report.
    END.
END.
*/

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

