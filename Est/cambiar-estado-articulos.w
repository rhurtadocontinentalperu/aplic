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

DEFINE TEMP-TABLE tt-articulo
    FIELDS tt-codmat LIKE almmmatg.codmat
    FIELDS tt-desmat LIKE almmmatg.desmat
    FIELDS tt-stkact LIKE almstkge.stkact
    FIELDS tt-motivo AS CHAR FORMAT 'x(60)'.

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
&Scoped-Define ENABLED-OBJECTS txtYear cboMes btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtYear cboMes txtDesde txtHasta txtMsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE cboMes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "Meses" 
     VIEW-AS COMBO-BOX INNER-LINES 5
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

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE txtYear AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Año a considerar" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtYear AT ROW 2.54 COL 18 COLON-ALIGNED WIDGET-ID 2
     cboMes AT ROW 3.88 COL 18 COLON-ALIGNED WIDGET-ID 4
     txtDesde AT ROW 6 COL 12 COLON-ALIGNED WIDGET-ID 12
     txtHasta AT ROW 6 COL 34 COLON-ALIGNED WIDGET-ID 14
     btnProcesar AT ROW 8.12 COL 24 WIDGET-ID 6
     txtMsg AT ROW 10.23 COL 6 COLON-ALIGNED NO-LABEL WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.29 BY 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Cambiar Estado - Automatica de Articulos"
         HEIGHT             = 11
         WIDTH              = 65.29
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

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtDesde IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Cambiar Estado - Automatica de Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Cambiar Estado - Automatica de Articulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar wWin
ON CHOOSE OF btnProcesar IN FRAME fMain /* Procesar */
DO:
  
    ASSIGN txtYear cboMes.
    ASSIGN txtDesde txtHasta.

    RUN procesa_articulos.
    RUN genera_excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboMes wWin
ON VALUE-CHANGED OF cboMes IN FRAME fMain /* Meses */
DO:
  
    DEFINE VAR lFechaDesde AS DATE.
    DEFINE VAR lFechaHasta AS DATE.

    ASSIGN txtYear cboMes.
    
    lFechaDesde = DATE(cboMes, 01,  txtYear - 1).
    IF cboMes = 12 THEN lFechaHasta = DATE(01,01,txtYear + 1).
    ELSE lFechaHasta = DATE(cboMes + 1 ,01,txtYear).
    lFechaHasta = lFechaHasta - 1.

    DO WITH FRAME {&FRAME-NAME}:
        txtDesde:SCREEN-VALUE = STRING(lFechaDesde,'99-99-9999').
        txtHasta:SCREEN-VALUE = STRING(lFechaHasta,'99-99-9999').
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtYear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtYear wWin
ON VALUE-CHANGED OF txtYear IN FRAME fMain /* Año a considerar */
DO:
    DEFINE VAR lFechaDesde AS DATE.
     DEFINE VAR lFechaHasta AS DATE.

     ASSIGN txtYear cboMes.

     lFechaDesde = DATE(cboMes, 01,  txtYear - 1).
     IF cboMes = 12 THEN lFechaHasta = DATE(01,01,txtYear + 1).
     ELSE lFechaHasta = DATE(cboMes + 1 ,01,txtYear).
     lFechaHasta = lFechaHasta - 1.

     DO WITH FRAME {&FRAME-NAME}:
         txtDesde:SCREEN-VALUE = STRING(lFechaDesde,'99-99-9999').
         txtHasta:SCREEN-VALUE = STRING(lFechaHasta,'99-99-9999').
     END.
  
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
  DISPLAY txtYear cboMes txtDesde txtHasta txtMsg 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtYear cboMes btnProcesar 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genera_excel wWin 
