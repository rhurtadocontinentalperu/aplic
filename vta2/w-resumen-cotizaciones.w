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

DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE TEMP-TABLE tt-resumen-cot
            FIELDS tt-codmat LIKE almmmatg.codmat
            FIELDS tt-desmat LIKE almmmatg.desmat
        FIELDS tt-codfam LIKE almtfami.codfam
        FIELDS tt-desfam LIKE almtfami.desfam
        FIELDS tt-subfam LIKE almsfam.subfam
        FIELDS tt-dessub LIKE almsfam.dessub
        FIELDS tt-qtysoli AS DEC INIT 0
        FIELDS tt-qtyate AS DEC INIT 0
        FIELDS tt-stkcds AS DEC INIT 0

            INDEX idx01 IS PRIMARY tt-codmat.

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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta txtCodProv txtCDs ~
btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtDivision txtDesde txtHasta txtCodProv ~
txtNomProv txtCDs 

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

DEFINE VARIABLE txtCDs AS CHARACTER FORMAT "X(256)":U INITIAL "11,21,21S,22,34,35" 
     LABEL "Centros de Distribucion" 
     VIEW-AS FILL-IN 
     SIZE 62 BY 1 NO-UNDO.

DEFINE VARIABLE txtCodProv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Algun proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDivision AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 51 BY 1
     FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtNomProv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     txtDivision AT ROW 1.77 COL 20 COLON-ALIGNED WIDGET-ID 6
     txtDesde AT ROW 3.5 COL 20 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 3.5 COL 44 COLON-ALIGNED WIDGET-ID 4
     txtCodProv AT ROW 5.42 COL 20 COLON-ALIGNED WIDGET-ID 8
     txtNomProv AT ROW 5.42 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtCDs AT ROW 7.15 COL 20 COLON-ALIGNED WIDGET-ID 14
     btnProcesar AT ROW 8.5 COL 60 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.72 BY 9.35 WIDGET-ID 100.


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
         TITLE              = "Resumenes de Cotizaciones"
         HEIGHT             = 9.35
         WIDTH              = 87.72
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
/* SETTINGS FOR FILL-IN txtDivision IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtNomProv IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Resumenes de Cotizaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Resumenes de Cotizaciones */
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
  ASSIGN txtDesde txtHasta txtCodProv txtNomProv txtCDs txtDivision.
  IF txtDesde > txtHasta THEN DO:
      MESSAGE 'Rango de Fechas Erradas' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF txtCodProv <> "" THEN DO:      
      FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
          gn-prov.codpro = txtCodprov NO-LOCK NO-ERROR.
    
      IF NOT AVAILABLE gn-prov THEN DO:
          MESSAGE 'Proveedor no existe' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
   END.

   SESSION:SET-WAIT-STATE('GENERAL').
   RUN um-procesar.
   RUN um-calc-saldos-art.
   RUN um-excel.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtCodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtCodProv wWin
