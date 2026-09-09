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
DEFINE BUFFER B-PL-FLG-SEM FOR PL-FLG-SEM.
DEFINE VARIABLE OK-STATUS  AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-CodPln   AS INTEGER NO-UNDO.
DEFINE SHARED VAR s-nrosem AS INTEGER.
s-CodPln = 2.

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
&Scoped-define EXTERNAL-TABLES PL-FLG-SEM
&Scoped-define FIRST-EXTERNAL-TABLE PL-FLG-SEM


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PL-FLG-SEM.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PL-MOV-SEM PL-CONC

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PL-MOV-SEM.CodMov ~
PL-MOV-SEM.valcal-sem PL-CONC.DesMov 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PL-MOV-SEM.CodMov ~
PL-MOV-SEM.valcal-sem 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}~
 ~{&FP1}valcal-sem ~{&FP2}valcal-sem ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PL-MOV-SEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PL-MOV-SEM
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PL-MOV-SEM ~
      WHERE PL-MOV-SEM.CodCia       = PL-FLG-SEM.CodCia ~
 AND PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo ~
 AND PL-MOV-SEM.NroSem  = x-NroSem ~
 AND PL-MOV-SEM.codpln  = PL-FLG-SEM.CodPln ~
 AND PL-MOV-SEM.codcal  = s-CodCal ~
 AND PL-MOV-SEM.codper  = PL-FLG-SEM.CodPer ~
 NO-LOCK, ~
      EACH PL-CONC OF PL-MOV-SEM  NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table PL-MOV-SEM PL-CONC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PL-MOV-SEM


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-27 br_table Btn-UP-2 Btn-DOWN-2 ~
x-NroSem Btn-UP Btn-DOWN 
&Scoped-Define DISPLAYED-OBJECTS s-CodCal s-DesCal x-NroSem 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE s-CodCal AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Cálculo" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE s-DesCal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-NroSem AS INTEGER FORMAT "Z9":U INITIAL 1 
     LABEL "Sem" 
     VIEW-AS FILL-IN 
     SIZE 2.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 7.86 BY 1.35.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 56.14 BY 1.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PL-MOV-SEM, 
      PL-CONC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PL-MOV-SEM.CodMov
      PL-MOV-SEM.valcal-sem
      PL-CONC.DesMov COLUMN-LABEL "Descripción" FORMAT "X(53)"
  ENABLE
      PL-MOV-SEM.CodMov
      PL-MOV-SEM.valcal-sem
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 59.57 BY 9.92
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.81 COL 1
     s-CodCal AT ROW 1.42 COL 5.43 COLON-ALIGNED
     s-DesCal AT ROW 1.38 COL 10.43 COLON-ALIGNED NO-LABEL
     Btn-UP-2 AT ROW 1.12 COL 57.57
     Btn-DOWN-2 AT ROW 1.73 COL 57.57
     x-NroSem AT ROW 1.35 COL 63.43 COLON-ALIGNED
     Btn-UP AT ROW 1.12 COL 69.14
     Btn-DOWN AT ROW 1.73 COL 69.14
     RECT-29 AT ROW 1.12 COL 1.29
     RECT-27 AT ROW 1.08 COL 61
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-FLG-SEM
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
         HEIGHT             = 12.08
         WIDTH              = 71.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-27 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* SETTINGS FOR FILL-IN s-CodCal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-DesCal IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-MOV-SEM,integral.PL-CONC OF integral.PL-MOV-SEM "
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _Where[1]         = "PL-MOV-SEM.CodCia       = PL-FLG-SEM.CodCia
 AND PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo
 AND PL-MOV-SEM.NroSem  = x-NroSem
 AND PL-MOV-SEM.codpln  = PL-FLG-SEM.CodPln
 AND PL-MOV-SEM.codcal  = s-CodCal
 AND PL-MOV-SEM.codper  = PL-FLG-SEM.CodPer
"
     _FldNameList[1]   > integral.PL-MOV-SEM.CodMov
