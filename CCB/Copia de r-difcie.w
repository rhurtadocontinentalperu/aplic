&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-user FILL-IN-fchcie FILL-IN-fchcie-1 ~
FILL-IN-user-1 Btn_OK Btn_Cancel Btn_OK-2 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-user FILL-IN-fchcie ~
FILL-IN-fchcie-1 FILL-IN-user-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Ca&ncelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/print-2.ico":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-fchcie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Cierre" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-fchcie-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-user AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-user-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 54.86 BY 2.85.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-user AT ROW 1.73 COL 14.86 COLON-ALIGNED
     FILL-IN-fchcie AT ROW 2.69 COL 14.86 COLON-ALIGNED
     FILL-IN-fchcie-1 AT ROW 2.69 COL 35.86 COLON-ALIGNED
     FILL-IN-user-1 AT ROW 1.73 COL 35.86 COLON-ALIGNED
     Btn_OK AT ROW 4.46 COL 3
     Btn_Cancel AT ROW 4.46 COL 27
     Btn_OK-2 AT ROW 4.46 COL 15 WIDGET-ID 2
     RECT-1 AT ROW 1.19 COL 2
     RECT-2 AT ROW 4.27 COL 2
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte Diferencia Cierre Caja"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte Diferencia Cierre Caja */
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

    RUN Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 D-Dialog
