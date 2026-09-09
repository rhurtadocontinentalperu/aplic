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

{cbd\cbglobal.i}

DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE SHARED VAR cb-codcia AS INTEGER.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.

DEFINE STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-7 F-Compania R-tipo-reporte ~
cta-ini cta-fin l-margen Btn_OK BUTTON-1 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-Compania R-tipo-reporte cta-ini cta-fin ~
l-margen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 12 BY 1.62.

DEFINE VARIABLE cta-fin AS CHARACTER FORMAT "X(10)":U 
     LABEL "Hasta la Cta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE cta-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Desde la Cta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Compania AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Compañía" 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-tipo-reporte AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detallado", 2
     SIZE 10.86 BY 1.27 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 4.04.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 1.85.

DEFINE VARIABLE l-margen AS LOGICAL INITIAL no 
     LABEL "Indentado" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Compania AT ROW 1.54 COL 12 COLON-ALIGNED WIDGET-ID 6
     R-tipo-reporte AT ROW 2.15 COL 35.14 NO-LABEL WIDGET-ID 10
     cta-ini AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 4
     cta-fin AT ROW 3.69 COL 12 COLON-ALIGNED WIDGET-ID 2
     l-margen AT ROW 3.96 COL 34 WIDGET-ID 8
     Btn_OK AT ROW 5.58 COL 2 WIDGET-ID 20
     BUTTON-1 AT ROW 5.58 COL 14 WIDGET-ID 22
     Btn_Cancel AT ROW 5.58 COL 26 WIDGET-ID 18
     " Formato" VIEW-AS TEXT
          SIZE 6.72 BY .62 AT ROW 1.54 COL 35 WIDGET-ID 16
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 2
     RECT-7 AT ROW 1.85 COL 34 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 52.72 BY 6.54
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
         TITLE              = "Reporte de Cuentas Contables"
         HEIGHT             = 6.54
         WIDTH              = 52.72
         MAX-HEIGHT         = 6.54
         MAX-WIDTH          = 52.72
         VIRTUAL-HEIGHT     = 6.54
         VIRTUAL-WIDTH      = 52.72
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
ON END-ERROR OF W-Win /* Reporte de Cuentas Contables */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Cuentas Contables */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN
        cta-fin cta-ini
        F-Compania
        l-margen
        R-tipo-reporte.

    cta-fin = cta-fin + "9999999999".
    IF cta-fin < cta-ini THEN DO:
        MESSAGE
            "La cuenta fin es menor" SKIP
            "que la cuenta inicio"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cta-ini.
        RETURN NO-APPLY.
    END.

    RUN Imprime.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN
        cta-fin cta-ini
        F-Compania
        l-margen
        R-tipo-reporte.

    cta-fin = cta-fin + "9999999999".
    IF cta-fin < cta-ini THEN DO:
        MESSAGE
            "La cuenta fin es menor" SKIP
            "que la cuenta inicio"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cta-ini.
        RETURN NO-APPLY.
    END.

    RUN Imprime-Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}
{lib/def-prn2.i}

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
  DISPLAY F-Compania R-tipo-reporte cta-ini cta-fin l-margen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-7 F-Compania R-tipo-reporte cta-ini cta-fin l-margen 
         Btn_OK BUTTON-1 Btn_Cancel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-1 W-Win 
PROCEDURE Excel-1 :
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):VALUE = "Cuenta".
chWorkSheet:Range("B2"):VALUE = "Auxiliar".
chWorkSheet:Range("C2"):VALUE = "Descripcion".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".        /* Texto */

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND codcta >= cta-ini
     AND codcta <= cta-fin NO-LOCK BREAK BY SUBSTRING(codcta,1,2):
     IF F-Compania <> 000 THEN DO:
        IF cb-ctas.vcodcia <> 000 THEN IF cb-ctas.vcodcia <> F-Compania THEN NEXT.
     END.
     t-column = t-column + 1.
     IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN DO:
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = cb-ctas.codcta.
        cRange = "C" + cColumn.   
        chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
        t-column = t-column + 1.
     END.
     cColumn = STRING(t-Column).      
     cRange = "A" + cColumn.   
     chWorkSheet:Range(cRange):Value = cb-ctas.codcta.
     cRange = "B" + cColumn.   
     chWorkSheet:Range(cRange):Value = cb-ctas.clfaux.
     cRange = "C" + cColumn.   
     chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):VALUE = "Cuenta".
