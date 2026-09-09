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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-codcia AS INT.

DEF VAR s-acceso-total as LOG INIT NO.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacDPedi Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacDPedi.NroItm FacDPedi.codmat ~
Almmmatg.DesMat Almmmatg.DesMar FacDPedi.UndVta FacDPedi.AlmDes ~
FacDPedi.CanPed FacDPedi.Por_Dsctos[1] FacDPedi.PreUni FacDPedi.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacDPedi.CanPed ~
FacDPedi.PreUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacDPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacDPedi
&Scoped-define QUERY-STRING-br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF FacDPedi NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-1 

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
DEFINE BUTTON BUTTON-1 
     LABEL "PRECIOS EXPO" 
     SIZE 13 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacDPedi, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacDPedi.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U
      FacDPedi.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      FacDPedi.UndVta COLUMN-LABEL "Und." FORMAT "XXXX":U
      FacDPedi.AlmDes COLUMN-LABEL "Alm.!Desp." FORMAT "x(3)":U
      FacDPedi.CanPed FORMAT ">>>,>>9.9999":U
      FacDPedi.Por_Dsctos[1] COLUMN-LABEL "% Dscto." FORMAT ">>9.99":U
      FacDPedi.PreUni FORMAT ">>>,>>9.99999":U
      FacDPedi.ImpLin FORMAT ">,>>>,>>9.99":U
  ENABLE
      FacDPedi.CanPed
      FacDPedi.PreUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104 BY 8.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-1 AT ROW 9.08 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.FacCPedi
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
         HEIGHT             = 9.65
         WIDTH              = 104.57.
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
     _TblList          = "INTEGRAL.FacDPedi OF INTEGRAL.FacCPedi,INTEGRAL.Almmmatg OF INTEGRAL.FacDPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > INTEGRAL.FacDPedi.NroItm
"FacDPedi.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacDPedi.codmat
"FacDPedi.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacDPedi.UndVta
"FacDPedi.UndVta" "Und." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacDPedi.AlmDes
"FacDPedi.AlmDes" "Alm.!Desp." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacDPedi.CanPed
"FacDPedi.CanPed" ? ">>>,>>9.9999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacDPedi.Por_Dsctos[1]
"FacDPedi.Por_Dsctos[1]" "% Dscto." ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacDPedi.PreUni
"FacDPedi.PreUni" ? ">>>,>>9.99999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacDPedi.ImpLin
"FacDPedi.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  FacDPedi.CanPed:READ-ONLY IN BROWSE {&BROWSE-NAME} = NOT s-acceso-total.
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


&Scoped-define SELF-NAME FacDPedi.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacDPedi.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacDPedi.PreUni IN BROWSE br_table /* Precio Unitario */
OR F8 OF {&SELF-NAME}
DO:
  DEF VAR x-PreUni AS DEC.
  FIND ccbddocu WHERE ccbddocu.codcia = facdpedi.codcia
    AND ccbddocu.codmat = facdpedi.codmat
    AND ccbddocu.coddoc = faccpedi.cmpbnte
    AND ccbddocu.nrodoc = faccpedi.nroref
    NO-LOCK NO-ERROR.
  /*x-PreUni = ccbddocu.preuni.*/
  x-PreUni = facdpedi.preuni.
  RUN vtamay/d-vtamrd (facdpedi.codmat, faccpedi.codmon, faccpedi.tpocmb, facdpedi.factor,
                    INPUT-OUTPUT x-preuni).
  SELF:SCREEN-VALUE = STRING(x-PreUni).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PRECIOS EXPO */
DO:
  RUN Carga-Precios-Expo.
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Precios-Expo B-table-Win 
PROCEDURE Carga-Precios-Expo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-undvta AS CHAR.
DEF VAR f-factor AS DEC.
DEF VAR f-prebas AS DEC.
DEF VAR f-prevta AS DEC.
DEF VAR f-dsctos AS DEC.
DEF VAR y-dsctos AS DEC.
DEF VAR z-dsctos AS DEC.
DEF VAR x-tipdto AS CHAR.


