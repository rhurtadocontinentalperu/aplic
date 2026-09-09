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
DEFINE SHARED VAR cb-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES cb-cfgg
&Scoped-define FIRST-EXTERNAL-TABLE cb-cfgg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cfgg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-cfgg.Codope cb-cfgg.codcta[5] ~
cb-cfgg.codcta[6] cb-cfgg.codcta[10] cb-cfgg.codcta[9] cb-cfgg.codaux[9] ~
cb-cfgg.codaux[8] cb-cfgg.codcta[7] cb-cfgg.codcta[8] cb-cfgg.codaux[1] ~
cb-cfgg.codaux[3] 
&Scoped-define ENABLED-TABLES cb-cfgg
&Scoped-define FIRST-ENABLED-TABLE cb-cfgg
&Scoped-Define ENABLED-OBJECTS RECT-45 RECT-44 RECT-1 
&Scoped-Define DISPLAYED-FIELDS cb-cfgg.Codcfg cb-cfgg.Descripcion ~
cb-cfgg.Codope cb-cfgg.codcta[2] cb-cfgg.codcta[5] cb-cfgg.codcta[3] ~
cb-cfgg.codcta[6] cb-cfgg.codcta[10] cb-cfgg.codcta[9] cb-cfgg.codaux[9] ~
cb-cfgg.codaux[8] cb-cfgg.codcta[7] cb-cfgg.codcta[8] cb-cfgg.codaux[1] ~
cb-cfgg.codaux[3] 
&Scoped-define DISPLAYED-TABLES cb-cfgg
&Scoped-define FIRST-DISPLAYED-TABLE cb-cfgg
&Scoped-Define DISPLAYED-OBJECTS F-DesOpe 

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
DEFINE VARIABLE F-DesOpe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 2.23.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.57 BY 7.77.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 3.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-cfgg.Codcfg AT ROW 1.31 COL 12.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .81
     cb-cfgg.Descripcion AT ROW 1.31 COL 17.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35.14 BY .81
     cb-cfgg.Codope AT ROW 2.19 COL 12.14 COLON-ALIGNED
          LABEL "Cod.Operacion" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .81
     F-DesOpe AT ROW 2.19 COL 17.72 COLON-ALIGNED NO-LABEL
     cb-cfgg.codcta[2] AT ROW 3.42 COL 13 COLON-ALIGNED
          LABEL "I.S.C."
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[5] AT ROW 3.42 COL 42 COLON-ALIGNED
          LABEL "Mercaderia Gravada"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[3] AT ROW 4.23 COL 13 COLON-ALIGNED
          LABEL "I.G.V"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[6] AT ROW 4.23 COL 42 COLON-ALIGNED
          LABEL "Mercaderia Exonerada"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[10] AT ROW 5.04 COL 13 COLON-ALIGNED
          LABEL "Descuentos"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[9] AT ROW 5.04 COL 42 COLON-ALIGNED
          LABEL "Servicios"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codaux[9] AT ROW 5.85 COL 13 COLON-ALIGNED WIDGET-ID 2
          LABEL "IGV Transf.Grat." FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codaux[8] AT ROW 5.85 COL 42 COLON-ALIGNED WIDGET-ID 4
          LABEL "ICBPER" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[7] AT ROW 7.27 COL 38.72 COLON-ALIGNED
          LABEL "Donaciones"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codcta[8] AT ROW 8.08 COL 38.72 COLON-ALIGNED
          LABEL "Obsequios - Regalos  / Clientes Proveedores"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codaux[1] AT ROW 8.88 COL 38.72 COLON-ALIGNED
          LABEL "Obsequios - Regalos / Personal"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     cb-cfgg.codaux[3] AT ROW 9.69 COL 38.72 COLON-ALIGNED
          LABEL "Cuenta de I.G.V. (extorno)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     " Titulo Gratuito" VIEW-AS TEXT
          SIZE 14.72 BY .73 AT ROW 6.77 COL 13
          BGCOLOR 1 FGCOLOR 15 FONT 1
     RECT-45 AT ROW 7.08 COL 7.57
     RECT-44 AT ROW 3.31 COL 1.29
     RECT-1 AT ROW 1.08 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-cfgg
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
         HEIGHT             = 10.15
         WIDTH              = 62.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cb-cfgg.codaux[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codaux[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codaux[8] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfgg.codaux[9] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfgg.Codcfg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[2] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[3] IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.codcta[9] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cfgg.Codope IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN cb-cfgg.Descripcion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN F-DesOpe IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-cfgg.codaux[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgg.codaux[9] V-table-Win
ON LEAVE OF cb-cfgg.codaux[9] IN FRAME F-Main /* IGV Transf.Grat. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
          cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta no existe' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO cb-cfgg.codaux[9].
        RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgg.codcta[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgg.codcta[2] V-table-Win
ON LEAVE OF cb-cfgg.codcta[2] IN FRAME F-Main /* I.S.C. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
          cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta no existe' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO cb-cfgg.codcta[2].
        RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgg.codcta[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgg.codcta[3] V-table-Win
ON LEAVE OF cb-cfgg.codcta[3] IN FRAME F-Main /* I.G.V */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia AND
          cb-ctas.codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-ctas THEN DO:
        MESSAGE 'Cuenta no existe' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO cb-cfgg.codcta[3].
        RETURN NO-APPLY.
     END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cfgg.Codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cfgg.Codope V-table-Win
ON LEAVE OF cb-cfgg.Codope IN FRAME F-Main /* Cod.Operacion */
DO:
  FIND cb-oper WHERE cb-oper.codcia = cb-codcia AND
       cb-oper.codope = SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper THEN DO:
     MESSAGE 'Operaci¢n no existe.........' VIEW-AS ALERT-BOX.
     APPLY 'ENTRY':U TO cb-cfgg.codope.
     RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY
        cb-oper.nomope @ F-DesOpe.
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
  {src/adm/template/row-list.i "cb-cfgg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cfgg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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
  {src/adm/template/snd-list.i "cb-cfgg"}

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

