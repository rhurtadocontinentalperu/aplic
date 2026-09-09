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

DEFINE SHARED TEMP-TABLE DREQ LIKE Lg-DRequ.
DEFINE BUFFER B-CREQ FOR Lg-CRequ.
DEFINE BUFFER B-DREQ FOR Lg-DRequ.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LG-CRequ
&Scoped-define FIRST-EXTERNAL-TABLE LG-CRequ


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-CRequ.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-CRequ.Solicita LG-CRequ.Observ 
&Scoped-define ENABLED-TABLES LG-CRequ
&Scoped-define FIRST-ENABLED-TABLE LG-CRequ
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS LG-CRequ.NroReq LG-CRequ.FchReq ~
LG-CRequ.Solicita LG-CRequ.Userid-Sol LG-CRequ.Observ LG-CRequ.HorEmi 
&Scoped-define DISPLAYED-TABLES LG-CRequ
&Scoped-define FIRST-DISPLAYED-TABLE LG-CRequ
&Scoped-Define DISPLAYED-OBJECTS F-SitDoc 

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
DEFINE VARIABLE F-SitDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Solicitado" 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .81
     FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-CRequ.NroReq AT ROW 1.27 COL 14 COLON-ALIGNED
          LABEL "Nro. Requerimiento"
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          FONT 6
     F-SitDoc AT ROW 1.27 COL 66 COLON-ALIGNED
     LG-CRequ.FchReq AT ROW 2.04 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LG-CRequ.Solicita AT ROW 2.35 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .81
     LG-CRequ.Userid-Sol AT ROW 2.81 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     LG-CRequ.Observ AT ROW 3.42 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .81
     LG-CRequ.HorEmi AT ROW 3.58 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     RECT-24 AT ROW 1 COL 1
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
         HEIGHT             = 3.46
         WIDTH              = 86.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-SitDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.FchReq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.HorEmi IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.NroReq IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.Userid-Sol IN FRAME F-Main
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/       
 FOR EACH LG-DREQU EXCLUSIVE-LOCK WHERE LG-DREQU.CODCIA = LG-CREQU.CODCIA
    AND LG-DREQU.NROREQ = LG-CREQU.NROREQ
     ON ERROR UNDO, RETURN 'ADM-ERROR'   
     ON STOP UNDO, RETURN 'ADM-ERROR':
     DELETE LG-DREQU.    
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DREQ:
    DELETE DREQ.
  END.
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
   RUN Borra-Temporal.
