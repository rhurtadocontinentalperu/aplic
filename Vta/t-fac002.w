&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE t-ccbddocu LIKE CcbDDocu.



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
DEF SHARED VAR cl-CODCIA  AS INTEGER.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-codcli LIKE gn-clie.codcli.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR S-CNDVTA AS CHAR.    /* Forma de Pago */
DEF SHARED VAR S-TPOCMB AS DECIMAL.  

DEF VAR F-FACTOR AS DEC INIT 1 NO-UNDO.
DEF VAR S-UNDBAS AS CHA NO-UNDO.
DEF VAR F-PREVTA LIKE Almmmatg.PreBas NO-UNDO.
DEF VAR F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEF VAR F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEF VAR F-PorImp LIKE Almmmatg.PreBas NO-UNDO.
DEF VAR I-NROITM AS INT INIT 0 NO-UNDO.     /* NUMERO DE ITEM */

DEF BUFFER b-ccbddocu FOR t-ccbddocu.

FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

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
&Scoped-define INTERNAL-TABLES t-ccbddocu Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-ccbddocu.NroItm t-ccbddocu.codmat ~
Almmmatg.DesMat Almmmatg.DesMar t-ccbddocu.AlmDes t-ccbddocu.CanDes ~
t-ccbddocu.UndVta t-ccbddocu.PreUni t-ccbddocu.PorDto t-ccbddocu.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table t-ccbddocu.codmat ~
t-ccbddocu.CanDes t-ccbddocu.PreUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table t-ccbddocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table t-ccbddocu
&Scoped-define QUERY-STRING-br_table FOR EACH t-ccbddocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF t-ccbddocu NO-LOCK ~
    BY t-ccbddocu.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-ccbddocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF t-ccbddocu NO-LOCK ~
    BY t-ccbddocu.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table t-ccbddocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-ccbddocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-22 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-ImpBrt FILL-IN-ImpDto ~
FILL-IN-ImpIsc FILL-IN-ImpTot FILL-IN-ImpExo FILL-IN-ImpVta FILL-IN-ImpIgv 

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
DEFINE VARIABLE FILL-IN-ImpBrt AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Bruto" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpDto AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Descuento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpExo AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Exonerado" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpIgv AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpIsc AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "I.S.C" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpVta AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Valor Venta" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 97 BY 2.31.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-ccbddocu, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-ccbddocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U
      t-ccbddocu.codmat COLUMN-LABEL "<<Codigo>>" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(35)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)":U
      t-ccbddocu.AlmDes COLUMN-LABEL "Alm." FORMAT "x(3)":U
      t-ccbddocu.CanDes FORMAT ">,>>9.99":U
      t-ccbddocu.UndVta COLUMN-LABEL "Unidad" FORMAT "x(4)":U
      t-ccbddocu.PreUni FORMAT ">,>>9.99999":U
      t-ccbddocu.PorDto FORMAT "->>9.99":U
      t-ccbddocu.ImpLin COLUMN-LABEL "Importe Total" FORMAT ">>,>>9.99":U
  ENABLE
      t-ccbddocu.codmat
      t-ccbddocu.CanDes
      t-ccbddocu.PreUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 97 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-ImpBrt AT ROW 8.12 COL 13 COLON-ALIGNED
     FILL-IN-ImpDto AT ROW 8.12 COL 38 COLON-ALIGNED
     FILL-IN-ImpIsc AT ROW 8.12 COL 59 COLON-ALIGNED
     FILL-IN-ImpTot AT ROW 8.12 COL 83 COLON-ALIGNED
     FILL-IN-ImpExo AT ROW 8.88 COL 13 COLON-ALIGNED
     FILL-IN-ImpVta AT ROW 8.88 COL 38 COLON-ALIGNED
     FILL-IN-ImpIgv AT ROW 8.88 COL 59 COLON-ALIGNED
     RECT-22 AT ROW 7.73 COL 1
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
      TABLE: t-ccbddocu T "SHARED" ? INTEGRAL CcbDDocu
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
         HEIGHT             = 9.58
         WIDTH              = 101.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpDto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpIsc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-ccbddocu,INTEGRAL.Almmmatg OF Temp-Tables.t-ccbddocu"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "Temp-Tables.t-ccbddocu.NroItm|yes"
     _FldNameList[1]   > Temp-Tables.t-ccbddocu.NroItm
"t-ccbddocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-ccbddocu.codmat
"t-ccbddocu.codmat" "<<Codigo>>" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-ccbddocu.AlmDes
"t-ccbddocu.AlmDes" "Alm." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-ccbddocu.CanDes
"t-ccbddocu.CanDes" ? ">,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-ccbddocu.UndVta
"t-ccbddocu.UndVta" "Unidad" "x(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-ccbddocu.PreUni
"t-ccbddocu.PreUni" ? ">,>>9.99999" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-ccbddocu.PorDto
"t-ccbddocu.PorDto" ? "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-ccbddocu.ImpLin
"t-ccbddocu.ImpLin" "Importe Total" ">>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DISPLAY I-NROITM @ t-ccbddocu.nroitm WITH BROWSE {&BROWSE-NAME}.
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


