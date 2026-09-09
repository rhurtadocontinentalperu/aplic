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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED TEMP-TABLE DREP LIKE Almdrequ.
DEFINE BUFFER REQU FOR DREP.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE BUFFER B-Almmmate FOR Almmmate.
DEFINE SHARED VARIABLE C-CODALM  AS CHAR.
DEFINE SHARED VARIABLE ORDTRB    AS CHAR.


DEFINE STREAM Reporte.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE VAR stkdes LIKE Almmmate.StkAct.
DEFINE VAR SW AS LOGICAL.
DEF VAR S-CANREQ AS DECI INIT 0.

DEFINE BUFFER B-DREP FOR DREP.
def buffer b-almcrequ for almcrequ.
def buffer b-almdrequ for almdrequ.

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
&Scoped-define INTERNAL-TABLES DREP Almmmate Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DREP.codmat Almmmate.desmat Almmmatg.DesMar Almmmate.UndVta Almmmate.StkAct stkdes DREP.CanReq   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DREP.codmat ~
DREP.CanReq   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}codmat ~{&FP2}codmat ~{&FP3}~
 ~{&FP1}CanReq ~{&FP2}CanReq ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DREP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DREP
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DREP NO-LOCK, ~
             FIRST Almmmate OF DREP NO-LOCK, ~
             FIRST Almmmatg OF Almmmate NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table DREP Almmmate Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DREP


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
      DREP, 
      Almmmate, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DREP.codmat       COLUMN-LABEL "Codigo!Articulo"
      Almmmate.desmat   COLUMN-LABEL "Descripcion" FORMAT "X(40)"
      Almmmatg.DesMar   COLUMN-LABEL "Marca" FORMAT "X(15)"
      Almmmate.UndVta   COLUMN-LABEL "Unidad"
      Almmmate.StkAct   FORMAT "(Z,ZZZ,ZZ9.99)"
      stkdes            COLUMN-LABEL "Stock!Despacho" FORMAT "(Z,ZZZ,ZZ9.99)"
      DREP.CanReq       FORMAT ">,>>>,>>9.99"  
  ENABLE
      DREP.codmat
      DREP.CanReq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 67.29 BY 9.08
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.08
         WIDTH              = 67.29.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 2.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH DREP NO-LOCK,
      FIRST Almmmate OF DREP NO-LOCK,
      FIRST Almmmatg OF Almmmate NO-LOCK.
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


ON "RETURN":U OF DREP.Codmat,DREP.CanReq
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
ON "MOUSE-SELECT-DBLCLICK":U OF DREP.Codmat
DO:
    input-var-1 = S-CODALM.
    input-var-2 = DREP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA 
                   AND  Almtfami.codfam = input-var-2  
                  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-artalm.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       DREP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.
ON "LEAVE":U OF DREP.Codmat
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                 AND  Almmmate.codmat = SELF:SCREEN-VALUE 
                 AND  Almmmate.CodAlm = S-CODALM 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
     MESSAGE "Codigo de Articulo no Asignado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia 
                 AND  Almmmatg.codmat = Almmmate.codmat 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.

  /**** Busca el stock del almacen despacho  ****/
  stkdes = 0.
  SW = TRUE.
 /*
  SW = FALSE.
  IF S-CODALM = "11" OR S-CODALM = "83" THEN DO:
    IF S-CODALM = "11" AND C-CODALM = "83" THEN SW = TRUE. 
    ELSE 
    IF S-CODALM = "83" AND C-CODALM <> "11" THEN SW = TRUE.
  END.
*/

  IF SW THEN DO:
      FIND B-Almmmate WHERE B-Almmmate.CodCia = S-CODCIA 
                       AND  B-Almmmate.codmat = SELF:SCREEN-VALUE 
                       AND  B-Almmmate.CodAlm = C-CODALM 
                      NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmate THEN stkdes = B-Almmmate.StkAct.
  END.

  IF ORDTRB <> "" THEN DO:
       FIND Almdotrb Where Almdotrb.Codcia = S-CODCIA AND
                           Almdotrb.Coddoc = "O/T"    AND
                           Almdotrb.Nroser = INT(SUbstring(ORDTRB,1,3)) AND
                           Almdotrb.Nrodoc = INT(SUbstring(ORDTRB,4,6)) AND
                           Almdotrb.Codmat = SELF:SCREEN-VALUE  NO-LOCK NO-ERROR.
                      
       IF NOT AVAILABLE Almdotrb OR Almdotrb.Flgtip <> "I" THEN DO:
         MESSAGE "Articulo no Pertenece a Orden de Trabajo" VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
       END.           
  END.
  
  DISPLAY Almmmate.DesMat @ Almmmate.DesMat 
          Almmmatg.DesMar @ Almmmatg.DesMar
          Almmmate.UndVta @ Almmmate.UndVta 
          Almmmate.StkAct @ Almmmate.StkAct 
          stkdes
          WITH BROWSE {&BROWSE-NAME}. 
