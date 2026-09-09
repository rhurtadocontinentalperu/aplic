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

DEFINE SHARED TEMP-TABLE DCST LIKE ImDCstP.
DEFINE SHARED TEMP-TABLE DCSTP LIKE ImDCst.
DEFINE SHARED TEMP-TABLE DREQ LIKE LG-DREQU.
DEFINE BUFFER B-CCST  FOR ImCCst.
DEFINE BUFFER B-DCST  FOR ImDCstP.
DEFINE BUFFER B-DCSTP FOR ImDCst.

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NomCia  AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE VARIABLE p-NroRef LIKE LG-CREQU.NroReq.

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
&Scoped-define EXTERNAL-TABLES ImCCst
&Scoped-define FIRST-EXTERNAL-TABLE ImCCst


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCCst.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCCst.NroCst ImCCst.Version ImCCst.TpoCmb ~
ImCCst.Fchdoc ImCCst.NroEmbq ImCCst.Hora ImCCst.Codmon ImCCst.Observaciones ~
ImCCst.Userid-com 
&Scoped-define ENABLED-TABLES ImCCst
&Scoped-define FIRST-ENABLED-TABLE ImCCst
&Scoped-Define ENABLED-OBJECTS RECT-24 
&Scoped-Define DISPLAYED-FIELDS ImCCst.NroCst ImCCst.NroReq ImCCst.Version ~
ImCCst.TpoCmb ImCCst.Fchdoc ImCCst.NroEmbq ImCCst.Hora ImCCst.Codmon ~
ImCCst.Observaciones ImCCst.Userid-com 
&Scoped-define DISPLAYED-TABLES ImCCst
&Scoped-define FIRST-DISPLAYED-TABLE ImCCst


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
DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 106 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCCst.NroCst AT ROW 1.27 COL 14 COLON-ALIGNED WIDGET-ID 24
          LABEL "Nro. de Costeo"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          FONT 6
     ImCCst.NroReq AT ROW 1.27 COL 41 COLON-ALIGNED WIDGET-ID 12
          LABEL "Nro. de Requerimiento"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          FONT 6
     ImCCst.Version AT ROW 1.27 COL 92 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          FONT 6
     ImCCst.TpoCmb AT ROW 2.08 COL 70.43 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     ImCCst.Fchdoc AT ROW 2.08 COL 92 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCCst.NroEmbq AT ROW 2.35 COL 14 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     ImCCst.Hora AT ROW 2.88 COL 92 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
     ImCCst.Codmon AT ROW 3.15 COL 72.43 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 8.72 BY 1.31
     ImCCst.Observaciones AT ROW 3.42 COL 14 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     ImCCst.Userid-com AT ROW 3.69 COL 92 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.15 COL 66 WIDGET-ID 22
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCCst
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
         HEIGHT             = 3.85
         WIDTH              = 106.14.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN ImCCst.NroCst IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCCst.NroReq IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DCMP V-table-Win 
