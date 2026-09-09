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


/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE BUFFER TFAMI FOR AlmtFami.
DEFINE BUFFER SFAMI FOR AlmsFami.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Familias".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

DEF VAR S-CODFAM AS CHARACTER.

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
&Scoped-define EXTERNAL-TABLES Almtfami
&Scoped-define FIRST-EXTERNAL-TABLE Almtfami


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almtfami.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmSFami.subfam AlmSFami.dessub ~
AlmSFami.Orden AlmSFami.SwDigesa AlmSFami.Libre_c05 AlmSFami.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table AlmSFami.subfam ~
AlmSFami.dessub AlmSFami.Orden AlmSFami.SwDigesa AlmSFami.Libre_c05 ~
AlmSFami.Libre_c04 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table AlmSFami
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table AlmSFami
&Scoped-define QUERY-STRING-br_table FOR EACH AlmSFami WHERE AlmSFami.CodCia = Almtfami.CodCia ~
  AND AlmSFami.codfam = Almtfami.codfam NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmSFami WHERE AlmSFami.CodCia = Almtfami.CodCia ~
  AND AlmSFami.codfam = Almtfami.codfam NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmSFami


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
      AlmSFami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmSFami.subfam FORMAT "X(3)":U
      AlmSFami.dessub FORMAT "X(40)":U
      AlmSFami.Orden FORMAT ">>>9":U
      AlmSFami.SwDigesa COLUMN-LABEL "Switch Digesa" FORMAT "yes/no":U
            VIEW-AS TOGGLE-BOX
      AlmSFami.Libre_c05 COLUMN-LABEL "Afecto a!Percepción" FORMAT "x(3)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "SI","NO" 
                      DROP-DOWN-LIST 
      AlmSFami.Libre_c04 COLUMN-LABEL "Descuento x Volumen!Agrupados" FORMAT "x(2)":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "No","",
                                      "Si","Si"
                      DROP-DOWN-LIST 
  ENABLE
      AlmSFami.subfam
      AlmSFami.dessub
      AlmSFami.Orden
      AlmSFami.SwDigesa
      AlmSFami.Libre_c05
      AlmSFami.Libre_c04
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 78 BY 12.5
         BGCOLOR 15 FONT 4
         TITLE BGCOLOR 15 "Sub-Familias" FIT-LAST-COLUMN.


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
   External Tables: integral.Almtfami
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
         HEIGHT             = 12.54
         WIDTH              = 89.72.
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
     _TblList          = "integral.AlmSFami Where integral.Almtfami ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "AlmSFami.CodCia = Almtfami.CodCia
  AND AlmSFami.codfam = Almtfami.codfam"
     _FldNameList[1]   > integral.AlmSFami.subfam
"AlmSFami.subfam" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.AlmSFami.dessub
"AlmSFami.dessub" ? "X(40)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.AlmSFami.Orden
"AlmSFami.Orden" ? ">>>9" "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.AlmSFami.SwDigesa
"AlmSFami.SwDigesa" "Switch Digesa" ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[5]   > integral.AlmSFami.Libre_c05
"AlmSFami.Libre_c05" "Afecto a!Percepción" "x(3)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," "SI,NO" ? 5 no 0 no no
     _FldNameList[6]   > integral.AlmSFami.Libre_c04
"AlmSFami.Libre_c04" "Descuento x Volumen!Agrupados" "x(2)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "No,,Si,Si" 5 no 0 no no
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
ON ANY-PRINTABLE OF br_table IN FRAME F-Main /* Sub-Familias */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Sub-Familias */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  RUN get-attribute ("ADM-NEW-RECORD":U).
  IF RETURN-VALUE = 'NO':U THEN DO:  
     almsfami.subfam:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
     APPLY "ENTRY":U TO almsfami.dessub.
  END.
  ELSE DO:
       almsfami.subfam:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
       APPLY "ENTRY":U TO almsfami.subfam. 
  END.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Sub-Familias */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Sub-Familias */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  S-CODFAM = ALMTFAMI.CODFAM.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


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
  {src/adm/template/row-list.i "Almtfami"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almtfami"}

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
      AlmSFami.CodCia = AlmTFami.CodCia 
      AlmSFami.codfam = AlmTFami.codfam.

  /* DESCUENTO POR VOLUMEN X SUBFAMILIA */
  FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND
      FacTabla.Codigo = TRIM(Almsfami.codfam) + TRIM(almsfami.subfam) AND
      FacTabla.Tabla = "DVXSF"
      NO-LOCK NO-ERROR.
  IF AlmSFami.Libre_c04 = "Si" THEN DO:
      IF NOT AVAILABLE FacTabla THEN DO:
          CREATE FacTabla.
          ASSIGN
              FacTabla.CodCia = s-codcia 
              FacTabla.Codigo = TRIM(Almsfami.codfam) + TRIM(almsfami.subfam) 
              FacTabla.Tabla = "DVXSF".
      END.
  END.
  ELSE DO:
      IF AVAILABLE FacTabla THEN DO:
          FIND CURRENT FacTabla EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
          IF AVAILABLE FacTabla THEN DELETE FacTabla.
      END.
  END.
  RELEASE FacTabla.
  RUN Procesa-Handle IN lh_handle ("Pinta-Volumen").

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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */

/*MLR* 08/11/07 ***
/*    RB-FILTER = "AlmSfami.CodCia = " + string(S-CODCIA) +
                " AND AlmSfami.codfam = '" + AlmtFami.codfam + "'".*/
  
    RB-OTHER-PARAMETERS = "GsNomCia = " + s-nomcia.

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            
* ***/

/*DEF VAR I AS INTEGER.
  DEF VAR x-Ok AS LOG NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*    RB-OTHER-PARAMETERS = "GsNomCia = " + s-nomcia.

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
    RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            
*/

  /*FOR EACH AlmSFami WHERE AlmSFami.CodCia = Almtfami.CodCia 
      AND  AlmSFami.codfam = Almtfami.codfam NO-LOCK:
           RUN ALM\r-fam(ROWID(AlmSFami), AlmSFami.subfam).
  END.   */

 
/*FOR EACH Almtfami WHERE Almtfami.codcia = s-codcia NO-LOCK:*/
    FOR EACH AlmSFami WHERE AlmSFami.CodCia = Almtfami.codcia AND 
        AlmSFami.CodFam = Almtfami.CodFam NO-LOCK :
        RUN ALM\r-fam(ROWID(AlmSFami), AlmSFami.subfam).
    END.
/*END.*/
 /*FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodFam = X-CodFam,
    EACH AlmSFami NO-LOCK WHERE AlmSFami.CodFam = Almtfami.CodFam*/*/
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
  {src/adm/template/snd-list.i "Almtfami"}
  {src/adm/template/snd-list.i "AlmSFami"}

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
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'Yes' THEN DO:
   FIND SFAMI WHERE SFAMI.CodCia = s-codcia AND
        SFAMI.codfam = AlmtFami.Codfam  AND
        SFAMI.Orden  = INTEGER(AlmsFami.orden:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
        NO-LOCK NO-ERROR.
   IF AVAILABLE SFAMI THEN DO:
      MESSAGE 'Orden ya existe' VIEW-AS ALERT-BOX ERROR. 
      RETURN "ADM-ERROR".
   END.
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

