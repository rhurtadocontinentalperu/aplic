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

DEF TEMP-TABLE T-CAB LIKE cb-cmov.
DEF TEMP-TABLE T-DET LIKE cb-dmov
    FIELD gloast AS CHAR FORMAT 'x(120)'.

DEFINE SHARED VAR s-user-id AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS cboOperacion txtYear txtMes btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS cboOperacion txtYear txtMes 

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

DEFINE VARIABLE cboOperacion AS CHARACTER FORMAT "X(256)":U INITIAL "061" 
     LABEL "Elija una Operacion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Canje Documentos","061",
                     "Pagos Bancarios","002",
                     "Registro de Compras","060",
                     "Salida de Fondos","059",
                     "Entrada de Fondos","001",
                     "Rendicion de Gastos","092"
     DROP-DOWN-LIST
     SIZE 23 BY 1 NO-UNDO.

DEFINE VARIABLE txtMes AS INTEGER FORMAT ">9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtYear AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Periodo (Año/Mes)" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     cboOperacion AT ROW 2.15 COL 30 COLON-ALIGNED WIDGET-ID 2
     txtYear AT ROW 3.69 COL 30 COLON-ALIGNED WIDGET-ID 4
     txtMes AT ROW 3.69 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     btnProcesar AT ROW 5.62 COL 49 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70 BY 6.38 WIDGET-ID 100.


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
         TITLE              = "Interface (Files XLS) desde OpenOrange"
         HEIGHT             = 6.38
         WIDTH              = 70
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
ON END-ERROR OF wWin /* Interface (Files XLS) desde OpenOrange */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Interface (Files XLS) desde OpenOrange */
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
  ASSIGN txtYear txtMes cboOperacion.

  IF txtYear < 2015 THEN DO:
      MESSAGE "Año errado...".
      RETURN NO-APPLY.
  END.
  IF txtMes < 1 OR txtMes > 12  THEN DO:
      MESSAGE "Mes errado...".
      RETURN NO-APPLY.
  END.

  RUN ue-procesar.


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
  DISPLAY cboOperacion txtYear txtMes 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE cboOperacion txtYear txtMes btnProcesar 
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

  txtYear:SCREEN-VALUE IN FRAM {&FRAME-NAME} = STRING(YEAR(TODAY),"9999").
  txtMes:SCREEN-VALUE IN FRAM {&FRAME-NAME} = STRING(MONTH(TODAY),"99").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-canje-documentos wWin 
PROCEDURE ue-canje-documentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* TEMPORAL CONTABLE */

DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR s-periodo AS INT INIT 9999 NO-UNDO.     /*  Año */
DEF VAR s-nromes AS INT INIT 99 NO-UNDO.        /* Mes */
DEF VAR s-codope AS CHAR INIT 'ZZZ' NO-UNDO.    /* Operacion 061 */
DEF VAR s-nrodoc AS CHAR NO-UNDO.

DEF VAR sFiler1 AS CHARACTER.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

s-periodo = txtYear.
s-nromes = txtMes.
s-codope = cboOperacion.   /*'061'.*/
/*
FILL-IN-file = "C:\Ciman\MigrarSpeedToProgres\Conti\mov_ctable_CONTI_speed_para_progress_Ago2015_CP_061.xls".
FILL-IN-file = "C:\Ciman\Atenciones\OpenOrange\Asientos\CanjeDocumentos_12_20160113-184751.xls".
*/

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls*", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

MESSAGE 'Esta seguro de cargar la INTERFACE?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

