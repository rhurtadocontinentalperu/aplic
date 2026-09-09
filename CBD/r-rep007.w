&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
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

/* Definimos el temp-table de salida */
DEF TEMP-TABLE Detalle
    FIELD coddiv AS CHAR FORMAT 'x(60)' LABEL 'División'
    FIELD coddoc LIKE ccbcdocu.coddoc   LABEL 'Doc.'
    FIELD nrodoc LIKE ccbcdocu.nrodoc   LABEL 'Número'
    FIELD fchdoc LIKE ccbcdocu.fchdoc   LABEL 'Emisión'
    FIELD fmapgo AS CHAR FORMAT 'x(60)' LABEL 'Condición de Venta'
    FIELD flgest AS CHAR FORMAT 'x(20)' LABEL 'Estado'
    FIELD imptot AS DEC FORMAT '->>>,>>>,>>9.99'    LABEL 'Importe Total'
    FIELD codref LIKE ccbcdocu.coddoc   LABEL 'Ref.'
    FIELD nroref LIKE ccbcdocu.nrodoc   LABEL 'Número'
    FIELD fchref LIKE ccbcdocu.fchdoc   LABEL 'Emisión'
    INDEX Llave01 AS PRIMARY coddiv coddoc nrodoc.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division COMBO-BOX-Documento ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-1 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division COMBO-BOX-Documento ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "División" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Documento AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "FAC","BOL" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-Division AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-Documento AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-1 AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Fecha-2 AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 5.31 COL 77 WIDGET-ID 10
     BtnDone AT ROW 5.31 COL 84 WIDGET-ID 12
     FILL-IN-Mensaje AT ROW 5.85 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96.14 BY 6.35 WIDGET-ID 100.


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
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE FACTURAS VS GUIAS DE REMISION"
         HEIGHT             = 6.35
         WIDTH              = 96.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* REPORTE DE FACTURAS VS GUIAS DE REMISION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* REPORTE DE FACTURAS VS GUIAS DE REMISION */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Button 1 */
DO:
  ASSIGN
      COMBO-BOX-Division COMBO-BOX-Documento FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  RUN Carga-Temporal.
  FIND FIRST Detalle NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Detalle THEN DO:
      MESSAGE 'No hay registros a imprimir' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.

/*   FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'GENERANDO ARCHIVO EXCEL'. */
/*   DEF VAR pArchivo AS CHAR.                                                        */
/*   DEF VAR pOptions AS CHAR.                                                        */
/*   ASSIGN                                                                           */
/*       pOptions = "FileType:XLS" + CHR(1) +                                         */
/*                 "ExcelAlert:false" + CHR(1) +                                      */
/*                 "ExcelVisible:false".                                              */
/*   RUN lib/tt-file (TEMP-TABLE Detalle:HANDLE, pArchivo, pOptions).                 */
/*   FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.                        */
/*   MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.                       */

  RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.
DEF BUFFER B-DOCU FOR Ccbcdocu.
SESSION:SET-WAIT-STATE('GENERAL').
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
    AND (COMBO-BOX-Division = "Todos" OR gn-divi.coddiv = ENTRY(1, COMBO-BOX-Division, ' - ')):
    FOR EACH Ccbcdocu WHERE ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddiv = gn-divi.coddiv
        AND Ccbcdocu.coddoc = COMBO-BOX-Documento
        AND Ccbcdocu.fchdoc >= FILL-IN-Fecha-1
        AND Ccbcdocu.fchdoc <= FILL-IN-Fecha-2
        AND Ccbcdocu.flgest <> "A":
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            'PROCESANDO ' + Ccbcdocu.coddiv + ' ' + STRING (Ccbcdocu.fchdoc).
        CREATE Detalle.
        ASSIGN
            Detalle.coddiv = gn-divi.coddiv + ' ' + GN-DIVI.DesDiv
            Detalle.coddoc = Ccbcdocu.coddoc
            Detalle.nrodoc = Ccbcdocu.nrodoc
            Detalle.fchdoc = Ccbcdocu.fchdoc
            Detalle.fmapgo = Ccbcdocu.fmapgo
            Detalle.imptot = Ccbcdocu.imptot
            Detalle.codref = Ccbcdocu.codref
            Detalle.nroref = Ccbcdocu.nroref.
        FIND gn-convt WHERE gn-convt.codig = Ccbcdocu.fmapgo NO-LOCK NO-ERROR.
        IF AVAILABLE gn-convt THEN Detalle.fmapgo = gn-ConVt.Codig + ' ' + gn-ConVt.Nombr.
        FIND b-docu WHERE b-docu.codcia = ccbcdocu.codcia
            AND b-docu.coddoc = ccbcdocu.codref
            AND b-docu.nrodoc = ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE b-docu THEN detalle.fchref = b-docu.fchdoc.
        CASE Ccbcdocu.flgest:
            WHEN 'P' THEN Detalle.flgest = 'PENDIENTE'.
            WHEN 'C' THEN Detalle.flgest = 'CANCELADO'.
            OTHERWISE Detalle.flgest = Ccbcdocu.flgest.
        END CASE.
        IF Detalle.codref <> 'G/R' THEN DO:
            FIND b-docu WHERE b-docu.codcia = s-codcia
                AND b-docu.coddoc = 'G/R'
                AND b-docu.codref = ccbcdocu.coddoc
                AND b-docu.nroref = ccbcdocu.nrodoc
                AND b-docu.flgest <> "A"
                NO-LOCK NO-ERROR.
            ASSIGN
                Detalle.codref = ''
                Detalle.nroref = ''
                Detalle.fchref = ?.
            IF AVAILABLE b-docu THEN
                ASSIGN
                    Detalle.codref = b-docu.coddoc
                    Detalle.nroref = b-docu.nrodoc
                    Detalle.fchref = b-docu.fchdoc.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-Division COMBO-BOX-Documento FILL-IN-Fecha-1 FILL-IN-Fecha-2 
          FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-Division COMBO-BOX-Documento FILL-IN-Fecha-1 FILL-IN-Fecha-2 
         BUTTON-1 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:Range("A1"):VALUE = "Division".
chWorkSheet:Range("B1"):VALUE = "Doc".
chWorkSheet:Range("C1"):VALUE = "Numero".
chWorkSheet:Range("D1"):VALUE = "Emision".
chWorkSheet:Range("E1"):VALUE = "Condicion de Venta".
chWorkSheet:Range("F1"):VALUE = "Estado".
chWorkSheet:Range("G1"):VALUE = "Importe Total".
chWorkSheet:Range("H1"):VALUE = "Ref".
chWorkSheet:Range("I1"):VALUE = "Numero".
chWorkSheet:Range("J1"):VALUE = "Emision".

chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/MM/yyyy".
chWorkSheet:COLUMNS("J"):NumberFormat = "dd/MM/yyyy".
chWorkSheet = chExcelApplication:Sheets:Item(1).

FOR EACH detalle NO-LOCK:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).      
    cRange = "A" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.coddiv.
    cRange = "B" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.coddoc.
    cRange = "C" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.nrodoc.
    cRange = "D" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.fchdoc.
    cRange = "E" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.fmapgo.
    cRange = "F" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.flgest.
    cRange = "G" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.imptot.
    cRange = "H" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.codref.
    cRange = "I" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.nroref.
    cRange = "J" + cColumn.   
    chWorkSheet:Range(cRange):Value = detalle.fchref.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
      FILL-IN-Fecha-2 = TODAY.
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
      COMBO-BOX-Division:ADD-LAST(gn-divi.coddiv + ' - ' + GN-DIVI.DesDiv)  IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

