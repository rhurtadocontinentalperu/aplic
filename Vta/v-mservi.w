&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MSERV FOR INTEGRAL.almmserv.


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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-GrabaLog AS LOG INIT FALSE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES almmserv
&Scoped-define FIRST-EXTERNAL-TABLE almmserv


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR almmserv.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almmserv.DesMat almmserv.UndBas ~
almmserv.Detalle almmserv.AftIgv almmserv.MonVta almmserv.Estado ~
almmserv.CtoLis almmserv.CtoTot almmserv.MrgUti almmserv.PreOfi ~
almmserv.PorMax 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}DesMat ~{&FP2}DesMat ~{&FP3}~
 ~{&FP1}UndBas ~{&FP2}UndBas ~{&FP3}~
 ~{&FP1}CtoLis ~{&FP2}CtoLis ~{&FP3}~
 ~{&FP1}CtoTot ~{&FP2}CtoTot ~{&FP3}~
 ~{&FP1}MrgUti ~{&FP2}MrgUti ~{&FP3}~
 ~{&FP1}PreOfi ~{&FP2}PreOfi ~{&FP3}~
 ~{&FP1}PorMax ~{&FP2}PorMax ~{&FP3}
&Scoped-define ENABLED-TABLES almmserv
&Scoped-define FIRST-ENABLED-TABLE almmserv
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-1 
&Scoped-Define DISPLAYED-FIELDS almmserv.codmat almmserv.DesMat ~
almmserv.UndBas almmserv.Detalle almmserv.AftIgv almmserv.MonVta ~
almmserv.Estado almmserv.CtoLis almmserv.CtoTot almmserv.MrgUti ~
almmserv.PreOfi almmserv.PorMax almmserv.FchIng almmserv.FchAct ~
almmserv.usuario 

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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 7.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 5.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almmserv.codmat AT ROW 1.19 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     almmserv.DesMat AT ROW 2.15 COL 14 COLON-ALIGNED FORMAT "X(45)"
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     almmserv.UndBas AT ROW 3.12 COL 14 COLON-ALIGNED
          LABEL "Unidad"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     almmserv.Detalle AT ROW 4.08 COL 16 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     almmserv.AftIgv AT ROW 8.69 COL 16
          LABEL "Afecto a I.G.V."
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .77
     almmserv.MonVta AT ROW 9.46 COL 16 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .77
     almmserv.Estado AT ROW 1.19 COL 31 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Inactivo", "I":U
          SIZE 18 BY .77
     almmserv.CtoLis AT ROW 8.69 COL 58 COLON-ALIGNED
          LABEL "Precio Costo Lista sin IGV"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     almmserv.CtoTot AT ROW 9.65 COL 58 COLON-ALIGNED
          LABEL "Precio Costo Lista con IGV"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     almmserv.MrgUti AT ROW 10.62 COL 58 COLON-ALIGNED
          LABEL "Margen de Utilidad"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     almmserv.PreOfi AT ROW 11.58 COL 58 COLON-ALIGNED
          LABEL "Precio de Venta"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     almmserv.PorMax AT ROW 12.54 COL 58 COLON-ALIGNED
          LABEL "Descuento Maximo"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     almmserv.FchIng AT ROW 3.12 COL 60 COLON-ALIGNED
          LABEL "Fecha de Creacion" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     almmserv.FchAct AT ROW 4.08 COL 60 COLON-ALIGNED
          LABEL "Fecha Actualizacion" FORMAT "99/99/99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     almmserv.usuario AT ROW 5.04 COL 60 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     RECT-2 AT ROW 8.5 COL 1
     "Moneda de Venta:" VIEW-AS TEXT
          SIZE 13 BY .69 AT ROW 9.46 COL 3
     RECT-1 AT ROW 1 COL 1
     "Detalle:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.08 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.almmserv
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MSERV B "?" ? INTEGRAL almmserv
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
         HEIGHT             = 13.31
         WIDTH              = 73.43.
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

