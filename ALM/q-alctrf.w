&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
/*------------------------------------------------------------------------
  File:  
  Description: from QUERY.W - Template For Query objects in the ADM
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
DEFINE VARIABLE T-TITULO AS CHAR INITIAL "".

DEFINE SHARED VARIABLE S-NROSER AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV AS CHARACTER.
DEFINE SHARED VARIABLE S-CODALM AS CHARACTER.
DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle AS HANDLE.

DEFINE SHARED VARIABLE S-TPOMOV AS CHAR.
DEFINE SHARED VARIABLE S-MOVTRF AS INTEGER.
DEFINE SHARED VARIABLE L-NROSER AS CHAR.

FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
    AND Almtmovm.Tipmov = S-TPOMOV 
    AND Almtmovm.CodMov = S-MOVTRF
    NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME FRAME-A
&Scoped-define QUERY-NAME Query-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almtdocm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almtdocm.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almcmov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define QUERY-STRING-Query-Main FOR EACH Almcmov WHERE Almcmov.CodCia = Almtdocm.CodCia ~
  AND Almcmov.CodAlm = Almtdocm.CodAlm ~
  AND Almcmov.TipMov = Almtdocm.TipMov ~
  AND Almcmov.CodMov = Almtdocm.CodMov ~
  AND Almcmov.NroSer = S-NROSER ~
 NO-LOCK ~
    BY Almcmov.FchDoc DESCENDING ~
       BY Almcmov.NroDoc DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH Almcmov WHERE Almcmov.CodCia = Almtdocm.CodCia ~
  AND Almcmov.CodAlm = Almtdocm.CodAlm ~
  AND Almcmov.TipMov = Almtdocm.TipMov ~
  AND Almcmov.CodMov = Almtdocm.CodMov ~
  AND Almcmov.NroSer = S-NROSER ~
 NO-LOCK ~
    BY Almcmov.FchDoc DESCENDING ~
       BY Almcmov.NroDoc DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main Almcmov


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 C-NroSer F-Numero RECT-2 
&Scoped-Define DISPLAYED-OBJECTS C-NroSer F-Numero 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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
     IMAGE-UP FILE "img\b-buscar":U
     LABEL "Button 1" 
     SIZE 4 BY 1.08.

DEFINE VARIABLE C-NroSer AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7.14 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-Numero AS INTEGER FORMAT "999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .69
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 8    
     SIZE 7.86 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      Almcmov SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     BUTTON-1 AT ROW 1.04 COL 17.29
     C-NroSer AT ROW 1.12 COL 1.86 NO-LABEL
     F-Numero AT ROW 1.23 COL 9.86 NO-LABEL
     RECT-2 AT ROW 1.08 COL 9.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   External Tables: integral.Almtdocm
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.88
         WIDTH              = 27.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmquery.i}
{src/adm/method/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME FRAME-A
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME FRAME-A:SCROLLABLE       = FALSE.

/* SETTINGS FOR COMBO-BOX C-NroSer IN FRAME FRAME-A
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-Numero IN FRAME FRAME-A
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "INTEGRAL.Almcmov WHERE INTEGRAL.Almtdocm ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE"
     _OrdList          = "INTEGRAL.Almcmov.FchDoc|no,INTEGRAL.Almcmov.NroDoc|no"
     _JoinCode[1]      = "Almcmov.CodCia = Almtdocm.CodCia
  AND Almcmov.CodAlm = Almtdocm.CodAlm
  AND Almcmov.TipMov = Almtdocm.TipMov
  AND Almcmov.CodMov = Almtdocm.CodMov
  AND Almcmov.NroSer = S-NROSER
"
     _Design-Parent    is WINDOW q-tables @ ( 1.04 , 22.43 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 q-tables
ON CHOOSE OF BUTTON-1 IN FRAME FRAME-A /* Button 1 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('qbusca':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-NroSer q-tables
ON VALUE-CHANGED OF C-NroSer IN FRAME FRAME-A
DO:
  ASSIGN C-NroSer.
  S-NROSER = INTEGER(ENTRY(LOOKUP(C-NroSer,C-NroSer:LIST-ITEMS),C-NroSer:LIST-ITEMS)).
 
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/**/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Numero
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Numero q-tables
ON LEAVE OF F-Numero IN FRAME FRAME-A
OR "RETURN":U OF F-Numero
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  ASSIGN F-Numero.
  RUN Ubica-Registro.
  SELF:SCREEN-VALUE = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almtdocm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series q-tables 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH FacCorre NO-LOCK WHERE 
           FacCorre.CodCia = S-CODCIA AND
           FacCorre.CodDoc = "G/R"    AND
           FacCorre.CodDiv = S-CODDIV AND
           FacCorre.CodAlm = S-CODALM AND
