&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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

DEF SHARED VAR lh_handle AS HANDLE.
DEFINE SHARED VAR s-codcia AS INT.

DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER x-ccbdcaja FOR ccbdcaja.
DEFINE BUFFER x-faccpedi FOR faccpedi.

DEFINE VAR x-col-estado AS CHAR.
DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.


DEFINE TEMP-TABLE ttComprobMismaCotizacion
    FIELD   ttTipo      AS  CHAR
    FIELD   ttCodDoc    AS  CHAR
    FIELD   ttNroDoc    AS  CHAR.

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
&Scoped-define INTERNAL-TABLES tt-w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[6] tt-w-report.Campo-D[2] ~
tt-w-report.Campo-F[2] fEstado(tt-w-report.Campo-C[7]) @ x-col-estado ~
tt-w-report.Campo-F[3] tt-w-report.Campo-F[4] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH tt-w-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH tt-w-report WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-br_table tt-w-report


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table FILL-IN-desde FILL-IN-hasta ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Mostrar" 
     SIZE 11.57 BY .77.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .96 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      tt-w-report.Campo-C[4] COLUMN-LABEL "Doc.!Deposito" FORMAT "X(8)":U
            WIDTH 6.43
      tt-w-report.Campo-C[5] COLUMN-LABEL "Numero!Deposito" FORMAT "X(15)":U
            WIDTH 10.43
      tt-w-report.Campo-C[6] COLUMN-LABEL "Mone!Deposito" FORMAT "X(8)":U
            WIDTH 7.43
      tt-w-report.Campo-D[2] COLUMN-LABEL "Fecha!Deposito" FORMAT "99/99/9999":U
            WIDTH 8.43
      tt-w-report.Campo-F[2] COLUMN-LABEL "Importe!Aplicado" FORMAT "->>,>>>,>>9.99":U
      fEstado(tt-w-report.Campo-C[7]) @ x-col-estado COLUMN-LABEL "Estado" FORMAT "x(25)":U
            WIDTH 12.57
      tt-w-report.Campo-F[3] COLUMN-LABEL "Importe!Deposito" FORMAT "->>,>>>,>>9.99":U
      tt-w-report.Campo-F[4] COLUMN-LABEL "Saldo!Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 84.57 BY 4.73
         FONT 4
         TITLE "Anticipos".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.43
     FILL-IN-desde AT ROW 1.85 COL 85.57 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-hasta AT ROW 2.92 COL 85.43 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 4.12 COL 88.43 WIDGET-ID 8
     "Desde" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 1.19 COL 87 WIDGET-ID 10
     "A/R, BD sin saldos" VIEW-AS TEXT
          SIZE 16.29 BY .62 AT ROW 5.04 COL 86.72 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
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
         HEIGHT             = 4.96
         WIDTH              = 102.43.
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
/* BROWSE-TAB br_table TEXT-2 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[4]
"tt-w-report.Campo-C[4]" "Doc.!Deposito" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[5]
"tt-w-report.Campo-C[5]" "Numero!Deposito" "X(15)" "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[6]
"tt-w-report.Campo-C[6]" "Mone!Deposito" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-D[2]
"tt-w-report.Campo-D[2]" "Fecha!Deposito" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-F[2]
"tt-w-report.Campo-F[2]" "Importe!Aplicado" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"fEstado(tt-w-report.Campo-C[7]) @ x-col-estado" "Estado" "x(25)" ? ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-F[3]
"tt-w-report.Campo-F[3]" "Importe!Deposito" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-F[4]
"tt-w-report.Campo-F[4]" "Saldo!Actual" "->>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Anticipos */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Anticipos */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Anticipos */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Mostrar */
DO:
    ASSIGN fill-in-desde fill-in-hasta.
  IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
      MESSAGE "Ingrese correctamente los rangos de fechas" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.
  IF fill-in-desde > fill-in-hasta THEN DO:
      MESSAGE "Rango de fechas incorrecta" VIEW-AS ALERT-BOX INFORMATION.
      RETURN NO-APPLY.
  END.

  RUN sin-saldos.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-anticipos B-table-Win 
PROCEDURE refrescar-anticipos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDOc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.

EMPTY TEMP-TABLE tt-w-report.

DEFINE VAR x-codcot AS CHAR.
DEFINE VAR x-nrocot AS CHAR.
DEFINE VAR x-codcli AS CHAR.

EMPTY TEMP-TABLE ttComprobMismaCotizacion.

/* FAC/BOL */
FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.coddoc = pCodDOc AND
                            ccbcdocu.nrodoc = pNroDOc NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN DO:
    {&open-query-br_table}
    RETURN.
END.
    

SESSION:SET-WAIT-STATE("GENERAL").

x-codcli = ccbcdocu.codcli.
x-coddoc = pCodDoc.
x-nrodoc = pNroDoc.

/* Buscar el nro de cotizacion */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = ccbcdocu.codped AND
                            x-faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
