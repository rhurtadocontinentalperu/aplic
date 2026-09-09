&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR cb-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE SHARED TEMP-TABLE VMOV LIKE cb-cmov.
DEFINE VARIABLE L-CREA AS LOGICAL.
DEFINE VARIABLE I-CODMON AS INTEGER.

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
&Scoped-define FIELDS-IN-QUERY-br_table RMOV.CodCta RMOV.Coddoc RMOV.Nrodoc RMOV.Glodoc RMOV.TpoMov RMOV.ImpMn1 RMOV.ImpMn2   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table RMOV.CodCta ~
 RMOV.Coddoc ~
 RMOV.Nrodoc ~
 RMOV.Glodoc ~
 RMOV.TpoMov ~
 RMOV.ImpMn1 ~
 RMOV.ImpMn2   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table RMOV
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table RMOV
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH RMOV       WHERE RMOV.TpoMov NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH RMOV       WHERE RMOV.TpoMov NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table RMOV
&Scoped-define FIRST-TABLE-IN-QUERY-br_table RMOV


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-8 RECT-9 
&Scoped-Define DISPLAYED-OBJECTS F-SdoCta-1 F-SdoCta-2 F-TotMn1 F-TotMn2 

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
DEFINE VARIABLE F-SdoCta-1 AS DECIMAL FORMAT "(>>>,>>>,>>9.99)":U INITIAL 0 
     LABEL "Saldos  :    S/." 
     VIEW-AS FILL-IN 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE F-SdoCta-2 AS DECIMAL FORMAT "(>>>,>>>,>>9.99)":U INITIAL 0 
     LABEL "US$" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE F-TotMn1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10.72 BY .62 NO-UNDO.

DEFINE VARIABLE F-TotMn2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.43 BY .77.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.43 BY .77.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      RMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      RMOV.CodCta FORMAT "x(10)"
      RMOV.Coddoc
      RMOV.Nrodoc FORMAT "x(12)"
      RMOV.Glodoc
      RMOV.TpoMov
      RMOV.ImpMn1
      RMOV.ImpMn2
      ENABLE
        RMOV.CodCta 
        RMOV.Coddoc
        RMOV.Nrodoc
        RMOV.Glodoc
        RMOV.TpoMov
        RMOV.ImpMn1
        RMOV.ImpMn2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71.86 BY 4.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-SdoCta-1 AT ROW 5.69 COL 10 COLON-ALIGNED
     F-SdoCta-2 AT ROW 5.69 COL 27 COLON-ALIGNED
     F-TotMn1 AT ROW 5.69 COL 46 COLON-ALIGNED NO-LABEL
     F-TotMn2 AT ROW 5.69 COL 57.29 COLON-ALIGNED NO-LABEL
     RECT-8 AT ROW 5.62 COL 47.43
     RECT-9 AT ROW 5.62 COL 58.72
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
         HEIGHT             = 5.54
         WIDTH              = 73.
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

/* SETTINGS FOR FILL-IN F-SdoCta-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SdoCta-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotMn1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotMn2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH RMOV
      WHERE RMOV.TpoMov NO-LOCK INDEXED-REPOSITION.
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
  FIND LAST VMOV NO-LOCK NO-ERROR.
  IF L-CREA THEN 
     ASSIGN RMOV.TpoMov:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "YES"
            I-CODMON = VMOV.CODMON.
  ELSE I-CODMON = RMOV.CodMon.
  
  IF I-CODMON = 1 THEN 
     ASSIGN RMOV.ImpMn1:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO
            RMOV.ImpMn2:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  ELSE 
     ASSIGN RMOV.ImpMn1:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
            RMOV.ImpMn2:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
            
  
  RMOV.TpoMov:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  
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
  IF AVAILABLE RMOV THEN RUN Saldo-Cuenta(RMOV.CodCta).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* DEFINICION DE TRIGGERS */
