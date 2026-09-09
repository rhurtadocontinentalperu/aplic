&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
DEF SHARED VAR s-aplic-id AS CHAR.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

DEFINE TEMP-TABLE wrk_user NO-UNDO
    FIELDS wrk_userid LIKE CcbcCaja.Usuario COLUMN-LABEL "Usuario"
    FIELDS wrk_name AS CHARACTER FORMAT "x(24)" LABEL "Nombre"
    INDEX wrk_user IS PRIMARY wrk_userid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-user

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES wrk_user

/* Definitions for BROWSE BROWSE-user                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-user wrk_user.wrk_userid wrk_user.wrk_name   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-user   
&Scoped-define SELF-NAME BROWSE-user
&Scoped-define QUERY-STRING-BROWSE-user FOR EACH wrk_user
&Scoped-define OPEN-QUERY-BROWSE-user OPEN QUERY {&SELF-NAME} FOR EACH wrk_user.
&Scoped-define TABLES-IN-QUERY-BROWSE-user wrk_user
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-user wrk_user


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-user}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-user Btn_OK Btn_Cancel FILL-IN-date ~
RECT-65 RECT-66 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-date 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-date AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 6.15.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-user FOR 
      wrk_user SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-user
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-user D-Dialog _FREEFORM
  QUERY BROWSE-user DISPLAY
      wrk_user.wrk_userid
    wrk_user.wrk_name
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 28.57 BY 5.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-user AT ROW 3.12 COL 5
     Btn_OK AT ROW 6.38 COL 37
     Btn_Cancel AT ROW 7.58 COL 37
     FILL-IN-date AT ROW 1.38 COL 8 COLON-ALIGNED
     "Seleccione uno o mas cajeros" VIEW-AS TEXT
          SIZE 26 BY .5 AT ROW 9.08 COL 3
          FONT 6
     RECT-65 AT ROW 2.73 COL 3
     RECT-66 AT ROW 1.19 COL 3
     SPACE(14.42) SKIP(7.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de pre-cierre de caja"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


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
/* BROWSE-TAB BROWSE-user 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-user
/* Query rebuild information for BROWSE BROWSE-user
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH wrk_user.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-user */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de pre-cierre de caja */
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

    IF INPUT FILL-IN-date = ? THEN DO:
        MESSAGE
            "Ingrese la fecha"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE
            "Seleccione uno o mas Usuarios"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.

    RUN proc_Imprimir.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-date D-Dialog
ON LEAVE OF FILL-IN-date IN FRAME D-Dialog /* Fecha */
DO:

    IF FILL-IN-date:SCREEN-VALUE = STRING(FILL-IN-date,"99/99/9999") THEN RETURN.

    ASSIGN FILL-IN-date.
    RUN proc_CargaUsuarios.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-user
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
  DISPLAY FILL-IN-date 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-user Btn_OK Btn_Cancel FILL-IN-date RECT-65 RECT-66 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
    FILL-IN-date = TODAY.
    RUN proc_CargaUsuarios.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Carga-Temporal D-Dialog 
