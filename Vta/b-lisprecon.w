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
DEF SHARED VAR s-user-id AS CHAR.

DEFINE VARIABLE X-CTOTOT AS DECIMAL FORMAT "->>>>>>>>>9.999999" NO-UNDO.
DEFINE VARIABLE X-CTOUND AS DECIMAL NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE SHARED VARIABLE S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.

DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE F-MrgUti-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PreVta-A AS DECIMAL NO-UNDO.
DEFINE VARIABLE X-Mon AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Almmmatp Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almmmatp.codmat Almmmatg.DesMat ~
Almmmatg.UndBas Almmmatg.DesMar Almmmatg.MonVta ~
IF Almmmatg.MonVta = 1 THEN 'S/.' ELSE 'US$' @ x-Mon almmmatp.TpoCmb ~
Almmmatp.CtoLis Almmmatp.CtoTot Almmmatp.Dec__01 Almmmatp.PreOfi ~
Almmmatp.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table almmmatp.TpoCmb ~
Almmmatp.CtoLis Almmmatp.Dec__01 Almmmatp.PreOfi 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}CtoLis ~{&FP2}CtoLis ~{&FP3}~
 ~{&FP1}Dec__01 ~{&FP2}Dec__01 ~{&FP3}~
 ~{&FP1}PreOfi ~{&FP2}PreOfi ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table almmmatp
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table almmmatp
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Almmmatp WHERE ~{&KEY-PHRASE} ~
      AND Almmmatp.CodCia = s-codcia NO-LOCK, ~
      FIRST Almmmatg OF Almmmatp NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table Almmmatp Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Almmmatp


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Asignar" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      Almmmatp, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almmmatp.codmat COLUMN-LABEL "Articulo"
      Almmmatg.DesMat FORMAT "X(65)"
      Almmmatg.UndBas FORMAT "X(6)"
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(15)"
      Almmmatg.MonVta
      IF Almmmatg.MonVta = 1 THEN 'S/.' ELSE 'US$' @ x-Mon COLUMN-LABEL "Mon" FORMAT "x(4)"
      almmmatp.TpoCmb
      Almmmatp.CtoLis COLUMN-LABEL "Precio Costo!Lista S/IGV"
      Almmmatp.CtoTot COLUMN-LABEL "Precio Costo!Lista Total"
      Almmmatp.Dec__01 COLUMN-LABEL "%Marg Utilid!Pre.Ofi." FORMAT "->>9.99"
      Almmmatp.PreOfi COLUMN-LABEL "Precio de Oficina"
      Almmmatp.Chr__01 COLUMN-LABEL "UM.!Pre.Ofi." FORMAT "X(6)"
  ENABLE
      almmmatp.TpoCmb
      Almmmatp.CtoLis
      Almmmatp.Dec__01
      Almmmatp.PreOfi
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 107 BY 10.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.88 COL 1
     BUTTON-1 AT ROW 2.35 COL 92
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
         HEIGHT             = 13.42
         WIDTH              = 107.57.
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
     _TblList          = "INTEGRAL.Almmmatp,INTEGRAL.Almmmatg OF INTEGRAL.Almmmatp"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "INTEGRAL.Almmmatp.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.Almmmatp.codmat
"Almmmatp.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(65)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.Almmmatg.UndBas
"Almmmatg.UndBas" ? "X(6)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(15)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   = INTEGRAL.Almmmatg.MonVta
     _FldNameList[6]   > "_<CALC>"
"IF Almmmatg.MonVta = 1 THEN 'S/.' ELSE 'US$' @ x-Mon" "Mon" "x(4)" ? ? ? ? ? ? ? no ?
     _FldNameList[7]   > INTEGRAL.almmmatp.TpoCmb
"almmmatp.TpoCmb" ? ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > INTEGRAL.Almmmatp.CtoLis
"Almmmatp.CtoLis" "Precio Costo!Lista S/IGV" ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[9]   > INTEGRAL.Almmmatp.CtoTot
"Almmmatp.CtoTot" "Precio Costo!Lista Total" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[10]   > INTEGRAL.Almmmatp.Dec__01
"Almmmatp.Dec__01" "%Marg Utilid!Pre.Ofi." "->>9.99" "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[11]   > INTEGRAL.Almmmatp.PreOfi
"Almmmatp.PreOfi" "Precio de Oficina" ? "decimal" ? ? ? ? ? ? yes ?
     _FldNameList[12]   > INTEGRAL.Almmmatp.Chr__01
"Almmmatp.Chr__01" "UM.!Pre.Ofi." "X(6)" "character" ? ? ? ? ? ? no ?
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