/* PRIMERO BORRAMOS ASIENTOS ANTES TRANSFERIDOS */
DELETE FROM cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope.
DELETE FROM cb-dmov WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = s-periodo
    AND cb-dmov.nromes = s-nromes
    AND cb-dmov.codope = s-codope.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 7.
    DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-File).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        /*
        DISPLAY t-row.
        PAUSE 0.
        */
        /* asaeje - PERIODO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        CREATE T-DET.
        ASSIGN
            T-DET.CodCia = s-codcia
            T-DET.Periodo = iValue.
        /* asaper - MES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroMes = iValue.
        /* asacve - ASIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DET.NroAst = cValue.
        /* asaseq - ITEM */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroItm  = iValue.
        /* asacta - CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.CodCta = cValue.
        sFiler1 = trim(cValue).
        /* asacoa - CARGO O ABONO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.TpoMov = (IF cValue = "C" THEN NO ELSE YES).
        /* asare1 - DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroDoc = cValue.

        /* asare2 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        cValue = SUBSTRING(cValue,1,2).
        ASSIGN  T-DET.CodDoc = cValue.
        
        /*
        13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT
        IF cValue <> '' THEN DO:
            IF SUBSTRING(sFiler1,1,2)='14' OR SUBSTRING(sFiler1,1,3)='422' OR SUBSTRING(sFiler1,1,3)='469' THEN DO :
                /* Cuenta 14, el tipo dcto es 34 */
                T-DET.CodDoc = '34'.
            END.
            ELSE DO:
                FIND cb-tabl WHERE cb-tabl.Tabla = "A1"
                    AND cb-tabl.Codigo = cValue
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN T-DET.CodDoc = cb-tabl.Codcta.
            END.
        END.
        */
        /* asare3 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare4 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asafem - FECHA DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchDoc = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asave - FECHA DE VENCIMIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchVto = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asadde - GLOSA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.GloDoc = cValue.
        /* asamon - MONEDA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        ASSIGN T-DET.CodMon  = iValue + 1.
        /* asactc - ¿CODIGO TIPO DE CAMBIO? */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        /* asaimn - IMPORTE SOLES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn1 = dValue.
        /* asaime - IMPORTE DOLARES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn2 = dValue.
        /* asatca - T.C. */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.TpoCmb = dValue.
        /* asacco - CONCEPTO CONTABLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*ASSIGN T-DET.CodOpe = cValue.*/
        ASSIGN T-DET.CodOpe = s-codope.
        /* asata1 - TIPO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        T-DET.ClfAux = (IF cValue = "PR" THEN "@PV" ELSE cValue).
        /* asaca1 - CODIGO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*T-DET.CodAux = SUBSTRING(cValue,3,8).*/
        T-DET.CodAux = cValue.
        /* asata2 - TIPO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaca2 - CODIGO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asacos - CENTRO DE COSTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* Parcheee */
        /*FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia*/
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.libre_c01 = cValue NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN ASSIGN T-DET.Cco = cb-auxi.codaux.
        ELSE ASSIGN T-DET.Cco = cValue.
        IF T-DET.Cco = ? THEN T-DET.Cco = ''.
        /* asaact - ACTIVIDAD */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asagas - TIPO DE GASTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaid - SITUACION DEL DETALLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaimo - IMPORTE MONEDA DE ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatmno - VALOR DE CAMBIO MONEDA ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* flgdan - DEPURACION ANALISIS DE CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare5 - REFERENCIA 5*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare6 - REFERENCIA 6*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr1 - TIPO 1*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr2 - TIPO 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.

        /* Segun correo Juan Hermoza del 09Dic2015 */
        IF T-DET.CodCta BEGINS '423' THEN T-DET.CodDoc = '37'.
        IF T-DET.CodCta BEGINS '422' THEN T-DET.CodDoc = '34'.
        /*
        IF T-DET.CodCta BEGINS '421' AND T-DET.TpoMov = NO THEN T-DET.CodDoc = '01'.
        IF T-DET.CodCta BEGINS '421' AND T-DET.TpoMov = YES THEN T-DET.CodDoc = '07'.
        */
        IF T-DET.NroDoc = ? THEN T-DET.NroDoc = "".
        IF T-DET.CodDoc = ? THEN T-DET.CodDoc = "".
        IF T-DET.CodAux = ? THEN T-DET.CodAux = "".

        IF T-DET.CodDoc = '00' OR T-DET.CodDoc = 'DD' THEN T-DET.CodDoc = "".
    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 



/* TERCERO GENERAMOS LOS ASIENTOS */
FOR EACH T-DET NO-LOCK BREAK BY T-DET.Periodo BY T-DET.NroMes BY T-DET.CodOpe BY T-DET.NroAst:
    DISPLAY t-det.codope t-det.nroast t-det.codcta.
    PAUSE 0.
    IF FIRST-OF(T-DET.Periodo) 
        OR FIRST-OF(T-DET.NroMes)
        OR FIRST-OF(T-DET.CodOpe)
        OR FIRST-OF(T-DET.NroAst) THEN DO:
        CREATE cb-cmov.
        BUFFER-COPY T-DET
            TO cb-cmov
            ASSIGN
            /*cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)*/
            cb-cmov.FchAst = T-DET.FchDoc
            cb-cmov.NroAst = SUBSTRING(T-DET.NroAst,5,6)
            cb-cmov.Usuario = "AUTO".
    END.
    CREATE cb-dmov.
    BUFFER-COPY T-DET
        TO cb-dmov
        ASSIGN
        cb-dmov.NroAst = SUBSTRING(T-DET.NroAst,5,6).
END.
FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope:
    ASSIGN
        cb-cmov.HbeMn1 = 0
        cb-cmov.HbeMn2 = 0
        cb-cmov.HbeMn3 = 0
        cb-cmov.DbeMn1 = 0
        cb-cmov.DbeMn2 = 0
        cb-cmov.DbeMn3 = 0.
    FOR EACH cb-dmov OF cb-cmov:
        IF cb-dmov.TpoMov THEN     /* Tipo H */
            ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                    cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                    cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
        ELSE 
            ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
                   cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
                   cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
        /* NUMERO DE DOCUMENTO */
        IF LENGTH(cb-dmov.nrodoc) = 15 THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = STRING(INTEGER(SUBSTRING(cb-dmov.nrodoc,1,5)), '999') + '-' +
                TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6))))
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))).
            END.
            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
    END.
END.

RUN lib/logtabla ('INTERFACE',
                  "Operacion:" + cboOperacion + '|' + STRING(txtYear,"9999") + '|' + STRING(txtMes,"99") + '|' + s-user-id,
                  'OPENORANGE').


SESSION:SET-WAIT-STATE('').
MESSAGE "Proceso concluido...".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-diarios wWin 
PROCEDURE ue-diarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR s-periodo AS INT INIT 2014 NO-UNDO.     /* ??? */
DEF VAR s-nromes AS INT INIT 01 NO-UNDO.      /*  ???? */
/* ER:093, DI y CO : 005,058,059,065,070,071,075,076.080,091,092  */
DEF VAR s-codope AS CHAR INIT 'ZZZ' NO-UNDO.    /* ??? */  
DEF VAR sFiler1 AS CHARACTER.

DEF VAR s-nrodoc AS CHAR NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

/*
    059 : Salidas de Fondos
    092 : Rendicion de Gastos
    001 : Entrada de Fondos
*/
s-periodo = txtYear.
s-nromes = txtMes.
s-codope = cboOperacion /*"001".*/.

