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
&Scoped-define EXTERNAL-TABLES CcbCCaja
&Scoped-define FIRST-EXTERNAL-TABLE CcbCCaja


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCCaja.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] ~
CcbCCaja.ImpNac[2] CcbCCaja.ImpUsa[2] CcbCCaja.CodBco[2] ~
CcbCCaja.Voucher[2] CcbCCaja.FchVto[2] CcbCCaja.ImpNac[3] ~
CcbCCaja.ImpUsa[3] CcbCCaja.CodBco[3] CcbCCaja.Voucher[3] ~
CcbCCaja.FchVto[3] CcbCCaja.ImpNac[4] CcbCCaja.ImpUsa[4] CcbCCaja.CodBco[4] ~
CcbCCaja.Voucher[4] CcbCCaja.ImpNac[5] CcbCCaja.ImpUsa[5] ~
CcbCCaja.CodBco[5] CcbCCaja.Voucher[5] CcbCCaja.ImpNac[6] ~
CcbCCaja.ImpUsa[6] CcbCCaja.Voucher[6] CcbCCaja.ImpNac[7] ~
CcbCCaja.ImpUsa[7] CcbCCaja.Voucher[7] CcbCCaja.ImpNac[8] ~
CcbCCaja.ImpUsa[8] CcbCCaja.CodBco[8] CcbCCaja.Voucher[8] ~
CcbCCaja.ImpNac[9] CcbCCaja.ImpUsa[9] CcbCCaja.ImpNac[10] ~
CcbCCaja.ImpUsa[10] 
&Scoped-define ENABLED-TABLES CcbCCaja
&Scoped-define FIRST-ENABLED-TABLE CcbCCaja
&Scoped-Define ENABLED-OBJECTS RECT-51 
&Scoped-Define DISPLAYED-FIELDS CcbCCaja.ImpNac[1] CcbCCaja.ImpUsa[1] ~
CcbCCaja.ImpNac[2] CcbCCaja.ImpUsa[2] CcbCCaja.CodBco[2] ~
CcbCCaja.Voucher[2] CcbCCaja.FchVto[2] CcbCCaja.ImpNac[3] ~
CcbCCaja.ImpUsa[3] CcbCCaja.CodBco[3] CcbCCaja.Voucher[3] ~
CcbCCaja.FchVto[3] CcbCCaja.ImpNac[4] CcbCCaja.ImpUsa[4] CcbCCaja.CodBco[4] ~
CcbCCaja.Voucher[4] CcbCCaja.ImpNac[5] CcbCCaja.ImpUsa[5] ~
CcbCCaja.CodBco[5] CcbCCaja.Voucher[5] CcbCCaja.ImpNac[6] ~
CcbCCaja.ImpUsa[6] CcbCCaja.Voucher[6] CcbCCaja.ImpNac[7] ~
CcbCCaja.ImpUsa[7] CcbCCaja.CodBco[7] CcbCCaja.Voucher[7] ~
CcbCCaja.ImpNac[8] CcbCCaja.ImpUsa[8] CcbCCaja.CodBco[8] ~
CcbCCaja.Voucher[8] CcbCCaja.ImpNac[9] CcbCCaja.ImpUsa[9] ~
CcbCCaja.ImpNac[10] CcbCCaja.ImpUsa[10] 
&Scoped-define DISPLAYED-TABLES CcbCCaja
&Scoped-define FIRST-DISPLAYED-TABLE CcbCCaja


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
DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCCaja.ImpNac[1] AT ROW 2 COL 13 COLON-ALIGNED
          LABEL "Efectivo"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[1] AT ROW 2 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpNac[2] AT ROW 2.81 COL 13 COLON-ALIGNED
          LABEL "Cheque del Día"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[2] AT ROW 2.81 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[2] AT ROW 2.81 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCCaja.Voucher[2] AT ROW 2.81 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.FchVto[2] AT ROW 2.81 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCCaja.ImpNac[3] AT ROW 3.62 COL 13 COLON-ALIGNED
          LABEL "Cheque Diferido"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[3] AT ROW 3.62 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[3] AT ROW 3.62 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCCaja.Voucher[3] AT ROW 3.62 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.FchVto[3] AT ROW 3.62 COL 55 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCCaja.ImpNac[4] AT ROW 4.42 COL 13 COLON-ALIGNED
          LABEL "Tarjeta de Crédito"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[4] AT ROW 4.42 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[4] AT ROW 4.42 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCCaja.Voucher[4] AT ROW 4.42 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.ImpNac[5] AT ROW 5.23 COL 13 COLON-ALIGNED
          LABEL "Boleta Depósito"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[5] AT ROW 5.23 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[5] AT ROW 5.23 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCCaja.Voucher[5] AT ROW 5.23 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.ImpNac[6] AT ROW 6.04 COL 13 COLON-ALIGNED
          LABEL "Nota de Crédito"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[6] AT ROW 6.04 COL 23.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.Voucher[6] AT ROW 6.04 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.ImpNac[7] AT ROW 6.85 COL 13 COLON-ALIGNED
          LABEL "Anticipos"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[7] AT ROW 6.85 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[7] AT ROW 6.85 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CcbCCaja.Voucher[7] AT ROW 6.85 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.ImpNac[8] AT ROW 7.65 COL 13 COLON-ALIGNED
          LABEL "Comisiones"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[8] AT ROW 7.65 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.CodBco[8] AT ROW 7.65 COL 33 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCCaja.Voucher[8] AT ROW 7.65 COL 39 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     CcbCCaja.ImpNac[9] AT ROW 8.46 COL 13 COLON-ALIGNED
          LABEL "Retenciones"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[9] AT ROW 8.46 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpNac[10] AT ROW 9.27 COL 13 COLON-ALIGNED
          LABEL "Vales Consumo"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     CcbCCaja.ImpUsa[10] AT ROW 9.27 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
     "      S/.           US$.      Banco  Voucher         Vencimiento" VIEW-AS TEXT
          SIZE 50.86 BY .73 AT ROW 1.15 COL 15.14
          FONT 7
     RECT-51 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCCaja
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
         HEIGHT             = 9.42
         WIDTH              = 66.86.
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

/* SETTINGS FOR FILL-IN CcbCCaja.CodBco[7] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[10] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[5] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[6] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[7] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[8] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCCaja.ImpNac[9] IN FRAME F-Main
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
  {src/adm/template/row-list.i "CcbCCaja"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCCaja"}

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
  {src/adm/template/snd-list.i "CcbCCaja"}

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