&Scoped-define SELF-NAME Almmmatp.CtoLis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatp.CtoLis br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatp.CtoLis IN BROWSE br_table /* Precio Costo!Lista S/IGV */
DO:

   ASSIGN
    X-CTOTOT = DECIMAL(Almmmatp.CtoLis:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
   
   Almmmatp.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = IF Almmmatg.AftIgv THEN 
                                                              STRING(X-CTOTOT * (1 + FacCfgGn.PorIgv / 100))
                                                           ELSE STRING(X-CTOTOT).

  ASSIGN
    F-PreVta-A = DECIMAL(Almmmatp.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    X-CTOUND = DECIMAL(Almmmatp.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-FACTOR = 1
    F-MrgUti-A = 0.    
  /****   Busca el Factor de conversion   ****/
  IF Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
  END.
  /*******************************************/
  DISPLAY F-MrgUti-A @ Almmmatp.Dec__01 WITH BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatp.Dec__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatp.Dec__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatp.Dec__01 IN BROWSE br_table /* %Marg Utilid!Pre.Ofi. */
DO:
  ASSIGN
    F-MrgUti-A = DECIMAL(Almmmatp.Dec__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    X-CTOUND   = DECIMAL(Almmmatp.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-FACTOR = 1.
    F-PreVta-A = 0.
  /****   Busca el Factor de conversion   ****/
  IF Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no exixte" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-PreVta-A = ROUND(( X-CTOUND * (1 + F-MrgUti-A / 100) ), 6) * F-FACTOR.
  END.
  DISPLAY F-PreVta-A @ Almmmatp.PreOfi WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatp.PreOfi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatp.PreOfi br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatp.PreOfi IN BROWSE br_table /* Precio de Oficina */
DO:
  ASSIGN
    F-PreVta-A = DECIMAL(Almmmatp.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    X-CTOUND = DECIMAL(Almmmatp.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    F-FACTOR = 1
    F-MrgUti-A = 0.    
  /****   Busca el Factor de conversion   ****/
  IF Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "" THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
        AND  Almtconv.Codalter = Almmmatp.Chr__01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE "Codigo de unidad no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    F-FACTOR = Almtconv.Equival.
    F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
  END.
  /*******************************************/
  DISPLAY F-MrgUti-A @ Almmmatp.Dec__01 WITH BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatp.Chr__01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatp.Chr__01 br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Almmmatp.Chr__01 IN BROWSE br_table /* UM.!Pre.Ofi. */
DO:
   FIND Unidades WHERE Unidades.Codunid = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Unidades THEN DO:
      MESSAGE "Unidad no registrada ..." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.   
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Asignar */
DO:
  RUN Asigna-Codigo.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  REPOSITION {&BROWSE-NAME} TO ROWID output-var-1.
  RUN dispatch IN THIS-PROCEDURE ('row-changed':U).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON "RETURN":U OF Almmmatp.CtoLis,Almmmatp.Chr__01,Almmmatp.Dec__01,Almmmatp.PreOfi
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Codigo B-table-Win 
PROCEDURE Asigna-Codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN
    input-var-1 = ''
    input-var-2 = ''
    input-var-3 = ''
    output-var-1 = ?
    output-var-2 = ''
    output-var-3 = ''.
  RUN lkup/c-listpr2 ('Catalogo de Productos').
  IF output-var-1 <> ? THEN DO:
    FIND Almmmatg WHERE ROWID(Almmmatg) = output-var-1 NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        FIND Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatp THEN DO:
            CREATE Almmmatp.
            BUFFER-COPY Almmmatg TO Almmmatp.
            output-var-1 = ROWID(Almmmatp).
            message STRING(output-var-1).
        END.
        ELSE output-var-1 = ROWID(Almmmatp).
    END.
    ELSE output-var-1 = ?.
  END.
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE F-PreAnt LIKE Almmmatg.PreBas  NO-UNDO.
  IF AVAILABLE Almmmatg THEN F-PreAnt = Almmmatg.PreBas.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      Almmmatp.CtoTot = DEC(Almmmatp.CtoTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      Almmmatp.CtoUnd = DEC(Almmmatp.CtoLis:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      almmmatp.DesMat = Almmmatg.DesMat
      almmmatp.DesMar = Almmmatg.DesMar.

  IF Almmmatg.AftIgv THEN 
    Almmmatp.PreBas = ROUND((DEC(Almmmatp.PreOfi:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})) / ( 1 + FacCfgGn.PorIgv / 100), 6).

  Almmmatp.MrgUti = ((Almmmatp.Prevta[1] / Almmmatp.Ctotot) - 1 ) * 100. 

  F-FACTOR = 1.
  IF F-PreAnt <> Almmmatp.PreBas THEN Almmmatp.FchmPre[3] = TODAY.
  Almmmatp.FchmPre[1] = TODAY.
  Almmmatp.Usuario = S-USER-ID.
  Almmmatp.FchAct  = TODAY.
  
/*  FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
 *     AND Almtfami.codfam = Almmmatg.Codfam
 *     NO-LOCK NO-ERROR.
 *   IF AVAILABLE Almtfami THEN Almmmatp.TpoCmb = Almtfami.Tpocmb.*/

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
  {src/adm/template/snd-list.i "Almmmatp"}
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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMoneda B-table-Win 
FUNCTION fMoneda RETURNS CHARACTER
  ( INPUT pCodMon AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF pCodMon = 1 THEN RETURN 'S/.'.
  IF pCodMon = 2 THEN RETURN 'US$'.
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


