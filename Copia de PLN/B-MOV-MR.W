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

DEFINE NEW SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 30.

DEFINE VARIABLE OK-STATUS AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-CodPln  AS INTEGER NO-UNDO.

{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-FLG-MES
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-FLG-MES


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-FLG-MES.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-MOV-MES integral.PL-CONC

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-MOV-MES.CodMov ~
integral.PL-MOV-MES.valcal-mes integral.PL-CONC.DesMov 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-MOV-MES.CodMov ~
integral.PL-MOV-MES.valcal-mes 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}~
 ~{&FP1}valcal-mes ~{&FP2}valcal-mes ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-MOV-MES
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-MOV-MES
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-MOV-MES WHERE PL-MOV-MES.CodCia = PL-FLG-MES.CodCia ~
  AND PL-MOV-MES.Periodo = PL-FLG-MES.Periodo ~
  AND PL-MOV-MES.codpln = PL-FLG-MES.codpln ~
  AND PL-MOV-MES.codper = PL-FLG-MES.codper ~
      AND PL-MOV-MES.NroMes = s-nromes ~
 AND PL-MOV-MES.codcal = FILL-IN-codcal NO-LOCK, ~
      EACH integral.PL-CONC OF integral.PL-MOV-MES NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-MOV-MES ~
integral.PL-CONC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-MOV-MES


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-29 br_table Btn-UP-2 Btn-DOWN-2 ~
B-recalcula 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-codcal FILL-IN-descal ~
FILL-IN-nromes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-recalcula 
     LABEL "&Recalcular" 
     SIZE 9.72 BY .85.

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-codcal AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "C lculo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-descal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-nromes AS INTEGER FORMAT "Z9":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61.72 BY 12.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-MOV-MES, 
      integral.PL-CONC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-MOV-MES.CodMov
      integral.PL-MOV-MES.valcal-mes
      integral.PL-CONC.DesMov FORMAT "X(53)"
  ENABLE
      integral.PL-MOV-MES.CodMov
      integral.PL-MOV-MES.valcal-mes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 59.29 BY 10.42
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.58 COL 2.29
     FILL-IN-codcal AT ROW 1.42 COL 6.57 COLON-ALIGNED
     Btn-UP-2 AT ROW 1.23 COL 13
     Btn-DOWN-2 AT ROW 1.85 COL 13
     FILL-IN-descal AT ROW 1.42 COL 14.43 COLON-ALIGNED NO-LABEL
     FILL-IN-nromes AT ROW 1.38 COL 45.14 COLON-ALIGNED
     B-recalcula AT ROW 1.35 COL 51.86
     RECT-29 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-FLG-MES
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
         HEIGHT             = 12.31
         WIDTH              = 61.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-29 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-codcal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-descal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-nromes IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-MOV-MES WHERE integral.PL-FLG-MES ...,integral.PL-CONC OF integral.PL-MOV-MES"
     _Options          = "NO-LOCK"
     _JoinCode[1]      = "PL-MOV-MES.CodCia = PL-FLG-MES.CodCia
  AND PL-MOV-MES.Periodo = PL-FLG-MES.Periodo
  AND PL-MOV-MES.codpln = PL-FLG-MES.codpln
  AND PL-MOV-MES.codper = PL-FLG-MES.codper"
     _Where[1]         = "PL-MOV-MES.NroMes = s-nromes
 AND PL-MOV-MES.codcal = FILL-IN-codcal"
     _FldNameList[1]   > integral.PL-MOV-MES.CodMov
