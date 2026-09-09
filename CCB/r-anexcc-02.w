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
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR s-subtit AS CHAR NO-UNDO.
DEF VAR s-horcie AS CHAR NO-UNDO.
DEF VAR s-divi   AS CHAR NO-UNDO.
DEF VAR xtpocmb  AS DECI NO-UNDO.

DEFINE VARIABLE ImpNac AS DECIMAL EXTENT 10 NO-UNDO.
DEFINE VARIABLE ImpUSA AS DECIMAL EXTENT 10 NO-UNDO.

DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.

DEFINE TEMP-TABLE TEMPO
    FIELD TIPO      AS CHAR
    FIELD TOTSOL    AS DECI INIT 0
    FIELD TOTDOL    AS DECI INIT 0
    FIELD TOTSOLND  AS DECI INIT 0
    FIELD TOTDOLND  AS DECI INIT 0
    FIELD TOTSOLCR  AS DECI INIT 0
    FIELD TOTDOLCR  AS DECI INIT 0
    FIELD TOTSOLCE  AS DECI INIT 0
    FIELD TOTDOLCE  AS DECI INIT 0
    FIELD CAJA      AS DECI EXTENT 10 INIT 0
    FIELD NRODOC    AS CHAR
    FIELD CODDOC    AS CHAR
    FIELD GLOSA     AS CHAR
    INDEX TEMPO TIPO.

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
&Scoped-define INTERNAL-TABLES FacUsers CcbCierr

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH FacUsers ~
      WHERE FacUsers.CodCia = s-codcia ~
 AND FacUsers.CodDiv = s-coddiv NO-LOCK, ~
      EACH CcbCierr WHERE CcbCierr.CodCia = FacUsers.CodCia ~
  AND CcbCierr.usuario = FacUsers.Usuario ~
      AND CcbCierr.FchCie = x-fchcie NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH FacUsers ~
      WHERE FacUsers.CodCia = s-codcia ~
 AND FacUsers.CodDiv = s-coddiv NO-LOCK, ~
      EACH CcbCierr WHERE CcbCierr.CodCia = FacUsers.CodCia ~
  AND CcbCierr.usuario = FacUsers.Usuario ~
      AND CcbCierr.FchCie = x-fchcie NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 FacUsers CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 FacUsers
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 CcbCierr


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 X-FchCie Btn_OK Btn_Cancel RECT-1 ~
RECT-2 RECT-3 
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
     SIZE 37.43 BY 6.23.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37.43 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 14.86 BY 7.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      FacUsers, 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 D-Dialog _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      CcbCierr.FchCie COLUMN-LABEL "Fecha de Cierre" FORMAT "99/99/9999":U
            WIDTH 11.43
      CcbCierr.HorCie FORMAT "x(5)":U
      CcbCierr.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U WIDTH 13.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 36 BY 4.85
         FONT 4 ROW-HEIGHT-CHARS .54 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-1 AT ROW 2.62 COL 2 WIDGET-ID 100
     X-FchCie AT ROW 1.38 COL 14.57 COLON-ALIGNED
     Btn_OK AT ROW 3.04 COL 40.14
     Btn_Cancel AT ROW 4.23 COL 40.14
     "Haga ~"click~" en o los cajeros a imprimir" VIEW-AS TEXT
          SIZE 33.43 BY .5 AT ROW 7.69 COL 2.86
          FONT 6
     RECT-1 AT ROW 2.46 COL 1.14
     RECT-2 AT ROW 1.04 COL 1.14
     RECT-3 AT ROW 1 COL 38.86
     SPACE(1.41) SKIP(0.30)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-1 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.FacUsers,INTEGRAL.CcbCierr WHERE INTEGRAL.FacUsers ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "INTEGRAL.FacUsers.CodCia = s-codcia
 AND INTEGRAL.FacUsers.CodDiv = s-coddiv"
     _JoinCode[2]      = "INTEGRAL.CcbCierr.CodCia = INTEGRAL.FacUsers.CodCia
  AND INTEGRAL.CcbCierr.usuario = INTEGRAL.FacUsers.Usuario"
     _Where[2]         = "INTEGRAL.CcbCierr.FchCie = x-fchcie"
     _FldNameList[1]   > INTEGRAL.CcbCierr.FchCie
