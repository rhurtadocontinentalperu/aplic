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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR cb-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEF VAR x-Periodo AS CHAR NO-UNDO.
DEF VAR x-Meses   AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = ''
THEN DO:
    MESSAGE 'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-Titulo  AS CHAR NO-UNDO.

DEF TEMP-TABLE w-report
    FIELD task-no AS INT
    FIELD Llave-I AS INT
    FIELD Llave-C AS CHAR
    FIELD Campo-C AS CHAR EXTENT 10
    FIELD Campo-F AS DEC  EXTENT 20
    INDEX Llave01 AS PRIMARY task-no Llave-I.

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
    SIDE-LABELS NO-UNDERLINE
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 ~
FILL-IN-CCosto BUTTON-1 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 ~
FILL-IN-CCosto FILL-IN-NomAux 

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
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes-1 AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes-2 AS INTEGER FORMAT "99":U INITIAL 12 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CCosto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.58 COL 19 COLON-ALIGNED
     x-NroMes-1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-NroMes-2 AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-CCosto AT ROW 4.77 COL 19 COLON-ALIGNED
     FILL-IN-NomAux AT ROW 4.77 COL 27 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 6.38 COL 3
     BUTTON-2 AT ROW 6.38 COL 19
     BUTTON-3 AT ROW 6.38 COL 35 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 7.77
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
         TITLE              = "CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO"
         HEIGHT             = 7.77
         WIDTH              = 71.86
         MAX-HEIGHT         = 8.85
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 8.85
         VIRTUAL-WIDTH      = 71.86
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

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NomAux IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO */
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
  ASSIGN COMBO-BOX-Periodo FILL-IN-CCosto x-NroMes-1 x-NroMes-2.
  IF FILL-IN-CCosto <> ''
  THEN DO:
    FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = FILL-IN-CCosto
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = FILL-IN-CCosto
            NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-auxi
    THEN DO:
        MESSAGE 'Centro de costo no registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-CCosto.
        RETURN NO-APPLY.
    END.
  END.
  RUN Imprimir.
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
    ASSIGN COMBO-BOX-Periodo FILL-IN-CCosto x-NroMes-1 x-NroMes-2.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CCosto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CCosto W-Win
