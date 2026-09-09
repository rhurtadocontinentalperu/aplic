&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR F-ESTADO AS CHAR.
DEFINE VAR X-STA AS CHAR.
DEFINE VAR R-MATP AS RECID.

/*DEFINE VAR X-MON AS CHARACTER NO-UNDO.
DEFINE VAR X-VTA AS CHARACTER NO-UNDO.
DEFINE VAR X-STA AS CHARACTER NO-UNDO.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE VAR F-ESTADO AS CHAR.*/

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LG-cmatpr gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LG-cmatpr.nrolis gn-prov.NomPro ~
LG-cmatpr.Dsctos[1] LG-cmatpr.Dsctos[2] LG-cmatpr.Dsctos[3] ~
LG-cmatpr.FchEmi LG-cmatpr.FchVig LG-cmatpr.FchVto X-STA @ X-STA 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH LG-cmatpr WHERE ~{&KEY-PHRASE} ~
      AND gn-prov.CodCia = PV-CODCIA AND ~
        gn-prov.CodPro = LG-cmatpr.CodPro NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND ~
        gn-prov.CodPro = LG-cmatpr.CodPro ~
      AND gn-prov.NomPro BEGINS wprovee NO-LOCK ~
    BY LG-cmatpr.nrolis DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH LG-cmatpr WHERE ~{&KEY-PHRASE} ~
      AND gn-prov.CodCia = PV-CODCIA AND ~
        gn-prov.CodPro = LG-cmatpr.CodPro NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND ~
        gn-prov.CodPro = LG-cmatpr.CodPro ~
      AND gn-prov.NomPro BEGINS wprovee NO-LOCK ~
    BY LG-cmatpr.nrolis DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table LG-cmatpr gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table LG-cmatpr
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-prov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-2 COMBO-BOX-1 wnrolis wprovee ~
br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-2 COMBO-BOX-1 wnrolis wprovee 

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
DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "No. Lista" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "No. Lista","Proveedor" 
     DROP-DOWN-LIST
     SIZE 12.43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Condición" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","A","P","D" 
     DROP-DOWN-LIST
     SIZE 6.86 BY 1 NO-UNDO.

DEFINE VARIABLE wnrolis AS CHARACTER FORMAT "XXXXXX":U 
     LABEL "No. Lista" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .77 NO-UNDO.

DEFINE VARIABLE wprovee AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 33.43 BY .77 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      LG-cmatpr, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LG-cmatpr.nrolis FORMAT "999999":U
      gn-prov.NomPro FORMAT "x(37)":U
      LG-cmatpr.Dsctos[1] COLUMN-LABEL "Dscto[1]" FORMAT ">>9.99":U
      LG-cmatpr.Dsctos[2] COLUMN-LABEL "Dscto[2]" FORMAT ">>9.99":U
      LG-cmatpr.Dsctos[3] COLUMN-LABEL "Dscto[3]" FORMAT ">>9.99":U
      LG-cmatpr.FchEmi COLUMN-LABEL "     Fecha   !    Emision" FORMAT "99/99/9999":U
      LG-cmatpr.FchVig COLUMN-LABEL "     Fecha   !    Vigencia" FORMAT "99/99/9999":U
      LG-cmatpr.FchVto COLUMN-LABEL "    Fecha    !Vencimiento" FORMAT "99/99/9999":U
      X-STA @ X-STA COLUMN-LABEL "Estado" FORMAT "XXX":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 88 BY 13.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-2 AT ROW 1.19 COL 75.29 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 1.23 COL 8.86 COLON-ALIGNED NO-LABEL
     wnrolis AT ROW 1.31 COL 31 COLON-ALIGNED
     wprovee AT ROW 1.31 COL 31 COLON-ALIGNED
     br_table AT ROW 2.38 COL 1
     "Buscar x" VIEW-AS TEXT
          SIZE 7.72 BY .58 AT ROW 1.35 COL 2.14
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 14.46
         WIDTH              = 88.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table wprovee F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.LG-cmatpr,INTEGRAL.gn-prov WHERE INTEGRAL.LG-cmatpr ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.LG-cmatpr.nrolis|no"
     _Where[1]         = "integral.gn-prov.CodCia = PV-CODCIA AND
        integral.gn-prov.CodPro = integral.LG-cmatpr.CodPro"
     _JoinCode[2]      = "integral.gn-prov.CodCia = PV-CODCIA AND
        integral.gn-prov.CodPro = integral.LG-cmatpr.CodPro"
     _Where[2]         = "integral.gn-prov.NomPro BEGINS wprovee"
     _FldNameList[1]   = integral.LG-cmatpr.nrolis
     _FldNameList[2]   > integral.gn-prov.NomPro
