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
{cbd\cbglobal.i}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE BUFFER Detalle FOR T-cb-dmov.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
      NO-LOCK  NO-ERROR.

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES T-cb-cmov
&Scoped-define FIRST-EXTERNAL-TABLE T-cb-cmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR T-cb-cmov.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-cb-dmov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-cb-dmov.Nroitm T-cb-dmov.CodDiv ~
T-cb-dmov.Codcta T-cb-dmov.Clfaux T-cb-dmov.Codaux T-cb-dmov.Glodoc ~
T-cb-dmov.TpoMov T-cb-dmov.ImpMn1 T-cb-dmov.ImpMn2 T-cb-dmov.Fchdoc ~
T-cb-dmov.Coddoc T-cb-dmov.Nrodoc T-cb-dmov.Codref T-cb-dmov.Nroref ~
T-cb-dmov.TpoItm T-cb-dmov.Relacion T-cb-dmov.tm 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-cb-dmov.CodDiv ~
T-cb-dmov.Codcta T-cb-dmov.Clfaux T-cb-dmov.Codaux T-cb-dmov.Glodoc ~
T-cb-dmov.TpoMov T-cb-dmov.ImpMn1 T-cb-dmov.ImpMn2 T-cb-dmov.Fchdoc ~
T-cb-dmov.Coddoc T-cb-dmov.Nrodoc T-cb-dmov.Codref T-cb-dmov.Nroref ~
T-cb-dmov.tm 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-cb-dmov
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-cb-dmov
&Scoped-define QUERY-STRING-br_table FOR EACH T-cb-dmov WHERE T-cb-dmov.CodCia = T-cb-cmov.Codcia ~
  AND T-cb-dmov.Periodo = T-cb-cmov.Periodo ~
  AND T-cb-dmov.NroMes = T-cb-cmov.Nromes ~
  AND T-cb-dmov.Codope = T-cb-cmov.Codope ~
  AND T-cb-dmov.Nroast = T-cb-cmov.Nroast NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-cb-dmov WHERE T-cb-dmov.CodCia = T-cb-cmov.Codcia ~
  AND T-cb-dmov.Periodo = T-cb-cmov.Periodo ~
  AND T-cb-dmov.NroMes = T-cb-cmov.Nromes ~
  AND T-cb-dmov.Codope = T-cb-cmov.Codope ~
  AND T-cb-dmov.Nroast = T-cb-cmov.Nroast NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table T-cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-cb-dmov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-21 
&Scoped-Define DISPLAYED-OBJECTS F-D-Soles F-D-Dolares F-H-Soles ~
F-H-Dolares 

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
DEFINE VARIABLE F-D-Dolares AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Debe (US$)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-D-Soles AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Debe (S/.)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-H-Dolares AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Haber (US$)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE F-H-Soles AS DECIMAL FORMAT "->>>>,>>9.99":U INITIAL 0 
     LABEL "Haber (S/.)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.43 BY 2.08.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-cb-dmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-cb-dmov.Nroitm FORMAT ">>>>9":U
      T-cb-dmov.CodDiv COLUMN-LABEL "Division" FORMAT "x(5)":U
      T-cb-dmov.Codcta COLUMN-LABEL "Cuenta!Contable" FORMAT "x(10)":U
      T-cb-dmov.Clfaux COLUMN-LABEL "   C l f" FORMAT "xxx":U
      T-cb-dmov.Codaux COLUMN-LABEL "      Auxiliar" FORMAT "x(8)":U
      T-cb-dmov.Glodoc FORMAT "x(30)":U
      T-cb-dmov.TpoMov FORMAT "H/D":U
      T-cb-dmov.ImpMn1 FORMAT "-ZZZ,ZZZ,ZZ9.99":U
      T-cb-dmov.ImpMn2 FORMAT "-ZZZ,ZZZ,ZZ9.99":U
      T-cb-dmov.Fchdoc FORMAT "99/99/9999":U
      T-cb-dmov.Coddoc FORMAT "x(4)":U
      T-cb-dmov.Nrodoc FORMAT "x(10)":U
      T-cb-dmov.Codref FORMAT "x(4)":U
      T-cb-dmov.Nroref FORMAT "x(10)":U
      T-cb-dmov.TpoItm FORMAT "x":U
      T-cb-dmov.Relacion FORMAT ">>>>>>>>>9":U
      T-cb-dmov.tm FORMAT "9":U
  ENABLE
      T-cb-dmov.CodDiv
      T-cb-dmov.Codcta
      T-cb-dmov.Clfaux
      T-cb-dmov.Codaux
      T-cb-dmov.Glodoc
      T-cb-dmov.TpoMov
      T-cb-dmov.ImpMn1
      T-cb-dmov.ImpMn2
      T-cb-dmov.Fchdoc
      T-cb-dmov.Coddoc
      T-cb-dmov.Nrodoc
      T-cb-dmov.Codref
      T-cb-dmov.Nroref
      T-cb-dmov.tm
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 84.86 BY 6.54
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     F-D-Soles AT ROW 7.77 COL 10.43 COLON-ALIGNED
     F-D-Dolares AT ROW 7.77 COL 30.86 COLON-ALIGNED
     F-H-Soles AT ROW 8.65 COL 10.43 COLON-ALIGNED
     F-H-Dolares AT ROW 8.65 COL 31 COLON-ALIGNED
     RECT-21 AT ROW 7.62 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.T-cb-cmov
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
         HEIGHT             = 8.69
         WIDTH              = 85.14.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-D-Dolares IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-D-Soles IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-H-Dolares IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-H-Soles IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.T-cb-dmov WHERE integral.T-cb-cmov ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "integral.T-cb-dmov.CodCia = integral.T-cb-cmov.Codcia
  AND integral.T-cb-dmov.Periodo = integral.T-cb-cmov.Periodo
  AND integral.T-cb-dmov.NroMes = integral.T-cb-cmov.Nromes
  AND integral.T-cb-dmov.Codope = integral.T-cb-cmov.Codope
  AND integral.T-cb-dmov.Nroast = integral.T-cb-cmov.Nroast"
     _FldNameList[1]   = integral.T-cb-dmov.Nroitm
     _FldNameList[2]   > integral.T-cb-dmov.CodDiv
