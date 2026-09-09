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

    
DEFINE SHARED VARIABLE s-codcia AS INT.

DEFINE TEMP-TABLE tt-liquidacion-combustible
            FIELDS tt-fecha     LIKE di-cgasol.fecha
            FIELDS tt-placa     LIKE di-cgasol.placa
        FIELDS tt-galones   LIKE di-cgasol.galones
        FIELDS tt-importe   LIKE di-cgasol.importe
        FIELDS tt-kmini     LIKE di-rutaC.KmtIni
        FIELDS tt-kmfin     LIKE di-rutaC.KmtFin
        FIELDS tt-kmrecorrido   AS DEC

            INDEX idx01 IS PRIMARY tt-placa tt-fecha .

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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtDesde txtHasta 

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

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtDesde AT ROW 2.92 COL 10 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.92 COL 35 COLON-ALIGNED WIDGET-ID 4
     btnProcesar AT ROW 6.19 COL 32 WIDGET-ID 6
     "   Liquidacion de Consumo de Combustible" VIEW-AS TEXT
          SIZE 37 BY .62 AT ROW 1 COL 9.86 WIDGET-ID 8
          BGCOLOR 1 FGCOLOR 15 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.72 BY 8.23 WIDGET-ID 100.


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
         TITLE              = "Liquidacion Combustible"
         HEIGHT             = 8.23
         WIDTH              = 60.72
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Liquidacion Combustible */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Liquidacion Combustible */
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
    ASSIGN txtDesde txtHasta.

    RUN um_procesar.

    RUN um_excel.
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
  DISPLAY txtDesde txtHasta 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtDesde txtHasta btnProcesar 
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

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    txtDesde:SCREEN-VALUE = STRING(TODAY - 30,"99/99/9999").
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999") .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_excel wWin 
PROCEDURE um_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

        DEFINE VAR lRecorrido AS DEC.
        DEFINE VAR lGalones AS DEC.
        DEFINE VAR lImporte AS DEC.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1:R1"):Font:Bold = TRUE.
        chWorkSheet:Range("A2:R2"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "COMSUMOS DE COMBUSTIBLES  Desde : " + STRING(txtDesde,"99/99/9999") + 
        "   Hasta :" + STRING(txtHasta,"99/99/9999").
        
        chWorkSheet:Range("A2"):Value = "PLACA".
        chWorkSheet:Range("B2"):Value = "MARCA".
        chWorkSheet:Range("C2"):Value = "F. SALIDA".
        chWorkSheet:Range("D2"):Value = "Km. Inicial".
        chWorkSheet:Range("E2"):Value = "Km. Final".
        chWorkSheet:Range("F2"):Value = "Recorrido".
        chWorkSheet:Range("G2"):Value = "Consumo".
        chWorkSheet:Range("H2"):Value = "Importe".

        iColumn = 2.
        lRecorrido  = 0.
        lGalones    = 0.
        lImporte    = 0.

         FOR EACH tt-liquidacion-combustible BREAK BY tt-placa BY tt-fecha :
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).
    
            IF FIRST-OF(tt-placa) THEN DO:
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "'" + tt-placa.
                lRecorrido  = 0.
                lGalones    = 0.
                lImporte    = 0.
            END.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-fecha.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-kmini.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-kmfin.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-kmrecorrido.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-galones.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-importe.

            lRecorrido  = lRecorrido + tt-kmrecorrido.
            lGalones    = lGalones + tt-galones.
            lImporte    = lImporte + tt-importe.

            IF LAST-OF(tt-placa) THEN DO:
                iColumn = iColumn + 1.
                cColumn = STRING(iColumn).

                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = lRecorrido.
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = lGalones.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = lImporte.
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = lRecorrido / lGalones.
                
                cRange = "F" + cColumn + ":I" + cColumn.
                chWorkSheet:Range(cRange):Font:Bold = TRUE.
            END.
    
         END.

    chExcelApplication:Visible = TRUE.

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_procesar wWin 
PROCEDURE um_procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lKmIni AS DEC.
DEFINE VAR lKmFin AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-liquidacion-combustible.

