&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          reporte          PROGRESS
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
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.

DEFINE VARIABLE X-NROFCH AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almdmov
&Scoped-define FIRST-EXTERNAL-TABLE Almdmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almdmov.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES EvtArti

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table EvtArti.Codano EvtArti.Codmes ~
EvtArti.Canxdia[1] EvtArti.Canxdia[2] EvtArti.Canxdia[3] EvtArti.Canxdia[4] ~
EvtArti.Canxdia[5] EvtArti.Canxdia[6] EvtArti.Canxdia[7] EvtArti.Canxdia[8] ~
EvtArti.Canxdia[9] EvtArti.Canxdia[10] EvtArti.Canxdia[11] ~
EvtArti.Canxdia[12] EvtArti.Canxdia[13] EvtArti.Canxdia[14] ~
EvtArti.Canxdia[15] EvtArti.Canxdia[16] EvtArti.Canxdia[17] ~
EvtArti.Canxdia[18] EvtArti.Canxdia[19] EvtArti.Canxdia[20] ~
EvtArti.Canxdia[21] EvtArti.Canxdia[22] EvtArti.Canxdia[23] ~
EvtArti.Canxdia[24] EvtArti.Canxdia[25] EvtArti.Canxdia[26] ~
EvtArti.Canxdia[27] EvtArti.Canxdia[28] EvtArti.Canxdia[29] ~
EvtArti.Canxdia[30] EvtArti.Canxdia[31] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH EvtArti WHERE TRUE /* Join to Almdmov incomplete */ ~
      AND EvtArti.CodCia = S-CODCIA ~
 AND EvtArti.CodDiv = S-CODDIV ~
 AND EvtArti.codmat = Almdmov.CodMat ~
 AND EvtArti.Nrofch >= X-NROFCH NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table EvtArti
&Scoped-define FIRST-TABLE-IN-QUERY-br_table EvtArti


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
      EvtArti SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      EvtArti.Codano
      EvtArti.Codmes
      EvtArti.Canxdia[1] COLUMN-LABEL "Dia 01" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[2] COLUMN-LABEL "Dia 02" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[3] COLUMN-LABEL "Dia 03" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[4] COLUMN-LABEL "Dia 04" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[5] COLUMN-LABEL "Dia 05" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[6] COLUMN-LABEL "Dia 06" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[7] COLUMN-LABEL "Dia 07" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[8] COLUMN-LABEL "Dia 08" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[9] COLUMN-LABEL "Dia 09" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[10] COLUMN-LABEL "Dia 10" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[11] COLUMN-LABEL "Dia 11" FORMAT "->>>>>>>"
            COLUMN-FGCOLOR 9
      EvtArti.Canxdia[12] COLUMN-LABEL "Dia 12" FORMAT "->>>>>>>"
      EvtArti.Canxdia[13] COLUMN-LABEL "Dia 13" FORMAT "->>>>>>>"
      EvtArti.Canxdia[14] COLUMN-LABEL "Dia 14" FORMAT "->>>>>>>"
      EvtArti.Canxdia[15] COLUMN-LABEL "Dia 15" FORMAT "->>>>>>>"
      EvtArti.Canxdia[16] COLUMN-LABEL "Dia 16" FORMAT "->>>>>>>"
      EvtArti.Canxdia[17] COLUMN-LABEL "Dia 17" FORMAT "->>>>>>>"
      EvtArti.Canxdia[18] COLUMN-LABEL "Dia 18" FORMAT "->>>>>>>"
      EvtArti.Canxdia[19] COLUMN-LABEL "Dia 19" FORMAT "->>>>>>>"
      EvtArti.Canxdia[20] COLUMN-LABEL "Dia 20" FORMAT "->>>>>>>"
      EvtArti.Canxdia[21] COLUMN-LABEL "Dia 21" FORMAT "->>>>>>>"
      EvtArti.Canxdia[22] COLUMN-LABEL "Dia 22" FORMAT "->>>>>>>"
      EvtArti.Canxdia[23] COLUMN-LABEL "Dia 23" FORMAT "->>>>>>>"
      EvtArti.Canxdia[24] COLUMN-LABEL "Dia 24" FORMAT "->>>>>>>"
      EvtArti.Canxdia[25] COLUMN-LABEL "Dia 25" FORMAT "->>>>>>>"
      EvtArti.Canxdia[26] COLUMN-LABEL "Dia 26" FORMAT "->>>>>>>"
      EvtArti.Canxdia[27] COLUMN-LABEL "Dia 27" FORMAT "->>>>>>>"
      EvtArti.Canxdia[28] COLUMN-LABEL "Dia 28" FORMAT "->>>>>>>"
      EvtArti.Canxdia[29] COLUMN-LABEL "Dia 29" FORMAT "->>>>>>>"
      EvtArti.Canxdia[30] COLUMN-LABEL "Dia 30" FORMAT "->>>>>>>"
      EvtArti.Canxdia[31] COLUMN-LABEL "Dia 31" FORMAT "->>>>>>>"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 74.57 BY 4.58
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
   External Tables: INTEGRAL.Almdmov
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
         HEIGHT             = 4.69
         WIDTH              = 74.57.
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
     _TblList          = "REPORTE.EvtArti WHERE INTEGRAL.Almdmov <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "REPORTE.EvtArti.CodCia = S-CODCIA
 AND REPORTE.EvtArti.CodDiv = S-CODDIV
 AND REPORTE.EvtArti.codmat = Integral.Almdmov.CodMat
 AND REPORTE.EvtArti.Nrofch >= X-NROFCH"
     _FldNameList[1]   = REPORTE.EvtArti.Codano
     _FldNameList[2]   = REPORTE.EvtArti.Codmes
     _FldNameList[3]   > REPORTE.EvtArti.Canxdia[1]
