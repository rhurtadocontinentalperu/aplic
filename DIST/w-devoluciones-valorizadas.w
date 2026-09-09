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

DEFINE SHARED VARIABLE s-codcia  AS INT.

DEFINE TEMP-TABLE tt-rsmen-dist
            FIELDS tt-codigo LIKE almtabla.codigo
            FIELDS tt-desmot LIKE almtabla.nombre
        FIELDS tt-ptos-ent AS INT INIT 0
        FIELDS tt-imp-ent AS DEC INIT 0
        FIELDS tt-ptos-dev AS INT INIT 0
        FIELDS tt-imp-dev AS DEC INIT 0
        FIELDS tt-ptos-aun AS INT INIT 0
        FIELDS tt-imp-aun AS DEC INIT 0

            INDEX idx01 IS PRIMARY tt-codigo.

DEFINE TEMP-TABLE tt-rsmen-dtl
            FIELDS tt-coddiv LIKE gn-divi.coddiv
            FIELDS tt-codcli LIKE gn-clie.codcli
        FIELDS tt-ptos-ent AS INT INIT 0
        FIELDS tt-imp-ent AS DEC INIT 0
        FIELDS tt-ptos-dev AS INT INIT 0
        FIELDS tt-imp-dev AS DEC INIT 0
        FIELDS tt-ptos-aun AS INT INIT 0
        FIELDS tt-imp-aun AS DEC INIT 0

    INDEX idx01 IS PRIMARY tt-coddiv tt-codcli.

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
&Scoped-Define ENABLED-OBJECTS txtCoddivi txtDesde txtHasta txtProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtCoddivi txtDesDivi txtDesde txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON txtProcesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtCoddivi AS CHARACTER FORMAT "X(5)":U 
     LABEL "Centro de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesDivi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtCoddivi AT ROW 2.65 COL 26 COLON-ALIGNED WIDGET-ID 2
     txtDesDivi AT ROW 2.65 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtDesde AT ROW 3.96 COL 18 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 4.15 COL 40.14 COLON-ALIGNED WIDGET-ID 6
     txtProcesar AT ROW 6.58 COL 44 WIDGET-ID 8
     "Resumen de Devoluciones de Mercaderias" VIEW-AS TEXT
          SIZE 70 BY .96 AT ROW 1.38 COL 8 WIDGET-ID 12
          FGCOLOR 9 FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.72 BY 7.65 WIDGET-ID 100.


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
         TITLE              = "Devoluciones Valorizadas"
         HEIGHT             = 7.65
         WIDTH              = 80.86
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

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txtDesDivi IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Devoluciones Valorizadas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Devoluciones Valorizadas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCoddivi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCoddivi wWin
ON LEAVE OF txtCoddivi IN FRAME fMain /* Centro de Distribucion */
DO:
    txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = "".
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = txtCodDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN txtDesDivi:SCREEN-VALUE IN FRAM {&FRAME-NAME} = gn-divi.desdiv.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtProcesar wWin
ON CHOOSE OF txtProcesar IN FRAME fMain /* Procesar */
DO:
  ASSIGN txtCoddivi txtdesde txthasta txtDesDivi.

  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = txtCodDivi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-divi THEN DO:
        MESSAGE 'Division esta Errada' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
    IF txtDesde > txtHasta THEN DO:
        MESSAGE 'Fechas Erradas' VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN um-procesar.
    RUN um-excel.
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
  DISPLAY txtCoddivi txtDesDivi txtDesde txtHasta 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtCoddivi txtDesde txtHasta txtProcesar 
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

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros wWin 
PROCEDURE procesa-parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros wWin 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-excel wWin 
PROCEDURE um-excel :
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
        DEFINE VARIABLE x-signo                 AS DECI.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    chExcelApplication:VISIBLE = FALSE.

        /* set the column names for the Worksheet */

        chWorkSheet:Range("B1"):Font:Bold = TRUE.
        chWorkSheet:Range("B1"):Value = "RESUMEN DE NO ENTREGADOS RUTA -  DESDE :" + 
        STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("B2"):Font:Bold = TRUE.
        chWorkSheet:Range("B2"):Value = "CENTRO DE DISTRIBUCION :" + 
        txtCodDivi + " " + txtDesDivi.

        chWorkSheet:Range("A3:AZ3"):Font:Bold = TRUE.
        chWorkSheet:Range("A3"):Value = "Motivo".
        chWorkSheet:Range("B3"):Value = "Descripcion".
        chWorkSheet:Range("C3"):Value = "Puntos Devueltos".
        chWorkSheet:Range("D3"):Value = "Importe Devueltos S/.".
    

        DEF VAR x-Column AS INT INIT 74 NO-UNDO.
        DEF VAR x-Range  AS CHAR NO-UNDO.
        DEF VAR lPtosEnt AS INT INIT 0.
        DEF VAR lPtosEntImp AS DEC INIT 0.
        DEF VAR lPtosDev AS INT INIT 0.
        DEF VAR lPtosDevImp AS DEC INIT 0.
        DEF VAR lPtosAun AS INT INIT 0.
        DEF VAR lPtosAunImp AS DEC INIT 0.


SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 3.

FOR EACH tt-rsmen-dist NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "'" + tt-codigo.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "'" + tt-desmot.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-ptos-dev.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt-imp-dev.

        lPtosEnt = lPtosEnt + tt-ptos-ent.
        lPtosEntImp = lPtosEntImp + tt-imp-ent.
        lPtosDev = lPtosDev + tt-ptos-dev.
        lPtosDevImp = lPtosDevImp + tt-imp-dev.
        lPtosAun = lPtosAun + tt-ptos-aun.
        lPtosAunImp = lPtosAunImp + tt-imp-aun.

END.

        iColumn = iColumn + 2.
        cColumn = STRING(iColumn).

        chWorkSheet:Range("A" + cColumn + ":AZ" + cColumn):Font:Bold = TRUE.
        
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "** TOTALES **".
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosDev.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = lPtosDevImp.


    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:VISIBLE = TRUE .
        /*chExcelApplication:Quit().*/


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE tt-rsmen-dist.
EMPTY TEMP-TABLE tt-rsmen-dtl.

    DEFINE VAR lImp AS DEC.     
    DEFINE VAR lSoles AS DEC.
    DEFINE VAR lTcmb AS DEC.

FOR EACH di-rutaC WHERE di-rutaC.codcia = s-codcia AND di-rutaC.coddiv = txtCodDivi AND 
        (di-rutaC.fchsal >= txtDesde AND di-rutaC.fchsal <= txtHasta) AND 
    di-rutaC.flgest = 'C' NO-LOCK,
    EACH di-rutaD OF di-rutaC WHERE di-rutaD.flgest = 'N' NO-LOCK :  /* Solo NO Entregados */
        
    /* Busco por division - segun hoja de ruta */
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = DI-rutaC.codcia AND 
        DI-RutaD.coddiv = ccbcdocu.coddiv AND DI-RutaD.codref = ccbcdocu.coddoc AND
        DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.

    /* Si no ubica el documento, lo busco sin la division
        por que hay casos que la hoja de ruta contiene
        documentos emitidos x otra division
     */
    IF NOT AVAILABLE ccbcdocu THEN DO:
        FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
            AND DI-RutaD.codref = ccbcdocu.coddoc
            AND DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
    END.

    IF AVAILABLE ccbcdocu THEN DO:
            lImp = ccbcdocu.imptot.
            lTcmb = ccbcdocu.tpocmb.
            lSoles = IF (ccbcdocu.codmon = 2) THEN lImp * lTcmb ELSE lImp.

        FIND FIRST tt-rsmen-dist WHERE tt-rsmen-dist.tt-codigo = di-rutaD.flgestdet EXCLUSIVE NO-ERROR.
        IF NOT AVAILABLE tt-rsmen-dist THEN DO:
            CREATE tt-rsmen-dist.
            ASSIGN tt-rsmen-dist.tt-codigo = di-rutaD.flgestdet
                tt-rsmen-dist.tt-desmot = " < No existe >"
                tt-rsmen-dist.tt-ptos-ent = 0
                tt-rsmen-dist.tt-imp-ent = 0
                tt-rsmen-dist.tt-ptos-dev = 0
                tt-rsmen-dist.tt-imp-dev = 0
                tt-rsmen-dist.tt-ptos-aun = 0
                tt-rsmen-dist.tt-imp-aun  = 0.
            FIND FIRST almtabla WHERE almtabla.tabla = 'HR' AND almtabla.codigo = di-rutaD.flgestdet NO-LOCK NO-ERROR.
            IF AVAILABLE almtabla THEN DO:
                tt-rsmen-dist.tt-desmot = almtabla.nombre.
            END.
        END.
        /*  */
        FIND FIRST tt-rsmen-dtl WHERE tt-rsmen-dtl.tt-coddiv = '000' /*CcbCDocu.divori*/ AND 
            tt-rsmen-dtl.tt-codcli = CcbCDocu.codcli EXCLUSIVE NO-ERROR.

        IF NOT AVAILABLE tt-rsmen-dtl THEN DO:
            CREATE tt-rsmen-dtl.
            ASSIGN tt-rsmen-dtl.tt-coddiv = '000' /*CcbCDocu.divori */
                    tt-rsmen-dtl.tt-codcli = CcbCDocu.codcli.
        END.

        /* Mercaderia fue DEVUELTA */
        IF tt-rsmen-dtl.tt-ptos-dev = 0 THEN DO:                
            ASSIGN tt-rsmen-dtl.tt-ptos-dev = tt-rsmen-dtl.tt-ptos-dev + 1.
            ASSIGN tt-rsmen-dist.tt-ptos-dev = tt-rsmen-dist.tt-ptos-dev + 1.
        END.
        ASSIGN tt-rsmen-dist.tt-imp-dev  = tt-rsmen-dist.tt-imp-dev + lImp.

        /*
        IF di-rutaC.flgest = "P" THEN DO:
           /* Pendientes */
           IF tt-rsmen-dtl.tt-ptos-aun = 0 THEN DO:           
                ASSIGN tt-rsmen-dtl.tt-ptos-aun = tt-rsmen-dtl.tt-ptos-aun + 1.
                ASSIGN tt-rsmen-dist.tt-ptos-aun = tt-rsmen-dist.tt-ptos-aun + 1.
            END.
            ASSIGN tt-rsmen-dist.tt-imp-aun  = tt-rsmen-dist.tt-imp-aun + lImp.
        END.
        ELSE DO:
            IF di-rutaC.flgest = "C" THEN DO:
               /* Cerradas */
                IF di-RutaD.flgest = 'C' THEN DO:
                    /* Mercaderia fue ENTREGADA */
                    IF tt-rsmen-dtl.tt-ptos-ent = 0 THEN DO:                
                        ASSIGN tt-rsmen-dtl.tt-ptos-ent = tt-rsmen-dtl.tt-ptos-ent + 1.
                        ASSIGN tt-rsmen-dist.tt-ptos-ent = tt-rsmen-dist.tt-ptos-ent + 1.
                    END.
                    ASSIGN tt-rsmen-dist.tt-imp-ent  = tt-rsmen-dist.tt-imp-ent + lImp.
                END.
                ELSE DO:
                    /* Mercaderia fue DEVUELTA */
                    IF tt-rsmen-dtl.tt-ptos-dev = 0 THEN DO:                
                        ASSIGN tt-rsmen-dtl.tt-ptos-dev = tt-rsmen-dtl.tt-ptos-dev + 1.
                        ASSIGN tt-rsmen-dist.tt-ptos-dev = tt-rsmen-dist.tt-ptos-dev + 1.
                    END.
                    ASSIGN tt-rsmen-dist.tt-imp-dev  = tt-rsmen-dist.tt-imp-dev + lImp.
                END.
            END.
            ELSE DO:
                 /* ??????? */
            END.
        END.
        */
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

