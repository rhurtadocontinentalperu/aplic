&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{bin/s-global.i}
{pln/s-global.i}

DEFINE NEW GLOBAL SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20 FORMAT "ZZZ,ZZ9.99".

DEFINE VARIABLE CMB-seccion AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea     AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE stat-reg    AS LOGICAL NO-UNDO.
DEFINE VARIABLE i           AS INTEGER NO-UNDO.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/print-2" SIZE 5.43 BY 1.46 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(6)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 7.57 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-seccion AS CHARACTER FORMAT "X(25)":U 
    LABEL "Secci¢n" VIEW-AS FILL-IN SIZE 26.14 BY .81 BGCOLOR 15 FGCOLOR 9 NO-UNDO.

DEFINE RECTANGLE RECT-1
    EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.29 BY 3.88 BGCOLOR 8 FGCOLOR 0 .

DEFINE FRAME D-Dialog
    FILL-IN-seccion AT ROW 2.88 COL 8.72 COLON-ALIGNED
    FILL-IN-Codigo AT ROW 3.73 COL 8.72 COLON-ALIGNED
    Btn_OK AT ROW 1.27 COL 30.72
    RECT-1 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 26.57 BY .5 AT ROW 2 COL 2.29
    SPACE(8.42) SKIP(2.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
    FONT 6 TITLE "Imprimiendo..." CENTERED.

DEFINE STREAM strm-concep. /* STREAM para el reporte */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-s

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-PLAN integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-PLAN, integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-FLG-SEM integral.PL-PERS

/* Definitions for BROWSE br_pl-flg-s                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM.codper ~
integral.PL-PERS.patper integral.PL-PERS.matper integral.PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-s 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-s
&Scoped-define OPEN-QUERY-br_pl-flg-s OPEN QUERY br_pl-flg-s FOR EACH integral.PL-FLG-SEM ~
      WHERE PL-FLG-SEM.CodCia = s-CodCia ~
 AND PL-FLG-SEM.Periodo = s-Periodo ~
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln ~
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM ~
  NO-LOCK, ~
      EACH integral.PL-PERS OF integral.PL-FLG-SEM NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM ~
integral.PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-s integral.PL-FLG-SEM


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-s}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TOGGLE-2 R-seleccion COMBO-1 B-aceptar ~
FILL-IN-Concepto FILL-IN-NRO-SEM Btn-UP Btn-DOWN br_pl-flg-s 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-2 R-seleccion COMBO-1 ~
FILL-IN-Concepto FILL-IN-NRO-SEM 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE COMBO-1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 18.14 BY 1
     BGCOLOR 15 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-Concepto AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-SEM AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Semana" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE R-seleccion AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todo el personal", 1,
"Selectivo", 2,
"Una secci¢n", 3
     SIZE 14.86 BY 1.5 NO-UNDO.

DEFINE VARIABLE TOGGLE-2 AS LOGICAL INITIAL no 
     LABEL "Conceptos manuales" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.29 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-s FOR 
      integral.PL-FLG-SEM, 
      integral.PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-s B-table-Win _STRUCTURED
  QUERY br_pl-flg-s NO-LOCK DISPLAY
      integral.PL-FLG-SEM.codper
      integral.PL-PERS.patper
      integral.PL-PERS.matper
      integral.PL-PERS.nomper
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47 BY 8.85
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TOGGLE-2 AT ROW 1 COL 2.14
     R-seleccion AT ROW 3.81 COL 3.72 NO-LABEL
     COMBO-1 AT ROW 5.38 COL 1.57 NO-LABEL
     B-aceptar AT ROW 6.42 COL 5.14
     FILL-IN-Concepto AT ROW 1.69 COL 8.43 COLON-ALIGNED
     FILL-IN-NRO-SEM AT ROW 2.77 COL 8.72 COLON-ALIGNED
     Btn-UP AT ROW 2.5 COL 14.72
     Btn-DOWN AT ROW 3.12 COL 14.72
     br_pl-flg-s AT ROW 1 COL 20.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 66.57 BY 8.85
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN,integral.PL-CALC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.85
         WIDTH              = 66.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-s Btn-DOWN F-Main */
ASSIGN 
       br_pl-flg-s:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR COMBO-BOX COMBO-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-s
/* Query rebuild information for BROWSE br_pl-flg-s
     _TblList          = "integral.PL-FLG-SEM,integral.PL-PERS OF integral.PL-FLG-SEM"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-FLG-SEM.CodCia = s-CodCia
 AND PL-FLG-SEM.Periodo = s-Periodo
 AND PL-FLG-SEM.codpln = PL-PLAN.CodPln
 AND PL-FLG-SEM.NroSem = FILL-IN-NRO-SEM
 "
     _FldNameList[1]   = integral.PL-FLG-SEM.codper
     _FldNameList[2]   = integral.PL-PERS.patper
     _FldNameList[3]   = integral.PL-PERS.matper
     _FldNameList[4]   = integral.PL-PERS.nomper
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-s */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    FIND PL-CONC WHERE PL-CONC.CodMov = INPUT FILL-IN-Concepto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CONC THEN DO:
        BELL.
        MESSAGE "C¢digo de concepto no registrado"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-Concepto.
        RETURN NO-APPLY.
    END.
    ASSIGN FILL-IN-NRO-SEM R-seleccion COMBO-1 FILL-IN-Concepto TOGGLE-2.
    RUN imp_concepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-s
&Scoped-define SELF-NAME br_pl-flg-s
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-ENTRY OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON ROW-LEAVE OF br_pl-flg-s IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-s B-table-Win
ON VALUE-CHANGED OF br_pl-flg-s IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN B-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM - 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-SEM + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-SEM + 1 @ FILL-IN-NRO-SEM WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-1 B-table-Win
ON ENTRY OF COMBO-1 IN FRAME F-Main
DO:
    ASSIGN i = 0.
    FOR EACH integral.PL-SECC NO-LOCK:
        IF i = 0 THEN ASSIGN CMB-Seccion = COMBO-1.
        ELSE ASSIGN CMB-Seccion = CMB-Seccion + "," + integral.PL-SECC.seccio.
        ASSIGN i = i + 1.
    END.
    COMBO-1:LIST-ITEMS IN FRAME F-Main = CMB-Seccion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Concepto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Concepto B-table-Win
ON LEAVE OF FILL-IN-Concepto IN FRAME F-Main /* Concepto */
DO:
    FIND PL-CONC WHERE PL-CONC.CodMov = INPUT FILL-IN-Concepto NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CONC THEN DO:
        BELL.
        MESSAGE "C¢digo de concepto no registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF NOT PL-CONC.SemMov THEN DO:
        BELL.
        MESSAGE "Concepto no es de semana"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Concepto B-table-Win
ON MOUSE-SELECT-DBLCLICK OF FILL-IN-Concepto IN FRAME F-Main /* Concepto */
OR F8 OF FILL-IN-Concepto
DO:
    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-CONC-S.W (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-CONC WHERE ROWID(PL-CONC) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN
            DISPLAY PL-CONC.CodMov @ FILL-IN-Concepto WITH FRAME F-Main.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-SEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-SEM B-table-Win
ON LEAVE OF FILL-IN-NRO-SEM IN FRAME F-Main /* Semana */
DO:
    IF INPUT FILL-IN-NRO-SEM > 54 OR INPUT FILL-IN-NRO-SEM = 0 THEN DO:
        BELL.
        MESSAGE "Rango de mes es de 1 a 54"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-SEM.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-SEM = FILL-IN-NRO-SEM THEN RETURN.
    ASSIGN FILL-IN-NRO-SEM.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-seleccion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-seleccion B-table-Win
ON VALUE-CHANGED OF R-seleccion IN FRAME F-Main
DO:
    CASE INPUT R-seleccion:
    WHEN 1 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = FALSE
            COMBO-1:SENSITIVE  = FALSE.
    WHEN 2 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = TRUE
            COMBO-1:SENSITIVE  = FALSE.
    WHEN 3 THEN
        ASSIGN
            Br_pl-flg-s:SENSITIVE = FALSE
            COMBO-1:SENSITIVE  = TRUE.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-PLAN"}
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-PLAN"}
  {src/adm/template/row-find.i "integral.PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_concepto B-table-Win 
PROCEDURE imp_concepto :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/
DEFINE VARIABLE x-CodCal AS INTEGER NO-UNDO.
DEFINE VARIABLE x-ImpCon AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99" NO-UNDO.

IF TOGGLE-2 = TRUE THEN ASSIGN x-CodCal = 0.
ELSE x-CodCal = PL-CALC.CodCal.

/* Direccionamiento del STREAM a la impresora */
OUTPUT STREAM strm-concep TO PRINTER PAGED PAGE-SIZE 66.

FIND PF-CIAS WHERE PF-CIAS.CodCia = s-CodCia NO-LOCK.

DEFINE FRAME F-Concepto
    PL-FLG-SEM.CodPer COLUMN-LABEL "C¢digo"
    x-linea COLUMN-LABEL "Apellidos y nombres"
    PL-FLG-SEM.Seccion COLUMN-LABEL "Secci¢n"
    PL-MOV-SEM.ValCal-Sem COLUMN-LABEL "Valor"
    HEADER
    integral.PF-CIAS.NomCia "Fecha :" TO 70 TODAY TO 80
    integral.PF-CIAS.DirCia SKIP(1)
    integral.PL-CONC.CodMov integral.PL-CONC.DesMov SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 80.

DEFINE FRAME F-Concepto1
    PL-FLG-SEM.CodPer COLUMN-LABEL "C¢digo"
    x-linea COLUMN-LABEL "Apellidos y nombres"
    PL-FLG-SEM.Seccion COLUMN-LABEL "Secci¢n"
    PL-MOV-SEM.ValCal-Sem COLUMN-LABEL "Valor"
    HEADER
    integral.PF-CIAS.NomCia "Fecha :" TO 70 TODAY TO 80
    integral.PF-CIAS.DirCia SKIP(1)
    integral.PL-CONC.CodMov integral.PL-CONC.DesMov SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 80.

DEFINE FRAME F-Concepto2
    PL-FLG-SEM.CodPer COLUMN-LABEL "C¢digo"
    x-linea COLUMN-LABEL "Apellidos y nombres"
    PL-FLG-SEM.Seccion COLUMN-LABEL "Secci¢n"
    PL-MOV-SEM.ValCal-Sem COLUMN-LABEL "Valor"
    HEADER
    integral.PF-CIAS.NomCia "Fecha :" TO 70 TODAY TO 80
    integral.PF-CIAS.DirCia SKIP(1)
    integral.PL-CONC.CodMov integral.PL-CONC.DesMov SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 80.

CASE R-seleccion:
WHEN 1 THEN DO:
    FOR EACH PL-FLG-SEM WHERE
        PL-FLG-SEM.CodCia  = s-CodCia AND
        PL-FLG-SEM.Periodo = s-Periodo AND
        PL-FLG-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln  = PL-PLAN.CodPln NO-LOCK:

        IF PL-FLG-SEM.SitAct <> "Activo" THEN NEXT. /* Si no esta Activo */

        DISPLAY
            PL-FLG-SEM.seccion @ FILL-IN-Seccion
            PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        ELSE ASSIGN x-linea = "".

        FIND PL-MOV-SEM WHERE
            PL-MOV-SEM.CodCia  = s-CodCia AND
            PL-MOV-SEM.Periodo = s-Periodo AND
            PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
            PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
            PL-MOV-SEM.CodCal  = x-CodCal AND
            PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
            PL-MOV-SEM.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
            DISPLAY STREAM strm-concep
                PL-FLG-SEM.CodPer
                x-linea
                PL-FLG-SEM.Seccion
                PL-MOV-SEM.ValCal-Sem
                WITH FRAME F-Concepto.
            IF PL-MOV-SEM.ValCal-Sem <> ? THEN
                ASSIGN x-ImpCon = x-ImpCon + PL-MOV-SEM.ValCal-Sem.
        END.
    END.
END.
WHEN 2 THEN DO:
    DO i = 1 TO br_pl-flg-s:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-s:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            IF PL-FLG-SEM.SitAct <> "Activo" THEN NEXT. /* Si no esta Activo */
            DISPLAY
                PL-FLG-SEM.seccion @ FILL-IN-Seccion
                PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

            FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
            IF AVAILABLE PL-PERS THEN
                ASSIGN
                    x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
            ELSE ASSIGN x-linea = "".
    
            FIND PL-MOV-SEM WHERE
                PL-MOV-SEM.CodCia  = s-CodCia AND
                PL-MOV-SEM.Periodo = s-Periodo AND
                PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
                PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
                PL-MOV-SEM.CodCal  = x-CodCal AND
                PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
                PL-MOV-SEM.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
            IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
                DISPLAY STREAM strm-concep
                    PL-FLG-SEM.CodPer
                    x-linea
                    PL-FLG-SEM.Seccion
                    PL-MOV-SEM.ValCal-Sem
                    WITH FRAME F-Concepto2.
                DOWN STREAM strm-concep WITH FRAME F-Concepto2.
                IF PL-MOV-SEM.ValCal-Sem <> ? THEN
                    ASSIGN x-ImpCon = x-ImpCon + PL-MOV-SEM.ValCal-Sem.
            END.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-s:DESELECT-ROWS().
END.
WHEN 3 THEN DO:
    DISPLAY COMBO-1 @ FILL-IN-Seccion WITH FRAME D-Dialog.
    FOR EACH PL-FLG-SEM NO-LOCK WHERE
        PL-FLG-SEM.CodCia  = s-CodCia AND
        PL-FLG-SEM.Periodo = s-Periodo AND
        PL-FLG-SEM.NroSem  = FILL-IN-NRO-SEM AND
        PL-FLG-SEM.CodPln  = PL-PLAN.CodPln AND
        PL-FLG-SEM.Seccion = COMBO-1:

        IF PL-FLG-SEM.SitAct <> "Activo" THEN NEXT. /* Si no esta Activo */

        DISPLAY PL-FLG-SEM.CodPer @ FILL-IN-Codigo WITH FRAME D-Dialog.

        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-SEM.CodPer NO-LOCK NO-ERROR.
        IF AVAILABLE PL-PERS THEN
            ASSIGN
                x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        ELSE ASSIGN x-linea = "".

        FIND PL-MOV-SEM WHERE
            PL-MOV-SEM.CodCia  = s-CodCia AND
            PL-MOV-SEM.Periodo = s-Periodo AND
            PL-MOV-SEM.NroSem  = FILL-IN-NRO-SEM AND
            PL-MOV-SEM.CodPln  = PL-PLAN.CodPln AND
            PL-MOV-SEM.CodCal  = x-CodCal AND
            PL-MOV-SEM.CodPer  = PL-FLG-SEM.CodPer AND
            PL-MOV-SEM.CodMov  = FILL-IN-Concepto NO-LOCK NO-ERROR.
        IF AVAILABLE PL-MOV-SEM AND PL-MOV-SEM.ValCal-Sem <> 0 THEN DO:
            DISPLAY STREAM strm-concep
                PL-FLG-SEM.CodPer
                x-linea
                PL-FLG-SEM.Seccion
                PL-MOV-SEM.ValCal-Sem
                WITH FRAME F-Concepto1.
            IF PL-MOV-SEM.ValCal-Sem <> ? THEN
                ASSIGN x-ImpCon = x-ImpCon + PL-MOV-SEM.ValCal-Sem.
        END.
    END.
END.

END CASE.

PUT STREAM strm-concep FILL(" ",69) FORMAT "x(69)" "-----------" SKIP.
PUT STREAM strm-concep
    FILL(" ",52) FORMAT "x(52)"
    "Importe TOTAL : "
    x-ImpCon SKIP.

HIDE FRAME D-Dialog.

OUTPUT STREAM strm-concep CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN FILL-IN-NRO-SEM = s-NroSem.
    DISPLAY FILL-IN-NRO-SEM WITH FRAME F-Main.

    APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "integral.PL-PLAN"}
  {src/adm/template/snd-list.i "integral.PL-CALC"}
  {src/adm/template/snd-list.i "integral.PL-FLG-SEM"}
  {src/adm/template/snd-list.i "integral.PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


