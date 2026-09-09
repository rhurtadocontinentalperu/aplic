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

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE s-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-coddiv AS CHAR.
DEFINE SHARED VARIABLE s-tipo AS CHARACTER.
DEFINE SHARED VARIABLE s-codcli LIKE gn-clie.codcli.
DEFINE SHARED VARIABLE fathWH AS HANDLE NO-UNDO.
DEF SHARED VAR cl-codcia AS INT.

DEFINE VARIABLE L-CODREF AS CHAR NO-UNDO INITIAL "N/C".
DEFINE VARIABLE L-NROREF AS CHAR NO-UNDO.

/* Se usa para las retenciones */
DEFINE SHARED TEMP-TABLE wrk_ret NO-UNDO
    FIELDS CodCia LIKE CcbDCaja.CodCia
    FIELDS CodCli LIKE CcbCDocu.CodCli
    FIELDS CodDoc LIKE CcbCDocu.CodDoc COLUMN-LABEL "Tipo  "
    FIELDS NroDoc LIKE CcbCDocu.NroDoc COLUMN-LABEL "Documento " FORMAT "x(10)"
    FIELDS CodRef LIKE CcbDCaja.CodRef
    FIELDS NroRef LIKE CcbDCaja.NroRef
    FIELDS FchDoc LIKE CcbCDocu.FchDoc COLUMN-LABEL "    Fecha    !    Emisión    "
    FIELDS FchVto LIKE CcbCDocu.FchVto COLUMN-LABEL "    Fecha    ! Vencimiento"
    FIELDS CodMon AS CHARACTER COLUMN-LABEL "Moneda" FORMAT "x(3)"
    FIELDS ImpTot LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe Total"
    FIELDS ImpRet LIKE CcbDCaja.ImpTot COLUMN-LABEL "Importe!a Retener"
    FIELDS FchRet AS DATE
    FIELDS NroRet AS CHARACTER
    INDEX ind01 CodRef NroRef.

DEFINE SHARED TEMP-TABLE wrk_dcaja NO-UNDO LIKE ccbdcaja.

DEFINE BUFFER DCAJA FOR wrk_dcaja.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

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
&Scoped-define INTERNAL-TABLES wrk_dcaja CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table wrk_dcaja.CodRef wrk_dcaja.NroRef CcbCDocu.FchDoc CcbCDocu.FchVto wrk_dcaja.CodDoc CcbCDocu.SdoAct wrk_dcaja.ImpTot   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table wrk_dcaja.NroRef ~
wrk_dcaja.ImpTot   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table wrk_dcaja
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table wrk_dcaja
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH wrk_dcaja NO-LOCK, ~
             FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia       AND CcbCDocu.CodCli = wrk_dcaja.CodCli       AND CcbCDocu.CodDoc = wrk_dcaja.CodRef       AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH wrk_dcaja NO-LOCK, ~
             FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia       AND CcbCDocu.CodCli = wrk_dcaja.CodCli       AND CcbCDocu.CodDoc = wrk_dcaja.CodRef       AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table wrk_dcaja CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table wrk_dcaja
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


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
      wrk_dcaja, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      wrk_dcaja.CodRef COLUMN-LABEL  "Tipo  "
      wrk_dcaja.NroRef COLUMN-LABEL "Documento " FORMAT "x(15)"
      CcbCDocu.FchDoc  COLUMN-LABEL "    Fecha    !    Emisión    "
      CcbCDocu.FchVto  COLUMN-LABEL "    Fecha    ! Vencimiento"
      wrk_dcaja.CodDoc COLUMN-LABEL "Moneda" FORMAT "x(3)"
      CcbCDocu.SdoAct  COLUMN-LABEL "Saldo ! Actual"
      wrk_dcaja.ImpTot COLUMN-LABEL "Importe ! a Pagar"
  ENABLE
      wrk_dcaja.NroRef
      wrk_dcaja.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 64 BY 6.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
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
         HEIGHT             = 6.58
         WIDTH              = 64.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
 OPEN QUERY {&SELF-NAME} FOR EACH wrk_dcaja NO-LOCK,
      FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
      AND CcbCDocu.CodCli = wrk_dcaja.CodCli
      AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
      AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
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


/* ***************************  TRIGGERS DE CONTROL  *************************** */

