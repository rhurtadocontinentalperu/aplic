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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR s-subtit AS CHAR NO-UNDO.
DEF VAR s-Estado AS CHAR NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "vta/rbvta.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Estado-Cuenta-Tarjeta-Conti".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

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
&Scoped-Define ENABLED-OBJECTS F-nrocar f-fecini f-fecfin F-unival x-MtoMin ~
f-TpoCmb RADIO-SET-Formato BUTTON-2 Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS F-nrocar f-fecini f-fecfin F-unival ~
x-MtoMin f-TpoCmb RADIO-SET-Formato x-Mensaje 

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

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 2" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE f-fecfin AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-fecini AS DATE FORMAT "99/99/9999":U 
     LABEL "Facturados desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE F-nrocar AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nro Tarjeta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE f-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "T.C." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE F-unival AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Valor Unitario del vale en S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE VARIABLE x-MtoMin AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Monto Minimo de Compra S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Formato AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Papel Blanco", 1,
"Pre-Impreso", 2
     SIZE 25 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-nrocar AT ROW 1.19 COL 22 COLON-ALIGNED
     f-fecini AT ROW 2.35 COL 22 COLON-ALIGNED
     f-fecfin AT ROW 3.5 COL 22 COLON-ALIGNED
     F-unival AT ROW 4.65 COL 22 COLON-ALIGNED
     x-MtoMin AT ROW 5.81 COL 22 COLON-ALIGNED
     f-TpoCmb AT ROW 6.77 COL 22 COLON-ALIGNED
     RADIO-SET-Formato AT ROW 7.92 COL 24 NO-LABEL
     x-Mensaje AT ROW 8.88 COL 3 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 10.04 COL 4
     BUTTON-2 AT ROW 10.04 COL 20
     Btn_Done AT ROW 10.04 COL 36
     "Formato de Impresion:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 7.92 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.43 BY 11.5
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
         TITLE              = "Estado de Cuenta de Clientes con Tarjeta Exclusiva"
         HEIGHT             = 11.5
         WIDTH              = 63.43
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 63.43
         VIRTUAL-HEIGHT     = 11.5
         VIRTUAL-WIDTH      = 63.43
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Estado de Cuenta de Clientes con Tarjeta Exclusiva */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Estado de Cuenta de Clientes con Tarjeta Exclusiva */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN f-fecfin f-fecini F-nrocar F-unival RADIO-SET-Formato x-MtoMin f-tpocmb.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN f-fecfin f-fecini F-nrocar F-unival RADIO-SET-Formato x-MtoMin f-tpocmb.
  IF f-nrocar = '' 
  THEN DO:
    MESSAGE 'Increse un numero de tarjeta valido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO f-nrocar.
    RETURN NO-APPLY.
  END.
  RUN Carga-Temporal.
  
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.

/*  CASE RADIO-SET-Formato:
 *   WHEN 1 THEN RUN Excel-1.
 *   WHEN 2 THEN RUN Excel-2.
 *   END CASE.*/
  RUN Excel-1.
  RUN Borra-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-fecfin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-fecfin W-Win
ON LEAVE OF f-fecfin IN FRAME F-Main /* Hasta */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAILABLE GN-TCMB
  THEN DISPLAY gn-tcmb.venta @ f-tpocmb WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-nrocar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-nrocar W-Win
