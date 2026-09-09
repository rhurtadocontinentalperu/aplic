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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.

DEF VAR s-codref AS CHAR INIT 'G/R' NO-UNDO.

DEF VAR x-Tipo LIKE Di-RutaDG.Tipo NO-UNDO.
DEF VAR x-DesTip AS CHAR NO-UNDO.

DEF BUFFER b-rutad FOR di-rutadg.
DEF BUFFER b-rutac FOR di-rutac.

DEF SHARED VAR lh_handle AS HANDLE.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Di-RutaDG

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Di-RutaDG.NroRef Di-RutaDG.HorEst ~
Di-RutaDG.Tipo Di-RutaDG.CodAlm Di-RutaDG.TipDes Di-RutaDG.Glosa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Di-RutaDG.NroRef ~
Di-RutaDG.Tipo 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Di-RutaDG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Di-RutaDG
&Scoped-define QUERY-STRING-br_table FOR EACH Di-RutaDG OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Di-RutaDG OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Di-RutaDG
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Di-RutaDG


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
      Di-RutaDG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Di-RutaDG.NroRef COLUMN-LABEL "Correlativo" FORMAT "X(9)":U
      Di-RutaDG.HorEst COLUMN-LABEL "Hora!Estimada" FORMAT "XX:XX":U
      Di-RutaDG.Tipo FORMAT "!":U
      Di-RutaDG.CodAlm COLUMN-LABEL "Almacén!Origen" FORMAT "x(3)":U
      Di-RutaDG.TipDes FORMAT "x(10)":U
      Di-RutaDG.Glosa COLUMN-LABEL "Descripcion" FORMAT "x(35)":U
  ENABLE
      Di-RutaDG.NroRef
      Di-RutaDG.Tipo HELP "(R) recojo  (E) envío"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 85 BY 6.92
         FONT 2.


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
   External Tables: INTEGRAL.DI-RutaC
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
         HEIGHT             = 7.08
         WIDTH              = 85.86.
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
     _TblList          = "INTEGRAL.Di-RutaDG OF INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > INTEGRAL.Di-RutaDG.NroRef
"Di-RutaDG.NroRef" "Correlativo" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Di-RutaDG.HorEst
"Di-RutaDG.HorEst" "Hora!Estimada" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Di-RutaDG.Tipo
"Di-RutaDG.Tipo" ? "!" "character" ? ? ? ? ? ? yes "(R) recojo  (E) envío" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Di-RutaDG.CodAlm
"Di-RutaDG.CodAlm" "Almacén!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Di-RutaDG.TipDes
     _FldNameList[6]   > INTEGRAL.Di-RutaDG.Glosa
"Di-RutaDG.Glosa" "Descripcion" "x(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME Di-RutaDG.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Di-RutaDG.NroRef br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Di-RutaDG.NroRef IN BROWSE br_table /* Correlativo */
DO:
  ASSIGN
    Di-RutaDG.codalm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    Di-RutaDG.tipdes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    Di-RutaDG.glosa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
    
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = s-codref
    AND Ccbcdocu.nrodoc = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdocu 
  THEN ASSIGN
        Di-RutaDG.codalm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Ccbcdocu.codalm
        Di-RutaDG.tipdes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Ccbcdocu.codant
        Di-RutaDG.glosa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = Ccbcdocu.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF Di-RutaDG.HorEst, Di-RutaDG.NroRef DO:
    APPLY 'TAB'.
    RETURN NO-APPLY.
END.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    IF hColumn:NAME = 'Tipo' OR hColumn:NAME = 'NroRef' THEN hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP (di-rutac.flgest, 'C,A') > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR". 
  END.
  IF DI-RutaC.Libre_l01 = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

/*   IF LOOKUP (di-rutac.flgest, 'P,C,A') > 0 THEN DO:      */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN "ADM-ERROR".                                */
/*   END.                                                   */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('disable-header').

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

  ASSIGN 
    Di-RutaDG.CodCia = Di-RutaC.CodCia
    Di-RutaDG.CodDiv = Di-RutaC.CodDiv
    Di-RutaDG.CodDoc = Di-RutaC.CodDoc
    Di-RutaDG.NroDoc = Di-RutaC.NroDoc
    Di-RutaDG.CodRef = s-codref
    Di-RutaDG.CodAlm = Ccbcdocu.CodAlm
    Di-RutaDG.TipDes = Ccbcdocu.CodAnt
    Di-RutaDG.CodDes = Ccbcdocu.CodCli
    Di-RutaDG.Glosa  = Ccbcdocu.NomCli.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('enable-header').

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
  IF LOOKUP (di-rutac.flgest, 'C,A') > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR". 
  END.
  IF DI-RutaC.Libre_l01 = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

/*   {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""} */

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
  RUN Procesa-Handle IN lh_handle ('enable-header').

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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "Di-RutaDG"}

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
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = s-codref
    AND Ccbcdocu.nrodoc = Di-RutaDG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND Ccbcdocu.tpofac = 'I'
    AND Ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu
  THEN DO:
    MESSAGE 'Guia Itinenrante no encontrada'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
/*   IF Di-RutaDG.HorEst:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''                     */
/*         OR Di-RutaDG.HorEst:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '  :  ' THEN DO: */
/*     MESSAGE 'Debe ingresar la hora estimada' VIEW-AS ALERT-BOX ERROR.                */
/*     APPLY 'ENTRY':U TO Di-RutaDG.HorEst IN BROWSE {&BROWSE-NAME}.                    */
/*     RETURN 'ADM-ERROR'.                                                              */
/*   END.                                                                               */

  IF di-rutac.flgest = "C" THEN DO:
    MESSAGE "Hoja de Ruta esta CERRADA" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.

  IF LOOKUP(Di-RutaDG.Tipo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, 'R,E') = 0 THEN DO:
    MESSAGE 'Debe ingresar lo siguiente:' SKIP
            '(R) si es recojo' SKIP
            '(E) si es envío' 
            VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO Di-RutaDG.Tipo IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
  END.
  
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      IF CAN-FIND(FIRST DI-RutaDG OF DI-RutaC WHERE DI-RutaDG.nroref = DI-RutaDG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK)
      THEN DO:
        MESSAGE "El documento" DI-RutaDG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "ya fue registrado en esta hoja de ruta" VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
      END.
      /* consistencia en otros documentos */
      FOR EACH b-rutad NO-LOCK WHERE b-rutad.codcia = s-codcia
          AND b-rutad.coddoc = s-coddoc
          AND b-rutad.nroref = DI-RutaDG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
          FIRST b-rutac OF b-rutad NO-LOCK:
          IF b-rutac.flgest = "E" OR b-rutac.flgest = "P" THEN DO:
              MESSAGE "Documento ya se encuentra registrado en la H.R.:" b-rutac.nrodoc
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
          IF b-rutac.flgest = "C"  AND b-rutad.flgest = "C" THEN DO:
              MESSAGE "Documento ya se encuentra registrado en la H.R.:" b-rutac.nrodoc
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
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

  IF LOOKUP (di-rutac.flgest, 'C,A') > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR". 
  END.
  IF DI-RutaC.Libre_l01 = YES THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

/*   IF LOOKUP (di-rutac.flgest, 'P,C,A') > 0 THEN DO:      */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN "ADM-ERROR".                                */
/*   END.                                                   */

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""}

      RUN Procesa-Handle IN lh_handle ('disable-header').

      RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

