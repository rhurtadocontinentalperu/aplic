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
DEF SHARED VAR pv-codcia AS INT.
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

DEFINE TEMP-TABLE Detalle LIKE Vtadtickets.
DEFINE TEMP-TABLE Tarjetas LIKE Ccbccaja.
DEFINE TEMP-TABLE Boveda  LIKE Ccbccaja.

/* CONTAMOS CUANTAS LINEAS TIENE LA IMPRESION */
DEF VAR x-Lineas AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES CcbCierr CcbCCaja

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-FchCie NO-LOCK, ~
      FIRST CcbCCaja WHERE CcbCCaja.CodCia = CcbCierr.CodCia ~
  AND CcbCCaja.usuario = CcbCierr.usuario ~
  AND CcbCCaja.FchCie = CcbCierr.FchCie ~
      AND CcbCCaja.CodDiv = s-coddiv ~
 AND CcbCCaja.FlgEst <> "A" ~
 AND CcbCCaja.FlgCie = "C" ~
 AND (CcbCCaja.CodDoc = "I/C" ~
  OR CcbCCaja.CodDoc = "E/C") NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-FchCie NO-LOCK, ~
      FIRST CcbCCaja WHERE CcbCCaja.CodCia = CcbCierr.CodCia ~
  AND CcbCCaja.usuario = CcbCierr.usuario ~
  AND CcbCCaja.FchCie = CcbCierr.FchCie ~
      AND CcbCCaja.CodDiv = s-coddiv ~
 AND CcbCCaja.FlgEst <> "A" ~
 AND CcbCCaja.FlgCie = "C" ~
 AND (CcbCCaja.CodDoc = "I/C" ~
  OR CcbCCaja.CodDoc = "E/C") NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 CcbCierr CcbCCaja
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 CcbCierr
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 CcbCCaja


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
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Ca&ncelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "&Aceptar" 
     SIZE 12 BY 1.62
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
      CcbCierr, 
      CcbCCaja SCROLLING.
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
     Btn_Cancel AT ROW 4.65 COL 40
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
         TITLE "Arqueo de Caja"
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

