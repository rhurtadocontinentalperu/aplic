&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE CB-CODCIA AS INTEGER.
DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/*ML01* 24/Jun/2008 ***/
DEFINE SHARED VARIABLE fFchAst AS DATE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES RMOV

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table RMOV.CodDiv RMOV.CodCta RMOV.Coddoc RMOV.Nrodoc RMOV.Fchdoc RMOV.Fchvto RMOV.TpoMov RMOV.ImpMn1 RMOV.ImpMn2 RMOV.Tpocmb RMOV.Clfaux RMOV.Codaux RMOV.Nroref RMOV.cco   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table RMOV.CodDiv ~
 RMOV.CodCta ~
 RMOV.Coddoc ~
 RMOV.Nrodoc ~
 RMOV.Fchdoc ~
 RMOV.Fchvto ~
 RMOV.TpoMov ~
 RMOV.ImpMn1 ~
 RMOV.ImpMn2 ~
 RMOV.Tpocmb ~
 RMOV.Clfaux ~
 RMOV.Codaux ~
 RMOV.Nroref ~
 RMOV.cco   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table RMOV
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table RMOV
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH RMOV       NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH RMOV       NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table RMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table RMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-15 
&Scoped-Define DISPLAYED-OBJECTS F-Soles F-Dolares 

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
DEFINE VARIABLE F-Dolares AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81 NO-UNDO.

DEFINE VARIABLE F-Soles AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 36.57 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      RMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      RMOV.CodDiv COLUMN-LABEL "Division"
      RMOV.CodCta FORMAT "x(10)"
      RMOV.Coddoc
      RMOV.Nrodoc FORMAT "x(12)"
      RMOV.Fchdoc COLUMN-LABEL "Fecha Emision"
      RMOV.Fchvto COLUMN-LABEL "Fecha Vencmto"
      RMOV.TpoMov
      RMOV.ImpMn1
      RMOV.ImpMn2
      RMOV.Tpocmb 
      RMOV.Clfaux
      RMOV.Codaux 
      RMOV.Nroref 
      RMOV.cco
      ENABLE
        RMOV.CodDiv
        RMOV.CodCta
        RMOV.Coddoc
        RMOV.Nrodoc
        RMOV.Fchdoc
        RMOV.Fchvto
        RMOV.TpoMov
        RMOV.ImpMn1
        RMOV.ImpMn2
        RMOV.Tpocmb 
        RMOV.Clfaux
        RMOV.Codaux 
        RMOV.Nroref 
        RMOV.cco
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71.86 BY 8.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-Soles AT ROW 9.77 COL 46.43 COLON-ALIGNED NO-LABEL
     F-Dolares AT ROW 9.77 COL 59 COLON-ALIGNED NO-LABEL
     "TOTAL :" VIEW-AS TEXT
          SIZE 7.43 BY .5 AT ROW 9.96 COL 37.86
          FONT 6
     RECT-15 AT ROW 9.69 COL 36
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.96
         WIDTH              = 71.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-Dolares IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Soles IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH RMOV
      NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
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


ON "RETURN":U OF RMOV.CodCta,RMOV.Coddoc,RMOV.Nrodoc,RMOV.Fchdoc,RMOV.Fchvto,RMOV.TpoMov,RMOV.ImpMn1,RMOV.ImpMn2,RMOV.Tpocmb,RMOV.Clfaux,RMOV.Codaux,RMOV.Nroref,RMOV.cco
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
ON "LEAVE":U  OF RMOV.CodCta
DO:
   IF RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.
   RMOV.CODCTA:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

ON "LEAVE":U  OF RMOV.CodDiv
DO:
   IF RMOV.CodDiv:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.
   RMOV.CODDiv:SCREEN-VALUE = SELF:SCREEN-VALUE.
END.

ON "MOUSE-SELECT-DBLCLICK":U OF RMOV.CodAux  
DO:
  output-var-1 = ?.
  output-var-2 = "".
  CASE RMOV.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
       WHEN "@PV" THEN DO:
            RUN CBD\C-PROVEE("Maestro de Proveedores").
       END.
       WHEN "@CL" THEN DO:
            RUN CBD\C-CLIENT("Maestro de Clientes").
       END.
       OTHERWISE DO:
            input-var-1 = RMOV.clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
            RUN CBD\C-AUXIL("Maestro de Auxiliares").
       END.
  END CASE.
  IF output-var-1 NE ?  THEN  RMOV.CODAUX:SCREEN-VALUE = output-var-2.
END.

ON "LEAVE":U  OF RMOV.CodAUX
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  CASE RMOV.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
       WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = 0 AND
                 gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN
               FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND
                    gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
       WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = 0 AND
                 gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN
               FIND gn-clie WHERE gn-clie.CodCia = S-CODCIA AND
                    gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
       OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
                 cb-auxi.ClfAux = RMOV.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                 cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi THEN
               FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
                    cb-auxi.ClfAux = RMOV.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                    cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-AUXI THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
       END.
  END CASE.
END.
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar B-table-Win 
PROCEDURE Asignar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN cbd\D-cjedoc.R.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  RUN Totales.
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
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = 'Yes' THEN DO:
     ASSIGN 
        RMOV.Codmon = 1.
  END.
     
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
  RUN Totales.
  
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
        WHEN "CodDoc" THEN ASSIGN input-var-1 = "02".
        WHEN "Clfaux" THEN ASSIGN input-var-1 = "01".
        WHEN "Codaux" THEN ASSIGN input-var-1 = RMOV.clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "RMOV"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-soles   AS DECIMAL NO-UNDO.
  DEFINE VAR x-dolares AS DECIMAL NO-UNDO.
  FOR EACH RMOV:
     x-soles   = x-soles   + RMOV.ImpMn1.
     x-dolares = x-dolares + RMOV.ImpMn2.
  END.
  DISPLAY
     x-soles @ F-soles
     x-dolares @ F-dolares WITH FRAME {&FRAME-NAME}.
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
IF RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Cuenta en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO RMOV.CodCta.
   RETURN "ADM-ERROR".   
END.
FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
     cb-ctas.Codcta = RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN
   FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
        cb-ctas.Codcta = RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-ctas THEN DO:
   MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO RMOV.CodCta.
   RETURN "ADM-ERROR".   
END.
IF RMOV.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Documento en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO RMOV.CodDoc.
   RETURN "ADM-ERROR".
END.
IF RMOV.Nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "No.de Documento en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO RMOV.Nrodoc.
   RETURN "ADM-ERROR".
END.
   IF DECIMAL(RMOV.ImpMn1:SCREEN-VALUE  IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Importe debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO RMOV.ImpMn1.
     RETURN "ADM-ERROR".
   END.
   IF DECIMAL(RMOV.ImpMn2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Importe debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO RMOV.ImpMn2.
     RETURN "ADM-ERROR".
   END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

