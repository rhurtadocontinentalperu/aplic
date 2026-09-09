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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHARACTER.

DEFINE VARIABLE F-Ingreso AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-PreIng AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE F-TotIng AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-Salida AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-Saldo AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-STKGEN AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-PRECIO AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE F-VALCTO AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dTotIng AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTotSal AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-SUBTIT AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor..." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0 TITLE "Procesando..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 F-CodFam F-SubFam DesdeC HastaC ~
DesdeF HastaF nCodMon R-Tipo Btn_OK Btn_Cancel Btn_TXT Btn_Excel 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-DesFam F-SubFam F-DesSub DesdeC ~
HastaC DesdeF HastaF nCodMon R-Tipo x-mensaje 

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
     SIZE 11 BY 1.35 TOOLTIP "Cancelar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Excel" 
     SIZE 12 BY 1.35 TOOLTIP "Salida a excel".

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.35 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE BUTTON Btn_TXT 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Texto" 
     SIZE 12 BY 1.35 TOOLTIP "Salida a texto".

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Línea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-línea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 19.43 BY .46 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.88 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.43 BY 9.15.

DEFINE VARIABLE T-Resumen AS LOGICAL INITIAL no 
     LABEL "Total General Resumido" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.57 BY .69 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.81 COL 18 COLON-ALIGNED
     F-DesFam AT ROW 1.85 COL 24.29 COLON-ALIGNED NO-LABEL
     F-SubFam AT ROW 2.62 COL 18 COLON-ALIGNED
     F-DesSub AT ROW 2.62 COL 24.29 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 3.42 COL 18 COLON-ALIGNED
     HastaC AT ROW 3.42 COL 47 COLON-ALIGNED
     DesdeF AT ROW 4.23 COL 18 COLON-ALIGNED
     HastaF AT ROW 4.23 COL 47 COLON-ALIGNED
     T-Resumen AT ROW 5.04 COL 20
     nCodMon AT ROW 6.12 COL 20 NO-LABEL
     R-Tipo AT ROW 6.92 COL 20 NO-LABEL
     x-mensaje AT ROW 9.27 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 10.62 COL 32.86
     Btn_Cancel AT ROW 10.62 COL 44.29
     Btn_TXT AT ROW 10.62 COL 55.72
     Btn_Excel AT ROW 10.62 COL 68.14 WIDGET-ID 6
     "Moneda:" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 6.12 COL 13
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .69 AT ROW 7.46 COL 14
          FONT 1
     RECT-46 AT ROW 10.46 COL 1
     RECT-57 AT ROW 1.27 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 11.23
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
         TITLE              = "Kardex General Contable - 2010"
         HEIGHT             = 11.23
         WIDTH              = 80.57
         MAX-HEIGHT         = 11.23
         MAX-WIDTH          = 80.57
         VIRTUAL-HEIGHT     = 11.23
         VIRTUAL-WIDTH      = 80.57
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX T-Resumen IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       T-Resumen:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Kardex General Contable - 2010 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Kardex General Contable - 2010 */
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

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Excel.
    RUN Habilita.
    RUN Inicializa-Variables.

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


&Scoped-define SELF-NAME Btn_TXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_TXT W-Win
ON CHOOSE OF Btn_TXT IN FRAME F-Main /* Texto */
DO:

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Texto.
    RUN Habilita.
    RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Artículo */
DO:

    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FOR Almmmatg FIELDS
        (Almmmatg.CodCia Almmmatg.CodMat) WHERE
        Almmmatg.CodCia = S-CODCIA AND
        Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK:
    END.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Código no Existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'Entry':U TO SELF.
        RETURN NO-APPLY.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Línea */
DO:

    ASSIGN F-CodFam.
    FIND Almtfami WHERE
        Almtfami.CodCia = S-CODCIA AND
        Almtfami.codfam = F-CodFam NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN 
        DISPLAY
            Almtfami.desfam @ F-DesFam
            WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-línea */
