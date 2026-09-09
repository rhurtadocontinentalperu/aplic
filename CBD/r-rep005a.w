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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-Periodo AS INT.
DEF SHARED VAR s-nromes  AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF BUFFER bccbcdocu FOR ccbcdocu.

DEF VAR dDesdeF AS DATE NO-UNDO.
DEF VAR dHastaF AS DATE NO-UNDO.
DEF VAR dFechaF AS DATE NO-UNDO.

DEF TEMP-TABLE detalle
    FIELD codcia LIKE almmmatg.codcia
    FIELD coddiv LIKE ccbcdocu.coddiv
    FIELD desdiv LIKE gn-divi.desdiv
    FIELD divori LIKE ccbcdocu.divori
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD codpro AS CHAR FORMAT 'x(11)'
    FIELD nompro AS CHAR FORMAT 'x(60)'
    FIELD undbas LIKE almmmatg.undbas
    FIELD codfam LIKE almmmatg.codfam
    FIELD candes LIKE ccbddocu.candes FORMAT '->>,>>>,>>9.9999'
    FIELD implin LIKE ccbddocu.implin FORMAT '->>,>>>,>>9.9999'
    FIELD impcto LIKE ccbddocu.impcto FORMAT '->>,>>>,>>9.9999'
    FIELD tipo   AS CHAR FORMAT 'x(15)'
    INDEX LLave01 IS PRIMARY UNIQUE codcia coddiv codmat.

DEF TEMP-TABLE tddocu
    FIELD coddiv LIKE ccbcdocu.coddiv
    FIELD divori LIKE ccbcdocu.divori
    FIELD coddoc LIKE ccbcdocu.coddoc
    FIELD nrodoc LIKE ccbcdocu.nrodoc
    FIELD nroitm LIKE ccbddocu.nroitm
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD undvta LIKE ccbddocu.undvta
    FIELD preuni LIKE ccbddocu.preuni FORMAT '->>,>>>,>>9.9999'
    FIELD implin LIKE ccbddocu.implin FORMAT '->>,>>>,>>9.9999'
    FIELD Candes LIKE ccbddocu.candes FORMAT '->>,>>>,>>9.9999'
    FIELD factor LIKE ccbddocu.factor
    FIELD cantidadvta LIKE ccbddocu.candes  FORMAT '->>,>>>,>>9.9999' COLUMN-LABEL "CantidadTotal"
    FIELD codmon LIKE ccbcdocu.codmon
    FIELD codmov LIKE ccbcdocu.codmov
    FIELD codped LIKE ccbcdocu.codped
    FIELD nroped LIKE ccbcdocu.nroped
    .

DEF VAR x-Factor AS INT NO-UNDO.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(100)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0
        TITLE "Procesando!!!" FONT 7.

DEFINE VARIABLE cMeses AS CHARACTER NO-UNDO EXTENT 12.
cMeses[01]  = 'Enero'.
cMeses[02]  = 'Febrero'.
cMeses[03]  = 'Marzo'.
cMeses[04]  = 'Abril'.
cMeses[05]  = 'Mayo'.
cMeses[06]  = 'Junio'.
cMeses[07]  = 'Julio'.
cMeses[08]  = 'Agosto'.
cMeses[09]  = 'Setiembre'.
cMeses[10] = 'Octubre'.
cMeses[11] = 'Noviembre'.
cMeses[12] = 'Diciembre'.

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
&Scoped-Define ENABLED-OBJECTS RADIO-SET-Division x-Periodo tg-acum CB-MES ~
Btn_Excel Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Division x-Periodo tg-acum ~
x-mensaje CB-MES 

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
     LABEL "Salir" 
     SIZE 11 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.54 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE VARIABLE CB-MES AS CHARACTER FORMAT "X(13)":U INITIAL "01" 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Enero","01",
                     "Febrero","02",
                     "Marzo","03",
                     "Abril","04",
                     "Mayo","05",
                     "Junio","06",
                     "Julio","07",
                     "Agosto","08",
                     "Setiembre","09",
                     "Octubre","10",
                     "Noviembre","11",
                     "Diciembre","12"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "X(4)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Division AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Por Despacho", 1,