ON "RETURN":U OF wrk_dcaja.NroRef, wrk_dcaja.ImpTot DO:
    APPLY "TAB":U.
    RETURN NO-APPLY.
END.

ON ENTRY OF wrk_dcaja.NroRef DO:
    IF wrk_dcaja.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN
        wrk_dcaja.CodRef:SCREEN-VALUE = L-CODREF.
END.

ON LEAVE OF wrk_dcaja.NroRef DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    wrk_dcaja.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
    FIND ccbcdocu WHERE
        ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = wrk_dcaja.codref:SCREEN-VALUE AND
        ccbcdocu.nrodoc = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE = STRING(ccbcdocu.fchdoc)
            ccbcdocu.fchvto:SCREEN-VALUE = STRING(ccbcdocu.fchvto)
            wrk_dcaja.coddoc:SCREEN-VALUE = (IF ccbcdocu.codmon = 1
                THEN "S/." ELSE "US$")
            ccbcdocu.sdoact:SCREEN-VALUE = STRING(ccbcdocu.sdoact)
            wrk_dcaja.imptot:SCREEN-VALUE = STRING(ccbcdocu.sdoact).
    END.        
    ELSE DO:
        ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE = ""
            ccbcdocu.fchvto:SCREEN-VALUE = ""
            wrk_dcaja.coddoc:SCREEN-VALUE = ""
            ccbcdocu.sdoact:SCREEN-VALUE = ""
            wrk_dcaja.imptot:SCREEN-VALUE = "".
        MESSAGE
            "El documento de referencia no es un documento por cobrar"
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