FOR EACH Facdpedi OF Faccpedi, FIRST Almmmatg OF Facdpedi NO-LOCK:
    RUN vtagn/PrecioListaMayorista-2a (
                        "10015",        /*s-CodDiv,*/
                        Faccpedi.CodCli,
                        Faccpedi.CodMon,
                        Faccpedi.TpoCmb,
                        OUTPUT s-UndVta,
                        OUTPUT f-Factor,
                        Almmmatg.CodMat,
                        Faccpedi.FmaPgo,
                        Facdpedi.CanPed,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT z-Dsctos,
                        OUTPUT x-TipDto
                        ).
    IF RETURN-VALUE = "ADM-ERROR" THEN NEXT.
    IF f-PreVta <= 0 THEN NEXT.
    ASSIGN
        Facdpedi.PreUni = f-PreVta * ( 1 - z-Dsctos / 100 ) * ( 1 - y-Dsctos / 100 ).
    ASSIGN 
      Facdpedi.ImpDto = ROUND( Facdpedi.PreUni * Facdpedi.CanPed * (Facdpedi.Por_Dsctos[1] / 100),4 )
      Facdpedi.ImpLin = ROUND( Facdpedi.PreUni * Facdpedi.CanPed , 2 ) - Facdpedi.ImpDto.
    IF facdpedi.AftIsc 
    THEN facdpedi.ImpIsc = ROUND(facdpedi.PreBas * facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    IF facdpedi.AftIgv 
    THEN facdpedi.ImpIgv = facdpedi.ImpLin - ROUND(facdpedi.ImpLin  / (1 + (faccpedi.PorIgv / 100)),4).
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Procesa-Handle IN lh_handle ('calcula-totales').

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
  s-acceso-total = NO.
  BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
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
    Facdpedi.ImpDto = ROUND( Facdpedi.PreUni * Facdpedi.CanPed * (Facdpedi.Por_Dsctos[1] / 100),4 )
    Facdpedi.ImpLin = ROUND( Facdpedi.PreUni * Facdpedi.CanPed , 2 ) - Facdpedi.ImpDto.
  IF facdpedi.AftIsc 
  THEN facdpedi.ImpIsc = ROUND(facdpedi.PreBas * facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
  IF facdpedi.AftIgv 
  THEN facdpedi.ImpIgv = facdpedi.ImpLin - ROUND(facdpedi.ImpLin  / (1 + (faccpedi.PorIgv / 100)),4).

  RUN Procesa-Handle IN lh_handle ('calcula-totales').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('calcula-totales').

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
  BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "FacDPedi"}
  {src/adm/template/snd-list.i "Almmmatg"}

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
  /* CONSISTENCIAMOS QUE EL PRECIO ESTE DENTRO DE LOS PARAMETROS */
  DEF VAR x-PreUni AS DEC DECIMALS 5 NO-UNDO.
  DEF VAR x-PreBas AS DEC DECIMALS 5 NO-UNDO.
  
  x-PreUni = DECIMAL(FacDPedi.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  FIND ccbddocu WHERE ccbddocu.codcia = facdpedi.codcia
    AND ccbddocu.codmat = facdpedi.codmat
    AND ccbddocu.coddoc = faccpedi.cmpbnte
    AND ccbddocu.nrodoc = faccpedi.nroref
    NO-LOCK NO-ERROR.
  x-PreBas = ccbddocu.preuni.
  IF x-PreUni = x-PreBas THEN RETURN 'OK'.

/* RHC 05.03.05 bloqueado a pedido de la señora Patricia Wong
  /* Buscamos en los precios alternativos */
  FIND MrdMMatg WHERE mrdmmatg.codcia = s-codcia
    AND mrdmmatg.codmat = facdpedi.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE mrdmmatg
  THEN DO:
    x-PreBas = MrdMMatg.PreAlt[1] * FacDPedi.Factor.
    IF faccpedi.CodMon <> Almmmatg.monvta
    THEN IF faccpedi.CodMon = 1 
            THEN x-PreBas = x-PreBas * faccpedi.TpoCmb.
            ELSE x-PreBas = x-PreBas / faccpedi.TpoCmb.
    message 'primero' skip x-preuni x-prebas.
    IF ABSOLUTE(x-PreUni - x-PreBas) <= 0.01 THEN RETURN 'OK'.
    x-PreBas = MrdMMatg.PreAlt[2] * FacDPedi.Factor.
    IF faccpedi.CodMon <> Almmmatg.monvta
    THEN IF faccpedi.CodMon = 1 
            THEN x-PreBas = x-PreBas * faccpedi.TpoCmb.
            ELSE x-PreBas = x-PreBas / faccpedi.TpoCmb.
    message 'segundo' skip x-preuni x-prebas.
    IF ABSOLUTE(x-PreUni - x-PreBas) <= 0.01 THEN RETURN 'OK'.
    x-PreBas = MrdMMatg.PreAlt[3] * FacDPedi.Factor.
    IF faccpedi.CodMon <> Almmmatg.monvta
    THEN IF faccpedi.CodMon = 1 
            THEN x-PreBas = x-PreBas * faccpedi.TpoCmb.
            ELSE x-PreBas = x-PreBas / faccpedi.TpoCmb.
    message 'tercero' skip x-preuni x-prebas.
    IF ABSOLUTE(x-PreUni - x-PreBas) <= 0.01 THEN RETURN 'OK'.
  END.
  /* ERROR */
  MESSAGE 'El precio unitario está errado' VIEW-AS ALERT-BOX ERROR.
  APPLY 'ENTRY':U TO FacDPedi.PreUni IN BROWSE {&BROWSE-NAME}.
  RETURN 'ADM-ERROR'.
************************************************************* */

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
  DEF VAR X-CLAVE AS CHAR INIT 'seguro' NO-UNDO.
  DEF VAR X-REP AS CHAR NO-UNDO.

  RUN lib/_clave (x-clave, OUTPUT x-rep).

  IF x-rep = 'OK' 
  THEN s-acceso-total = YES.
  ELSE s-acceso-total = NO.
  
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