/*
FILL-IN-file = "C:\Ciman\MigrarSpeedToProgres\Conti\mov_ctable_conti_speed_a_progress_Ago2015_DI_CO_ER_" + s-codope + ".XLS".
FILL-IN-file = "C:\Ciman\Atenciones\OpenOrange\Asientos\EntradaFondos_0001_12_20160113-195446.xls".
*/

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls*", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

MESSAGE 'Esta seguro de cargar la INTERFACE?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

/* PRIMERO BORRAMOS ASIENTOS ANTES TRANSFERIDOS */
DELETE FROM cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope.
DELETE FROM cb-dmov WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = s-periodo
    AND cb-dmov.nromes = s-nromes
    AND cb-dmov.codope = s-codope.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 7.
    DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-File).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        DISPLAY t-row.
        PAUSE 0.
        /* asaeje - PERIODO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        CREATE T-DET.
        ASSIGN
            T-DET.CodCia = s-codcia
            T-DET.Periodo = iValue.
        /* asaper - MES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroMes = iValue.
        /* asacve - ASIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DET.NroAst = cValue.
        /* asaseq - ITEM */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroItm  = iValue.
        /* asacta - CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.CodCta = cValue.
        sFiler1 = trim(cValue).
        /* asacoa - CARGO O ABONO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.TpoMov = (IF cValue = "C" THEN NO ELSE YES).
        /* asare1 - DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroDoc = cValue.
        /* asare2 - TIPO DOCUMENTO*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        cValue = SUBSTRING(cValue,1,2).
        ASSIGN  T-DET.CodDoc = cValue.
        /*
        13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT
        IF cValue <> '' THEN DO:
            IF SUBSTRING(sFiler1,1,2)='14' OR SUBSTRING(sFiler1,1,3)='422' OR SUBSTRING(sFiler1,1,3)='469' THEN DO :
                /* Cuenta 14, el tipo dcto es 34 */
                T-DET.CodDoc = '34'.
            END.
            ELSE DO:
                FIND cb-tabl WHERE cb-tabl.Tabla = "A1"
                    AND cb-tabl.Codigo = cValue
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN T-DET.CodDoc = cb-tabl.Codcta.
            END.
        END.
        */
        /* asare3 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare4 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asafem - FECHA DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchDoc = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asave - FECHA DE VENCIMIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchVto = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asadde - GLOSA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.GloDoc = cValue.
        /* asamon - MONEDA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        ASSIGN T-DET.CodMon  = iValue + 1.
        /* asactc - ¿CODIGO TIPO DE CAMBIO? */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        /* asaimn - IMPORTE SOLES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn1 = dValue.
        /* asaime - IMPORTE DOLARES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn2 = dValue.
        /* asatca - T.C. */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.TpoCmb = dValue.
        /* asacco - CONCEPTO CONTABLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*ASSIGN T-DET.CodOpe = cValue.*/
        ASSIGN T-DET.CodOpe = s-codope.
        /* asata1 - TIPO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = trim(chWorkSheet:Cells(t-Row, t-Column):VALUE).
        T-DET.ClfAux = cvalue.
        IF cValue = "PR" THEN T-DET.ClfAux = "@PV".
        IF cValue = "TR" THEN T-DET.ClfAux = "@PV".
        /*IF cValue = "PE" THEN T-DET.ClfAux = "@PE".*/
       
        /* asaca1 - CODIGO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        cvalue = TRIM(cValue).
        IF SUBSTRING(sFiler1,1,2)='14' THEN DO :
            /* Codigo de Personal debe tener 8 digitos */
            T-DET.CodAux = cValue.
            IF LENGTH(cValue) < 8 THEN DO:
                cValue = FILL('0', 8 - (LENGTH(cValue))) + cValue.
                T-DET.CodAux = cValue.
            END.            
        END.
        ELSE DO:        
            /*T-DET.CodAux = SUBSTRING(cValue,3,8).*/
            T-DET.CodAux = cValue.
        END.
        /* asata2 - TIPO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaca2 - CODIGO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asacos - CENTRO DE COSTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.

        /* Parcheeee */
        /*FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia*/
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.libre_c01 = cValue NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN ASSIGN T-DET.Cco = cb-auxi.codaux.
        ELSE ASSIGN T-DET.Cco = cValue.
        /* asaact - ACTIVIDAD */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asagas - TIPO DE GASTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaid - SITUACION DEL DETALLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaimo - IMPORTE MONEDA DE ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatmno - VALOR DE CAMBIO MONEDA ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* flgdan - DEPURACION ANALISIS DE CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare5 - REFERENCIA 5*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        T-DET.gloast = cValue.
        /* asare6 - REFERENCIA 6*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr1 - TIPO 1*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr2 - TIPO 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xx_cta - CUENTA REAL */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* Para OpenOrange No vaaa
        IF cValue <> '' THEN T-DET.CodCta = cValue.
        */

        IF T-DET.Cco = ? THEN T-DET.Cco = ''.
        IF T-DET.codaux = ? THEN T-DET.Codaux = ''.        
        IF T-DET.ClfAux = ? THEN T-DET.ClfAux = ''.
        IF T-DET.coddoc = '00' OR T-DET.Cco = 'DD' THEN T-DET.coddoc = ''.
        IF T-DET.nrodoc = ? THEN T-DET.nrodoc = ''.
        IF T-DET.Coddoc = ? THEN T-DET.Coddoc = ''.

    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 