END.

ON "LEAVE":U OF DREP.CanReq
DO:
 S-CANREQ = 0.
  IF ORDTRB <> "" THEN DO:
       
      IF AVAILABLE Almdotrb THEN DO:
      message "entro".
      FOR EACH b-almcrequ Where b-Almcrequ.Codcia = S-CODCIA AND
                              b-Almcrequ.Nrorf3 = ORDTRB AND
                              b-Almcrequ.FlgEst = "p"
                              :
        message flgest ordtrb DREP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
        
        for each b-Almdrequ of b-Almcrequ Where b-Almdrequ.codmat = DREP.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    
                                :
                               s-canreq = s-canreq + b-Almdrequ.canreq.
        end.
      end.                             
                               
       IF DECI(SELF:SCREEN-VALUE ) > ( Almdotrb.Canped -  Almdotrb.Canate - S-CANREQ ) THEN do:
         MESSAGE "Cantidad Excede lo proyectado por la O/T".
        return no-apply.
         end.
    
  END.   
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos B-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN Alm\C-AsgRep.r("ARTICULOS").
   RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  N-ITMS = 0.
  FOR EACH B-DREP:
      N-ITMS = N-ITMS + 1.
  END.
  IF (N-ITMS + 1) > 16 THEN DO:
     MESSAGE "El Numero de Items No Puede Ser Mayor a " 16 
             VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
    
  APPLY "ENTRY" TO DREP.CodMat IN BROWSE {&BROWSE-NAME}.
  RETURN NO-APPLY.


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
  ASSIGN DREP.CodCia = S-CODCIA
         DREP.CodAlm = S-CODALM.

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
  
  DEFINE VARIABLE S-Tit AS CHAR NO-UNDO.
  DEFINE VAR S-DesSol AS CHAR NO-UNDO.
  DEFINE FRAME F-FMT
         DREP.codmat COLUMN-LABEL "Codigo!Articulo" 
         Almmmatg.DesMat FORMAT "X(60)"
         Almmmatg.DesMar FORMAT "X(19)"
         Almmmatg.UndStk COLUMN-LABEL "Unidad" FORMAT "X(6)"
         DREP.CanReq FORMAT ">>>,>>>,>>9.99" 
         HEADER
         S-NOMCIA FORMAT "X(40)" "PRE-IMPRESION DE SOLICITUD DE REPOSICION" TO 60 SKIP(1)
         "Fecha : " TO 100 TODAY  SKIP(2)
          WITH WIDTH 145 STREAM-IO DOWN.
  OUTPUT STREAM Reporte TO PRINTER PAGED PAGE-SIZE 60.
  PUT STREAM Reporte CONTROL CHR(27) + CHR(67) + CHR(66).
  PUT STREAM Reporte CONTROL CHR(27) + CHR(15).
  FOR EACH DREP:
      FIND Almmmatg WHERE Almmmatg.CodCia = DREP.CodCia AND
           Almmmatg.CodMat = DREP.CodMat NO-LOCK NO-ERROR.
      DISPLAY STREAM Reporte 
                   DREP.codmat 
                   Almmmatg.DesMat 
                   Almmmatg.DesMar 
                   Almmmatg.UndStk 
                   DREP.CanReq WITH FRAME F-FMT.
       DOWN STREAM Reporte WITH FRAME F-FMT.
  END.
  OUTPUT STREAM Reporte CLOSE.


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
        WHEN "CodMat" THEN ASSIGN input-var-1 = S-CODALM.
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
  {src/adm/template/snd-list.i "DREP"}
  {src/adm/template/snd-list.i "Almmmate"}
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
IF DREP.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO DREP.CodMat.
   RETURN "ADM-ERROR".   
END.
IF decimal(DREP.CanReq:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO DREP.CanReq.
   RETURN "ADM-ERROR".   
END.

FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
     Almmmatg.codmat = DREP.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
   MESSAGE "Codigo de Articulo no existe" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

FIND REQU WHERE REQU.Codcia  = S-CODCIA AND
     REQU.CodAlm = S-CODALM AND
     REQU.CodMat = DREP.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE REQU AND ROWID(REQU) <> ROWID(DREP) THEN DO:
   MESSAGE "Codigo ya esta registrado" VIEW-AS ALERT-BOX ERROR.
   APPLY "ENTRY" TO DREP.CodMat.
   RETURN "ADM-ERROR".   
END. 

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


