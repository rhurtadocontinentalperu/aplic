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

DEFINE VARIABLE OK      AS LOGICAL NO-UNDO.
DEFINE VARIABLE s-ROWID AS ROWID NO-UNDO.
{bin/s-global.i}
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
&Scoped-define EXTERNAL-TABLES INTEGRAL.PL-FLG-MES
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.PL-FLG-MES


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.PL-FLG-MES.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.PR-MOV-MES

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table INTEGRAL.PR-MOV-MES.NumOrd ~
INTEGRAL.PR-MOV-MES.FchReg INTEGRAL.PR-MOV-MES.HoraI ~
INTEGRAL.PR-MOV-MES.HoraF INTEGRAL.PR-MOV-MES.Periodo ~
INTEGRAL.PR-MOV-MES.NroMes INTEGRAL.PR-MOV-MES.Numliq ~
INTEGRAL.PR-MOV-MES.FlgEst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH INTEGRAL.PR-MOV-MES OF INTEGRAL.PL-FLG-MES WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY INTEGRAL.PR-MOV-MES.CodCia ~
       BY INTEGRAL.PR-MOV-MES.Periodo ~
        BY INTEGRAL.PR-MOV-MES.codpln ~
         BY INTEGRAL.PR-MOV-MES.NroMes ~
          BY INTEGRAL.PR-MOV-MES.codper ~
           BY INTEGRAL.PR-MOV-MES.NumOrd ~
            BY INTEGRAL.PR-MOV-MES.FchReg ~
             BY INTEGRAL.PR-MOV-MES.HoraI.
&Scoped-define TABLES-IN-QUERY-br_table INTEGRAL.PR-MOV-MES
&Scoped-define FIRST-TABLE-IN-QUERY-br_table INTEGRAL.PR-MOV-MES


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
      INTEGRAL.PR-MOV-MES SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      INTEGRAL.PR-MOV-MES.NumOrd COLUMN-LABEL "Orden !Trabajo" FORMAT "X(12)"
      INTEGRAL.PR-MOV-MES.FchReg COLUMN-LABEL "Fecha              !Registro"
      INTEGRAL.PR-MOV-MES.HoraI COLUMN-LABEL "Hora    !Inicial"
      INTEGRAL.PR-MOV-MES.HoraF COLUMN-LABEL "Hora    !Final"
      INTEGRAL.PR-MOV-MES.Periodo COLUMN-LABEL "Año       !."
      INTEGRAL.PR-MOV-MES.NroMes COLUMN-LABEL "Mes    !."
      INTEGRAL.PR-MOV-MES.Numliq COLUMN-LABEL "Liquidacion"
      INTEGRAL.PR-MOV-MES.FlgEst COLUMN-LABEL "Estado"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 61.57 BY 8.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.15 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.PL-FLG-MES
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
         HEIGHT             = 8.77
         WIDTH              = 61.57.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.PR-MOV-MES OF INTEGRAL.PL-FLG-MES"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.PR-MOV-MES.CodCia|yes,INTEGRAL.PR-MOV-MES.Periodo|yes,INTEGRAL.PR-MOV-MES.codpln|yes,INTEGRAL.PR-MOV-MES.NroMes|yes,INTEGRAL.PR-MOV-MES.codper|yes,INTEGRAL.PR-MOV-MES.NumOrd|yes,INTEGRAL.PR-MOV-MES.FchReg|yes,INTEGRAL.PR-MOV-MES.HoraI|yes"
     _FldNameList[1]   > INTEGRAL.PR-MOV-MES.NumOrd
"PR-MOV-MES.NumOrd" "Orden !Trabajo" "X(12)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > INTEGRAL.PR-MOV-MES.FchReg
"PR-MOV-MES.FchReg" "Fecha              !Registro" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.PR-MOV-MES.HoraI
"PR-MOV-MES.HoraI" "Hora    !Inicial" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.PR-MOV-MES.HoraF
"PR-MOV-MES.HoraF" "Hora    !Final" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[5]   > INTEGRAL.PR-MOV-MES.Periodo
"PR-MOV-MES.Periodo" "Año       !." ? "integer" ? ? ? ? ? ? no "Año"
     _FldNameList[6]   > INTEGRAL.PR-MOV-MES.NroMes
