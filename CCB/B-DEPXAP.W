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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODDIV AS CHAR.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR S-CODDOC AS CHAR INIT "BD".
DEFINE VAR R-BOLD AS RECID.
DEFINE VAR X-MON  AS CHAR.
DEFINE VAR X-EST  AS CHAR.

DEFINE VARIABLE P-MON AS CHAR NO-UNDO.
DEFINE VARIABLE P-EST AS CHAR NO-UNDO.
DEFINE STREAM REPORT.

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
&Scoped-define INTERNAL-TABLES CcbBolDep

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbBolDep.NroDoc CcbBolDep.NroRef ~
CcbBolDep.NomCli CcbBolDep.FchDoc X-MON @ X-MON CcbBolDep.SdoAct ~
X-EST @ X-EST 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbBolDep WHERE ~{&KEY-PHRASE} ~
      AND CcbBolDep.Codcia = S-CODCIA ~
 AND CcbBolDep.CodDoc = S-CODDOC ~
 AND CcbBolDep.nomcli BEGINS wclient ~
 AND CcbBolDep.FlgEst = "P" ~
 AND CcbBolDep.CodDiv = s-coddiv NO-LOCK ~
    BY CcbBolDep.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table CcbBolDep
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbBolDep


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 br_table COMBO-BOX-8 wbold ~
wclient BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-8 wbold wclient 

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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print":U
     LABEL "Button 1" 
     SIZE 5.72 BY 1.35 TOOLTIP "Imprimir Boleta".

DEFINE VARIABLE COMBO-BOX-8 AS CHARACTER FORMAT "X(256)":U INITIAL "Número B/D" 
     LABEL "Buscar x" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Número B/D","Cliente" 
     SIZE 13.86 BY 1 NO-UNDO.

DEFINE VARIABLE wbold AS CHARACTER FORMAT "XXX-XXXXXX":U 
     LABEL "# B/D" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .77 NO-UNDO.

DEFINE VARIABLE wclient AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 39.72 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.12.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 12.69.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbBolDep SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbBolDep.NroDoc COLUMN-LABEL "Codigo!Documento" FORMAT "XXX-XXXXXXXX"
      CcbBolDep.NroRef COLUMN-LABEL "Numero ! Depósito" FORMAT "X(11)"
      CcbBolDep.NomCli COLUMN-LABEL "Cliente"
      CcbBolDep.FchDoc COLUMN-LABEL "     Fecha    !     Emisión"
      X-MON @ X-MON COLUMN-LABEL "Mon." FORMAT "XXX"
      CcbBolDep.SdoAct COLUMN-LABEL "     Saldo !     Actual"
      X-EST @ X-EST COLUMN-LABEL "Estado" FORMAT "X(4)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 86 BY 11.77
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 3.88 COL 3
     COMBO-BOX-8 AT ROW 1.77 COL 8 COLON-ALIGNED
     wbold AT ROW 1.77 COL 30 COLON-ALIGNED
     wclient AT ROW 1.77 COL 30 COLON-ALIGNED
     BUTTON-1 AT ROW 1.58 COL 79
     RECT-2 AT ROW 3.5 COL 2
     RECT-1 AT ROW 1.19 COL 2
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
         HEIGHT             = 15.19
         WIDTH              = 90.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table RECT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbBolDep"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.CcbBolDep.NroDoc|no"
     _Where[1]         = "integral.CcbBolDep.Codcia = S-CODCIA
 AND integral.CcbBolDep.CodDoc = S-CODDOC
 AND integral.CcbBolDep.nomcli BEGINS wclient
 AND integral.CcbBolDep.FlgEst = ""P""
 AND CcbBolDep.CodDiv = s-coddiv"
     _FldNameList[1]   > integral.CcbBolDep.NroDoc
"CcbBolDep.NroDoc" "Codigo!Documento" "XXX-XXXXXXXX" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.CcbBolDep.NroRef
"CcbBolDep.NroRef" "Numero ! Depósito" "X(11)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.CcbBolDep.NomCli
"CcbBolDep.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.CcbBolDep.FchDoc
"CcbBolDep.FchDoc" "     Fecha    !     Emisión" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   > "_<CALC>"
"X-MON @ X-MON" "Mon." "XXX" ? ? ? ? ? ? ? no ?
     _FldNameList[6]   > integral.CcbBolDep.SdoAct
"CcbBolDep.SdoAct" "     Saldo !     Actual" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[7]   > "_<CALC>"
"X-EST @ X-EST" "Estado" "X(4)" ? ? ? ? ? ? ? no ?
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