/* TERCERO GENERAMOS LOS ASIENTOS */
FOR EACH T-DET NO-LOCK BREAK BY T-DET.Periodo BY T-DET.NroMes BY T-DET.CodOpe BY T-DET.NroAst:
    DISPLAY t-det.codope t-det.nroast t-det.codcta.
    PAUSE 0.
    IF FIRST-OF(T-DET.Periodo) 
        OR FIRST-OF(T-DET.NroMes)
        OR FIRST-OF(T-DET.CodOpe)
        OR FIRST-OF(T-DET.NroAst) THEN DO:
        CREATE cb-cmov.
        BUFFER-COPY T-DET
            TO cb-cmov
            ASSIGN
            /*cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)*/
            cb-cmov.gloast = T-DET.gloast
            cb-cmov.FchAst = T-DET.FchDoc
            cb-cmov.NroAst = SUBSTRING(T-DET.NroAst,5,6)
            cb-cmov.Usuario = "AUTO".
    END.
    CREATE cb-dmov.
    BUFFER-COPY T-DET
        TO cb-dmov
        ASSIGN
        cb-dmov.NroAst = SUBSTRING(T-DET.NroAst,5,6).
END.
FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope:
    ASSIGN
        cb-cmov.HbeMn1 = 0
        cb-cmov.HbeMn2 = 0
        cb-cmov.HbeMn3 = 0
        cb-cmov.DbeMn1 = 0
        cb-cmov.DbeMn2 = 0
        cb-cmov.DbeMn3 = 0.
    FOR EACH cb-dmov OF cb-cmov:
        IF cb-dmov.TpoMov THEN     /* Tipo H */
            ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                    cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                    cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
        ELSE 
        ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
               cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
               cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
        /* NUMERO DE DOCUMENTO */
        IF LENGTH(cb-dmov.nrodoc) = 15 THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = STRING(INTEGER(SUBSTRING(cb-dmov.nrodoc,1,5)), '999') + '-' +
                TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6))))
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                /* Fac Electronicas */
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))).
            END.

            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
    END.

END.

RUN lib/logtabla ('INTERFACE',
                  "Operacion:" + cboOperacion + '|' + STRING(txtYear,"9999") + '|' + STRING(txtMes,"99") + '|' + s-user-id,
                  'OPENORANGE').


SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido...".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-pagos-bancarios wWin 
PROCEDURE ue-pagos-bancarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR pv-codcia AS INT INIT 000 NO-UNDO.
DEF VAR s-codope AS CHAR INIT '002' NO-UNDO.     /* Operacion */
DEF VAR s-periodo AS INT INIT 9999 NO-UNDO.      /* Año */
DEF VAR s-nromes AS INT INIT 99 NO-UNDO.          /* Mes */
DEF VAR s-nrodoc AS CHAR NO-UNDO.

DEF VAR sFiler1 AS CHARACTER.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

s-codope    = cboOperacion  /*'002'.*/.
s-periodo   = txtYear.
s-nromes    = txtMes.
/*
FILL-IN-file = "C:\Ciman\MigrarSpeedToProgres\Conti\mov_ctable_CONTI_speed_para_progress_Ago2015_RB_002.XLS".
FILL-IN-file = "C:\Ciman\Atenciones\OpenOrange\Asientos\PagosBancarios_12_20160118-180446.xls".
*/

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls*", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

MESSAGE 'Esta seguro de cargar la INTERFACE?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

