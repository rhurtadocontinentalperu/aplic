&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.

DEFINE BUFFER CREQ FOR LG-CRequ.
DEFINE SHARED TEMP-TABLE DREQ LIKE LG-DRequ.
DEFINE VAR TipoBien AS INTEGER INIT 1 NO-UNDO.
DEFINE VAR Sub-tit AS CHAR.
DEFINE VAR Nro-req AS INTEGER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Requisicion de Orden".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".
/*
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

*/

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
&Scoped-Define ENABLED-FIELDS LG-CRequ.Observ LG-CRequ.FchReq ~
LG-CRequ.FchVto 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Observ ~{&FP2}Observ ~{&FP3}~
 ~{&FP1}FchReq ~{&FP2}FchReq ~{&FP3}~
 ~{&FP1}FchVto ~{&FP2}FchVto ~{&FP3}
&Scoped-define ENABLED-TABLES LG-CRequ
&Scoped-define FIRST-ENABLED-TABLE LG-CRequ
&Scoped-Define ENABLED-OBJECTS RECT-23 
&Scoped-Define DISPLAYED-FIELDS LG-CRequ.NroReq LG-CRequ.Userid-Sol ~
LG-CRequ.Observ LG-CRequ.FchReq LG-CRequ.FchVto 
&Scoped-Define DISPLAYED-OBJECTS F-Situacion 

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
CodCia||y|integral.LG-CRequ.CodCia
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "CodCia"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-Situacion AS CHARACTER FORMAT "X(15)" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .69
     FONT 0.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82.14 BY 2.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-CRequ.NroReq AT ROW 1.19 COL 10.72 COLON-ALIGNED
          LABEL "No.Requisicion"
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .69
          FONT 0
     LG-CRequ.Userid-Sol AT ROW 1.88 COL 10.72 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 18.57 BY .69
     LG-CRequ.Observ AT ROW 2.58 COL 10.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38.57 BY .69
     F-Situacion AT ROW 1.19 COL 64.14 COLON-ALIGNED NO-LABEL
     LG-CRequ.FchReq AT ROW 1.88 COL 70.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-CRequ.FchVto AT ROW 2.58 COL 70.57 COLON-ALIGNED
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-23 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.LG-CRequ
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 2.54
         WIDTH              = 82.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-CRequ.NroReq IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-CRequ.Userid-Sol IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DReq V-table-Win 
PROCEDURE Actualiza-DReq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER I-EST AS INTEGER.
FOR EACH DREQ:
    DELETE DREQ.
END.
IF I-EST = 2 THEN DO:
   FOR EACH LG-DRequ WHERE LG-DRequ.CodCia = LG-CRequ.CodCia AND 
       LG-DRequ.NroReq = LG-CRequ.NroReq AND
       LG-DRequ.TpoBien = TipoBien:
       CREATE DREQ.
       ASSIGN DREQ.CodCia  = LG-DRequ.CodCia 
              DREQ.NroReq  = LG-DRequ.NroReq
              DREQ.codmat  = LG-DRequ.Codmat 
              DREQ.CanPedi = LG-DRequ.CanPedi 
              DREQ.UndCmp  = LG-DRequ.UndCmp
              DREQ.TpoBien = LG-DRequ.TpoBien.

   END.
              nro-req = LG-DRequ.NroReq.   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Requisicion V-table-Win 
