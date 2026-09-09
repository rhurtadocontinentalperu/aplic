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
DEFINE VARIABLE cl-CodCia AS INTEGER NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE TEMP-TABLE tt_work NO-UNDO
    FIELDS tt_coddoc LIKE ccbcdocu.coddoc
    FIELDS tt_nrodoc LIKE ccbcdocu.nrodoc
    FIELDS tt_fchdoc LIKE ccbcdocu.fchdoc
    FIELDS tt_licencia LIKE almmmatg.Licencia[1]
    FIELDS tt_deslic AS CHARACTER
    FIELDS tt_codmat LIKE almmmatg.codmat
    FIELDS tt_desmat LIKE almmmatg.desmat
    FIELDS tt_imptot LIKE ccbcdocu.imptot
    FIELDS tt_impdol LIKE ccbcdocu.imptot
    FIELDS tt_rebsol LIKE ccbcdocu.imptot
    FIELDS tt_rebdol LIKE ccbcdocu.imptot
        INDEX tt_coddoc IS PRIMARY tt_coddoc tt_nrodoc tt_licencia
        INDEX tt_codmat tt_coddoc tt_nrodoc tt_licencia tt_codmat.

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

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE Empresas THEN DO:
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 FILL-IN-codcli FILL-IN-desde ~
FILL-IN-hasta RADIO-format x-reb Btn_Excel Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codcli FILL-IN-nomcli ~
FILL-IN-desde FILL-IN-hasta RADIO-format x-reb 

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

DEFINE VARIABLE FILL-IN-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-reb AS INTEGER FORMAT ">99":U INITIAL 0 
     LABEL "Rebate" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-format AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Resumido", 1,
"Detallado", 2
     SIZE 12 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.88
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 4.85.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-codcli AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-nomcli AT ROW 2.08 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-desde AT ROW 3.15 COL 9 COLON-ALIGNED
     FILL-IN-hasta AT ROW 3.15 COL 27 COLON-ALIGNED
     RADIO-format AT ROW 4.23 COL 30 NO-LABEL WIDGET-ID 12
     x-reb AT ROW 4.42 COL 55 COLON-ALIGNED WIDGET-ID 18
     Btn_Excel AT ROW 6.38 COL 55 WIDGET-ID 6
     Btn_Cancel AT ROW 6.38 COL 68
     "%" VIEW-AS TEXT
          SIZE 2.57 BY .5 AT ROW 4.58 COL 61.43 WIDGET-ID 20
          FONT 6
     "Formato:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.77 COL 23 WIDGET-ID 16
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 6.12 COL 1
     RECT-57 AT ROW 1.27 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.04
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
         TITLE              = "Licencias por Documento por Cliente"
         HEIGHT             = 7.04
         WIDTH              = 80
         MAX-HEIGHT         = 7.04
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 7.04
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Licencias por Documento por Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Licencias por Documento por Cliente */
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

    FOR gn-clie
        FIELDS(gn-clie.codcia gn-clie.codcli gn-clie.nomcli)
        WHERE gn-clie.codcia = cl-CodCia
        AND gn-clie.codcli = FILL-IN-codcli:SCREEN-VALUE
        NO-LOCK:
    END.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE
            "Cliente no existe"
            VIEW-AS ALERT-BOX WARNING.
        DISPLAY "CLIENTE NO EXISTE!!!" @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.
        APPLY 'Entry':U TO FILL-IN-codcli.
        RETURN NO-APPLY.
    END.
    DISPLAY gn-clie.nomcli @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.

    RUN Excel.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codcli W-Win