ON "F8":U OF wrk_dcaja.nroref OR "LEFT-MOUSE-DBLCLICK":U OF wrk_dcaja.nroref DO:
    ASSIGN
        input-var-1 = wrk_dcaja.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        input-var-2 = s-codcli
        /*input-var-3 = (IF s-Tipo = 'MOSTRADOR' THEN 'MOSTRADOR' ELSE '') */
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-docflg-div ('Notas de Abono').
    IF output-var-1 <> ? THEN DO:
        FIND ccbcdocu WHERE ROWID(ccbcdocu) = output-var-1 NO-LOCK NO-ERROR.
        IF AVAILABLE ccbcdocu
        THEN SELF:SCREEN-VALUE = ccbcdocu.nrodoc.
    END.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE dTpoCmb AS DECIMAL NO-UNDO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    ASSIGN
        wrk_dcaja.CodCia = S-CODCIA
        wrk_dcaja.CodCli = S-CodCli
        wrk_dcaja.codref = wrk_dcaja.codref:SCREEN-VALUE IN BROWSE {&browse-name}
        wrk_dcaja.nroref = L-NROREF
        wrk_dcaja.imptot = DECIMAL(wrk_dcaja.imptot:SCREEN-VALUE IN BROWSE {&browse-name}).
    FIND ccbcdocu WHERE
        ccbcdocu.codcia = s-codcia AND
        ccbcdocu.codcli = s-codcli AND
        ccbcdocu.coddoc = wrk_dcaja.codref AND
        ccbcdocu.nrodoc = wrk_dcaja.nroref
        NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu THEN DO:
        ASSIGN
            wrk_dcaja.CodCli = ccbcdocu.codcli
            wrk_dcaja.CodMon = ccbcdocu.codmon
            wrk_dcaja.CodDoc = IF ccbcdocu.codmon = 1 THEN "S/." ELSE "US$".
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = wrk_dcaja.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:
            dTpoCmb = 1.
            /* Verifica si Documento ya tiene aplicada la retencion */
            /*
            FIND FIRST CcbCmov WHERE
                CCBCMOV.CodCia = ccbcdocu.codcia AND
                CCBCMOV.CodDoc = ccbcdocu.coddoc AND
                CCBCMOV.NroDoc = ccbcdocu.nrodoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CCBCMOV 
                AND NOT CAN-FIND(FIRST wrk_ret WHERE wrk_ret.CodDoc = ccbcdocu.coddoc 
                                 AND wrk_ret.NroDoc = ccbcdocu.nrodoc) 
                THEN DO:
                FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= TODAY NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-tccja THEN DO:
                    IF ccbcdocu.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
                    ELSE dTpoCmb = Gn-tccja.Venta.
                END.
                CREATE wrk_ret.
                ASSIGN
                    wrk_ret.CodCia = ccbcdocu.codcia
                    wrk_ret.CodCli = ccbcdocu.codcli
                    wrk_ret.CodDoc = ccbcdocu.coddoc
                    wrk_ret.NroDoc = ccbcdocu.nrodoc
                    wrk_ret.FchDoc = ccbcdocu.fchdoc
                    wrk_ret.CodRef = "I/C"
                    wrk_ret.NroRef = ""
                    wrk_ret.CodMon = "S/.".
                /* OJO: Cálculo de Retenciones Siempre en Soles */
                IF ccbcdocu.codmon = 1 THEN DO:
                    wrk_ret.ImpTot = ccbcdocu.ImpTot *
                        IF LOOKUP(ccbcdocu.coddoc, "N/C,NCI") > 0 THEN -1 ELSE 1.
                    wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
                END.
                ELSE DO:
                    wrk_ret.ImpTot = ROUND((ccbcdocu.ImpTot * dTpoCmb),2) *
                        IF LOOKUP(ccbcdocu.coddoc, "N/C,NCI") > 0 THEN -1 ELSE 1.
                    wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
                END.
            END.
            */
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR L-CODREF AS CHAR NO-UNDO.

  L-CODREF = wrk_dcaja.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  L-NROREF = wrk_dcaja.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

  APPLY 'VALUE-CHANGED':U TO br_table IN FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    FOR EACH wrk_ret WHERE
        wrk_ret.CodDoc = L-CODREF AND
        wrk_ret.NroDoc = L-NROREF:
        DELETE wrk_ret.
    END.
    IF fathWH <> ?  THEN RUN proc_total6 IN fathWH.

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
  IF fathWH <> ?  THEN RUN proc_total6 IN fathWH.

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
        WHEN "CodRef" THEN 
            ASSIGN
                input-var-1 = "CARGO"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "NroRef" THEN 
            ASSIGN
                input-var-1 = wrk_dcaja.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                input-var-2 = s-codcli
                input-var-3 = "P".
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
  {src/adm/template/snd-list.i "wrk_dcaja"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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
    /* consistencia del documento */
    DEF VAR L-CODREF AS CHAR NO-UNDO.

    L-CODREF = wrk_dcaja.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    L-NROREF = wrk_dcaja.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
        AND ccbcdocu.coddiv = S-CODDIV
        AND ccbcdocu.coddoc = L-CODREF 
        AND ccbcdocu.nrodoc = L-NROREF NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ccbcdocu THEN DO:
        MESSAGE "N/C NO registrada o pertenece a otra división" 
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF ccbcdocu.codcli NE s-codcli  THEN DO:
        MESSAGE "Este documento no pertenece al cliente" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF ccbcdocu.flgest NE "P" THEN DO:
        MESSAGE "El documento de referencia no esta pendiente de pago" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF Ccbcdocu.FlgSit = "X" THEN DO:
        MESSAGE "Nota de Crédito está asignado a un canje por letra pendiente de aprobar"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    IF DECIMAL(wrk_dcaja.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > ccbcdocu.sdoact 
        THEN DO:
        MESSAGE "El importe a pagar es mayor que la deuda" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.imptot.
        RETURN "ADM-ERROR".
    END.
    IF Ccbcdocu.fchvto < TODAY THEN DO:
        MESSAGE 'N/C venció el' Ccbcdocu.fchvto VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    FIND DCAJA WHERE DCaja.CodCia = S-CODCIA 
        AND DCaja.CodCli = S-CodCli 
        AND DCaja.codref = L-CODREF 
        AND DCaja.nroref = L-NROREF NO-LOCK NO-ERROR.
    IF AVAILABLE DCAJA AND ROWID(DCAJA) <> ROWID(wrk_dcaja) THEN DO:
        MESSAGE "Documento repetido" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
        RETURN "ADM-ERROR".
    END.
    /* 03/01/2018 */
    IF Ccbcdocu.TpoFac = "OTROS" AND Ccbcdocu.CodCta = "00003" THEN DO:
        MESSAGE 'Esta NC no puede ser aplicada' SKIP
            'Consultar con Créditos y Cobranzas' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO wrk_dcaja.nroref.
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
IF NOT AVAILABLE wrk_dcaja THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

