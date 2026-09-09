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
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
DEFINE VARIABLE cOpciones     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDetalles     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRetorno      AS CHARACTER NO-UNDO.
DEFINE VARIABLE i             AS INTEGER NO-UNDO.
DEFINE VARIABLE s-RowID       AS ROWID.

DEFINE BUFFER b-VAR-RPT FOR integral.PL-VAR-RPT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES integral.PL-CFG-RPT
&Scoped-define FIRST-EXTERNAL-TABLE integral.PL-CFG-RPT


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR integral.PL-CFG-RPT.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES integral.PL-VAR-RPT integral.PL-CONC

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table integral.PL-VAR-RPT.CodVar ~
integral.PL-VAR-RPT.CodMov integral.PL-CONC.DesMov ~
integral.PL-VAR-RPT.CodCal integral.PL-VAR-RPT.Metodo ~
integral.PL-VAR-RPT.NroSem integral.PL-VAR-RPT.NroMes ~
integral.PL-VAR-RPT.Periodo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table integral.PL-VAR-RPT.CodVar ~
integral.PL-VAR-RPT.CodMov integral.PL-VAR-RPT.CodCal ~
integral.PL-VAR-RPT.Metodo integral.PL-VAR-RPT.NroSem ~
integral.PL-VAR-RPT.NroMes integral.PL-VAR-RPT.Periodo 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodVar ~{&FP2}CodVar ~{&FP3}~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}~
 ~{&FP1}CodCal ~{&FP2}CodCal ~{&FP3}~
 ~{&FP1}Metodo ~{&FP2}Metodo ~{&FP3}~
 ~{&FP1}NroSem ~{&FP2}NroSem ~{&FP3}~
 ~{&FP1}NroMes ~{&FP2}NroMes ~{&FP3}~
 ~{&FP1}Periodo ~{&FP2}Periodo ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table integral.PL-VAR-RPT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table integral.PL-VAR-RPT
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH integral.PL-VAR-RPT ~
      WHERE PL-VAR-RPT.CodRep = PL-CFG-RPT.CodRep ~
 AND PL-VAR-RPT.TpoRpt = PL-CFG-RPT.TpoRpt NO-LOCK, ~
      EACH integral.PL-CONC OF integral.PL-VAR-RPT NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table integral.PL-VAR-RPT ~
integral.PL-CONC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table integral.PL-VAR-RPT


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-deslib 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-deslib AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61.57 BY 9.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      integral.PL-VAR-RPT, 
      integral.PL-CONC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      integral.PL-VAR-RPT.CodVar COLUMN-LABEL "Nro." FORMAT "Z99"
      integral.PL-VAR-RPT.CodMov
      integral.PL-CONC.DesMov FORMAT "X(25)"
      integral.PL-VAR-RPT.CodCal FORMAT "Z9"
      integral.PL-VAR-RPT.Metodo
      integral.PL-VAR-RPT.NroSem FORMAT "-Z9"
      integral.PL-VAR-RPT.NroMes FORMAT "-Z9"
      integral.PL-VAR-RPT.Periodo FORMAT "-ZZZ9"
  ENABLE
      integral.PL-VAR-RPT.CodVar
      integral.PL-VAR-RPT.CodMov
      integral.PL-VAR-RPT.CodCal
      integral.PL-VAR-RPT.Metodo
      integral.PL-VAR-RPT.NroSem
      integral.PL-VAR-RPT.NroMes
      integral.PL-VAR-RPT.Periodo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 60.14 BY 8
         BGCOLOR 15 FGCOLOR 0 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-deslib AT ROW 1.23 COL 2 NO-LABEL
     br_table AT ROW 2.23 COL 1.86
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-CFG-RPT
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
         HEIGHT             = 9.54
         WIDTH              = 61.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
/* BROWSE-TAB br_table FILL-IN-deslib F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-deslib IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "integral.PL-VAR-RPT,integral.PL-CONC OF integral.PL-VAR-RPT"
     _Options          = "NO-LOCK"
     _Where[1]         = "PL-VAR-RPT.CodRep = PL-CFG-RPT.CodRep
 AND PL-VAR-RPT.TpoRpt = PL-CFG-RPT.TpoRpt"
     _FldNameList[1]   > integral.PL-VAR-RPT.CodVar
"PL-VAR-RPT.CodVar" "Nro." "Z99" "integer" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > integral.PL-VAR-RPT.CodMov
"PL-VAR-RPT.CodMov" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[3]   > integral.PL-CONC.DesMov
"PL-CONC.DesMov" ? "X(25)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.PL-VAR-RPT.CodCal
"PL-VAR-RPT.CodCal" ? "Z9" "character" ? ? ? ? ? ? yes ?
     _FldNameList[5]   > integral.PL-VAR-RPT.Metodo
"PL-VAR-RPT.Metodo" ? ? "integer" ? ? ? ? ? ? yes ?
     _FldNameList[6]   > integral.PL-VAR-RPT.NroSem
"PL-VAR-RPT.NroSem" ? "-Z9" "character" ? ? ? ? ? ? yes ?
     _FldNameList[7]   > integral.PL-VAR-RPT.NroMes
"PL-VAR-RPT.NroMes" ? "-Z9" "character" ? ? ? ? ? ? yes ?
     _FldNameList[8]   > integral.PL-VAR-RPT.Periodo
"PL-VAR-RPT.Periodo" ? "-ZZZ9" "character" ? ? ? ? ? ? yes ?
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


&Scoped-define SELF-NAME integral.PL-VAR-RPT.CodMov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VAR-RPT.CodMov br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-VAR-RPT.CodMov IN BROWSE br_table /* Concepto */
DO:
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN pln/h-conc.w( OUTPUT s-RowID ).
        IF s-RowID = ? THEN LEAVE.
        FIND integral.PL-CONC WHERE ROWID(integral.PL-CONC) = s-RowID NO-LOCK.
        SELF:SCREEN-VALUE = STRING( integral.PL-CONC.CodMov, "999").
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-VAR-RPT.Metodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VAR-RPT.Metodo br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-VAR-RPT.Metodo IN BROWSE br_table /* Método */
DO:
    cOpciones = "00,02,03".
    cDetalles = "Acumulado a la Semana/Mes,Acumulado Mensual,Acumulado Anual".
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    cRetorno = ?.
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN adm/h-cons01.w( cOpciones, cDetalles, OUTPUT cRetorno).
        IF cRetorno <> ? THEN SELF:SCREEN-VALUE = cRetorno.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-VAR-RPT.NroSem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VAR-RPT.NroSem br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-VAR-RPT.NroSem IN BROWSE br_table /* Semana */
