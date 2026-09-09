&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CcbPenDep NO-UNDO LIKE CcbPenDep
       FIELD CodMon AS INT
       FIELD SdoAct AS DEC.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-Rowid  AS ROWID.
DEF SHARED VAR cb-codcia AS INT.

DEF VAR Moneda AS CHAR FORMAT 'x(3)' LABEL 'Mon'.

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
&Scoped-define INTERNAL-TABLES T-CcbPenDep

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-CcbPenDep.CodDiv T-CcbPenDep.usuario T-CcbPenDep.FchCie T-CcbPenDep.HorCie T-CcbPenDep.ImpNac T-CcbPenDep.ImpUsa T-CcbPenDep.SdoNac T-CcbPenDep.SdoUsa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table   
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH T-CcbPenDep WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH T-CcbPenDep WHERE ~{&KEY-PHRASE} NO-LOCK     ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-CcbPenDep
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CcbPenDep


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table COMBO-BOX-Codigo FILL-IN-Comentario 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Codigo FILL-IN-Comentario 

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
DEFINE VARIABLE COMBO-BOX-Codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sustento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Comentario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comentario" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CcbPenDep SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      T-CcbPenDep.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)"
      T-CcbPenDep.usuario
      T-CcbPenDep.FchCie COLUMN-LABEL "Fecha de!Cierre" FORMAT "99/99/99"
      T-CcbPenDep.HorCie COLUMN-LABEL "Hora de!Cierre"
      T-CcbPenDep.ImpNac COLUMN-LABEL "Importe S/!Sistemas"     FORMAT ">>>,>>9.99"
      T-CcbPenDep.ImpUsa COLUMN-LABEL "Importe US$!Sistemas"    FORMAT ">>>,>>9.99"
      T-CcbPenDep.SdoNac COLUMN-LABEL "Importe S/!Declarado"    FORMAT ">>>,>>9.99"
      T-CcbPenDep.SdoUsa COLUMN-LABEL "Importe US$!Declarado"   FORMAT ">>>,>>9.99"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 64 BY 10.58
         FONT 4
         TITLE "SELECCIONADOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     COMBO-BOX-Codigo AT ROW 11.77 COL 8 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Comentario AT ROW 12.73 COL 8 COLON-ALIGNED WIDGET-ID 4
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
   Temp-Tables and Buffers:
      TABLE: T-CcbPenDep T "?" NO-UNDO INTEGRAL CcbPenDep
      ADDITIONAL-FIELDS:
          FIELD CodMon AS INT
          FIELD SdoAct AS DEC
      END-FIELDS.
   END-TABLES.
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
         HEIGHT             = 15.5
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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
OPEN QUERY {&SELF-NAME} FOR EACH T-CcbPenDep WHERE ~{&KEY-PHRASE} NO-LOCK
    ~{&SORTBY-PHRASE}.
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* SELECCIONADOS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* SELECCIONADOS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* SELECCIONADOS */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Codigo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Codigo IN FRAME F-Main /* Sustento */
DO:
  ASSIGN {&SELF-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Comentario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Comentario B-table-Win
ON LEAVE OF FILL-IN-Comentario IN FRAME F-Main /* Comentario */
DO:
  ASSIGN {&SELF-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aceptar-Deposito B-table-Win 
PROCEDURE Aceptar-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN COMBO-BOX-Codigo FILL-IN-Comentario.

    IF COMBO-BOX-Codigo = "" THEN DO:
        MESSAGE
            "Seleccione el sustento"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO COMBO-BOX-Codigo.
        RETURN 'ADM-ERROR'.
    END.
    MESSAGE
        '¿Está seguro de realizar Operación?' SKIP
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO
        UPDATE X-OK AS LOGICAL.
    IF x-Ok = NO THEN RETURN 'ADM-ERROR'.
    RUN proc_Genera-Deposito.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    RUN dispatch IN THIS-PROCEDURE('open-query':U).
    DISPLAY
        "" @ FILL-IN-Comentario.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Registro B-table-Win 
PROCEDURE Borra-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF AVAILABLE T-CcbPenDep THEN DO:
    DELETE T-CcbPenDep.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND CcbPenDep WHERE ROWID(CcbPenDep) = s-Rowid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbPenDep THEN RETURN.
  
  FIND T-CcbPenDep OF CcbPenDep NO-LOCK NO-ERROR.
  IF NOT AVAILABLE T-CcbPenDep THEN DO:
      CREATE T-CcbPenDep.
      BUFFER-COPY CcbPenDep TO T-CcbPenDep.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Codigo:DELETE(1).
      FOR EACH Ccbtabla WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = "DCC" BY CcbTabla.Codigo DESC:
          COMBO-BOX-Codigo:ADD-LAST(CcbTabla.Nombre,CcbTabla.Codigo).
          COMBO-BOX-Codigo = CcbTabla.Codigo.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_Genera-Deposito B-table-Win 
PROCEDURE proc_Genera-Deposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER b_pen FOR CcbPenDep.
    DEFINE VARIABLE n AS INTEGER NO-UNDO.

    ASSIGN FRAME {&FRAME-NAME}
        COMBO-BOX-Codigo FILL-IN-Comentario.

    FOR EACH T-CcbPenDep TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR' ON ERROR UNDO, RETURN 'ADM-ERROR':
        /* Actualiza Flag T-CcbPenDep */
        FIND FIRST b_pen WHERE b_pen.codcia = T-CcbPenDep.codcia
            AND b_pen.coddiv = T-CcbPenDep.coddiv
            AND b_pen.coddoc = T-CcbPenDep.coddoc
            AND b_pen.nrodoc = T-CcbPenDep.nrodoc
            AND b_pen.codref = T-CcbPenDep.codref
            AND b_pen.nroref = T-CcbPenDep.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN 
            b_pen.FlgEst    = "C"
            b_pen.Libre_c01 = COMBO-BOX-Codigo
            b_pen.Libre_c02 = FILL-IN-Comentario.
        RELEASE b_pen.
        DELETE T-CcbPenDep.
    END.
    RETURN 'OK'.


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
  {src/adm/template/snd-list.i "T-CcbPenDep"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Vales-de-Responsabilidad B-table-Win 
PROCEDURE Vales-de-Responsabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Por cada registro solicitamos información para el vale
------------------------------------------------------------------------------*/

    ASSIGN FRAME {&FRAME-NAME} COMBO-BOX-Codigo FILL-IN-Comentario.

    IF COMBO-BOX-Codigo = "" THEN DO:
        MESSAGE "Seleccione el sustento" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO COMBO-BOX-Codigo.
        RETURN 'ADM-ERROR'.
    END.
    MESSAGE '¿Está seguro de realizar Operación?' SKIP VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE X-OK AS LOGICAL.
    IF x-Ok = NO THEN RETURN 'ADM-ERROR'.

    DEF VAR pOk AS LOGICAL NO-UNDO.
    /* Una transacción por cada registro */
    DEFINE BUFFER b_pen FOR CcbPenDep.
    DEFINE VAR x-SdoNac AS DEC NO-UNDO.
    DEFINE VAR x-SdoUsa AS DEC NO-UNDO.

    FOR EACH T-CcbPenDep EXCLUSIVE-LOCK TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        ASSIGN 
            t-CcbPenDep.Libre_c01 = COMBO-BOX-Codigo
            t-CcbPenDep.Libre_c02 = FILL-IN-Comentario.
        ASSIGN
            x-SdoNac = t-CcbPenDep.SdoNac - t-CcbPenDep.ImpNac
            x-SdoUsa = t-CcbPenDep.SdoUsa - t-CcbPenDep.ImpUsa.
        /* Por cada moneda un vale de responsabilidad */
        CASE TRUE:
            WHEN x-SdoNac < 0 OR x-SdoUsa < 0 THEN DO:
                /* Por cada moneda un vale de responsabilidad */
                IF t-CcbPenDep.SdoNac < t-CcbPenDep.ImpNac THEN DO:
                    RUN ccb/d-valeresp (INPUT TABLE t-CcbPenDep, 
                                        INPUT 1,
                                        OUTPUT pOk).
                    IF pOk = NO THEN UNDO, NEXT.
                END.
                IF t-CcbPenDep.SdoUsa < t-CcbPenDep.ImpUsa THEN DO:
                    RUN ccb/d-valeresp (INPUT TABLE t-CcbPenDep, 
                                        INPUT 2,
                                        OUTPUT pOk).
                    IF pOk = NO THEN UNDO, NEXT.
                END.
            END.
            OTHERWISE NEXT.
        END CASE.
        
        /* Actualiza Flag T-CcbPenDep */
        FIND FIRST b_pen WHERE b_pen.codcia = T-CcbPenDep.codcia
            AND b_pen.coddiv = T-CcbPenDep.coddiv
            AND b_pen.coddoc = T-CcbPenDep.coddoc
            AND b_pen.nrodoc = T-CcbPenDep.nrodoc
            AND b_pen.codref = T-CcbPenDep.codref
            AND b_pen.nroref = T-CcbPenDep.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b_pen THEN UNDO, NEXT.
        
        ASSIGN 
            b_pen.FlgEst    = "C"
            b_pen.Libre_c01 = COMBO-BOX-Codigo
            b_pen.Libre_c02 = FILL-IN-Comentario.
        RELEASE b_pen.
        DELETE T-CcbPenDep.
        
    END.
    RUN dispatch IN THIS-PROCEDURE('open-query':U).
    FILL-IN-Comentario:SCREEN-VALUE = ''.

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