PROCEDURE Genera-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* BORRAMOS DETALLE ANTERIOR */
  FOR EACH LG-DRequ WHERE 
      LG-DRequ.CodCia = LG-CRequ.CodCia AND 
      LG-DRequ.NroReq = LG-CRequ.NroReq:
    
      FIND DREQ WHERE DREQ.CODMAT = LG-DRequ.codmat NO-LOCK NO-ERROR.
      IF NOT AVAILABLE DREQ THEN DO:
         FOR EACH LG-RqAlm WHERE 
                  LG-RqAlm.CodCia = LG-DRequ.CodCia AND
                  LG-RqAlm.NroReq = LG-DRequ.NroReq AND
                  LG-RqAlm.codmat = LG-DRequ.codmat:
             FOR EACH LG-RqFch WHERE 
                      LG-RqFch.CodCia = LG-RqAlm.CodCia AND
                      LG-RqFch.NroReq = LG-RqAlm.NroReq AND
                      LG-RqFch.codmat = LG-RqAlm.codmat AND
                      LG-RqFch.CodAlm = LG-RqAlm.codAlm:
                 DELETE LG-RqFch.
             END.
             DELETE LG-RqAlm.
         END.
      END.
      DELETE LG-DRequ.
  END.
  /* ACTUALIZAMOS EL NUEVO DETALLE */
  FOR EACH DREQ:
      CREATE LG-DRequ.
      ASSIGN LG-DRequ.CodCia  = LG-CRequ.CodCia
             LG-DRequ.NroReq  = LG-CRequ.NroReq
             LG-DRequ.Codmat  = DREQ.Codmat
             LG-DRequ.CanPedi = DREQ.CanPedi
             LG-DRequ.CanApro = DREQ.CanPedi
             LG-DRequ.tpobien = TipoBien
             LG-DRequ.UndCmp  = DREQ.UndCmp.
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
  
  RUN Actualiza-DREQ (1).
  RUN Procesa-Handle IN lh_Handle ("Pagina2").
  RUN Procesa-Handle IN lh_Handle ('Browse').
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY     @ LG-CRequ.FchReq 
             TODAY + 7 @ LG-CRequ.FchVto
             S-USER-ID @ LG-CRequ.Userid-sol.
  END.
  
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
  DEFINE VAR X-NRO AS INTEGER NO-UNDO.
  FIND LAST CREQ WHERE CREQ.CodCia = S-CODCIA NO-LOCK NO-ERROR.
  IF AVAILABLE CREQ THEN X-NRO = CREQ.NroReq + 1.
  ELSE X-NRO = 1.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     ASSIGN LG-CRequ.CodCia = S-CODCIA
            LG-CRequ.NroReq = X-NRO
            LG-CRequ.TpoReq = "P"
            LG-CRequ.Userid-sol = S-USER-ID.
  END.
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
  
  IF LG-CRequ.FlgSit <> "S" THEN RETURN ERROR.
  
  FOR EACH LG-DRequ WHERE 
      LG-DRequ.CodCia = LG-CRequ.CodCia AND 
      LG-DRequ.NroReq = LG-CRequ.NroReq:
      FOR EACH LG-RqAlm WHERE 
               LG-RqAlm.CodCia = LG-DRequ.CodCia AND
               LG-RqAlm.NroReq = LG-DRequ.NroReq AND
               LG-RqAlm.codmat = LG-DRequ.codmat:
          FOR EACH LG-RqFch WHERE 
                   LG-RqFch.CodCia = LG-RqAlm.CodCia AND
                   LG-RqFch.NroReq = LG-RqAlm.NroReq AND
                   LG-RqFch.codmat = LG-RqAlm.codmat AND
                   LG-RqFch.CodAlm = LG-RqAlm.codAlm:
              DELETE LG-RqFch.
          END.
          DELETE LG-RqAlm.
      END.
      DELETE LG-DRequ.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ('Browse').
   
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
  
  IF AVAILABLE LG-CRequ THEN DO WITH FRAME {&FRAME-NAME}:
     CASE LG-CRequ.FlgSit:
          WHEN "S" THEN F-Situacion:SCREEN-VALUE = "Solicitada".
          WHEN "R" THEN F-Situacion:SCREEN-VALUE = "Rechazada".
          WHEN "A" THEN F-Situacion:SCREEN-VALUE = "Aprobada".
          WHEN "C" THEN F-Situacion:SCREEN-VALUE = "Atendida".
     END CASE.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 
 RB-FILTER = "LG-Drequ.CodCia = " + string(S-CODCIA) +
             " AND LG-Drequ.nroreq = " + string(LG-Crequ.nroreq).
  
    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA.

    RUN lib\_imprime2.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            

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
     RUN VALIDA.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Genera-Requisicion.
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  
  
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
        WHEN "" THEN.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "CodCia" "LG-CRequ" "CodCia"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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

  IF p-state = 'update-begin':U AND NOT AVAILABLE LG-CRequ THEN RETURN ERROR.
  IF p-state = 'update-begin':U AND LG-CRequ.FlgSit <> "S" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     RUN Actualiza-DREQ (2).
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
     RUN Procesa-Handle IN lh_Handle ('Browse').
  END.
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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