"gn-prov.NomPro" ? "x(37)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.LG-cmatpr.Dsctos[1]
"LG-cmatpr.Dsctos[1]" "Dscto[1]" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.LG-cmatpr.Dsctos[2]
"LG-cmatpr.Dsctos[2]" "Dscto[2]" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.LG-cmatpr.Dsctos[3]
"LG-cmatpr.Dsctos[3]" "Dscto[3]" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.LG-cmatpr.FchEmi
"LG-cmatpr.FchEmi" "     Fecha   !    Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.LG-cmatpr.FchVig
"LG-cmatpr.FchVig" "     Fecha   !    Vigencia" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.LG-cmatpr.FchVto
"LG-cmatpr.FchVto" "    Fecha    !Vencimiento" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"X-STA @ X-STA" "Estado" "XXX" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON MOUSE-SELECT-DBLCLICK OF br_table IN FRAME F-Main
DO:
  RUN LGC\d-clppro.r(integral.LG-cmatpr.nrolis).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&Scoped-define SELF-NAME COMBO-BOX-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-1 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-1 IN FRAME F-Main
DO:
  wnrolis:visible = yes.
  wprovee:visible = yes.
  ASSIGN COMBO-BOX-1.
  CASE COMBO-BOX-1:
       WHEN "Proveedor" THEN
            wnrolis:visible = not wnrolis:visible.
       WHEN "No. Lista" THEN
            wprovee:visible = not wprovee:visible.
  end case.         
  ASSIGN COMBO-BOX-1.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-2 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-2 IN FRAME F-Main /* Condición */
DO:
  ASSIGN COMBO-BOX-2.
  CASE COMBO-BOX-2:
       WHEN "P" THEN 
          ASSIGN F-ESTADO = " ".
       WHEN "A" THEN 
          ASSIGN F-ESTADO = "A".          
       WHEN "D" THEN 
          ASSIGN F-ESTADO = "D".
       OTHERWISE
          ASSIGN F-ESTADO = "".        
  END.        
  RUN abrir-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wnrolis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wnrolis B-table-Win
ON LEAVE OF wnrolis IN FRAME F-Main /* No. Lista */
or "RETURN":U of wnrolis
DO:
  IF INPUT wnrolis = "" THEN RETURN.
  find first LG-cmatpr where LG-cmatpr.Nrolis = integer(string(wnrolis:SCREEN-VALUE,"999999")) AND
             integral.LG-cmatpr.FlgEst BEGINS F-ESTADO NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LG-cmatpr THEN DO:
     MESSAGE " No. Lista NO EXISTE " VIEW-AS ALERT-BOX ERROR.
     wnrolis = "".
     RETURN NO-APPLY.
  END.        
  R-matp = RECID(LG-cmatpr).
  REPOSITION BR_TABLE TO RECID R-matp.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No. Lista NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wnrolis = "".
     RETURN.
  END.
  wnrolis:SCREEN-VALUE = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wprovee
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wprovee B-table-Win
ON LEAVE OF wprovee IN FRAME F-Main /* Proveedor */
or "RETURN":U of wprovee
DO:
  ASSIGN WPROVEE.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

ON FIND OF LG-cmatpr  
DO:
        
              
    IF LG-cmatpr.FlgEst = "A" THEN
        ASSIGN
            X-STA = "ACT".
    ELSE
        IF LG-cmatpr.FlgEst = "D" THEN
           ASSIGN 
              X-STA = "DES".
        ELSE        
           ASSIGN
              X-STA = "PEN".                           

END.




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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  wprovee:visible IN FRAME F-MAIN = not wprovee:visible.
  
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
  {src/adm/template/snd-list.i "LG-cmatpr"}
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

