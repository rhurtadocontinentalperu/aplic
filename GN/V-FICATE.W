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

DEFINE BUFFER C-Ficha FOR fi-cate.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FI-CATE
&Scoped-define FIRST-EXTERNAL-TABLE FI-CATE


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FI-CATE.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FI-CATE.FchSol FI-CATE.CodCli ~
FI-CATE.Contacto FI-CATE.Agente FI-CATE.Mensaje FI-CATE.Observacion ~
FI-CATE.FchEje FI-CATE.HorIni FI-CATE.HorFin 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}FchSol ~{&FP2}FchSol ~{&FP3}~
 ~{&FP1}CodCli ~{&FP2}CodCli ~{&FP3}~
 ~{&FP1}Contacto ~{&FP2}Contacto ~{&FP3}~
 ~{&FP1}Agente ~{&FP2}Agente ~{&FP3}~
 ~{&FP1}FchEje ~{&FP2}FchEje ~{&FP3}~
 ~{&FP1}HorIni ~{&FP2}HorIni ~{&FP3}~
 ~{&FP1}HorFin ~{&FP2}HorFin ~{&FP3}
&Scoped-define ENABLED-TABLES FI-CATE
&Scoped-define FIRST-ENABLED-TABLE FI-CATE
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS FI-CATE.NroDoc FI-CATE.FchSol ~
FI-CATE.CodCli FI-CATE.Contacto FI-CATE.Agente FI-CATE.Mensaje ~
FI-CATE.Observacion FI-CATE.FchEje FI-CATE.HorIni FI-CATE.HorFin 
&Scoped-Define DISPLAYED-OBJECTS F-NomCia 

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
DEFINE VARIABLE F-NomCia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.86 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 8.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FI-CATE.NroDoc AT ROW 1.27 COL 10.29 COLON-ALIGNED FORMAT "999999"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
     FI-CATE.FchSol AT ROW 1.27 COL 62.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FI-CATE.CodCli AT ROW 2.08 COL 10.29 COLON-ALIGNED FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-NomCia AT ROW 2.08 COL 15.57 COLON-ALIGNED NO-LABEL
     FI-CATE.Contacto AT ROW 2.88 COL 10.29 COLON-ALIGNED FORMAT "X(30)"
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .69
     FI-CATE.Agente AT ROW 3.62 COL 10.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46.43 BY .69
     FI-CATE.Mensaje AT ROW 5.54 COL 2.57 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 35.29 BY 2.23
     FI-CATE.Observacion AT ROW 5.54 COL 41.43 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 35.29 BY 2.31
     FI-CATE.FchEje AT ROW 8.04 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .69
     FI-CATE.HorIni AT ROW 8.04 COL 36.29 COLON-ALIGNED FORMAT "XX:XX"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     FI-CATE.HorFin AT ROW 8.04 COL 56.57 COLON-ALIGNED FORMAT "XX:XX"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     RECT-1 AT ROW 1 COL 1.14
     "Observaciones" VIEW-AS TEXT
          SIZE 11.72 BY .77 AT ROW 4.62 COL 41.72
     "Mensaje" VIEW-AS TEXT
          SIZE 8.72 BY .69 AT ROW 4.65 COL 2.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FI-CATE
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
         HEIGHT             = 8.04
         WIDTH              = 77.14.
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

/* SETTINGS FOR FILL-IN FI-CATE.CodCli IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FI-CATE.Contacto IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-NomCia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-CATE.HorFin IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FI-CATE.HorIni IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FI-CATE.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FI-CATE.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FI-CATE.CodCli V-table-Win
ON LEAVE OF FI-CATE.CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND GN-CIAS WHERE GN-CIAS.CodCia = INTEGER( SELF:SCREEN-VALUE )
               NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CIAS THEN DO :
     F-NomCia:SCREEN-VALUE = GN-CIAS.NomCia.
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
  {src/adm/template/row-list.i "FI-CATE"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FI-CATE"}

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
DEFINE VAR I-CONT AS INTEGER.

DEFINE FRAME f-cab
  FI-DATE.Modulo FORMAT "X(4)" AT 2
  FI-DATE.SitTra FORMAT "P/NP" AT 10
  FI-DATE.PtoRef FORMAT "999999" AT 15
  FI-DATE.ClfPto FORMAT "X" 
  FI-DATE.descripcion   AT 28
  FI-DATE.Entrega FORMAT "C/I"  
  HEADER
       "VALMIESA S.A" 
       "FICHA DE ATENCION TECNICA" TO 60 
       "NRO. " TO 115 fi-cate.NroDoc  SKIP(1)
       "AGENTE  : " TO 10 fi-cate.Agente FORMAT "X(30)" 
       "CONTACTO: " TO 60 fi-cate.Contacto FORMAT "X(30)" 
       "FECHA : " TO 119 fi-cate.FchSol FORMAT "99/99/9999" SKIP
       "MENSAJE : " TO 10 fi-cate.Mensaje SKIP       
       "-- EJECUCION DE TRABAJOS ---------------------------------------------------------------------------------------------------------" SKIP
       "FECHA : " TO 10 fi-cate.FchEje FORMAT "99/99/9999" 
       "H.INICIO : " TO 50 fi-cate.HorIni FORMAT "99:99"
       "H.TERMINO: " TO 75 fi-cate.HorFin FORMAT "99:99" SKIP
       "OBSERVA.: " TO 10 fi-cate.Observacion SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       " MOD.  P/NP  PTO.  TIPO   TRABAJO EJECUTADO                                                                                ENTREGA" SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       WITH WIDTH 130 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 33. /* Pantalla */
       WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 33. /* Impresora */
       WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 33. /* Archivo */
 END CASE.

PUT STREAM report CONTROL {&prn0} + {&prn5a} + CHR(33) + {&prn3}.
  
FOR EACH fi-date NO-LOCK WHERE fi-date.NroDoc = fi-cate.NroDoc 
    BY PtoRef ON ERROR UNDO, LEAVE:
    DISPLAY STREAM REPORT FI-DATE.Modulo 
                          FI-DATE.SitTra 
                          FI-DATE.PtoRef                           
                          FI-DATE.ClfPto 
                          FI-DATE.descripcion 
                          FI-DATE.Entrega WITH FRAME F-CAB.                              
END.

DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
   PUT STREAM report "" skip.
END.
PUT STREAM report "                         -----------------                               -----------------      "  AT 20 SKIP.
PUT STREAM report "                              VALMIESA                                        CLIENTE           "  AT 20 SKIP.

OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR I-CORREL AS INTEGER.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FIND LAST c-Ficha NO-LOCK NO-ERROR.
  IF NOT AVAILABLE c-Ficha THEN I-CORREL = 1.
  ELSE I-CORREL = INTEGER(c-Ficha.NroDoc) + 1.
  
  fi-cate.NroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(I-CORREL ,"999999").
  fi-cate.CodCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "001".
  fi-cate.FchSol:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
  fi-cate.FchEje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
     
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

  fi-cate.nroDoc = fi-cate.nroDoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

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
  
  DO WITH FRAME {&FRAME-NAME} :
  
    FIND GN-CIAS WHERE GN-CIAS.CodCia = INTEGER( fi-cate.CodCli:SCREEN-VALUE )
                 NO-LOCK NO-ERROR.
    IF AVAILABLE GN-CIAS THEN DO :
       F-NomCia:SCREEN-VALUE = GN-CIAS.NomCia.
    END.
  
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
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
    
  RUN Formato.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN BIN/_VCAT.P(s-print-file). 
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
  {src/adm/template/snd-list.i "FI-CATE"}

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


