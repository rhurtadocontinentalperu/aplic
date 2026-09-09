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
DEF INPUT PARAMETER x-Rowid AS ROWID.

DEFINE SHARED VAR s-CodCia AS INTEGER.
DEFINE SHARED VAR s-nomCia AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE STREAM Report.

/* Local Variable Definitions ---                                       */

DEF FRAME RB-MENSAJE
  " Procesando, un momento por favor... "
  WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX.

/* VARIABLES PARA LA IMPRESION */
{src/bin/_prns.i}

DEF VAR RB-REPORT-LIBRARY AS CHAR.
DEF VAR RB-REPORT-NAME AS CHAR.
DEF VAR RB-INCLUDE-RECORDS AS CHAR.
DEF VAR RB-FILTER AS CHAR.
DEF VAR RB-OTHER-PARAMETERS AS CHAR.
DEF VAR RB-DB-CONNECTION AS CHAR.
DEF VAR RB-MEMO-FILE AS CHAR.
DEF VAR RB-PRINT-DESTINATION AS CHAR.
DEF VAR RB-PRINTER-NAME AS CHAR.
DEF VAR RB-PRINTER-PORT AS CHAR.
DEF VAR RB-OUTPUT-FILE AS CHAR.
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER.
DEF VAR RB-END-PAGE AS INTEGER.
DEF VAR RB-TEST-PATTERN AS LOGICAL.
DEF VAR RB-WINDOW-TITLE AS CHARACTER.
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INIT YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INIT YES.
DEF VAR RB-NO-WAIT AS LOGICAL.

DEF VAR s-task-no AS INT NO-UNDO.

DEF TEMP-TABLE T-REPORT LIKE W-REPORT.
DEFINE BUFFER B-DOCU FOR CcbCDocu.

DEF VAR x-Cargos AS CHAR INIT 'LET,BOL,CHQ,FAC,TCK,N/D' NO-UNDO.
DEF VAR x-Abonos AS CHAR INIT 'N/C,A/R,BD,A/C'.

DEF VAR x-Saldo-Mn AS DEC NO-UNDO.
DEF VAR x-Saldo-Me AS DEC NO-UNDO.

