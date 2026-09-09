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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.

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
&Scoped-define INTERNAL-TABLES PR-PRESER Almmmatg gn-prov PR-GASTOS

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PR-PRESER.CodPro gn-prov.NomPro ~
PR-PRESER.CodGas PR-GASTOS.Desgas PR-PRESER.codmat Almmmatg.DesMat ~
PR-PRESER.UndA PR-PRESER.CanDes[1] PR-PRESER.PreLis[1] PR-PRESER.CodMon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PR-PRESER.CodPro ~
PR-PRESER.CodGas PR-PRESER.codmat PR-PRESER.CanDes[1] PR-PRESER.PreLis[1] ~
PR-PRESER.CodMon 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PR-PRESER
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PR-PRESER
&Scoped-define QUERY-STRING-br_table FOR EACH PR-PRESER WHERE ~{&KEY-PHRASE} ~
      AND PR-PRESER.Codcia = S-CODCIA NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = PR-PRESER.Codcia ~
  AND Almmmatg.codmat = PR-PRESER.codmat NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = pv-codcia ~
  AND gn-prov.CodPro = PR-PRESER.CodPro NO-LOCK, ~
      EACH PR-GASTOS WHERE PR-GASTOS.CodCia = PR-PRESER.Codcia ~
  AND PR-GASTOS.CodGas = PR-PRESER.CodGas NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PR-PRESER WHERE ~{&KEY-PHRASE} ~
      AND PR-PRESER.Codcia = S-CODCIA NO-LOCK, ~
      EACH Almmmatg WHERE Almmmatg.CodCia = PR-PRESER.Codcia ~
  AND Almmmatg.codmat = PR-PRESER.codmat NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodCia = pv-codcia ~
  AND gn-prov.CodPro = PR-PRESER.CodPro NO-LOCK, ~
      EACH PR-GASTOS WHERE PR-GASTOS.CodCia = PR-PRESER.Codcia ~
  AND PR-GASTOS.CodGas = PR-PRESER.CodGas NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table PR-PRESER Almmmatg gn-prov ~
PR-GASTOS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PR-PRESER
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table gn-prov
&Scoped-define FOURTH-TABLE-IN-QUERY-br_table PR-GASTOS


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
      PR-PRESER, 
      Almmmatg, 
      gn-prov, 
      PR-GASTOS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PR-PRESER.CodPro COLUMN-LABEL "Código!Proveedor" FORMAT "x(13)":U
      gn-prov.NomPro COLUMN-LABEL "Nombre o Razon Social!Proveedor" FORMAT "x(20)":U
      PR-PRESER.CodGas COLUMN-LABEL "Concepto" FORMAT "X(8)":U
      PR-GASTOS.Desgas COLUMN-LABEL "Descripcion!Concepto" FORMAT "X(15)":U
      PR-PRESER.codmat COLUMN-LABEL "Codigo !Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat COLUMN-LABEL "Descripción!Articulo" FORMAT "X(20)":U
      PR-PRESER.UndA COLUMN-LABEL "Unidad" FORMAT "X(6)":U
      PR-PRESER.CanDes[1] COLUMN-LABEL "Cantidad" FORMAT "->>,>>9.99":U
      PR-PRESER.PreLis[1] FORMAT ">>,>>>,>>9.9999":U
      PR-PRESER.CodMon FORMAT "9":U
  ENABLE
      PR-PRESER.CodPro
      PR-PRESER.CodGas
      PR-PRESER.codmat
      PR-PRESER.CanDes[1]
      PR-PRESER.PreLis[1]
      PR-PRESER.CodMon
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 102.43 BY 6.69
         FONT 4.


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
         HEIGHT             = 6.85
         WIDTH              = 102.43.
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
     _TblList          = "INTEGRAL.PR-PRESER,INTEGRAL.Almmmatg WHERE INTEGRAL.PR-PRESER ...,INTEGRAL.gn-prov WHERE INTEGRAL.PR-PRESER ...,INTEGRAL.PR-GASTOS WHERE INTEGRAL.PR-PRESER ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.PR-PRESER.Codcia = S-CODCIA"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = INTEGRAL.PR-PRESER.Codcia
  AND INTEGRAL.Almmmatg.codmat = INTEGRAL.PR-PRESER.codmat"
     _JoinCode[3]      = "INTEGRAL.gn-prov.CodCia = pv-codcia
  AND INTEGRAL.gn-prov.CodPro = INTEGRAL.PR-PRESER.CodPro"
     _JoinCode[4]      = "INTEGRAL.PR-GASTOS.CodCia = INTEGRAL.PR-PRESER.Codcia
  AND INTEGRAL.PR-GASTOS.CodGas = INTEGRAL.PR-PRESER.CodGas"
     _FldNameList[1]   > INTEGRAL.PR-PRESER.CodPro
