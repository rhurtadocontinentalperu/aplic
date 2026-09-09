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

/* Shared Variable Definitions --- */
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODCIA  AS INTEGER. 
DEFINE SHARED VAR S-CODDOC  AS CHAR. 
DEFINE SHARED VAR S-CODDIV  AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-CODMOV  AS INTEGER. 
DEFINE SHARED TEMP-TABLE DETA LIKE CcbDDocu.

/* Local Variable Definitions --- */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE F-Equivale AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-Unidad   AS CHAR NO-UNDO.
DEFINE VARIABLE S-UndStk   AS CHAR NO-UNDO.
DEFINE VARIABLE S-CODART   AS CHAR NO-UNDO.

DEFINE BUFFER B-DETA       FOR  DETA.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DETA Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DETA.codmat Almmmatg.DesMat Almmmatg.DesMar DETA.UndVta DETA.CanDes   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DETA.CanDes   
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DETA
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DETA
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH DETA WHERE ~{&KEY-PHRASE} NO-LOCK, ~
             EACH Almmmatg OF DETA NO-LOCK BY DETA.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DETA WHERE ~{&KEY-PHRASE} NO-LOCK, ~
             EACH Almmmatg OF DETA NO-LOCK BY DETA.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table DETA Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DETA
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-Total 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Total 

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
DEFINE VARIABLE FILL-IN-Total AS DECIMAL FORMAT "-ZZ,ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Total" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 2 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DETA, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DETA.codmat COLUMN-LABEL "Articulo  ."
      Almmmatg.DesMat FORMAT "X(48)" COLUMN-LABEL "Descripcion"
      Almmmatg.DesMar FORMAT "X(16)" COLUMN-LABEL "Marca"
      DETA.UndVta COLUMN-LABEL "Unidad"
      DETA.CanDes FORMAT "ZZZ,ZZZ,ZZ9.9999"
  ENABLE
      DETA.CanDes
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 76.43 BY 7.42
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Total AT ROW 8.5 COL 32.14 COLON-ALIGNED
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
         HEIGHT             = 8.38
         WIDTH              = 76.43.
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
OPEN QUERY {&SELF-NAME} FOR EACH DETA WHERE ~{&KEY-PHRASE} NO-LOCK,
      EACH Almmmatg OF DETA NO-LOCK BY DETA.NroItm.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
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


/* ***************************  DEFINICION DE TRIGGER  *************************** */
ON "RETURN":U OF DETA.CanDes DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
ON "LEAVE":U OF DETA.Candes DO:
   FIND Almmmatg WHERE Almmmatg.codcia = s-codcia 
                  AND  Almmmatg.codmat = DETA.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                 NO-LOCK NO-ERROR.
/*   IF AVAILABLE Almmmatg THEN
 *       DISPLAY 
 *          Almmmatg.Pesmat * DECIMAL(DETA.Candes:SCREEN-VALUE) * F-Equivale
 *          @ DETA.Pesmat  WITH BROWSE {&BROWSE-NAME}.*/
END.

/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
0&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Desmarcar-Items B-table-Win 
PROCEDURE Desmarcar-Items :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Items B-table-Win 
PROCEDURE Eliminar-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE I AS INTEGER NO-UNDO.
output-var-2 = "".
&IF DEFINED (FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}) > 0 &THEN
DO:
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
   MESSAGE "No existen registros seleccionados" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
