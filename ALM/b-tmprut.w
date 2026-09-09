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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.
DEFINE VARIABLE L-NROREF AS CHAR.
DEFINE VARIABLE L-CODREF AS CHAR.

DEFINE SHARED TEMP-TABLE T-Rutad LIKE DI-RutaD.

DEFINE BUFFER B-Rutad FOR T-Rutad.

DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.

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
&Scoped-define INTERNAL-TABLES T-Rutad CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-Rutad.CodRef T-Rutad.NroRef T-Rutad.FlgEst T-Rutad.MonCob T-Rutad.ImpCob T-Rutad.HorAte T-Rutad.Glosa CcbCDocu.FchDoc CcbCDocu.FchVto CcbCDocu.Nomcli   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-Rutad.CodRef ~
T-Rutad.NroRef ~
T-Rutad.FlgEst ~
T-Rutad.MonCob ~
T-Rutad.ImpCob ~
T-Rutad.HorAte ~
T-Rutad.Glosa   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodRef ~{&FP2}CodRef ~{&FP3}~
 ~{&FP1}NroRef ~{&FP2}NroRef ~{&FP3}~
 ~{&FP1}FlgEst ~{&FP2}FlgEst ~{&FP3}~
 ~{&FP1}MonCob ~{&FP2}MonCob ~{&FP3}~
 ~{&FP1}ImpCob ~{&FP2}ImpCob ~{&FP3}~
 ~{&FP1}HorAte ~{&FP2}HorAte ~{&FP3}~
 ~{&FP1}Glosa ~{&FP2}Glosa ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-Rutad
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-Rutad
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-Rutad  NO-LOCK, ~
            FIRST CcbCDocu WHERE CcbCDocu.Codcia = T-Rutad.Codcia AND                           CcbCDocu.Coddoc = T-Rutad.CodRef AND                           CcbCDocu.Nrodoc = T-Rutad.NroRef                           NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table T-Rutad CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-Rutad


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
      T-Rutad, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-Rutad.CodRef COLUMN-LABEL  "Tipo  "
      T-Rutad.NroRef COLUMN-LABEL "Documento " FORMAT "x(10)"
      T-Rutad.FlgEst COLUMN-LABEL "Estado"
      T-Rutad.MonCob COLUMN-LABEL "Moneda!Cobranza"
      T-Rutad.ImpCob COLUMN-LABEL "Importe!Cobrado" FORMAT "->>>,>>9.99"
      T-Rutad.HorAte COLUMN-LABEL "Hora!LLegada"
      T-Rutad.Glosa  COLUMN-lABEL "Observaciones"
      CcbCDocu.FchDoc   COLUMN-LABEL "    Fecha    !    Emisión    "
      CcbCDocu.FchVto   COLUMN-LABEL "    Fecha    ! Vencimiento"
      CcbCDocu.Nomcli   COLUMN-LABEL "Nombre o Razon Social" FORMAT "x(50)"
  ENABLE
      T-Rutad.CodRef
      T-Rutad.NroRef
      T-Rutad.FlgEst
      T-Rutad.MonCob
      T-Rutad.ImpCob
      T-Rutad.HorAte
      T-Rutad.Glosa
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78.57 BY 6.69
         BGCOLOR 15 FONT 4.


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
         HEIGHT             = 6.85
         WIDTH              = 79.14.
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
OPEN QUERY {&SELF-NAME} FOR EACH T-Rutad  NO-LOCK,
     FIRST CcbCDocu WHERE CcbCDocu.Codcia = T-Rutad.Codcia AND
                          CcbCDocu.Coddoc = T-Rutad.CodRef AND
                          CcbCDocu.Nrodoc = T-Rutad.NroRef
                          NO-LOCK.
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


ON "RETURN":U OF T-Rutad.CodRef, T-Rutad.NroRef, T-Rutad.FlgEst,T-Rutad.MonCob,T-Rutad.ImpCob,T-Rutad.HorAte,T-Rutad.Glosa
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON LEAVE OF T-Rutad.CodRef
DO:
    T-Rutad.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = CAPS(SELF:SCREEN-VALUE).
END.

ON LEAVE OF T-Rutad.NroRef
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN .
    T-Rutad.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = SELF:SCREEN-VALUE.
    FIND B-Rutad WHERE B-Rutad.Codref = T-Rutad.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                       B-Rutad.NroRef = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE B-rutad THEN DO:
       MESSAGE "El documento de referencia ya esta registrado" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.            

    END.                   

    FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
        ccbcdocu.coddoc = T-Rutad.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
        ccbcdocu.nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    
    IF AVAILABLE ccbcdocu
    THEN DO: ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.fchdoc)
            ccbcdocu.fchvto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.fchvto)
            ccbcdocu.Nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(ccbcdocu.Nomcli).
            Release CcbcDocu.
    END.        
    ELSE DO : ASSIGN
            ccbcdocu.fchdoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            ccbcdocu.fchvto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ""
            ccbcdocu.nomcli:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "".
            Release CcbcDocu.
            MESSAGE "El documento de referencia no existe" VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.            
    END.        
    IF L-CREA THEN DO:
       DISPLAY "E" @ T-Rutad.FlgEst 
         WITH BROWSE {&BROWSE-NAME}.

    END.
        
END.
ON LEAVE OF T-Rutad.Flgest
DO:

    IF SELF:SCREEN-VALUE = "" THEN RETURN .
    
    IF LOOKUP(T-Rutad.FlgEst:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},"E,D,P") = 0 THEN DO:
       MESSAGE "Tipo de Estado Incorrecto" SKIP
               " E : Enviado   " SKIP
               " D : Devuelto  " SKIP
               " P : Pendiente "
               VIEW-AS ALERT-BOX ERROR.
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
  ASSIGN T-Rutad.CodCia = S-CODCIA
         T-Rutad.CodDiv = S-CODDIV
         T-Rutad.codref = L-CODREF
         T-Rutad.nroref = L-NROREF
         T-Rutad.FlgEst = T-Rutad.FlgEst:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         T-Rutad.Glosa  = T-Rutad.Glosa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
         T-Rutad.HorAte = T-Rutad.HorAte:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.

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
  {src/adm/template/snd-list.i "T-Rutad"}
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
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida B-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* consistencia del documento */
  L-CODREF = t-rutad.codref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  L-NROREF = t-rutad.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
       ccbcdocu.coddoc = L-CODREF AND
       ccbcdocu.nrodoc = L-NROREF NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbcdocu THEN DO:
     MESSAGE "Documento de referencia no registrado" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO T-Rutad.nroref.
     RETURN "ADM-ERROR".
  END.
/*
  IF ccbcdocu.flgest NE "P" THEN DO:
     MESSAGE "El documento de referencia no esta pendiente de pago" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-ccbdcaja.nroref.
     RETURN "ADM-ERROR".
  END.
*/

/*
  FIND B-Rutad WHERE B-Rutad.CodCia = S-CODCIA AND
         B-Rutad.codref = L-CODREF AND 
         B-Rutad.nroref = L-NROREF NO-LOCK NO-ERROR.
  IF AVAILABLE B-Rutad THEN DO:
     MESSAGE "Documento repetido" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO t-Rutad.nroref.
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE T-Rutad THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


