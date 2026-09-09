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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Periodo BUTTON-1 x-NroMes-1 ~
BUTTON-2 x-NroMes-2 TOGGLE-1 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 ~
TOGGLE-1 

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

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.35.

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

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Solo resumen anual" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Periodo AT ROW 1.27 COL 19 COLON-ALIGNED
     BUTTON-1 AT ROW 1.38 COL 50
     x-NroMes-1 AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-2 AT ROW 3.12 COL 50
     x-NroMes-2 AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 4
     TOGGLE-1 AT ROW 4.5 COL 21
     BUTTON-3 AT ROW 4.77 COL 50 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 6.27
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
         TITLE              = "Resumen de Planillas Anual por Centro de Costo"
         HEIGHT             = 6.27
         WIDTH              = 71.86
         MAX-HEIGHT         = 6.27
         MAX-WIDTH          = 71.86
         VIRTUAL-HEIGHT     = 6.27
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Resumen de Planillas Anual por Centro de Costo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Resumen de Planillas Anual por Centro de Costo */
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
  ASSIGN COMBO-BOX-Periodo TOGGLE-1 x-NroMes-1 x-NroMes-2.
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
    ASSIGN COMBO-BOX-Periodo TOGGLE-1 x-NroMes-1 x-NroMes-2.
    IF TOGGLE-1 = NO
    THEN RUN Excel-1.
    ELSE RUN Excel-2.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
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
            FIRST PL-FLG-MES OF PL-MOV-MES NO-LOCK:
        DISPLAY pl-mov-mes.codper @ Fi-Mensaje LABEL "Personal "
             FORMAT "X(11)" 
             WITH FRAME F-Proceso.
        FIND w-report WHERE w-report.task-no = s-task-no 
            AND w-report.Llave-C = PL-FLG-MES.CCosto
            AND w-report.Llave-I = x-NroMes EXCLUSIVE-LOCK NO-ERROR.        
        IF NOT AVAILABLE w-report
        THEN CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.Llave-C = PL-FLG-MES.CCosto
            w-report.Llave-I = x-nromes
            w-report.Campo-C[1] = ENTRY(x-NroMes, x-Meses).
        CASE PL-MOV-MES.codcal:
            WHEN 001 THEN DO:           /* Planilla de sueldos */
                CASE PL-MOV-MES.codmov:
                    WHEN 101 THEN campo-f[1] = campo-f[1] + PL-MOV-MES.valcal-mes.
                    WHEN 136 THEN campo-f[2] = campo-f[2] + PL-MOV-MES.valcal-mes.
                    WHEN 103 THEN campo-f[3] = campo-f[3] + PL-MOV-MES.valcal-mes.
                    WHEN 125 OR WHEN 126 OR WHEN 127
                        THEN campo-f[4] = campo-f[4] + PL-MOV-MES.valcal-mes.
                    WHEN 209 THEN campo-f[5] = campo-f[5] + PL-MOV-MES.valcal-mes.
                    WHEN 131 THEN campo-f[6] = campo-f[6] + PL-MOV-MES.valcal-mes.
                    WHEN 134 OR WHEN 138 OR WHEN 116
                        THEN campo-f[7] = campo-f[7] + PL-MOV-MES.valcal-mes.
                    WHEN 139 THEN campo-f[8] = campo-f[8] + PL-MOV-MES.valcal-mes.
                    WHEN 106 OR WHEN 107 OR WHEN 108
                        THEN campo-f[9] = campo-f[9] + PL-MOV-MES.valcal-mes.
                    WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-MES.valcal-mes.
                    WHEN 221 OR WHEN 222 OR WHEN 225
                        THEN campo-f[11] = campo-f[11] + PL-MOV-MES.valcal-mes.
                    WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-MES.valcal-mes.
                    WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-MES.valcal-mes.
                    WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-MES.valcal-mes.
                    WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-MES.valcal-mes.
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-MES.valcal-mes.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                CASE PL-MOV-MES.codmov:
                    WHEN 212 THEN campo-f[8] = campo-f[8] + PL-MOV-MES.valcal-mes.
                    WHEN 202 THEN campo-f[10] = campo-f[10] + PL-MOV-MES.valcal-mes.
                    WHEN 221 OR WHEN 222 OR WHEN 225
                        THEN campo-f[11] = campo-f[11] + PL-MOV-MES.valcal-mes.
                    WHEN 215 THEN campo-f[12] = campo-f[12] + PL-MOV-MES.valcal-mes.
                    WHEN 227 THEN campo-f[13] = campo-f[13] + PL-MOV-MES.valcal-mes.
                    WHEN 204 THEN campo-f[14] = campo-f[14] + PL-MOV-MES.valcal-mes.
                    WHEN 207 THEN campo-f[15] = campo-f[15] + PL-MOV-MES.valcal-mes.
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-MES.valcal-mes.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
        END CASE.            
    END.
  END.            
  HIDE FRAME F-PROCESO.
  
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
            FIRST PL-FLG-MES OF PL-MOV-MES NO-LOCK:
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
                    WHEN 101 THEN campo-f[1] = campo-f[1] + PL-MOV-MES.valcal-mes.
                    WHEN 136 THEN campo-f[2] = campo-f[2] + PL-MOV-MES.valcal-mes.
                    WHEN 103 THEN campo-f[3] = campo-f[3] + PL-MOV-MES.valcal-mes.
                    WHEN 125 OR WHEN 127 THEN campo-f[4] = campo-f[4] + PL-MOV-MES.valcal-mes.
                    WHEN 126 THEN campo-f[5] = campo-f[5] + PL-MOV-MES.valcal-mes.
                    WHEN 131 THEN campo-f[6] = campo-f[6] + PL-MOV-MES.valcal-mes.
                    WHEN 134 THEN campo-f[7] = campo-f[7] + PL-MOV-MES.valcal-mes.
                    WHEN 139 OR WHEN 212 THEN campo-f[8] = campo-f[8] + PL-MOV-MES.valcal-mes.
                    WHEN 106 OR WHEN 107 OR WHEN 108 THEN campo-f[9] = campo-f[9] + PL-MOV-MES.valcal-mes.
                    WHEN 138 THEN campo-f[10] = campo-f[10] + PL-MOV-MES.valcal-mes.
                    WHEN 116 THEN campo-f[11] = campo-f[11] + PL-MOV-MES.valcal-mes.
                    WHEN 401 THEN campo-f[12] = campo-f[12] + PL-MOV-MES.valcal-mes.    /* BOLSA */
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-MES.valcal-mes.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
            WHEN 004 THEN DO:           /* Planilla de Gratificaciones */
                CASE PL-MOV-MES.codmov:
                    WHEN 301 THEN campo-f[16] = campo-f[16] + PL-MOV-MES.valcal-mes.
                    WHEN 305 THEN campo-f[17] = campo-f[17] + PL-MOV-MES.valcal-mes.
                END CASE.
            END.
        END CASE.            
    END.
  END.            
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    w-report.campo-f[12] = w-report.campo-f[12] - ( w-report.campo-f[1] + w-report.campo-f[2] +
                            w-report.campo-f[3] + w-report.campo-f[4] + w-report.campo-f[5] +
                            w-report.campo-f[6] + w-report.campo-f[7] + w-report.campo-f[8] +
                            w-report.campo-f[9] + w-report.campo-f[10] + w-report.campo-f[11] ).
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
  DISPLAY COMBO-BOX-Periodo x-NroMes-1 x-NroMes-2 TOGGLE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-Periodo BUTTON-1 x-NroMes-1 BUTTON-2 x-NroMes-2 TOGGLE-1 
         BUTTON-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-1 W-Win 