FIND GN-CLIE WHERE ROWID(GN-CLIE) = x-Rowid NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gn-clie

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog gn-clie.CodCli gn-clie.NomCli 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH gn-clie SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH gn-clie SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog gn-clie
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog gn-clie


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 Btn_OK ~
Btn_Cancel BUTTON-9 
&Scoped-Define DISPLAYED-FIELDS gn-clie.CodCli gn-clie.NomCli 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS x-FchDoc-1 x-FchDoc-2 x-CodDiv RADIO-SET-1 ~
TOGGLE-1 TOGGLE-2 TOGGLE-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Imprimir" 
     SIZE 12 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Texto" 
     SIZE 12 BY 1.54.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
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
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Normal", 1,
"Expolibreria", 2,
"EN PRUEBA", 3
     SIZE 16 BY 2.5 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL yes 
     LABEL "Estado de Cuenta" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL yes 
     LABEL "Aplicación" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-3 AS LOGICAL INITIAL yes 
     LABEL "Saldo" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.29 BY .77 NO-UNDO.

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
     TOGGLE-1 AT ROW 5.23 COL 32 WIDGET-ID 8
     TOGGLE-2 AT ROW 6.19 COL 32 WIDGET-ID 10
     TOGGLE-3 AT ROW 7.15 COL 32 WIDGET-ID 6
     Btn_OK AT ROW 8.5 COL 4
     Btn_Cancel AT ROW 8.5 COL 16
     BUTTON-9 AT ROW 8.5 COL 28 WIDGET-ID 2
     SPACE(25.13) SKIP(0.18)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-clie.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-clie.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-3 IN FRAME D-Dialog
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
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Imprimir */
DO:
  ASSIGN
    x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 x-CodDiv.
  ASSIGN TOGGLE-1 TOGGLE-2 TOGGLE-3.
  RUN dispatch IN THIS-PROCEDURE ('imprime':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 D-Dialog
ON CHOOSE OF BUTTON-9 IN FRAME D-Dialog /* Texto */
DO:
    ASSIGN
        x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 x-CodDiv.

    VIEW FRAME RB-MENSAJE.   
        RUN Texto.
    HIDE FRAME RB-MENSAJE.   

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
  IF SELF:SCREEN-VALUE = '3' 
      THEN ASSIGN
      TOGGLE-1:SENSITIVE = YES
      TOGGLE-2:SENSITIVE = YES
      TOGGLE-3:SENSITIVE = YES.
  ELSE ASSIGN
      TOGGLE-1:SENSITIVE = NO
      TOGGLE-2:SENSITIVE = NO
      TOGGLE-3:SENSITIVE = NO.
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
VIEW FRAME RB-MENSAJE.  
  /* PRIMERO LOS CARGOS */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        AND LOOKUP(TRIM(B-DOCU.coddoc), x-Cargos) > 0
        /*AND (x-CodDiv = 'Todas' OR B-DOCU.CodDiv = x-CodDiv)*/
        AND (x-CodDiv = 'Todas' OR B-DOCU.DivOri = x-CodDiv)
        AND (x-FchDoc-1 = ? OR B-DOCU.FchDoc >= x-FchDoc-1)
        AND (x-FchDoc-2 = ? OR B-DOCU.FchDoc <= x-FchDoc-2)
        AND B-DOCU.flgest <> 'A':
    CREATE w-report.
    ASSIGN
        w-report.task-no    = s-task-no
        w-report.llave-d    = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'A'
        w-report.llave-c    = B-DOCU.divori     /*B-DOCU.coddiv*/
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
        AND LOOKUP(TRIM(B-DOCU.coddoc), x-Abonos) > 0
        /*AND (x-CodDiv = 'Todas' OR B-DOCU.CodDiv = x-CodDiv)*/
        AND (x-CodDiv = 'Todas' OR B-DOCU.DivOri = x-CodDiv)
        AND LOOKUP(B-DOCU.flgest,'A,E') = 0
        AND (x-FchDoc-1 = ? OR B-DOCU.fchdoc >= x-FchDoc-1)
        AND (x-FchDoc-2 = ? OR B-DOCU.fchdoc <= x-FchDoc-2):
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-d = B-DOCU.fchdoc
        w-report.campo-d[1] = B-DOCU.fchcan
        w-report.campo-d[2] = B-DOCU.fchvto
        w-report.campo-c[10] = 'B'
        w-report.llave-c = B-DOCU.divori        /*B-DOCU.coddiv*/
        w-report.campo-c[1] = B-DOCU.coddoc
        w-report.campo-c[2] = B-DOCU.nrodoc
        w-report.campo-c[3] = B-DOCU.flgest
        w-report.llave-i = B-DOCU.codmon
        w-report.campo-c[5] = IF(B-DOCU.cndcre='D') THEN "DEVOLUCIONES" ELSE "OTROS"
        w-report.campo-c[6] = B-DOCU.glosa.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[1] = B-DOCU.imptot.
    ELSE w-report.campo-f[3] = B-DOCU.imptot.
    x-Factor = -1.
    IF B-DOCU.codmon = 1
    THEN w-report.campo-f[2] = B-DOCU.imptot * x-factor.
    ELSE w-report.campo-f[4] = B-DOCU.imptot * x-factor.
  END.        
/*   /* RHC 14.12.2010 FAC y BOL POR ANTICIPOS  */                 */
/*   FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia        */
/*       AND B-DOCU.codcli = gn-clie.codcli                        */
/*       AND LOOKUP(B-DOCU.coddoc, 'FAC,BOL') > 0                  */
/*       AND (x-CodDiv = 'Todas' OR B-DOCU.CodDiv = x-CodDiv)      */
/*       AND B-DOCU.TpoFac = "A"                                   */
/*       AND B-DOCU.flgest = "C"                                   */
/*       AND B-DOCU.FchDoc <= 12/14/2010                           */
/*       AND (x-FchDoc-1 = ? OR B-DOCU.fchdoc >= x-FchDoc-1)       */
/*       AND (x-FchDoc-2 = ? OR B-DOCU.fchdoc <= x-FchDoc-2):      */
/*       CREATE w-report.                                          */
/*       ASSIGN                                                    */
/*           w-report.task-no = s-task-no                          */
/*           w-report.llave-d = B-DOCU.fchdoc                      */
/*           w-report.campo-d[1] = B-DOCU.fchcan                   */
/*           w-report.campo-d[2] = B-DOCU.fchvto                   */
/*           w-report.campo-c[10] = 'B'                            */
/*           w-report.llave-c = B-DOCU.coddiv                      */
/*           w-report.campo-c[1] = "A/C"       /* B-DOCU.coddoc */ */
/*           w-report.campo-c[2] = B-DOCU.nrodoc                   */
/*           w-report.campo-c[3] = B-DOCU.flgest                   */
/*           w-report.llave-i = B-DOCU.codmon.                     */
/*       IF B-DOCU.codmon = 1                                      */
/*       THEN w-report.campo-f[1] = B-DOCU.imptot.                 */
/*       ELSE w-report.campo-f[3] = B-DOCU.imptot.                 */
/*       x-Factor = -1.                                            */
/*       IF B-DOCU.codmon = 1                                      */
/*       THEN w-report.campo-f[2] = B-DOCU.imptot * x-factor.      */
/*       ELSE w-report.campo-f[4] = B-DOCU.imptot * x-factor.      */
/*   END.                                                          */

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
  VIEW FRAME RB-MENSAJE.
  /* PRIMERO LOS CARGOS */
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        AND LOOKUP(TRIM(B-DOCU.coddoc), x-Cargos) > 0
        AND LOOKUP(B-DOCU.flgest, 'A,X') = 0:
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
        AND LOOKUP(TRIM(w-report.campo-c[1]), x-Cargos) > 0:
    FOR EACH ccbdcaja NO-LOCK WHERE CcbDCaja.CodCia = s-codcia
            AND CcbDCaja.CodRef = w-report.campo-c[1]
            AND CcbDCaja.NroRef = w-report.campo-c[2]
            AND CcbDCaja.ImpTot > 0:
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
        IF LOOKUP(t-report.campo-c[1], 'FAC,BOL') > 0 THEN t-report.campo-c[1] = 'A/C'.
    END.
  END.

  /* TERCERO ABONOS POR APLICAR (N/C A/R BD)*/
  FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.codcli = GN-CLIE.codcli
        /*AND B-DOCU.coddoc = 'N/C'*/
        AND lookup(B-DOCU.coddoc, x-Abonos) > 0
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

  /* RHC 14.12.2010 FAC y BOL POR ANTICIPOS POR APLICAR  */
/*   FOR EACH B-DOCU NO-LOCK WHERE B-DOCU.codcia = s-codcia        */
/*       AND LOOKUP(B-DOCU.coddoc, 'FAC,BOL') > 0                  */
/*       AND B-DOCU.codcli = gn-clie.codcli                        */
/*       AND B-DOCU.TpoFac = "A"                                   */
/*       AND B-DOCU.flgest = "C"                                   */
/*       AND B-DOCU.imptot2 > 0:                                   */
/*       CREATE w-report.                                          */
/*       ASSIGN                                                    */
/*           w-report.task-no = s-task-no                          */
/*           w-report.llave-d = B-DOCU.fchdoc                      */
/*           w-report.campo-d[1] = B-DOCU.fchcan                   */
/*           w-report.campo-d[2] = B-DOCU.fchvto                   */
/*           w-report.campo-c[10] = 'C'                            */
/*           w-report.llave-c = B-DOCU.coddiv                      */
/*           w-report.campo-c[1] = "A/C"       /* B-DOCU.coddoc */ */
/*           w-report.campo-c[2] = B-DOCU.nrodoc                   */
/*           w-report.llave-i = B-DOCU.codmon.                     */
/*       IF B-DOCU.codmon = 1                                      */
/*       THEN w-report.campo-f[2] = B-DOCU.imptot2.                */
/*       ELSE w-report.campo-f[4] = B-DOCU.imptot2.                */
/*   END.                                                          */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EECCGeneral D-Dialog 
PROCEDURE EECCGeneral :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  RUN bin/_prnctr.
  IF s-salida-impresion = 0 THEN RETURN.

  /* test de impresion */
  DEF VAR pTask-No AS INT NO-UNDO.
  DEF VAR pSaldoInicialSoles   AS DEC NO-UNDO.
  DEF VAR pSaldoInicialDolares AS DEC NO-UNDO.
  DEF VAR pFechaD AS DATE NO-UNDO.
  DEF VAR pFechaH AS DATE NO-UNDO.
  /* capturamos ruta inicial */
  DEF VAR S-REPORT-LIBRARY AS CHAR.
  GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
  /* base de datos */
  DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

  GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
  GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

  ASSIGN cDelimeter = CHR(32).
  IF NOT (cDatabaseName = ? OR
    cHostName = ? OR
    cNetworkProto = ? OR
    cPortNumber = ?) THEN DO:
    ASSIGN
        cNewConnString =
        "-db" + cDelimeter + cDatabaseName + cDelimeter +
        "-H" + cDelimeter + cHostName + cDelimeter +
        "-N" + cDelimeter + cNetworkProto + cDelimeter +
        "-S" + cDelimeter + cPortNumber + cDelimeter.
    RB-DB-CONNECTION = cNewConnString.
  END.

  ASSIGN
      pFechaD = x-FchDoc-1
      pFechaH = x-FchDoc-2.

  IF TOGGLE-1 = YES THEN DO:
      RUN ccb/p-eeccgeneral (gn-clie.codcli, s-user-id, pFechaD, pFechaH, 
                             OUTPUT pTask-No, OUTPUT pSaldoInicialSoles, OUTPUT pSaldoInicialDolares).
      IF pTask-No > 0 THEN DO:
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(pTask-No) +  
                      " AND w-report.Llave-C = '" + s-user-id + "'".
          RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
              "~nInicial-Soles = " + STRING(pSaldoInicialSoles) +
              "~nInicial-Dolares = " + STRING(pSaldoInicialDolares) +
              "~ns-nomcli = " + gn-clie.nomcli + 
              "~ns-desde = " + STRING(pFechaD) + 
              "~ns-hasta = " + STRING(pFechaH).
          RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".
          /* Captura parametros de impresion */
          ASSIGN
              RB-REPORT-NAME = "EECC General"
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
          RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                              RB-OTHER-PARAMETERS,
                              "").
      END.
  END.
  IF TOGGLE-2 = YES THEN DO:
      RUN ccb/p-eeccaplicacion (gn-clie.codcli, s-user-id, pFechaD, pFechaH, OUTPUT pTask-No).
      IF pTask-No > 0 THEN DO:
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(pTask-No) +  
                      " AND w-report.Llave-C = '" + s-user-id + "'".
          RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
              "~ns-nomcli = " + gn-clie.nomcli + 
              "~ns-desde = " + STRING(pFechaD) + 
              "~ns-hasta = " + STRING(pFechaH).
          RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".
          /* Captura parametros de impresion */
          ASSIGN
              RB-REPORT-NAME = "EECC Aplicacion"
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
          RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                              RB-OTHER-PARAMETERS,
                              "").
      END.
  END.
  IF TOGGLE-3 = YES THEN DO:
      RUN ccb/p-eeccsaldo (gn-clie.codcli, s-user-id, pFechaD, pFechaH, OUTPUT pTask-No).
      IF pTask-No > 0 THEN DO:
          RB-INCLUDE-RECORDS = "O".
          RB-FILTER = "w-report.task-no = " + STRING(pTask-No) +  
                      " AND w-report.Llave-C = '" + s-user-id + "'".
          RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia + 
              "~ns-nomcli = " + gn-clie.nomcli + 
              "~ns-desde = " + STRING(pFechaD) + 
              "~ns-hasta = " + STRING(pFechaH).
          RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".
          /* Captura parametros de impresion */
          ASSIGN
              RB-REPORT-NAME = "EECC Saldo"
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
          RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
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
                              RB-OTHER-PARAMETERS,
                              "").
      END.
  END.

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
  DISPLAY x-FchDoc-1 x-FchDoc-2 x-CodDiv RADIO-SET-1 TOGGLE-1 TOGGLE-2 TOGGLE-3 
      WITH FRAME D-Dialog.
  IF AVAILABLE gn-clie THEN 
    DISPLAY gn-clie.CodCli gn-clie.NomCli 
      WITH FRAME D-Dialog.
  ENABLE x-FchDoc-1 x-FchDoc-2 RADIO-SET-1 Btn_OK Btn_Cancel BUTTON-9 
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
  /*VIEW FRAME RB-MENSAJE.                    */
  CASE RADIO-SET-1:
      WHEN 1 THEN RUN Carga-Temporal-3.   /* Saldo de acuerdo a la moneda de origen */
      WHEN 2 THEN RUN Carga-Temporal-2.
      WHEN 3 THEN DO:
          RUN EECCGeneral.
          RETURN.
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto D-Dialog 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dSaldoMn AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE dSaldoMe AS DECIMAL     NO-UNDO.

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
  DEF VAR dTotCarMn AS DEC  NO-UNDO.
  DEF VAR dTotCarMe AS DEC  NO-UNDO.
  DEF VAR dTotAboMn AS DEC  NO-UNDO.
  DEF VAR dTotAboMe AS DEC  NO-UNDO.

  RUN Carga-Temporal-3.

  x-Archivo = 'Estado_de_Cuenta.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  OUTPUT STREAM REPORT TO VALUE(x-Archivo).

    PUT STREAM Report
        s-nomcia FORMAT "X(20)" SKIP(2)
        "ESTADO DE CUENTA CORRIENTE AL " AT 50 STRING(x-fchdoc-2) AT 82 SKIP
        "Cliente : " AT 20 STRING(gn-clie.codcli) FORMAT "99999999999" AT 30 STRING(gn-clie.nomcli) FORMAT "X(45)" AT 45 SKIP
        "Desde el: " AT 20 STRING(x-fchdoc-1) AT 30   SKIP
        "Hasta el: " AT 20 STRING(x-fchdoc-1) AT 30   SKIP(2).

    PUT STREAM Report
        "FECHA     "
        "DIVISION"
        " DOC. "
        "   NUMERO "
        "     REFERENCIA"
        "     CARGOS S/.  "
        "   CARGOS $    "
        "ABONOS S/.  "
        "   ABONOS $    "
        "   SALDOS S/.  "
        "   SALDOS $    "
        SKIP.

    FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK
        BREAK BY llave-d BY campo-c[10] :

        IF FIRST(Llave-d) THEN DO:
            PUT STREAM Report "SALDO INICIAL " AT 90 x-saldo-mn AT 114 x-saldo-me AT 129 SKIP. 
            ASSIGN
                dSaldoMn = x-saldo-mn
                dSaldoMe = x-saldo-me.
        END.
        PUT STREAM REPORT
            llave-d    
            llave-c    AT 12
            campo-c[1]
            campo-c[2] FORMAT "X(12)"
            campo-c[6] FORMAT "999999999"
            campo-f[1]
            campo-f[3]
            campo-f[2]
            campo-f[4]
            (dSaldoMn + (campo-f[1] - campo-f[2])) FORMAT "->>>,>>>,>>9.99"
            (dSaldoMe + (campo-f[3] - campo-f[4])) FORMAT "->>>,>>>,>>9.99"
             SKIP.

        ASSIGN 
            dSaldoMn = dSaldoMn + (campo-f[1] - campo-f[2])
            dSaldoMe = dSaldoMe + (campo-f[3] - campo-f[4])
            dTotCarMn = dTotCarMn +  campo-f[1]
            dTotCarMe = dTotCarMe +  campo-f[3]
            dTotAboMn = dTotAboMn +  campo-f[2]
            dTotAboMe = dTotAboMe +  campo-f[4].
    END.  

    PUT STREAM Report  
        dTotCarMn AT 49
        dTotCarMe AT 64
        dTotAboMn AT 79
        dTotAboMe AT 94.


  OUTPUT STREAM REPORT CLOSE.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

