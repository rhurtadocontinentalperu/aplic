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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES INTEGRAL.AlmCfg
&Scoped-define FIRST-EXTERNAL-TABLE INTEGRAL.AlmCfg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR INTEGRAL.AlmCfg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS INTEGRAL.AlmCfg.UtilPes ~
INTEGRAL.AlmCfg.UtilFecI INTEGRAL.AlmCfg.UtilfecF INTEGRAL.AlmCfg.VentPes ~
INTEGRAL.AlmCfg.VentFecI INTEGRAL.AlmCfg.VentFecF INTEGRAL.AlmCfg.CrecPes ~
INTEGRAL.AlmCfg.CrecFecI[1] INTEGRAL.AlmCfg.CrecFecF[1] ~
INTEGRAL.AlmCfg.CrecFecI[2] INTEGRAL.AlmCfg.CrecFecF[2] ~
INTEGRAL.AlmCfg.CateA INTEGRAL.AlmCfg.CateD INTEGRAL.AlmCfg.Cate ~
INTEGRAL.AlmCfg.CateB INTEGRAL.AlmCfg.CateE INTEGRAL.AlmCfg.CateC ~
INTEGRAL.AlmCfg.CateF INTEGRAL.AlmCfg.CodFam 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}UtilPes ~{&FP2}UtilPes ~{&FP3}~
 ~{&FP1}UtilFecI ~{&FP2}UtilFecI ~{&FP3}~
 ~{&FP1}UtilfecF ~{&FP2}UtilfecF ~{&FP3}~
 ~{&FP1}VentPes ~{&FP2}VentPes ~{&FP3}~
 ~{&FP1}VentFecI ~{&FP2}VentFecI ~{&FP3}~
 ~{&FP1}VentFecF ~{&FP2}VentFecF ~{&FP3}~
 ~{&FP1}CrecPes ~{&FP2}CrecPes ~{&FP3}~
 ~{&FP1}CrecFecI[1] ~{&FP2}CrecFecI[1] ~{&FP3}~
 ~{&FP1}CrecFecF[1] ~{&FP2}CrecFecF[1] ~{&FP3}~
 ~{&FP1}CrecFecI[2] ~{&FP2}CrecFecI[2] ~{&FP3}~
 ~{&FP1}CrecFecF[2] ~{&FP2}CrecFecF[2] ~{&FP3}~
 ~{&FP1}CateA ~{&FP2}CateA ~{&FP3}~
 ~{&FP1}CateD ~{&FP2}CateD ~{&FP3}~
 ~{&FP1}Cate ~{&FP2}Cate ~{&FP3}~
 ~{&FP1}CateB ~{&FP2}CateB ~{&FP3}~
 ~{&FP1}CateE ~{&FP2}CateE ~{&FP3}~
 ~{&FP1}CateC ~{&FP2}CateC ~{&FP3}~
 ~{&FP1}CateF ~{&FP2}CateF ~{&FP3}~
 ~{&FP1}CodFam ~{&FP2}CodFam ~{&FP3}
