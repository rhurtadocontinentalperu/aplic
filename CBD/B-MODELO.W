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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.


DEFINE VAR RECID-stack AS RECID.

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
&Scoped-define EXTERNAL-TABLES cb-cmdlo
&Scoped-define FIRST-EXTERNAL-TABLE cb-cmdlo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cmdlo.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmdlo

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table cb-dmdlo.Codcta cb-dmdlo.Clfaux ~
cb-dmdlo.Codaux cb-dmdlo.Coddoc cb-dmdlo.Nrodoc cb-dmdlo.Fchdoc ~
cb-dmdlo.TpoItm cb-dmdlo.TpoMov cb-dmdlo.Importe cb-dmdlo.Codref ~
cb-dmdlo.Nroref cb-dmdlo.cco cb-dmdlo.DisCCo cb-dmdlo.tm 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table cb-dmdlo.Codcta ~
cb-dmdlo.Clfaux cb-dmdlo.Codaux cb-dmdlo.Coddoc cb-dmdlo.Nrodoc ~
cb-dmdlo.Fchdoc cb-dmdlo.TpoItm cb-dmdlo.TpoMov cb-dmdlo.Importe ~
cb-dmdlo.Codref cb-dmdlo.Nroref cb-dmdlo.cco cb-dmdlo.DisCCo cb-dmdlo.tm 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table cb-dmdlo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table cb-dmdlo
&Scoped-define QUERY-STRING-br_table FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table cb-dmdlo
&Scoped-define FIRST-TABLE-IN-QUERY-br_table cb-dmdlo


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
      cb-dmdlo SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      cb-dmdlo.Codcta FORMAT "x(12)":U
      cb-dmdlo.Clfaux COLUMN-LABEL "Clf Aux" FORMAT "xxx":U
      cb-dmdlo.Codaux COLUMN-LABEL "Codigo Aux." FORMAT "x(8)":U
      cb-dmdlo.Coddoc FORMAT "x(4)":U
      cb-dmdlo.Nrodoc FORMAT "x(10)":U
      cb-dmdlo.Fchdoc FORMAT "99/99/99":U
      cb-dmdlo.TpoItm FORMAT "x":U
      cb-dmdlo.TpoMov FORMAT "H/D":U
      cb-dmdlo.Importe FORMAT "X(100)":U WIDTH 41.72
      cb-dmdlo.Codref FORMAT "x(4)":U
      cb-dmdlo.Nroref FORMAT "x(10)":U
      cb-dmdlo.cco FORMAT "x(5)":U
      cb-dmdlo.DisCCo FORMAT "X(2)":U
      cb-dmdlo.tm COLUMN-LABEL "Tipo!Monto" FORMAT "99":U
  ENABLE
      cb-dmdlo.Codcta
      cb-dmdlo.Clfaux
      cb-dmdlo.Codaux
      cb-dmdlo.Coddoc
      cb-dmdlo.Nrodoc
      cb-dmdlo.Fchdoc
      cb-dmdlo.TpoItm
      cb-dmdlo.TpoMov
      cb-dmdlo.Importe
      cb-dmdlo.Codref
      cb-dmdlo.Nroref
      cb-dmdlo.cco
      cb-dmdlo.DisCCo
      cb-dmdlo.tm
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 121 BY 10.23
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
   External Tables: integral.cb-cmdlo
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
         HEIGHT             = 10.23
         WIDTH              = 137.86.
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
     _TblList          = "integral.cb-dmdlo Where integral.cb-cmdlo ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "cb-dmdlo.CodMod = cb-cmdlo.CodMod"
     _FldNameList[1]   > integral.cb-dmdlo.Codcta
