&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

DEF VAR pv-codcia AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
&Scoped-define INTERNAL-TABLES FacCtPro gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCtPro.CodPro gn-prov.NomPro ~
FacCtPro.Categoria FacCtPro.Dsctos[1] FacCtPro.Dsctos[2] FacCtPro.Dsctos[3] ~
FacCtPro.Dsctos[4] FacCtPro.Dsctos[5] FacCtPro.Dsctos[6] FacCtPro.Dsctos[7] ~
FacCtPro.Dsctos[8] FacCtPro.Dsctos[9] FacCtPro.Dsctos[10] ~
FacCtPro.Dsctos[11] FacCtPro.Dsctos[12] FacCtPro.Dsctos[13] ~
FacCtPro.Dsctos[14] FacCtPro.Dsctos[15] FacCtPro.Dsctos[16] ~
FacCtPro.Dsctos[17] FacCtPro.Dsctos[18] FacCtPro.Dsctos[19] ~
FacCtPro.Dsctos[20] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacCtPro.CodPro ~
FacCtPro.Categoria FacCtPro.Dsctos[1] FacCtPro.Dsctos[2] FacCtPro.Dsctos[3] ~
FacCtPro.Dsctos[4] FacCtPro.Dsctos[5] FacCtPro.Dsctos[6] FacCtPro.Dsctos[7] ~
FacCtPro.Dsctos[8] FacCtPro.Dsctos[9] FacCtPro.Dsctos[10] ~
FacCtPro.Dsctos[11] FacCtPro.Dsctos[12] FacCtPro.Dsctos[13] ~
FacCtPro.Dsctos[14] FacCtPro.Dsctos[15] FacCtPro.Dsctos[16] ~
FacCtPro.Dsctos[17] FacCtPro.Dsctos[18] FacCtPro.Dsctos[19] ~
FacCtPro.Dsctos[20] 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}Categoria ~{&FP2}Categoria ~{&FP3}~
 ~{&FP1}Dsctos[1] ~{&FP2}Dsctos[1] ~{&FP3}~
 ~{&FP1}Dsctos[2] ~{&FP2}Dsctos[2] ~{&FP3}~
 ~{&FP1}Dsctos[3] ~{&FP2}Dsctos[3] ~{&FP3}~
 ~{&FP1}Dsctos[4] ~{&FP2}Dsctos[4] ~{&FP3}~
 ~{&FP1}Dsctos[5] ~{&FP2}Dsctos[5] ~{&FP3}~
 ~{&FP1}Dsctos[6] ~{&FP2}Dsctos[6] ~{&FP3}~
 ~{&FP1}Dsctos[7] ~{&FP2}Dsctos[7] ~{&FP3}~
 ~{&FP1}Dsctos[8] ~{&FP2}Dsctos[8] ~{&FP3}~
 ~{&FP1}Dsctos[9] ~{&FP2}Dsctos[9] ~{&FP3}~
 ~{&FP1}Dsctos[10] ~{&FP2}Dsctos[10] ~{&FP3}~
 ~{&FP1}Dsctos[11] ~{&FP2}Dsctos[11] ~{&FP3}~
 ~{&FP1}Dsctos[12] ~{&FP2}Dsctos[12] ~{&FP3}~
 ~{&FP1}Dsctos[13] ~{&FP2}Dsctos[13] ~{&FP3}~
 ~{&FP1}Dsctos[14] ~{&FP2}Dsctos[14] ~{&FP3}~
 ~{&FP1}Dsctos[15] ~{&FP2}Dsctos[15] ~{&FP3}~
 ~{&FP1}Dsctos[16] ~{&FP2}Dsctos[16] ~{&FP3}~
 ~{&FP1}Dsctos[17] ~{&FP2}Dsctos[17] ~{&FP3}~
 ~{&FP1}Dsctos[18] ~{&FP2}Dsctos[18] ~{&FP3}~
 ~{&FP1}Dsctos[19] ~{&FP2}Dsctos[19] ~{&FP3}~
 ~{&FP1}Dsctos[20] ~{&FP2}Dsctos[20] ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacCtPro
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacCtPro
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCtPro WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = pv-codcia ~
  AND gn-prov.CodPro = FacCtPro.CodPro NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCtPro gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCtPro


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
      FacCtPro, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCtPro.CodPro COLUMN-LABEL "<Proveedor>"
      gn-prov.NomPro
      FacCtPro.Categoria FORMAT "x(2)"
      FacCtPro.Dsctos[1] COLUMN-LABEL "Dsctos A" COLUMN-BGCOLOR 14
      FacCtPro.Dsctos[2] COLUMN-LABEL "Dsctos A" COLUMN-BGCOLOR 14
      FacCtPro.Dsctos[3] COLUMN-LABEL "Dsctos A" COLUMN-BGCOLOR 14
      FacCtPro.Dsctos[4] COLUMN-LABEL "Dsctos A" COLUMN-BGCOLOR 14
      FacCtPro.Dsctos[5] COLUMN-LABEL "Dsctos B" COLUMN-BGCOLOR 11
      FacCtPro.Dsctos[6] COLUMN-LABEL "Dsctos B" COLUMN-BGCOLOR 11
      FacCtPro.Dsctos[7] COLUMN-LABEL "Dsctos B" COLUMN-BGCOLOR 11
      FacCtPro.Dsctos[8] COLUMN-LABEL "Dsctos B" COLUMN-BGCOLOR 11
      FacCtPro.Dsctos[9] COLUMN-LABEL "Dsctos C" COLUMN-BGCOLOR 10
      FacCtPro.Dsctos[10] COLUMN-LABEL "Dsctos C" COLUMN-BGCOLOR 10
      FacCtPro.Dsctos[11] COLUMN-LABEL "Dsctos C" COLUMN-BGCOLOR 10
      FacCtPro.Dsctos[12] COLUMN-LABEL "Dsctos C" COLUMN-BGCOLOR 10
      FacCtPro.Dsctos[13] COLUMN-LABEL "Dsctos D" COLUMN-BGCOLOR 13
      FacCtPro.Dsctos[14] COLUMN-LABEL "Dsctos D" COLUMN-BGCOLOR 13
      FacCtPro.Dsctos[15] COLUMN-LABEL "Dsctos D" COLUMN-BGCOLOR 13
      FacCtPro.Dsctos[16] COLUMN-LABEL "Dsctos D" COLUMN-BGCOLOR 13
      FacCtPro.Dsctos[17] COLUMN-LABEL "Dsctos E"
      FacCtPro.Dsctos[18] COLUMN-LABEL "Dsctos E"
      FacCtPro.Dsctos[19] COLUMN-LABEL "Dsctos E"
      FacCtPro.Dsctos[20] COLUMN-LABEL "Dsctos E"
  ENABLE
      FacCtPro.CodPro
      FacCtPro.Categoria
      FacCtPro.Dsctos[1]
      FacCtPro.Dsctos[2]
      FacCtPro.Dsctos[3]
      FacCtPro.Dsctos[4]
      FacCtPro.Dsctos[5]
      FacCtPro.Dsctos[6]
      FacCtPro.Dsctos[7]
      FacCtPro.Dsctos[8]
      FacCtPro.Dsctos[9]
      FacCtPro.Dsctos[10]
      FacCtPro.Dsctos[11]
      FacCtPro.Dsctos[12]
      FacCtPro.Dsctos[13]
      FacCtPro.Dsctos[14]
      FacCtPro.Dsctos[15]
      FacCtPro.Dsctos[16]
      FacCtPro.Dsctos[17]
      FacCtPro.Dsctos[18]
      FacCtPro.Dsctos[19]
      FacCtPro.Dsctos[20]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 140 BY 12.69
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
         HEIGHT             = 12.73
         WIDTH              = 141.43.
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
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCtPro,INTEGRAL.gn-prov WHERE INTEGRAL.FacCtPro ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[2]      = "gn-prov.CodCia = pv-codcia
  AND gn-prov.CodPro = FacCtPro.CodPro"
     _FldNameList[1]   > INTEGRAL.FacCtPro.CodPro