lKmIni = 9999999999.
lKmFin = 0.

FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddoc = 'H/R' AND
            (di-rutaC.fchsal >= txtDesde AND di-rutaC.fchsal <= txtHasta) NO-LOCK
            BREAK BY di-rutaC.fchsal BY di-rutaC.codveh :
    IF FIRST-OF(di-rutaC.fchsal) OR FIRST-OF(di-rutaC.codveh)  THEN DO:
        lKmIni = 9999999999.
        lKmFin = 0.
        /**/
        FIND FIRST tt-liquidacion-combustible WHERE tt-placa = di-rutaC.codveh AND 
            tt-fecha = di-rutaC.fchsal EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-liquidacion-combustible THEN DO:
            CREATE tt-liquidacion-combustible.
                ASSIGN  tt-fecha    = di-rutaC.fchsal
                        tt-placa    = di-rutaC.codveh.
            /* Busco los Galones e Importes consumidos */
            FIND FIRST di-cgasol WHERE di-cgasol.codcia = s-codcia AND 
                    di-cgasol.fecha = di-rutaC.fchsal AND 
                    di-cgasol.placa = di-rutaC.codveh NO-LOCK NO-ERROR.
            IF AVAILABLE di-cgasol THEN DO:
                ASSIGN tt-liquidacion-combustible.tt-galones  = di-cgasol.galones
                        tt-liquidacion-combustible.tt-importe  = di-cgasol.importe.

            END.
        END.
    END.
    IF di-rutaC.KmtIni < lKmIni THEN lKmIni = di-rutaC.KmtIni.
    IF di-rutaC.KmtFin > lKmFin THEN lKmFin = di-rutaC.KmtFin.

    IF LAST-OF(di-rutaC.fchsal) OR LAST-OF(di-rutaC.codveh) THEN DO:
        IF lKmIni = 9999999999 THEN lKmIni = 0.

        ASSIGN  tt-liquidacion-combustible.tt-kmini     = lKmIni
                tt-liquidacion-combustible.tt-kmfin     = lKmFin
                tt-liquidacion-combustible.tt-kmrecorrido  = lKmFin - lKmIni.
    END.
END.
/*
FOR EACH di-cgasol WHERE di-cgasol.codcia = s-codcia AND di-cgasol.fecha >= txtDesde AND di-cgasol.fecha <= txtHasta NO-LOCK:
    FIND FIRST tt-liquidacion-combustible WHERE tt-placa = di-cgasol.placa AND 
        tt-fecha = di-cgasol.fecha EXCLUSIVE NO-ERROR.
    IF NOT AVAILABLE tt-liquidacion-combustible THEN DO:
        CREATE tt-liquidacion-combustible.
            ASSIGN  tt-fecha    = di-cgasol.fecha
                    tt-placa    = di-cgasol.placa
                    tt-galones  = di-cgasol.galones
                    tt-importe  = di-cgasol.importe.
    END.

    lKmIni = 9999999999.
    lKmFin = 0.

    FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddoc = 'H/R' AND di-rutaC.fchsal = di-cgasol.fecha 
            AND di-rutaC.codveh = di-cgasol.placa NO-LOCK:
        IF di-rutaC.KmtIni < lKmIni THEN lKmIni = di-rutaC.KmtIni.
        IF di-rutaC.KmtFin > lKmFin THEN lKmFin = di-rutaC.KmtFin.
    END.
    IF lKmIni = 9999999999 THEN lKmIni = 0.

    ASSIGN  tt-liquidacion-combustible.tt-kmini     = lKmIni
            tt-liquidacion-combustible.tt-kmfin     = lKmFin
            tt-liquidacion-combustible.tt-kmrecorrido  = lKmFin - lKmIni.

END.
*/
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

