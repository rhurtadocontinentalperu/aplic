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

DEF TEMP-TABLE detalle NO-UNDO
    FIELD codcia LIKE almmmatg.codcia
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD codpro AS CHAR FORMAT 'x(11)'
    FIELD nompro AS CHAR FORMAT 'x(60)'
    FIELD undbas LIKE almmmatg.undbas
    FIELD codfam LIKE almmmatg.codfam
    FIELD candes LIKE ccbddocu.candes
    FIELD implin LIKE ccbddocu.implin
    FIELD impcto LIKE ccbddocu.impcto
    FIELD tipo   AS CHAR FORMAT 'x(15)'
    INDEX LLave01 IS PRIMARY UNIQUE codcia codmat.
DEF VAR x-Factor AS INT NO-UNDO.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
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
        TITLE "Procesando..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS x-Periodo tg-acum x-CodDiv CB-MES Btn_Excel ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo tg-acum x-mensaje x-CodDiv ~
CB-MES 

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

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "X(4)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.14 BY .81 NO-UNDO.

DEFINE VARIABLE tg-acum AS LOGICAL INITIAL no 
     LABEL "Acumulado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 14
     tg-acum AT ROW 4.5 COL 35 WIDGET-ID 10
     x-mensaje AT ROW 6.38 COL 4 NO-LABEL WIDGET-ID 12
     x-CodDiv AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 8
     CB-MES AT ROW 4.23 COL 9 COLON-ALIGNED WIDGET-ID 2
     Btn_Excel AT ROW 7.46 COL 40
     Btn_Done AT ROW 7.46 COL 51
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.43 BY 8.65
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
         TITLE              = "VENTAS Y COSTOS COMPARATIVOS MENSUAL"
         HEIGHT             = 8.65
         WIDTH              = 64.43
         MAX-HEIGHT         = 10.15
         MAX-WIDTH          = 64.43
         VIRTUAL-HEIGHT     = 10.15
         VIRTUAL-WIDTH      = 64.43
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
ON END-ERROR OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL */
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
    ASSIGN CB-MES x-coddiv tg-acum x-periodo.
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
  DISPLAY x-Periodo tg-acum x-mensaje x-CodDiv CB-MES 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo tg-acum x-CodDiv CB-MES Btn_Excel Btn_Done 
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

    SESSION:SET-WAIT-STATE('COMPILER').
    RUN proc_carga-temp.
    SESSION:SET-WAIT-STATE('').

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
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Division:'.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-coddiv.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "COD MAT".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "UND BAS".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANTIDAD".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "COSTO TOTAL S/.".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTA TOTAL S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "MARCA".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "PROVEEDOR".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "LINEA".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "@".
    chWorkSheet:Columns("K"):NumberFormat = "@".
    chWorkSheet:Range("A1:K3"):Font:Bold = TRUE.

    FOR EACH detalle NO-LOCK:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.undbas.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.candes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.impcto.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.implin.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmar.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.tipo.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codpro.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.nompro.
        cRange = "K" + cColumn.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro W-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-Factor AS DECI NO-UNDO.

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.

FIND detalle OF Almdmov EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE detalle THEN DO:
    CREATE detalle.
    ASSIGN
        detalle.codcia = almmmatg.codcia
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
    detalle.candes = detalle.candes + (Almdmov.CanDes * Almdmov.Factor * x-factor).

/*Calculando el precio de venta sin I.G.V*/
IF AVAILABLE Ccbcdocu THEN DO:
    FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN DO:
        IF ccbcdocu.codmon = 1 
        THEN detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * x-factor.
        ELSE DO: 
            FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = Almcmov.fchdoc NO-LOCK NO-ERROR.
            IF AVAIL gn-tcmb 
            THEN detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * gn-tcmb.venta * x-factor.
            ELSE detalle.implin = detalle.implin + (ccbddocu.implin - ccbddocu.impigv) * ccbcdocu.tpocmb * x-factor.
        END.
    END.
END.