PROCEDURE Excel-1 :
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

    RUN Carga-Temporal.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Centro Costo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Basico".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Reintegros".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Asig. Familiar".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "H. Extras Simples".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "H. Extras Dobles".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Incentivo".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Bonif. especial".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Grat. Jul/Dic".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vacaciones".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Asig. Extraordinaria".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Refig. y Movil.".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Otros".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Ingresos".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "ESSALUD".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "IESS".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Gastos".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total".
    iCount = iCount + 1.


    FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no BY w-report.llave-c BY w-report.llave-i:
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
      END.
      iCount = iCount + 1.
      cColumn = STRING(iCount).
      cRange = "A" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.llave-c + ' - ' + x-Descrip.
      ASSIGN
          x-TotIng = w-report.campo-f[1] + w-report.campo-f[2] + w-report.campo-f[3] +
                  w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                  w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9] +
                  w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12]
          x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
          x-NetPag = x-TotIng + x-TotGto.
      ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE x-toting (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE x-totgto (TOTAL BY w-report.task-no BY w-report.llave-c).
      ACCUMULATE x-netpag (TOTAL BY w-report.task-no BY w-report.llave-c).
      cRange = "B" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-c[1].
      cRange = "C" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
      cRange = "D" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
      cRange = "E" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[3].
      cRange = "F" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[4].
      cRange = "G" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[5].
      cRange = "H" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[6].
      cRange = "I" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[7].
      cRange = "J" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[8].
      cRange = "K" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[9].
      cRange = "L" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[10].
      cRange = "M" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[11].
      cRange = "N" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[12].
      cRange = "O" + cColumn.
      chWorkSheet:Range(cRange):Value = x-TotIng.
      cRange = "P" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[16].
      cRange = "Q" + cColumn.
      chWorkSheet:Range(cRange):Value = w-report.campo-f[17].
      cRange = "R" + cColumn.
      chWorkSheet:Range(cRange):Value = x-totgto.
      cRange = "S" + cColumn.
      chWorkSheet:Range(cRange):Value = x-netpag.
      IF LAST-OF(w-report.llave-c) THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[1].
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[2].
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[3].
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[4].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[5].
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[6].
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[7].
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[8].
          cRange = "K" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[9].
          cRange = "L" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[10].
          cRange = "M" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[11].
          cRange = "N" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[12].
          cRange = "O" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c x-toting.
          cRange = "P" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[16].
          cRange = "Q" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c w-report.campo-f[17].
          cRange = "R" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c x-totgto.
          cRange = "S" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-c x-netpag.
          iCount = iCount + 1.
      END.
      IF LAST-OF(w-report.task-no)
      THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[1].
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[2].
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[3].
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[4].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[5].
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[6].
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[7].
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[8].
          cRange = "K" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[9].
          cRange = "L" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[10].
          cRange = "M" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[11].
          cRange = "N" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[12].
          cRange = "O" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-toting.
          cRange = "P" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[16].
          cRange = "Q" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[17].
          cRange = "R" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-totgto.
          cRange = "S" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-netpag.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
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

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Mes".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Basico".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Reintegros".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Asig. Familiar".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "H. Extras Simples".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "H. Extras Dobles".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Incentivo".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Bonif. especial".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Grat. Jul/Dic".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Vacaciones".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Asig. Extraordinaria".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Refig. y Movil.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Otros".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Ingresos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "ESSALUD".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "IESS".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total Gastos".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "Total".
    iCount = iCount + 1.


    FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no BY w-report.llave-i:
      ASSIGN
          x-TotIng = w-report.campo-f[1] + w-report.campo-f[2] + w-report.campo-f[3] +
                  w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                  w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9] +
                  w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12]
          x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
          x-NetPag = x-TotIng + x-TotGto.
      ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE x-toting (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE x-totgto (TOTAL BY w-report.task-no BY w-report.llave-I).
      ACCUMULATE x-netpag (TOTAL BY w-report.task-no BY w-report.llave-I).
      IF LAST-OF(w-report.llave-I) THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = w-report.campo-C[1].
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[1].
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[2].
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[3].
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[4].
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[5].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[6].
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[7].
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[8].
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[9].
          cRange = "K" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[10].
          cRange = "L" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[11].
          cRange = "M" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[12].
          cRange = "N" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I x-toting.
          cRange = "O" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[16].
          cRange = "P" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I w-report.campo-f[17].
          cRange = "Q" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I x-totgto.
          cRange = "R" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.llave-I x-netpag.
          iCount = iCount + 1.
      END.
      IF LAST-OF(w-report.task-no)
      THEN DO:
          iCount = iCount + 1.
          cColumn = STRING(iCount).
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[1].
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[2].
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[3].
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[4].
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[5].
          cRange = "G" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[6].
          cRange = "H" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[7].
          cRange = "I" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[8].
          cRange = "J" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[9].
          cRange = "K" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[10].
          cRange = "L" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[11].
          cRange = "M" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[12].
          cRange = "N" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-toting.
          cRange = "O" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[16].
          cRange = "P" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no w-report.campo-f[17].
          cRange = "Q" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-totgto.
          cRange = "R" + cColumn.
          chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY w-report.task-no x-netpag.
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
    w-report.campo-c[1] FORMAT 'x(10)' 
    w-report.campo-f[1] FORMAT '>>>>>>9.99' 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' 
    w-report.campo-f[3] FORMAT '>>>>>>9.99' 
    w-report.campo-f[4] FORMAT '>>>>>>9.99' 
    w-report.campo-f[5] FORMAT '>>>>>>9.99' 
    w-report.campo-f[6] FORMAT '>>>>>>9.99' 
    w-report.campo-f[7] FORMAT '>>>>>>9.99' 
    w-report.campo-f[8] FORMAT '>>>>>>9.99' 
    w-report.campo-f[9] FORMAT '>>>>>>9.99' 
    w-report.campo-f[10] FORMAT '>>>>>>9.99' 
    w-report.campo-f[11] FORMAT '>>>>>>9.99' 
    w-report.campo-f[12] FORMAT '>>>>>>9.99' 
    x-TotIng            FORMAT '>>>>>>9.99' 
    w-report.campo-f[16] FORMAT '>>>>>>9.99'
    w-report.campo-f[17] FORMAT '>>>>>>9.99'
    x-TotGto            FORMAT '>>>>>>9.99' 
    x-NetPag            FORMAT '>>>>>>9.99' 
    WITH WIDTH 230 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "RESUMEN DE PLANILLAS POR CENTRO DE COSTO EMPLEADOS"  AT 100 FORMAT 'x(60)'
        {&PRN4} + {&PRN6B} + "Pag.  : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
       "                                     Asign.  H. Extras  H. Extras              Bonific.      Grat.                Asign.  Refrig. y                 Total                            Total           " SKIP 
       "Mes        Basico     Reintegros   Familiar    Simples     Dobles  Incentivo   Especial  Jul./Dic.  Vacaciones Extraord.  Movilidad      Otros   Ingresos    ESSALUD       IESS     Gastos      Total" SKIP
       "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                 1         2         3         4         5         6         7         8         9        10        11        12        14        15        16        17        18        19        20        21        22        23
        1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        1234567890 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99
*/
    WITH PAGE-TOP WIDTH 230 NO-BOX NO-LABELS STREAM-IO DOWN.
 
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
                w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12]
        x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
        x-NetPag = x-TotIng + x-TotGto.
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE x-totgto (TOTAL BY w-report.task-no BY w-report.llave-c).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no BY w-report.llave-c).
    DISPLAY STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        x-toting
        w-report.campo-f[16]
        w-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
    IF LAST-OF(w-report.llave-c)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        x-toting
        w-report.campo-f[16]
        w-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "SUB-TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.llave-c x-toting @ x-toting
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.llave-c w-report.campo-f[17] @ w-report.campo-f[17]
            ACCUM TOTAL BY w-report.llave-c x-totgto @ x-totgto
            ACCUM TOTAL BY w-report.llave-c x-netpag @ x-netpag
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        x-toting
        w-report.campo-f[16]
        w-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            ACCUM TOTAL BY w-report.task-no x-totgto @ x-totgto
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
            WITH FRAME F-REPORTE.
    END.
  END.

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
  DEF VAR x-TotIng AS DEC NO-UNDO.
  DEF VAR x-TotGto AS DEC NO-UNDO.
  DEF VAR x-NetPag AS DEC NO-UNDO.
  DEF VAR x-Descrip AS CHAR FORMAT 'x(40)' NO-UNDO.
  
  DEFINE FRAME F-REPORTE
    w-report.campo-c[1] FORMAT 'x(10)' 
    w-report.campo-f[1] FORMAT '>>>>>>9.99' 
    w-report.campo-f[2] FORMAT '>>>>>>9.99' 
    w-report.campo-f[3] FORMAT '>>>>>>9.99' 
    w-report.campo-f[4] FORMAT '>>>>>>9.99' 
    w-report.campo-f[5] FORMAT '>>>>>>9.99' 
    w-report.campo-f[6] FORMAT '>>>>>>9.99' 
    w-report.campo-f[7] FORMAT '>>>>>>9.99' 
    w-report.campo-f[8] FORMAT '>>>>>>9.99' 
    w-report.campo-f[9] FORMAT '>>>>>>9.99' 
    w-report.campo-f[10] FORMAT '>>>>>>9.99' 
    w-report.campo-f[11] FORMAT '>>>>>>9.99' 
    w-report.campo-f[12] FORMAT '>>>>>>9.99' 
    x-TotIng            FORMAT '>>>>>>9.99' 
    w-report.campo-f[16] FORMAT '>>>>>>9.99'
    w-report.campo-f[17] FORMAT '>>>>>>9.99'
    x-TotGto            FORMAT '>>>>>>9.99' 
    x-NetPag            FORMAT '>>>>>>9.99' 
    WITH WIDTH 230 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  DEFINE FRAME F-HEADER       
    HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(45)" SKIP
        {&PRN6A} + "RESUMEN DE PLANILLAS POR CENTRO DE COSTO EMPLEADOS"  AT 100 FORMAT 'x(60)'
        {&PRN4} + {&PRN6B} + "Pag.  : " AT 200 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN4} + "Fecha : " AT 200 STRING(TODAY,"99/99/9999") + {&PRN6B} + {&PRND} FORMAT "X(12)" 
        "Hora  : " AT 200 STRING(TIME,"HH:MM:SS") SKIP
        s-Titulo FORMAT 'x(50)' SKIP
       "                                     Asign.  H. Extras  H. Extras              Bonific.      Grat.                Asign.  Refrig. y                 Total                            Total           " SKIP 
       "Mes        Basico     Reintegros   Familiar    Simples     Dobles  Incentivo   Especial  Jul./Dic.  Vacaciones Extraord.  Movilidad      Otros   Ingresos    ESSALUD       IESS     Gastos      Total" SKIP
       "-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                 1         2         3         4         5         6         7         8         9        10        11        12        14        15        16        17        18        19        20        21        22        23
        1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        1234567890 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99 >>>>>>9.99
