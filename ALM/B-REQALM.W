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

/* Shared Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM AS CHAR.
DEFINE SHARED TEMP-TABLE DREQ LIKE LG-DRequ.
DEFINE BUFFER REQU FOR DREQ.

/* Local Variable Definitions ---                                       */
DEFINE VAR TipoBien AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR I-NROITM AS INTEGER NO-UNDO.

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
&Scoped-define INTERNAL-TABLES DREQ Almmmate Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DREQ.Codmat Almmmate.DesMat Almmmatg.DesMar DREQ.UndCmp Almmmate.StkAct DREQ.CanPedi   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DREQ.Codmat ~
DREQ.CanPedi   
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}Codmat ~{&FP2}Codmat ~{&FP3}~
 ~{&FP1}CanPedi ~{&FP2}CanPedi ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DREQ
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DREQ
&Scoped-define SELF-NAME br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH DREQ NO-LOCK, ~
             FIRST Almmmate WHERE Almmmate.CodCia = DREQ.CodCia                       AND  Almmmate.CodAlm = S-CODALM                       AND  Almmmate.CodMat = DREQ.CodMat NO-LOCK, ~
             FIRST Almmmatg OF Almmmate NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table DREQ Almmmate Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DREQ


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
      DREQ, 
      Almmmate, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      DREQ.Codmat
      Almmmate.DesMat FORMAT "X(40)"
      Almmmatg.DesMar FORMAT "X(20)"
      DREQ.UndCmp COLUMN-LABEL "Unidad" FORMAT "X(5)"
      Almmmate.StkAct COLUMN-LABEL "Stock Actual" FORMAT "->,>>>,>>9.99"
      DREQ.CanPedi
  ENABLE
      DREQ.Codmat
      DREQ.CanPedi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 64.29 BY 9.12
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
         HEIGHT             = 9.12
         WIDTH              = 65.72.
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
OPEN QUERY {&SELF-NAME} FOR EACH DREQ NO-LOCK,
      FIRST Almmmate WHERE Almmmate.CodCia = DREQ.CodCia
                      AND  Almmmate.CodAlm = S-CODALM
                      AND  Almmmate.CodMat = DREQ.CodMat NO-LOCK,
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


ON "RETURN":U OF DREQ.Codmat,DREQ.CanPedi
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "MOUSE-SELECT-DBLCLICK":U OF DREQ.Codmat
DO:
    input-var-1 = S-CODALM.
    input-var-2 = DREQ.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    FIND Almtfami WHERE Almtfami.codcia = S-CODCIA AND
         Almtfami.codfam = input-var-2  NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtfami THEN input-var-2 = ''.
    RUN lkup\c-artalm.r ('Articulos por Almacen').
    IF output-var-1 <> ? THEN
       DREQ.Codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = output-var-2.
END.

ON "LEAVE":U OF DREQ.Codmat
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo de Articulo No Existe" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ Almmmate.DesMat 
          Almmmatg.DesMar @ Almmmatg.DesMar
          Almmmatg.UndStk @ DREQ.UndCmp WITH BROWSE {&BROWSE-NAME}.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
           Almmmate.CodAlm = S-CODALM AND
           Almmmate.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
     MESSAGE "Codigo de Articulo no Esta Asignado al Almacen " S-CODALM VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmate.StkAct @ Almmmate.StkAct  WITH BROWSE {&BROWSE-NAME}.
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
  Notes: Asigna articulos a la requisicion y verifica que no se repitan en otra
         requisicion
------------------------------------------------------------------------------*/

  RUN LGC\C-ASIGRE.R ("Asignacion de Articulos").  
  
  FOR EACH DREQ:  
      I-NROITM = 0.
      FOR EACH LG-CRequ NO-LOCK WHERE
               LG-CRequ.CodCia = S-CODCIA AND
               LG-CRequ.Solicita = S-CODALM AND
               LG-CRequ.FlgSit = "S" AND
               LG-CRequ.FchVto >= TODAY:
          FIND LG-DRequ WHERE 
               LG-DRequ.CodCia = LG-CRequ.CodCia AND
               LG-DRequ.NroSer = LG-CRequ.NroSer AND
               LG-DRequ.NroReq = LG-CRequ.NroReq AND
               LG-DRequ.CodMat = DREQ.CodMat NO-LOCK NO-ERROR.
          IF AVAILABLE LG-DRequ AND LG-DRequ.NroReq <> DREQ.NroReq THEN DO:
             I-NROITM = 1.
             LEAVE.
          END.
      END.
      IF I-NROITM = 1 THEN DELETE DREQ.
  END.
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
  
  ASSIGN DREQ.CodCia = S-CODCIA
         DREQ.TpoBien = TipoBien.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
       Almmmatg.CodMat = DREQ.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN ASSIGN DREQ.UndCmp = Almmmatg.UndStk.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Requisicion-Automatica B-table-Win 
