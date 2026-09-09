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
Almmmatg.DesMat Almmmatg.DesMar FacDPedi.UndVta FacDPedi.CanPed ~
FacDPedi.canate FacDPedi.PreUni ~
FacDPedi.FactorDescuento * 100 @ FacDPedi.FactorDescuento ~
FacDPedi.cMontoBaseIGV + FacDPedi.cSumaIGV @ FacDPedi.cImporteTotalConImpuesto ~
FacDPedi.ImporteDescuento @ FacDPedi.ImporteDescuento 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF FacDPedi NO-LOCK ~
    BY FacDPedi.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacDPedi OF FacCPedi WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF FacDPedi NO-LOCK ~
    BY FacDPedi.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table FacDPedi Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacDPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Propios FILL-IN_ImpDto ~
FILL-IN_PorIgv FILL-IN_ImpTot FILL-IN-TERCEROS FILL-IN_ImpExo ~
FILL-IN_ImpVta FILL-IN_ImpIgv FILL-IN_Import2 FILL-IN-Cuadernos ~
FILL-IN-Practiforros FILL-IN-Variacion FILL-IN_ImpDto2 ~
FILL-IN_TotalMontoICBPER 

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
DEFINE VARIABLE FILL-IN-Cuadernos AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "CUADERNOS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Practiforros AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "PRACTIFORROS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-Propios AS DECIMAL FORMAT "ZZZZ,ZZ9.99":U INITIAL 0 
     LABEL "PROPIOS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-TERCEROS AS DECIMAL FORMAT "ZZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TERCEROS" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Variacion AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "% VAR" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpBrt AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE BRUTO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpDto AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "DESCUENTO DETALLE" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpDto2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "DESCUENTO FINAL" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpExo AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE EXONERADO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpIgv AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE IGV" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_Import2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "REDONDEO" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "IMPORTE TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_ImpVta AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "VALOR VENTA" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_PorIgv AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     LABEL "% I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .81
     BGCOLOR 1 FGCOLOR 15 .

DEFINE VARIABLE FILL-IN_TotalMontoICBPER AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99" INITIAL 0 
     LABEL "ICBPER" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

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
      FacDPedi.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      FacDPedi.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U WIDTH 6.43
      Almmmatg.DesMat FORMAT "X(80)":U WIDTH 69.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U WIDTH 10.43
      FacDPedi.UndVta COLUMN-LABEL "Unidad" FORMAT "X(10)":U WIDTH 5.43
      FacDPedi.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>>,>>9.99":U
      FacDPedi.canate COLUMN-LABEL "Cantidad!Atendida" FORMAT ">>>,>>9.99":U
      FacDPedi.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.99999":U
            WIDTH 7.86
      FacDPedi.FactorDescuento * 100 @ FacDPedi.FactorDescuento COLUMN-LABEL "% Descuento"
      FacDPedi.cMontoBaseIGV + FacDPedi.cSumaIGV @ FacDPedi.cImporteTotalConImpuesto COLUMN-LABEL "Importe" FORMAT ">,>>>,>>9.99":U
      FacDPedi.ImporteDescuento @ FacDPedi.ImporteDescuento COLUMN-LABEL "Otros!Descuentos" FORMAT ">>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 156 BY 10.77
         BGCOLOR 15 FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Propios AT ROW 11.77 COL 13 COLON-ALIGNED WIDGET-ID 32
     FILL-IN_ImpBrt AT ROW 11.77 COL 49 COLON-ALIGNED WIDGET-ID 14
     FILL-IN_ImpDto AT ROW 11.77 COL 83 COLON-ALIGNED WIDGET-ID 28
     FILL-IN_PorIgv AT ROW 11.77 COL 109 COLON-ALIGNED WIDGET-ID 24
     FILL-IN_ImpTot AT ROW 11.77 COL 140 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-TERCEROS AT ROW 12.58 COL 13 COLON-ALIGNED WIDGET-ID 34
     FILL-IN_ImpExo AT ROW 12.58 COL 49 COLON-ALIGNED WIDGET-ID 16
     FILL-IN_ImpVta AT ROW 12.58 COL 83 COLON-ALIGNED WIDGET-ID 22
     FILL-IN_ImpIgv AT ROW 12.58 COL 109 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_Import2 AT ROW 12.58 COL 140 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-Cuadernos AT ROW 13.38 COL 13 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Practiforros AT ROW 13.38 COL 38 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Variacion AT ROW 13.38 COL 56 COLON-ALIGNED WIDGET-ID 8
     FILL-IN_ImpDto2 AT ROW 13.38 COL 109 COLON-ALIGNED WIDGET-ID 40
     FILL-IN_TotalMontoICBPER AT ROW 13.38 COL 140 COLON-ALIGNED WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.FacCPedi
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
         HEIGHT             = 14.38
         WIDTH              = 157.
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