"cb-dmdlo.Codcta" ? "x(12)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.cb-dmdlo.Clfaux
"cb-dmdlo.Clfaux" "Clf Aux" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.cb-dmdlo.Codaux
"cb-dmdlo.Codaux" "Codigo Aux." ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.cb-dmdlo.Coddoc
"cb-dmdlo.Coddoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.cb-dmdlo.Nrodoc
"cb-dmdlo.Nrodoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.cb-dmdlo.Fchdoc
"cb-dmdlo.Fchdoc" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.cb-dmdlo.TpoItm
"cb-dmdlo.TpoItm" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.cb-dmdlo.TpoMov
"cb-dmdlo.TpoMov" ? ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.cb-dmdlo.Importe
"cb-dmdlo.Importe" ? "X(100)" "character" ? ? ? ? ? ? yes ? no no "41.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.cb-dmdlo.Codref
"cb-dmdlo.Codref" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.cb-dmdlo.Nroref
"cb-dmdlo.Nroref" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > integral.cb-dmdlo.cco
"cb-dmdlo.cco" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > integral.cb-dmdlo.DisCCo
"cb-dmdlo.DisCCo" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > integral.cb-dmdlo.tm
"cb-dmdlo.tm" "Tipo!Monto" "99" "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME cb-dmdlo.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmdlo.Codcta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF cb-dmdlo.Codcta IN BROWSE br_table /* Cuenta */
DO:
  FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                     cb-ctas.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CB-CTAS THEN DO :
     MESSAGE "Cuenta No se encuentra Registrada"
              VIEW-AS ALERT-BOX.                     
     RETURN "NO-APPLY".  
  END.
  ELSE RUN Cfg-Cuenta.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmdlo.Clfaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmdlo.Clfaux br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-dmdlo.Clfaux IN BROWSE br_table /* Clf Aux */
OR "F8":U OF cb-dmdlo.Clfaux
DO:
    RUN cbd/q-clfaux.w("01", OUTPUT RECID-stack).
    IF RECID-stack <> 0 THEN DO:
       FIND cb-tabl WHERE RECID( cb-tabl ) = RECID-stack NO-LOCK  NO-ERROR.
       IF AVAIL cb-tabl THEN DO:
            cb-dmdlo.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = cb-tabl.codigo.
       END.
       ELSE MESSAGE "No existen Registros." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dmdlo.Codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dmdlo.Codaux br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF cb-dmdlo.Codaux IN BROWSE br_table /* Codigo Aux. */
OR "F8":U OF cb-dmdlo.codaux DO:
    DEF VAR T-ROWID AS ROWID.
    DEF VAR T-RECID AS RECID.  
    CASE cb-dmdlo.ClfAux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
    WHEN "@PV"  THEN DO:
        RUN ADM/H-PROV01.W(s-codcia , OUTPUT T-ROWID).
        IF T-ROWID <> ? THEN DO:
           FIND gn-prov WHERE ROWID(gn-prov) = T-ROWID NO-LOCK NO-ERROR.
           IF AVAILABLE gn-prov THEN DO:
              cb-dmdlo.CodAux:SCREEN-VALUE = gn-prov.CodPro.              
           END.
        END.
    END.
    WHEN "@CL" THEN DO:
        RUN ADM/H-CLIE01.W(s-codcia, OUTPUT T-ROWID).    
        IF T-ROWID <> ? THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = T-ROWID NO-LOCK NO-ERROR.
            IF AVAIL gn-clie THEN DO:
               cb-dmdlo.CodAux:SCREEN-VALUE = gn-clie.CodCli.
            END.
        END.
    END.
    OTHERWISE DO:
        RUN CBD/H-AUXI01(s-codcia,cb-dmdlo.ClfAux:SCREEN-VALUE, OUTPUT T-ROWID ).     
        IF T-ROWID <> ?
        THEN DO:
            FIND cb-auxi WHERE ROWID(cb-auxi) = T-ROWID NO-LOCK  NO-ERROR.
            IF AVAIL cb-auxi
            THEN DO:
                cb-dmdlo.Codaux:SCREEN-VALUE = cb-auxi.CodAux.
            END.
        END.
    END.
    END CASE.
    RETURN NO-APPLY.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF cb-dmdlo.cco, cb-dmdlo.Clfaux, cb-dmdlo.Codaux, cb-dmdlo.Codcta, 
                 cb-dmdlo.Coddoc, cb-dmdlo.Codref, cb-dmdlo.DisCCo, cb-dmdlo.Fchdoc, 
                 cb-dmdlo.Importe, cb-dmdlo.Nrodoc, cb-dmdlo.Nroref, cb-dmdlo.tm, 
                 cb-dmdlo.TpoItm, cb-dmdlo.TpoMov 
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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
  {src/adm/template/row-list.i "cb-cmdlo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cmdlo"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-CodAux B-table-Win 
PROCEDURE Cfg-CodAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE cb-dmdlo.ClfAux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}:
     WHEN "@PV" THEN DO:
          FIND gn-prov WHERE gn-prov.CodCia = pv-codcia AND
                             gn-prov.CodPro = cb-dmdlo.CodAux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                             NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN RETURN ERROR.
     END.
     WHEN "@CL" THEN DO:
          FIND gn-clie WHERE gn-clie.CodCia = cl-codcia AND
                             gn-clie.CodCli = cb-dmdlo.CodAux:SCREEN-VALUE  IN BROWSE {&BROWSE-NAME}
                             NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clie THEN RETURN ERROR.
     END.
     OTHERWISE DO:
          FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia AND
                             cb-auxi.ClfAux = cb-dmdlo.ClfAux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} AND
                             cb-auxi.CodAux = cb-dmdlo.CodAux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                             NO-LOCK NO-ERROR.
          IF NOT AVAILABLE cb-auxi THEN RETURN ERROR. 
     END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cfg-Cuenta B-table-Win 
