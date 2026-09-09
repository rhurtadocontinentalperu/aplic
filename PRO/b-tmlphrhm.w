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
DEFINE VAR p-Fecha AS DATE.

/* Local Variable Definitions ---                                       */

{bin/s-global.i}
/*{pln/s-global.i}*/

DEFINE  SHARED VARIABLE s-periodo AS INTEGER FORMAT "9999".
DEFINE  SHARED VARIABLE s-NroMes  AS INTEGER FORMAT "99".
DEFINE  SHARED VARIABLE s-NroSem  AS INTEGER FORMAT "9999".

DEF BUFFER B-HORAS FOR LPRDHRHM.

DEFINE VAR HR  AS CHARACTER NO-UNDO.
DEFINE VAR MN  AS CHARACTER NO-UNDO.
DEFINE VAR HRS AS CHARACTER NO-UNDO.
DEFINE VAR MNS AS CHARACTER NO-UNDO.
DEFINE VARIABLE Fecha AS INTEGER.
DEFINE VARIABLE Mes   AS INTEGER.
DEFINE VARIABLE Anio  AS INTEGER.
DEF VAR H1  AS INTEGER.
DEF VAR M1  AS DECIMAL.
DEF VAR H   AS DECIMAL.
DEF VAR M   AS DECIMAL.
DEF VAR TOT AS DECIMAL.

s-periodo = year(today).
s-nromes  = month(today).

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
&Scoped-define EXTERNAL-TABLES LPRCLPRO
&Scoped-define FIRST-EXTERNAL-TABLE LPRCLPRO


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LPRCLPRO.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LPRDHRHM PL-PERS

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table LPRDHRHM.CodPer PL-PERS.patper ~
PL-PERS.matper PL-PERS.nomper LPRDHRHM.HoraI LPRDHRHM.HoraF LPRDHRHM.HoraT 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table LPRDHRHM.CodPer 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_table~
 ~{&FP1}CodPer ~{&FP2}CodPer ~{&FP3}
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table LPRDHRHM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table LPRDHRHM
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH LPRDHRHM OF LPRCLPRO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST PL-PERS OF LPRDHRHM NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table LPRDHRHM PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table LPRDHRHM


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
      LPRDHRHM, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      LPRDHRHM.CodPer COLUMN-LABEL "<<Código>>"
      PL-PERS.patper FORMAT "X(23)"
      PL-PERS.matper FORMAT "X(23)"
      PL-PERS.nomper FORMAT "X(23)"
      LPRDHRHM.HoraI FORMAT "99:99"
      LPRDHRHM.HoraF COLUMN-LABEL "Hora Salida" FORMAT "99:99"
      LPRDHRHM.HoraT
  ENABLE
      LPRDHRHM.CodPer
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 90 BY 9.23
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.19 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.LPRCLPRO
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
         HEIGHT             = 10.19
         WIDTH              = 94.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

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
     _TblList          = "INTEGRAL.LPRDHRHM OF INTEGRAL.LPRCLPRO,INTEGRAL.PL-PERS OF INTEGRAL.LPRDHRHM"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > INTEGRAL.LPRDHRHM.CodPer
"LPRDHRHM.CodPer" "<<Código>>" ? "character" ? ? ? ? ? ? yes ?
     _FldNameList[2]   > INTEGRAL.PL-PERS.patper
"PL-PERS.patper" ? "X(23)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > INTEGRAL.PL-PERS.matper
"PL-PERS.matper" ? "X(23)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > INTEGRAL.PL-PERS.nomper
"PL-PERS.nomper" ? "X(23)" "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > INTEGRAL.LPRDHRHM.HoraI
"LPRDHRHM.HoraI" ? "99:99" "date" ? ? ? ? ? ? no ?
     _FldNameList[6]   > INTEGRAL.LPRDHRHM.HoraF
"LPRDHRHM.HoraF" "Hora Salida" "99:99" "date" ? ? ? ? ? ? no ?
     _FldNameList[7]   = INTEGRAL.LPRDHRHM.HoraT
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

{src/adm-vm/method/vmbrowser.i}
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

ON RETURN OF LPRDHRHM.CodPer, LPRDHRHM.HoraI, LPRDHRHM.HoraF
DO:
    APPLY "TAB":U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LPRDHRHM.CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRDHRHM.CodPer br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF LPRDHRHM.CodPer IN BROWSE br_table /* <<Código>> */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND PL-PERS WHERE PL-PERS.CodCia = S-CodCia AND
       PL-PERS.codper = SELF:SCREEN-VALUE
       NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PL-PERS THEN DO:
     MESSAGE "No existe empleado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY 
    PL-PERS.PatPer @ PL-PERS.PatPer
    PL-PERS.MatPer @ PL-PERS.MatPer
    PL-PERS.NomPer @ PL-PERS.NomPer
  WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRDHRHM.CodPer br_table _BROWSE-COLUMN B-table-Win
