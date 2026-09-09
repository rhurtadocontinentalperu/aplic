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
DEFINE {&NEW} SHARED VARIABLE s-codcia       AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE cb-niveles AS CHARACTER INITIAL "2,3,5".
DEFINE VARIABLE cb-codcia                   AS INTEGER INITIAL 0  NO-UNDO.
DEFINE BUFFER CTAS FOR cb-ctas.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodCbd THEN cb-codcia = s-codcia.

/* Buscamos las configuraciones del Sistema Contable */
FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia
               AND cb-cfga.CodCfg = 1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
    BELL.
    MESSAGE "NO SE HA CONFIGURADO EL SISTEMA CONTABLE" VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Definimos variables para la consistencia de cuentas */
DEFINE VARIABLE x-MaxNiv    AS INTEGER NO-UNDO.
DEFINE VARIABLE x-CodCta    LIKE cb-ctas.CodCta  NO-UNDO.
DEFINE VARIABLE nivel       AS INTEGER NO-UNDO.
DEFINE VARIABLE i           AS INTEGER NO-UNDO.
DEFINE VARIABLE x-Ctas9     AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-Ctas6     AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-Ctas0     AS LOGICAL NO-UNDO.

DEFINE VARIABLE Cbd-CodDiv  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE x-leave     AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL NO-UNDO.

x-MaxNiv = INTEGER( ENTRY ( NUM-ENTRIES ( cb-niveles ), cb-niveles ) ).
pto      = SESSION:SET-WAIT-STATE("").

IF cb-cfga.coddiv THEN CBD-coddiv = YES.

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
&Scoped-define EXTERNAL-TABLES cb-ctas
&Scoped-define FIRST-EXTERNAL-TABLE cb-ctas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-ctas.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-ctas.Codcta cb-ctas.Nomcta cb-ctas.Codmon ~
cb-ctas.PidAux cb-ctas.ClfAux cb-ctas.MovCta cb-ctas.PidDoc cb-ctas.Coddoc ~
cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.Tpocmb cb-ctas.pidcco cb-ctas.activo ~
cb-ctas.CieRes cb-ctas.Sustento cb-ctas.An1cta cb-ctas.vcodcia ~
cb-ctas.Cc1cta cb-ctas.Tpogto cb-ctas.TM cb-ctas.CodDiv 
&Scoped-define ENABLED-TABLES cb-ctas
&Scoped-define FIRST-ENABLED-TABLE cb-ctas
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 RECT-14 RECT-13 
&Scoped-Define DISPLAYED-FIELDS cb-ctas.Codcta cb-ctas.Nomcta ~
cb-ctas.Codmon cb-ctas.PidAux cb-ctas.ClfAux cb-ctas.MovCta cb-ctas.PidDoc ~
cb-ctas.Coddoc cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.Tpocmb cb-ctas.pidcco ~
cb-ctas.activo cb-ctas.CieRes cb-ctas.Sustento cb-ctas.An1cta ~
cb-ctas.vcodcia cb-ctas.Cc1cta cb-ctas.Tpogto cb-ctas.TM cb-ctas.CodDiv 
&Scoped-define DISPLAYED-TABLES cb-ctas
&Scoped-define FIRST-DISPLAYED-TABLE cb-ctas


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define List-4 cb-ctas.PidAux cb-ctas.ClfAux cb-ctas.MovCta ~
cb-ctas.PidDoc cb-ctas.Coddoc cb-ctas.PidRef cb-ctas.AftDcb cb-ctas.Tpocmb ~
cb-ctas.pidcco cb-ctas.CieRes cb-ctas.An1cta cb-ctas.vcodcia cb-ctas.Cc1cta ~
cb-ctas.Tpogto cb-ctas.TM cb-ctas.CodDiv 

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
DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.15.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 72 BY 1.15.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 12.12.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 11.43 BY 1.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-ctas.Codcta AT ROW 1.19 COL 6.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-ctas.Nomcta AT ROW 1.19 COL 16.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48.14 BY .69
     cb-ctas.Codmon AT ROW 1.73 COL 69.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2,