PROCEDURE Requisicion-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Generamos la Requisicion automatica para lor articulos con stock actual
         menor al stock minimo.      
------------------------------------------------------------------------------*/
  /*FIND FIRST DREQ NO-LOCK NO-ERROR.
  IF AVAILABLE DREQ THEN DO:
     MESSAGE "Existen pedidos no se puede asignar" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.*/
  FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = S-CODCIA AND
           Almmmate.CodAlm = S-CODALM AND 
           Almmmate.StkAct < Almmmate.StkMin:
      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.
      FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia AND
           Almmmatg.codmat = Almmmate.codmat NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
         FIND FIRST almautmv WHERE 
              almautmv.CodCia = Almmmatg.codcia AND
              almautmv.CodFam = Almmmatg.codfam AND
              almautmv.CodMar = Almmmatg.codMar AND
              almautmv.Almsol = Almmmate.CodAlm NO-LOCK NO-ERROR.
         IF AVAILABLE almautmv AND almautmv.Almdes = "" THEN DO:
            FIND FIRST DREQ WHERE 
                 DREQ.CodCia = Almmmate.CodCia AND
                 DREQ.codmat = Almmmate.codmat NO-ERROR.
            IF NOT AVAILABLE DREQ THEN DO:
               RUN Verifica-Requisiciones-Pendientes.
               IF I-NROITM = 0 THEN DO:
                  CREATE DREQ.
                  ASSIGN DREQ.CodCia = Almmmate.CodCia
                         DREQ.codmat = Almmmate.codmat
                         DREQ.TpoBien = TipoBien
                         DREQ.CanPedi = (Almmmate.StkMax - Almmmate.StkAct)
                         DREQ.UndCmp = Almmmatg.UndStk.
               END.
            END.
         END.
      END.   
  END.
  HIDE FRAME F-PROCESO.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  
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
  {src/adm/template/snd-list.i "DREQ"}
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
IF INTEGER(DREQ.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
   MESSAGE "Codigo de articulo en blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".   
END.

IF DECIMAL(DREQ.CanPedi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0 THEN DO:
   MESSAGE "Cantidad debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".   
END.

FIND REQU WHERE REQU.Codcia  = S-CODCIA AND
     REQU.CodMat = DREQ.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF AVAILABLE REQU AND ROWID(REQU) <> ROWID(DREQ) THEN DO:
   MESSAGE "Articulo repetido" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END. 

FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
     Almmmatg.codmat = DREQ.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
   MESSAGE "Codigo de Articulo no existe" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.
I-NROITM = 0.
FOR EACH LG-CRequ NO-LOCK WHERE
         LG-CRequ.CodCia = S-CODCIA AND
         LG-CRequ.Solicita = S-CODALM AND
         LG-CRequ.FlgSit = "S" AND
         LG-CRequ.FchVto >= TODAY:
    FIND LG-DRequ WHERE 
         LG-DRequ.CodCia = LG-CRequ.CodCia AND
         LG-DRequ.NroSer = LG-CRequ.NroSer AND
         LG-DRequ.NroReq = LG-CRequ.NroReq AND
         LG-DRequ.CodMat = DREQ.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
         NO-LOCK NO-ERROR.
    IF AVAILABLE LG-DRequ THEN DO:
       IF NOT AVAILABLE DREQ OR LG-DRequ.NroReq <> DREQ.NroReq THEN DO:
          I-NROITM = 1.
          MESSAGE "Articulo solicitado en la" SKIP
                  "Requisicion No. : " LG-DRequ.NroSer "-" LG-DRequ.NroReq SKIP
                  "y llegara antes de : " STRING(LG-CRequ.FchVto,"99/99/9999") VIEW-AS ALERT-BOX ERROR.
          LEAVE.
       END.
    END.
END.
IF I-NROITM = 1 THEN DO:
   RETURN "ADM-ERROR".   
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Requisiciones-Pendientes B-table-Win 
PROCEDURE Verifica-Requisiciones-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: verificamos si el articulo ya fue solicitado en otra requisicion      
------------------------------------------------------------------------------*/
I-NROITM = 0.
FOR EACH LG-CRequ NO-LOCK WHERE
         LG-CRequ.CodCia = Almmmate.CodCia AND
         LG-CRequ.Solicita = Almmmate.CodAlm AND
         LG-CRequ.FlgSit = "S" AND
         LG-CRequ.FchVto >= TODAY:
    FIND LG-DRequ WHERE 
         LG-DRequ.CodCia = LG-CRequ.CodCia AND
         LG-DRequ.NroSer = LG-CRequ.NroSer AND
         LG-DRequ.NroReq = LG-CRequ.NroReq AND
         LG-DRequ.CodMat = Almmmate.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE LG-DRequ THEN DO:
       I-NROITM = 1.
       LEAVE.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