"FacCtPro.CodPro" "<Proveedor>" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   = INTEGRAL.gn-prov.NomPro
     _FldNameList[3]   > INTEGRAL.FacCtPro.Categoria
"FacCtPro.Categoria" ? "x(2)" "character" ? ? ? ? ? ? yes ?
     _FldNameList[4]   > INTEGRAL.FacCtPro.Dsctos[1]
"FacCtPro.Dsctos[1]" "Dsctos A" ? "decimal" 14 ? ? ? ? ? yes ?
     _FldNameList[5]   > INTEGRAL.FacCtPro.Dsctos[2]
"FacCtPro.Dsctos[2]" "Dsctos A" ? "decimal" 14 ? ? ? ? ? yes ?
     _FldNameList[6]   > INTEGRAL.FacCtPro.Dsctos[3]
"FacCtPro.Dsctos[3]" "Dsctos A" ? "decimal" 14 ? ? ? ? ? yes ?
     _FldNameList[7]   > INTEGRAL.FacCtPro.Dsctos[4]
"FacCtPro.Dsctos[4]" "Dsctos A" ? "decimal" 14 ? ? ? ? ? yes ?
     _FldNameList[8]   > INTEGRAL.FacCtPro.Dsctos[5]
"FacCtPro.Dsctos[5]" "Dsctos B" ? "decimal" 11 ? ? ? ? ? yes ?
     _FldNameList[9]   > INTEGRAL.FacCtPro.Dsctos[6]
