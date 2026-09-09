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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR pv-codcia AS INT.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
&Scoped-define EXTERNAL-TABLES VtaCProm GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE VtaCProm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCProm, GN-DIVI.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCProm.FlgEst VtaCProm.CodPro ~
VtaCProm.Glosa VtaCProm.TipProm VtaCProm.CodMon VtaCProm.Importe ~
VtaCProm.Cantidad VtaCProm.Desde VtaCProm.Hasta 
&Scoped-define ENABLED-TABLES VtaCProm
&Scoped-define FIRST-ENABLED-TABLE VtaCProm
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-54 RECT-55 
&Scoped-Define DISPLAYED-FIELDS VtaCProm.NroDoc VtaCProm.FlgEst ~
VtaCProm.CodPro VtaCProm.Glosa VtaCProm.TipProm VtaCProm.CodMon ~
VtaCProm.Importe VtaCProm.Cantidad VtaCProm.Desde VtaCProm.Hasta 
&Scoped-define DISPLAYED-TABLES VtaCProm
&Scoped-define FIRST-DISPLAYED-TABLE VtaCProm
&Scoped-Define DISPLAYED-OBJECTS x-NomPro 

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
DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 27 BY 3.77.

DEFINE RECTANGLE RECT-54
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 3.77.

DEFINE RECTANGLE RECT-55
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCProm.NroDoc AT ROW 1.27 COL 15 COLON-ALIGNED FORMAT "999999"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     VtaCProm.FlgEst AT ROW 1.27 COL 42 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Inactivo", "I":U
          SIZE 18 BY .58
     VtaCProm.CodPro AT ROW 2.04 COL 15 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     x-NomPro AT ROW 2.04 COL 26 COLON-ALIGNED NO-LABEL
     VtaCProm.Glosa AT ROW 2.81 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     VtaCProm.TipProm AT ROW 3.96 COL 17 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Por importe", 1,
"Por cantidad", 2,
"Por proveedor y compra minima", 3
          SIZE 68 BY .81
     VtaCProm.CodMon AT ROW 5.04 COL 17 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11 BY .77
     VtaCProm.Importe AT ROW 6.12 COL 15 COLON-ALIGNED
          LABEL "Monto mínimo" FORMAT ">>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     VtaCProm.Cantidad AT ROW 6.12 COL 41 COLON-ALIGNED WIDGET-ID 8
          LABEL "Cantidad Mínima"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     VtaCProm.Desde AT ROW 7.73 COL 16 COLON-ALIGNED WIDGET-ID 10
          LABEL "Válida desde el"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     VtaCProm.Hasta AT ROW 7.73 COL 39 COLON-ALIGNED WIDGET-ID 12
          LABEL "Hasta el"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     "Una promoción por vez, no acumulables" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 5.31 COL 53 WIDGET-ID 20
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 5.23 COL 11
     "Estado:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.27 COL 36
     "Tipo de Promoción:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 3.96 COL 3 WIDGET-ID 6
     RECT-2 AT ROW 3.69 COL 2 WIDGET-ID 14
     RECT-54 AT ROW 3.69 COL 29 WIDGET-ID 16
     RECT-55 AT ROW 3.69 COL 52 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCProm,INTEGRAL.GN-DIVI
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
         HEIGHT             = 8.92
         WIDTH              = 90.14.
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaCProm.Cantidad IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCProm.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCProm.Desde IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCProm.Hasta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCProm.Importe IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCProm.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
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

&Scoped-define SELF-NAME VtaCProm.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCProm.CodPro V-table-Win
ON LEAVE OF VtaCProm.CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
    AND Gn-prov.codpro = VtaCProm.CodPro:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov THEN x-NomPro:SCREEN-VALUE = Gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCProm.TipProm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCProm.TipProm V-table-Win