{src/bin/_prns.i}
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
     _TblList          = "INTEGRAL.CcbCierr,INTEGRAL.CcbCCaja WHERE INTEGRAL.CcbCierr ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _Where[1]         = "CcbCierr.CodCia = s-codcia
 AND CcbCierr.FchCie = x-FchCie"
     _JoinCode[2]      = "CcbCCaja.CodCia = CcbCierr.CodCia
  AND CcbCCaja.usuario = CcbCierr.usuario
  AND CcbCCaja.FchCie = CcbCierr.FchCie"
     _Where[2]         = "CcbCCaja.CodDiv = s-coddiv
 AND CcbCCaja.FlgEst <> ""A""
 AND CcbCCaja.FlgCie = ""C""
 AND (CcbCCaja.CodDoc = ""I/C""
  OR CcbCCaja.CodDoc = ""E/C"")"
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Arqueo de Caja */
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

    DEFINE VARIABLE xLlave-1 AS INT NO-UNDO.    /* 1er. Orden: INGRESOS EGRESOS */
    DEFINE VARIABLE xLlave-2 AS INT NO-UNDO.    /* 2do. Orden: EFECTIVO APLICACIONES */

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

    FIND GN-DIVI WHERE
        GN-DIVI.CodCia = S-CODCIA AND
        GN-DIVI.CodDiv = S-CODDIV
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN s-divi = GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv + " ".
    /* Barremos seleccionados */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        IF INDEX(s-subtit,ccbcierr.Usuario) = 0 THEN
            s-subtit = s-subtit + ccbcierr.Usuario + " ".
        s-horcie = s-horcie + ccbcierr.horcie + " ".
        ASSIGN
            USER_name = ''
            monto_decNac = 0
            monto_decUSA = 0.
        FIND DICTDB._user WHERE DICTDB._user._userid = ccbcierr.Usuario NO-LOCK NO-ERROR.
        IF AVAILABLE DICTDB._user THEN user_name = DICTDB._user._user-name.
        FIND CCBDECL WHERE CCBDECL.CODCIA  = S-CODCIA 
            AND CCBDECL.USUARIO = CCBCIERR.USUARIO 
            AND CCBDECL.FCHCIE  = CCBCIERR.FCHCIE 
            AND CCBDECL.HORCIE  = CCBCIERR.HORCIE NO-LOCK.
        IF AVAILABLE CCBDECL THEN DO:
            monto_decNac = CCBDECL.ImpNac[1].
            monto_decUSA = CCBDECL.ImpUsa[1].
        END.
        /* Barremos Movimientos de Caja */
        FOR EACH ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia 
            AND LOOKUP(ccbccaja.coddoc, "I/C,E/C") <> 0 
            AND ccbccaja.flgcie = "C" 
            AND ccbccaja.fchcie = ccbcierr.fchcie 
            AND ccbccaja.horcie = ccbcierr.horcie 
            AND ccbccaja.flgest <> "A" 
            AND ccbccaja.usuario = ccbcierr.Usuario:
            IF xtpocmb = 0 THEN xtpocmb = CcbCCaja.TpoCmb.
            CASE Ccbccaja.CodDoc:
                WHEN 'I/C' THEN xLlave-1 = 1.
                WHEN 'E/C' THEN xLlave-1 = 2.
            END CASE.
            /* Revisamos los ARRAY */
            DO j = 1 TO 10:
                CASE j:
                    WHEN 1 THEN forma_pago = "EFECTIVO".
                    WHEN 2 THEN forma_pago = "CHEQUES DEL DIA".
                    WHEN 3 THEN forma_pago = "CHEQUES DIFERIDOS".
                    WHEN 4 THEN forma_pago = "TARJETA DE CREDITO".
                    WHEN 5 THEN forma_pago = "BOLETAS DE DEPOSITO".
                    WHEN 6 THEN forma_pago = "NOTAS DE CREDITO".
                    WHEN 7 THEN forma_pago = "ANTICIPOS".
                    WHEN 8 THEN forma_pago = "COMISION FACTORING".
                    WHEN 9 THEN forma_pago = "RETENCIONES".
                    WHEN 10 THEN forma_pago = "VALES DE CONSUMO".
                END CASE.
                IF CcbCCaja.ImpNac[j] + CcbCCaja.Impusa[j] <= 0 THEN NEXT.
                xLlave-2 = (IF j <= 4 THEN 1 ELSE 2).   /* 1: Efectivo  2: Aplicaciones */
                CASE Ccbccaja.CodDoc:
                    WHEN "I/C" THEN DO:
                        /* Detalla los I/C Efectivo */
                        IF j = 1 THEN DO:
                            CASE ccbccaja.tipo:
                                WHEN "SENCILLO"     THEN forma_pago = "EFECTIVO - SENCILLO".
                                WHEN "ANTREC"       THEN forma_pago = "EFECTIVO - ANTICIPO".
                                WHEN "CANCELACION"  THEN forma_pago = "EFECTIVO - CANCELACIÓN".
                                WHEN "MOSTRADOR"    THEN forma_pago = "EFECTIVO - MOSTRADOR".
                                OTHERWISE forma_pago = "EFECTIVO - OTROS".
                            END CASE.
                        END.
                    END.
                    WHEN "E/C" THEN DO:
                        CASE ccbccaja.tipo:
                            WHEN "REMEBOV"  THEN forma_pago = "REMESA A BÓVEDA".
                            WHEN "REMECJC"  THEN forma_pago = "REMESA A CAJA CENTRAL".
                            WHEN "ANTREC"   THEN forma_pago = "DEVOLUCIÓN EFECTIVO (ANTICIPO)".
                            WHEN "DEVONC"   THEN forma_pago = "DEVOLUCIÓN EFECTIVO (N/C)".
                            WHEN "SENCILLO" THEN forma_pago = "SENCILLO".
                            OTHERWISE forma_pago = "OTROS EGRESOS".
                        END CASE.
                    END.
                END CASE.
                /* El quiebre va a ser por usuario y hora de cierre */
                FIND FIRST w-report WHERE w-report.Task-No = s-task-no 
                    AND w-report.Llave-C = s-user-id 
                    AND w-report.Campo-C[1] = ccbccaja.usuario 
                    AND w-report.Campo-C[2] = ccbccaja.coddoc
                    AND w-report.Campo-C[3] = forma_pago
                    AND w-report.Campo-C[5] = ccbcierr.horcie
                    AND w-report.Campo-I[1] = xLlave-1
                    AND w-report.Campo-I[2] = xLlave-2
                    AND w-report.Campo-I[3] = j
                    NO-ERROR.
                IF NOT AVAILABLE w-report THEN DO:
                    CREATE w-report.
                    ASSIGN
                        w-report.Task-No = s-task-no
                        w-report.Llave-C = s-user-id
                        w-report.Campo-C[1] = ccbccaja.usuario
                        w-report.Campo-C[2] = ccbccaja.coddoc
                        w-report.Campo-I[1] = xLlave-1
                        w-report.Campo-I[2] = xLlave-2
                        w-report.Campo-I[3] = j
                        w-report.Campo-C[3] = forma_pago
                        w-report.Campo-C[4] = user_name
                        w-report.Campo-C[5] = ccbcierr.horcie
                        w-report.Campo-F[3] = monto_decNac
                        w-report.Campo-F[4] = monto_decUSA
                        monto_decNac = 0
                        monto_decUSA = 0.
                END.
                /* Descuenta Vuelto */
                /*RDP01 - Parche No descuenta vuelto */
                IF j = 1 THEN DO:
                    monto_nac = CcbCCaja.ImpNac[j] - CcbCCaja.VueNac.
                    monto_usa = CcbCCaja.ImpUSA[j] - CcbCCaja.VueUSA.
                END.
                ELSE DO:
                    monto_nac = CcbCCaja.ImpNac[j].
                    monto_usa = CcbCCaja.ImpUSA[j].
                END.
                IF ccbccaja.coddoc = "I/C" AND j = 1 THEN DO:
                    /* Guarda Efectivo Recibido */
                    w-report.Campo-F[5] = w-report.Campo-F[5] + monto_Nac.
                    w-report.Campo-F[6] = w-report.Campo-F[6] + monto_USA.
                END.
                w-report.Campo-F[1] = w-report.Campo-F[1] + monto_nac.
                w-report.Campo-F[2] = w-report.Campo-F[2] + monto_usa.
                w-report.Campo-F[10] = xTpoCmb.
            END.
        END.
    END.

    FOR EACH w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id AND
        w-report.Campo-C[1] = "":
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 D-Dialog 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     Cargamos las diferencias de precios ventas manuales
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-PreUni AS DEC.
DEF VAR x-PreLis AS DEC.