PROCEDURE proc_Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i AS INT NO-UNDO.
    DEFINE VARIABLE j AS INT NO-UNDO.
    DEFINE VARIABLE pos AS INT NO-UNDO.
    DEFINE VARIABLE forma_pago AS CHARACTER NO-UNDO.
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

    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /* Fuerza el indice llave09 */
        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv = s-coddiv AND
            LOOKUP(ccbccaja.coddoc,"I/C,E/C") NE 0 AND
            ccbccaja.usuario = wrk_user.wrk_userid AND
            ccbccaja.flgcie = "P" AND
            ccbccaja.FchDoc = FILL-IN-date AND
            ccbccaja.flgest NE "A" NO-LOCK:
            DO j = 1 TO 11:
                CASE j:
                    WHEN 1 THEN forma_pago = "EFECTIVO".
                    WHEN 2 THEN forma_pago = "CHEQUES DEL DIA".
                    WHEN 3 THEN forma_pago = "CHEQUES DIFERIDOS".
                    WHEN 4 THEN forma_pago = "POS".                                 /*"TARJETA DE CREDITO".*/
                    WHEN 5 THEN forma_pago = "B.DEPOS. / VTAS WHATASAPP".     /*"BOLETAS DE DEPOSITO".*/
                    WHEN 6 THEN forma_pago = "NOTAS DE CREDITO".
                    WHEN 7 THEN forma_pago = "ANTICIPOS".
                    WHEN 8 THEN forma_pago = "RAPPI PLATAFORMA VIRTUAL".
                    WHEN 9 THEN forma_pago = "RETENCIONES".
                    WHEN 10 THEN forma_pago = "VALES DE CONSUMO".
                    WHEN 11 THEN forma_pago = "TARJETA PUNTOS".
                END CASE.
                IF j = 11 THEN DO:
                    pos = j.
                    IF CcbCCaja.TarPtoNac <> 0 OR CcbCCaja.TarPtoUsa <> 0 THEN DO:
                        IF ccbccaja.coddoc = "I/C" THEN DO:
                            pos = pos * 10.
                            FIND FIRST w-report WHERE
                                w-report.Task-No = s-task-no AND
                                w-report.Llave-C = s-user-id AND
                                w-report.Campo-C[1] = ccbccaja.usuario AND
                                w-report.Campo-C[2] = ccbccaja.coddoc AND
                                w-report.Campo-I[1] = pos
                                NO-ERROR.
                            IF NOT AVAILABLE w-report THEN DO:
                                CREATE w-report.
                                ASSIGN
                                    w-report.Task-No = s-task-no
                                    w-report.Llave-C = s-user-id
                                    w-report.Campo-C[1] = ccbccaja.usuario
                                    w-report.Campo-C[2] = ccbccaja.coddoc
                                    w-report.Campo-I[1] = pos
                                    w-report.Campo-C[3] = forma_pago
                                    w-report.Campo-C[4] = wrk_user.wrk_name.
                            END.
                            monto_nac = CcbCCaja.TarPtoNac - CcbCCaja.VueNac.
                            monto_usa = CcbCCaja.TarPtoUsa - CcbCCaja.VueUSA.
                            w-report.Campo-F[1] = w-report.Campo-F[1] + monto_nac.
                            w-report.Campo-F[2] = w-report.Campo-F[2] + monto_usa.
                        END.
                    END.
                    NEXT.
                END.
                IF CcbCCaja.ImpNac[j] <> 0 OR CcbCCaja.Impusa[j] <> 0 THEN DO:
                    pos = j.

                    IF ccbccaja.coddoc = "I/C" THEN DO:
                        IF pos > 1 THEN pos = pos * 10.
                        ELSE CASE ccbccaja.tipo:
                            WHEN "SENCILLO" THEN DO:
                                forma_pago = "EFECTIVO - SENCILLO".
                                pos = 1.
                            END.
                            WHEN "ANTREC" THEN DO:
                                forma_pago = "EFECTIVO - ANTICIPO".
                                pos = 2.
                            END.
                            WHEN "CANCELACION" THEN DO:
                                forma_pago = "EFECTIVO - CANCELACIÓN".
                                pos = 3.
                            END.
                            WHEN "MOSTRADOR" THEN DO:
                                forma_pago = "EFECTIVO - MOSTRADOR".
                                pos = 4.
                            END.
                            OTHERWISE DO:
                                forma_pago = "OTROS".
                                pos = 20.
                            END.
                        END CASE.
                        IF j = 8 THEN DO:   /* RAPPI */
                            pos = 8.
                        END.
                        IF j = 5 THEN DO:   /* Venta Whatsapp o BD */
                            forma_pago = "BOLETAS DE DEPOSITO".
                            IF ccbccaja.codbco[j] = 'PPE' OR ccbccaja.codbco[j] = 'PLN' THEN DO:
                                /* Venta WhatsApp */
                                forma_pago = "VTAS WHATASAPP".
                                pos = 39.
                            END.
                            
                        END.
                    END.

                    /* Detalla los E/C */
                    IF ccbccaja.coddoc = "E/C" THEN DO:
                        CASE ccbccaja.tipo:
                            WHEN "REMEBOV" THEN DO:
                                forma_pago = "REMESA A BÓVEDA".
                                pos = 1.
                            END.
                            WHEN "REMECJC" THEN DO:
                                forma_pago = "REMESA A CAJA CENTRAL".
                                pos = 2.
                            END.
                            WHEN "ANTREC" THEN DO:
                                forma_pago = "DEVOLUCIÓN EFECTIVO (ANTICIPO)".
                                pos = 3.
                            END.
                            WHEN "DEVONC" THEN DO:
                                forma_pago = "DEVOLUCIÓN EFECTIVO (N/C)".
                                pos = 4.
                            END.
                            WHEN "SENCILLO" THEN DO:
                                forma_pago = "SENCILLO".
                                pos = 5.
                            END.
                            OTHERWISE DO:
                                forma_pago = "OTROS".
                                pos = 20.
                            END.
                        END CASE.
                    END.
                    FIND FIRST w-report WHERE
                        w-report.Task-No = s-task-no AND
                        w-report.Llave-C = s-user-id AND
                        w-report.Campo-C[1] = ccbccaja.usuario AND
                        w-report.Campo-C[2] = ccbccaja.coddoc AND
                        w-report.Campo-I[1] = pos
                        NO-ERROR.
                    IF NOT AVAILABLE w-report THEN DO:
                        CREATE w-report.
                        ASSIGN
                            w-report.Task-No = s-task-no
                            w-report.Llave-C = s-user-id
                            w-report.Campo-C[1] = ccbccaja.usuario
                            w-report.Campo-C[2] = ccbccaja.coddoc
                            w-report.Campo-I[1] = pos
                            w-report.Campo-C[3] = forma_pago
                            w-report.Campo-C[4] = wrk_user.wrk_name.
                    END.
                    IF j <> 4 THEN DO:
                        monto_nac = CcbCCaja.ImpNac[j] - CcbCCaja.VueNac.
                        monto_usa = CcbCCaja.ImpUSA[j] - CcbCCaja.VueUSA.
                    END.
                    ELSE DO:
                        monto_nac = CcbCCaja.ImpNac[j].
                        monto_usa = CcbCCaja.ImpUSA[j].
                    END.
                    w-report.Campo-F[1] = w-report.Campo-F[1] + monto_nac.
                    w-report.Campo-F[2] = w-report.Campo-F[2] + monto_usa.
                END.
            END. /* DO j = 1 TO... */
        END. /* FOR EACH ccbccaja... */
    END.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Campo-C[1] = "":
        DELETE w-report.
    END.

