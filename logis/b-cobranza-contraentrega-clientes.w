&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE clientes NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEFINE BUFFER x-clientes FOR clientes.

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
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES clientes

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table clientes.Llave-C ~
clientes.Campo-C[1] clientes.Campo-F[1] clientes.Campo-F[2] ~
clientes.Campo-F[3] clientes.Campo-F[4] clientes.Campo-F[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table clientes.Campo-F[2] ~
clientes.Campo-F[3] clientes.Campo-F[4] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table clientes
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table clientes
&Scoped-define QUERY-STRING-br_table FOR EACH clientes WHERE clientes.Task-No = integer(di-rutaC.nrodoc) NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH clientes WHERE clientes.Task-No = integer(di-rutaC.nrodoc) NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table clientes
&Scoped-define FIRST-TABLE-IN-QUERY-br_table clientes


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-total FILL-IN-efectivo ~
FILL-IN-billetera FILL-IN-deposito FILL-IN-cobrado 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ff_just_right B-table-Win 
FUNCTION ff_just_right RETURNS CHAR ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-billetera AS DECIMAL FORMAT ">>,>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .62
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-cobrado AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 17.72 BY .85
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-deposito AS DECIMAL FORMAT ">>,>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .62
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-efectivo AS DECIMAL FORMAT ">>,>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 10 BY .62
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total AS DECIMAL FORMAT ">>,>>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 12 BY .5
     FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      clientes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      clientes.Llave-C COLUMN-LABEL "Codigo" FORMAT "x(12)":U WIDTH 9.29
      clientes.Campo-C[1] COLUMN-LABEL "Razon Social" FORMAT "X(50)":U
            WIDTH 27.72
      clientes.Campo-F[1] COLUMN-LABEL "Cobrar Soles" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 10.14
      clientes.Campo-F[2] COLUMN-LABEL "Efectivo" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.43
      clientes.Campo-F[3] COLUMN-LABEL "Billetera!Electronica" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.14
      clientes.Campo-F[4] COLUMN-LABEL "Deposito!Bancario" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.72
      clientes.Campo-F[5] COLUMN-LABEL "Cobrados" FORMAT ">>,>>>,>>9.99":U
            WIDTH 9.57
  ENABLE
      clientes.Campo-F[2]
      clientes.Campo-F[3]
      clientes.Campo-F[4]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS NO-VALIDATE SIZE 93.86 BY 9.38
         FONT 4
         TITLE "Clientes para cobrar".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1.14
     FILL-IN-total AT ROW 10.42 COL 38 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-efectivo AT ROW 10.42 COL 50 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     FILL-IN-billetera AT ROW 10.42 COL 71 RIGHT-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-deposito AT ROW 10.42 COL 82 RIGHT-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-cobrado AT ROW 11.23 COL 72.29 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     "Total COBRADO" VIEW-AS TEXT
          SIZE 22 BY .85 AT ROW 11.23 COL 52 WIDGET-ID 18
          FGCOLOR 12 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: clientes T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 11.35
         WIDTH              = 94.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-billetera IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-cobrado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-deposito IN FRAME F-Main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-efectivo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.clientes WHERE INTEGRAL.DI-RutaC <external> ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "clientes.Task-No = integer(di-rutaC.nrodoc)"
     _FldNameList[1]   > Temp-Tables.clientes.Llave-C
"clientes.Llave-C" "Codigo" "x(12)" "character" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.clientes.Campo-C[1]
"clientes.Campo-C[1]" "Razon Social" "X(50)" "character" ? ? ? ? ? ? no ? no no "27.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.clientes.Campo-F[1]
"clientes.Campo-F[1]" "Cobrar Soles" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.clientes.Campo-F[2]
"clientes.Campo-F[2]" "Efectivo" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.clientes.Campo-F[3]
"clientes.Campo-F[3]" "Billetera!Electronica" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.clientes.Campo-F[4]
"clientes.Campo-F[4]" "Deposito!Bancario" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.clientes.Campo-F[5]
"clientes.Campo-F[5]" "Cobrados" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Clientes para cobrar */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Clientes para cobrar */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Clientes para cobrar */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clientes.Campo-F[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clientes.Campo-F[2] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF clientes.Campo-F[2] IN BROWSE br_table /* Efectivo */
DO:
    RUN TOTALes(2,DECIMAL(SELF:SCREEN-VALUE), ROWID(clientes)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clientes.Campo-F[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clientes.Campo-F[3] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF clientes.Campo-F[3] IN BROWSE br_table /* Billetera!Electronica */
DO:
  RUN TOTALes (3,DECIMAL(SELF:SCREEN-VALUE), ROWID(clientes)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME clientes.Campo-F[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL clientes.Campo-F[4] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF clientes.Campo-F[4] IN BROWSE br_table /* Deposito!Bancario */
DO:
  RUN TOTALes (4,DECIMAL(SELF:SCREEN-VALUE), ROWID(clientes)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* TAB AUTOMATICO */
ON 'RETURN':U OF clientes.campo-f[2], clientes.campo-f[3], clientes.campo-f[4] IN BROWSE {&BROWSE-NAME} DO:
    APPLY 'TAB':U.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info B-table-Win 
PROCEDURE carga-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR clientes.

SESSION:SET-WAIT-STATE("GENERAL").


{&open-query-br_table}
    

SESSION:SET-WAIT-STATE("").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabamos-info B-table-Win 
PROCEDURE grabamos-info :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-efectivo FILL-in-billetera FILL-in-deposito FILL-in-total .
END.

DEFINE BUFFER b-cobranza_hr_cliente FOR cobranza_hr_cliente.
          
GRABACION:            
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":

    pMsg = "Eliminando registros anteriores de cobranza_hr_cliente".
    FOR EACH cobranza_hr_cliente WHERE cobranza_hr_cliente.nruta = di-rutaC.nrodoc NO-LOCK:
        FIND FIRST b-cobranza_hr_cliente WHERE ROWID(b-cobranza_hr_cliente) = ROWID(cobranza_hr_cliente) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED b-cobranza_hr_cliente THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + "La tabla cobranza_hr_cliente esta bloqueada por otro usuario".
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
        /* Eliminar */
        DELETE cobranza_hr_cliente NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
    END.
            .
    /* Lo comprobantes */
    FOR EACH clientes WHERE clientes.task-no = integer(di-rutaC.nrodoc) NO-LOCK:
        FIND FIRST cobranza_hr_cliente WHERE cobranza_hr_cliente.nruta = di-rutaC.nrodoc AND
                        cobranza_hr_cliente.ccliente = clientes.llave-C NO-LOCK NO-ERROR.
        IF AVAILABLE cobranza_hr_cliente THEN DO:
            pMsg = "El codigo de cliente con esta misma hoja de ruta " + clientes.llave-C + " ya fue registrado".
            UNDO GRABACION, RETURN "ADM-ERROR".
        END.
        pMsg = "Grabando clientes a cobrar cobranza_hr_cliente :" + clientes.llave-C.
        CREATE cobranza_hr_cliente.
        ASSIGN cobranza_hr_cliente.nruta = di-rutaC.nrodoc
                cobranza_hr_cliente.usuario = USERID("DICTDB")
                cobranza_hr_cliente.fregistro = TODAY
                cobranza_hr_cliente.hregistro = STRING(TIME,"hh:mm:ss")
                cobranza_hr_cliente.ccliente = clientes.llave-C
                cobranza_hr_cliente.icobrarsoles = clientes.campo-f[1]
                cobranza_hr_cliente.iefectivosoles = clientes.campo-f[2]
                cobranza_hr_cliente.ibilleteraelectrosoles = clientes.campo-f[3]
                cobranza_hr_cliente.idepobancariosoles = clientes.campo-f[4] NO-ERROR.
        
        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.

    END.
END.

pMsg = "".

RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-cobranza B-table-Win 
PROCEDURE grabar-cobranza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER pRetval AS LOG.

DEFINE VAR dCobrar AS DEC.
DEFINE VAR dCobrado AS DEC.
DEFINE VAR dEfectivo AS DEC.
DEFINE VAR dBilletera AS DEC.
DEFINE VAR dDeposito AS DEC.

DEFINE VAR dDiferencias AS DEC.

pRetval = YES.

VALIDA:
FOR EACH x-clientes WHERE x-clientes.task-no = INTEGER(di-rutaC.nrodoc) NO-LOCK:

    dCobrar = x-clientes.campo-f[1].
    dCobrado = x-clientes.campo-f[2] + x-clientes.campo-f[3] + x-clientes.campo-f[4].

    IF dCobrado = 0 THEN NEXT.

    dDiferencias = ABSOLUTE(dCobrar - dCobrado).

    IF dCobrado > dCobrar AND dDiferencias > 1  THEN DO:
        MESSAGE "El cliente " + x-clientes.campo-c[1] SKIP
                "Se esta cobrando en exceso: " + STRING(dCobrado) + " con su deuda: " + STRING(dCobrar)
                VIEW-AS ALERT-BOX INFORMATION.

        pRetval = NO.

        LEAVE VALIDA.
    END.
END.

IF pRetval = YES THEN DO:
    
    FIND FIRST cobranza_hr WHERE cobranza_hr.nruta = di-rutaC.nrodoc NO-LOCK NO-ERROR.
    
    IF AVAILABLE cobranza_hr AND cobranza_hr.flgest = 'C' THEN DO:
        MESSAGE "La Hoja de ruta " + di-rutaC.nrodoc SKIP
                "ya le registraron las cobranzas"
                VIEW-AS ALERT-BOX INFORMATION.

        pRetval = NO.
    END.
    
END.

RUN local-update-record.


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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[2]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[4]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[2]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[4]:READ-ONLY IN BROWSE {&BROWSE-NAME}= NO.


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

  /*
  /* Code placed here will execute AFTER standard behavior.    */
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[2]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[3]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
  {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.campo-f[4]:READ-ONLY IN BROWSE {&BROWSE-NAME}= YES.
*/
    DEFINE VAR dTotal1 AS DEC.
    DEFINE VAR dTotal2 AS DEC.
    DEFINE VAR dTotal3 AS DEC.
    DEFINE VAR dTotal4 AS DEC.

    DO WITH FRAME {&FRAME-NAME}:
        /*GET FIRST {&BROWSE-NAME}.*/
        DO  WHILE AVAILABLE clientes:
            dTotal1 = dTotal1 + clientes.campo-f[1].
            dTotal2 = dTotal2 + clientes.campo-f[2].
            dTotal3 = dTotal3 + clientes.campo-f[3].
            dTotal4 = dTotal4 + clientes.campo-f[4].
            GET NEXT {&BROWSE-NAME}.
        END.
        fill-in-total:SCREEN-VALUE = STRING(dTotal1).        
        fill-in-efectivo:SCREEN-VALUE = STRING(dTotal2).
        fill-in-billetera:SCREEN-VALUE = STRING(dTotal3).
        fill-in-deposito:SCREEN-VALUE = STRING(dTotal4).
        fill-in-cobrado:SCREEN-VALUE = STRING(dTotal2 + dTotal3 + dTotal4).

        br_table:TITLE = "Clientes de la H/R ".
        IF AVAILABLE di-rutaC THEN br_table:TITLE = "Clientes de la H/R " + di-rutac.nrodoc.

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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "clientes"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totales B-table-Win 
PROCEDURE totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER iCol AS INT.
DEFINE INPUT PARAMETER dValue AS DEC.
DEFINE INPUT PARAMETER rRowId AS ROWID.

    DEFINE VAR dTotal AS DEC.
    DEFINE VAR dTotalCobrado AS DEC.
    DEFINE VAR dTotalCliente AS DEC.

    dTotal = dValue.

    DO WITH FRAME {&FRAME-NAME}:

        dTotalCliente = decimal(clientes.campo-f[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        dTotalCliente = dTotalCliente + decimal(clientes.campo-f[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        dTotalCliente = dTotalCliente + decimal(clientes.campo-f[4]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
        
        ASSIGN clientes.campo-f[5]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(dTotalCliente).

        dTotalCobrado = dTotalCliente.
        FOR EACH x-clientes WHERE x-clientes.task-no = INTEGER(di-rutaC.nrodoc) NO-LOCK:
            
            IF ROWID(x-clientes) <> rRowId THEN DO:
                dTotalCobrado = dTotalCobrado + (x-clientes.campo-f[2] + x-clientes.campo-f[3] + x-clientes.campo-f[4]).
                dTotal = dTotal + x-clientes.campo-f[icol].
            END.
                
        END.

        IF iCol = 1 THEN DO:
            fill-in-total:SCREEN-VALUE = STRING(dTotal).
        END.
        
        IF iCol = 2 THEN DO:
            fill-in-efectivo:SCREEN-VALUE = STRING(dTotal).
        END.

        IF iCol = 3 THEN DO:
            fill-in-billetera:SCREEN-VALUE = STRING(dTotal).
        END.

        IF iCol = 4 THEN DO:
            fill-in-deposito:SCREEN-VALUE = STRING(dTotal).
        END.

        fill-in-cobrado:SCREEN-VALUE = STRING(dTotalCobrado).

        /*
        ff_just_right(INPUT fill-in-total:HANDLE IN FRAME {&FRAME-NAME}).
        ff_just_right(INPUT fill-in-efectivo:HANDLE IN FRAME {&FRAME-NAME}).
        ff_just_right(INPUT fill-in-billetera:HANDLE IN FRAME {&FRAME-NAME}).
        ff_just_right(INPUT fill-in-deposito:HANDLE IN FRAME {&FRAME-NAME}).
        */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ff_just_right B-table-Win 
FUNCTION ff_just_right RETURNS CHAR ( INPUT h AS HANDLE ) :
    DEFINE VARIABLE reps AS INTEGER     NO-UNDO.

    reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
    h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).
    RETURN 'OK'.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