DEF VAR f-CanPed AS DEC.
DEF VAR s-UndVta AS CHAR.
DEF VAR f-Factor AS DEC.
DEF VAR f-PreBas AS DEC.
DEF VAR f-PreVta AS DEC.
DEF VAR f-Dsctos AS DEC.
DEF VAR y-Dsctos AS DEC.
DEF VAR z-Dsctos AS DEC.
DEF VAR x-TipDto AS CHAR.

/* Crea w-report */
s-task-no = 0.
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

FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddiv = s-coddiv
    AND LOOKUP(ccbcdocu.coddoc, 'FAC,BOL') > 0
    AND ccbcdocu.fchdoc = x-FchCie
    AND ccbcdocu.flgest <> "A"
    AND ccbcdocu.tpofac = "M":
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK, FIRST Almmmatg OF ccbddocu NO-LOCK:
        /* buscamos el precio de venta por lista de precios minorista general */
        /* todas las ventas son en SOLES */
        RUN PrecioListaMinorista (
            ccbcdocu.CodDiv,
            ccbcdocu.CodMon,
            OUTPUT s-UndVta,
            OUTPUT f-Factor,
            ccbddocu.CodMat,
            ccbddocu.CanDes,
            4,
            ccbcdocu.flgsit,       /* s-codbko, */
            OUTPUT f-PreBas
            ).
        /* todos los precios unitarios deben representarse a una sola unidad */
        ASSIGN
            x-PreUni = ccbddocu.preuni / ccbddocu.factor
            x-PreLis = f-PreBas / f-Factor.
        IF ( ABS(x-PreUni - f-PreBas) / x-PreLis ) > ( 0.20 / 100 ) THEN DO:
            CREATE w-report.
            ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Campo-C[1] = ccbcdocu.coddoc
                w-report.Campo-C[2] = ccbcdocu.nrodoc
                w-report.Campo-C[3] = ccbddocu.codmat
                w-report.Campo-C[4] = almmmatg.desmat
                w-report.Campo-F[1] = ccbddocu.preuni
                w-report.Campo-C[5] = ccbddocu.undvta
                w-report.Campo-F[2] = f-PreBas
                w-report.Campo-C[6] = s-UndVta
                w-report.Campo-F[3] = x-PreUni
                w-report.Campo-F[4] = x-PreLis
                w-report.Campo-C[7] = Almmmatg.UndStk.
        END.
    END.
END.
FOR EACH w-report WHERE
    w-report.task-no = s-task-no AND
    w-report.Llave-C = s-user-id AND
    w-report.Campo-C[1] = "":
    DELETE w-report.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Boveda D-Dialog 
PROCEDURE Carga-Temporal-Boveda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i AS INT NO-UNDO.

    EMPTY TEMP-TABLE Tarjetas.

    FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
        AND Ccbccaja.flgcie = "C"
        AND Ccbccaja.flgest <> 'A'
        AND Ccbccaja.usuario = CcbCierr.usuario
        AND Ccbccaja.fchcie = Ccbcierr.fchcie
        AND Ccbccaja.horcie = Ccbcierr.horcie
        AND Ccbccaja.coddoc = 'E/C'
        AND ccbccaja.tipo = "REMEBOV":
        CREATE Boveda.
        BUFFER-COPY Ccbccaja TO Boveda.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-old D-Dialog 