ON LEAVE OF FILL-IN-CCosto IN FRAME F-Main /* Centro de Costo */
DO:
  FILL-IN-NomAux:SCREEN-VALUE = ''.
  FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
    AND cb-auxi.clfaux = 'CCO'
    AND cb-auxi.codaux = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-auxi
  THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = SELF:SCREEN-VALUE
            NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi
  THEN FILL-IN-NomAux:SCREEN-VALUE = cb-auxi.nomaux.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-NroMes AS INT NO-UNDO.
  DEF VAR x-Meses  AS CHAR NO-UNDO.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.

  x-Meses = 'ENE,FEB,MAR,ABR,MAY,JUN,JUL,AGO,SET,OCT,NOV,DIC'.
  /*DO x-NroMes = 01 TO 12:*/
  DO x-NroMes = x-NroMes-1 TO x-NroMes-2:
    FOR EACH PL-MOV-MES NO-LOCK WHERE codcia = s-codcia
            AND periodo = COMBO-BOX-Periodo
            AND nromes  = x-NroMes
            AND codpln  = 01,
            FIRST PL-FLG-MES OF PL-MOV-MES WHERE PL-FLG-MES.ccosto BEGINS FILL-IN-CCosto
            NO-LOCK:
        DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Personal "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
        FIND w-report WHERE w-report.task-no = s-task-no 
            AND w-report.Llave-I = x-NroMes 
            AND w-report.Llave-C = PL-FLG-MES.ccosto
            EXCLUSIVE-LOCK NO-ERROR.        
        IF NOT AVAILABLE w-report
        THEN CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.Llave-I = x-nromes
            w-report.Llave-C = PL-FLG-MES.ccosto
            w-report.Campo-C[1] = ENTRY(x-NroMes, x-Meses).
        CASE PL-MOV-MES.codcal:
            WHEN 001 THEN DO:           /* Planilla de sueldos */
                CASE PL-MOV-MES.codmov:
                    WHEN 401 THEN campo-f[1] = campo-f[1] + PL-MOV-MES.valcal-mes.
                    WHEN 406 THEN campo-f[1] = campo-f[1] + PL-MOV-MES.valcal-mes.
                    WHEN 101 OR WHEN 103 THEN campo-f[11] = campo-f[11] + PL-MOV-MES.valcal-mes.
                    WHEN 125 OR WHEN 126 OR WHEN 127 THEN campo-f[12] = campo-f[12] + PL-MOV-MES.valcal-mes.
                    WHEN 209 THEN campo-f[13] = campo-f[13] + PL-MOV-MES.valcal-mes.
                    WHEN 301 THEN campo-f[15] = campo-f[15] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                CASE PL-MOV-MES.codmov:
                    WHEN 406 THEN campo-f[1] = campo-f[1] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 009 THEN DO:           /* Planilla de CTS mensual */
                CASE PL-MOV-MES.codmov:
                    WHEN 403 THEN campo-f[2] = campo-f[2] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 010 THEN DO:           /* Planilla de prov. vac. truncas */
                CASE PL-MOV-MES.codmov:
                    WHEN 403 THEN campo-f[3] = campo-f[3] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 011 THEN DO:           /* Planilla de prov. grat. truncas */
                CASE PL-MOV-MES.codmov:
                    WHEN 403 THEN campo-f[4] = campo-f[4] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
        END CASE.            
    END.
  END.            
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    w-report.campo-f[10] = w-report.campo-f[1] + w-report.campo-f[2] + 
                            w-report.campo-f[3] + w-report.campo-f[4] + 
                            w-report.campo-f[15].
  END.
  HIDE FRAME F-PROCESO.
  
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
  DISPLAY COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 FILL-IN-CCosto FILL-IN-NomAux 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 FILL-IN-CCosto BUTTON-1 
         BUTTON-2 BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEF VAR x-TotIng AS DEC NO-UNDO.
    DEF VAR x-TotGto AS DEC NO-UNDO.
    DEF VAR x-NetPag AS DEC NO-UNDO.
    DEF VAR x-Descrip AS CHAR FORMAT 'x(40)' NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Carga-Temporal-1.

    FIND FIRST w-report WHERE w-report.task-no = s-task-no 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report
    THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    s-Titulo = 'DE ENERO A DICIEMBRE DEL ' + STRING(COMBO-BOX-Periodo, '9999').

    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".    

    /*Cabecera*/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO EMPLEADOS".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = s-Titulo.

    iCount = iCount + 3.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Sueldo".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "301".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total CTS".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Vacaciones Truncas".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Gratific Truncas".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total General".
    iCount = iCount + 1.

    FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no BY w-report.llave-c BY w-report.llave-i:      
      IF FIRST-OF(w-report.llave-c) THEN DO:
          FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
              AND cb-auxi.clfaux = 'CCO'
              AND cb-auxi.codaux = w-report.llave-c
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE cb-auxi
          THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
              AND cb-auxi.clfaux = 'CCO'
              AND cb-auxi.codaux = w-report.llave-c
              NO-LOCK NO-ERROR.
          IF AVAILABLE cb-auxi
          THEN x-Descrip = cb-auxi.nomaux.
          ELSE x-Descrip = ''.

          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = "CENTRO DE COSTO: " + w-report.llave-c + " " + x-Descrip.          
      END.
      ASSIGN
          x-TotIng = w-report.campo-f[1] + w-report.campo-f[2] + w-report.campo-f[3] +
                  w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                  w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9] +
                  w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                  w-report.campo-f[15]
          x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
          x-NetPag = x-TotIng + x-TotGto.
      ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no BY w-report.llave-c).

      iCount = iCount + 1.
      cColumn = STRING(iCount).
      cRange = "A" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-c[1].
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[15].
      cRange = "D" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
      cRange = "E" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[3].
      cRange = "F" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[4].
      cRange = "G" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[10].

      IF LAST-OF(w-report.llave-c) THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = "-------------".
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".

          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[1].
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[15] .
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[2] .
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[3] .
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[4].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[10].

      END.
      IF LAST-OF(w-report.task-no) THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = "-------------".
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = "-----------------".

          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[1].
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] .
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] .
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] .
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[4].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[10].
          iCount = iCount + 1.
      END.
    END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.
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
  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotGto AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  DEF VAR x-Descrip AS CHAR FORMAT 'x(40)' NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] COLUMN-LABEL 'Mes'          FORMAT 'x(10)' 
    w-report.campo-f[1] COLUMN-LABEL 'Total!Sueldo' FORMAT '>>>>,>>9.99' 
    w-report.campo-f[15] COLUMN-LABEL 'Total!Sueldo' FORMAT '>>>>,>>9.99' 
    w-report.campo-f[2] COLUMN-LABEL 'Total!CTS'    FORMAT '>>>>,>>9.99' 
    w-report.campo-f[3] COLUMN-LABEL 'Total!Vacaciones!Truncas'         FORMAT '>>>>,>>9.99' 
    w-report.campo-f[4] COLUMN-LABEL 'Total!Gratificaciones!Truncas'    FORMAT '>>>>,>>9.99' 
    w-report.campo-f[10] COLUMN-LABEL 'Total!General'   FORMAT '>>>>,>>9.99' 
    WITH WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        S-NOMCIA FORMAT "X(45)" SKIP
        "CONSOLIDADO DE PLANILLAS POR CENTRO DE COSTO EMPLEADOS"  AT 10
        "Pag.  : " AT 75 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 75 STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        "Hora  : " AT 75 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
       "                                         Total       Total            " SKIP
       "                 Total                   Total  Vacaciones    Gratific.      Total" SKIP
       "Mes             Sueldo       301           CTS     Truncas     Truncas     General" SKIP
       "----------------------------------------------------------------------------------" SKIP
