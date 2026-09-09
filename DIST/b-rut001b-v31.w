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
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VARIABLE pRCID AS INT.

DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
DEF VAR s-codmov AS INT  INIT 03  NO-UNDO.      /* Salida por transferencia */

DEF BUFFER b-rutad FOR di-rutag.
DEF BUFFER b-rutac FOR di-rutac.

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
&Scoped-define INTERNAL-TABLES Di-RutaG Almcmov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Di-RutaG.serref Di-RutaG.nroref ~
Di-RutaG.HorEst Di-RutaG.CodAlm Almcmov.AlmDes Almcmov.FchDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Di-RutaG.serref ~
Di-RutaG.nroref 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Di-RutaG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Di-RutaG
&Scoped-define QUERY-STRING-br_table FOR EACH Di-RutaG OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia ~
  AND Almcmov.CodAlm = Di-RutaG.CodAlm ~
  AND Almcmov.TipMov = Di-RutaG.Tipmov ~
  AND Almcmov.CodMov = Di-RutaG.Codmov ~
  AND Almcmov.NroSer = Di-RutaG.serref ~
  AND Almcmov.NroDoc = Di-RutaG.nroref NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Di-RutaG OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almcmov WHERE Almcmov.CodCia = Di-RutaG.CodCia ~
  AND Almcmov.CodAlm = Di-RutaG.CodAlm ~
  AND Almcmov.TipMov = Di-RutaG.Tipmov ~
  AND Almcmov.CodMov = Di-RutaG.Codmov ~
  AND Almcmov.NroSer = Di-RutaG.serref ~
  AND Almcmov.NroDoc = Di-RutaG.nroref NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Di-RutaG Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Di-RutaG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almcmov


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
      Di-RutaG, 
      Almcmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Di-RutaG.serref COLUMN-LABEL "Serie" FORMAT "999":U
      Di-RutaG.nroref COLUMN-LABEL "Correlativo" FORMAT "9999999":U
      Di-RutaG.HorEst COLUMN-LABEL "Hora!Estimada" FORMAT "XX:XX":U
      Di-RutaG.CodAlm COLUMN-LABEL "Almacén!Origen" FORMAT "x(5)":U
      Almcmov.AlmDes FORMAT "x(3)":U
      Almcmov.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
  ENABLE
      Di-RutaG.serref
      Di-RutaG.nroref
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 58 BY 6.92
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
         HEIGHT             = 8.85
         WIDTH              = 62.57.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Di-RutaG OF INTEGRAL.DI-RutaC,INTEGRAL.Almcmov WHERE INTEGRAL.Di-RutaG ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[2]      = "INTEGRAL.Almcmov.CodCia = INTEGRAL.Di-RutaG.CodCia
  AND INTEGRAL.Almcmov.CodAlm = INTEGRAL.Di-RutaG.CodAlm
  AND INTEGRAL.Almcmov.TipMov = INTEGRAL.Di-RutaG.Tipmov
  AND INTEGRAL.Almcmov.CodMov = INTEGRAL.Di-RutaG.Codmov
  AND INTEGRAL.Almcmov.NroSer = INTEGRAL.Di-RutaG.serref
  AND INTEGRAL.Almcmov.NroDoc = INTEGRAL.Di-RutaG.nroref"
     _FldNameList[1]   > INTEGRAL.Di-RutaG.serref
"Di-RutaG.serref" "Serie" ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Di-RutaG.nroref
"Di-RutaG.nroref" "Correlativo" "9999999" "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Di-RutaG.HorEst
"Di-RutaG.HorEst" "Hora!Estimada" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Di-RutaG.CodAlm
"Di-RutaG.CodAlm" "Almacén!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.Almcmov.AlmDes
     _FldNameList[6]   > INTEGRAL.Almcmov.FchDoc