&Scoped-define ENABLED-TABLES INTEGRAL.AlmCfg
&Scoped-define FIRST-ENABLED-TABLE INTEGRAL.AlmCfg
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-3 RECT-4 RECT-8 RECT-5 RECT-6 
&Scoped-Define DISPLAYED-FIELDS INTEGRAL.AlmCfg.UtilPes ~
INTEGRAL.AlmCfg.UtilFecI INTEGRAL.AlmCfg.UtilfecF INTEGRAL.AlmCfg.VentPes ~
INTEGRAL.AlmCfg.VentFecI INTEGRAL.AlmCfg.VentFecF INTEGRAL.AlmCfg.CrecPes ~
INTEGRAL.AlmCfg.CrecFecI[1] INTEGRAL.AlmCfg.CrecFecF[1] ~
INTEGRAL.AlmCfg.CrecFecI[2] INTEGRAL.AlmCfg.CrecFecF[2] ~
INTEGRAL.AlmCfg.CateA INTEGRAL.AlmCfg.CateD INTEGRAL.AlmCfg.Cate ~
INTEGRAL.AlmCfg.CateB INTEGRAL.AlmCfg.CateE INTEGRAL.AlmCfg.CateC ~
INTEGRAL.AlmCfg.CateF INTEGRAL.AlmCfg.CodFam 

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
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.43 BY .69.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.14 BY 1.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.14 BY 2.04.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.14 BY 3.92.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.14 BY 2.31.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.14 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     INTEGRAL.AlmCfg.UtilPes AT ROW 1.96 COL 13 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     INTEGRAL.AlmCfg.UtilFecI AT ROW 1.96 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.UtilfecF AT ROW 1.96 COL 36 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.VentPes AT ROW 2.85 COL 13 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     INTEGRAL.AlmCfg.VentFecI AT ROW 2.85 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.VentFecF AT ROW 2.85 COL 36 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.CrecPes AT ROW 3.85 COL 13 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     INTEGRAL.AlmCfg.CrecFecI[1] AT ROW 3.85 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.CrecFecF[1] AT ROW 3.85 COL 36 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.CrecFecI[2] AT ROW 4.77 COL 24.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.CrecFecF[2] AT ROW 4.77 COL 36 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     INTEGRAL.AlmCfg.CateA AT ROW 7.19 COL 12 COLON-ALIGNED
          LABEL "CateA" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CateD AT ROW 7.19 COL 33.57 COLON-ALIGNED
          LABEL "CateD" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.Cate AT ROW 7.19 COL 45.43 COLON-ALIGNED FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CateB AT ROW 8 COL 12 COLON-ALIGNED
          LABEL "CateB" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CateE AT ROW 8 COL 33.57 COLON-ALIGNED
          LABEL "CateE" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CateC AT ROW 8.81 COL 12 COLON-ALIGNED
          LABEL "CateC" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CateF AT ROW 8.81 COL 33.57 COLON-ALIGNED
          LABEL "CateF" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .69
     INTEGRAL.AlmCfg.CodFam AT ROW 11.23 COL 3.43 NO-LABEL FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 50.57 BY .69
     "Crecimiento" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.92 COL 5.43
     "Periodo 1" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.96 COL 50.57
     "Periodo 1" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.04 COL 50.57
     "Dias de Reposicion x Categoria" VIEW-AS TEXT
          SIZE 36.43 BY .5 AT ROW 6.31 COL 7.57
     "Codigos de Familias a Clasificar" VIEW-AS TEXT
          SIZE 33.43 BY .5 AT ROW 10.38 COL 7.72
     RECT-7 AT ROW 10 COL 1.29
     RECT-3 AT ROW 1.08 COL 14.43
     "Desde" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 1.19 COL 27.29
     "Hasta" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.19 COL 38.57
     RECT-4 AT ROW 2.85 COL 1.86
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-8 AT ROW 1.81 COL 2
     "Periodo 2" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.88 COL 50.57
     "Factor" VIEW-AS TEXT
          SIZE 6.72 BY .5 AT ROW 1.19 COL 15.86
     "Utilidad" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2 COL 5.43
     "Periodo 1" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.04 COL 50.57
     RECT-5 AT ROW 3.77 COL 1.86
     "Ventas" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3 COL 5.43
     RECT-6 AT ROW 5.96 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.AlmCfg
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
         HEIGHT             = 11.73
         WIDTH              = 58.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.Cate IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateA IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateB IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateC IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateD IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateE IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CateF IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN INTEGRAL.AlmCfg.CodFam IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
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
  {src/adm/template/row-list.i "INTEGRAL.AlmCfg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "INTEGRAL.AlmCfg"}

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
    Almcfg.Codcia = S-CODCIA.
    
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
  {src/adm/template/snd-list.i "INTEGRAL.AlmCfg"}

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


