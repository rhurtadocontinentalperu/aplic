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
x-Meses = '01'.
DO i = 2 TO 12:
    x-Meses = x-Meses + ',' + STRING(i, '99').
END.

/* VARIABLES DE IMPRESION */
DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS F-Codpln BUTTON-3 COMBO-BOX-Periodo BUTTON-1 ~
COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS F-Codpln F-NomPla COMBO-BOX-Periodo ~
COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 

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
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 3" 
     SIZE 15 BY 1.5 TOOLTIP "Salida a archivo".

DEFINE VARIABLE COMBO-BOX-Mes-1 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Desde el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Mes-2 AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Hasta el mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE F-Codpln AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Planilla" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE F-NomPla AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Codpln AT ROW 1.38 COL 10 COLON-ALIGNED
     F-NomPla AT ROW 1.38 COL 16 COLON-ALIGNED NO-LABEL
     BUTTON-3 AT ROW 1.38 COL 43
     COMBO-BOX-Periodo AT ROW 2.35 COL 10 COLON-ALIGNED
     BUTTON-1 AT ROW 3.12 COL 43
     COMBO-BOX-Mes-1 AT ROW 3.31 COL 10 COLON-ALIGNED
     COMBO-BOX-Mes-2 AT ROW 4.27 COL 10 COLON-ALIGNED
     BUTTON-2 AT ROW 4.85 COL 43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 5.92
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
         TITLE              = "Reporte de Empleados Cesados"
         HEIGHT             = 5.92
         WIDTH              = 71.86
         MAX-HEIGHT         = 5.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 5.92
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN F-NomPla IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Empleados Cesados */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Empleados Cesados */
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
            F-Codpln
            COMBO-BOX-Periodo
            COMBO-BOX-Mes-1
            COMBO-BOX-Mes-2.
        FIND Pl-plan WHERE Pl-plan.Codpln = F-Codpln NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Pl-plan THEN DO:
            MESSAGE
                "Código de planilla no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Codpln.
            RETURN NO-APPLY.
        END.
        F-NomPla = Pl-plan.despln.
        DISPLAY F-Codpln F-Nompla.
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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            F-Codpln
            COMBO-BOX-Periodo
            COMBO-BOX-Mes-1
            COMBO-BOX-Mes-2.
        FIND Pl-plan WHERE Pl-plan.Codpln = F-Codpln NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Pl-plan THEN DO:
            MESSAGE
                "Código de planilla no existe"
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Codpln.
            RETURN NO-APPLY.
        END.
        F-NomPla = Pl-plan.despln.
        DISPLAY F-Codpln F-Nompla.
    END.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Codpln
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Codpln W-Win
ON MOUSE-SELECT-DBLCLICK OF F-Codpln IN FRAME F-Main /* Planilla */
OR F8 OF F-Codpln
DO:
 DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-PLAN.w (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
       FIND pl-plan WHERE ROWID(pl-plan) = reg-act NO-LOCK NO-ERROR.
       ASSIGN
       F-Codpln = pl-plan.codpln 
       F-Nompla = pl-plan.Despln.
       DISPLAY F-Codpln F-Nompla.       
    END.  
  END.
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
  DISPLAY F-Codpln F-NomPla COMBO-BOX-Periodo COMBO-BOX-Mes-1 COMBO-BOX-Mes-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-Codpln BUTTON-3 COMBO-BOX-Periodo BUTTON-1 COMBO-BOX-Mes-1 
         COMBO-BOX-Mes-2 BUTTON-2 
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

    DEFINE VARIABLE cNomAux AS CHARACTER NO-UNDO.

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountReg          AS INTEGER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE EMPLEADOS CESADOS".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        "DESDE EL MES " + STRING(COMBO-BOX-Mes-1,">9") +
        " HASTA EL MES " + STRING(COMBO-BOX-Mes-2,">9") +
        " DEL PERIODO " + STRING(COMBO-BOX-Periodo,"9999").
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "CÓDIGO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA INGRESO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA CESE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "MES".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "CENTRO COSTO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CARGO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO PATERNO".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDO MATERNO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRES".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "DNI".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("J"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 8.
    chWorkSheet:Columns("E"):ColumnWidth = 30.
    chWorkSheet:Columns("F"):ColumnWidth = 30.
    chWorkSheet:Columns("G"):ColumnWidth = 30.
    chWorkSheet:Columns("H"):ColumnWidth = 30.
    chWorkSheet:Columns("I"):ColumnWidth = 30.
    chWorkSheet:Columns("J"):ColumnWidth = 10.
    chWorkSheet:Range("A1:J3"):Font:Bold = TRUE.

    FOR EACH pl-flg-mes NO-LOCK WHERE
        pl-flg-mes.codcia = s-codcia AND
        pl-flg-mes.codpln = f-codpln AND
        pl-flg-mes.periodo = COMBO-BOX-Periodo AND
        pl-flg-mes.nromes >= COMBO-BOX-Mes-1 AND
        pl-flg-mes.nromes <= COMBO-BOX-Mes-2 AND
        pl-flg-mes.vcontr <> ? AND
        MONTH(pl-flg-mes.vcontr) >= COMBO-BOX-Mes-1 AND
        MONTH(pl-flg-mes.vcontr) <= COMBO-BOX-Mes-2 AND
        pl-flg-mes.situacion = "13",
        FIRST pl-pers OF pl-flg-mes NO-LOCK:
        FIND cb-auxi WHERE
            cb-auxi.codcia = cb-codcia AND
            cb-auxi.clfaux = "CCO" AND
            cb-auxi.codaux = pl-flg-mes.ccosto
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
        ELSE cNomAux = "".

        iCountReg = iCountReg + 1.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.codper.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.fecing.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.vcontr.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.nromes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = cNomAux.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-flg-mes.cargos.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.patper.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.matper.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = pl-pers.nomper.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = INTEGRAL.PL-PERS.NroDocId.
        DISPLAY
            pl-flg-mes.codper @ FI-MENSAJE LABEL "    Personal"
            WITH FRAME F-PROCESO.        
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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

  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'pln/reporte.prl'.
  RB-REPORT-NAME = 'Cesados Empleados'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = 'pl-flg-mes.codcia = ' + STRING(s-codcia) +
                ' AND pl-flg-mes.codpln = ' + STRING(f-codpln) + 
                ' AND pl-flg-mes.periodo = ' + STRING(COMBO-BOX-Periodo) + 
                ' AND pl-flg-mes.nromes >= ' + STRING(COMBO-BOX-Mes-1) +
                ' AND pl-flg-mes.nromes <= ' + STRING(COMBO-BOX-Mes-2) +
                ' AND pl-flg-mes.vcontr <> ?' + 
                ' AND MONTH(pl-flg-mes.vcontr) >= ' + STRING(COMBO-BOX-Mes-1) +
                ' AND MONTH(pl-flg-mes.vcontr) <= ' + STRING(COMBO-BOX-Mes-2) +
                ' AND pl-flg-mes.situacion = "13"'.
  RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia +
                        '~ns-periodo = ' + STRING(COMBO-BOX-Periodo) +
                        '~ns-nromes-1 = ' + STRING(COMBO-BOX-Mes-1) +
                        '~ns-nromes-2 = ' + STRING(COMBO-BOX-Mes-2).
  RUN lib/_Imprime2(RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

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
        COMBO-BOX-Mes-1:LIST-ITEMS = x-Meses
        COMBO-BOX-Mes-2:LIST-ITEMS = x-Meses
        COMBO-BOX-Periodo = s-periodo 
        COMBO-BOX-Mes-1 = s-nromes
        COMBO-BOX-Mes-2 = s-nromes
        F-Codpln = 01 .
    FIND Pl-plan WHERE Pl-plan.Codpln = F-Codpln NO-LOCK NO-ERROR.
    IF AVAILABLE Pl-plan THEN F-NomPla = Pl-plan.despln.    
    DISPLAY F-Codpln F-Nompla.    
        
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