&Scoped-define SELF-NAME t-ccbddocu.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-ccbddocu.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF t-ccbddocu.codmat IN BROWSE br_table /* <<Codigo>> */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

  DEF VAR l-Ok AS LOG NO-UNDO.

  FIND almmmate WHERE almmmate.codcia = s-codcia 
    AND almmmate.codalm = s-codalm
    AND almmmate.codmat = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE almmmate
  THEN DO:
    FIND almmmatg OF almmmate NO-LOCK.
    DISPLAY almmmatg.desmat @ almmmatg.desmat WITH BROWSE {&BROWSE-NAME}.
    RUN lkup/c-uniofi ("Unidades de Venta",
                   Almmmate.CodMat,
                   OUTPUT L-OK
                   ).
    IF l-Ok = NO
    THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    S-UNDBAS = Almmmatg.UndBas.
    F-FACTOR = 1.
    RUN Calculo-Precios.
    DISPLAY 
        Almmmatg.DesMat @ almmmatg.desmat
        Almmmatg.DesMar @ almmmatg.desmar
        Almmmatg.Chr__01 @ t-ccbddocu.UndVta 
        s-codalm @ t-ccbddocu.AlmDes
        F-DSCTOS @ t-ccbddocu.PorDto
        F-PREVTA @ t-ccbddocu.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
  END.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON RETURN OF t-ccbddocu.CanDes, t-ccbddocu.codmat, t-ccbddocu.PreUni DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-Precios B-table-Win 