*/
    WITH PAGE-TOP WIDTH 230 NO-BOX NO-LABELS STREAM-IO DOWN.
 
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.task-no BY w-report.llave-i:
    VIEW STREAM REPORT FRAME F-HEADER.
    ASSIGN
        x-TotIng = w-report.campo-f[1] + w-report.campo-f[2] + w-report.campo-f[3] +
                w-report.campo-f[4] + w-report.campo-f[5] + w-report.campo-f[6] +
                w-report.campo-f[7] + w-report.campo-f[8] + w-report.campo-f[9] +
                w-report.campo-f[10] + w-report.campo-f[11] + w-report.campo-f[12]
        x-TotGto = w-report.campo-f[16] + w-report.campo-f[17]
        x-NetPag = x-TotIng + x-TotGto.
    ACCUMULATE w-report.campo-f[1] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[2] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[3] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[4] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[5] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[6] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[7] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[8] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[9] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[10] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[11] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[12] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[16] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE w-report.campo-f[17] (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE x-toting (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE x-totgto (TOTAL BY w-report.task-no BY w-report.llave-i).
    ACCUMULATE x-netpag (TOTAL BY w-report.task-no BY w-report.llave-i).
    IF LAST-OF(w-report.llave-i)
    THEN DO:
        DISPLAY STREAM REPORT
            w-report.campo-c[1]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.llave-i x-toting @ x-toting
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.llave-i w-report.campo-f[17] @ w-report.campo-f[17]
            ACCUM TOTAL BY w-report.llave-i x-totgto @ x-totgto
            ACCUM TOTAL BY w-report.llave-i x-netpag @ x-netpag
            WITH FRAME F-REPORTE.
    END.
    IF LAST-OF(w-report.task-no)
    THEN DO:
        UNDERLINE STREAM REPORT
        w-report.campo-c[1] 
        w-report.campo-f[1] 
        w-report.campo-f[2] 
        w-report.campo-f[3] 
        w-report.campo-f[4] 
        w-report.campo-f[5] 
        w-report.campo-f[6] 
        w-report.campo-f[7] 
        w-report.campo-f[8] 
        w-report.campo-f[9] 
        w-report.campo-f[10]
        w-report.campo-f[11]
        w-report.campo-f[12]
        x-toting
        w-report.campo-f[16]
        w-report.campo-f[17]
        x-totgto
        x-netpag
        WITH FRAME F-REPORTE.
        
        DISPLAY STREAM REPORT
            "TOTAL" @ w-report.campo-c[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[1] @ w-report.campo-f[1]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[2] @ w-report.campo-f[2]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[3] @ w-report.campo-f[3]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[4] @ w-report.campo-f[4]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[5] @ w-report.campo-f[5]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[6] @ w-report.campo-f[6]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[7] @ w-report.campo-f[7]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[8] @ w-report.campo-f[8]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[9] @ w-report.campo-f[9]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[10] @ w-report.campo-f[10]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[11] @ w-report.campo-f[11]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[12] @ w-report.campo-f[12]
            ACCUM TOTAL BY w-report.task-no x-toting @ x-toting
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[16] @ w-report.campo-f[16]
            ACCUM TOTAL BY w-report.task-no w-report.campo-f[17] @ w-report.campo-f[17]
            ACCUM TOTAL BY w-report.task-no x-totgto @ x-totgto
            ACCUM TOTAL BY w-report.task-no x-netpag @ x-netpag
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
    DEF VAR x-Meses AS CHAR INIT 'ENERO,FEBRERO,MARZO,ABRIL,MAYO,JUNIO,JULIO,AGOSTO,SETIEMBRE,OCTUBRE,NOVIEMBRE,DICIEMBRE'.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF TOGGLE-1 = YES
    THEN RUN Carga-Temporal-1.
    ELSE RUN Carga-Temporal.

    FIND FIRST w-report WHERE w-report.task-no = s-task-no 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report
    THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
    s-Titulo = 'RESUMEN DE ' + ENTRY(x-NroMes-1, x-Meses) +
        ' A ' + ENTRY(x-NroMes-2, x-Meses) +
        ' DEL ' + STRING(COMBO-BOX-Periodo, '9999').

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        IF TOGGLE-1 = NO
        THEN RUN Formato-1.
        ELSE RUN Formato-2.
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