ON "RETURN":U OF RMOV.CodCta,RMOV.CodDoc,RMOV.Nrodoc,RMOV.GloDoc,RMOV.TpoMov
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF RMOV.CodCta
DO:
   IF RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN RETURN.
   RMOV.CODCTA:SCREEN-VALUE = RMOV.CODCTA:SCREEN-VALUE.
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
        cb-ctas.Codcta = RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-ctas THEN
      FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
           cb-ctas.Codcta = RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
           NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-ctas THEN DO:
      MESSAGE "Cuenta no registrada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   I-CODMON = cb-ctas.CodMon.
   IF cb-ctas.CodMon = 1 THEN 
      ASSIGN RMOV.ImpMn1:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO
             RMOV.ImpMn2:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
   ELSE 
      ASSIGN RMOV.ImpMn1:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
             RMOV.ImpMn2:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
   IF cb-ctas.PidDoc THEN 
      ASSIGN RMOV.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = cb-ctas.Coddoc
             RMOV.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = cb-ctas.nrochq.
   RMOV.GloDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = cb-ctas.NomCta.
   RUN Saldo-Cuenta(RMOV.CodCta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
END.

ON "LEAVE":U OF RMOV.CodDoc
DO:
  RMOV.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  IF RMOV.CodDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "CH" THEN 
     RMOV.NroDoc:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  L-CREA = YES.

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

  FIND LAST VMOV NO-LOCK NO-ERROR.
  ASSIGN RMOV.TpoCmb = VMOV.TpoCmb
         RMOV.CodMon = I-CODMON.
  IF RMOV.CodMon = 1 AND RMOV.TpoCmb > 0 THEN
       ASSIGN RMOV.ImpMn2 = ROUND(RMOV.ImpMn1 / RMOV.TpoCmb,2).
  ELSE ASSIGN RMOV.ImpMn1 = ROUND(RMOV.ImpMn2 * RMOV.TpoCmb,2).
  DISPLAY RMOV.ImpMn1 RMOV.ImpMn2 WITH BROWSE {&BROWSE-NAME}.
  RUN Total-Importe.

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

  RUN Total-Importe.
  
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
        WHEN "CodDoc" THEN ASSIGN input-var-1 = "02".
        WHEN "Codcta" THEN ASSIGN input-var-1 = "10".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldo-Cuenta B-table-Win 
PROCEDURE Saldo-Cuenta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER C-CODCTA AS CHAR.
DEFINE VARIABLE II AS INTEGER.
DEFINE VARIABLE F-SdoCta AS DECIMAL EXTENT 2 INITIAL 0.
     FIND cb-acmd WHERE cb-acmd.CodCia = S-CODCIA AND
                       cb-acmd.Periodo = S-PERIODO AND
                       cb-acmd.CodCta  = C-CODCTA AND
                       cb-acmd.CodAux  = "" AND
                       cb-acmd.CodDiv  = "" NO-LOCK NO-ERROR.
     IF AVAILABLE cb-acmd THEN 
        DO II = 1 TO 14:
           F-SdoCta[1] = F-SdoCta[1] + (DbeMn1[II] - HbeMn1[II]).
           F-SdoCta[2] = F-SdoCta[2] + (DbeMn2[II] - HbeMn2[II]).
        END.
     DISPLAY F-SdoCta[1] @ F-SdoCta-1
             F-SdoCta[2] @ F-SdoCta-2 WITH FRAME {&FRAME-NAME}.

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
  IF p-state = 'update-begin':U THEN L-CREA = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Total-Importe B-table-Win 
PROCEDURE Total-Importe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER DETALLE FOR RMOV.
DEFINE VAR F-IMPORTE AS DECIMAL EXTENT 2.
FOR EACH DETALLE WHERE DETALLE.TpoMov:
    F-IMPORTE[1] = F-IMPORTE[1] + DETALLE.ImpMn1. 
    F-IMPORTE[2] = F-IMPORTE[2] + DETALLE.ImpMn2. 
END.
DISPLAY STRING(F-IMPORTE[1],">>>>,>>>,>>9.99") @ F-TotMn1
        STRING(F-IMPORTE[2],">>>>,>>>,>>9.99") @ F-TotMn2 WITH FRAME {&FRAME-NAME}.
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
IF VMOV.TpoCmb = 0 THEN DO:
   MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
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
IF RMOV.Nrodoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "No.de Documento en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO RMOV.Nrodoc.
   RETURN "ADM-ERROR".
END.
IF I-CODMON = 1 THEN DO:
   IF DECIMAL(RMOV.ImpMn1:SCREEN-VALUE  IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Importe debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO RMOV.ImpMn1.
     RETURN "ADM-ERROR".
   END.
END.
IF I-CODMON = 2 THEN DO:
   IF DECIMAL(RMOV.ImpMn2:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Importe debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO RMOV.ImpMn2.
     RETURN "ADM-ERROR".
   END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

