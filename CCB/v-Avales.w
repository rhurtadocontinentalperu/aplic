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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES gn-clie
&Scoped-define FIRST-EXTERNAL-TABLE gn-clie


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-clie.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-clie.Aval1[2] gn-clie.Aval1[4] ~
gn-clie.Aval2[1] gn-clie.Aval2[2] gn-clie.Aval2[3] gn-clie.Aval2[4] 
&Scoped-define ENABLED-TABLES gn-clie
&Scoped-define FIRST-ENABLED-TABLE gn-clie
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-29 
&Scoped-Define DISPLAYED-FIELDS gn-clie.Aval1[2] gn-clie.Aval1[4] ~
gn-clie.Aval2[1] gn-clie.Aval2[2] gn-clie.Aval2[3] gn-clie.Aval2[4] 
&Scoped-define DISPLAYED-TABLES gn-clie
&Scoped-define FIRST-DISPLAYED-TABLE gn-clie
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Aval1-1 FILL-IN_Aval1-2 ~
FILL-IN_Aval3-1 FILL-IN_Aval3-2 

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
DEFINE VARIABLE FILL-IN_Aval1-1 AS CHARACTER FORMAT "X(60)" 
     LABEL "Nombre 1" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .69.

DEFINE VARIABLE FILL-IN_Aval1-2 AS CHARACTER FORMAT "X(60)" 
     LABEL "Nombre 2" 
     VIEW-AS FILL-IN 
     SIZE 49 BY .69.

DEFINE VARIABLE FILL-IN_Aval3-1 AS CHARACTER FORMAT "x(11)" 
     LABEL "RUC/DNI 1" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .69.

DEFINE VARIABLE FILL-IN_Aval3-2 AS CHARACTER FORMAT "x(11)" 
     LABEL "RUC/DNI 2" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .69.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 5.85.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 4.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_Aval1-1 AT ROW 2 COL 10 COLON-ALIGNED
     FILL-IN_Aval1-2 AT ROW 2.88 COL 10 COLON-ALIGNED WIDGET-ID 2
     gn-clie.Aval1[2] AT ROW 3.69 COL 10 COLON-ALIGNED
          LABEL "Dirección" FORMAT "X(90)"
          VIEW-AS FILL-IN 
          SIZE 69 BY .69
     FILL-IN_Aval3-1 AT ROW 4.5 COL 10 COLON-ALIGNED
     FILL-IN_Aval3-2 AT ROW 5.31 COL 10 COLON-ALIGNED WIDGET-ID 4
     gn-clie.Aval1[4] AT ROW 6.12 COL 10 COLON-ALIGNED
          LABEL "Teléfonos"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .69
     gn-clie.Aval2[1] AT ROW 7.92 COL 9.57 COLON-ALIGNED
          LABEL "Nombre" FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 49.43 BY .69
     gn-clie.Aval2[2] AT ROW 8.73 COL 9.57 COLON-ALIGNED
          LABEL "Dirección" FORMAT "X(90)"
          VIEW-AS FILL-IN 
          SIZE 69.43 BY .69
     gn-clie.Aval2[3] AT ROW 9.54 COL 9.57 COLON-ALIGNED
          LABEL "RUC/DNI" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
     gn-clie.Aval2[4] AT ROW 10.35 COL 9.57 COLON-ALIGNED
          LABEL "Teléfonos"
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .69
     "Datos Aval 1" VIEW-AS TEXT
          SIZE 11.43 BY .5 AT ROW 1.12 COL 2.72
          FONT 6
     "Datos Aval 2" VIEW-AS TEXT
          SIZE 11.43 BY .5 AT ROW 7.19 COL 2.14
          FONT 6
     RECT-30 AT ROW 7.38 COL 1
     RECT-29 AT ROW 1.35 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.gn-clie
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
         HEIGHT             = 15.31
         WIDTH              = 95.86.
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