"PL-MOV-SEM.CodMov" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-MOV-SEM.valcal-sem
"PL-MOV-SEM.valcal-sem" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.PL-CONC.DesMov
"PL-CONC.DesMov" "Descripción" "X(53)" "character" ? ? ? ? ? ? no ?
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


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN B-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main x-NroSem - 1 > 0 THEN DO:
    ASSIGN x-NroSem = x-NroSem - 1.
    DISPLAY x-NroSem WITH FRAME F-Main.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 B-table-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
    FIND LAST integral.PL-CALC WHERE integral.PL-CALC.CodCal < s-CodCal 
                                 AND integral.PL-CALC.CodPln = s-CodPln 
        NO-LOCK NO-ERROR.
    
    IF AVAILABLE integral.PL-CALC
    THEN DO:
        ASSIGN s-CodCal = integral.PL-CALC.CodCal
               s-DesCal = integral.PL-CALC.DesCal.
        DISPLAY s-CodCal s-DesCal  WITH FRAME F-MAIN.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main x-NroSem + 1 <= 53 THEN DO:
    ASSIGN x-NroSem = x-NroSem + 1.
    DISPLAY x-NroSem WITH FRAME F-Main.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 B-table-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
    FIND FIRST integral.PL-CALC WHERE integral.PL-CALC.CodCal > s-CodCal 
                                 AND integral.PL-CALC.CodPln = s-CodPln 
        NO-LOCK NO-ERROR.
    
    IF AVAILABLE integral.PL-CALC
    THEN DO:
        ASSIGN s-CodCal = integral.PL-CALC.CodCal
               s-DesCal = integral.PL-CALC.DesCal.
        DISPLAY s-CodCal s-DesCal  WITH FRAME F-MAIN.
        {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-NroSem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-NroSem B-table-Win
ON LEAVE OF x-NroSem IN FRAME F-Main /* Sem */
DO:
    IF INPUT x-NroSEM = x-NroSEM THEN RETURN.
    ASSIGN x-NroSEM.
    IF x-NroSEM > 53 OR x-NroSEM <= 0 THEN DO:
        MESSAGE "Rango de Semana es de 1 a 53"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-flg-sem B-table-Win 
PROCEDURE add-flg-sem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT CAN-FIND(FIRST B-PL-FLG-SEM WHERE 
             B-PL-FLG-SEM.CodCia  = PL-FLG-SEM.CODCIA  AND
             B-PL-FLG-SEM.PERIODO = PL-FLG-SEM.PERIODO AND
             B-PL-FLG-SEM.NROSEM  = X-NroSEM          AND
             B-PL-FLG-SEM.CODPLN  = PL-FLG-SEM.Codpln  AND
             B-PL-FLG-SEM.CODPER  = PL-FLG-SEM.Codper )
THEN DO:
    CREATE B-PL-FLG-SEM.
    ASSIGN B-PL-FLG-SEM.CodCia       = integral.PL-FLG-SEM.CODCIA
           B-PL-FLG-SEM.PERIODO      = integral.PL-FLG-SEM.PERIODO
           B-PL-FLG-SEM.NROSEM       = X-NroSEM
           B-PL-FLG-SEM.CODPLN       = PL-FLG-SEM.Codpln  
           B-PL-FLG-SEM.CODPER       = PL-FLG-SEM.Codper   
           B-PL-FLG-SEM.Cargos       = integral.PL-FLG-SEM.cargos 
           B-PL-FLG-SEM.Ccosto       = integral.PL-FLG-SEM.ccosto 
           B-PL-FLG-SEM.Clase        = integral.PL-FLG-SEM.Clase 
           B-PL-FLG-SEM.Cnpago       = integral.PL-FLG-SEM.cnpago 
           B-PL-FLG-SEM.Codafp       = integral.PL-FLG-SEM.codafp 
           B-PL-FLG-SEM.Coddiv       = integral.PL-FLG-SEM.CodDiv 
           B-PL-FLG-SEM.Conyugue     = integral.PL-FLG-SEM.Conyugue  
           B-PL-FLG-SEM.Exceso-SEM   = integral.PL-FLG-SEM.Exceso-SEM 
           B-PL-FLG-SEM.Fch-Ult-Reg  = TODAY
           B-PL-FLG-SEM.FecIng       = integral.PL-FLG-SEM.fecing 
           B-PL-FLG-SEM.finvac       = integral.PL-FLG-SEM.finvac 
           B-PL-FLG-SEM.CTS          = integral.PL-FLG-SEM.CTS 
           B-PL-FLG-SEM.nrodpt-CTS   = integral.PL-FLG-SEM.nrodpt-CTS 
           B-PL-FLG-SEM.Hra-Ult-Reg  = STRING(TIME, "HH:MM")
           B-PL-FLG-SEM.inivac       = integral.PL-FLG-SEM.inivac 
           B-PL-FLG-SEM.Nro-De-Hijos = integral.PL-FLG-SEM.Nro-De-Hijos 
           B-PL-FLG-SEM.nroafp       = integral.PL-FLG-SEM.nroafp 
           B-PL-FLG-SEM.nrodpt       = integral.PL-FLG-SEM.nrodpt 
           B-PL-FLG-SEM.Proyecto     = integral.PL-FLG-SEM.Proyecto 
           B-PL-FLG-SEM.seccion      = integral.PL-FLG-SEM.seccion 
           B-PL-FLG-SEM.SitAct       = integral.PL-FLG-SEM.SitAct 
           B-PL-FLG-SEM.vcontr       = integral.PL-FLG-SEM.vcontr.
END.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-mov-sem B-table-Win 
PROCEDURE add-mov-sem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH PL-BOLE WHERE PL-BOLE.CODPLN = PL-FLG-SEM.CODPLN AND
                       PL-BOLE.CODCAL = s-CodCal NO-LOCK:
    IF NOT CAN-FIND(PL-MOV-SEM WHERE
                PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia
            AND PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo
            AND PL-MOV-SEM.codpln  = PL-FLG-SEM.codpln
            AND PL-MOV-SEM.codper  = PL-FLG-SEM.codper
            AND PL-MOV-SEM.NroSEM  = X-NroSEM
            AND PL-MOV-SEM.codcal  = s-CodCal
            AND PL-MOV-SEM.codmov  = PL-BOLE.codmov)
    THEN DO:
        CREATE PL-MOV-SEM.
        ASSIGN 
            PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia
            PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo
            PL-MOV-SEM.codpln  = PL-FLG-SEM.codpln
            PL-MOV-SEM.codper  = PL-FLG-SEM.codper
            PL-MOV-SEM.NroSEM  = X-NroSEM
            PL-MOV-SEM.codcal  = s-CodCal
            PL-MOV-SEM.codmov  = PL-BOLE.codmov.
    END.
END.                                   


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "PL-FLG-SEM"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PL-FLG-SEM"}

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

  ASSIGN FRAME {&FRAME-NAME} s-CodCal.

  RUN get-attribute ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN
     ASSIGN
        PL-MOV-SEM.CodCia  = PL-FLG-SEM.CodCia
        PL-MOV-SEM.Periodo = PL-FLG-SEM.Periodo
        PL-MOV-SEM.codpln  = PL-FLG-SEM.codpln
        PL-MOV-SEM.codper  = PL-FLG-SEM.codper
        PL-MOV-SEM.NroSEM  = X-NroSEM
        PL-MOV-SEM.codcal  = s-CodCal.

   ASSIGN
       PL-MOV-SEM.flgreg-sem  = TRUE
       PL-MOV-SEM.Hra-Ult-Cal = STRING(TIME, "HH:MM")
       PL-MOV-SEM.Fch-Ult-Cal = TODAY.

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
  x-NroSem = s-nrosem.
  DISPLAY x-NroSem WITH FRAME F-MAIN.
  
  FIND FIRST integral.PL-CALC WHERE 
     integral.PL-CALC.CodPln = s-CodPln NO-LOCK NO-ERROR.
    
/*  IF AVAILABLE integral.PL-CALC THEN DO:
     ASSIGN s-CodCal = integral.PL-CALC.CodCal
            s-DesCal = integral.PL-CALC.DesCal.
     DISPLAY s-CodCal s-DesCal  WITH FRAME F-MAIN.
  END.*/
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {&OPEN-QUERY-{&BROWSE-NAME}}
  
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
  {src/adm/template/snd-list.i "PL-FLG-SEM"}
  {src/adm/template/snd-list.i "PL-MOV-SEM"}
  {src/adm/template/snd-list.i "PL-CONC"}

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