"CcbCierr.FchCie" "Fecha de Cierre" ? "date" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.CcbCierr.HorCie
     _FldNameList[3]   > INTEGRAL.CcbCierr.usuario
"CcbCierr.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
OR "RETURN" OF X-FchCie DO:
    ASSIGN {&SELF-NAME}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
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
        FIND FACUSERS WHERE FACUSERS.CODCIA = S-CODCIA AND
            FACUSERS.USUARIO = CCBCIERR.USUARIO
            NO-LOCK NO-ERROR.
        IF AVAILABLE FACUSERS THEN DO:
            IF INDEX(s-divi,FACUSERS.CODDIV) = 0 THEN DO:
                FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
                    GN-DIVI.CodDiv = FACUSERS.CODDIV
                    NO-LOCK NO-ERROR.
                IF AVAILABLE GN-DIVI THEN
                    s-divi = s-divi + GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv + " ".
            END.
            FIND DICTDB._user WHERE
                DICTDB._user._userid = FACUSERS.USUARIO
                NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._user THEN user_name = DICTDB._user._user-name.
        END.
        FOR EACH ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia AND
            LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0 AND
            ccbccaja.flgcie = "C" AND
            ccbccaja.fchcie = ccbcierr.fchcie AND
            ccbccaja.horcie = ccbcierr.horcie AND
            ccbccaja.flgest NE "A" AND
            ccbccaja.usuario = ccbcierr.Usuario,
            EACH Vtadtickets NO-LOCK WHERE Vtadtickets.codcia = s-codcia AND
            Vtadtickets.codref = Ccbccaja.coddoc AND
            Vtadtickets.nroref = Ccbccaja.nrodoc AND
            Vtadtickets.coddiv = Ccbccaja.coddiv:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Campo-C[1] = ccbccaja.usuario
                w-report.Campo-C[2] = ccbccaja.coddoc
                w-report.Campo-C[3] = ccbccaja.nrodoc
                w-report.Campo-C[4] = user_name
                w-report.Campo-C[5] = ccbcierr.horcie
                w-report.Campo-C[6] = VtaDTickets.NroTck  
                w-report.Campo-F[1] = VtaDTickets.Valor.
        END.
    END. /* DO i = 1 TO... */

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
  DISPLAY X-FchCie 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-1 X-FchCie Btn_OK Btn_Cancel RECT-1 RECT-2 RECT-3 
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
    
    RUN Carga-Temporal.
    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    s-titulo = "REPORTE DE CIERRE DE CAJA DEL " + STRING(X-FchCie,"99/99/9999").

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ccb/rbccb.prl"
        RB-REPORT-NAME = "Arqueo de Caja - 02"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER =
            "w-report.task-no = " + STRING(s-task-no) +
            " AND w-report.Llave-C = '" + s-user-id + "'"
        RB-OTHER-PARAMETERS =
            "s-nomcia = " + s-nomcia +
            "~ns-titulo = " + s-titulo +
            "~ns-subtit = " + s-subtit +
            "~ns-horcie = " + s-horcie +
            "~ns-divi   = " + s-divi   +
            "~ns-tpocmb = " + string(xtpocmb,">>,>>9.9999").

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
  x-FchCie = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN x-fchcie:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrecioListaMinorista D-Dialog 
PROCEDURE PrecioListaMinorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.

DEF VAR s-TpoCmb AS DEC.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMinGn THEN RETURN.
        ASSIGN
            s-UndVta = VtaListaMinGn.Chr__01.

        /* FACTOR DE EQUIVALENCIA */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-undvta
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN RETURN.
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

        /* RHC 12.06.08 tipo de cambio de la familia */
        s-tpocmb = VtaListaMinGn.TpoCmb.     /* ¿? */

        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMinGn.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMinGn.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / S-TPOCMB).
        END.
    END.
    WHEN 2 THEN DO:
        FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMin THEN RETURN.
        ASSIGN
            s-UndVta = VtaListaMin.Chr__01.
        /* FACTOR DE EQUIVALENCIA */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-undvta
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN RETURN.
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

        /* RHC 12.06.08 tipo de cambio de la familia */
        s-tpocmb = VtaListaMin.TpoCmb.     /* ¿? */

        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMin.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMin.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
        END.
    END.
END CASE.

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
  {src/adm/template/snd-list.i "FacUsers"}
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