"Ambas", 3
          SIZE 8.86 BY 1.46
     cb-ctas.PidAux AT ROW 2.38 COL 9.72
          LABEL "Requiere Código Auxiliar"
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .69
     cb-ctas.ClfAux AT ROW 2.38 COL 37.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .69
     cb-ctas.MovCta AT ROW 2.38 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
     cb-ctas.PidDoc AT ROW 3.73 COL 9.72
          VIEW-AS TOGGLE-BOX
          SIZE 25.43 BY .69
     cb-ctas.Coddoc AT ROW 3.73 COL 51.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.14 BY .69
     cb-ctas.PidRef AT ROW 4.88 COL 9.72
          VIEW-AS TOGGLE-BOX
          SIZE 28.14 BY .69
     cb-ctas.AftDcb AT ROW 6.04 COL 9.72
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .69
     cb-ctas.Tpocmb AT ROW 6.04 COL 47.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Compra", 1,
"Venta", 2,
"Segun el Saldo", 3
          SIZE 30 BY .81
     cb-ctas.pidcco AT ROW 7.19 COL 9.72
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .69
     cb-ctas.activo AT ROW 8.27 COL 67 COLON-ALIGNED WIDGET-ID 4 FORMAT "Activo/Inactivo"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Yes","No" 
          DROP-DOWN-LIST
          SIZE 12 BY 1
     cb-ctas.CieRes AT ROW 8.35 COL 9.72
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .69
     cb-ctas.Sustento AT ROW 9.35 COL 10 WIDGET-ID 6
          LABEL "Solicita sustento de gasto"
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .77
     cb-ctas.An1cta AT ROW 10.42 COL 26 COLON-ALIGNED
          LABEL "Cuenta Automática"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cb-ctas.vcodcia AT ROW 10.42 COL 67 COLON-ALIGNED
          LABEL "Visible para Compañia"
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     cb-ctas.Cc1cta AT ROW 11.23 COL 26 COLON-ALIGNED
          LABEL "Contra Cuenta Automática"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .69
     cb-ctas.Tpogto AT ROW 11.23 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     cb-ctas.TM AT ROW 12.04 COL 26 COLON-ALIGNED FORMAT "99"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     cb-ctas.CodDiv AT ROW 12.04 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.72 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 1.19 COL 69.14
     RECT-16 AT ROW 1 COL 1
     RECT-17 AT ROW 1.5 COL 68.29
     RECT-14 AT ROW 3.54 COL 7.72
     RECT-13 AT ROW 5.85 COL 7.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-ctas
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
         HEIGHT             = 14.15
         WIDTH              = 91.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-ctas.activo IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.AftDcb IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.An1cta IN FRAME F-Main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN cb-ctas.Cc1cta IN FRAME F-Main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.CieRes IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.ClfAux IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.CodDiv IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.Coddoc IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.MovCta IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.PidAux IN FRAME F-Main
   4 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.pidcco IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.PidDoc IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.PidRef IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX cb-ctas.Sustento IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.TM IN FRAME F-Main
   4 EXP-FORMAT                                                         */
/* SETTINGS FOR RADIO-SET cb-ctas.Tpocmb IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.Tpogto IN FRAME F-Main
   4                                                                    */
/* SETTINGS FOR FILL-IN cb-ctas.vcodcia IN FRAME F-Main
   4 EXP-LABEL                                                          */
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

&Scoped-define SELF-NAME cb-ctas.AftDcb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.AftDcb V-table-Win
ON VALUE-CHANGED OF cb-ctas.AftDcb IN FRAME F-Main /* Afecta diferencia de Cambio */
DO:
  integral.cb-ctas.Tpocmb:SENSITIVE = SELF:SCREEN-VALUE = "SI".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.An1cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.An1cta V-table-Win
ON LEAVE OF cb-ctas.An1cta IN FRAME F-Main /* Cuenta Automática */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN 
        IF NOT CAN-FIND(cb-ctas WHERE cb-ctas.codcta = SELF:SCREEN-VALUE) THEN DO:
           MESSAGE 'Cuenta Contable no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY' TO cb-ctas.An1cta.
           RETURN NO-APPLY.
        END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Cc1cta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Cc1cta V-table-Win