/*
                 1         2         3         4         5         6         8         9
        12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        1234567890 >>>>,>>9.99 >>>>,>99.99 >>>>,>>9.99 >>>>,>>9.99 >>>>,>>9.99 
*/
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no BY w-report.llave-c BY w-report.llave-i:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(w-report.llave-c)
    THEN DO:
        FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = w-report.llave-c
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi
        THEN FIND cb-auxi WHERE cb-auxi.codcia = s-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = w-report.llave-c
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi
        THEN x-Descrip = cb-auxi.nomaux.
        ELSE x-Descrip = ''.
        PUT STREAM REPORT
            " " SKIP
            "CENTRO DE COSTO: " w-report.llave-c SPACE x-Descrip SKIP
            "----------------" SKIP.
    END.
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9] +
                w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12] + 
                w-report.campo-f[15]    
        x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
        x-NetPag = x-TotIng + x-TotGto.
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[15] (TOTAL BY w-report.task-no BY w-report.llave-c).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[15] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[10]
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.llave-c)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[15] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[10]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "SUB-TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[10] @ w-report.campo-f[10]
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[15]
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[10]
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[15] @ w-report.campo-f[15]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            WITH FRAME F-REPORTE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal-1.

    FIND FIRST w-report WHERE w-report.task-no = s-task-no 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report
    THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    s-Titulo = 'DE ENERO A DICIEMBRE DEL ' + STRING(COMBO-BOX-Periodo, '9999').

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn2}.
        RUN Formato-1.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

    FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
    END.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-Periodo:LIST-ITEMS = x-Periodo
        COMBO-BOX-Periodo = s-periodo.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "FILL-IN-CCosto" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

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

