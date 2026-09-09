&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
&GLOBAL-DEFINE BROWSE-VERSION 1.00
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE OK      AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-ROWID AS ROWID NO-UNDO.
{bin/s-global.i}
{pln/s-global.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

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
integral.PL-MOV-MES.valcal-mes integral.PL-CONC.Tipvar ~
integral.PL-CONC.DesMov integral.PL-CONC.CieMov 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-MOV-MES.CodMov ~
integral.PL-MOV-MES.valcal-mes 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-MOV-MES
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-MOV-MES
&Scoped-define QUERY-STRING-br_table FOR EACH integral.PL-MOV-MES ~
      WHERE PL-MOV-MES.CodCia = s-CodCia ~
 AND PL-MOV-MES.Periodo = s-Periodo ~
 AND PL-MOV-MES.NroMes = s-NroMes ~
 AND PL-MOV-MES.codpln = PL-FLG-MES.CodPln ~
 AND PL-MOV-MES.codcal = 0 ~
 AND PL-MOV-MES.codper = PL-FLG-MES.CodPer ~
 AND ( PL-MOV-MES.flgreg-mes = TRUE ~
 OR PL-MOV-MES.flgreg-mes = x-todos ) ~
 NO-LOCK, ~
      EACH integral.PL-CONC OF integral.PL-MOV-MES  NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-MOV-MES ~
      WHERE PL-MOV-MES.CodCia = s-CodCia ~
 AND PL-MOV-MES.Periodo = s-Periodo ~
 AND PL-MOV-MES.NroMes = s-NroMes ~
 AND PL-MOV-MES.codpln = PL-FLG-MES.CodPln ~
 AND PL-MOV-MES.codcal = 0 ~
 AND PL-MOV-MES.codper = PL-FLG-MES.CodPer ~
 AND ( PL-MOV-MES.flgreg-mes = TRUE ~
 OR PL-MOV-MES.flgreg-mes = x-todos ) ~
 NO-LOCK, ~
      EACH integral.PL-CONC OF integral.PL-MOV-MES  NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-MOV-MES ~
integral.PL-CONC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-MOV-MES
&Scoped-define SECOND-TABLE-IN-QUERY-br_table integral.PL-CONC


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 x-todos FILL-IN-codmov FILL-IN-valcal ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS x-todos FILL-IN-py FILL-IN-codmov ~
FILL-IN-descon FILL-IN-tipo FILL-IN-valcal 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-codmov AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 4.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-descon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-py AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cia" 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-valcal AS DECIMAL FORMAT "ZZ,ZZ9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.43 BY 9.19.

DEFINE VARIABLE x-todos AS LOGICAL INITIAL no 
     LABEL "Mostrar registros modificados" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .77
     FONT 4 NO-UNDO.

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
      integral.PL-MOV-MES.CodMov FORMAT "999":U
      integral.PL-MOV-MES.valcal-mes FORMAT "ZZZZ,ZZ9.99":U
      integral.PL-CONC.Tipvar COLUMN-LABEL "Tipo" FORMAT "x(11)":U
      integral.PL-CONC.DesMov COLUMN-LABEL "Descripci¢n" FORMAT "X(42)":U
      integral.PL-CONC.CieMov FORMAT "X(30)":U
  ENABLE
      integral.PL-MOV-MES.CodMov
      integral.PL-MOV-MES.valcal-mes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 59.72 BY 6.69
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-todos AT ROW 1.23 COL 3.29
     FILL-IN-py AT ROW 1.23 COL 27.72 COLON-ALIGNED
     FILL-IN-codmov AT ROW 2.19 COL 7.57 COLON-ALIGNED
     FILL-IN-descon AT ROW 2.19 COL 11.86 COLON-ALIGNED NO-LABEL
     FILL-IN-tipo AT ROW 2.19 COL 35.43 COLON-ALIGNED NO-LABEL
     FILL-IN-valcal AT ROW 2.19 COL 50.57 COLON-ALIGNED
     br_table AT ROW 3.23 COL 1.86
     "[" VIEW-AS TEXT
          SIZE 1.14 BY .81 AT ROW 2.19 COL 36.14
          FONT 0
     "]" VIEW-AS TEXT
          SIZE 1.43 BY .81 AT ROW 2.19 COL 46.57
          FONT 0
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.23
         WIDTH              = 61.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table FILL-IN-valcal F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN FILL-IN-descon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-py IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-MOV-MES,integral.PL-CONC OF integral.PL-MOV-MES "
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _Where[1]         = "PL-MOV-MES.CodCia = s-CodCia
 AND PL-MOV-MES.Periodo = s-Periodo
 AND PL-MOV-MES.NroMes = s-NroMes
 AND PL-MOV-MES.codpln = PL-FLG-MES.CodPln
 AND PL-MOV-MES.codcal = 0
 AND PL-MOV-MES.codper = PL-FLG-MES.CodPer
 AND ( PL-MOV-MES.flgreg-mes = TRUE
 OR PL-MOV-MES.flgreg-mes = x-todos )
"
     _FldNameList[1]   > integral.PL-MOV-MES.CodMov
"PL-MOV-MES.CodMov" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PL-MOV-MES.valcal-mes
"PL-MOV-MES.valcal-mes" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.PL-CONC.Tipvar
"PL-CONC.Tipvar" "Tipo" "x(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.PL-CONC.DesMov
"PL-CONC.DesMov" "Descripci¢n" "X(42)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = integral.PL-CONC.CieMov
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME F-Main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Main B-table-Win
ON END-ERROR OF FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON DELETE-CHARACTER OF br_table IN FRAME F-Main
DO:
    &IF NOT "{&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}" = ""
    &THEN
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U) .
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON END-ERROR OF br_table IN FRAME F-Main
ANYWHERE
DO:
    &IF NOT "{&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}" = ""
    &THEN

        RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
        RETURN NO-APPLY.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME integral.PL-MOV-MES.CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-MOV-MES.CodMov br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-MOV-MES.CodMov IN BROWSE br_table /* Concepto */
