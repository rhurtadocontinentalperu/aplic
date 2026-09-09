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

DEFINE VARIABLE reg-act5  AS ROWID.
DEFINE VARIABLE S-DESMOV AS CHARACTER NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES integral.PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-CALC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-BOLE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-BOLE.Prioridad ~
integral.PL-BOLE.nroitm integral.PL-BOLE.CodMov integral.PL-BOLE.CodRef ~
integral.PL-BOLE.codcal-ref integral.PL-BOLE.TpoBol ~
integral.PL-BOLE.ERROR-MOV S-DESMOV @ S-DESMOV 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-BOLE.Prioridad ~
integral.PL-BOLE.nroitm integral.PL-BOLE.CodMov integral.PL-BOLE.CodRef ~
integral.PL-BOLE.codcal-ref integral.PL-BOLE.TpoBol 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Prioridad ~{&FP2}Prioridad ~{&FP3}~
 ~{&FP1}nroitm ~{&FP2}nroitm ~{&FP3}~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}~
 ~{&FP1}CodRef ~{&FP2}CodRef ~{&FP3}~
 ~{&FP1}codcal-ref ~{&FP2}codcal-ref ~{&FP3}~
 ~{&FP1}TpoBol ~{&FP2}TpoBol ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-BOLE
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-BOLE
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-BOLE WHERE PL-BOLE.codcal = PL-CALC.codcal ~
  AND PL-BOLE.codpln = PL-CALC.codpln NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-BOLE
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-BOLE


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-BOLE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-BOLE.Prioridad
      integral.PL-BOLE.nroitm
      integral.PL-BOLE.CodMov
      integral.PL-BOLE.CodRef
      integral.PL-BOLE.codcal-ref COLUMN-LABEL "Cal!Ref"
      integral.PL-BOLE.TpoBol FORMAT "X(14)"
      integral.PL-BOLE.ERROR-MOV
      S-DESMOV @ S-DESMOV COLUMN-LABEL "Descripci¢n de Concepto" FORMAT "X(41)"
  ENABLE
      integral.PL-BOLE.Prioridad
      integral.PL-BOLE.nroitm
      integral.PL-BOLE.CodMov
      integral.PL-BOLE.CodRef
      integral.PL-BOLE.codcal-ref
      integral.PL-BOLE.TpoBol
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 73 BY 5.15
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-CALC
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
         HEIGHT             = 5.15
         WIDTH              = 80.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-BOLE WHERE integral.PL-CALC <external> ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST USED"
     _JoinCode[1]      = "PL-BOLE.codcal = PL-CALC.codcal
  AND PL-BOLE.codpln = PL-CALC.codpln"
     _FldNameList[1]   > integral.PL-BOLE.Prioridad
"PL-BOLE.Prioridad" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-BOLE.nroitm
"PL-BOLE.nroitm" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.PL-BOLE.CodMov
"PL-BOLE.CodMov" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.PL-BOLE.CodRef
"PL-BOLE.CodRef" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.PL-BOLE.codcal-ref
"PL-BOLE.codcal-ref" "Cal!Ref" ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > integral.PL-BOLE.TpoBol
"PL-BOLE.TpoBol" ? "X(14)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[7]   = integral.PL-BOLE.ERROR-MOV
     _FldNameList[8]   > "_<CALC>"
"S-DESMOV @ S-DESMOV" "Descripci¢n de Concepto" "X(41)" ? ? ? ? ? ? ? no ?
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
    FIND integral.PL-CONC WHERE integral.PL-CONC.CodMov = integral.PL-BOLE.CodMov
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CONC
    THEN S-DESMOV = integral.PL-CONC.DesMov.
    ELSE S-DESMOV = "".
    /*DISPLAY S-DESMOV IN BROWSE br_table.*/
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
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  FIND integral.PL-CONC WHERE integral.PL-CONC.CodMov = integral.PL-BOLE.CodMov
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CONC
    THEN S-DESMOV:SCREEN-VALUE IN BROWSE br_table = integral.PL-CONC.DesMov.
    ELSE S-DESMOV:SCREEN-VALUE IN BROWSE br_table = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-BOLE.CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.CodMov br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-BOLE.CodMov IN BROWSE br_table /* Con-!cepto */