PROCEDURE Actualiza-DCMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "ImCCst"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCCst"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH ImDCstP WHERE
        ImDCstP.CodCia = ImCCst.CodCia AND
        ImDCstP.CodDiv = ImCCst.CodDiv AND
        ImDCstP.NroCst = ImCCst.NroCst EXCLUSIVE-LOCK
        ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
     DELETE ImDCstP.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DCST:
    DELETE DCST.
  END.
  FOR EACH DREQ:
    DELETE DREQ.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN Borra-Temporal.
    FOR EACH LG-DREQU WHERE
       LG-DREQU.CodCia  = S-CodCia AND
       LG-DREQU.NroReq  = INTEGER(ImCCst.NroReq:SCREEN-VALUE IN FRAME {&FRAME-NAME}) AND
       LG-DREQU.CanApro > 0 NO-LOCK:
            CREATE DREQ.
            BUFFER-COPY LG-DREQU TO DREQ.
   END.
   FOR EACH DREQ:
       CREATE DCST.
       ASSIGN
            DCST.NroCst  = INTEGER(ImCCst.NroCst:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            DCST.CodCia  = DREQ.CodCia
            DCST.CodDoc  = "00000"
            DCST.CodMat  = DREQ.CodMat
            DCST.CanPedi = DREQ.CanApro.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal2 V-table-Win 
PROCEDURE Carga-Temporal2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 RUN Borra-Temporal.
   FOR EACH B-DCST WHERE
       B-DCST.NroCst = ImCCst.NroCst NO-LOCK:
       CREATE DCST.
       /* BUFFER-COPY B-DCST TO DCST. */
         ASSIGN
            DCST.NroCst     = ImCCst.NroCst
            DCST.CodCia     = ImCCst.CodCia
            DCST.CodDiv     = "00000"
            DCST.CodMat     = B-DCST.CodMat
            DCST.CanPedi    = B-DCST.CanPedi
            DCST.Factor     = B-DCST.Factor
            DCST.FobUnit    = B-DCST.FobUnit
            DCST.Prorrat    = B-DCST.Prorrat
            DCST.CstTot     = B-DCST.CstTot
            DCST.CstTotUnit = B-DCST.CstTotUnit.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Contador V-table-Win 
PROCEDURE Contador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DCST:
    CREATE ImDCstP.
    BUFFER-COPY DCST TO ImDCstP
        ASSIGN
            ImDCstP.CodCia    = ImCCst.CodCia
            ImDCstP.CodDiv    = ImCCst.CodDiv
            ImDCstP.NroCst    = ImCCst.NroCst
            ImDCstP.CodMat    = DCST.CodMat
            ImDCstP.CanPedi   = DCST.CanPedi
            ImDCstP.Factor    = DCST.Factor
            ImDCstP.FobUnit   = DCST.FobUnit
            ImDCstP.Prorrat   = DCST.Prorrat
            ImDCstP.CstTot    = DCST.FobUnit + DCST.Prorrat
            ImDCstP.CstTotUni = ImDCstP.CstTot / DCST.CanPedi.
  END.
  RELEASE ImDCstP.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE CanTot AS DECIMAL INIT 0 NO-UNDO.   

    FOR EACH B-DCST NO-LOCK WHERE
        B-DCST.codCia = ImCCst.Codcia AND
        B-DCST.codDiv = ImCCst.CodDiv AND
        B-DCST.NroCst = ImCCst.NroCst:
        CanTot = CanTot + B-DCST.CanPedi.
    END.
    ASSIGN ImCCst.ImpTotC = CanTot.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Incoterm V-table-Win 
PROCEDURE Incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
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
  
  RUN IMP\d-reqpen (OUTPUT p-NroRef).
  IF p-NroRef = 0 THEN RETURN 'ADM-ERROR'.
  
 /*  FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA */
/*     AND LG-CORR.CodDiv = s-CodDiv */
/*     AND LG-CORR.CodDoc = "O/C" */
/*     NO-LOCK NO-ERROR. */
/*   IF NOT AVAILABLE LG-CORR THEN DO: */
/*     MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR. */
/*     RETURN 'ADM-ERROR'. */
/*   END. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
    
  DEFINE VAR CONTADOR AS INTEGER INIT 1. 
  FOR EACH B-CCST 
      BREAK BY B-CCST.NroCst:
      CONTADOR = CONTADOR + 1.
  END.
  DISPLAY contador @ ImCCst.NroCst WITH FRAME {&FRAME-NAME}.  
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH LG-CREQU WHERE LG-CREQU.NroReq = p-NroRef. 
        DISPLAY p-NroRef   @ ImCCst.NroReq WITH FRAME {&FRAME-NAME}.
    END.
    RUN Carga-Temporal.
    DISPLAY
        TODAY                    @ ImCCst.FchDoc
        S-USER-ID                @ ImCCst.Userid-com
        STRING(TIME, "HH:MM")    @ ImCCst.Hora.
    RUN Borra-Temporal.
  END.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR Version AS INTEGER INIT 1. 
      
    /* Code placed here will execute PRIOR to standard behavior. */
   /*  FIND LG-CORR WHERE */
/*         LG-CORR.codcia = s-codcia AND */
/*         LG-CORR.coddiv = s-coddiv AND */
/*         LG-CORR.coddoc = "O/C" */
/*         EXCLUSIVE-LOCK NO-ERROR. */
/*     IF NOT AVAILABLE LG-CORR THEN DO: */
/*         MESSAGE 'Correlativo No Disponible' */
/*         VIEW-AS ALERT-BOX ERROR. */
/*         UNDO, RETURN 'ADM-ERROR'. */
/*     END. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
 
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
        FOR EACH B-CCST WHERE B-CCST.NroReq = INTEGER(ImCCst.NroReq:SCREEN-VALUE)
           BREAK BY B-CCST.NroReq:
           Version = Version + 1.
        END.
        ASSIGN
            ImCCst.NroCst     = INTEGER(ImCCst.NroCst:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            ImCCst.codcia     = s-codcia
            ImCCst.CodDiv     = s-coddiv
            ImCCst.FchDoc     = TODAY
            ImCCst.Userid-com = S-USER-ID
            ImCCst.Hora       = STRING(TIME, 'HH:MM')
            ImCCst.Version    = Version.
    END.
    ELSE DO:
        RUN Carga-Temporal2.
        RUN Borra-Detalle.
    END.
    RUN Genera-Detalle.
    RUN Graba-Totales.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 /*  /* Code placed here will execute PRIOR to standard behavior. */ */
/*    */
/*     IF LOOKUP(ImCOCmp.FlgSit, "E") = 0 THEN DO: */
/*         MESSAGE "La Orden de Compra no puede ser anulada" SKIP */
/*                 "se encuentra " ENTRY(LOOKUP(ImCOCmp.FlgSit,"A,C"),"Anulada,Cerrada") */
/*                 VIEW-AS ALERT-BOX ERROR. */
/*         RETURN "ADM-ERROR". */
/*     END. */
/*     ELSE DO: */
/*          FIND B-CCMP OF ImCOCmp EXCLUSIVE-LOCK NO-ERROR. */
/*          IF AVAILABLE B-CCMP AND B-CCMP.FlgSit = "E" THEN DO: */
/*             FOR EACH ImDOCmp OF ImCOCmp EXCLUSIVE-LOCK */
/*                 ON ERROR UNDO, RETURN 'ADM-ERROR' */
/*                 ON STOP UNDO, RETURN 'ADM-ERROR': */
/*                 DELETE ImDOCmp. */
/*             END. */
/*             ASSIGN */
/*                 B-CCMP.FlgSit = "A" */
/*                 B-CCMP.Userid-com = S-USER-ID. */
/*          END. */
/*          RELEASE B-CCMP. */
/*          FIND CURRENT ImCOCmp NO-LOCK NO-ERROR. */
/*     END. */
/*     RUN dispatch IN THIS-PROCEDURE ('display-fields':U). */
/*     RUN Procesa-Handle IN lh_Handle ('Pagina1'). */

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 /*  DEF VAR I AS INTEGER. */
/*   DEF VAR x-Ok AS LOG NO-UNDO. */
/*    */
/*   /* Code placed here will execute PRIOR to standard behavior. */ */
/*   SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok. */
/*   IF x-Ok = NO THEN RETURN. */
/*    */
/*   /* Dispatch standard ADM method.                             */ */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) . */
/*    */
/*   /* Code placed here will execute AFTER standard behavior.    */ */
/*    */
/*   IF ImCOCmp.FlgSit <> "A" THEN RUN IMP\r-pedimp(ROWID(ImCOCmp), ImCOCmp.CODDOC, ImCOCmp.NROIMP). */
/*    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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
  {src/adm/template/snd-list.i "ImCCst"}

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
  
  /*IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
 *      Im-CREA = NO.
 *      RUN Actualiza-DCMP.
 *      RUN Procesa-Handle IN lh_Handle ("Pagina2").
 *      RUN Procesa-Handle IN lh_Handle ('Browse').
  END.*/
  
  
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
   IF ImCCst.NroEmbq:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Nro de Embarque debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO ImCCst.NroEmbq.
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
  IF NOT AVAILABLE ImCCst THEN RETURN "ADM-ERROR".
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

