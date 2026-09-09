&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
DEF STREAM REPORT.

DEFINE SHARED VARIABLE S-CODTER  LIKE ccbcterm.codter.
DEFINE SHARED VARIABLE S-NOMCIA  AS CHAR.
DEFINE SHARED VARIABLE S-User-Id AS CHAR.
DEFINE SHARED VARIABLE S-CODCIA  AS INT.
DEFINE SHARED VARIABLE S-CODDOC  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHARACTER.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR X-EnLetras AS CHAR FORMAT "X(60)" NO-UNDO.
DEFINE VAR X-Total    AS DECIMAL.
DEFINE VAR Y-Total    AS DECIMAL.
DEFINE VAR E-VISUAL   AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.
DEFINE VAR Y-VISUAL   AS CHARACTER VIEW-AS EDITOR SIZE 50 BY 2.
DEFINE VAR T-DEPSOL   AS DECIMAL.
DEFINE VAR T-DEPDOL   AS DECIMAL.

DEFINE SHARED VARIABLE G-Fecha AS DATE.

DEFINE VARIABLE x-nrodoc LIKE CcbDMvto.nrodoc.

FIND FIRST CcbDMvto WHERE CcbDMvto.FchEmi = G-FECHA NO-ERROR.
     IF AVAILABLE CcbDMvto THEN x-nrodoc = CcbDMvto.nrodoc.

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
&Scoped-define INTERNAL-TABLES CcbDMvto

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbDMvto.CodRef CcbDMvto.NroRef ~
CcbDMvto.TpoRef CcbDMvto.FchVto CcbDMvto.DepNac[2] CcbDMvto.DepUsa[2] ~
CcbDMvto.CodDoc CcbDMvto.NroDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbDMvto WHERE ~{&KEY-PHRASE} ~
      AND CcbDMvto.CodCia = s-codcia ~
 AND CcbDMvto.CodDoc = s-coddoc ~
 AND CcbDMvto.CodCli = s-coddiv ~
 AND CcbDMvto.FchEmi = g-fecha NO-LOCK ~
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table CcbDMvto
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbDMvto


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
      CcbDMvto SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbDMvto.CodRef COLUMN-LABEL "Tipo!Deposito" FORMAT "x(8)"
      CcbDMvto.NroRef COLUMN-LABEL "Nro. Cheque"
      CcbDMvto.TpoRef COLUMN-LABEL "Banco" FORMAT "X(5)"
      CcbDMvto.FchVto COLUMN-LABEL "Fecha!Vencimiento"
      CcbDMvto.DepNac[2] COLUMN-LABEL "Depositado!en S/."
      CcbDMvto.DepUsa[2] COLUMN-LABEL "Depositado!en US$"
      CcbDMvto.CodDoc
      CcbDMvto.NroDoc COLUMN-LABEL "Numero     ."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 50.57 BY 7.81
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.81
         WIDTH              = 54.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.CcbDMvto"
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "integral.CcbDMvto.CodCia = s-codcia
 AND integral.CcbDMvto.CodDoc = s-coddoc
 AND integral.CcbDMvto.CodCli = s-coddiv
 AND integral.CcbDMvto.FchEmi = g-fecha"
     _FldNameList[1]   > integral.CcbDMvto.CodRef
"CcbDMvto.CodRef" "Tipo!Deposito" "x(8)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.CcbDMvto.NroRef
"CcbDMvto.NroRef" "Nro. Cheque" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.CcbDMvto.TpoRef
"CcbDMvto.TpoRef" "Banco" "X(5)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.CcbDMvto.FchVto
"CcbDMvto.FchVto" "Fecha!Vencimiento" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.CcbDMvto.DepNac[2]
"CcbDMvto.DepNac[2]" "Depositado!en S/." ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.CcbDMvto.DepUsa[2]
"CcbDMvto.DepUsa[2]" "Depositado!en US$" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   = integral.CcbDMvto.CodDoc
     _FldNameList[8]   > integral.CcbDMvto.NroDoc
"CcbDMvto.NroDoc" "Numero     ." ? "character" ? ? ? ? ? ? no ?
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

{src/bin/_prns.i}
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

DEF VAR x-desc   AS CHARACTER NO-UNDO.
DEF VAR tot_nac  AS DECIMAL NO-UNDO.
DEF VAR tot_usa  AS DECIMAL NO-UNDO.
DEF VAR tot_nac1 AS DECIMAL NO-UNDO.
DEF VAR tot_usa1 AS DECIMAL NO-UNDO.
DEFINE VAR T-DEPSOL   AS DECIMAL.
DEFINE VAR T-DEPDOL   AS DECIMAL.