IF AVAILABLE x-faccpedi THEN DO:
    x-codcot = x-faccpedi.codref.
    x-nrocot = x-faccpedi.nroref.
END.
/* Todos los pedidos de la cotizacion */
FOR EACH x-faccpedi USE-INDEX llave07 WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.codref = x-codcot AND 
                            x-faccpedi.nroref = x-nrocot AND 
                            x-faccpedi.coddoc = 'PED' NO-LOCK:
    CREATE ttComprobMismaCotizacion.
        ASSIGN  ttComprobMismaCotizacion.tttipo = 'PED'
                ttComprobMismaCotizacion.ttcoddoc = x-faccpedi.coddoc
                ttComprobMismaCotizacion.ttnrodoc = x-faccpedi.nroped.
END.

/* Los Comprobantes de los pedidos */
FOR EACH ttComprobMismaCotizacion WHERE ttComprobMismaCotizacion.tttipo = 'PED':
    FOR EACH ccbcdocu USE-INDEX llave15 WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.codped = ttComprobMismaCotizacion.ttcoddoc AND
                                            ccbcdocu.nroped = ttComprobMismaCotizacion.ttnrodoc AND 
                                            (ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'BOL') AND
                                            ccbcdocu.flgest <> 'A' NO-LOCK:
        ASSIGN  ttComprobMismaCotizacion.tttipo = 'COMPROB'
                ttComprobMismaCotizacion.ttcoddoc = ccbcdocu.coddoc
                ttComprobMismaCotizacion.ttnrodoc = ccbcdocu.nrodoc.

    END.
END.

DEFINE VAR x-tiene-aplicaciones AS LOG.

/* Las Aplicaciones  */
FOR EACH ttComprobMismaCotizacion WHERE ttComprobMismaCotizacion.tttipo = 'COMPROB':
    FOR EACH x-ccbdcaja WHERE x-ccbdcaja.codcia = s-codcia AND                                    
                                x-ccbdcaja.codref = ttComprobMismaCotizacion.ttCodDoc AND /*pCodDoc */         /* FAC,BOL */
                                x-ccbdcaja.nroref = ttComprobMismaCotizacion.ttNroDoc AND /* pNroDoc*/ 
                                x-ccbdcaja.coddoc = 'I/C' NO-LOCK :

        x-tiene-aplicaciones = NO.

        FOR EACH ccbdmov WHERE ccbdmov.codcia = s-codcia AND
                                ccbdmov.codref = x-ccbdcaja.coddoc AND
                                ccbdmov.nroref = x-ccbdcaja.nrodoc AND 
                                ccbdmov.coddoc <> 'N/C' NO-LOCK:
            /* Existe el BD */
            FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                        x-ccbcdocu.coddoc = ccbdmov.coddoc AND
                                        x-ccbcdocu.nrodoc = ccbdmov.nrodoc NO-LOCK NO-ERROR.
            IF NOT AVAILABLE x-ccbcdocu OR x-ccbcdocu.flgest = 'A' THEN NEXT.

            FIND FIRST tt-w-report WHERE tt-w-report.campo-c[4] = ccbdmov.coddoc AND
                                            tt-w-report.campo-c[5] = ccbdmov.nrodoc EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE tt-w-report THEN DO:

                x-tiene-aplicaciones = YES.

                CREATE tt-w-report.
                     ASSIGN tt-w-report.campo-c[4] = ccbdmov.coddoc
                             tt-w-report.campo-c[5] = ccbdmov.nrodoc
                             tt-w-report.campo-c[6] = IF(ccbdmov.codmon = 2) THEN "US$" ELSE "S/"
                             tt-w-report.campo-c[7] = x-ccbcdocu.flgest
                             tt-w-report.campo-d[2] = ccbdmov.fchdoc
                             tt-w-report.campo-f[2] = ccbdmov.imptot
                             tt-w-report.campo-f[3] = x-ccbcdocu.imptot
                             tt-w-report.campo-f[4] = x-ccbcdocu.sdoact
                             tt-w-report.campo-c[10] = "".
            END.
        END.
        IF x-tiene-aplicaciones = NO THEN DO:
            FIND FIRST ccbccaja WHERE ccbccaja.codcia = s-codcia AND
                                        ccbccaja.coddoc = ccbdcaja.coddoc AND
                                        ccbccaja.nrodoc = ccbdcaja.nrodoc AND
                                        ccbccaja.flgest <> 'A' NO-LOCK NO-ERROR.
            IF AVAILABLE ccbccaja THEN DO:
                /* Boleta de depoisto y tiene voucher ?  */
                IF ccbccaja.impnac[5] > 0 AND NOT (TRUE <> (ccbccaja.voucher[5] > "")) THEN DO:
                    /* Existe el BD */
                    FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                                x-ccbcdocu.coddoc = "BD" AND
                                                x-ccbcdocu.nrodoc = ccbccaja.voucher[5] NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE x-ccbcdocu OR x-ccbcdocu.flgest = 'A' THEN NEXT.

                    FIND FIRST tt-w-report WHERE tt-w-report.campo-c[4] = "BD" AND
                                                    tt-w-report.campo-c[5] = ccbccaja.voucher[5] EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE tt-w-report THEN DO:

                        CREATE tt-w-report.
                             ASSIGN tt-w-report.campo-c[4] = "BD"
                                     tt-w-report.campo-c[5] = ccbccaja.voucher[5]
                                     tt-w-report.campo-c[6] = IF(ccbccaja.codmon = 2) THEN "US$" ELSE "S/"
                                     tt-w-report.campo-c[7] = x-ccbcdocu.flgest
                                     tt-w-report.campo-d[2] = ccbccaja.fchdoc
                                     tt-w-report.campo-f[2] = ccbccaja.impnac[5]
                                     tt-w-report.campo-f[3] = x-ccbcdocu.imptot
                                     tt-w-report.campo-f[4] = x-ccbcdocu.sdoact
                                     tt-w-report.campo-c[10] = "".
                    END.

                END.
            END.
        END.
    END.
