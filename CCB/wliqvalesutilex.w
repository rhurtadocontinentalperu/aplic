&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

DEF VAR s-task-no AS INT NO-UNDO.

/* Variables para migrar a Excel */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

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
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 CcbCierr.HorCie CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-fchcie ~
 NO-LOCK ~
    BY CcbCierr.usuario ~
       BY CcbCierr.HorCie INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-fchcie ~
 NO-LOCK ~
    BY CcbCierr.usuario ~
       BY CcbCierr.HorCie INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 CcbCierr


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-3 BtnDone x-FchCie BROWSE-4 BUTTON-1 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-FchCie 

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
     SIZE 7 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "Marcar todos" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Desmarcar todos" 
     SIZE 17 BY 1.12.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 7 BY 1.73.

DEFINE VARIABLE x-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Cierre" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 wWin _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      CcbCierr.HorCie COLUMN-LABEL "Hora de cierre" FORMAT "x(5)":U
      CcbCierr.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 35 BY 19.42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-3 AT ROW 1.19 COL 40 WIDGET-ID 8
     BtnDone AT ROW 1.19 COL 47 WIDGET-ID 6
     x-FchCie AT ROW 1.38 COL 17 COLON-ALIGNED WIDGET-ID 2
     BROWSE-4 AT ROW 2.92 COL 3 WIDGET-ID 200
     BUTTON-1 AT ROW 6.58 COL 39 WIDGET-ID 10
     BUTTON-2 AT ROW 7.92 COL 39 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 58 BY 21.77 WIDGET-ID 100.


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
         TITLE              = "LIQUIDACION DE VALES UTILEX"
         HEIGHT             = 21.77
         WIDTH              = 58
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
/* BROWSE-TAB BROWSE-4 x-FchCie fMain */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.CcbCierr"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.CcbCierr.usuario|yes,INTEGRAL.CcbCierr.HorCie|yes"
     _Where[1]         = "CcbCierr.CodCia = s-codcia
 AND CcbCierr.FchCie = x-fchcie
"
     _FldNameList[1]   > INTEGRAL.CcbCierr.HorCie
"CcbCierr.HorCie" "Hora de cierre" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.CcbCierr.usuario
"CcbCierr.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* LIQUIDACION DE VALES UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* LIQUIDACION DE VALES UTILEX */
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
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* Marcar todos */
DO:
  {&BROWSE-NAME}:SELECT-ALL().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Desmarcar todos */
DO:
  {&BROWSE-NAME}:DESELECT-ROWS().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* Button 3 */
DO:
  ASSIGN x-FchCie.
  /* Excel */
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Excel.
  SESSION:SET-WAIT-STATE('').
  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

  MESSAGE 'Proceso terminado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-FchCie wWin
ON LEAVE OF x-FchCie IN FRAME fMain /* Fecha de Cierre */
DO:
  ASSIGN {&self-name}.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

DEF VAR k AS INT NO-UNDO.

s-task-no = 0.
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} WITH FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        /* Barremos los I/C */
        FOR EACH ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia
            AND ccbccaja.coddoc = "I/C"
            AND ccbccaja.flgcie = "C"
            AND ccbccaja.usuario = CcbCierr.usuario
            AND ccbccaja.horcie = CcbCierr.HorCie
            AND ccbccaja.fchcie = CcbCierr.FchCie,
            EACH vtadtickets NO-LOCK WHERE vtadtickets.codcia = s-codcia
            AND vtadtickets.codref = ccbccaja.coddoc
            AND vtadtickets.nroref = ccbccaja.nrodoc
            AND vtadtickets.coddiv = ccbccaja.coddiv,
            EACH ccbdcaja OF ccbccaja NO-LOCK,  /* Normalmente en UTILEX 1 solo registro */
            FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = ccbdcaja.codref
            AND ccbcdocu.nrodoc = ccbdcaja.nroref:
            IF s-task-no = 0 THEN DO:
                REPEAT:
                    s-task-no = RANDOM(1,999999).
                    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
                        THEN LEAVE.
                END.
            END.
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-I = s-codcia
                w-report.Llave-C = ccbccaja.usuario
                w-report.Llave-D = ccbccaja.fchdoc
                w-report.Campo-C[1] = ccbccaja.coddiv
                w-report.Campo-C[2] = vtadtickets.nrotck
                w-report.Campo-C[3] = ccbdcaja.nroref
                w-report.Campo-C[4] = VtaDTickets.CodPro
                w-report.Campo-C[5] = ccbcdocu.nomcli
                w-report.Campo-C[6] = ccbcdocu.codant
                w-report.Campo-F[1] = vtadtickets.valor
                w-report.Campo-F[2] = ccbdcaja.imptot.
            /* BUSCAMOS LA EMPRESA QUE RECIBIO LOS VALES */
            FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
                AND VtaTabla.Tabla = "VUTILEX"
                AND VtaTabla.Libre_c03 = "DETALLE"
                AND vtadtickets.nrotck >= VtaTabla.Llave_c5 
                AND vtadtickets.nrotck <= VtaTabla.Llave_c6
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla THEN w-report.Campo-C[4] = VtaTabla.Libre_c02.
        END.

    END.
