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
DEF SHARED VAR s-nomcia AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'H/R'.
DEF VAR x-Estado AS CHAR NO-UNDO.

DEF VAR s-Fecha-de-Cierre AS DATE NO-UNDO.

s-Fecha-de-Cierre = TODAY.

FIND FIRST AlmCfgGn WHERE AlmCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
IF AVAILABLE AlmCfgGn THEN s-Fecha-de-Cierre = TODAY - AlmCfgGn.Libre_d02.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME sbr_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DI-RutaC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE sbr_table                                     */
&Scoped-define FIELDS-IN-QUERY-sbr_table DI-RutaC.NroDoc DI-RutaC.FchSal ~
DI-RutaC.CodVeh DI-RutaC.Nomtra DI-RutaC.HorSal DI-RutaC.HorRet ~
DI-RutaC.KmtIni DI-RutaC.KmtFin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-sbr_table 
&Scoped-define QUERY-STRING-sbr_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND DI-RutaC.CodCia = s-codcia ~
 AND DI-RutaC.CodDiv = s-coddiv ~
 AND DI-RutaC.CodDoc = s-coddoc ~
 AND DI-RutaC.FlgEst = "C" ~
 AND DI-RutaC.FchSal >= (s-Fecha-de-Cierre - 1) NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-sbr_table OPEN QUERY sbr_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND DI-RutaC.CodCia = s-codcia ~
 AND DI-RutaC.CodDiv = s-coddiv ~
 AND DI-RutaC.CodDoc = s-coddoc ~
 AND DI-RutaC.FlgEst = "C" ~
 AND DI-RutaC.FchSal >= (s-Fecha-de-Cierre - 1) NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-sbr_table DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-sbr_table DI-RutaC


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS sbr_table 

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
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY sbr_table FOR 
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE sbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS sbr_table B-table-Win _STRUCTURED
  QUERY sbr_table NO-LOCK DISPLAY
      DI-RutaC.NroDoc FORMAT "X(9)":U
      DI-RutaC.FchSal COLUMN-LABEL "Fecha de !Salida" FORMAT "99/99/9999":U
      DI-RutaC.CodVeh COLUMN-LABEL "Placa" FORMAT "X(10)":U
      DI-RutaC.Nomtra FORMAT "X(30)":U
      DI-RutaC.HorSal COLUMN-LABEL "Hora!Salida" FORMAT "XX:XX":U
      DI-RutaC.HorRet COLUMN-LABEL "Hora!Retorno" FORMAT "XX:XX":U
      DI-RutaC.KmtIni COLUMN-LABEL "Kilometraje!Salida" FORMAT ">>>,>>9":U
            WIDTH 13.14
      DI-RutaC.KmtFin COLUMN-LABEL "Kilometraje!Llegada" FORMAT ">>>,>>9":U
            WIDTH 32.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 106 BY 6.92
         FONT 2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     sbr_table AT ROW 1 COL 1
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
         HEIGHT             = 8.19
         WIDTH              = 114.14.
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
/* BROWSE-TAB sbr_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE sbr_table
/* Query rebuild information for BROWSE sbr_table
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.DI-RutaC.NroDoc|no"
     _Where[1]         = "INTEGRAL.DI-RutaC.CodCia = s-codcia
 AND INTEGRAL.DI-RutaC.CodDiv = s-coddiv
 AND INTEGRAL.DI-RutaC.CodDoc = s-coddoc
 AND INTEGRAL.DI-RutaC.FlgEst = ""C""
 AND DI-RutaC.FchSal >= (s-Fecha-de-Cierre - 1)"
     _FldNameList[1]   = INTEGRAL.DI-RutaC.NroDoc
     _FldNameList[2]   > INTEGRAL.DI-RutaC.FchSal
"DI-RutaC.FchSal" "Fecha de !Salida" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.CodVeh
"DI-RutaC.CodVeh" "Placa" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.DI-RutaC.Nomtra
     _FldNameList[5]   > INTEGRAL.DI-RutaC.HorSal
"DI-RutaC.HorSal" "Hora!Salida" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.DI-RutaC.HorRet
"DI-RutaC.HorRet" "Hora!Retorno" "XX:XX" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.DI-RutaC.KmtIni
"DI-RutaC.KmtIni" "Kilometraje!Salida" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "13.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.DI-RutaC.KmtFin
"DI-RutaC.KmtFin" "Kilometraje!Llegada" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "32.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE sbr_table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME sbr_table
&Scoped-define SELF-NAME sbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sbr_table B-table-Win
ON ROW-ENTRY OF sbr_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sbr_table B-table-Win
ON ROW-LEAVE OF sbr_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sbr_table B-table-Win
ON VALUE-CHANGED OF sbr_table IN FRAME F-Main
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aperturar B-table-Win 
PROCEDURE Aperturar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Chequeo Previo */
DEF VAR k AS INT NO-UNDO.
DEF VAR x-Transportista AS CHAR INIT '' NO-UNDO.
DEF VAR x-HojasdeRuta AS CHAR INIT '' NO-UNDO.

