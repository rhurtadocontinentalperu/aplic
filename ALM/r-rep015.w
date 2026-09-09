&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME NoiNwWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS NoiNwWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF VAR s-task-no AS INT INIT 0 NO-UNDO.
DEF SHARED VAR s-nomcia AS CHAR.

/*DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
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
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.*/

DEFINE FRAME F-Mensajes
     /*IMAGE-1 AT ROW 1.5 COL 5*/
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16
          FONT 8
     "por favor..." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19
          FONT 8
     "F10 = Cancela Reporte" VIEW-AS TEXT
          SIZE 21 BY 1 AT ROW 3.5 COL 12
          FONT 8          
    SPACE(10.28) SKIP(0.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Cargando...".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 Btn_Excel BtnDone x-CodDiv ~
x-codprov x-FchDoc-1 x-FchDoc-2 x-FlgEst 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-codprov x-FchDoc-1 x-FchDoc-2 ~
x-FlgEst f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR NoiNwWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "./img/exit.ico":U
     LABEL "&Done" 
     SIZE 9 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Excel 
     IMAGE-UP FILE "img\excel":U
     LABEL "Excel" 
     SIZE 9 BY 2.15 TOOLTIP "Salida a Excel".

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "./img/print-2.ico":U
     LABEL "Button 1" 
     SIZE 10 BY 2.15.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE x-codprov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FlgEst AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", "",
"Pendientes", "P",
"Cancelados", "C",
"Anulados", "A"
     SIZE 12 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-1 AT ROW 1.27 COL 51 WIDGET-ID 12
     Btn_Excel AT ROW 1.27 COL 62 WIDGET-ID 2
     BtnDone AT ROW 1.27 COL 72 WIDGET-ID 14
     x-CodDiv AT ROW 1.54 COL 22 COLON-ALIGNED WIDGET-ID 18
     x-codprov AT ROW 2.62 COL 22 COLON-ALIGNED WIDGET-ID 32
     x-FchDoc-1 AT ROW 3.73 COL 22 COLON-ALIGNED WIDGET-ID 8
     x-FchDoc-2 AT ROW 3.73 COL 42 COLON-ALIGNED WIDGET-ID 10
     x-FlgEst AT ROW 4.88 COL 24 NO-LABEL WIDGET-ID 24
     f-Mensaje AT ROW 9.08 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.12 COL 18 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 9.58
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW NoiNwWin ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE COMPROBANTES Y HOJAS DE RUTA"
         HEIGHT             = 9.58
         WIDTH              = 80.57
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB NoiNwWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW NoiNwWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(NoiNwWin)
THEN NoiNwWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NoiNwWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NoiNwWin NoiNwWin
ON END-ERROR OF NoiNwWin /* REPORTE DE COMPROBANTES Y HOJAS DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NoiNwWin NoiNwWin
ON WINDOW-CLOSE OF NoiNwWin /* REPORTE DE COMPROBANTES Y HOJAS DE RUTA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone NoiNwWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel NoiNwWin
ON CHOOSE OF Btn_Excel IN FRAME fMain /* Excel */
DO:
    SESSION:SET-WAIT-STATE("COMPILER").
    RUN Asigna-Variables.
    RUN Excel. /*RUN Imprime.*/
    RUN Inicializa-Variables.
    SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 NoiNwWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 x-FlgEst X-codprov.
   RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK NoiNwWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects NoiNwWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables NoiNwWin 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN x-FchDoc-1 x-FchDoc-2 x-FlgEst x-CodProv.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal NoiNwWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF s-task-no = 0 THEN DO:
        CORRELATIVO:
        REPEAT:
            s-task-no = RANDOM(1,999999).
            FIND FIRST w-report WHERE task-no = s-task-no NO-LOCK NO-ERROR.
            IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
        END.
    END.
                      
    FOR EACH LG-COCmp WHERE LG-COCmp.codcia = s-codcia
        AND LG-COCmp.flgsit = x-FlgEst 
        AND LG-COCmp.CodPro BEGINS x-codprov        
        AND LG-COCmp.Fchdoc >= x-FchDoc-1 
        AND LG-COCmp.Fchdoc <= x-FchDoc-2 NO-LOCK,
        EACH LG-DOCmp OF LG-COCmp NO-LOCK:

        FIND FIRST w-report WHERE w-report.task-no = s-task-no
            AND w-report.llave-i = lg-cocmp.nrodoc
            AND w-report.campo-c[1] = lg-docmp.codmat NO-LOCK NO-ERROR.

        IF NOT AVAIL w-report THEN DO:
            CREATE w-report.
            ASSIGN
                Task-No    = s-task-no
                llave-i    = lg-cocmp.nrodoc
                campo-i[1] = lg-docmp.codcia
                campo-c[1] = lg-docmp.codmat 
                campo-c[2] = lg-cocmp.codpro
                campo-c[3] = lg-docmp.undcmp
                campo-f[1] = lg-docmp.canped
                campo-f[2] = lg-docmp.canate
                campo-d[1] = lg-cocmp.FchEnt 
                campo-d[2] = lg-cocmp.FchVto
                campo-d[3] = lg-cocmp.FchAte.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI NoiNwWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(NoiNwWin)
  THEN DELETE WIDGET NoiNwWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI NoiNwWin  _DEFAULT-ENABLE
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
  DISPLAY x-CodDiv x-codprov x-FchDoc-1 x-FchDoc-2 x-FlgEst f-Mensaje 
      WITH FRAME fMain IN WINDOW NoiNwWin.
  ENABLE BUTTON-1 Btn_Excel BtnDone x-CodDiv x-codprov x-FchDoc-1 x-FchDoc-2 
         x-FlgEst 
      WITH FRAME fMain IN WINDOW NoiNwWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW NoiNwWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel NoiNwWin 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/*
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

DEFINE BUFFER   b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER   b-di-rutad FOR di-rutad.
DEFINE BUFFER   b-di-rutac FOR di-rutac.
DEFINE VARIABLE f-Estado   AS CHARACTER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
chWorkSheet:COLUMNS("B"):ColumnWidth = 10.
chWorkSheet:COLUMNS("C"):ColumnWidth = 11.
chWorkSheet:COLUMNS("D"):ColumnWidth = 11.
chWorkSheet:COLUMNS("E"):ColumnWidth = 11.
chWorkSheet:COLUMNS("F"):ColumnWidth = 40.
chWorkSheet:COLUMNS("G"):ColumnWidth = 10.
chWorkSheet:COLUMNS("H"):ColumnWidth = 11.
chWorkSheet:COLUMNS("I"):ColumnWidth = 11.

chWorkSheet:Range("A1: J2"):FONT:Bold = TRUE.
chWorkSheet:Range("A1"):VALUE =
    "CONSULTA DE PEDIDOS" +
    " DEL " + STRING(x-FchDoc-1) + " AL " + STRING(x-FchDoc-2).
chWorkSheet:Range("A2"):VALUE = "Cod ".
chWorkSheet:Range("B2"):VALUE = "Número".
chWorkSheet:Range("C2"):VALUE = "Emisión".
chWorkSheet:Range("D2"):VALUE = "Estado".
chWorkSheet:Range("E2"):VALUE = "Cliente".
chWorkSheet:Range("F2"):VALUE = "Nombre".
chWorkSheet:Range("G2"):VALUE = "H/Ruta".
chWorkSheet:Range("H2"):VALUE = "Fecha".
chWorkSheet:Range("I2"):VALUE = "Cond. Venta".

chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

COMPROBANTES:
FOR EACH b-ccbcdocu NO-LOCK WHERE b-ccbcdocu.codcia = s-codcia
      AND b-ccbcdocu.coddiv = x-coddiv
      AND (x-coddoc = 'Todos' OR b-ccbcdocu.coddoc = x-coddoc)
      AND LOOKUP(b-ccbcdocu.coddoc, 'FAC,BOL') > 0
      AND b-ccbcdocu.fchdoc >= x-fchdoc-1
      AND b-ccbcdocu.fchdoc <= x-fchdoc-2
      AND b-ccbcdocu.flgest <> 'A' BREAK BY
      b-ccbcdocu.NroDoc :
      IF x-FlgEst <> '' THEN DO:
          IF b-Ccbcdocu.flgest <> x-flgest THEN NEXT COMPROBANTES.
      END.
      IF  x-fmapgo <> 'Todos' THEN DO: 
          IF b-ccbcdocu.fmapgo <> SUBSTRING(x-fmapgo,1,3) THEN NEXT COMPROBANTES.
      END.

      CASE b-ccbcdocu.FlgEst:
            WHEN "A" THEN f-Estado = "ANULADO".
            WHEN "P" THEN f-Estado = "PENDIENTE".
            WHEN "C" THEN f-Estado = "CANCELADO".
      END CASE.
  
      FIND FIRST b-di-rutad WHERE b-di-rutad.codcia = b-ccbcdocu.codcia
          AND b-di-rutad.coddoc = 'H/R'
          AND b-di-rutad.codref = b-ccbcdocu.coddoc
          AND b-di-rutad.nroref = b-ccbcdocu.nrodoc
          AND b-di-rutad.flgest = 'C'     /* Entregado */
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b-di-rutad THEN NEXT.
      FIND FIRST b-di-rutac OF b-di-rutad NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b-di-rutac THEN NEXT.

        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.NroDoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.FchDoc.
        cRange = "D" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = f-Estado.                      
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.CodCli. 
        cRange = "F" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.NomCli. 
        cRange = "G" + cColumn.                                                
        chWorkSheet:Range(cRange):Value = b-di-rutad.NroDoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = b-di-rutac.FchDoc.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = b-ccbcdocu.fmapgo.

/*        DISPLAY b-ccbcdocu.NroDoc @ Fi-Mensaje LABEL "Número de Pedido"
                FORMAT "X(9)" LABEL " Procesando documento "
                WITH FRAME F-Proceso.
        READKEY PAUSE 0.
        IF LASTKEY = KEYCODE("F10") THEN LEAVE COMPROBANTES.
END.

HIDE FRAME F-Proceso NO-PAUSE.*/

 DISPLAY
        b-ccbcdocu.NroDoc FORMAT "X(9)" LABEL "   Procesando documento"
        WITH FRAME f-mensajes.
    READKEY PAUSE 0.
    IF LASTKEY = KEYCODE("F10") THEN LEAVE COMPROBANTES.

END.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject NoiNwWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir NoiNwWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */
   
RUN Carga-Temporal.

RB-REPORT-NAME = 'Comprobantes Entregados'.
GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "alm/rbalm.prl".
RB-INCLUDE-RECORDS = 'O'.
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.

RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

   FOR EACH w-report WHERE task-no = s-task-no:
       DELETE w-report.
   END.

s-task-no = 0. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables NoiNwWin 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN x-FchDoc-1 x-FchDoc-2 x-FlgEst x-CodProv.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject NoiNwWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      x-FchDoc-1 = TODAY - DAY(TODAY) + 1
      x-FchDoc-2 = TODAY.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

