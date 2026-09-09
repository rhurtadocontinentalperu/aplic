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
DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

DEFINE VAR C-DESMOV AS CHAR.
DEFINE VAR X-flgest AS CHAR.
DEFINE VAR S-ImpCto AS DECIMAL NO-UNDO.
DEFINE VAR F-Candes AS DECIMAL NO-UNDO.
DEFINE VAR X-despro AS CHARACTER NO-UNDO.
DEFINE VAR X-Cospro AS DECIMAL NO-UNDO.
DEFINE VAR X-Impcto AS DECIMAL NO-UNDO.
DEFINE VAR T-Impcto AS DECIMAL NO-UNDO.
DEFINE VAR D-Impcto AS DECIMAL NO-UNDO.
DEFINE VAR X-SUB1   AS CHAR INIT "".
DEFINE VAR X-SUB2   AS CHAR INIT "".
DEFINE VAR X-Desmat AS CHAR .
DEFINE VAR X-Desmar AS CHAR .
DEFINE VAR F-ImpCto AS DECIMAL NO-UNDO.

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 C-TipMov C-CodMov DocIni DocFin ~
DesdeF HastaF F-provee1 F-provee2 DesdeC HastaC T-valorizado T-Igv ~
Btn_texto-2 Btn_texto Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS C-TipMov C-CodMov DocIni DocFin DesdeF ~
HastaF F-provee1 F-provee2 DesdeC HastaC T-valorizado T-Igv 

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
     SIZE 11 BY 1.5 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_texto 
     IMAGE-UP FILE "img/api-lc.ico":U
     LABEL "Texto" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON Btn_texto-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Texto" 
     SIZE 11 BY 1.5 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE VARIABLE C-CodMov AS CHARACTER FORMAT "X(2)":U 
     LABEL "Codigo Movimiento" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DocFin AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE DocIni AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "Nro. Documento" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-provee2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE C-TipMov AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ingresos", "I",
"Salidas", "S",
"Transferencias", "T"
     SIZE 13.29 BY 1.81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.96.

DEFINE VARIABLE T-Igv AS LOGICAL INITIAL no 
     LABEL "Con IGV" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.

DEFINE VARIABLE T-valorizado AS LOGICAL INITIAL no 
     LABEL "Valorizado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     C-TipMov AT ROW 2.65 COL 20 NO-LABEL
     C-CodMov AT ROW 4.73 COL 18 COLON-ALIGNED
     DocIni AT ROW 5.5 COL 18 COLON-ALIGNED
     DocFin AT ROW 5.5 COL 47 COLON-ALIGNED
     DesdeF AT ROW 6.19 COL 18 COLON-ALIGNED
     HastaF AT ROW 6.19 COL 47 COLON-ALIGNED
     F-provee1 AT ROW 6.92 COL 18 COLON-ALIGNED
     F-provee2 AT ROW 6.92 COL 47 COLON-ALIGNED
     DesdeC AT ROW 7.65 COL 18 COLON-ALIGNED
     HastaC AT ROW 7.65 COL 47 COLON-ALIGNED
     T-valorizado AT ROW 8.65 COL 47.72
     T-Igv AT ROW 8.65 COL 64
     Btn_texto-2 AT ROW 10.35 COL 29 WIDGET-ID 2
     Btn_texto AT ROW 10.35 COL 41
     Btn_OK AT ROW 10.35 COL 53.72
     Btn_Cancel AT ROW 10.35 COL 66.14
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Tipo de Movimiento" VIEW-AS TEXT
          SIZE 13.72 BY .5 AT ROW 2.77 COL 5.29
     RECT-57 AT ROW 1.23 COL 1.14
     RECT-46 AT ROW 10.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
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
         TITLE              = "Registro de Movimientos FOC"
         HEIGHT             = 10.92
         WIDTH              = 80
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Movimientos FOC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Movimientos FOC */
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


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_texto W-Win
ON CHOOSE OF Btn_texto IN FRAME F-Main /* Texto */
DO:

    DEFINE VARIABLE cFile-Name AS CHARACTER FORMAT "x(40)" LABEL "Archivo".
    DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.

    cFile-Name = "M:\FOC.txt".

    lOk = FALSE.
    SYSTEM-DIALOG GET-FILE cFile-Name
        TITLE      "Seleccione Archivo..."
        FILTERS    "Texto (*.txt)"   "*.txt",
                   "Todos (*.*)"     "*.*"
        MUST-EXIST
        SAVE-AS
        USE-FILENAME
        UPDATE lOk.
    IF lOk <> TRUE THEN RETURN NO-APPLY.

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Genera-Txt(cFile-Name).
    RUN Habilita.
    RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_texto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_texto-2 W-Win
ON CHOOSE OF Btn_texto-2 IN FRAME F-Main /* Texto */
DO:
    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel.
    RUN Habilita.
    RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee1 W-Win
ON LEAVE OF F-provee1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-provee2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-provee2 W-Win
ON LEAVE OF F-provee2 IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA 
                AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN do:
/*     DISPLAY gn-prov.NomPro @ FILL-IN-NomPro1 WITH FRAME {&FRAME-NAME}.*/
  END.
  ELSE DO:
      FIND gn-prov WHERE gn-prov.CodCia = pv-codcia 
                    AND  gn-prov.CodPro = SELF:SCREEN-VALUE 
                   NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
           MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
      END.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-valorizado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-valorizado W-Win
ON VALUE-CHANGED OF T-valorizado IN FRAME F-Main /* Valorizado */
DO:
  ASSIGN T-valorizado T-igv.
  
  IF T-valorizado = NO  THEN T-igv:SENSITIVE = NO.
  IF T-valorizado = YES THEN T-igv:SENSITIVE = YES.

 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN C-CodMov C-TipMov DesdeC DesdeF DocFin DocIni F-provee1 F-provee2 HastaC HastaF T-valorizado T-igv.

  IF DocFin = 0 THEN DocFin = 999999.
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.
  IF HastaC = "" THEN HastaC = "999999".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".

  X-SUB1 = "Documentos Emitidos del:" + STRING(DocIni) +  "al:" +  STRING(DocFin) . 
  X-SUB2 = "Periodo del:" + STRING(DesdeF)  + "al:" + STRING(HastaF) .
  

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
  DISPLAY C-TipMov C-CodMov DocIni DocFin DesdeF HastaF F-provee1 F-provee2 
          DesdeC HastaC T-valorizado T-Igv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 C-TipMov C-CodMov DocIni DocFin DesdeF HastaF F-provee1 
         F-provee2 DesdeC HastaC T-valorizado T-Igv Btn_texto-2 Btn_texto 
         Btn_OK Btn_Cancel 
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VARIABLE x-CuentaReg AS INTE INIT 0 NO-UNDO.
DEFINE VARIABLE x-ImpMn1 LIKE cb-dmov.ImpMn1 NO-UNDO.
DEFINE VARIABLE x-NroDoc LIKE cb-dmov.NroDoc NO-UNDO.
DEFINE VARIABLE x-FchDoc LIKE cb-dmov.FchDoc NO-UNDO.
DEFINE VARIABLE x-NroAst LIKE cb-dmov.NroAst NO-UNDO.
DEFINE VARIABLE x-CodOpe LIKE cb-dmov.CodOpe NO-UNDO.
DEFINE VARIABLE x-periodo LIKE cb-dmov.periodo NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("D"):ColumnWidth = 25.
chWorkSheet:COLUMNS("E"):ColumnWidth = 25.
chWorkSheet:COLUMNS("G"):ColumnWidth = 25.
chWorkSheet:COLUMNS("F"):ColumnWidth = 25.

