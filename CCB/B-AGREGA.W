&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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
&Scoped-define INTERNAL-TABLES CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCDocu.CodCia CcbCDocu.CodDiv ~
CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.RucCli CcbCDocu.CodCli ~
CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.FchDoc CcbCDocu.FchVto ~
CcbCDocu.FchCan CcbCDocu.CodMon CcbCDocu.ImpTot CcbCDocu.SdoAct ~
CcbCDocu.FmaPgo CcbCDocu.CodVen CcbCDocu.ImpBrt CcbCDocu.ImpVta ~
CcbCDocu.ImpIgv CcbCDocu.TpoCmb CcbCDocu.FlgEst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CcbCDocu.CodCia ~
CcbCDocu.CodDiv CcbCDocu.CodDoc CcbCDocu.NroDoc CcbCDocu.RucCli ~
CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.DirCli CcbCDocu.FchDoc ~
CcbCDocu.FchVto CcbCDocu.FchCan CcbCDocu.CodMon CcbCDocu.ImpTot ~
CcbCDocu.SdoAct CcbCDocu.FmaPgo CcbCDocu.CodVen CcbCDocu.ImpBrt ~
CcbCDocu.ImpVta CcbCDocu.ImpIgv CcbCDocu.TpoCmb CcbCDocu.FlgEst 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodCia ~{&FP2}CodCia ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}CodDoc ~{&FP2}CodDoc ~{&FP3}~
 ~{&FP1}NroDoc ~{&FP2}NroDoc ~{&FP3}~
 ~{&FP1}RucCli ~{&FP2}RucCli ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}NomCli ~{&FP2}NomCli ~{&FP3}~
 ~{&FP1}DirCli ~{&FP2}DirCli ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}FchVto ~{&FP2}FchVto ~{&FP3}~
 ~{&FP1}FchCan ~{&FP2}FchCan ~{&FP3}~
 ~{&FP1}CodMon ~{&FP2}CodMon ~{&FP3}~
 ~{&FP1}ImpTot ~{&FP2}ImpTot ~{&FP3}~
 ~{&FP1}SdoAct ~{&FP2}SdoAct ~{&FP3}~
 ~{&FP1}FmaPgo ~{&FP2}FmaPgo ~{&FP3}~
 ~{&FP1}CodVen ~{&FP2}CodVen ~{&FP3}~
 ~{&FP1}ImpBrt ~{&FP2}ImpBrt ~{&FP3}~
 ~{&FP1}ImpVta ~{&FP2}ImpVta ~{&FP3}~
 ~{&FP1}ImpIgv ~{&FP2}ImpIgv ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}FlgEst ~{&FP2}FlgEst ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CcbCDocu
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCDocu WHERE ~{&KEY-PHRASE} ~
      AND CcbCDocu.CodCia = 1 AND ~
integral.CcbCDocu.CodDiv = f-divi ~
 AND CcbCDocu.FchDoc = f-fecha NO-LOCK ~
    BY CcbCDocu.FchDoc ~
       BY CcbCDocu.NroDoc.
