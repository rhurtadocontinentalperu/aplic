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

DEFINE INPUT PARAMETER p-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-codcia AS INT.

DEFINE TEMP-TABLE tt-comision-ventas
        FIELD tt-tipo AS CHAR FORMAT "x(1)"
        FIELD tt-codven AS CHAR FORMAT "x(3)"
        FIELD tt-desven AS CHAR FORMAT "x(50)"
        FIELDS tt-codfam AS CHAR FORMAT "x(3)"
        FIELDS tt-desfam AS CHAR FORMAT "x(50)"
        FIELD tt-imp-vta AS DEC
        FIELD tt-imp-vta-sin-igv AS DEC
        FIELDS tt-por-comi AS DEC
        FIELD tt-imp-comi AS DEC
        
        INDEX idx01 IS PRIMARY tt-tipo tt-codven tt-codfam.

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
&Scoped-Define ENABLED-OBJECTS txtYear cboMes btnOk 
&Scoped-Define DISPLAYED-OBJECTS txtYear cboMes txtHasta txtDesde 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnOk 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE cboMes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Mes" 
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
     SIZE 20.29 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtYear AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Año" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtYear AT ROW 2.38 COL 11.72 COLON-ALIGNED WIDGET-ID 2
     cboMes AT ROW 2.38 COL 26.72 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 4.12 COL 31 COLON-ALIGNED WIDGET-ID 10
     txtDesde AT ROW 4.19 COL 8.14 COLON-ALIGNED WIDGET-ID 8
     btnOk AT ROW 6.35 COL 19 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 54.29 BY 8 WIDGET-ID 100.


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
         TITLE              = "Comisiones de Ventas"
         HEIGHT             = 8
         WIDTH              = 54.29
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Comisiones de Ventas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Comisiones de Ventas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOk wWin
ON CHOOSE OF btnOk IN FRAME fMain /* Procesar */
DO:
    ASSIGN txtdesde txthasta.
  RUN um_procesa.
  RUN um_excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cboMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cboMes wWin
ON VALUE-CHANGED OF cboMes IN FRAME fMain /* Mes */
DO:
  RUN um_muestra_fechas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtYear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtYear wWin
ON LEAVE OF txtYear IN FRAME fMain /* Año */
DO:
  RUN um_muestra_fechas.
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
  DISPLAY txtYear cboMes txtHasta txtDesde 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtYear cboMes btnOk 
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

  /* Code placed here will execute AFTER standard behavior.*/
  DEFINE VAR lDate AS DATE.
  DEFINE VAR lMes AS INT.
  DEFINE VAR lYear AS INT.

  lDate = TODAY.

  DO WITH FRAME {&FRAME-NAME}:
    txtYear:SCREEN-VALUE = STRING(YEAR(lDate),">>>9") . 
    cboMes:SCREEN-VALUE = STRING(MONTH(lDate),">9"). 
  END.
  RUN um_muestra_fechas.

  

 
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
        chWorkSheet:Range("A1"):Value = "Procesado desde: " + 
            STRING(txtDesde,"99/99/9999") + "  Hasta: " + 
            STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("A2:R2"):Font:Bold = TRUE.
        chWorkSheet:Range("A2"):Value = "VENDEDOR".
        chWorkSheet:Range("B2"):Value = "LINEA".
        chWorkSheet:Range("C2"):Value = "TOTAL".
        chWorkSheet:Range("D2"):Value = "TOTAL SIN IGV".
        chWorkSheet:Range("E2"):Value = "%COMISION".
        chWorkSheet:Range("F2"):Value = "IMP.COMISION".

    iColumn = 2.
    FOR EACH tt-comision-ventas BREAK BY tt-tipo BY tt-codven:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        IF FIRST-OF(tt-codven) THEN DO:     
            cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = "'" + tt-codven + " " + tt-desven.            
        END.     
        /*
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-codven + " " + tt-desven.            
        */
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + tt-codfam + " " + tt-desfam.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-imp-vta.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-imp-vta-sin-igv.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = tt-por-comi.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = ROUND((tt-por-comi / 100 ) * tt-imp-vta-sin-igv,2) .
                                               
    END.

    chExcelApplication:Visible = TRUE.

        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR.     

    SESSION:SET-WAIT-STATE('').

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_muestra_fechas wWin 
PROCEDURE um_muestra_fechas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR lDate AS DATE.
  DEFINE VAR lMes AS INT.
  DEFINE VAR lYear AS INT.

  DO WITH FRAME {&FRAME-NAME}:

    lMes = int(cboMes:SCREEN-VALUE).
    lYear = INT(txtYear:SCREEN-VALUE). 

    lDate = DATE(lMes,25,lYear).
    txthasta:SCREEN-VALUE = STRING(lDate,'99/99/9999').

    IF lMes = 1 THEN DO:
        lMes = 12.
        lYear = lYear - 1.
    END.
    ELSE 
        lMes = lMes - 1.

    lDate = DATE(lMes,26,lYear).
    txtdesde:SCREEN-VALUE = STRING(lDate,'99/99/9999').

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_procesa wWin 
PROCEDURE um_procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR lCodSup AS CHAR.
DEFINE VAR lPorComi AS DEC.

