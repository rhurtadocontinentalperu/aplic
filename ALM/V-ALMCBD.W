&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE SHARED VAR cb-codcia AS INTEGER.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE VAR s-tipo AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE BUFFER B-TMOV FOR Almtmovm.
s-tipo = 'I'.

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
&Scoped-define EXTERNAL-TABLES Almtmovm
&Scoped-define FIRST-EXTERNAL-TABLE Almtmovm


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almtmovm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almtmovm.Detalle Almtmovm.Codope ~
Almtmovm.Ctadbe1 Almtmovm.Ctadbe2 Almtmovm.Ctahbe1 Almtmovm.CtaHbe2 
&Scoped-define ENABLED-TABLES Almtmovm
&Scoped-define FIRST-ENABLED-TABLE Almtmovm
&Scoped-Define ENABLED-OBJECTS RECT-15 
&Scoped-Define DISPLAYED-FIELDS Almtmovm.Codmov Almtmovm.Desmov ~
Almtmovm.Detalle Almtmovm.Codope Almtmovm.Ctadbe1 Almtmovm.Ctadbe2 ~
Almtmovm.Ctahbe1 Almtmovm.CtaHbe2 
&Scoped-define DISPLAYED-TABLES Almtmovm
&Scoped-define FIRST-DISPLAYED-TABLE Almtmovm
&Scoped-Define DISPLAYED-OBJECTS F-ctadbe1 F-ctadbe2 F-ctahbe1 F-ctahbe2 

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
DEFINE VARIABLE F-ctadbe1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-ctadbe2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-ctahbe1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-ctahbe2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.72 BY 5.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almtmovm.Codmov AT ROW 1.38 COL 15.86 COLON-ALIGNED
          LABEL "Movimiento"
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .81
     Almtmovm.Desmov AT ROW 1.38 COL 19.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
     Almtmovm.Detalle AT ROW 2.31 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 16.14 BY .77
     Almtmovm.Codope AT ROW 2.35 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     Almtmovm.Ctadbe1 AT ROW 3.38 COL 16.14 COLON-ALIGNED
          LABEL "Cuenta Debe Grav."
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     F-ctadbe1 AT ROW 3.38 COL 25.29 COLON-ALIGNED NO-LABEL
     Almtmovm.Ctadbe2 AT ROW 4.08 COL 16.14 COLON-ALIGNED
          LABEL "Cuenta Debe Exon."
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     F-ctadbe2 AT ROW 4.08 COL 25.29 COLON-ALIGNED NO-LABEL
     Almtmovm.Ctahbe1 AT ROW 4.85 COL 16.14 COLON-ALIGNED
          LABEL "Cuenta Haber Grav."
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     F-ctahbe1 AT ROW 4.85 COL 25.29 COLON-ALIGNED NO-LABEL
     Almtmovm.CtaHbe2 AT ROW 5.62 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     F-ctahbe2 AT ROW 5.62 COL 25.29 COLON-ALIGNED NO-LABEL
     RECT-15 AT ROW 1.12 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almtmovm
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
         HEIGHT             = 5.85
         WIDTH              = 50.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almtmovm.Codmov IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN Almtmovm.Ctadbe1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almtmovm.Ctadbe2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almtmovm.Ctahbe1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almtmovm.Desmov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ctadbe1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ctadbe2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ctahbe1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ctahbe2 IN FRAME F-Main
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

&Scoped-define SELF-NAME Almtmovm.Codope
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.Codope V-table-Win
ON LEAVE OF Almtmovm.Codope IN FRAME F-Main /* Operacion */
DO:
/*  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-oper WHERE cb-oper.CodCia = s-codcia AND
          cb-oper.Codope = almtmovm.codope:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE cb-oper THEN
        F-desope:SCREEN-VALUE = cb-oper.Nomope.
  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.Ctadbe1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.Ctadbe1 V-table-Win
ON LEAVE OF Almtmovm.Ctadbe1 IN FRAME F-Main /* Cuenta Debe Grav. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctadbe1:SCREEN-VALUE = cb-ctas.Nomcta.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.Ctadbe2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.Ctadbe2 V-table-Win
ON LEAVE OF Almtmovm.Ctadbe2 IN FRAME F-Main /* Cuenta Debe Exon. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctadbe2:SCREEN-VALUE = cb-ctas.Nomcta.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.Ctahbe1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.Ctahbe1 V-table-Win
ON LEAVE OF Almtmovm.Ctahbe1 IN FRAME F-Main /* Cuenta Haber Grav. */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctahbe1:SCREEN-VALUE = cb-ctas.Nomcta.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almtmovm.CtaHbe2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almtmovm.CtaHbe2 V-table-Win
ON LEAVE OF Almtmovm.CtaHbe2 IN FRAME F-Main /* Cuenta Haber */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctahbe2:SCREEN-VALUE = cb-ctas.Nomcta.
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
  {src/adm/template/row-list.i "Almtmovm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almtmovm"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir V-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 80 TODAY SKIP(1)
    {&PRN6A} + 
    "MOVIMIENTOS DE ALMACEN - INGRESOS"
    + {&PRN6B} + {&PRND} AT 50 FORMAT "X(45)" SKIP(1)
    "------------------------------------------------------------------------------------------------------------" SKIP
    "                                              TRASLADO                   CTA.NACIONAL        CTA.EXTERIOR   " SKIP
    "CODIGO  DESCRIPCION                           DETALLADO OPERACION      DEBE      HABER     DEBE      HABER  " SKIP
    "------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 115. 
   
DEFINE FRAME F-Detalle
    B-tmov.Codmov  AT 3 FORMAT '99'
    B-tmov.Desmov  AT 8 FORMAT 'X(40)'
    B-tmov.Detalle AT 50
    B-tmov.Codope  AT 60
    B-tmov.Ctadbe1 AT 70
    B-tmov.Ctahbe1 AT 80
    B-tmov.Ctadbe2 AT 90
    B-tmov.CtaHbe2 AT 100 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 115 STREAM-IO DOWN. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.


 FOR EACH B-Tmov WHERE B-Tmov.codcia = s-codcia AND
     B-tmov.Tipmov = s-tipo NO-LOCK:
     VIEW FRAME F-Header.
     DISPLAY  
        B-tmov.Codmov  
        B-tmov.Desmov  
        B-tmov.Detalle 
        B-tmov.Codope  
        B-tmov.Ctadbe1 
        B-tmov.Ctahbe1 
        B-tmov.Ctadbe2 
        B-tmov.CtaHbe2 
        WITH FRAME F-Detalle.
 END.
OUTPUT CLOSE.
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
  
/*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .*/

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
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = almtmovm.ctadbe1 NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctadbe1:SCREEN-VALUE = cb-ctas.Nomcta.
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = almtmovm.ctadbe2 NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctadbe2:SCREEN-VALUE = cb-ctas.Nomcta.
     FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND 
          cb-ctas.Codcta = almtmovm.ctahbe1 NO-LOCK NO-ERROR.
     IF AVAILABLE cb-ctas THEN
        F-ctahbe1:SCREEN-VALUE = cb-ctas.Nomcta.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
   
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE.   
     
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
  {src/adm/template/snd-list.i "Almtmovm"}

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

