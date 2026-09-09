&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>
7
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE SHARED TEMP-TABLE RMOV LIKE cb-dmov.
DEFINE SHARED TEMP-TABLE VMOV LIKE cb-cmov.

DEFINE VARIABLE L-CREA   AS LOGICAL.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = 0 AND cb-cfga.CodCfg = 1 NO-LOCK  NO-ERROR.
FIND cb-oper WHERE cb-oper.CodCia = cb-cfga.CodCia AND
     cb-oper.Codope = cb-cfga.Transf NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cb-cmov
&Scoped-define FIRST-EXTERNAL-TABLE cb-cmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-cmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 FILL-IN_CodDiv EDITOR_GloAst ~
FILL-IN_Fchast FILL-IN_Tpocmb RADIO-SET_Codmon 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Nroast FILL-IN_CodDiv ~
EDITOR_GloAst F-DesDiv FILL-IN_Fchast FILL-IN_Tpocmb RADIO-SET_Codmon 

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
DEFINE VARIABLE EDITOR_GloAst AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodDiv AS CHARACTER FORMAT "x(5)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Fchast AS DATE FORMAT "99/99/9999" INITIAL ? 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Nroast AS CHARACTER FORMAT "x(6)" 
     LABEL "Asiento" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_Tpocmb AS DECIMAL FORMAT ">,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE RADIO-SET_Codmon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 11.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71.86 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_Nroast AT ROW 1.15 COL 8 COLON-ALIGNED
     FILL-IN_CodDiv AT ROW 1.85 COL 8 COLON-ALIGNED HELP
          "Ingrese el Codigo de Divisionaria" NO-LABEL
     EDITOR_GloAst AT ROW 2.54 COL 10 NO-LABEL
     F-DesDiv AT ROW 1.85 COL 17.29 COLON-ALIGNED NO-LABEL
     FILL-IN_Fchast AT ROW 1.15 COL 56.86 COLON-ALIGNED HELP
          "Ingrese la fecha del asiento"
     FILL-IN_Tpocmb AT ROW 1.85 COL 56.86 COLON-ALIGNED NO-LABEL
     RADIO-SET_Codmon AT ROW 2.54 COL 58.86 NO-LABEL
     RECT-7 AT ROW 1 COL 1
     "Divisionaria" VIEW-AS TEXT
          SIZE 8.29 BY .58 AT ROW 1.88 COL 1.57
     "Glosa" VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 2.65 COL 5.29
     "Tipo de Cambio" VIEW-AS TEXT
          SIZE 11 BY .58 AT ROW 1.85 COL 47.86
     "Moneda" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 2.54 COL 52.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-cmov
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
         HEIGHT             = 2.42
         WIDTH              = 71.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN EDITOR_GloAst IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN F-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Nroast IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FILL-IN_CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodDiv V-table-Win
ON LEAVE OF FILL-IN_CodDiv IN FRAME F-Main
DO:
   FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
        GN-DIVI.CodDiv = FILL-IN_CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE GN-DIVI THEN DO:
      MESSAGE "Division no registrada" VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
   END.
   ASSIGN FILL-IN_CodDiv
          VMOV.CodDiv = FILL-IN_CodDiv.
   DISPLAY GN-DIVI.DesDiv @ F-DesDiv WITH FRAME {&FRAME-NAME}.
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Fchast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Fchast V-table-Win
ON LEAVE OF FILL-IN_Fchast IN FRAME F-Main /* Fecha */
DO:
  IF INPUT FILL-IN_FchAst = ? THEN RETURN.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT FILL-IN_FchAst NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO :
     IF cb-oper.Tpocmb = 1 THEN FILL-IN_TpoCmb = gn-tcmb.compra.
     ELSE  FILL-IN_TpoCmb = gn-tcmb.Venta.
     DISPLAY FILL-IN_TpoCmb WITH FRAME {&FRAME-NAME}.
  END.
  ELSE  MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX ERROR.
  ASSIGN FILL-IN_FchAst
         FILL-IN_Tpocmb
         VMOV.Fchast = FILL-IN_FchAst
         VMOV.Tpocmb = FILL-IN_Tpocmb.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Tpocmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Tpocmb V-table-Win
ON LEAVE OF FILL-IN_Tpocmb IN FRAME F-Main
DO:
  ASSIGN FILL-IN_Tpocmb
         VMOV.Tpocmb = FILL-IN_Tpocmb.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Codmon V-table-Win
ON VALUE-CHANGED OF RADIO-SET_Codmon IN FRAME F-Main
DO:
ASSIGN RADIO-SET_Codmon
       VMOV.Codmon = RADIO-SET_Codmon.
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
  {src/adm/template/row-list.i "cb-cmov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-cmov"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  CREATE VMOV.
  ASSIGN VMOV.FchMod = TODAY
         VMOV.FchAst = TODAY
         VMOV.Codmon = 1.
 
  FIND LAST gn-tcmb NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb AND cb-oper.Tpocmb = 1 THEN ASSIGN VMOV.TpoCmb = gn-tcmb.compra.
  IF AVAILABLE gn-tcmb AND cb-oper.Tpocmb = 2 THEN ASSIGN VMOV.TpoCmb = gn-tcmb.Venta.
  
  FIND FIRST GN-DIVI WHERE GN-DIVI.CODCIA = S-CODCIA NO-LOCK NO-ERROR.
  IF AVAILABLE GN-DIVI THEN ASSIGN VMOV.CodDiv = GN-DIVI.CodDiv.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  L-CREA = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:  
   ASSIGN EDITOR_GloAst 
          FILL-IN_Tpocmb 
          FILL-IN_FchAst
          RADIO-SET_Codmon
          FILL-IN_CodDiv.
END.
ASSIGN VMOV.GloAst = EDITOR_GloAst
       VMOV.Fchast = FILL-IN_FchAst
       VMOV.Tpocmb = FILL-IN_Tpocmb
       VMOV.Codmon = RADIO-SET_Codmon
       VMOV.CodDiv = FILL-IN_CodDiv.
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
  L-CREA = NO.
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN_Nroast   = ""
            FILL-IN_Tpocmb   = 1
            FILL-IN_CodDiv   = ""
            EDITOR_GloAst    = "".
     FIND FIRST VMOV NO-LOCK NO-ERROR.
     IF AVAILABLE VMOV THEN 
        ASSIGN FILL-IN_FchAst   = VMOV.FchAst
               FILL-IN_Nroast   = VMOV.Nroast
               FILL-IN_Tpocmb   = VMOV.Tpocmb
               FILL-IN_CodDiv   = VMOV.CodDiv
               RADIO-SET_Codmon = VMOV.Codmon
               EDITOR_GloAst    = VMOV.GloAst.
     DISPLAY EDITOR_GloAst 
             FILL-IN_FchAst
             FILL-IN_Nroast 
             FILL-IN_Tpocmb
             FILL-IN_CodDiv 
             RADIO-SET_Codmon.
     
     FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
          GN-DIVI.CodDiv = VMOV.CodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN 
         DISPLAY GN-DIVI.DesDiv @ F-DesDiv.
     ELSE DISPLAY "" @ F-DesDiv.
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
  {src/adm/template/snd-list.i "cb-cmov"}

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


