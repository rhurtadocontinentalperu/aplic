&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEFINE VARIABLE s-task-no AS INT INITIAL 0 NO-UNDO.
DEFINE VARIABLE s-titulo AS CHAR NO-UNDO.
DEFINE VARIABLE s-subtit AS CHAR NO-UNDO.
DEFINE VARIABLE s-horcie AS CHAR NO-UNDO.
DEFINE VARIABLE s-divi   AS CHAR NO-UNDO.
DEFINE VARIABLE xtpocmb  AS DECI NO-UNDO.

DEFINE VARIABLE ImpNac AS DECIMAL EXTENT 10 NO-UNDO.
DEFINE VARIABLE ImpUSA AS DECIMAL EXTENT 10 NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = FILL-IN-fchcie NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = FILL-IN-fchcie NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CcbCierr


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-FchCie Btn_OK Btn_Cancel BROWSE-1 ~
RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FchCie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Ca&ncelar" 
     SIZE 15 BY 1.54 TOOLTIP "Cancelar"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Aceptar" 
     SIZE 15 BY 1.54 TOOLTIP "Imprimir"
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de cierre" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.86 BY 7.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 2.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 D-Dialog _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      CcbCierr.FchCie COLUMN-LABEL "Fecha de cierre" FORMAT "99/99/9999":U
      CcbCierr.HorCie FORMAT "x(5)":U
      CcbCierr.usuario COLUMN-LABEL "          Cajero" FORMAT "x(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 33.72 BY 5.81
         FONT 4 TOOLTIP "Haga ~"click~" para seleccionar".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-FchCie AT ROW 1.27 COL 17 COLON-ALIGNED
     Btn_OK AT ROW 8.88 COL 3.43
     Btn_Cancel AT ROW 8.88 COL 20.43
     BROWSE-1 AT ROW 2.35 COL 3
     RECT-1 AT ROW 1 COL 1.14
     RECT-2 AT ROW 8.5 COL 1
     SPACE(0.99) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Cierre de caja".


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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 Btn_Cancel D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.CcbCierr"
     _Where[1]         = "integral.CcbCierr.CodCia = s-codcia
 AND integral.CcbCierr.FchCie = FILL-IN-fchcie"
     _FldNameList[1]   > integral.CcbCierr.FchCie
"CcbCierr.FchCie" "Fecha de cierre" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = integral.CcbCierr.HorCie
     _FldNameList[3]   > integral.CcbCierr.usuario
"CcbCierr.usuario" "          Cajero" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
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
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
        MESSAGE
            "Seleccione algún cajeros a imprimir"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchCie D-Dialog