{src/adm/method/browser.i}
{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}

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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    RUN proc_print.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-8 B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-8 IN FRAME F-Main /* Buscar x */
DO:
  wbold:visible = yes.
  wclient:visible = yes.
  ASSIGN COMBO-BOX-8.
  CASE COMBO-BOX-8:
       WHEN "Cliente" THEN
            wbold:visible = not wbold:visible.
       WHEN "Número B/D" THEN
            wclient:visible = not wclient:visible.
  end case.         
  ASSIGN COMBO-BOX-8.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wbold
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wbold B-table-Win
ON LEAVE OF wbold IN FRAME F-Main /* # B/D */
or "RETURN":U of wbold
DO:
  IF INPUT wbold = "" THEN RETURN.
  find first CcbBolDep where CcbBolDep.NroDoc = substring(wbold:screen-value,1,3) +
             String(integer(substring(wbold:screen-value,5,6)),"999999") AND 
             integral.CcbBolDep.CodDoc = "BD" AND
             integral.CcbBolDep.NomCli BEGINS wclient NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CcbBolDep THEN DO:
     MESSAGE " No. Boleta de Depósito NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wbold:screen-value = "".
     RETURN.
  END.        
  R-bold = RECID(CcbBolDep).
  REPOSITION BR_TABLE TO RECID R-bold.  
  RUN dispatch IN THIS-PROCEDURE('ROW-CHANGED':U). 
  IF ERROR-STATUS:ERROR THEN DO:
     MESSAGE " No. Boleta de Depósito NO EXISTE "
     VIEW-AS ALERT-BOX ERROR.
     wbold:screen-value = "".
     RETURN.
  END.
  wbold:SCREEN-VALUE = "".    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME wclient
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wclient B-table-Win
ON LEAVE OF wclient IN FRAME F-Main /* Cliente */
or "RETURN":U of wclient
DO:
  ASSIGN WCLIENT.
  RUN ABRIR-QUERY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON FIND OF CCBBOLDEP  
DO:
    IF CCBBOLDEP.CodMon = 1 THEN
        ASSIGN
            X-MON = "S/." .
    ELSE
        ASSIGN
            X-MON = "US$" .
            
    IF CCBBOLDEP.Flgest = "P" THEN
       ASSIGN
            X-EST = "PEN".        

/*
    ENLSE
       ASSIGN
            X-PAG = "CR".
                    
    IF CCBBOLDEP.tipvta = "1" THEN
        ASSIGN
            X-VTA = "Factura".
    ELSE
        ASSIGN
            X-VTA = "Letra".             */
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE abrir-query B-table-Win 
PROCEDURE abrir-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE formato B-table-Win 
PROCEDURE formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE FRAME f-cab
        CcbBolDep.NroDoc AT 1   FORMAT "XXX-XXXXXX"
        CcbBoldep.NroRef AT 13  FORMAT "X(10)"
        CcbBolDep.NomCli AT 25  FORMAT "X(40)"
        CcbBolDep.FchDoc AT 77
        P-MON            AT 90  FORMAT "X(4)"
        CcbBolDep.ImpTot AT 97  FORMAT "->,>>>,>>9.99"
        CcbBolDep.SdoAct AT 114 FORMAT "->,>>>,>>9.99"
        P-EST            AT 132 FORMAT "X(3)"
        HEADER
        S-NOMCIA FORMAT "X(45)"
        "Pag.  : " AT 119 PAGE-NUMBER(REPORT) TO 134 FORMAT "ZZ9" SKIP
        "(" + S-CODDIV + ")" AT 1 FORMAT "X(15)" 
        "RESUMEN DE BOLETAS DE DEPOSITO X APLICAR" TO 87 FORMAT "X(40)" 
        "Fecha : " AT 119 STRING(TODAY,"99/99/9999") TO 134
        "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") TO 134 SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "  CODIGO        No.                                                           FECHA                   TOTAL         S A L D O         " SKIP
        " DOCUMENTO   DEPOSITO   C L I E N T E                                        EMISION    MONEDA       IMPORTE       A C T U A L  ESTADO" SKIP
        "--------------------------------------------------------------------------------------------------------------------------------------" SKIP
        WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    FOR EACH CcbBolDep NO-LOCK WHERE
        CcbBolDep.CodCia = S-CODCIA AND
        CcbBolDep.CodDoc = "BD"     AND
        CcbBolDep.Flgest = "P"
        BY CcbBolDep.NroDoc:
        IF CcbBolDep.Codmon = 1 THEN P-MON = "S/.".
        ELSE P-MON = "US$.".
        IF CcbBolDep.FlgEst = "P" THEN P-EST = "PEN".   
        DISPLAY STREAM REPORT 
            CcbBolDep.NroDoc 
            CcbBolDep.NroRef
            CcbBolDep.NomCli 
            CcbBolDep.FchDoc
            P-MON           
            CcbBolDep.ImpTot 
            CcbBolDep.SdoAct
            P-EST
            WITH FRAME F-Cab.
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

  wclient:visible IN FRAME F-MAIN = not wclient:visible .
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_print B-table-Win 
PROCEDURE proc_print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        RUN Formato.
        PAGE STREAM REPORT .
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
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
  {src/adm/template/snd-list.i "CcbBolDep"}

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