ON VALUE-CHANGED OF VtaCProm.TipProm IN FRAME F-Main /* TipProm */
DO:
  CASE SELF:SCREEN-VALUE:
      WHEN '1' THEN ASSIGN 
                        VtaCProm.CodMon:SENSITIVE = YES 
                        VtaCProm.Importe:SENSITIVE = YES
                        VtaCProm.Cantidad:SENSITIVE = NO
                        VtaCProm.Cantidad:SCREEN-VALUE = '0'.
      WHEN '2' THEN ASSIGN 
                        VtaCProm.CodMon:SENSITIVE = NO
                        VtaCProm.Importe:SENSITIVE = NO
                        VtaCProm.Cantidad:SENSITIVE = YES
                        VtaCProm.Importe:SCREEN-VALUE = '0.00'.
      WHEN '3' THEN ASSIGN 
                        VtaCProm.CodMon:SENSITIVE = NO 
                        VtaCProm.Importe:SENSITIVE = NO
                        VtaCProm.Cantidad:SENSITIVE = NO
                        VtaCProm.Importe:SCREEN-VALUE = '0.00'
                        VtaCProm.Cantidad:SCREEN-VALUE = '0'.
  END CASE.
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
  {src/adm/template/row-list.i "VtaCProm"}
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCProm"}
  {src/adm/template/row-find.i "GN-DIVI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'No está definido el correlativo para el documento' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DISPLAY
      TODAY @ VtaCProm.Hasta
      TODAY - DAY(TODAY) + 1 @ VtaCProm.Desde
      WITH FRAME {&FRAME-NAME}.
  RUN Procesa-Handle IN lh_handle ('Pagina0').

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
  IF VtaCProm.Desde = ?
      OR VtaCProm.Hasta = ?
      OR VtaCProm.Desde > VtaCProm.Hasta
      THEN DO:
      MESSAGE 'Ingrese las fechas correctas' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO VtaCProm.Desde IN FRAME {&FRAME-NAME}.
      UNDO, RETURN 'ADM-ERROR'.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Procesa-Handle IN lh_handle ('Pagina1').

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddoc = s-coddoc
/*       AND Faccorre.coddiv = s-coddiv */
      AND Faccorre.flgest = YES
    EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
    VtaCProm.CodCia = s-codcia
    VtaCProm.CodDiv = gn-divi.coddiv
    VtaCProm.coddoc = s-coddoc
    VtaCProm.nrodoc = FacCorre.Correlativo.
  ASSIGN
    Faccorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

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
  FOR EACH VtaDProm OF VtaCProm:
    DELETE VtaDProm.
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
  DO WITH FRAME {&FRAME-NAME}:
    FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
        AND Gn-prov.codpro = VtaCProm.CodPro
        NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-prov THEN x-NomPro:SCREEN-VALUE = Gn-prov.nompro.
  END.
  
  IF AVAILABLE VtaCProm THEN DO:
      CASE VtaCProm.TipProm:
          WHEN 1 OR WHEN 2 THEN RUN Procesa-Handle IN lh_handle ('Pagina1').
          WHEN 3 THEN RUN Procesa-Handle IN lh_handle ('Pagina2'). 
      END CASE.
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
      VtaCProm.Cantidad:SENSITIVE = NO.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          VtaCProm.CodPro:SENSITIVE = NO.
          VtaCProm.TipProm:SENSITIVE = NO.
          CASE VtaCProm.TipProm:
              WHEN 1 THEN ASSIGN 
                              VtaCProm.CodMon:SENSITIVE = YES 
                              VtaCProm.Importe:SENSITIVE = YES
                              VtaCProm.Cantidad:SENSITIVE = NO.
              WHEN 2 THEN ASSIGN 
                              VtaCProm.CodMon:SENSITIVE = NO
                              VtaCProm.Importe:SENSITIVE = NO
                              VtaCProm.Cantidad:SENSITIVE = YES.
              WHEN 3 THEN ASSIGN 
                              VtaCProm.CodMon:SENSITIVE = NO
                              VtaCProm.Importe:SENSITIVE = NO
                              VtaCProm.Cantidad:SENSITIVE = NO.
          END CASE.
      END.
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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  /*RUN Procesa-Handle IN lh_handle ('Pagina1').*/

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
  {src/adm/template/snd-list.i "VtaCProm"}
  {src/adm/template/snd-list.i "GN-DIVI"}

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
    FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
        AND Gn-prov.codpro = VtaCProm.CodPro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Gn-prov THEN DO:
        MESSAGE 'Codigo de Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF VtaCProm.TipProm:SCREEN-VALUE = '1' 
        AND DECIMAL(VtaCProm.Importe:SCREEN-VALUE) <= 0
        THEN DO:
        MESSAGE 'Ingrese el monto mínimo' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF VtaCProm.TipProm:SCREEN-VALUE = '2' 
        AND DECIMAL(VtaCProm.Cantidad:SCREEN-VALUE) <= 0
        THEN DO:
        MESSAGE 'Ingrese la cantidad mínima' VIEW-AS ALERT-BOX ERROR.
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

