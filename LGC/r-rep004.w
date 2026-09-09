&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEF VAR s-task-no AS INT NO-UNDO.

DEF VAR x-Meses AS CHAR INIT 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-Periodo x-Mes-1 x-Mes-2 x-Tipo ~
x-CodMon Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-Mes-1 x-Mes-2 x-Tipo x-CodMon ~
x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\excel":U
     LABEL "Button 1" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE x-Mes-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Enero" 
     LABEL "Desde" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Mes-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Diciembre" 
     LABEL "Hasta" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 12 BY 1.92 NO-UNDO.

DEFINE VARIABLE x-Tipo AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cantidad", 1,
"Importe", 2
     SIZE 12 BY 1.92 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 8.88 COL 9
     x-Periodo AT ROW 1.77 COL 18 COLON-ALIGNED
     x-Mes-1 AT ROW 2.73 COL 18 COLON-ALIGNED
     x-Mes-2 AT ROW 3.69 COL 18 COLON-ALIGNED
     x-Tipo AT ROW 4.65 COL 20 NO-LABEL
     x-CodMon AT ROW 6.58 COL 20 NO-LABEL
     Btn_Done AT ROW 8.88 COL 17
     x-Mensaje AT ROW 10.81 COL 14 COLON-ALIGNED NO-LABEL
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.77 COL 13
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 4.85 COL 15
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "RESUMEN ANUAL DE SERVICIOS"
         HEIGHT             = 11.81
         WIDTH              = 71.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RESUMEN ANUAL DE SERVICIOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RESUMEN ANUAL DE SERVICIOS */
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
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
    x-CodMon x-Mes-1 x-Mes-2 x-Periodo x-Tipo.
  RUN Excel.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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
  DEF VAR FechaD AS DATE NO-UNDO.
  DEF VAR FechaH AS DATE NO-UNDO.
  DEF VAR Fecha  AS DATE NO-UNDO.
  DEF VAR x-NroMes AS INT NO-UNDO.
  DEF VAR x-TpoCmb AS DEC NO-UNDO.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN LEAVE.
  END.

  x-NroMes = LOOKUP(x-Mes-1, x-Meses).
  RUN bin/_DateIF (x-NroMes, x-Periodo, OUTPUT FechaD, OUTPUT Fecha).
  x-NroMes = LOOKUP(x-Mes-2, x-Meses).
  RUN bin/_DateIF (x-NroMes, x-Periodo, OUTPUT Fecha, OUTPUT FechaH).

  FOR EACH lg-coser WHERE lg-coser.codcia = s-codcia 
        AND lg-coser.CodDoc = 'O/S'
        AND lg-coser.Fchdoc >= fechad 
        AND lg-coser.fchdoc <= fechah 
        NO-LOCK:
    IF LOOKUP(TRIM(lg-coser.flgsit), 'X,A,V') > 0 THEN NEXT.
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'PROCESANDO: ' + STRING(lg-coser.nrodoc) + ' ' + STRING(lg-coser.fchdoc).
    ASSIGN
        x-NroMes = MONTH(lg-coser.fchdoc)
        x-TpoCmb = 1.
    FIND FIRST Gn-tcmb WHERE Gn-tcmb.fecha >= lg-coser.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-tcmb 
    THEN IF x-CodMon = 1 
            THEN x-TpoCmb = Gn-tcmb.compra.
            ELSE x-TpoCmb = Gn-tcmb.venta.
    FOR EACH lg-doser OF lg-coser NO-LOCK:
        FIND w-report WHERE w-report.Llave-I = s-codcia
            AND w-report.Llave-C = lg-doser.codser
            AND w-report.campo-c[20] = lg-doser.desser
            AND w-report.Task-No = s-task-no
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.task-no = s-task-no
                w-report.llave-c = lg-doser.codser
                w-report.llave-i = s-codcia
                w-report.campo-c[20] = lg-doser.desser 
                w-report.campo-c[21] = lg-doser.UndCmp.
        END.
        IF x-Tipo = 1 THEN DO:
            ASSIGN
                w-report.campo-f[x-NroMes] = w-report.campo-f[x-NroMes] + lg-doser.canaten.
        END.
        ELSE DO:
            IF x-CodMon = lg-coser.codmon
            THEN w-report.campo-f[x-NroMes] = w-report.campo-f[x-NroMes] + lg-doser.ImpTot.
            ELSE IF x-CodMon = 1
                    THEN w-report.campo-f[x-NroMes] = w-report.campo-f[x-NroMes] + lg-doser.ImpTot * x-TpoCmb.
                    ELSE w-report.campo-f[x-NroMes] = w-report.campo-f[x-NroMes] + lg-doser.ImpTot / x-TpoCmb.
        END.
    END.
  END.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY x-Periodo x-Mes-1 x-Mes-2 x-Tipo x-CodMon x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-Periodo x-Mes-1 x-Mes-2 x-Tipo x-CodMon Btn_Done 
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
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

RUN Carga-Temporal.
FIND FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK NO-ERROR.
IF NOT AVAILABLE w-report THEN DO:
    MESSAGE 'NO hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Codigo".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Unidad".

cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Enero".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Febrero".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Marzo".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Abril".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Mayo".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Junio".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Julio".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Agosto".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Setiembre".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Ocubre".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Noviembre".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Diciembre".

FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no:
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + w-report.llave-c.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[20].
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-c[21].

    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[1].
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[2].
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[3].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[4].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[5].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[6].
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[7].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[8].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[9].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[10].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[11].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = w-report.campo-f[12].
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.
MESSAGE 'PROCESO TERMINADO' VIEW-AS ALERT-BOX INFORMATION.

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
    x-Periodo:DELETE(1).
    FOR EACH cb-peri NO-LOCK WHERE cb-peri.codcia = s-codcia:   
        x-Periodo:ADD-LAST(STRING(cb-peri.periodo, '9999')).
    END.
    x-Periodo = YEAR(TODAY).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


