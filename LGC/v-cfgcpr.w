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
DEFINE BUFFER B-ALMT FOR Almtmovm.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LG-CFGCPR
&Scoped-define FIRST-EXTERNAL-TABLE LG-CFGCPR


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-CFGCPR.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-CFGCPR.TpoLiq LG-CFGCPR.Correlativo ~
LG-CFGCPR.TipMov[1] LG-CFGCPR.TipMov[2] LG-CFGCPR.almacenes ~
LG-CFGCPR.CodMov[1] LG-CFGCPR.CodMov[2] LG-CFGCPR.Descrip 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}TpoLiq ~{&FP2}TpoLiq ~{&FP3}~
 ~{&FP1}Correlativo ~{&FP2}Correlativo ~{&FP3}~
 ~{&FP1}TipMov[1] ~{&FP2}TipMov[1] ~{&FP3}~
 ~{&FP1}TipMov[2] ~{&FP2}TipMov[2] ~{&FP3}~
 ~{&FP1}almacenes ~{&FP2}almacenes ~{&FP3}~
 ~{&FP1}CodMov[1] ~{&FP2}CodMov[1] ~{&FP3}~
 ~{&FP1}CodMov[2] ~{&FP2}CodMov[2] ~{&FP3}~
 ~{&FP1}Descrip ~{&FP2}Descrip ~{&FP3}
&Scoped-define ENABLED-TABLES LG-CFGCPR
&Scoped-define FIRST-ENABLED-TABLE LG-CFGCPR
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS LG-CFGCPR.TpoLiq LG-CFGCPR.Correlativo ~
LG-CFGCPR.TipMov[1] LG-CFGCPR.TipMov[2] LG-CFGCPR.almacenes ~
LG-CFGCPR.CodMov[1] LG-CFGCPR.CodMov[2] LG-CFGCPR.Descrip 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-2 

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
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63.29 BY 5.73.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-CFGCPR.TpoLiq AT ROW 1.62 COL 8.72 COLON-ALIGNED
          LABEL "Tipo" FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .69
     LG-CFGCPR.Correlativo AT ROW 2.62 COL 8.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
     LG-CFGCPR.TipMov[1] AT ROW 3.5 COL 8.72 COLON-ALIGNED
          LABEL "Ingreso" FORMAT "X"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
     LG-CFGCPR.TipMov[2] AT ROW 4.42 COL 8.86 COLON-ALIGNED
          LABEL "Devolucion" FORMAT "X"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
     LG-CFGCPR.almacenes AT ROW 5.38 COL 2.57
          VIEW-AS FILL-IN 
          SIZE 51.14 BY .69
     LG-CFGCPR.CodMov[1] AT ROW 3.54 COL 12.14 COLON-ALIGNED NO-LABEL FORMAT "99"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     LG-CFGCPR.CodMov[2] AT ROW 4.46 COL 12.29 COLON-ALIGNED NO-LABEL FORMAT "99"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     LG-CFGCPR.Descrip AT ROW 1.62 COL 14.29 COLON-ALIGNED NO-LABEL FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 45.57 BY .69
     FILL-IN-1 AT ROW 3.46 COL 18.14 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 4.42 COL 17.86 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.08 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LG-CFGCPR
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
         HEIGHT             = 5.85
         WIDTH              = 63.86.
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

