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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-nomcia AS CHARACTER.

DEFINE VARIABLE cCodDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodOpe AS CHARACTER NO-UNDO.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0 NO-UNDO.

DEFINE TEMP-TABLE tt_ret NO-UNDO
    FIELDS tt_nroret AS CHARACTER FORMAT "x(9)" COLUMN-LABEL "Comprobte!Retención"
    FIELDS tt_fchast LIKE cb-cmov.fchast FORMAT "99/99/99"
    FIELDS tt_nroast LIKE cb-cmov.nroast
    FIELDS tt_codpro LIKE gn-prov.CodPro
    FIELDS tt_coddoc AS CHARACTER LABEL "Tpo" FORMAT "x(2)"
    FIELDS tt_nrodoc AS CHARACTER LABEL "Documento" FORMAT "x(12)"
    FIELDS tt_fchdoc AS DATE COLUMN-LABEL "Fecha de!Document"
    FIELDS tt_imptot AS DECIMAL FORMAT "->,>>>,>>9.99" COLUMN-LABEL "Monto del!Pago"
    FIELDS tt_impret AS DECIMAL FORMAT "->,>>>,>>9.99" COLUMN-LABEL "Importe!Retenido"
    FIELDS tt_codmon AS INTEGER
    INDEX tt_idx1 AS PRIMARY tt_nroret.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando..." FONT 7.

FIND Empresas WHERE Empresas.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

cCodDoc = "RET".
cCodOpe = "002".

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchAst FILL-IN-FchAst-2 ~
COMBO-BOX-serie FILL-IN-NroComp FILL-IN-NroComp-2 BUTTON-3 BUTTON-1 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchAst FILL-IN-FchAst-2 ~
COMBO-BOX-serie FILL-IN-NroComp FILL-IN-NroComp-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-serie AS CHARACTER FORMAT "X(3)":U 
     LABEL "Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst AS DATE FORMAT "99/99/99":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAst-2 AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroComp AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroComp-2 AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-FchAst AT ROW 1.54 COL 13 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-FchAst-2 AT ROW 1.54 COL 32 COLON-ALIGNED WIDGET-ID 16
     COMBO-BOX-serie AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NroComp AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroComp-2 AT ROW 3.69 COL 32 COLON-ALIGNED WIDGET-ID 14
     BUTTON-3 AT ROW 5.04 COL 12 WIDGET-ID 6
     BUTTON-1 AT ROW 5.04 COL 28
     BUTTON-2 AT ROW 5.04 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62 BY 6
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
         TITLE              = "Reporte de Comprobantes de Retención"
         HEIGHT             = 6
         WIDTH              = 62
         MAX-HEIGHT         = 6
         MAX-WIDTH          = 62
         VIRTUAL-HEIGHT     = 6
         VIRTUAL-WIDTH      = 62
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

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Comprobantes de Retención */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Comprobantes de Retención */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:

    ASSIGN COMBO-BOX-serie FILL-IN-FchAst FILL-IN-FchAst-2 FILL-IN-NroComp FILL-IN-NroComp-2.

    IF FILL-IN-FchAst = ? THEN FILL-IN-FchAst = 01/01/1900.
    IF FILL-IN-FchAst-2 = ? THEN FILL-IN-FchAst = 12/31/3999.
    IF FILL-IN-NroComp-2 = 0 THEN FILL-IN-NroComp-2 = 999999.

    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:

    ASSIGN COMBO-BOX-serie FILL-IN-FchAst FILL-IN-FchAst-2 FILL-IN-NroComp FILL-IN-NroComp-2.

    IF FILL-IN-FchAst = ? THEN FILL-IN-FchAst = 01/01/1900.
    IF FILL-IN-FchAst-2 = ? THEN FILL-IN-FchAst = 12/31/3999.
    IF FILL-IN-NroComp-2 = 0 THEN FILL-IN-NroComp-2 = 999999.

    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-serie W-Win