EMPTY TEMP-TABLE tt-comision-ventas.

FOR EACH estavtas.ventas WHERE (ventas.datekey >= txtDesde AND 
    ventas.datekey <= txtHasta) AND ventas.coddiv = p-coddiv NO-LOCK,
    FIRST estavtas.dimproducto OF estavtas.ventas NO-LOCK,
    FIRST integral.factabla WHERE factabla.codcia = s-codcia AND 
        factabla.tabla = 'CF' AND factabla.codigo = dimproducto.codfam :

    /* Por los VENDEDORES */
    lCodSup = ''.
    lPorComi = 0.
    FIND tt-comision-ventas WHERE tt-comision-ventas.tt-tipo = 'V' AND 
            tt-comision-ventas.tt-codven = ventas.codven AND
            tt-comision-ventas.tt-codfam = dimproducto.codfam EXCLUSIVE NO-ERROR.
    FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
            gn-ven.codven = ventas.codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN DO:
        lCodSup = gn-ven.libre_c03.
    END.
    IF NOT AVAILABLE tt-comision-ventas THEN DO:
        FIND FIRST DimLinea WHERE dimlinea.codfam = dimproducto.codfam NO-LOCK NO-ERROR.
        /**/
        CREATE tt-comision-ventas.
        ASSIGN  tt-tipo = 'V'
                tt-comision-ventas.tt-codven = ventas.codven
                tt-comision-ventas.tt-codfam = dimproducto.codfam.
        CASE gn-ven.libre_c02:
            WHEN 'N' THEN lPorComi = factabla.valor[1]. /* Norte */
            WHEN 'C' THEN lPorComi = factabla.valor[2]. /* Centro */
            WHEN 'O' THEN lPorComi = factabla.valor[3]. /* Oriente */
            WHEN 'S' THEN lPorComi = factabla.valor[4]. /* Sur */
        END CASE.
        IF AVAILABLE dimlinea THEN DO:
            ASSIGN tt-comision-ventas.tt-desfam = dimlinea.nomfam.
        END.
        IF AVAILABLE gn-ven THEN DO:
            ASSIGN tt-comision-ventas.tt-desven = gn-ven.nomven.
        END.
        ASSIGN tt-comision-ventas.tt-por-comi = lPorComi.
    END.
    ASSIGN tt-comision-ventas.tt-imp-vta = tt-comision-ventas.tt-imp-vta + ventas.ImpNacCIgv
            tt-comision-ventas.tt-imp-vta-sin-igv = tt-comision-ventas.tt-imp-vta-sin-igv + ventas.ImpNacSIgv.
            

    /* Por los SUPERVISORES */
    lPorComi = 0.

    /* Cualquier vendedor que no tiene supervisor asignado
        lo asignamos al Sr. Luis SEN.
     */
    IF lCodSup = ? OR lCodSup = "" THEN lCodSup = '015'.

    IF lCodSup <> ? AND lCodSup <> "" THEN DO:
        FIND tt-comision-ventas WHERE tt-comision-ventas.tt-tipo = 'X' AND 
                tt-comision-ventas.tt-codven = lCodSup AND
                tt-comision-ventas.tt-codfam = dimproducto.codfam EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-comision-ventas THEN DO:
            FIND FIRST DimLinea WHERE dimlinea.codfam = dimproducto.codfam NO-LOCK NO-ERROR.
            FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                    gn-ven.codven = lCodSup NO-LOCK NO-ERROR.
            /**/
            CREATE tt-comision-ventas.
            ASSIGN  tt-tipo = 'X'
                    tt-comision-ventas.tt-codven = lCodSup
                    tt-comision-ventas.tt-codfam = dimproducto.codfam.
            IF AVAILABLE dimlinea THEN DO:
                ASSIGN tt-comision-ventas.tt-desfam = dimlinea.nomfam.
            END.
            IF AVAILABLE gn-ven THEN DO:               
                ASSIGN tt-comision-ventas.tt-desven = TRIM(gn-ven.nomven) + " (SUPERVISOR)".
            END.
            lPorComi = factabla.valor[5]. /* Supervisor */
            ASSIGN tt-comision-ventas.tt-por-comi = lPorComi.

        END.
        ASSIGN tt-comision-ventas.tt-imp-vta = tt-comision-ventas.tt-imp-vta + ventas.ImpNacCIgv
                tt-comision-ventas.tt-imp-vta-sin-igv = tt-comision-ventas.tt-imp-vta-sin-igv + ventas.ImpNacSIgv.
                
        
    END.

END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.
/*
DEFINE TEMP-TABLE tt-comision-ventas
        FIELD tt-codven AS CHAR FORMAT "x(3)"
        FIELD tt-desven AS CHAR FORMAT "x(50)"
        FIELDS tt-codfam AS CHAR FORMAT "x(3)"
        FIELDS tt-desfam AS CHAR FORMAT "x(50)"
        FIELD tt-imp-vta AS DEC
        FIELD tt-imp-vta-sin-igv AS DEC
        FIELDS tt-por-comi AS DEC
        FIELD tt-imp-comi AS DEC
  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