"Por Origen de Venta", 2
     SIZE 19 BY 1.73 NO-UNDO.

DEFINE VARIABLE tg-acum AS LOGICAL INITIAL no 
     LABEL "Acumulado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-Division AT ROW 3.5 COL 11 NO-LABEL WIDGET-ID 16
     x-Periodo AT ROW 1.38 COL 9 COLON-ALIGNED WIDGET-ID 14
     tg-acum AT ROW 2.69 COL 34 WIDGET-ID 10
     x-mensaje AT ROW 5.42 COL 4 NO-LABEL WIDGET-ID 12
     CB-MES AT ROW 2.42 COL 9 COLON-ALIGNED WIDGET-ID 2
     Btn_Excel AT ROW 6.5 COL 38.86
     Btn_Done AT ROW 6.5 COL 51
     "v2" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.77 COL 66 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.72 BY 7.54
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
         TITLE              = "VENTAS Y COSTOS COMPARATIVOS MENSUAL - TODAS POR DIVISION"
         HEIGHT             = 7.54
         WIDTH              = 78.72
         MAX-HEIGHT         = 10.15
         MAX-WIDTH          = 78.72
         VIRTUAL-HEIGHT     = 10.15
         VIRTUAL-WIDTH      = 78.72
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
ASSIGN 
       Btn_Excel:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL - TODAS POR DIVISION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL - TODAS POR DIVISION */
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
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    ASSIGN CB-MES tg-acum x-periodo RADIO-SET-Division .
    RUN bin/_dateif (01, INT(x-periodo), OUTPUT dFechaF, OUTPUT dHastaF).
    RUN bin/_dateif (cb-Mes, INT(x-periodo), OUTPUT dDesdeF, OUTPUT dHastaF).
    IF tg-acum THEN dDesdeF = dFechaF.    
    
    RUN Excel.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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
  DISPLAY RADIO-SET-Division x-Periodo tg-acum x-mensaje CB-MES 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-Division x-Periodo tg-acum CB-MES Btn_Excel Btn_Done 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.

    RUN proc_carga-temp.

    IF NOT CAN-FIND (FIRST detalle) THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTAS Y COSTOS COMPARATIVOS MENSUAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Mes'.
    cRange = "B" + cColumn.
    IF NOT tg-acum THEN chWorkSheet:Range(cRange):Value = cMeses[INT(cb-mes)].
    ELSE chWorkSheet:Range(cRange):Value = "Enero a " + cMeses[INT(cb-mes)].
    
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    CASE RADIO-SET-Division:
        WHEN 1 THEN chWorkSheet:Range(cRange):Value = "DIVISION DESPACHO".
        WHEN 2 THEN chWorkSheet:Range(cRange):Value = "DIVISION ORIGEN".
    END CASE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".


    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "COD MAT".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "UND BAS".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANTIDAD".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "COSTO TOTAL S/. SIN IGV".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTA TOTAL S/. SIN IGV".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "MARCA".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "PROVEEDOR".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "LINEA".

    chWorkSheet:Columns("A"):NumberFormat = "@".

    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Columns("K"):NumberFormat = "@".
    chWorkSheet:Columns("M"):NumberFormat = "@".
    chWorkSheet:Range("A1:M3"):Font:Bold = TRUE.

    FOR EACH detalle NO-LOCK:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.coddiv.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desdiv.

        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmat.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.undbas.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.candes.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.impcto.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.implin.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmar.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.tipo.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codpro.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.nompro.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codfam.
        DISPLAY "CARGANDO EXCEL" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    DEFINE VARIABLE iCount-Cab AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCount-Aux AS INTEGER NO-UNDO.

    DEFINE BUFFER b-wrkp_prod FOR wrkp_prod.

    DEFINE FRAME f-cab
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + s-nomcia + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(80)" SKIP
        "INGRESOS Y SALIDAD DE PRODUCCIÓN" FORMAT "x(32)" AT 90
        "Página :" TO 190 PAGE-NUMBER(report) FORMAT "ZZ9" TO 200 SKIP
        "DEL" FILL-IN-fecha "AL" FILL-IN-fecha-2
        "Fecha  :" TO 190 STRING(TODAY,"99/99/99") TO 200
        "Hora   :" TO 190 STRING(TIME,"HH:MM:SS") TO 200
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    DEFINE FRAME f-det
        wrkp_prod.wrkp_ordpro
        wrkp_prod.wrkp_fching
        wrkp_prod.wrkp_nroing
        wrkp_prod.wrkp_iteing
        wrkp_prod.wrkp_desing
        wrkp_prod.wrkp_uming
        wrkp_prod.wrkp_qtying
        wrkpd_fchsal
        wrkpd_nrosal
        wrkpd_itesal
        wrkpd_dessal
        wrkpd_umsal
        wrkpd_qtysal
        WITH DOWN STREAM-IO WIDTH 320.

    VIEW STREAM report FRAME f-cab.

    FOR EACH wrkp_prod NO-LOCK BREAK BY wrkp_prod.wrkp_ordpro
        WITH FRAME f-det:
        IF FIRST-OF(wrkp_prod.wrkp_ordpro) THEN DO:
            DISPLAY
                wrkp_ordpro @ FI-MENSAJE LABEL "    OP"
                WITH FRAME F-PROCESO.
            iCount-Cab = 0.
            iCount-Aux = 0.
            FOR EACH b-wrkp_prod NO-LOCK WHERE
                b-wrkp_prod.wrkp_ordpro = wrkp_prod.wrkp_ordpro:
                iCount-Cab = iCount-Cab + 1.
            END.
            FIND FIRST wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.
        DISPLAY STREAM report
            wrkp_prod.wrkp_ordpro /* WHEN FIRST-OF(wrkp_ordpro) */
            wrkp_prod.wrkp_fching
            wrkp_prod.wrkp_nroing
            wrkp_prod.wrkp_iteing
            wrkp_prod.wrkp_desing
            wrkp_prod.wrkp_uming
            wrkp_prod.wrkp_qtying.
        iCount-Aux = iCount-Aux + 1.
        IF AVAILABLE wrkpd_prod THEN DO:
            DISPLAY STREAM report
                wrkpd_fchsal
                wrkpd_nrosal
                wrkpd_itesal
                wrkpd_dessal
                wrkpd_umsal
                wrkpd_qtysal.
            FIND NEXT wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.
        IF iCount-Aux = iCount-Cab THEN
            REPEAT WHILE AVAILABLE wrkpd_prod:
            DOWN STREAM report 1 WITH FRAME f-det.
            DISPLAY STREAM report
                wrkpd_fchsal
                wrkpd_nrosal
                wrkpd_itesal
                wrkpd_dessal
                wrkpd_umsal
                wrkpd_qtysal
                WITH FRAME f-det.
            FIND NEXT wrkpd_prod WHERE
                wrkpd_ordpro = wrkp_prod.wrkp_ordpro
                NO-LOCK NO-ERROR.
        END.

        IF LAST-OF(wrkp_prod.wrkp_ordpro) AND
            NOT LAST(wrkp_prod.wrkp_ordpro) THEN
            DOWN STREAM report 1 WITH FRAME f-det.

    END.
    HIDE FRAME F-PROCESO.
    */
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
    /*
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN proc_carga-temp.

    IF NOT CAN-FIND (FIRST wrkp_prod) THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
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
    */                    
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

  DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  DO iInt = 0 TO 8 :
      x-periodo:ADD-LAST(STRING(YEAR(TODAY) - iInt)) IN FRAME {&FRAME-NAME}.
  END.
  ASSIGN 
      x-periodo = STRING(YEAR(TODAY), '9999')
      cb-mes = STRING(s-nromes,'99'). 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp W-Win 
