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
DEFINE SHARED VAR s-CodDoc AS CHAR.
DEFINE SHARED VAR s-CodDiv AS CHAR.
DEFINE SHARED VAR s-CodCia AS INTEGER. 
DEFINE SHARED VAR s-User-Id AS CHAR. 
DEFINE BUFFER Documento FOR ccbCdocu.

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.CodDiv ~
CcbCDocu.FchDoc CcbCDocu.CodCli CcbCDocu.CodRef CcbCDocu.NroRef ~
CcbCDocu.CodMon CcbCDocu.ImpBrt CcbCDocu.ImpInt CcbCDocu.Glosa ~
CcbCDocu.CodCta CcbCDocu.CodAge CcbCDocu.CodCob CcbCDocu.CodVen 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}NroDoc ~{&FP2}NroDoc ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}FchDoc ~{&FP2}FchDoc ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}CodRef ~{&FP2}CodRef ~{&FP3}~
 ~{&FP1}NroRef ~{&FP2}NroRef ~{&FP3}~
 ~{&FP1}ImpBrt ~{&FP2}ImpBrt ~{&FP3}~
 ~{&FP1}ImpInt ~{&FP2}ImpInt ~{&FP3}~
 ~{&FP1}CodCta ~{&FP2}CodCta ~{&FP3}~
 ~{&FP1}CodAge ~{&FP2}CodAge ~{&FP3}~
 ~{&FP1}CodCob ~{&FP2}CodCob ~{&FP3}~
 ~{&FP1}CodVen ~{&FP2}CodVen ~{&FP3}
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-25 RECT-28 RECT-27 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.CodDoc CcbCDocu.NroDoc ~
CcbCDocu.CodDiv CcbCDocu.FchDoc CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.RucCli CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.CodMon ~
CcbCDocu.TpoCmb CcbCDocu.ImpBrt CcbCDocu.ImpInt CcbCDocu.ImpTot ~
CcbCDocu.Glosa CcbCDocu.CodCta CcbCDocu.CodAge CcbCDocu.CodCob ~
CcbCDocu.CodVen 

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
DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 1.35.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 4.54.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 3.69.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.86 BY 1.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.CodDoc AT ROW 1.23 COL 6.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .69
     CcbCDocu.NroDoc AT ROW 1.23 COL 20.57 COLON-ALIGNED FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 14.57 BY .69
     CcbCDocu.CodDiv AT ROW 1.23 COL 41.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .69
     CcbCDocu.FchDoc AT ROW 1.23 COL 58.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     CcbCDocu.CodCli AT ROW 2.58 COL 6 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.NomCli AT ROW 2.58 COL 17.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 50.14 BY .69
          FGCOLOR 2 
     CcbCDocu.RucCli AT ROW 3.58 COL 5.86 COLON-ALIGNED FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     CcbCDocu.CodRef AT ROW 4.62 COL 5.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     CcbCDocu.NroRef AT ROW 4.62 COL 12.57 COLON-ALIGNED NO-LABEL FORMAT "X(9)"
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .69
     CcbCDocu.CodMon AT ROW 4.62 COL 30 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 20 BY .69
     CcbCDocu.TpoCmb AT ROW 4.62 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCDocu.ImpBrt AT ROW 5.81 COL 10.86 COLON-ALIGNED FORMAT "-ZZZ,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
          FGCOLOR 2 
     CcbCDocu.ImpInt AT ROW 5.81 COL 32.57 COLON-ALIGNED FORMAT "-ZZZ,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
          FGCOLOR 2 
     CcbCDocu.ImpTot AT ROW 5.81 COL 57.43 COLON-ALIGNED FORMAT "-ZZZ,ZZZ,ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
          FGCOLOR 2 
     CcbCDocu.Glosa AT ROW 7.35 COL 25.86 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 60 SCROLLBAR-VERTICAL
          SIZE 48 BY 2.88
     CcbCDocu.CodCta AT ROW 7.5 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCDocu.CodAge AT ROW 9.42 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCDocu.CodCob AT ROW 10.77 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CcbCDocu.CodVen AT ROW 10.77 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .69
     RECT-26 AT ROW 2.35 COL 1
     RECT-25 AT ROW 1 COL 1
     RECT-28 AT ROW 10.54 COL 1
     RECT-27 AT ROW 6.85 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CcbCDocu
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
         HEIGHT             = 11.04
         WIDTH              = 73.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.CodDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpBrt IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpInt IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.ImpTot IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE <> "" THEN DO :
     FIND FIRST GN-CLIE WHERE GN-CLIE.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE GN-CLIE THEN DO :
        integral.CcbCDocu.NomCli:SCREEN-VALUE = gn-clie.NomCli.
        integral.CcbCDocu.RucCli:SCREEN-VALUE = gn-clie.Ruc.
     END.
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FchDoc V-table-Win
ON LEAVE OF CcbCDocu.FchDoc IN FRAME F-Main /* Fecha */
DO:
   FIND GN-TCMB WHERE GN-TCMB.FECHA = INPUT CCBCDOCU.FCHDOC NO-LOCK NO-ERROR. 
  IF NOT AVAILABLE GN-TCMB THEN DO:
  Message "No hay tipo de Cambio Contable" VIEW-AS ALERT-BOX .
  RETURN NO-APPLY.
  END.
  ASSIGN
     CCBCDOCU.TPOCMB:SCREEN-VALUE  = STRING(GN-TCMB.VENTA).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.ImpInt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.ImpInt V-table-Win