/* SETTINGS FOR FILL-IN FILL-IN-Cuadernos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Practiforros IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Propios IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TERCEROS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Variacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpBrt IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN_ImpBrt:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_ImpDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpDto2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Import2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_TotalMontoICBPER IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.FacDPedi OF integral.FacCPedi,integral.Almmmatg OF integral.FacDPedi"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "integral.FacDPedi.NroItm|yes"
     _FldNameList[1]   > integral.FacDPedi.NroItm
"FacDPedi.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.FacDPedi.codmat
"FacDPedi.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "69.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.FacDPedi.UndVta
"FacDPedi.UndVta" "Unidad" "X(10)" "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.FacDPedi.CanPed
"FacDPedi.CanPed" "Cantidad!Aprobada" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.FacDPedi.canate
"FacDPedi.canate" "Cantidad!Atendida" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.FacDPedi.PreUni
"FacDPedi.PreUni" "Precio!Unitario" ">>,>>9.99999" "decimal" ? ? ? ? ? ? no ? no no "7.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"FacDPedi.FactorDescuento * 100 @ FacDPedi.FactorDescuento" "% Descuento" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"FacDPedi.cMontoBaseIGV + FacDPedi.cSumaIGV @ FacDPedi.cImporteTotalConImpuesto" "Importe" ">,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"FacDPedi.ImporteDescuento @ FacDPedi.ImporteDescuento" "Otros!Descuentos" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  RUN Pinta-Totales.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Totales B-table-Win 
PROCEDURE Pinta-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN_ImpBrt = 0
    FILL-IN_ImpExo = 0
    FILL-IN_ImpDto = 0
    FILL-IN_ImpDto2 = 0
    FILL-IN_Import2 = 0
    FILL-IN_ImpIgv = 0
    FILL-IN_ImpTot = 0
    FILL-IN_ImpVta = 0
    FILL-IN_PorIgv = 0
    FILL-IN-Propios = 0
    FILL-IN-TERCEROS = 0
    FILL-IN_TotalMontoICBPER = 0
    .
IF AVAILABLE FacCPedi THEN DO:
    ASSIGN
        FILL-IN_ImpBrt = FacCPedi.ImpBrt
        FILL-IN_ImpExo = FacCPedi.ImpExo
        FILL-IN_ImpDto = FacCPedi.ImpDto
        FILL-IN_ImpDto2 = FacCPedi.DescuentosGlobales
        FILL-IN_Import2 = FacCPedi.Importe[2]
        FILL-IN_ImpIgv = FacCPedi.TotalIGV
        FILL-IN_ImpTot = FacCPedi.TotalPrecioVenta
        FILL-IN_ImpVta = FacCPedi.TotalValorVenta
        FILL-IN_PorIgv = FacCPedi.PorIgv
        FILL-IN_TotalMontoICBPER = FacCPedi.TotalMontoICBPER
        .
    IF FacCPedi.FlgIgv = YES THEN FILL-IN_ImpExo:LABEL IN FRAME {&FRAME-NAME} = 'IMPORTE EXONERADO'.
        ELSE FILL-IN_ImpExo:LABEL IN FRAME {&FRAME-NAME} = 'IMPORTE INAFECTO'.
END.
DISPLAY
    FILL-IN_ImpBrt
    FILL-IN_ImpExo
    FILL-IN_ImpDto
    FILL-IN_ImpDto2
    FILL-IN_Import2
    FILL-IN_ImpIgv
    FILL-IN_ImpTot
    FILL-IN_ImpVta
    FILL-IN_PorIgv
    FILL-IN_TotalMontoICBPER
    WITH FRAME {&FRAME-NAME}.

/* RHC TOTALES POR FAMILIA */
ASSIGN
    FILL-IN-Cuadernos = 0
    FILL-IN-Practiforros = 0
    FILL-IN-Variacion = 0.
IF AVAILABLE FacCPedi THEN DO:
    FOR EACH FacDPedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF FacDPedi NO-LOCK:
        IF LOOKUP(Almmmatg.codfam, '010,011,012,013,017') > 0 
            THEN FILL-IN-Propios = FILL-IN-Propios + FacDPedi.ImpLin.
        ELSE FILL-IN-TERCEROS = FILL-IN-TERCEROS +  FacDPedi.ImpLin.
        CASE Almmmatg.CodFam:
            WHEN '010' THEN DO:
                IF (Almmmatg.SubFam = '012' OR Almmmatg.SubFam = '013')
                    THEN FILL-IN-Cuadernos = FILL-IN-Cuadernos + FacDPedi.ImpLin.
            END.
            WHEN '012' THEN DO:
                IF Almmmatg.SubFam = '063'
                    THEN FILL-IN-Practiforros = FILL-IN-Practiforros + FacDPedi.ImpLin.
            END.
        END CASE.
    END.
END.
IF FILL-IN-Cuadernos > 0 THEN FILL-IN-Variacion = FILL-IN-Practiforros / FILL-IN-Cuadernos * 100.
ASSIGN
    FILL-IN-Variacion:BGCOLOR = 12
    FILL-IN-Variacion:FGCOLOR = 15.
IF FILL-IN-Variacion > 0 AND FILL-IN-Variacion > 5 THEN
    ASSIGN
    FILL-IN-Variacion:BGCOLOR = 2
    FILL-IN-Variacion:FGCOLOR = 15.

DISPLAY
    FILL-IN-Cuadernos FILL-IN-Practiforros FILL-IN-Variacion
    FILL-IN-Propios FILL-IN-TERCEROS
    WITH FRAME {&FRAME-NAME}.

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