ON LEAVE OF cb-ctas.Cc1cta IN FRAME F-Main /* Contra Cuenta Automática */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE <> '' THEN 
        IF NOT CAN-FIND(cb-ctas WHERE cb-ctas.codcta = SELF:SCREEN-VALUE) THEN DO:
           MESSAGE 'Cuenta Contable no se encuentra registrada' VIEW-AS ALERT-BOX ERROR.
           APPLY 'ENTRY' TO cb-ctas.CC1cta.
           RETURN NO-APPLY.
        END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.Codcta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.Codcta V-table-Win
ON LEAVE OF cb-ctas.Codcta IN FRAME F-Main /* Cuenta */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  RUN Valida-Cuenta.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.PidAux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.PidAux V-table-Win
ON VALUE-CHANGED OF cb-ctas.PidAux IN FRAME F-Main /* Requiere Código Auxiliar */
DO:
  integral.cb-ctas.ClfAux:SENSITIVE = SELF:SCREEN-VALUE = "SI".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ctas.PidDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ctas.PidDoc V-table-Win
ON VALUE-CHANGED OF cb-ctas.PidDoc IN FRAME F-Main /* Requiere Documento de Control */
DO:
  integral.cb-ctas.Coddoc:SENSITIVE = SELF:SCREEN-VALUE = "SI".
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
  {src/adm/template/row-list.i "cb-ctas"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-ctas"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-Automatica V-table-Win 
PROCEDURE Control-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  x-Ctas9 = FALSE.
  x-Ctas6 = FALSE.
  x-Ctas0 = FALSE.
 
  /* Verificamos si la Cuenta genera automaticas de Clase 9 */
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):
     IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
           x-Ctas9 = YES.
           LEAVE.
        END.                                              
     END.
  END.
  /* Verificamos si la Cuenta genera automaticas de Clase 6 */
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
     IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
           x-Ctas6 = YES.
           LEAVE.
        END.
     END.
  END.
  DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
     IF cb-ctas.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
        IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
           x-Ctas0 = YES.
           LEAVE.
        END.
     END.
  END.
  /* FILTRANDO LOS CAMPOS QUE DEBEN SALIR */
  cb-ctas.CodDiv:VISIBLE IN FRAME {&FRAME-NAME} = CBD-CodDiv.
  IF NOT x-Ctas9 THEN ASSIGN cb-ctas.TpoGto:VISIBLE IN FRAME {&FRAME-NAME} = NO.
  IF x-Ctas9 THEN DO :
     ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
            cb-ctas.Cc1Cta:VISIBLE = YES                              
            x-Ctas6 = NO
            x-Ctas0 = NO.
     IF  cb-ctas.Cc1Cta:SCREEN-VALUE = "" THEN
         cb-ctas.Cc1Cta:SCREEN-VALUE = cb-cfga.Cc1Cta9.
  END.       
  IF x-Ctas6 THEN DO:
     ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
            cb-ctas.Cc1Cta:VISIBLE = YES    
            x-Ctas0 = NO.
     IF cb-ctas.Cc1Cta:SCREEN-VALUE = "" THEN 
        cb-ctas.Cc1Cta:SCREEN-VALUE = cb-cfga.Cc1Cta6.
  END.       
  IF x-Ctas0 THEN 
     ASSIGN cb-ctas.An1Cta:VISIBLE = YES 
            cb-ctas.Cc1Cta:VISIBLE = YES.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     integral.cb-ctas.ClfAux:SENSITIVE = integral.cb-ctas.PidAux.
     integral.cb-ctas.Coddoc:SENSITIVE = integral.cb-ctas.PidDoc.
     integral.cb-ctas.Tpocmb:SENSITIVE = integral.cb-ctas.AftDcb.
     DISABLE {&List-4}.     
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
  
  ASSIGN cb-ctas.codcia = CB-CODCIA.

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
  IF CAN-FIND(FIRST cb-acmd WHERE cb-acmd.CODCTA = cb-ctas.CODCTA)  THEN DO:
     MESSAGE "Cuenta tiene movimiento" SKIP
             "no puede ser Eliminada" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
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
     RUN VALIDA.
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
        WHEN "" THEN.
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
        WHEN "clfaux" THEN ASSIGN input-var-1 = "01".
        WHEN "coddoc" THEN ASSIGN input-var-1 = "02".
        WHEN "TM" THEN ASSIGN input-var-1 = "05".
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
  {src/adm/template/snd-list.i "cb-ctas"}

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
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}: 
     cb-ctas.Codcta:SENSITIVE = NO.
     DISABLE {&List-4}.
     Nivel = LOOKUP(STRING( LENGTH(cb-ctas.CodCta) ), cb-niveles ).
     IF Nivel = NUM-ENTRIES( cb-niveles ) THEN DO:
        ENABLE {&List-4}.
        RUN Control-Automatica.
     END.
     cb-ctas.ClfAux:SENSITIVE = cb-ctas.PidAux.
     cb-ctas.Coddoc:SENSITIVE = cb-ctas.PidDoc.
     cb-ctas.Tpocmb:SENSITIVE = cb-ctas.AftDcb.
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
   IF cb-ctas.Codcta:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Cuenta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO cb-ctas.Codcta.
      RETURN "ADM-ERROR".
   END.
   ASSIGN x-CodCta = cb-ctas.CodCta:SCREEN-VALUE.
   /*FIND CTAS WHERE CTAS.CodCia = cb-codcia AND 
        CTAS.CodCta = x-CodCta NO-LOCK NO-ERROR.
   IF AVAILABLE CTAS THEN DO:
      BELL.
      MESSAGE "Codigo de cuenta ya existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.*/
   IF cb-ctas.Nomcta:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Descripcion de cuenta no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO cb-ctas.nomcta.
      RETURN "ADM-ERROR".
   END.
   Nivel = LOOKUP(STRING( LENGTH(x-CodCta) ), cb-niveles ).
   IF Nivel = 0 THEN DO:
        BELL.
        MESSAGE "Inv lido formato en el registro de la cuenta"
       
            SKIP "  Intente de nuevo..." VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO cb-ctas.Codcta.
        RETURN "ADM-ERROR".
   END.
   ELSE DO:
       IF Nivel > 1 THEN DO:
          FIND CTAS WHERE CTAS.CodCia = cb-codcia AND CTAS.CodCta =
               SUBSTRING(x-CodCta,1, INTEGER(ENTRY(Nivel - 1,cb-niveles))) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE CTAS THEN DO:
             MESSAGE "Cuenta del Nivel anterior" SKIP
                     "aun no ha sido creada"  VIEW-AS ALERT-BOX ERROR.
             APPLY "ENTRY" TO cb-ctas.Codcta.
             RETURN "ADM-ERROR".
          END.
       END.
   END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Cuenta V-table-Win 