PROCEDURE Carga-Temporal-old :
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

        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0 AND
            ccbccaja.flgcie = "C" AND
            ccbccaja.fchcie = ccbcierr.fchcie AND
            ccbccaja.horcie = ccbcierr.horcie AND
            ccbccaja.flgest NE "A" AND
            ccbccaja.usuario = ccbcierr.Usuario
            NO-LOCK:
            IF xtpocmb = 0 THEN xtpocmb = CcbCCaja.TpoCmb.
            DO j = 1 TO 10:
                CASE j:
                    WHEN 1 THEN forma_pago = "EFECTIVO".
                    WHEN 2 THEN forma_pago = "CHEQUES DEL DIA".
                    WHEN 3 THEN forma_pago = "CHEQUES DIFERIDOS".
                    WHEN 4 THEN forma_pago = "TARJETA DE CREDITO".
                    WHEN 5 THEN forma_pago = "BOLETAS DE DEPOSITO".
                    WHEN 6 THEN forma_pago = "NOTAS DE CREDITO".
                    WHEN 7 THEN forma_pago = "ANTICIPOS".
                    WHEN 8 THEN forma_pago = "COMISION FACTORING".
                    WHEN 9 THEN forma_pago = "RETENCIONES".
                    WHEN 10 THEN forma_pago = "VALES DE CONSUMO".
                END CASE.
                IF CcbCCaja.ImpNac[j] <> 0 OR CcbCCaja.Impusa[j] <> 0 THEN DO:
                    /* Detalla los I/C Efectivo */
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
                    END.

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
                            w-report.Campo-C[4] = user_name
                            w-report.Campo-C[5] = ccbcierr.horcie
                            w-report.Campo-F[3] = monto_decNac
                            w-report.Campo-F[4] = monto_decUSA
                            monto_decNac = 0
                            monto_decUSA = 0.
                    END.
                    /* Descuenta Vuelto */
                    /*RDP01 - Parche No descuenta vuelto */
                    IF j = 1 THEN DO:
                        monto_nac = CcbCCaja.ImpNac[j] - CcbCCaja.VueNac.
                        monto_usa = CcbCCaja.ImpUSA[j] - CcbCCaja.VueUSA.
                    END.
                    ELSE DO:
                        monto_nac = CcbCCaja.ImpNac[j].
                        monto_usa = CcbCCaja.ImpUSA[j].
                    END.

                    IF ccbccaja.coddoc = "I/C" AND j = 1 THEN DO:
                        /* Guarda Efectivo Recibido */
                        w-report.Campo-F[5] = w-report.Campo-F[5] + monto_Nac.
                        w-report.Campo-F[6] = w-report.Campo-F[6] + monto_USA.
                    END.
                    w-report.Campo-F[1] = w-report.Campo-F[1] + monto_nac.
                    w-report.Campo-F[2] = w-report.Campo-F[2] + monto_usa.
/*                     MESSAGE 'Verificaremos carga de datos' SKIP    */
/*                         'forma_pago ' w-report.Campo-C[3] SKIP     */
/*                         'monto_decNac '  w-report.Campo-F[3] SKIP  */
/*                         'monto_decUSA ' w-report.Campo-F[4]  SKIP  */
/*                         'monto_nac '  w-report.Campo-F[1]    SKIP  */
/*                         'monto_usa '  w-report.Campo-F[2]    SKIP. */

                END.
            END. /* DO j = 1 TO... */
        END. /* FOR EACH ccbccaja... */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Tarjetas D-Dialog 
PROCEDURE Carga-Temporal-Tarjetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i AS INT NO-UNDO.

    EMPTY TEMP-TABLE Tarjetas.

    FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
        AND Ccbccaja.flgcie = "C"
        AND Ccbccaja.flgest <> 'A'
        AND Ccbccaja.usuario = CcbCierr.usuario
        AND Ccbccaja.fchcie = Ccbcierr.fchcie
        AND Ccbccaja.horcie = Ccbcierr.horcie
        AND Ccbccaja.impnac[4] + Ccbccaja.impusa[4] > 0:
        CREATE Tarjetas.
        BUFFER-COPY Ccbccaja TO Tarjetas.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-Vales D-Dialog 
PROCEDURE Carga-Temporal-Vales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR i AS INT NO-UNDO.

    EMPTY TEMP-TABLE Detalle.

    FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
        AND Ccbccaja.flgcie = "C"
        AND Ccbccaja.flgest <> 'A'
        AND Ccbccaja.usuario = CcbCierr.usuario
        AND Ccbccaja.fchcie = Ccbcierr.fchcie
        AND Ccbccaja.horcie = Ccbcierr.horcie,
        EACH Vtadtickets NO-LOCK WHERE Vtadtickets.codcia = s-codcia
        AND Vtadtickets.codref = Ccbccaja.coddoc
        AND Vtadtickets.nroref = Ccbccaja.nrodoc:
        CREATE Detalle.
        BUFFER-COPY Vtadtickets TO Detalle.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato D-Dialog 
