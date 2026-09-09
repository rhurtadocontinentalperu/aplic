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

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE VAR L-CREA AS LOGICAL .
DEFINE BUFFER B-LPRMAQ FOR LPRMAQUI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LPRMAQUI
&Scoped-define FIRST-EXTERNAL-TABLE LPRMAQUI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LPRMAQUI.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LPRMAQUI.CodMaq LPRMAQUI.DesPro ~
LPRMAQUI.Contomet LPRMAQUI.CapOpe LPRMAQUI.CapOp1 LPRMAQUI.CapOp2 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodMaq ~{&FP2}CodMaq ~{&FP3}~
 ~{&FP1}DesPro ~{&FP2}DesPro ~{&FP3}~
 ~{&FP1}CapOpe ~{&FP2}CapOpe ~{&FP3}~
 ~{&FP1}CapOp1 ~{&FP2}CapOp1 ~{&FP3}~
 ~{&FP1}CapOp2 ~{&FP2}CapOp2 ~{&FP3}
&Scoped-define ENABLED-TABLES LPRMAQUI
&Scoped-define FIRST-ENABLED-TABLE LPRMAQUI
&Scoped-Define ENABLED-OBJECTS RECT-64 
&Scoped-Define DISPLAYED-FIELDS LPRMAQUI.CodMaq LPRMAQUI.DesPro ~
LPRMAQUI.Contomet LPRMAQUI.CapOpe LPRMAQUI.CapOp1 LPRMAQUI.CapOp2 

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
DEFINE RECTANGLE RECT-64
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 4.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LPRMAQUI.CodMaq AT ROW 1.58 COL 13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     LPRMAQUI.DesPro AT ROW 2.54 COL 13 COLON-ALIGNED
          LABEL "Nombre Máquina"
          VIEW-AS FILL-IN 
          SIZE 30.57 BY .81
     LPRMAQUI.Contomet AT ROW 3.69 COL 15
          LABEL ""
          VIEW-AS TOGGLE-BOX
          SIZE 3 BY .5
     LPRMAQUI.CapOpe AT ROW 1.58 COL 65 COLON-ALIGNED FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     LPRMAQUI.CapOp1 AT ROW 2.54 COL 65 COLON-ALIGNED
          LABEL "Cap. Operativa - 12 horas" FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     LPRMAQUI.CapOp2 AT ROW 3.5 COL 65 COLON-ALIGNED
          LABEL "Cap. Operativa - 8 horas" FORMAT "->,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     "Si" VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 3.69 COL 18
     "Contómetro:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.69 COL 6
     RECT-64 AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LPRMAQUI
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
         HEIGHT             = 4.85
         WIDTH              = 79.14.
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

/* SETTINGS FOR FILL-IN LPRMAQUI.CapOp1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LPRMAQUI.CapOp2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LPRMAQUI.CapOpe IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX LPRMAQUI.Contomet IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LPRMAQUI.DesPro IN FRAME F-Main
   EXP-LABEL                                                            */
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

ON RETURN OF LPRMAQUI.CodMaq, 
   LPRMAQUI.DesPro, 
/*   x-opcion,*/
   LPRMAQUI.CapOpe, 
   LPRMAQUI.CapOp1, 
   LPRMAQUI.CapOp2 
DO:
  APPLY "TAB":U.
  RETURN NO-APPLY.
END.

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
  {src/adm/template/row-list.i "LPRMAQUI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LPRMAQUI"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita-Campos V-table-Win 
PROCEDURE Habilita-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
    LPRMAQUI.CodMaq:SENSITIVE = TRUE.
    LPRMAQUI.DesPro:SENSITIVE = TRUE.
    LPRMAQUI.CapOpe:SENSITIVE = TRUE.
    LPRMAQUI.CapOp1:SENSITIVE = TRUE.
    LPRMAQUI.CapOp2:SENSITIVE = TRUE.
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
  
  RUN Habilita-Campos.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  L-CREA = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
 DEFINE VARIABLE X-Tipo AS LOGICAL.
 
 DO WITH FRAME {&FRAME-NAME}:
  IF LPRMAQUI.Contomet = true THEN 
     x-tipo = yes.
  ELSE X-Tipo = NO.
 
  ASSIGN
     LPRMAQUI.CodCia   = S-CODCIA
     LPRMAQUI.CodMaq   = CAPS(LPRMAQUI.CodMaq:SCREEN-VALUE)
     LPRMAQUI.Contomet = X-Tipo.
 END.
 
 RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  
  DO WITH FRAME {&FRAME-NAME}:
    LPRMAQUI.CodMaq:SENSITIVE = FALSE.
    LPRMAQUI.DesPro:SENSITIVE = FALSE.
    LPRMAQUI.CapOpe:SENSITIVE = FALSE.
    LPRMAQUI.CapOp1:SENSITIVE = FALSE.
    LPRMAQUI.CapOp2:SENSITIVE = FALSE.
  END.
  
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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
        END CASE.
    END.


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
  {src/adm/template/snd-list.i "LPRMAQUI"}

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
    RUN Valida-update.
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
    L-CREA = NO.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida V-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
 
 IF LPRMAQUI.CodMaq:SCREEN-VALUE = "" THEN DO:
    MESSAGE "Ingrese código de maquinaria" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO LPRMAQUI.CodMaq.
    RETURN "ADM-ERROR".
 END. 
 
 IF LPRMAQUI.DesPro:SCREEN-VALUE = "" THEN DO:
    MESSAGE "Registre descripción de maquinaria" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO LPRMAQUI.DesPro.
    RETURN "ADM-ERROR".
 END. 
 
 RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
 IF RETURN-VALUE = 'YES' AND
    CAN-FIND(FIRST B-LPRMAQ WHERE
    B-LPRMAQ.CodMaq = LPRMAQUI.CodMaq:SCREEN-VALUE NO-LOCK) THEN DO:
    MESSAGE " Código ya registrado" VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO LPRMAQUI.CodMaq.
    RETURN 'ADM-ERROR'.
 END.
 
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-update V-table-Win 
PROCEDURE Valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