/***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
FIND FacCorre WHERE 
     FacCorre.CodCia = s-codcia AND
     FacCorre.CodDiv = s-codDiv AND
     FacCorre.CodDoc = s-coddoc NO-LOCK NO-ERROR.
IF LOOKUP(FacCorre.Printer, s-printer-list) = 0 THEN DO:
   MESSAGE "Impresora " FacCorre.Printer " no esta instalada" VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.
s-port-name = ENTRY(LOOKUP(FacCorre.Printer, s-printer-list), s-port-list).
s-port-name = REPLACE(S-PORT-NAME, ":", "").
***/


DEFINE FRAME F-CAB
    x-desc FORMAT "X(30)"
    CcbDMvto.NroRef 
    CcbDMvto.TpoRef FORMAT "XXX"
    CcbDMvto.DepNac[2] FORMAT "->>,>>>,>>9.99"
    CcbDMvto.DepUsa[2] FORMAT "->>,>>>,>>9.99"
    CcbDMvto.CodDoc 
    CcbDMvto.NroDoc
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
    "Pag.  :" AT 108 PAGE-NUMBER(REPORT) FORMAT ">>>9" SKIP     
    {&PRN2} + {&PRN7A} + {&PRN6A} + "( " + S-CODDIV + " )" + {&PRN6B} + {&PRN7B} + {&PRN3} AT 5 FORMAT "X(20)" 
    {&PRN3} + {&PRN6B} + "TRANSFERENCIA DE CAJA A BOVEDA Nro. " AT 31 FORMAT "X(43)" x-nrodoc FORMAT "XXX-XXXXXX"                       
    "Fecha :" AT 110 TODAY AT 117 FORMAT "99/99/9999" SKIP
    "Cajero :" AT 1 S-CODTER "Hecho por :" AT 56 FORMAT "X(12)" S-User-Id FORMAT "X(12)" 
    "Hora  :" AT 110 STRING(TIME, "HH:MM:SS") SKIP(1)
    "-----------------------------------------------------------------------------------------------------------------------------------" SKIP
    "Movimiento                        Nro. Doc.   DEPOSITO S/.   DEPOSITO US$.  "
    "-----------------------------------------------------------------------------------------------------------------------------------" SKIP        
    WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 200 STREAM-IO DOWN.         
    OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30.
    PUT STREAM Report CONTROL {&PRN0} + {&PRN5A} + CHR(33) + {&PRN3}.  

    FOR EACH integral.CcbDMvto WHERE integral.CcbDMvto.CodCia = s-codcia
             AND integral.CcbDMvto.CodDoc = s-coddoc
             AND integral.CcbDMvto.CodCli = s-coddiv
             AND integral.CcbDMvto.FchEmi = g-fecha                   
             BREAK BY CcbDMvto.CodDoc 
                   BY CcbDMvto.CodRef:                   

        x-desc = "".
        CASE CcbDMvto.CodRef:
            WHEN "EFEC" THEN x-desc = "EFECTIVO".
            WHEN "CHEC" THEN x-desc = "CHEQUES DEL DIA".
            WHEN "CHED" THEN x-desc = "CHEQUES DIFERIDOS".
            WHEN "TARC" THEN x-desc = "TARJETAS DE CREDITO".
            WHEN "BOLD" THEN x-desc = "BOLETAS DE DEPOSITO".
        END CASE.
        
        T-DEPSOL = T-DEPSOL + CcbDMvto.DepNac[2].
        T-DEPDOL = T-DEPDOL + CcbDMvto.DepUsa[2].

        DISPLAY STREAM REPORT
            x-desc 
            CcbDMvto.NroRef 
            CcbDMvto.TpoRef 
            CcbDMvto.DepNac[2] when CcbDMvto.DepNac[2] > 0
            CcbDMvto.DepUsa[2] when CcbDMvto.DepUsa[2] > 0
            CcbDMvto.CodDoc 
            CcbDMvto.NroDoc
            WITH FRAME F-CAB.
            
       IF LAST(CcbDMvto.CodDoc) THEN DO:
          PUT STREAM REPORT "----------------------------------------------------------------" AT 15 SKIP(1).
          PUT STREAM REPORT "TOTAL   : " AT 15
                            T-DEPSOL AT 46 FORMAT "->>,>>>,>>9.99"
                            T-DEPDOL AT 60 FORMAT "->>,>>>,>>9.99" SKIP.
       END.
    END.
    DO WHILE LINE-COUNTER(Report) < PAGE-SIZE(Report) - 4 :
       PUT STREAM Report "" skip.
    END.
    PUT STREAM Report "    ----------------------------                 ----------------------------"  AT 20 SKIP.
    PUT STREAM Report "        Vo.Bo ADMINISTRACION                             Vo.Bo CAJERO        "  AT 20 SKIP.
    OUTPUT STREAM Report CLOSE.

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
  {src/adm/template/snd-list.i "CcbDMvto"}

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


