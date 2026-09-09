&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEFINE SHARED VARIABLE pRCID AS INT.

DEF VAR x-Moneda AS CHAR NO-UNDO.

DEF BUFFER b-rutad FOR di-rutad.
DEF BUFFER b-rutac FOR di-rutac.

DEF SHARED VAR lh_handle AS HANDLE.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DI-RutaD CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaD.CodRef DI-RutaD.NroRef ~
DI-RutaD.HorEst CcbCDocu.NomCli ~
IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda CcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DI-RutaD.CodRef ~
DI-RutaD.NroRef 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DI-RutaD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DI-RutaD
&Scoped-define QUERY-STRING-br_table FOR EACH DI-RutaD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaD.CodCia ~
  AND CcbCDocu.CodDoc = DI-RutaD.CodRef ~
  AND CcbCDocu.NroDoc = DI-RutaD.NroRef NO-LOCK ~
    BY CcbCDocu.CodCli
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DI-RutaD OF DI-RutaC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = DI-RutaD.CodCia ~
  AND CcbCDocu.CodDoc = DI-RutaD.CodRef ~
  AND CcbCDocu.NroDoc = DI-RutaD.NroRef NO-LOCK ~
    BY CcbCDocu.CodCli.
&Scoped-define TABLES-IN-QUERY-br_table DI-RutaD CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DI-RutaD
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table txtOrdDesp btnAddOD 
&Scoped-Define DISPLAYED-OBJECTS txtOrdDesp 

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
DEFINE BUTTON btnAddOD 
     LABEL "Add O/D" 
     SIZE 13 BY .96.

DEFINE VARIABLE txtOrdDesp AS CHARACTER FORMAT "X(9)":U 
     LABEL "O/D" 
     VIEW-AS FILL-IN 
     SIZE 15.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DI-RutaD, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaD.CodRef COLUMN-LABEL "Doc." FORMAT "x(3)":U WIDTH 7
            VIEW-AS COMBO-BOX INNER-LINES 2
                      LIST-ITEMS "G/R","TCK" 
                      DROP-DOWN-LIST 
      DI-RutaD.NroRef FORMAT "X(11)":U
      DI-RutaD.HorEst COLUMN-LABEL "Hora!Estimada" FORMAT "XX:XX":U
      CcbCDocu.NomCli FORMAT "x(40)":U
      IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda COLUMN-LABEL "Mon." FORMAT "x(3)":U
      CcbCDocu.ImpTot COLUMN-LABEL "Importe" FORMAT "->>,>>>,>>9.99":U
  ENABLE
      DI-RutaD.CodRef
      DI-RutaD.NroRef
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 90 BY 7.5
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     txtOrdDesp AT ROW 8.92 COL 51.29 COLON-ALIGNED WIDGET-ID 2
     btnAddOD AT ROW 8.85 COL 70 WIDGET-ID 4
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
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 9.27
         WIDTH              = 90.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.DI-RutaD OF INTEGRAL.DI-RutaC,INTEGRAL.CcbCDocu WHERE INTEGRAL.DI-RutaD ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.CcbCDocu.CodCli|yes"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = INTEGRAL.DI-RutaD.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = INTEGRAL.DI-RutaD.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = INTEGRAL.DI-RutaD.NroRef"
     _FldNameList[1]   > INTEGRAL.DI-RutaD.CodRef
"DI-RutaD.CodRef" "Doc." ? "character" ? ? ? ? ? ? yes ? no no "7" yes no no "U" "" "" "DROP-DOWN-LIST" "," "G/R,TCK" ? 2 no 0 no no
     _FldNameList[2]   > INTEGRAL.DI-RutaD.NroRef
"DI-RutaD.NroRef" ? "X(11)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaD.HorEst
"DI-RutaD.HorEst" "Hora!Estimada" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"IF CcbCDocu.CodMon = 1 THEN 'S/.' ELSE 'US$' @ x-moneda" "Mon." "x(3)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" "Importe" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
/*   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').                                */
/*   IF RETURN-VALUE = 'YES'                                             */
/*   THEN DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = 'G/R'. */
  IF DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
  THEN DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = 'G/R'.
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


&Scoped-define SELF-NAME DI-RutaD.CodRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaD.CodRef br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DI-RutaD.CodRef IN BROWSE br_table /* Doc. */
DO:
  ASSIGN SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaD.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaD.NroRef br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DI-RutaD.NroRef IN BROWSE br_table /* Numero */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    /* RUTINA CON EL SCANNER */
    CASE SUBSTRING(SELF:SCREEN-VALUE,1,1):
      WHEN '9' THEN DO:           /* G/R */
          ASSIGN
              SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,2,3) + SUBSTRING(SELF:SCREEN-VALUE,6,6).
      END.
    END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DI-RutaD.HorEst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DI-RutaD.HorEst br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF DI-RutaD.HorEst IN BROWSE br_table /* Hora!Estimada */
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