ON LEAVE OF F-nrocar IN FRAME F-Main /* Nro Tarjeta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Gn-Card WHERE Gn-Card.NroCard = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.

     IF NOT AVAILABLE Gn-Card THEN DO:
        MESSAGE "Numero de Tarjeta No Existe...."
        VIEW-AS ALERT-BOX .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  
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
  DEF VAR x-signo AS INT.
  DEF VAR x-impnac AS DEC.
  DEF VAR x-impusa AS DEC.
  DEF VAR x-sdonac AS DEC.
  DEF VAR x-sdousa AS DEC.
  DEF VAR x-imptot AS DEC.
  DEF VAR x-sdotot AS DEC.
  
  REPEAT:
    s-task-no = RANDOM(1,999998).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.

  FOR EACH GN-DIVI WHERE GN-DIVI.codcia = s-codcia NO-LOCK:  
    FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddiv = gn-divi.coddiv                          
            AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,TCK') > 0
            AND ccbcdocu.fchdoc >= f-fecini AND ccbcdocu.fchdoc <= f-fecfin
            AND ccbcdocu.flgest <> 'A'
            AND (f-nrocar = '' OR ccbcdocu.nrocard = f-nrocar)
            AND ccbcdocu.nrocard <> '':
/*        IF ccbcdocu.codmon = 1 AND ccbcdocu.imptot < x-MtoMin THEN NEXT.
 *         IF ccbcdocu.codmon = 2 
 *             AND ROUND(ccbcdocu.imptot * ccbcdocu.tpocmb, 2) < x-MtoMin THEN NEXT.*/
        x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.nrocard + ' ' +
                                                        STRING(ccbcdocu.fchdoc) + ' ' +
                                                        ccbcdocu.coddoc + ' ' +
                                                        ccbcdocu.nrodoc + ' ' +
                                                        ccbcdocu.nomcli.
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.llave-c = ccbcdocu.nrocard
            w-report.campo-i[1] = ccbcdocu.codcia.
        ASSIGN
            x-impnac = 0
            x-impusa = 0
            x-imptot = 0
            x-sdonac = 0
            x-sdousa = 0
            x-sdotot = 0.        
        x-signo = if ccbcdocu.coddoc = "N/C" then -1 else 1.
        if ccbcdocu.codmon = 1 then x-impnac = ccbcdocu.imptot * x-signo.
        if ccbcdocu.codmon = 2 then x-impusa = ccbcdocu.imptot * x-signo.
        if ccbcdocu.codmon = 1 then x-sdonac = ccbcdocu.sdoact * x-signo.
        if ccbcdocu.codmon = 2 then x-sdousa = ccbcdocu.sdoact * x-signo.
        x-imptot = x-impnac + x-impusa * f-tpocmb.
        x-sdotot = x-sdonac + x-sdousa * f-tpocmb.
/*        x-imptot = x-impnac + x-impusa * ccbcdocu.tpocmb.
 *         x-sdotot = x-sdonac + x-sdousa * ccbcdocu.tpocmb.*/
        ASSIGN
            w-report.Campo-F[1] = x-impnac
            w-report.Campo-F[2] = x-impusa
            w-report.Campo-F[3] = x-imptot
            w-report.Campo-F[4] = x-sdonac
            w-report.Campo-F[5] = x-sdousa
            w-report.Campo-F[6] = x-sdotot
            w-report.Campo-D[1] = ccbcdocu.fchdoc
            w-report.Campo-D[2] = f-fecini
            w-report.Campo-D[3] = f-fecfin
            w-report.Campo-C[1] = ccbcdocu.coddoc
            w-report.Campo-C[2] = ccbcdocu.nrodoc
            w-report.Campo-C[3] = GN-DIVI.DesDiv
            w-report.Campo-C[4] = ccbcdocu.codcli
            w-report.Campo-C[5] = ccbcdocu.coddiv
            w-report.Campo-C[6] = ccbcdocu.nomcli
            w-report.Campo-c[7] = ccbcdocu.dircli                    
            w-report.Campo-c[8] = ccbcdocu.ruccli
            w-report.Campo-c[9] = ccbcdocu.flgest.                    
    END.        
  END.
  
  /* POR EL MONTO MINIMO DE COMPRA */
  DEF VAR x-Anular AS CHAR.
  DEF VAR x-Total AS DECI.
  FOR EACH w-report WHERE w-report.task-no = s-task-no BREAK BY w-report.Llave-C:
    x-Total = w-report.campo-f[3].
    ACCUMULATE x-Total (TOTAL BY w-report.llave-c).
    IF LAST-OF(w-report.llave-c)
    THEN DO:
        IF (ACCUM TOTAL BY w-report.llave-c x-Total) < x-MtoMin
        THEN DO:
            IF x-Anular = '' 
            THEN x-Anular = w-report.llave-c.
            ELSE x-Anular = x-Anular + ',' + w-report.llave-c.
        END.
    END.
  END.
  DEF VAR i AS INT NO-UNDO.
  DO i = 1 TO NUM-ENTRIES(x-Anular):
    FOR EACH w-report WHERE w-report.task-no = s-task-no
            AND w-report.llave-c = ENTRY(i, x-Anular):
        DELETE w-report.
    END.            
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
  DISPLAY F-nrocar f-fecini f-fecfin F-unival x-MtoMin f-TpoCmb 
          RADIO-SET-Formato x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-nrocar f-fecini f-fecfin F-unival x-MtoMin f-TpoCmb 
         RADIO-SET-Formato BUTTON-2 Btn_Done 
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
DEF VAR x-Total AS DEC NO-UNDO.
DEF VAR x-Bonos AS INT NO-UNDO.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
/*chWorkSheet:Columns("A"):ColumnWidth = 10.
 * chWorkSheet:Columns("B"):ColumnWidth = 15.
 * chWorkSheet:Columns("C"):ColumnWidth = 35.
 * chWorkSheet:Columns("D"):ColumnWidth = 35.
 * chWorkSheet:Columns("E"):ColumnWidth = 20.
 * chWorkSheet:Columns("F"):ColumnWidth = 20.
 * chWorkSheet:Columns("G"):ColumnWidth = 20.
 * chWorkSheet:Columns("H"):ColumnWidth = 20.*/