/* PRIMERO BORRAMOS ASIENTOS ANTES TRANSFERIDOS */
DELETE FROM cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope.
DELETE FROM cb-dmov WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = s-periodo
    AND cb-dmov.nromes = s-nromes
    AND cb-dmov.codope = s-codope.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 7.
    DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-File).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        DISPLAY t-row.
        PAUSE 0.
        /* asaeje - PERIODO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 

        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        CREATE T-DET.
        ASSIGN
            T-DET.CodCia = s-codcia
            T-DET.Periodo = iValue.
        /* asaper - MES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroMes  = iValue.
        /* asacve - ASIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DET.NroAst = cValue.
        /* asaseq - ITEM */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroItm  = iValue.
        /* asacta - CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.CodCta = cValue.
        sFiler1 = trim(cValue).
        /* asacoa - CARGO O ABONO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.TpoMov = (IF cValue = "C" THEN NO ELSE YES).
        /* asare1 - DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroDoc = cValue.
        /* asare2 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue <> "" THEN T-DET.CodDoc = cValue.
        /*
        13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT
        IF cValue <> '' THEN DO:
            IF SUBSTRING(sFiler1,1,2)='14' OR SUBSTRING(sFiler1,1,3)='422' OR SUBSTRING(sFiler1,1,3)='469' THEN DO :
                /* Cuenta 14, el tipo dcto es 34 */
                T-DET.CodDoc = '34'.
            END.
            ELSE DO:
                FIND cb-tabl WHERE cb-tabl.Tabla = "A1"
                    AND cb-tabl.Codigo = cValue
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN T-DET.CodDoc = cb-tabl.Codcta.
            END.
        END.
        */
        /* asare3 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroRuc = cValue.
        /* asare4 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asafem - FECHA DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchDoc = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asave - FECHA DE VENCIMIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchVto = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asadde - GLOSA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.GloDoc = cValue.
        /* asamon - MONEDA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        ASSIGN T-DET.CodMon  = iValue.
        /* asactc - ¿CODIGO TIPO DE CAMBIO? */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        /* asaimn - IMPORTE SOLES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn1 = dValue.
        /* asaime - IMPORTE DOLARES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn2 = dValue.
        /* asatca - T.C. */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.TpoCmb = dValue.
        /* asacco - CONCEPTO CONTABLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*ASSIGN T-DET.CodOpe = cValue.*/
        ASSIGN T-DET.CodOpe = s-codope.
        /* asata1 - TIPO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        T-DET.ClfAux = (IF cValue = "PR" THEN "@PV" ELSE cValue).
        /* asaca1 - CODIGO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* 05Dic2015 - Viene desde OPEN
        T-DET.CodAux = SUBSTRING(cValue,3,8).
        */
        T-DET.CodAux = cValue.
        T-DET.CodAux = IF (T-DET.CodAux = ?) THEN '' ELSE T-DET.CodAux.

        /* asata2 - TIPO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaca2 - CODIGO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asacos - CENTRO DE COSTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.

        /*FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia*/
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.libre_c01 = cValue NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN ASSIGN T-DET.Cco = cb-auxi.codaux.
        ELSE ASSIGN T-DET.Cco = cValue.
        IF T-DET.Cco = ? THEN T-DET.Cco = "".
        /* asaact - ACTIVIDAD */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asagas - TIPO DE GASTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaid - SITUACION DEL DETALLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaimo - IMPORTE MONEDA DE ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatmno - VALOR DE CAMBIO MONEDA ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* flgdan - DEPURACION ANALISIS DE CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare5 - REFERENCIA 5*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare6 - REFERENCIA 6*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr1 - TIPO 1*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr2 - TIPO 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xxcta - CUENTA REAL */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
         /* Para OPENORANGE no va */
        /*IF cValue <> "" THEN T-DET.CodCta = cValue.*/

        /* tdoc - CODIGO DEL DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* AJUSTES FINALES */
        /* 13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT de SPEED
        IF T-DET.CodCta BEGINS '423' THEN T-DET.CodDoc = '37'.
        IF T-DET.CodCta BEGINS '421' AND T-DET.TpoMov = NO THEN T-DET.CodDoc = '01'.
        IF T-DET.CodCta BEGINS '421' AND T-DET.TpoMov = YES THEN T-DET.CodDoc = '07'.
        */

        /*
            Segun correo de Juan Hermosa del dia 05Dic2015, nueva interface desde OPEN
        */
        IF T-DET.CodCta BEGINS '423' THEN T-DET.CodDoc = '37'.
        /* Ic - 16Feb2016 - Segun correo del 16/02/2016 de Luis Urbano con aprobacion de Juan Hermoza se anulo
            es condicion, para que graba tal como viene del OpenOrange.
           
        IF T-DET.CodCta BEGINS '421' THEN T-DET.CodDoc = '01'.           
        */
        IF T-DET.CodCta BEGINS '422' THEN T-DET.CodDoc = '34'.

        IF T-DET.Cco = ? THEN T-DET.Cco = ''.
        IF T-DET.codaux = ? THEN T-DET.Codaux = ''.        
        IF T-DET.ClfAux = ? THEN T-DET.ClfAux = ''.
        IF T-DET.coddoc = '00' OR T-DET.Cco = 'DD' THEN T-DET.coddoc = ''.
        IF T-DET.nrodoc = ? THEN T-DET.nrodoc = ''.
        IF T-DET.Coddoc = ? THEN T-DET.Coddoc = ''.

    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 

/* TERCERO GENERAMOS LOS ASIENTOS */
    FOR EACH T-DET WHERE T-DET.codcta BEGINS '12':
        DISPLAY 'borrando' t-det.nroast t-det.codcta.
        PAUSE 0.
        DELETE T-DET.
    END.

    FOR EACH T-DET NO-LOCK BREAK BY T-DET.Periodo BY T-DET.NroMes BY T-DET.CodOpe BY T-DET.NroAst:
        DISPLAY 'generando' t-det.codope t-det.nroast t-det.codcta.
        PAUSE 0.
        IF FIRST-OF(T-DET.Periodo) 
            OR FIRST-OF(T-DET.NroMes)
            OR FIRST-OF(T-DET.CodOpe)
            OR FIRST-OF(T-DET.NroAst) THEN DO:
            CREATE cb-cmov.
            BUFFER-COPY T-DET
                TO cb-cmov
                ASSIGN
                /*cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)*/
                cb-cmov.FchAst = T-DET.FchDoc
                cb-cmov.NroAst = SUBSTRING(T-DET.NroAst,5,6)
                cb-cmov.Usuario = "AUTO".
        END.
        CREATE cb-dmov.
        BUFFER-COPY T-DET
            TO cb-dmov
            ASSIGN
            cb-dmov.NroAst = SUBSTRING(T-DET.NroAst,5,6).
    END.
    FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
        AND cb-cmov.periodo = s-periodo
        AND cb-cmov.nromes = s-nromes
        AND cb-cmov.codope = s-codope:
        DISPLAY 'acumulando' cb-cmov.nroast.
        PAUSE 0.
        ASSIGN
            cb-cmov.HbeMn1 = 0
            cb-cmov.HbeMn2 = 0
            cb-cmov.HbeMn3 = 0
            cb-cmov.DbeMn1 = 0
            cb-cmov.DbeMn2 = 0
            cb-cmov.DbeMn3 = 0.
        FOR EACH cb-dmov OF cb-cmov NO-LOCK:
            IF cb-dmov.TpoMov THEN     /* Tipo H */
                ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                        cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                        cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
            ELSE 
                ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
                       cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
                       cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
        END.
    END.


/* Borramos errores  */
FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope
    AND ABS(cb-cmov.dbemn1 - cb-cmov.hbemn1) > 1:
    FOR EACH cb-dmov OF cb-cmov:
        DELETE cb-dmov.
    END.
    ASSIGN
        cb-cmov.DbeMn1 = 0
        cb-cmov.DbeMn2 = 0
        cb-cmov.DbeMn3 = 0
        cb-cmov.HbeMn1 = 0
        cb-cmov.HbeMn2 = 0
        cb-cmov.HbeMn3 = 0.