chWorkSheet:Range("B2"):VALUE = "Auxiliar".
chWorkSheet:Range("C2"):VALUE = "Descripcion".
chWorkSheet:Range("D2"):VALUE = "Dif Cmb".
chWorkSheet:Range("E2"):VALUE = "Cod Mon".
chWorkSheet:Range("F2"):VALUE = "Tpo Cmb".
chWorkSheet:Range("G2"):VALUE = "Pid Doc".
chWorkSheet:Range("H2"):VALUE = "Cod Doc".
chWorkSheet:Range("I2"):VALUE = "Pid Ref".
chWorkSheet:Range("J2"):VALUE = "Cuenta Autom".
chWorkSheet:Range("K2"):VALUE = "Contra Cuenta".
chWorkSheet:Range("L2"):VALUE = "Pid Cco".
chWorkSheet:Range("M2"):VALUE = "Cierre Anual Resumido".
chWorkSheet:Range("N2"):VALUE = "Solicita sustento de gasto".
chWorkSheet:Range("O2"):VALUE = "Tpo de Gasto".
chWorkSheet:Range("P2"):VALUE = "T.Monto".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".        /* Texto */

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH cb-ctas NO-LOCK WHERE cb-ctas.codcia = cb-codcia AND 
    codcta >= cta-ini AND codcta <= cta-fin
    BREAK BY SUBSTRING(codcta,1,2):
    IF F-Compania <> 000 THEN DO:
       IF cb-ctas.vcodcia <> 000 THEN IF cb-ctas.vcodcia <> F-Compania THEN NEXT.
    END.
    t-column = t-column + 1.
    IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN DO:
        cColumn = STRING(t-Column).      
        cRange = "A" + cColumn.   
        chWorkSheet:Range(cRange):Value = cb-ctas.codcta.
        cRange = "B" + cColumn.   
        chWorkSheet:Range(cRange):Value = cb-ctas.clfaux.
        cRange = "C" + cColumn.   
        chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
        t-column = t-column + 1.
    END.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.codcta.
    cRange = "B" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.clfaux.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.nomcta.
    cRange = "D" + cColumn.   
    chWorkSheet:Range(cRange):Value = IF cb-ctas.aftdcb THEN 'Si' ELSE 'No'.
    cRange = "E" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.codmon.
    cRange = "F" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.tpocmb.
    cRange = "G" + cColumn.   
    chWorkSheet:Range(cRange):Value = IF cb-ctas.piddoc THEN 'Si' ELSE 'No'.
    cRange = "H" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.coddoc.
    cRange = "I" + cColumn.   
    chWorkSheet:Range(cRange):Value = IF cb-ctas.pidref THEN 'Si' ELSE 'No'.
    cRange = "J" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.an1cta.
    cRange = "K" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.cc1cta.
    cRange = "L" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.pidcco.
    cRange = "M" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.cieres.
    cRange = "N" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.sustento.
    cRange = "O" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.tpogto.
    cRange = "P" + cColumn.   
    chWorkSheet:Range(cRange):Value = cb-ctas.tm.
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
  DEFINE VAR x-codcta AS CHAR NO-UNDO.
  DEFINE VAR i AS INTEGER NO-UNDO.
  i = INTEGER(ENTRY(1,cb-niveles)).
  
  DEFINE FRAME f-cab 
    SPACE(10) 
    cb-ctas.codcta 
    cb-ctas.clfaux COLUMN-LABEL "Aux."
    cb-ctas.nomcta
    HEADER 
    s-nomcia FORMAT 'X(40)' "FECHA :" TO 69 TODAY TO 78 SKIP
    "OFICINA DE CONTABILIDAD" "PAGINA :" TO 69
    c-Pagina FORMAT "ZZ9" TO 100 SKIP
    "PLAN DE CUENTAS" AT 33 SKIP
    WITH DOWN NO-BOX STREAM-IO.
  
  DEFINE FRAME f-cab2
    cb-ctas.codcta 
    cb-ctas.clfaux COLUMN-LABEL "Aux."
    cb-ctas.Nomcta
    cb-ctas.aftdcb COLUMN-LABEL "Dif!Cmb"
    cb-ctas.codmon COLUMN-LABEL "Cod!Mon"
    cb-ctas.tpocmb COLUMN-LABEL "Tpo!Cmb"
    cb-ctas.piddoc COLUMN-LABEL "Pid!Doc"
    cb-ctas.coddoc COLUMN-LABEL "Cod!Doc"
    cb-ctas.pidref COLUMN-LABEL "Pid!Ref"
    cb-ctas.An1Cta COLUMN-LABEL "Cuenta!Autom."
    cb-ctas.Cc1Cta COLUMN-LABEL "Contra!Cuenta"    
    HEADER
    s-NomCia "FECHA :" TO 91 TODAY TO 100 SKIP
    "OFICINA DE CONTABILIDAD" "PAGINA :" TO 91
    c-Pagina FORMAT "ZZ9" TO 100 SKIP
    "PLAN DE CUENTAS":C100  SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 160.