ON CHOOSE OF Btn_OK-2 IN FRAME D-Dialog /* Aceptar */
DO:

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-fchcie
            FILL-IN-fchcie-1
            FILL-IN-user
            FILL-IN-user-1.
        IF FILL-IN-user-1 = "" THEN FILL-IN-user-1 = "ZZZZZZZZ".
        IF FILL-IN-fchcie-1 = ? THEN FILL-IN-fchcie-1 = 12/31/3999.
    END.

    RUN Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    s-titulo = "REPORTE DIFERENCIA CIERRE DE CAJA".

    RUN Excel.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        DELETE w-report.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

    DEFINE VARIABLE username AS CHARACTER NO-UNDO.
    DEFINE VARIABLE monto_nac AS DECIMAL NO-UNDO.
    DEFINE VARIABLE monto_usa AS DECIMAL NO-UNDO.

    s-task-no = 0.

    /* Crea w-report */
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE
            w-report.task-no = s-task-no AND
            w-report.Llave-C = s-user-id NO-LOCK) THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id.
            LEAVE.
        END.
    END.

    FOR EACH CcbCierr WHERE
        CcbCierr.CodCia = s-Codcia AND
        CcbCierr.usuario >= FILL-IN-user AND
        CcbCierr.usuario <= FILL-IN-user-1 AND
        CcbCierr.FchCie >= FILL-IN-fchcie AND
        CcbCierr.FchCie <= FILL-IN-fchcie-1 AND
        CcbCierr.HorCie >= "" NO-LOCK
        BREAK BY CcbCierr.CodCia
        BY CcbCierr.usuario
        BY CcbCierr.FchCie
        BY CcbCierr.HorCie:
        IF FIRST-OF(CcbCierr.usuario) THEN DO:
            username = "".
            FIND DICTDB._user WHERE
                DICTDB._user._userid = CcbCierr.usuario
                NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._user THEN
                username = DICTDB._user._user-name.
        END.

        /* Carga lo declarado */
        FIND CCBDECL WHERE
            CCBDECL.CODCIA = S-CODCIA AND
            CCBDECL.USUARIO = CCBCIERR.USUARIO AND
            CCBDECL.FCHCIE = CCBCIERR.FCHCIE AND
            CCBDECL.HORCIE = CCBCIERR.HORCIE
            NO-LOCK NO-ERROR.
        IF AVAILABLE CCBDECL AND
            (CCBDECL.ImpNac[1] <> CcbCierr.ImpNac[1] OR
            CCBDECL.Impusa[1] <> CcbCierr.ImpUSA[1]) THEN DO:
            FIND FIRST w-report WHERE
                w-report.Task-No = s-task-no AND
                w-report.Llave-C = s-user-id AND
                w-report.Campo-C[1] = CcbCierr.usuario AND
                w-report.Campo-D[1] = CcbCierr.FchCie AND
                w-report.Campo-C[2] = CcbCierr.HorCie NO-ERROR.
            IF NOT AVAILABLE w-report THEN DO:
                CREATE w-report.
                ASSIGN
                    w-report.Task-No = s-task-no
                    w-report.Llave-C = s-user-id
                    w-report.Campo-C[1] = CcbCierr.usuario
                    w-report.Campo-D[1] = CcbCierr.FchCie
                    w-report.Campo-C[2] = CcbCierr.HorCie
                    w-report.Campo-C[3] = username.
            END.
            /* Soles */
            w-report.Campo-F[2] = w-report.Campo-F[2] + CCBDECL.ImpNac[1].
            /* Dólares */
            w-report.Campo-F[5] = w-report.Campo-F[5] + CCBDECL.ImpUSA[1].

            FOR EACH ccbccaja WHERE
                ccbccaja.codcia = s-codcia AND
                ccbccaja.coddoc = "I/C" AND
                ccbccaja.flgcie = "C" AND
                ccbccaja.fchcie = ccbcierr.fchcie AND
                ccbccaja.horcie = ccbcierr.horcie AND
                ccbccaja.flgest NE "A" AND
                ccbccaja.usuario = ccbcierr.Usuario
                NO-LOCK:
                /*
                monto_nac = 0.
                monto_usa = 0.
                IF CcbCCaja.ImpNac[1] <> 0 THEN
                */
                    monto_nac = CcbCCaja.ImpNac[1] - CcbCCaja.VueNac.
                    /*
                IF CcbCCaja.ImpUSA[1] <> 0 THEN
                */
                    monto_usa = CcbCCaja.ImpUSA[1] - CcbCCaja.VueUSA.
                /* Guarda Efectivo Recibido */
                w-report.Campo-F[1] = w-report.Campo-F[1] + monto_Nac.
                w-report.Campo-F[4] = w-report.Campo-F[4] + monto_USA.
            END.
        END.
    END.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        IF w-report.Campo-C[1] = "" THEN DO:
            DELETE w-report.
            NEXT.
        END.
        w-report.Campo-F[3] = w-report.Campo-F[1] - w-report.Campo-F[2].
        w-report.Campo-F[6] = w-report.Campo-F[4] - w-report.Campo-F[5].
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-user FILL-IN-fchcie FILL-IN-fchcie-1 FILL-IN-user-1 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-user FILL-IN-fchcie FILL-IN-fchcie-1 FILL-IN-user-1 Btn_OK 
         Btn_Cancel Btn_OK-2 RECT-1 RECT-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel D-Dialog 
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
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
chWorkSheet:Range("A1"):Value = "CAJERO".
chWorkSheet:Range("B1"):Value = "FECHA".
chWorkSheet:Range("C1"):Value = "HORA".
chWorkSheet:Range("D1"):Value = "SISTEMA S/.".
chWorkSheet:Range("E1"):Value = "DECLARADO S/.".
chWorkSheet:Range("F1"):Value = "DIFERENCIA S/.".
chWorkSheet:Range("G1"):Value = "SISTEMA US$".
chWorkSheet:Range("H1"):Value = "DECLARADO US$.".
chWorkSheet:Range("I1"):Value = "DIFERENCIA US$".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "dd/MM/yyyy".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".

FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
    AND w-report.Llave-C = s-user-id:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TRIM(w-report.campo-c[1]) + ' ' +
                                                    w-report.campo-c[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-d[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-c[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[1].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[2].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[3].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[4].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[5].
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = w-report.campo-f[6].
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            FILL-IN-fchcie
            FILL-IN-fchcie-1
            FILL-IN-user
            FILL-IN-user-1.
        IF FILL-IN-user-1 = "" THEN FILL-IN-user-1 = "ZZZZZZZZ".
        IF FILL-IN-fchcie-1 = ? THEN FILL-IN-fchcie-1 = 12/31/3999.
    END.

    RUN Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    s-titulo = "REPORTE DIFERENCIA CIERRE DE CAJA".

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Diferencia Cierre Caja"
        RB-INCLUDE-RECORDS = "O".
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'".
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo.

    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id:
        DELETE w-report.
    END.

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
  ASSIGN
    FILL-IN-FchCie:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY)
    FILL-IN-FchCie-1:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