END.

/* Borrar Cabecers con CERO que no tienen detalles */
    FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
        AND cb-cmov.periodo = s-periodo
        AND cb-cmov.nromes = s-nromes
        AND cb-cmov.codope = s-codope:
        
        IF cb-cmov.HbeMn1 = 0 AND cb-cmov.HbeMn2 = 0 AND cb-cmov.DbeMn1 = 0 AND cb-cmov.DbeMn2 = 0 THEN DO:
               DELETE cb-cmov.
        END.

    END.


FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope:
    FOR EACH cb-dmov OF cb-cmov:
        DISPLAY 'Verificando NroDctos : ' cb-dmov.codope cb-dmov.nroast cb-dmov.codcta cb-dmov.nrodoc.
        PAUSE 0.
        /* RUC DEL PROVEEDOR */
        IF cb-dmov.clfaux = "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = cb-dmov.codaux
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN cb-dmov.NroRuc =  gn-prov.Ruc.
        END.
        /* NUMERO DE DOCUMENTO */
        IF (cb-dmov.codcta BEGINS '421' OR cb-dmov.codcta BEGINS '424' OR cb-dmov.codcta BEGINS '422' OR cb-dmov.codcta BEGINS '43')
            AND LENGTH(cb-dmov.nrodoc) = 15
            THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = STRING(INTEGER(SUBSTRING(cb-dmov.nrodoc,1,5)), '999') + '-' +
                TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6))))
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                /* Fac Electronicas */
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    s-NroDoc = cb-dmov.NroDoc.
                END.
            END.
            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
        IF (cb-dmov.codcta BEGINS '423') AND LENGTH(cb-dmov.nrodoc) = 15
            THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = TRIM(STRING(DECIMAL(cb-dmov.nrodoc))) NO-ERROR. 
            IF ERROR-STATUS:ERROR THEN DO:
                /* Fac Electronicas */
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    s-NroDoc = cb-dmov.NroDoc.
                END.
            END.
            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
        IF cb-dmov.codcta BEGINS '422' THEN cb-dmov.coddoc = '34'.  /* ANTICIPOS */

        /* Juan hermosa correo 07Dic2015 */
        IF cb-dmov.codcta = '94639161' AND (cb-dmov.Cco = ? OR cb-dmov.Cco = '') THEN DO:
            ASSIGN cb-dmov.Cco = '04'.
        END.

    END.
END.

RUN lib/logtabla ('INTERFACE',
                  "Operacion :" + cboOperacion + '|' + STRING(txtYear,"9999") + '|' + STRING(txtMes,"99") + '|' + s-user-id,
                  'OPENORANGE').

SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido...".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar wWin 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-CAB.
EMPTY TEMP-TABLE T-DET.

CASE cboOperacion :
    WHEN '060' THEN DO:
        /* Compras */
        RUN ue-registro-compras.
    END.
    WHEN '002' THEN DO:
        /* Pagos Bancarios */
        RUN ue-pagos-bancarios.
    END.
    WHEN '061' THEN DO:
        /* Canje Documentos */
        RUN ue-canje-documentos.
    END.
    WHEN '059' THEN DO:
        /* Salidas de Fondos */
        RUN ue-diarios.
    END.
    WHEN '001' THEN DO:
        /* Entrada de Fondos */
        RUN ue-diarios.
    END.
    WHEN '092' THEN DO:
        /* Rendicion de Gastos */
        RUN ue-diarios.
    END.

END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-registro-compras wWin 
PROCEDURE ue-registro-compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
DEF VAR cb-codcia AS INT INIT 000 NO-UNDO.
DEF VAR pv-codcia AS INT INIT 000 NO-UNDO.
DEF VAR s-periodo AS INT INIT 9999 NO-UNDO.          /* Año */
DEF VAR s-nromes AS INT INIT 99 NO-UNDO.             /* Mes */
DEF VAR s-codope AS CHAR INIT 'ZZZ' NO-UNDO.        /* Operacion */
DEF VAR s-nrodoc AS CHAR NO-UNDO.

DEF VAR sFiler1 AS CHARACTER.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO. 
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.

s-periodo = txtYear.
s-nromes = txtMes.
s-codope = cboOperacion /*'060'.*/.
/*
FILL-IN-file = "C:\Ciman\MigrarSpeedToProgres\Conti\mov_ctable_CONTI_speed_para_progress_Ago2015_RC_060.xls".
FILL-IN-file = "C:\Ciman\Atenciones\OpenOrange\Asientos\RegCompras_12_20160118-184102.xls".
*/

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls,*.xlsx)" "*.xls*", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

MESSAGE 'Esta seguro de cargar la INTERFACE?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

SESSION:SET-WAIT-STATE('GENERAL').