"T-cb-dmov.CodDiv" "Division" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.T-cb-dmov.Codcta
"T-cb-dmov.Codcta" "Cuenta!Contable" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > integral.T-cb-dmov.Clfaux
"T-cb-dmov.Clfaux" "   C l f" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > integral.T-cb-dmov.Codaux
"T-cb-dmov.Codaux" "      Auxiliar" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.T-cb-dmov.Glodoc
"T-cb-dmov.Glodoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.T-cb-dmov.TpoMov
"T-cb-dmov.TpoMov" ? ? "logical" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > integral.T-cb-dmov.ImpMn1
"T-cb-dmov.ImpMn1" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > integral.T-cb-dmov.ImpMn2
"T-cb-dmov.ImpMn2" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > integral.T-cb-dmov.Fchdoc
"T-cb-dmov.Fchdoc" ? ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > integral.T-cb-dmov.Coddoc
"T-cb-dmov.Coddoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > integral.T-cb-dmov.Nrodoc
"T-cb-dmov.Nrodoc" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > integral.T-cb-dmov.Codref
"T-cb-dmov.Codref" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > integral.T-cb-dmov.Nroref
"T-cb-dmov.Nroref" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   = integral.T-cb-dmov.TpoItm
     _FldNameList[16]   > integral.T-cb-dmov.Relacion
"T-cb-dmov.Relacion" ? ">>>>>>>>>9" "recid" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > integral.T-cb-dmov.tm
"T-cb-dmov.tm" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

ON "RETURN":U OF t-cb-dmov.codcta,t-cb-dmov.clfaux,t-cb-dmov.codaux,t-cb-dmov.glodoc,t-cb-dmov.codref,t-cb-dmov.nroref
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF t-cb-dmov.Codcta DO:
   FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
        cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-ctas THEN DO:
      MESSAGE 'Cuenta contable no registrada' VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
   END.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "T-cb-cmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "T-cb-cmov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica B-table-Win 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-GenAut AS INTEGER.
    DEFINE VAR i        AS INTEGER INIT 1.
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.

    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = t-cb-dmov.CodCta NO-LOCK NO-ERROR.

    /* Elimina si existieran automaticas */
    FOR EACH DETALLE WHERE DETALLE.Relacion = RECID(t-cb-dmov):
        DELETE DETALLE.
    END.
          
    /* Genera Automaticas                */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):

        IF t-cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF t-cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF t-cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN t-cb-dmov.CtaAut = ""
           t-cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN t-cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                t-cb-dmov.CtaAut = t-cb-dmov.CodAux.
             ELSE
                t-cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF t-cb-dmov.CtrCta = ""  THEN t-cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
                        ASSIGN t-cb-dmov.CtaAut = cb-ctas.An1Cta
                               t-cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                        IF t-cb-dmov.CtrCta = ""
                        THEN t-cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
                    END.
        WHEN 3 THEN DO:
                        ASSIGN t-cb-dmov.CtaAut = cb-ctas.An1Cta
                               t-cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                    END.
    END CASE.