PROCEDURE Formato PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR ImpNacCja AS DEC NO-UNDO.
DEF VAR ImpUsaCja AS DEC NO-UNDO.
DEF VAR TotDecNac AS DEC NO-UNDO.
DEF VAR TotDecUsa AS DEC NO-UNDO.
DEF VAR TotEfeNac AS DEC NO-UNDO.
DEF VAR TotEfeUsa AS DEC NO-UNDO.



/* Quebramos por usuario y hora de cierre */
FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no AND w-report.llave-c = s-user-id
    BREAK BY (w-report.Campo-C[1] + w-report.Campo-C[5]) BY w-report.Campo-I[1] BY w-report.Campo-I[2] BY w-report.Campo-I[3]:
    /* CABECERA */
    IF FIRST-OF(w-report.Campo-C[1] + w-report.Campo-C[5]) THEN DO:
        PUT UNFORMATTED
            s-NomCia SKIP(1)
            "REPORTE DE CIERRE DE CAJA" SKIP(1)
            "Division      : " s-Divi SKIP
            "Cajero        : " w-report.Campo-C[1] " " w-report.Campo-C[4] SKIP
            "Cierre        : " x-FchCie " " w-report.Campo-C[5] SKIP
            "Tipo de Cambio: " STRING(xTpoCmb, '>,>>9.99')
            SKIP(1)
            "FORMAS DE PAGO                                SOLES    DOLARES" SKIP
            "--------------------------------------------------------------" SKIP.
           /*12345678901234567890123456789012345678901234567890123456789012345678901234567890*/
           /*                      TOTAL INGRESOS >>> */
           /*                       TOTAL EGRESOS >>> */
           /*                           SUB-TOTAL >>> */
           /*1234567890123456789012345678901234567890 >>>,>>9.99 >>>,>>9.99*/
    END.
    IF FIRST-OF(w-report.Campo-I[1]) THEN DO:
        CASE w-report.Campo-I[1]:
            WHEN 1 THEN PUT UNFORMATTED "INGRESOS" SKIP.
            WHEN 2 THEN PUT UNFORMATTED "EGRESOS" SKIP.
        END CASE.
        ASSIGN
            ImpNacCja = 0
            ImpUsaCja = 0.
    END.
    /* Acumuladores Totales */
    ACCUMULATE w-report.Campo-F[3] (SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5]) ).
    ACCUMULATE w-report.Campo-F[4] (SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5]) ).
    ACCUMULATE w-report.Campo-F[5] (SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5]) ).
    ACCUMULATE w-report.Campo-F[6] (SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5]) ).
    /* Acumuladores por (1) INGRESOS (2) EGRESOS */
    ACCUMULATE w-report.Campo-F[1] (SUB-TOTAL BY w-report.Campo-I[1]).
    ACCUMULATE w-report.Campo-F[2] (SUB-TOTAL BY w-report.Campo-I[1]).
    /* Acumuladores por (1) DINERO (2) APLICACIONES */
    ACCUMULATE w-report.Campo-F[1] (SUB-TOTAL BY w-report.Campo-I[2]).
    ACCUMULATE w-report.Campo-F[2] (SUB-TOTAL BY w-report.Campo-I[2]).
    IF w-report.Campo-I[2] = 1 THEN ImpNacCja = ImpNacCja + w-report.Campo-F[1].
    IF w-report.Campo-I[2] = 1 THEN ImpUsaCja = ImpUsaCja + w-report.Campo-F[2].
    PUT 
        w-report.Campo-C[3] AT 5  FORMAT 'x(25)'
        w-report.Campo-F[1] AT 42 FORMAT '>>>,>>9.99'
        w-report.Campo-F[2] AT 53 FORMAT '>>>,>>9.99'
        SKIP.
    IF LAST-OF(w-report.Campo-I[2]) THEN DO:
        PUT
            'SUB-TOTAL >>>' AT 28
            ACCUM SUB-TOTAL BY w-report.Campo-I[2] w-report.Campo-F[1] AT 42 FORMAT '>>>,>>9.99'
            ACCUM SUB-TOTAL BY w-report.Campo-I[2] w-report.Campo-F[2] AT 53 FORMAT '>>>,>>9.99'
            SKIP.
    END.
    IF LAST-OF(w-report.Campo-I[1]) THEN DO:
        CASE w-report.Campo-I[1]:
            WHEN 1 THEN PUT 'TOTAL INGRESOS >>>' AT 23.
            WHEN 2 THEN PUT ' TOTAL EGRESOS >>>' AT 23.
        END CASE.
        PUT
