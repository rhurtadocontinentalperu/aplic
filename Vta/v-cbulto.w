&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR S-NomCia  AS CHAR.

DEF SHARED VAR lh_Handle AS HANDLE.


DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */

DEF STREAM REPORTE.

DEF VAR s-task-no AS INT INIT 0 NO-UNDO.

DEF BUFFER bDBult FOR CcbDBult.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCBult
&Scoped-define FIRST-EXTERNAL-TABLE CcbCBult


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCBult.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCBult.NroDoc CcbCBult.Bultos ~
CcbCBult.Chr_04 CcbCBult.Agencia CcbCBult.ordcmp CcbCBult.Chr_01 ~
CcbCBult.Chr_02 CcbCBult.Chr_03 
&Scoped-define ENABLED-TABLES CcbCBult
&Scoped-define FIRST-ENABLED-TABLE CcbCBult
&Scoped-Define DISPLAYED-FIELDS CcbCBult.NroDoc CcbCBult.FchDoc ~
CcbCBult.Bultos CcbCBult.usuario CcbCBult.Chr_04 CcbCBult.Chequeador ~
CcbCBult.Agencia CcbCBult.ordcmp CcbCBult.Chr_01 CcbCBult.Chr_02 ~
CcbCBult.Chr_03 
&Scoped-define DISPLAYED-TABLES CcbCBult
&Scoped-define FIRST-DISPLAYED-TABLE CcbCBult


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCBult.NroDoc AT ROW 1 COL 10 COLON-ALIGNED
          LABEL "G/R Nº"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCBult.FchDoc AT ROW 1 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCBult.Bultos AT ROW 1.81 COL 10 COLON-ALIGNED FORMAT ">>9"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     CcbCBult.usuario AT ROW 1.81 COL 75 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCBult.Chr_04 AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 14
          LABEL "Chequeador"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     CcbCBult.Chequeador AT ROW 2.62 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35 BY .81
     CcbCBult.Agencia AT ROW 3.42 COL 10 COLON-ALIGNED FORMAT "x(40)"
          VIEW-AS FILL-IN 
          SIZE 30 BY .81
     CcbCBult.ordcmp AT ROW 4.23 COL 10 COLON-ALIGNED WIDGET-ID 8
          LABEL "O/Compra Nº"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCBult.Chr_01 AT ROW 5.04 COL 10 COLON-ALIGNED WIDGET-ID 2
          LABEL "Albarán" FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     CcbCBult.Chr_02 AT ROW 5.85 COL 10 COLON-ALIGNED WIDGET-ID 4
          LABEL "Local" FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     CcbCBult.Chr_03 AT ROW 6.65 COL 10 COLON-ALIGNED WIDGET-ID 6
          LABEL "Sub Línea" FORMAT "x(50)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCBult
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.73
         WIDTH              = 86.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCBult.Agencia IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCBult.Bultos IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCBult.Chequeador IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCBult.Chr_01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCBult.Chr_02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCBult.Chr_03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCBult.Chr_04 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCBult.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCBult.NroDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCBult.ordcmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCBult.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCBult.Chr_04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCBult.Chr_04 V-table-Win
ON LEAVE OF CcbCBult.Chr_04 IN FRAME F-Main /* Chequeador */
DO:
  FOR FIRST gn-cob WHERE gn-cob.codcia = s-codcia
      AND gn-cob.CodCob =  INPUT CcbCBult.Chr_04 NO-LOCK:
      DISPLAY
          gn-cob.NomCob @ CcbCBult.Chequeador 
          WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "CcbCBult"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCBult"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle1 V-table-Win 
PROCEDURE Carga-Detalle1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST CcbCDocu WHERE CcbCDocu.CodCia = CcbCBult.CodCia
        AND CcbCDocu.CodDiv = CcbCBult.CodDiv
        AND CcbCDocu.CodDoc = CcbCBult.CodDoc
        AND CcbCDocu.NroDoc = CcbCBult.NroDoc NO-LOCK.
    FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
        FIND CcbDBult WHERE CcbDBult.CodCia = Ccbddocu.codcia
            AND CcbDBult.CodDoc = Ccbddocu.coddoc
            AND CcbDBult.NroDoc = Ccbddocu.nrodoc
            AND CcbDBult.codmat = Ccbddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CcbDBult THEN DO:
            CREATE Ccbdbult.
            ASSIGN
                CcbDBult.CodCia   = Ccbddocu.codcia
                CcbDBult.CodDoc   = Ccbddocu.coddoc
                CcbDBult.NroDoc   = Ccbddocu.nrodoc
                CcbDBult.codmat   = Ccbddocu.codmat
                CcbDBult.Factor   = Ccbddocu.factor
                CcbDBult.UndVta   = Ccbddocu.undvta
                CcbDBult.NroBulto = CcbCBult.Bulto
                CcbDBult.CanDes   = Ccbddocu.CanDes.   
            RELEASE Ccbdbult.
        END.
    END.
    RUN Procesa-Handle IN lh_handle ('Query').        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencia V-table-Win 