PROCEDURE genera_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.

    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Generando EXCEL...".
    SESSION:SET-WAIT-STATE('GENERAL').

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        chWorkSheet:Range("C1"):Font:Bold = TRUE.
        chWorkSheet:Range("C1"):Value = "ARTICULOS PROCESADOS - DESDE " + STRING(txtDesde,"99/99/9999") + " HASTA :" + STRING(txtHasta,"99/99/9999") .
    chWorkSheet:Range("A2"):VALUE = 'Codigo'.
    chWorkSheet:Range("B2"):VALUE = 'Descripcion'.
    chWorkSheet:Range("C2"):VALUE = 'Stock'.
    chWorkSheet:Range("D2"):VALUE = 'Motivo'.

    iColumn = 2.
    FOR EACH tt-articulo :
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-articulo.tt-codmat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-articulo.tt-desmat.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-articulo.tt-Stkact.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-articulo.tt-motivo.
    END.
    chExcelApplication:Visible = TRUE.

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

    txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    SESSION:SET-WAIT-STATE('').

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

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

    DEFINE VAR lFechaDesde AS DATE.
    DEFINE VAR lFechaHasta AS DATE.
    
    ASSIGN txtYear = YEAR(TODAY).
    ASSIGN cboMes = MONTH(TODAY).

    lFechaDesde = DATE(cboMes, 01,  txtYear - 1).
    IF cboMes = 12 THEN lFechaHasta = DATE(01,01,txtYear + 1).
    ELSE lFechaHasta = DATE(cboMes + 1 ,01,txtYear).
    lFechaHasta = lFechaHasta - 1.

    ASSIGN txtDesde = lFechaDesde.
    ASSIGN txtHasta = lFechaHasta.

  RUN SUPER.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa_articulos wWin 
PROCEDURE procesa_articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lStkActual AS DECIMAL.
DEFINE VAR lMovimientos AS DECIMAL.
DEFINE VAR lMotivo AS CHARACTER.

SESSION:SET-WAIT-STATE('GENERAL').

/* Borro el temporal */
EMPTY TEMP-TABLE tt-articulo.

txtmsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...!!!" .
 

FOR EACH almmmatg WHERE codcia = 1 AND (almmmatg.catconta[1]='MC' OR almmmatg.catconta[1]='PT') :

    lStkActual      = 0.
    lMovimientos    = 0.
    /* Stock Actual */
    /*
    FIND LAST almstkge WHERE almmmatg.codcia = almstkge.codcia AND almmmatg.codmat = almstkge.codmat 
        AND almstkge.fecha <= txtHasta NO-LOCK NO-ERROR.
    IF AVAILABLE almstkge THEN lStkActual = almstkge.stkact.
    */
    FOR EACH almmmate WHERE almmmate.codcia = 1 AND almmmate.codmat = almmmatg.codmat USE-INDEX mate03:
        FIND LAST almstkal WHERE almstkal.codcia = 1 AND almmmate.codalm = almstkal.codalm AND almstkal.codmat = almmmate.codmat AND almstkal.fecha <= txtHasta NO-LOCK NO-ERROR.
        IF AVAILABLE almstkal THEN lStkActual = lStkActual + almstkal.stkact.
        /*DISPLAY almstkal.codalm almstkal.codmat almstkal.stkact almstkal.fecha.*/
    END.

    /* Movimientos */
    FIND FIRST almdmov WHERE almdmov.codcia = almmmatg.codcia AND almdmov.codmat = almmmatg.codmat AND 
            (almdmov.FchDoc >= txtDesde AND almdmov.FchDoc <= txtHasta) USE-INDEX almd02 NO-LOCK NO-ERROR.
    IF AVAILABLE almdmov THEN lMovimientos = 1.

    lMotivo = ''.
    IF lStkActual <> 0 AND almmmatg.TipArt='D' THEN DO:
        /* Tiene Stock y esta desactivado */
        /*ASSIGN almmmatg.TipArt = 'A'.*/
        lMotivo = 'REACTIVADO'.
    END.
    ELSE DO:
        IF lStkActual <> 0 AND lMovimientos = 0 THEN DO:
            /* Tieen Stock y sin movimientos Baja Preventiva */
            IF almmmatg.TipArt <> 'B' THEN DO:
                /*ASSIGN almmmatg.TipArt = 'B'.*/
                lMotivo = 'BAJA PREVENTIVA'.
            END.
        END.
        ELSE DO:
            IF lStkActual = 0 AND lMovimientos = 0 THEN DO:
                /* Sin Stock y sin movimientos */
                /*ASSIGN almmmatg.TipArt = 'D'.*/
                IF almmmatg.TipArt <> 'D' THEN DO:
                    lMotivo = 'BAJA'.
                END.                    
            END.
        END.
    END.
    IF lMotivo <> '' THEN DO:
        /* Guardo en el Temporal para luego Generar EXCEL  */
        CREATE tt-articulo.
            ASSIGN  tt-codmat   = almmmatg.codmat
                    tt-desmat   = almmmatg.desmat
                    tt-stkact   = lStkActual
                    tt-motivo   = lMotivo.
    END.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