/*   RUN Borra-Temporal.   */
   FOR EACH Lg-drequ of lg-crequ NO-LOCK: 
        CREATE DREQ.
        BUFFER-COPY LG-DREQU TO DREQ.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DREQ:
    CREATE LG-DREQU.
    BUFFER-COPY DREQ TO LG-DREQU
        ASSIGN 
          LG-DREQU.CodCia  = S-CODCIA 
          LG-DRequ.CodDiv  = s-coddiv
          LG-DRequ.NroSer  = 0
          LG-DREQU.NroReq  = INTEGER(LG-CREQU.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME})
          LG-DRequ.Codmat  = DREQ.CodMat
          LG-DRequ.CanPedi = DREQ.CanPed
          LG-DRequ.FchIng  = DREQ.FchIng.
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
  
  DEFINE VAR CONTADOR AS INTEGER INIT 1. 
  DEFINE VAR Usuario LIKE DICTDB._user._user-name.
  FOR EACH B-CREQ /*WHERE B-CREQ.NroReq = INTEGER(IMCOCMP.PERIODO:SCREEN-VALUE)*/
      BREAK BY B-CREQ.NroReq:
      CONTADOR = CONTADOR + 1.
  END.
  DISPLAY contador @ LG-CREQU.NroReq WITH FRAME {&FRAME-NAME}.  
  
  DO WITH FRAME {&FRAME-NAME}:
  /*Cargando usuario*/
      FIND DICTDB._user WHERE DICTDB._user._userid = s-User-Id NO-LOCK NO-ERROR.
      IF AVAILABLE DICTDB._user THEN
         Usuario = DICTDB._user._user-name.
      ELSE Usuario = "".

    DISPLAY
        TODAY                    @ LG-CREQU.FchReq
        Usuario                  @ LG-CRequ.Solicita
        S-USER-ID                @ LG-CREQU.Userid-sol
        STRING(TIME, "HH:MM")    @ LG-CREQU.HorEmi.
    RUN Borra-Temporal.
  END.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
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
  
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
       FIND DICTDB._user WHERE DICTDB._user._userid = s-User-Id NO-LOCK NO-ERROR.
            IF AVAILABLE DICTDB._user THEN
       ASSIGN LG-CREQU.Solicita = DICTDB._user._user-name.
       ELSE ASSIGN LG-CREQU.Solicita = "".
       ASSIGN 
            LG-CREQU.codcia = s-codcia
            LG-CREQU.NroReq = INTEGER(LG-CREQU.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            LG-CREQU.FchReq = TODAY
            LG-CREQU.Userid-Sol = S-USER-ID
            LG-CREQU.HorEmi = STRING(TIME, 'HH:MM')
            LG-CREQU.FlgSit = 'S'.      /* Solicitado */
    END.
    ELSE DO:
      RUN Borra-Detalle.
    END.
    RUN Genera-Detalle.
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  
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

    IF LOOKUP(LG-CREQU.FlgSit, "S") = 0 THEN DO:
        MESSAGE "El Requerimiento de Compra no puede ser anulado" SKIP
                "se encuentra " ENTRY(LOOKUP(LG-CREQU.FlgSit,"R,A,N,C,P"),"Rechazado,Aprobado,Anulado,Atendido,Atendido Parcialmente")
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    ELSE DO:     
         FIND B-CREQ OF LG-CREQU EXCLUSIVE-LOCK NO-ERROR.
         IF AVAILABLE B-CREQ AND B-CREQ.FlgSit = "S" THEN DO:
            FOR EACH LG-DREQU OF LG-CREQU EXCLUSIVE-LOCK
                ON ERROR UNDO, RETURN 'ADM-ERROR'   
                ON STOP UNDO, RETURN 'ADM-ERROR':
                DELETE LG-DREQU.
            END.
            ASSIGN
                B-CREQ.FlgSit = "N"
                B-CREQ.Userid-Sol = S-USER-ID.      
         END.
         RELEASE B-CREQ.
         FIND CURRENT LG-CREQU NO-LOCK NO-ERROR.
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RUN Procesa-Handle IN lh_Handle ('Pagina1').  


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
  IF AVAILABLE LG-CREQU THEN DO WITH FRAME {&FRAME-NAME}:   
      CASE LG-CREQU.FlgSit:
        WHEN "S" THEN DISPLAY "Solicitado"            @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "R" THEN DISPLAY "Rechazado"             @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "N" THEN DISPLAY "Anulado"               @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "A" THEN DISPLAY "Aprobado"              @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "T" THEN DISPLAY "Atendido"              @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "P" THEN DISPLAY "Atendido Parcialmente" @ F-SitDoc WITH FRAME {&FRAME-NAME}.
        WHEN "O" THEN DISPLAY "O/C Emitida"           @ F-SitDoc WITH FRAME {&FRAME-NAME}.
     END CASE.   
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
          INTEGRAL.LG-CRequ.Solicita:SENSITIVE = FALSE.
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
  DEF VAR I AS INTEGER.
  DEF VAR x-Ok AS LOG NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF LG-CREQU.FlgSit <> "R" THEN RUN IMP\r-req(ROWID(LG-CREQU), LG-CREQU.NROREQ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
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
/*DO WITH FRAME {&FRAME-NAME} :   
   IF LG-CREQU.Solicita:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Ingrese quien es el Solicitante" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-CREQU.Solicita.
      RETURN "ADM-ERROR".   
   END.
END.*/
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
    IF NOT AVAILABLE LG-CREQU THEN RETURN "ADM-ERROR".
    IF LOOKUP(LG-CREQU.FlgSit, "S") = 0 THEN DO:
        MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.    
    RUN Carga-Temporal.
    RUN Procesa-Handle IN lh_handle ('Pagina2').

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