"PR-PRESER.CodPro" "Código!Proveedor" "x(13)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-prov.NomPro
"gn-prov.NomPro" "Nombre o Razon Social!Proveedor" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.PR-PRESER.CodGas
"PR-PRESER.CodGas" "Concepto" "X(8)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.PR-GASTOS.Desgas
"PR-GASTOS.Desgas" "Descripcion!Concepto" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.PR-PRESER.codmat
"PR-PRESER.codmat" "Codigo !Articulo" "X(8)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" "Descripción!Articulo" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.PR-PRESER.UndA
"PR-PRESER.UndA" "Unidad" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.PR-PRESER.CanDes[1]
"PR-PRESER.CanDes[1]" "Cantidad" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.PR-PRESER.PreLis[1]
"PR-PRESER.PreLis[1]" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.PR-PRESER.CodMon
"PR-PRESER.CodMon" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


ON "RETURN":U OF PR-PRESER.CodPro, PR-PRESER.CodGas, PR-PRESER.CodMat, PR-PRESER.CanDes[1], PR-PRESER.PreLis[1], PR-PRESER.CodMon
 
DO:   
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.

ON "LEAVE":U OF PR-PRESER.CodPro
DO:

  IF SELF:SCREEN-VALUE = "" THEN RETURN .

   /* Valida Maestro Proveedores */
   FIND Gn-Prov WHERE 
        Gn-Prov.Codcia = pv-codcia AND  
        Gn-Prov.CodPro = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Gn-Prov THEN DO:
      MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY Gn-Prov.NomPro @ Gn-Prov.NomPro   
           WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF PR-PRESER.CodGas
DO:

   IF SELF:SCREEN-VALUE = "" THEN RETURN .
   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").

   /* Valida Maestro Proveedores */
   FIND PR-Gastos WHERE 
        PR-Gastos.Codcia = S-CODCIA AND  
        PR-Gastos.CodGas = SELF:SCREEN-VALUE         
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PR-Gastos THEN DO:
      MESSAGE "Codigo de Gastos no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   DISPLAY PR-Gastos.DesGas @ PR-Gastos.DesGas   
           WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF PR-PRESER.CodMat
DO:

   IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.

   SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
   /* Valida Maestro Productos */
   FIND Almmmatg WHERE 
        Almmmatg.CodCia = S-CODCIA AND  
        Almmmatg.codmat = SELF:SCREEN-VALUE 
        use-index matg01
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.TpoArt <> "A" THEN DO:
      MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
   IF Almmmatg.UndBas = "" THEN DO:
      MESSAGE "Articulo no tiene unidad Base" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

   DISPLAY Almmmatg.DesMat @ Almmmatg.DesMat 
           Almmmatg.UndBas @ PR-PRESER.UndA
           WITH BROWSE {&BROWSE-NAME}.
END.

ON "LEAVE":U OF PR-PRESER.CanDes[1]
DO:

   IF DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN .

   /* Valida Maestro Proveedores */
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Cantidad debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF PR-PRESER.PreLis[1]
DO:

   IF DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN .

   /* Valida Maestro Proveedores */
   IF DECI(SELF:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE "Precio debe ser mayor que Cero" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

ON "LEAVE":U OF PR-PRESER.CodMon
DO:

   IF INTEGER(SELF:SCREEN-VALUE) = 0 THEN RETURN .
   /* Valida Maestro Proveedores */
   IF INTEGER(SELF:SCREEN-VALUE) > 2 OR INTEGER(SELF:SCREEN-VALUE) < 1 THEN DO:
      MESSAGE "Moneda debe ser 1=Soles u 2=Dolares Americanos " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     PR-PRESER.Codcia = S-CODCIA.
     PR-PRESER.UndA   = Almmmatg.UndBas.
  END.
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
  {src/adm/template/snd-list.i "PR-PRESER"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "gn-prov"}
  {src/adm/template/snd-list.i "PR-GASTOS"}

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