END PROCEDURE.

/*
                    WHEN 1 THEN forma_pago = "EFECTIVO".
                    WHEN 2 THEN forma_pago = "CHEQUES DEL DIA".
                    WHEN 3 THEN forma_pago = "CHEQUES DIFERIDOS".
                    WHEN 4 THEN forma_pago = "TARJETA DE CREDITO".
                    WHEN 5 THEN forma_pago = "B.DEPOS. / VTAS WHATASAPP".     /*"BOLETAS DE DEPOSITO".*/
                    WHEN 6 THEN forma_pago = "NOTAS DE CREDITO".
                    WHEN 7 THEN forma_pago = "ANTICIPOS".
                    WHEN 8 THEN forma_pago = "RAPPI PLATAFORMA VIRTUAL".
                    WHEN 9 THEN forma_pago = "RETENCIONES".
                    WHEN 10 THEN forma_pago = "VALES DE CONSUMO".
                    WHEN 11 THEN forma_pago = "TARJETA PUNTOS".

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CargaUsuarios D-Dialog 
PROCEDURE proc_CargaUsuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH wrk_user:
        DELETE wrk_user.
    END.

    FOR EACH ccbccaja WHERE
        ccbccaja.codcia = s-codcia AND
        ccbccaja.coddiv = s-coddiv AND
        LOOKUP(ccbccaja.coddoc,"I/C,E/C") > 0 AND
        ccbccaja.usuario >= "" AND
        ccbccaja.flgcie = "P" AND
        ccbccaja.FchDoc = FILL-IN-date AND
        ccbccaja.flgest NE "A" NO-LOCK:
        FIND FIRST wrk_user WHERE
            wrk_user.wrk_userid = CcbcCaja.Usuario
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE wrk_user THEN DO:
            CREATE wrk_user.
            wrk_user.wrk_userid = CcbcCaja.Usuario.
            FIND DICTDB._user WHERE
                DICTDB._user._userid = wrk_user.wrk_userid
                NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._user THEN
                wrk_user.wrk_name = DICTDB._user._user-name.
        END.
    END.

    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Imprimir D-Dialog 
PROCEDURE proc_Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR s-titulo AS CHAR NO-UNDO.
    DEF VAR s-subtit AS CHAR NO-UNDO.
    DEF VAR s-divi AS CHAR NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN FILL-IN-date.
    END.

    RUN proc_Carga-Temporal.

    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    s-titulo = "REPORTE PRE-CIERRE DE CAJA".
    s-subtit = "FECHA " + STRING(FILL-IN-date).
    s-divi = "DIVISION: " + s-coddiv.

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Pre-cierre de caja - 01"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo +
            "~ns-subtit = " + s-subtit +
            "~ns-divi = " + s-divi.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "wrk_user"}

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