/* Generando las cuentas autom ticas */
IF t-cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
                        AND integral.cb-ctas.CodCta = t-cb-dmov.CodCta
                        NO-LOCK NO-ERROR.
    IF t-cb-dmov.CtaAut <> ""
        THEN DO:
            CREATE DETALLE.
            ASSIGN DETALLE.CodCia   = t-cb-dmov.CodCia
                   DETALLE.Periodo  = t-cb-dmov.Periodo
                   DETALLE.NroMes   = t-cb-dmov.NroMes
                   DETALLE.CodOpe   = t-cb-dmov.CodOpe
                   DETALLE.NroAst   = t-cb-dmov.NroAst
                   DETALLE.TpoItm   = "A"
                   DETALLE.Relacion = RECID(t-cb-dmov)
                   DETALLE.CodMon   = t-cb-dmov.CodMon
                   DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
                   DETALLE.NroItm   = t-cb-dmov.NroItm + 1
                   DETALLE.Codcta   = t-cb-dmov.CtaAut
                   DETALLE.CodDiv   = t-cb-dmov.CodDiv
                   DETALLE.ClfAux   = t-cb-dmov.ClfAux
                   DETALLE.CodAux   = t-cb-dmov.CodCta
                   DETALLE.NroRuc   = t-cb-dmov.NroRuc
                   DETALLE.CodDoc   = t-cb-dmov.CodDoc
                   DETALLE.NroDoc   = t-cb-dmov.NroDoc
                   DETALLE.GloDoc   = t-cb-dmov.GloDoc
                   DETALLE.CodMon   = t-cb-dmov.CodMon
                   DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
                   DETALLE.TpoMov   = t-cb-dmov.TpoMov
                   DETALLE.NroRef   = t-cb-dmov.NroRef
                   DETALLE.FchDoc   = t-cb-dmov.FchDoc
                   DETALLE.FchVto   = t-cb-dmov.FchVto
                   DETALLE.ImpMn1   = t-cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = t-cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = t-cb-dmov.ImpMn3
                   DETALLE.Tm       = t-cb-dmov.Tm
                   DETALLE.CCO      = t-cb-dmov.CCO.
        END.
         
    CREATE DETALLE.
    ASSIGN DETALLE.CodCia   = t-cb-dmov.CodCia
           DETALLE.Periodo  = t-cb-dmov.Periodo
           DETALLE.NroMes   = t-cb-dmov.NroMes
           DETALLE.CodOpe   = t-cb-dmov.CodOpe
           DETALLE.NroAst   = t-cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.Relacion = RECID(t-cb-dmov)           
           DETALLE.CodMon   = t-cb-dmov.CodMon
           DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
           DETALLE.NroItm   = t-cb-dmov.NroItm + 2
           DETALLE.Codcta   = t-cb-dmov.Ctrcta
           DETALLE.CodDiv   = t-cb-dmov.CodDiv
           DETALLE.ClfAux   = t-cb-dmov.ClfAux
           DETALLE.CodAux   = t-cb-dmov.CodCta
           DETALLE.NroRuc   = t-cb-dmov.NroRuc
           DETALLE.CodDoc   = t-cb-dmov.CodDoc
           DETALLE.NroDoc   = t-cb-dmov.NroDoc
           DETALLE.GloDoc   = t-cb-dmov.GloDoc
           DETALLE.CodMon   = t-cb-dmov.CodMon
           DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
           DETALLE.TpoMov   = NOT t-cb-dmov.TpoMov
           DETALLE.ImpMn1   = t-cb-dmov.ImpMn1
           DETALLE.ImpMn2   = t-cb-dmov.ImpMn2
           DETALLE.ImpMn3   = t-cb-dmov.ImpMn3
           DETALLE.NroRef   = t-cb-dmov.NroRef
           DETALLE.FchDoc   = t-cb-dmov.FchDoc
           DETALLE.FchVto   = t-cb-dmov.FchVto
           DETALLE.Tm       = t-cb-dmov.Tm
           DETALLE.CCO      = t-cb-dmov.CCO.
END.

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
  RUN Genera-Automatica.
  
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
  IF AVAILABLE T-cb-cmov THEN
     DO WITH FRAME {&FRAME-NAME}:
        DISPLAY 
           t-cb-cmov.DbeMn1 @ F-D-Soles 
           t-cb-cmov.DbeMn2 @ F-D-Dolares
           t-cb-cmov.HbeMn1 @ F-H-Soles
           t-cb-cmov.HbeMn2 @ F-H-Dolares. 
     END.

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
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
        WHEN "tm" THEN ASSIGN input-var-1 = "25".   
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
  {src/adm/template/snd-list.i "T-cb-cmov"}
  {src/adm/template/snd-list.i "T-cb-dmov"}

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