"REPORTE.EvtArti.Canxdia[1]" "Dia 01" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[4]   > REPORTE.EvtArti.Canxdia[2]
"REPORTE.EvtArti.Canxdia[2]" "Dia 02" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[5]   > REPORTE.EvtArti.Canxdia[3]
"REPORTE.EvtArti.Canxdia[3]" "Dia 03" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[6]   > REPORTE.EvtArti.Canxdia[4]
"REPORTE.EvtArti.Canxdia[4]" "Dia 04" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[7]   > REPORTE.EvtArti.Canxdia[5]
"REPORTE.EvtArti.Canxdia[5]" "Dia 05" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[8]   > REPORTE.EvtArti.Canxdia[6]
"REPORTE.EvtArti.Canxdia[6]" "Dia 06" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[9]   > REPORTE.EvtArti.Canxdia[7]
"REPORTE.EvtArti.Canxdia[7]" "Dia 07" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[10]   > REPORTE.EvtArti.Canxdia[8]
"REPORTE.EvtArti.Canxdia[8]" "Dia 08" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[11]   > REPORTE.EvtArti.Canxdia[9]
"REPORTE.EvtArti.Canxdia[9]" "Dia 09" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[12]   > REPORTE.EvtArti.Canxdia[10]
"REPORTE.EvtArti.Canxdia[10]" "Dia 10" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[13]   > REPORTE.EvtArti.Canxdia[11]
"REPORTE.EvtArti.Canxdia[11]" "Dia 11" "->>>>>>>" "decimal" ? 9 ? ? ? ? no ?
     _FldNameList[14]   > REPORTE.EvtArti.Canxdia[12]
"REPORTE.EvtArti.Canxdia[12]" "Dia 12" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[15]   > REPORTE.EvtArti.Canxdia[13]
"REPORTE.EvtArti.Canxdia[13]" "Dia 13" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[16]   > REPORTE.EvtArti.Canxdia[14]
"REPORTE.EvtArti.Canxdia[14]" "Dia 14" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[17]   > REPORTE.EvtArti.Canxdia[15]
"REPORTE.EvtArti.Canxdia[15]" "Dia 15" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[18]   > REPORTE.EvtArti.Canxdia[16]
"REPORTE.EvtArti.Canxdia[16]" "Dia 16" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[19]   > REPORTE.EvtArti.Canxdia[17]
"REPORTE.EvtArti.Canxdia[17]" "Dia 17" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[20]   > REPORTE.EvtArti.Canxdia[18]
"REPORTE.EvtArti.Canxdia[18]" "Dia 18" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[21]   > REPORTE.EvtArti.Canxdia[19]
"REPORTE.EvtArti.Canxdia[19]" "Dia 19" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[22]   > REPORTE.EvtArti.Canxdia[20]
"REPORTE.EvtArti.Canxdia[20]" "Dia 20" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[23]   > REPORTE.EvtArti.Canxdia[21]
"REPORTE.EvtArti.Canxdia[21]" "Dia 21" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[24]   > REPORTE.EvtArti.Canxdia[22]
"REPORTE.EvtArti.Canxdia[22]" "Dia 22" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[25]   > REPORTE.EvtArti.Canxdia[23]
"REPORTE.EvtArti.Canxdia[23]" "Dia 23" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[26]   > REPORTE.EvtArti.Canxdia[24]
"REPORTE.EvtArti.Canxdia[24]" "Dia 24" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[27]   > REPORTE.EvtArti.Canxdia[25]
"REPORTE.EvtArti.Canxdia[25]" "Dia 25" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[28]   > REPORTE.EvtArti.Canxdia[26]
"REPORTE.EvtArti.Canxdia[26]" "Dia 26" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[29]   > REPORTE.EvtArti.Canxdia[27]
"REPORTE.EvtArti.Canxdia[27]" "Dia 27" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[30]   > REPORTE.EvtArti.Canxdia[28]
"REPORTE.EvtArti.Canxdia[28]" "Dia 28" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[31]   > REPORTE.EvtArti.Canxdia[29]
"REPORTE.EvtArti.Canxdia[29]" "Dia 29" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[32]   > REPORTE.EvtArti.Canxdia[30]
"REPORTE.EvtArti.Canxdia[30]" "Dia 30" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[33]   > REPORTE.EvtArti.Canxdia[31]
"REPORTE.EvtArti.Canxdia[31]" "Dia 31" "->>>>>>>" "decimal" ? ? ? ? ? ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartBrowserCues" B-table-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartBrowser,uib,49266
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmbrowser.i}
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


on find of almdmov
do:
x-nrofch = YEAR(Almdmov.fchDoc) * 100 + MONTH(Almdmov.FchDoc) .

end.


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "Almdmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almdmov"}

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
  {src/adm/template/snd-list.i "Almdmov"}
  {src/adm/template/snd-list.i "EvtArti"}

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


