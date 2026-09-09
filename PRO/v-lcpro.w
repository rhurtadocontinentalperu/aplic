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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-codref AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-CodAlm AS CHARACTER.

DEF VAR L-CREA AS LOGICAL.
DEF BUFFER B-ORDPRO FOR PR-ODPC.
DEF BUFFER B-LPROD  FOR LPRCLPRO.
DEF BUFFER B-SERVICIOS FOR PR-ODPDG.

DEF VAR p-NumOrd LIKE PR-ODPC.NumOrd.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES LPRCLPRO
&Scoped-define FIRST-EXTERNAL-TABLE LPRCLPRO


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LPRCLPRO.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LPRCLPRO.NumOrd LPRCLPRO.CodMaq ~
LPRCLPRO.ConmtroI LPRCLPRO.ConmtroF LPRCLPRO.HrsMaq 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}NumOrd ~{&FP2}NumOrd ~{&FP3}~
 ~{&FP1}CodMaq ~{&FP2}CodMaq ~{&FP3}~
 ~{&FP1}ConmtroI ~{&FP2}ConmtroI ~{&FP3}~
 ~{&FP1}ConmtroF ~{&FP2}ConmtroF ~{&FP3}~
 ~{&FP1}HrsMaq ~{&FP2}HrsMaq ~{&FP3}
&Scoped-define ENABLED-TABLES LPRCLPRO
&Scoped-define FIRST-ENABLED-TABLE LPRCLPRO
&Scoped-Define ENABLED-OBJECTS RECT-2 
&Scoped-Define DISPLAYED-FIELDS LPRCLPRO.NumOrd LPRCLPRO.CodMaq ~
LPRCLPRO.ConmtroI LPRCLPRO.ConmtroF LPRCLPRO.NroDoc LPRCLPRO.FchDoc ~
LPRCLPRO.HrsMaq LPRCLPRO.Usuario 
&Scoped-Define DISPLAYED-OBJECTS x-nommaq f-estado 

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
DEFINE VARIABLE f-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 1 NO-UNDO.

DEFINE VARIABLE x-nommaq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 92 BY 4.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LPRCLPRO.NumOrd AT ROW 1.58 COL 15 COLON-ALIGNED
          LABEL "Nº. O/P"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     LPRCLPRO.CodMaq AT ROW 2.54 COL 15 COLON-ALIGNED
          LABEL "Nº. Lote"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     LPRCLPRO.ConmtroI AT ROW 3.5 COL 15 COLON-ALIGNED
          LABEL "Contometro Inicial." FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     LPRCLPRO.ConmtroF AT ROW 4.46 COL 15 COLON-ALIGNED
          LABEL "Contometro Final" FORMAT "->>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     LPRCLPRO.NroDoc AT ROW 2.54 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     x-nommaq AT ROW 2.54 COL 31 COLON-ALIGNED NO-LABEL
     f-estado AT ROW 1.58 COL 42 COLON-ALIGNED NO-LABEL
     LPRCLPRO.FchDoc AT ROW 1.58 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     LPRCLPRO.HrsMaq AT ROW 3.5 COL 75 COLON-ALIGNED
          LABEL "Horas Máquina"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     LPRCLPRO.Usuario AT ROW 4.46 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     "-" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 2.73 COL 23
          FONT 1
     RECT-2 AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.LPRCLPRO
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
         HEIGHT             = 5
         WIDTH              = 94.57.
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

/* SETTINGS FOR FILL-IN LPRCLPRO.CodMaq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.ConmtroF IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LPRCLPRO.ConmtroI IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN f-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.HrsMaq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LPRCLPRO.NumOrd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LPRCLPRO.Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nommaq IN FRAME F-Main
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

&Scoped-define SELF-NAME LPRCLPRO.CodMaq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LPRCLPRO.CodMaq V-table-Win
ON LEAVE OF LPRCLPRO.CodMaq IN FRAME F-Main /* Nº. Lote */
DO:
  FIND FIRST LPRMAQUI WHERE
       LPRMAQUI.CodCia = s-CodCia AND
       LPRMAQUI.CodMaq = INPUT LPRCLPRO.CodMaq
       NO-LOCK NO-ERROR.
       IF NOT AVAILABLE LPRMAQUI THEN DO:
         MESSAGE "No existe maquina" VIEW-AS ALERT-BOX ERROR.
         RETURN 'ADM-ERROR'.
       END.
         DISPLAY
          LPRMAQUI.DesPro @ x-nommaq 
         WITH FRAME {&FRAME-NAME}.    
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