PROCEDURE proc_carga-temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-CodDiv AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesDiv AS CHAR NO-UNDO.

EMPTY TEMP-TABLE detalle.
EMPTY TEMP-TABLE tddocu.

DEFINE VAR cListaDocs AS CHAR.
DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR iSec AS INT.
DEFINE VAR cMiMsg AS CHAR.

cListaDocs = "FAC,BOL,N/C,FAI".

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia:
    REPEAT iSec = 1 TO NUM-ENTRIES(cListaDocs,","):
        cCodDoc = ENTRY(iSec,cListaDocs,",").
        /*
        FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = gn-divi.CodCia
                AND ccbcdocu.coddiv = gn-divi.coddiv
                AND ccbcdocu.coddoc = 'FAC' OR 
                     ccbcdocu.coddoc = 'BOL' OR 
                     ccbcdocu.coddoc = 'N/C') OR
                     ccbcdocu.coddoc = 'FAI'
                AND ccbcdocu.fchdoc  >= dDesdeF 
                AND ccbcdocu.fchdoc  <= dHastaF:
        */
        Docs:
        FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = gn-divi.CodCia
                AND ccbcdocu.coddiv = gn-divi.coddiv
                AND ccbcdocu.coddoc = cCodDoc
                AND (ccbcdocu.fchdoc  >= dDesdeF AND ccbcdocu.fchdoc  <= dHastaF):
            /* FILTROS */
            IF Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.CndCre <> "D" THEN NEXT Docs.      /* Solo devoluciones */
            IF LOOKUP(ccbcdocu.tpofac, 'A,S,V') > 0  THEN NEXT Docs.      /* NO facturas adelantadas NI servicios NI ventas Adelantadas*/ 
            IF ccbcdocu.flgest = 'A' THEN NEXT Docs.
            /* IF ccbcdocu.FmaPgo = '900' THEN NEXT Docs. */         /* Gratuitos */
            /* FIN DE FILTROS */
            IF ccbcdocu.coddoc = 'N/C' THEN DO:
                FIND bccbcdocu WHERE bccbcdocu.codcia = s-codcia
                    AND bccbcdocu.coddoc = ccbcdocu.codref
                    AND bccbcdocu.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
                IF AVAIL bccbcdocu AND LOOKUP(CcbCdocu.TpoFac, 'A,S,V') > 0 THEN NEXT Docs.
            END.
            x-Factor = IF ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.

            cMiMsg = "PROCESANDO..." + Ccbcdocu.coddiv + " / " + Ccbcdocu.coddoc + " / " + Ccbcdocu.nrodoc.

            DISPLAY cMiMsg @ x-mensaje WITH FRAME {&FRAME-NAME}.

            FOR EACH ccbddocu OF ccbcdocu NO-LOCK /*WHERE ccbddocu.implin > 0*/,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                CASE RADIO-SET-Division:
                    WHEN 1 THEN ASSIGN x-CodDiv = Ccbcdocu.coddiv x-DesDiv = gn-divi.desdiv.
                    WHEN 2 THEN ASSIGN x-CodDiv = Ccbcdocu.divori x-DesDiv = gn-divi.desdiv.
                END CASE.
                IF x-CodDiv = '' THEN ASSIGN x-CodDiv = Ccbcdocu.coddiv.
                FIND detalle WHERE detalle.codcia = ccbcdocu.codcia
                    AND detalle.coddiv = x-CodDiv
                    AND detalle.codmat = ccbddocu.codmat NO-ERROR.
                IF NOT AVAILABLE detalle THEN DO:
                    CREATE detalle.
                    ASSIGN
                        detalle.codcia = almmmatg.codcia
                        detalle.coddiv = x-CodDiv
                        detalle.desdiv = x-DesDiv
                        detalle.codmat = almmmatg.codmat
                        detalle.desmat = almmmatg.desmat
                        detalle.undbas = almmmatg.undbas 
                        detalle.desmar = almmmatg.desmar
                        detalle.codfam = almmmatg.codfam
                        detalle.codpro = almmmatg.codpr1. 
                    IF almmmatg.CHR__02 = 'P' THEN detalle.tipo = 'PROPIOS'.
                    ELSE detalle.tipo = 'TERCEROS'.
                    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                        AND gn-prov.codpro = almmmatg.codpr1
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.
                END.
                ASSIGN
                    detalle.candes = detalle.candes + (ccbddocu.candes * ccbddocu.factor * x-factor).
                /*Calculando el precio de venta sin I.G.V*/
                IF ccbcdocu.codmon = 1 
                THEN detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * x-factor).
                ELSE DO: 
                    FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                    IF AVAIL gn-tcmb THEN
                        detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * gn-tcmb.venta * x-factor).
                    ELSE detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * ccbcdocu.tpocmb * x-factor).
                END.
                /*Calculando Costo Promedio*/
                f-precio = 0.
                FIND LAST AlmStkGe USE-INDEX Llave01 WHERE AlmStkge.CodCia = s-codcia
                    AND AlmStkge.codmat = Ccbddocu.codmat
                    AND AlmStkge.Fecha <= Ccbcdocu.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
                IF Ccbcdocu.coddoc = "N/C" THEN DO:
                    FIND Almcmov WHERE Almcmov.CodCia = CcbCDocu.CodCia
                        AND  Almcmov.CodAlm = CcbCDocu.CodAlm 
                        AND  Almcmov.TipMov = "I"
                        AND  Almcmov.CodMov = CcbCDocu.CodMov 
                        AND  Almcmov.NroSer = 000
                        AND  Almcmov.NroDoc = INTEGER(CcbCDocu.NroPed)
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN DO:
                        FIND LAST AlmStkGe WHERE AlmStkge.CodCia = Almcmov.codcia
                            AND AlmStkge.codmat = Ccbddocu.codmat
                            AND AlmStkge.Fecha <= Almcmov.fchdoc
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
                    END.
                END.
                ASSIGN detalle.impcto = detalle.impcto + (ccbddocu.candes * ccbddocu.factor * f-precio * x-factor).

                /* para verificacion */

                CREATE tddocu.
                BUFFER-COPY ccbcdocu TO tddocu.
                BUFFER-COPY almmmatg TO tddocu.
                BUFFER-COPY ccbddocu TO tddocu.
                ASSIGN tddocu.cantidadvta = (ccbddocu.candes * ccbddocu.factor * x-factor).
            END.            
        END.
    END.