IF NOT AVAILABLE Di-RutaC THEN RETURN.

DEF VAR pGlosa AS CHAR NO-UNDO.
DEF VAR pError AS LOG  NO-UNDO.

RUN dist/d-mot-anu-hr ("INGRESE GLOSA",
                       OUTPUT pGlosa,
                       OUTPUT pError).
IF pError = YES OR (TRUE <> (pGlosa > '')) THEN RETURN.

DEF VAR x-Rowid AS ROWID NO-UNDO.
x-Rowid = ROWID(Di-RutaC).
DEF BUFFER B-RUTAC FOR Di-RutaC.
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    {lib/lock-genericov3.i ~
        &Tabla="B-RutaC" ~
        &Condicion="ROWID(B-RUTAC) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    IF B-RUTAC.FlgEst = 'P' THEN RETURN.   /* Ya fue aperturado por otro usuario */
    ASSIGN
        B-RUTAC.FlgEst = 'P'
        B-RUTAC.UserApertura = s-user-id
        B-RUTAC.FechaApertura = TODAY
        B-RUTAC.HoraApertura = STRING(TIME, 'HH:MM:SS')
        B-RUTAC.GlosaApertura = pGlosa.
    /* *************************** */
    /* RHC 19.06.2012 Aperturamos Ccbcbult POR ORDENES DE DESPACHO */
    FOR EACH Di-RutaD OF B-RUTAC NO-LOCK WHERE Di-RutaD.FlgEst = "C",    /* SOLO ENTREGADOS */
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = B-RUTAC.codcia
        AND Ccbcdocu.coddoc = Di-RutaD.codref
        AND Ccbcdocu.nrodoc = Di-RutaD.nroref,
        FIRST Ccbcbult EXCLUSIVE-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia
        AND CcbCBult.CodDoc = Ccbcdocu.Libre_C01      /*Ccbcdocu.codped*/
        AND CcbCBult.NroDoc = Ccbcdocu.Libre_C02      /*Ccbcdocu.nroped*/
        AND CcbCBult.Chr_01 = "C":
        CcbCBult.Chr_01 = "P".
    END.
    /* RHC 20.08.2012 Aperturamos Ccbcbult POR TRANSFERENCIAS */
    /* Ic 13Mar205 considerar OTR */
    FOR EACH Di-RutaG OF B-RUTAC NO-LOCK WHERE Di-RutaG.FlgEst = "C",    /* SOLO ENTREGADOS */
        EACH Ccbcbult EXCLUSIVE-LOCK USE-INDEX Llave03 WHERE CcbCBult.CodCia = B-RUTAC.codcia
        AND CcbCBult.CodDoc = "TRA"
        AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '999999'):
        IF CcbCBult.Chr_01 = "C" THEN CcbCBult.Chr_01 = "P".
    END.
    FOR EACH Di-RutaG OF B-RUTAC NO-LOCK WHERE Di-RutaG.FlgEst = "C",    /* SOLO ENTREGADOS */
        EACH Ccbcbult EXCLUSIVE-LOCK USE-INDEX Llave03 WHERE CcbCBult.CodCia = B-RUTAC.codcia
        AND CcbCBult.CodDoc = "OTR"
        AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '999999'):
        IF CcbCBult.Chr_01 = "C" THEN CcbCBult.Chr_01 = "P".
    END.
    RELEASE B-RUTAC.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "DI-RutaC"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN alm/f-flgrut ("C", Di-RutaC.flgest, OUTPUT x-Estado).
  RETURN x-Estado.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