PROCEDURE Consistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* DEBEN ESTAR TODOS LOS BULTOS */
  DEF VAR i AS INT NO-UNDO.
  DO i = 1 TO CcbCBult.Bultos:
    FIND FIRST CcbDBult WHERE CcbDBult.CodCia = CcbCBult.CodCia
        AND CcbDBult.CodDoc = CcbCBult.CodDoc
        AND CcbDBult.NroDoc = CcbCBult.NroDoc
        AND CcbDBult.NroBulto = i NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbDBult THEN DO:
        MESSAGE 'Falta ingresar el bulto #' i VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
  END.
  /* TODOS LOS MATERIALES DEBEN ESTAR DISTRIBUIDOS EN TODOS LOS BULTOS */
  DEF VAR x-CanDes AS DEC NO-UNDO.
  FOR EACH Ccbddocu NO-LOCK WHERE Ccbddocu.codcia = CcbCBult.CodCia 
      AND Ccbddocu.coddiv = CcbCBult.CodDiv
      AND Ccbddocu.coddoc = CcbCBult.CodDoc 
      AND Ccbddocu.nrodoc = CcbCBult.NroDoc:
    x-CanDes = Ccbddocu.candes.
    FOR EACH Ccbdbult NO-LOCK WHERE CcbDBult.CodCia = CcbCBult.CodCia
        AND CcbDBult.CodDoc = CcbCBult.CodDoc
        AND CcbDBult.NroDoc = CcbCBult.NroDoc
        AND Ccbdbult.codmat = Ccbddocu.codmat:
        x-CanDes = x-CanDes - CcbDBult.CanDes.
    END.
    IF x-CanDes <> 0 THEN DO:
        MESSAGE 'Del producto' Ccbddocu.codmat SKIP
                'Falta repartir' x-CanDes Ccbddocu.undvta
                VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR c-Copias AS INT.
    
  DO c-Copias = 1 TO s-nro-copias:
    CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
    END CASE.
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
    RUN Formato.
    PAGE STREAM REPORT.
    OUTPUT STREAM REPORT CLOSE.
  END.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-A V-table-Win 
