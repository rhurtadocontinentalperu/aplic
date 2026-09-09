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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR cb-CodCia AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.

DEFINE BUFFER B-cb-tbal FOR cb-tbal.
DEFINE BUFFER B-cb-nbal FOR cb-nbal.
DEFINE BUFFER B-cb-dbal FOR cb-dbal.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cb-tbal
&Scoped-define FIRST-EXTERNAL-TABLE cb-tbal


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cb-tbal.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cb-tbal.CodBal cb-tbal.DesBal 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodBal ~{&FP2}CodBal ~{&FP3}~
 ~{&FP1}DesBal ~{&FP2}DesBal ~{&FP3}
&Scoped-define ENABLED-TABLES cb-tbal
&Scoped-define FIRST-ENABLED-TABLE cb-tbal
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS cb-tbal.CodBal cb-tbal.DesBal 

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
     SIZE 55.29 BY 2.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-tbal.CodBal AT ROW 1.38 COL 9.14 COLON-ALIGNED
          LABEL "Cod.Balance"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     cb-tbal.DesBal AT ROW 2.23 COL 9.14 COLON-ALIGNED
          LABEL "Descripción"
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .69
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.cb-tbal
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
         HEIGHT             = 2.23
         WIDTH              = 55.29.
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

/* SETTINGS FOR FILL-IN cb-tbal.CodBal IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-tbal.DesBal IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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
  {src/adm/template/row-list.i "cb-tbal"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cb-tbal"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FORMATO V-table-Win 
PROCEDURE FORMATO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE FRAME f-cab
       cb-nbal.Nota
       cb-nbal.Glosa   FORMAT "X(40)"
       cb-dbal.CodCta
       cb-dbal.CodAux
       cb-dbal.Signo
       cb-dBal.Metodo
       HEADER
       S-NOMCIA FORMAT "X(50)" "CONFIGURACION DE PRESUPUESTO" TO 85
       "PAGINA : " AT 70 PAGE-NUMBER(REPORT) FORMAT "ZZZ9" AT 80 SKIP
       "CONFIGURACION DE " cb-tbal.DesBal SKIP
       TODAY STRING(TIME,"HH:MM:SS") SKIP(3)       
       WITH WIDTH 150 NO-BOX STREAM-IO DOWN.

/*MLR* 09/11/07 ***
 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
* ***/

 FOR EACH cb-nbal NO-LOCK WHERE cb-nbal.CodCia = cb-tbal.CodCia AND
                                cb-nbal.TpoBal = cb-tbal.TpoBal AND 
                                cb-nbal.CodBal = cb-tbal.CodBal AND
                                cb-nbal.Nota   <>  ""                       
                                BREAK BY cb-nbal.ForBal BY cb-nbal.Item :                                             
     
     DISPLAY STREAM REPORT cb-nbal.Nota cb-nbal.Glosa WITH FRAME F-CAB.
     
     FOR EACH cb-dbal NO-LOCK WHERE cb-dbal.CodCia = cb-nbal.CodCia AND
                                    cb-dbal.TpoBal = cb-nbal.TpoBal AND 
                                    cb-dbal.CodBal = cb-nbal.CodBal AND                                                             
                                    cb-dbal.Item   = cb-nbal.Item   :                                   
                                             
         DISPLAY STREAM REPORT cb-dbal.CodCta
                               cb-dbal.CodAux 
                               cb-dbal.CodAux
                               cb-dbal.Signo
                               cb-dBal.Metodo WITH FRAME F-CAB. 
         DOWN STREAM REPORT WITH FRAME F-CAB.                                 
     END.
     
     UNDERLINE STREAM REPORT cb-dbal.CodCta
                             cb-dbal.CodAux 
                             cb-dbal.CodAux
                             cb-dbal.Signo
                             cb-dBal.Metodo WITH FRAME F-CAB.                                      
 END.

