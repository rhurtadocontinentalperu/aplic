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

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.

DEFINE BUFFER DOCP FOR SlsDocp.
DEFINE VAR C-NUEVO  AS CHAR NO-UNDO.
DEFINE VARIABLE F-NOMBRE AS CHAR NO-UNDO.
DEFINE VARIABLE F-USERID AS CHAR NO-UNDO.
F-USERID = "000138".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES SlsDocP
&Scoped-define FIRST-EXTERNAL-TABLE SlsDocP


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR SlsDocP.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS SlsDocP.Clase[1] SlsDocP.TxtExt ~
SlsDocP.Priori SlsDocP.TxtCor SlsDocP.Frec SlsDocP.Clase[2] ~
SlsDocP.Clase[3] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Clase[1] ~{&FP2}Clase[1] ~{&FP3}~
 ~{&FP1}Priori ~{&FP2}Priori ~{&FP3}~
 ~{&FP1}TxtCor ~{&FP2}TxtCor ~{&FP3}~
 ~{&FP1}Frec ~{&FP2}Frec ~{&FP3}~
 ~{&FP1}Clase[2] ~{&FP2}Clase[2] ~{&FP3}~
 ~{&FP1}Clase[3] ~{&FP2}Clase[3] ~{&FP3}
&Scoped-define ENABLED-TABLES SlsDocP
&Scoped-define FIRST-ENABLED-TABLE SlsDocP
&Scoped-Define ENABLED-OBJECTS RECT-39 RECT-38 RECT-40 RECT-41 F-Entrega 
&Scoped-Define DISPLAYED-FIELDS SlsDocP.Clase[1] SlsDocP.TxtExt ~
SlsDocP.NroPri SlsDocP.Usr SlsDocP.Area SlsDocP.Priori SlsDocP.TxtCor ~
SlsDocP.Frec SlsDocP.Clase[2] SlsDocP.Clase[3] SlsDocP.CodDiv 
&Scoped-Define DISPLAYED-OBJECTS F-NomclaA F-NomUsr F-DesPrio F-NomclaB ~
F-DesUso F-NomclaC F-Fecha F-Hora F-Entrega 

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
DEFINE VARIABLE F-DesPrio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesUso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Entrega AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Fecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Hora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomclaA AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomclaB AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomclaC AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomUsr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 2.73.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 1.23.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 5.15.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 1.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     SlsDocP.Clase[1] AT ROW 5.77 COL 2.29 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     SlsDocP.TxtExt AT ROW 7.81 COL 2.72 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
          SIZE 68.29 BY 3.88
     SlsDocP.NroPri AT ROW 1.35 COL 6 COLON-ALIGNED
          LABEL "Numero"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     SlsDocP.Usr AT ROW 2.19 COL 6 COLON-ALIGNED
          LABEL "De"
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .69
     SlsDocP.Area AT ROW 3.04 COL 6 COLON-ALIGNED
          LABEL "Area"
          VIEW-AS FILL-IN 
          SIZE 31.86 BY .69
     SlsDocP.Priori AT ROW 4.31 COL 6 COLON-ALIGNED
          LABEL "Prioridad"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-NomclaA AT ROW 5.77 COL 5.72 COLON-ALIGNED NO-LABEL
     SlsDocP.TxtCor AT ROW 7 COL 2.29
          LABEL "Asunto"
          VIEW-AS FILL-IN 
          SIZE 62 BY .69
     F-NomUsr AT ROW 2.19 COL 13.72 COLON-ALIGNED NO-LABEL
     F-DesPrio AT ROW 4.31 COL 11.29 COLON-ALIGNED NO-LABEL
     SlsDocP.Frec AT ROW 4.31 COL 28.86 COLON-ALIGNED
          LABEL "Uso"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     SlsDocP.Clase[2] AT ROW 5.81 COL 24.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-NomclaB AT ROW 5.81 COL 29.57 COLON-ALIGNED NO-LABEL
     F-DesUso AT ROW 4.31 COL 34.14 COLON-ALIGNED NO-LABEL
     SlsDocP.Clase[3] AT ROW 5.85 COL 47.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-NomclaC AT ROW 5.85 COL 53.14 COLON-ALIGNED NO-LABEL
     F-Fecha AT ROW 1.35 COL 58 COLON-ALIGNED
     F-Hora AT ROW 2.19 COL 58 COLON-ALIGNED
     SlsDocP.CodDiv AT ROW 3.04 COL 58 COLON-ALIGNED
          LABEL "Division"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-Entrega AT ROW 4.31 COL 58 COLON-ALIGNED
     RECT-39 AT ROW 5.38 COL 1
     RECT-38 AT ROW 1.19 COL 1
     "Clasificacion" VIEW-AS TEXT
          SIZE 9.86 BY .54 AT ROW 5.19 COL 2.29
     RECT-40 AT ROW 6.81 COL 1
     RECT-41 AT ROW 4.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.SlsDocP
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
         HEIGHT             = 11.12
         WIDTH              = 70.72.
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

