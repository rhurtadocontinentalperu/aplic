&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DOSER LIKE lg-doser.



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
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-aftigv AS LOG.

DEF VAR x-NroItm AS INT NO-UNDO.
DEF VAR s-PorIgv AS DEC INIT 0 NO-UNDO.

DEF BUFFER B-DOSER FOR T-DOSER.

DEF SHARED VAR s-coddoc AS CHAR.

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-DOSER

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-DOSER.codser T-DOSER.desser ~
T-DOSER.DisCCo T-DOSER.CCo T-DOSER.CanAten T-DOSER.UndCmp T-DOSER.PreUni ~
T-DOSER.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-DOSER.codser ~
T-DOSER.desser T-DOSER.DisCCo T-DOSER.CCo T-DOSER.CanAten T-DOSER.UndCmp ~
T-DOSER.PreUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-DOSER
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-DOSER
&Scoped-define QUERY-STRING-br_table FOR EACH T-DOSER WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY T-DOSER.Nroitm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-DOSER WHERE ~{&KEY-PHRASE} NO-LOCK ~
    BY T-DOSER.Nroitm.
&Scoped-define TABLES-IN-QUERY-br_table T-DOSER
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-DOSER


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpNet FILL-IN-ImpIgv ~
FILL-IN-ImpTot 

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
DEFINE VARIABLE FILL-IN-ImpIgv AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpNet AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.92
     BGCOLOR 1 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-DOSER SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-DOSER.codser FORMAT "X(8)":U
      T-DOSER.desser FORMAT "X(60)":U LABEL-FONT 4
      T-DOSER.DisCCo COLUMN-LABEL "Cod.!Dist." FORMAT "999":U
      T-DOSER.CCo COLUMN-LABEL "CCosto" FORMAT "X(5)":U
      T-DOSER.CanAten COLUMN-LABEL "Cantidad" FORMAT "ZZZZZ9.99":U
      T-DOSER.UndCmp COLUMN-LABEL "Und" FORMAT "X(3)":U
      T-DOSER.PreUni COLUMN-LABEL "P.Unitario" FORMAT ">>>>>9.9999":U
      T-DOSER.ImpTot FORMAT ">>>,>>9.99":U
  ENABLE
      T-DOSER.codser
      T-DOSER.desser
      T-DOSER.DisCCo
      T-DOSER.CCo
      T-DOSER.CanAten
      T-DOSER.UndCmp
      T-DOSER.PreUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 112 BY 7.12
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpNet AT ROW 8.88 COL 66 COLON-ALIGNED NO-LABEL
     FILL-IN-ImpIgv AT ROW 8.88 COL 81 COLON-ALIGNED NO-LABEL
     FILL-IN-ImpTot AT ROW 8.88 COL 96 COLON-ALIGNED NO-LABEL
     "TOTAL" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 8.31 COL 102
          BGCOLOR 1 FGCOLOR 15 
     "HAZ DOBLE CLIC EN EL REGISTRO PARA INGRESAR EL DETALLE" VIEW-AS TEXT
          SIZE 49 BY .5 AT ROW 8.12 COL 1
          BGCOLOR 15 FGCOLOR 1 
     "NETO" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 8.31 COL 75
          BGCOLOR 1 FGCOLOR 15 
     "IGV" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 8.31 COL 88
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 8.12 COL 37
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
   Temp-Tables and Buffers:
      TABLE: T-DOSER T "SHARED" ? INTEGRAL lg-doser
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
         HEIGHT             = 9.92
         WIDTH              = 112.43.
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
/* BROWSE-TAB br_table TEXT-4 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 2.

/* SETTINGS FOR FILL-IN FILL-IN-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpNet IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-DOSER"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "Temp-Tables.T-DOSER.Nroitm|yes"
     _FldNameList[1]   > Temp-Tables.T-DOSER.codser
"T-DOSER.codser" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DOSER.desser
"T-DOSER.desser" ? "X(60)" "character" ? ? ? ? ? 4 yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DOSER.DisCCo
"T-DOSER.DisCCo" "Cod.!Dist." ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DOSER.CCo
"T-DOSER.CCo" "CCosto" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DOSER.CanAten
"T-DOSER.CanAten" "Cantidad" "ZZZZZ9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DOSER.UndCmp
"T-DOSER.UndCmp" "Und" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-DOSER.PreUni
"T-DOSER.PreUni" "P.Unitario" ">>>>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-DOSER.ImpTot
"T-DOSER.ImpTot" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE T-DOSER
  THEN CASE s-coddoc:
            WHEN 'O/S' THEN RUN lgc/d-ordser (ROWID(T-DOSER)).
            WHEN 'OCA' THEN RUN lgc/d-ordadm (ROWID(T-DOSER)).
        END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN ASSIGN
        T-DOSER.DisCCo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '000'.
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


&Scoped-define SELF-NAME T-DOSER.codser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DOSER.codser br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DOSER.codser IN BROWSE br_table /* Código */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  /*T-DOSER.desser:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.*/
  FIND lg-serv WHERE lg-serv.coddoc = s-coddoc
    AND LG-SERV.codser = SELF:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF AVAILABLE lg-serv AND T-DOSER.desser:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
  THEN T-DOSER.desser:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = LG-SERV.desser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DOSER.UndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DOSER.UndCmp br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DOSER.UndCmp IN BROWSE br_table /* Und */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME T-DOSER.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL T-DOSER.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF T-DOSER.PreUni IN BROWSE br_table /* P.Unitario */
