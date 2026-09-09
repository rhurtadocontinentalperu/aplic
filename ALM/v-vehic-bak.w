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
DEF SHARED VAR pv-codcia AS INT.

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
&Scoped-define EXTERNAL-TABLES INTEGRAL.gn-vehic
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.gn-vehic


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.gn-vehic.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.gn-vehic.placa ~
INTEGRAL.gn-vehic.Marca INTEGRAL.gn-vehic.Estado INTEGRAL.gn-vehic.CodPro ~
INTEGRAL.gn-vehic.Combustible INTEGRAL.gn-vehic.Rendimiento ~
INTEGRAL.gn-vehic.Velocidad INTEGRAL.gn-vehic.Carga ~
INTEGRAL.gn-vehic.Volumen INTEGRAL.gn-vehic.Tipo INTEGRAL.gn-vehic.Costo 
&Scoped-define ENABLED-TABLES INTEGRAL.gn-vehic
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.gn-vehic
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.gn-vehic.placa ~
INTEGRAL.gn-vehic.Marca INTEGRAL.gn-vehic.Estado INTEGRAL.gn-vehic.CodPro ~
INTEGRAL.gn-vehic.Combustible INTEGRAL.gn-vehic.Rendimiento ~
INTEGRAL.gn-vehic.Velocidad INTEGRAL.gn-vehic.Carga ~
INTEGRAL.gn-vehic.Volumen INTEGRAL.gn-vehic.Tipo INTEGRAL.gn-vehic.Costo 
&Scoped-define DISPLAYED-TABLES INTEGRAL.gn-vehic
&Scoped-define FIRST-DISPLAYED-TABLE INTEGRAL.gn-vehic
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomPro 

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
DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.gn-vehic.placa AT ROW 1.19 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     INTEGRAL.gn-vehic.Marca AT ROW 1.96 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     INTEGRAL.gn-vehic.Estado AT ROW 2.92 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Propio", "01":U,
"Externo", "02":U
          SIZE 21 BY .96
     INTEGRAL.gn-vehic.CodPro AT ROW 3.88 COL 20 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     FILL-IN-NomPro AT ROW 3.88 COL 30 COLON-ALIGNED NO-LABEL
     INTEGRAL.gn-vehic.Combustible AT ROW 4.85 COL 20 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "D-2","G-84","G-90","G-95","G-97","GLP","GNV" 
          DROP-DOWN-LIST
          SIZE 9 BY 1
     INTEGRAL.gn-vehic.Rendimiento AT ROW 5.81 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.gn-vehic.Velocidad AT ROW 6.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.gn-vehic.Carga AT ROW 7.35 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.gn-vehic.Volumen AT ROW 8.12 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     INTEGRAL.gn-vehic.Tipo AT ROW 9.08 COL 22 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Por Dia", "D":U,
"Por Viaje", "V":U,
"No definido", " ":U
          SIZE 39 BY .69
     INTEGRAL.gn-vehic.Costo AT ROW 9.88 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     "(Km/h)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6.77 COL 35
     "(Km/Gal)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 6 COL 35
     "(S/. )" VIEW-AS TEXT
          SIZE 11 BY .54 AT ROW 10.08 COL 35
     "Estado:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 3.12 COL 14
     "(m3)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 8.31 COL 35
     "(Kgs)" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 7.54 COL 35
     "Tipo de contrato:" VIEW-AS TEXT
          SIZE 17 BY .54 AT ROW 9.08 COL 4 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-vehic
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
         HEIGHT             = 9.85
         WIDTH              = 74.43.
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

/* SETTINGS FOR FILL-IN INTEGRAL.gn-vehic.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
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

&Scoped-define SELF-NAME INTEGRAL.gn-vehic.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL INTEGRAL.gn-vehic.CodPro V-table-Win
ON LEAVE OF INTEGRAL.gn-vehic.CodPro IN FRAME F-Main /* Proveedor */
DO:
  FILL-IN-NomPro:SCREEN-VALUE = ''.
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov 
  THEN DISPLAY gn-prov.nompro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "INTEGRAL.gn-vehic"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.gn-vehic"}

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
  ASSIGN
    gn-vehic.placa  = CAPS(gn-vehic.placa)
    gn-vehic.marca  = CAPS(gn-vehic.marca)
    gn-vehic.codcia = s-codcia.

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
  FIND FIRST di-rutac WHERE di-rutac.codcia = s-codcia
      AND di-rutac.codveh = gn-vehic.placa
      AND di-rutac.flgest <> 'A'
      NO-LOCK NO-ERROR.
  IF AVAILABLE di-rutac THEN DO:
      MESSAGE 'NO se puede anular el registro' SKIP
          'Presenta movimientos en hojas de ruta'
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  IF AVAILABLE gn-vehic THEN DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-NomPro:SCREEN-VALUE = ''.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = gn-vehic.codpro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov 
    THEN DISPLAY gn-prov.nompro @ FILL-IN-NomPro.
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
  {src/adm/template/snd-list.i "INTEGRAL.gn-vehic"}

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
    IF gn-vehic.placa:SCREEN-VALUE = ''
    THEN DO:
        MESSAGE 'Debe ingresar el número de placa'
            VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY":U TO gn-vehic.placa.
        RETURN 'ADM-ERROR'.
    END.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = gn-vehic.CodPro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov
    THEN DO:
        MESSAGE "Código del proveedor incorrecto"
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY' TO gn-vehic.codpro.
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

