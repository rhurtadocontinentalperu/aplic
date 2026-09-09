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

  History: /*ML01*/ 05/Ene/2010 Captura Poercentaje de Detracción
                    de campo cb-CMov.PorDet.
          
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

DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.
DEFINE SHARED VARIABLE s-periodo AS INTEGER.
DEFINE SHARED VARIABLE s-nromes AS INTEGER.

DEFINE VARIABLE cListCta AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPeriodo AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNroMes AS INTEGER NO-UNDO.
DEFINE VARIABLE iNroMes-1 AS INTEGER NO-UNDO.
DEFINE VARIABLE ind AS INTEGER NO-UNDO.

DEFINE VARIABLE cb-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE pv-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE cl-codcia AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE cPinta-mes AS CHARACTER FORMAT "X(30)".
DEFINE VARIABLE cNomAux  AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE cTipAux  AS CHARACTER.
DEFINE VARIABLE dPordet  AS DECIMAL FORMAT ">>9.99" NO-UNDO.
DEFINE VARIABLE dTotImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dDetImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dSalImp1 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dTotImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dDetImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dSalImp2 AS DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

RUN cbd/cb-m000 (OUTPUT cPeriodo).
IF cPeriodo = '' THEN DO:
    MESSAGE
        'NO existen periodos configurados para esta compañia'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

cCodOpe = "060".
cListCta = "421101,421102".

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-Periodo Btn_Excel ~
COMBO-mes Btn_OK FILL-IN-CodAux FILL-IN-CodAux-1 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-Periodo COMBO-mes FILL-IN-CodAux ~
FILL-IN-CodAux-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-mes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "<Todos>","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAux AS CHARACTER FORMAT "X(256)":U 
     LABEL "Auxiliar" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAux-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 5.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 5.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-Periodo AT ROW 1.38 COL 10 COLON-ALIGNED
     Btn_Excel AT ROW 1.38 COL 48
     COMBO-mes AT ROW 2.35 COL 10 COLON-ALIGNED
     Btn_OK AT ROW 2.92 COL 48
     FILL-IN-CodAux AT ROW 3.31 COL 10 COLON-ALIGNED
     FILL-IN-CodAux-1 AT ROW 3.31 COL 27 COLON-ALIGNED
     Btn_Cancel AT ROW 4.46 COL 48
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 1 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 5.38
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
         TITLE              = "Reporte de Detracciones"
         HEIGHT             = 5.38
         WIDTH              = 60.14
         MAX-HEIGHT         = 5.38
         MAX-WIDTH          = 60.14
         VIRTUAL-HEIGHT     = 5.38
         VIRTUAL-WIDTH      = 60.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
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
ON END-ERROR OF W-Win /* Reporte de Detracciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Detracciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        FILL-IN-CodAux
        FILL-IN-CodAux-1.

    DO WITH FRAME {&FRAME-NAME}:
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS).
        IF iNroMes = 1 THEN iNroMes-1 = 12.
        ELSE DO:
            iNroMes = iNroMes - 1.
            iNroMes-1 = iNroMes.
        END.
    END.

    IF FILL-IN-CodAux-1 = "" THEN FILL-IN-CodAux-1 = "ZZZZZZZZ".
    RUN Excel.
    IF FILL-IN-CodAux-1 = "ZZZZZZZZ" THEN FILL-IN-CodAux-1 = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:

    ASSIGN
        COMBO-Periodo
        COMBO-Mes
        FILL-IN-CodAux
        FILL-IN-CodAux-1.

    DO WITH FRAME {&FRAME-NAME}:
        iNroMes = LOOKUP(COMBO-mes,COMBO-mes:LIST-ITEMS).
        IF iNroMes = 1 THEN iNroMes-1 = 12.
        ELSE DO:
            iNroMes = iNroMes - 1.
            iNroMes-1 = iNroMes.
        END.
        DISABLE ALL.
    END.

    IF FILL-IN-CodAux-1 = "" THEN FILL-IN-CodAux-1 = "ZZZZZZZZ".
    RUN Imprime.
    IF FILL-IN-CodAux-1 = "ZZZZZZZZ" THEN FILL-IN-CodAux-1 = "".

    DO WITH FRAME {&FRAME-NAME}:
        ENABLE ALL.
    END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo W-Win 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR F-Saldo AS DEC.
/*
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND  (x-Linea = 'Todas' OR Almmmatg.codfam = x-Linea)
        AND  Almmmatg.CodMat >= DesdeC  
        AND  Almmmatg.CodMat <= HastaC 
        AND  Almmmatg.CodMar BEGINS F-marca1 
        AND  Almmmatg.CodPr1 BEGINS F-provee1
        AND  Almmmatg.Catconta[1] BEGINS F-Catconta 
        AND  Almmmatg.TpoArt BEGINS R-Tipo: 
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      
      FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= D-CORTE NO-LOCK NO-ERROR.

    /* Saldo Logistico */
    ASSIGN
        F-Saldo = 0.