/*             ACCUM SUB-TOTAL BY w-report.Campo-I[1] w-report.Campo-F[1] AT 42 FORMAT '>>>,>>9.99' */
/*             ACCUM SUB-TOTAL BY w-report.Campo-I[1] w-report.Campo-F[2] AT 53 FORMAT '>>>,>>9.99' */
            ImpNacCja AT 42 FORMAT '>>>,>>9.99'
            ImpUsaCja AT 53 FORMAT '>>>,>>9.99'
            SKIP(1).
    END.
    IF LAST-OF((w-report.Campo-C[1] + w-report.Campo-C[5]) ) THEN DO:
        ASSIGN
            TotDecNac = ACCUM SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5])  w-report.Campo-F[3]
            TotDecUsa = ACCUM SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5])  w-report.Campo-F[4]
            TotEfeNac = ACCUM SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5])  w-report.Campo-F[5]
            TotEfeUsa = ACCUM SUB-TOTAL BY (w-report.Campo-C[1] + w-report.Campo-C[5])  w-report.Campo-F[6].
        PUT UNFORMATTED
            SKIP
            "EFECTIVO DECLARADO" AT 15 TotDecNac AT 42 FORMAT '>>>,>>9.99' TotDecUsa AT 53 FORMAT '>>>,>>9.99' SKIP
            "  EFECTIVO SISTEMA" AT 15 TotEfeNac AT 42 FORMAT '>>>,>>9.99' TotEfeUsa AT 53 FORMAT '>>>,>>9.99' SKIP
            "        DIFERENCIA" AT 15 (TotDecNac - TotEfeNac) AT 42 FORMAT '>>>,>>9.99' 
            (TotDecUsa - TotEfeUsa) AT 53 FORMAT '>>>,>>9.99' SKIP
            .
        PUT UNFORMATTED
            SKIP(3)
            "---------------------------------------" SKIP
            "                CAJERO                 " SKIP(4)
            "---------------------------------------" SKIP
            "             ADMINISTRADOR             " SKIP(3).
    END.
END.
/*OUTPUT CLOSE.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Boveda D-Dialog 
PROCEDURE Formato-Boveda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Resumen de productos */
PUT UNFORMATTED
    s-NomCia SKIP(1)
    "REPORTE DE CIERRE DE CAJA - ANEXO DE REMESAS A BOVEDA" SKIP(1)
    "Division    : " s-Divi SKIP
    "Cajero      : " Ccbcierr.Usuario SKIP
    "Cierre      : " Ccbcierr.FchCie " " Ccbcierr.HorCie SKIP
    "Comprobante : " STRING(Ccbcierr.FchCie, '99999999') + REPLACE(Ccbcierr.HorCie, ":", "")
    SKIP(1)
    "Correlativo     Hora                    Importe S/. Importe US$" SKIP
    "---------------------------------------------------------------" SKIP.
   /*12345678901234567890123456789012345678901234567890123456789012345678901234567890*/
   /*123456789012345 HH:MM:SS                 >>>,>>9.99 >>>,>>9.99*/

FOR EACH Boveda BREAK BY Boveda.codcia:
    ACCUMULATE Boveda.ImpNac[1] (SUB-TOTAL BY Boveda.CodCia).
    ACCUMULATE Boveda.ImpUsa[1] (SUB-TOTAL BY Boveda.CodCia).
    PUT
        Boveda.NroDoc FORMAT 'x(15)'
        Boveda.Voucher[10] AT 17 FORMAT 'x(8)'
        Boveda.ImpNac[1]  AT 43 FORMAT '>>>,>>9.99'
        Boveda.ImpUsa[1]  AT 54 FORMAT '>>>,>>9.99'
        SKIP.
    IF LAST-OF(Boveda.CodCia) THEN DO:
        PUT
            'TOTAL' AT 20
            (ACCUM SUB-TOTAL BY Boveda.CodCia Boveda.ImpNac[1]) AT 43 FORMAT '>>>,>>9.99'
            (ACCUM SUB-TOTAL BY Boveda.CodCia Boveda.ImpUsa[1]) AT 54 FORMAT '>>>,>>9.99'
            SKIP(1).
    END.
END.
PUT UNFORMATTED
    SKIP(3)
    "---------------------------------------" SKIP
    "                CAJERO                 " SKIP(4)
    "---------------------------------------" SKIP
    "             ADMINISTRADOR             " SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Tarjetas D-Dialog 