ON RETURN OF LPRCLPRO.CodMaq, LPRCLPRO.ConmtroI, LPRCLPRO.ConmtroF, LPRCLPRO.HrsMaq 
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
  {src/adm/template/row-list.i "LPRCLPRO"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LPRCLPRO"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalles V-table-Win 
PROCEDURE Borra-Detalles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Borrando Muestras*/

FOR EACH LPRDMUES NO-LOCK WHERE
    LPRDMUES.CodCia = LPRCLPRO.CodCia AND
    LPRDMUES.CodMaq = LPRCLPRO.CodMaq AND
    LPRDMUES.NroDoc = LPRCLPRO.NroDoc:
    DELETE LPRDMUES.
END.

/*Borrando Materiales*/

FOR EACH LPRDLPRO NO-LOCK WHERE
    LPRDLPRO.CodCia =  LPRCLPRO.CodCia AND
    LPRDLPRO.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDLPRO.NroDoc =  LPRCLPRO.NroDoc AND 
    LPRDLPRO.TpoMat <> "PT":
    DELETE LPRDLPRO.
END.        

/*Borrando registro de bobinas*/

FOR EACH LPRDBOB NO-LOCK WHERE
    LPRDBOB.CodCia =  LPRCLPRO.CodCia AND
    LPRDBOB.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDBOB.NroDoc =  LPRCLPRO.NroDoc:
    DELETE LPRDBOB.
END.

/*Borrando Servicios*/

FOR EACH LPRDSERV NO-LOCK WHERE
    LPRDSERV.CodCia =  LPRCLPRO.CodCia AND
    LPRDSERV.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDSERV.NroDoc =  LPRCLPRO.NroDoc:
    DELETE LPRDSERV.
END.

/*Borrando Horas - Hombre*/

FOR EACH LPRDHRHM NO-LOCK WHERE
    LPRDHRHM.CodCia =  LPRCLPRO.CodCia AND
    LPRDHRHM.CodMaq =  LPRCLPRO.CodMaq AND
    LPRDHRHM.NroDoc =  LPRCLPRO.NroDoc:
    DELETE LPRDHRHM.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Mermas V-table-Win 
PROCEDURE Graba-Mermas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FIND FIRST LPRDMERM WHERE LPRDMERM.CODCIA = S-CodCia AND
     LPRDMERM.CodMaq = LPRCLPRO.CodMaq AND
     LPRDMERM.NroDoc = LPRCLPRO.NroDoc 
     NO-LOCK NO-ERROR.
   IF NOT AVAILABLE LPRDMERM THEN DO: 
      CREATE LPRDMERM.   
      ASSIGN
        LPRDMERM.CodCia = LPRCLPRO.CodCia
        LPRDMERM.CodMaq = LPRCLPRO.CodMaq
        LPRDMERM.NroDoc = LPRCLPRO.NroDoc.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Productos V-table-Win 
PROCEDURE Graba-Productos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 FIND FIRST LPRDLPRO WHERE LPRDLPRO.CODCIA = S-CodCia AND
     LPRDLPRO.CodMaq = LPRCLPRO.CodMaq AND
     LPRDLPRO.NroDoc = LPRCLPRO.NroDoc 
     NO-LOCK NO-ERROR.
     IF NOT AVAILABLE LPRDLPRO THEN DO: 
      CREATE LPRDLPRO.   
      ASSIGN
        LPRDLPRO.CodCia = LPRCLPRO.CodCia
        LPRDLPRO.CodMaq = LPRCLPRO.CodMaq
        LPRDLPRO.NroDoc = LPRCLPRO.NroDoc
        LPRDLPRO.TpoMat = "PT".
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Servicios V-table-Win 
PROCEDURE Graba-Servicios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH PR-ODPDG NO-LOCK WHERE
        PR-ODPDG.codcia = LPRCLPRO.CodCia AND
        PR-ODPDG.numord = LPRCLPRO.numord:
        CREATE LPRDSERV.
        ASSIGN
            LPRDSERV.CodCia = LPRCLPRO.CodCia
            LPRDSERV.CodMaq = LPRCLPRO.CodMaq
            LPRDSERV.NroDoc = LPRCLPRO.NroDoc
            LPRDSERV.CodGas = PR-ODPDG.codgas
            LPRDSERV.CodPro = PR-ODPDG.codpro.
            /* AVERIGUAR...
            LPRDSERV.PreUni = PR-ODPDG.preuni.
            */
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
  
   RUN PRO\D-LOrdPro (OUTPUT p-NumOrd).  
   IF p-NumOrd = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
    FIND B-ORDPRO WHERE B-ORDPRO.codcia = s-codcia
      AND B-ORDPRO.NumOrd = p-numOrd
      NO-LOCK.
    DISPLAY
        p-NumOrd @ LPRCLPRO.NumOrd
        TODAY    @ LPRCLPRO.FchDoc
        WITH FRAME {&FRAME-NAME}.       
  END.
  LPRCLPRO.NumOrd:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
   
   IF L-CREA THEN DO:
    DEFINE VAR X-NumDoc AS INTEGER.
    
    FIND LAST B-LPROD WHERE B-LPROD.Codcia = S-CODCIA 
         AND B-LPROD.CodMaq = LPRCLPRO.CodMaq
         NO-LOCK NO-ERROR.
    IF AVAILABLE B-LPROD THEN x-NumDoc = INTEGER(B-LPROD.NroDoc) + 1.
    ELSE x-NumDoc = 1.
  
    DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
       LPRCLPRO.Codcia  = S-CODCIA
       LPRCLPRO.NroDoc  = STRING(X-NumDoc,"999999")
       LPRCLPRO.FchDoc  = TODAY 
       LPRCLPRO.Estado  = "E".
    END.
  END.
  
  ASSIGN
    LPRCLPRO.Usuario = s-user-id.
  RUN Graba-Servicios.  
/*  RUN Graba-Productos.
 *   RUN Graba-Mermas.*/
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   
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

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE LPRCLPRO THEN RETURN "ADM-ERROR".
  IF LPRCLPRO.Estado = "A" THEN RETURN "ADM-ERROR".
  
  IF LPRCLPRO.Estado = "L" THEN DO:
     MESSAGE "Lote de Produccion ya fue Liquidada, no puede ser eliminado" 
     VIEW-AS ALERT-BOX.
     RETURN "ADM-ERROR".
  END.
  FIND B-LPROD WHERE ROWID(B-LPROD) = ROWID(LPRCLPRO) EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-LPROD
  THEN ASSIGN
        B-LPROD.Estado = "A"
        B-LPROD.Usuario = s-user-id.
  RELEASE B-LPROD.
  RUN Borra-Detalles.
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

  
  DO WITH FRAME {&FRAME-NAME}:
    IF AVAILABLE LPRCLPRO THEN DO:
       CASE LPRCLPRO.Estado:
            WHEN "E" THEN DISPLAY "     E N T R A D A     " @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "A" THEN DISPLAY "     A N U L A D O     " @ F-Estado WITH FRAME {&FRAME-NAME}.
            WHEN "L" THEN DISPLAY "   L I Q U I D A D O   " @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE. 
       FIND FIRST LPRMAQUI WHERE
            LPRMAQUI.CodCia = LPRCLPRO.CodCia AND
            LPRMAQUI.CodMaq = LPRCLPRO.CodMaq
            NO-LOCK NO-ERROR.
       IF AVAILABLE LPRMAQUI THEN DISPLAY LPRMAQUI.DesPro @ x-nommaq WITH FRAME {&FRAME-NAME}.
    END.
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO'    /* MOdificando */
  THEN ASSIGN
            LPRCLPRO.CodMaq:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
            LPRCLPRO.NumOrd:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).

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
  {src/adm/template/snd-list.i "LPRCLPRO"}

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
  
  /*RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
 *   IF RETURN-VALUE = 'NO' THEN DO:
 *         MESSAGE "Usted no puede modificar registro" VIEW-AS ALERT-BOX ERROR.
 *         RETURN 'ADM-ERROR'.
 *   END.*/
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

  IF LPRCLPRO.Estado = 'A' THEN DO:
    MESSAGE 'Lote Anulado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  IF LPRCLPRO.Estado <> 'E' THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  RETURN 'OK'.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