"Almcmov.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME Di-RutaG.nroref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Di-RutaG.nroref br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Di-RutaG.nroref IN BROWSE br_table /* Correlativo */
DO:
  di-rutag.codalm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
  /* buscamos el documento a que almacen pertenece */
  FOR EACH almacen WHERE almacen.codcia = s-codcia NO-LOCK:
    FIND almcmov WHERE almcmov.codcia = s-codcia
        AND almcmov.codalm = almacen.codalm
        AND almcmov.tipmov = s-tipmov
        AND almcmov.codmov = s-codmov
        AND almcmov.nroser = INTEGER(Di-RutaG.serref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        AND almcmov.nrodoc = INTEGER(Di-RutaG.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        NO-LOCK NO-ERROR.
    IF AVAILABLE almcmov
    THEN DO:
        DISPLAY 
            almacen.codalm @ di-rutag.codalm
            almcmov.fchdoc 
            almcmov.almdes
            WITH BROWSE {&BROWSE-NAME}.
        LEAVE.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Di-RutaG.HorEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Di-RutaG.HorEst br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Di-RutaG.HorEst IN BROWSE br_table /* Hora!Estimada */
DO:
  IF SELF:SCREEN-VALUE = "  :  " THEN RETURN.
  /* Consistencia */
  DEF VAR x-Hora AS INT.
  DEF VAR x-Min  AS INT.
  
  ASSIGN
    x-Hora = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,1,2))
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'Ingrese correctamente la hora' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  ASSIGN
    x-Min = INTEGER(SUBSTRING(SELF:SCREEN-VALUE,4,2))
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'Ingrese correctamente los minutos' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  SELF:SCREEN-VALUE = STRING(x-Hora, '99') + STRING(x-Min, '99').
  IF NOT (x-Hora >= 0 AND x-Hora <= 23) THEN DO:
    MESSAGE 'La hora debe estar en 00 y 23' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
  IF NOT (x-Min >= 0 AND x-Min <= 59) THEN DO:
    MESSAGE 'Los minutos deben estar en 00 y 59' VIEW-AS ALERT-BOX WARNING.
    RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF Di-RutaG.nroref, Di-RutaG.serref DO:
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
    IF hColumn:NAME = 'SerRef' OR hColumn:NAME = 'NroRef' THEN hColumn:READ-ONLY = TRUE.
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
  RUN ue-assign-statement(NO).


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
  IF Di-RutaG.Libre_c01 <> "*" THEN DO:     /* OJO: ingresado manualmente */ 
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR". 
  END.

/*   IF LOOKUP (di-rutac.flgest, 'P,C,A') > 0 THEN DO:      */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN "ADM-ERROR".                                */
/*   END.                                                   */
  