END.

/* Los anticipos disponible */
FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                        ccbcdocu.codcli = x-codcli AND
                        ccbcdocu.flgest <> 'A' AND
                        (ccbcdocu.coddoc = 'A/R' or ccbcdocu.coddoc = 'BD') AND
                        ccbcdocu.sdoact > 0 NO-LOCK :
    FIND FIRST tt-w-report WHERE tt-w-report.campo-c[4] = ccbcdocu.coddoc AND
                                    tt-w-report.campo-c[5] = ccbcdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-w-report THEN DO:
        CREATE tt-w-report.
             ASSIGN tt-w-report.campo-c[4] = ccbcdocu.coddoc
                     tt-w-report.campo-c[5] = ccbcdocu.nrodoc
                     tt-w-report.campo-c[6] = IF(ccbcdocu.codmon = 2) THEN "US$" ELSE "S/"
                     tt-w-report.campo-c[7] = ccbcdocu.flgest
                     tt-w-report.campo-d[2] = ccbcdocu.fchdoc
                     tt-w-report.campo-f[2] = 0
                     tt-w-report.campo-f[3] = ccbcdocu.imptot
                     tt-w-report.campo-c[10] = "".
    END.

END.

{&open-query-br_table}
    
SESSION:SET-WAIT-STATE("").

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
  {src/adm/template/snd-list.i "tt-w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sin-saldos B-table-Win 
PROCEDURE sin-saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-codcli AS CHAR.

/* FAC/BOL */
FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.coddoc = x-CodDOc AND
                            ccbcdocu.nrodoc = x-NroDOc NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN DO:
    {&open-query-br_table}
    RETURN.
END.
    
SESSION:SET-WAIT-STATE("GENERAL").

x-codcli = ccbcdocu.codcli.

/* Eliminamos si existiesem */
FOR EACH tt-w-report WHERE tt-w-report.campo-c[10] = "SIN SALDOS" :
    DELETE tt-w-report.
END.

/* Los anticipos con saldos cero */
FOR EACH ccbcdocu USE-INDEX llave06 WHERE ccbcdocu.codcia = s-codcia AND
                        ccbcdocu.codcli = x-codcli AND
                        ccbcdocu.flgest <> 'A' AND
                        (ccbcdocu.coddoc = 'A/R' or ccbcdocu.coddoc = 'BD') AND
                        ccbcdocu.sdoact = 0 AND 
                        (ccbcdocu.fchdoc >= fill-in-desde AND ccbcdocu.fchdoc <= fill-in-hasta)
                        NO-LOCK :
    FIND FIRST tt-w-report WHERE tt-w-report.campo-c[4] = ccbcdocu.coddoc AND
                                    tt-w-report.campo-c[5] = ccbcdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-w-report THEN DO:
        CREATE tt-w-report.
             ASSIGN tt-w-report.campo-c[4] = ccbcdocu.coddoc
                     tt-w-report.campo-c[5] = ccbcdocu.nrodoc
                     tt-w-report.campo-c[6] = IF(ccbcdocu.codmon = 2) THEN "US$" ELSE "S/"
                     tt-w-report.campo-c[7] = ccbcdocu.flgest
                     tt-w-report.campo-d[2] = ccbcdocu.fchdoc
                     tt-w-report.campo-f[2] = 0
                     tt-w-report.campo-f[3] = ccbcdocu.imptot
                     tt-w-report.campo-c[10] = "SIN SALDOS".
    END.

END.

{&open-query-br_table}

SESSION:SET-WAIT-STATE("").

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS CHAR.

    RUN gn/fFlgEstCCB (INPUT pEstado, OUTPUT x-retval).

    IF TRUE <> (x-retval > "") THEN x-retval = pEstado.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