ON LEAVE OF CcbCDocu.ImpInt IN FRAME F-Main /* Intereses */
DO:
  DEFINE VAR x-ImpBto AS DECIMAL.
  DEFINE VAR x-ImpInt AS DECIMAL.
  DEFINE VAR x-ImpTot AS DECIMAL. 
  
  x-ImpBto = DECIMAL(ccbcDocu.ImpBrt:SCREEN-VALUE).
  x-ImpInt = DECIMAL(ccbcDocu.ImpInt:SCREEN-VALUE).
  x-ImpTot = x-ImpBto + x-ImpInt.
  
  CcbCDocu.ImpTot:SCREEN-VALUE = STRING(x-ImpTot).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.NroRef V-table-Win
ON LEAVE OF CcbCDocu.NroRef IN FRAME F-Main /* Numero */
DO:
  IF CcbCDocu.NroRef:SCREEN-VALUE = "" THEN RETURN.
  
  FIND FIRST Documento WHERE Documento.CodCia = s-CodCia AND 
                             Documento.FlgEst = "C" AND 
                             Documento.CodDoc = CcbCDocu.CodRef:SCREEN-VALUE AND
                             Documento.NroDoc = CcbCDocu.NroRef:SCREEN-VALUE 
                             NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Documento THEN DO :
     MESSAGE "Documento no se encuentra registrado" VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  
  DO WITH FRAME {&FRAME-NAME} :
     DISPLAY Documento.ImpTot @ CcbCDocu.ImpBrt .
     CcbCDocu.CodMon:SCREEN-VALUE = STRING(Documento.CodMon).
     CcbCDocu.Codven:SCREEN-VALUE = Documento.CodVen. 
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY s-CodDoc @ CcbCDocu.CodDoc
             TODAY    @ CcbCDocu.FchDoc
             s-CodDiv @ CcbCDocu.CodDiv
             0 @ CcbCDocu.ImpBrt 
             0 @ CcbCDocu.ImpInt 
             0 @ CcbCDocu.ImpTot.
     FIND GN-TCMB WHERE GN-TCMB.FECHA = INPUT CCBCDOCU.FCHDOC NO-LOCK NO-ERROR. 
     IF AVAILABLE GN-TCMB THEN 
        ASSIGN  CCBCDOCU.TPOCMB:SCREEN-VALUE = STRING(GN-TCMB.VENTA).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME} :
      ASSIGN
            CcbCDocu.CodCia = s-CodCia
            CcbCDocu.CodDoc = s-CodDoc
            CcbCDocu.NomCli = CcbCDocu.NomCli:SCREEN-VALUE
            CcbCDocu.RucCli = CcbCDocu.RucCli:SCREEN-VALUE
            CcbCDocu.ImpTot = CcbCDocu.ImpBrt + CcbCDocu.ImpInt
            CcbCDocu.SdoAct = CcbCDocu.ImpBrt + CcbCDocu.ImpInt
            CcbCDocu.FlgEst = "P"
           CcbCDocu.Usuario = s-User-Id
            CcbCDocu.FchVto = CcbCDocu.FchDoc .
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR iRowid AS ROWID.  

  /* Dispatch standard ADM method.   
  
  RUN valida-update.                          */
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  iRowid = ROWID(integral.CcbCDocu).
  
  FIND FIRST Documento WHERE ROWID(Documento) = iRowid NO-ERROR.
  
  IF AVAILABLE Documento THEN DO :
     ASSIGN
     Documento.FlgEst = "A"
     Documento.NomCli = " * * * A N U L A D O * * * "
     Documento.SdoAct = 0.   
  END.
  
  RELEASE Documento.

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
            WHEN "NroRef" THEN 
                 ASSIGN Input-var-1 = ccbcdoc.CodRef:SCREEN-VALUE 
                        Input-var-2 = CcbCDocu.CodCli:SCREEN-VALUE 
                        Input-var-3 = "C". 
            WHEN "CodRef" THEN ASSIGN Input-var-1 = "CARGO" . 
            WHEN "CodCta" THEN ASSIGN Input-var-1 = "104" .    
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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     integral.CcbCDocu.NroDoc:SENSITIVE = NO.     
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

  IF ccbcdocu.CodCli:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Debe Ingresar el CODIGO DEL CLIENTE"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ccbcdocu.CodCli.
         RETURN "ADM-ERROR".    
  END.
  
  IF ccbcdocu.NroDoc:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Debe Ingresar el NUMERO DE CHEQUE"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ccbcdocu.NroDoc.
         RETURN "ADM-ERROR".    
  END.
  
  IF ccbcdocu.CodDiv:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Debe Ingresar el Codigo de la DIVISION"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ccbcdocu.CodDiv.
         RETURN "ADM-ERROR".    
  END.
  
  IF DECIMAL( ccbcdocu.TpoCmb:SCREEN-VALUE ) <= 0 THEN DO:
         MESSAGE "Tipo de Cambio no debe ser cero"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO ccbcdocu.TpoCmb.
         RETURN "ADM-ERROR".    
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
  IF NOT AVAILABLE ccbcdocu THEN RETURN "ADM-ERROR". 
  
  IF ccbcdocu.FlgEst = "A" THEN DO:
         MESSAGE "EL DOCUMENTO HA SIDO ANULADO ANTERIORMENTE "
         VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".    
  END.
   
  IF ccbcdocu.ImpTot <> ccbcdocu.SdoAct THEN DO:
         MESSAGE "EL DOCUMENTO TIENE AMORTIZACIONES"
         VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".    
  END.
  
  IF ccbcdocu.FlgEst <> "P" THEN DO:
         MESSAGE "EL DOCUMENTO NO PUEDE SER MODIFICADO"
         VIEW-AS ALERT-BOX ERROR.
         RETURN "ADM-ERROR".    
  END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