PROCEDURE Formato-A :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF VAR cCodEAN AS CHARACTER.
 DEF VAR iInt AS INT NO-UNDO.

 IF s-task-no = 0 THEN DO:
     CORRELATIVO:
     REPEAT:
         s-task-no = RANDOM(1,999999).
         FIND FIRST w-report WHERE task-no = s-task-no NO-LOCK NO-ERROR.
         IF NOT AVAILABLE w-report THEN LEAVE CORRELATIVO.
     END.
 END.

 FOR EACH ccbdbult NO-LOCK WHERE CcbDBult.CodCia = CcbCBult.CodCia
        AND CcbDBult.CodDoc = CcbCBult.CodDoc
        AND CcbDBult.NroDoc = CcbCBult.NroDoc,
     FIRST almmmatg OF ccbdbult NO-LOCK WHERE almmmatg.codbrr <> ''
     BREAK BY CcbDBult.NroBulto BY CcbDBult.codmat:
     RUN Vta\R-CalCodEAN.p (INPUT Almmmatg.CodBrr, OUTPUT cCodEan).
     iInt = iInt + 1.     
     CREATE w-report.
     ASSIGN
         w-report.Task-No    = s-task-no 
         w-report.Llave-I    = iInt
         w-report.Campo-C[1] = CcbCBult.OrdCmp
         w-report.Campo-C[2] = CcbCBult.Chr_01
         w-report.Campo-C[3] = CcbCBult.Chr_02
         w-report.Campo-C[4] = CcbCBult.Chr_03
         w-report.Campo-C[5] = CcbCBult.CodDoc
         w-report.Campo-C[6] = CcbCBult.NroDoc
         w-report.Campo-C[7] = CcbdBult.CodMat
         w-report.Campo-C[8] = Almmmatg.DesMat
         w-report.Campo-C[9] = cCodEan        
         w-report.Campo-C[10] = Almmmatg.CodBrr 
         w-report.Campo-I[1] = CcbdBult.NroBulto
         w-report.Campo-I[2] = CcbCBult.Bultos
         w-report.Campo-I[3] = CcbdBult.CanDes
         w-report.Campo-I[4] = s-codcia.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pagina2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
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
    CcbCBult.CodCli = Ccbcdocu.codcli
    CcbCBult.DirCli = Ccbcdocu.dircli
    CcbCBult.NomCli = Ccbcdocu.nomcli
    CcbCBult.usuario = s-user-id
    CcbCBult.FchDoc  = TODAY
    CcbCBult.Chequeador = CAPS(CcbCBult.Chequeador:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

  IF CcbCBult.Bultos = 1 THEN RUN Carga-Detalle1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    CcbCBult.CodCia = s-CodCia
    CcbCBult.CodDiv = s-CodDiv
    CcbCBult.CodDoc = s-CodDoc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH Ccbdbult WHERE Ccbdbult.codcia = Ccbcbult.codcia
         AND Ccbdbult.coddoc = Ccbcbult.coddoc
         AND Ccbdbult.nrodoc = Ccbcbult.nrodoc:
    DELETE Ccbdbult.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN CcbCBult.NroDoc:SENSITIVE = NO.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE Ccbcbult THEN RETURN.
  RUN Consistencia.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* IMPRESION A MEDIA HOJA */
  DEF VAR pFormato AS INT.

  RUN vta/d-cbulto (OUTPUT pFormato).
  IF pFormato = 0 THEN RETURN.

  CASE pFormato:
      WHEN 1 THEN DO:
/*           DEF VAR Rpta-1 AS LOG.                     */
/*           SYSTEM-DIALOG PRINTER-SETUP UPDATE Rpta-1. */
/*           IF Rpta-1 = NO THEN RETURN.                */
          GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
          ASSIGN
            RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'
            RB-REPORT-NAME = 'Identificacion de Bultos'
            RB-INCLUDE-RECORDS = "O"
            RB-FILTER = "ccbdbult.codcia = " + STRING(Ccbcbult.codcia) +
                        " AND Ccbdbult.coddoc = '" + Ccbcbult.coddoc + "'" +
                        " AND Ccbdbult.nrodoc = '" + Ccbcbult.nrodoc + "'".
          RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                            RB-REPORT-NAME,
                            RB-INCLUDE-RECORDS,
                            RB-FILTER,
                            RB-OTHER-PARAMETERS).
      END.
      WHEN 2 THEN DO:
          /* CODIGO DE BARRAS */
/*           DEF VAR x-Tipo AS INT INIT 2 NO-UNDO.                                                              */
/*           DEF VAR x-Copias AS INT INIT 1 NO-UNDO.                                                            */
/*                                                                                                              */
/*           RUN lib/_port-name('Barras', OUTPUT s-port-name).                                                  */
/*           IF s-port-name = '' THEN RETURN.                                                                   */
/*           IF s-OpSys = 'WinVista' OR s-OpSys = 'WinXP'                                                       */
/*           THEN OUTPUT STREAM REPORTE TO PRINTER VALUE(s-port-name).                                          */
/*           ELSE OUTPUT STREAM REPORTE TO VALUE(s-port-name).                                                  */
/*           FOR EACH ccbdbult OF ccbcbult NO-LOCK,                                                             */
/*                 FIRST almmmatg OF ccbdbult NO-LOCK WHERE almmmatg.codbrr <> ''                               */
/*                 BY CcbDBult.NroBulto BY CcbDBult.codmat:                                                     */
/*               PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */                  */
/*               {alm/ean13.i}                                                                                  */
/*                                                                                                              */
/*               PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */                  */
/*               {alm/ean13.i}                                                                                  */
/*                                                                                                              */
/*               PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */                  */
/*               {alm/ean13.i}                                                                                  */
/*                                                                                                              */
/*               PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */                  */
/*               {alm/ean13.i}                                                                                  */
/*                                                                                                              */
/*               PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */             */
/*               PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */ */
/*               PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */                  */
/*           END.                                                                                               */
/*           OUTPUT STREAM REPORTE CLOSE.                                                                       */