&Scoped-define SELF-NAME btnAddOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAddOD B-table-Win
ON CHOOSE OF btnAddOD IN FRAME F-Main /* Add O/D */
DO:
  ASSIGN txtOrdDesp.

  RUN ue-add-ord-desp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF DI-RutaD.CodRef, DI-RutaD.HorEst, DI-RutaD.NroRef 
DO:
    APPLY 'TAB':U.
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
  Notes:       SOLO se puede crear registros
------------------------------------------------------------------------------*/


    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
    
    /*  */
    RUN ue-assign-statement(NO).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
/*   IF LOOKUP (di-rutac.flgest, 'P,C,A') > 0 THEN DO:      */
/*       MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*       RETURN "ADM-ERROR".                                */
/*   END.                                                   */

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* 22Oct2014 - Ic */
      RUN ue-chequea-rack.

      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
      /* Code placed here will execute AFTER standard behavior.    */
      /* RHC 17.09.11 Control de G/R por pedidos */
      RUN dist/p-rut001 ( ROWID(Di-RutaC), NO ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  RUN Procesa-Handle IN lh_handle ('pinta-viewer').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      btnAddOD:SENSITIVE = YES.
      txtOrdDesp:SENSITIVE = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      btnAddOD:SENSITIVE = NO.
      txtOrdDesp:SENSITIVE = NO.
  END.

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
  {src/adm/template/snd-list.i "DI-RutaD"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-add-ord-desp B-table-Win 
PROCEDURE ue-add-ord-desp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lMsg AS CHAR.              
DEFINE VAR lNroPed AS CHAR.
DEFINE VAR lOrdDsp AS CHAR.
                
IF LOOKUP (di-rutac.flgest, 'C,A') > 0 THEN DO:
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN "ADM-ERROR". 
END.
ELSE DO:
    SESSION:SET-WAIT-STATE('GENERAL').
    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND faccpedi.coddoc = 'O/D' AND 
                                faccpedi.nroped = txtOrdDesp NO-LOCK NO-ERROR.
    IF AVAILABLE faccpedi THEN DO:
        /* Si la O/D esta rotulada */
        FIND FIRST CcbCBult USE-INDEX llave03 WHERE CcbCBult.CodCia = s-codcia
            AND CcbCBult.CodDoc = 'O/D'      /* O/D O/M */
            AND CcbCBult.NroDoc = faccpedi.nroped
            AND CcbCBult.CHR_01 = "P"
            NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbcbult THEN DO:
            lMsg = "".
            lOrdDsp = faccpedi.nroped.
            lNroped = faccpedi.nroref.
            DEFINE BUFFER bb-ccbcdocu FOR ccbcdocu.
            DEFINE BUFFER bb-di-rutad FOR di-rutad.
            DEFINE BUFFER bb-di-rutac FOR di-rutac.
            /* las guias (G/R) de la O/D que esten facturadas */
            FOR EACH bb-ccbcdocu USE-INDEX llave15 WHERE bb-ccbcdocu.codcia = s-codcia  AND 
                            (bb-ccbcdocu.codped = 'PED' AND bb-ccbcdocu.nroped = lNroPed)  NO-LOCK :

                IF bb-ccbcdocu.coddoc = 'G/R' AND (bb-ccbcdocu.libre_c01 = 'O/D' AND bb-ccbcdocu.libre_c02 = lOrdDsp )
                    AND bb-Ccbcdocu.flgest = "F" THEN DO:
                    lMsg = "".
                    /* consistencia en otros documentos */
                    FOR EACH bb-di-rutad USE-INDEX llave02 NO-LOCK WHERE bb-di-rutad.codcia = s-codcia
                        AND bb-di-rutad.coddoc = 'H/R'
                        AND bb-di-rutad.codref = bb-ccbcdocu.coddoc
                        AND bb-di-rutad.nroref = bb-ccbcdocu.nrodoc ,
                        FIRST bb-di-rutac OF bb-di-rutad NO-LOCK:
    
                        IF bb-di-rutac.flgest = "E" OR bb-di-rutac.flgest = "P" OR bb-di-rutac.flgest = "X" THEN DO:    
                            lMsg = "Documento ya se encuentra registrado en la H.R.:" + bb-di-rutac.nrodoc.
                        END.
                        IF bb-di-rutac.flgest = "C"  AND bb-di-rutad.flgest = "C" THEN DO:
                            lMsg = "Documento ya se encuentra registrado en la H.R.:" + bb-di-rutac.nrodoc.
                        END.
                    END.
                    IF lMsg = "" THEN DO:
                        /* Add G/R a la hoja de Ruta */
                        CREATE di-rutaD.
                            ASSIGN di-rutaD.codref = bb-ccbcdocu.coddoc
                                    di-rutaD.nroref = bb-ccbcdocu.nrodoc.
                    
                        RUN ue-assign-statement (YES).            
                        RUN dispatch IN THIS-PROCEDURE ('open-query':U).

                        RUN Procesa-Handle IN lh_handle ('pinta-viewer').
                        /**/
                    END.
                END.
            END.
            RELEASE bb-di-rutaC.
            RELEASE bb-di-rutaD.
            RELEASE bb-ccbcdocu.
            /*
            IF lMsg = "" THEN DO:

            END.
            ELSE DO:
                MESSAGE lMsg.
                RETURN "ADM-ERROR". 
            END.
            */
        END.
        ELSE DO:
            MESSAGE "O/D no esta Rotulado ó ya fue cargada a una H/R ó No existe".
            RETURN "ADM-ERROR". 
        END.
    END.
    ELSE DO:
        MESSAGE "O/D No existe".
        RETURN "ADM-ERROR". 
    END.
    SESSION:SET-WAIT-STATE('').

    RETURN "OK".
END.


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
DEFINE INPUT PARAMETER lOrgOD AS LOG    NO-UNDO.

/* Code placed here will execute AFTER standard behavior.    */
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.
DEFINE VAR lComa AS CHAR.
DEFINE VAR lPaletadespachada AS LOG.
DEFINE VAR lRowId AS ROWID.

ASSIGN
    DI-RutaD.CodCia = DI-RutaC.CodCia
    DI-RutaD.CodDiv = DI-RutaC.CodDiv
    DI-RutaD.CodDoc = DI-RutaC.CodDoc
    DI-RutaD.NroDoc = DI-RutaC.NroDoc
    DI-RutaD.CodRef = IF (lOrgOD = YES ) THEN DI-RutaD.CodRef ELSE DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&browse-name}.

/* Pesos y Volumenes */
RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
    cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
END.
DI-RutaD.Libre_c01 = cValor.

/* Grabamos el orden de impresion */
ASSIGN
    DI-RutaD.Libre_d01 = 9999.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ccbcdocu.codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
        AND VtaUbiDiv.CodDiv = s-coddiv
        AND VtaUbiDiv.CodDept = gn-clie.CodDept 
        AND VtaUbiDiv.CodProv = gn-clie.CodProv 
        AND VtaUbiDiv.CodDist = gn-clie.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
END.

/* RHC 17.09.11 Control de G/R por pedidos */
RUN dist/p-rut001 ( ROWID(Di-RutaC), NO ).
IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

/************************** Los RACKS  *****************************************/
DISABLE TRIGGERS FOR LOAD OF vtadtabla.
DISABLE TRIGGERS FOR LOAD OF vtactabla.
DISABLE TRIGGERS FOR LOAD OF vtatabla.   

/* Buscamos la GUIA de REMISION */
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = DI-RutaC.codcia
        AND Ccbcdocu.coddoc = DI-RutaD.CodRef
        AND Ccbcdocu.nrodoc = DI-RutaD.NroRef NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:  
  /* Chequeo si la O/D esta en el detalle del RACK */
  DEFINE BUFFER bb-vtadtabla FOR vtadtabla.

  FIND FIRST bb-vtadtabla WHERE bb-vtadtabla.codcia = DI-RutaC.codcia AND
        bb-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
        bb-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND   /* O/D, OTR, TRA */
        bb-vtadtabla.llavedetalle = ccbcdocu.libre_c02 NO-LOCK NO-ERROR. /* Nro */
  IF AVAILABLE bb-vtadtabla THEN DO:

      lComa = "".
      IF (bb-vtadtabla.libre_c05 = ? OR TRIM(bb-vtadtabla.libre_c05) = "") THEN DO:
          lComa = "".
      END.                
      ELSE DO :
          lComa = TRIM(bb-vtadtabla.libre_c05).
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

      lRowIdx = ROWID(bb-vtadtabla).
      FIND FIRST z-vtadtabla WHERE ROWID(z-vtadtabla) = lRowidx EXCLUSIVE NO-ERROR.
      IF AVAILABLE z-vtadtabla  THEN DO:
        ASSIGN z-vtadtabla.libre_c05 = lComa.            
      END.
      RELEASE z-vtadtabla.

      /* Libero RACKS Paletas */
        FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                    vtactabla.tabla = "MOV-RACK-HDR" AND 
                    vtactabla.llave BEGINS bb-vtadtabla.llave AND 
                    vtactabla.libre_c02 = bb-vtadtabla.tipo NO-LOCK NO-ERROR.
    
        IF AVAILABLE vtactabla THEN DO:

            /* Grabo el RACK en la RI-RUTAD */
            ASSIGN DI-RutaD.libre_c05 = vtactabla.libre_c01.

            /* Chequeo si todo el detalle de la paleta tiene HR (hoja de ruta) */
            DEF BUFFER B-vtadtabla FOR vtadtabla.
            DEF BUFFER B-vtactabla FOR vtactabla.

            /**MESSAGE "Cheqear si la GUIA aun NO esta despachada..".*/

            lPaletadespachada = YES.
            FOR EACH b-vtadtabla WHERE b-vtadtabla.codcia = s-codcia AND 
                    b-vtadtabla.tabla = "MOV-RACK-DTL" AND 
                    b-vtadtabla.llave = bb-vtadtabla.llave AND /* Division */
                    b-vtadtabla.tipo = bb-vtadtabla.tipo NO-LOCK :  /* Nro paleta */
                IF (b-vtadtabla.libre_c05 = ? OR b-vtadtabla.libre_c05 = "") THEN lPaletadespachada = NO.
            END.
            RELEASE B-vtadtabla.

            IF lPaletadespachada = YES THEN DO:
                /* Todos los O/D, OTR, TRA de la paleta tienen HR (Hoja de Ruta) */

               /* MESSAGE "La Guia no esta despachada .." .*/

                FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                            vtatabla.tabla = 'RACKS' AND 
                            vtatabla.llave_c1 = bb-vtadtabla.llave AND  /* Division */
                            vtatabla.llave_c2 = vtactabla.libre_c01 EXCLUSIVE NO-ERROR.  /* Rack */
                IF AVAILABLE vtatabla THEN DO:
                    ASSIGN vtatabla.valor[2] = vtatabla.valor[2] - 1.
                    ASSIGN vtatabla.valor[2] = IF (vtatabla.valor[2] < 0) THEN 0 ELSE vtatabla.valor[2].

                    RELEASE vtatabla.
                END.
                ELSE DO:
                    RELEASE vtatabla.
                    MESSAGE "NO EXISTE en RACK ..Division(" + bb-vtadtabla.llave + ") Rack(" + vtactabla.libre_c01 + ")" .
                END.
                
                /**/
                lRowId = ROWID(vtactabla).  
                FIND B-vtactabla WHERE rowid(B-vtactabla) = lROwId EXCLUSIVE NO-ERROR.
                IF AVAILABLE B-vtactabla THEN DO:
                    /* Cabecera */
                    ASSIGN B-vtactabla.libre_d03 =  pRCID
                            B-vtactabla.libre_f02 = TODAY
                            B-vtactabla.libre_c04 = STRING(TIME,"HH:MM:SS").

                    RELEASE B-vtactabla.

                END.                    
                ELSE DO:
                    RELEASE B-vtactabla.
                    MESSAGE "NO existe CABECERA .." .
                END.                
            END.            
            ELSE DO:
                RELEASE B-vtactabla.
                /* Aun hay O/D, TRA, OTR pendientes de despachar */
                /*MESSAGE "ERROR : libre_c05 ..(" bb-vtadtabla.llave + ") (" +  bb-vtadtabla.tipo + ")".*/
            END.            
        END.
        ELSE DO:
            MESSAGE "NO esta en la CABECERA ..(" bb-vtadtabla.llave + ") (" +  bb-vtadtabla.tipo + ")".
        END.
  END.
  ELSE DO:
      MESSAGE "No esta en el DETALLE ..Tipo(" + ccbcdocu.libre_c01 + ") Nro (" + ccbcdocu.libre_c02 + ")".
  END.
END.

RELEASE vtadtabla.
RELEASE vtactabla.
RELEASE B-vtactabla.
RELEASE bb-vtadtabla.

RETURN 'OK'.

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


FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = DI-RutaC.codcia
        AND Ccbcdocu.coddoc = DI-RutaD.CodRef
        AND Ccbcdocu.nrodoc = DI-RutaD.NroRef NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:  
  /* Chequeo si la O/D esta en el detalle del RACK */

  DEFINE BUFFER b-vtadtabla FOR vtadtabla.

  FIND FIRST b-vtadtabla WHERE b-vtadtabla.codcia = DI-RutaC.codcia AND
        b-vtadtabla.tabla = 'MOV-RACK-DTL' AND 
        b-vtadtabla.libre_c03 = ccbcdocu.libre_c01 AND   /* O/D, OTR, TRA  */
        b-vtadtabla.llavedetalle = ccbcdocu.libre_c02 EXCLUSIVE NO-ERROR.  /* Nro */
  IF AVAILABLE b-vtadtabla THEN DO:
        lComa = "".
        IF (b-vtadtabla.libre_c05 = ? OR TRIM(b-vtadtabla.libre_c05) = "") THEN DO:
            lComa = "".
        END.                
        ELSE DO :
            lComa = TRIM(b-vtadtabla.libre_c05).
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
        ASSIGN b-vtadtabla.libre_c05 = lComa.
      /* ------------------------  */
  END.
  RELEASE b-vtadtabla.
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
  DEF VAR x-Rowid AS ROWID.
  
  IF LOOKUP(TRIM(DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 'G/R,TCK') = 0
  THEN DO:
    MESSAGE 'El documento debe ser G/R o TCK' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO DI-RutaD.CodRef IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
  END.
  FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND ccbcdocu.nrodoc = DI-RutaD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbcdocu
  THEN DO:
    MESSAGE "El documento" DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        DI-RutaD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        "no está registrado" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF Ccbcdocu.flgest = "A" THEN DO:
      MESSAGE "El documento se encuentra anulado" VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO DI-RutaD.NroRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
  END.
  IF Ccbcdocu.coddoc = 'G/R' AND Ccbcdocu.flgest <> "F" THEN DO:
      MESSAGE "El documento NO está FACTURADO" VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO DI-RutaD.NroRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
  END.
  /* RHC 31/05/2016 Consistencia de Contado Anticipado */
  IF Ccbcdocu.coddoc = "G/R" THEN DO:
      FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddoc = Ccbcdocu.codref
          AND B-CDOCU.nrodoc = Ccbcdocu.nroref
          NO-LOCK NO-ERROR.
      IF AVAILABLE B-CDOCU
          AND B-CDOCU.fmapgo = '002'
          AND B-CDOCU.flgest <> "C"
          THEN DO:
          MESSAGE 'El comprobante:' B-CDOCU.coddoc B-CDOCU.nrodoc SKIP
              'cuya condición de venta es CONTADO ANTICIPADO' SKIP
              'NO está cancelado aún' VIEW-AS ALERT-BOX ERROR.
          APPLY 'entry' TO DI-RutaD.NroRef IN BROWSE {&browse-name}.
          RETURN "ADM-ERROR".
      END.
  END.
  IF di-rutac.flgest = "C" THEN DO:
      MESSAGE "Hoja de Ruta esta CERRADA" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.    
  /* RHC 16/08/2012 CONSISTENCIA DE ROTULADO */
  FIND FIRST CcbCBult WHERE CcbCBult.CodCia = Ccbcdocu.codcia
      AND CcbCBult.CodDoc = Ccbcdocu.Libre_C01      /* O/D O/M */
      AND CcbCBult.NroDoc = Ccbcdocu.Libre_C02
      AND CcbCBult.CHR_01 = "P"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcbult THEN DO:
      MESSAGE 'Falta ROTULAR la' Ccbcdocu.Libre_C01 Ccbcdocu.Libre_C02
          VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* *************************************** */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      IF CAN-FIND(FIRST DI-RutaD OF DI-RutaC WHERE DI-RutaD.codref = DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                  AND DI-RutaD.nroref = DI-RutaD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                  NO-LOCK)
          THEN DO:
          MESSAGE "El documento" DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              DI-RutaD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
              "ya fue registrado en esta hoja de ruta" VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      /* consistencia en otros documentos */
      FOR EACH b-rutad NO-LOCK WHERE b-rutad.codcia = s-codcia
          AND b-rutad.coddoc = s-coddoc
          AND b-rutad.codref = DI-RutaD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          AND b-rutad.nroref = DI-RutaD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
          FIRST b-rutac OF b-rutad NO-LOCK:
          IF b-rutac.flgest = "E" OR b-rutac.flgest = "P" OR b-rutac.flgest = "X" THEN DO:
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

MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
RETURN 'ADM-ERROR'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

