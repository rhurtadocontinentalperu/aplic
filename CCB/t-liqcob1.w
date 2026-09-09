&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codcli LIKE gn-clie.codcli.
DEF SHARED VAR s-tipo    AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE VARIABLE L-CODREF AS CHAR NO-UNDO.
DEFINE VARIABLE L-NROREF AS CHAR NO-UNDO.
DEF SHARED TEMP-TABLE t-ccbdcob LIKE ccbdcob.
DEFINE BUFFER DCAJA FOR t-ccbdcob.

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
&Scoped-define INTERNAL-TABLES T-ccbdcob

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-ccbdcob.CodCli T-ccbdcob.Nomcli T-ccbdcob.ImpNaC[1] T-ccbdcob.ImpUsa[1] T-ccbdcob.ImpNaC[2] T-ccbdcob.ImpUsa[2] T-ccbdcob.ImpNaC[5] T-ccbdcob.ImpUsa[5]   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-ccbdcob.Codcli ~
T-ccbdcob.Nomcli ~
T-ccbdcob.ImpNaC[1] ~
 T-ccbdcob.ImpUsa[1] ~
 T-ccbdcob.ImpNaC[2] ~
 T-ccbdcob.ImpUsa[2] ~
 T-ccbdcob.ImpNaC[5] ~
 T-ccbdcob.ImpUsa[5]   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Codcli ~{&FP2}Codcli ~{&FP3}~
 ~{&FP1}Nomcli ~{&FP2}Nomcli ~{&FP3}~
 ~{&FP1}ImpNaC[1] ~{&FP2}ImpNaC[1] ~{&FP3}~
 ~{&FP1}ImpUsa[1] ~{&FP2}ImpUsa[1] ~{&FP3}~
 ~{&FP1}ImpNaC[2] ~{&FP2}ImpNaC[2] ~{&FP3}~
 ~{&FP1}ImpUsa[2] ~{&FP2}ImpUsa[2] ~{&FP3}~
 ~{&FP1}ImpNaC[5] ~{&FP2}ImpNaC[5] ~{&FP3}~
 ~{&FP1}ImpUsa[5] ~{&FP2}ImpUsa[5] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-ccbdcob
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-ccbdcob
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table  OPEN QUERY {&SELF-NAME} FOR EACH T-ccbdcob NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table T-ccbdcob
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-ccbdcob


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
      T-ccbdcob SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-ccbdcob.CodCli     COLUMN-LABEL  "Codigo "
      T-ccbdcob.Nomcli     COLUMN-LABEL "Nombre!Razon Social " FORMAT "x(35)"
      T-ccbdcob.ImpNaC[1]  COLUMN-LABEL "Efectivo!Soles  "
      T-ccbdcob.ImpUsa[1]  COLUMN-LABEL "Efectivo!Dolares"
      T-ccbdcob.ImpNaC[2]  COLUMN-LABEL "Cheques !Soles  "
      T-ccbdcob.ImpUsa[2]  COLUMN-LABEL "Cheques !Dolares"
      T-ccbdcob.ImpNaC[5]  COLUMN-LABEL "Deposito!Soles  "
      T-ccbdcob.ImpUsa[5]  COLUMN-LABEL "Deposito!Dolares"
  ENABLE
      T-ccbdcob.Codcli
      T-ccbdcob.Nomcli
      T-ccbdcob.ImpNaC[1]  
      T-ccbdcob.ImpUsa[1]  
      T-ccbdcob.ImpNaC[2]  
      T-ccbdcob.ImpUsa[2]  
      T-ccbdcob.ImpNaC[5]  
      T-ccbdcob.ImpUsa[5]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 6.54
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
         HEIGHT             = 6.73
         WIDTH              = 66.
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
     _START_FREEFORM
 OPEN QUERY {&SELF-NAME} FOR EACH T-ccbdcob NO-LOCK.
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

