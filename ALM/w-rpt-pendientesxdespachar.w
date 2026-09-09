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
DEFINE SHARED VARIABLE cl-codcia AS INT.

DEFINE VAR x-Archivo AS CHAR.

DEFINE TEMP-TABLE ttReporte NO-UNDO
    FIELDS  tcoddiv     AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Cod.Div"
    FIELDS  tdesdiv     AS CHAR FORMAT 'x(60)'  COLUMN-LABEL "Nombre Div."
    FIELDS  tfecha      AS DATE     COLUMN-LABEL "Fecha"
    FIELDS  tQtySKUTot    AS INT  COLUMN-LABEL "Total SKUs"       INIT 0
    FIELDS  tPesoTot    AS DEC  COLUMN-LABEL "Total Peso"       INIT 0
    FIELDS  tVolTot    AS DEC  COLUMN-LABEL "Total Volumen m3"     FORMAT '->,>>>,>>>,>>9.99'   INIT 0
    FIELDS  tQOrdTot    AS INT  COLUMN-LABEL "Total Ordenes"       INIT 0
    FIELDS  tQSPesoTot    AS INT  COLUMN-LABEL "SKUs sin peso"       INIT 0
    FIELDS  tQSVolTot    AS INT  COLUMN-LABEL "SKUs sin vol"       INIT 0
    FIELDS  tQtyskuOD     AS INT  COLUMN-LABEL "Total SKUs O/D"   INIT 0
    FIELDS  tQtySkuOTR    AS INT  COLUMN-LABEL "Total SKUs OTR"   INIT 0
    FIELDS  tQtySKUOM     AS INT  COLUMN-LABEL "Total SKUs O/M"   INIT 0    
    FIELDS  tPesoOD     AS DEC  COLUMN-LABEL "Total Peso O/D"   INIT 0
    FIELDS  tPesoOTR    AS DEC  COLUMN-LABEL "Total Peso OTR"   INIT 0
    FIELDS  tPesoOM     AS DEC  COLUMN-LABEL "Total Peso O/M"   INIT 0
    FIELDS  tQOrdOD     AS INT  COLUMN-LABEL "Total Ordenes O/D"   INIT 0
    FIELDS  tQOrdOTR    AS INT  COLUMN-LABEL "Total Ordenes OTR"   INIT 0
    FIELDS  tQOrdOM     AS INT  COLUMN-LABEL "Total Ordenes O/M"   INIT 0    
    FIELDS  tVolOD     AS DEC  COLUMN-LABEL "Volumen m3 - O/D" FORMAT '->,>>>,>>>,>>9.99'   INIT 0
    FIELDS  tVolOTR    AS DEC  COLUMN-LABEL "Volumen m3 - OTR" FORMAT '->,>>>,>>>,>>9.99'   INIT 0
    FIELDS  tVolOM     AS DEC COLUMN-LABEL "Volumen m3- O/M"  FORMAT '->,>>>,>>>,>>9.99'   INIT 0    
    FIELDS  tQSPesoOD     AS INT  COLUMN-LABEL "SKUs sin peso O/D"   INIT 0
    FIELDS  tQSPesoOTR    AS INT  COLUMN-LABEL "SKUs sin peso OTR"   INIT 0
    FIELDS  tQSPesoOM     AS INT  COLUMN-LABEL "SKUs sin peso O/M"   INIT 0   
    FIELDS  tQSVolOD     AS INT  COLUMN-LABEL "SKUs sin vol O/D"   INIT 0
    FIELDS  tQSVolOTR    AS INT  COLUMN-LABEL "SKUs sin vol OTR"   INIT 0
    FIELDS  tQSVolOM     AS INT  COLUMN-LABEL "SKUs sin vol O/M"   INIT 0
    INDEX idx01 tcoddiv tFecha.