/*           DEF VAR x-Tipo AS INT INIT 2 NO-UNDO.                                                                  */
/*           DEF VAR x-Copias AS INT INIT 1 NO-UNDO.                                                                */
/*           DEF VAR x-Fila AS INT INIT 1 NO-UNDO.                                                                  */
/*                                                                                                                  */
/*           RUN lib/_port-name('Barras', OUTPUT s-port-name).                                                      */
/*           IF s-port-name = '' THEN RETURN.                                                                       */
/*           IF s-OpSys = 'WinVista' OR s-OpSys = 'WinXP'                                                           */
/*           THEN OUTPUT STREAM REPORTE TO PRINTER VALUE(s-port-name).                                              */
/*           ELSE OUTPUT STREAM REPORTE TO VALUE(s-port-name).                                                      */
/*           FOR EACH ccbdbult OF ccbcbult NO-LOCK,                                                                 */
/*                 FIRST almmmatg OF ccbdbult NO-LOCK WHERE almmmatg.codbrr <> ''                                   */
/*                 BREAK BY CcbDBult.NroBulto BY CcbDBult.codmat:                                                   */
/*               CASE x-Fila:                                                                                       */
/*                   WHEN 1 THEN DO:                                                                                */
/*                       PUT STREAM REPORTE '^XA^LH000,012'               SKIP.   /* Inicia formato */              */
/*                       {alm/ean13.i}                                                                              */
/*                   END.                                                                                           */
/*                   WHEN 2 THEN DO:                                                                                */
/*                       PUT STREAM REPORTE '^LH210,012'                  SKIP.   /* Inicia formato */              */
/*                       {alm/ean13.i}                                                                              */
/*                   END.                                                                                           */
/*                   WHEN 3 THEN DO:                                                                                */
/*                       PUT STREAM REPORTE '^LH420,012'                  SKIP.   /* Inicia formato */              */
/*                       {alm/ean13.i}                                                                              */
/*                   END.                                                                                           */
/*                   WHEN 4 THEN DO:                                                                                */
/*                       PUT STREAM REPORTE '^LH630,012'                  SKIP.   /* Inicia formato */              */
/*                       {alm/ean13.i}                                                                              */
/*                   END.                                                                                           */
/*               END CASE.                                                                                          */
/*               x-Fila = x-Fila + 1.                                                                               */
/*               IF x-Fila > 4 OR LAST-OF(Ccbdbult.NroBulto)THEN DO:                                                */
/*                   x-Fila = 1.                                                                                    */
/*                   PUT STREAM REPORTE '^PQ' + TRIM(STRING(x-Copias)) SKIP.  /* Cantidad a imprimir */             */
/*                   PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */ */
/*                   PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */                  */
/*               END.                                                                                               */
/*           END.                                                                                                   */
/*           OUTPUT STREAM REPORTE CLOSE.                                                                           */
/*                                                                                                                  */
/*             /* ROTULO POR CAJA */                                                                                */
/*           GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.                                    */
/*           ASSIGN                                                                                                 */
/*             RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'                                              */
/*             RB-REPORT-NAME = 'Bultos Supermercados'                                                              */
/*             RB-INCLUDE-RECORDS = "O"                                                                             */
/*             RB-FILTER = "ccbdbult.codcia = " + STRING(Ccbcbult.codcia) +                                         */
/*                         " AND Ccbdbult.coddoc = '" + Ccbcbult.coddoc + "'" +                                     */
/*                         " AND Ccbdbult.nrodoc = '" + Ccbcbult.nrodoc + "'".                                      */
/*           RUN lib/_imprime2 (RB-REPORT-LIBRARY,                                                                  */
/*                             RB-REPORT-NAME,                                                                      */
/*                             RB-INCLUDE-RECORDS,                                                                  */
/*                             RB-FILTER,                                                                           */
/*                             RB-OTHER-PARAMETERS).                                                                */


          RUN Formato-A.
          /* ROTULO POR CAJA */     
          GET-KEY-VALUE SECTION 'Startup' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
          ASSIGN
              RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'vta/rbvta.prl'
              RB-REPORT-NAME = 'Bultos Supermercados_2'
              RB-INCLUDE-RECORDS = "O"
              RB-FILTER = "w-report.task-no = " + STRING(s-task-no) + 
                          " AND w-report.Campo-C[5] = '" + Ccbcbult.coddoc + "'" +
                          " AND w-report.Campo-C[6] = '" + Ccbcbult.nrodoc + "'".
        
          RUN lib/_imprime2 (RB-REPORT-LIBRARY,
                              RB-REPORT-NAME,
                              RB-INCLUDE-RECORDS,
                              RB-FILTER,
                              RB-OTHER-PARAMETERS).
        
          FOR EACH w-report WHERE task-no = s-task-no:
              DELETE w-report.
          END.
          s-task-no = 0.
      END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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
  RUN Procesa-Handle IN lh_handle ('pagina1').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCBult"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = 'G/R'
        AND Ccbcdocu.nrodoc = CcbCBult.NroDoc:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'Número de la Guia de Remisión NO valido' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.flgest = 'A' THEN DO:
        MESSAGE 'Guia de Remisión ANULADA' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF INPUT CcbCBult.Bultos = 0 THEN DO:
        MESSAGE 'Ingrese el número de bultos' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF CcbCBult.Chequeador:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el nombre del chequeador' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
  END.

  RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