/*Calculando Costo Promedio*/
f-precio = 0.
FIND LAST AlmStkGe WHERE AlmStkge.CodCia = s-codcia
    AND AlmStkge.codmat = Almdmov.codmat
    AND AlmStkge.Fecha <= Almcmov.fchdoc
    NO-LOCK NO-ERROR.
IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
ASSIGN detalle.impcto = detalle.impcto + (Almdmov.CanDes * Almdmov.Factor * f-precio * x-factor).

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
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
      x-coddiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.

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
  Notes:       Se debe tomar el movimiento de almacén tenga o no tenga contraparte en ccbcdocu
------------------------------------------------------------------------------*/

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.

EMPTY TEMP-TABLE detalle.

/* 14/01/2025: Juan Hermoza, movimientos de almacén I-09 S-02 */
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia AND (x-coddiv = 'Todas' OR gn-divi.coddiv = x-coddiv): 
    /* Ventas S-02 */
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = gn-divi.codcia AND Almacen.coddiv = gn-divi.coddiv,
        EACH Almcmov NO-LOCK WHERE Almcmov.codcia = gn-divi.codcia AND 
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "S" AND
        Almcmov.codmov = 02 AND
        Almcmov.fchdoc >= dDesdeF AND
        Almcmov.fchdoc <= dHastaF AND
        Almcmov.flgest <> "A":

        FIND Ccbcdocu WHERE Ccbcdocu.codcia = Almcmov.codcia AND
            Ccbcdocu.coddoc = Almcmov.codref AND 
            Ccbcdocu.nrodoc = Almcmov.nroref AND
            Ccbcdocu.flgest <> "A"
            NO-LOCK NO-ERROR.

        FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
            RUN Graba-Registro (1).
        END.
    END.
    /* Ventas I-09 */
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = gn-divi.codcia AND Almacen.coddiv = gn-divi.coddiv,
        EACH Almcmov NO-LOCK WHERE Almcmov.codcia = gn-divi.codcia AND 
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "I" AND
        Almcmov.codmov = 09 AND
        Almcmov.fchdoc >= dDesdeF AND
        Almcmov.fchdoc <= dHastaF AND
        Almcmov.flgest <> "A":

        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.coddoc = "N/C" AND
            Ccbcdocu.codref = Almcmov.codref AND
            Ccbcdocu.nroref = Almcmov.nroref AND
            INTEGER(Ccbcdocu.nroped) = Almcmov.nrodoc AND
            Ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.

        FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
            RUN Graba-Registro (-1).
        END.
    END.
END.


/* ***********
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia AND (x-coddiv = 'Todas' OR gn-divi.coddiv = x-coddiv):  
    Docs:
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = gn-divi.CodCia
        AND ccbcdocu.coddiv = gn-divi.coddiv
        AND (ccbcdocu.coddoc = 'FAC' OR  
             ccbcdocu.coddoc = 'BOL' OR 
             ccbcdocu.coddoc = 'TCK' OR 
             ccbcdocu.coddoc = 'N/C')
        AND ccbcdocu.fchdoc  >= dDesdeF 
        AND ccbcdocu.fchdoc  <= dHastaF:
        /* FILTROS */
        IF Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.CndCre <> "D" THEN NEXT Docs.
        IF LOOKUP(ccbcdocu.tpofac, 'A,S') > 0  THEN NEXT Docs.      /* NO facturas adelantadas NI servicios */ 
        IF ccbcdocu.flgest = 'A' THEN NEXT Docs.
        IF ccbcdocu.FmaPgo = '900' THEN NEXT Docs.
        /* FIN DE FILTROS */
        IF ccbcdocu.coddoc = 'N/C' THEN DO:
            FIND bccbcdocu WHERE bccbcdocu.codcia = s-codcia
                AND bccbcdocu.coddoc = ccbcdocu.codref
                AND bccbcdocu.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
            IF AVAIL bccbcdocu AND LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT Docs.
        END.
        x-Factor = IF ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.

        FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE ccbddocu.implin > 0,
            FIRST almmmatg OF ccbddocu NO-LOCK:
            FIND detalle OF ccbddocu NO-ERROR.
            IF NOT AVAILABLE detalle THEN DO:
                CREATE detalle.
                ASSIGN
                    detalle.codcia = almmmatg.codcia
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
********* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp-olf W-Win 
PROCEDURE proc_carga-temp-olf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.