/*    FOR EACH Almacen WHERE almacen.codcia = s-codcia
 *             AND almacen.flgrep = YES NO-LOCK:
 *         IF Almacen.AlmCsg = YES THEN NEXT.
 *         FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
 *             AND almstkal.codalm = almacen.codalm
 *             AND almstkal.codmat = almmmatg.codmat
 *             AND almstkal.fecha <= D-Corte
 *             NO-LOCK NO-ERROR.
 *         IF AVAILABLE Almstkal THEN F-Saldo = F-Saldo + AlmStkal.StkAct.
 *     END.
 *     IF F-Saldo = 0 THEN NEXT.*/
    /* Costo Unitario */
    FIND LAST AlmStkGe WHERE almstkge.codcia = s-codcia
        AND almstkge.codmat = almmmatg.codmat
        AND almstkge.fecha <= D-Corte
        NO-LOCK NO-ERROR.

    IF AVAILABLE Almstkge THEN f-Saldo = AlmStkge.StkAct.
    IF f-Saldo = 0 THEN NEXT.

      
/*      FIND LAST AlmStkge WHERE AlmStkge.Codcia = S-CODCIA AND
 *                         AlmStkge.Codmat = Almmmatg.Codmat AND
 *                         AlmStkge.Fecha <= D-Corte
 *                         NO-LOCK NO-ERROR.
 *       IF NOT AVAILABLE AlmStkge THEN NEXT. 
 *       IF ALmStkge.StkAct = 0 THEN NEXT.*/
      
      FIND Tempo WHERE Tempo.Codcia = S-CODCIA AND
                       Tempo.Codmat = Almmmatg.Codmat
                       EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAILABLE Tempo THEN DO:
         X-DESCAT = "".
         FIND Almtabla WHERE Almtabla.Tabla = CATEGORIA
                       AND  Almtabla.codigo = Almmmatg.Catconta[1] 
                       NO-LOCK NO-ERROR.
         IF AVAILABLE Almtabla THEN X-DESCAT = Almtabla.Nombre.
         
         CREATE Tempo.
         ASSIGN 
         Tempo.Codcia = Almmmatg.Codcia 
         Tempo.Codmat = Almmmatg.Codmat
         Tempo.Desmat = Almmmatg.Desmat
         Tempo.DesMar = Almmmatg.DesMar
         Tempo.UndStk = Almmmatg.UndStk
         Tempo.Catego = Almmmatg.Catconta[1]
         Tempo.Descat = X-DESCAT.   
      END.        