DO:
    FIND PL-CONC WHERE PL-CONC.CodMov = INPUT BROWSE br_table PL-MOV-MES.CodMov
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        DISPLAY
            PL-CONC.TipVar
            PL-CONC.DesMov
            PL-CONC.ciemov
            WITH BROWSE br_table.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-MOV-MES.CodMov br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-MOV-MES.CodMov IN BROWSE br_table /* Concepto */
OR F8 OF PL-MOV-MES.CodMov IN BROWSE br_table
DO:
    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-CONC-M.W (OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-CONC WHERE ROWID(PL-CONC) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN
            DISPLAY
                PL-CONC.ciemov
                PL-CONC.TipVar
                PL-CONC.DesMov
                PL-CONC.CodMov @ PL-MOV-MES.CodMov
                WITH BROWSE br_table.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-codmov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmov B-table-Win
ON LEAVE OF FILL-IN-codmov IN FRAME F-Main /* Concepto */
DO:
    FIND PL-CONC WHERE PL-CONC.CodMov = INPUT FRAME {&FRAME-NAME} FILL-IN-CodMov
        NO-LOCK NO-ERROR.
    IF AVAILABLE PL-CONC THEN
        DISPLAY
            PL-CONC.TipVar @ FILL-IN-tipo
            PL-CONC.DesMov @ FILL-IN-descon
            WITH FRAME {&FRAME-NAME}.
    ELSE
        DISPLAY
            "" @ FILL-IN-tipo
            "" @ FILL-IN-descon
            WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-codmov B-table-Win
ON RETURN OF FILL-IN-codmov IN FRAME F-Main /* Concepto */
DO:
    APPLY "ENTRY" TO FILL-IN-valcal.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-valcal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-valcal B-table-Win
ON LEAVE OF FILL-IN-valcal IN FRAME F-Main /* Valor */
DO:
    DISPLAY
        0 @ FILL-IN-codmov
        "" @ FILL-IN-descon
        "" @ FILL-IN-tipo
        0 @ FILL-IN-valcal
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-valcal B-table-Win
ON RETURN OF FILL-IN-valcal IN FRAME F-Main /* Valor */
DO:
    IF INPUT FRAME {&FRAME-NAME} FILL-IN-valcal = 0 THEN DO:
        APPLY "ENTRY":U TO FILL-IN-codmov.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN FILL-IN-codmov FILL-IN-valcal.
        RUN consistencia-fill-in.
        IF RETURN-VALUE <> "ADM-ERROR" THEN RUN crea-registro.
        APPLY "ENTRY":U TO FILL-IN-codmov.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-todos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-todos B-table-Win
ON VALUE-CHANGED OF x-todos IN FRAME F-Main /* Mostrar registros modificados */
DO:
    ASSIGN x-todos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CONSISTENCIA B-table-Win 
PROCEDURE CONSISTENCIA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND PL-CONC WHERE
        PL-CONC.CodMov = INPUT BROWSE {&BROWSE-NAME} PL-MOV-MES.CodMov
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CONC THEN DO:
        BELL.
        MESSAGE "C¢digo de concepto no registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF LOOKUP(PL-CONC.Tipmov,"Ingresos y Descuentos Fijos,Ingresos y Descuentos Variables")
      = 0 THEN DO:
      BELL.
      MESSAGE "No es un Concepto a ingresar"
            VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
    END.
    IF NOT PL-CONC.MesMov THEN DO:
        BELL.
        MESSAGE "Concepto ingresado no es un compcepto mensual"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
/*    IF NOT s-Admin AND PL-CONC.Tipmov = "Ingresos y Descuentos Fijos" THEN DO:
 *         BELL.
 *         MESSAGE "No tiene autorizaci¢n para actualizar este concepto"
 *             VIEW-AS ALERT-BOX ERROR.
 *         RETURN "ADM-ERROR".
 *     END.  */
    RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistencia-fill-in B-table-Win 
PROCEDURE consistencia-fill-in :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND PL-CONC WHERE
        PL-CONC.CodMov = INPUT FRAME {&FRAME-NAME} FILL-IN-CodMov
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PL-CONC THEN DO:
        BELL.
        MESSAGE "C¢digo de concepto no registrado"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF CAN-FIND(FIRST PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia          AND
        PL-MOV-MES.Periodo = s-Periodo         AND
        PL-MOV-MES.NroMes  = s-NroMes          AND
        PL-MOV-MES.codpln  = PL-FLG-MES.CodPln AND
        PL-MOV-MES.codcal  = 0                 AND
        PL-MOV-MES.codmov  = PL-CONC.CodMov    AND
        PL-MOV-MES.codper  = PL-FLG-MES.CodPer)
        THEN DO:
        BELL.
        MESSAGE "Concepto ya registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF LOOKUP(PL-CONC.Tipmov,"Ingresos y Descuentos Fijos,Ingresos y Descuentos Variables")
        = 0 THEN DO:
        BELL.
        MESSAGE "No es un Concepto a ingresar" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF NOT PL-CONC.MesMov THEN DO:
        BELL.
        MESSAGE "Concepto ingresado no es un compcepto mensual"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    IF NOT s-Admin AND PL-CONC.Tipmov = "Ingresos y Descuentos Fijos" THEN DO:
        BELL.
        MESSAGE "No tiene autorizaci¢n para actualizar este concepto"
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.  
    RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crea-registro B-table-Win 
PROCEDURE crea-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE PL-MOV-MES.
    ASSIGN
        PL-MOV-MES.CodCia     = s-CodCia
        PL-MOV-MES.Periodo    = s-Periodo
        PL-MOV-MES.NroMes     = s-NroMes
        PL-MOV-MES.codpln     = PL-FLG-MES.CodPln
        PL-MOV-MES.codcal     = 0
        PL-MOV-MES.codper     = PL-FLG-MES.CodPer
        PL-MOV-MES.CodMov     = PL-CONC.CodMov
        PL-MOV-MES.flgreg-mes  = TRUE
        PL-MOV-MES.valcal-mes  = FILL-IN-valcal
        PL-MOV-MES.Hra-Ult-Cal = STRING(TIME, "HH:MM")
        PL-MOV-MES.Fch-Ult-Cal = TODAY.

        RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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
    IF NOT QUERY-OFF-END("{&BROWSE-NAME}") THEN DO:
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
        RETURN.
    END.
  
    /* PARA EL CASO DE UN BROWSE CON VARIAS TABLAS REQUIERE QUE EL PRIMER REGISTRO
    SE LE ADICIONE MANUALMENTE (FALLA DESDE LA VERSION 8.00 ). */

    FOR EACH PL-CONC WHERE
        (PL-CONC.Tipmov = "Ingresos y Descuentos Fijos" OR
        PL-CONC.Tipmov = "Ingresos y Descuentos Variables") AND
        PL-CONC.MesMov = TRUE NO-LOCK:
        IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
            PL-MOV-MES.CodCia  = s-CodCia          AND
            PL-MOV-MES.Periodo = s-Periodo         AND
            PL-MOV-MES.NroMes  = s-NroMes          AND
            PL-MOV-MES.codpln  = PL-FLG-MES.CodPln AND
            PL-MOV-MES.codcal  = 0                 AND
            PL-MOV-MES.codmov  = PL-CONC.CodMov    AND
            PL-MOV-MES.codper  = PL-FLG-MES.CodPer)
        THEN DO WITH FRAME F-MAIN:
            CREATE PL-MOV-MES.
            ASSIGN
                PL-MOV-MES.CodCia     = s-CodCia
                PL-MOV-MES.Periodo    = s-Periodo
                PL-MOV-MES.NroMes     = s-NroMes
                PL-MOV-MES.codpln     = PL-FLG-MES.CodPln
                PL-MOV-MES.codcal     = 0
                PL-MOV-MES.codper     = PL-FLG-MES.CodPer
                PL-MOV-MES.CodMov     = PL-CONC.CodMov
                PL-MOV-MES.flgreg-mes = TRUE.
            RUN dispatch IN THIS-PROCEDURE ('open-query':U).
            RUN dispatch IN THIS-PROCEDURE ('apply-entry':U).
            RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
            APPLY "ENTRY":U TO br_table.
            RETURN.
        END.
    END.
    BELL.
    MESSAGE "No existe registros de conceptos" VIEW-AS ALERT-BOX ERROR.
    RUN dispatch IN THIS-PROCEDURE ("open-query").

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

    RUN get-attribute ('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN
        ASSIGN
            PL-MOV-MES.CodCia      = s-codcia
            PL-MOV-MES.Periodo     = s-periodo
            PL-MOV-MES.nromes      = s-nromes
            PL-MOV-MES.codpln      = PL-FLG-MES.CodPln
            PL-MOV-MES.CodCal      = 0
            PL-MOV-MES.CodPer      = PL-FLG-MES.CodPer.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY "VALUE-CHANGED" TO x-todos IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE PL-FLG-MES THEN
    FILL-IN-py = PL-FLG-MES.proyecto.
  DISPLAY FILL-IN-py WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    RUN CONSISTENCIA.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
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