DEFINE VAR lTiempoDesde AS DATETIME.
DEFINE VAR lTiempoHasta AS DATETIME.

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
     LABEL "Indique el CD" 
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
     txtCoddivi AT ROW 2.23 COL 19.72 COLON-ALIGNED WIDGET-ID 2
     txtDesDivi AT ROW 2.23 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtDesde AT ROW 5.19 COL 13 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 5.19 COL 35.14 COLON-ALIGNED WIDGET-ID 6
     txtProcesar AT ROW 7.35 COL 61 WIDGET-ID 28
     "  PED, OTR, O/M que tengan fecha de ENTREGA en este rango de fechas" VIEW-AS TEXT
          SIZE 64.86 BY .62 AT ROW 4.42 COL 14.14 WIDGET-ID 20
          FGCOLOR 1 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83 BY 9.08 WIDGET-ID 100.


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
         TITLE              = "Pendientes x despachar resumen"
         HEIGHT             = 9.08
         WIDTH              = 83
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
ON END-ERROR OF wWin /* Pendientes x despachar resumen */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Pendientes x despachar resumen */
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
ON LEAVE OF txtCoddivi IN FRAME fMain /* Indique el CD */
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
  /*ASSIGN txtCoddivi txtdesde txthasta txtDesDivi txtCodClie txtNomClie rbQueRpt.*/
  ASSIGN txtCoddivi txtdesde txthasta txtDesDivi .

  
  FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = txtCodDivi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-divi THEN DO:
     MESSAGE 'Division esta Errada' VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  
    IF txtDesde > txtHasta THEN DO:
        MESSAGE 'Fechas Erradas' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    DEFINE VAR x-rpta AS LOG.

    x-Archivo = 'SeguimientoPedidos'.
    SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS 'XLSX' '*.xlsx'
      ASK-OVERWRITE
      CREATE-TEST-FILE
      DEFAULT-EXTENSION '.xlsx'
      INITIAL-DIR 'c:\tmp'
      RETURN-TO-START-DIR 
      USE-FILENAME
      SAVE-AS
      UPDATE x-rpta.
    IF x-rpta = NO THEN RETURN NO-APPLY.

    SESSION:SET-WAIT-STATE('GENERAL').
    RUN um-procesar.
    SESSION:SET-WAIT-STATE('').

    FIND FIRST ttReporte NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttReporte THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    SESSION:SET-WAIT-STATE('GENERAL').

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = x-Archivo.

    run pi-crea-archivo-csv IN hProc (input  buffer ttReporte:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer ttReporte:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.

    SESSION:SET-WAIT-STATE('').

    MESSAGE "Proceso Concluido" SKIP "Desde : " lTiempoDesde SKIP "Hasta : " lTiempoHasta VIEW-AS ALERT-BOX WARNING.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcular-ordenes wWin 
PROCEDURE calcular-ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lDocs AS CHAR.
DEFINE VAR lCoddoc AS CHAR.
DEFINE VAR lSec AS INT.

DEFINE VAR lPeso AS DEC.
DEFINE VAR lVol AS DEC.
DEFINE VAR lCant AS DEC.

lDocs = "PED,O/D,OTR,O/M".

SESSION:SET-WAIT-STATE('GENERAL').


/* Ordenes */
REPEAT lSec = 1 TO NUM-ENTRIES(lDocs,","):
    lCoddoc = ENTRY(lsec,lDocs,",").    

    /* Ojo : si PED debe considerar varios estados */
    FOR EACH faccpedi   USE-INDEX llave08
                        WHERE faccpedi.codcia = s-codcia AND
                                faccpedi.divdes = txtCodDivi AND 
                                faccpedi.coddoc = lCodDoc AND
                                ((faccpedi.flgest = 'P' AND faccpedi.coddoc <> 'PED') OR
                                (faccpedi.coddoc = 'PED' AND LOOKUP(faccpedi.flgest,"G,X,W,WX,WL,P") > 0)) AND                                
                                (faccpedi.fchent >= txtDesde AND faccpedi.fchent <= txtHasta)
                                NO-LOCK :        
        FOR EACH facdpedi OF faccpedi NO-LOCK:       

            IF (faccpedi.coddoc <> 'PED' AND facdpedi.canped > 0) THEN lCant = facdpedi.canped.
            IF (faccpedi.coddoc = 'PED' AND (facdpedi.canped - facdpedi.canate) > 0 )  THEN lCant = facdpedi.canped - facdpedi.canate.

            IF lCant > 0 THEN DO:
                FIND FIRST almmmatg OF facdpedi NO-LOCK.
                lPeso = 0.
                lVol = 0.
                IF AVAILABLE almmmatg THEN DO:
                    lPeso = IF (almmmatg.pesmat = ? OR almmmatg.pesmat <= 0) THEN 0 ELSE almmmatg.pesmat.
                    lVol = IF (almmmatg.libre_d02 = ? OR almmmatg.libre_d02 <= 0) THEN 0 ELSE almmmatg.libre_d02.
                END.
                lPeso = lPeso * lCant.
                lVol= lVol * lCant.
                /**/
                FIND FIRST ttReporte WHERE ttReporte.tcoddiv = faccpedi.divdes AND 
                                            ttReporte.tfecha = faccpedi.fchent NO-ERROR.
                IF NOT AVAILABLE ttReporte THEN DO:
                    CREATE ttReporte.
                    ASSIGN  tCoddiv     = faccpedi.divdes
                            tfecha      = faccpedi.fchent
                            tDesdiv     = txtDesDivi.
                END.
                ASSIGN  tQtyskuOD = tQtyskuOD + (IF (faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') THEN 1 ELSE 0)
                        tQtyskuOTR = tQtyskuOTR + (IF (faccpedi.coddoc = 'OTR') THEN 1 ELSE 0)
                        tQtyskuOM = tQtyskuOM + (IF (faccpedi.coddoc = 'O/M') THEN 1 ELSE 0)
                        tQtyskuTot = tQtyskuTot + 1
                        tPesoOD = tPesoOD + (IF (faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') THEN lpeso ELSE 0)
                        tPesoOTR = tPesoOTR + (IF (faccpedi.coddoc = 'OTR') THEN lPeso ELSE 0)
                        tPesoOM = tPesoOM + (IF (faccpedi.coddoc = 'O/M') THEN lPeso ELSE 0)
                        tPesoTot = tPesoTot + lPeso
                        tVolOD = tVolOD + (IF (faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') THEN lVol ELSE 0)
                        tVolOTR = tVolOTR + (IF (faccpedi.coddoc = 'OTR') THEN lVol ELSE 0)
                        tVolOM = tVolOM + (IF (faccpedi.coddoc = 'O/M') THEN lVol ELSE 0)
                        tVolTot = tVolTot + lVol
                        tQSPesoOD = tQSPesoOD + (IF ((faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') AND lPeso <= 0) THEN 1 ELSE 0)
                        tQSPesoOTR = tQSPesoOTR + (IF (faccpedi.coddoc = 'OTR' AND lPeso <= 0) THEN 1 ELSE 0)
                        tQSPesoOM = tQSPesoOM + (IF (faccpedi.coddoc = 'O/M' AND lpeso <= 0) THEN 1 ELSE 0)
                        tQSPesoTot = tQSPesoOD + tQSPesoOTR + tQSPesoOM
                        tQSVolOD = tQSVolOD + (IF ((faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') AND lVol <= 0) THEN 1 ELSE 0)
                        tQSVolOTR = tQSVolOTR + (IF (faccpedi.coddoc = 'OTR' AND lVol <= 0) THEN 1 ELSE 0)
                        tQSVolOM = tQSVolOM + (IF (faccpedi.coddoc = 'O/M' AND lVol <= 0) THEN 1 ELSE 0)
                        tQSVolTot = tQSVolOD + tQSVolOTR +  tQSVolOM
                        .
            END.
        END.
        /**/
        FIND FIRST ttReporte WHERE ttReporte.tcoddiv = faccpedi.divdes AND 
                                    ttReporte.tfecha = faccpedi.fchent NO-ERROR.
        IF NOT AVAILABLE ttReporte THEN DO:
            CREATE ttReporte.
            ASSIGN  tCoddiv     = faccpedi.divdes
                    tfecha      = faccpedi.fchent
                    tDesdiv     = txtDesDivi.
        END.

        ASSIGN  tQOrdOD = tQOrdOD + (IF (faccpedi.coddoc = 'O/D' OR faccpedi.coddoc = 'PED') THEN 1 ELSE 0)
                tQOrdOTR = tQOrdOTR + (IF (faccpedi.coddoc = 'OTR') THEN 1 ELSE 0)
                tQOrdOM = tQOrdOM + (IF (faccpedi.coddoc = 'O/M') THEN 1 ELSE 0)
                tQOrdTot = tQOrdTot + 1.

    END.
END.

FOR EACH ttReporte:
    ASSIGN tVolOD = tVolOD / 1000000
            tVolOTR = tVolOTR / 1000000
            tVolOM = tVolOM / 1000000
            tVolTot = tVolTot / 1000000.

END.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttReporte NO-UNDO
    FIELDS  tcoddiv     AS CHAR FORMAT 'x(10)'  COLUMN-LABEL "Cod.Div"
    FIELDS  tdesdiv     AS CHAR FORMAT 'x(60)'  COLUMN-LABEL "Nombre Div."
    FIELDS  tfecha      AS DATE     COLUMN-LABEL "Fecha"
    FIELDS  tQtyskuOD     AS INT  COLUMN-LABEL "Total SKUs O/D"   INIT 0
    FIELDS  tQtySkuOTR    AS INT  COLUMN-LABEL "Total SKUs OTR"   INIT 0
    FIELDS  tQtySKUOM     AS INT  COLUMN-LABEL "Total SKUs O/M"   INIT 0
    FIELDS  tQtySKUTot    AS INT  COLUMN-LABEL "Total SKUs"       INIT 0
    FIELDS  tPesoOD     AS INT  COLUMN-LABEL "Total Peso O/D"   INIT 0
    FIELDS  tPesoOTR    AS INT  COLUMN-LABEL "Total Peso OTR"   INIT 0
    FIELDS  tPesoOM     AS INT  COLUMN-LABEL "Total Peso O/M"   INIT 0
    FIELDS  tPesoTot    AS INT  COLUMN-LABEL "Total Peso"       INIT 0
    FIELDS  tQOrdOD     AS INT  COLUMN-LABEL "Total Ordenes O/D"   INIT 0
    FIELDS  tQOrdOTR    AS INT  COLUMN-LABEL "Total Ordenes OTR"   INIT 0
    FIELDS  tQOrdOM     AS INT  COLUMN-LABEL "Total Ordenes O/M"   INIT 0
    FIELDS  tQOrdTot    AS INT  COLUMN-LABEL "Total Ordenes"       INIT 0
    FIELDS  tVolOD     AS INT  COLUMN-LABEL "Total Volumen O/D"   INIT 0
    FIELDS  tVolOTR    AS INT  COLUMN-LABEL "Total Volumen OTR"   INIT 0
    FIELDS  tVolOM     AS INT  COLUMN-LABEL "Total Volumen O/M"   INIT 0
    FIELDS  tVolTot    AS INT  COLUMN-LABEL "Total Volumen"       INIT 0
    FIELDS  tQSPesoOD     AS INT  COLUMN-LABEL "Orden sin peso O/D"   INIT 0
    FIELDS  tQSPesoTR    AS INT  COLUMN-LABEL "Orden sin peso OTR"   INIT 0
    FIELDS  tQSPesoOM     AS INT  COLUMN-LABEL "Orden sin peso O/M"   INIT 0
    FIELDS  tQSPesoTot    AS INT  COLUMN-LABEL "Orden sin peso"       INIT 0
    FIELDS  tQSVolOD     AS INT  COLUMN-LABEL "Orden sin vol O/D"   INIT 0
    FIELDS  tQSVolOTR    AS INT  COLUMN-LABEL "Orden sin vol OTR"   INIT 0
    FIELDS  tQSVolOM     AS INT  COLUMN-LABEL "Orden sin vol O/M"   INIT 0
    FIELDS  tQSVolTot    AS INT  COLUMN-LABEL "Orden sin vol"       INIT 0.

*/

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

  txtDesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 3,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY + 5,"99/99/9999").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um-procesar wWin 
PROCEDURE um-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


lTiempoDesde = NOW.

EMPTY TEMP-TABLE ttReporte.

RUN calcular-ordenes.

lTiempoHasta = NOW.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

