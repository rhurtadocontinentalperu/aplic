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

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE archivo AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-Periodo AS CHAR NO-UNDO.
DEFINE VARIABLE meses AS CHARACTER INITIAL
    "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".
    
DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorkbook AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWorksheet AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE iCountReg AS INTEGER NO-UNDO.
DEFINE VARIABLE cColumn AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.

DEFINE VARIABLE dVal AS DECIMAL EXTENT 100 NO-UNDO.
DEFINE VARIABLE iPeriodo LIKE PL-FLG-MES.Periodo NO-UNDO.
DEFINE VARIABLE iNroMes LIKE PL-FLG-MES.NroMes NO-UNDO.
DEFINE VARIABLE iMes-1 LIKE PL-FLG-MES.NroMes NO-UNDO.
DEFINE VARIABLE iMes-2 LIKE PL-FLG-MES.NroMes NO-UNDO.

RUN cbd/cb-m000 (OUTPUT x-Periodo).
IF x-Periodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" .

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
&Scoped-Define ENABLED-OBJECTS COMBO-Periodo COMBO-mes COMBO-seccion ~
COMBO-Reporte BUTTON-1 BUTTON-2 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-Periodo COMBO-mes COMBO-seccion ~
COMBO-Reporte 

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

DEFINE VARIABLE COMBO-mes AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero",1,
                     "Febrero",2,
                     "Marzo",3,
                     "Abril",4,
                     "Mayo",5,
                     "Junio",6,
                     "Julio",7,
                     "Agosto",8,
                     "Setiembre",9,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Reporte AS CHARACTER FORMAT "X(256)":U 
     LABEL "Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-seccion AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Sección" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY .04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-Periodo AT ROW 1.54 COL 14 COLON-ALIGNED
     COMBO-mes AT ROW 2.62 COL 14 COLON-ALIGNED WIDGET-ID 2
     COMBO-seccion AT ROW 3.69 COL 14 COLON-ALIGNED
     COMBO-Reporte AT ROW 4.77 COL 14 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 7.15 COL 30
     BUTTON-2 AT ROW 7.15 COL 46
     RECT-2 AT ROW 6.77 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.29 BY 8
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
         TITLE              = "Otros Reportes (Excel)"
         HEIGHT             = 8
         WIDTH              = 62.29
         MAX-HEIGHT         = 8
         MAX-WIDTH          = 62.29
         VIRTUAL-HEIGHT     = 8
         VIRTUAL-WIDTH      = 62.29
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
ON END-ERROR OF W-Win /* Otros Reportes (Excel) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Otros Reportes (Excel) */
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
            COMBO-periodo
            COMBO-mes
            COMBO-seccion
            COMBO-Reporte
            iCountReg = 0
            iCount = 1
            dVal = 0.
    END.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:ADD().
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    CASE COMBO-Reporte:
        WHEN "HojaCts" THEN RUN proc_Excel1.
        WHEN "HojaGrat" THEN RUN proc_Excel2.
    END CASE.

    chExcelApplication:VISIBLE = TRUE.
    RELEASE OBJECT chExcelApplication.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con Satisfactoriamente"
        VIEW-AS ALERT-BOX INFORMA.

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
  DISPLAY COMBO-Periodo COMBO-mes COMBO-seccion COMBO-Reporte 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-Periodo COMBO-mes COMBO-seccion COMBO-Reporte BUTTON-1 BUTTON-2 
         RECT-2 
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

   DEFINE VARIABLE lPto AS LOGICAL NO-UNDO.
   DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
   DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-Periodo:LIST-ITEMS = x-Periodo
            COMBO-Periodo = s-periodo
            COMBO-mes = s-NroMes.
        DO iInd = 1 TO NUM-ENTRIES(x-Periodo):
            IF ENTRY(iInd,x-Periodo) = "" THEN lPto = COMBO-Periodo:DELETE("").
        END.
        FOR EACH pl-secc NO-LOCK:
            IF pl-secc.seccion <> "" THEN
                COMBO-seccion:ADD-LAST(pl-secc.seccion).
        END.
        /* Configuración de Reportes */
        FOR EACH PL-CFG-RPT WHERE
            PL-CFG-RPT.TpoRpt = 2 AND
            LOOKUP(PL-CFG-RPT.codrep,"HojaCts,HojaGrat") > 0 NO-LOCK:
            IF cListItems = "" THEN cListItems = PL-CFG-RPT.desrep + "," + PL-CFG-RPT.codrep.
            ELSE cListItems = cListItems + "," + PL-CFG-RPT.desrep + "," + PL-CFG-RPT.codrep.
        END.
        IF cListItems <> "" THEN DO:
            COMBO-Reporte = ENTRY(2,cListItems).
            COMBO-Reporte:LIST-ITEM-PAIRS = cListItems.
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_excel1 W-Win 
PROCEDURE proc_excel1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE dIngDiario AS DECIMAL NO-UNDO.

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "HOJA DE TRABAJO CTS".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE =
        "PERIODO: " + STRING(s-Periodo,"9999") + 
        " MES: " + ENTRY(COMBO-mes,meses).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Nro".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CÓDIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "APELLIDOS Y NOMBRES".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FECHA ING".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "SUELDO BASICO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "BON. ESPECIAL".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ASIG. FAMILIAR".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO COM.".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "1/6 ULT. GRAT.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO BONIFICACION".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO HHEE NORMAL".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO HHEE DOBLES".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO ALIMENTACION".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO NOCTURNIDAD".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROMEDIO RIESGO DE CAJA".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "REM. COMP.".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "MES".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DIA".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "IMP. MES".
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "IMP. DIA".
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "TOTAL".
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "TOTAL US$".

    chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 70.
    chWorkSheet:Range("A1:Q3"):FONT:Bold = TRUE.

    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.codcia = S-codcia AND
        PL-FLG-MES.periodo = COMBO-periodo AND
        PL-FLG-MES.codpln = 1 AND
        PL-FLG-MES.nromes = COMBO-mes AND
        (COMBO-seccion = "Todas" OR
        PL-FLG-MES.seccion BEGINS COMBO-seccion),
        FIRST PL-PERS NO-LOCK WHERE
        PL-PERS.codper = PL-FLG-MES.codper:
        /* Configuración Reporte */
        dVal = 0.
        FOR EACH PL-VAR-RPT WHERE
            PL-VAR-RPT.CodRep = COMBO-Reporte AND
            PL-VAR-RPT.TpoRpt = 2 NO-LOCK:

            /* VARIABLES SEGUN CONFIGURACION */
            iNroMes = IF PL-VAR-RPT.NROMES = 0 THEN COMBO-mes ELSE PL-VAR-RPT.NROMES.
            IF iNroMes < 0 THEN iNroMes = COMBO-mes + iNroMes.
            IF PL-VAR-RPT.Periodo = 0 THEN iPeriodo = s-periodo.
            ELSE
                IF PL-VAR-RPT.Periodo > 0 THEN iPeriodo = PL-VAR-RPT.Periodo.
                ELSE iPeriodo = s-periodo - PL-VAR-RPT.Periodo.
            ASSIGN
                iMes-1 = iNroMes
                iMes-2 = iNroMes.
            IF PL-VAR-RPT.Metodo = 3 THEN
                ASSIGN
                    iMes-1 = 1
                    iMes-2 = COMBO-mes.
            FOR EACH PL-MOV-MES WHERE
                PL-MOV-MES.CODCIA  = s-codcia AND
                PL-MOV-MES.PERIODO = iPeriodo AND
                PL-MOV-MES.codpln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CODCAL  = PL-VAR-RPT.CodCal AND
                PL-MOV-MES.codper  = PL-FLG-MES.codper AND
                PL-MOV-MES.CODMOV  = PL-VAR-RPT.CodMov AND
                PL-MOV-MES.NROMES  >= iMes-1 AND
                PL-MOV-MES.NROMES  <= iMes-2 NO-LOCK:
                IF PL-VAR-RPT.CodVAR > 0 AND PL-VAR-RPT.CodVAR < 101 THEN
                    dVal[PL-VAR-RPT.CodVAR] =  dVal[PL-VAR-RPT.CodVAR] + PL-MOV-MES.VALCAL-MES.
            END.
        END. /* FOR EACH PL-VAR-RPT... */

        iCount = iCount + 1.
        iCountReg = iCountReg + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = iCountReg.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = PL-FLG-MES.codper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE =
            PL-PERS.patper + " " + PL-PERS.matper + " " + PL-PERS.nomper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = PL-FLG-MES.fecing.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[5].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[12].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[6].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[8].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[10].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[17].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[9].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[13].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[15].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[14].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[16].
        cRange = "P" + cColumn.
        dIngDiario = dVal[5] + dVal[12] + dVal[6] + dVal[8] + dVal[10] + dVal[9] + dVal[17] +
                    dVal[13] + dVal[15] + dVal[14] + dVal[16].
        chWorkSheet:Range(cRange):VALUE = dIngDiario.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[2].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[3].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):VALUE = (dIngDiario / 12) * dVal[2].
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):VALUE = (dIngDiario / (12 * 30)) * dVal[3].
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[1].
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[1] / dVal[11].

        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_excel2 W-Win 
