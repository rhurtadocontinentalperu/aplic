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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codmon AS INT INIT 1 NO-UNDO.

DEFINE TEMP-TABLE tt-excel
    FIELD   tt-fecha    AS  DATE    COLUMN-LABEL "fecha"
    FIELD   tt-placa    AS  CHAR    FORMAT 'x(10)'  COLUMN-LABEL "No de Placa"
    FIELD   tt-marca    AS  CHAR    FORMAT 'x(30)'  COLUMN-LABEL "Marca"
    FIELD   tt-km       AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Kilometraje"
    FIELD   tt-combustible  AS  CHAR    FORMAT 'x(15)'  COLUMN-LABEL "Combustible"
    FIELD   tt-galones  AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Galones"
    FIELD   tt-impte    AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe".

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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Di-CGasol gn-vehic

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Di-CGasol.fecha Di-CGasol.placa ~
gn-vehic.Marca Di-CGasol.Kilometraje gn-vehic.Combustible Di-CGasol.galones ~
Di-CGasol.importe 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table Di-CGasol.fecha ~
Di-CGasol.placa Di-CGasol.Kilometraje Di-CGasol.galones Di-CGasol.importe 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table Di-CGasol
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table Di-CGasol
&Scoped-define QUERY-STRING-br_table FOR EACH Di-CGasol WHERE ~{&KEY-PHRASE} ~
      AND Di-CGasol.CodCia = s-codcia NO-LOCK, ~
      EACH gn-vehic OF Di-CGasol NO-LOCK ~
    BY Di-CGasol.fecha DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH Di-CGasol WHERE ~{&KEY-PHRASE} ~
      AND Di-CGasol.CodCia = s-codcia NO-LOCK, ~
      EACH gn-vehic OF Di-CGasol NO-LOCK ~
    BY Di-CGasol.fecha DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table Di-CGasol gn-vehic
&Scoped-define FIRST-TABLE-IN-QUERY-br_table Di-CGasol
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-vehic


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
      Di-CGasol, 
      gn-vehic SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Di-CGasol.fecha COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      Di-CGasol.placa FORMAT "x(10)":U
      gn-vehic.Marca FORMAT "x(20)":U
      Di-CGasol.Kilometraje FORMAT ">>>,>>9.99":U
      gn-vehic.Combustible COLUMN-LABEL "Combustible" FORMAT "x(5)":U
      Di-CGasol.galones COLUMN-LABEL "Galones" FORMAT "->>,>>9.99":U
      Di-CGasol.importe COLUMN-LABEL "Importe S/." FORMAT ">>,>>9.99":U
  ENABLE
      Di-CGasol.fecha
      Di-CGasol.placa
      Di-CGasol.Kilometraje
      Di-CGasol.galones
      Di-CGasol.importe
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 94 BY 15.58
         FONT 2.


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
         HEIGHT             = 15.65
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
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.Di-CGasol,INTEGRAL.gn-vehic OF INTEGRAL.Di-CGasol"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.Di-CGasol.fecha|no"
     _Where[1]         = "INTEGRAL.Di-CGasol.CodCia = s-codcia"
     _FldNameList[1]   > INTEGRAL.Di-CGasol.fecha
"Di-CGasol.fecha" "Fecha" ? "date" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Di-CGasol.placa
"Di-CGasol.placa" ? ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.gn-vehic.Marca
     _FldNameList[4]   > INTEGRAL.Di-CGasol.Kilometraje
"Di-CGasol.Kilometraje" ? ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.gn-vehic.Combustible
"gn-vehic.Combustible" "Combustible" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Di-CGasol.galones
"Di-CGasol.galones" "Galones" ? "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.Di-CGasol.importe
"Di-CGasol.importe" "Importe S/." ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  THEN Di-CGasol.fecha:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = STRING(TODAY).
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


&Scoped-define SELF-NAME Di-CGasol.placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Di-CGasol.placa br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF Di-CGasol.placa IN BROWSE br_table /* No de Placa */
DO:
  ASSIGN
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE)
    gn-vehic.Marca:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = '' 
    gn-vehic.Combustible:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
    AND gn-vehic.placa = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE gn-vehic
  THEN DO:
    DISPLAY
        gn-vehic.Marca
        gn-vehic.Combustible
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


ON RETURN OF Di-CGasol.fecha, Di-CGasol.galones, Di-CGasol.placa, Di-CGasol.Kilometraje
    DO:
    APPLY 'TAB'.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-excel B-table-Win 
PROCEDURE enviar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-excel.
    
GET FIRST {&BROWSE-NAME}.
DO  WHILE AVAILABLE di-cgasol:

    CREATE tt-excel.
    ASSIGN  tt-fecha    = di-cgasol.fecha
            tt-placa    = di-cgasol.placa
            tt-marca    = gn-vehic.marca
            tt-km       = di-cgasol.kilometraje
            tt-combustible  = gn-vehic.combustible
            tt-galones  = di-cgasol.galones
            tt-impte    = di-cgasol.importe.

    GET NEXT {&BROWSE-NAME}.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-archivo.

run pi-crea-archivo-csv IN hProc (input  buffer tt-excel:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-excel:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


SESSION:SET-WAIT-STATE('').

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
    Di-CGasol.CodCia = s-codcia
    Di-CGasol.CodDiv = s-coddiv
    Di-CGasol.CodMon = s-codmon
    Di-CGasol.Usuario = s-user-id.

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
  {src/adm/template/snd-list.i "Di-CGasol"}
  {src/adm/template/snd-list.i "gn-vehic"}

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
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
    AND gn-vehic.placa = Di-CGasol.placa:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-vehic
  THEN DO:
    MESSAGE 'Debe ingresar el vehiculo' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY' TO di-cgasol.placa.
    RETURN 'ADM-ERROR'.
  END.
  IF gn-vehic.Estado <> '01'
  THEN DO:
    MESSAGE 'Debe ser un transporte PROPIO'
    VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY' TO di-cgasol.placa.
    RETURN 'ADM-ERROR'.
  END.
  IF DECIMAL(Di-CGasol.Kilometraje:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0
  THEN DO:
    MESSAGE 'Debe ingresar el kilometraje' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY' TO di-cgasol.kilometraje.
    RETURN 'ADM-ERROR'.
  END.
  IF DECIMAL(Di-CGasol.galones:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0
  THEN DO:
    MESSAGE 'Debe ingresar los galones' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY' TO di-cgasol.galones.
    RETURN 'ADM-ERROR'.
  END.
  IF DECIMAL(Di-CGasol.importe:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) <= 0
  THEN DO:
    MESSAGE 'Debe ingresar el importe' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY' TO di-cgasol.importe.
    RETURN 'ADM-ERROR'.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