/* SETTINGS FOR FILL-IN gn-clie.Aval1[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Aval1[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-clie.Aval2[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Aval2[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Aval2[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-clie.Aval2[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Aval1-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Aval1-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Aval3-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Aval3-2 IN FRAME F-Main
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

&Scoped-define SELF-NAME gn-clie.Aval2[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Aval2[1] V-table-Win
ON LEAVE OF gn-clie.Aval2[1] IN FRAME F-Main /* Nombre */
DO:
  IF gn-clie.aval2[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
      IF FILL-IN_Aval1-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
          MESSAGE 'Debe ingresar los Datos de Aval 1 previamente'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          DISPLAY '' @ gn-clie.aval2[1] WITH FRAME {&FRAME-NAME}.
          APPLY 'entry' TO FILL-IN_Aval1-1.
          RETURN 'ADM-ERROR'.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Aval2[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Aval2[2] V-table-Win
ON LEAVE OF gn-clie.Aval2[2] IN FRAME F-Main /* Dirección */
DO:
  IF gn-clie.aval2[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
      IF FILL-IN_Aval1-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
          MESSAGE 'Debe ingresar los Datos de Aval 1 previamente'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          DISPLAY '' @ gn-clie.aval2[2] WITH FRAME {&FRAME-NAME}.
          APPLY 'entry' TO FILL-IN_Aval1-1.
          RETURN 'ADM-ERROR'.
      END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Aval2[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Aval2[3] V-table-Win
ON LEAVE OF gn-clie.Aval2[3] IN FRAME F-Main /* RUC/DNI */
DO:
  IF gn-clie.aval2[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
      IF FILL-IN_Aval1-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
          MESSAGE 'Debe ingresar los Datos de Aval 1 previamente'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          DISPLAY '' @ gn-clie.aval2[3] WITH FRAME {&FRAME-NAME}.
          APPLY 'entry' TO FILL-IN_Aval1-1.
          RETURN 'ADM-ERROR'.
      END.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-clie.Aval2[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-clie.Aval2[4] V-table-Win
ON LEAVE OF gn-clie.Aval2[4] IN FRAME F-Main /* Teléfonos */
DO:
  IF gn-clie.aval2[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
      IF FILL-IN_Aval1-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
          MESSAGE 'Debe ingresar los Datos de Aval 1 previamente'
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          DISPLAY '' @ gn-clie.aval2[4] WITH FRAME {&FRAME-NAME}.
          APPLY 'entry' TO FILL-IN_Aval1-1.
          RETURN 'ADM-ERROR'.
      END.
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
  {src/adm/template/row-list.i "gn-clie"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-clie"}

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
  ASSIGN FRAME {&FRAME-NAME}
     FILL-IN_Aval1-1 FILL-IN_Aval1-2 FILL-IN_Aval3-1 FILL-IN_Aval3-2.
  ASSIGN
      gn-clie.aval1[1] = FILL-IN_Aval1-1
      gn-clie.aval1[3] = FILL-IN_Aval3-1.
  IF FILL-IN_Aval1-2 <> '' THEN gn-clie.aval1[1] = TRIM(gn-clie.aval1[1]) + '|' + FILL-IN_Aval1-2.
  IF FILL-IN_Aval3-2 <> '' THEN gn-clie.aval1[3] = TRIM(gn-clie.aval1[3]) + '|' + FILL-IN_Aval3-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
      FILL-IN_Aval1-1:SENSITIVE = NO
      FILL-IN_Aval1-2:SENSITIVE = NO
      FILL-IN_Aval3-1:SENSITIVE = NO
      FILL-IN_Aval3-2:SENSITIVE = NO.
  END.

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
  IF AVAILABLE gn-clie THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN_Aval1-1:SCREEN-VALUE = ''
          FILL-IN_Aval3-1:SCREEN-VALUE = ''
          FILL-IN_Aval1-2:SCREEN-VALUE = ''
          FILL-IN_Aval3-2:SCREEN-VALUE = ''.

      ASSIGN
          FILL-IN_Aval1-1:SCREEN-VALUE = ENTRY(1, gn-clie.aval1[1], '|')
          FILL-IN_Aval3-1:SCREEN-VALUE = ENTRY(1, gn-clie.aval1[3], '|')
          NO-ERROR.
      ASSIGN
          FILL-IN_Aval1-2:SCREEN-VALUE = ENTRY(2, gn-clie.aval1[1], '|')
          FILL-IN_Aval3-2:SCREEN-VALUE = ENTRY(2, gn-clie.aval1[3], '|')
          NO-ERROR.
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
      FILL-IN_Aval1-1:SENSITIVE = YES
      FILL-IN_Aval1-2:SENSITIVE = YES
      FILL-IN_Aval3-1:SENSITIVE = YES
      FILL-IN_Aval3-2:SENSITIVE = YES.
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
  {src/adm/template/snd-list.i "gn-clie"}

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

    /*Valida existencia del primer aval*/
    IF gn-clie.aval2[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' 
        OR gn-clie.aval2[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> ''
        OR gn-clie.aval2[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> ''  
        OR gn-clie.aval2[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> '' THEN DO:
        IF FILL-IN_Aval1-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '' THEN DO:
            MESSAGE 'Debe ingresar los Datos de Aval 1 previamente'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            DISPLAY '' @ gn-clie.aval2[4] WITH FRAME {&FRAME-NAME}.
            APPLY 'entry' TO FILL-IN_Aval1-1.
            RETURN 'ADM-ERROR'.
        END.
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

