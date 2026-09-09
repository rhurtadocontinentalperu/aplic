&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

/* VARIABLES A USAR */
/* Variables compartidas */
DEFINE new SHARED VAR s-pagina-final AS INTEGER.
DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
DEFINE new SHARED VAR s-printer-name AS CHAR.
DEFINE new SHARED VAR s-print-file AS CHAR.
DEFINE new SHARED VAR s-nro-copias AS INTEGER.
DEFINE new SHARED VAR s-orientacion AS INTEGER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/ccb/rbccb.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Pre-cierre de caja".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-fchcie NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCierr


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 X-FchCie Btn_OK ~
Btn_Cancel BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS X-FchCie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Ca&ncelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE X-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de cierre" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.43 BY 6.19.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.43 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14.86 BY 7.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      CcbCierr.FchCie COLUMN-LABEL "Fecha de cierre"
      CcbCierr.HorCie
      CcbCierr.usuario COLUMN-LABEL "          Cajero" FORMAT "x(15)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 33.72 BY 4.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-FchCie AT ROW 1.38 COL 14.57 COLON-ALIGNED
     Btn_OK AT ROW 3.04 COL 40.14
     Btn_Cancel AT ROW 4.23 COL 40.14
     BROWSE-2 AT ROW 2.77 COL 2.72
     RECT-1 AT ROW 2.46 COL 1.14
     RECT-2 AT ROW 1.04 COL 1.14
     RECT-3 AT ROW 1.04 COL 38.72
     "Haga ~"click~" en o los cajeros a imprimir" VIEW-AS TEXT
          SIZE 33.43 BY .5 AT ROW 7.69 COL 2.86
          FONT 6
     SPACE(17.70) SKIP(0.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Cierre de caja"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
/* BROWSE-TAB BROWSE-2 Btn_Cancel D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.CcbCierr"
     _Where[1]         = "integral.CcbCierr.CodCia = s-codcia
 AND integral.CcbCierr.FchCie = x-fchcie"
     _FldNameList[1]   > integral.CcbCierr.FchCie
"FchCie" "Fecha de cierre" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[2]   = integral.CcbCierr.HorCie
     _FldNameList[3]   > integral.CcbCierr.usuario
"usuario" "          Cajero" "x(15)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Cierre de caja */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE "Marque el o los cajeros a imprimir" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-FchCie D-Dialog
ON LEAVE OF X-FchCie IN FRAME D-Dialog /* Fecha de cierre */
OR "RETURN" OF X-FchCie
DO:
  ASSIGN {&SELF-NAME}.
  OPEN QUERY {&BROWSE-NAME} FOR EACH CcbCierr
    WHERE CcbCierr.CodCia = s-codcia
    AND CcbCierr.FchCie = x-fchcie SHARE-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR i AS INT NO-UNDO.
  s-subtit = "CAJERO(S): ".
  DO WITH FRAME D-Dialog:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) 
        THEN DO:
            s-subtit = s-subtit + ccbcierr.Usuario + " " + ccbcierr.horcie + ",".
            FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia 
                               AND  LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0 
                               AND  ccbccaja.flgcie = "C" 
                               AND  ccbccaja.fchcie = ccbcierr.fchcie 
                               AND  ccbccaja.horcie = ccbcierr.horcie 
                               AND  ccbccaja.flgest NE "A" 
                               AND  ccbccaja.usuario = ccbcierr.Usuario 
                              NO-LOCK:
              IF s-task-no = 0
              THEN REPEAT:
                  s-task-no = RANDOM(1, 999999).
                  IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                                                  AND  w-report.Llave-C = s-user-id 
                                                 NO-LOCK)
                  THEN LEAVE.
              END.
              CREATE w-report.
              ASSIGN
                  w-report.Task-No = s-task-no
                  w-report.Llave-C = s-user-id
                  w-report.Campo-I[1] = s-codcia 
                  w-report.Campo-C[1] = ccbccaja.coddoc
                  w-report.Campo-C[2] = ccbccaja.nrodoc.
            END.
        END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY X-FchCie 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 RECT-3 X-FchCie Btn_OK Btn_Cancel BROWSE-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
                       AND  w-report.Llave-C = s-user-id 
                      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
    
  /* test de impresion */
  s-titulo = "REPORTE DE CIERRE DE CAJA DEL " + STRING(X-FchCie).
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " AND w-report.Llave-C = '" + s-user-id + "'".  
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-titulo = " + s-titulo +
                        "~ns-subtit = " + s-subtit.
  
  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
    
  DELETE FROM w-report WHERE w-report.task-no = s-task-no 
                        AND  w-report.Llave-C = s-user-id.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN x-fchcie:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCierr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