/* SETTINGS FOR TOGGLE-BOX almmserv.AftIgv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.codmat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almmserv.CtoLis IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.CtoTot IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.DesMat IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN almmserv.FchAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN almmserv.FchIng IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN almmserv.MrgUti IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.PorMax IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.PreOfi IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.UndBas IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almmserv.usuario IN FRAME F-Main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME almmserv.AftIgv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmserv.AftIgv V-table-Win
ON VALUE-CHANGED OF almmserv.AftIgv IN FRAME F-Main /* Afecto a I.G.V. */
DO:
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmserv.CtoLis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmserv.CtoLis V-table-Win
ON LEAVE OF almmserv.CtoLis IN FRAME F-Main /* Precio Costo Lista sin IGV */
DO:
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmserv.MrgUti
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmserv.MrgUti V-table-Win
ON LEAVE OF almmserv.MrgUti IN FRAME F-Main /* Margen de Utilidad */
DO:
  RUN Calculo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almmserv.UndBas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almmserv.UndBas V-table-Win
ON LEAVE OF almmserv.UndBas IN FRAME F-Main /* Unidad */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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
  {src/adm/template/row-list.i "almmserv"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "almmserv"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo V-table-Win 
PROCEDURE Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND FIRST FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK NO-ERROR.

  DO WITH FRAME {&FRAME-NAME}:
    /* PRECIO DE COSTO */
   
    IF INPUT almmserv.AftIgv = YES
    THEN almmserv.CtoTot:SCREEN-VALUE = STRING( DECIMAL(almmserv.CtoLis:SCREEN-VALUE) * ( 1 + FacCfgGn.PorIgv / 100 ) ).
    ELSE almmserv.CtoTot:SCREEN-VALUE = almmserv.CtoLis:SCREEN-VALUE.

    /* PRECIO DE VENTA */
    almmserv.PreOfi:SCREEN-VALUE = STRING( DECIMAL(almmserv.CtoTot:SCREEN-VALUE) *
                                        ( 1 + DECIMAL(almmserv.MrgUti:SCREEN-VALUE) / 100) ).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Log V-table-Win 
PROCEDURE Graba-Log :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF s-GrabaLog THEN DO:
    CREATE Almlserv.
    BUFFER-COPY Almmserv TO Almlserv
        ASSIGN
            almlserv.FchAct = TODAY
            almlserv.HorAct = STRING(TIME, 'HH:MM')
            almlserv.usuario = s-user-id.
    RELEASE Almlserv.            
  END.
  
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
  DEF VAR x-CodMat AS INT INIT 1 NO-UNDO.
  
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DO:      /* Buscamos correlativo */
    FIND LAST B-MSERV WHERE B-MSERV.codcia = s-codcia AND
        B-MSERV.codmat <> '' EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE B-MSERV THEN x-CodMat = INTEGER(B-MSERV.CodMat) + 1.
  END.
  ELSE DO:
    x-CodMat = INTEGER(Almmserv.codmat).
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES'
  THEN DO:
    ASSIGN
        Almmserv.codcia = s-codcia
        Almmserv.codmat = STRING(x-codmat, '999999')
        Almmserv.fching = TODAY.
    RELEASE B-MSERV.
  END.        
  ELSE
    ASSIGN
        Almmserv.fchact = TODAY.
  ASSIGN
    Almmserv.usuario = s-user-id.

  RUN Graba-Log.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
  

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
  MESSAGE 'NO se puede anular registros' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.

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
    almmserv.CtoTot:SENSITIVE = NO.
    almmserv.preofi:SENSITIVE = NO.
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
  {src/adm/template/snd-list.i "almmserv"}

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
    FIND Unidades WHERE Unidades.Codunid = Almmserv.UndBas:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Unidades THEN DO:
        MESSAGE "Unidad no registrada ..." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO Almmserv.UndBas.
        RETURN "ADM-ERROR".   
    END.
    /* DEFINIMOS SI ACTUALIZAMOS EL LOG DE DATOS */
    s-GrabaLog = NO.
    IF Almmserv.desmat <> INPUT Almmserv.desmat THEN s-GrabaLog = YES.
    IF Almmserv.undbas <> INPUT Almmserv.undbas THEN s-GrabaLog = YES.
    IF Almmserv.aftigv <> INPUT Almmserv.aftigv THEN s-GrabaLog = YES.
    IF Almmserv.ctolis <> INPUT Almmserv.ctolis THEN s-GrabaLog = YES.
    IF Almmserv.mrguti <> INPUT Almmserv.mrguti THEN s-GrabaLog = YES.
    IF Almmserv.preofi <> INPUT Almmserv.preofi THEN s-GrabaLog = YES.
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