ON MOUSE-SELECT-DBLCLICK OF LPRDHRHM.CodPer IN BROWSE br_table /* <<Código>> */
OR F8 OF LPRDHRHM.CodPer DO:

    DEFINE VARIABLE reg-act AS ROWID.
    RUN PLN/H-FLG-M-PR.R (1, OUTPUT reg-act).
    IF reg-act <> ? THEN DO:
        FIND PL-FLG-MES WHERE ROWID(PL-FLG-MES) = reg-act NO-LOCK NO-ERROR.
        IF AVAILABLE PL-FLG-MES THEN
           LPRDHRHM.CodPEr:screen-value IN BROWSE {&BROWSE-NAME} = PL-FLG-MES.CodPer.
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
  {src/adm/template/row-list.i "LPRCLPRO"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LPRCLPRO"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculando-Horas B-table-Win 
PROCEDURE Calculando-Horas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 

  
  /*****Calculando horas totales**************/
  
  H1 = (INTEGER(SUBSTRING(LPRDHRHM.HoraF,1,2)) - INTEGER(SUBSTRING(LPRDHRHM.HoraI,1,2))) - 1. 
  M1 = (60 - INTEGER(SUBSTRING(LPRDHRHM.HoraI,3))) + INTEGER(SUBSTRING(LPRDHRHM.HoraF,3)).
    
  IF M1 > 59 THEN DO:
     M1 = M1 / 60.
     /*H1 = H1 + TRUNCATE(M1,0).
   *   M1 = (M1 - H1) * 60.*/
  END.
  ELSE M1 = M1 / 100.
   TOT = H1 + M1.
  
  Fecha = DECIMAL(DAY(TODAY)).
  Mes   = DECIMAL(MONTH(TODAY)).
  Anio  = DECIMAL(YEAR (TODAY)).
  
  IF Fecha >= 26 AND Mes < 12 THEN DO:
    Mes = Mes + 1 .
  END.
  ELSE IF Fecha > 25 AND Mes = 12 THEN DO:
    Mes  = 1 .
    Anio = Anio + 1 .
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

  /* Code placed here will execute PRIOR to standard behavior. */
  IF LPRCLPRO.Estado <> 'E' THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN Calculando-Horas.
  ASSIGN 
      LPRDHRHM.CodCia   = LPRCLPRO.CodCia
      LPRDHRHM.CodMaq   = LPRCLPRO.CodMaq
      LPRDHRHM.NroDoc   = LPRCLPRO.NroDoc 
      /*LPRDHRHM.CodMov = 
 *       LPRDHRHM.CodCal =*/
      LPRDHRHM.HoraT    = TOT
      LPRDHRHM.CodPln   = 1
      LPRDHRHM.NroMes   = Mes
      LPRDHRHM.Periodo  = Anio .
 END.
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
  ASSIGN  input-var-1 = LPRCLPRO.NumOrd
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
     IF LPRCLPRO.Estado <> 'E' THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "LPRCLPRO"}
  {src/adm/template/snd-list.i "LPRDHRHM"}
  {src/adm/template/snd-list.i "PL-PERS"}

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

/************Validando ingreso de personal******************/
 IF LPRDHRHM.CodPer:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> "" THEN DO:
    FIND PL-PERS WHERE PL-PERS.CodCia = S-CodCia AND
        PL-PERS.CodPer = LPRDHRHM.CodPer:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
        IF NOT AVAILABLE PL-PERS THEN DO:
          MESSAGE "Ingreso inválido" VIEW-AS ALERT-BOX ERROR.
          RETURN 'NO-APPLY'.
     END.
 END.
 ELSE DO:
    MESSAGE "Ingrese personal" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO LPRDHRHM.CodPer.
    RETURN "ADM-ERROR".
 END.
 
/*******************Validando hora inicio******************/
 
 IF LPRDHRHM.HoraI:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
    MESSAGE "Ingrese hora de inicio" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO LPRDHRHM.HoraI.
    RETURN "ADM-ERROR".    
 END.
 ELSE DO:
    HR = SUBSTRING(LPRDHRHM.HoraI:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,2).
    MN = SUBSTRING(LPRDHRHM.HoraI:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4).
 END.
 
  IF (INTEGER(HR) > 23) OR INTEGER(MN) > 59 THEN DO:
       MESSAGE "Hora inválida" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO LPRDHRHM.HoraI.
       RETURN "ADM-ERROR".    
  END. 
 
/*******************Validando hora fin**********************/
 
 IF LPRDHRHM.HoraF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
    MESSAGE "Ingrese hora de inicio" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO LPRDHRHM.HoraF.
    RETURN "ADM-ERROR".    
 END.
 ELSE DO:
    HRS = SUBSTRING(LPRDHRHM.HoraF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},1,2).
    MNS = SUBSTRING(LPRDHRHM.HoraF:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},4).
 END.
 IF (INTEGER(HRS) > 23) OR INTEGER (MNS) > 59 THEN DO:
       MESSAGE "Hora inválida" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO LPRDHRHM.HoraF.
       RETURN "ADM-ERROR".    
 END.  

/*******************Validando repetecion de registro******************/
  
IF NOT(DECIMAL(HR)< DECIMAL(HRS)) THEN DO:
   MESSAGE "Hora inválida" VIEW-AS ALERT-BOX ERROR.
   APPLY 'ENTRY':U TO LPRDHRHM.HoraI.
   RETURN "ADM-ERROR".    
END.

/*******************Validando repetecion de registro******************/
 
 RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' AND
     CAN-FIND(FIRST B-HORAS WHERE
        B-HORAS.CodCia = LPRDHRHM.CodCia AND
        B-HORAS.CodMaq = LPRDHRHM.CodMaq /*:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/ AND
        B-HORAS.NroDoc = LPRDHRHM.NroDoc /*:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/ AND
        B-HORAS.CodPer = LPRDHRHM.CodPer:SCREEN-VALUE 
        IN BROWSE {&BROWSE-NAME} NO-LOCK) THEN DO:
        MESSAGE "Registro repetido" VIEW-AS ALERT-BOX ERROR.
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
IF LPRCLPRO.Estado <> 'E' THEN RETURN 'ADM-ERROR'.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