DO:
    cOpciones = "".
    cDetalles = "<* Semana del Sistema *>".
    DO i = 1 TO 53:
        cOpciones = cOpciones + "," + STRING( i, "99").
        cDetalles = cDetalles + ",Semana " + STRING( i, "99").
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("ARROW").
    cRetorno = ?.
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN adm/h-cons01.w( cOpciones, cDetalles, OUTPUT cRetorno).
        IF cRetorno <> ?
        THEN SELF:SCREEN-VALUE = cRetorno.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-VAR-RPT.NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VAR-RPT.NroMes br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-VAR-RPT.NroMes IN BROWSE br_table /* Mes */
DO:
    cOpciones = ",01,02,03,04,05,06,07,08,09,10,11,12".
    cDetalles = "<* Mes del Sistema *>,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre".
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    cRetorno = ?.
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN adm/h-cons01.w( cOpciones, cDetalles, OUTPUT cRetorno).
        IF cRetorno <> ? THEN SELF:SCREEN-VALUE = cRetorno.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integral.PL-VAR-RPT.Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integral.PL-VAR-RPT.Periodo br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF integral.PL-VAR-RPT.Periodo IN BROWSE br_table /* Año */
DO:
    cOpciones = ",1995,1996,1997,1998,1999,2000".
    cDetalles = "<* A¤o del Sistema *>,1995,1996,1997,1998,1999,2000".
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
    cRetorno = ?.
    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        RUN adm/h-cons01.w( cOpciones, cDetalles, OUTPUT cRetorno).
        IF cRetorno <> ? THEN SELF:SCREEN-VALUE = cRetorno.
    END.
    OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


ON "RETURN":U OF PL-VAR-RPT.CodCal, PL-VAR-RPT.CodMov, PL-VAR-RPT.CodVar, PL-VAR-RPT.Metodo, PL-VAR-RPT.NroMes, PL-VAR-RPT.NroSem, PL-VAR-RPT.Periodo
DO:
   APPLY "TAB":U.
   RETURN NO-APPLY.
END.
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "integral.PL-CFG-RPT"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "integral.PL-CFG-RPT"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consistencias B-table-Win 
PROCEDURE consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND PL-CONC WHERE
        PL-CONC.CodMov = INPUT BROWSE {&BROWSE-NAME} PL-VAR-RPT.CodMov
        NO-LOCK NO-ERROR.
   IF NOT AVAILABLE PL-CONC THEN DO:
      BELL.
      MESSAGE "Codigo de concepto no registrado" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.
   
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE x-CodVar AS INTEGER NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  IF NOT AVAILABLE PL-CFG-RPT THEN DO:
     BELL.
     MESSAGE "Debe ingresar primero Registro de Librerias"  VIEW-AS ALERT-BOX ERROR.
     RUN dispatch IN THIS-PROCEDURE ('cancel-record':U).
     RETURN.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record B-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN PL-VAR-RPT.CodRep = PL-CFG-RPT.CodRep
         PL-VAR-RPT.TpoRpt = PL-CFG-RPT.TpoRpt.
         
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

  /* Code placed here will execute AFTER standard behavior.    */

    IF AVAILABLE PL-CFG-RPT THEN DO:
        CASE PL-CFG-RPT.TpoRpt:
            WHEN 1 THEN FILL-IN-deslib = "SEMANA :".
            WHEN 2 THEN FILL-IN-deslib = "MES :".
            WHEN 3 THEN FILL-IN-deslib = "CONSOLIDADO :".
        END CASE.
        FILL-IN-deslib = FILL-IN-deslib + " " +
            PL-CFG-RPT.CodRep + " - " + PL-CFG-RPT.DesRep.
    END.
    ELSE FILL-IN-deslib = "".

    DISPLAY FILL-IN-deslib WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN consistencias.

    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "integral.PL-CFG-RPT"}
  {src/adm/template/snd-list.i "integral.PL-VAR-RPT"}
  {src/adm/template/snd-list.i "integral.PL-CONC"}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