ON LEAVE OF txtCodProv IN FRAME fMain /* Algun proveedor */
DO:
  DEFINE VAR lProv AS CHAR.

  txtNomProv:SCREEN-VALUE = "".
  lProv = txtCodProv:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  IF lProv <> "" THEN DO:      
      FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND 
          gn-prov.codpro = lProv NO-LOCK NO-ERROR.
    
      IF AVAILABLE gn-prov THEN DO:
          txtNomProv:SCREEN-VALUE = gn-prov.nompro.
      END.
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
  DISPLAY txtDivision txtDesde txtHasta txtCodProv txtNomProv txtCDs 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE txtDesde txtHasta txtCodProv txtCDs btnProcesar 
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
  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME}= STRING(TODAY - 15,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").    
  
  txtDivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
  FIND FIRST gn-divi  WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = s-coddiv NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN DO:
    txtDivision:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv + " " + gn-divi.desdiv.                
  END.
   

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-calc-saldos-art wWin 
PROCEDURE um-calc-saldos-art :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR iint AS INT INIT 0.
DEFINE VAR cAlm AS CHAR.
DEFINE VAR lStkCds AS DEC INIT 0.
DEFINE VAR lStk AS DEC INIT 0.
    
FOR EACH tt-resumen-cot EXCLUSIVE :
    lStkCds = 0.
    DO iint = 1 TO NUM-ENTRIES(txtCDs):
            cAlm = ENTRY(iint,txtCDs,",").
        lStk = 0.

        RUN um-saldos-almacen (INPUT cAlm, INPUT tt-resumen-cot.tt-codmat, INPUT TODAY, 
                           OUTPUT lstk).
        lStkCds = lStkCds + lStk.
    END.
    ASSIGN tt-stkcds = lStkCDs.
END.


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
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

        /* set the column names for the Worksheet */

        chWorkSheet:Range("B1"):Font:Bold = TRUE.
        chWorkSheet:Range("B1"):Value = "DIVISION : " + txtDivision.        
        
    chWorkSheet:Range("B2"):Font:Bold = TRUE.
        chWorkSheet:Range("B2"):Value = "RESUMEN DE ARTICULOS DE COTIZACIONES - DEL " + 
        STRING(txtDesde,"99/99/9999") + "  AL " + STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("B3"):Font:Bold = TRUE.
        chWorkSheet:Range("B3"):Value = "ALMACENES DE DISTRIBUCION CONSIDERADOS (" + txtCDs + ")".        

        chWorkSheet:Range("B4"):Font:Bold = TRUE.
        chWorkSheet:Range("B4"):Value = "PROVEEDOR : " + IF (txtCodProv = "") THEN "< TODOS >"
                ELSE txtCodprov + " " + txtNomProv.        

        chWorkSheet:Range("A5:R5"):Font:Bold = TRUE.
        chWorkSheet:Range("A5"):Value = "COD. ART".
        chWorkSheet:Range("B5"):Value = "DESCRIPCION".
        chWorkSheet:Range("C5"):Value = "COD.FAM".
        chWorkSheet:Range("D5"):Value = "DESCRP. FAM".
        chWorkSheet:Range("E5"):Value = "COD.SUBFAM".
        chWorkSheet:Range("F5"):Value = "DESCRP. SUBFAM".
        chWorkSheet:Range("G5"):Value = "CANT. SOLICITADA".
        chWorkSheet:Range("H5"):Value = "CANT. ATENDIDA".
        chWorkSheet:Range("I5"):Value = "CANT. X ATENDER".
        chWorkSheet:Range("J5"):Value = "STOCKS CDs".

        DEF VAR x-Column AS INT INIT 74 NO-UNDO.
        DEF VAR x-Range  AS CHAR NO-UNDO.


        /* Iterate through the salesrep table and populate
           the Worksheet appropriately */
        iColumn = 5.
    
    FOR EACH tt-resumen-cot :
             iColumn = iColumn + 1.
             cColumn = STRING(iColumn).

             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-codmat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-desmat.
             cRange = "C" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-codfam.
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-desfam.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-subfam.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):Value = "'" + tt-dessub.
             cRange = "G" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-qtysoli.
             cRange = "H" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-qtyate.
             cRange = "I" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-qtysoli - tt-qtyate.
             cRange = "J" + cColumn.
             chWorkSheet:Range(cRange):Value = tt-stkcds.

    END.

    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:Visible = TRUE.


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

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

DEFINE VAR lConsiderar AS LOGICAL.
EMPTY TEMP-TABLE tt-resumen-cot.

FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
    AND coddoc = 'COT'
    AND coddiv = s-CodDiv
    AND faccpedi.fchped >= txtDesde
    AND faccpedi.fchped <= txtHasta :

    IF Faccpedi.flgest = "A" OR Faccpedi.flgest = "W" THEN NEXT.

    FOR EACH facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        lConsiderar = YES.
        IF txtCodProv <> "" THEN DO:
            lConsiderar = NO.
            IF almmmatg.codpr1 = txtCodProv OR almmmatg.codpr2 = txtCodProv THEN lConsiderar = YES.
        END.
        IF lConsiderar = YES THEN DO:
            FIND tt-resumen-cot WHERE tt-codmat = facdpedi.codmat EXCLUSIVE NO-ERROR.
            IF NOT AVAILABLE tt-resumen-cot THEN DO:

                FIND FIRST almtfam WHERE almtfam.codcia = s-codcia AND 
                    almtfam.codfam = almmmatg.codfam NO-LOCK NO-ERROR.
                FIND FIRST almsfam WHERE almsfam.codcia = s-codcia AND
                    almsfam.codfam = almmmatg.codfam AND 
                    almsfam.subfam = almmmatg.subfam NO-LOCK NO-ERROR.
                
                CREATE tt-resumen-cot.
                    ASSIGN tt-codmat    = facdpedi.codmat
                            tt-desmat   = almmmatg.desmat
                            tt-codfam   = almmmatg.codfam
                            tt-subfam   = almmmatg.subfam
                            tt-desfam   = IF (AVAILABLE almtfam) THEN almtfam.desfam ELSE ""
                            tt-dessub   = IF (AVAILABLE almsfam) THEN almsfam.dessub ELSE "".
            END.
            ASSIGN tt-qtysol    = tt-qtysol + facdpedi.canped
                    tt-qtyate   = tt-qtyate + facdpedi.canate.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-saldos-almacen wWin 
PROCEDURE um-saldos-almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-almacen AS CHAR.
DEFINE INPUT PARAMETER p-codmat AS CHAR.
DEFINE INPUT PARAMETER p-fecha AS DATE.
DEFINE OUTPUT PARAMETER p-Stock AS DECIMAL.

p-stock = 0.
FIND LAST almstkal WHERE almstkal.codcia = s-codcia AND 
    almstkal.codalm = p-almacen AND almstkal.codmat = p-codmat AND
    almstkal.fecha <= p-fecha NO-LOCK NO-ERROR.
IF AVAILABLE almstkal THEN DO:
    p-stock = almstkal.stkact.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