PROCEDURE Formato-Tarjetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Resumen de productos */
PUT UNFORMATTED
    s-NomCia SKIP(1)
    "REPORTE DE CIERRE DE CAJA - ANEXO DE TARJETAS DE CREDITO" SKIP(1)
    "Division    : " s-Divi SKIP
    "Cajero      : " Ccbcierr.Usuario SKIP
    "Cierre      : " Ccbcierr.FchCie " " Ccbcierr.HorCie SKIP
    "Comprobante : " STRING(Ccbcierr.FchCie, '99999999') + REPLACE(Ccbcierr.HorCie, ":", "")
    SKIP(1)
    "Tarjeta              Voucher            Importe S/. Importe US$" SKIP
    "---------------------------------------------------------------" SKIP.
   /*12345678901234567890123456789012345678901234567890123456789012345678901234567890*/
   /*12345678901234567890 12345678901234567890 >>>,>>9.99 >>>,>>9.99*/

FOR EACH Tarjetas BREAK BY Tarjetas.codcia BY Tarjetas.voucher[9]:
    ACCUMULATE Tarjetas.ImpNac[4] (SUB-TOTAL BY Tarjetas.CodCia).
    ACCUMULATE Tarjetas.ImpUsa[4] (SUB-TOTAL BY Tarjetas.CodCia).
    ACCUMULATE Tarjetas.ImpNac[4] (SUB-TOTAL BY Tarjetas.Voucher[9]).
    ACCUMULATE Tarjetas.ImpUsa[4] (SUB-TOTAL BY Tarjetas.Voucher[9]).
    PUT
        Tarjetas.Voucher[9] FORMAT 'x(20)'
        Tarjetas.Voucher[4] AT 22 FORMAT 'x(20)'
        Tarjetas.ImpNac[4]  AT 43 FORMAT '>>>,>>9.99'
        Tarjetas.ImpUsa[4]  AT 54 FORMAT '>>>,>>9.99'
        SKIP.
    IF LAST-OF(Tarjetas.Voucher[9]) THEN DO:
        PUT
            'SUB-TOTAL' AT 20
            (ACCUM SUB-TOTAL BY Tarjetas.Voucher[9] Tarjetas.ImpNac[4]) AT 43 FORMAT '>>>,>>9.99'
            (ACCUM SUB-TOTAL BY Tarjetas.Voucher[9] Tarjetas.ImpUsa[4]) AT 54 FORMAT '>>>,>>9.99'
            SKIP(1).
    END.
    IF LAST-OF(Tarjetas.CodCia) THEN DO:
        PUT
            'TOTAL' AT 20
            (ACCUM SUB-TOTAL BY Tarjetas.CodCia Tarjetas.ImpNac[4]) AT 43 FORMAT '>>>,>>9.99'
            (ACCUM SUB-TOTAL BY Tarjetas.CodCia Tarjetas.ImpUsa[4]) AT 54 FORMAT '>>>,>>9.99'
            SKIP(1).
    END.
END.
PUT UNFORMATTED
    SKIP(3)
    "---------------------------------------" SKIP
    "                CAJERO                 " SKIP(4)
    "---------------------------------------" SKIP
    "             ADMINISTRADOR             " SKIP.

/*OUTPUT CLOSE.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-Vales D-Dialog 
PROCEDURE Formato-Vales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Resumen de productos */
PUT UNFORMATTED
    s-NomCia SKIP(1)
    "REPORTE DE CIERRE DE CAJA - ANEXO DE VALES DE CONSUMO" SKIP(1)
    "Division    : " s-Divi SKIP
    "Cajero      : " Ccbcierr.Usuario SKIP
    "Cierre      : " Ccbcierr.FchCie " " Ccbcierr.HorCie SKIP
    "Comprobante : " STRING(Ccbcierr.FchCie, '99999999') + REPLACE(Ccbcierr.HorCie, ":", "")
    SKIP(1)
    "Proveedor                                Producto  Importe S/." SKIP
    "--------------------------------------------------------------" SKIP.
   /*12345678901234567890123456789012345678901234567890123456789012345678901234567890*/
   /*1234567890123456789012345678901234567890 123456789 >>>,>>9.99*/
FOR EACH Detalle, FIRST Vtactickets OF Detalle NO-LOCK,
    FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND gn-prov.codpro = Vtactickets.codpro
    BREAK BY Vtactickets.CodCia BY Vtactickets.Producto:
    ACCUMULATE Detalle.Valor (TOTAL BY Vtactickets.CodCia).
    ACCUMULATE Detalle.Valor (SUB-TOTAL BY Vtactickets.Producto).
    IF LAST-OF(Vtactickets.Producto) THEN DO:
        PUT
            gn-prov.NomPro FORMAT 'x(40)' ' '
            Vtactickets.producto ' '
            (ACCUM SUB-TOTAL BY Vtactickets.Producto Detalle.Valor) FORMAT '>>>,>>9.99'
            SKIP.
    END.
    IF LAST-OF(Vtactickets.CodCia) THEN DO:
        PUT
            '-----------' AT 52 SKIP
            'TOTAL' AT 42
            ACCUM TOTAL BY Vtactickets.CodCia Detalle.Valor AT 51 FORMAT '>>>,>>9.99'
            SKIP.
    END.