DO:

    ASSIGN F-CodFam.
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF F-CodFam = "" THEN DO:
        SELF:SCREEN-VALUE = "".
        RETURN.
    END.
    FIND AlmSFami WHERE
        AlmSFami.CodCia = S-CODCIA AND
        AlmSFami.codfam = F-CodFam AND
        AlmSFami.subfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE AlmSFami THEN 
        DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
    ELSE DO:
        MESSAGE
            "Código de Sub-Familia no Existe"
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'Entry':U TO SELF.
        RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:

    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FOR Almmmatg FIELDS
        (Almmmatg.CodCia Almmmatg.CodMat) WHERE
        Almmmatg.CodCia = S-CODCIA AND
        Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK:
    END.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE "Código no Existe" VIEW-AS ALERT-BOX ERROR.
        APPLY 'Entry':U TO SELF.
        RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
        DesdeC
        DesdeF
        F-CodFam
        F-DesFam
        HastaC
        HastaF
        nCodMon
        T-Resumen
        R-Tipo.

    IF HastaC <> "" THEN 
        S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
    ELSE
        S-SUBTIT = "".

    IF HastaC = "" THEN HastaC = "999999999".
    S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).

    IF HastaC = "" THEN HastaC = "999999".
    IF DesdeF = ? THEN DesdeF = 01/01/1900.
    IF HastaF = ? THEN HastaF = 01/01/3000.

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
  DISPLAY F-CodFam F-DesFam F-SubFam F-DesSub DesdeC HastaC DesdeF HastaF 
          nCodMon R-Tipo x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF nCodMon R-Tipo 
         Btn_OK Btn_Cancel Btn_TXT Btn_Excel 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* Encabezados */
    DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
    DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
    DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
    DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
    DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
    DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
    DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-total AS DECIMAL.

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "KARDEX GENERAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = s-subtit.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = IF nCodmon = 1 THEN "Expresado en Nuevos Soles " ELSE "Expresado en Dolares Americanos".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cod. Alm.".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cod. Mov.".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Número Doc.".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Alm. Origen".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Código Proveedor".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Código Cliente".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Referencia".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Referencia".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Fecha Documento".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Ingresos".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Salidas".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Costo Ingresos".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Costo Promedio".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Saldos".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Costo Total".

    ASSIGN
        x-inggen = 0
        x-salgen = 0
        x-totgen = 0  
        x-total  = 0.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

    KARDEX:
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.CodMat >= DesdeC  
        AND Almmmatg.CodMat <= HastaC  
        AND Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.TpoArt BEGINS R-Tipo
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
        EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
        AND Almdmov.codmat = Almmmatg.CodMat 
        AND Almdmov.FchDoc >= DesdeF 
        AND Almdmov.FchDoc <= HastaF,
        FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
        AND Almtmovm.TipMov = Almdmov.TipMov 
        AND Almtmovm.Codmov = Almdmov.Codmov
        AND Almtmovm.Movtrf = No,
        FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = Yes
        AND Almacen.AlmCsg = No
        BREAK BY Almmmatg.CodCia BY Almmmatg.CodMat BY Almdmov.FchDoc:
        /* control de filas en el Excel */
        IF iCount > 65500 THEN DO:
            MESSAGE 'Este reporte ha superado la capacidad de la hoja de cálculo'
                VIEW-AS ALERT-BOX WARNING.
            LEAVE KARDEX.
        END.
        /* **************************** */

        /*
        DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(11)" 
            WITH FRAME F-Proceso.
        */
        DISPLAY "Codigo de Articulo " + Almmmatg.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
            /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
            FIND LAST AlmStkGe WHERE
                AlmstkGe.Codcia = Almmmatg.Codcia AND
                AlmstkGe.CodMat = Almmmatg.CodMat AND
                AlmstkGe.Fecha < DesdeF
                NO-LOCK NO-ERROR.
            F-STKGEN = 0.
            F-SALDO  = 0.
            F-PRECIO = 0.
            F-VALCTO = 0.
            IF AVAILABLE AlmStkGe THEN DO:
                F-STKGEN = AlmStkGe.StkAct.
                F-SALDO  = AlmStkGe.StkAct.
                F-PRECIO = AlmStkGe.CtoUni.
                F-VALCTO = F-STKGEN * F-PRECIO.
            END.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Almmmatg.codmat.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Almmmatg.desmat.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Almmmatg.desmar.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):VALUE = Almmmatg.undstk.
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):VALUE = f-precio.
            cRange = "N" + cColumn.
            chWorkSheet:Range(cRange):VALUE = f-saldo.
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):VALUE = f-valcto.
        END.
        x-codpro = "".
        x-codcli = "".
        x-nrorf1 = "".
        x-nrorf2 = "".
        FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
            AND  Almcmov.CodAlm = Almdmov.codalm 
            AND  Almcmov.TipMov = Almdmov.tipmov 
            AND  Almcmov.CodMov = Almdmov.codmov 
            AND  Almcmov.NroDoc = Almdmov.nrodoc 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcmov THEN DO:
            ASSIGN
                x-codpro = Almcmov.codpro
                x-codcli = Almcmov.codcli
                x-nrorf1 = Almcmov.nrorf1
                x-nrorf2 = Almcmov.nrorf2
                x-codmon = Almcmov.codmon
                x-tpocmb = Almcmov.tpocmb.
        END.
        S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
        F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-PreIng  = 0.
        F-TotIng  = 0.
        IF nCodmon = x-Codmon THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                F-TotIng  = Almdmov.ImpCto.
            END.
            ELSE DO:
                F-PreIng  = 0.
                F-TotIng  = F-PreIng * F-Ingreso.
            END.
        END.
        ELSE DO:
            IF nCodmon = 1 THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                    F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
            ELSE DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                    F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
        END.
        F-Salida = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-Saldo = Almdmov.StkAct.
        F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
        F-PRECIO = Almdmov.VctoMn1.
        ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-Salida (TOTAL BY Almmmatg.CodMat).
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almdmov.codalm.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = s-codmov.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almdmov.nrodoc.
        IF almdmov.codmov = 03 THEN DO:
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):VALUE = almdmov.almori.
        END.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = x-codpro.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = x-codcli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = x-nrorf1.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = x-nrorf2.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almdmov.fchdoc.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = f-ingreso.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = f-salida.
        IF  Almdmov.TipMov = "I" AND (ALmtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1) THEN DO:
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):VALUE = f-preing.
        END.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):VALUE = f-precio.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):VALUE = f-saldo.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):VALUE = f-valcto.
        IF LAST-OF(Almmmatg.CodMat) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):VALUE = (ACCUM TOTAL BY Almmmatg.CodMat F-Ingreso).
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):VALUE = (ACCUM TOTAL BY Almmmatg.CodMat F-Salida).
            x-total = x-total + F-VALCTO.
        END.
        IF LAST-OF(Almmmatg.CodCia) THEN DO:
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "O" + cColumn.
            chWorkSheet:Range(cRange):VALUE = x-total.
            iCount = iCount + 1.
        END.
    END.
    /*
    HIDE FRAME F-PROCESO.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
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

    DEFINE VARIABLE cTpoDoc AS CHARACTER FORMAT "x(2)" NO-UNDO.
    DEFINE VARIABLE iSerDoc AS INTEGER FORMAT "999" NO-UNDO.
    DEFINE VARIABLE cNroDoc AS CHARACTER FORMAT "x(7)" NO-UNDO.
    DEFINE VARIABLE cTpoOpe AS CHARACTER FORMAT "x(2)" NO-UNDO.
    DEFINE VARIABLE cCodMov AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCodMon LIKE Almdmov.candes NO-UNDO.

    DEFINE VARIABLE x-total AS DECIMAL NO-UNDO.

    DEFINE FRAME f-header
        HEADER
        "DETALLE DE INVENTARIO VALORIZADO"
        IF nCodmon = 1 THEN "EN NUEVOS SOLES" ELSE "DOLARES"
        "PAGINA :" TO 150 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
        "PERIODO             :" YEAR(DesdeF) SKIP
        "RUC                 : 20100038146" SKIP
        "RAZON SOCIAL        :" S-NOMCIA FORMAT "X(50)" SKIP
        "ESTABLECIMIENTO     :" SKIP
        "CODIGO              :" Almmmatg.CodMat SKIP
        "TIPO                :" SKIP
        "DESCRIPCION         :" Almmmatg.DesMat SKIP
        "UNIDAD DE MEDIDA    :" SKIP
        "METODO DE VALUACION : PROMEDIO PONDERADO"
        WITH PAGE-TOP WIDTH 250 NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    DEFINE FRAME f-report
        Almdmov.FchDoc  COLUMN-LABEL "FECHA DE!DOCUMENT" FORMAT "99/99/99"
        cTpoDoc         COLUMN-LABEL "TP!DC"
        iSerDoc         COLUMN-LABEL "SE-!RIE"
        cNroDoc         COLUMN-LABEL "NUMERO!DOCUMEN"
        cTpoOpe         COLUMN-LABEL "TP!OP"
        F-Ingreso       COLUMN-LABEL "INGRESOS"     FORMAT '>>>,>>9.99'
        F-PreIng        COLUMN-LABEL "COSTO"        FORMAT '->>>,>>9.9999'
        dTotIng         COLUMN-LABEL "TOTAL"        FORMAT '->>>>>,>>9.99'
        F-Salida        COLUMN-LABEL "SALIDAS"      FORMAT '>>>,>>9.99'
        F-PRECIO        COLUMN-LABEL "COSTO"        FORMAT '->>>>9.9999'
        dTotSal         COLUMN-LABEL "TOTAL"        FORMAT '->>>>>,>>9.99'
        F-SALDO         COLUMN-LABEL "SALDO"        FORMAT '>>>>,>>9.99'
        F-VALCTO        COLUMN-LABEL "COSTO!TOTAL"  FORMAT '->>>>>,>>9.99'
        WITH WIDTH 250 STREAM-IO DOWN.

    ASSIGN x-total = 0.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

    FOR EACH Almmmatg NO-LOCK
        WHERE Almmmatg.CodCia = S-CODCIA
        AND Almmmatg.CodMat >= DesdeC
        AND Almmmatg.CodMat <= HastaC
        AND Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.TpoArt BEGINS R-Tipo
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]),'AF,SV,XX') = 0,
        EACH Almdmov NO-LOCK USE-INDEX ALMD02
        WHERE Almdmov.CodCia = Almmmatg.CodCia 
        AND Almdmov.codmat = Almmmatg.CodMat 
        AND Almdmov.FchDoc >= DesdeF 
        AND Almdmov.FchDoc <= HastaF,
        FIRST Almtmov NO-LOCK
        WHERE Almtmovm.Codcia = Almdmov.Codcia 
        AND Almtmovm.TipMov = Almdmov.TipMov 
        AND Almtmovm.Codmov = Almdmov.Codmov
        AND Almtmovm.Movtrf = FALSE,
        FIRST Almacen OF Almdmov NO-LOCK
        WHERE Almacen.FlgRep = TRUE
        AND Almacen.AlmCsg = FALSE
        BREAK BY Almmmatg.CodCia 
        BY Almmmatg.CodMat
        BY Almdmov.FchDoc:
        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
            /*
            DISPLAY
                Almmmatg.CodMat @ Fi-Mensaje LABEL "Código de Artículo" FORMAT "X(11)"
                WITH FRAME F-PROCESO.
            */
            DISPLAY "Código de Artículo: " + Almmmatg.CodMat @ x-mensaje
                WITH FRAME {&FRAME-NAME}.

            VIEW STREAM REPORT FRAME F-header.            
        END.
        cCodMov = Almdmov.TipMov + STRING(Almdmov.CodMov,"99").

        /* Tipo de Operación (Tabla 12) */
        FOR FIRST cb-tabl WHERE
            cb-tabl.tabla = "S12" AND
            cb-tabl.codcta = cCodMov NO-LOCK:
        END.
        IF AVAILABLE cb-tabl THEN cTpoOpe = cb-tabl.codigo.
        ELSE cTpoOpe = "".

        FIND Almcmov NO-LOCK
            WHERE Almcmov.CodCia = Almdmov.codcia
            AND Almcmov.CodAlm = Almdmov.codalm
            AND Almcmov.TipMov = Almdmov.tipmov
            AND Almcmov.CodMov = Almdmov.codmov
            AND Almcmov.NroDoc = Almdmov.nrodoc
            NO-ERROR.
        IF AVAILABLE Almcmov THEN DO:

            ASSIGN iCodMon = Almcmov.codmon.

            cTpoDoc = "99".
            iSerDoc = 0.
            cNroDoc = STRING(Almcmov.NroDoc,"9999999").

            /* Ingreso por compras */
            IF cCodMov = "I02" THEN DO:
                /* Captura de G/R */
                IF Almcmov.nrorf1 <> "" THEN DO:
                    cTpoDoc = "09".
                    IF NUM-ENTRIES(Almcmov.nrorf1,"-") > 1 THEN DO:
                        iSerDoc = INTEGER(ENTRY(1,Almcmov.nrorf1,"-")).
                        cNroDoc = ENTRY(2,Almcmov.nrorf1,"-").
                    END.
                    ELSE DO:
                        iSerDoc = INTEGER(SUBSTRING(Almcmov.nrorf1,1,3)).
                        cNroDoc = SUBSTRING(Almcmov.nrorf1,4).
                    END.
                    cNroDoc = STRING(INTEGER(cNroDoc),"9999999").
                END.
            END.
            /* Salida por Ventas */
            IF cCodMov = "S02" THEN DO:
                IF Almcmov.nrorf1 <> "" THEN DO:
                    CASE SUBSTRING(Almcmov.nrorf1,1,1):
                        WHEN "F" THEN cTpoDoc = "01".
                        WHEN "B" THEN cTpoDoc = "03".
                        WHEN "G" THEN cTpoDoc = "09".
                    END CASE.
                    iSerDoc = INTEGER(SUBSTRING(Almcmov.nrorf1,2,3)).
                    cNroDoc = SUBSTRING(Almcmov.nrorf1,5).
                    cNroDoc = STRING(INTEGER(cNroDoc),"9999999").
                END.
            END.

        END.

        F-Ingreso =
            IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0
            THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-PreIng = 0.
        F-TotIng = 0.

        IF nCodmon = iCodMon THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                F-PreIng = Almdmov.PreUni / Almdmov.Factor.
                F-TotIng = Almdmov.ImpCto.
            END.
            ELSE DO:
                F-PreIng = 0.
                F-TotIng = F-PreIng * F-Ingreso.
            END.
        END.
        ELSE DO:
            IF nCodmon = 1 THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                    F-TotIng = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng = 0.
                    F-TotIng = F-PreIng * F-Ingreso.
                END.
            END.
            ELSE DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                    F-TotIng = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng = 0.
                    F-TotIng = F-PreIng * F-Ingreso.
                END.
            END.
        END.

        F-Salida =
            IF LOOKUP(Almdmov.TipMov,"S,T") > 0
            THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-Saldo = Almdmov.StkAct.
        F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
        F-PRECIO = Almdmov.VctoMn1.

        IF NOT (Almdmov.TipMov = "I" AND (ALmtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1)) THEN
            F-PreIng = 0.

        ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-Salida (TOTAL BY Almmmatg.CodMat).

        dTotIng = F-Ingreso * F-PreIng.
        dTotSal = F-Salida * F-PRECIO.

        DISPLAY STREAM REPORT
            Almdmov.FchDoc
            cTpoDoc
            iSerDoc
            cNroDoc
            cTpoOpe
            F-Ingreso
            F-PreIng
            dTotIng
            F-Salida
            F-PRECIO
            dTotSal
            F-SALDO
            F-VALCTO
            WITH FRAME f-report.

        IF LAST-OF(Almmmatg.CodMat) THEN DO:
            UNDERLINE STREAM REPORT
                F-Ingreso
                F-Salida
                F-PreIng
                F-SALDO
                F-VALCTO
                WITH FRAME f-report.
            DISPLAY STREAM REPORT
                ACCUM TOTAL BY Almmmatg.CodMat F-Ingreso
                    WHEN (ACCUM TOTAL BY Almmmatg.CodMat F-Ingreso) > 0 @ F-Ingreso
                ACCUM TOTAL BY Almmmatg.CodMat F-Salida  @ F-Salida
                WITH FRAME f-report.
            x-total = x-total + F-VALCTO.
        END.
        IF LAST-OF(Almmmatg.CodCia) THEN DO:
            UNDERLINE STREAM REPORT
                F-VALCTO
                WITH FRAME f-report.
            DISPLAY STREAM REPORT
                x-total @ F-ValCto
                WITH FRAME f-report.
            UNDERLINE STREAM REPORT
                F-VALCTO
                WITH FRAME f-report.
            DOWN STREAM REPORT WITH FRAME f-report.
        END.
    END.
    /*
    HIDE FRAME F-PROCESO.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
        ENABLE ALL EXCEPT F-DesFam F-DesSub x-mensaje.
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
        ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon T-Resumen R-Tipo.
        IF HastaC <> "" THEN HastaC = "".
        IF DesdeF <> ?  THEN DesdeF = ?.
        IF HastaF <> ?  THEN HastaF = ?.
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
        ASSIGN
            DesdeF = TODAY + 1 - DAY(TODAY).
            HastaF = TODAY.
            R-Tipo = ''.
        DISPLAY DesdeF HastaF R-Tipo.
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
        WHEN "x-Licencia" THEN ASSIGN input-var-1 = "LC".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE S-CODMOV AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
    DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
    DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
    DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
    DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
    DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-total AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x-Archivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE x-Rpta AS LOGICAL NO-UNDO.

    x-Archivo = 'KardexContable.txt'.
    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        INITIAL-DIR 'c:\tmp'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS UPDATE x-rpta.
    IF x-rpta = NO THEN RETURN.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

    OUTPUT STREAM REPORT TO VALUE(x-Archivo).

    PUT STREAM REPORT
        "CODIGO|"
        "DESCRIPCION|"
        "CAT CONTABLE|"
        "MARCA|"
        "UM|"
        "ALMACEN|"
        "CODMOV|"
        "NUMERO|"
        "ALM ORIGEN|"
        "PROVEEDOR|"
        "CLIENTE|"
        "NRO DOCUMENTO|"
        "REFERENCIA|"
        "FECHA|"
        "INGRESO|"
        "SALIDA|"
        "CTO INGRESO|"
        "CTO PROMEDIO|"
        "SALDO|"
        "CTO TOTAL|"
        SKIP.

    ASSIGN
        x-inggen = 0
        x-salgen = 0
        x-totgen = 0
        x-total  = 0.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
    FOR EACH Almmmatg NO-LOCK
        WHERE Almmmatg.CodCia = S-CODCIA
        AND Almmmatg.CodMat >= DesdeC
        AND Almmmatg.CodMat <= HastaC
        AND Almmmatg.codfam BEGINS F-CodFam
        AND Almmmatg.TpoArt BEGINS R-Tipo
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
        EACH Almdmov NO-LOCK USE-INDEX ALMD02
        WHERE Almdmov.CodCia = Almmmatg.CodCia 
        AND Almdmov.codmat = Almmmatg.CodMat
        AND Almdmov.FchDoc >= DesdeF
        AND Almdmov.FchDoc <= HastaF,
        FIRST Almtmov NO-LOCK
        WHERE Almtmovm.Codcia = Almdmov.Codcia 
        AND Almtmovm.TipMov = Almdmov.TipMov 
        AND Almtmovm.Codmov = Almdmov.Codmov
        AND Almtmovm.Movtrf = FALSE,
        FIRST Almacen OF Almdmov NO-LOCK
        WHERE Almacen.FlgRep = TRUE
        AND Almacen.AlmCsg = FALSE
        BREAK BY Almmmatg.CodCia
        BY Almmmatg.CodMat
        BY Almdmov.FchDoc:

        /*
        DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Código de Artículo "
              FORMAT "X(11)" WITH FRAME F-Proceso.
        */
        DISPLAY "Código de Artículo: " + Almmmatg.CodMat 
            WITH FRAME {&FRAME-NAME}.

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:

            /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
            FIND LAST AlmStkGe WHERE
                AlmstkGe.Codcia = Almmmatg.Codcia AND
                AlmstkGe.CodMat = Almmmatg.CodMat AND
                AlmstkGe.Fecha < DesdeF
                NO-LOCK NO-ERROR.
            F-STKGEN = 0.
            F-SALDO  = 0.
            F-PRECIO = 0.
            F-VALCTO = 0.
            IF AVAILABLE AlmStkGe THEN DO:
                F-STKGEN = AlmStkGe.StkAct.
                F-SALDO  = AlmStkGe.StkAct.
                F-PRECIO = AlmStkGe.CtoUni.
                F-VALCTO = F-STKGEN * F-PRECIO.
            END.
        END.

        x-codpro = "".
        x-codcli = "".
        x-nrorf1 = "".
        x-nrorf2 = "".

        FIND Almcmov
            WHERE Almcmov.CodCia = Almdmov.codcia 
            AND Almcmov.CodAlm = Almdmov.codalm 
            AND Almcmov.TipMov = Almdmov.tipmov 
            AND Almcmov.CodMov = Almdmov.codmov 
            AND Almcmov.NroDoc = Almdmov.nrodoc 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcmov THEN DO:
            ASSIGN
                x-codpro = Almcmov.codpro
                x-codcli = Almcmov.codcli
                x-nrorf1 = Almcmov.nrorf1
                x-nrorf2 = Almcmov.nrorf2
                x-codmon = Almcmov.codmon
                x-tpocmb = Almcmov.tpocmb.
        END.

        S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 

        F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-PreIng  = 0.
        F-TotIng  = 0.

        IF nCodmon = x-Codmon THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                F-TotIng  = Almdmov.ImpCto.
            END.
            ELSE DO:
                F-PreIng  = 0.
                F-TotIng  = F-PreIng * F-Ingreso.
             END.
        END.
        ELSE DO:
            IF nCodmon = 1 THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                    F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
            ELSE DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                    F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
        END.

        F-Salida = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-Saldo = Almdmov.StkAct.
        F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
        F-PRECIO = Almdmov.VctoMn1.
        ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
        ACCUMULATE F-Salida (TOTAL BY Almmmatg.CodMat).

        PUT STREAM REPORT
            Almmmatg.CodMat "|"
            Almmmatg.DesMat "|"
            Almmmatg.catconta[1] "|"
            Almmmatg.DesMar "|"
            Almmmatg.UndStk "|"
            Almdmov.CodAlm  "|"
            S-CODMOV "|"
            Almdmov.NroDoc "|".
        IF Almdmov.Codmov = 03 THEN PUT STREAM REPORT Almdmov.Almori "|".
        ELSE PUT STREAM REPORT "|".
        PUT STREAM REPORT
            x-CodPro "|"
            x-CodCli "|"
            x-NroRf1 "|"
            x-NroRf2 "|"
            Almdmov.FchDoc "|"
            F-Ingreso "|"
            F-Salida "|".
        IF Almdmov.TipMov = "I" AND (ALmtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1) THEN
            PUT STREAM REPORT F-PreIng "|".
        ELSE PUT STREAM REPORT "|".
        PUT STREAM REPORT
            F-PRECIO "|"
            F-SALDO "|"
            F-VALCTO "|"
            SKIP.
        IF LAST-OF(Almmmatg.CodMat) THEN DO:
            x-total = x-total + F-VALCTO.
        END.
    END.
    /*
    HIDE FRAME F-PROCESO.
    */
    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    OUTPUT STREAM REPORT CLOSE.

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