/*MLR* 09/11/07 ***           
 PAGE STREAM REPORT.
 OUTPUT STREAM REPORT CLOSE.
* ***/

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

  cb-tbal.CodCia = cb-CodCia.
  cb-tbal.TpoBal = "4".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-BAL AS CHAR NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Code placed here will execute AFTER standard behavior.    */
  FIND LAST B-cb-tbal WHERE 
            B-cb-tbal.CodCia = cb-codcia AND 
            B-cb-tbal.TpoBal = "4" NO-LOCK NO-ERROR.
  IF AVAILABLE B-cb-tbal THEN X-BAL = STRING(INTEGER(B-cb-tbal.CodBal) + 1,"99").
  ELSE X-BAL = "01".
  CREATE B-cb-tbal.
  ASSIGN B-cb-tbal.CodCia = cb-tbal.CodCia 
         B-cb-tbal.TpoBal = cb-tbal.TpoBal
         B-cb-tbal.CodBal = X-BAL 
         B-cb-tbal.DesBal = cb-tbal.DesBal 
         B-cb-tbal.ForBal = cb-tbal.ForBal.
  FOR EACH cb-nbal NO-LOCK WHERE 
           cb-nbal.CodCia = cb-tbal.CodCia AND
           cb-nbal.TpoBal = cb-tbal.TpoBal AND
           cb-nbal.CodBal = cb-tbal.CodBal:
      CREATE B-cb-nbal.
      ASSIGN B-cb-nbal.CodCia = cb-nbal.CodCia 
             B-cb-nbal.TpoBal = cb-nbal.TpoBal
             B-cb-nbal.CodBal = B-cb-tbal.CodBal
             B-cb-nbal.ForBal = cb-nbal.ForBal 
             B-cb-nbal.Item   = cb-nbal.Item 
             B-cb-nbal.DesGlo = cb-nbal.DesGlo 
             B-cb-nbal.Glosa  = cb-nbal.Glosa 
             B-cb-nbal.Nota   = cb-nbal.Nota.
      FOR EACH cb-dbal NO-LOCK WHERE 
               cb-dbal.CodCia = cb-nbal.CodCia AND 
               cb-dbal.TpoBal = cb-nbal.TpoBal AND
               cb-dbal.CodBal = cb-nbal.CodBal AND
               cb-dbal.ForBal = cb-nbal.ForBal AND
               cb-dbal.Item   = cb-nbal.Item:
          CREATE B-cb-dbal.
          ASSIGN B-cb-dbal.CodCia = cb-dbal.CodCia 
                 B-cb-dbal.TpoBal = cb-dbal.TpoBal 
                 B-cb-dbal.CodBal = B-cb-nbal.CodBal
                 B-cb-dbal.ForBal = cb-dbal.ForBal 
                 B-cb-dbal.Item   = cb-dbal.Item 
                 B-cb-dbal.Codcta = cb-dbal.Codcta 
                 B-cb-dbal.Codope = cb-dbal.Codope 
                 B-cb-dbal.Metodo = cb-dbal.Metodo 
                 B-cb-dbal.Signo  = cb-dbal.Signo 
                 B-cb-dbal.CCosto = cb-dbal.CCosto 
                 B-cb-dbal.CodAux = cb-dbal.CodAux.
      END.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  FOR EACH cb-nbal WHERE 
           cb-nbal.CodCia = cb-tbal.CodCia AND
           cb-nbal.TpoBal = cb-tbal.TpoBal AND
           cb-nbal.CodBal = cb-tbal.CodBal:
      FOR EACH cb-dbal WHERE 
               cb-dbal.CodCia = cb-nbal.CodCia AND 
               cb-dbal.TpoBal = cb-nbal.TpoBal AND
               cb-dbal.CodBal = cb-nbal.CodBal AND
               cb-dbal.ForBal = cb-nbal.ForBal AND
               cb-dbal.Item   = cb-nbal.Item:
          DELETE cb-dbal.
      END.
      DELETE cb-nbal.
  END. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
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
  {src/adm/template/snd-list.i "cb-tbal"}

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
  
  IF p-state = 'update-begin':U THEN DO:
     cb-tbal.CodBal:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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