IF R-tipo-reporte = 1 THEN
   FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND codcta >= cta-ini
        AND codcta <= cta-fin NO-LOCK
        BREAK BY SUBSTRING(codcta,1,2) ON ERROR UNDO, LEAVE:
        IF F-Compania <> 000 THEN DO:
           IF cb-ctas.vcodcia <> 000 THEN
              IF cb-ctas.vcodcia <> F-Compania THEN NEXT.
        END.
        IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN DO:
           {&NEW-PAGE}.
           DOWN STREAM report 2 WITH FRAME f-cab.
           {&NEW-PAGE}.
           DISPLAY STREAM report 
                FILL("=", LENGTH(nomcta)) @ cb-ctas.nomcta WITH FRAME f-cab.
           {&NEW-PAGE}.
           DOWN STREAM report 1 WITH FRAME f-cab.
           {&NEW-PAGE}.
           DISPLAY STREAM report 
                cb-ctas.codcta
                cb-ctas.nomcta WITH FRAME f-cab.
           {&NEW-PAGE}.
           DOWN STREAM report 1 WITH FRAME f-cab.
           {&NEW-PAGE}.
           DISPLAY STREAM report 
                FILL("=",LENGTH(nomcta)) @ cb-ctas.nomcta WITH FRAME f-cab.
        END.
        IF l-margen THEN 
           x-codcta = FILL(" ",LENGTH(cb-ctas.codcta) - i) + cb-ctas.codcta.
        ELSE 
           X-codcta = cb-ctas.codcta.
        {&NEW-PAGE}.
        DISPLAY STREAM report 
           X-codcta @ cb-ctas.codcta
           cb-ctas.clfaux 
           cb-ctas.nomcta WITH FRAME f-cab.
        IF LAST-OF (SUBSTRING(codcta,1,2)) THEN DO:
           {&NEW-PAGE}.
           DOWN STREAM report WITH FRAME f-cab.
        END.
   END.
ELSE
   FOR EACH cb-ctas WHERE cb-ctas.codcia = cb-codcia AND 
       codcta >= cta-ini AND codcta <= cta-fin NO-LOCK
       BREAK BY SUBSTRING(codcta,1,2) ON ERROR UNDO, LEAVE:
       IF F-Compania <> 000 THEN DO:
          IF cb-ctas.vcodcia <> 000 THEN
             IF cb-ctas.vcodcia <> F-Compania THEN NEXT.
       END.
       IF FIRST-OF (SUBSTRING(codcta,1,2)) THEN DO:
          {&NEW-PAGE}.
          DOWN STREAM report 2 WITH FRAME f-cab2.
          {&NEW-PAGE}.
          DISPLAY STREAM report 
               FILL("=", LENGTH(nomcta)) @ cb-ctas.nomcta WITH FRAME f-cab2.
          {&NEW-PAGE}.
          DOWN STREAM report 1 WITH FRAME f-cab2.
          {&NEW-PAGE}.
          DISPLAY STREAM report 
               cb-ctas.codcta 
               cb-ctas.clfaux 
               cb-ctas.nomcta WITH FRAME f-cab2.
          {&NEW-PAGE}.
          DOWN STREAM report 1 WITH FRAME f-cab2.
          {&NEW-PAGE}.
          DISPLAY STREAM report 
               FILL("=",LENGTH(nomcta)) @ cb-ctas.nomcta WITH FRAME f-cab2.
       END.
       IF l-margen  THEN x-codcta = FILL(" ",LENGTH(cb-ctas.codcta) - i) + cb-ctas.codcta.
       ELSE X-codcta = cb-ctas.codcta.
       {&NEW-PAGE}.
       DISPLAY STREAM report 
           X-codcta @ cb-ctas.codcta 
           cb-ctas.clfaux 
           cb-ctas.nomcta
           cb-ctas.aftdcb
           cb-ctas.codmon 
           cb-ctas.tpocmb 
           cb-ctas.piddoc 
           cb-ctas.coddoc 
           cb-ctas.pidref 
           cb-ctas.An1Cta 
           cb-ctas.Cc1Cta 
           WITH FRAME f-cab2.
       IF LAST-OF (SUBSTRING(codcta,1,2)) THEN DO:
          {&NEW-PAGE}.
          DOWN STREAM report WITH FRAME f-cab2.
       END.
   END.

   HIDE FRAME F-Mensaje.

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

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    ASSIGN
        P-Largo = 66.
        P-reset = {&Prn0}.
        P-flen = {&Prn5A} + CHR(66).
        P-config = {&Prn4}.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        OUTPUT STREAM report TO NUL PAGED PAGE-SIZE 1000.
        c-Pagina = 0.
        RUN Formato.
        OUTPUT STREAM report CLOSE.        
    END.
    OUTPUT STREAM report CLOSE.        

    HIDE FRAME F-Mensaje.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Excel W-Win 
PROCEDURE Imprime-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos informacion */
VIEW FRAME f-Mensaje.
CASE r-Tipo-Reporte:
    WHEN 1 THEN RUN Excel-1.
    WHEN 2 THEN RUN Excel-2.
END CASE.
HIDE FRAME f-Mensaje.

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
RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
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