ON LEAVE OF FILL-IN-FchCie IN FRAME D-Dialog /* Fecha de cierre */
OR "RETURN" OF FILL-IN-FchCie DO:

    ASSIGN {&SELF-NAME}.
    OPEN QUERY {&BROWSE-NAME} FOR EACH CcbCierr WHERE
        CcbCierr.CodCia = s-codcia AND
        CcbCierr.FchCie = FILL-IN-FchCie SHARE-LOCK.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE j AS INTEGER NO-UNDO.
    DEFINE VARIABLE pos AS INTEGER NO-UNDO.
    DEFINE VARIABLE forma_pago AS CHARACTER NO-UNDO.
    DEFINE VARIABLE monto_nac AS DECIMAL NO-UNDO.
    DEFINE VARIABLE monto_usa AS DECIMAL NO-UNDO.
    DEFINE VARIABLE monto_decNac AS DECIMAL NO-UNDO.
    DEFINE VARIABLE monto_decUSA AS DECIMAL NO-UNDO.
    DEFINE VARIABLE user_name AS CHARACTER NO-UNDO.

    s-subtit = "CAJERO(S): ".
    s-horcie = "".
    s-divi   = "DIVISION: ".
    xtpocmb = 0.
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

        IF INDEX(s-subtit,ccbcierr.Usuario) = 0 THEN
            s-subtit = s-subtit + ccbcierr.Usuario + " ".
        s-horcie = s-horcie + ccbcierr.horcie + " ".

        FIND FACUSERS WHERE
            FACUSERS.CODCIA = S-CODCIA AND
            FACUSERS.USUARIO = CCBCIERR.USUARIO
            NO-LOCK NO-ERROR.
        IF AVAILABLE FACUSERS THEN DO:
            IF INDEX(s-divi,FACUSERS.CODDIV) = 0 THEN DO:
                FIND GN-DIVI WHERE
                    GN-DIVI.CodCia = S-CODCIA AND
                    GN-DIVI.CodDiv = FACUSERS.CODDIV
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-DIVI THEN
                    s-divi = s-divi + GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv + " ".
            END.
            FIND DICTDB._user WHERE
                DICTDB._user._userid = FACUSERS.USUARIO
                NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._user THEN
                user_name = DICTDB._user._user-name.
        END.

        FIND CCBDECL WHERE
            CCBDECL.CODCIA  = S-CODCIA AND
            CCBDECL.USUARIO = CCBCIERR.USUARIO AND
            CCBDECL.FCHCIE  = CCBCIERR.FCHCIE AND
            CCBDECL.HORCIE  = CCBCIERR.HORCIE NO-LOCK.
        IF AVAILABLE CCBDECL THEN DO:
            monto_decNac = CCBDECL.ImpNac[1].
            monto_decUSA = CCBDECL.ImpUsa[1].
        END.

        DISPLAY
            ccbcierr.Usuario @ Fi-Mensaje
            LABEL "    Cajera(o)" FORMAT "X(13)"
            WITH FRAME F-Proceso.

        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0 AND
            ccbccaja.flgcie = "C" AND
            ccbccaja.fchcie = ccbcierr.fchcie AND
            ccbccaja.horcie = ccbcierr.horcie AND
            ccbccaja.flgest NE "A" AND
            ccbccaja.usuario = ccbcierr.Usuario
            NO-LOCK:
            /* Ingresos a Caja */
            IF ccbccaja.coddoc = "I/C" THEN
                FOR EACH ccbdcaja OF ccbccaja NO-LOCK:
                CASE ccbccaja.tipo:
                    WHEN "ANTREC" THEN forma_pago = "ANTICIPO".
                    WHEN "SENCILLO" THEN forma_pago = "SENCILLO".
                    WHEN "OTROS" THEN forma_pago = "OTROS".
                    OTHERWISE forma_pago = ccbdcaja.codref.
                END CASE.
                FIND FIRST w-report WHERE
                    w-report.Task-No = s-task-no AND
                    w-report.Llave-C = s-user-id AND
                    w-report.Campo-C[1] = ccbccaja.usuario AND
                    w-report.Campo-C[2] = ccbcierr.horcie AND
                    w-report.Campo-C[3] = ccbccaja.coddoc AND
                    w-report.Campo-C[4] = forma_pago
                    NO-ERROR.
                IF NOT AVAILABLE w-report THEN DO:
                    CREATE w-report.
                    ASSIGN
                        w-report.Task-No = s-task-no
                        w-report.Llave-C = s-user-id
                        w-report.Campo-C[1] = ccbccaja.usuario
                        w-report.Campo-C[2] = ccbcierr.horcie
                        w-report.Campo-C[3] = ccbccaja.coddoc
                        w-report.Campo-C[4] = forma_pago
                        w-report.Campo-C[5] = user_name.
                END.
                IF ccbdcaja.codmon = 1 THEN DO:
                    monto_nac = ccbdcaja.imptot.
                    monto_usa = 0.
                END.
                ELSE DO:
                    monto_nac = 0.
                    monto_usa = ccbdcaja.imptot.
                END.
                IF CcbCCaja.ImpNac[1] <> 0 OR
                    CcbCCaja.ImpUSA[1] <> 0 THEN DO:
                    w-report.Campo-F[1] = w-report.Campo-F[1] + monto_nac.
                    w-report.Campo-F[2] = w-report.Campo-F[2] + monto_usa.
                END.
                ELSE DO:
                    w-report.Campo-F[3] = w-report.Campo-F[3] + monto_nac.
                    w-report.Campo-F[4] = w-report.Campo-F[4] + monto_usa.
                END.
            END.
            /* Egresos de Caja */
            ELSE DO:
                CASE ccbccaja.tipo:
                    WHEN "REMEBOV" THEN forma_pago = "REMESA A BÓVEDA".
                    WHEN "REMECJC" THEN forma_pago = "REMESA A CAJA CENTRAL".
                    WHEN "ANTREC" THEN forma_pago = "DEVOLUCIÓN EFECTIVO (ANTICIPO)".
                    WHEN "DEVONC" THEN forma_pago = "DEVOLUCIÓN EFECTIVO (N/C)".
                    WHEN "SENCILLO" THEN forma_pago = "SENCILLO".
                    OTHERWISE forma_pago = "OTROS".
                END CASE.
                CREATE w-report.
                ASSIGN
                    w-report.Task-No = s-task-no
                    w-report.Llave-C = s-user-id
                    w-report.Campo-C[1] = ccbccaja.usuario
                    w-report.Campo-C[2] = ccbcierr.horcie
                    w-report.Campo-C[3] = ccbccaja.coddoc
                    w-report.Campo-C[4] = forma_pago
                    w-report.Campo-C[5] = user_name
                    w-report.Campo-C[6] =
                        ccbccaja.coddoc + " " + ccbccaja.nrodoc
                    w-report.Campo-F[1] = CcbCCaja.ImpNac[1]
                    w-report.Campo-F[2] = CcbCCaja.ImpUSA[1].
            END. /* ELSE DO:... */
        END. /* FOR EACH ccbccaja... */

    END. /* DO i = 1 TO... */

    HIDE FRAME F-Proceso.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Campo-C[1] = "":
        DELETE w-report.
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
  DISPLAY FILL-IN-FchCie 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-FchCie Btn_OK Btn_Cancel BROWSE-1 RECT-1 RECT-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato D-Dialog 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cTipo AS CHARACTER FORMAT "X(30)" NO-UNDO.

    DEFINE FRAME F-HEADER
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN4} FORMAT "X(80)" SKIP
        "REPORTE CIERRE DE CAJA DEL" FORMAT "x(28)" AT 56 FILL-IN-FchCie
        "Página :" AT 132 PAGE-NUMBER FORMAT "ZZ9" SKIP
        "Fecha  :" AT 132 STRING(TODAY,"99/99/99")
        "Hora   :" AT 132 STRING(TIME,"HH:MM:SS") SKIP
        WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    VIEW FRAME F-HEADER.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id NO-LOCK
        BREAK BY w-report.Campo-C[1]
        BY w-report.Campo-C[2]
        BY w-report.Campo-C[3] DESCENDING
        BY w-report.Campo-C[4]
        WITH FRAME b STREAM-IO WIDTH 180:
        IF FIRST-OF(w-report.Campo-C[3]) THEN DO:
            IF w-report.Campo-C[3] = "I/C" THEN cTipo = "<< INGRESOS >>".
            ELSE cTipo = "<< EGRESOS >>".
            DISPLAY
                w-report.Campo-C[5] WHEN FIRST-OF(w-report.Campo-C[1])
                    COLUMN-LABEL "Cajera(o)" FORMAT "x(30)"
                w-report.Campo-C[2] WHEN FIRST-OF(w-report.Campo-C[2]) COLUMN-LABEL "Hora"
                cTipo @ w-report.Campo-C[4] COLUMN-LABEL "Tipo" FORMAT "x(30)"
                WITH STREAM-IO.
            DOWN WITH STREAM-IO.
        END.
        DISPLAY
            w-report.Campo-C[4]
            w-report.Campo-C[6] COLUMN-LABEL "Referencia" FORMAT "x(13)"
            w-report.Campo-F[1] COLUMN-LABEL "E F E C!S/.     "
            w-report.Campo-F[2] COLUMN-LABEL "T I V O        !US$     "
            w-report.Campo-F[3] WHEN w-report.Campo-F[3] <> 0
                COLUMN-LABEL "A P L I C A!S/.     "
            w-report.Campo-F[4] WHEN w-report.Campo-F[4] <> 0 
                COLUMN-LABEL "C I O N E S    !US$     "
            WITH STREAM-IO.
        ACCUMULATE w-report.Campo-F[1] (SUB-TOTAL BY w-report.Campo-C[3]).
        ACCUMULATE w-report.Campo-F[2] (SUB-TOTAL BY w-report.Campo-C[3]).
        ACCUMULATE w-report.Campo-F[3] (SUB-TOTAL BY w-report.Campo-C[3]).
        ACCUMULATE w-report.Campo-F[4] (SUB-TOTAL BY w-report.Campo-C[3]).
        IF LAST-OF(w-report.Campo-C[3]) THEN DO:
            UNDERLINE
                w-report.Campo-F[1]
                w-report.Campo-F[2]
                w-report.Campo-F[3] WHEN w-report.Campo-C[3] = "I/C"
                w-report.Campo-F[4] WHEN w-report.Campo-C[3] = "I/C"
                WITH STREAM-IO.
            DISPLAY
                "    TOTAL " + w-report.Campo-C[3] @ w-report.Campo-C[6]
                ACCUM SUB-TOTAL BY w-report.Campo-C[3] w-report.Campo-F[1] @ w-report.Campo-F[1]
                ACCUM SUB-TOTAL BY w-report.Campo-C[3] w-report.Campo-F[2] @ w-report.Campo-F[2]
                ACCUM SUB-TOTAL BY w-report.Campo-C[3] w-report.Campo-F[3]
                    WHEN w-report.Campo-C[3] = "I/C" @ w-report.Campo-F[3]
                ACCUM SUB-TOTAL BY w-report.Campo-C[3] w-report.Campo-F[4]
                    WHEN w-report.Campo-C[3] = "I/C" @ w-report.Campo-F[4]
                WITH STREAM-IO.
        END.
    END.

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.
    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE
            "Sin registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 60.
            WHEN 2 THEN
                OUTPUT TO PRINTER PAGED PAGE-SIZE 60. /* Impresora */
        END CASE.
        PUT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} + {&PrnD}.
        RUN Formato.
        PAGE.
        OUTPUT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  ASSIGN FILL-IN-FchCie:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY).
  
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