"FacCtPro.Dsctos[6]" "Dsctos B" ? "decimal" 11 ? ? ? ? ? yes ?
     _FldNameList[10]   > INTEGRAL.FacCtPro.Dsctos[7]
"FacCtPro.Dsctos[7]" "Dsctos B" ? "decimal" 11 ? ? ? ? ? yes ?
     _FldNameList[11]   > INTEGRAL.FacCtPro.Dsctos[8]
"FacCtPro.Dsctos[8]" "Dsctos B" ? "decimal" 11 ? ? ? ? ? yes ?
     _FldNameList[12]   > INTEGRAL.FacCtPro.Dsctos[9]
"FacCtPro.Dsctos[9]" "Dsctos C" ? "decimal" 10 ? ? ? ? ? yes ?
     _FldNameList[13]   > INTEGRAL.FacCtPro.Dsctos[10]
"FacCtPro.Dsctos[10]" "Dsctos C" ? "decimal" 10 ? ? ? ? ? yes ?
     _FldNameList[14]   > INTEGRAL.FacCtPro.Dsctos[11]
"FacCtPro.Dsctos[11]" "Dsctos C" ? "decimal" 10 ? ? ? ? ? yes ?
     _FldNameList[15]   > INTEGRAL.FacCtPro.Dsctos[12]
"FacCtPro.Dsctos[12]" "Dsctos C" ? "decimal" 10 ? ? ? ? ? yes ?
     _FldNameList[16]   > INTEGRAL.FacCtPro.Dsctos[13]
"FacCtPro.Dsctos[13]" "Dsctos D" ? "decimal" 13 ? ? ? ? ? yes ?
     _FldNameList[17]   > INTEGRAL.FacCtPro.Dsctos[14]
"FacCtPro.Dsctos[14]" "Dsctos D" ? "decimal" 13 ? ? ? ? ? yes ?
     _FldNameList[18]   > INTEGRAL.FacCtPro.Dsctos[15]
"FacCtPro.Dsctos[15]" "Dsctos D" ? "decimal" 13 ? ? ? ? ? yes ?
     _FldNameList[19]   > INTEGRAL.FacCtPro.Dsctos[16]
"FacCtPro.Dsctos[16]" "Dsctos D" ? "decimal" 13 ? ? ? ? ? yes ?
     _FldNameList[20]   > INTEGRAL.FacCtPro.Dsctos[17]
"FacCtPro.Dsctos[17]" "Dsctos E" ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[21]   > INTEGRAL.FacCtPro.Dsctos[18]
"FacCtPro.Dsctos[18]" "Dsctos E" ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[22]   > INTEGRAL.FacCtPro.Dsctos[19]
"FacCtPro.Dsctos[19]" "Dsctos E" ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[23]   > INTEGRAL.FacCtPro.Dsctos[20]
"FacCtPro.Dsctos[20]" "Dsctos E" ? "decimal" ? ? ? ? ? ? yes ?
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


&Scoped-define SELF-NAME FacCtPro.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCtPro.CodPro br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacCtPro.CodPro IN BROWSE br_table /* <Proveedor> */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia 
    AND Gn-prov.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov 
  THEN DISPLAY Gn-prov.nompro WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF FacCtPro.Categoria, FacCtPro.CodPro, 
    FacCtPro.Dsctos[1], FacCtPro.Dsctos[10], FacCtPro.Dsctos[11], 
    FacCtPro.Dsctos[2], FacCtPro.Dsctos[3], FacCtPro.Dsctos[4], 
    FacCtPro.Dsctos[5], FacCtPro.Dsctos[6], FacCtPro.Dsctos[7], 
    FacCtPro.Dsctos[8], FacCtPro.Dsctos[9] DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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
    FacCtPro.CodCia = s-codcia.

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
  {src/adm/template/snd-list.i "FacCtPro"}
  {src/adm/template/snd-list.i "gn-prov"}

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
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia 
    AND Gn-prov.codpro = FacCtPro.CodPro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Gn-prov THEN DO:
    MESSAGE 'Provedor no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF FacCtPro.Categoria:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
    MESSAGE 'Ingrese la categoria' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
/*  IF LOOKUP(FacCtPro.Categoria:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}, '1,2,3,4,5') = 0
 *   THEN DO:
 *     MESSAGE 'La Categoria debe ser: 1, 2, 3, 4 ó 5' VIEW-AS ALERT-BOX ERROR.
 *     RETURN 'ADM-ERROR'.
 *   END.*/
  
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