/* SETTINGS FOR FILL-IN SlsDocP.Area IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN SlsDocP.Clase[1] IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN SlsDocP.CodDiv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN F-DesPrio IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesUso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomclaA IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomclaB IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomclaC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomUsr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN SlsDocP.Frec IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN SlsDocP.NroPri IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN SlsDocP.Priori IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN SlsDocP.TxtCor IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN SlsDocP.Usr IN FRAME F-Main
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
  {src/adm/template/row-list.i "SlsDocP"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "SlsDocP"}

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
  FIND PL-PERS WHERE PL-PERS.CodPer = F-USERID NO-LOCK NO-ERROR.
  IF AVAILABLE PL-PERS THEN
     ASSIGN
     F-NomUsr = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
                PL-PERS.NomPer.

     FIND PL-FLG-MES WHERE PL-FLG-MES.Codcia  = S-CODCIA AND
                           PL-FLG-MES.Periodo = YEAR(TODAY) AND
                           PL-FLG-MES.CodPln  = 1 AND
                           PL-FLG-MES.Nromes  = MONTH(TODAY) AND
                           PL-FLG-MES.CodPer  = F-USERID NO-LOCK NO-ERROR.
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY F-NomUsr
             
             TODAY @ F-Fecha 
             TODAY @ F-Entrega 
             F-USERID @ SlsDocP.Usr
             PL-FLG-MES.Seccion @ SlsDocP.Area
             PL-FLG-MES.Coddiv  @ SlsDocP.Coddiv.
     F-Entrega:SENSITIVE = YES. 
 
  END.

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE VAR x-NroCor AS INTEGER.
  
  /* Dispatch standard ADM method.                             */
  IF C-NUEVO = "YES" THEN DO WITH FRAME {&FRAME-NAME}:
     FIND LAST DOCP WHERE DOCP.CodCia = STRING(S-CODCIA,"9") NO-LOCK NO-ERROR.
     IF AVAILABLE DOCP THEN x-NroCor = INTEGER(DOCP.NroPri) + 1.
     ELSE x-NroCor = 1.
  END.
  /* Dispatch standard ADM method.                             */
  /* Code placed here will execute AFTER standard behavior.    */
  IF C-NUEVO = "YES" THEN DO:
     ASSIGN SlsDocp.CodCia = STRING(S-CODCIA,"9")
            SlsDocp.Fch    = TODAY
            SlsDocp.NroPri = STRING(x-NroCor,"999999")
            SlsDocp.Hra     = TIME
            SlsDocp.FchInf[1] = F-Entrega
            SlsDocp.FchInf[2] = F-Entrega
            SlsDocp.FchInf[3] = F-Entrega.
  END.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

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
  IF AVAILABLE SlsDocP THEN DO WITH FRAME {&FRAME-NAME}:
     FIND PL-PERS WHERE PL-PERS.CodPer = SlsDocP.Usr NO-LOCK NO-ERROR.
     IF AVAILABLE PL-PERS THEN
        ASSIGN
            F-NomUsr = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " +
            PL-PERS.NomPer.

     FIND PL-FLG-MES WHERE PL-FLG-MES.Codcia  = S-CODCIA AND
                           PL-FLG-MES.Periodo = YEAR(SlsDocP.Fch) AND
                           PL-FLG-MES.CodPln  = 1 AND
                           PL-FLG-MES.Nromes  = MONTH(SlsDocP.Fch) AND
                           PL-FLG-MES.CodPer  = SlsDocP.Usr NO-LOCK NO-ERROR.

     DISPLAY
        F-NomUsr
        /*
        PL-FLG-MES.Seccion @ SlsDocP.Area
        PL-FLG-MES.CodDiv  @ SlsDocP.Coddiv
        */
        
        SlsDocP.Fch @ F-Fecha 
        STRING(SlsDocP.Hra,"HH:MM:SS") @ F-Hora
        SlsDocP.FchInf[1] @ F-Entrega .
           
    /*
     CASE SlsDocP.Est:
          WHEN "A" THEN DISPLAY " ANULADO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "C" THEN DISPLAY "ATENDIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "P" THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "V" THEN DISPLAY " VENCIDO " @ F-Estado WITH FRAME {&FRAME-NAME}.
      END CASE.         
      */
  END.  
  F-Entrega:SENSITIVE = NO.
  /* Code placed here will execute AFTER standard behavior.    */

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
  RUN get-attribute('ADM-NEW-RECORD').
  ASSIGN C-NUEVO = RETURN-VALUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-parametros V-table-Win 
PROCEDURE Procesa-parametros :
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
/*
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
 */   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros V-table-Win 
PROCEDURE Recoge-Parametros :
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
/*
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
*/
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
  {src/adm/template/snd-list.i "SlsDocP"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida V-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
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
   ASSIGN F-ENTREGA.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Update V-table-Win 
PROCEDURE Valida-Update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   F-Entrega:SENSITIVE = YES.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