/*      Tempo.F-STKGEN = AlmStkge.Stkact.
 *       Tempo.F-PRECTO = AlmStkGe.CtoUni.
 *       
 *       IF I-CodMon = 1 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO.
 *       IF I-CodMon = 2 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO / Gn-Tcmb.Compra. */

    IF AVAILABLE Almstkge THEN Tempo.f-PreCto = Almstkge.CtoUni.
    Tempo.f-StkGen = F-Saldo.
    IF I-CodMon = 1 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO.
    IF I-CodMon = 2 THEN Tempo.F-VALCTO = Tempo.F-STKGEN * Tempo.F-PRECTO / Gn-Tcmb.Compra. 
    
      /***************Costo Ultima Reposicion********MAGM***********/
      F-COSTO = 0.
      IF F-COSTO = 0 THEN DO:
         F-COSTO = Almmmatg.Ctolis.
         IF I-CodMon <> Almmmatg.MonVta THEN DO:
            IF I-CodMon = 1 THEN F-costo = F-costo * gn-tcmb.venta. 
            IF I-CodMon = 2 THEN F-costo = F-costo / gn-tcmb.venta. 
         END.            
      END.
      FT-COSTO = F-COSTO * F-STKGEN.
      
      /***************************************************************/

  END.
  */
  HIDE FRAME F-PROCESO.
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
  DISPLAY COMBO-Periodo COMBO-mes FILL-IN-CodAux FILL-IN-CodAux-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 COMBO-Periodo Btn_Excel COMBO-mes Btn_OK FILL-IN-CodAux 
         FILL-IN-CodAux-1 Btn_Cancel 
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

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    IF iNroMes <> iNroMes-1 THEN
        cPinta-mes = "DE ENERO A DICIEMBRE DE " + STRING(COMBO-Periodo).
    ELSE cPinta-mes = CAPS(COMBO-Mes) + " DE " + STRING(COMBO-Periodo).

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE DETRACCIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = cPinta-mes.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIENTO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CUENTA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "AUXILIAR".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "GLOSA".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "CD".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOCUMENTO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "% DETRACCION".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION S/.".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO S/.".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO CAMBIO".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE US$".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "DETRACCION US$".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "SALDO US$".

    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("G"):NumberFormat = "@".
    chWorkSheet:Columns("H"):NumberFormat = "@".
    chWorkSheet:Columns("E"):ColumnWidth = 45.
    chWorkSheet:Columns("F"):ColumnWidth = 45.
    chWorkSheet:Range("A1:P3"):Font:Bold = TRUE.

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes >= iNroMes AND
        cb-dmov.nromes <= iNroMes-1 AND
        cb-dmov.codope = cCodOpe AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0 AND
        cb-dmov.codaux >= FILL-IN-CodAux AND
        cb-dmov.codaux <= FILL-IN-CodAux-1,
        FIRST cb-cmov NO-LOCK WHERE
            cb-cmov.codcia = cb-dmov.codcia AND
            cb-cmov.periodo = cb-dmov.periodo AND
            cb-cmov.nromes = cb-dmov.nromes AND
            cb-cmov.codope = cb-dmov.codope AND
            cb-cmov.nroast = cb-dmov.nroast
        BREAK BY cb-dmov.nromes BY cb-dmov.nroast:
        IF FIRST-OF(cb-dmov.nroast) THEN DO:
