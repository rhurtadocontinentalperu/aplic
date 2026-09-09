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
/*{src/bin/_prns.i} */  /* Para la impresion */
{src/adm2/widgetprto.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR S-CODCIA      AS INTEGER.
DEFINE SHARED VAR CL-CODCIA     AS INTEGER.
DEFINE SHARED VAR S-NOMCIA      AS CHARACTER.
DEFINE SHARED VAR S-DESALM      AS CHARACTER.
DEFINE SHARED VAR S-USER-ID     AS CHARACTER.

DEFINE VAR s-task-no AS INTEGER NO-UNDO.

DEFINE VAR S-CODMOV LIKE ALMTMOVM.CODMOV.
FIND FacDocum WHERE codcia = s-codcia 
    AND coddoc = 'D/F'
    NO-LOCK NO-ERROR.
IF AVAILABLE facdocum THEN S-CODMOV = facdocum.codmov.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE BUFFER DMOV FOR Almdmov.

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
&Scoped-Define ENABLED-OBJECTS rs-tipo x-codalm txt-page txt-page-2 r-imp ~
btn-Excel Btn_Ok Btn_Done x-zona x-zona-2 RECT-70 RECT-71 RECT-72 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo x-codalm x-mensaje txt-desalm ~
txt-page txt-page-2 r-imp x-zona x-zona-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Excel 
     IMAGE-UP FILE "IMG/excel.bmp":U
     LABEL "Button 1" 
     SIZE 11 BY 1.46.

DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.46
     BGCOLOR 8 .

DEFINE BUTTON Btn_Ok 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.46.

DEFINE VARIABLE txt-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.57 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE txt-page AS INTEGER FORMAT "9999":U INITIAL 1 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE txt-page-2 AS INTEGER FORMAT "9999":U INITIAL 9999 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE x-codalm AS CHARACTER FORMAT "X(4)":U INITIAL "11X" 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81 NO-UNDO.

DEFINE VARIABLE x-zona AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE x-zona-2 AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE r-imp AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impresión Laser", 1,
"Impresion Matricial", 2
     SIZE 34.14 BY .81 NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Conteo", "C",
"Reconteo", "R"
     SIZE 34 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70 BY 1.73
     BGCOLOR 7 FGCOLOR 7 .

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.15.

DEFINE RECTANGLE RECT-72
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 1.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-tipo AT ROW 6.92 COL 7 NO-LABEL WIDGET-ID 50
     x-codalm AT ROW 1.54 COL 11 COLON-ALIGNED WIDGET-ID 42
     x-mensaje AT ROW 8.12 COL 2 NO-LABEL WIDGET-ID 28
     txt-desalm AT ROW 1.54 COL 19.57 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     txt-page AT ROW 4.23 COL 18 COLON-ALIGNED WIDGET-ID 24
     txt-page-2 AT ROW 4.23 COL 33 COLON-ALIGNED WIDGET-ID 26
     r-imp AT ROW 5.65 COL 6.86 NO-LABEL WIDGET-ID 16
     btn-Excel AT ROW 9.12 COL 36.57 WIDGET-ID 20
     Btn_Ok AT ROW 9.12 COL 48
     Btn_Done AT ROW 9.12 COL 59.43
     x-zona AT ROW 2.96 COL 18 COLON-ALIGNED WIDGET-ID 40
     x-zona-2 AT ROW 2.96 COL 33 COLON-ALIGNED WIDGET-ID 44
     "Nº Página" VIEW-AS TEXT
          SIZE 7.86 BY .5 AT ROW 4.42 COL 6 WIDGET-ID 8
     "Zona(s):" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.23 COL 6 WIDGET-ID 46
     RECT-70 AT ROW 9 COL 1.29 WIDGET-ID 22
     RECT-71 AT ROW 5.5 COL 5 WIDGET-ID 48
     RECT-72 AT ROW 6.81 COL 5 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71 BY 9.96
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
         TITLE              = "Impresion Hojas Inventario"
         HEIGHT             = 9.96
         WIDTH              = 71
         MAX-HEIGHT         = 9.96
         MAX-WIDTH          = 71
         VIRTUAL-HEIGHT     = 9.96
         VIRTUAL-WIDTH      = 71
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
IF NOT W-Win:LOAD-ICON("adeicon/edit%.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/edit%.ico"
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txt-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion Hojas Inventario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion Hojas Inventario */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Excel W-Win
ON CHOOSE OF btn-Excel IN FRAME F-Main /* Button 1 */
DO:
    RUN Asigna-Variables.
    
  FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
           AND Almacen.CodAlm = X-codalm NO-LOCK NO-ERROR.
  IF AVAIL Almacen THEN DO:
        txt-desalm:SCREEN-VALUE = Almacen.Descripcion.
        RUN Carga-Temporal.
        RUN Excel.
  END.  
  ELSE DO:
      MESSAGE 'Almacen Virual No existe' VIEW-AS ALERT-BOX WARNING.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Cancelar */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Ok W-Win
ON CHOOSE OF Btn_Ok IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.

  FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
           AND Almacen.CodAlm = X-codalm NO-LOCK NO-ERROR.
  IF AVAIL Almacen THEN DO:
    txt-desalm:SCREEN-VALUE = Almacen.Descripcion.
    RUN Carga-Temporal.
    RUN Imprime.    
  END.  
  ELSE DO:
      MESSAGE 'Almacen Virual No existe' VIEW-AS ALERT-BOX WARNING.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codalm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codalm W-Win
ON LEAVE OF x-codalm IN FRAME F-Main /* Almacen */
DO:
        DEFINE VAR lAlm-virtual AS CHAR.

        lAlm-virtual = SELF:SCREEN-VALUE.

       FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
           AND Almacen.CodAlm = lAlm-virtual NO-LOCK NO-ERROR.
       IF AVAIL Almacen THEN DO:
           /*ASSIGN txt-desalm = Almacen.Descripcion.*/
           txt-desalm:SCREEN-VALUE = Almacen.Descripcion.
           /*DISPLAY Almacen.Descripcion @ txt-desalm.*/
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
            x-CodAlm txt-page txt-page-2 r-imp x-zona x-zona-2 rs-tipo txt-desalm.  
    END.    

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
DEFINE VARIABLE L-Ubica AS LOGICAL     INIT YES.
DEFINE VARIABLE cCodAlm AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomCia AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSup    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cZonaD  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cZonaH  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cNomLis AS CHARACTER   NO-UNDO.

REPEAT WHILE L-Ubica:
    s-task-no = RANDOM(900000,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN L-Ubica = NO.
END.

cNomCia = "CONTISTAND".
cCodAlm = x-codalm.   /*"11x".*/

IF x-zona   = '' THEN cZonaD = '     '. ELSE cZonaD = x-zona.
IF x-zona-2 = '' THEN cZonaH = 'ZZZZZ'. ELSE cZonaH = x-zona-2.
IF rs-tipo = 'C' THEN cNomLis = 'HOJAS DE CONTEO'.
ELSE cNomLis = 'HOJAS DE RECONTEO'.

FOR EACH AlmDInv WHERE AlmDInv.CodCia = s-codcia
    AND AlmDInv.CodAlm    =  cCodAlm 
    AND AlmDInv.NroPagina >= INTEGER(txt-page)
    AND AlmDInv.NroPagina <= INTEGER(txt-page-2)
    AND AlmDInv.NroPagina <  9000 
    AND (AlmDInv.NomCia    =  cNomCia OR AlmDInv.NomCia = "CONTI")
    AND AlmDInv.CodUbi    >= cZonaD  
    AND AlmDInv.CodUbi    <= cZonaH  NO-LOCK:
    FIND LAST almcinv WHERE almcinv.codcia = almdinv.codcia
        AND almcinv.codalm = almdinv.codalm
        AND almcinv.nomcia = almdinv.nomcia NO-LOCK NO-ERROR.

    /*Supervisores*/
    FIND TabSupAlm WHERE TabSupAlm.CodCia = AlmDInv.CodCia
        AND TabSupAlm.CodAlm = AlmDInv.CodAlm 
        AND TabSupAlm.CodUbi = AlmDInv.CodUbi NO-LOCK NO-ERROR.
    IF AVAIL TabSupAlm THEN cSup = TabSupAlm.Cargo. ELSE cSup = ''.

    IF rs-tipo = 'C' OR (almdinv.qtyfisico - almdinv.libre_d01 <> 0) THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.Task-No    = s-task-no
            w-report.Llave-I    = AlmDInv.CodCia
            w-report.Campo-I[1] = AlmDInv.NroPagina
            w-report.Campo-I[2] = AlmDInv.NroSecuencia
            w-report.Campo-I[3] = AlmCInv.NroPagina
            w-report.Campo-C[1] = AlmDInv.CodAlm
            w-report.Campo-C[2] = AlmDInv.CodUbi
            w-report.Campo-C[3] = AlmDInv.CodMat        
            w-report.Campo-C[4] = "Almacen: " + almdinv.codalm + "- " + txt-desalm
            w-report.Campo-C[5] = cSup
            w-report.Campo-C[6] = cNomLis.   
        DISPLAY "Cargando informacion " + AlmDInv.CodMat @ x-mensaje WITH FRAME {&FRAME-NAME}.
    END.
END.

DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

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
  DISPLAY rs-tipo x-codalm x-mensaje txt-desalm txt-page txt-page-2 r-imp x-zona 
          x-zona-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rs-tipo x-codalm txt-page txt-page-2 r-imp btn-Excel Btn_Ok Btn_Done 
         x-zona x-zona-2 RECT-70 RECT-71 RECT-72 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Und    AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "HOJA DE CONTEO".
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.
cRange = "C" + '3'.
chWorkSheet:Range(cRange):Value = "Almacen: ".
cRange = "D" + '3'.
chWorkSheet:Range(cRange):Value = x-CodAlm.
cRange = "E" + '3'.
chWorkSheet:Range(cRange):Value = txt-desalm.


/*Formato*/
chWorkSheet:Columns("C"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

/* set the column names for the Worksheet */
t-Column = t-Column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Pag".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro.Sec".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Ubicación".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Código".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripción".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Conteo".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Observaciones".

FOR EACH w-report WHERE w-report.task-no = s-task-no
    BREAK BY w-report.Campo-I[1]
        BY w-report.Campo-I[2]:
    FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-CodCia
        AND Almmmatg.CodMat = w-report.Campo-C[3] NO-LOCK NO-ERROR.
    IF AVAIL Almmmatg THEN 
        ASSIGN 
            x-DesMat = Almmmatg.DesMat
            x-DesMar = Almmmatg.DesMar
            x-Und    = Almmmatg.UndBas.
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-I[1].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-I[2].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-C[2].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.Campo-C[3].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Desmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = x-DesMar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-Und.
    DISPLAY "Cargando informacion ... "  @ x-mensaje
        WITH FRAME {&FRAME-NAME}.
END.

HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

/*Borrando Temporal*/
FOR EACH w-report WHERE task-no = s-task-no:
    DELETE w-report.
END.
s-task-no = 0.

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
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'alm/rbalm.prl'.
  IF r-imp = 1 THEN RB-REPORT-NAME = 'Listado de Inventarios'.
  ELSE RB-REPORT-NAME = 'Listado de Inventarios Draft'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "w-report.task-no = " + STRING(S-TASK-NO).

  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia +
                        "~ncNropage = " + STRING(txt-page-2).

  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).


  /*Borrando Temporal*/
  FOR EACH w-report WHERE task-no = s-task-no:
      DELETE w-report.
  END.
  s-task-no = 0.

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
   DO WITH FRAME {&FRAME-NAME}:
       x-CodAlm:LIST-ITEMS = 'Todos'.
       FOR EACH Almacen WHERE Almacen.CodCia = s-codcia NO-LOCK:
           x-CodAlm:ADD-LAST(Almacen.CodAlm).
       END.     
       ASSIGN 
           x-CodAlm = "   "
           txt-page-2 = 9999.

       FIND FIRST Almacen WHERE Almacen.CodCia = s-codcia
           AND Almacen.CodAlm = x-CodAlm NO-LOCK NO-ERROR.
       IF AVAIL Almacen THEN DO:
           ASSIGN txt-desalm = Almacen.Descripcion.
           DISPLAY Almacen.Descripcion @ txt-desalm.
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