/* PRIMERO BORRAMOS ASIENTOS ANTES TRANSFERIDOS */
DELETE FROM cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope.
DELETE FROM cb-dmov WHERE cb-dmov.codcia = s-codcia
    AND cb-dmov.periodo = s-periodo
    AND cb-dmov.nromes = s-nromes
    AND cb-dmov.codope = s-codope.

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE.

    DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iValue          AS INTEGER      NO-UNDO.
    DEFINE VARIABLE dValue          AS DECIMAL      NO-UNDO.
    DEFINE VARIABLE t-Column        AS INTEGER INIT 1.
    DEFINE VARIABLE t-Row           AS INTEGER INIT 7.
    DEFINE VARIABLE i-Column        AS INTEGER     NO-UNDO.

    CREATE "Excel.Application" chExcelApplication.
    chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-File).
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    t-Row = 1.     /* Saltamos el encabezado de los campos */
    REPEAT:
        ASSIGN
            t-column = 0
            t-Row    = t-Row + 1.
        DISPLAY t-row.
        PAUSE 0.
        /* asaeje - PERIODO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */ 
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        CREATE T-DET.
        ASSIGN
            T-DET.CodCia = s-codcia
            T-DET.Periodo = iValue.
        /* asaper - MES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroMes  = iValue.
        /* asacve - ASIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN
            T-DET.NroAst = cValue.
        /*
        /* Ic - Fecha del Comprobnate */
        cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)
        Dte_05
        */
        /* asaseq - ITEM */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN T-DET.NroItm  = iValue.
        /* asacta - CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.CodCta = cValue.
        sFiler1 = trim(cValue).
        /* asacoa - CARGO O ABONO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.TpoMov = (IF cValue = "C" THEN NO ELSE YES).
        /* asare1 - DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroDoc = cValue.
        IF (T-DET.codcta BEGINS '601'
            OR T-DET.codcta BEGINS '604'
            OR T-DET.codcta BEGINS '605'
            OR T-DET.codcta BEGINS '606') THEN T-DET.ordcmp = cValue.
        /* asare2 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroRef = cValue.
        /* asare3 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN  T-DET.NroRuc = cValue.
        /* asare4 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asafem - FECHA DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchDoc = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asave - FECHA DE VENCIMIENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND iValue > 0 THEN 
            ASSIGN T-DET.FchVto = DATE(INTEGER(SUBSTRING(cValue,5,2)),
                                       INTEGER(SUBSTRING(cValue,7)),
                                       INTEGER(SUBSTRING(cValue,1,4)))
            NO-ERROR.
        /* asadde - GLOSA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN T-DET.GloDoc = cValue.
        /* asamon - MONEDA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = INTEGER(cValue) NO-ERROR.
        ASSIGN T-DET.CodMon  = iValue + 1.

        /* asactc - ¿CODIGO TIPO DE CAMBIO? */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN iValue = DECIMAL(cValue) NO-ERROR.

        /* asaimn - IMPORTE SOLES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn1 = dValue.
        /* asaime - IMPORTE DOLARES */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.ImpMn2 = dValue.
        /* asatca - T.C. */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        ASSIGN dValue = DECIMAL(cValue) NO-ERROR.
        IF ERROR-STATUS:ERROR = NO THEN ASSIGN T-DET.TpoCmb = dValue.
        /* asacco - CONCEPTO CONTABLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*ASSIGN T-DET.CodOpe = cValue.*/
        ASSIGN T-DET.CodOpe = "060".
        /* asata1 - TIPO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        T-DET.ClfAux = (IF cValue = "PR" THEN "@PV" ELSE cValue).
        /* asaca1 - CODIGO AUXILIAR 1 */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*T-DET.CodAux = SUBSTRING(cValue,3,8).  /*??????????????????????*/*/
        T-DET.CodAux = cValue.  /*??????????????????????*/

        /* asata2 - TIPO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaca2 - CODIGO AUXILIAR 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asacos - CENTRO DE COSTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.

        /* Parcheeee */
        /*FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia*/
        FIND cb-auxi WHERE cb-auxi.codcia = 0
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.libre_c01 = cValue NO-LOCK NO-ERROR.
        IF AVAILABLE cb-auxi THEN ASSIGN T-DET.Cco = cb-auxi.codaux.
        ELSE ASSIGN T-DET.Cco = cValue.
        IF T-DET.Cco = ? THEN T-DET.Cco = "".
        /* asaact - ACTIVIDAD */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asagas - TIPO DE GASTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaid - SITUACION DEL DETALLE */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asaimo - IMPORTE MONEDA DE ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatmno - VALOR DE CAMBIO MONEDA ORIGEN */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* flgdan - DEPURACION ANALISIS DE CUENTA */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare5 - REFERENCIA 5*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asare6 - REFERENCIA 6*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr1 - TIPO 1*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* asatr2 - TIPO 2*/
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xxcta - CUENTA REAL */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /*IF cValue <> "" THEN T-DET.CodCta = cValue.    ??????????????????*/    
        /* xxcmpt */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xxsec */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* xx_ope */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        /* tdoc - CODIGO DEL DOCUMENTO */
        t-column = t-column + 1.
        cValue = chWorkSheet:Cells(t-Row, t-Column):VALUE.
        IF cValue <> "" THEN T-DET.CodDoc = cValue.
        /*
        13Abr2015, desde el proceso de VFP ya viene con el codigo se SUNAT
        IF cValue <> '' THEN DO:
            IF SUBSTRING(sFiler1,1,2)='14' OR SUBSTRING(sFiler1,1,3)='422' OR SUBSTRING(sFiler1,1,3)='469' THEN DO :
                /* Cuenta 14, el tipo dcto es 34 */
                T-DET.CodDoc = '34'.
            END.
            ELSE DO:
                FIND cb-tabl WHERE cb-tabl.Tabla = "A1"
                    AND cb-tabl.Codigo = cValue
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cb-tabl THEN T-DET.CodDoc = cb-tabl.Codcta.
            END.
        END.
        */
        /* TM: Tipo de Monto */
        IF T-DET.CodCta BEGINS "6" OR T-DET.CodCta BEGINS "9" THEN T-DET.TM = 03.
        IF T-DET.CodCta BEGINS "40" THEN T-DET.TM = 06.
        IF T-DET.CodCta BEGINS "42" OR T-DET.CodCta BEGINS "46" THEN T-DET.TM = 08.

        IF T-DET.Cco = ? THEN T-DET.Cco = ''.
        IF T-DET.codaux = ? THEN T-DET.Codaux = ''.        
        IF T-DET.ClfAux = ? THEN T-DET.ClfAux = ''.
        IF T-DET.coddoc = '00' OR T-DET.Cco = 'DD' THEN T-DET.coddoc = ''.
        IF T-DET.nrodoc = ? THEN T-DET.nrodoc = ''.
        IF T-DET.Coddoc = ? THEN T-DET.Coddoc = ''.

        
    END.
    chExcelApplication:QUIT().
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet. 