EMPTY TEMP-TABLE detalle.

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia
    AND (x-coddiv = 'Todas' OR gn-divi.coddiv = x-coddiv):  
    Docs:
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = gn-divi.CodCia
        AND ccbcdocu.coddiv = gn-divi.coddiv
        AND (ccbcdocu.coddoc = 'FAC' OR  
             ccbcdocu.coddoc = 'BOL' OR 
             ccbcdocu.coddoc = 'TCK' OR 
             ccbcdocu.coddoc = 'N/C')
        AND ccbcdocu.fchdoc  >= dDesdeF 
        AND ccbcdocu.fchdoc  <= dHastaF 
        AND LOOKUP(ccbcdocu.tpofac, 'A,S') = 0  /* NO facturas adelantadas NI servicios */ 
        AND ccbcdocu.flgest <> 'A'
        AND ccbcdocu.FmaPgo <> '900',
        EACH ccbddocu OF ccbcdocu NO-LOCK WHERE ccbddocu.implin > 0,
        FIRST almmmatg OF ccbddocu NO-LOCK:

        IF ccbcdocu.coddoc = 'N/C' THEN DO:
            IF CcbCdocu.CndCre = "N" THEN NEXT Docs.    /* NO por otros conceptos */
            FIND bccbcdocu WHERE bccbcdocu.codcia = s-codcia
                AND bccbcdocu.coddoc = ccbcdocu.codref
                AND bccbcdocu.nrodoc = ccbcdocu.nroref NO-LOCK NO-ERROR.
            IF AVAIL bccbcdocu AND LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN NEXT Docs.
        END.
        x-Factor = IF ccbcdocu.coddoc = 'N/C' THEN -1 ELSE 1.
        
        FIND detalle OF ccbddocu NO-ERROR.
        IF NOT AVAILABLE detalle THEN DO:
            CREATE detalle.
            ASSIGN
                detalle.codcia = almmmatg.codcia
                detalle.codmat = almmmatg.codmat
                detalle.desmat = almmmatg.desmat
                detalle.undbas = almmmatg.undbas
                detalle.desmar = almmmatg.desmar
                detalle.codpro = almmmatg.codpr1.
            IF almmmatg.CHR__02 = 'P' THEN detalle.tipo = 'PROPIOS'.
            ELSE detalle.tipo = 'TERCEROS'.
            FIND gn-prov WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = almmmatg.codpr1
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.
        END.
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
        FIND LAST almdmov USE-INDEX ALMD07 WHERE Almdmov.CodCia = ccbcdocu.codcia
            AND Almdmov.codmat = ccbddocu.CodMat
            AND Almdmov.FchDoc <= ccbddocu.fchdoc
            AND Almdmov.tipmov = "S"
            AND Almdmov.codmov = 02 NO-LOCK NO-ERROR.

        IF AVAIL almdmov THEN f-precio = Almdmov.VctoMn1.
        ASSIGN detalle.impcto = detalle.impcto + (ccbddocu.candes * ccbddocu.factor * f-precio * x-factor).

        /*
        IF NOT AVAILABLE Almdmov THEN DO:
            FIND LAST Almdmov USE-INDEX ALMD02 WHERE Almdmov.CodCia = ccbcdocu.codcia
                AND Almdmov.tipmov = "S"
                AND Almdmov.codmov = 02
                AND Almdmov.codmat = ccbddocu.CodMat 
                AND Almdmov.FchDoc <= dHastaf NO-LOCK  NO-ERROR.
        END.
        */

        DISPLAY "PROCESANDO INFORMACION" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    END.
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

