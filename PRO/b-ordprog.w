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
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.

DEFINE BUFFER B-PR-ODPC FOR PR-ODPC.

DEFINE SHARED VAR lh_Handle AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES PR-ODPC
&Scoped-define FIRST-EXTERNAL-TABLE PR-ODPC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-ODPC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PR-ODPDG PR-GASTOS gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PR-ODPDG.codgas PR-GASTOS.Desgas ~
PR-ODPDG.CodPro gn-prov.NomPro PR-ODPDG.Cantidad PR-ODPDG.UndA ~
PR-ODPDG.CodMon PR-ODPDG.CtoUni 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PR-ODPDG.codgas ~
PR-ODPDG.CodPro PR-ODPDG.Cantidad PR-ODPDG.CodMon PR-ODPDG.CtoUni 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PR-ODPDG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PR-ODPDG
&Scoped-define QUERY-STRING-br_table FOR EACH PR-ODPDG OF PR-ODPC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH PR-GASTOS WHERE PR-GASTOS.CodCia = PR-ODPDG.Codcia ~
  AND PR-GASTOS.CodGas = PR-ODPDG.codgas NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = PV-CODCIA ~
  AND gn-prov.CodPro = PR-ODPDG.CodPro NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PR-ODPDG OF PR-ODPC WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH PR-GASTOS WHERE PR-GASTOS.CodCia = PR-ODPDG.Codcia ~
  AND PR-GASTOS.CodGas = PR-ODPDG.codgas NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = PV-CODCIA ~
  AND gn-prov.CodPro = PR-ODPDG.CodPro NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PR-ODPDG PR-GASTOS gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PR-ODPDG
&Scoped-define SECOND-TABLE-IN-QUERY-br_table PR-GASTOS
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-prov


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
      PR-ODPDG, 
      PR-GASTOS, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PR-ODPDG.codgas COLUMN-LABEL "Codigo!Gas/Serv" FORMAT "X(8)":U
      PR-GASTOS.Desgas COLUMN-LABEL "Descripcion!Gas/Serv" FORMAT "X(35)":U
      PR-ODPDG.CodPro COLUMN-LABEL "Código!Proveedor" FORMAT "x(13)":U
      gn-prov.NomPro FORMAT "x(50)":U
      PR-ODPDG.Cantidad FORMAT ">>>,>>9.99":U
      PR-ODPDG.UndA COLUMN-LABEL "UM" FORMAT "x(4)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      PR-ODPDG.CodMon COLUMN-LABEL "Moneda" FORMAT "9":U WIDTH 8.14
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      PR-ODPDG.CtoUni COLUMN-LABEL "Precio" FORMAT ">>>,>>,>>9.9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
  ENABLE
      PR-ODPDG.codgas
      PR-ODPDG.CodPro
      PR-ODPDG.Cantidad
      PR-ODPDG.CodMon
      PR-ODPDG.CtoUni
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 116.72 BY 8.88
         FONT 4
         TITLE "Servicios - Gastos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PR-ODPC
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
         HEIGHT             = 10.92
         WIDTH              = 127.43.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.PR-ODPDG OF INTEGRAL.PR-ODPC,INTEGRAL.PR-GASTOS WHERE INTEGRAL.PR-ODPDG ...,INTEGRAL.gn-prov WHERE INTEGRAL.PR-ODPDG ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ",,"
     _JoinCode[2]      = "integral.PR-GASTOS.CodCia = integral.PR-ODPDG.Codcia
  AND integral.PR-GASTOS.CodGas = integral.PR-ODPDG.codgas"
     _JoinCode[3]      = "integral.gn-prov.CodCia = PV-CODCIA
  AND integral.gn-prov.CodPro = integral.PR-ODPDG.CodPro"
     _FldNameList[1]   > integral.PR-ODPDG.codgas
"PR-ODPDG.codgas" "Codigo!Gas/Serv" "X(8)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > integral.PR-GASTOS.Desgas
"PR-GASTOS.Desgas" "Descripcion!Gas/Serv" "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > integral.PR-ODPDG.CodPro
"PR-ODPDG.CodPro" "Código!Proveedor" "x(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = integral.gn-prov.NomPro
     _FldNameList[5]   > integral.PR-ODPDG.Cantidad