ON RETURN OF COMBO-BOX-serie IN FRAME F-Main /* Serie */
DO:
    APPLY 'TAB':U TO SELF.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNroComp AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNroComp1 AS CHARACTER NO-UNDO.

    DEFINE BUFFER b_cb-dmov FOR cb-dmov.

    ASSIGN
        cNroComp = COMBO-BOX-serie + STRING(FILL-IN-NroComp,"999999")
        cNroComp1 = COMBO-BOX-serie + STRING(FILL-IN-NroComp-2,"999999").

    FOR EACH tt_ret:
        DELETE tt_ret.
    END.

    FOR EACH cb-cmov FIELDS
        (cb-cmov.CodCia cb-cmov.Periodo cb-cmov.NroMes
        cb-cmov.CodOpe cb-cmov.FchAst cb-cmov.codmon) WHERE
        cb-cmov.CodCia = s-CodCia AND
        cb-cmov.Periodo = YEAR(FILL-IN-FchAst) AND
        cb-cmov.NroMes = MONTH(FILL-IN-FchAst) AND
        cb-cmov.CodOpe = cCodOpe AND
        cb-cmov.FchAst >= FILL-IN-FchAst AND
        cb-cmov.FchAst <= FILL-IN-FchAst-2 NO-LOCK,
        EACH cb-dmov FIELDS
        (cb-dmov.CodCia cb-dmov.Periodo cb-dmov.NroMes cb-dmov.CodOpe
        cb-dmov.NroAst cb-dmov.chr_01 cb-dmov.codaux cb-dmov.coddoc cb-dmov.CodCta
        cb-dmov.nrodoc cb-dmov.fchdoc cb-dmov.ImpMn1) WHERE
        cb-dmov.CodCia = cb-cmov.CodCia AND
        cb-dmov.Periodo = cb-cmov.Periodo AND
        cb-dmov.NroMes = cb-cmov.NroMes AND
        cb-dmov.CodOpe = cb-cmov.CodOpe AND
        cb-dmov.NroAst = cb-cmov.NroAst AND
        cb-dmov.chr_01 <> "" NO-LOCK:

        DISPLAY
            cb-dmov.NroAst @ Fi-Mensaje LABEL " Nro Asiento" FORMAT "X(11)"
            WITH FRAME F-Proceso.

        IF cb-dmov.chr_01 >= cNroComp AND
            cb-dmov.chr_01 <= cNroComp1 THEN DO:
            CREATE tt_ret.
            ASSIGN
                tt_nroret = cb-dmov.chr_01
                tt_fchast = cb-cmov.fchast
                tt_nroast = cb-cmov.nroast
                tt_codpro = cb-dmov.codaux
                tt_coddoc = cb-dmov.coddoc
                tt_nrodoc = cb-dmov.nrodoc
                tt_fchdoc = cb-dmov.fchdoc
                tt_codmon = cb-cmov.codmon
                tt_impret = cb-dmov.ImpMn1.
            /* Busca el Monto Pagado */
            FOR EACH b_cb-dmov
                FIELDS (b_cb-dmov.CodCia b_cb-dmov.Periodo b_cb-dmov.NroMes b_cb-dmov.CodOpe
                    b_cb-dmov.NroAst b_cb-dmov.CodCta b_cb-dmov.CodAux b_cb-dmov.CodDoc
                    b_cb-dmov.NroDoc b_cb-dmov.ImpMn1 b_cb-dmov.ImpMn2)
                WHERE b_cb-dmov.CodCia = cb-dmov.CodCia
                AND b_cb-dmov.Periodo = cb-dmov.Periodo
                AND b_cb-dmov.NroMes = cb-dmov.NroMes
                AND b_cb-dmov.CodOpe = cb-dmov.CodOpe
                AND b_cb-dmov.NroAst = cb-dmov.NroAst
                NO-LOCK:
                IF b_cb-dmov.CodCta <> cb-dmov.CodCta AND
                    b_cb-dmov.CodAux = cb-dmov.CodAux AND
                    b_cb-dmov.CodDoc = cb-dmov.CodDoc AND
                    b_cb-dmov.NroDoc = cb-dmov.NroDoc THEN
                    IF cb-cmov.codmon = 1 THEN
                        tt_imptot = b_cb-dmov.ImpMn1.
                    ELSE
                        tt_imptot = b_cb-dmov.ImpMn2.
            END.

        END.
    END.

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
  DISPLAY FILL-IN-FchAst FILL-IN-FchAst-2 COMBO-BOX-serie FILL-IN-NroComp 
          FILL-IN-NroComp-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-FchAst FILL-IN-FchAst-2 COMBO-BOX-serie FILL-IN-NroComp 
         FILL-IN-NroComp-2 BUTTON-3 BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cNomPro LIKE gn-prov.NomPro NO-UNDO.
    DEFINE VARIABLE cRuc LIKE gn-prov.Ruc NO-UNDO.
    DEFINE VARIABLE cSymbol AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSymRet AS CHARACTER INITIAL " S/." NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    RUN Carga-Temporal.

    /*Formato*/
    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):NumberFormat = "@".
    chWorkSheet:COLUMNS("F"):NumberFormat = "@".
    chWorkSheet:COLUMNS("G"):NumberFormat = "@".
    chWorkSheet:Range("A1:L2"):FONT:Bold = TRUE.
    chWorkSheet:COLUMNS("C"):ColumnWidth = 30.

    /*Cabecera*/
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "REPORTE DE RETENCIONES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NRO RETENCIÓN".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "PROVEEDOR".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NOMBRE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "ASIENTO".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FECHA ASTO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "CODIGO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NÚMERO DOC".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FECHA DOC".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "MONEDA".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "IMPORTE".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "MONEDA".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "IMP RETENCIÓN".

    FOR EACH tt_ret
        BREAK BY tt_nroret:
        IF FIRST-OF(tt_nroret) THEN DO:
            FOR gn-prov
                FIELDS (gn-prov.CodCia gn-prov.CodPro gn-prov.NomPro gn-prov.Ruc)
                WHERE gn-prov.CodCia = pv-CodCia
                AND gn-prov.CodPro = tt_codpro
                NO-LOCK:
            END.
            IF AVAILABLE gn-prov THEN DO:
                cNomPro = gn-prov.NomPro.
                cRuc = gn-prov.Ruc.
            END.
            ELSE DO:
                cNomPro = "".
                cRuc = "".
            END.
            cSymbol = IF tt_codmon = 1 THEN "S/." ELSE "US$".
        END.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_nroret.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_codpro.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cNomPro.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_nroast.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_fchast.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_coddoc.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_nrodoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_fchdoc.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cSymbol.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_imptot.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = cSymRet.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):VALUE = tt_impret.

    END.    

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

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

    DEFINE VARIABLE cNomPro LIKE gn-prov.NomPro FORMAT "x(30)" NO-UNDO.
    DEFINE VARIABLE cRuc LIKE gn-prov.Ruc NO-UNDO.
    DEFINE VARIABLE iInd AS INTEGER NO-UNDO.
    DEFINE VARIABLE iCounReg AS INTEGER NO-UNDO.
    DEFINE VARIABLE cSymbol AS CHARACTER FORMAT "x(3)" NO-UNDO.
    DEFINE VARIABLE cSymRet AS CHARACTER FORMAT "x(4)" INITIAL " S/." NO-UNDO.

    FIND FIRST tt_ret NO-LOCK NO-ERROR.

    DEFINE FRAME F-REPORTE
        tt_nroret
        tt_codpro
        cNomPro
        tt_nroast
        tt_fchast
        tt_coddoc
        tt_nrodoc
        tt_fchdoc
        cSymbol     COLUMN-LABEL "Mon"
        tt_imptot
        cSymRet     COLUMN-LABEL "Mon"
        tt_impret
        WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

    DEFINE FRAME F-HEADER
        HEADER
        s-nomcia
        "PAGINA:" TO 100 PAGE-NUMBER(REPORT) SKIP
        "REPORTE DE RETENCIONES"
        WITH PAGE-TOP WIDTH 200 NO-LABELS NO-UNDERLINE STREAM-IO.

    FOR EACH tt_ret
        BREAK BY tt_nroret:
        IF FIRST-OF(tt_nroret) THEN DO:
            FOR gn-prov
                FIELDS (gn-prov.CodCia gn-prov.CodPro gn-prov.NomPro gn-prov.Ruc)
                WHERE gn-prov.CodCia = pv-CodCia
                AND gn-prov.CodPro = tt_codpro
                NO-LOCK:
            END.
            IF AVAILABLE gn-prov THEN DO:
                cNomPro = gn-prov.NomPro.
                cRuc = gn-prov.Ruc.
            END.
            ELSE DO:
                cNomPro = "".
                cRuc = "".
            END.
            iCounReg = 0.
            cSymbol = IF tt_codmon = 1 THEN "S/." ELSE "US$".
            VIEW STREAM REPORT FRAME F-HEADER.
        END.

        ACCUMULATE tt_imptot (TOTAL BY tt_nroret).
        ACCUMULATE tt_impret (TOTAL BY tt_nroret).
        iCounReg = iCounReg + 1.

        DISPLAY STREAM REPORT
            tt_nroret   WHEN FIRST-OF(tt_nroret)
            tt_codpro   WHEN FIRST-OF(tt_nroret)
            cNomPro     WHEN FIRST-OF(tt_nroret)
            tt_nroast   WHEN FIRST-OF(tt_nroret)
            tt_fchast   WHEN FIRST-OF(tt_nroret)
            tt_coddoc
            tt_nrodoc
            tt_fchdoc
            cSymbol
            tt_imptot
            cSymRet
            tt_impret
            WITH FRAME F-REPORTE.

        IF LAST(tt_nroret) THEN DO:
            UNDERLINE STREAM REPORT tt_impret WITH FRAME F-REPORTE.
            DISPLAY STREAM REPORT
                cSymRet
                ACCUM TOTAL tt_impret @ tt_impret
                WITH FRAME F-REPORTE.
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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    FIND FIRST tt_ret NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt_ret THEN DO:
        MESSAGE
            "No existen Comprobantes a Imprimir"
            VIEW-AS ALERT-BOX INFORMA.
        RETURN.
    END.

    IF s-salida-impresion = 1 THEN
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 66.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 66. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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

    DEFINE VARIABLE cListSer AS CHARACTER NO-UNDO.

    FOR EACH faccorre WHERE
        faccorre.codcia = s-codcia AND
        faccorre.coddoc = cCodDoc AND
        faccorre.NroSer >= 0 NO-LOCK:
        IF FlgEst THEN DO:
            IF cListSer = "" THEN cListSer = STRING(faccorre.NroSer,"999").
            ELSE cListSer = cListSer + "," + STRING(faccorre.NroSer,"999").
            FILL-IN-NroComp-2 = faccorre.correlativo.
        END.
    END.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-FchAst = DATE(MONTH(TODAY),1,YEAR(TODAY))
            FILL-IN-FchAst-2 = TODAY
            COMBO-BOX-serie:LIST-ITEMS = cListSer
            COMBO-BOX-serie = ENTRY(1,cListSer).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "FILL-IN-CCosto" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
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