PROCEDURE proc_excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    
    DEFINE VARIABLE dIngDiario AS DECIMAL NO-UNDO.

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "HOJA DE TRABAJO GRATIFICACIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE =
        "PERIODO: " + STRING(s-Periodo,"9999") + 
        " MES: " + ENTRY(COMBO-mes,meses).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Nro".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CÓDIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "APELLIDOS Y NOMBRES".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FECHA ING".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "SUELDO BASICO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "BON. ESPECIAL".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ASIG. FAMILIAR".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "3.3% SNP".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PRM. COM.".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PRM. H. E.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PRM. BON.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PRM. H.E.126".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PRM. ALIMENT.".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FALTA INJUS.".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NOCTURNIDAD".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "RIESGO DE CAJA".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "TOTAL".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "TOTAL US$".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "SECCION".

    chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 70.
    chWorkSheet:Range("A1:R3"):FONT:Bold = TRUE.

    FOR EACH PL-FLG-MES NO-LOCK WHERE
        PL-FLG-MES.codcia = S-codcia AND
        PL-FLG-MES.periodo = COMBO-periodo AND
        PL-FLG-MES.codpln = 1 AND
        PL-FLG-MES.nromes = COMBO-mes AND
        (COMBO-seccion = "Todas" OR
        PL-FLG-MES.seccion BEGINS COMBO-seccion),
        FIRST PL-PERS NO-LOCK WHERE
        PL-PERS.codper = PL-FLG-MES.codper:
        /* Configuración Reporte */
        dVal = 0.
        FOR EACH PL-VAR-RPT WHERE
            PL-VAR-RPT.CodRep = COMBO-Reporte AND
            PL-VAR-RPT.TpoRpt = 2 NO-LOCK:

            /* VARIABLES SEGUN CONFIGURACION */
            iNroMes = IF PL-VAR-RPT.NROMES = 0 THEN COMBO-mes ELSE PL-VAR-RPT.NROMES.
            IF iNroMes < 0 THEN iNroMes = COMBO-mes + iNroMes.
            IF PL-VAR-RPT.Periodo = 0 THEN iPeriodo = s-periodo.
            ELSE
                IF PL-VAR-RPT.Periodo > 0 THEN iPeriodo = PL-VAR-RPT.Periodo.
                ELSE iPeriodo = s-periodo - PL-VAR-RPT.Periodo.
            ASSIGN
                iMes-1 = iNroMes
                iMes-2 = iNroMes.
            IF PL-VAR-RPT.Metodo = 3 THEN
                ASSIGN
                    iMes-1 = 1
                    iMes-2 = COMBO-mes.
            FOR EACH PL-MOV-MES WHERE
                PL-MOV-MES.CODCIA  = s-codcia AND
                PL-MOV-MES.PERIODO = iPeriodo AND
                PL-MOV-MES.codpln  = PL-FLG-MES.codpln AND
                PL-MOV-MES.CODCAL  = PL-VAR-RPT.CodCal AND
                PL-MOV-MES.codper  = PL-FLG-MES.codper AND
                PL-MOV-MES.CODMOV  = PL-VAR-RPT.CodMov AND
                PL-MOV-MES.NROMES  >= iMes-1 AND
                PL-MOV-MES.NROMES  <= iMes-2 NO-LOCK:
                IF PL-VAR-RPT.CodVAR > 0 AND PL-VAR-RPT.CodVAR < 101 THEN
                    dVal[PL-VAR-RPT.CodVAR] =  dVal[PL-VAR-RPT.CodVAR] + PL-MOV-MES.VALCAL-MES.
            END.
        END. /* FOR EACH PL-VAR-RPT... */

        iCount = iCount + 1.
        iCountReg = iCountReg + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = iCountReg.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = PL-FLG-MES.codper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE =
            PL-PERS.patper + " " + PL-PERS.matper + " " + PL-PERS.nomper.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = PL-FLG-MES.fecing.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[5].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[12].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[6].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[7].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[8].
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[9].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[10].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[13].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[14].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[15].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[16].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[17].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[1].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dVal[1] / dVal[11].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):VALUE = PL-FLG-MES.Seccion.
        DISPLAY
            "   Personal: " + PL-FLG-MES.codper @ FI-MENSAJE
            WITH FRAME F-PROCESO.

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

