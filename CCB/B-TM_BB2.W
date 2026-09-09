&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE s-Der AS LOGICAL.
DEFINE SHARED VARIABLE s-Izq AS LOGICAL.
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.
DEFINE SHARED VARIABLE s-coddiv AS CHARACTER.
DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-coddoc AS CHARACTER.
DEFINE SHARED VARIABLE S-CodCta LIKE cb-ctas.codcta.
DEFINE SHARED VARIABLE S-CodBco LIKE cb-ctas.codbco.
DEFINE SHARED VARIABLE S-User-Id AS CHAR.

  DEFINE SHARED TEMP-TABLE T-CcbDMvt1 LIKE CcbDMvto.
  DEFINE SHARED TEMP-TABLE T-CcbDMvto LIKE CcbDMvto.
  DEFINE BUFFER B-CcbDMvto FOR CcbDMvto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-CcbDMvt1

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-CcbDMvt1.CodRef t-CcbDMvt1.NroRef t-CcbDMvt1.TpoRef t-CcbDMvt1.FchVto t-CcbDMvt1.DepNac[1] t-CcbDMvt1.DepNac[2] t-CcbDMvt1.DepUsa[1] t-CcbDMvt1.DepUsa[2] t-CcbDMvt1.FchCie   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table t-CcbDMvt1.DepNac[2] ~
t-CcbDMvt1.DepUsa[2]   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}DepNac[2] ~{&FP2}DepNac[2] ~{&FP3}~
 ~{&FP1}DepUsa[2] ~{&FP2}DepUsa[2] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table t-CcbDMvt1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table t-CcbDMvt1
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH t-CcbDMvt1 NO-LOCK      INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table t-CcbDMvt1
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-CcbDMvt1


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-CcbDMvt1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      t-CcbDMvt1.CodRef    COLUMN-LABEL "Tipo!Deposito" FORMAT "X(8)"
      t-CcbDMvt1.NroRef    COLUMN-LABEL "Nro. Referencia"   FORMAT "X(20)" COLUMN-BGCOLOR 16
      t-CcbDMvt1.TpoRef    COLUMN-LABEL "Banco" FORMAT "X(5)"
      t-CcbDMvt1.FchVto    COLUMN-LABEL "Fecha!Vencimiento"
      t-CcbDMvt1.DepNac[1] COLUMN-LABEL "Saldo!Pendiente S/."
      t-CcbDMvt1.DepNac[2] COLUMN-LABEL "A Depositar!en S/." COLUMN-BGCOLOR 11
      t-CcbDMvt1.DepUsa[1] COLUMN-LABEL "Saldo!Pendiente US$"
      t-CcbDMvt1.DepUsa[2] COLUMN-LABEL "A Depositar!en US$" COLUMN-BGCOLOR 11
      t-CcbDMvt1.FchCie    COLUMN-LABEL "Fecha Cierre" FORMAT "99/99/9999"
  ENABLE
      t-CcbDMvt1.DepNac[2]
      t-CcbDMvt1.DepUsa[2]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 79.43 BY 5.85
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
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
         HEIGHT             = 5.92
         WIDTH              = 79.43.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH t-CcbDMvt1 NO-LOCK
     INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ANY-PRINTABLE OF br_table IN FRAME F-Main
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  T-CcbDMvt1.DepNac[2]:READ-ONLY IN BROWSE {&BROWSE-NAME} = (S-CODMON = 2).
  T-CcbDMvt1.DepUsa[2]:READ-ONLY IN BROWSE {&BROWSE-NAME} = (S-CODMON = 1).
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF t-CcbDMvt1.DepNac[2], t-CcbDMvt1.DepUsa[2]
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "ANY-PRINTABLE":U OF t-CcbDMvt1.DepNac[2] DO:
    IF DEC(t-CcbDMvt1.DepNac[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
        RETURN NO-APPLY.

    IF t-CcbDMvt1.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "EFEC" THEN
        RETURN NO-APPLY.
END.

ON "ANY-PRINTABLE":U OF t-CcbDMvt1.DepUsa[2] DO:
    IF DEC(t-CcbDMvt1.DepUsa[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN
        RETURN NO-APPLY.

    IF t-CcbDMvt1.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "EFEC" THEN
        RETURN NO-APPLY.
END.

ON "LEAVE":U OF t-CcbDMvt1.DepNac[2] DO:
   IF DEC(SELF:SCREEN-VALUE) = 0 THEN RETURN.
   t-CcbDMvt1.DepNac[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
   IF DEC(t-CcbDMvt1.DepNac[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 5 + DEC(t-CcbDMvt1.DepNac[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
   THEN DO:
      MESSAGE 'El Deposito no debe ser mayor al Saldo...' VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO t-CcbDMvt1.DepNac[2] IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF t-CcbDMvt1.DepUsa[2] DO:
   IF DEC(SELF:SCREEN-VALUE) = 0 THEN RETURN.
   t-CcbDMvt1.DepUsa[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
   IF DEC(t-CcbDMvt1.DepUsa[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 5 + DEC(t-CcbDMvt1.DepUsa[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
   THEN DO:
      MESSAGE 'El Deposito no debe ser mayor al Saldo...' VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO t-CcbDMvt1.DepUsa[2] IN BROWSE {&BROWSE-NAME}.
      RETURN NO-APPLY.
   END.
END.
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Deposito B-table-Win 
PROCEDURE Asigna-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-nro AS CHARACTER NO-UNDO.
DEFINE VAR sw AS LOGICAL NO-UNDO INIT FALSE.

FIND FIRST FacCorre WHERE 
           FacCorre.CodCia = S-CodCia AND 
           FacCorre.CodDiv = S-CodDiv AND 
           FacCorre.CodDoc = S-CodDoc EXCLUSIVE-LOCK NO-ERROR.

FOR EACH T-CcbDMvt1:
      CREATE CcbDMvto.
      ASSIGN
          CcbDMvto.CodCia = T-CcbDMvt1.CodCia
          CcbDMvto.CodDiv = T-CcbDMvt1.CodDiv
          CcbDMvto.CodDoc = S-CodDoc                /* "BBC" */
          CcbDMvto.CodCli = T-CcbDMvt1.CodCli       /***   Division   ****/
          CcbDMvto.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
          CcbDMvto.CodRef = T-CcbDMvt1.CodRef
          CcbDMvto.NroRef = T-CcbDMvt1.NroRef
          CcbDMvto.TpoRef = S-CodBco                    /****    Banco    ****/
          CcbDMvto.CodCta = S-CodCta                    /****   Cuenta    ****/
          CcbDMvto.DepNac[1] = T-CcbDMvt1.DepNac[1]     /*** saldo actual  ****/
          CcbDMvto.DepUsa[1] = T-CcbDMvt1.DepUsa[1]     /*** saldo actual  ****/
          CcbDMvto.DepNac[2] = T-CcbDMvt1.DepNac[2]     /*** a depositar   ****/
          CcbDMvto.DepUsa[2] = T-CcbDMvt1.DepUsa[2]     /*** a depositar   ****/
          CcbDMvto.FchVto  = T-CcbDMvt1.FchVto
          CcbDMvto.FchEmi  = T-CcbDMvt1.Fchemi
          CcbDMvto.FchCie  = T-CcbDMvt1.FchCie
          CcbDMvto.HorCie  = T-CcbDMvt1.HorCie
          CcbDMvto.usuario = S-User-Id.

      T-CcbDMvt1.NroDoc = CcbDMvto.NroDoc.
      /* Considerar si el efectivo fue asignado en varias partes */
      DEFINE VAR x-depnac AS DECIMAL NO-UNDO.
      DEFINE VAR x-depusa AS DECIMAL NO-UNDO.
      DEFINE VAR x-resnac AS DECIMAL NO-UNDO.
      DEFINE VAR x-resusa AS DECIMAL NO-UNDO.
      x-depnac = T-CcbDMvt1.DepNac[2].
      x-depusa = T-CcbDMvt1.DepUsa[2].
      FOR EACH b-CcbDMvto WHERE 
               b-CcbDMvto.CodCia = T-CcbDMvt1.CodCia
          AND  b-CcbDMvto.CodDoc = T-CcbDMvt1.CodDoc
          AND  b-CcbDMvto.CodCli = T-CcbDMvt1.CodCli
          AND  b-CcbDMvto.CodRef = T-CcbDMvt1.CodRef
          AND  b-CcbDMvto.NroRef = T-CcbDMvt1.NroRef
          AND  b-CcbDMvto.FchCie = T-CcbDMvt1.FchCie:
          x-resnac = MINIMUM(x-depnac, b-CcbDMvto.DepNac[3]).
          x-resusa = MINIMUM(x-depusa, b-CcbDMvto.DepUsa[3]).
          b-CcbDMvto.DepNac[3] = b-CcbDMvto.DepNac[3] - x-resnac.
          b-CcbDMvto.DepUsa[3] = b-CcbDMvto.DepUsa[3] - x-resusa.
          IF b-CcbDMvto.DepNac[3] + b-CcbDMvto.DepUsa[3] <= 0 THEN b-CcbDMvto.Flgest = 'T'.
          x-depnac = x-depnac - x-resnac.
          x-depusa = x-depusa - x-resusa.
      END.
      
/*      FIND ccbpendep WHERE CcbPenDep.CodCia = T-CcbDMvt1.CodCia
                      AND  CcbPenDep.CodDoc = T-CcbDMvt1.CodDoc
                      AND  CcbPenDep.CodDiv = T-CcbDMvt1.CodCia
                      AND  CcbPenDep.CodRef = T-CcbDMvt1.CodRef
                      AND  CcbPenDep.NroRef = T-CcbDMvt1.NroRef
                      AND  CcbPenDep.FchCie = T-CcbDMvt1.FchCie
      IF AVAILABLE ccbpendep THEN
         ASSIGN CcbPenDep.FlgEst = "B" */
         
/*      FIND b-CcbDMvto WHERE b-CcbDMvto.CodCia = T-CcbDMvt1.CodCia
                      AND  b-CcbDMvto.CodDoc = T-CcbDMvt1.CodDoc
                      AND  b-CcbDMvto.CodCli = T-CcbDMvt1.CodCli
                      AND  b-CcbDMvto.CodRef = T-CcbDMvt1.CodRef
                      AND  b-CcbDMvto.NroRef = T-CcbDMvt1.NroRef
                      AND  b-CcbDMvto.FchCie = T-CcbDMvt1.FchCie
                      NO-ERROR.
      IF AVAIL b-CcbDMvto THEN DO:
            b-CcbDMvto.DepNac[3] = b-CcbDMvto.DepNac[3] - T-CcbDMvt1.DepNac[2].
            b-CcbDMvto.DepUsa[3] = b-CcbDMvto.DepUsa[3] - T-CcbDMvt1.DepUsa[2].
      END.*/
         
      RELEASE b-CcbDMvto.
          
      IF NOT sw THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1
        sw = TRUE.
      DELETE T-CcbDMvt1.
END.

RELEASE faccorre.

RUN dispatch IN THIS-PROCEDURE ('imprime':U).

FIND FIRST T-CcbDMvto NO-ERROR.
IF AVAIL T-CcbDMvto THEN S-Der = TRUE.
ELSE S-Der = FALSE.

FIND FIRST T-CcbDMvt1 NO-ERROR.
IF AVAIL T-CcbDMvt1 THEN S-Izq = TRUE.
ELSE S-Izq = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Temporal B-table-Win 
PROCEDURE Asigna-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR n AS INTEGER NO-UNDO.

DO n = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(n) THEN DO:
      CREATE t-CcbDMvto.
      ASSIGN
          t-CcbDMvto.CodCia = t-CcbDMvt1.CodCia
          t-CcbDMvto.CodDoc = t-CcbDMvt1.CodDoc
          t-CcbDMvto.NroDoc = t-CcbDMvt1.NroDoc
          t-CcbDMvto.CodRef = t-CcbDMvt1.CodRef
          t-CcbDMvto.NroRef = t-CcbDMvt1.NroRef
          t-CcbDMvto.TpoRef = t-CcbDMvt1.TpoRef
          t-CcbDMvto.DepNac[1] = t-CcbDMvt1.DepNac[1]
          t-CcbDMvto.DepUsa[1] = t-CcbDMvt1.DepUsa[1]
          t-CcbDMvto.DepNac[2] = t-CcbDMvt1.DepNac[2]
          t-CcbDMvto.DepUsa[2] = t-CcbDMvt1.DepUsa[2]
          t-CcbDMvto.DepNac[3] = t-CcbDMvt1.DepNac[2]
          t-CcbDMvto.DepUsa[3] = t-CcbDMvt1.DepUsa[2]
          t-CcbDMvto.FchVto = t-CcbDMvt1.FchVto
          t-CcbDMvto.FchCie = t-CcbDMvt1.FchCie
          t-CcbDMvto.HorCie = t-CcbDMvt1.HorCie
          t-CcbDMvto.usuario = t-CcbDMvt1.usuario.

      DELETE t-CcbDMvt1.
    END.
END.

FIND FIRST t-CcbDMvto NO-ERROR.
IF AVAIL t-CcbDMvto THEN S-Der = TRUE.
ELSE S-Der = FALSE.

FIND FIRST t-CcbDMvt1 NO-ERROR.
IF AVAIL t-CcbDMvt1 THEN S-Izq = TRUE.
ELSE S-Izq = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Deselect-All B-table-Win 
PROCEDURE Deselect-All :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pto AS LOGICAL NO-UNDO.
DEF VAR n   AS INTEGER NO-UNDO.
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} > 0 THEN DO:
    DO n = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        pto = {&BROWSE-NAME}:DESELECT-ROWS( ).
    END.    
END.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 RUN CCB\r-bovbco.
 
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
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Select-All B-table-Win 
PROCEDURE Select-All :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pto AS LOGICAL NO-UNDO.
DEF VAR n   AS INTEGER NO-UNDO.
IF {&BROWSE-NAME}:NUM-ITERATIONS IN FRAME {&FRAME-NAME} > 0 THEN DO:
    DO n = 1 TO {&BROWSE-NAME}:NUM-ITERATIONS IN FRAME {&FRAME-NAME}:
        pto = {&BROWSE-NAME}:SELECT-ROW(n).
    END.    
END.
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
  {src/adm/template/snd-list.i "t-CcbDMvt1"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  EN CASO DE ERROR RETORNAR : RETURN "ADM-ERROR"
------------------------------------------------------------------------------*/

IF DECIMAL(t-CcbDMvt1.DepNac[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > (5 + DECIMAL(t-CcbDMvt1.DepNac[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})) THEN DO:
   MESSAGE "El Deposito no debe ser mayor al Saldo" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Consistenciar la modificacion de la fila
  Parameters:  Retornar "ADM-ERROR" en caso de bloquear la modificacion
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


