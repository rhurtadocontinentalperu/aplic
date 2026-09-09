&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DREQ LIKE INTEGRAL.LG-DRequ.


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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-codpro AS CHAR.

DEF VAR pv-codcia AS INT NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LG-CRequ
&Scoped-define FIRST-EXTERNAL-TABLE LG-CRequ


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-CRequ.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-CRequ.TpoReq LG-CRequ.FchReq ~
LG-CRequ.Solicita LG-CRequ.Userid-Sol LG-CRequ.CodPro LG-CRequ.NomPro ~
LG-CRequ.Observ 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}FchReq ~{&FP2}FchReq ~{&FP3}~
 ~{&FP1}Solicita ~{&FP2}Solicita ~{&FP3}~
 ~{&FP1}Userid-Sol ~{&FP2}Userid-Sol ~{&FP3}~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}NomPro ~{&FP2}NomPro ~{&FP3}~
 ~{&FP1}Observ ~{&FP2}Observ ~{&FP3}
&Scoped-define ENABLED-TABLES LG-CRequ
&Scoped-define FIRST-ENABLED-TABLE LG-CRequ
&Scoped-Define DISPLAYED-FIELDS LG-CRequ.NroSer LG-CRequ.NroReq ~
LG-CRequ.TpoReq LG-CRequ.FchReq LG-CRequ.Solicita LG-CRequ.Userid-Sol ~
LG-CRequ.CodPro LG-CRequ.NomPro LG-CRequ.Observ 
&Scoped-Define DISPLAYED-OBJECTS x-NomAlm 

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
DEFINE VARIABLE x-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-CRequ.NroSer AT ROW 1.19 COL 11 COLON-ALIGNED
          LABEL "Correlativo"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     LG-CRequ.NroReq AT ROW 1.19 COL 16 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     LG-CRequ.TpoReq AT ROW 1.19 COL 39 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nacional", "N":U,
"Importacion", "I":U
          SIZE 21 BY .77
     LG-CRequ.FchReq AT ROW 1.19 COL 74 COLON-ALIGNED
          LABEL "Emision"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LG-CRequ.Solicita AT ROW 2.15 COL 11 COLON-ALIGNED
          LABEL "Almacen"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     x-NomAlm AT ROW 2.15 COL 17 COLON-ALIGNED NO-LABEL
     LG-CRequ.Userid-Sol AT ROW 2.15 COL 74 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LG-CRequ.CodPro AT ROW 3.12 COL 11 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     LG-CRequ.NomPro AT ROW 3.12 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     LG-CRequ.Observ AT ROW 4.08 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47 BY .81
     "Tipo:" VIEW-AS TEXT
          SIZE 4 BY .5 AT ROW 1.19 COL 35
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LG-CRequ
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DREQ T "SHARED" ? INTEGRAL LG-DRequ
   END-TABLES.
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.31
         WIDTH              = 96.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN LG-CRequ.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.FchReq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.NroReq IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.NroSer IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.Solicita IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.Userid-Sol IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN x-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME LG-CRequ.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-CRequ.CodPro V-table-Win
ON LEAVE OF LG-CRequ.CodPro IN FRAME F-Main /* Proveedor */
DO:
  LG-CRequ.NomPro:SCREEN-VALUE = ''.
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
    AND Gn-prov.codpro = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov 
  THEN ASSIGN
        LG-CRequ.NomPro:SCREEN-VALUE = gn-prov.NomPro
        s-codpro = INPUT {&SELF-NAME}
        LG-CRequ.CodPro:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-CRequ.Solicita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-CRequ.Solicita V-table-Win
ON LEAVE OF LG-CRequ.Solicita IN FRAME F-Main /* Almacen */
DO:
  x-NomAlm:SCREEN-VALUE = ''.
  FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = INPUT {&SELF-NAME}
    NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN x-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "LG-CRequ"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-CRequ"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DREQ:
    DELETE DREQ.
  END.
  IF AVAILABLE Lg-CRequ
  THEN DO:
    FOR EACH Lg-DRequ OF Lg-CRequ NO-LOCK:
        CREATE DREQ.
        BUFFER-COPY Lg-DRequ TO DREQ.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle V-table-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH Lg-Drequ OF Lg-CRequ:
    DELETE Lg-DRequ.
  END.
  FOR EACH DREQ:
    CREATE Lg-DRequ.
    BUFFER-COPY DREQ TO Lg-DRequ
        ASSIGN
            LG-DRequ.CodCia = Lg-CRequ.codcia
            LG-DRequ.CodDiv = Lg-CRequ.coddiv
            LG-DRequ.NroReq = Lg-CRequ.nroreq
            LG-DRequ.NroSer = Lg-CRequ.nroser.
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
  FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'Correlativo para el documento' s-coddoc 'NO está configurado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    s-codpro = ''.
    DISPLAY
        TODAY @ LG-CRequ.FchReq 
        Faccorre.nroser @ LG-CRequ.NroSer
        Faccorre.correlativo  @ LG-CRequ.NroReq 
        s-codalm @ LG-CRequ.Solicita 
        s-user-id @ LG-CRequ.Userid-Sol.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse').

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
    LG-CRequ.Userid-Sol = s-user-id.
  RUN Graba-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

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
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').

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
  FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.coddiv = s-coddiv
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'No se pudo bloquear el correlativo' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    LG-CRequ.CodCia = s-codcia
    LG-CRequ.CodDiv = s-coddiv
    LG-CRequ.HorEmi = STRING(TIME, 'HH:MM')
    LG-CRequ.NroSer = FacCorre.NroSer
    LG-CRequ.NroReq = FacCorre.Correlativo.
  ASSIGN
    FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

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
  RUN valida-update.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT Lg-CRequ EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Lg-CRequ THEN UNDO, RETURN 'ADM-ERROR'.
    FOR EACH Lg-DRequ OF Lg-CRequ:
        DELETE Lg-DRequ.
    END.
    ASSIGN
        LG-CRequ.FlgSit = 'A'
        LG-CRequ.Observ = 'A N U L A D O'
        LG-CRequ.Userid-Sol = s-user-id.
    FIND CURRENT Lg-CRequ NO-LOCK NO-ERROR.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Lg-CRequ THEN DO WITH FRAME {&FRAME-NAME}:
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = LG-CRequ.Solicita
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN x-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
  END.

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
    ASSIGN
        LG-CRequ.FchReq:SENSITIVE = NO
        LG-CRequ.NomPro:SENSITIVE = NO
        LG-CRequ.Solicita:SENSITIVE = NO
        LG-CRequ.Userid-Sol:SENSITIVE = NO.
  END.
  
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
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "LG-CRequ"}

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
  DO WITH FRAME {&FRAME-NAME} :
    FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
        AND Gn-prov.codpro = INPUT LG-CRequ.CodPro
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-prov THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
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
  IF LG-CRequ.FlgSit <> 'S' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  s-codpro = Lg-CRequ.codpro. 
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse').
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