"PL-MOV-MES.CodMov" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-MOV-MES.valcal-mes
"PL-MOV-MES.valcal-mes" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.PL-CONC.DesMov
"PL-CONC.DesMov" ? "X(53)" "character" ? ? ? ? ? ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-recalcula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-recalcula B-table-Win
ON CHOOSE OF B-recalcula IN FRAME F-Main /* Recalcular */
DO:
    ok-status = SESSION:SET-WAIT-STATE("GENERAL").
    ASSIGN FILL-IN-codcal.
    RUN recalcula.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    ok-status = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
    /* This code displays initial values for newly added or copied rows. */
    {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 B-table-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
    FIND LAST integral.PL-CALC WHERE
        integral.PL-CALC.CodCal < FILL-IN-codcal AND
        integral.PL-CALC.CodPln = PL-FLG-MES.codpln NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CALC THEN DO:
        FILL-IN-codcal = integral.PL-CALC.CodCal.
        FILL-IN-descal = integral.PL-CALC.DesCal.
        DISPLAY FILL-IN-codcal FILL-IN-descal WITH FRAME {&FRAME-NAME}.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 B-table-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
    FIND FIRST integral.PL-CALC WHERE
        integral.PL-CALC.CodCal > FILL-IN-codcal AND
        integral.PL-CALC.CodPln = PL-FLG-MES.codpln NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CALC THEN DO:
        FILL-IN-codcal = integral.PL-CALC.CodCal.
        FILL-IN-descal = integral.PL-CALC.DesCal.
        DISPLAY FILL-IN-codcal FILL-IN-descal WITH FRAME {&FRAME-NAME}.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
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
  {src/adm/template/row-list.i "integral.PL-FLG-MES"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-FLG-MES"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    IF NOT QUERY-OFF-END("br_table") THEN DO:
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
        RETURN.
    END.
/*
    CREATE PL-MOV-MES.
    ASSIGN
        PL-MOV-MES.CodCia  = PL-FLG-MES.codcia
        PL-MOV-MES.Periodo = PL-FLG-MES.periodo
        PL-MOV-MES.nromes  = PL-FLG-MES.nromes
        PL-MOV-MES.codpln  = PL-FLG-MES.CodPln
        PL-MOV-MES.CodCal  = FILL-IN-codcal
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer
        PL-MOV-MES.CodMov  = 999.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN dispatch IN THIS-PROCEDURE ('apply-entry':U).
    RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
    APPLY "ENTRY":U TO {&BROWSE-NAME} IN FRAME {&FRAME-NAME}.
    RETURN.
*/
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN FRAME {&FRAME-NAME} FILL-IN-codcal.

    RUN get-attribute ('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN
        ASSIGN
            PL-MOV-MES.CodCia  = PL-FLG-MES.codcia
            PL-MOV-MES.Periodo = PL-FLG-MES.periodo
            PL-MOV-MES.nromes  = PL-FLG-MES.nromes
            PL-MOV-MES.codpln  = PL-FLG-MES.CodPln
            PL-MOV-MES.CodCal  = FILL-IN-codcal
            PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer.
    ASSIGN
        PL-MOV-MES.flgreg-mes  = TRUE
        PL-MOV-MES.Hra-Ult-Cal = STRING(TIME, "HH:MM")
        PL-MOV-MES.Fch-Ult-Cal = TODAY.

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
    FILL-IN-nromes = s-nromes.
    DISPLAY FILL-IN-nromes WITH FRAME F-MAIN.

    FIND FIRST integral.PL-CALC WHERE
        integral.PL-CALC.CodPln = PL-FLG-MES.codpln NO-LOCK NO-ERROR.

    IF AVAILABLE integral.PL-CALC  THEN DO:
        FILL-IN-codcal = integral.PL-CALC.CodCal.
        FILL-IN-descal = integral.PL-CALC.DesCal.
        DISPLAY FILL-IN-codcal FILL-IN-descal WITH FRAME {&FRAME-NAME}.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalcula B-table-Win 
PROCEDURE recalcula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE remunera  AS DECIMAL.
DEFINE VARIABLE descuenta AS DECIMAL.
DEFINE VARIABLE aporta    AS DECIMAL.
DEFINE VARIABLE auxiliar  AS DECIMAL.

FOR EACH PL-BOLE NO-LOCK WHERE
    PL-BOLE.CodPln = PL-FLG-MES.CodPln AND
    PL-BOLE.CodCal = FILL-IN-codcal AND
    PL-BOLE.TpoBol <> "Otros":
    FIND PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = PL-FLG-MES.codcia AND
        PL-MOV-MES.Periodo = PL-FLG-MES.periodo AND
        PL-MOV-MES.NroMes  = PL-FLG-MES.nromes AND
        PL-MOV-MES.CodPln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND
        PL-MOV-MES.CodMov  = PL-BOLE.CodMov NO-LOCK NO-ERROR.
    IF AVAILABLE PL-MOV-MES AND PL-MOV-MES.ValCal-Mes <> 0 THEN DO:
        CASE PL-BOLE.TpoBol:
            WHEN "Remuneraciones" THEN remunera = remunera + PL-MOV-MES.ValCal-Mes.
            WHEN "Descuentos" THEN descuenta = descuenta + PL-MOV-MES.ValCal-Mes.
            WHEN "Aportes" THEN aporta = aporta + PL-MOV-MES.ValCal-Mes.
        END CASE.
    END.
END.

RUN PLN/P-CALC-M.R(
    integral.PL-FLG-MES.Codcia,
    integral.PL-FLG-MES.Periodo,
    integral.PL-FLG-MES.NroMes,
    integral.PL-FLG-MES.codpln,
    FILL-IN-codcal,
    integral.PL-FLG-MES.codper,
    "^141(0);^132(1);^202(1);^111(1)" ).

{ pln/crea-c-m.i FILL-IN-codcal 401 remunera }
{ pln/crea-c-m.i FILL-IN-codcal 402 descuenta }
auxiliar = remunera - descuenta.
{ pln/crea-c-m.i FILL-IN-codcal 403 auxiliar }
IF VAL-VAR[3] = 0 THEN DO:
    auxiliar = remunera - VAL-VAR[2].
    { pln/crea-c-m.i FILL-IN-codcal 404 auxiliar }
END.
auxiliar = remunera - VAL-VAR[1].
{ pln/crea-c-m.i FILL-IN-codcal 405 auxiliar }
{ pln/crea-c-m.i FILL-IN-codcal 406 aporta }
auxiliar = remunera - VAL-VAR[2].
{ pln/crea-c-m.i FILL-IN-codcal 407 auxiliar }
/*auxiliar = remunera - descuenta - VAL-VAR[4].
 * { pln/crea-c-m.i FILL-IN-codcal 411 auxiliar }*/

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
  {src/adm/template/snd-list.i "integral.PL-FLG-MES"}
  {src/adm/template/snd-list.i "integral.PL-MOV-MES"}
  {src/adm/template/snd-list.i "integral.PL-CONC"}

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