PROCEDURE Cfg-Cuenta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF cb-ctas.PidAux THEN DO :
   IF cb-ctas.ClfAux <> cb-dmdlo.Clfaux:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      THEN DISPLAY cb-ctas.ClfAux @ cb-dmdlo.Clfaux WITH BROWSE {&BROWSE-NAME}.
          
       ASSIGN cb-dmdlo.CodAux:READ-ONLY = NO.   
       ASSIGN cb-dmdlo.ClfAux:READ-ONLY = NO.
       DO ON ERROR UNDO,LEAVE:
          RUN Cfg-CodAux.
       END.
                          
    END.
    ELSE DO:
       ASSIGN
         cb-dmdlo.ClfAux:READ-ONLY = YES
         cb-dmdlo.CodAux:READ-ONLY = YES.
    END.
    
    cb-dmdlo.TpoMov:SCREEN-VALUE = STRING(cb-ctas.MovCta,"H/D"). 
    
    IF cb-ctas.Pidcco THEN 
       ASSIGN cb-dmdlo.cco:READ-ONLY = NO
              cb-dmdlo.DisCco:READ-ONLY = NO.
              
    ELSE ASSIGN cb-dmdlo.Cco:READ-ONLY  = YES
                cb-dmdlo.DisCco:READ-ONLY = YES.
                
    IF cb-ctas.PidDoc THEN DO:
        IF cb-dmdlo.CodDoc:SCREEN-VALUE = ""
        THEN DISPLAY cb-ctas.CodDoc @ cb-dmdlo.CodDoc WITH BROWSE {&BROWSE-NAME}.
        ASSIGN cb-dmdlo.CodDoc:READ-ONLY = NO               
               cb-dmdlo.NroDoc:READ-ONLY = NO
               cb-dmdlo.FchDoc:READ-ONLY = NO.
    END.
    ELSE DO:
        ASSIGN cb-dmdlo.CodDoc:READ-ONLY = YES              
               cb-dmdlo.NroDoc:READ-ONLY = YES
               cb-dmdlo.FchDoc:READ-ONLY = YES.        
    END.
    IF cb-ctas.PidRef THEN ASSIGN cb-dmdlo.NroRef:READ-ONLY = NO
                                  cb-dmdlo.CodRef:READ-ONLY = NO.
    ELSE ASSIGN cb-dmdlo.NroRef:READ-ONLY = YES
                cb-dmdlo.CodRef:READ-ONLY = YES.
                cb-dmdlo.NroRef:SCREEN-VALUE = "".
    
    
    IF cb-dmdlo.TM:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN
       DISPLAY cb-ctas.TM @ cb-dmdlo.TM WITH BROWSE {&BROWSE-NAME}.
                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN cb-dmdlo.CodMod = cb-cmdlo.CodMod.

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
        WHEN "cco" THEN ASSIGN input-var-1 = "CCO".
        WHEN "Coddoc" THEN ASSIGN input-var-1 = "02".
        WHEN "CodRef" THEN ASSIGN input-var-1 = "02".
        WHEN "DisCCo" THEN ASSIGN input-var-1 = "15".
        WHEN "tm" THEN ASSIGN input-var-1 = "05".   
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
  {src/adm/template/snd-list.i "cb-cmdlo"}
  {src/adm/template/snd-list.i "cb-dmdlo"}

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
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