ON "RETURN":U OF T-ccbdcob.Codcli, T-ccbdcob.Nomcli, T-ccbdcob.ImpNaC[1], T-ccbdcob.ImpUsa[1], T-ccbdcob.ImpNaC[2], T-ccbdcob.ImpUsa[2], T-ccbdcob.ImpNaC[5], T-ccbdcob.ImpUsa[5]
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON LEAVE OF T-ccbdcob.Codcli
DO:
    T-ccbdcob.Codcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = CAPS(SELF:SCREEN-VALUE).
    FIND Gn-clie WHERE Gn-clie.Codcia = 0 AND
                       Gn-clie.CodCli =  T-ccbdcob.Codcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-clie THEN DO:
       MESSAGE "Codigo de Cliente No existe" SKIP
               "Verifique ............." VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.            
    END.          
    T-ccbdcob.nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = GN-clie.Nomcli.
                    
END.

ON LEAVE OF T-ccbdcob.Nomcli
DO:


/*
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    T-ccbdcob.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = t-ccbdcob.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
        ccbcdocu.nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE ccbcdocu
    THEN DO: ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.fchdoc)
            ccbcdocu.fchvto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.fchvto)
            t-ccbdcob.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = (IF ccbcdocu.codmon = 1
                                                                       THEN "S/." 
                                                                       ELSE "US$")
            ccbcdocu.sdoact:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.sdoact)
            t-ccbdcob.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.sdoact).
            Release CcbcDocu.
    END.        
    ELSE DO : ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            ccbcdocu.fchvto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            t-ccbdcob.coddoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            ccbcdocu.sdoact:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            t-ccbdcob.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".
            Release CcbcDocu.
            MESSAGE "El documento de referencia no es un documento por cobrar" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.            
    END.        
*/
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
  ASSIGN T-ccbdcob.CodCia = S-CODCIA.
        /* T-ccbdcob.codcob = S-coddoc.*/
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
/*
    CASE HANDLE-CAMPO:name:
        WHEN "CodRef" THEN 
            ASSIGN
                input-var-1 = "CARGO"
                input-var-2 = ""
                input-var-3 = "".
        WHEN "NroRef" THEN 
            ASSIGN
                input-var-1 = t-ccbdcob.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                input-var-2 = s-codcli
                input-var-3 = "P".
    END CASE.
*/

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
  {src/adm/template/snd-list.i "T-ccbdcob"}

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
  /*
  L-CODREF = t-ccbdcob.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  L-NROREF = t-ccbdcob.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  FIND facdocum WHERE FacDocum.CodCia = s-codcia AND
       FacDocum.CodDoc = L-CODREF  NO-LOCK NO-ERROR.
  IF NOT AVAILABLE facdocum OR NOT FacDocum.TpoDoc THEN DO:
     MESSAGE "El documento de referencia no es un documento por cobrar" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.codref.
     RETURN "ADM-ERROR".
  END.
  FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
       ccbcdocu.coddoc = L-CODREF AND
       ccbcdocu.nrodoc = L-NROREF NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbcdocu THEN DO:
     MESSAGE "Documento de referencia no registrado" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.nroref.
     RETURN "ADM-ERROR".
  END.
  IF ccbcdocu.codcli NE s-codcli  THEN DO:
     MESSAGE "Este documento no pertenece al cliente" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.nroref.
     RETURN "ADM-ERROR".
  END.
  IF ccbcdocu.flgest NE "P" THEN DO:
     MESSAGE "El documento de referencia no esta pendiente de pago" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.nroref.
     RETURN "ADM-ERROR".
  END.
  IF DECIMAL(t-ccbdcob.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > ccbcdocu.sdoact THEN DO:
     MESSAGE "El importe a pagar es mayor que la deuda" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.imptot.
     RETURN "ADM-ERROR".
  END.
  FIND DCAJA WHERE DCaja.CodCia = S-CODCIA AND
         DCaja.CodCli = S-CodCli AND
         DCaja.codref = L-CODREF AND 
         DCaja.nroref = L-NROREF NO-LOCK NO-ERROR.
  IF AVAILABLE DCAJA AND ROWID(DCAJA) <> ROWID(t-ccbdcob) THEN DO:
     MESSAGE "Documento repetido" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcob.nroref.
     RETURN "ADM-ERROR".
  END.
 */       
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
IF NOT AVAILABLE T-ccbdcob THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