END.
PUT ' ' SKIP.
/* Detalle */
PUT UNFORMATTED
    "Número          Importe S/.  Doc Número  " SKIP
    "-----------------------------------------" SKIP.
   /*1234567890123456789012345678901234567890*/
   /*123456789012 >>>,>>9.99 123 123456789012*/
FOR EACH Detalle BREAK BY Detalle.Producto BY Detalle.NroTck:
    ACCUMULATE Detalle.Valor (SUB-TOTAL BY Detalle.Producto).
    IF FIRST-OF(Detalle.Producto) THEN DO:
        PUT 
            "PRODUCTO: " Detalle.Producto 
            SKIP.
    END.
    PUT
        Detalle.NroTck  FORMAT 'x(12)' ' '
        Detalle.Valor   FORMAT ">>>,>>9.99" ' '
        Detalle.CodRef  FORMAT 'x(3)' ' '
        Detalle.NroRef  FORMAT 'x(12)'
        SKIP.
    IF LAST-OF(Detalle.Producto) THEN DO:
        PUT
            'SUB-TOTAL' AT 2
            (ACCUM SUB-TOTAL BY Detalle.Producto Detalle.Valor) AT 14 FORMAT '>>>,>>9.99'
            SKIP.
    END.
END.
PUT UNFORMATTED
    SKIP(3)
    "---------------------------------------" SKIP
    "                CAJERO                 " SKIP(4)
    "---------------------------------------" SKIP
    "             ADMINISTRADOR             " SKIP.

/*OUTPUT CLOSE.*/

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
    
    DEF VAR i AS INT NO-UNDO.
    DEF VAR rpta AS LOG NO-UNDO.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
    
    RUN Carga-Temporal.
    FIND FIRST w-report WHERE
        w-report.task-no = s-task-no AND
        w-report.Llave-C = s-user-id 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE w-report THEN DO:
        MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
/*     RUN Carga-Temporal-Vales. */
/*     x-Lineas = 0.                                                                                  */
/*     FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no AND w-report.llave-c = s-user-id: */
/*         x-Lineas = x-Lineas + 1.                                                                   */
/*     END.                                                                                           */
/*     DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:                                */
/*         IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.                                     */
/*         /* Por cada cierre imprimimos un recibo */                                                 */
/*         RUN Carga-Temporal-Vales.                                                                  */
/*         FOR EACH Detalle:                                                                          */
/*             x-Lineas = x-Lineas + 1.                                                               */
/*         END.                                                                                       */
/*     END.                                                                                           */
/*     /* AGREGAMOS LOS TITULOS Y PIE DE PAGINA */                                                    */
/*     x-Lineas = x-Lineas + 20.                                                                      */

    OUTPUT TO PRINTER PAGE-SIZE 1000.
    /*PUT CONTROL CHR(27) + CHR(112) + CHR(48) .*/
    PUT CONTROL {&PRN0} + {&PRN5A} + CHR(1000) + {&PRN4}.

    RUN Formato.
    
    /* Imprimimos el detalle de vales de consumo */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /* Por cada cierre imprimimos un recibo */
        RUN Carga-Temporal-Vales.
        FIND FIRST Detalle NO-ERROR.
        IF NOT AVAILABLE Detalle THEN NEXT.
        RUN Formato-Vales.
    END.
    /* Imprimimos el detalle de las tarjetas de crédito */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /* Por cada cierre imprimimos un recibo */
        RUN Carga-Temporal-Tarjetas.
        FIND FIRST Tarjetas NO-ERROR.
        IF NOT AVAILABLE Tarjetas THEN NEXT.
        RUN Formato-Tarjetas.
    END.
    /* Imprimimos el detalle de los depósitos a bóveda */
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME D-Dialog:
        IF NOT {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN NEXT.
        /* Por cada cierre imprimimos un recibo */
        RUN Carga-Temporal-Boveda.
        FIND FIRST Boveda NO-ERROR.
        IF NOT AVAILABLE Boveda THEN NEXT.
        RUN Formato-Boveda.
    END.

    OUTPUT CLOSE.
    

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
  {src/adm/template/snd-list.i "CcbCierr"}
  {src/adm/template/snd-list.i "CcbCCaja"}

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