ON LEAVE OF FILL-IN-codcli IN FRAME F-Main /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FOR gn-clie
        FIELDS(gn-clie.codcia gn-clie.codcli gn-clie.nomcli)
        WHERE gn-clie.codcia = cl-CodCia
        AND gn-clie.codcli = SELF:SCREEN-VALUE
        NO-LOCK:
    END.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE
            "Cliente no existe"
            VIEW-AS ALERT-BOX WARNING.
        DISPLAY "CLIENTE NO EXISTE!!!" @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DISPLAY gn-clie.nomcli @ FILL-IN-nomcli WITH FRAME {&FRAME-NAME}.
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
  DISPLAY FILL-IN-codcli FILL-IN-nomcli FILL-IN-desde FILL-IN-hasta RADIO-format 
          x-reb 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 FILL-IN-codcli FILL-IN-desde FILL-IN-hasta RADIO-format x-reb 
         Btn_Excel Btn_Cancel 
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
    DEFINE VARIABLE iCount             AS INTEGER NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    RUN proc_carga-tt.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE =
        "DOCUMENTOS EMITIDOS A " + FILL-IN-codcli + " " + FILL-IN-nomcli.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "TIPO".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DOCUMENTO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "FECHA".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "LICENCIA".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "DESCRIPCIÓN".

    chWorkSheet:COLUMNS("B"):ColumnWidth = 14.
    chWorkSheet:COLUMNS("D"):NumberFormat = "@".
    chWorkSheet:COLUMNS("E"):ColumnWidth = 30.
    chWorkSheet:Range("A1:K2"):FONT:Bold = TRUE.

    IF RADIO-format = 1 THEN DO:

        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "IMPORTE S/.".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "IMPORTE $".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "REBATE S/.".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "REBATE $".


        FOR EACH tt_work NO-LOCK
            BREAK BY tt_coddoc BY tt_nrodoc BY tt_licencia:
            IF FIRST-OF(tt_nrodoc) THEN
                DISPLAY
                    tt_coddoc + "-" + tt_nrodoc @ Fi-Mensaje
                        LABEL "Documento" FORMAT "X(16)"
                    WITH FRAME F-PROCESO.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_coddoc.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_coddoc + "-" + tt_nrodoc.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_fchdoc.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_licencia.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_deslic.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_imptot.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_impdol.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_rebsol.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_rebdol.
        END.

    END.
    ELSE DO:

        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "ARTICULO".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "DESCRIPCIÓN".
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "IMPORTE S/.".
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "IMPORTE $".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "REBATE S/.".
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = "REBATE $".


        chWorkSheet:COLUMNS("F"):NumberFormat = "@".
        chWorkSheet:COLUMNS("G"):ColumnWidth = 40.
        chWorkSheet:Range("A1:H2"):FONT:Bold = TRUE.

        FOR EACH tt_work NO-LOCK
            BREAK BY tt_coddoc BY tt_nrodoc BY tt_licencia BY tt_codmat:
            IF FIRST-OF(tt_nrodoc) THEN
                DISPLAY
                    tt_coddoc + "-" + tt_nrodoc @ Fi-Mensaje
                        LABEL "Documento" FORMAT "X(16)"
                    WITH FRAME F-PROCESO.
            iCount = iCount + 1.
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_coddoc.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_coddoc + "-" + tt_nrodoc.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_fchdoc.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_licencia.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_deslic.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_codmat.
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_desmat.
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_imptot.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_impdol.
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_rebsol.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):VALUE = tt_rebdol.
        END.

    END.

    HIDE FRAME F-PROCESO.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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
        ASSIGN
            FILL-IN-desde = TODAY + 1 - DAY(TODAY).
            FILL-IN-hasta = TODAY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-tt W-Win 