"PR-MOV-MES.NroMes" "Mes    !." ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[7]   > INTEGRAL.PR-MOV-MES.Numliq
"PR-MOV-MES.Numliq" "Liquidacion" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[8]   > INTEGRAL.PR-MOV-MES.FlgEst
"PR-MOV-MES.FlgEst" "Estado" ? "character" ? ? ? ? ? ? no ?
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

{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF PR-MOV-MES.NumOrd, PR-MOV-MES.FchReg, PR-MOV-MES.HoraI, PR-MOV-MES.HoraF
DO:
  IF PR-MOV-MES.NumOrd:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       APPLY "ENTRY" TO PR-MOV-MES.NumOrd IN BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.
  END.   
  APPLY "TAB":U.
  RETURN NO-APPLY.
END.

ON "LEAVE":U OF PR-MOV-MES.NumOrd
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN .

   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   /* Valida Maestro Productos */
   FIND PR-ODPC WHERE PR-ODPC.Codcia = S-CODCIA AND
                      PR-ODPC.NumOrd = SELF:SCREEN-VALUE 
                      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de Trabajo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF PR-ODPC.FlgEst = "C" THEN DO:
      MESSAGE "Orden de Trabajo Liquidada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF PR-ODPC.FlgEst = "A" THEN DO:
      MESSAGE "Orden de Trabajo Anulada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF PR-ODPC.FlgEst = "B" THEN DO:
      MESSAGE "Orden de Trabajo Bloqueada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

END.


ON "LEAVE":U OF PR-MOV-MES.FchReg
DO:
  IF MONTH(DATE(SELF:SCREEN-VALUE)) <> s-nromes OR 
     YEAR(DATE(SELF:SCREEN-VALUE)) <> s-periodo THEN DO:
      MESSAGE "Fecha de Registro fuera del Periodo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF PR-MOV-MES.HoraI
DO:
  IF DEC(SELF:SCREEN-VALUE) < 0 OR DEC(SELF:SCREEN-VALUE) > 24 THEN DO:
      MESSAGE "Hora Inicial No Permitida" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF PR-MOV-MES.HoraF
DO:
  IF DEC(SELF:SCREEN-VALUE) < 0 OR DEC(SELF:SCREEN-VALUE) > 24 THEN DO:
      MESSAGE "Hora Final No Permitida" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  IF DEC(SELF:SCREEN-VALUE) < DEC(PR-MOV-MES.HoraI:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
      MESSAGE "Hora Final No puede ser menor a Hora Inicial" VIEW-AS ALERT-BOX ERROR.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "INTEGRAL.PL-FLG-MES"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.PL-FLG-MES"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    RUN get-attribute ('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN
        ASSIGN
            PR-MOV-MES.CodCia      = s-codcia
            PR-MOV-MES.Periodo     = s-periodo
            PR-MOV-MES.nromes      = s-nromes
            PR-MOV-MES.codpln      = PL-FLG-MES.CodPln
            PR-MOV-MES.CodPer      = PL-FLG-MES.CodPer.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   FIND PR-ODPC WHERE PR-ODPC.Codcia = S-CODCIA AND
                      PR-ODPC.NumOrd = PR-MOV-MES.NumOrd 
                      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-ODPC THEN DO:
      MESSAGE "Orden de Trabajo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.
   IF PR-ODPC.FlgEst = "C" THEN DO:
      MESSAGE "Orden de Trabajo Liquidada" VIEW-AS ALERT-BOX ERROR.
      RETURN .
   END.
   IF PR-ODPC.FlgEst = "B" THEN DO:
      MESSAGE "Orden de Trabajo Bloqueado" VIEW-AS ALERT-BOX ERROR.
      RETURN .
   END.
   IF PR-MOV-MES.NumLiq <> "" THEN DO:
      MESSAGE "Registro Presenta Liquidacion" VIEW-AS ALERT-BOX ERROR.
      RETURN .
   
   END.
   
  IF PR-MOV-MES.FlgEst = "C" THEN RETURN.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  {src/adm/template/snd-list.i "INTEGRAL.PL-FLG-MES"}
  {src/adm/template/snd-list.i "INTEGRAL.PR-MOV-MES"}

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