DO:
  FIND FIRST PL-CONC WHERE PL-CONC.codmov = INTEGER( SELF:SCREEN-VALUE )
                           NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PL-CONC THEN DO:
        MESSAGE "C¢digo no Existe..." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.CodMov br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-BOLE.CodMov IN BROWSE br_table /* Con-!cepto */
OR "F8" OF PL-BOLE.codmov DO:
    RUN PLN/H-CONC.w (OUTPUT reg-act5).
    IF reg-act5 <> ? THEN DO:
        FIND PL-CONC WHERE ROWID(PL-CONC) = reg-act5 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN SELF:SCREEN-VALUE = STRING(PL-CONC.codmov).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-BOLE.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.CodRef br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-BOLE.CodRef IN BROWSE br_table /* Con.!Refe. */
DO:
  /*
  IF SELF:SCREEN-VALUE <> ""
  THEN DO:
      FIND FIRST PL-CONC WHERE PL-CONC.codmov = INTEGER( SELF:SCREEN-VALUE )
                               NO-LOCK NO-ERROR.
      IF NOT AVAILABLE PL-CONC THEN DO:
            MESSAGE "C¢digo no Existe..." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            RETURN NO-APPLY.
  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.CodRef br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-BOLE.CodRef IN BROWSE br_table /* Con.!Refe. */
OR "F8" OF PL-BOLE.codref DO:
    RUN PLN/H-CONC.w (OUTPUT reg-act5).
    IF reg-act5 <> ? THEN DO:
        FIND PL-CONC WHERE ROWID(PL-CONC) = reg-act5 NO-LOCK NO-ERROR.
        IF AVAILABLE PL-CONC THEN SELF:SCREEN-VALUE = STRING(PL-CONC.codmov).
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-BOLE.TpoBol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.TpoBol br_table _BROWSE-COLUMN B-table-Win
ON ANY-PRINTABLE OF integral.PL-BOLE.TpoBol IN BROWSE br_table /* Tipo */
DO:
  IF CAN-DO( "R,D,A,O", CHR( LASTKEY ))
  THEN 
    CASE CHR( LASTKEY ) :
        WHEN "R" THEN SELF:SCREEN-VALUE = "Remuneraciones".
        WHEN "D" THEN SELF:SCREEN-VALUE = "Descuentos".
        WHEN "A" THEN SELF:SCREEN-VALUE = "Aportes".
        WHEN "O" THEN SELF:SCREEN-VALUE = "Otros".
  
    END CASE.
  ELSE
    MESSAGE "Los Valores valido solo son:" SKIP
            "  Remuneraciones,Descuentos,Aportes,Otros" 
            VIEW-AS ALERT-BOX ERROR.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.TpoBol br_table _BROWSE-COLUMN B-table-Win
ON DELETE-CHARACTER OF integral.PL-BOLE.TpoBol IN BROWSE br_table /* Tipo */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-BOLE.TpoBol br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF integral.PL-BOLE.TpoBol IN BROWSE br_table /* Tipo */
DO:
  IF LOOKUP( SELF:SCREEN-VALUE, "Remuneraciones,Descuentos,Aportes,Otros") = 0
  /*IF NOT CAN-DO( "Remuneraciones,Descuentos,Aportes,Otros", SELF:SCREEN-VALUE)*/
  THEN DO:
    MESSAGE "Los Valores valido solo son:" SKIP
            "  Remuneraciones, Descuentos, Aportes, Otros" 
            VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
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
ON FIND OF integral.PL-BOLE DO:
    FIND integral.PL-CONC WHERE integral.PL-CONC.CodMov = integral.PL-BOLE.CodMov
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.PL-CONC THEN
        ASSIGN S-DESMOV = integral.PL-CONC.DesMov.
    ELSE ASSIGN S-DESMOV = "".
END.

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
  {src/adm/template/row-list.i "integral.PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry B-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
  RUN get-attribute ('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' 
  THEN ASSIGN integral.PL-BOLE.codpln = integral.PL-CALC.codpln
              integral.PL-BOLE.codcal = integral.PL-CALC.codcal.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
  {src/adm/template/snd-list.i "integral.PL-CALC"}
  {src/adm/template/snd-list.i "integral.PL-BOLE"}

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