/*ML01* ***
            IF NUM-ENTRIES(cb-cmov.GloAst,"-") > 1 THEN
                dPordet = DECIMAL(ENTRY(1,cb-cmov.GloAst,"-")) NO-ERROR.
            ELSE dPordet = DECIMAL(cb-cmov.GloAst) NO-ERROR.
*ML01* ***/
/*ML01*/    dPordet = cb-cmov.PorDet.
            dTotImp1 = 0.
        END.
        IF cb-dmov.TM = 8 THEN dTotImp1 = dTotImp1 + ImpMn1.
        IF LAST-OF(cb-dmov.nroast) AND
            dPordet <> 0 AND dTotImp1 <> 0 THEN DO:
            dDetImp1 = ROUND((dTotImp1 * (dPordet / 100)),0).
            dSalImp1 = dTotImp1 - dDetImp1.
            IF cb-cmov.codmon = 2 THEN DO:
                dTotImp2 = ROUND((dTotImp1 / cb-cmov.tpocmb),2).
                dDetImp2 = ROUND((dDetImp1 / cb-cmov.tpocmb),2).
                dSalImp2 = dTotImp2 - dDetImp2.
            END.
            ELSE DO:
                dTotImp2 = 0.
                dDetImp2 = 0.
                dSalImp2 = 0.
            END.
            cNomAux = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN cNomAux = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN cNomAux = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.

            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codcta.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.codaux.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = cNomAux.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.glodoc.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.coddoc.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-dmov.nrodoc.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = dPordet.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp1.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp1.
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp1.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = cb-cmov.tpocmb.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotImp2.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):Value = dDetImp2.
            cRange = "P" + cColumn.
            chWorkSheet:Range(cRange):Value = dSalImp2.

            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.
        END.
    END.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

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

    FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK.
    IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
    IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

    IF iNroMes <> iNroMes-1 THEN
        cPinta-mes = "DE ENERO A DICIEMBRE DE " + STRING(COMBO-Periodo).
    ELSE cPinta-mes = CAPS(COMBO-Mes) + " DE " + STRING(COMBO-Periodo).

    DEFINE FRAME f-cab
        HEADER
        s-nomcia FORMAT "x(50)"
        "R E P O R T E   D E   D E T R A C C I O N E S" AT 107
        "FECHA : " TO 247 TODAY TO 257
        SKIP
        cPinta-mes  AT 114
        "PAGINA :" TO 247 PAGE-NUMBER(report) FORMAT ">,>>9" TO 257
        WITH WIDTH 400 NO-BOX DOWN STREAM-IO NO-UNDERLINE NO-LABEL PAGE-TOP.

    RUN bin/_centrar.p(INPUT cPinta-mes, 30, OUTPUT cPinta-mes).

    VIEW STREAM report FRAME F-CAB.

    FOR EACH cb-dmov NO-LOCK WHERE
        cb-dmov.codcia = s-codcia AND
        cb-dmov.periodo = COMBO-periodo AND
        cb-dmov.nromes >= iNroMes AND
        cb-dmov.nromes <= iNroMes-1 AND
        cb-dmov.codope = cCodOpe AND
        LOOKUP(cb-dmov.codcta,cListCta) > 0 AND
        cb-dmov.codaux >= FILL-IN-CodAux AND
        cb-dmov.codaux <= FILL-IN-CodAux-1,
        FIRST cb-cmov NO-LOCK WHERE
            cb-cmov.codcia = cb-dmov.codcia AND
            cb-cmov.periodo = cb-dmov.periodo AND
            cb-cmov.nromes = cb-dmov.nromes AND
            cb-cmov.codope = cb-dmov.codope AND
            cb-cmov.nroast = cb-dmov.nroast
        BREAK BY cb-dmov.nromes BY cb-dmov.nroast
        WITH FRAME f-det WIDTH 400:
        IF FIRST-OF(cb-dmov.nroast) THEN DO:
