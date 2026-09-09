&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-TpoCmb LIKE Faccpedi.tpocmb.
DEF SHARED VAR Lh_Handle AS HANDLE.
DEF SHARED VAR s-CodMon AS INT.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE BUFFER B-PEDI FOR PEDI.

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
&Scoped-define INTERNAL-TABLES PEDI almmserv

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.NroItm PEDI.codmat ~
almmserv.DesMat PEDI.CanPed PEDI.UndVta PEDI.PreUni PEDI.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.codmat PEDI.CanPed ~
PEDI.UndVta PEDI.PreUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH almmserv OF PEDI NO-LOCK ~
    BY PEDI.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH almmserv OF PEDI NO-LOCK ~
    BY PEDI.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI almmserv
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table almmserv


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-22 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_ImpBrt FILL-IN_PorDto ~
FILL-IN_ImpDto FILL-IN_PorIgv FILL-IN_ImpIgv FILL-IN_ImpExo FILL-IN_ImpVta ~
FILL-IN_ImpTot 

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
DEFINE VARIABLE FILL-IN_ImpBrt AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. Bruto" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_ImpDto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. Dscto." 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_ImpExo AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. Exo." 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_ImpIgv AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. Total" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_ImpVta AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Imp. Venta" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_PorDto AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "% Dscto." 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .81.

DEFINE VARIABLE FILL-IN_PorIgv AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "% I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      almmserv SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.NroItm FORMAT ">>9":U
      PEDI.codmat FORMAT "X(6)":U
      almmserv.DesMat FORMAT "X(45)":U
      PEDI.CanPed FORMAT ">,>>>,>>9.9999":U
      PEDI.UndVta FORMAT "XXXX":U
      PEDI.PreUni FORMAT ">,>>>,>>9.99999":U
      PEDI.ImpLin FORMAT "->>,>>>,>>9.99":U
  ENABLE
      PEDI.codmat
      PEDI.CanPed
      PEDI.UndVta
      PEDI.PreUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 91 BY 5.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN_ImpBrt AT ROW 6.77 COL 8 COLON-ALIGNED
     FILL-IN_PorDto AT ROW 6.77 COL 31 COLON-ALIGNED
     FILL-IN_ImpDto AT ROW 6.77 COL 46 COLON-ALIGNED
     FILL-IN_PorIgv AT ROW 6.77 COL 69 COLON-ALIGNED
     FILL-IN_ImpIgv AT ROW 6.77 COL 84 COLON-ALIGNED
     FILL-IN_ImpExo AT ROW 7.54 COL 8 COLON-ALIGNED
     FILL-IN_ImpVta AT ROW 7.58 COL 46 COLON-ALIGNED
     FILL-IN_ImpTot AT ROW 7.58 COL 84 COLON-ALIGNED
     RECT-22 AT ROW 6.58 COL 1
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 9.31
         WIDTH              = 99.29.
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

/* SETTINGS FOR FILL-IN FILL-IN_ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PorDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.almmserv OF Temp-Tables.PEDI"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.PEDI.NroItm|yes"
     _FldNameList[1]   = Temp-Tables.PEDI.NroItm
     _FldNameList[2]   > Temp-Tables.PEDI.codmat
"PEDI.codmat" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.almmserv.DesMat
     _FldNameList[4]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = Temp-Tables.PEDI.ImpLin
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

  ASSIGN
    PEDI.PreUni:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES
    PEDI.UndVta:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' 
  THEN PEDI.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  ELSE PEDI.codmat:READ-ONLY IN BROWSE {&BROWSE-NAME} = NO.
  
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


&Scoped-define SELF-NAME PEDI.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.codmat IN BROWSE br_table /* Codigo Articulo */
DO:
    MESSAGE '¿leave?' SKIP SELF:SCREEN-VALUE.
    IF PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" OR 
        PEDI.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ? THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
    /* Valida Maestro Productos */
    FIND Almmserv WHERE Almmserv.CodCia = S-CODCIA 
        AND Almmserv.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmserv THEN DO:
       MESSAGE "Codigo de Servicio no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmserv.Estado <> "A" THEN DO:
       MESSAGE "Servicio no Activo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    RUN vta/PrecioServ (s-CodCia,
                        s-CodMon,
                        s-TpoCmb,
                        Almmserv.CodMat,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta).
                        
    DISPLAY Almmserv.DesMat @ Almmserv.DesMat 
            Almmserv.UndBas @ PEDI.UndVta 
            F-PREVTA @ PEDI.PreUni 
            WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON RETURN OF PEDI.CanPed, PEDI.codmat