PROCEDURE Valida-Cuenta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   ASSIGN x-CodCta = cb-ctas.CodCta:SCREEN-VALUE.
   FIND CTAS WHERE CTAS.CodCia = cb-codcia AND 
        CTAS.CodCta = x-CodCta NO-LOCK NO-ERROR.
   IF AVAILABLE CTAS THEN DO:
      BELL.
      MESSAGE "Codigo de cuenta ya existe" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.
   Nivel = LOOKUP(STRING( LENGTH(x-CodCta) ), cb-niveles ).
   IF Nivel = 0 THEN DO:
        BELL.
        MESSAGE "Inv lido formato en el registro de la cuenta"
            SKIP "  Intente de nuevo..." VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
   END.
   ELSE DO:
       IF Nivel > 1 THEN DO:
          FIND CTAS WHERE CTAS.CodCia = cb-codcia AND CTAS.CodCta =
               SUBSTRING(x-CodCta,1, INTEGER(ENTRY(Nivel - 1,cb-niveles))) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE CTAS THEN DO:
             MESSAGE "Cuenta del Nivel anterior" SKIP
                     "aun no ha sido creada"  VIEW-AS ALERT-BOX ERROR.
             RETURN "ADM-ERROR".
          END.
          IF Nivel = NUM-ENTRIES( cb-niveles ) THEN DO:
               ENABLE {&List-4}.
               RUN Control-Automatica.
           END.
       END.
   END.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