chWorkSheet:Range("A2"):VALUE = "Documento".
chWorkSheet:Range("B2"):VALUE = "Alm Dest".
chWorkSheet:Range("C2"):VALUE = "Fecha".
chWorkSheet:Range("D2"):VALUE = "Referencia".
chWorkSheet:Range("E2"):VALUE = "Referencia".
chWorkSheet:Range("F2"):VALUE = "Proveedor".
chWorkSheet:Range("G2"):VALUE = "Nombre o Razón Social".
chWorkSheet:Range("H2"):VALUE = "Usuario".
chWorkSheet:Range("I2"):VALUE = "Estado".
chWorkSheet:Range("J2"):VALUE = "Ope".
chWorkSheet:Range("K2"):VALUE = "Asto".
chWorkSheet:Range("L2"):VALUE = "Nro Doc".
chWorkSheet:Range("M2"):VALUE = "Fecha".
chWorkSheet:Range("N2"):VALUE = "Importe S/.".
chWorkSheet:Range("O2"):VALUE = "Articulo".
chWorkSheet:Range("P2"):VALUE = "Descripción".
chWorkSheet:Range("Q2"):VALUE = "Marca".
chWorkSheet:Range("R2"):VALUE = "Unid".
chWorkSheet:Range("S2"):VALUE = "Cantidad".
chWorkSheet:Range("T2"):VALUE = "Precio".
chWorkSheet:Range("U2"):VALUE = "Importe".
chWorkSheet:Range("V2"):VALUE = "Observaciones".
chWorkSheet:Range("W2"):VALUE = "Forma Pago".

chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".
chWorkSheet:COLUMNS("L"):NumberFormat = "@".
chWorkSheet:COLUMNS("O"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH Almcmov WHERE
    Almcmov.CodCia  = S-CODCIA AND
    Almcmov.CodAlm  = S-CODALM AND
    Almcmov.TipMov  = C-TipMov AND
    STRING(Almcmov.CodMov,"99") BEGINS C-CodMov AND
    (Almcmov.NroDoc >= DocIni AND Almcmov.NroDoc <= DocFin) AND
    (Almcmov.FchDoc >= DesdeF AND Almcmov.FchDoc <= HastaF) AND
    (Almcmov.CodPro >= F-provee1 AND Almcmov.CodPro <= F-provee2)
    BREAK BY Almcmov.CodMov:

    x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO".          
    IF Almcmov.TipMov = 'S' THEN DO :
        IF trim(Almcmov.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
        IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
        IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
    END.

    IF Almcmov.TipMov = 'I' THEN DO :   
        IF trim(Almcmov.FlgEst) = "A" THEN assign X-Flgest = "  ANULADO  ".  
        IF trim(Almcmov.FlgEst) = ""  THEN assign X-Flgest = "   ACTIVO  ".  
        IF trim(Almcmov.FlgEst) = "C" THEN assign X-Flgest = "   ACTIVO  ".  
        IF trim(Almcmov.FlgEst) = "P" THEN assign X-Flgest = " PENDIENTE ".  
    END.            

    IF FIRST-OF(Almcmov.CodMov) THEN x-CuentaReg = 0.
    
    FIND gn-prov WHERE
        gn-prov.CodCia = Almtdocm.CodCia AND
        gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
    ELSE DO:
        FIND gn-prov WHERE
            gn-prov.CodCia = pv-codcia AND
            gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
    END.

    IF c-CodMov = "02" THEN DO:        
        x-ImpMn1 = 0.
        x-NroDoc = "".
        x-FchDoc = ?.
        x-NroAst = "NO HAY".
        x-CodOpe = "".
        IF MONTH(Almcmov.FchDoc) = 1 THEN x-periodo = YEAR(Almcmov.FchDoc) - 1.
        ELSE x-periodo = YEAR(Almcmov.FchDoc).

        cbloop:
        FOR EACH cb-dmov WHERE
            cb-dmov.codcia = Almcmov.CodCia AND
            cb-dmov.periodo >= x-periodo AND
            cb-dmov.CodCta BEGINS "6" AND
            cb-dmov.CodAux = Almcmov.Codpro AND
            cb-dmov.CodDoc = "01" AND
            (cb-dmov.CodOpe = "060" OR
             cb-dmov.CodOpe = "076") AND
            cb-dmov.nromes >= 1 NO-LOCK:
            IF INTEGER(cb-dmov.OrdCmp) = INTEGER(Almcmov.Nrorf1) THEN DO:
                x-ImpMn1 = cb-dmov.ImpMn1.
                x-NroDoc = cb-dmov.Nrodoc.
                x-FchDoc = cb-dmov.FchDoc.
                x-NroAst = cb-dmov.NroAst.
                x-CodOpe = cb-dmov.CodOpe.

                t-column = t-column + 1.
                cColumn = STRING(t-Column).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = Almcmov.Nrodoc.
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = Almcmov.AlmDes.
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = Almcmov.FchDoc.
                cRange = "D" + cColumn.                                                
                chWorkSheet:Range(cRange):Value = Almcmov.Nrorf1.                      
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = Almcmov.NroRf3. 
                cRange = "F" + cColumn.                                                
                chWorkSheet:Range(cRange):Value = Almcmov.Codpro. 
                cRange = "G" + cColumn.                                                
                chWorkSheet:Range(cRange):Value = X-despro.
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = Almcmov.Usuario.
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = x-flgest.
                cRange = "J" + cColumn.                                                
                chWorkSheet:Range(cRange):Value = x-CodOpe. 
                cRange = "K" + cColumn.                                                
                chWorkSheet:Range(cRange):Value = x-NroAst.
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Value = x-NroDoc.
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = x-FchDoc.
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Value = x-ImpMn1.
            END.        
        END. /*For....*/
        IF x-CodOpe = "" THEN DO:        
            t-column = t-column + 1.
            cColumn = STRING(t-Column).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = Almcmov.Nrodoc.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = Almcmov.AlmDes.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = Almcmov.FchDoc.
            cRange = "D" + cColumn.                                                
            chWorkSheet:Range(cRange):Value = Almcmov.Nrorf1.                      
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = Almcmov.NroRf3. 
            cRange = "F" + cColumn.                                                
            chWorkSheet:Range(cRange):Value = Almcmov.Codpro. 
            cRange = "G" + cColumn.                                                
            chWorkSheet:Range(cRange):Value = X-despro.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = Almcmov.Usuario.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = x-flgest. 
        END.
    END.
    ELSE DO:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.Nrodoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.AlmDes.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.FchDoc.
        cRange = "D" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = Almcmov.Nrorf1.                      
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.NroRf3. 
        cRange = "F" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = Almcmov.Codpro. 
        cRange = "G" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = X-despro.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = Almcmov.Usuario.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = x-flgest.
    END.

    /*Busca Orden de Compra*/
    FIND FIRST lg-cocmp WHERE lg-cocmp.codcia = s-codcia
        AND lg-cocmp.nrodoc = INT(TRIM(Almcmov.Nrorf1)) NO-LOCK NO-ERROR.
    IF AVAIL lg-cocmp THEN DO:
        cRange = "V" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = LG-COCmp.Observaciones.
        cRange = "W" + cColumn.
        FIND gn-concp WHERE gn-concp.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
        IF AVAILABLE gn-concp THEN 
            chWorkSheet:Range(cRange):Value = LG-COCmp.CndCmp + "-" + gn-concp.Nombr.
        ELSE chWorkSheet:Range(cRange):Value = LG-COCmp.CndCmp.
    END.

    T-Impcto = 0.
    X-Cospro = 0.
    F-Candes = 0.
    S-Impcto = 0.
    D-Impcto = 0.
    FOR EACH Almdmov WHERE
        Almdmov.CodCia = Almcmov.CodCia AND
        Almdmov.CodAlm = Almcmov.CodAlm AND
        Almdmov.TipMov = Almcmov.TipMov AND
        Almdmov.CodMov = Almcmov.CodMov AND
        Almdmov.NroDoc = Almcmov.NroDoc AND
        (Almdmov.CodMat >= DesdeC AND Almdmov.cODmAT <= HastaC)
        BREAK BY Almdmov.NroDoc:
        FIND Almmmatg WHERE
            Almmmatg.CodCia = Almdmov.CodCia AND
            Almmmatg.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
        ASSIGN 
            X-Desmat = ""
            X-Desmar = "".
        IF AVAILABLE Almmmatg THEN 
            ASSIGN
                X-desmat = Almmmatg.DesMat
                X-Desmar = Almmmatg.Desmar.

        /*********************************/
        x-cospro = almdmov.preuni.
        IF T-igv THEN X-Cospro = x-cospro * ( 1 + Almdmov.Igvmat / 100).
        /*********************************/
        X-Impcto = X-Cospro * Almdmov.CanDes.
        T-Impcto = T-Impcto + X-Impcto.
        x-CuentaReg = x-CuentaReg + 1.

        S-Impcto = S-Impcto + IF Almcmov.Codmon = 01 THEN X-Impcto ELSE X-Impcto * Almcmov.Tpocmb.
        D-Impcto = D-Impcto + IF Almcmov.Codmon = 02 THEN X-Impcto ELSE X-Impcto / Almcmov.Tpocmb.

        F-Candes = F-Candes + (Almdmov.CanDes * Almdmov.Factor).

        ACCUMULATE X-ImpCto (TOTAL BY Almdmov.NroDoc).

        DISPLAY
            Almdmov.codmat @ Fi-Mensaje LABEL "Código de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = Almdmov.codmat.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = X-DesMat.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = X-DesMar.
        cRange = "R" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = Almdmov.CodUnd.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = (Almdmov.CanDes * Almdmov.Factor).
        cRange = "T" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = X-Cospro.
        cRange = "U" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = X-ImpCto.

        PAUSE 0.
    END.   
    PAUSE 0.
END.

HIDE FRAME F-PROCESO.
MESSAGE
    "Proceso Terminado con suceso"
    VIEW-AS ALERT-BOX INFORMA.

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
  DEFINE VAR F-ImpCto AS DECIMAL NO-UNDO.
  DEFINE VAR F-Candes AS DECIMAL NO-UNDO.
  DEFINE VAR X-despro AS CHARACTER NO-UNDO.
  
  
  DEFINE FRAME F-REP
         Almcmov.NroDoc COLUMN-LABEL "Numero!Docmto"
         Almcmov.FchDoc COLUMN-LABEL "Fecha de!Documento " FORMAT "99/99/9999"
         Almcmov.NroRf1 COLUMN-LABEL "Referencia"
         Almcmov.NroRf2 COLUMN-LABEL "Referencia"
         Almcmov.CodPro COLUMN-LABEL "Cod.Prov"  
         X-despro FORMAT "X(20)"
         Almdmov.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "X(9)"
         Almmmatg.DesMat FORMAT "X(40)"
         Almmmatg.DesMar FORMAT "X(16)"
         Almdmov.CodUnd COLUMN-LABEL "Cod.!Unid" FORMAT "X(7)"
         Almdmov.CanDes FORMAT "(>>>,>>9.99)" 
         Almdmov.PreUni FORMAT "(>>>,>>9.99)"
         Almdmov.ImpCto FORMAT "(>,>>>,>>9.99)"
  WITH WIDTH 255 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.
  
  DEFINE FRAME F-HEADER
     HEADER
         S-NOMCIA     "DOCUMENTOS EMITIDOS POR MOVIMIMIENTO" AT 56  
         "Pagina  :" AT 153 PAGE-NUMBER(REPORT) AT 166 FORMAT "ZZZZZ9" SKIP
         "Fecha   :" AT 153 Almcmov.FchDoc AT 166 FORMAT "99/99/9999" SKIP
         "Hora    :" AT 153 STRING(TIME,"HH:MM:SS") AT 166 SKIP(1)
         "Documentos Emitidos del:" DocIni AT 26 "al:" AT 34 DocFin AT 37 
         "Periodo del:" AT 117 DesdeF AT 129 "al:" AT 140 HastaF AT 145 SKIP 
"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
"NUMERO FECHA DE                                                       CODIGO                                                            COD.                     PRECIO                " SKIP
"DOCMTO DOCUMENTO  REFERENCIA REFERENCIA COD.PROV NOMBRE DEL PROVEEDOR ARTICULO  DESCRIPCION                              MARCA          UNID      CANTIDAD     UNITARIO        IMPORTE " SKIP
"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP(1)
  WITH PAGE-TOP WIDTH 255 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                    AND  Almcmov.CodAlm  = S-CODALM 
                    AND  Almcmov.TipMov  = C-TipMov 
                    AND  STRING(Almcmov.CodMov,"99") BEGINS C-CodMov 
                    AND  (Almcmov.NroDoc >= DocIni   
                    AND   Almcmov.NroDoc <= DocFin)
                    AND  (Almcmov.FchDoc >= DesdeF   
                    AND   Almcmov.FchDoc <= HastaF)
                    AND  (Almcmov.CodPro >= F-provee1
                    AND   Almcmov.CodPro <= F-provee2)
                   BREAK BY Almcmov.CodMov:
      VIEW STREAM REPORT FRAME F-HEADER.

      IF FIRST-OF(Almcmov.CodMov) THEN DO:
         FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                        AND  Almtmovm.Tipmov = Almcmov.TipMov 
                        AND  Almtmovm.Codmov = Almcmov.CodMov 
                       NO-LOCK NO-ERROR.
         PUT STREAM REPORT Almcmov.CodMov " - " Almtmovm.Desmov SKIP.
         DOWN STREAM report 1 WITH FRAME F-REP.
      END.

      FIND gn-prov WHERE gn-prov.CodCia = Almtdocm.CodCia 
                    AND  gn-prov.CodPro = Almcmov.CodPro 
                    NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
      ELSE DO:
           FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                         AND  gn-prov.CodPro = Almcmov.CodPro 
                        NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
      END.

      DISPLAY STREAM REPORT 
              Almcmov.NroDoc 
              Almcmov.FchDoc
              Almcmov.NroRf1 
              Almcmov.NroRf2
              Almcmov.CodPro
              X-despro 
              WITH FRAME F-REP.
/*      DOWN STREAM report 1 WITH FRAME F-REP.*/
      F-Impcto = 0.
      F-Candes = 0.
      FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                        AND  Almdmov.CodAlm = Almcmov.CodAlm 
                        AND  Almdmov.TipMov = Almcmov.TipMov 
                        AND  Almdmov.CodMov = Almcmov.CodMov 
                        AND  Almdmov.NroDoc = Almcmov.NroDoc 
                        AND  (Almdmov.CodMat >= DesdeC
                        AND   Almdmov.cODmAT <= HastaC)
                       BREAK BY Almdmov.NroDoc:
          F-Impcto = F-Impcto + Almdmov.ImpCto.
          F-Candes = F-Candes + (Almdmov.CanDes * Almdmov.Factor).
          ACCUMULATE Almdmov.ImpCto (TOTAL BY Almdmov.NroDoc).
          FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                         AND  Almmmatg.codmat = Almdmov.codmat 
                        NO-LOCK NO-ERROR.

          DISPLAY Almdmov.codmat @ Fi-Mensaje LABEL "Codigo de Articulo "
                  FORMAT "X(8)" WITH FRAME F-Proceso.

          DISPLAY STREAM REPORT 
                  Almdmov.codmat 
                  Almmmatg.DesMat
                  Almmmatg.DesMar
                  Almdmov.CodUnd 
                  (Almdmov.CanDes * Almdmov.Factor) @ Almdmov.CanDes
                  (Almdmov.PreUni / Almdmov.Factor) @ Almdmov.PreUni 
                  Almdmov.ImpCto WHEN Almdmov.ImpCto > 0 
                  WITH FRAME F-REP.
          DOWN STREAM report 1 WITH FRAME F-REP.
          IF LAST-OF(Almdmov.NroDoc) THEN DO:
             UNDERLINE STREAM report 
                       Almmmatg.DesMat
                       Almdmov.ImpCto  
                       WITH FRAME F-REP.
             DISPLAY STREAM REPORT 
                     "TOTAL DOCUMENTO" @ Almmmatg.DesMat
                     ACCUM TOTAL BY Almdmov.NroDoc Almdmov.ImpCto @ Almdmov.ImpCto 
                     WITH FRAME F-REP.
             DOWN STREAM report 1 WITH FRAME F-REP.
          END.
      END.
      ACCUMULATE F-ImpCto (TOTAL BY Almcmov.Codmov).
      ACCUMULATE F-Candes (TOTAL BY Almcmov.Codmov).
      IF LAST-OF(Almcmov.CodMov) THEN DO:
         UNDERLINE STREAM report 
                   Almmmatg.DesMat
                   Almdmov.Candes
                   Almdmov.ImpCto  
                   WITH FRAME F-REP.
         DISPLAY STREAM REPORT 
                 "TOTAL MOVIMIENTO" @ Almmmatg.DesMat
                 ACCUM TOTAL BY Almcmov.Codmov F-Candes @ Almdmov.Candes
                 ACCUM TOTAL BY Almcmov.CodMov F-ImpCto @ Almdmov.ImpCto WITH FRAME F-REP.
         DOWN STREAM report 1 WITH FRAME F-REP.
      END.
  END.

  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------".
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE x-CuentaReg AS INTE INIT 0 NO-UNDO.
  DEFINE VARIABLE x-ImpMn1 LIKE cb-dmov.ImpMn1 NO-UNDO.
  DEFINE VARIABLE x-NroDoc LIKE cb-dmov.NroDoc NO-UNDO.
  DEFINE VARIABLE x-FchDoc LIKE cb-dmov.FchDoc NO-UNDO.
  DEFINE VARIABLE x-NroAst LIKE cb-dmov.NroAst NO-UNDO.
  DEFINE VARIABLE x-CodOpe LIKE cb-dmov.CodOpe NO-UNDO.
  DEFINE VARIABLE x-periodo LIKE cb-dmov.periodo NO-UNDO.
  
  DEFINE FRAME FC-REP
         Almcmov.Nrodoc
         Almcmov.AlmDes
         Almcmov.FchDoc FORMAT "99/99/99"
         Almcmov.Nrorf1
         Almcmov.NroRf3
         Almcmov.Codpro
         X-despro       FORMAT "X(30)"
         Almcmov.Usuario
         x-flgest       FORMAT 'X(10)'
         x-CodOpe
         x-NroAst
         x-NroDoc
         x-FchDoc       FORMAT "99/99/99"
         x-ImpMn1
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME FD-REP
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         X-Desmat        AT 28 FORMAT "X(40)"
         X-Desmar        AT 75 FORMAT "X(10)"
         Almdmov.CodUnd  AT 90 FORMAT 'x(7)'
         Almdmov.CanDes FORMAT "(>>>,>>9.99)" 
         X-Cospro       FORMAT "(>>,>>9.9999)"
         X-ImpCto       FORMAT "(>,>>>,>>9.99)"
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  DEFINE FRAME F-HEADER
     HEADER        
        S-NOMCIA  FORMAT "X(35)" SKIP
        "( " + S-CODALM + ")"  FORMAT "X(15)"
        "DOCUMENTOS EMITIDOS POR MOVIMIMIENTO VALORIZADO " AT 45 SKIP
         IF T-igv THEN "(Pecios Incluyen IGV)" ELSE "(Precios No Incluyen IGV)" FORMAT "X(50)" AT 50  
        "Pagina  :" AT 130 PAGE-NUMBER(REPORT) AT 146 FORMAT "ZZZZZ9" SKIP
        "Fecha   :" AT 130 Almcmov.FchDoc AT 146 FORMAT "99/99/9999" SKIP
        "Hora    :" AT 130 STRING(TIME,"HH:MM:SS") AT 146 SKIP(1)
        "Documentos Emitidos del:" DocIni AT 26 "al:" AT 34 DocFin AT 37 
        "Periodo del:" AT 117 DesdeF AT 129 "al:" AT 140 HastaF AT 145 SKIP            
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Docmto     Fecha          Referencia        Proveedor                                  Usuario     Estado  Ope Asto   Nro Doc    Fecha          Importe S/." SKIP
        "                                                                                                                                           " SKIP
        "           Articulo        Descripcion                                        Marca       Unid.         Cantidad       Precio    Importe   " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                    AND  Almcmov.CodAlm  = S-CODALM 
                    AND  Almcmov.TipMov  = C-TipMov 
                    AND  STRING(Almcmov.CodMov,"99") BEGINS C-CodMov 
                    AND  (Almcmov.NroDoc >= DocIni   
                    AND   Almcmov.NroDoc <= DocFin)
                    AND  (Almcmov.FchDoc >= DesdeF   
                    AND   Almcmov.FchDoc <= HastaF)
                    AND  (Almcmov.CodPro >= F-provee1
                    AND   Almcmov.CodPro <= F-provee2)
                   BREAK BY Almcmov.CodMov:
        VIEW STREAM REPORT FRAME F-HEADER.

        x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO".          
        IF Almcmov.TipMov = 'S' THEN DO :
          IF trim(Almcmov.FlgEst) = "A" THEN assign X-Flgest = "ANULADO".
          IF trim(Almcmov.FlgEst) ne "A" and Almcmov.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
          IF trim(Almcmov.FlgEst) ne "A" and Almcmov.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
        END.
        IF Almcmov.TipMov = 'I' THEN DO :   
          IF trim(Almcmov.FlgEst) = "A" THEN assign X-Flgest = "  ANULADO  ".  
          IF trim(Almcmov.FlgEst) = ""  THEN assign X-Flgest = "   ACTIVO  ".  
          IF trim(Almcmov.FlgEst) = "C" THEN assign X-Flgest = "   ACTIVO  ".  
          IF trim(Almcmov.FlgEst) = "P" THEN assign X-Flgest = " PENDIENTE ".  
        END.            

        IF FIRST-OF(Almcmov.CodMov) THEN DO:
           FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                          AND  Almtmovm.Tipmov = Almcmov.TipMov 
                          AND  Almtmovm.Codmov = Almcmov.CodMov 
                         NO-LOCK NO-ERROR.
           PUT STREAM REPORT Almcmov.CodMov " - " Almtmovm.Desmov SKIP(2).
            x-CuentaReg = 0.    /* INICIALIZA CONTADOR */
        END.

        FIND gn-prov WHERE gn-prov.CodCia = Almtdocm.CodCia 
                      AND  gn-prov.CodPro = Almcmov.CodPro 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        ELSE DO:
           FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                         AND  gn-prov.CodPro = Almcmov.CodPro 
                        NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        END.

        IF c-CodMov = "02" THEN DO:
            x-ImpMn1 = 0.
            x-NroDoc = "".
            x-FchDoc = ?.
            x-NroAst = "NO HAY".
            x-CodOpe = "".
            IF MONTH(Almcmov.FchDoc) = 1 THEN
                x-periodo = YEAR(Almcmov.FchDoc) - 1.
            ELSE
                x-periodo = YEAR(Almcmov.FchDoc).
            cbloop:
            FOR EACH cb-dmov WHERE
                cb-dmov.codcia = Almcmov.CodCia AND
                cb-dmov.periodo >= x-periodo AND
                cb-dmov.CodCta BEGINS "6" AND
                cb-dmov.CodAux = Almcmov.Codpro AND
                cb-dmov.CodDoc = "01" AND
                (cb-dmov.CodOpe = "060" OR
                cb-dmov.CodOpe = "076") AND
                cb-dmov.nromes >= 1 NO-LOCK:
                IF INTEGER(cb-dmov.OrdCmp) = INTEGER(Almcmov.Nrorf1) THEN DO:
                    x-ImpMn1 = cb-dmov.ImpMn1.
                    x-NroDoc = cb-dmov.Nrodoc.
                    x-FchDoc = cb-dmov.FchDoc.
                    x-NroAst = cb-dmov.NroAst.
                    x-CodOpe = cb-dmov.CodOpe.
                    PUT STREAM REPORT 
                        Almcmov.Nrodoc " "
                        Almcmov.AlmDes " "
                        Almcmov.FchDoc " "
                        Almcmov.Nrorf1 " "
                        Almcmov.NroRf3 " "
                        Almcmov.Codpro " "
                        X-despro FORMAT "X(30)" " "
                        Almcmov.Usuario " "
                        x-flgest FORMAT "X(10)" " "
                        x-CodOpe " "
                        x-NroAst " "
                        x-NroDoc " "
                        x-FchDoc " "
                        x-ImpMn1 SKIP.
                END.
            END.
            IF x-CodOpe = "" THEN
                PUT STREAM REPORT
                    Almcmov.Nrodoc " "
                    Almcmov.AlmDes " "
                    Almcmov.FchDoc " "
                    Almcmov.Nrorf1 " "
                    Almcmov.NroRf3 " "
                    Almcmov.Codpro " "
                    X-despro FORMAT "X(30)" " "
                    Almcmov.Usuario " "
                    x-flgest FORMAT "X(10)" SKIP.
        END.
        ELSE
            PUT STREAM REPORT 
                Almcmov.Nrodoc " "
                Almcmov.AlmDes " "
                Almcmov.FchDoc " "
                Almcmov.Nrorf1 " "
                Almcmov.NroRf3 " "
                Almcmov.Codpro " "
                X-despro FORMAT "X(30)" " "
                Almcmov.Usuario " "
                x-flgest FORMAT "X(10)"
                SKIP.

       T-Impcto = 0.
       X-Cospro = 0.
       F-Candes = 0.
       S-Impcto = 0.
       D-Impcto = 0.
       FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                        AND  Almdmov.CodAlm = Almcmov.CodAlm 
                        AND  Almdmov.TipMov = Almcmov.TipMov 
                        AND  Almdmov.CodMov = Almcmov.CodMov 
                        AND  Almdmov.NroDoc = Almcmov.NroDoc 
                        AND  (Almdmov.CodMat >= DesdeC
                        AND   Almdmov.cODmAT <= HastaC)
                       BREAK BY Almdmov.NroDoc:

          FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                         AND  Almmmatg.codmat = Almdmov.codmat 
                        NO-LOCK NO-ERROR.
          
          ASSIGN 
             X-Desmat = ""
             X-Desmar = "".
          IF AVAILABLE Almmmatg THEN 
          ASSIGN
             X-desmat = Almmmatg.DesMat
             X-Desmar = Almmmatg.Desmar .
             
          /*********************************/
          x-cospro = almdmov.preuni.
          IF T-igv THEN X-Cospro = x-cospro * ( 1 + Almdmov.Igvmat / 100).
          /*********************************/
          X-Impcto = X-Cospro * Almdmov.CanDes.
          T-Impcto = T-Impcto + X-Impcto.
          x-CuentaReg = x-CuentaReg + 1.
          
          S-Impcto = S-Impcto + IF Almcmov.Codmon = 01 THEN X-Impcto ELSE X-Impcto * Almcmov.Tpocmb.
          D-Impcto = D-Impcto + IF Almcmov.Codmon = 02 THEN X-Impcto ELSE X-Impcto / Almcmov.Tpocmb.

          F-Candes = F-Candes + (Almdmov.CanDes * Almdmov.Factor).

          ACCUMULATE X-ImpCto (TOTAL BY Almdmov.NroDoc).
          
          DISPLAY Almdmov.codmat @ Fi-Mensaje LABEL "Codigo de Articulo "
                  FORMAT "X(8)" WITH FRAME F-Proceso.

          DISPLAY STREAM REPORT 
                  Almdmov.codmat 
                  X-DesMat
                  X-DesMar
                  Almdmov.CodUnd 
                  (Almdmov.CanDes * Almdmov.Factor) @ Almdmov.CanDes
                  X-Cospro                        
                  X-Impcto   WHEN X-Impcto > 0    
                  WITH FRAME FD-REP.
                  
          IF LAST-OF(Almdmov.NroDoc) THEN DO:
             UNDERLINE STREAM report 
                       X-DesMat
                       Almdmov.CodUnd
                       Almdmov.Candes
                       X-Impcto  
                       WITH FRAME FD-REP.
             DISPLAY STREAM REPORT 
                     "TOTAL DOCUMENTO" @ X-Desmat
                     if Almcmov.Codmon = 01 then "S/." Else "US$/." @ Almdmov.CodUnd
                     "        T/C :"   @ Almdmov.Candes
                     Almcmov.Tpocmb    @ X-Cospro
                     T-Impcto          @ X-Impcto 
                     WITH FRAME FD-REP.
             DOWN STREAM report 1 WITH FRAME FD-REP.
             T-Impcto = 0.         
          END.
      END.
      ACCUMULATE S-ImpCto (TOTAL BY Almcmov.Codmov).
      ACCUMULATE D-ImpCto (TOTAL BY Almcmov.Codmov).

      IF LAST-OF(Almcmov.CodMov) THEN DO:
         PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------" SKIP.
         PUT STREAM REPORT "TOTAL REGISTROS " AT 5 x-CuentaReg FORMAT ">>>,>>9" AT 70 SKIP.
         PUT STREAM REPORT "TOTAL MOVIMIENTO NUEVOS SOLES " FORMAT "X(50)"  AT 5.
         PUT STREAM REPORT ACCUM TOTAL BY Almcmov.Codmov S-Impcto  AT 70 SKIP.
         PUT STREAM REPORT "TOTAL MOVIMIENTO DOLARES AMERICANOS" FORMAT "X(50)" AT 5.
         PUT STREAM REPORT ACCUM TOTAL BY Almcmov.Codmov D-Impcto AT 70 SKIP.
         PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------" SKIP.
         D-Impcto = 0.
         S-Impcto = 0.
      END.

  END.

  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------".
  HIDE FRAME F-PROCESO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE x-CuentaReg AS INTE INIT 0 NO-UNDO.
  DEFINE VARIABLE x-ImpMn1 LIKE cb-dmov.ImpMn1 NO-UNDO.
  DEFINE VARIABLE x-NroDoc LIKE cb-dmov.NroDoc NO-UNDO.
  DEFINE VARIABLE x-FchDoc LIKE cb-dmov.FchDoc NO-UNDO.
  DEFINE VARIABLE x-NroAst LIKE cb-dmov.NroAst NO-UNDO.
  DEFINE VARIABLE x-CodOpe LIKE cb-dmov.CodOpe NO-UNDO.
  DEFINE VARIABLE x-periodo LIKE cb-dmov.periodo NO-UNDO.

  DEFINE FRAME FC-REP
         Almcmov.Nrodoc
         Almcmov.AlmDes
         Almcmov.FchDoc FORMAT "99/99/99"
         Almcmov.Nrorf1
         Almcmov.NroRf3
         Almcmov.Codpro
         X-despro       FORMAT "X(30)"
         Almcmov.Usuario
         x-flgest       FORMAT 'X(10)'
         x-CodOpe
         x-NroAst
         x-NroDoc
         x-FchDoc       FORMAT "99/99/99"
         x-ImpMn1
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME FD-REP
         Almdmov.codmat  AT 16 FORMAT "X(8)"
         X-Desmat        AT 28 FORMAT "X(40)"
         X-Desmar        AT 75 FORMAT "X(10)"
         Almdmov.CodUnd  AT 90 FORMAT 'x(7)'
         Almdmov.CanDes FORMAT "(>>>,>>9.99)" 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 


  DEFINE FRAME F-HEADER
     HEADER        
        S-NOMCIA  FORMAT "X(35)" SKIP
        "( " + S-CODALM + ")"  FORMAT "X(15)"
        "DOCUMENTOS EMITIDOS POR MOVIMIMIENTO " AT 45 SKIP
        "Pagina  :" AT 130 PAGE-NUMBER(REPORT) AT 146 FORMAT "ZZZZZ9" SKIP
        "Fecha   :" AT 130 Almcmov.FchDoc AT 146 FORMAT "99/99/9999" SKIP
        "Hora    :" AT 130 STRING(TIME,"HH:MM:SS") AT 146 SKIP(1)
        "Documentos Emitidos del:" DocIni AT 26 "al:" AT 34 DocFin AT 37 
        "Periodo del:" AT 117 DesdeF AT 129 "al:" AT 140 HastaF AT 145 SKIP            
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Docmto     Fecha          Referencia        Proveedor                                  Usuario     Estado  Ope Asto   Nro Doc    Fecha          Importe S/." SKIP
        "                                                                                                                                           " SKIP
        "           Articulo        Descripcion                                        Marca       Unid.         Cantidad       Precio    Importe   " SKIP
        "-----------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Almcmov WHERE Almcmov.CodCia  = S-CODCIA 
                    AND  Almcmov.CodAlm  = S-CODALM 
                    AND  Almcmov.TipMov  = C-TipMov 
                    AND  STRING(Almcmov.CodMov,"99") BEGINS C-CodMov 
                    AND  (Almcmov.NroDoc >= DocIni   
                    AND   Almcmov.NroDoc <= DocFin)
                    AND  (Almcmov.FchDoc >= DesdeF   
                    AND   Almcmov.FchDoc <= HastaF)
                    AND  (Almcmov.CodPro >= F-provee1
                    AND   Almcmov.CodPro <= F-provee2)
                   BREAK BY Almcmov.CodMov:
        VIEW STREAM REPORT FRAME F-HEADER.

        x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO".          
        IF Almcmov.TipMov = 'S' THEN DO :
          IF trim(Almcmov.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
          IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
          IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
        END.
        IF Almcmov.TipMov = 'I' THEN DO :   
          IF trim(Almcmov.FlgEst) = "A" THEN assign X-Flgest = "  ANULADO  ".  
          IF trim(Almcmov.FlgEst) = ""  THEN assign X-Flgest = "   ACTIVO  ".  
          IF trim(Almcmov.FlgEst) = "C" THEN assign X-Flgest = "   ACTIVO  ".  
          IF trim(Almcmov.FlgEst) = "P" THEN assign X-Flgest = " PENDIENTE ".  
        END.            

        IF FIRST-OF(Almcmov.CodMov) THEN DO:
           FIND Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
                          AND  Almtmovm.Tipmov = Almcmov.TipMov 
                          AND  Almtmovm.Codmov = Almcmov.CodMov 
                         NO-LOCK NO-ERROR.
           PUT STREAM REPORT Almcmov.CodMov " - " Almtmovm.Desmov SKIP.
           DOWN STREAM report 1 WITH FRAME F-REP.
           x-CuentaReg = 0.
        END.

        FIND gn-prov WHERE gn-prov.CodCia = Almtdocm.CodCia 
                      AND  gn-prov.CodPro = Almcmov.CodPro 
                      NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        ELSE DO:
           FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
                         AND  gn-prov.CodPro = Almcmov.CodPro 
                        NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        END.
        IF c-CodMov = "02" THEN DO:
            x-ImpMn1 = 0.
            x-NroDoc = "".
            x-FchDoc = ?.
            x-NroAst = "NO HAY".
            x-CodOpe = "".
            IF MONTH(Almcmov.FchDoc) = 1 THEN
                x-periodo = YEAR(Almcmov.FchDoc) - 1.
            ELSE
                x-periodo = YEAR(Almcmov.FchDoc).
            cbloop:
            FOR EACH cb-dmov WHERE
                cb-dmov.codcia = Almcmov.CodCia AND
                cb-dmov.periodo >= x-periodo AND
                cb-dmov.CodCta BEGINS "6" AND
                cb-dmov.CodAux = Almcmov.Codpro AND
                cb-dmov.CodDoc = "01" AND
                (cb-dmov.CodOpe = "060" OR
                cb-dmov.CodOpe = "076") AND
                cb-dmov.nromes >= 1 NO-LOCK:
                IF INTEGER(cb-dmov.OrdCmp) = INTEGER(Almcmov.Nrorf1) THEN DO:
                    x-ImpMn1 = cb-dmov.ImpMn1.
                    x-NroDoc = cb-dmov.Nrodoc.
                    x-FchDoc = cb-dmov.FchDoc.
                    x-NroAst = cb-dmov.NroAst.
                    x-CodOpe = cb-dmov.CodOpe.
                    PUT STREAM REPORT 
                        Almcmov.Nrodoc " "
                        Almcmov.AlmDes " "
                        Almcmov.FchDoc " "
                        Almcmov.Nrorf1 " "
                        Almcmov.NroRf3 " "
                        Almcmov.Codpro " "
                        X-despro FORMAT "X(30)" " "
                        Almcmov.Usuario " "
                        x-flgest FORMAT "X(10)" " "
                        x-CodOpe " "
                        x-NroAst " "
                        x-NroDoc " "
                        x-FchDoc " "
                        x-ImpMn1 SKIP.
                END.
            END.
            IF x-CodOpe = "" THEN
                PUT STREAM REPORT
                    Almcmov.Nrodoc " "
                    Almcmov.AlmDes " "
                    Almcmov.FchDoc " "
                    Almcmov.Nrorf1 " "
                    Almcmov.NroRf3 " "
                    Almcmov.Codpro " "
                    X-despro FORMAT "X(30)" " "
                    Almcmov.Usuario " "
                    x-flgest FORMAT "X(10)" SKIP.
        END.
        ELSE
            PUT STREAM REPORT 
                Almcmov.Nrodoc " "
                Almcmov.AlmDes " "
                Almcmov.FchDoc " "
                Almcmov.Nrorf1 " "
                Almcmov.NroRf3 " "
                Almcmov.Codpro " "
                X-despro FORMAT "X(30)" " "
                Almcmov.Usuario " "
                x-flgest FORMAT "X(10)"
                SKIP.
 
       T-Impcto = 0.
       X-Cospro = 0.
       F-Candes = 0.
       S-Impcto = 0.
       D-Impcto = 0.
       FOR EACH Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                        AND  Almdmov.CodAlm = Almcmov.CodAlm 
                        AND  Almdmov.TipMov = Almcmov.TipMov 
                        AND  Almdmov.CodMov = Almcmov.CodMov 
                        AND  Almdmov.NroDoc = Almcmov.NroDoc 
                        AND  (Almdmov.CodMat >= DesdeC
                        AND   Almdmov.cODmAT <= HastaC)
                       BREAK BY Almdmov.NroDoc:

          FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                         AND  Almmmatg.codmat = Almdmov.codmat 
                        NO-LOCK NO-ERROR.
          
          ASSIGN 
             X-Desmat = ""
             X-Desmar = "".
          IF AVAILABLE Almmmatg THEN 
          ASSIGN
             X-desmat = Almmmatg.DesMat
             X-Desmar = Almmmatg.Desmar .
             
          /*********************************/
          x-cospro = almdmov.preuni.
          IF T-igv THEN X-Cospro = x-cospro * ( 1 + Almdmov.Igvmat / 100).
          /*********************************/
          X-Impcto = X-Cospro * Almdmov.CanDes.
          T-Impcto = T-Impcto + X-Impcto.
          x-CuentaReg = x-CuentaReg + 1.
          
          S-Impcto = S-Impcto + IF Almcmov.Codmon = 01 THEN X-Impcto ELSE X-Impcto * Almcmov.Tpocmb.
          D-Impcto = D-Impcto + IF Almcmov.Codmon = 02 THEN X-Impcto ELSE X-Impcto / Almcmov.Tpocmb.

          F-Candes = F-Candes + (Almdmov.CanDes * Almdmov.Factor).

          ACCUMULATE X-ImpCto (TOTAL BY Almdmov.NroDoc).
          
          DISPLAY Almdmov.codmat @ Fi-Mensaje LABEL "Codigo de Articulo "
                  FORMAT "X(8)" WITH FRAME F-Proceso.

          DISPLAY STREAM REPORT 
                  Almdmov.codmat 
                  X-DesMat
                  X-DesMar
                  Almdmov.CodUnd 
                  (Almdmov.CanDes * Almdmov.Factor) @ Almdmov.CanDes
                  WITH FRAME FD-REP.
                  
      END.
    IF LAST-OF(Almcmov.CodMov) THEN DO:
        PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------" SKIP.
        PUT STREAM REPORT "TOTAL REGISTROS " AT 5 x-CuentaReg FORMAT ">>>,>>9" AT 70 SKIP.
        PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------" SKIP.
    END.
  END.

  PUT STREAM REPORT "------------------------------------------------------------------------------------------------------------------------------".
  HIDE FRAME F-PROCESO.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-TXT W-Win 
PROCEDURE Genera-TXT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_file AS CHARACTER.

    DEFINE VARIABLE x-CuentaReg AS INTE INIT 0 NO-UNDO.
    DEFINE VARIABLE x-ImpMn1 LIKE cb-dmov.ImpMn1 NO-UNDO.
    DEFINE VARIABLE x-NroDoc LIKE cb-dmov.NroDoc NO-UNDO.
    DEFINE VARIABLE x-FchDoc LIKE cb-dmov.FchDoc NO-UNDO.
    DEFINE VARIABLE x-NroAst LIKE cb-dmov.NroAst NO-UNDO.
    DEFINE VARIABLE x-CodOpe LIKE cb-dmov.CodOpe NO-UNDO.
    DEFINE VARIABLE x-periodo LIKE cb-dmov.periodo NO-UNDO.

    OUTPUT STREAM report TO VALUE(para_file).

    PUT STREAM REPORT
        "Documento|"
        "Alm Dest|"
        "Fecha|"
        "Referencia|"
        "Referencia|"
        "Proveedor|"
        "Nombre Razón Social|"
        "Usuario|"
        "Estado|"
        "Ope|"
        "Asto|"
        "Nro Doc|"
        "Fecha|"
        "Importe S/.|"
        "Artículo|"
        "Descripción|"
        "Marca|"
        "Unid|"
        "Cantidad|"
        "Precio|"
        "Importe|"
        SKIP.

    FOR EACH Almcmov WHERE
        Almcmov.CodCia  = S-CODCIA AND
        Almcmov.CodAlm  = S-CODALM AND
        Almcmov.TipMov  = C-TipMov AND
        STRING(Almcmov.CodMov,"99") BEGINS C-CodMov AND
        (Almcmov.NroDoc >= DocIni AND Almcmov.NroDoc <= DocFin) AND
        (Almcmov.FchDoc >= DesdeF AND Almcmov.FchDoc <= HastaF) AND
        (Almcmov.CodPro >= F-provee1 AND Almcmov.CodPro <= F-provee2)
        BREAK BY Almcmov.CodMov:
        x-flgest = IF Almcmov.flgest = 'A' THEN "ANULADO" ELSE "ACTIVO".          
        IF Almcmov.TipMov = 'S' THEN DO :
            IF trim(Almcmov.FlgEst)  = "A" THEN assign X-Flgest = "ANULADO".
            IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "T" THEN assign X-Flgest = "TRANSFERID".
            IF trim(Almcmov.FlgEst)  ne "A" and Almcmov.FlgSit  = "R" THEN assign X-Flgest = "RECEPCIONA".
        END.
        IF Almcmov.TipMov = 'I' THEN DO :   
            IF trim(Almcmov.FlgEst) = "A" THEN assign X-Flgest = "  ANULADO  ".  
            IF trim(Almcmov.FlgEst) = ""  THEN assign X-Flgest = "   ACTIVO  ".  
            IF trim(Almcmov.FlgEst) = "C" THEN assign X-Flgest = "   ACTIVO  ".  
            IF trim(Almcmov.FlgEst) = "P" THEN assign X-Flgest = " PENDIENTE ".  
        END.            

        IF FIRST-OF(Almcmov.CodMov) THEN x-CuentaReg = 0.

        FIND gn-prov WHERE
            gn-prov.CodCia = Almtdocm.CodCia AND
            gn-prov.CodPro = Almcmov.CodPro 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        ELSE DO:
            FIND gn-prov WHERE
                gn-prov.CodCia = pv-codcia AND
                gn-prov.CodPro = Almcmov.CodPro 
                NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN X-despro = gn-prov.NomPro.
        END.

        IF c-CodMov = "02" THEN DO:        
            x-ImpMn1 = 0.
            x-NroDoc = "".
            x-FchDoc = ?.
            x-NroAst = "NO HAY".
            x-CodOpe = "".
            IF MONTH(Almcmov.FchDoc) = 1 THEN
                x-periodo = YEAR(Almcmov.FchDoc) - 1.
            ELSE
                x-periodo = YEAR(Almcmov.FchDoc).
            cbloop:
            FOR EACH cb-dmov WHERE
                cb-dmov.codcia = Almcmov.CodCia AND
                cb-dmov.periodo >= x-periodo AND
                cb-dmov.CodCta BEGINS "6" AND
                cb-dmov.CodAux = Almcmov.Codpro AND
                cb-dmov.CodDoc = "01" AND
                (cb-dmov.CodOpe = "060" OR
                cb-dmov.CodOpe = "076") AND
                cb-dmov.nromes >= 1 NO-LOCK:
                IF INTEGER(cb-dmov.OrdCmp) = INTEGER(Almcmov.Nrorf1) THEN DO:
                    x-ImpMn1 = cb-dmov.ImpMn1.
                    x-NroDoc = cb-dmov.Nrodoc.
                    x-FchDoc = cb-dmov.FchDoc.
                    x-NroAst = cb-dmov.NroAst.
                    x-CodOpe = cb-dmov.CodOpe.
                    PUT STREAM REPORT 
                        Almcmov.Nrodoc "|"
                        Almcmov.AlmDes "|"
                        Almcmov.FchDoc "|"
                        Almcmov.Nrorf1 "|"
                        Almcmov.NroRf3 "|"
                        Almcmov.Codpro "|"
                        X-despro FORMAT "X(30)" "|"
                        Almcmov.Usuario "|"
                        x-flgest FORMAT "X(10)" "|"
                        x-CodOpe "|"
                        x-NroAst "|"
                        x-NroDoc "|"
                        x-FchDoc "|"
                        x-ImpMn1 "|"
                        SKIP.
                END.
            END.
            IF x-CodOpe = "" THEN
                PUT STREAM REPORT
                    Almcmov.Nrodoc "|"
                    Almcmov.AlmDes "|"
                    Almcmov.FchDoc "|"
                    Almcmov.Nrorf1 "|"
                    Almcmov.NroRf3 "|"
                    Almcmov.Codpro "|"
                    X-despro FORMAT "X(30)" "|"
                    Almcmov.Usuario "|"
                    x-flgest FORMAT "X(10)"
                    "||||||"
                    SKIP.
        END.
        ELSE
            PUT STREAM REPORT
                Almcmov.Nrodoc "|"
                Almcmov.AlmDes "|"
                Almcmov.FchDoc "|"
                Almcmov.Nrorf1 "|"
                Almcmov.NroRf3 "|"
                Almcmov.Codpro "|"
                X-despro FORMAT "X(30)" "|"
                Almcmov.Usuario "|"
                x-flgest FORMAT "X(10)"
                "||||||"
                SKIP.
        T-Impcto = 0.
        X-Cospro = 0.
        F-Candes = 0.
        S-Impcto = 0.
        D-Impcto = 0.
        FOR EACH Almdmov WHERE
            Almdmov.CodCia = Almcmov.CodCia AND
            Almdmov.CodAlm = Almcmov.CodAlm AND
            Almdmov.TipMov = Almcmov.TipMov AND
            Almdmov.CodMov = Almcmov.CodMov AND
            Almdmov.NroDoc = Almcmov.NroDoc AND
            (Almdmov.CodMat >= DesdeC AND Almdmov.cODmAT <= HastaC)
            BREAK BY Almdmov.NroDoc:
            FIND Almmmatg WHERE
                Almmmatg.CodCia = Almdmov.CodCia AND
                Almmmatg.codmat = Almdmov.codmat 
                NO-LOCK NO-ERROR.
            ASSIGN 
                X-Desmat = ""
                X-Desmar = "".
            IF AVAILABLE Almmmatg THEN 
                ASSIGN
                    X-desmat = Almmmatg.DesMat
                    X-Desmar = Almmmatg.Desmar.

            /*********************************/
            x-cospro = almdmov.preuni.
            IF T-igv THEN X-Cospro = x-cospro * ( 1 + Almdmov.Igvmat / 100).
            /*********************************/
            X-Impcto = X-Cospro * Almdmov.CanDes.
            T-Impcto = T-Impcto + X-Impcto.
            x-CuentaReg = x-CuentaReg + 1.

            S-Impcto = S-Impcto + IF Almcmov.Codmon = 01 THEN X-Impcto ELSE X-Impcto * Almcmov.Tpocmb.
            D-Impcto = D-Impcto + IF Almcmov.Codmon = 02 THEN X-Impcto ELSE X-Impcto / Almcmov.Tpocmb.

            F-Candes = F-Candes + (Almdmov.CanDes * Almdmov.Factor).

            ACCUMULATE X-ImpCto (TOTAL BY Almdmov.NroDoc).

            DISPLAY
                Almdmov.codmat @ Fi-Mensaje LABEL "Código de Articulo "
                FORMAT "X(8)" WITH FRAME F-Proceso.

            PUT STREAM REPORT
                "||||||||||||||"
                Almdmov.codmat "|"
                X-DesMat "|"
                X-DesMar "|"
                Almdmov.CodUnd  FORMAT 'x(7)' "|"
                (Almdmov.CanDes * Almdmov.Factor) "|"
                X-Cospro "|"
                X-ImpCto "|"
                SKIP.

        END.
    END.

    OUTPUT STREAM report CLOSE.

    HIDE FRAME F-PROCESO.
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT.
END.

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
        IF T-valorizado THEN RUN Formato1.
        IF NOT T-valorizado THEN RUN Formato2.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   
    ASSIGN C-CodMov C-TipMov DesdeC DesdeF DocFin DocIni F-provee1 F-provee2 HastaC HastaF T-valorizado T-igv.
  
  IF DocFin <> 0 THEN DocFin = 0.
  IF DesdeF <> ?  THEN DesdeF =?.
  IF HastaF <> ?  THEN HastaF = ?.
  IF HastaC = "" THEN HastaC = "zzzzzzzzzz".
  IF F-provee2 = "" THEN F-provee2 = "ZZZZZZZZZZZZZ".
  IF T-valorizado = NO THEN T-igv:SENSITIVE = NO.
   
END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
     DISPLAY DesdeF HastaF.
     T-igv:SENSITIVE = NO.
     T-valorizado:SENSITIVE = YES.
     T-valorizado = NO.
  END.
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
        WHEN "" THEN .
        WHEN "C-CodMov" THEN 
               ASSIGN input-var-1 = C-TipMov:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