DO:
    APPLY "TAB":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.

  ASSIGN 
    FILL-IN_ImpDto = 0
    FILL-IN_ImpExo = 0
    FILL-IN_ImpIgv = 0
    FILL-IN_ImpTot = 0
    FILL-IN_ImpBrt = 0
    FILL-IN_ImpVta = 0
    FILL-IN_PorDto = 0.
  FOR EACH B-PEDI:
    FILL-IN_ImpTot = FILL-IN_ImpTot + B-PEDI.ImpLin.
    F-Igv = F-Igv + B-PEDI.ImpIgv.
    F-Isc = F-Isc + B-PEDI.ImpIsc.
    IF NOT B-PEDI.AftIgv THEN FILL-IN_ImpExo = FILL-IN_ImpExo + B-PEDI.ImpLin.
    IF B-PEDI.AftIgv = YES
    THEN FILL-IN_ImpDto = FILL-IN_ImpDto + ROUND(B-PEDI.ImpDto / (1 + FacCfgGn.PorIgv / 100), 2).
    ELSE FILL-IN_ImpDto = FILL-IN_ImpDto + B-PEDI.ImpDto.
  END.
  FILL-IN_ImpIgv = ROUND(F-Igv,2).
  FILL-IN_ImpVta = FILL-IN_ImpTot - FILL-IN_ImpExo - FILL-IN_ImpIgv.
  FILL-IN_ImpBrt = FILL-IN_ImpVta + FILL-IN_ImpDto + FILL-IN_ImpExo.
  DISPLAY FILL-IN_ImpDto
        FILL-IN_ImpExo
        FILL-IN_ImpIgv
        FILL-IN_ImpTot
        FILL-IN_ImpBrt
        FILL-IN_ImpVta WITH FRAME {&FRAME-NAME}.

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
  DEF VAR x-NroItm LIKE FacDPedi.NroItm INIT 1.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
    FOR EACH B-PEDI NO-LOCK BY B-PEDI.NroItm:
        x-NroItm = B-PEDI.NroItm + 1.
    END.
  END.
  ELSE x-NroItm = PEDI.NroItm.
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    PEDI.CodCia = s-CodCia
    PEDI.NroItm = x-NroItm
    PEDI.UndVta = Almmserv.undbas
    PEDI.Factor = 1
    PEDI.PreBas = F-PreBas 
    PEDI.AftIgv = Almmserv.AftIgv 
    PEDI.AftIsc = NO
    PEDI.Por_DSCTOS[2] = Almmserv.PorMax
    PEDI.ImpLin = ROUND( PEDI.PreUni * PEDI.CanPed , 2 ).

  IF PEDI.AftIgv THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND(PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.

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
  RUN Renumera-Items.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  RUN Imp-Total.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH B-PEDI:
    /* Valida Maestro Productos */
    FIND Almmserv WHERE Almmserv.CodCia = S-CODCIA 
        AND Almmserv.codmat = B-PEDI.CodMat 
        NO-LOCK NO-ERROR.
    RUN vta/PrecioServ (s-CodCia,
                        s-CodMon,
                        s-TpoCmb,
                        Almmserv.CodMat,
                        4,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta).
    ASSIGN
        B-PEDI.PreBas = F-PreBas 
        B-PEDI.PreUni = F-PREVTA
        B-PEDI.AftIgv = Almmserv.AftIgv 
        B-PEDI.ImpLin = ROUND( B-PEDI.PreUni * B-PEDI.CanPed , 2 ).
    IF B-PEDI.AftIgv 
    THEN B-PEDI.ImpIgv = B-PEDI.ImpLin - ROUND(B-PEDI.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
  END.
  
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Renumera-Items B-table-Win 
PROCEDURE Renumera-Items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER B-PEDI FOR PEDI.
  DEF VAR x-NroItm LIKE FacDPedi.NroItm INIT 1.
  
  FOR EACH B-PEDI BY B-PEDI.NroItm:
    B-PEDI.NroItm = x-NroItm.
    x-NroItm = x-NroItm + 1.
  END.
  

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
  {src/adm/template/snd-list.i "PEDI"}
  {src/adm/template/snd-list.i "almmserv"}

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
  
  FIND Almmserv WHERE Almmserv.codcia = s-codcia
    AND Almmserv.codmat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmserv THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
  END.
  IF Almmserv.Estado <> "A" THEN DO:
       MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
  END.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
    AND CAN-FIND(FIRST B-PEDI WHERE B-PEDI.CodMat = PEDI.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK)
  THEN DO:
    MESSAGE 'Material repetido' VIEW-AS ALERT-BOX ERROR.
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