&Scoped-define TABLES-IN-QUERY-br_table CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table f-divi f-fecha 
&Scoped-Define DISPLAYED-OBJECTS f-divi f-fecha 

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
DEFINE VARIABLE f-divi AS CHARACTER FORMAT "XXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE f-fecha AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCDocu.CodCia
      CcbCDocu.CodDiv FORMAT "XX-XXXX"
      CcbCDocu.CodDoc
      CcbCDocu.NroDoc FORMAT "X(12)"
      CcbCDocu.RucCli
      CcbCDocu.CodCli FORMAT "x(10)"
      CcbCDocu.NomCli
      CcbCDocu.DirCli
      CcbCDocu.FchDoc
      CcbCDocu.FchVto
      CcbCDocu.FchCan
      CcbCDocu.CodMon
      CcbCDocu.ImpTot
      CcbCDocu.SdoAct
      CcbCDocu.FmaPgo
      CcbCDocu.CodVen
      CcbCDocu.ImpBrt
      CcbCDocu.ImpVta
      CcbCDocu.ImpIgv
      CcbCDocu.TpoCmb
      CcbCDocu.FlgEst
  ENABLE
      CcbCDocu.CodCia
      CcbCDocu.CodDiv
      CcbCDocu.CodDoc
      CcbCDocu.NroDoc
      CcbCDocu.RucCli
      CcbCDocu.CodCli
      CcbCDocu.NomCli
      CcbCDocu.DirCli
      CcbCDocu.FchDoc
      CcbCDocu.FchVto
      CcbCDocu.FchCan
      CcbCDocu.CodMon
      CcbCDocu.ImpTot
      CcbCDocu.SdoAct
      CcbCDocu.FmaPgo
      CcbCDocu.CodVen
      CcbCDocu.ImpBrt
      CcbCDocu.ImpVta
      CcbCDocu.ImpIgv
      CcbCDocu.TpoCmb
      CcbCDocu.FlgEst
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 87.72 BY 9.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.35 COL 1
     f-divi AT ROW 1.23 COL 10.86 COLON-ALIGNED NO-LABEL
     f-fecha AT ROW 1.19 COL 32.14 COLON-ALIGNED
     "Division :" VIEW-AS TEXT
          SIZE 8.86 BY .77 AT ROW 1.23 COL 3.72
          FONT 6
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
         HEIGHT             = 11.12
         WIDTH              = 87.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.CcbCDocu"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "integral.CcbCDocu.FchDoc|yes,integral.CcbCDocu.NroDoc|yes"
     _Where[1]         = "integral.CcbCDocu.CodCia = 1 AND
integral.CcbCDocu.CodDiv = f-divi
 AND integral.CcbCDocu.FchDoc = f-fecha"
     _FldNameList[1]   > integral.CcbCDocu.CodCia
"CcbCDocu.CodCia" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.CcbCDocu.CodDiv
"CcbCDocu.CodDiv" ? "XX-XXXX" "character" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.CcbCDocu.CodDoc
"CcbCDocu.CodDoc" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > integral.CcbCDocu.NroDoc
"CcbCDocu.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.CcbCDocu.RucCli
"CcbCDocu.RucCli" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > integral.CcbCDocu.CodCli
"CcbCDocu.CodCli" ? "x(10)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[7]   > integral.CcbCDocu.NomCli
"CcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > integral.CcbCDocu.DirCli
"CcbCDocu.DirCli" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[9]   > integral.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[10]   > integral.CcbCDocu.FchVto
"CcbCDocu.FchVto" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[11]   > integral.CcbCDocu.FchCan
"CcbCDocu.FchCan" ? ? "date" ? ? ? ? ? ? yes ?
     _FldNameList[12]   > integral.CcbCDocu.CodMon
"CcbCDocu.CodMon" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[13]   > integral.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[14]   > integral.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[15]   > integral.CcbCDocu.FmaPgo
"CcbCDocu.FmaPgo" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[16]   > integral.CcbCDocu.CodVen
"CcbCDocu.CodVen" ? ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[17]   > integral.CcbCDocu.ImpBrt
"CcbCDocu.ImpBrt" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[18]   > integral.CcbCDocu.ImpVta
"CcbCDocu.ImpVta" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[19]   > integral.CcbCDocu.ImpIgv
"CcbCDocu.ImpIgv" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[20]   > integral.CcbCDocu.TpoCmb
"CcbCDocu.TpoCmb" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[21]   > integral.CcbCDocu.FlgEst
"CcbCDocu.FlgEst" ? ? "character" ? ? ? ? ? ? yes ?
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


&Scoped-define SELF-NAME f-divi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-divi B-table-Win
ON LEAVE OF f-divi IN FRAME F-Main
DO:
  ASSIGN f-divi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-fecha B-table-Win
ON LEAVE OF f-fecha IN FRAME F-Main /* Fecha */
DO:
  assign f-divi
         f-fecha.
  message f-divi f-fecha.         
  run abrir-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

assign f-divi  = S-CODDIV
       f-fecha = TODAY.
       
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