DO:
  T-DOSER.imptot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(
    DECIMAL(T-DOSER.CanAten:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) *
    DECIMAL(T-DOSER.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF T-DOSER.CanAten, T-DOSER.CCo,
    T-DOSER.codser, T-DOSER.desser, T-DOSER.DisCCo,
    T-DOSER.PreUni, T-DOSER.UndCmp DO:
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Totales B-table-Win 
PROCEDURE Calcula-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    FILL-IN-ImpIgv = 0
    FILL-IN-ImpNet = 0
    FILL-IN-ImpTot = 0.
  FOR EACH T-DOSER:
    ASSIGN
      FILL-IN-ImpTot = FILL-IN-ImpTot + T-DOSER.ImpTot
      FILL-IN-ImpIgv = FILL-IN-ImpIgv + T-DOSER.ImpIgv.
  END.
  FILL-IN-ImpNet = FILL-IN-ImpTot - FILL-IN-ImpIgv.
  DISPLAY FILL-IN-ImpIgv FILL-IN-ImpNet FILL-IN-ImpTot
    WITH FRAME {&FRAME-NAME}.

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
  s-PorIgv = T-DOSER.IgvMat.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DO:
    FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.
    IF AVAILABLE Faccfggn THEN s-PorIgv = Faccfggn.porigv.
  END.
  ASSIGN
    T-DOSER.ImpTot = T-DOSER.canaten * T-DOSER.preuni
    T-DOSER.AftIgv = s-AftIgv
    T-DOSER.IgvMat = ( IF s-AftIgv = YES THEN s-PorIgv ELSE 0 )
    T-DOSER.ImpIgv = T-DOSER.imptot / (1 + T-DOSER.igvmat / 100) * T-DOSER.igvmat / 100.
  RUN Calcula-Totales.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record B-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  x-NroItm = 1.
  FOR EACH B-DOSER NO-LOCK BY B-DOSER.NroItm.
    x-NroItm = B-DOSER.NroItm + 1.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  T-DOSER.NroItm = x-NroItm.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Calcula-Totales.

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
        WHEN "CodSer" THEN ASSIGN
                            input-var-1 = s-coddoc
                            input-var-2 = ""
                            input-var-3 = "".
        WHEN "DisCco" THEN ASSIGN
                            input-var-1 = "15"
                            input-var-2 = ""
                            input-var-3 = "".
        WHEN "Cco" THEN ASSIGN
                            input-var-1 = "CCO"
                            input-var-2 = ""
                            input-var-3 = "".
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
  {src/adm/template/snd-list.i "T-DOSER"}

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
  FIND lg-serv WHERE LG-SERV.coddoc = s-coddoc
    AND LG-SERV.codser = T-DOSER.codser:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE lg-serv
  THEN DO:
    MESSAGE 'Codigo del servicio no registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  FIND CB-TABL WHERE cb-tabl.tabla = '15'
    AND cb-tabl.codigo = T-DOSER.DisCCo:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CB-TABL
  THEN DO:
    MESSAGE 'Codigo de distribucion no registrado' VIEW-AS ALERT-BOX.
    RETURN 'ADM-ERROR'.
  END.
  IF T-DOSER.Cco:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' THEN DO:
      MESSAGE 'Ingrese el Centro de Costo' VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO T-DOSER.Cco IN BROWSE {&BROWSE-NAME}.
      RETURN 'ADM-ERROR'.
  END.
  FIND CB-AUXI WHERE cb-auxi.codcia = cb-codcia
      AND cb-auxi.clfaux = 'CCO'
      AND cb-auxi.codaux = T-DOSER.Cco:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CB-AUXI
  THEN DO:
      MESSAGE 'Centro de costo no registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.        
  IF cb-auxi.codaux = '00' THEN DO:
      MESSAGE 'Ingrese el Centro de Costo' VIEW-AS ALERT-BOX ERROR.
      APPLY 'entry' TO T-DOSER.Cco IN BROWSE {&BROWSE-NAME}.
      RETURN 'ADM-ERROR'.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