/*   {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""} */

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* 22Oct2014 - Ic  */
      RUN ue-chequea-rack.

      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
      /* Code placed here will execute AFTER standard behavior.    */
      /* RHC 17.09.11 Control de G/R por pedidos y transferencias */
      RUN dist/p-rut001 ( ROWID(Di-RutaC), NO ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  RUN Procesa-Handle IN lh_handle ('pinta-viewer').

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pinta-viewer').
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
  {src/adm/template/snd-list.i "Di-RutaG"}
  {src/adm/template/snd-list.i "Almcmov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-assign-statement B-table-Win 
PROCEDURE ue-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER lOrgOTR AS LOG.

DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lSerMovAlm AS INT.
DEFINE VAR lNroMovAlm AS INT.

IF lOrgOTR = YES THEN DO:
    lAlmacen = Di-RutaG.CodAlm.
    lSerMovAlm = di-rutag.serref.
    lNroMovAlm = di-rutaG.nroref.
END.
ELSE DO:
    lAlmacen = Di-RutaG.CodAlm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
    lSerMovAlm = INTEGER(di-rutag.serref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    lNroMovAlm = INTEGER(di-rutag.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
END.
 
ASSIGN 
    Di-RutaG.CodCia = Di-RutaC.CodCia
    Di-RutaG.CodDiv = Di-RutaC.CodDiv
    Di-RutaG.CodDoc = Di-RutaC.CodDoc
    Di-RutaG.NroDoc = Di-RutaC.NroDoc
    Di-RutaG.Tipmov = s-tipmov
    Di-RutaG.Codmov = s-codmov
    Di-RutaG.CodAlm = lAlmacen.

/* RHC 01/12/17 OJO, esta rutina funciona solo para registros manuales */
ASSIGN
    Di-RutaG.Libre_c01 = "*".   /* OJO */
/* ******************************************************************* */

/* RHC 17.09.11 Control de G/R por pedidos */
RUN dist/p-rut001 ( ROWID(Di-RutaC), NO ).
IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

/* Guardos los pesos y el costo de Mov. Almacen - Ic 10Jul2013 */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.

lPesos = 0.
lCosto = 0.
lVolumen = 0.

FOR EACH almdmov WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = lAlmacen /*di-rutag.codalm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}*/
    AND almdmov.tipmov = s-tipmov 
    AND almdmov.codmov = s-codmov
    AND almdmov.nroser = lSerMovAlm
    AND almdmov.nrodoc = lNroMovAlm NO-LOCK:

    /*lPesos = lPesos + almdmov.pesmat.*/
    /* Costo */
    FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
        AND AlmStkGe.codmat = almdmov.codmat 
        AND AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
    
    lValorizado = NO.
    IF AVAILABLE AlmStkGe THEN DO:
        /* Ic - 29Mar2017
            Correo de Luis Figueroa 28Mar2017
            De: Luis Figueroa [mailto:lfigueroa@continentalperu.com] 
            Enviado el: martes, 28 de marzo de 2017 08:59 p.m.
            
            Enrique:
            Para el cálculo del  valorizado de las transferencias internas por favor utilizar el costo y no el precio de venta
            Esto ya lo aprobó PW            
        */
        /* Costo KARDEX */
        IF AlmStkGe.CtoUni <> ? THEN DO:
            lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes * AlmDmov.factor).
            lValorizado = YES.
        END.        
        /*
        IF AlmStkGe.CtoUni > 0 THEN lValorizado = YES.
        */
    END.
    /* 
        Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta
        Ic - 29Mar2017, se dejo sin efecto lo anterior (Felix Perez)
    */
    /*lValorizado = NO.*/

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
        lPesos = lPesos + (almmmatg.pesmat * almdmov.candes).
    END.

    /* Volumen */
    IF lValorizado = NO THEN DO:
        IF AVAILABLE almmmatg THEN DO :
            
            /* Si tiene valorzacion CERO, cargo el precio de venta */
            IF lValorizado = NO THEN DO:
                IF almmmatg.monvta = 2 THEN DO:
                    /* Dolares */
                    lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
                END.
                ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes * Almdmov.factor).
            END.
        END.

    END.
END.

ASSIGN 
    Di-RutaG.libre_d01 = lPesos
    Di-RutaG.libre_d02 = lCosto.           
    Di-RutaG.libre_d03 = lVolumen.

/*
21Oct2014 - Ic
*/

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.
DEFINE VAR lRowId AS ROWID.

DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.

/*      R A C K S      */
FIND FIRST almcmov WHERE almcmov.codcia = DI-RutaC.codcia AND 
                        almcmov.codalm = di-rutaG.codalm AND
                        almcmov.tipmov = di-rutaG.tipmov AND
                        almcmov.codmov = di-rutaG.codmov AND 
                        almcmov.nroser = di-rutaG.serref AND
                        almcmov.nrodoc = di-rutaG.nroref NO-LOCK NO-ERROR.
IF AVAILABLE almcmov THEN DO:
    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.
    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST vtadtabla WHERE vtadtabla.codcia = DI-RutaC.codcia AND
          vtadtabla.tabla = 'MOV-RACK-DTL' AND 
          vtadtabla.libre_c03 = lCodDoc AND 
          vtadtabla.llavedetalle = lNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtadtabla THEN DO:
        lComa = "".
        IF (vtadtabla.libre_c05 = ? OR TRIM(vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.                
        ELSE DO :
            lComa = TRIM(vtadtabla.libre_c05).
        END.
        /* Grabo la Hoja de Ruta */
        IF lComa = "" THEN DO:
            lComa = trim(Di-RutaC.nrodoc).
        END.
        ELSE DO:
            lComa = lComa + ", " + trim(Di-RutaC.nrodoc).
        END.
        
        DEFINE BUFFER z-vtadtabla FOR vtadtabla.
        DEFINE VAR lRowIdx AS ROWID.

        lRowIdx = ROWID(vtadtabla).
        FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
        IF AVAILABLE z-vtadtabla THEN DO:
            ASSIGN z-vtadtabla.libre_c05 = lComa.
        END.       
        RELEASE z-vtadtabla.

        /* * */

        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                    vtactabla.tabla = "MOV-RACK-HDR" AND 
                    vtactabla.llave BEGINS vtadtabla.llave AND 
                    vtactabla.libre_c02 = vtadtabla.tipo NO-LOCK NO-ERROR.

        IF AVAILABLE vtactabla THEN DO:
            /* Grabo el RACK en DI-RUTAG */
            ASSIGN Di-RutaG.libre_c05 = vtactabla.libre_c01.

            DEF BUFFER B-vtadtabla FOR vtadtabla.
            DEF BUFFER B-vtactabla FOR vtactabla.

            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                    b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                    b-vtadtabla.llave = vtadtabla.llave AND 
                    b-vtadtabla.tipo = vtadtabla.tipo NO-LOCK :
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.

            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */
                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'RACKS' AND 
                            vtatabla.llave_c1 = vtadtabla.llave AND
                            vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].
                END.
                RELEASE vtatabla.

                /* la Paleta */
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    ASSIGN B-vtactabla.libre_d03 =  pRCID
                            B-vtactabla.libre_f02 = TODAY
                            B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").
                END.                    
            END.
            RELEASE B-vtactabla.
        END.
    END.
    RELEASE vtadtabla.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-chequea-rack B-table-Win 
PROCEDURE ue-chequea-rack :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lHojaRuta AS CHAR.

DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.


FIND FIRST almcmov WHERE almcmov.codcia = DI-RutaC.codcia AND 
                    almcmov.codalm = di-rutaG.codalm AND
                    almcmov.tipmov = di-rutaG.tipmov AND
                    almcmov.codmov = di-rutaG.codmov AND 
                    almcmov.nroser = di-rutaG.serref AND
                    almcmov.nrodoc = di-rutaG.nroref NO-LOCK NO-ERROR.
IF AVAILABLE almcmov THEN DO:
    IF almcmov.codref = 'OTR' THEN DO:
        /* Orden de Transferencia */
        lCodDoc = almcmov.codref.
        lNroDoc = almcmov.nroref.
    END.
    ELSE DO:
        /* Transferencia entre almacenes */
        lCodDoc = 'TRA'.
        lNroDoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999").
    END.
    /* Chequeo si la O/D esta en el detalle del RACK */
    FIND FIRST vtadtabla WHERE vtadtabla.codcia = DI-RutaC.codcia AND
          vtadtabla.tabla = 'MOV-RACK-DTL' AND 
          vtadtabla.libre_c03 = lCodDoc AND 
          vtadtabla.llavedetalle = lNroDoc EXCLUSIVE NO-ERROR.
    IF AVAILABLE vtadtabla THEN DO:
        lComa = "".
        IF (vtadtabla.libre_c05 = ? OR TRIM(vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.                
        ELSE DO :
            lComa = TRIM(vtadtabla.libre_c05).
        END.

        lHojaRuta = trim(Di-RutaC.nrodoc) + ",".
        IF INDEX(lComa,lHojaRuta) > 0 THEN DO:
            lComa = REPLACE(lComa,lHojaRuta,"").
        END.
        ELSE DO:
            lHojaRuta = trim(Di-RutaC.nrodoc).
            IF INDEX(lComa,lHojaRuta) > 0 THEN DO:
                lComa = REPLACE(lComa,lHojaRuta,"").
            END.
        END.        
        ASSIGN vtadtabla.libre_c05 = lComa.
        /*  */
    END.
    RELEASE vtadtabla.
END.

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
  FIND almcmov WHERE almcmov.codcia = s-codcia
    AND almcmov.codalm = di-rutag.codalm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND almcmov.tipmov = s-tipmov 
    AND almcmov.codmov = s-codmov
    AND almcmov.nroser = INTEGER(di-rutag.serref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    AND almcmov.nrodoc = INTEGER(di-rutag.nroref:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE almcmov
  THEN DO:
    MESSAGE 'Guia de transferencia no encontrada'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF Almcmov.flgest = "A" THEN DO:
      MESSAGE "Guia de transferencia ANULADA" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF Almcmov.FlgSit = "R" THEN DO:
      MESSAGE 'La Guia está RECEPCIONADA (¿?)' SKIP
          'Revise su información' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF Almcmov.CodRef = "OTR" THEN DO:    /* NO por OTR */
      MESSAGE 'La Transferencia viene de la' Almcmov.codref Almcmov.nroref SKIP
          'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  IF di-rutac.flgest = "C" THEN DO:
    MESSAGE "Hoja de Ruta esta CERRADA" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  /* RHC 16/08/2012 CONSISTENCIA DE ROTULADO */
  CASE TRUE:
      WHEN Almcmov.CodRef = "OTR" THEN DO:
          FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
              AND CcbCBult.CodDoc = Almcmov.CodRef
              AND CcbCBult.NroDoc = Almcmov.NroRef
              AND CcbCBult.CHR_01 = "P"
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Ccbcbult THEN DO:
              MESSAGE 'Falta ROTULAR la G/R por Transferencia'
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
      OTHERWISE DO:
          FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
              AND CcbCBult.CodDoc = "TRA"
              AND CcbCBult.NroDoc = STRING(INPUT di-rutag.serref , '999') +
                                    STRING(INPUT di-rutag.nroref , '9999999')
              AND CcbCBult.CHR_01 = "P"
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Ccbcbult THEN DO:
              MESSAGE 'Falta ROTULAR la G/R por Transferencia'
                  VIEW-AS ALERT-BOX ERROR.
              RETURN "ADM-ERROR".
          END.
      END.
  END CASE.
  /* *************************************** */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      IF CAN-FIND(FIRST DI-RutaG OF DI-RutaC WHERE DI-RutaG.serref = INTEGER (DI-RutaG.SerRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        AND DI-RutaG.nroref = INTEGER (DI-RutaG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        NO-LOCK)
      THEN DO:
        MESSAGE "El documento" DI-RutaG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
            "ya fue registrado en esta hoja de ruta" VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
      END.
      /* consistencia en otros documentos */
      FOR EACH b-rutad NO-LOCK WHERE b-rutad.codcia = s-codcia
          AND b-rutad.coddoc = s-coddoc
          AND b-rutad.serref = INTEGER (DI-RutaG.SerRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
          AND b-rutad.nroref = INTEGER (DI-RutaG.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}),
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

  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

/*   IF LOOKUP (di-rutac.flgest, 'P,C,A') > 0 THEN DO:      */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN "ADM-ERROR".                                */
/*   END.                                                   */
/*   IF DI-RutaC.Libre_l01 = YES THEN DO:                   */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN 'ADM-ERROR'.                                */
/*   END.                                                   */
/*                                                          */
/*   {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""}            */
/*                                                          */
/*   RUN Procesa-Handle IN lh_handle ('enable-header').     */
/*   RETURN "OK".                                           */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