END.

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
  DISPLAY x-FchCie 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-3 BtnDone x-FchCie BROWSE-4 BUTTON-1 BUTTON-2 
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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = CAPS(s-nomcia) + " - ANEXO DE VALES CONTINENTAL"
    chWorkSheet:Range("A2"):Value = "Division"
    chWorkSheet:Range("B2"):Value = "Doc"
    chWorkSheet:Range("C2"):Value = "Numero"
    chWorkSheet:Range("D2"):Value = "Fecha de Emision"
    chWorkSheet:Range("E2"):Value = "Usuario"
    chWorkSheet:Range("F2"):Value = "Producto"
    chWorkSheet:Range("G2"):Value = "Proveedor"
    chWorkSheet:Range("H2"):Value = "Nombre"
    chWorkSheet:Range("I2"):Value = "Ticket N°"
    chWorkSheet:Range("J2"):Value = "Importe"
    chWorkSheet:Range("K2"):Value = "Cierre"
    chWorkSheet:Columns("A"):NumberFormat = "@"
    chWorkSheet:Columns("C"):NumberFormat = "@"
    chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Columns("F"):NumberFormat = "@"
    chWorkSheet:Columns("G"):NumberFormat = "@"
    chWorkSheet:Columns("I"):NumberFormat = "@"
    chWorkSheet:Columns("K"):NumberFormat = "dd/mm/yyyy HH:MM"
    .

ASSIGN
    t-Row = 2.
DEF VAR k AS INT NO-UNDO.

s-task-no = 0.
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} WITH FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        /* Barremos los I/C */
        FOR EACH ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia
            AND ccbccaja.coddoc = "I/C"
            AND ccbccaja.flgcie = "C"
            AND ccbccaja.usuario = CcbCierr.usuario
            AND ccbccaja.horcie = CcbCierr.HorCie
            AND ccbccaja.fchcie = CcbCierr.FchCie,
            EACH vtadtickets NO-LOCK WHERE vtadtickets.codcia = s-codcia
            AND vtadtickets.codref = ccbccaja.coddoc
            AND vtadtickets.nroref = ccbccaja.nrodoc
            AND vtadtickets.coddiv = ccbccaja.coddiv,
            FIRST VtaCTickets OF Vtadtickets NO-LOCK,
            FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = Vtactickets.codpro:
            ASSIGN
                t-Column = 0
                t-Row    = t-Row + 1.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodDiv.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.CodRef.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.NroRef.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Fecha.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Usuario.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaCTickets.Producto.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaCTickets.CodPro.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = gn-prov.NomPro.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.NroTck.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = VtaDTickets.Valor.
            ASSIGN
                t-Column = t-Column + 1
                chWorkSheet:Cells(t-Row, t-Column):VALUE = DATETIME(STRING(Ccbccaja.fchcie) + ' ' + Ccbccaja.horcie).
        END.
    END.
END.

chExcelApplication:VISIBLE = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir wWin 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Carga-Temporal.
IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN DO:
    MESSAGE 'Fin de archivo' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DEFINE VAR p-pagina-final AS INTEGER.
DEFINE VAR p-pagina-inicial AS INTEGER.
DEFINE VAR p-salida-impresion AS INTEGER.
DEFINE VAR p-printer-name AS CHAR.
DEFINE VAR p-printer-port AS CHARACTER.
DEFINE VAR p-print-file AS CHAR.
DEFINE VAR p-nro-copias AS INTEGER.
DEFINE VAR p-orientacion AS INTEGER.
DEF VAR RB-REPORT-LIBRARY AS CHAR.
DEF VAR RB-REPORT-NAME AS CHAR .
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     

/* capturamos ruta inicial */
GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
ASSIGN
    p-nro-copias = 2
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
    RB-REPORT-NAME = "Liquidacion Diaria Vales Utilex"
    RB-INCLUDE-RECORDS = "O"
    RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

/* PARAMETROS */

RUN lib/_Imprime3 (p-pagina-final,
                   p-pagina-inicial,
                   p-salida-impresion,
                   p-printer-name,
                   p-printer-port,
                   p-print-file,
                   p-nro-copias,
                   p-orientacion,
                   RB-REPORT-LIBRARY,
                   RB-REPORT-NAME,
                   RB-INCLUDE-RECORDS,
                   RB-FILTER,
                   RB-OTHER-PARAMETERS).

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
  x-FchCie = TODAY - 1.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