DO I = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
   IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(I) THEN DO:
     DELETE {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.      
   END.
  
END.
END.
&ENDIF
RUN dispatch IN THIS-PROCEDURE ('open-query':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total B-table-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FILL-IN-Total  = 0.
FOR EACH B-DETA NO-LOCK:
    FILL-IN-Total  = FILL-IN-Total + B-DETA.ImpLin.
END.
DISPLAY FILL-IN-Total WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RETURN "ADM-ERROR".
  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-DETA:
      N-ITMS = N-ITMS + 1.
  END.
  IF (N-ITMS + 1) > FacCfgGn.Items_Guias THEN DO:
     MESSAGE "El numero de items no puede ser mayor a "  FacCfgGn.Items_Guias 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN DETA.Factor = F-Equivale
         DETA.CodCia = S-CODCIA.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.codmat = DETA.codmat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
     ASSIGN DETA.Pesmat = Almmmatg.Pesmat * DETA.Candes * DETA.Factor
           /*
            DETA.ImpDto = ROUND( DETA.PreUni * (DETA.PorDto / 100) * DETA.CanDes , 2 )
            DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 )  - DETA.ImpDto.
           */ 
            DETA.ImpDto = ROUND( DETA.PreBas * (DETA.PorDto / 100) * DETA.CanDes , 2 )
            DETA.ImpLin = ROUND( DETA.PreUni * DETA.CanDes , 2 ) /* - DETA.ImpDto*/.

     IF DETA.AftIsc THEN 
        DETA.ImpIsc = ROUND(DETA.PreBas * DETA.CanDes * Almmmatg.PorIsc / 100,2).
     IF DETA.AftIgv THEN 
        DETA.ImpIgv = DETA.ImpLin - ROUND(DETA.ImpLin / (1 + (FacCfgGn.PorIgv / 100)),4).
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

  /* Dispatch standard ADM method.  */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Importe-Total.
  
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
  
  RUN Importe-Total.

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
  
  RUN Importe-Total.
  
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
        WHEN "CodMat" THEN ASSIGN input-var-1 = S-CodAlm.
        WHEN "CodUnd" THEN ASSIGN input-var-1 = S-UndStk.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Seleccionar-Items B-table-Win 
PROCEDURE Seleccionar-Items :
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
  {src/adm/template/snd-list.i "DETA"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
IF DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".   
END.
IF INTEGER(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO DETA.CanDes.
   RETURN "ADM-ERROR".   
END.
/* usamos candev para controlar lo maximo que podemos despachar segun el saldo del pedido */
IF INTEGER(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > DETA.CanDev THEN DO:
   MESSAGE "Cantidad no debe ser mayor a " DETA.CanDev VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO DETA.CanDes.
   RETURN "ADM-ERROR".   
END.
FIND B-DETA WHERE B-DETA.Codcia  = S-CODCIA AND
     B-DETA.CodMat = DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE B-DETA AND ROWID(B-DETA) <> ROWID(DETA) THEN DO:
   MESSAGE "Codigo ya esta registrado" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO DETA.CanDes.
   RETURN "ADM-ERROR".   
END. 
FIND Almmmate WHERE Almmmate.CodCia = S-CodCia AND
     Almmmate.CodAlm = S-CodAlm AND
     Almmmate.CodMat = DETA.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate OR (Almmmate.StkAct - INTEGER(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) ) < 0 THEN DO:
   MESSAGE "No hay Stock en almacen " S-CodAlm VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY":U TO DETA.CanDes.
   RETURN "ADM-ERROR".   
END.
   
FIND Almtconv WHERE 
     Almtconv.CodUnid  = Almmmatg.UndBas AND  
     Almtconv.Codalter = DETA.Undvta 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
   APPLY "ENTRY":U TO DETA.CanDes.
   RETURN "ADM-ERROR".   
END.

IF Almtconv.Multiplos <> 0 THEN DO:
       IF DEC(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
          INT(DEC(DETA.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) THEN DO:
          MESSAGE " La Cantidad debe de ser un, " SKIP
                  " multiplo de : " Almtconv.Multiplos
                  VIEW-AS ALERT-BOX WARNING.
         APPLY "ENTRY":U TO DETA.CanDes.
         RETURN "ADM-ERROR".   
       END.
END.




RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-UpDate B-table-Win 
PROCEDURE Valida-UpDate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE DETA THEN RETURN "ADM-ERROR".
ASSIGN F-Equivale = DETA.Factor.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