"PR-ODPDG.Cantidad" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > integral.PR-ODPDG.UndA
"PR-ODPDG.UndA" "UM" ? "character" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > integral.PR-ODPDG.CodMon
"PR-ODPDG.CodMon" "Moneda" ? "integer" 11 0 ? ? ? ? yes ? no no "8.14" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[8]   > integral.PR-ODPDG.CtoUni
"PR-ODPDG.CtoUni" "Precio" ? "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Servicios - Gastos */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
      
  FIND FIRST PR-ODPCX OF PR-ODPC NO-LOCK NO-ERROR.
  DISPLAY PR-ODPCX.codund @ PR-ODPDG.UndA WITH BROWSE {&browse-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Servicios - Gastos */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Servicios - Gastos */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-ODPDG.codgas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-ODPDG.codgas br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PR-ODPDG.codgas IN BROWSE br_table /* Codigo!Gas/Serv */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
    FIND PR-GASTO WHERE PR-GASTO.Codcia  = S-CODCIA AND
                        PR-GASTO.CodGas  = SELF:SCREEN-VALUE 
                        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PR-GASTO THEN DO:
       MESSAGE "Codigo de Gasto no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.

    DISPLAY PR-GASTO.Desgas @ PR-GASTO.Desgas 
            WITH BROWSE {&BROWSE-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-ODPDG.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-ODPDG.CodPro br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PR-ODPDG.CodPro IN BROWSE br_table /* Código!Proveedor */
DO:
   IF SELF:SCREEN-VALUE = '' THEN RETURN.
   FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND  
        Gn-Prov.CodPro = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Prov THEN DO:
      MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY Gn-Prov.NomPro @ Gn-Prov.NomPro WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PR-ODPDG.Cantidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PR-ODPDG.Cantidad br_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF PR-ODPDG.Cantidad IN BROWSE br_table /* Cantidad */
DO:
    IF DECIMAL(SELF:SCREEN-VALUE) <> 0 THEN RETURN.
    FIND FIRST PR-ODPCX OF PR-ODPC NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PR-ODPCX THEN RETURN.
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA 
        AND Almmmatg.CodMat = PR-ODPCX.CodArt
        NO-LOCK NO-ERROR.
    FIND PR-PRESER WHERE PR-PRESER.codcia = s-codcia
        AND PR-PRESER.codpro = PR-ODPDG.CodPro:SCREEN-VALUE IN BROWSE {&browse-name}
        AND PR-PRESER.codgas = PR-ODPDG.CodGas:SCREEN-VALUE IN BROWSE {&browse-name}
        AND PR-PRESER.codmat = PR-ODPCX.CodArt
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PR-PRESER THEN RETURN.
    DISPLAY
        PR-PRESER.UndA @ PR-ODPDG.UndA
        PR-PRESER.CanDes[1] @ PR-ODPDG.Cantidad
        PR-PRESER.CodMon @ PR-ODPDG.CodMon
        PR-PRESER.PreLis[1] @ PR-ODPDG.CtoUni
        WITH BROWSE {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF


ON "RETURN":U OF PR-ODPDG.codgas, PR-ODPDG.CodPro, PR-ODPDG.Cantidad,
    PR-ODPDG.CodMon, PR-ODPDG.CtoUni
DO:
  APPLY "TAB":U.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Orden B-table-Win 
PROCEDURE Actualiza-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-TOTGAS AS DECI INIT 0.

FOR EACH PR-ODPDG OF PR-ODPC NO-LOCK:
    X-TOTGAS = X-TOTGAS + PR-ODPDG.CtoTot.
END.

FIND B-PR-ODPC WHERE B-PR-ODPC.Codcia = PR-ODPC.Codcia AND
                     B-PR-ODPC.NumOrd = PR-ODPC.NumOrd EXCLUSIVE-LOCK.
IF AVAILABLE B-PR-ODPC THEN DO:                 
  ASSIGN  
     B-PR-ODPC.CtoGas = X-TOTGAS
     B-PR-ODPC.CtoTot = B-PR-ODPC.CtoMat + B-PR-ODPC.CtoGas
     B-PR-ODPC.CtoPro = B-PR-ODPC.CtoTot / B-PR-ODPC.CanPed.  
  
  RELEASE B-PR-ODPC.
         
END.
  

/*RUN Procesa-Handle IN lh_Handle ('Pagina1').*/

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "PR-ODPC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-ODPC"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE PR-ODPC THEN RETURN .
  FIND FIRST PR-ODPCX OF PR-ODPC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PR-ODPCX THEN RETURN.

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
  DEF VAR x-Rowid AS ROWID.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      PR-ODPDG.Codcia = S-CODCIA 
      PR-ODPDG.UndA   = PR-ODPDG.UndA:SCREEN-VALUE IN BROWSE {&browse-name}
      PR-ODPDG.NumOrd = PR-ODPC.NumOrd.
  x-Rowid = ROWID(PR-ODPDG).
  IF CAN-FIND(FIRST PR-ODPDG OF PR-ODPC WHERE PR-ODPDG.codgas = PR-ODPDG.CodGas:SCREEN-VALUE IN BROWSE {&browse-name}
              AND PR-ODPDG.codpro = PR-ODPDG.CodPro:SCREEN-VALUE IN BROWSE {&browse-name}
              AND ROWID(PR-ODPDG) <> x-Rowid NO-LOCK)
      THEN DO:
      MESSAGE 'Registro repetido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY' TO PR-ODPDG.codgas IN BROWSE {&browse-name}.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* actualizamos tabla PR-PRESER */
  IF PR-ODPDG.Cantidad > 0 AND PR-ODPDG.CtoUni > 0 THEN DO:
      FOR EACH PR-ODPCX OF PR-ODPC NO-LOCK,
          EACH Almmmatg NO-LOCK WHERE Almmmatg.Codcia = S-CODCIA 
              AND Almmmatg.CodMat = PR-ODPCX.CodArt:
          FIND PR-PRESER WHERE PR-PRESER.codcia = s-codcia
              AND PR-PRESER.codpro = PR-ODPDG.CodPro
              AND PR-PRESER.codgas = PR-ODPDG.CodGas
              AND PR-PRESER.codmat = PR-ODPCX.CodArt
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE PR-PRESER THEN CREATE PR-PRESER.
          ASSIGN
              PR-PRESER.Codcia = S-CODCIA
              PR-PRESER.CodPro = PR-ODPDG.CodPro
              PR-PRESER.CodGas = PR-ODPDG.CodGas
              PR-PRESER.CodMat = PR-ODPCX.CodArt
              PR-PRESER.UndA = Almmmatg.UndBas
              PR-PRESER.CanDes[1] = PR-ODPDG.Cantidad
              PR-PRESER.CodMon = PR-ODPDG.CodMon
              PR-PRESER.PreLis[1] = PR-ODPDG.CtoUni.
      END.
  END.
  /* **************************** */
  
  RUN Actualiza-Orden.

  IF AVAILABLE(PR-PRESER) THEN RELEASE PR-PRESER.

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
  /*RETURN "ADM-ERROR".*/
    
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   RUN Actualiza-Orden.

   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

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
  {src/adm/template/snd-list.i "PR-ODPC"}
  {src/adm/template/snd-list.i "PR-ODPDG"}
  {src/adm/template/snd-list.i "PR-GASTOS"}
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
IF PR-ODPDG.CodGas:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Gasto/Servicio no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF PR-ODPDG.CodPro:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
   MESSAGE "Codigo de Proveedor no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

FIND PR-GASTO WHERE PR-GASTO.Codcia  = S-CODCIA AND
    PR-GASTO.CodGas  = PR-ODPDG.codgas:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-GASTO THEN DO:
    MESSAGE "Codigo de Gasto no Existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO PR-ODPDG.codgas IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
END.
FIND Gn-Prov WHERE 
    Gn-Prov.Codcia = pv-codcia AND  
    Gn-Prov.CodPro = PR-ODPDG.codpro:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-Prov THEN DO:
    MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO PR-ODPDG.codpro IN BROWSE {&browse-name}.
    RETURN "ADM-ERROR".
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

IF NOT AVAILABLE PR-ODPC THEN RETURN "ADM-ERROR".

IF PR-ODPC.FlgEst = "C" THEN DO:
   MESSAGE "Orden se encuentra Liquidada " 
   VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.

IF PR-ODPC.FlgEst = "A" THEN DO:
   MESSAGE "Orden se encuentra Anulada " 
   VIEW-AS ALERT-BOX.
   RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

