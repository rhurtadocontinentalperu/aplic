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
{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR s-coddoc AS CHAR INIT 'H/R' NO-UNDO.

DEF TEMP-TABLE DETALLE-1
    FIELD CodCia AS INT
    FIELD Fecha  AS DATE
    FIELD Canal  AS CHAR
    FIELD CodDepto AS CHAR
    FIELD CodProvi AS CHAR
    FIELD CodDistr AS CHAR
    FIELD CanDes AS DEC
    FIELD ImpDes AS DEC
    FIELD CanDev AS DEC
    FIELD ImpDev AS DEC
    FIELD ImpTot AS DEC
    INDEX Llave01 AS PRIMARY CodCia Fecha Canal.
    
DEF TEMP-TABLE DETALLE-2
    FIELD CodCia AS INT
    FIELD Fecha  AS DATE
    FIELD CodCli AS CHAR.

DEF TEMP-TABLE DETALLE-3
    FIELD CodCia AS INT
    FIELD CodDepto AS CHAR
    FIELD CodProvi AS CHAR
    FIELD CodDistr AS CHAR
    FIELD Canal  AS CHAR
    FIELD CanDes AS DEC
    FIELD ImpDes AS DEC
    FIELD CanDev AS DEC
    FIELD ImpDev AS DEC
    FIELD ImpTot AS DEC
    INDEX Llave01 AS PRIMARY CodCia Canal.

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
&Scoped-Define ENABLED-OBJECTS Btn_OK FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
Btn_Done x-CodMon BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "OK" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 1.58 COL 46
     FILL-IN-Fecha-1 AT ROW 1.77 COL 21 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 2.92 COL 21 COLON-ALIGNED
     Btn_Done AT ROW 3.5 COL 46
     x-CodMon AT ROW 3.88 COL 23 NO-LABEL
     BUTTON-1 AT ROW 5.31 COL 46 WIDGET-ID 2
     "Fechas de Salida del vehículo" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 1.19 COL 2
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.08 COL 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.14 BY 6.62
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
         TITLE              = "INFORME SEMANAL AREA DE DISTRIBUCION POR DISTRITO"
         HEIGHT             = 6.62
         WIDTH              = 66.14
         MAX-HEIGHT         = 6.62
         MAX-WIDTH          = 66.14
         VIRTUAL-HEIGHT     = 6.62
         VIRTUAL-WIDTH      = 66.14
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* INFORME SEMANAL AREA DE DISTRIBUCION POR DISTRITO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INFORME SEMANAL AREA DE DISTRIBUCION POR DISTRITO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:
  ASSIGN
    FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon.
    RUN Carga-Temporal-1.
    FIND FIRST DETALLE-1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE-1 THEN DO:
        MESSAGE
            'No hay información a imprimir'
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Excel.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-1 W-Win 
PROCEDURE Carga-Temporal-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-ImpDev AS DEC NO-UNDO.
  
  EMPTY TEMP-TABLE DETALLE-1.
  EMPTY TEMP-TABLE DETALLE-2.
  EMPTY TEMP-TABLE DETALLE-3.
  
  FOR EACH Di-RutaC NO-LOCK WHERE di-rutac.codcia = s-codcia
        AND di-rutac.coddiv = s-coddiv
        AND di-rutac.coddoc = s-coddoc
        AND di-rutac.fchsal >= FILL-IN-Fecha-1
        AND di-rutac.fchsal <= FILL-IN-Fecha-2
        AND di-rutac.flgest = 'C':
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK /*WHERE LOOKUP(di-rutad.flgest, 'C,X,D') > 0*/,   /* RHC 06.07.11 todos los documentos */
            FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = di-rutad.codcia
                AND ccbcdocu.coddoc = di-rutad.codref
                AND ccbcdocu.nrodoc = di-rutad.nroref,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = ccbcdocu.codcli:
        /* resumen por dia y por distrito del cliente */
        FIND DETALLE-1 WHERE detalle-1.codcia = di-rutac.codcia
            AND detalle-1.coddepto = gn-clie.CodDept 
            AND detalle-1.codprovi = gn-clie.CodProv 
            AND detalle-1.coddistr = gn-clie.CodDist
            AND detalle-1.fecha = di-rutac.fchsal
            NO-ERROR.
        IF NOT AVAILABLE DETALLE-1
        THEN CREATE DETALLE-1.
        ASSIGN
            DETALLE-1.codcia = di-rutac.codcia
            detalle-1.coddepto = gn-clie.CodDept 
            detalle-1.codprovi = gn-clie.CodProv 
            detalle-1.coddistr = gn-clie.CodDist
            DETALLE-1.fecha  = di-rutac.fchsal.
        /* RHC 06.07.11 Ordenamos primero LIMA */
        IF Detalle-1.CodDepto = '15' AND Detalle-1.CodProvi = '01' THEN Detalle-1.Canal = 'A'.
        ELSE Detalle-1.Canal = 'B'.
        /* contador de clientes */
        FIND DETALLE-2 WHERE detalle-2.codcia = di-rutac.codcia
            AND detalle-2.fecha = di-rutac.fchsal
            AND detalle-2.codcli = ccbcdocu.codcli
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE-2
        THEN DO:
            ASSIGN 
                DETALLE-1.candes = DETALLE-1.candes + 1.
            IF LOOKUP(di-rutad.flgest, 'X,D') > 0
            THEN DETALLE-1.candev = DETALLE-1.candev + 1.
            CREATE DETALLE-2.
            ASSIGN
                detalle-2.codcia = di-rutac.codcia
                detalle-2.fecha  = di-rutac.fchsal
                detalle-2.codcli = ccbcdocu.codcli.
        END.
        IF x-codmon = ccbcdocu.codmon
        THEN x-ImpTot = ccbcdocu.imptot.
        ELSE IF x-codmon = 1
                THEN x-ImpTot = ccbcdocu.imptot * ccbcdocu.tpocmb.
                ELSE x-ImpTot = ccbcdocu.imptot / ccbcdocu.tpocmb.
        DETALLE-1.impdes = DETALLE-1.impdes + x-imptot.
                            
        /* Importe de las devoluciones */
        CASE di-rutad.flgest:
            /*WHEN 'X' THEN ASSIGN DETALLE-1.impdev = DETALLE-1.impdev + x-imptot.*/
            WHEN 'C' THEN .     /* RHC 06.07.11 Entregado totalmente */
            WHEN 'D' THEN DO:   /* Devolucion parcial */
                FOR EACH Di-RutaDv WHERE di-rutadv.codcia = di-rutac.codcia
                           AND di-rutadv.coddiv = di-rutac.coddiv
                           AND di-rutadv.coddoc = di-rutac.coddoc
                           AND di-rutadv.nrodoc = di-rutac.nrodoc
                           AND di-rutadv.codref = di-rutad.codref
                           AND di-rutadv.nroref = di-rutad.nroref
                           AND di-rutadv.candev > 0
                           NO-LOCK:
                    FIND FIRST ccbddocu OF ccbcdocu WHERE ccbddocu.codmat = di-rutadv.codmat NO-LOCK.
                    IF x-codmon = ccbcdocu.codmon 
                        THEN x-ImpDev = di-rutadv.candev * (ccbddocu.implin / ccbddocu.candes).
                    ELSE IF x-codmon = 1 
                        THEN x-ImpDev = di-rutadv.candev * (ccbddocu.implin / ccbddocu.candes) * ccbcdocu.tpocmb.
                    ELSE x-ImpDev = di-rutadv.candev * (ccbddocu.implin / ccbddocu.candes) / ccbcdocu.tpocmb.
                    DETALLE-1.impdev = DETALLE-1.impdev + x-ImpDev.
                END.
            END.
            OTHERWISE ASSIGN DETALLE-1.impdev = DETALLE-1.impdev + x-imptot.   /* Devolucion total o retorno de mercaderia */
        END CASE.
    END.
  END.        
  
  /* ACUMULAMOS TOTALES */
  FOR EACH DETALLE-1:
    ASSIGN
        DETALLE-1.imptot = DETALLE-1.impdes - DETALLE-1.impdev.
    FIND DETALLE-3 WHERE detalle-3.codcia = detalle-1.codcia
        AND detalle-3.coddepto = detalle-1.coddepto
        AND detalle-3.codprovi = detalle-1.codprovi
        AND detalle-3.coddistr = detalle-1.coddistr
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE-3 THEN CREATE DETALLE-3.
    ASSIGN
        DETALLE-3.codcia = DETALLE-1.codcia
        DETALLE-3.canal    = DETALLE-1.canal        /* OJO */
        DETALLE-3.coddepto = DETALLE-1.coddepto
        DETALLE-3.codprovi = DETALLE-1.codprovi
        DETALLE-3.coddistr = DETALLE-1.coddistr
        DETALLE-3.candes = DETALLE-3.candes + DETALLE-1.candes
        DETALLE-3.impdes = DETALLE-3.impdes + DETALLE-1.impdes
        DETALLE-3.candev = DETALLE-3.candev + DETALLE-1.candev
        DETALLE-3.impdev = DETALLE-3.impdev + DETALLE-1.impdev
        DETALLE-3.imptot = DETALLE-3.impdes - DETALLE-3.impdev.
  END.

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn_OK FILL-IN-Fecha-1 FILL-IN-Fecha-2 Btn_Done x-CodMon BUTTON-1 
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

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

DEF VAR x-Nombre AS CHAR NO-UNDO.
DEF VAR x-CanDes AS DEC INIT 0 NO-UNDO.
DEF VAR x-ImpDes AS DEC INIT 0 NO-UNDO.
DEF VAR x-CanDev AS DEC INIT 0 NO-UNDO.
DEF VAR x-ImpDev AS DEC INIT 0 NO-UNDO.
DEF VAR x-ImpTot AS DEC INIT 0 NO-UNDO.  
DEF VAR x-PorTot AS DEC INIT 0 NO-UNDO.
DEF VAR x-SubTit AS CHAR FORMAT 'x(50)' NO-UNDO.
  
x-SubTit = 'IMPORTES EXPRESADOS EN ' + IF x-codmon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS'.

chWorkSheet:Range("A1"):Value = s-NomCia.
chWorkSheet:Range("A2"):Value = "( " + S-CODDIV + ")".
chWorkSheet:Range("A3"):Value = "Desde : " + STRING (FILL-IN-Fecha-1,"99/99/9999") +  " hasta el " + STRING (FILL-IN-Fecha-2,"99/99/9999").
chWorkSheet:Range("A4"):Value = x-SubTit.
chWorkSheet:Range("A5"):Value = "Dia".
chWorkSheet:Range("B5"):Value = "Distrito".
chWorkSheet:Range("C5"):Value = "Descripcion".
chWorkSheet:Range("D5"):Value = "Cantidad Despachada".
chWorkSheet:Range("E5"):Value = "Monto Despachado".
chWorkSheet:Range("F5"):Value = "Devoluciones".
chWorkSheet:Range("G5"):Value = "Monto Devoluciones".
chWorkSheet:Range("H5"):Value = "Total Despacho".
chWorkSheet:Range("I5"):Value = "% Monto Total Despacho".

chWorkSheet = chExcelApplication:Sheets:Item(1).


FOR EACH DETALLE-1 BREAK BY DETALLE-1.codcia BY DETALLE-1.Fecha BY DETALLE-1.Canal BY DETALLE-1.CodDistr:
    ASSIGN
        t-column = t-column + 1
        cColumn = STRING(t-Column).
    x-Nombre = ''.
    FIND TabDistr OF DETALLE-1 NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN x-Nombre = TabDistr.NomDistr.

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.fecha.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.coddistr.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Nombre.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.candes.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.impdes.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.candev.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.impdev.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-1.imptot.

    ACCUMULATE DETALLE-1.candes (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.candes (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.impdes (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.impdes (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.candev (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.candev (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.impdev (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.impdev (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.imptot (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.imptot (SUB-TOTAL BY DETALLE-1.fecha).
    IF LAST-OF(DETALLE-1.Fecha)
    THEN DO:
        ASSIGN
            t-column = t-column + 1
            cColumn = STRING(t-Column).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "TOTAL DIARIO >>>".
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.candes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.impdes.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.candev.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.impdev.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.imptot.
        ASSIGN
            t-column = t-column + 1.
    END.
    IF LAST-OF(DETALLE-1.CodCia)
    THEN DO:
        ASSIGN
            x-CanDes = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.candes
            x-ImpDes = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.impdes 
            x-CanDev = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.candev 
            x-ImpDev = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.impdev 
            x-ImpTot = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.imptot.
    END.
  END.  

  ASSIGN
      t-column = t-column + 1
      cColumn = STRING(t-Column).
  cRange = "A" + cColumn.
  chWorkSheet:Range(cRange):Value = "DETALLE SEMANAL".
  FOR EACH DETALLE-3 BREAK BY DETALLE-3.CodCia BY DETALLE-3.Canal BY DETALLE-3.CodDistr:
      ASSIGN
          t-column = t-column + 1
          cColumn = STRING(t-Column).
    x-Nombre = ''.
    FIND TabDistr OF DETALLE-3 NO-LOCK NO-ERROR.
    x-PorTot = IF x-impdes <> 0 THEN DETALLE-3.impdes / x-impdes * 100 ELSE 0.
    IF AVAILABLE TabDistr THEN x-Nombre = TabDistr.NomDistr.
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.coddistr.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Nombre.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.candes.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.impdes.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.candev.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.impdev.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = DETALLE-3.imptot.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-portot.
    IF LAST-OF(DETALLE-3.codcia)
    THEN DO:
        ASSIGN
            t-column = t-column + 1
            cColumn = STRING(t-Column).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = x-candes.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = x-impdes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = x-candev.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = x-impdev.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = x-imptot.
    END.
END.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

HIDE FRAME F-PROCESO.

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
  DEF VAR x-Nombre AS CHAR NO-UNDO.
  DEF VAR x-CanDes AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpDes AS DEC INIT 0 NO-UNDO.
  DEF VAR x-CanDev AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpDev AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpTot AS DEC INIT 0 NO-UNDO.  
  DEF VAR x-PorTot AS DEC INIT 0 NO-UNDO.
  DEF VAR x-SubTit AS CHAR FORMAT 'x(50)' NO-UNDO.
  
  x-SubTit = 'IMPORTES EXPRESADOS EN ' + IF x-codmon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS'.
  DEFINE FRAME FC-REP
    DETALLE-1.fecha     COLUMN-LABEL "Dia"                         
    DETALLE-1.coddistr  COLUMN-LABEL "Distrito"             FORMAT "x(5)"
    x-Nombre            COLUMN-LABEL "Descripcion"          FORMAT "x(25)"
    DETALLE-1.candes    COLUMN-LABEL "Cantidad!Despachada"  FORMAT ">>>,>>9"
    DETALLE-1.impdes    COLUMN-LABEL "Monto!Despachado"     FORMAT ">>>,>>>,>>9.99"
    DETALLE-1.candev    COLUMN-LABEL "Devoluciones"         FORMAT ">>>,>>9"
    DETALLE-1.impdev    COLUMN-LABEL "Monto!Devoluciones"   FORMAT ">>>,>>>,>>9.99"
    DETALLE-1.ImpTot    COLUMN-LABEL "Total!Despacho"       FORMAT ">>>,>>>,>>9.99"
    x-PorTot            COLUMN-LABEL "% Monto!Total Desp."  FORMAT ">>9.99"
    WITH WIDTH 150 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + S-CODDIV + ")"  FORMAT "X(15)"
    "INFORME SEMANAL AREA DE DISTRIBUCION POR DISTRITO" AT 30
    "Pag.  : " AT 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 100 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Desde : " FILL-IN-Fecha-1 FORMAT "99/99/9999" "hasta el" FILL-IN-Fecha-2 FORMAT "99/99/9999" SKIP
    x-SubTit SKIP
    WITH PAGE-TOP WIDTH 150 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH DETALLE-1 BREAK BY DETALLE-1.codcia BY DETALLE-1.Fecha BY DETALLE-1.Canal BY DETALLE-1.CodDistr:
    VIEW STREAM REPORT FRAME H-REP.
    x-Nombre = ''.
    FIND TabDistr OF DETALLE-1 NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN x-Nombre = TabDistr.NomDistr.
    DISPLAY STREAM REPORT
        DETALLE-1.fecha     
        DETALLE-1.coddistr
        x-Nombre
        DETALLE-1.candes    
        DETALLE-1.impdes    
        DETALLE-1.candev    
        DETALLE-1.impdev    
        DETALLE-1.ImpTot
        WITH FRAME FC-REP.      
    ACCUMULATE DETALLE-1.candes (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.candes (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.impdes (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.impdes (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.candev (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.candev (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.impdev (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.impdev (SUB-TOTAL BY DETALLE-1.fecha).
    ACCUMULATE DETALLE-1.imptot (TOTAL BY DETALLE-1.codcia).
    ACCUMULATE DETALLE-1.imptot (SUB-TOTAL BY DETALLE-1.fecha).
    IF LAST-OF(DETALLE-1.Fecha)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE-1.fecha     
            DETALLE-1.coddistr
            x-Nombre
            DETALLE-1.candes    
            DETALLE-1.impdes    
            DETALLE-1.candev    
            DETALLE-1.impdev    
            DETALLE-1.ImpTot
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            "TOTAL DIARIO >>>" @ x-Nombre
            ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.candes @ DETALLE-1.candes
            ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.impdes @ DETALLE-1.impdes
            ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.candev @ DETALLE-1.candev
            ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.impdev @ DETALLE-1.impdev
            ACCUM SUB-TOTAL BY DETALLE-1.Fecha DETALLE-1.imptot @ DETALLE-1.imptot
            WITH FRAME FC-REP.
        DOWN STREAM REPORT 1 WITH FRAME FC-REP.
    END.
    IF LAST-OF(DETALLE-1.CodCia)
    THEN DO:
        ASSIGN
            x-CanDes = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.candes
            x-ImpDes = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.impdes 
            x-CanDev = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.candev 
            x-ImpDev = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.impdev 
            x-ImpTot = ACCUM TOTAL BY DETALLE-1.Codcia DETALLE-1.imptot.
    END.
  END.  
  PUT STREAM REPORT
    "DETALLE SEMANAL" SKIP.
  PUT STREAM REPORT
    "===============" SKIP.
  FOR EACH DETALLE-3 BREAK BY DETALLE-3.CodCia BY DETALLE-3.Canal BY DETALLE-3.CodDistr:
    x-Nombre = ''.
    FIND TabDistr OF DETALLE-3 NO-LOCK NO-ERROR.
    x-PorTot = IF x-impdes <> 0 THEN DETALLE-3.impdes / x-impdes * 100 ELSE 0.
    IF AVAILABLE TabDistr THEN x-Nombre = TabDistr.NomDistr.
    PUT STREAM REPORT
        DETALLE-3.coddistr  AT 9    FORMAT 'x(5)'           SPACE(1)
        x-Nombre                    FORMAT 'x(25)'          SPACE(5)
        DETALLE-3.candes            FORMAT '>>>,>>9'        SPACE(1)
        DETALLE-3.impdes            FORMAT '>>>,>>>,>>9.99' SPACE(6)
        DETALLE-3.candev            FORMAT '>>>,>>9'        SPACE(1)
        DETALLE-3.impdev            FORMAT '>>>,>>>,>>9.99' SPACE(1)
        DETALLE-3.imptot            FORMAT '>>>,>>>,>>9.99' SPACE(1)
        x-portot                    FORMAT '>>9.99'
        SKIP.
    IF LAST-OF(DETALLE-3.codcia)
    THEN DO:
        PUT STREAM REPORT
            FILL('=',130) FORMAT 'x(130)' SKIP.
        PUT STREAM REPORT
            x-candes    AT 45   FORMAT '>>>,>>9'        SPACE(1)
            x-impdes            FORMAT '>>>,>>>,>>9.99' SPACE(6)
            x-candev            FORMAT '>>>,>>9'        SPACE(1)
            x-impdev            FORMAT '>>>,>>>,>>9.99' SPACE(1)
            x-imptot            FORMAT '>>>,>>>,>>9.99' SPACE(1)
            SKIP.
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

    RUN Carga-Temporal-1.
    FIND FIRST DETALLE-1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE-1 THEN DO:
        MESSAGE
            'No hay información a imprimir'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
        RUN Formato-1.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  ASSIGN
    FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-Fecha-2 = TODAY.

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