/* SETTINGS FOR FILL-IN LG-CFGCPR.almacenes IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN LG-CFGCPR.CodMov[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCPR.CodMov[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCPR.Descrip IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-CFGCPR.TipMov[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCPR.TipMov[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-CFGCPR.TpoLiq IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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
  {src/adm/template/row-list.i "LG-CFGCPR"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-CFGCPR"}

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
  ASSIGN
  LG-CfgCpr.Codcia = S-CODCIA.
  
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
  IF AVAILABLE LG-Cfgcpr THEN DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST Almtmovm WHERE Almtmovm.CodCia = S-CODCIA 
                         AND  Almtmovm.Tipmov = LG-Cfgcpr.TipMov[1] 
                         AND  Almtmovm.Codmov = LG-Cfgcpr.CodMov[1] 
                        NO-LOCK NO-ERROR.
    FIND FIRST B-Almt WHERE B-Almt.CodCia = S-CODCIA 
                         AND B-Almt.Tipmov = LG-Cfgcpr.TipMov[2] 
                         AND B-Almt.Codmov = LG-Cfgcpr.CodMov[2] 
                        NO-LOCK NO-ERROR.

    DISPLAY Almtmovm.Desmov @ FILL-IN-1 
            B-Almt.DesMov   @ FILL-IN-2.
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
  {src/adm/template/snd-list.i "LG-CFGCPR"}

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
   IF LG-Cfgcpr.Descrip:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Descrip.
         RETURN "ADM-ERROR".   
   
   END.
   IF LG-Cfgcpr.TipMov[1]:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO TipMov[1].
         RETURN "ADM-ERROR".   
   
   END.
   IF LG-Cfgcpr.TipMov[2]:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO TipMov[2].
         RETURN "ADM-ERROR".   
   
   END.
   IF LOOKUP(LG-Cfgcpr.TipMov[1]:SCREEN-VALUE,"I,S") = 0 THEN DO:
         MESSAGE "Tipo de Movimiento solo puede ser I o S"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO TipMov[1].
         RETURN "ADM-ERROR".      
   END.
   IF LOOKUP(LG-Cfgcpr.TipMov[2]:SCREEN-VALUE,"I,S") = 0 THEN DO:
         MESSAGE "Tipo de Movimiento solo puede ser I o S"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO TipMov[2].
         RETURN "ADM-ERROR".      
   END.

   FIND  Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.Tipmov = LG-Cfgcpr.TipMov[1]:SCREEN-VALUE AND
         Almtmovm.CodMov = INTEGER(LG-Cfgcpr.CodMov[2]:SCREEN-VALUE)
         NO-LOCK NO-ERROR.

   IF NOT AVAILABLE Almtmovm THEN DO:
         MESSAGE "Operacion de Almacen No existe "
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO LG-Cfgcpr.TipMov[1].
         RETURN "ADM-ERROR".      
   END.

   FIND  Almtmovm WHERE Almtmovm.CodCia = S-CODCIA AND
         Almtmovm.Tipmov = LG-Cfgcpr.TipMov[2]:SCREEN-VALUE AND
         Almtmovm.CodMov = INTEGER(LG-Cfgcpr.CodMov[2]:SCREEN-VALUE)
         NO-LOCK NO-ERROR.

   IF NOT AVAILABLE Almtmovm THEN DO:
         MESSAGE "Operacion de Almacen No existe "
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO LG-Cfgcpr.TipMov[2].
         RETURN "ADM-ERROR".      
   END.
/*
    /* CHEQUEAMOS LA CONFIGURACION DE CORRELATIVOS */
    FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA AND
         Almtdocm.CodAlm = S-CODALM AND
         Almtdocm.TipMov = "I" AND
         Almtdocm.CodMov <> S-MOVCMP NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtdocm THEN DO:
       MESSAGE "No existen movimientos asignados al almacen" VIEW-AS ALERT-BOX ERROR.
       RETURN ERROR.
    END.
*/
      
   DEFINE VAR I AS INTEGER.
   DO I = 1 TO NUM-ENTRIES(LG-Cfgcpr.Almacenes:SCREEN-VALUE):
      FIND Almacen WHERE Almacen.CODCIA = S-CODCIA AND
                         Almacen.CodAlm = ENTRY(I,LG-Cfgcpr.Almacenes:SCREEN-VALUE)
                         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN DO:
         MESSAGE "Almacen No existe"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO Almacenes.
         RETURN "ADM-ERROR".   

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


