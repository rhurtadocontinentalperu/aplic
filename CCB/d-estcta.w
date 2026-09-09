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
DEF INPUT PARAMETER x-Rowid AS ROWID.

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR s-nomCia AS CHAR.

/* Local Variable Definitions ---                                       */

DEF FRAME RB-MENSAJE
  " Procesando, un momento por favor... "
  WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX.

DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE T-REPORT LIKE W-REPORT.
DEFINE BUFFER B-DOCU FOR CcbCDocu.

DEF VAR x-Cargos AS CHAR INIT 'LET,BOL,CHQ,FAC,TCK,N/D' NO-UNDO.
DEF VAR x-Abonos AS CHAR INIT 'N/C,A/R'.

DEF VAR x-Saldo-Mn AS DEC NO-UNDO.
DEF VAR x-Saldo-Me AS DEC NO-UNDO.

FIND GN-CLIE WHERE ROWID(GN-CLIE) = x-Rowid NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog gn-clie.CodCli gn-clie.NomCli 
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli 
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 x-CodDiv RADIO-SET-1 

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

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Normal", 1,
"Expolibreria (en prueba)", 2
     SIZE 29 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      gn-clie SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     gn-clie.CodCli AT ROW 1.38 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     gn-clie.NomCli AT ROW 2.35 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
     x-FchDoc-1 AT ROW 3.31 COL 10 COLON-ALIGNED
     x-FchDoc-2 AT ROW 3.31 COL 29 COLON-ALIGNED
     x-CodDiv AT ROW 4.27 COL 10 COLON-ALIGNED
     RADIO-SET-1 AT ROW 5.23 COL 12 NO-LABEL
     Btn_OK AT ROW 7.73 COL 4
     Btn_Cancel AT ROW 7.73 COL 19
     SPACE(34.13) SKIP(0.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ESTADO DE CUENTA POR CLIENTE"
         CANCEL-BUTTON Btn_Cancel.


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
   L-To-R                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX x-CodDiv IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.gn-clie"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* ESTADO DE CUENTA POR CLIENTE */
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
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 x-CodDiv.
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 D-Dialog
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME D-Dialog
DO:
  IF SELF:SCREEN-VALUE = '2' 
  THEN x-CodDiv:SENSITIVE = YES.
  ELSE x-CodDiv:SENSITIVE = NO.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-2 D-Dialog 
PROCEDURE Carga-Temporal-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TpoCmb  AS DEC NO-UNDO.
  DEF VAR x-Factor  AS INT INIT 1 NO-UNDO.
  DEF BUFFER B-report FOR w-report.

  FOR EACH T-REPORT:
    DELETE T-REPORT.
  END.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.
  
  /* PRIMERO LOS CARGOS */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        AND LOOKUP(TRIM(B-DOCU.coddoc), x-Cargos) > 0
        AND (x-CodDiv = 'Todas' OR B-DOCU.CodDiv = x-CodDiv)
        AND (x-FchDoc-1 = ? OR B-DOCU.FchDoc >= x-FchDoc-1)
        AND (x-FchDoc-2 = ? OR B-DOCU.FchDoc <= x-FchDoc-2):
    CREATE w-report.
    ASSIGN
        w-report.task-no    = s-task-no
        w-report.llave-d    = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'A'
        w-report.llave-c    = B-DOCU.coddiv
        w-report.campo-c[1] = B-DOCU.coddoc
        w-report.campo-c[2] = B-DOCU.nrodoc
        w-report.campo-c[3] = B-DOCU.flgest
        w-report.llave-i    = B-DOCU.codmon.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[1] = B-DOCU.imptot.
    ELSE w-report.campo-f[3] = B-DOCU.imptot.
    IF LOOKUP(B-DOCU.flgest, 'A,X') > 0
    THEN x-Factor = 0.
    ELSE x-Factor = 1.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[2] = B-DOCU.imptot * x-factor.
    ELSE w-report.campo-f[4] = B-DOCU.imptot * x-factor.
  END.        
  /* SEGUNDO NOTAS DE ABONO */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        AND B-DOCU.coddoc = x-Abonos
        AND (x-CodDiv = 'Todas' OR B-DOCU.CodDiv = x-CodDiv)
        AND B-DOCU.flgest <> 'A'
        AND (x-FchDoc-1 = ? OR B-DOCU.fchdoc >= x-FchDoc-1)
        AND (x-FchDoc-2 = ? OR B-DOCU.fchdoc <= x-FchDoc-2):
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'B'
        w-report.llave-c = B-DOCU.coddiv
        w-report.campo-c[1] = B-DOCU.coddoc
        w-report.campo-c[2] = B-DOCU.nrodoc
        w-report.campo-c[3] = B-DOCU.flgest
        w-report.llave-i = B-DOCU.codmon.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[1] = B-DOCU.imptot.
    ELSE w-report.campo-f[3] = B-DOCU.imptot.
    x-Factor = -1.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[2] = B-DOCU.imptot * x-factor.
    ELSE w-report.campo-f[4] = B-DOCU.imptot * x-factor.
  END.        
  /* TERCERO BOLETAS DE DEPOSITO */
  FOR EACH CcbBolDep NO-LOCK WHERE ccbboldep.codcia = s-codcia
        AND ccbboldep.codcli = GN-CLIE.codcli
        AND ccbboldep.coddoc = 'BD'
        AND (x-CodDiv = 'Todas' OR CcbBolDep.CodDiv = x-CodDiv)
        AND ccbboldep.flgest <> 'A'
        AND (x-FchDoc-1 = ? OR CcbBolDep.fchdoc >= x-FchDoc-1)
        AND (x-FchDoc-2 = ? OR CcbBolDep.fchdoc <= x-FchDoc-2):
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = ccbboldep.fchdoc
        w-report.campo-c[10] = 'C'
        w-report.llave-c = ccbboldep.coddiv
        w-report.campo-c[1] = ccbboldep.coddoc
        w-report.campo-c[2] = ccbboldep.nrodoc
        w-report.llave-i = ccbboldep.codmon.
    IF ccbboldep.codmon = 1
    THEN w-report.campo-f[1] = ccbboldep.imptot.
    ELSE w-report.campo-f[3] = ccbboldep.imptot.
    x-Factor = -1.
    IF ccbboldep.codmon = 1
    THEN w-report.campo-f[2] = ccbboldep.imptot * x-factor.
    ELSE w-report.campo-f[4] = ccbboldep.imptot * x-factor.
  END.        
  /* CUARTO ANTICIPOS POR APLICAR */
  FOR EACH CcbAntRec NO-LOCK WHERE ccbantrec.codcia = s-codcia
        AND ccbantrec.codcli = GN-CLIE.codcli
        AND ccbantrec.coddoc = 'A/R'
        AND (x-CodDiv = 'Todas' OR CcbAntRec.CodDiv = x-CodDiv)
        AND ccbantrec.flgest <> 'A':
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = ccbantrec.fchdoc
        w-report.campo-c[10] = 'D'
        w-report.llave-c = ccbantrec.coddiv
        w-report.campo-c[1] = ccbantrec.coddoc
        w-report.campo-c[2] = ccbantrec.nrodoc
        w-report.llave-i = ccbantrec.codmon.
    IF ccbantrec.codmon = 1
    THEN w-report.campo-f[1] = ccbantrec.imptot.
    ELSE w-report.campo-f[3] = ccbantrec.imptot.
    x-Factor = -1.
    IF ccbantrec.codmon = 1
    THEN w-report.campo-f[2] = ccbantrec.imptot * x-factor.
    ELSE w-report.campo-f[4] = ccbantrec.imptot * x-factor.
  END.        
/*  /* CUARTO ANTICIPOS POR APLICAR */
 *   FOR EACH CcbAntRec NO-LOCK WHERE ccbantrec.codcia = s-codcia
 *         AND ccbantrec.codcli = GN-CLIE.codcli
 *         AND ccbantrec.coddoc = 'A/R'
 *         AND (x-CodDiv = 'Todas' OR CcbAntRec.CodDiv = x-CodDiv)
 *         AND ccbantrec.flgest <> 'A':
 *     FIND w-report WHERE w-report.task-no = s-task-no
 *         AND w-report.campo-c[10] = 'D'
 *         AND w-report.llave-c = ccbantrec.coddiv
 *         EXCLUSIVE-LOCK NO-ERROR.
 *     IF NOT AVAILABLE w-report THEN DO:
 *         CREATE w-report.
 *         ASSIGN
 *             w-report.task-no = s-task-no
 *             w-report.campo-c[10] = 'D'
 *             w-report.llave-c = ccbantrec.coddiv.
 *     END.
 *     IF ccbantrec.codmon = 1
 *     THEN w-report.campo-f[1] = w-report.campo-f[1] + ccbantrec.imptot.
 *     ELSE w-report.campo-f[3] = w-report.campo-f[3] + ccbantrec.imptot.
 *     x-Factor = -1.
 *     IF ccbantrec.codmon = 1
 *     THEN w-report.campo-f[2] = w-report.campo-f[2] + ccbantrec.imptot * x-factor.
 *     ELSE w-report.campo-f[4] = w-report.campo-f[4] + ccbantrec.imptot * x-factor.
 *   END.        */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-3 D-Dialog 
PROCEDURE Carga-Temporal-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-TpoCmb  AS DEC NO-UNDO.
  DEF BUFFER B-report FOR w-report.

  FOR EACH T-REPORT:
    DELETE T-REPORT.
  END.

  REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
    THEN LEAVE.
  END.
  
  /* PRIMERO LOS CARGOS */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        /*AND LOOKUP(TRIM(B-DOCU.coddoc), 'LET,BOL,CHQ,FAC,TCK,N/D') > 0*/
        AND LOOKUP(TRIM(B-DOCU.coddoc), x-Cargos) > 0
        AND LOOKUP(B-DOCU.flgest, 'A,X') = 0:
/*        AND B-DOCU.flgest <> 'A':*/
    CREATE w-report.
    ASSIGN
        w-report.task-no    = s-task-no
        w-report.llave-d    = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'A'
        w-report.llave-c    = B-DOCU.coddiv
        w-report.campo-c[1] = B-DOCU.coddoc
        w-report.campo-c[2] = B-DOCU.nrodoc
        w-report.llave-i    = B-DOCU.codmon.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[1] = B-DOCU.imptot.
    ELSE w-report.campo-f[3] = B-DOCU.imptot.
  END.        
  /* SEGUNDO LAS CANCELACIONES */
  FOR EACH w-report WHERE w-report.task-no = s-task-no
        /*AND LOOKUP(TRIM(w-report.campo-c[1]), 'LET,BOL,CHQ,FAC,TCK,N/D') > 0:*/
        AND LOOKUP(TRIM(w-report.campo-c[1]), x-Cargos) > 0:
    FOR EACH ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = s-codcia
            AND CcbDCaja.CodRef = w-report.campo-c[1]
            AND CcbDCaja.NroRef = w-report.campo-c[2]:
        CREATE t-report.
        ASSIGN
            t-report.task-no = s-task-no
            t-report.llave-d = ccbdcaja.fchdoc
            t-report.llave-c = w-report.llave-c
            t-report.campo-c[10] = 'B'
            t-report.campo-c[1] = ccbdcaja.coddoc
            t-report.campo-c[2] = ccbdcaja.nrodoc
            t-report.campo-c[3] = w-report.campo-c[1]
            t-report.campo-c[4] = w-report.campo-c[2]
            t-report.llave-i = ccbdcaja.codmon.
        IF ccbdcaja.codmon = 1
        THEN t-report.campo-f[2] = ccbdcaja.imptot.
        ELSE t-report.campo-f[4] = ccbdcaja.imptot.
    END.
  END.

  /* TERCERO NOTAS DE ABONO POR APLICAR */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        /*AND B-DOCU.coddoc = 'N/C'*/
        AND B-DOCU.coddoc = x-Abonos
        AND B-DOCU.flgest = 'P':
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'C'
        w-report.llave-c = B-DOCU.coddiv
        w-report.campo-c[1] = B-DOCU.coddoc
        w-report.campo-c[2] = B-DOCU.nrodoc
        w-report.llave-i = B-DOCU.codmon.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[2] = B-DOCU.sdoact.
    ELSE w-report.campo-f[4] = B-DOCU.sdoact.
  END.        
  /* CUARTO BOLETAS DE DEPOSITO POR APLICAR */
  FOR EACH CcbBolDep NO-LOCK WHERE ccbboldep.codcia = s-codcia
        AND ccbboldep.codcli = GN-CLIE.codcli
        AND ccbboldep.coddoc = 'BD'
        AND ccbboldep.flgest = 'P'
        AND ccbboldep.fchdoc >= DATE(09,01,2004):   /* PATTY SEN */
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = ccbboldep.fchdoc
        w-report.campo-c[10] = 'D'
        w-report.llave-c = ccbboldep.coddiv
        w-report.campo-c[1] = ccbboldep.coddoc
        w-report.campo-c[2] = ccbboldep.nrodoc
        w-report.llave-i = ccbboldep.codmon.
    IF ccbboldep.codmon = 1
    THEN w-report.campo-f[2] = ccbboldep.sdoact.
    ELSE w-report.campo-f[4] = ccbboldep.sdoact.
  END.        
/*  /* QUINTO ANTICIPOS POR APLICAR */
 *   FOR EACH CcbAntRec NO-LOCK WHERE ccbantrec.codcia = s-codcia
 *         AND ccbantrec.codcli = GN-CLIE.codcli
 *         AND ccbantrec.coddoc = 'A/R'
 *         AND ccbantrec.flgest = 'P':
 *     CREATE w-report.
 *     ASSIGN
 *         w-report.task-no = s-task-no
 *         w-report.llave-d = ccbantrec.fchdoc
 *         w-report.campo-c[10] = 'E'
 *         w-report.llave-c = ccbantrec.coddiv
 *         w-report.campo-c[1] = ccbantrec.coddoc
 *         w-report.campo-c[2] = ccbantrec.nrodoc
 *         w-report.llave-i = ccbantrec.codmon.
 *     IF ccbantrec.codmon = 1
 *     THEN w-report.campo-f[2] = ccbantrec.sdoact.
 *     ELSE w-report.campo-f[4] = ccbantrec.sdoact.
 *   END.        */

  /* MIGRAMOS LAS CANCELACIONES PERO LOS I/C VAN RESUMIDOS */
  FOR EACH T-REPORT:
    IF T-REPORT.campo-c[1] = 'I/C'
    THEN DO:
        FIND w-report WHERE w-report.task-no = t-report.task-no
            AND w-report.campo-c[1] = t-report.campo-c[1]
            AND w-report.campo-c[2] = t-report.campo-c[2]
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE w-report
        THEN DO:
            CREATE w-report.
            BUFFER-COPY t-report TO w-report
                ASSIGN w-report.campo-f[2] = 0
                        w-report.campo-f[4] = 0.
        END.            
        ASSIGN
            w-report.campo-f[2] = w-report.campo-f[2] + t-report.campo-f[2]
            w-report.campo-f[4] = w-report.campo-f[4] + t-report.campo-f[4].
        /* BUSCAMOS INFORMACION DEL I/C */
        FIND ccbccaja WHERE ccbccaja.codcia = s-codcia
            AND ccbccaja.coddoc = w-report.campo-c[1]
            AND ccbccaja.nrodoc = w-report.campo-c[2]
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbccaja
        THEN ASSIGN 
                w-report.llave-c    = CcbCCaja.coddiv
                w-report.campo-c[6] = TRIM( CcbCCaja.Voucher[1] +
                                            CcbCCaja.Voucher[2] +
                                            CcbCCaja.Voucher[3] +
                                            CcbCCaja.Voucher[4] +
                                            CcbCCaja.Voucher[5] +
                                            CcbCCaja.Voucher[6] +
                                            CcbCCaja.Voucher[7] +
                                            CcbCCaja.Voucher[8] +
                                            CcbCCaja.Voucher[9] +
                                            CcbCCaja.Voucher[10] ).
    END.
    ELSE DO:
        CREATE w-report.
        BUFFER-COPY t-report TO w-report.
    END.
  END.

  /* DETERMINAMOS EL SALDO INICIAL Y BORRAMOS LO QUE SOBRA */
  ASSIGN
    x-Saldo-Mn = 0
    x-Saldo-Me = 0.
  FOR EACH w-report WHERE w-report.task-no = s-task-no BY w-report.llave-d BY w-report.campo-c[10]:
    IF x-FChDoc-1 <> ? AND w-report.llave-d < x-FchDoc-1
    THEN DO:
        ASSIGN
            x-Saldo-Mn = x-Saldo-Mn + (w-report.campo-f[1] - w-report.campo-f[2])
            x-Saldo-Me = x-Saldo-Me + (w-report.campo-f[3] - w-report.campo-f[4]).
        DELETE w-report.
        NEXT.
    END.
    IF x-FchDoc-2 <> ? AND w-report.llave-d > x-FchDoc-2 THEN DELETE w-report.
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
  DISPLAY x-FchDoc-1 x-FchDoc-2 x-CodDiv RADIO-SET-1 
      WITH FRAME D-Dialog.
  IF AVAILABLE gn-clie THEN 
    DISPLAY gn-clie.CodCli gn-clie.NomCli 
      WITH FRAME D-Dialog.
  ENABLE x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-2 D-Dialog 
PROCEDURE Formato-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Cuenta Corriente 5'       /* A LA MONEDA DEL DOCUMENTO */
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no)
    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia +
                            '~ns-codcli = ' + gn-clie.codcli +
                             '~ns-nomcli = ' + gn-clie.nomcli +
                             '~np-saldo-mn = ' + STRING(x-saldo-mn) +
                             '~np-saldo-me = ' + STRING(x-saldo-me).
  IF x-FchDoc-1 <> ? THEN RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + '~np-fchdoc-1 = ' + STRING(x-fchdoc-1, '99/99/9999').
  IF x-FchDoc-2 <> ? THEN RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + '~np-fchdoc-2 = ' + STRING(x-fchdoc-2, '99/99/9999').
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 D-Dialog 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  ASSIGN
    RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'
    RB-REPORT-NAME = 'Cuenta Corriente 4'       /* A LA MONEDA DEL DOCUMENTO */
    RB-INCLUDE-RECORDS = 'O'
    RB-FILTER = 'w-report.task-no = ' + STRING(s-task-no)
    RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia +
                            '~ns-codcli = ' + gn-clie.codcli +
                             '~ns-nomcli = ' + gn-clie.nomcli +
                             '~np-saldo-mn = ' + STRING(x-saldo-mn) +
                             '~np-saldo-me = ' + STRING(x-saldo-me).
  IF x-FchDoc-1 <> ? THEN RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + '~np-fchdoc-1 = ' + STRING(x-fchdoc-1, '99/99/9999').
  IF x-FchDoc-2 <> ? THEN RB-OTHER-PARAMETERS = RB-OTHER-PARAMETERS + '~np-fchdoc-2 = ' + STRING(x-fchdoc-2, '99/99/9999').
  RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime D-Dialog 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  VIEW FRAME RB-MENSAJE.                    
  CASE RADIO-SET-1:
    WHEN 1 THEN RUN Carga-Temporal-3.   /* Saldo de acuerdo a la moneda de origen */
    WHEN 2 THEN RUN Carga-Temporal-2.
  END CASE.
  HIDE FRAME RB-MENSAJE.

  IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK)
  THEN DO:
    MESSAGE 'NO hay registros a imprimir' VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  CASE RADIO-SET-1:
    WHEN 1 THEN RUN Formato-3.   /* Saldo de acuerdo a la moneda de origen */
    WHEN 2 THEN RUN Formato-2.
  END CASE.
  
  VIEW FRAME RB-MENSAJE.                    
  FOR EACH w-report WHERE w-report.task-no = s-task-no:
    DELETE w-report.
  END.
  HIDE FRAME RB-MENSAJE.


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
  ASSIGN
    x-FchDoc-1 = TODAY - DAY(TODAY) + 1
    x-FchDoc-2 = TODAY.

  FOR EACH GN-DIVI WHERE gn-divi.codcia = s-codcia NO-LOCK:
    x-CodDiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "gn-clie"}

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