/* ENCABEZADO */
FIND gn-card WHERE gn-card.nrocard = f-nrocar NO-LOCK NO-ERROR.

cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = gn-card.nomclie[1].
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Tarjeta No. ' + f-nrocar.
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = gn-card.dir[1].
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = STRING(f-fecini) + ' AL ' + STRING(f-fecfin).
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'T.C. ' + STRING(f-tpocmb).
t-column = t-column + 1.
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = 'Fecha'.
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = 'Doc'.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = 'Numero'.
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = 'Cliente'.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = 'Nombre'.
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = 'Importe en S/.'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = 'Importe en US$'.

FOR EACH w-report WHERE w-report.task-no = s-task-no BY w-report.campo-d[1]:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-d[1].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[1].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[2].
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.campo-c[4].
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[6].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
    cRange = "H" + cColumn.
    IF LOOKUP(TRIM(campo-c[1]), 'FAC,BOL,TCK') > 0
        AND w-report.campo-c[5] <> 'C' 
    THEN chWorkSheet:Range(cRange):Value = 'PENDIENTE'.
    ELSE chWorkSheet:Range(cRange):Value = ''.
    x-Total = x-Total + w-report.campo-f[3].
END.
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = 'Total en S/.'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = x-Total.
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = 'Valor unitario de vale de compra'.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = F-unival.
t-column = t-column + 2.
cColumn = STRING(t-Column).
cRange = "G" + cColumn.
x-Bonos = TRUNCATE(x-Total / f-unival / 100, 0).
chWorkSheet:Range(cRange):Value = x-Bonos.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


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

    RUN carga-temporal.
    HIDE FRAME f-mensaje NO-PAUSE.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* ¿TIENE ALGUN PENDIENTE? */
    FIND FIRST w-report WHERE
        task-no = s-task-no AND
        llave-c = f-nrocar AND
        LOOKUP(campo-c[1], 'FAC,BOL,N/D,TCK') > 0 AND
        campo-c[9] = 'P' NO-LOCK NO-ERROR.
    IF AVAILABLE w-report THEN s-Estado = "PENDIENTE".
    ELSE s-Estado = "".

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    CASE RADIO-SET-Formato:
        WHEN 1 THEN RB-REPORT-NAME = "Estado-Cuenta-Tarjeta-Conti-1a".
        WHEN 2 THEN RB-REPORT-NAME = "Estado-Cuenta-Tarjeta-Conti-2a".
    END CASE.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "vta\rbvta.prl"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.task-no = " + STRING(s-task-no)
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~nx-valuni = " + string(f-unival) +
            "~nf-fecini = " + string(f-fecini,"99/99/9999") +
            "~nf-fecfin = " + string(f-fecfin,"99/99/9999") +
            "~ns-estado = " + s-estado +
            "~ns-tpocmb = " + string(f-tpocmb).

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    RUN Borra-Temporal.

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
  ASSIGN
    f-fecfin = TODAY
    f-fecini = TODAY
    F-unival = 50.00.
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= f-fecfin NO-LOCK NO-ERROR.
  IF AVAILABLE GN-TCMB THEN f-tpocmb = gn-tcmb.venta.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