/*ML01* ***
            IF NUM-ENTRIES(cb-cmov.GloAst,"-") > 1 THEN
                dPordet = DECIMAL(ENTRY(1,cb-cmov.GloAst,"-")) NO-ERROR.
            ELSE dPordet = DECIMAL(cb-cmov.GloAst) NO-ERROR.
*ML01* ***/
/*ML01*/    dPordet = cb-cmov.PorDet.
            dTotImp1 = 0.
        END.
        IF cb-dmov.TM = 8 THEN dTotImp1 = dTotImp1 + ImpMn1.
        IF LAST-OF(cb-dmov.nroast) AND
            dPordet <> 0 AND dTotImp1 <> 0 THEN DO:
            dDetImp1 = ROUND((dTotImp1 * (dPordet / 100)),0).
            dSalImp1 = dTotImp1 - dDetImp1.
            IF cb-cmov.codmon = 2 THEN DO:
                dTotImp2 = ROUND((dTotImp1 / cb-cmov.tpocmb),2).
                dDetImp2 = ROUND((dDetImp1 / cb-cmov.tpocmb),2).
                dSalImp2 = dTotImp2 - dDetImp2.
            END.
            ELSE DO:
                dTotImp2 = 0.
                dDetImp2 = 0.
                dSalImp2 = 0.
            END.
            cNomAux = "".
            CASE cb-dmov.clfaux:
                WHEN "@CL" THEN DO:
                    cTipAux = "Cliente".
                    FIND gn-clie WHERE
                        gn-clie.codcli = cb-dmov.codaux AND
                        gn-clie.CodCia = cl-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-clie THEN cNomAux = gn-clie.nomcli.
                END.
                WHEN "@PV" THEN DO:
                    cTipAux = "Proveedor".
                    FIND gn-prov WHERE
                        gn-prov.codpro = cb-dmov.codaux AND
                        gn-prov.CodCia = pv-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE gn-prov THEN cNomAux = gn-prov.nompro.
                END.
                WHEN "@CT" THEN DO:
                    cTipAux = "Cuenta".
                    find cb-ctas WHERE
                        cb-ctas.codcta = cb-dmov.codaux AND
                        cb-ctas.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-ctas THEN cNomAux = cb-ctas.nomcta.
                END.
                OTHERWISE DO:
                    cTipAux = "Otro".
                    FIND cb-auxi WHERE
                        cb-auxi.clfaux = cb-dmov.clfaux AND
                        cb-auxi.codaux = cb-dmov.codaux AND
                        cb-auxi.CodCia = cb-codcia NO-LOCK NO-ERROR.
                    IF AVAILABLE cb-auxi THEN cNomAux = cb-auxi.nomaux.
                END.
            END CASE.

            ACCUMULATE dTotImp1 (TOTAL).
            ACCUMULATE dDetImp1 (TOTAL).
            ACCUMULATE dSalImp1 (TOTAL).
            ACCUMULATE dTotImp2 (TOTAL).
            ACCUMULATE dDetImp2 (TOTAL).
            ACCUMULATE dSalImp2 (TOTAL).

            DISPLAY STREAM report
                cb-cmov.fchast  COLUMN-LABEL "Fecha" FORMAT "99/99/99"
                cb-cmov.nroast  COLUMN-LABEL "Asto"
                cb-dmov.codcta  COLUMN-LABEL "Cuenta"
                cb-dmov.codaux  COLUMN-LABEL "Auxiliar"
                cNomAux         COLUMN-LABEL "Nombre"
                cb-dmov.glodoc  COLUMN-LABEL "Glosa" FORMAT "x(40)"
                cb-dmov.coddoc  COLUMN-LABEL "Cod!Doc"
                cb-dmov.nrodoc  COLUMN-LABEL "Documento"
                dPordet         COLUMN-LABEL "% Det"
                dTotImp1        COLUMN-LABEL "Importe S/."
                dDetImp1        COLUMN-LABEL "Detracción S/."
                dSalImp1        COLUMN-LABEL "Saldo S/."
                cb-cmov.tpocmb  COLUMN-LABEL "Tipo!Cambio" WHEN cb-cmov.tpocmb <> 0
                dTotImp2        COLUMN-LABEL "Importe US$" WHEN dTotImp2 <> 0
                dDetImp2        COLUMN-LABEL "Detracción US$" WHEN dDetImp2 <> 0
                dSalImp2        COLUMN-LABEL "Saldo US$" WHEN dSalImp2 <> 0
                WITH STREAM-IO.
            DISPLAY
                "   " + cTipAux + ": " + cb-dmov.codaux @ FI-MENSAJE
                WITH FRAME F-PROCESO.
        END.
        IF LAST(cb-dmov.nroast) THEN DO:
            UNDERLINE STREAM report
                dTotImp1
                dDetImp1
                dSalImp1
                dTotImp2
                dDetImp2
                dSalImp2
                WITH STREAM-IO.
            DISPLAY STREAM report
                ACCUM TOTAL dTotImp1 @ dTotImp1
                ACCUM TOTAL dDetImp1 @ dDetImp1
                ACCUM TOTAL dSalImp1 @ dSalImp1
                ACCUM TOTAL dTotImp2 @ dTotImp2
                ACCUM TOTAL dDetImp2 @ dDetImp2
                ACCUM TOTAL dSalImp2 @ dSalImp2
                WITH STREAM-IO.
        END.
    END.

    HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

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

   DEFINE VARIABLE pto AS LOGICAL NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            COMBO-Periodo:LIST-ITEMS = cPeriodo
            COMBO-Periodo = s-periodo
            COMBO-Mes = ENTRY(s-nromes,COMBO-Mes:LIST-ITEMS).
        DO ind = 1 TO NUM-ENTRIES(cPeriodo):
            IF ENTRY(ind,cPeriodo) = "" THEN pto = COMBO-Periodo:DELETE("").
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
        WHEN "F-Catconta" THEN ASSIGN input-var-1 = "CC".
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "" THEN ASSIGN input-var-1 = "".
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