/* TERCERO GENERAMOS LOS ASIENTOS */
FOR EACH T-DET:
    IF T-DET.codcta BEGINS '20' OR T-DET.codcta BEGINS '61' THEN DELETE T-DET.
END.

FOR EACH T-DET NO-LOCK BREAK BY T-DET.Periodo BY T-DET.NroMes BY T-DET.CodOpe BY T-DET.NroAst:
    DISPLAY t-det.codope t-det.nroast t-det.codcta.
    PAUSE 0.
    IF FIRST-OF(T-DET.Periodo) 
        OR FIRST-OF(T-DET.NroMes)
        OR FIRST-OF(T-DET.CodOpe)
        OR FIRST-OF(T-DET.NroAst) THEN DO:
        CREATE cb-cmov.
        BUFFER-COPY T-DET
            TO cb-cmov
            ASSIGN
            /*cb-cmov.FchAst = DATE(T-DET.NroMes, 01, T-DET.Periodo)*/
            cb-cmov.FchAst = T-DET.FchDoc
            cb-cmov.NroAst = SUBSTRING(T-DET.NroAst,5,6)
            cb-cmov.Usuario = "AUTO".
    END.
    CREATE cb-dmov.
    BUFFER-COPY T-DET
        TO cb-dmov
        ASSIGN
        cb-dmov.NroAst = SUBSTRING(T-DET.NroAst,5,6).
END.
/* PARCHES */
DEF BUFFER b-dmov FOR cb-dmov.
FOR EACH cb-cmov WHERE cb-cmov.codcia = s-codcia
    AND cb-cmov.periodo = s-periodo
    AND cb-cmov.nromes = s-nromes
    AND cb-cmov.codope = s-codope:
    ASSIGN
        cb-cmov.HbeMn1 = 0
        cb-cmov.HbeMn2 = 0
        cb-cmov.HbeMn3 = 0
        cb-cmov.DbeMn1 = 0
        cb-cmov.DbeMn2 = 0
        cb-cmov.DbeMn3 = 0.
    FOR EACH cb-dmov OF cb-cmov:
        /* ACUMULADOS */
        IF cb-dmov.TpoMov THEN     /* Tipo H */
            ASSIGN  cb-cmov.HbeMn1 = cb-cmov.HbeMn1 + cb-dmov.ImpMn1
                    cb-cmov.HbeMn2 = cb-cmov.HbeMn2 + cb-dmov.ImpMn2
                    cb-cmov.HbeMn3 = cb-cmov.HbeMn3 + cb-dmov.ImpMn3.
        ELSE 
            ASSIGN cb-cmov.DbeMn1 = cb-cmov.DbeMn1 + cb-dmov.ImpMn1
                   cb-cmov.DbeMn2 = cb-cmov.DbeMn2 + cb-dmov.ImpMn2
                   cb-cmov.DbeMn3 = cb-cmov.DbeMn3 + cb-dmov.ImpMn3.
        /* RUC DEL PROVEEDOR */
        IF cb-dmov.clfaux = "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = cb-dmov.codaux
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN cb-dmov.NroRuc =  gn-prov.Ruc.
        END.
        /* NUMERO DE DOCUMENTO */
        /* 422 : 27Set2013, Juan Hermoza */
        IF (cb-dmov.codcta BEGINS '422' OR cb-dmov.codcta BEGINS '421' OR cb-dmov.codcta BEGINS '424' OR cb-dmov.codcta BEGINS '40' OR cb-dmov.codcta BEGINS '43')
            AND LENGTH(cb-dmov.nrodoc) = 15
            THEN DO:
            s-NroDoc = cb-dmov.NroDoc.
            ASSIGN
                s-NroDoc = STRING(INTEGER(SUBSTRING(cb-dmov.nrodoc,1,5)), '999') + '-' +
                TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                /* Fac Electronicas */
                s-nrodoc = SUBSTRING(cb-dmov.nrodoc,1,5) + "-" + TRIM(STRING(DECIMAL(SUBSTRING(cb-dmov.nrodoc,6)))) NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    s-NroDoc = cb-dmov.NroDoc.
                END.
            END.
            ASSIGN
                cb-dmov.NroDoc = s-NroDoc.
        END.
    END.
    FIND FIRST cb-dmov OF cb-cmov WHERE cb-dmov.codcta BEGINS '4'
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-dmov THEN DO:
        FOR EACH b-dmov OF cb-cmov WHERE b-dmov.codcta BEGINS '9':
            ASSIGN
                b-dmov.coddoc = cb-dmov.coddoc
                b-dmov.nrodoc = cb-dmov.nrodoc.
        END.
    END.
END.

RUN lib/logtabla ('INTERFACE',
                  "Operacion:" + cboOperacion + '|' + STRING(txtYear,"9999") + '|' + STRING(txtMes,"99") + '|' + s-user-id,
                  'OPENORANGE').


SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso concluido...".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