PROCEDURE Calculo-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-ClfCli LIKE gn-clie.ClfCli NO-UNDO.
  DEF VAR MaxCat AS DEC NO-UNDO.
  DEF VAR MaxVta AS DEC NO-UNDO.
  
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia
    AND  gn-clie.CodCli = S-CODCLI
    NO-LOCK NO-ERROR.
  IF AVAIL gn-clie 
  THEN X-CLFCLI = gn-clie.clfCli.
  ELSE X-CLFCLI = "".
    
  IF S-CODMON = 1 
  THEN DO:
    IF Almmmatg.MonVta = 1 
    THEN ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = Almmmatg.PreOfi * s-TpoCmb * F-FACTOR.
  END.
  IF S-CODMON = 2 
  THEN DO:
    IF Almmmatg.MonVta = 2 
    THEN ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (Almmmatg.PreOfi / s-TpoCmb) * F-FACTOR.
  END.
  ASSIGN
    MaxCat = 0
    MaxVta = 0.
  FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI
    NO-LOCK NO-ERROR.
  IF AVAIL ClfClie 
  THEN DO:
    IF Almmmatg.Chr__02 = "P" 
    THEN MaxCat = ClfClie.PorDsc.
    ELSE MaxCat = ClfClie.PorDsc1.
  END.
  /* Descuentos */
  FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA 
    AND Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
  IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
  /***************************************************/
  IF NOT AVAILABLE ClfClie 
  THEN F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
  ELSE F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
  F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).
  RUN BIN/_ROUND1(F-PREVTA,2,OUTPUT F-PREVTA).

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  F-FACTOR = 1.
  I-NROITM = 1.
  FOR EACH b-ccbddocu:
    I-NROITM = I-NROITM + 1.
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
  ASSIGN
    t-ccbddocu.codcia = s-codcia
    t-ccbddocu.nroitm = INTEGER(t-ccbddocu.nroitm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    t-ccbddocu.almdes = s-codalm
    t-ccbddocu.undvta = Almmmatg.Chr__01
    t-ccbddocu.factor = F-FACTOR
    t-ccbddocu.pordto = DEC(t-ccbddocu.pordto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
  ASSIGN
    t-ccbddocu.PreBas = F-PREBAS
    t-ccbddocu.AftIgv = Almmmatg.AftIgv 
    t-ccbddocu.AftIsc = Almmmatg.AftIsc 
    t-ccbddocu.Por_DSCTOS[2] = Almmmatg.PorMax
    t-ccbddocu.ImpDto = ROUND( t-ccbddocu.PreBas * (t-ccbddocu.PorDto / 100) * t-ccbddocu.Candes , 2 )
    t-ccbddocu.ImpLin = ROUND( t-ccbddocu.PreUni * t-ccbddocu.Candes , 2 ).
  IF t-ccbddocu.AftIsc 
  THEN t-ccbddocu.ImpIsc = ROUND(t-ccbddocu.PreBas * t-ccbddocu.Candes * (Almmmatg.PorIsc / 100),4).
  IF t-ccbddocu.AftIgv 
  THEN t-ccbddocu.ImpIgv = t-ccbddocu.ImpLin - ROUND(t-ccbddocu.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).


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
  I-NROITM = 1.
  FOR EACH b-ccbddocu:
    b-ccbddocu.nroitm = I-NROITM.
    I-NROITM = I-NROITM + 1.
  END.
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
  RUN Pinta-Totales.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
    FILL-IN-impdto = 0
    FILL-IN-impigv = 0
    FILL-IN-impisc = 0
    FILL-IN-impexo = 0
    FILL-IN-imptot = 0
    FILL-IN-impvta = 0.
  FOR EACH b-ccbddocu NO-LOCK:
    ASSIGN
        FILL-IN-impdto = FILL-IN-impdto + b-ccbddocu.impdto
        FILL-IN-impigv = FILL-IN-impigv + b-ccbddocu.impigv
        FILL-IN-impisc = FILL-IN-impisc + b-ccbddocu.impisc
        FILL-IN-imptot = FILL-IN-imptot + b-ccbddocu.implin.
    IF b-ccbddocu.aftigv = NO
    THEN FILL-IN-impexo = FILL-IN-impexo + b-ccbddocu.implin.
  END.
  ASSIGN
    FILL-IN-impigv = ROUND(FILL-IN-impigv,2)
    FILL-IN-impisc = ROUND(FILL-IN-impisc,2)
    FILL-IN-impbrt = FILL-IN-imptot -
                        FILL-IN-impigv -
                        FILL-IN-impisc -
                        FILL-IN-impexo +
                        FILL-IN-impdto
    FILL-IN-impvta = FILL-IN-impbrt - FILL-IN-impdto.
  DISPLAY 
    FILL-IN-ImpBrt FILL-IN-ImpDto FILL-IN-ImpExo FILL-IN-ImpIgv 
    FILL-IN-ImpIsc FILL-IN-ImpTot FILL-IN-ImpVta
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH b-ccbddocu:
    F-FACTOR = b-ccbddocu.Factor.
    FIND Almmmatg WHERE 
        Almmmatg.CodCia = S-CODCIA AND  
        Almmmatg.codmat = b-ccbddocu.codmat 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg 
    THEN DO:
        RUN Calculo-Precios.
        ASSIGN 
            b-ccbddocu.PreBas = F-PreBas 
            b-ccbddocu.AftIgv = Almmmatg.AftIgv 
            b-ccbddocu.AftIsc = Almmmatg.AftIsc
            b-ccbddocu.PreUni = F-PREVTA
            b-ccbddocu.PorDto = F-DSCTOS
            b-ccbddocu.ImpDto = ROUND( b-ccbddocu.PreBas * (F-DSCTOS / 100) * b-ccbddocu.CanDes , 2)
            b-ccbddocu.ImpLin = ROUND( b-ccbddocu.PreUni * b-ccbddocu.CanDes , 2 ).  
        IF b-ccbddocu.AftIsc 
        THEN b-ccbddocu.ImpIsc = ROUND(b-ccbddocu.PreBas * b-ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        IF b-ccbddocu.AftIgv 
        THEN b-ccbddocu.ImpIgv = b-ccbddocu.ImpLin - ROUND(b-ccbddocu.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
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
  {src/adm/template/snd-list.i "t-ccbddocu"}
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

  /* Valida # de Items a facturar */
  IF INTEGER(t-ccbddocu.nroitm:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > FacCfgGn.Items_Factura
  THEN DO:
    MESSAGE "La cantidad items a factura no debe ser mayor a" FacCfgGn.Items_Factura
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  /* Valida digitacion */
  IF DEC(t-ccbddocu.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0
  THEN DO:
    MESSAGE "La cantidad debe ser mayor a cero"
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  IF DEC(t-ccbddocu.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0
  THEN DO:
    MESSAGE "El precio unitario debe ser mayor a cero"
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  /* Valida Maestro Productos */
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
    AND  Almmmatg.codmat = t-ccbddocu.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg 
  THEN DO:
    MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  IF Almmmatg.TpoArt = "D" 
  THEN DO:
    MESSAGE "Articulo NO Activo" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  IF Almmmatg.Chr__01 = "" THEN DO:
    MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  /* Valida Maestro Productos x Almacen */
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
    AND  Almmmate.CodAlm = S-CODALM 
    AND  Almmmate.CodMat = t-ccbddocu.codmat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate 
  THEN DO:
    MESSAGE "Articulo no esta asignado al" SKIP
            "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.   
  END.
  /* Validacion de unidades y cantidades */   
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = Almmmatg.Chr__01 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv 
  THEN DO:
    MESSAGE "Codigo de unidad" almmmatg.chr__01 "no existe" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.
  IF Almtconv.Multiplos <> 0 
  THEN DO:
    IF DEC(t-ccbddocu.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos <> 
        INT(DEC(t-ccbddocu.CanDes:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) / Almtconv.Multiplos) 
    THEN DO:
        MESSAGE " La Cantidad debe de ser un, " SKIP
                " multiplo de : " Almtconv.Multiplos
                VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR':U.
    END.
  END.
  /* Validacion de precios */
  RUN Calculo-Precios.      /* Aqui nos interesa el F-PREBAS y F-PREVTA (se usa tambien en local-assign-statement) */
  IF F-PREVTA > DEC(t-ccbddocu.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) 
  THEN DO:
    MESSAGE "No Autorizado para reducir Precios" 
    VIEW-AS ALERT-BOX ERROR.
    DISPLAY F-PREVTA @ t-ccbddocu.PreUni WITH BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR':U.   
  END.
  RETURN 'OK'.
  
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