PROCEDURE proc_carga-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cCodMat     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLicencia   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cLogLic     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE dFactor     AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE x-TpoCmbCmp LIKE Gn-Tcmb.Compra NO-UNDO.
    DEFINE VARIABLE x-TpoCmbVta LIKE Gn-Tcmb.Venta  NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN FILL-IN-codcli FILL-IN-desde FILL-IN-hasta FILL-IN-nomcli RADIO-format x-reb.
        IF FILL-IN-desde = ? THEN
            FILL-IN-desde = 01/01/1900.
        IF FILL-IN-hasta = ? THEN
            FILL-IN-hasta = 12/31/3999.
    END.

    FOR EACH tt_work:
        DELETE tt_work.
    END.

    FOR EACH ccbcdocu WHERE
        ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc <> "G/R" AND
        ccbcdocu.codcli = FILL-IN-codcli AND
        ccbcdocu.flgest <> "A" AND        
        ccbcdocu.fchdoc >= FILL-IN-desde AND
        ccbcdocu.fchdoc <= FILL-IN-hasta NO-LOCK:

        IF ccbcdocu.coddoc = "N/C" THEN dFactor = -1. ELSE dFactor = 1.

        DISPLAY
            ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ Fi-Mensaje
                LABEL "Documento" FORMAT "X(16)"
            WITH FRAME F-PROCESO.

        /*Tipo de Cambio*/
        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.


        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
            FOR FIRST Almmmatg
                FIELDS (Almmmatg.CodCia Almmmatg.CodMat almmmatg.Licencia[1] almmmatg.desmat)
                WHERE Almmmatg.CodCia = S-CODCIA
                AND Almmmatg.CodMat = ccbddocu.CodMat NO-LOCK:
            END.
            IF AVAILABLE Almmmatg THEN DO:

                IF almmmatg.Licencia[1] <> "" THEN DO:
                    cLicencia = almmmatg.Licencia[1].
                    cCodMat = almmmatg.codmat.
                    cLogLic = YES.
                END.
                ELSE DO:
                    cLicencia = "SINLIC".
                    cCodMat = "".
                    cLogLic = NO.
                END.

                /* Resumido */
                IF RADIO-format = 1 THEN DO:
                    FIND FIRST tt_work WHERE
                        tt_coddoc = ccbcdocu.coddoc AND
                        tt_nrodoc = ccbcdocu.nrodoc AND
                        tt_licencia = cLicencia
                        NO-ERROR.
                END.
                /* Detallado */
                ELSE DO:
                    FIND FIRST tt_work WHERE
                        tt_coddoc = ccbcdocu.coddoc AND
                        tt_nrodoc = ccbcdocu.nrodoc AND
                        tt_licencia = cLicencia AND
                        tt_codmat = cCodMat
                        NO-ERROR.
                END.
                IF NOT AVAILABLE tt_work THEN DO:
                    CREATE tt_work.
                    ASSIGN
                        tt_coddoc = ccbcdocu.coddoc
                        tt_nrodoc = ccbcdocu.nrodoc
                        tt_fchdoc = ccbcdocu.fchdoc
                        tt_licencia = cLicencia
                        tt_codmat = cCodMat
                        tt_desmat = IF cCodMat = "" THEN
                            "" ELSE almmmatg.desmat.
                    IF cLicencia = "SINLIC" THEN
                        tt_deslic = "SIN LICENCIA".
                    ELSE DO:
                        FIND almtabla WHERE
                            almtabla.Tabla = "LC" AND
                            almtabla.Codigo = Almmmatg.Licencia[1]
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE almtabla THEN
                            tt_deslic = almtabla.Nombre.
                    END.
                END.

                CASE ccbcdocu.codmon:
                    WHEN 1 THEN DO:
                        tt_imptot = tt_imptot + (ccbddocu.implin * dFactor).
                        tt_impdol = tt_impdol + (ccbddocu.implin / x-TpoCmbCmp * dFactor).
                    END.
                    WHEN 2 THEN DO:
                        tt_imptot = tt_imptot + (ccbddocu.implin * x-TpoCmbVta * dFactor).
                        tt_impdol = tt_impdol + (ccbddocu.implin * dFactor).
                    END.
                END CASE.

                /*
                IF ccbcdocu.codmon > 1 THEN
                    tt_imptot = tt_imptot + (ccbddocu.implin * ccbcdocu.tpocmb * dFactor).
                ELSE
                    tt_imptot = tt_imptot + (ccbddocu.implin * dFactor).
                    
                */    
                IF cLogLic THEN DO: 
                    tt_rebsol = tt_rebsol + (tt_imptot * (x-reb / 100 )).
                    tt_rebdol = tt_rebdol + (tt_impdol * (x-reb / 100 )).
                END.
            END.
        END.

    END.

    HIDE FRAME F-PROCESO.

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

    CASE HANDLE-CAMPO:NAME:
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

