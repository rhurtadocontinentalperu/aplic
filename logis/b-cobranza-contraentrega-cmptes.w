&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE comprobantes NO-UNDO LIKE w-report.



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
&Scoped-define INTERNAL-TABLES comprobantes

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table comprobantes.Llave-C ~
comprobantes.Campo-C[2] comprobantes.Campo-C[3] comprobantes.Campo-F[1] ~
comprobantes.Campo-F[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table comprobantes.Llave-C 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table comprobantes
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table comprobantes
&Scoped-define QUERY-STRING-br_table FOR EACH comprobantes WHERE comprobantes.Task-No = integer(di-rutaC.nrodoc) NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH comprobantes WHERE comprobantes.Task-No = integer(di-rutaC.nrodoc) NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table comprobantes
&Scoped-define FIRST-TABLE-IN-QUERY-br_table comprobantes


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-total FILL-IN-tipocambio 

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
DEFINE VARIABLE FILL-IN-tipocambio AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Tipo de cambio" 
      VIEW-AS TEXT 
     SIZE 9.29 BY .62
     FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-total AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
      VIEW-AS TEXT 
     SIZE 16.29 BY .62
     FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      comprobantes SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      comprobantes.Llave-C COLUMN-LABEL "Comprobante" FORMAT "x(15)":U
            WIDTH 13.29
      comprobantes.Campo-C[2] COLUMN-LABEL "Razon social" FORMAT "X(50)":U
            WIDTH 33.43
      comprobantes.Campo-C[3] COLUMN-LABEL "Moneda" FORMAT "X(8)":U
            WIDTH 7.43
      comprobantes.Campo-F[1] COLUMN-LABEL "Saldo Soles" FORMAT ">,>>>,>>9.99":U
            WIDTH 8.43
      comprobantes.Campo-F[2] COLUMN-LABEL "Saldo!Mn Orig" FORMAT ">,>>>,>>9.99":U
  ENABLE
      comprobantes.Llave-C
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71.86 BY 9.38
         FONT 4
         TITLE "Comprobantes".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.04 COL 1.14
     FILL-IN-total AT ROW 10.77 COL 53.57 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-tipocambio AT ROW 10.81 COL 16.43 COLON-ALIGNED WIDGET-ID 12
     "Total a cobrar >>>>>>" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 10.85 COL 32 WIDGET-ID 8
          FGCOLOR 9 FONT 6
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
      TABLE: comprobantes T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 10.85
         WIDTH              = 72.57.
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

/* SETTINGS FOR FILL-IN FILL-IN-tipocambio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-total IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.comprobantes Where INTEGRAL.DI-RutaC ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[1]      = "comprobantes.Task-No = integer(di-rutaC.nrodoc)"
     _FldNameList[1]   > Temp-Tables.comprobantes.Llave-C
"comprobantes.Llave-C" "Comprobante" "x(15)" "character" ? ? ? ? ? ? yes ? no no "13.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.comprobantes.Campo-C[2]
"comprobantes.Campo-C[2]" "Razon social" "X(50)" "character" ? ? ? ? ? ? no ? no no "33.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.comprobantes.Campo-C[3]
"comprobantes.Campo-C[3]" "Moneda" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.comprobantes.Campo-F[1]
"comprobantes.Campo-F[1]" "Saldo Soles" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.comprobantes.Campo-F[2]
"comprobantes.Campo-F[2]" "Saldo!Mn Orig" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Comprobantes */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Comprobantes */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Comprobantes */
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

DEFINE INPUT PARAMETER TABLE FOR comprobantes.

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
DEFINE INPUT PARAMETER pCerrar AS LOG.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-tipocambio FILL-in-total .
END.

FIND FIRST cobranza_hr WHERE cobranza_hr.nruta = di-rutaC.nrodoc NO-LOCK NO-ERROR.
IF AVAIL cobranza_hr AND cobranza_hr.flgest = 'C' THEN DO:
    pMsg = "Hoja de Ruta " + di-rutaC.nrodoc + " ya tiene registros de cobranza y esta CERRADO".
    RETURN "ADM-ERROR".
END.

pMsg = "Hoja de Ruta " + di-rutaC.nrodoc.

DEFINE VAR cCerrado AS CHAR INIT ''.
DEFINE BUFFER b-cobranza_hr_cmpte FOR cobranza_hr_cmpte.

IF pCerrar = YES THEN cCerrado = 'C'.

GRABACION:            
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":

    pMsg = "Eliminando registros anteriores de cobranza_hr".
    IF AVAIL cobranza_hr THEN DO:
        FIND CURRENT cobranza_hr EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED cobranza_hr THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + "La tabla cobranza_hr esta bloqueada por otro usuario".
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.

        DELETE cobranza_hr NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
    END.

    pMsg = "Eliminando registros anteriores de cobranza_hr_cmpte".
    FOR EACH cobranza_hr_cmpte WHERE cobranza_hr_cmpte.nruta = di-rutaC.nrodoc NO-LOCK:
        FIND FIRST b-cobranza_hr_cmpte WHERE ROWID(b-cobranza_hr_cmpte) = ROWID(cobranza_hr_cmpte) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF LOCKED b-cobranza_hr_cmpte THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + "La tabla cobranza_hr_cmpte esta bloqueada por otro usuario".
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
        /* Eliminar */
        DELETE cobranza_hr_cmpte NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = pMsg + chr(10) + chr(13) + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
    END.

    pMsg = "Grabando cabecera cobranza_hr".

    CREATE cobranza_hr.
    ASSIGN cobranza_hr.nruta = di-rutaC.nrodoc
        cobranza_hr.usuario = USERID("DICTDB")
        cobranza_hr.fregistro = TODAY
        cobranza_hr.hregistro = STRING(TIME,"hh:mm:ss")
        cobranza_hr.itipocambio = fill-in-tipocambio
        cobranza_hr.icobrarsoles = FILL-in-total
        cobranza_hr.icobrarsoles = 0
        cobranza_hr.iefectivosoles = 0
        cobranza_hr.ibilleteraelectrosoles = 0
        cobranza_hr.idepobancariosoles = 0 
        cobranza_hr.flgest = cCerrado NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        pMsg = pMsg + chr(10) + chr(13) + ERROR-STATUS:GET-MESSAGE(1).
        UNDO GRABACION, RETURN 'ADM-ERROR'.
    END.

    /* Lo comprobantes */
    FOR EACH comprobantes WHERE comprobantes.task-no = integer(di-rutaC.nrodoc) NO-LOCK:
        FIND FIRST cobranza_hr_cmpte WHERE cobranza_hr_cmpte.ccomprobante = comprobantes.campo-c[9] AND
                        cobranza_hr_cmpte.ncomprobante = comprobantes.campo-c[10] NO-LOCK NO-ERROR.
        IF AVAILABLE cobranza_hr_cmpte THEN DO:
            pMsg = "El comprobante " + comprobantes.llave-c + " ya fue registrado en la H/R " + di-rutaC.nrodoc.
            UNDO GRABACION, RETURN "ADM-ERROR".
        END.
        pMsg = "Grabando comprobante cobranza_hr_cmpte :" + comprobantes.llave-C.
        CREATE cobranza_hr_cmpte.
        ASSIGN cobranza_hr_cmpte.nruta = di-rutaC.nrodoc
                cobranza_hr_cmpte.usuario = USERID("DICTDB")
                cobranza_hr_cmpte.fregistro = TODAY
                cobranza_hr_cmpte.hregistro = STRING(TIME,"hh:mm:ss")
                cobranza_hr_cmpte.ccomprobante = comprobantes.campo-c[9]
                cobranza_hr_cmpte.ncomprobante = comprobantes.campo-c[10]
                cobranza_hr_cmpte.cmoneda = comprobantes.campo-c[3]
                cobranza_hr_cmpte.ioriginal = comprobantes.campo-f[2]
                cobranza_hr_cmpte.isoles = comprobantes.campo-f[1]
                cobranza_hr_cmpte.ccliente = comprobantes.campo-c[1] NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = pMsg + chr(13) + chr(10) + ERROR-STATUS:GET-MESSAGE(1).
            UNDO GRABACION, RETURN 'ADM-ERROR'.
        END.
    END.
END.

pMsg = "".

RETURN "OK".


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  DEFINE VAR dTotal AS DEC.
  DEFINE VAR dTipoCambio AS DEC.

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        /*GET FIRST {&BROWSE-NAME}.*/
        DO  WHILE AVAILABLE comprobantes:
            dTotal = dTotal + comprobantes.campo-f[1].
            GET NEXT {&BROWSE-NAME}.
        END.

        fill-in-total:SCREEN-VALUE = STRING(dTotal). /*,">>>,>>9.99").*/

        IF AVAILABLE di-rutaC THEN DO:
            FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= di-rutaC.FchSal NO-LOCK NO-ERROR.
            IF AVAIL Gn-Tcmb THEN dTipoCambio = Gn-Tcmb.Venta.
        END.
        
        fill-in-tipocambio:SCREEN-VALUE = STRING(dTipoCambio,">>9.9999").
        
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
  {src/adm/template/snd-list.i "comprobantes"}

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