END.

IF USERID("DICTDB") = "ADMIN" OR USERID("DICTDB") = "MASTER" THEN DO:
    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = session:TEMP-DIRECTORY + 'r-rep005a.xlsx'.

    run pi-crea-archivo-csv IN hProc (input  buffer tddocu:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tddocu:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-x-revisar W-Win 
PROCEDURE proc_carga-x-revisar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-CodDiv AS CHAR NO-UNDO.

EMPTY TEMP-TABLE detalle.

DEFINE VAR cDocumentos AS CHAR.
DEFINE VAR cCodDoc AS CHAR.
DEFINE VAR iConteo AS INT.
DEFINE VAR dDesde AS DATE.
DEFINE VAR dHasta AS DATE.
DEFINE VAR dFecha AS DATE.

cDocumentos = "FAC,BOL,TCK,N/C".

DEFINE VAR fhInicio AS DATETIME.
DEFINE VAR fhTermino AS DATETIME.

fhInicio = NOW.

SESSION:SET-WAIT-STATE('GENERAL').

/*FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia:*/
REPEAT dFecha = dDesdeF TO dHastaF:
    REPEAT iConteo = 1 TO NUM-ENTRIES(cDocumentos,","):
        cCodDoc = ENTRY(iConteo,cDocumentos,",").
        FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = 1
            /*AND ccbcdocu.coddiv = gn-divi.coddiv
            AND (ccbcdocu.fchdoc  >= dDesdeF 
            AND ccbcdocu.fchdoc  <= dHastaF)*/
            AND ccbcdocu.fchdoc = dFecha
            AND ccbcdocu.coddoc = cCodDoc :

            /* FILTROS */
            IF Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.CndCre <> "D" THEN NEXT.
            IF LOOKUP(ccbcdocu.tpofac, 'A,S') > 0  THEN NEXT.      /* NO facturas adelantadas NI servicios */ 
            IF ccbcdocu.flgest = 'A' THEN NEXT.
            IF ccbcdocu.FmaPgo = '900' THEN NEXT.
            /* FIN DE FILTROS */
            IF ccbcdocu.coddoc = 'N/C' THEN DO:
                FIND bccbcdocu WHERE bccbcdocu.codcia = s-codcia
                    AND bccbcdocu.coddoc = ccbcdocu.codref
                    AND bccbcdocu.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
                IF AVAIL bccbcdocu AND LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT .
            END.
            x-Factor = IF ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.

            FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE ccbddocu.implin > 0,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                CASE  RADIO-SET-Division:
                    WHEN 1 THEN x-CodDiv = Ccbcdocu.coddiv.
                    WHEN 2 THEN x-CodDiv = Ccbcdocu.divori.
                END CASE.
                IF x-CodDiv = '' THEN x-CodDiv = Ccbcdocu.coddiv.
                FIND FIRST detalle WHERE detalle.codcia = ccbcdocu.codcia
                    /*AND detalle.coddiv = ccbcdocu.coddiv*/
                    AND detalle.coddiv = x-CodDiv
                    AND detalle.codmat = ccbddocu.codmat NO-ERROR.
                IF NOT AVAILABLE detalle THEN DO:
                    CREATE detalle.
                    ASSIGN
                        detalle.codcia = almmmatg.codcia
                        /*detalle.coddiv = ccbcdocu.coddiv*/
                        detalle.coddiv = x-CodDiv
                        detalle.codmat = almmmatg.codmat
                        detalle.desmat = almmmatg.desmat
                        detalle.undbas = almmmatg.undbas
                        detalle.desmar = almmmatg.desmar
                        detalle.codfam = almmmatg.codfam
                        detalle.codpro = almmmatg.codpr1.
                    IF almmmatg.CHR__02 = 'P' THEN detalle.tipo = 'PROPIOS'.
                    ELSE detalle.tipo = 'TERCEROS'.
                    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                        AND gn-prov.codpro = almmmatg.codpr1
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.
                END.
                ASSIGN
                    detalle.candes = detalle.candes + ccbddocu.candes * ccbddocu.factor * x-factor.
                /*Calculando el precio de venta sin I.G.V*/
                IF ccbcdocu.codmon = 1 
                THEN detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * x-factor.
                ELSE DO: 
                    FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                    IF AVAIL gn-tcmb THEN
                        detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * gn-tcmb.venta * x-factor.
                    ELSE detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * ccbcdocu.tpocmb * x-factor.
                END.
                /*Calculando Costo Promedio*/
                f-precio = 0.
                FIND LAST AlmStkGe WHERE AlmStkge.CodCia = s-codcia
                    AND AlmStkge.codmat = Ccbddocu.codmat
                    AND AlmStkge.Fecha <= Ccbcdocu.fchdoc
                    NO-LOCK NO-ERROR.
                IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
                IF Ccbcdocu.coddoc = "N/C" THEN DO:
                    FIND Almcmov WHERE Almcmov.CodCia = CcbCDocu.CodCia
                        AND  Almcmov.CodAlm = CcbCDocu.CodAlm 
                        AND  Almcmov.TipMov = "I"
                        AND  Almcmov.CodMov = CcbCDocu.CodMov 
                        AND  Almcmov.NroSer = 000
                        AND  Almcmov.NroDoc = INTEGER(CcbCDocu.NroPed)
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN DO:
                        FIND LAST AlmStkGe WHERE AlmStkge.CodCia = Almcmov.codcia
                            AND AlmStkge.codmat = Ccbddocu.codmat
                            AND AlmStkge.Fecha <= Almcmov.fchdoc
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
                    END.
                END.
                ASSIGN detalle.impcto = detalle.impcto + (ccbddocu.candes * ccbddocu.factor * f-precio * x-factor).
            END.
            DISPLAY "PROCESANDO INFORMACION" @ x-mensaje WITH FRAME {&FRAME-NAME}.
        END.
    END.
END.
/*END.*/

fhTermino = NOW.

SESSION:SET-WAIT-STATE('').

MESSAGE fhInicio SKIP
        fhTermino.

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

