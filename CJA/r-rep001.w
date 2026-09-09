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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-Periodo AS INT.
DEF SHARED VAR s-NroMes AS INT.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-NroMes-1 x-NroMes-2 x-Situacion ~
Btn_Excel BUTTON-3 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-NroMes-1 x-NroMes-2 ~
x-Situacion 

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
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 15 BY 1.54 TOOLTIP "Genera archivo texto"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE x-NroMes-1 AS CHARACTER FORMAT "X(9)":U INITIAL "0" 
     LABEL "Desde el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-NroMes-2 AS CHARACTER FORMAT "X(9)":U INITIAL "0" 
     LABEL "Hasta el Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE x-Situacion AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Situacion" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","Anulados" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 1.77 COL 16 COLON-ALIGNED
     x-NroMes-1 AT ROW 2.73 COL 16 COLON-ALIGNED
     x-NroMes-2 AT ROW 2.73 COL 40 COLON-ALIGNED
     x-Situacion AT ROW 3.69 COL 16 COLON-ALIGNED
     Btn_Excel AT ROW 5.42 COL 19
     BUTTON-3 AT ROW 5.42 COL 34
     Btn_Done AT ROW 5.42 COL 49
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.43 BY 7.12
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
         TITLE              = "REPORTE DE CHEQUES DIFERIDOS"
         HEIGHT             = 7.12
         WIDTH              = 65.43
         MAX-HEIGHT         = 7.12
         MAX-WIDTH          = 65.43
         VIRTUAL-HEIGHT     = 7.12
         VIRTUAL-WIDTH      = 65.43
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
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE CHEQUES DIFERIDOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE CHEQUES DIFERIDOS */
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

    ASSIGN x-NroMes-1 x-NroMes-2 x-Periodo x-Situacion.

    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    x-NroMes-1 x-NroMes-2 x-Periodo x-Situacion.
  RUN Imprimir.
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
  DISPLAY x-Periodo x-NroMes-1 x-NroMes-2 x-Situacion 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo x-NroMes-1 x-NroMes-2 x-Situacion Btn_Excel BUTTON-3 
         Btn_Done 
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

    DEF VAR pPeriodo LIKE Cb-cmov.Periodo NO-UNDO.
    DEF VAR pNroMes  LIKE Cb-cmov.NroMes  NO-UNDO.
    DEF VAR pFlgEst  LIKE Cb-cmov.FlgEst  NO-UNDO.
   
    pPeriodo = INTEGER(x-Periodo).

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE CHEQUES".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value =
        "PERIODO: " + STRING(pPeriodo,"9999") + 
        " DESDE: " + CAPS(x-NroMes-1) +
        " HASTA: " + CAPS(x-NroMes-2).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "FECHA".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "NÚMERO".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "GIRADO".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIENTO".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "IMPORTE".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "USUARIO".

    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("D"):ColumnWidth = 70.
    chWorkSheet:Columns("E"):NumberFormat = "@".
    chWorkSheet:Range("A1:I3"):Font:Bold = TRUE.

    FOR EACH cb-cmov WHERE
        cb-cmov.codcia = s-codcia AND
        cb-cmov.periodo = x-Periodo AND
        cb-cmov.nromes >=
            LOOKUP(x-NroMes-1, x-NroMes-1:LIST-ITEMS IN FRAME {&FRAME-NAME}) AND
        cb-cmov.nromes <= LOOKUP(x-NroMes-2, x-NroMes-2:LIST-ITEMS) AND
        cb-cmov.codope = '002' AND
        (cb-cmov.coddoc = '32' OR cb-cmov.coddoc = 'CH' OR cb-cmov.coddoc = '007') AND
        (x-Situacion <> 'Anulados' OR cb-cmov.ImpChq = 0) NO-LOCK:

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.fchast.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.coddoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.nrochq.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.girado.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.nroast.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value =
            IF cb-cmov.codmon = 1 THEN "S/." ELSE "US$".
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.impchq.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cb-cmov.usuario.
        DISPLAY
            "   Asiento: " + cb-cmov.nroast @ FI-MENSAJE
            WITH FRAME F-PROCESO.

    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'cbd/rbcbd.prl'.
  RB-REPORT-NAME = 'Registro de Cheques'.
  RB-INCLUDE-RECORDS = 'O'.
  RB-FILTER = "cb-cmov.codcia = " + STRING(s-codcia) +
                 " AND cb-cmov.periodo = " + STRING(x-Periodo) +
                 " AND cb-cmov.nromes >= " + STRING(LOOKUP(x-NroMes-1, x-NroMes-1:LIST-ITEMS IN FRAME {&FRAME-NAME})) +
                 " AND cb-cmov.nromes <= " + STRING(LOOKUP(x-NroMes-2, x-NroMes-2:LIST-ITEMS IN FRAME {&FRAME-NAME})) +
                 " AND cb-cmov.codope = '002'" +
                 " AND (cb-cmov.coddoc= '32' OR cb-cmov.coddoc = 'CH' OR cb-cmov.coddoc = '007')".
  IF x-Situacion = 'Anulados'
  THEN RB-FILTER = RB-FILTER + " AND cb-cmov.ImpChq = 0".
  
  RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).
                    
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
    x-NroMes-1:SCREEN-VALUE = ENTRY(s-NroMes, x-NroMes-1:LIST-ITEMS).
    x-NroMes-2:SCREEN-VALUE = ENTRY(s-NroMes, x-NroMes-2:LIST-ITEMS).
    FOR  EACH cb-peri WHERE cb-peri.codcia = s-codcia NO-LOCK:
        x-Periodo:ADD-LAST(STRING(cb-peri.Periodo, '9999')).
    END.
    x-Periodo:DELETE(1).
    x-Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
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