/*           FacCorre.TipMov = s-TpoMov AND*/
           FacCorre.CodMov = s-MovTrf:
      IF L-NroSer = "" THEN L-NroSer = STRING(FacCorre.NroSer,"999").
      ELSE L-NroSer = L-NroSer + "," + STRING(FacCorre.NroSer,"999").
  END.

  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NroSer.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
  END.

  IF AVAILABLE Almtdocm THEN DO WITH FRAME {&FRAME-NAME}:
     FIND Almtmovm WHERE 
          Almtmovm.CodCia = Almtdocm.CodCia AND
          Almtmovm.Tipmov = Almtdocm.TipMov AND
          Almtmovm.Codmov = Almtdocm.CodMov 
          NO-LOCK NO-ERROR.
     IF Almtdocm.TipMov = "I" 
     THEN DO :
        C-NroSer:LIST-ITEMS = "000".
        S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
        C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
        DISPLAY C-NROSER.
        C-NROSER:SENSITIVE = NO.
     END.
     ELSE 
        /*IF Almtmovm.ReqGuia THEN*/ DO :
            C-NroSer:LIST-ITEMS = L-NroSer.
            IF S-NROSER = 0 THEN DO:
             S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
             C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
            END.
            C-NROSER:SENSITIVE = YES.
            DISPLAY C-NROSER.
        END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables  _DEFAULT-DISABLE
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
  HIDE FRAME FRAME-A.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry q-tables 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .
  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize q-tables 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN Carga-Series.*/
  DO WITH FRAME {&FRAME-NAME}:
    IF lh_handle <> ? THEN RUN Procesa-Handle IN lh_handle ('Carga-Series').
    C-NroSer:LIST-ITEMS = L-NroSer.
    S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
    C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
    DISPLAY C-NROSER.
  END.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query q-tables 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF AVAILABLE Almtdocm THEN DO WITH FRAME {&FRAME-NAME}:
    /* Devuelve la variable L-NroSer */
    IF lh_handle <> ? THEN RUN Procesa-Handle IN lh_handle ('Carga-Series').
    FIND Almtmovm WHERE 
          Almtmovm.CodCia = Almtdocm.CodCia AND
          Almtmovm.Tipmov = Almtdocm.TipMov AND
          Almtmovm.Codmov = Almtdocm.CodMov 
          NO-LOCK NO-ERROR.
    IF Almtdocm.TipMov <> "S" OR NOT Almtmovm.ReqGuia THEN DO :
        C-NroSer:LIST-ITEMS = "000".
        S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
        C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
        C-NROSER:SENSITIVE = NO.
    END.
    IF Almtmovm.ReqGuia THEN DO :
        C-NroSer:LIST-ITEMS = L-NroSer.
        IF S-NROSER = 0 OR S-NROSER = ? THEN DO:
            S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
            C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
        END.
        C-NROSER:SENSITIVE = YES.
    END.
    DISPLAY C-NROSER.
  END.
/*  IF AVAILABLE Almtdocm THEN DO WITH FRAME {&FRAME-NAME}:
 *      FIND Almtmovm WHERE 
 *           Almtmovm.CodCia = Almtdocm.CodCia AND
 *           Almtmovm.Tipmov = Almtdocm.TipMov AND
 *           Almtmovm.Codmov = Almtdocm.CodMov 
 *           NO-LOCK NO-ERROR.
 *      IF Almtdocm.TipMov <> "S" OR NOT Almtmovm.ReqGuia THEN DO :
 *         C-NroSer:LIST-ITEMS = "000".
 *         S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
 *         C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
 *         DISPLAY C-NROSER.
 *         C-NROSER:SENSITIVE = NO.
 *      END.
 *      IF Almtmovm.ReqGuia THEN DO :
 *          C-NroSer:LIST-ITEMS = L-NroSer.
 *          IF S-NROSER = 0 THEN DO:
 *           S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
 *           C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
 *          END.
 *          C-NROSER:SENSITIVE = YES.
 *          DISPLAY C-NROSER.
 *      END.
 *   END.*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN dispatch IN THIS-PROCEDURE ('get-last':U).*/
  RUN dispatch IN THIS-PROCEDURE ('row-available':U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-qbusca q-tables 
PROCEDURE local-qbusca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = Almtdocm.CodAlm 
          input-var-2 = Almtdocm.TipMov 
          input-var-3 = STRING(Almtdocm.CodMov)
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*
    AQUI SE DEBE LLAMAR AL PROGRAMA DE CONSULTA */
    
    IF input-var-2 = "I" THEN T-TITULO = "Ingresos de Almacen".
       ELSE T-TITULO = "Salidas de Almacen".
    
    
    RUN LKUP\C-MovAlm (T-TITULO).
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN DO:
            REPOSITION {&QUERY-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'qbusca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almtdocm"}
  {src/adm/template/snd-list.i "Almcmov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ubica-Registro q-tables 
PROCEDURE Ubica-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND Almcmov WHERE Almcmov.CodCia = Almtdocm.CodCia
     AND Almcmov.CodAlm = Almtdocm.CodAlm
     AND Almcmov.TipMov = Almtdocm.TipMov
     AND Almcmov.CodMov = Almtdocm.CodMov
     AND Almcmov.NroSer = S-NROSER 
     AND Almcmov.NroDoc = F-Numero NO-LOCK NO-ERROR.
IF AVAILABLE Almcmov THEN output-var-1 = ROWID(Almcmov).
ELSE output-var-1 = ?.
IF OUTPUT-VAR-1 <> ? THEN DO:
   FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} WHERE
        ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = OUTPUT-VAR-1 NO-LOCK NO-ERROR.
   IF AVAIL {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN DO:
      REPOSITION {&QUERY-NAME}  TO ROWID OUTPUT-VAR-1.
      RUN dispatch IN THIS-PROCEDURE ('get-next':U).
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

